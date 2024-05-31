library(tidyverse)
library(kableExtra)
library(ggrepel)
library(broom)
library(ggplot2)
library(corrplot)
library(Lahman)

# 1B: 1st Baseman (1루수)
# 2B: 2nd Baseman (2루수)
# 3B: 3rd Baseman (3루수)
# C: Catcher (포수)
# OF: Outside Fielder (외야수)
# P: Pitcher (투수)
# SS: Short Stop (유격수)

# ---------------------------------------------------------
# ---------------------------------------------------------
# 1. Load Data (from 2000 to 2019)
fielding <- read.csv("Fielding_0019.csv")         # Pitcher(투수)를 제외한 수비수 데이터
pitcher <- read.csv("Pitcher_0019.csv")           # Pitcher 데이터


# Import Lahman Fielding data to use pitcher's InnOuts and E columns
# pitcher 데이터셋에는 InnOuts과 Error 데이터가 없으므로 Lahman library에서 Fielding(수비) 데이터 가져오기
lahman_fielding <- Fielding %>% 
  filter(yearID <= 2019, yearID >= 2000) %>% 
  filter(POS == 'P')                              # position == pitcher


# Import People data and create a 'Name' column
# Lahman의 People(선수) 데이터에서 nameFirst와 nameLast 칼럼을 이용해 Name 칼럼 생성
Player <- People %>% 
  mutate(
    Name = paste(nameFirst, nameLast, sep= " ")
  )


# playerID 칼럼을 기준으로 lahman_fielding과 Player 데이터셋을 합치기 전에
# 각 데이터셋에서 중복되는 playerID가 있는지 확인
n_distinct(lahman_fielding$playerID)               # 3308
n_distinct(Player$playerID)                        # 20370 



# Join the 'Name' column to Lahman_fielding
# playerID를 기준으로 Lahman_fielding에 Player의 [Name] 칼럼 추가
lahman_fielding <- 
  left_join(lahman_fielding, Player[, c("playerID", "Name")], by = "playerID")


# Select needed columns(Name, InnOuts, E)
# lahman_fielding에서 필요한 칼럼(Name, InnOuts, E)만 남김
lahman_fielding <- lahman_fielding %>% 
  select(Name, InnOuts, E) %>% 
  group_by(Name) %>% 
  summarize(InnOuts = max(InnOuts), 
            E = max(E))


# Join lahman_fielding dataset to the loaded pitcher data
# [Name]을 기준으로 pitcher 데이터셋과 Lahman_fielding 데이터셋 결합
pitcher <- 
  left_join(pitcher, lahman_fielding[, c("Name", "InnOuts", "E")], by = "Name") %>% 
  filter(IP >= 30)
  


#----------------------------------------------------------
# 2. Make InnOuts data for make 'out_rate' data
# 2. 'out_rate'를 만들기 위한 InnOuts 데이터 만들기

# (Inn * 3) for fielders except pitchers
# 투수를 제외한 수비수의 Inn * 3
fielding <- fielding %>% 
  mutate(InnOuts = Inn * 3)



#-----------------------------------------------------------
# 3-1. make the sum of InnOuts in each position
# 3-1. 각 포지션별 InnOuts의 합계
fielding_outs <- fielding %>% 
  group_by(Pos) %>% 
  summarise(out_num = sum(InnOuts, na.rm = TRUE)) %>%
  ungroup()

# pitcher(투수)의 InnOuts 합계 따로 계산
pitcher_outs <- pitcher %>% 
  summarise(out_num = sum(InnOuts, na.rm = TRUE))


# 3-2. Add column to put position name in 'pitcher_outs' data
# 3-2. 'pitcher_outs' 데이터셋에 포지션('P') 칼럼 추가
pitcher_outs[, "Pos"] <- c("P")


# 3-3. Merge fielding_outs with pitcher_outs
# 3-3. fielding_outs 데이터셋과 pitcher_outs 데이터셋 병합
fielding_outs <-
  rbind(fielding_outs, pitcher_outs)


#-----------------------------------------------------------
# 4-1. make 'error_rate' variable (포지션별 기록된 실책 비율)
# 4-1. 'error_rate(실책비율) 변수 만들기

# Each position's out_rate == (sum of all outs in each position) / (sum of the outs of all positions)
# 각 포지션의 out_rate = (각 포지션별 out의 합) / (모든 포지션의 out의 합)
fielding_errors <- fielding %>% 
  group_by(Pos) %>% 
  summarise(error_num = sum(E, na.rm = TRUE)) %>% 
  ungroup()

# 투수 error 합 따로 계산
pitcher_errors <- pitcher %>% 
  summarise(error_num = sum(E, na.rm = TRUE))


# 4-2. Add column to put position name in 'pitcher_errors' data
# 4-2. pitcher_errors 데이터셋에 포지션값('P') 추가
pitcher_errors[, "Pos"] <- c("P")


# 4-3. Merge fielding_errors with pitcher_errors
# 4-3. fielding_errors와 pitcher_errors 데이터셋 병합
fielding_errors <-
  rbind(fielding_errors, pitcher_errors)


#-----------------------------------------------------------
# 5. create a data frame that combines fielding_outs and fielding_errors
# 5. fielding_outs과 fielding_errors를 결합한 데이터프레임 생성
df_out_error <- fielding_outs %>% 
  left_join(fielding_errors, by = "Pos") %>% 
  mutate(error_per_out = error_num / out_num)


#-----------------------------------------------------------
# 6. create each position's 'error/out' rate
# 6. 각 포지션별 'error/out' 비율 칼럼 추가

df_out_error <- df_out_error %>% 
  mutate(rate = error_per_out / sum(error_per_out))

# 순위 데이터셋
rank <- df_out_error %>% 
  arrange(desc(rate)) %>% 
  select(Pos, rate)

show(rank)

# high 'error_per_out' == high ratio of error
# low 'error_per_out'  == low ratio of error

#-----------------------------------------------------------
# 7. visualization
# 7. 시각화

p1 <- ggplot(rank, aes(x = Pos, y = rate, fill = Pos)) +
  geom_bar(stat = "identity") +
  labs(x = "Position", y = "Error/Out Rate") +
  theme_bw()

p1

#-----------------------------------------------------------
# 8. OAA(Outs Above Average; 평균 대비 아웃 기여)
# 타구 처리에 난이도를 매겨 평가하는 지표
# 수비수가 평균 대비 얼마나 어려운 수비를 했는지 알 수 있음

# OAA 칼럼이 있는 fielding 데이터셋 불러오기
fielding_OAA <- read.csv("Fielding_2020_2022.csv") %>% 
  filter(Pos != 'C')              # Catcher의 OAA는 없으므로 제외


# 포지션별 OAA의 평균 계산
OAA_mean <- fielding_OAA %>% 
  group_by(Pos) %>% 
  summarise(mean = mean(OAA, na.rm = TRUE))
  

# 시각화
p2 <- ggplot(OAA_mean, aes(x = Pos, y = mean, fill = Pos)) +
  geom_bar(stat = "identity") +
  labs(x = "Position", y = "OAA_mean") +
  theme_bw()

p2



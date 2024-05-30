library(tidyverse)
library(kableExtra)
library(ggrepel)
library(broom)
library(ggplot2)
library(corrplot)
library(Lahman)

# 1B: 1st Baseman
# 2B: 2nd Baseman
# 3B: 3rd Baseman
# C: Catcher
# OF: Outside Fielder
# P: Pitcher
# SS: Short Stop

# ---------------------------------------------------------
# ---------------------------------------------------------
# 1. Load Data (from 2000 to 2019)
fielding <- read.csv("Fielding_0019.csv") 
pitcher <- read.csv("Pitcher_0019.csv")


# Import Lahman Fielding data to use pitcher's InnOuts and E columns
# 투수의 InnOuts과 Error 칼럼을 사용하기 위해 Lahman Fielding(수비) 데이터 가져오기
lahman_fielding <- Fielding %>% 
  filter(yearID <= 2019, yearID >= 2000) %>% 
  filter(POS == 'P')

# Import People data and create a 'Name' column
# 선수명('Name') 칼럼을 만들기 위해 Lahman의 People 데이터 가져오기
Player <- People %>% 
  mutate(
    Name = paste(nameFirst, nameLast, sep= " ")
  )

# Join the 'Name' column to Lahman_fielding
# Lahman_fielding에 'Name' 칼럼 추가
lahman_fielding <- 
  left_join(lahman_fielding, Player[, c("playerID", "Name")], by = "playerID")

# Select needed columns(Name, InnOuts, E)
# 필요한 칼럼(Name, InnOuts, E)만 남기고 삭제
lahman_fielding <- lahman_fielding %>% 
  select(Name, InnOuts, E) %>% 
  group_by(Name) %>% 
  summarize(InnOuts = max(InnOuts), 
            E = max(E))

# Join lahman_fielding dataset to the loaded pitcher data
# pitcher 데이터에 Lahman_fielding 데이터셋 추가
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
# 8. OAA Graphs
fielding_OAA <- read.csv("Fielding_2020_2022.csv") %>% 
  filter(Pos != 'C')

OAA_mean <- fielding_OAA %>% 
  group_by(Pos) %>% 
  summarise(mean = mean(OAA, na.rm = TRUE))
  
p2 <- ggplot(OAA_mean, aes(x = Pos, y = mean, fill = Pos)) +
  geom_bar(stat = "identity") +
  labs(x = "Position", y = "OAA_mean") +
  theme_bw()

p2



### 1. setup ###
library(tidyverse)
library(kableExtra)
library(patchwork)



### 2. load data ###
# Load data from 2022 MLB batter (source: https://baseballsavant.mlb.com/)
batter_22 <- read.csv("batters_2022.csv")

# first name + last name으로 name column 만들기
batter_22 <- batter_22 %>% 
  mutate(
    name = paste(first_name, last_name, sep= " ")
  )



### 3. change name of column : data I need: BA, SLG, OBP, OPS ###
# 사용할 column을 약어로 수정
batter_22  <- 
  rename(batter_22,
         BA = batting_avg,
         SLG = slg_percent, 
         OBP = on_base_percent,
         OPS = on_base_plus_slg,
         R = r_run)



### 4. normalizing ###
# 각 통계량을 0에서 1의 척도로 정규화

# means
# 지표별 선수들의 평균을 담을 batter_means 테이블을 만듦
mean_selected <- select(batter_22, BA, OBP, SLG, OPS)
batter_means <- mean_selected %>% 
  summarize_all(mean)

# normalizing
# 정규화한 값을 batter_22 테이블에 nor_[지표이름] 칼럼으로 추가
batter_22 <- batter_22 %>% 
  mutate(    
    nor_BA = round(BA / batter_means$BA, digits = 3), 
    nor_OBP = round(OBP / batter_means$OBP, digits = 3), 
    nor_SLG = round(SLG / batter_means$SLG, digits = 3),
    nor_OPS = round(OPS / batter_means$OPS, digits = 3)
  )



### 5. Correlation ###

# Correlate to Runs
# 가중치를 결정하기 위한 상관관계 계산
batter_cor <- data.frame(
  r_BA = cor(batter_22$nor_BA, batter_22$R), 
  r_OBP = cor(batter_22$nor_OBP, batter_22$R),
  r_SLG = cor(batter_22$nor_SLG, batter_22$R),
  r_OPS = cor(batter_22$nor_OPS, batter_22$R)
) 

# Visualization
p1 <- ggplot(data = batter_22, aes(x = nor_BA, y = R)) + 
  geom_point() + 
  geom_smooth(method = "lm") + 
  theme_bw()

p2 <- ggplot(data = batter_22, aes(x = nor_OBP, y = R)) + 
  geom_point() + 
  geom_smooth(method = "lm") + 
  theme_bw()

p3 <- ggplot(data = batter_22, aes(x = nor_SLG, y = R)) + 
  geom_point() + 
  geom_smooth(method = "lm") +
  theme_bw()

p4 <- ggplot(data = batter_22, aes(x = nor_OPS, y = R)) + 
  geom_point() + 
  geom_smooth(method = "lm") +
  theme_bw()

(p1|p2)/(p3|p4)



### 6. determine weight ###
# 공격력을 측정에 있어 상대적인 중요성을 기반으로 각 지표에 가중치를 할당
# 가중치는 네 범주의 상관관계의 합에 대한 각 범주의 비율로 계산

batter_cor <- batter_cor %>% 
  mutate (
    weight_BA = r_BA / (r_BA +  r_OBP + r_SLG + r_OPS),
    weight_OBP = r_OBP / (r_BA +  r_OBP + r_SLG + r_OPS), 
    weight_SLG = r_SLG / (r_BA +  r_OBP + r_SLG + r_OPS),
    weight_OPS = r_OPS / (r_BA +  r_OBP + r_SLG + r_OPS)    
  )

# weight of BA == 0.192
# weight of OBP == 0.235
# weight of SLG == 0.279
# weight of OPS == 0.292



### 7. Multiply each normalized data by weight to create an overall value ###
# 정규화된 각 데이터에 가중치를 곱해 새로운 지표(overall_data)를 만듦
batter_22 <- batter_22 %>% 
  mutate (
    overall_data = (nor_BA * batter_cor$weight_BA) + (nor_OBP * batter_cor$weight_OBP) +
      (nor_SLG * batter_cor$weight_SLG) + (nor_OPS * batter_cor$r_OPS)
  )



### 8. Correlate newly created data with R ###
# 가중치를 사용하여 생성된 overall_data와 R(run) 사이의 상관관계 계산
batter_cor <- batter_cor %>% 
  mutate(
    r_overall_data = cor(batter_22$overall_data, batter_22$R)
  ) 

p5 <- ggplot(data = batter_22, aes(x = overall_data, y = R)) + 
  geom_point() + 
  geom_smooth(method = "lm") +
  theme_bw()

(p1|p2|p3)/(p4|p5)

#---------------------------------------------------------------------------

# 같은 방법으로 팀 데이터에 적용
team_batting_22 <- read.csv("team_batting_2022.csv")

### 1. Column 이름 수정 ###
# data I need: BA, SLG, OBP, OPS
team_batting_22  <- 
  rename(team_batting_22, BA = AVG)



### 2. normalizing ###

# means
# 지표별 선수들의 평균을 담을 team_mean_selected 테이블을 만듦
team_mean_selected <- select(team_batting_22, BA, OBP, SLG, OPS)
team_batting_means <- team_mean_selected %>% 
  summarize_all(mean)

# normalizing
# 정규화한 값을 team_batting_22 테이블에 nor_[지표이름] 칼럼으로 추가
team_batting_22 <- team_batting_22 %>% 
  mutate(    
    nor_BA = round(BA / team_batting_means$BA, digits = 3), 
    nor_OBP = round(OBP / team_batting_means$OBP, digits = 3), 
    nor_SLG = round(SLG / team_batting_means$SLG, digits = 3),
    nor_OPS = round(OPS / team_batting_means$OPS, digits = 3)
  )



### 3. Correlation ###

# Correlate to Runs
# 가중치를 결정하기 위한 상관관계 계산
team_batting_cor <- data.frame(
  r_BA = cor(team_batting_22$nor_BA, team_batting_22$R), 
  r_OBP = cor(team_batting_22$nor_OBP, team_batting_22$R),
  r_SLG = cor(team_batting_22$nor_SLG, team_batting_22$R),
  r_OPS = cor(team_batting_22$nor_OPS, team_batting_22$R)
) 

# Visualization
p1_team <- ggplot(data = team_batting_22, aes(x = nor_BA, y = R)) + 
  geom_point() + 
  geom_smooth(method = "lm") + 
  theme_bw()

p2_team <- ggplot(data = team_batting_22, aes(x = nor_OBP, y = R)) + 
  geom_point() + 
  geom_smooth(method = "lm") + 
  theme_bw()

p3_team <- ggplot(data = team_batting_22, aes(x = nor_SLG, y = R)) + 
  geom_point() + 
  geom_smooth(method = "lm") +
  theme_bw()

p4_team <- ggplot(data = team_batting_22, aes(x = nor_OPS, y = R)) + 
  geom_point() + 
  geom_smooth(method = "lm") +
  theme_bw()

(p1_team|p2_team)/(p3_team|p4_team)



### 4. determine weight ###
# 공격력을 측정에 있어 상대적인 중요성을 기반으로 각 지표에 가중치를 할당
# 가중치는 네 범주의 상관관계의 합에 대한 각 범주의 비율로 계산

team_batting_cor <- team_batting_cor %>% 
  mutate (
    weight_BA = r_BA / (r_BA +  r_OBP + r_SLG + r_OPS),
    weight_OBP = r_OBP / (r_BA +  r_OBP + r_SLG + r_OPS), 
    weight_SLG = r_SLG / (r_BA +  r_OBP + r_SLG + r_OPS),
    weight_OPS = r_OPS / (r_BA +  r_OBP + r_SLG + r_OPS)    
  )

# weight of BA == 0.195
# weight of OBP == 0.259
# weight of SLG == 0.269
# weight of OPS == 0.275



### 5. Multiply each normalized data by weight to create an overall value ###
# 정규화된 각 데이터에 가중치를 곱해 새로운 지표(overall_data)를 만듦
team_batting_22 <- team_batting_22 %>% 
  mutate (
    overall_data = (nor_BA * team_batting_cor$weight_BA) + (nor_OBP * team_batting_cor$weight_OBP) +
      (nor_SLG * team_batting_cor$weight_SLG) + (nor_OPS * team_batting_cor$r_OPS)
  )



### 6. Correlate newly created data with R ###
# 가중치를 사용하여 생성된 overall_data와 R(run) 사이의 상관관계 계산
team_batting_cor <- team_batting_cor %>% 
  mutate(
    r_overall_data = cor(team_batting_22$overall_data, team_batting_22$R)
  ) 

# Visualization
p5_team <- ggplot(data = team_batting_22, aes(x = overall_data, y = R)) + 
  geom_point() + 
  geom_smooth(method = "lm") +
  theme_bw()

(p1_team|p2_team|p3_team)/(p4_team|p5_team)

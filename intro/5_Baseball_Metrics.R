####### Baseball Metric #######

#### Setup ####

library(tidyverse)
library(Lahman)
library(kableExtra)
library(patchwork)


## Load Data ##

team <- Teams
batting <- Batting
players <- People %>% 
  mutate(
    Name = paste(nameFirst, nameLast, sep= " ")
  )

team_2000 <- team %>% 
  filter(yearID >= 2000, yearID != 2020)


#### Measure of Success ####

# Create metrics: BA, OBP, SLG, OPS #

team_2000 <-team_2000 %>% 
  mutate(
    X1B = H - X2B - X3B - HR, 
    BA = round(H/AB, digits = 3), 
    PA = AB + BB + HBP + SF, 
    OBP = round((H + BB + HBP)/PA, digits = 3), 
    SLG = round((1 * X1B + 2 * X2B + 3 * X3B + 4 * HR)/AB, digits = 3), 
    OPS = OBP + SLG
  )

# Top 10 OBP Seasons (by team) since 2000

team_2000 %>% 
  select(franchID, yearID, OBP, SLG, BA) %>% 
  arrange(-OBP) %>% 
  head(10) %>% 
  kable(booktabs = T) %>%                                            # making table with kable
  kable_styling(bootstrap_option = c('striped'))

# Correlate to Runs

team_2000 %>% 
  summarise (
    r_BA = cor(BA, R), 
    r_OBP = cor(OBP, R),     # 높은 OBP을 가지고 있는 팀이 점수를 더 많이 얻음
    r_SLG = cor(SLG, R),     # 높은 SLG을 가지고 있는 팀이 점수를 더 많이 얻음
    r_OPS = cor(OPS, R)      # 이 중에서 correlation이 가장 높음
  ) %>% 
  kable(booktabs = T) %>% 
  kable_styling()

# 팀마다 각각의 BA/OBP/SLG/OPS가 R(득점)과 얼마나 연관이 되어있는지 시각화

p1 <- ggplot(data = team_2000, aes(x = BA, y = R)) + 
  geom_point() + 
  geom_smooth(method = "lm") + 
  theme_bw()

p2 <- ggplot(data = team_2000, aes(x = OBP, y = R)) + 
  geom_point() + 
  geom_smooth(method = "lm") + 
  theme_bw()

p3 <- ggplot(data = team_2000, aes(x = SLG, y = R)) + 
  geom_point() + 
  geom_smooth(method = "lm") + 
  theme_bw()

p4 <- ggplot(data = team_2000, aes(x = OPS, y = R)) + 
  geom_point() + 
  geom_smooth(method = "lm") + 
  theme_bw()


(p1|p2)/(p3|p4) # 2x2로 그래프 삽입


# 분석할 때 처음 해야하는 것 : 변수 설명 (어떤 데이터인지 == 팀 level, BA/OBP/SLG/OPS)
# R과 BA는 positive related 되어있음
# 하지만 SLG|OBP가 BA보다 R과 더 related되어있음


#### Repeatability ####

bat_2000 <- batting %>%                               # 팀 단위가 아닌 개인 선수 기준으로 분석해보기
  filter(yearID >= 2000, yearID != 2022) %>% 
  group_by(playerID, yearID) %>% 
  summarise_if(is.numeric, sum) %>% 
  filter(AB > 100)

bat_2000 <- bat_2000 %>%                               # season stat
  mutate(
    X1B = H - X2B - X3B - HR, 
    BA = round(H/AB, digits = 3), 
    PA = AB + BB + HBP + SF, 
    OBP = round((H + BB + HBP)/PA, digits = 3), 
    SLG = round((1 * X1B + 2 * X2B + 3 * X3B + 4 * HR)/AB, digits = 3), 
    OPS = OBP + SLG
  )

# repeatability를 알려면 연도끼리 비교해야함 year to year
# 그러니까 예를 들면 한 선수의 2001년과 2002년, 2003, ... 이 사람의 매년 BA는 correlated 되어있나?

bat_2000 <- bat_2000 %>% 
  group_by(playerID) %>% 
  arrange(yearID) %>% 
  mutate(
    BA_lag = lag(BA),            # 2002라면 2001 데이터를 줌 (없으면 NA)
    OBP_lag = lag(OBP),
    SLG_lag = lag(SLG), 
    OPS_lag = lag(OPS)
  ) %>% 
  ungroup()                      # ungroup하지 않으면 플레이어 단위로 correlation을 찾으려고 할거임

# 이것들이 correlated되어있는지 확인
bat_2000 %>% 
  summarise(
    BA_rept = cor(BA, BA_lag, use = "complete.obs"),             # BA는 별로 반복적이지 않음 (운이 따라야 하는 경우가 있기 때문)
    OBP_rept = cor(OBP, OBP_lag, use = "complete.obs"), 
    SLG_rept = cor(SLG, SLG_lag, use = "complete.obs"), 
    OPS_rept = cor(OPS, OPS_lag, use = "complete.obs")
  ) %>% 
  kable(booktabs = T) %>% 
  kable_styling()

ggplot(data = bat_2000, aes(x = BA_lag, y = BA)) + 
  geom_point() + 
  geom_abline(slope = 1, intercept = 0, col = "red", linetype = "dashed") +    # 붉은 선은 45도
  theme_bw()


# ------------------------------------------------------------------------------
# Exercise

data("LahmanData")
LahmanData$file


# 1. RBI per Plate Appearance

batting <- Batting

bat_2000 <- batting %>% 
  filter(yearID >= 2000, yearID != 2020, AB >= 100)

bat_2000 <- bat_2000 %>% 
  mutate(
    X1B = H - X2B - X3B - HR, 
    BA = round(H/AB, digits = 3), 
    PA = AB + BB + HBP + SF, 
    OBP = round((H + BB + HBP)/PA, digits = 3), 
    SLG = round((1 * X1B + 2 * X2B + 3 * X3B + 4 * HR)/AB, digits = 3), 
    OPS = OBP + SLG, 
    RBI_p_PA = round(RBI / PA, digits = 3)
  )

bat_2000 <- bat_2000 %>% 
  group_by(playerID) %>% 
  arrange(yearID) %>% 
  mutate(
    RBI_p_PA_lag = lag(RBI_p_PA),
  ) %>% 
  ungroup()                      

bat_2000 %>% 
  summarise(
    RBI_p_RA_rept = cor(RBI_p_PA, RBI_p_PA_lag, use = "complete.obs")
  ) %>% 
  kable(booktabs = T) %>% 
  kable_styling()

ggplot(data = bat_2000, aes(x = RBI_p_PA_lag, y = RBI_p_PA)) + 
  geom_point() + 
  geom_abline(slope = 1, intercept = 0, col = "red", linetype = "dashed") + 
  theme_bw()


# 2. Win (W) per Pitching Appearance (G)

pitching <- Pitching

pitch_2000 <- pitching %>% 
  filter(yearID >= 2000, yearID != 2020) %>% 
  mutate(
    W_per_G = round(W/G, digits = 3),
    IP = (IPouts / 3)
  ) %>% 
  filter(IP >= 30)

pitch_2000 <- pitch_2000 %>% 
  group_by(playerID) %>% 
  arrange(yearID) %>% 
  mutate(
    W_per_G_lag = lag(W_per_G),
  ) %>% 
  ungroup()

pitch_2000 %>% 
  summarise(
    W_per_G_rept = cor(W_per_G, W_per_G_lag, use = "complete.obs")
  ) %>% 
  kable(booktabs = T) %>% 
  kable_styling()

ggplot(data = pitch_2000, aes(x = W_per_G_lag, y = W_per_G)) + 
  geom_point() + 
  geom_abline(slope = 1, intercept = 0, col = "red", linetype = "dashed") + 
  theme_bw()

# 3. Earned run average (ERA)
# ERA = (Runs Allowed(실점) * 9) / Innings Pitched (이닝 수)

pitch_2000 <- pitch_2000 %>% 
  group_by(playerID) %>% 
  arrange(yearID) %>% 
  mutate(
    ERA_lag = lag(ERA)
  ) %>% 
  ungroup()

pitch_2000 %>% 
  summarise(
    ERA_rept = cor(ERA, ERA_lag, use = "complete.obs")
  ) %>% 
  kable(booktabs = T) %>% 
  kable_styling()

ggplot(data = pitch_2000, aes(x = ERA_lag, y = ERA)) + 
  geom_point() + 
  geom_abline(slope = 1, intercept = 0, col = "red", linetype = "dashed") + 
  theme_bw()


# 4. Walk and Hits Per Inning Pitched (WHIP)
# (피안타 갯수 H + BB 사구) / Innings Pitched (이닝 수)

pitch_2000 <- pitch_2000 %>% 
  mutate(
    WHIP = (H + BB) / IP
  )

pitch_2000 <- pitch_2000 %>% 
  group_by(playerID) %>% 
  arrange(yearID) %>% 
  mutate(
    WHIP_lag = lag(WHIP)
  ) %>% 
  ungroup()

pitch_2000 %>% 
  summarise(
    WHIP_rept = cor(WHIP, WHIP_lag, use = "complete.obs")
  ) %>% 
  kable(booktabs = T) %>% 
  kable_styling()

ggplot(data = pitch_2000, aes(x = WHIP_lag, y = WHIP)) + 
  geom_point() + 
  geom_abline(slope = 1, intercept = 0, col = "red", linetype = "dashed") + 
  theme_bw()

# Use a correlation metric and show graphically which of the following pitching stats is most related
# to the measure of success Runs Allowed.
# 상관 메트릭을 사용하여 다음 투구 통계 중 성공 런 허용 측정값과 가장 관련이 있는 것을 그래픽으로 보여줍니다.
library(corrplot)

# 1. Win per Pitching Appearance
cor(pitch_2000$W_per_G, pitch_2000$R)

# 2. Earned run average (ERA)
cor(pitch_2000$ERA, pitch_2000$R)

# 3. Walk and Hits Per Inning Pitched (WHIP)
cor(pitch_2000$WHIP, pitch_2000$R)


# 4. Strikeouts (K) per Inning Pitched (IP)
pitch_2000 <- pitch_2000 %>% 
  mutate(
    K_p_IP = SO / IP
  )

cor(pitch_2000$K_p_IP, pitch_2000$R)

# 5. Walks (BB) per Inning Pitched
pitch_2000 <- pitch_2000 %>% 
  mutate(
    BB_p_IP = BB / IP
  )
cor(pitch_2000$BB_p_IP, pitch_2000$R)


corr_vars <- pitch_2000 %>% 
  select(W_per_G, ERA, WHIP, K_p_IP, BB_p_IP, R)

corr_pitch_2000 <- round(cor(corr_vars), digits = 2)

corrplot(corr_pitch_2000, method = "number")

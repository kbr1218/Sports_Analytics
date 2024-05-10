### Runs_Created_and_wOBA ###

library(tidyverse)
library(Lahman)
library(kableExtra)

batting <- Batting
players <- People %>% 
  mutate(
    Name = paste(nameFirst, nameLast, sep = " ")
  )

bat <- batting %>% 
  group_by(playerID, yearID) %>% 
  summarise_if(is.numeric, sum) %>% 
  filter(AB > 100) %>% 
  left_join(., select(players, playerID, Name)) %>% 
  ungroup() %>% 
  replace(is.na(.), 0) #Null값을 넣으면 계산할 때 더할 수가 없으므로 0으로 바꿔줌

####  Calculate RC and wOBA ####

bat_test <- bat %>% 
  mutate(
    X1B = H - X2B - X3B - HR, 
    TB = 1*X1B + 2*X2B + 3*X3B + 4*HR,
    RC = ((H + BB + HBP - CS - GIDP) * (TB + 0.26 * (BB - IBB + HBP)) + (0.52 * (SH + SF + SB))) / (AB + BB + HBP + SH + SF),
    wOBA = round((0.69 * (BB - IBB) + 0.72 * HBP + 0.88 * X1B + 1.25 * X2B + 1.58 * X3B + 2.03 * HR) / (AB + BB - IBB + HBP + SF), digits = 3)
  )

bat_test %>%      # 요약된 데이터 정보 확인 (평균, 중간값, 표준편차)
  summarise(
    mean_wOBA = mean(wOBA), 
    median_wOBA = median(wOBA),
    sd_wOBA = sd(wOBA),
    mean_RC = mean(RC),
    median_RC = median(RC),
    sd_RC = sd(RC)
  ) %>% 
  kable(booktabs = T) %>% 
  kable_styling()

bat_test %>%     # leader board 만들기
  select(Name, RC) %>% 
  arrange(-RC) %>% 
  head(20) %>% 
  kable(booktabs = T) %>% 
  kable_styling()

bat_test %>%     # leader board 만들기
  select(Name, wOBA) %>% 
  arrange(-wOBA) %>% 
  head(20) %>% 
  kable(booktabs = T) %>% 
  kable_styling()


#### 발표 끝나고 하신 말
# 1. effectively(clear, concise, organized) describe why valuable -> purpose
# 2. Relevant
# 3. Organization -> should flow -> story -> examples
# 4. visualizations -> explain -> variables -> type visual -> story (telling vs) -> what takeaway
# 5. thorough -> best|most available
# 6. know audience
# 7. Explain data (source, years, variables)

#### Presentation Outline
# -------overview (frame narrative)--------
# 1. Purpose
# 2. Motivation
# 3. Method 
# 4. Results (insight)
# (3 && 4: briefly -> intuition)
# ---------Analysis-------------
# 1. Data
# 2. Method in detail
# 3. Results(visual model results) analysis -> in detail
# 4. Takeaway && insight

#### Exercise
library(tidyverse)
library(Lahman)
library(kableExtra)

# Explore the distributions of Runs Created per 600 at bats (AB/600) and wOBA
batting <- Batting
players <- People %>% 
  mutate(
    Name = paste(nameFirst, nameLast, sep = " ")
  )

bat <- batting %>% 
  group_by(playerID, yearID) %>% 
  summarise_if(is.numeric, sum) %>% 
  filter(AB > 100) %>% 
  left_join(., select(players, playerID, Name)) %>% 
  ungroup() %>% 
  replace(is.na(.), 0)

bat <- bat %>% 
  mutate(
    X1B = H - X2B - X3B - HR, 
    TB = 1*X1B + 2*X2B + 3*X3B + 4*HR,
    RC = ((H + BB + HBP - CS - GIDP) * (TB + 0.26 * (BB - IBB + HBP)) + (0.52 * (SH + SF + SB))) / (AB + BB + HBP + SH + SF),
    wOBA = round((0.69 * (BB - IBB) + 0.72 * HBP + 0.88 * X1B + 1.25 * X2B + 1.58 * X3B + 2.03 * HR) / (AB + BB - IBB + HBP + SF), digits = 3),
    RC600 = (RC * 600),
    PA = sum(AB, BB, HBP, SH, SF)
  )

mean(bat$RC600)
mean(bat$RC600, trim = 0.05)
median(bat$RC600)
var(bat$RC600)
sd(bat$RC600)

mean(bat$wOBA)
mean(bat$wOBA, trim = 0.05)
median(bat$wOBA)
var(bat$wOBA)
sd(bat$wOBA)


# What are the 25th, 50th, 75th, 90th, 95th percentiles for RC600 and wOBA.
quantile(bat$RC600, c(.05, .1, .25, .5, .75, .9, .95))

quantile(bat$wOBA, c(.05, .1, .25, .5, .75, .9, .95))


# Are RC600 and wOBA repeatable year over year?

bat <- bat %>% 
  group_by(playerID) %>% 
  arrange(yearID) %>% 
  mutate(
    RC600_lag = lag(RC600),
    wOBA_lag = lag(wOBA),
  ) %>% 
  ungroup()

bat %>% 
  summarise(
    RC_rept = cor(RC600, RC600_lag, use = "complete.obs"),
    wOBA_rept = cor(wOBA, wOBA_lag, use = "complete.obs"), 
  ) %>% 
  kable(booktabs = T) %>% 
  kable_styling()


# Are RC600 and wOBA good measures of success?

# Use wOBA to calculate weighted runs above average (wRAA).
# wRAA = ((wOBA – league wOBA) / wOBA scale) × PA
league_wOBA <- mean(bat$wOBA)
wOBA_scale <- 1.25

bat_wRAA <- bat %>% 
  mutate(wRAA = ((wOBA - league_wOBA) / wOBA_scale) * PA)

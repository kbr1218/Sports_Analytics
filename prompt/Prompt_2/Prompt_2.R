library(tidyverse)
library(kableExtra)
library(ggrepel)
library(broom)
library(patchwork)

load("ARC_bat_ind.Rda")            # batter
load("ARC_bat_team.Rda")           # team batting
load("ARC_seasonal_Constants.Rda") # wOBA scale
load("ARC_pitch_team.Rda")         # team pitching


##### 1. Run Value of a Win ######

## Combine bat_team data and pitch_team data
# pitch_team 데이터에 있는 W(Win; 우승)과 ra(runs allowed; 허용한 득점) 칼럼을 bat_team 데이터에 추가
bat_team <- 
  mutate(bat_team, W = pitch_team$w) %>% 
  mutate(bat_team, ra = pitch_team$ra)
str(bat_team) # 자료형 확인

## change variables into integers
# 문자형을 정수형으로 변환
bat_team$W <- as.integer(bat_team$W)
bat_team$att <- as.integer(bat_team$att)
bat_team$sb <- as.integer(bat_team$sb)

# 새로운 변수들 계산
bat_team <- bat_team %>% 
  mutate(
    W_pct = W / G,             # Win_percentage(승률) = Wins / Games
    rd = r - ra,               # Run Differential = Runs Scored(득점) - Runs_Allowed(허용한 득점)
    X1b = h - X2b - X3b - hr,  # X1b(1루타) = hits(전체 안타) - X2b(2루타) - X3b(3루타) - hr(홈런)
    cs = att - sb              # Caught Stealing(도루 실패) = Stolen base attempts(도루시도) - Stolen bases(도루)
  )

## Visualization
# RD와 W_pct 사이의 관계 시각화
ggplot(data = bat_team, aes(x = rd, y = W_pct)) + 
  geom_point() +
  geom_smooth(method = "lm") +
  xlab("Run Differential") +
  ylab("Win Percentage") +
  theme_bw()

## linear model (선형회귀)
rd_model <- lm(W_pct ~ rd, data = bat_team)

tidy(rd_model) %>% 
  kable(booktabs = T) %>% 
  kable_styling()


# 회귀모델을 가지고 예측값과 잔차를 계산하여 df에 추가
bat_team <- bat_team %>% 
  mutate(
    W_pct_hat = predict(rd_model, bat_team), # 예측값
    resid = W_pct - W_pct_hat                # 잔차
  )

p1 <- ggplot(data = bat_team, aes(x = rd, y = W_pct)) + 
  geom_point() +
  geom_smooth(method = "lm") +
  xlab("Run Differential") +
  ylab("Win Percentage") + 
  theme_bw()

p2 <- ggplot(data = bat_team, aes(x = rd, y = resid)) + 
  geom_point() +
  geom_hline(yintercept = 0, linetype = 'dashed', col = 'red') +
  xlab("Run Differential") +
  ylab("Residual") +
  theme_bw()

# RD와 W_pct, RD와 잔차의 관계 시각화
p1/p2

# 잔차의 절댓값이 큰 상위 10개 팀 highlight해서 시각화
hightlight_team <- bat_team %>% 
  arrange(-abs(resid)) %>% 
  head(10)

p2 + 
  geom_text_repel(data = hightlight_team, 
                  aes(label = paste(teamID, year)), 
                  col = "blue")





##### 2. Run Value of Events #####
# 변수들(bb, hbp, x1b, 2xb, 3xb, hr, sb, cs)이 득점(R)에 미치는 영향을
# 분석하기 위해 회귀분석 수행
lin_weights <- lm(r ~ bb + hbp + X1b + X2b + X3b + hr + sb + cs, 
                  data = bat_team)

tidy(lin_weights) %>% 
  kable(bookends = T) %>% 
  kable_styling()





##### 3. wOBA(가중 출루율)계산 #####
## Create wOBA
bat_team <- bat_team %>% 
  mutate(
    wOBA = round(((0.69 * bb) + (0.72 * hbp) + (0.88 * X1b) + (1.25 * X2b) + (1.5 * X3b) + (2.03 * hr)) / (ab + bb + hbp + sf), digits = 3),
  )

# 상위 20개 팀 출력
bat_team %>%     # leader board 만들기
  select(year, wOBA) %>% 
  arrange(-wOBA) %>% 
  head(20) %>% 
  kable(booktabs = T) %>% 
  kable_styling()

# 연도별 평균/중앙값/표준편차를 테이블로 만듦
bat_team_year <- bat_team %>%  # 요약된 데이터 정보 확인 (평균, 중간값, 표준편차)
  group_by(year) %>%
  summarise(
    mean_wOBA = mean(wOBA),
    median_wOBA = median(wOBA),
    sd_wOBA = sd(wOBA)
  )

bat_team_year %>% 
  kable(booktabs = T) %>% 
  kable_styling()






##### 4. ARC와 MLB #####
library(Lahman)
team <- Teams

# Make RD #
# MLB 데이터에서 RD와 W_pct 사이의 관계 시각화
team_mlb <- team %>% 
  filter(yearID >= 2002, yearID <= 2022) %>% 
  mutate(
    W_pct = W/G,             # W% = (Wins) / (Games)
    RD = R - RA,              # RD = (Runs Scored) - (Runs Allowed)
    X1B = H - X2B - X3B - HR
  )

# Visualization
ggplot(data = team_mlb, aes(x = RD, y = W_pct)) + 
  geom_point() +
  geom_smooth(method = "lm") +                # 직선 추가 (lm: linear model)
  xlab("Run Differential") +
  ylab("Win Percentage") +
  theme_bw()  #강한 양수 그래프가 나옴

# Linear Model #
# 회귀분석
rd_model_mlb <- lm(W_pct ~ RD, data = team_mlb)

tidy(rd_model_mlb) %>%                # beta0 = 0.5, beta1 = 0.0006
  kable(booktabs = T) %>% 
  kable_styling()


# MLB 데이터에서 각 변수들이 득점에 미치는 영향 분석
lin_weights_mlb <- lm(R ~ BB + HBP + X1B + X2B + X3B + HR + SB + CS,
                      data = team_mlb)

tidy(lin_weights_mlb) %>% 
  kable(bookends = T) %>% 
  kable_styling()






##### 5. Stolen Base Analysis (도루분석) #####
bat_team$att <- as.integer(bat_team$att)
bat_team$sb <- as.integer(bat_team$sb)

bat_team <- bat_team %>% 
  mutate(
    sb_rate = sb / att,     # sb_rate = (Stolen_bases) / (Stolen_base_attempts)
    pa = ab + bb + hbp + sf + sh
  )

# 성공 시 run value = 0.512 (성공하면 한 루를 얻는 것이므로 x1B와 같다고 가정)
# 실패 시 아웃이므로= -0.36

## Visualization
# 도루 성공률(sb_rate)과 승률(w_pct) 사이의 관계를 시각화하고 회귀모델 생성
ggplot(data = bat_team, aes(x = sb_rate, y = W_pct)) + 
  geom_point() +
  geom_smooth(method = "lm") +
  xlab("Run Differential") +
  ylab("Win Percentage") +
  theme_bw()

## linear model
rd_model <- lm(W_pct ~ sb_rate, data = bat_team)

tidy(rd_model) %>% 
  kable(booktabs = T) %>% 
  kable_styling()





##### 6. Calculate Metrics #####

# wOBA, wRAA (weighted runs above average), wRC (weighted runs created)
# and wRC_100 (weighted runs created per game 100 at-bats))
# 타자의 성과를 평가하기 위한 wOBA, wRAA, wRC, wRC_100과 같은 고급 야구 통계 계산
bat_matrics <- bat_team

# left_join을 사용하여 bat_matrics와 wOBA_scale_iiac 데이터를 결합
# 결합된 데이터에는 연도별 wOBA_scale, 리그 평균 wOBA(wOBA_lg), 리그 평균득점(r_pa)이 포함된
bat_matrics <- 
  left_join(bat_matrics, wOBA_scale_iiac %>% 
              select(year, wOBA_scale, wOBA_lg, r_pa),
              by = "year")
  

# 계산된 값을 bat_matrics df에 추가
bat_matrics <- bat_matrics %>% 
  mutate(
    wRAA = ((wOBA - wOBA_lg) / wOBA_scale) * pa,
    wRC = (( ((wOBA - wOBA_lg) / wOBA_scale) + r_pa) * pa), 
    wRC_100 = (wRC / pa) * 100
  )
# 선수가 100 타석동안 생산한 가중 득점 수

head(bat_matrics, c("wOBA", "wRAA", "wRC", "wRC_100"), n = 10)


library(tidyverse)
library(Lahman)
library(kableExtra)
library(ggrepel)
library(broom)
library(patchwork)

team <- Teams

team <- team %>% 
  mutate(
    W_pct = W/G,             # W% = (Wins) / (Games)
    RD = R - RA,              # RD = (Runs Scored) - (Runs Allowed)
    X1B = H - X2B - X3B - HR
  )


team_00 <- team %>% 
  filter(yearID >= 2000, yearID != 2020)

# Visualization
ggplot(data = team_00, aes(x = RD, y = W_pct)) + 
  geom_point() +
  geom_smooth(method = "lm") +                # 직선 추가 (lm: linear model)
  xlab("Run Differential") +
  ylab("Win Percentage") +
  theme_bw()  #강한 양수 그래프가 나옴

#### Linear Model ####
rd_model <- lm(W_pct ~ RD, data = team_00)

tidy(rd_model) %>%                # beta0 = 0.5, beta1 = 0.0006
  kable(booktabs = T) %>% 
  kable_styling()

# residuals
# rd_model$residuals

team_00 <- team_00 %>% 
  mutate(
    W_pct_hat = predict(rd_model, team_00),     # hat: estimated value
    resid = W_pct - W_pct_hat
  )

p1 <- ggplot(data = team_00, aes(x = RD, y = W_pct)) + 
  geom_point() +
  geom_smooth(method = "lm") +
  xlab("Run Differential") +
  ylab("Win Percentage") +
  theme_bw()

p2 <- ggplot(data = team_00, aes(x = RD, y = resid)) + 
  geom_point() +
  geom_hline(yintercept = 0, linetype = 'dashed', col = 'red') +
  xlab("Run Differential") +
  ylab("Residual") +
  theme_bw()
# p2: 빨간 x축을 기준으로 그 위에 있는 팀들은 overperformed한거고 그 아래는 underperformed한거

p1/p2

hightlight_team <- team_00 %>% 
  arrange(-abs(resid)) %>% 
  head(10)

p2 + 
  geom_text_repel(data = hightlight_team, 
                  aes(label = paste(teamID, yearID)), 
                  col = "blue")

#### Run Values ####
lin_weights <- lm(R ~ BB + HBP + X1B + X2B + X3B + HR + SB + CS,
                  data = team_00)

tidy(lin_weights) %>% 
  kable(bookends = T) %>% 
  kable_styling()



# exercise
# 3. Converting linear weight run values (lwRV) to wOBA weights.
# Note that the wOBA weights are relative to an out and scaled so it equals league average OBP.

# setup
library(tidyverse)
library(Lahman)
library(kableExtra)
library(ggrepel)
library(broom)
library(patchwork)

data("Batting")
batting <- Batting

batting <- batting %>% 
  mutate(
    X1B = H - X2B - X3B - HR, 
    TB = 1*X1B + 2*X2B + 3*X3B + 4*HR,
    RC = ((H + BB + HBP - CS - GIDP) * (TB + 0.26 * (BB - IBB + HBP)) + (0.52 * (SH + SF + SB))) / (AB + BB + HBP + SH + SF),
    wOBA = round((0.69 * (BB - IBB) + 0.72 * HBP + 0.88 * X1B + 1.25 * X2B + 1.58 * X3B + 2.03 * HR) / (AB + BB - IBB + HBP + SF), digits = 3)
  )

# 3-1.  Run a Linear Weights regression for the year 2019
batting_19 <- batting %>% 
  filter(yearID == 2019)

lin_weights <- lm(R ~ BB + HBP + X1B + X2B + X3B + HR + SB + CS,
                  data = batting_19)

tidy(lin_weights) %>% 
  kable(bookends = T) %>% 
  kable_styling()

# 3-2.  Make the lwRV relative to an out by adding 0.3 to each value. Note, an out is worth -0.3 runs.

batting_19 <- batting_19 %>% 
  mutate(lwRV = RC - 20 * wOBA + 2.7)

batting_19$lwRV <- batting_19$lwRV + 0.3

# 3-3. Use the value from 2 to calculate raw wOBA for the entire league and OBP.
# You will have to sum all the team's data for the season before calculating league raw wOBA and OBP.
league_wOBA <- sum(0.69 * (sum(batting_19$BB) - sum(batting_19$IBB))
                   + 0.72 * sum(batting_19$HBP) + 0.88 * sum(batting_19$X1B)
                   + 1.25 * sum(batting_19$X2B) + 1.58 * sum(batting_19$X3B)
                   + 2.03 * sum(batting_19$HR)) / sum(batting_19$AB + sum(batting_19$BB)
                                                      - sum(batting_19$IBB) + sum(batting_19$HBP) + sum(batting_19$SF))

league_OBP <- sum(batting_19$H + batting_19$BB + batting_19$HBP) / sum(batting_19$AB + batting_19$BB + batting_19$HBP + batting_19$SF)

# 3-4. Find the wOBA scale by dividing OBP by wOBA.
league_19 <- batting_19 %>% 
  summarise(
    OBP = sum(H + BB + HBP) / sum(AB + BB + HBP + SF),
    wOBA = sum(0.69 * (BB - IBB) + 0.72 * HBP + 0.88 * X1B + 1.25 * X2B + 1.58 * X3B + 2.03 * HR) / sum(AB + BB - IBB + HBP + SF),
    RC = ((H + BB + HBP - CS - GIDP) * (TB + 0.26 * (BB - IBB + HBP)) + (0.52 * (SH + SF + SB))) / (AB + BB + HBP + SH + SF)
  )

league_19 <- league_19 %>% 
  mutate(lwRV = RC - 20 * wOBA + 2.7)

wOBA_scale <- league_19 %>% 
  summarise(
    wOBA_scale = OBP / wOBA
  )

# 3-5. The final wOBA weights are $wOBA\_scale\times(lwRV+0.3)$
league_19 <- league_19 %>% 
  mutate (
    final_weights = wOBA_scale$wOBA_scale * (lwRV + 0.3)
  )


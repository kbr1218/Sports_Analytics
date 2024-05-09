####### Exploratory Data Analysis #######

#### Setup ####

library(tidyverse)
library(Lahman)

team <- Teams %>% 
  filter(yearID >= 2000, yearID != 2020)


#### Tendency ####

mean(team$HR)                          # team이라는 dataset에서 특정 변수에 접근: $
mean(team$HR, trim = 0.05)             # 양쪽 끝을 잘라내는 argument: trim (이 경우는 5%)
median(team$HR)                        # Middle number

team <- team %>% 
  mutate(
    X1B = H - HR - X3B - X2B,          # Single 변수 만들기
    SLG = round((1 * X1B + 2 * X2B + 3 * X3B + 4 * HR) / AB, digits = 3)
  )

# 항상 평균 수치로 경기하는 게 아니니 (분포표에서) 꼬리값을 생각해야 함 -> range가 중요


#### Variability ####
var(team$HR)                            # average squared deviation from the mean
sd(team$HR)                             # 홈런에 대해 average에서 37정도 떨어져있다 (양쪽 끝까지)
quantile(team$HR)                       # 50% (172) == median, 25%(149)의 팀이 149보다 적게 홈런을 쳤다 -> quantile은 우리에게 quarter을 줌

quantile(team$HR, c(.05, .1, .25, .5, .75, .9, .95))       # %를 직접 지정할 수 있음 (-> 5%의 팀이 120개 보다 적은 홈런을 쳤다)



#### Visualize ####

# Boxplot #
ggplot(data = team) + 
  geom_boxplot(aes(y = HR)) +           # 박스 모양의 플롯 만들기
  theme_bw()


# Histogram #
ggplot(data = team) + 
  geom_histogram(aes(x = HR), bins = 100) + 
  # bin이 많을 수록 x축의 range를 세분화시킴
  theme_light()


# Density #
ggplot(data = team) +
  geom_density(aes(x = HR)) + 
  theme_bw()

# histogram과 density를 같은 그래프에 넣기
ggplot(data = team, aes(x = HR)) + 
  geom_histogram(aes(y = ..density..)) + 
  geom_density(col = "red") + 
  theme_bw()



#### Relation ####

cor(team$HR, team$R)
cor(team$SB, team$R)
cor(team$ERA, team$W)

# Scatter Plot # (correlation 시각화)
team <- team %>% 
  mutate(
    WPct = W/G
  )

ggplot(data = team) +
  geom_point(aes(x = HR, y = R,
                 col = WSWin,
                 size = WPct),
             alpha = 0.4) +
  theme_bw()

# Cor Plot #
library(corrplot)


corr_vars <- team %>% 
  select(HR, R, SO, ERA, W)

corr_matrix <- round(cor(corr_vars), digits = 2)

corrplot(corr_matrix, method = "number")




#### exercise ####
library(ggplot2)

# 1. Explore an individual pitching metric, analyze a visualization you created, and use that visualization to generate an interesting question.
data_1 <- read.csv("IndividualPitching_2021.csv")

ggplot(data = data_1) + 
  geom_point(aes(x = avg_hit_speed, y = gb),
             alpha = 0.7) + 
  labs(title = "Q1", x = "Average Hit Speed", y = "Ground Ball") +
  theme_bw()

# Interesting question: What is the relationship between a pitcher's average hit speed and their ground ball rate?
# -----------------------------------------------------------------------------


# 2. Explore an individual hitting metric, analyze a visualization you created, and use that visualization to generate an interesting question.
data_2 <- read.csv("IndividualHitting_2021.csv")

plot_2 <- ggplot(data = data_2) +
  geom_point(aes(x = avg_hit_speed, y = avg_distance), 
             alpha = 0.7) +
  labs(title = "Q2", x = "Average Hit Speed", y = "Average Distance") +
  theme_bw()

plot_2

#Interesting question: What is the relationship between a batter's average hit speed and average distance?
# -----------------------------------------------------------------------------

# 3. Explore a team pitching metric, analyze a visualization you created, and use that visualization to generate an interesting question.

data_3 <- read.csv("TeamPitching_2021.csv")
gb_for_bar = (data_3$gb)


ggplot(data = data_3, aes(x = team, y = gb_for_bar)) + 
  geom_bar(stat = "identity", fill = "orange", colour = "black") + 
  labs(title = "Q3", x = "Team", y = "Ground Ball") +
  theme(axis.text.x = element_text(angle=90))

# Interesting question: which team had the highest ground balls during the 2021 season?
# -----------------------------------------------------------------------------


# 4. Explore a team hitting metric, analyze a visualization you created, and use that visualization to generate an interesting question.

data_4 <- read.csv("TeamHitting_2021.csv")

cor(data_4$avg_hit_speed, data_4$avg_distance)
cor(data_4$avg_distance, data_4$ev95percent)
cor(data_4$ev95percent, data_4$brl_percent)

library(corrplot)

corr_vars <- data_4 %>% 
  select(avg_hit_speed, avg_distance, ev95percent, brl_percent)

corr_data_4 <- round(cor(corr_vars), digits = 2)

corrplot(corr_data_4, method = "number")

# Interesting question: What are the two most correlated things in the hitting metric?
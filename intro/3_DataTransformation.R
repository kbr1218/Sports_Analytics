library(tidyverse)    # load the tidyverse package

# Double #
hits <- c(1, 0, 3, 2, 0)     # c combines values

length(hits)    # tells you how many values
typeof(hits)    # tells the type of data (this is double or numberic)



# Integer #
ab <- c(4L, 4L, 5L, 3L, 4L)
typeof(ab)



# Character #
player <- c("Barry Bonds", 
            "Babe Ruth",
            "Ted Williams",
            "Willie Mays",
            "Mike Trout")
typeof(player)



# Logical #
HoF <- c(FALSE, TRUE, TRUE, TRUE, FALSE)



## Matrix ##
hit_matrix <- matrix(c(player, hits, ab), nrow = 5)
hit_matrix



## Factor ##
hand <- factor(c("L", "L", "L", "R", "R"))
typeof(hand)



## Data Frame ##
hit_df <- tibble(player = player, hand = hand, hits = hits, ab = ab)
hit_df

hit_df$player



#### Verbs ####
library(Lahman)

data("LahmanData")
LahmanData$file

batting <- Batting    # Load Batting data to batting object

names(batting)
str(batting)



#### Filter ####
bat_21 <- batting  %>%      # Keep data raw and make new data frame
  filter(yearID == 2021)    # dplyer에 있는 filter 함수 이용하기

#remove objects in environment: rm(name_of_object)

bat_21 <- batting %>% 
  filter(yearID == 2021, AB >= 100)    # multiple filters all at once



#### Select ####
bat_21_hr <- bat_21 %>%     # hr data를 담은 data frame 만들기
  select(playerID, HR)      # 이미 old data frame을 불렀으니 함수 안에 다시 old data frame을 부를 필요 없음

bat_21_hr                   # data frame 이름을 그냥 쓰면 console에 print됨



#### Arrange ####
bat_21_hr <- bat_21_hr %>%
  #arrange(HR)                    # lowest -> highest
  arrange(desc(HR))               # highest -> lowest

bat_21_hr_leader <- bat_21_hr %>%
  arrange(desc(HR)) %>%           # highest -> lowest
  head(15)                        # print top 15 row

bat_21_hr_leader



#### Mutate ####
bat_21 <- bat_21 %>% 
  mutate(                               # make many variables in one mutate
    BA = round(H/AB, digits = 3),       # BA: Batting Average
    SO_rate = round(SO/AB, digits = 2)  # SO: Strike Out
  )



#### Summarise ####
hr_dist <- bat_21_hr %>%                # summarise를 하면 주로 새로운 object를 만듦
  summarise(                            # 원래 있던 object에 overwriting하지 않으려고
    avg_hr = mean(HR),
    max_hr = max(HR),
    min_hr = min(HR)
  )

hr_dist



#### Group By ####
team <- Teams                   # team data frame을 계속 가지고 있기

team_2000 <- team %>%           # 2000년 이후, 2020년 제외한 data frame 만들기
  filter(
    yearID >= 2000,
    yearID != 2020,
  )

hr_team <- team_2000 %>%        # summarise를 위해 새로운 data frame 만들기
  group_by(franchID) %>%        # Group마다의 summarise하기 위해 group_by 함수 사용
  summarise(                    # group_by로는 각각의 data frame을 만들 필요 없음
    hr_avg = mean(HR),
    hr_max = max(HR),
    hr_min = min(HR)
  )

hr_total <- team_2000 %>%       # 팀마다 hr의 total값이 있는 data frame 만들기
  group_by(franchID) %>% 
  summarise(
    hr_tot = sum(HR)
  )



#### Merging ####
players <- People

# nameFirst와 nameLast를 합친 새로운 변수(Name)를 하나 만들려고 함 (mutate 함수로)
players <- players %>% 
  mutate(
    Name = paste(nameFirst, nameLast, sep=" ")    # paste 함수는 두 개의 무언가를 붙일 때
  )

batting <- batting %>% 
  # 왼쪽 df1의 row는 변하지 않지만 df2는 df1의 key를 찾아 순서를 바꿈, 윗줄에 이미 어떤 df를 사용할지 설정해놨으므로 첫번째 argument에서 .만 쓰면 됨 
  left_join(., select(players, playerID, Name))

bat_21_hr_leader <- batting %>% 
  filter(yearID == 2021, AB >= 100) %>% 
  select(Name, HR) %>% 
  arrange(-HR) %>%                                # arrange(-HR) == arrange(desc(HR))
  head(15)

hr_career <- batting %>% 
  select(playerID, Name, HR) %>% 
  group_by(playerID, Name) %>%                    # 겹치는 이름이 있을 수 있으므로 playerID로 group_by하는 것이 정확함
  summarise(
    HR_tot = sum(HR)
  ) %>% 
  ungroup() %>%                                   # 이전에 playerID와 Name으로 group_by했던 거를 다시 취소
  select(-playerID) %>%                           # == select everything except playerID (== remove playerID)
  arrange(-HR_tot) %>% 
  head(50)

# Fix batting to make season stats #
# bat_21 df에서 stint == 2(이적을 한 경우)에는 사람은 한 명이지만 AB 100 이하의 경우가 있으면 데이터가 잘릴 수도 있음, 그걸 고치려는 거
bat <- batting %>% 
  group_by(playerID, yearID) %>% 
  summarise_if(is.numeric, sum) %>%               # R에서는 char + 안됨
  #이러면 char 데이터를 잃음 (아마?)
  left_join(., select(players, playerID, Name))





#### Exercise ####
library(tidyverse)
library(Lahman)

data("LahmanData")
LahmanData$file

batting <- Batting

# 1. Make a batting average leader board (with just playerID and BA) for players with 100 or more ABs in 2019.
bat_19_leader <- batting %>% 
  filter(yearID == 2019, AB >= 100) %>% 
  mutate(BA = round(H/AB, digits = 3)) %>% 
  select(playerID, BA)


# 2. Make a leader board for HRs per AB for players with 100 or more ABs in 2021.
players <- People

players <- players %>% 
  mutate(
    Name = paste(nameFirst, nameLast, sep=" ")
  )


bat_21_hr_leader <- batting %>% 
  filter(yearID == 2021, AB >= 100) %>% 
  mutate(HRperAB = round(HR/AB, digits = 3)) %>% 
  select(playerID, HRperAB)


# 3. Build a data frame of seasonal stats for hitters in 2021.
# Hint: notice how players that were traded have multiple entries, one for each team.
players_Name_ID <- players %>% 
  select(Name, playerID)

stats_21 <- batting

stats_21 <- merge(x = stats_21, y = players_Name_ID, by="playerID", all.x = TRUE)

stats_21 <- stats_21 %>% 
  filter(yearID == 2021) %>% 
  group_by(playerID, yearID) %>% 
  summarise_if(is.numeric, sum) %>% 
  left_join(., select(players, playerID, Name))




# 4. Have average team stolen bases changed over the last 30 years?
team <- Teams

team_1993 <- team %>% 
  filter(
    yearID >= 1993,
    yearID != 2020,
  ) %>% 
  mutate(SBmean = round(mean(SB)))

sb_team <- team_1993 %>%
  group_by(franchID, yearID) %>% 
  select(franchID, yearID, SBmean)

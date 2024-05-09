# 3_DataTransformation.qmd

title: "Data Transformation"  
author: "kbr1218"  
format: html  
editor: visual
<br>
<br>

## Data

Data: information - comes in many forms: structured or unstructured

convert raw data into structured data (tidy)

| Structured Data |
|:---------------:|

| Numeric | Categorical: Take value representing set of categories |
|---------|--------------------------------------------------------|

| Continuous: Take any value in interval | Discrete: only integer values | Binary: Yes/No | Ordinal: Ordered Categories |
|--------------------|------------------|------------------|------------------|

R will convert imported data

<br>

### R Objects

#### Atomic Vector: vector of data

each vector can only store 1 type of data

-   Doubles (numeric)

-   Integer

-   Characters

-   Logicals

-   Complex

-   Raw

```{r, objects, message=FALSE, warning=FALSE}
library(tidyverse)    # load the tidyverse package

# Double #
hits <- c(1, 0, 3, 2, 0) 

length(hits)
typeof(hits)

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
```

#### Matrix: two dimensional array

```{r, matrix, warning=FALSE, message=FALSE}

## Matrix ##

hit_matrix <- matrix(c(player, hits, ab), nrow = 5)
hit_matrix

class(hit_matrix)
```

#### Factor: Category (can order them)

```{r, factor, warning=FALSE, message=FALSE}

hand <- factor(c("L", "L", "L", "R", "R"))
```

#### Data Frame: Group vectors into 2 dimensional table (vectors must be same length)

-   can contain different data types

-   each column must be the same

```{r, data_frames, warning=FALSE, message=FALSE}

## Data Frame ##

hit_df <- tibble(player = player, hand = hand, hits = hits, ab = ab)
hit_df

hit_df$player
```

typically use [rectangular data]{.underline}

[![](https://d33wubrfki0l68.cloudfront.net/6f1ddb544fc5c69a2478e444ab8112fb0eea23f8/91adc/images/tidy-1.png)](https://r4ds.had.co.nz/tidy-data.html#tidy-data-1)


<br>

## Verbs (Functions)

from tidyverse (dplyr)

How do they work?

-   how to make new data frame

    -   df_new \<- verb(df_old, arguments)

    -   df_new \<- df_old%\>%

verb(arguments) %\>%

verb(argument)

-   #%\>%: Pipes (shortcut: ctrl + shift + m)

1.  df_old: first argument, the data frame you're transform

2.  verb: the type of transformation

3.  arguments: how you transform

4.  df_new: result of the transformation(s)

**Can chain functions using a pipe**

```{r, setup, include=FALSE}
#include를 false로 넣으면 이 code chunk를 final documents에 포함시키지 않음

library(Lahman)

data("LahmanData")

batting <- Batting    # bring Batting data to batting object
names(batting)
str(batting)
```

1.  Filter: subset observations based on values, use comparison operators\
    [![](https://d33wubrfki0l68.cloudfront.net/01f4b6d39d2be8269740a3ad7946faa79f7243cf/8369a/diagrams/transform-logical.png)](https://r4ds.had.co.nz/transform.html)

    ```{r, filter, warning=FALSE, message=FALSE}
    bat_21 <- batting  %>%      # Keep data raw and make new data frame
      filter(yearID == 2021)    # dplyer- filter 함수 이용하기

    #remove objects in environment: rm(name_of_object)

    bat_21 <- batting %>% 
      filter(yearID == 2021, AB >= 100)    # multiple filters all at once
    ```

2.  Select: Selects variables of interest

    ```{r, select, warning=FALSE, message=FALSE}
    bat_21_hr <- bat_21 %>%     # hr data를 담은 data frame 생성
      select(playerID, HR)      
    ```

3.  Arrange: change row order based on column to sort by. Default is ascending, change by using descending

    ```{r, arrange, warning=FALSE, message=FALSE}
    bat_21_hr <- bat_21_hr %>%
      #arrange(HR)              # lowest -> highest
      arrange(desc(HR))         # highest -> lowest

    bat_21_hr_leader <- bat_21_hr %>%
      arrange(desc(HR)) %>%     # highest -> lowest
      head(15)                  # print top 15 row

    bat_21_hr_leader
    ```

4.  Mutate: New variable that is function or transformation of other variables

    ```{r, mutate, message=FALSE, warning=FALSE}

    bat_21 <- bat_21 %>% 
      mutate(                               # make many variables in one mutate
        BA = round(H/AB, digits = 3),       # BA: Batting Average
        SO_rate = round(SO/AB, digits = 2)  # SO: Strike Out
      )
    ```

5.  Summarise: Collapse to single row with summary statistic

    ```{r, summarise, message=FALSE, warning=FALSE}
    hr_dist <- bat_21_hr %>%        # summarise를 하면 주로 새로운 object를 만듦
      summarise(                    # 원래 있던 object에 overwriting하지 않으려고
        avg_hr = mean(HR),
        max_hr = max(HR),
        min_hr = min(HR)
      )

    hr_dist
    ```

6.  Group By: Uses a group (subset) as the unit of analysis

    ```{r, group_by, warning=FALSE, message=FALSE}
    team <- Teams               # team data frame을 계속 가지고 있기

    team_2000 <- team %>%       # 2000년 이후, 2020년 제외한 data frame 만들기
      filter(
        yearID >= 2000,
        yearID != 2020,
      )

    hr_team <- team_2000 %>%    # summarise를 위해 새로운 data frame 만들기
      group_by(franchID) %>%    # Group마다의 summarise하기 위해 group_by 함수 사용
      summarise(                # group_by로는 각각의 data frame을 만들 필요 없음
        hr_avg = mean(HR),
        hr_max = max(HR),
        hr_min = min(HR)
      )

    hr_total <- team_2000 %>%   # 팀마다 hr의 total값이 있는 data frame 만들기
      group_by(franchID) %>% 
      summarise(
        hr_tot = sum(HR)
      )
    ```

7.  Merging: combine datasets

    ```{r, merging, warning=FALSE, message=FALSE}

    ```
    
<br>

## Exercises

```{r, setup, warning=FALSE, message=FALSE}

library(tidyverse)
library(Lahman)

data("LahmanData")
LahmanData$file

batting <- Batting    # Load Batting data to batting object
```

1.  Make a batting average leader board (with just playerID and BA) for players with 100 or more ABs in 2019.

```{r, Q1, warning=FALSE, message=FALSE}

bat_19_leader <- batting %>% 
  filter(yearID == 2019, AB >= 100) %>% 
  mutate(BA = round(H/AB, digits = 3)) %>% 
  select(playerID, BA)

bat_19_leader
```

2.  Make a leader board for HRs per AB for players with 100 or more ABs in 2021.

```{r, Q2, warning=FALSE, message=FALSE}

players <- People

players <- players %>% 
  mutate(
    Name = paste(nameFirst, nameLast, sep=" ")
  )


bat_21_hr_leader <- batting %>% 
  filter(yearID == 2021, AB >= 100) %>% 
  mutate(HRperAB = round(HR/AB, digits = 3)) %>% 
  select(playerID, HRperAB)

bat_21_hr_leader
```

3.  Build a data frame of seasonal stats for hitters in 2021. Hint: notice how players that were traded have multiple entries, one for each team.

```{r, Q3, warning=FALSE, message=FALSE}
players_Name_ID <- players %>% 
  select(Name, playerID)

stats_21 <- batting

stats_21 <- merge(x = stats_21, y = players_Name_ID, by="playerID", all.x = TRUE)

stats_21 <- stats_21 %>% 
  filter(yearID == 2021) %>% 
  group_by(playerID, yearID) %>% 
  summarise_if(is.numeric, sum) %>% 
  left_join(., select(players, playerID, Name))

stats_21
```

4.  Have average team stolen bases changed over the last 30 years?

```{r, Q4, message=FALSE, warning=FALSE}
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

sb_team

# Average team stolen bases have not changed over the last 30 years.
```

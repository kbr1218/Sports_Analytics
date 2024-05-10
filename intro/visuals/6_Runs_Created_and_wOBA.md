# 6_Runs_Created_and_wOBA.qmd
title: "Runs Created and wOBA"  
author: "kbr1218"  
format: html  
editor: visual  

<br>
<br>

## Runs Created

Estimate of a player's contribution to team's runs scored

1.  Context Neutral
2.  Counting stat

- issue: 양적 수치이므로 많은 타석에 나선 선수가 유리함

$$
RC=\frac{\left(H+BB+HBP-CS-GIDP\right)\times\left(TB+0.26\times\left[BB-IBB+HBP\right]\right)+\left(0.52\times\left[SH+SF+SB\right]\right)}{AB+BB+HBP+SH+SF}
$$

```{r, setup, include=FALSE}

library(tidyverse)
library(Lahman)

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

```

<br>

## Weight On-Base Average (wOBA)

On-base percentage that weights how they got on base by RUN VALUES

$$
wOBA = \frac{0.69\times BB + 0.72\times HBP + 0.88\times 1B + 1.25\times 2B + 1.5\times 3B + 2.03\times HR}{AB+BB-IBB+SF+HBP}
$$

<br>

## Exercises

1.  Explore the distributions of Runs Created per 600 at bats (AB/600) and wOBA

2.  What are the 25th, 50th, 75th, 90th, 95th percentiles for RC600 and wOBA.

3.  Are RC600 and wOBA repeatable year over year?

4.  Are RC600 and wOBA good measures of success?

5.  Use wOBA to calculate weighted runs above average ([wRAA](https://library.fangraphs.com/offense/wraa/)).

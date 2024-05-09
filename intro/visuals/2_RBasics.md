# 2_RBasics.qmd

title: "R Basics"  
author: "kbr1218"  
format: html  
editor: visual
<br>
<br>

## R Studio

[![](https://d33wubrfki0l68.cloudfront.net/8a64bb047429d7ae0e2acae35c40e421e6439bf6/80e5d/diagrams/rstudio-editor.png)](https://r4ds.had.co.nz/workflow-scripts.html)

-   R Script : Place to save R code

-   R Quarto/Markdown : Publish output

### Running Code

Can run code in the Console (enter), through an R Script (command + enter), in RMarkdown (render or run code).

```{r, run_code, warning=FALSE, message=FALSE}
1 + 1
```

## Objects

Object: save and store data

-   Can't start with a number or special symbol

-   Case sensitive

```{r, objects}
# making an object
a <- 1 #object named a that is the value one, should see in environment
a
A # got error: object 'A' not found, case sensitive

a <- 2 # overwrote a equaling one with a equaling 2
a
```

## Functions

Many functions are already programmed to perform standard tasks

Can run multiple functions at once: inner -\> outer (tidyverse, string together first -\> last, connect with pipe %\>%)

Functions usually have multiple arguments

```{r, function_, warning=FALSE, message=FALSE}
die <- 1:6 # create object named die that's integers 1-6
die

mean(die) # Find the mean of die

round(mean(die), digits = 1)
#round(mean(die), 1)
```

good idea to write argument otherwise order matters

### Build own function

my_function \<- function(){}

-   name

-   arguments in ( )

-   body

-   output of function

note: the function will spit out the last line

```{r, die_roll_function, warning=FALSE, message=FALSE}
## Function to simulate a roll of the dice

roll <- function(){    # roll: name of function, function(arguments...)
  die <- 1:6
  dice <- sample(die, size = 2, replace = TRUE)
  # sample(): return random sample function
  
  sum(dice)    # last line is what function returns, here sum of my two die samples
  
}

roll() # runs the function
roll   # see the function
```

## Exercises

1.  **Where can you find the objects you've created?**

    objects in the environment area in the upper right corner

2.  **What is your current working directory?**

3.  **Find 3 built in tidyverse functions and explain what they do and their main arguments. Where can you find help with the functions?**

    1.  **separate**: Separate a character column into multiple columns with a regular expression or numeric locations (arguments: data, col, into, sep, etc.)

    2.  **unite**: Unite multiple columns into one by pasting strings together (arguments: data, col, sep, etc.)

    3.  **select**: Subset columns using their names and types (arguments: .data)

    4.  If I want to know who to use the function, type help("name_of_function") in Console window or search using the "Help" area in the lower right corner

        ```{r, help, warning=FALSE, message=FALSE}
        #help("name_of_function")
        ```

4.  **Write a function that finds the average of 2 die rolls.**

    ```{r, avg, warning=FALSE, message=FALSE}
    library(tidyverse)

    avg <- function(){
      die <- 1:6
      dice <- sample(die, size = 2, replace = TRUE)
      # sample(): return random sample function
      
      mean(dice)    # what function returns: mean
    }

    avg()
    ```

5.  **Write a function that finds the sum of 2 die rolls.**

    ```{r, sum, warning=FALSE, message=FALSE}
    roll <- function(){
      die <- 1:6
      dice <- sample(die, size = 2, replace = TRUE)
      # sample(): return random sample function
      
      sum(dice)    # what function return: sum
      
    }

    roll()
    ```

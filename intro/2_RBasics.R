# running code
1 + 1

# making an object
a <- 1    # object named a that is the value one, should see in environment
a
A    # got error: object 'A' not found, case sensitive

a <- 2    # overwrote a equaling one with a equaling 2

drew_velo <- 82    # made object drew_velo

ls()    # lists all the objects in the environment

rm(drew_velo)    # removed drew_velo from the environment

#### Functions ####

mean(1:6)    # Find the mean of integers 1-6

die <- 1:6   # create object named die that's integers 1-6
die

mean(die)    # Find the mean of die

round(mean(die), digits = 1)
# round(mean(die), 1)


## Build our own function ##

roll <- function(){    # roll: name of function, function(arguments...)
  die <- 1:6
  dice <- sample(die, size = 2, replace = TRUE)    # sample(): return random sample function
  
  sum(dice)    # last line is what function returns, here sum of my two die samples
  
}

roll() #runs the function
roll   #see the function


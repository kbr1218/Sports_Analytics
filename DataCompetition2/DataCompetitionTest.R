library(tidyverse)
library(ggrepel)
library(ggplot2)


# to use rbindlist in field code
# install.packages("data.table")
library(data.table)

# to use multiple graphs
# install.packages('gridExtra')
library(gridExtra)

hitter <- read.csv("Hitters Against ARC Opponents 2023_noName.csv")

####################################
########### Field  Graph ###########
####################################

f9.plot = data.frame(loc = rep("f9", times = 3),
                     x = c(50,100,54.25),
                     y = c(50,0,54.25),
                     x.1 = rep(50, times = 3),
                     y.1 = rep(31.25, times = 3))

f8.plot = data.frame(loc = rep("f8", times = 3),
                     x = c(54.25,100,62.5),
                     y = c(54.25,0,62.5),
                     x.1 = rep(50, times = 3),
                     y.1 = rep(31.25, times = 3))

f7.plot = data.frame(loc = rep("f7", times = 3),
                     x = c(62.5,100,66.75),
                     y = c(62.5,0,67),
                     x.1 = rep(81.25, times = 3),
                     y.1 = rep(60, times = 3))

f6.plot = data.frame(loc = rep("f6", times = 3),
                     x = c(66.75,100,88.9),
                     y = c(66.75,0,88.9),
                     x.1 = rep(81.25, times = 3),
                     y.1 = rep(60, times = 3))

f5.plot = data.frame(loc = rep("f5", times = 4),
                     x = c(88.9,100, 111.1, 100),
                     y = c(88.9,0, 88.9, 100),
                     x.1 = rep(81.25, times = 4),
                     y.1 = rep(60, times = 4))

f4.plot = data.frame(loc = rep("f4", times = 3),
                     x = c(111.1,100,133.25),
                     y = c(88.9,0,66.75),
                     x.1 = rep(81.25, times = 3),
                     y.1 = rep(60, times = 3))

f3.plot = data.frame(loc = rep("f3", times = 3),
                     x = c(100, 137.5, 133.25),
                     y = c(0, 62.5, 67),
                     x.1 = rep(118.75),
                     y.1 = rep(60, times = 3))

f2.plot = data.frame(loc = rep("f2", times = 3),
                     x = c(100, 145.75, 137.5),
                     y = c(0, 54.25, 62.5),
                     x.1 = rep(150, times = 3),
                     y.1 = rep(31.25, times = 3))

f1.plot = data.frame(loc = rep("f1", times = 3),
                     x = c(100, 150, 145.75),
                     y = c(0, 50, 54.25),
                     x.1 = rep(150, times = 3),
                     y.1 = rep(31.25, times = 3))

### outfield ###
f10.plot = data.frame(loc = rep("f10", times = 4),
                      x = c(0,50,54.25,0.5),
                      y = c(100,50,54.25,115),
                      x.1 = rep(37.5, times = 4),
                      y.1 = rep(100, times = 4))

f11.plot = data.frame(loc = rep("f11", times = 4),
                      x = c(0.5, 54.25, 70, 35),
                      y = c(115, 54.25, 70, 150),
                      x.1 = rep(37.5, times = 4),
                      y.1 = rep(100, times = 4))

f12.plot = data.frame(loc = rep("f12", times = 4),
                      x = c(70, 88.9, 70, 35),
                      y = c(70, 88.9, 170, 150),
                      x.1 = rep(37.5, times = 4),
                      y.1 = rep(100, times = 4))

f13.plot = data.frame(loc = rep("f13", times = 5),
                      x = c(88.9, 100, 111.1, 130, 70),
                      y = c(88.9, 100, 88.9, 170, 170),
                      x.1 = rep(100, times = 5),
                      y.1 = rep(125, times = 5))

f14.plot = data.frame(loc = rep("f14", times = 4),
                      x = c(111.1, 130, 165, 130),
                      y = c(88.9, 70, 150, 170),
                      x.1 = rep(162.5, times = 4),
                      y.1 = rep(100, times = 4))

f15.plot = data.frame(loc = rep("f15", times = 4),
                      x = c(130, 145.75, 199.5, 165),
                      y = c(70, 54.25, 115, 150),
                      x.1 = rep(162.5, times = 4),
                      y.1 = rep(100, times = 4))

f16.plot = data.frame(loc = rep("f16", times = 4),
                      x = c(145.75, 150, 200, 199.5),
                      y = c(54.25, 50, 100, 115),
                      x.1 = rep(162.5, times = 4),
                      y.1 = rep(100, times = 4))

field = rbindlist(list(f1.plot, f2.plot, f3.plot, f4.plot, f5.plot, f6.plot, f7.plot, f8.plot, f9.plot,   # infield
                       f10.plot, f11.plot, f12.plot, f13.plot, f14.plot, f15.plot, f16.plot))             # outfield


####################################
########### Make Dataset ###########
####################################

# make field name
hitter$bip_location <-
  paste0("f", hitter$bip_location[!is.null(hitter$bip_location)])

# make name column
hitter$name <- sapply(strsplit(as.character(hitter$narrative), " "), function(x) {
  if (grepl("\\.$", x[1])) {
    return(x[2])
  } else {
    return(x[1])
  }
})


# dataset containing name of field xVals and yVals
fieldGraph <- data.frame(bip_location = paste0("f", seq(1:16)))
fieldGraph[, "xVal"] <- c(130, 130, 129, 117.5, 100, 82.5, 71, 70, 70, 25, 35, 65, 100, 135, 170, 175)
fieldGraph[, 'yVal'] <- c(32.5, 42.5, 52.5, 65, 75, 65, 52.5, 42.5, 32.5, 80, 105, 125, 140, 125, 110, 80)


####################################
########### Field  Chart ###########
####################################

fieldNumber <- fieldGraph
fieldNumber[, "number"] <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)
  

ggplot(field, aes(x = x, y = y)) +
  xlim(0,200) +
  ylim(0,170) +
  geom_polygon(aes(x=x, y=y, group = loc), color = "black", fill = "white") +
  geom_text(data = fieldNumber, aes(x = xVal, y = yVal, label = number)) +
  theme(legend.position = "bottom", panel.background = element_blank(),
        axis.line = element_blank(), axis.ticks = element_blank(),
        axis.title = element_blank(),axis.text = element_blank(),
        plot.title = element_text(hjust = 0.5, size = 18, face = "bold")) +
  coord_fixed()+
  ggtitle("Field Number")


####################################
########### Hitter  Data ###########
####################################

# hitter 1 Ba**l
hitter1 <- hitter %>% 
  filter(name == 'Ba**l') %>% 
  group_by(bip_location) %>% 
  summarise(
    Bip = n(),
    ab = sum(at_bats),
    x1b = sum(singles),
    x2b = sum(doubles),
    x3b = sum(triples),
    hr = sum(hrs),
    slug = round((x1b + 2*x2b + 3*x3b + 4*hr) / ab, digits = 3)
  )
hitter1 <- 
  merge(fieldGraph, hitter1, by = "bip_location", all.x = TRUE)

p1 <- ggplot(field, aes(x = x, y = y)) +
  xlim(0,200) +
  ylim(0,170) +
  geom_polygon(aes(x=x, y=y, group = loc), color = "black", fill = "mediumseagreen") +
  geom_text(data = hitter1, aes(x = xVal, y = yVal, label = slug)) +
  theme(legend.position = "bottom", panel.background = element_blank(),
        axis.line = element_blank(), axis.ticks = element_blank(),
        axis.title = element_blank(),axis.text = element_blank(),
        plot.title = element_text(hjust = 0.5, size = 18, face = "bold")) +
  labs(subtitle = 'H1 Ba**l') +
  coord_fixed()

p1




# hitter 2 Bo**********t
hitter2 <- hitter %>% 
  filter(name == 'Bo**********t') %>% 
  group_by(bip_location) %>% 
  summarise(
    Bip = n(),
    ab = sum(at_bats),
    x1b = sum(singles),
    x2b = sum(doubles),
    x3b = sum(triples),
    hr = sum(hrs),
    slug = round((x1b + 2*x2b + 3*x3b + 4*hr) / ab, digits = 3)
  )
hitter2 <- 
  merge(fieldGraph, hitter2, by = "bip_location", all.x = TRUE)

p2 <- ggplot(field, aes(x = x, y = y)) +
  xlim(0,200) +
  ylim(0,170) +
  geom_polygon(aes(x=x, y=y, group = loc), color = "black", fill = "mediumseagreen") +
  geom_text(data = hitter2, aes(x = xVal, y = yVal, label = slug)) +
  theme(legend.position = "bottom", panel.background = element_blank(),
        axis.line = element_blank(), axis.ticks = element_blank(),
        axis.title = element_blank(),axis.text = element_blank(),
        plot.title = element_text(hjust = 0.5, size = 18, face = "bold")) +
  labs(subtitle = 'H2 Bo**********t') +
  coord_fixed()

p2




# hitter 3 Do**d
hitter3 <- hitter %>% 
  filter(name == 'Do**d') %>% 
  group_by(bip_location) %>% 
  summarise(
    Bip = n(),
    ab = sum(at_bats),
    x1b = sum(singles),
    x2b = sum(doubles),
    x3b = sum(triples),
    hr = sum(hrs),
    slug = round((x1b + 2*x2b + 3*x3b + 4*hr) / ab, digits = 3)
  )
hitter3 <- 
  merge(fieldGraph, hitter3, by = "bip_location", all.x = TRUE)

p3 <- ggplot(field, aes(x = x, y = y)) +
  xlim(0,200) +
  ylim(0,170) +
  geom_polygon(aes(x=x, y=y, group = loc), color = "black", fill = "mediumseagreen") +
  geom_text(data = hitter3, aes(x = xVal, y = yVal, label = slug)) +
  theme(legend.position = "bottom", panel.background = element_blank(),
        axis.line = element_blank(), axis.ticks = element_blank(),
        axis.title = element_blank(),axis.text = element_blank(),
        plot.title = element_text(hjust = 0.5, size = 18, face = "bold")) +
  labs(subtitle = 'H3 Do**d') +
  coord_fixed()

p3



# hitter 4 Gr*****d
hitter4 <- hitter %>% 
  filter(name == 'Gr*****d') %>% 
  group_by(bip_location) %>% 
  summarise(
    Bip = n(),
    ab = sum(at_bats),
    x1b = sum(singles),
    x2b = sum(doubles),
    x3b = sum(triples),
    hr = sum(hrs),
    slug = round((x1b + 2*x2b + 3*x3b + 4*hr) / ab, digits = 3)
  )
hitter4 <- 
  merge(fieldGraph, hitter4, by = "bip_location", all.x = TRUE)

p4 <- ggplot(field, aes(x = x, y = y)) +
  xlim(0,200) +
  ylim(0,170) +
  geom_polygon(aes(x=x, y=y, group = loc), color = "black", fill = "mediumseagreen") +
  geom_text(data = hitter4, aes(x = xVal, y = yVal, label = slug)) +
  theme(legend.position = "bottom", panel.background = element_blank(),
        axis.line = element_blank(), axis.ticks = element_blank(),
        axis.title = element_blank(),axis.text = element_blank(),
        plot.title = element_text(hjust = 0.5, size = 18, face = "bold")) +
  coord_fixed()+
  labs(subtitle = 'H4 Gr*****d')

p4




# hitter 5 Ka******r
hitter5 <- hitter %>% 
  filter(name == 'Ka******r') %>% 
  group_by(bip_location) %>% 
  summarise(
    Bip = n(),
    ab = sum(at_bats),
    x1b = sum(singles),
    x2b = sum(doubles),
    x3b = sum(triples),
    hr = sum(hrs),
    slug = round((x1b + 2*x2b + 3*x3b + 4*hr) / ab, digits = 3)
  )
hitter5 <- 
  merge(fieldGraph, hitter5, by = "bip_location", all.x = TRUE)

p5 <- ggplot(field, aes(x = x, y = y)) +
  xlim(0,200) +
  ylim(0,170) +
  geom_polygon(aes(x=x, y=y, group = loc), color = "black", fill = "mediumseagreen") +
  geom_text(data = hitter5, aes(x = xVal, y = yVal, label = slug)) +
  theme(legend.position = "bottom", panel.background = element_blank(),
        axis.line = element_blank(), axis.ticks = element_blank(),
        axis.title = element_blank(),axis.text = element_blank(),
        plot.title = element_text(hjust = 0.5, size = 18, face = "bold")) +
  labs(subtitle = 'H5 Ka******r') +
  coord_fixed()

p5




# hitter 6 Ma*******n
hitter6 <- hitter %>% 
  filter(name == 'Ma*******n') %>% 
  group_by(bip_location) %>% 
  summarise(
    Bip = n(),
    ab = sum(at_bats),
    x1b = sum(singles),
    x2b = sum(doubles),
    x3b = sum(triples),
    hr = sum(hrs),
    slug = round((x1b + 2*x2b + 3*x3b + 4*hr) / ab, digits = 3)
  )
hitter6 <- 
  merge(fieldGraph, hitter6, by = "bip_location", all.x = TRUE)


p6 <- ggplot(field, aes(x = x, y = y)) +
  xlim(0,200) +
  ylim(0,170) +
  geom_polygon(aes(x=x, y=y, group = loc), color = "black", fill = "mediumseagreen") +
  geom_text(data = hitter6, aes(x = xVal, y = yVal, label = slug)) +
  theme(legend.position = "bottom", panel.background = element_blank(),
        axis.line = element_blank(), axis.ticks = element_blank(),
        axis.title = element_blank(),axis.text = element_blank(),
        plot.title = element_text(hjust = 0.5, size = 18, face = "bold")) +
  labs(subtitle = 'H6 Ma*******n') +
  coord_fixed()

p6




# hitter 7 Me***e
hitter7 <- hitter %>% 
  filter(name == 'Me***e') %>% 
  group_by(bip_location) %>% 
  summarise(
    Bip = n(),
    ab = sum(at_bats),
    x1b = sum(singles),
    x2b = sum(doubles),
    x3b = sum(triples),
    hr = sum(hrs),
    slug = round((x1b + 2*x2b + 3*x3b + 4*hr) / ab, digits = 3)
  )
hitter7 <- 
  merge(fieldGraph, hitter7, by = "bip_location", all.x = TRUE)

p7 <- ggplot(field, aes(x = x, y = y)) +
  xlim(0,200) +
  ylim(0,170) +
  geom_polygon(aes(x=x, y=y, group = loc), color = "black", fill = "mediumseagreen") +
  geom_text(data = hitter7, aes(x = xVal, y = yVal, label = slug)) +
  theme(legend.position = "bottom", panel.background = element_blank(),
        axis.line = element_blank(), axis.ticks = element_blank(),
        axis.title = element_blank(),axis.text = element_blank(),
        plot.title = element_text(hjust = 0.5, size = 18, face = "bold")) +
  coord_fixed() +
  labs(subtitle = 'H7 Me***e')

p7




# hitter 8 St*****y
hitter8 <- hitter %>% 
  filter(name == 'St*****y') %>% 
  group_by(bip_location) %>% 
  summarise(
    Bip = n(),
    ab = sum(at_bats),
    x1b = sum(singles),
    x2b = sum(doubles),
    x3b = sum(triples),
    hr = sum(hrs),
    slug = round((x1b + 2*x2b + 3*x3b + 4*hr) / ab, digits = 3)
  )
hitter8 <- 
  merge(fieldGraph, hitter8, by = "bip_location", all.x = TRUE)

p8 <- ggplot(field, aes(x = x, y = y)) +
  xlim(0,200) +
  ylim(0,170) +
  geom_polygon(aes(x=x, y=y, group = loc), color = "black", fill = "mediumseagreen") +
  geom_text(data = hitter8, aes(x = xVal, y = yVal, label = slug)) +
  theme(legend.position = "bottom", panel.background = element_blank(),
        axis.line = element_blank(), axis.ticks = element_blank(),
        axis.title = element_blank(),axis.text = element_blank(),
        plot.title = element_text(hjust = 0.5, size = 18, face = "bold")) +
  coord_fixed()+
  labs(subtitle = 'H8 St*****y')

p8




# hitter 9 Vo*****a
hitter9 <- hitter %>% 
  filter(name == 'Vo*****a') %>% 
  group_by(bip_location) %>% 
  summarise(
    Bip = n(),
    ab = sum(at_bats),
    x1b = sum(singles),
    x2b = sum(doubles),
    x3b = sum(triples),
    hr = sum(hrs),
    slug = round((x1b + 2*x2b + 3*x3b + 4*hr) / ab, digits = 3)
  )
hitter9 <- 
  merge(fieldGraph, hitter9, by = "bip_location", all.x = TRUE)

p9 <- ggplot(field, aes(x = x, y = y)) +
  xlim(0,200) +
  ylim(0,170) +
  geom_polygon(aes(x=x, y=y, group = loc), color = "black", fill = "mediumseagreen") +
  geom_text(data = hitter9, aes(x = xVal, y = yVal, label = slug)) +
  theme(legend.position = "bottom", panel.background = element_blank(),
        axis.line = element_blank(), axis.ticks = element_blank(),
        axis.title = element_blank(),axis.text = element_blank(),
        plot.title = element_text(hjust = 0.5, size = 18, face = "bold")) +
  coord_fixed()+
  labs(subtitle = 'H9 Vo*****a')

p9




# hitter 10 Wo**d
hitter10 <- hitter %>% 
  filter(name == 'Wo**d') %>% 
  group_by(bip_location) %>% 
  summarise(
    Bip = n(),
    ab = sum(at_bats),
    x1b = sum(singles),
    x2b = sum(doubles),
    x3b = sum(triples),
    hr = sum(hrs),
    slug = round((x1b + 2*x2b + 3*x3b + 4*hr) / ab, digits = 3)
  )
hitter10 <- 
  merge(fieldGraph, hitter10, by = "bip_location", all.x = TRUE)

p10 <- ggplot(field, aes(x = x, y = y)) +
  xlim(0,200) +
  ylim(0,170) +
  geom_polygon(aes(x=x, y=y, group = loc), color = "black", fill = "mediumseagreen") +
  geom_text(data = hitter10, aes(x = xVal, y = yVal, label = slug)) +
  theme(legend.position = "bottom", panel.background = element_blank(),
        axis.line = element_blank(), axis.ticks = element_blank(),
        axis.title = element_blank(),axis.text = element_blank(),
        plot.title = element_text(hjust = 0.5, size = 18, face = "bold")) +
  labs(subtitle = 'H10 Wo**d') +
  coord_fixed()

p10




# Graphs in one slide
grid.arrange(p1, p2, p3, p4, p5,
             p6, p7, p8, p9, p10, ncol=5)


# with arrows
p8_result <- ggplot(field, aes(x = x, y = y)) +
  xlim(0,200) +
  ylim(0,170) +
  geom_polygon(aes(x=x, y=y, group = loc), color = "black", fill = "mediumseagreen") +
  geom_text(data = hitter8, aes(x = xVal, y = yVal, label = slug)) +
  theme(legend.position = "bottom", panel.background = element_blank(),
        axis.line = element_blank(), axis.ticks = element_blank(),
        axis.title = element_blank(),axis.text = element_blank(),
        plot.title = element_text(hjust = 0.5, size = 18, face = "bold")) +
  geom_segment(aes(x=100, y=50, xend=100, yend=110),
               arrow = arrow(), 
               color='orange', size=2) +
  geom_segment(aes(x=120, y=50, xend=150, yend=100),
               arrow = arrow(), 
               color='orange', size=2) +
  geom_segment(aes(x=80, y=50, xend=50, yend=100),
               arrow = arrow(), 
               color='orange', size=2) +
  coord_fixed()+
  ggtitle("H8 St*****y")


# Ma*******n
p6_result <- ggplot(field, aes(x = x, y = y)) +
  xlim(0,200) +
  ylim(0,170) +
  geom_polygon(aes(x=x, y=y, group = loc), color = "black", fill = "mediumseagreen") +
  geom_text(data = hitter6, aes(x = xVal, y = yVal, label = slug)) +
  theme(legend.position = "bottom", panel.background = element_blank(),
        axis.line = element_blank(), axis.ticks = element_blank(),
        axis.title = element_blank(),axis.text = element_blank(),
        plot.title = element_text(hjust = 0.5, size = 18, face = "bold")) +
  coord_fixed()+
  geom_segment(aes(x=160, y=110, xend=100, yend=110),
               arrow = arrow(), 
               color='orange', size=2) +
  geom_segment(aes(x=75, y=50, xend=50, yend=90),
               arrow = arrow(), 
               color='orange', size=2) +
  ggtitle("H6 Ma*******n")



p7_result <- ggplot(field, aes(x = x, y = y)) +
  xlim(0,200) +
  ylim(0,170) +
  geom_polygon(aes(x=x, y=y, group = loc), color = "black", fill = "mediumseagreen") +
  geom_text(data = hitter7, aes(x = xVal, y = yVal, label = slug)) +
  theme(legend.position = "bottom", panel.background = element_blank(),
        axis.line = element_blank(), axis.ticks = element_blank(),
        axis.title = element_blank(),axis.text = element_blank(),
        plot.title = element_text(hjust = 0.5, size = 18, face = "bold")) +
  coord_fixed()+
  geom_segment(aes(x=80, y=30, xend=40, yend=70),
               arrow = arrow(), 
               color='orange', size=2) +
  geom_segment(aes(x=60, y=120, xend=130, yend=120),
               arrow = arrow(), 
               color='orange', size=2) +
  ggtitle("H7 Me***e")

grid.arrange(p3,p8_result, p6_result, p7_result, ncol=4)



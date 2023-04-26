library(tidyverse) 

# Read in the data from a CSV file
sst.test <- read.csv(file = "test.csv")

# Check out the structure of the data set
summary(sst.test)
str(sst.test)
names(sst.test)

# Display the first 10 rows of the data frame
head(sst.test, n = 10)


ggplot(data = sst.test.df) +
  aes(x = Age, fill = Survived) +
  geom_histogram(bin = 30, colour = "#1380A1") +
  #scale_fill_brewer(palette = "Accent") +
  labs(title = "Survival rate on the Space Ship Titanic",
       y = "Survived",
       subtitle = "Distribution By Age, Sex and Pclass",
       caption = "Most that died sucumed to hyperthermia not drowning") +
  theme_bw() + 
  
  facet_grid(Sex~Pclass, scales = "free")
#Proportion of 1st, 2nd and  3rd class women and men who survived
mf.survived <- sst.test.df %>%
  filter(Survived == 1)%>%
  group_by(Pclass,Sex)%>%
  summarise(Counts = n()
  )
mf.died <- sst.test.df %>%
  filter(Survived != 1)%>%
  group_by(Pclass,Sex)%>%
  summarise(Counts = n()
  )
mf.perc.survived <- mf.survived/(mf.survived + mf.died) * 100
select (mf.perc.survived, Counts)


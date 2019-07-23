# Getting Started

library(readr) #### readr allows us more ways of reading in csv files #####
person <- read_csv(
  file = 'data/census_pums/sample.csv',
  col_types = cols_only(
    AGEP = 'i',
    WAGP = 'd',
    SCHL = 'c',
    SEX = 'c'))

## Layered Grammar

library(ggplot2)
ggplot(person, aes(x = WAGP)) +
  geom_histogram()

library(dplyr) ##### tidying data package ####
person <- filter(
  person,
  WAGP > 0,
  WAGP < max(WAGP, na.rm = TRUE))

ggplot(person,
  aes(x = AGEP, y = WAGP)) +
  geom_point()
### same data, differend plot  if change SCHL to AGEP ####
ggplot(person,
  aes(x = SCHL, y = WAGP)) +
  geom_boxplot()

## Layer Customization

ggplot(person,
  aes(x = SCHL, y = WAGP)) +
  geom_point(color = 'red') +
  geom_boxplot() 
  

ggplot(person,
  aes(x = SCHL, y = WAGP)) +
  geom_boxplot() +
  geom_point(
    color = 'red',
    stat = 'summary',
    fun.y = mean) ####what function of y to use ####

## Adding Aesthetics

ggplot(person,
  aes(x = SCHL, y = WAGP, color = SEX)) + ### color determined by SEX value ####
  geom_boxplot()

person$SEX <- factor(person$SEX, levels = c('2', '1')) #### ordering data differently ###

ggplot(person,
  aes(x = SCHL, y = WAGP, color = SEX)) +
  geom_boxplot()

# Storing and Re-plotting

schl_wagp <- ggplot(person,
  aes(x = SCHL, y = WAGP, color = SEX)) +
  geom_point(
    stat = 'summary',
    fun.y = 'mean')

schl_wagp <- schl_wagp +
  scale_color_manual(
    values = c('black', 'red')) ### can also specify a legend name, ask later ###

ggsave(filename = 'schl_wagp.svg',
  plot = schl_wagp,
  width = 4, height = 3)

# Smooth Lines 

ggplot(person,
  aes(x = SEX, y = WAGP)) + 
  geom_point() +
  geom_smooth(
    method = 'lm',   #### linear model method ####
    aes(group = 0))  #### only want to run the regression once ####

# Axes, Labels and Themes

sex_wagp <- ggplot(person,
  aes(x = SEX, y = WAGP)) + 
  geom_point() +
  geom_smooth(
    method = 'lm',
    level = 0.99,
    aes(group = 0))

sex_wagp + labs(           #### adding labels ####
  title = 'Wage Gap',
  x = NULL,
  y = 'Wages (Unadjusted USD)')

sex_wagp + scale_y_continuous(
  trans = 'log10')

sex_wagp + theme_light()

sex_wagp + theme_bw() +
  labs(title = 'Wage Gap') +
  theme(
    plot.title = element_text(
      face = 'bold',
      hjust = 0.5))     #### horizontal justify middle ####

# Facets - including different panels in your plots, but aesthetics controlled by what 
# we have already done in this lesson

person$SCHL <- factor(person$SCHL)
levels(person$SCHL) <- list(
  'High School' = '16',
  'Bachelor\'s' = '21',
  'Master\'s' = '22',
  'Doctorate' = '24')

ggplot(na.omit(person),      ###### want to omit any NA's for this data frame #####
  aes(x = SEX, y = WAGP)) + 
  geom_point() +
  geom_smooth(
    method = 'lm',
    aes(group = 0)) +
  facet_wrap(vars(SCHL))

###### Exercise 1 ############
ggplot(person,
       aes(x=AGEP, y = WAGP, color = SEX)) +
       geom_point(
         stat = 'summary',
         fun.y= 'mean'
       )
####### Exercise 3 #########

ggplot(na.omit(person), 
       aes(x = WAGP)) + 
  geom_histogram() +
  facet_grid(rows = vars(SEX), cols = vars(SCHL)) +
  geom_histogram(data = na.omit(person['WAGP']),
                 alpha = 0.3)

##### basicR exercises ########

###   
(-.3 +- sqrt((0.3^2) - (4*1.5*-2.9)))/(2*1.5)
### answer = -1.494035





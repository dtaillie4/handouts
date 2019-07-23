## Tidy Concept
## split, apply, combine 

trial <- read.delim(sep = ',', header = TRUE, text = "
block, drug, control, placebo
    1, 0.22,    0.58,    0.31
    2, 0.12,    0.98,    0.47
    3, 0.42,    0.19,    0.40
")

## Gather - takes wide data frame, gathers it into a tighter (longer) 
## data frame

library(tidyr)
tidy_trial <- gather(trial,
  key = "treatment",
  value = "response",
  -block) #everything but the block column is a response 

## Spread back out again

survey <- read.delim(sep = ',', header = TRUE, text = "
participant,   attr, val
1          ,    age,  24
2          ,    age,  57
3          ,    age,  13
1          , income,  30
2          , income,  60
")

tidy_survey <- spread(survey,
  key = attr,
  value = val)

tidy_survey <- spread(survey,
  key = attr,
  value = val,
  fill = 0)

## Sample Data 

library(data.table)
cbp <- fread('data/cbp15co.csv') #fread meant for really big data tablels
## str(cbp) shows that it thinks fips codes are numeric and 1 = 0000001
cbp <- fread(
  'data/cbp15co.csv',
  na.strings = NULL,
  colClasses =  c(
    FIPSTATE = 'character',
    FIPSCTY = 'character'))

acs <- fread(
  'data/ACS/sector_ACS_15_5YR_S2413.csv',
  colClasses = c(FIPS = 'character'))

## dplyr Functions 

library(dplyr) 
cbp2 <- filter(cbp,
  grepl('----', NAICS), #grepl searches a column for conditions
  !grepl('------', NAICS))  #!grepl means not something in NAICS colum------

library(stringr) # another way to find specific things in a column
#stringr uses regular expressions, to find patterns in text
cbp2 <- filter(cbp,
  str_detect(NAICS, '[0-9]{2}----')) #detecting this specific pattern in col

cbp3 <- mutate(cbp2,
  FIPS = str_c(FIPSTATE, FIPSCTY)) #str comnbine

cbp3 <- mutate(cbp2,
  FIPS = str_c(FIPSTATE, FIPSCTY),
  NAICS = str_remove(NAICS, '-+')) #str remove, dashes and any number of dashes
# pipe operator takes expression on left and ads it to the right 
# %>%
#c(1,3,5,NA) %>% sum(na.rm = T)

cbp <- cbp %>%
  filter(
    str_detect(NAICS, '[0-9]{2}----')
  ) %>%
  mutate(
    FIPS = str_c(FIPSTATE, FIPSCTY),
    NAICS = str_remove(NAICS, '-+')
  )

cbp <- cbp %>%
  select(
    FIPS,
    NAICS,
    starts_with('N')
  )

## Join

sector <- fread(
  'data/ACS/sector_naics.csv',
  colClasses = c(NAICS = 'character'))

cbp <- cbp %>%
  inner_join(sector) ## adding data from sector using commonly named column

## Group By in order to aggreagate columns 

cbp_grouped <- cbp %>%
  group_by(FIPS, Sector) ## adding data saying that these two columnns are special

## Summarize 

cbp <- cbp %>%
  group_by(FIPS, Sector) %>%
  select(starts_with('N'), -NAICS) %>%
  summarize_all(sum)

acs_cbp <- cbp %>%
  inner_join(acs)



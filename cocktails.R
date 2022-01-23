rm(list=ls()) # Removes everything from global environment

library(tidyverse)

setwd("/Users/benmalem/Documents/R_Projects/cocktails/") # change as needed 

d <- read_csv("/Users/benmalem/Documents/R_Projects/cocktails/cocktails.csv") # reads in data - set to right path

# tidy up some col names, reducing dataset, sorting in alphabetical order
# I've renamed some columns that I then remove, but I might use these columns in the future, which is why they stay...
d <- d %>% 
  rename(i1 = `ingredients/0/ingredient`,
         i1_amount = `ingredients/0/amount`,
         i1_unit = `ingredients/0/unit`,
         i2 = `ingredients/1/ingredient`,
         i2_amount = `ingredients/1/amount`,
         i2_unit = `ingredients/1/unit`,
         i3 = `ingredients/2/ingredient`,
         i3_amount = `ingredients/2/amount`,
         i3_unit = `ingredients/2/unit`,
         i4 = `ingredients/3/ingredient`,
         i4_amount = `ingredients/3/amount`,
         i4_unit = `ingredients/3/unit`,
         i5 = `ingredients/4/ingredient`,
         i5_amount = `ingredients/4/amount`,
         i5_unit = `ingredients/4/unit`) %>%
  select(-c(preparation, source, i1_amount, i1_unit, i2_amount, i2_unit, 
            i3_amount, i3_unit, i4_amount, i4_unit, i5_amount, i5_unit)) %>%
  arrange(name)


#### Adding more cocktails to data ####
# format: name, timing, taste, ingredient x5 (if less than 5, add as NA)
# e.g. old_fash <- c("Old Fashioned", "All day", "Sweet", "Whiskey", "Bitters", "Orange", NA, NA)
# template: old_fash <- c("", "", "", "", "", "", , )
old_f <- c("Old Fashioned", "All day", "Sweet", "Whiskey", "Bitters", "Orange", NA, NA)
d <- rbind(d, old_f) # will need to repeat this to 'bind' each extra row to the main data frame 


d$all_ingredients <- paste(d$i1, d$i2, d$i3, d$i4, sep = ", ") # all ingredients in one string 

# calculating the total amount of ingredients each cocktail has - use to merge with final datasets 
# will allow to judge how many ingredients are missing for each cocktail 
missing_df <- d %>%
  select(name, i1, i2, i3, i4, i5)
# not sure how to fix this so it can just be one statement 
#issue with using the changed missing_df frame with the mutate
missing_df <- missing_df %>% 
  mutate(Total_Ingredients = 5 - rowSums(is.na(missing_df))) %>%
  select(name, Total_Ingredients)


#### This function will allow you to input a cocktail name, and will tell you which cocktails you ####
# could make with similar ingredients. 

cocktail_filter <- function(user_cocktail) {

  # Want to first save the name and ingredients of desired cocktail 
  tipple <- d%>%
    filter(str_detect(user_cocktail, name))
  
  # With for loop, compares i1, i2, i3, i4, i5 to the all_ingredients
  # then appends the result to full_ix
  
  full_i1 <- c()
  full_i2 <- c()
  full_i3 <- c()
  full_i4 <- c()
  full_i5 <- c()
  full_names <- c()
  for (i in seq_along(d$name)) { # seq_along said to be a safer way compared to len()
    name <- d$name[i]
    full_names <- append(full_names, name) # saving name of cocktail
    
    temp <- as.integer(grepl(tipple$i1, d$all_ingredients[i])) # as.integer turns TRUE/FALSE to 1/0
    full_i1 <- append(full_i1, temp)
    
    temp <- as.integer(grepl(tipple$i2, d$all_ingredients[i]))
    full_i2 <- append(full_i2, temp)
    
    temp <- as.integer(grepl(tipple$i3, d$all_ingredients[i]))
    full_i3 <- append(full_i3, temp)
    
    temp <- as.integer(grepl(tipple$i4, d$all_ingredients[i]))
    full_i4 <- append(full_i4, temp)
    
    temp <- as.integer(grepl(tipple$i5, d$all_ingredients[i]))
    full_i5 <- append(full_i5, temp)
    
    df <- data.frame(full_names, full_i1, full_i2, full_i3, full_i4, full_i5) # dataframe with name of cocktail + match
  }
  
  # adding col of the sum of ingredients that match 
  # filter for full match, and when missing just one ingredient
  # arrange in descending order by closest match 
  df <- df %>%
    select(full_names, full_i1, full_i2, full_i3, full_i4, full_i5) %>%
    mutate(n_match = rowSums(df[, 2:6], na.rm = TRUE)) %>%
    select(full_names, n_match) %>%
    filter(n_match >= max(n_match) - 1) %>%
    arrange(desc(n_match))
  
    return(df)
}

# To use, see below e.g. Just enter name of your cocktail in speech marks (has to be in the main dataframe)
# e.g. cocktail_filter("Old Fashioned")



#### Almost identical, but allows you to input the ingredients you have ####
# essentially change the function input and the 'all ingredients' string to match 

cocktail_ingredient_match <- function(i1, i2 = NA, i3 = NA, i4 = NA, i5 = NA) { # user must input string sep by commas
  
  # Want to first save the name and ingredients of desired cocktail 
  tipple <- data.frame(i1, i2, i3, i4, i5)

  full_i1 <- c()
  full_i2 <- c()
  full_i3 <- c()
  full_i4 <- c()
  full_i5 <- c()
  Cocktails <- c()
  for (i in seq_along(d$name)) { # seq_along said to be a safer way compared to len()
    name <- d$name[i]
    Cocktails <- append(Cocktails, name)
    
    temp <- as.integer(grepl(tipple$i1, d$all_ingredients[i])) # as.integer turns TRUE/FALSE to 1/0
    full_i1 <- append(full_i1, temp)
    
    temp <- as.integer(grepl(tipple$i2, d$all_ingredients[i]))
    full_i2 <- append(full_i2, temp)
    
    temp <- as.integer(grepl(tipple$i3, d$all_ingredients[i]))
    full_i3 <- append(full_i3, temp)
    
    temp <- as.integer(grepl(tipple$i4, d$all_ingredients[i]))
    full_i4 <- append(full_i4, temp)
    
    temp <- as.integer(grepl(tipple$i5, d$all_ingredients[i]))
    full_i5 <- append(full_i5, temp)
    
    df <- data.frame(Cocktails, full_i1, full_i2, full_i3, full_i4, full_i5)
  }
  
  # adding col of the sum of ingredients that match 
  # filter for full match, and when missing just one ingredient
  # arrange in descending order by closest match 
  df <- df %>%
    select(Cocktails, full_i1, full_i2, full_i3, full_i4, full_i5) %>%
    mutate(Matched_Ingredients = rowSums(df[, 2:6], na.rm = TRUE)) %>% # calculate n of matched ingredients
    select(Cocktails, Matched_Ingredients) %>% # remove unnecessary cols 
    filter(Matched_Ingredients >= max(Matched_Ingredients) - 1) %>% # filter for closely matched cocktails 
    left_join(missing_df, by = c("Cocktails" = "name")) %>% # join with missing_df to include total ingreds for each cocktail
    mutate(Missing_Ingredients = Total_Ingredients - Matched_Ingredients) %>% # calculate n of missing ingredients
    select(Cocktails, Matched_Ingredients, Missing_Ingredients) %>%
    filter(Missing_Ingredients <= 2) %>% # only include close matches 
    arrange(Missing_Ingredients) # sort by n of ingredients that are missing

  return(df)
}

# Input up to 5 ingredients that you have and find out cocktails with similar ingredients

# To use function, see below. Can input 5 ingredients, in speech marks, separated by commas
# e.g cocktail_ingredient_match("Rye Whiskey", "Grapefruit juice") 

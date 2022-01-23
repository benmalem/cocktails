# cocktails

This script is for those who like making many cocktails with as few ingredients as possible. 

The data was taken from https://github.com/stevana/cocktails/blob/master/data/cocktails.yaml and first converted from .yaml to .csv
Though there are quite a few cocktails in this data, there are a few favourites missing; I have added some example code so they can be added in. 

The script mainly uses tidyverse in R. 

The script currently runs two functions: 

  1. cocktail_filter("Old Fashioned"). The user provides the name of a cocktail they have the ingredients for, and the function will return a table 
      of cocktails that you can make with similar ingredients. For example, if you input Old Fashioned, it will suggest a 'Champagne cocktail'
      as this has two matching ingredients. 
  2. cocktail_ingredient_match("Rye Whiskey", "Grapefruit juice"). The user provides a comma-separated list of ingredients that they have, and the 
      function will return a table of cocktails with one column of how many ingredients matched, and another that tells you how many ingredients are
      missing for each cocktail; the table is ordered so that the cocktail with the least amount of missing ingredients is at the top. For example, 
      if you provided Rye Whiskey and Grapefruit juice as your ingredients, the function will suggest the closest match is a Blinker or a Salty Dog...
      

Future possible edits: 
  - Specify which ingredients are missing 
  - Some flexibility with searching names/ingredients i.e. to prevent errors due to spelling or capitalisation etc. 
  - Making the tables pretty, possibly through including pictures of each cocktail in the data

Some limitations 
  - Only handles cocktails with 5 ingredients or less


Source for picture used for 'social media preview': Photo by <a href="https://unsplash.com/@off_the_paige?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Paige Ledford</a> on <a href="https://unsplash.com/s/photos/old-fashioned?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
  

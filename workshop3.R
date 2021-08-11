library(tidyverse)
library(tidymodels)
library(skimr)
library(janitor)

muffin_cupcake_data_original<-read.csv("https://raw.githubusercontent.com/adashofdata/muffin-cupcake/master/recipes_muffins_cupcakes.csv")

muffin_cupcake_data_original%>%skim()

#clean variable names
muffin_cupcake<-muffin_cupcake_data_original%>%
  clean_names()

# muffin_cupcake%>%count(type) - you have n= 10 cupcake & n= 10 muffin

#splitting the cleaned dataset into training vs testing - internal structure
muffin_cupcake_split<-initial_split(muffin_cupcake)
muffin_cupcake_split

#save training and testing datasets separately
muffin_cupcake_training<-training(muffin_cupcake_split)
muffin_cupcake_testing<-testing(muffin_cupcake_split)

#create a recipe
muffin_recipe<-recipe(type~flour+milk+sugar+egg,data = muffin_cupcake_training)
muffin_recipe


muffin_recipe_steps<-muffin_recipe%>%
  step_meanimpute(all_numeric())%>%
  step_center(all_numeric())%>%
  step_scale(all_numeric())


muffin_recipe_steps

#prep the recipe
prepped_recipe<-prep(muffin_recipe_steps,training=muffin_cupcake_training)
prepped_recipe


#bake
muffin_train_preprocessed<-bake(prepped_recipe,muffin_cupcake_training)

muffin_testing_preprocessed<-bake(prepped_recipe,muffin_cupcake_testing)

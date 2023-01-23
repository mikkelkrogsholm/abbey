library(plumber)
library(jinjar)
library(tidyverse)

source("functions/helpers.R")

# Config
config <- jinjar_config(loader = path_loader("templates"))

#* @apiTitle Plumber Example API

#* @assets ./static /static
list()

################################################################################
##############################       ROUTES       ##############################
################################################################################

# The INDEX page ###############################################################

#* Show index page
#* @get /
#* @serializer html
function(){

  template <- read_file("templates/index.html")

  template |>
    render(.config = config)
}

# The IRIS page ################################################################


# The MTCARS page ##############################################################


# The DIAMONDS page ############################################################


# The DATASETS page ###############################################################

#* Show index page
#* @get /datasets
#* @serializer html
function(){

  # Template
  template <- read_file("templates/datasets.html")

  # Data
  params <- list(dataframes = dataset_dataframes())

  # Render
  template |>
    render(!!!params, .config = config)
}

# The SINGLE DATASET page ######################################################

#* Show index page
#* @get /dataset/<dataset>
#* @serializer html
function(dataset){

  list_of_datasets <- dataset_dataframes()
  index <- which(str_to_lower(list_of_datasets) == dataset)
  dataset_name <- list_of_datasets[index]

  # Template
  template <- read_file("templates/dataset.html")

  # Data
  params <- list(title = dataset_name, tbl = create_table(dataset_name))

  # Render
  template |>
    render(!!!params, .config = config)
}





#* Plot ggplot png
#* @serializer contentType list(type='image/png')
#* @get /png
function(){

  plot <- ggplot(mtcars, aes(x=hp, y=mpg)) +
    geom_point(size=3, aes(color=cyl)) +
    geom_smooth(method="loess", color="black", se=FALSE) +
    geom_smooth(method="lm", aes(color=cyl, fill=cyl)) +
    theme_minimal()

  file <- paste0(tempfile(), ".png")

  h = 500
  w = h * 1.618

  ggsave(file, plot, width = w, height = h, units = "px", dpi = 72)

  readBin(file, "raw", n = file.info(file)$size)

}

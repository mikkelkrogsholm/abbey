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


#* Show Iris page
#* @get /iris
#* @serializer html
function(){

  tf <- tempfile(fileext = ".html")

  rmarkdown::render(input = "static/documents/iris.Rmd",
                    output_format = rmarkdown::html_fragment(),
                    output_file = tf)

  md2html <- read_file(tf)

  # Template
  template <- read_file("templates/iris.html")

  # Data
  params <- list(md2html = md2html)

  # Render
  template |>
    render(!!!params, .config = config)

}

# The MTCARS page ##############################################################

#* Show mtcars page
#* @get /mtcars
#* @serializer html
function(req){

  # Check url params
  qs <- shiny::parseQueryString(req$QUERY_STRING)

  g <- ggplot(mtcars_tbl)

  if(length(qs) != 0){
    if(qs$graphic == "scatter"){
      g <- g + geom_point(aes(wt, mpg))
    }

    if(qs$graphic == "bar"){
      g <- g + geom_bar(aes(x=cyl))
    }

    g <- g +
      labs(title = qs$title,
           subtitle = qs$subtitle) +
      theme_minimal()
  }

  encoded_graphic <- encode_graphic(g)

  # Define the plot types available
  graphics <- list(
    list(name = "Scatterplot", value = "scatter"),
    list(name = "Bar chart", value = "bar")
  )

  # Template
  template <- read_file("templates/mtcars.html")

  # Data
  params <- list(encoded_graphic = encoded_graphic, graphics = graphics)

  # Render
  template |>
    render(!!!params, .config = config)

}

# The DIAMONDS page ############################################################


# The DATASETS page ###############################################################

#* Show index page
#* @get /datasets
#* @serializer html
function(){

  # Template
  template <- read_file("templates/datasets.html")

  # Data
  params <- list(dataframes = get_names_of_datasets())

  # Render
  template |>
    render(!!!params, .config = config)
}

# The SINGLE DATASET page ######################################################

#* Show index page
#* @get /dataset/<dataset>
#* @serializer html
function(dataset){

  list_of_datasets <- get_names_of_datasets()
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

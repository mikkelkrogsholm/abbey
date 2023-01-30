library(kableExtra)
library(xml2)
library(tidyverse)
library(tsibble)

get_names_of_datasets <- function(){
  names_of_datasets <- ls("package:datasets")
  ok_classes <- c("matrix", "ts", "tibble", "data.frame")

  list_of_datasets <- map(names_of_datasets, function(x){
    data <- get(x)
    if(any(class(data) %in% ok_classes)){
      return(x)
    } else {
      return(NULL)
    }
  }) %>%
    compact() %>%
    unlist(use.names = F)

  list_of_datasets
}

create_table <- function(dataset_name){

  mytbl <- get(dataset_name)

  if(any(class(mytbl) %in% "matrix")){
    mytbl <- tibble(rownames = row.names(mytbl), as_tibble(mytbl))
  }

  if(any(class(mytbl) %in% "ts")){
    mytbl <- mytbl %>% as_tsibble()
  }

  if(any(class(mytbl) %in% "data.frame")){
    mytbl <- mytbl %>% as_tibble()
  }

  tbl_xml <- mytbl %>%
    kbl() %>%
    kable_as_xml()

  tbl_xml %>%
    xml_set_attrs(c(id = "mytable", class="display", style="width:100%"))

  tbl_out <- tbl_xml %>%
    xml_as_kable() %>%
    as.character()

  tbl_out
}


encode_graphic <- function(g) {
  png(tf1 <- tempfile(fileext = ".png"))  # Get an unused filename in the session's temporary directory, and open that file for .png structured output.
  print(g)  # Output a graphic to the file
  dev.off()  # Close the file.
  txt <- RCurl::base64Encode(readBin(tf1, "raw", file.info(tf1)[1, "size"]), "txt")  # Convert the graphic image to a base 64 encoded string.
  # my_image <- htmltools::HTML(sprintf('<img src="data:image/png;base64,%s">', txt))  # Save the image as a markdown-friendly html object.
  my_image <- glue::glue("data:image/png;base64,{txt}")
  return(my_image)
}

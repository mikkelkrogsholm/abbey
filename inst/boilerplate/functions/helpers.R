library(kableExtra)
library(xml2)
library(tidyverse)

dataset_dataframes <- function(){
  list_of_datasets <- ls("package:datasets")

  list_of_dataframes <- map(list_of_datasets, function(x){
    data <- get(x)
    if(is.data.frame(data)){
      return(x)
    } else {
      return(NULL)
    }
  }) %>%
    compact() %>%
    unlist(use.names = F)

  list_of_dataframes
}

create_table <- function(dataset_name){

  mytbl <- get(dataset_name) %>%
    as_tibble()

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

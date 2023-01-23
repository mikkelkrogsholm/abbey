library(stringr)

dir = "/my_code"

boilerplate <- function(dir, override = FALSE){

  if(!override){
    if(dir.exists(dir)){
      continue = warning_and_promt(glue::glue("You have asked me to place the boilercode in {dir}. Is this correct? "))

      # Create the directory
      dir.create(dir)
    }
  }

  # Creat




  return(NULL)
}

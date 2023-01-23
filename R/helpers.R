#' Display a warning message and prompt for user input
#'
#' @param msg The warning message to display. Default is "This is a warning"
#' @return A logical value indicating whether to continue (TRUE) or stop (FALSE) the code
#' @examples
#' warning_and_promt("This is a critical warning.")
warning_and_promt <- function(msg = "This is a warning"){
  message(msg)
  while(TRUE){
    response <- suppressWarnings(as.numeric(readline(prompt = "Enter 1 to continue or 0 to stop: ")))
    if(is.na(response)){
      print("Invalid input. Please enter either 1 or 0.")
    }
    else if (response == 1) {
      #code to continue
      print("Continuing with the code...")
      return(TRUE)
    } else if (response == 0) {
      #code to stop
      print("Stopping the code...")
      return(FALSE)
    }
  }
}

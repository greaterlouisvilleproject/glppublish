#' @export
glp_start_publish <- function() {
  repo_path <- path.expand(paste(Sys.getenv(c("APPDATA")), "\\glp-downloadable", sep = ""))

  if(!file.exists(repo_path)){
    #mkdir(repo_path)
    system2("git", paste("-C \"", Sys.getenv(c("APPDATA")), "\" clone https://github.com/greaterlouisvilleproject/glp-downloadable.git", sep = ""))
  }
  else
  {
    system2("git", paste("-C \"", repo_path, "\" pull", sep = ""))
  }
}

#' @export
glp_publish_file <- function(file) {
  Sys.setenv(HOME = Sys.getenv("UserProfile"))
  repo_path <- path.expand(paste(Sys.getenv(c("APPDATA")), "\\glp-downloadable", sep = ""))

  file.copy(path.expand(file),paste(repo_path, "\\", basename(file), sep = ""))

  system2("git", paste("-C \"", repo_path, "\" add \"", basename(file), "\"",sep = ""))
  system2("git", paste("-C \"", repo_path, "\" commit -m \"", basename(file) ,"\"", sep = ""))
}

#' @export
glp_end_publish <- function() {
  repo_path <- path.expand(paste(Sys.getenv(c("APPDATA")), "\\glp-downloadable", sep = ""))
  system2("git", paste("-C \"", repo_path, "\" push", sep = ""))
}

#This function publishes one file.
#For performance reasons, if you want to publish multiple files, first call glp_start_publish,
# and then call glp_publish_file with each file you want to publish,
# and finish with glp_end_publish to push all the files to the repo at once.
#' @export
glp_publish <- function(file) {
  glp_start_publish()
  glp_publish_file(file)
  glp_end_publish()
}

#' @export
glp_export_xls <- function(data_tbl, doc_tbl, dest_file){
  write.xlsx(data_tbl,dest_file,sheetName="Data")
  wb <- loadWorkbook(dest_file)
  addWorksheet(wb,"Documentation")
  writeData(wb,2,doc_tbl)
  saveWorkbook(wb,dest_file,overwrite = TRUE)
}


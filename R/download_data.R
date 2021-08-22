download_data <- function(url, data_file){
    
    # check if data have been downloaded
    download_trigger <- !file.exists(data_file)
    
    # download data
    if (download_trigger) {
        
        download.file(
            url = url,
            destfile = data_file,
            mode = "wb"
        )
        
        data_time_stamp <- file.info(data_file)$ctime
        print(paste("Data were created by download on", data_time_stamp,"."))
        
    } else {
        
        data_time_stamp <- file.info(data_file)$ctime
        print(paste("Data have been already downloaded on", data_time_stamp,"."))
    }
    
    return(data_file)
}

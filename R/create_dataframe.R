create_dataframe <- function(min = 0, max = 1, step = 0.1) {
  
  df <- data.frame(x = 0, y = 0, z = 0)
  
  x <- y <- seq(min, max, step)

  for (i in 1 : length(x)) {
    
    tmp <- data.frame(x = rep(x[i], length(y)), y = y, z = 0)
    
    df <- rbind(df, tmp)
    
  }
  
  df <- df[-1, ]
  
  return(df)
  
}

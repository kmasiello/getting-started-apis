library(plumber)

#* @apiTitle Coin Toss API

#* Toss a coin once and give the result
#* @get /coin_toss
  
  function() {
    sample(c("heads", "tails"), 1, 
           prob = c(0.5, 0.5), replace = TRUE)
  }

#* Toss a coin multiple times and summarize output
#* @param n the number of times to toss the coin
#* @get /multi_toss
  
  function(n) {
    as.data.frame(
      table(sample(c("heads", "tails"), n, 
                   prob = c(0.5, 0.5), replace = TRUE)))
  }
# simple coin toss
sample(c("heads", "tails"), 1, prob = c(0.5, 0.5), replace = TRUE)



# Function 1: toss once and give me a heads or tails output 

coin_toss <- function() {
  sample(c("heads", "tails"), 1, prob = c(0.5, 0.5), replace = TRUE)
}

# Function 2: toss multiple times and summarize output

multi_toss <- function(n) {
  table(sample(c("heads", "tails"), n, prob = c(0.5, 0.5), replace = TRUE))
}


coin_toss()
multi_toss(100)


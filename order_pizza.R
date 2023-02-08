# Pizza Store
orderpizza <- function() {
  print(" Welcome to pizza hut, the best pizza in the world ")
  a <- readline(" What's your name?: ")
  print(paste(" Hello ",a, " ! "))
  
  
  print(" Please press the button for your orders ")
  
  print(" Crazy Bacon please press 1 ") 
  print(" Hawaiian please press 2 ") 
  print(" Pepperoni please press 3 ")
  print(" Seafood Extreme please press 4 ") 
  print(" Bacon & Hokkaido Cheese please press 5 ")
  
  #  loop ---------------------------------------------------------------------------
  
  count1 <- 0
  while (count1 < 100){ 
    c <- readline(" Choose a pizza: ")
    count1 <- count1 + 1
    
    
    if(c == 4){
      print(" Seafood is out of stock, please select others pizza ")
    } else { 
      
      print(" size S please press 1 ") 
      print(" size M please press 2 ") 
      print(" size L please press 3 ")
      break
      
    }}
  d <- readline(" Select your size: ")
  
  
  # end loop -----------------------------------------------------------------------
  
  
  print(" Pan Crust – Original please press 1 ") 
  print(" Thin & Crispy Crust please press 2 ")
  
  e <- readline(" Select your crust: ")
  
  
  f <- readline(" Select your Pcs: ")
  
  
  
  h <- paste( ifelse(c == 1, " Crazy Bacon ",
              ifelse(c == 2, " Hawaiian ",
              ifelse(c == 3, " Pepperoni ",
              ifelse(c == 4, " Seafood Extreme ",
              ifelse(c == 5, " Bacon & Hokkaido Cheese "))))))
  
  i <- paste( ifelse(d == 1, " S ",
              ifelse(d == 2, " M ",
              ifelse(d == 3, " L "))))
  
  j <- paste( ifelse(e == 1, " Pan Crust – Original ",
              ifelse(e == 2, " Thin & Crispy Crust ")))
  
  
  ff <- as.numeric(f)
  
  k <- paste(" pcs: ", f)
  
  # summary
  
  l <- paste( ifelse(c == 1, 339*ff,
              ifelse(c == 2, 339*ff,
              ifelse(c == 3, 339*ff,
              ifelse(c == 4, 449*ff,
              ifelse(c == 5, 379*ff))))))
  
  
  
  p <- paste(ifelse(c == 1, 339,
             ifelse(c == 2, 339,
             ifelse(c == 3, 339,
             ifelse(c == 4, 449,
             ifelse(c == 5, 379))))))
  
  pp <- as.numeric(p)
  
  customer_name <- c(a)
  pizza <- c(h)
  size <- c(i)
  crust <- c(j)
  pcs <- c(f)
  price <- c(p)
  total <- c(pp*ff)
  df <- data.frame(customer_name,
                   pizza,
                   size,
                   crust,
                   pcs,
                   price,
                   total)
  print(" Thank you for your orders, enjoy eating! ")
  View(df)                                  
}

# Particle Settling velocity calculator following Dietrich 1982.
# Andrew J. Moodie
# andrewjmoodie.com
# GPL Copyleft, 2015

compute_w_a <- function(D_a, CSF){
    w_a <- rep(NA,length(D_a))
    w_a[D_a <= 0.05] <- 1.71e-4*(D_a[D_a <= 0.05]^2) # use stokes for D_a <= 0.05
    w_a[D_a >  0.05] <- compute_DSV(D_a[D_a > 0.05], CSF) # use dietrich for D_a > 0.05
    w_a[D_a > 5e9] <- NA # invalid for D_a > 5e9, no consideration to turbulent effects
    if(CSF <= 0.15){
        w_a <- rep(NA, length(D_a))
        print("solution invalid for CSF <= 0.15")
    }
    return(w_a)
}

compute_DSV <- function(D_a, CSF){
    R_1 <- (-3.76715) + (1.92944 * (log(D_a))) - (0.09815 * (log(D_a))^(2.0)) - (0.00575 * (log(D_a))^(3.0)) + (0.00056 * (log(D_a))^(4.0))
    R_2 <- (log(1 - ((1 - CSF) / 0.85))) - (((1 - CSF)^(2.3)) * tanh(log(D_a) - 4.6)) + (0.3 * (0.5 - CSF) * ((1 - CSF)^(2.0)) * (log(D_a) - 4.6))
    R_3 <- (0.65 - ((CSF / 2.83) * tanh(log(D_a) - 4.6)))^(1 + (3.5 - Pow)/2.5) # need to get form of the exponent!!
    w_a <- R_3 * (10 ^ (R_1 + R_2))
    return(w_a)    
}

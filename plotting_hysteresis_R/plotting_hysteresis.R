# Andrew J. Moodie
# Plotting river hysteresis in R
# data file available on andrewjmoodie.com

data <- read.csv("/home/andrew/Documents/Personal_Projects/blog/hysteresis/hysteresis_data.csv",header=TRUE)
df <- data.frame(data)

#### data ####
par(mfrow=c(1,2))
plot(1:10, 1:10,
        type="n",
        log="",
        xlab=expression(Time),
        ylab=expression(Discharges ~ (m^3/s)),
        xlim=c(0,400),
        ylim=c(1,2200),
        main="Discharge data"
        )
abline(h=740,
        col="darkgreen",
        lwd=2,
        lty=2
        )
lines(1:366,df[1:366,"Qw"],
        lwd=2,
        col="blue"
        )
lines(1:366,df[1:366,"Qs"],
        lwd=2,
        col="red"
        )
points(c(188,279), c(df[188,"Qw"],df[279,"Qw"]),
       pch=21,
       col="darkgreen",
       bg="darkgreen"
)

#### hysteresis ####
plot(1:10, 1:10,
         type="n",
         xlab=expression(Water ~ Discharge ~ (m^3/s)),
         ylab=expression(Sediment ~ Discharge ~ (m^3/s)),
         xlim=c(0,2200),
         ylim=c(0,50),
         main="Hysteresis plot"
         )
abline(v=740,
        col="darkgreen",
        lwd=2,
        lty=2
        )
lines(df[1:366,"Qw"],df[1:366,"Qs"],
        lwd=2,
        )
s <- seq(from=1, to=length(df[,"Qw"])-1, by=22)
arrows(df[,"Qw"][s], df[,"Qs"][s], df[,"Qw"][s+1], df[,"Qs"][s+1], 
        length=0.1,
        code=2,
        lwd=2
        )
points(c(df[188,"Qw"],df[279,"Qw"]), c(df[188,"Qs"],df[279,"Qs"]),
       pch=21,
       col="darkgreen",
       bg="darkgreen"
       )

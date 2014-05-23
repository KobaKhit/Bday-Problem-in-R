#Birthday Problem Simulation in R
#Author: Koba Khitlaishvili
#Date:05/14/2014

#----------Functions--------------------------------------------
# bdayProbs() function
#   
#   @parameters
#     -numberOfPeople - number of people(birthdays) in a group. The probability 
#      of at least one 
#      shared birthday in the group is calculated for groups of all sizes up 
#      untill this parameter. 
#     -numberOfTrials - number of times(trials) birthdays are randomly drawn for 
#      a group of size numberOfPeople.
bdayProbs<-function(numberOfPeople=60,numberOfTrials=25){
  prob<-vector() #shared birthday probabilities 
  N<-vector() #Number of people in a group
  for(k in 1:numberOfPeople){
    sameB<-0 #count of trials in which the group had at least one shared birthday 
    for(i in 1:numberOfTrials){
      id<-1:k #group member's id
      
      #Data fram
      df<-data.frame(id,month=round(runif(k,1,12)),day=2)
      
      #For months with 30 days randomly pick a day from 30 possible options
      month30<-df$month %in% c(4,6,9,11)
      df[month30,]$day<-round(runif(sum(month30),1,30))
      
      #For months with 31 days randomly pick a day from 31 possible options
      month31<-!(df$month %in% c(4,6,9,11))
      df[month31,]$day<-round(runif(sum(month31),1,31))
      
      #For February with 28 days randomly pick a day from 28 possible options
      feb<-df$month==2
      df[feb,]$day<-round(runif(sum(feb),1,28))
      
      #Increase sameB if during the trial the group had at least one shared birthday
      if(sum(duplicated(df[,2:3]))>0) {
        sameB<-sameB+1
      }   
    }
    #sameB/i is the fraction of groups per i trials that had at least one shared birthday,
    #i.e. probability of a shared birthday in a group of n people.
    prob<-append(prob,sameB/i)
    #N is the vector of group sizes that corresponds to the vector of probabilities of
    #a shared birthday 
    N<-append(N,k) 
  }
  return(data.frame(N=N,SharedBdayProb=prob))
}
#-----------------------------------------------------------------

#-----------Simulation--------------------------------------------

#Create a dataframe with shared birthday probabilities for groups of all sizes 
#up to 70 using 25,100, and 1000 trials
birthdayProbs<-data.frame(`25trials`=bdayProbs(70,25)[,"SharedBdayProb"],
                      `100trials`=bdayProbs(70,100)[,"SharedBdayProb"],
                      `1000trials`=bdayProbs(70,1000)[,"SharedBdayProb"])

#Add theoretical probabilities computed in Mathematica for groups of all sizes up to 95 people
theory<-read.csv("Mathematica/BDprobsTheory.csv",header=FALSE,sep=",")
birthdayProbs<-data.frame(birthdayProbs,theory=theory[1:nrow(birthdayProbs),])

#Plot the theoretical bday probs
with(birthdayProbs,
{
  plot(theory,
       pch=16,
       col="red",
       main="Birthday Problem",
       xlab="Number of people",
       ylab="Probability of at least one shared birthday")
  abline(h=0.5,v=23,lty=2)
})
#Save the plot to a png file
dir.create("R output")
dev.copy(png,"R output/TheoryBdayProbs.png",units="px",height=530,width=530)
dev.off()

#Plot the theoretical shared birthday probabilities and probabilities for 25,100, 1000 trials
with(birthdayProbs,
{
  plot(theory,
      pch=16,
      col="red",
      main="Birthday Problem",
      xlab="Number of people",
      ylab="Probability of at least one shared birthday")
 lines(X25trials,lwd=2,col="blue")
 lines(X100trials,lwd=2,col="green")
 lines(X1000trials,lwd=2)
 abline(h=0.5,v=23,lty=2)
 legend("bottomright",c("25 Trials","100 Trials","1000 Trials","theory"),
        col=c("blue","green","black","red"),
        lty=c(1,1,1,NA),
        pch=c(NA,NA,NA,16),
        lwd=2,
        cex=0.8)
 })

#Save the plot to a png file
dev.copy(png,"R output/SharedBdayProbs.png",units="px",height=530,width=530)
dev.off()

#Calculate the mean error by the number of trial s
k<-100 #number of trials
n<-60 #number of people in a group
error<-vector()
for(i in 1:k){
  #Difference between theoretical probability and simulated probability of a 
  #shared birthday in a group of sixty people
  error<-append(error,mean(na.omit(birthdayProbs[1:nrow(bdayProbs(n,i)),]$theory-bdayProbs(n,i)[,2])))
  print(c(i,"/",k),quote=FALSE)
}
rm(k,n)

#Plot the error
plot(error,
     pch=20,
     main="Mean error by number of trials for a group of 60 people",
     xlab="Number of trials",
     ylab="Mean error,%")
abline(h=0)

#Save the plot to a png file
dev.copy(png,"R output/Error.png",units="px",height=500,width=580)
dev.off()


#Write the theoretical shared birthday probabilities and probabilities for 25,100, 1000 trials
#to a csv file in the output folder
write.csv(birthdayProbs,"R output/birthdayProbs.csv")

#Write the error by number of trials for a group of n people
#to a csv file in the output folder
write.csv(error,"R output/error.csv")

#Birthday problem simulation in R
This is a project in which I run a simulation of the [birthday problem](http://en.wikipedia.org/wiki/Birthday_problem).

##Brithday problem
> What is the probability that in a set of n randomly chosen people at least two will have the same birthday? 

According to theory, the probability will be approximately 1 for a group of sixty people. A formula used to calculate the theoretical probabilities is 
![theory bdayprobs](http://latex.codecogs.com/gif.latex?p%28n%29%3D1-%5Cfrac%7B365%21%7D%7B365%5En%28365-n%29%21%7D)
where p(n) is the probability that at least two people share the same birthday in a group of n people. Below is the graph of theoritical probabilities against the number of people in a group.
![theoryprobs](https://raw.githubusercontent.com/KobaKhit/Bday-Problem-in-R/master/R%20output/TheoryBdayProbs.png)
The horizontal dashed line is drawn at a point 0.5 and the vertical dashed line is drawn at a point 23. In other words, the theoretical probability of a shared birthday in a group of 23 people is approximately 0.5 or 50%. 

I calculated the theoretical probabilities in Mathematica. The Mathematica notebook and the csv file with theoritical probabilities are in the `Mathematica` folder.

##Simulation
I run the simulation and analysis in `bdayProblem.R`. 

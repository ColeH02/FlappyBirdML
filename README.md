# Machine Learning Using NIT
### Process:
-Evaluate the fitness of an individual bird (calculated based on time alive and pipes passed) \
-Choose parents for reproduction, this is done somewhat randomly with bias towards better performing birds to be chosen as parents \
-Create offspring via crossover as well as gene mutations, this is accomplished by mutating weights, adding connections, or very rarely, adding new nodes to the child's brain. \
-Seperate the birds into species based on similarity to one another, if a bird is created such that its brain is too different from the others, a new species will be created \
-Lastly, natural selection, every generation kills off the bottom half of the population, as well as any species which have not improved in 15 generations.

### Performance:
-By utilizing this process on a population of 100 birds, it takes on average 6 generations for a bird to be created with a brain capable of playing flappy bird for an indefinte amount of time \

### The Brains:
-The brain of each bird is a neural network of nodes and weighted connections \n
-The neural network takes in an array of inputs defined as what a player can see (distance to next pipe, distance to the top pipe, distance to the bottom pipe, and the current velocity)
-The nueral network outputs an array which represents the actions a player is able to take. In the case of flappy bird the only action is to flap so the output is one value

### Running The Program:
-This program is written in Processing which is a sketchbook language utilzing Java that promotes visual arts. 
-To start download Processing  [here](https://processing.org/download "here")
-Then just click run and watch the birds learn generation to generation

![](https://cdn.discordapp.com/attachments/815292647715504140/907857848476786729/unknown.png)

![](https://cdn.discordapp.com/attachments/815292647715504140/907858923774705664/unknown.png)

class Species{
  ArrayList<Bird> players = new ArrayList<>();
  float bestFitness = 0;
  Bird champion;
  float avgFitness = 0;
  int staleness = 0;
  NeuralNet rep;
  
  float excessCoeff = 1;
  float weightedDiff = 0.5;
  float compatibilityThreshold = 3;
  Bird parent1;
  Bird parent2;
  
  Species(Bird p, boolean ignoreP){
    if(ignoreP){
      players.add(p);
      bestFitness = p.fitness;
      rep = p.brain.clone();
      champion = p.cloneForReplay();
    }
  }
  
  boolean sameSpecies(NeuralNet g){
    float compatibility;
    float excessAndDisjoint = getExcessDisjoint(g, rep);
    float avgWeightDiff = averageWeightDiff(g, rep);
    
    float largeGenomeNormalizer = g.genes.size() - 20;
    if(largeGenomeNormalizer < 1){
      largeGenomeNormalizer = 1;
    }
    
    compatibility = (this.excessCoeff * excessAndDisjoint / largeGenomeNormalizer) + (weightedDiff * avgWeightDiff);
    return (this.compatibilityThreshold > compatibility);
  
  }
  
  float getExcessDisjoint(NeuralNet brain1, NeuralNet brain2){
    float matching = 0.0;
    for(int i = 0; i < brain1.genes.size(); i++){
      for(int j = 0; j < brain2.genes.size(); j++){
        if(brain1.genes.get(i).inno == brain2.genes.get(j).inno){
          matching ++;
          break;
        }
      }
    }
    return (brain1.genes.size() + brain2.genes.size() - 2*(matching)); //returns number of disjoint and excess genes
  }
  
  float averageWeightDiff(NeuralNet brain1, NeuralNet brain2){
    if(brain1.genes.size() == 0 || brain2.genes.size() == 0){
      return 0;
    }
    
    float matching = 0;
    float totalDiff = 0;
    for(int i = 0; i < brain1.genes.size(); i++){
      for(int j = 0; j < brain2.genes.size(); j++){
        if(brain1.genes.get(i).inno == brain2.genes.get(j).inno){
          matching ++;
          totalDiff += abs(brain1.genes.get(i).weight - brain2.genes.get(j).weight);
          break;
        }
      }
    }
    if(matching == 0){
      return 100;
    }
    return totalDiff/matching;
  }
  
  void addToSpecies(Bird p){
    players.add(p);
  }
  
  void sortSpecies(){
    ArrayList<Bird> temp = new ArrayList<>();

    for(int i = 0; i < players.size(); i++){
      float max = 0;
      int maxIndex = 0;
      
      for(int j = 0; j < players.size(); j++){
        if(this.players.get(j).fitness > max){
          max = players.get(j).fitness;
          maxIndex = j;
        }
      }
      temp.add(players.get(maxIndex));
      players.remove(maxIndex);
      i--;
    }
    players = (ArrayList)temp.clone();
    if(players.size() == 0){
      staleness = 200;
      return;
    }
    if(players.get(0).fitness > bestFitness){
      staleness = 0;
      bestFitness = players.get(0).fitness;
      rep = players.get(0).brain.clone();
      champion = players.get(0).cloneForReplay();
    }else{
      staleness++;
    }
    
  }
  
  void setAverage(){
    float sum = 0;
    for(int i = 0; i < players.size(); i++){
      sum += players.get(i).fitness;
    }
    avgFitness = sum/players.size();
  }
  
  Bird getBaby(ArrayList<connectionHistory> innovationHistory){
    Bird baby;
    if(random(1) < 0.25){
      baby = selectPlayer().clone();
    }
    else{
      parent1 = selectPlayer();
      parent2 = selectPlayer();
      if(parent1.fitness < parent2.fitness){
        baby = parent2.crossover(parent1);
      }
      else{
        baby = parent1.crossover(parent2);
      }
    }
    
    baby.brain.mutate(innovationHistory);
    return baby;
  }
  
  
  Bird selectPlayer(){
    float fitnessSum = 0.0;
    for(int i = 0; i < players.size(); i++){
      fitnessSum += players.get(i).fitness;
    }
    float rand = random(fitnessSum);
    float runningSum = 0;
    
    for(int i = 0; i < players.size(); i++){
      runningSum += players.get(i).fitness;
      if(runningSum > rand){
        return players.get(i);
      }
    }
    //unreachable
    return players.get(0);
  }
  
  void cull(){
    if(players.size() > 2){
      for(int i = players.size()/2; i < players.size(); i++){
        players.remove(i);
        i--;
      }
    }
  }
  
  void fitnessSharing(){
    for(int i = 0; i < players.size(); i++){
      players.get(i).fitness /= players.size();
    }
  }


}

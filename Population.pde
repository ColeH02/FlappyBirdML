class Population{
  ArrayList<Bird> population = new ArrayList<>();
  Bird bestPlayer;
  float bestScore = 0;
  float globalBestScore;
  int gen;
  ArrayList<connectionHistory> innovationHistory = new ArrayList<>();
  ArrayList<Bird> genPopulation = new ArrayList<>();
  ArrayList<Species> species = new ArrayList<>();
  
  int ELIMINATIONCONSTANT = 15;
  
  boolean massExtinctionEvent;
  boolean newStage;
  int genSinceNewWorld;
  int populationLife = 0;
  Population(int popSize){
    for(int i = 0; i < popSize; i++){
      population.add(new Bird());
      population.get(i).brain.generateNetwork();
      population.get(i).brain.mutate(innovationHistory);
    }
    
  }
  boolean allDead(){
    for(int i = 0; i < population.size(); i++){
      if(population.get(i).dead == false){
        return false;
      }
    }
    return true;
  }
  
  int getPopSize(){
    return population.size();
  }
  
  Bird getCurrentBest(){
    for(int i = 0; i < population.size(); i++){
      if(!population.get(i).dead){
        return population.get(i);
      }
    }
    return population.get(0);
  }
  
  void updateAlive(){
    boolean firstShown = false;
    for(int i = 0; i < population.size(); i++){
      if(!population.get(i).dead){
        for(int j = 0; j < superSpeed; j++){
          population.get(i).look();
          population.get(i).think();
          population.get(i).update();
          
        }
        if(!showNothing && (!showBest  || !firstShown)){
          population.get(i).show();
          firstShown = true;
        }
        if(population.get(i).score > globalBestScore){
          globalBestScore = population.get(i).score;
        }
      }
    }
  
  }
  
  void setBestPlayer(){
    Bird tempBest = species.get(0).players.get(0);
    tempBest.gen = gen;
    
    if(tempBest.score >= bestScore){
      genPopulation.add(tempBest.cloneForReplay());
      System.out.println("old best: " + bestScore);
      System.out.println("new best: " + tempBest.score);
      bestScore = tempBest.score;
      bestPlayer = tempBest.cloneForReplay();
    }  
  }
  
  void naturalSelection(){
    Bird previousBest = population.get(0);
    speciate();
    calculateFitness();
    sortSpecies();
    
    if(massExtinctionEvent){
      massExtinction();
      massExtinctionEvent = false;
    }
    
    cullSpecies();
    setBestPlayer();
    killStaleSpecies();
    killBadSpecies();
    
    System.out.println("generation: " + this.gen + " Number of mutations: " + this.innovationHistory.size() + " species: " + this.species.size() + "");
    
    float averageSum = getAvgFitnessSum();
    ArrayList<Bird> children = new ArrayList<>();
    for(int j = 0; j < species.size(); j++){
      children.add(species.get(j).champion.clone());
      int NoOfChildren = floor(species.get(j).avgFitness/averageSum * population.size()) -1;
      for(int i = 0; i < NoOfChildren; i++){
        children.add(species.get(j).getBaby(innovationHistory));
      }
    }
    
    if(children.size() < population.size()){
      children.add(previousBest);
    }
    
    while(children.size() < population.size()){
      children.add(species.get(0).getBaby(this.innovationHistory));
    }
    population.clear();
    population = (ArrayList)children.clone();
    gen++;
    for(int i = 0; i < population.size(); i++){
      population.get(i).brain.generateNetwork();
    }
    
  }
  
  void speciate(){
    for(Species s: species){
      s.players.clear();
    }
    for(int i = 0; i < population.size(); i++){
      boolean speciesFound = false;
      for(Species s: species){
        if(s.sameSpecies(population.get(i).brain)){
          s.addToSpecies(population.get(i));
          speciesFound = true;
          break;
        }
      }
      if(!speciesFound){ 
        species.add(new Species(population.get(i), true));
      }
    }
  }
  
  void calculateFitness(){
    for(int i = 0; i < population.size(); i++){
      population.get(i).calculateFitness();
    }
  }
  
  void sortSpecies(){
    for (Species s : species) {
      s.sortSpecies();
    }

    //sort the species by the fitness of its best player
    ArrayList<Species> temp = new ArrayList<Species>();
    for (int i = 0; i < species.size(); i ++) {
      float max = 0;
      int maxIndex = 0;
      for (int j = 0; j< species.size(); j++) {
        if (species.get(j).bestFitness > max) {
          max = species.get(j).bestFitness;
          maxIndex = j;
        }
      }
      temp.add(species.get(maxIndex));
      species.remove(maxIndex);
      i--;
    }
    species = (ArrayList)temp.clone();
  }
  
  void killStaleSpecies(){
    for(int i = 2; i < species.size(); i++){
      if(species.get(i).staleness >= ELIMINATIONCONSTANT){
        species.remove(i);
        i--;
      }
    }
  }
  
  void killBadSpecies(){
    float avgSum = getAvgFitnessSum();
    for(int i = 1; i < species.size(); i++){
      if(species.get(i).avgFitness/avgSum * population.size() < 1){
        species.remove(i);
        i--;
      }
    }
  }
  
  float getAvgFitnessSum(){
    float avgSum = 0;
    for(Species s : species){
      avgSum += s.avgFitness;
    }
    return avgSum;
  }
  
  void cullSpecies(){
    for(Species s : species){
      s.cull();
      s.fitnessSharing();
      s.setAverage();
    }
  }
  
  void massExtinction(){
    for(int i = 5; i < species.size(); i++){
      this.species.remove(i);
      i--;
    }
  }

}

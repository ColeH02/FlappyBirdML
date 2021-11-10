class Bird {
  boolean dead = false;
  boolean falling = true;
  float posY = height/2;
  float posX = height/3;
  int w = bird.width;
  int h = bird.height;
  double velY = 0;
  float gravity = 1;
  float fitness = 0.0;
  float lifespan = 0;
  float score = 0;
  double bestScore;
  int gen;
  float fallRotation = -PI/6;
  ArrayList<Float> vision = new ArrayList<>();
  ArrayList<Float> decision = new ArrayList<>();
  ArrayList<connectionHistory> innovationHistory = new ArrayList<>();
  PipePairs closestPipe;
  int pipeRandomNo;
  
  PipePairs pipes1;
  PipePairs pipes2;
  
  
  
  
  int genomeInputs = 4;
  int genomeOutputs = 1;
  
  NeuralNet brain = new NeuralNet(genomeInputs, genomeOutputs, false);
  Bird(){
    pipeRandomNo = 0;
    pipes1 = new PipePairs(true);
    pipes2 = new PipePairs(false, pipes1, pipeRandomNo);
    closestPipe = pipes1;
    pipes2.setX((int)pipes1.bottomPipe.posX + 400);
    pipeRandomNo++;
  }
  
  void show(){
    pipes1.show();
    pipes2.show();
    if(!dead){
      fill(0,0,0);
      imageMode(CENTER);
      image(bird, posX, posY, w, h);
      if(velY < 10){
        pushMatrix();
        translate(posX, posY);
        rotate((-PI/6));
        image(bird, 0, 0);
        popMatrix();
        imageMode(CORNER);
      }else{
        pushMatrix();
        translate(posX, posY);
        rotate((PI/6));
        image(bird, 0, 0);
        popMatrix();
        imageMode(CORNER);
      }
      
    }
    
  }
  
  void move(){
     lifespan++;
     velY += gravity;
     posY += velY;
    
  }
  
  void updatePipes(){
    pipes1.update();
    pipes2.update();
    if(pipes1.offScreen()){
      pipes1 = new PipePairs(false, pipes2, pipeRandomNo);
      pipeRandomNo++;
    }
    if(pipes2.offScreen()){
      pipes2 = new PipePairs(false, pipes1, pipeRandomNo);
      pipeRandomNo++;
    }
  }
  
  void update(){
    move();
    updatePipes();
    if(pipes1.playerPassed(this)){
      closestPipe = pipes2;
      score++;
    }
    if(pipes2.playerPassed(this)){
      closestPipe = pipes1;
      score++;
    }
    checkCollisions();
  }
  
  void checkCollisions(){
    if(pipes1.collided(this)){
      dead = true;
    }
    if(pipes2.collided(this)){
      dead = true;
    }
  }
  
  void flap(){
    if(!dead){
      velY = -18;
    }
  
  }
  
  float getXpos(){
    return posX;
  }
  
  float getYpos(){
    return posY;
  }
  
  
  void look(){
    this.vision = new ArrayList<Float>();
    this.vision.add(map((float)this.velY, -18, 18, -1, 1));
    float distanceToClosestPipe = closestPipe.bottomPipe.posX - posX;
    this.vision.add(map(distanceToClosestPipe, 0, width-posX, 1, 0));
    this.vision.add(map(max(0.0, closestPipe.bottomPipe.topY - posY), 0, 700, 0, 1));
    this.vision.add(map(max(0.0, posY - closestPipe.topPipe.bottomY), 0, 700, 0, 1));
  }
  
  void think(){
    this.decision = this.brain.feedForward(this.vision);
    if(this.decision.get(0) > 0.6){
      flap();
    }
  }
  
  Bird cloneForReplay(){
    Bird clone = new Bird();
    clone.brain = this.brain.clone();
    clone.fitness = this.fitness;
    clone.brain.generateNetwork();
    clone.gen = this.gen;
    clone.bestScore = this.score;
    
    return clone;
  
  }
  
  Bird clone(){
    Bird clone  = new Bird();
    clone.brain = this.brain.clone();
    clone.fitness = this.fitness;
    clone.brain.generateNetwork();
    clone.gen = this.gen;
    clone.bestScore = this.score;
    return clone;
  }
  
  void calculateFitness(){
    this.fitness = 1 + pow(this.score, 2.0) + this.lifespan/20.0;
  }
  
  Bird crossover(Bird parent2){
    Bird child = new Bird();
    child.brain = this.brain.crossover(parent2.brain);
    child.brain.generateNetwork();
    return child;
  }
  




}

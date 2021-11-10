Population pop;
int superSpeed = 1;
boolean showNothing = false;
boolean showBest = false;
ArrayList<Integer> randomPipeHeights = new ArrayList<>();
PImage topPipe;
PImage bottomPipe;
PImage bird;
PImage backdrop;

int timeBetweenObs;

void setup(){
  size(600, 800);
  bird = loadImage("Sprites/birdSprite.png");
  backdrop = loadImage("Sprites/flappyBackdrop.png");
  frameRate(60);
  pop = new Population(100);
}

void draw(){
  background(255);
  image(backdrop, 0, 0, width, height);
  if(!pop.allDead()){
     pop.updateAlive();
  }else{
    pop.naturalSelection();
  }
  
  
}

void keyPressed(){
  pop.population.get(0).flap();
}

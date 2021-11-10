class PipePairs{
  int distanceBetweenObs = 340;
  Pipe bottomPipe;
  Pipe topPipe;
  //ArrayList<Integer> randomPipeHeights = new ArrayList<>(randomPipeHeights1);
  int num;
  int gap = 220;
  boolean passed = false;
  int topHeight;
  int bottomHeight;
  int upToRandNo;
  int minDistanceFromEdge = 50;
  int maxPipeDifference = 300;
  

  PipePairs(boolean firstPipe){
    if(firstPipe){
      topHeight = (height - 30)/2 - gap / 2;
      topPipe = new Pipe(true, topHeight);
      bottomHeight = height - topHeight - gap;
      bottomPipe = new Pipe(false, bottomHeight);
    }
    
  }
  PipePairs(boolean firstPipe, PipePairs previousPipe, int upToRandNo){
    if(firstPipe){
      topHeight = (height - 30)/2 - gap / 2;
      topPipe = new Pipe(true, topHeight);
    }else{
      if(randomPipeHeights.size()>= upToRandNo){
        randomPipeHeights.add(floor(random(minDistanceFromEdge, height - minDistanceFromEdge - 30 - this.gap)));
      }
      topHeight = randomPipeHeights.get(upToRandNo);
      while(abs(this.topHeight - previousPipe.topHeight) > maxPipeDifference){
        randomPipeHeights.add(upToRandNo, floor(random(minDistanceFromEdge, height - minDistanceFromEdge - 30 - this.gap)));
        topHeight = randomPipeHeights.get(upToRandNo);
      }
     
      topPipe = new Pipe(true, topHeight);
      
    }
    bottomHeight = height - topHeight - gap;
    bottomPipe = new Pipe(false, bottomHeight);
    setX(max(width + bottomPipe.w,(int)previousPipe.bottomPipe.posX + 300 + bottomPipe.w));
  }
  
  void show(){
    bottomPipe.show();
    topPipe.show();
  }
  void update(){
    topPipe.update();
    bottomPipe.update();
  }
  
  
  boolean offScreen(){
    if(bottomPipe.posX + bottomPipe.w < 0){
      return true;
    }
    return false;
  }
  
  boolean playerPassed(Bird p){
    if(!passed && p.posX > bottomPipe.posX + bottomPipe.w){
      passed = true;
      return true;
    }
    return false;
  }
  
  boolean collided(Bird p){
    return bottomPipe.colliding(p) || topPipe.colliding(p);
  }
  
  void setX(int x){
    topPipe.posX = x;
    bottomPipe.posX = x;
  }
  
  
}

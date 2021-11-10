import java.util.Random;
class Pipe {
  float posX = width;
  int w;
  int h;
  int type;
  int topY;
  int bottomY;
  boolean isTopPipe;
  
  Pipe(boolean isTop, int h1){
    h = h1;
    w = 100;
    isTopPipe = isTop;
    if(isTop){
      topY = 0;
      bottomY = h;
    }else{
      topY = height - h;
      bottomY = height;
    }
  }
  
  void show(){
    fill(36, 160, 21);
    /**
    rectMode(CENTER);
    if(isTopPipe){
      image(topPipe, posX, topY, w, h);
    }else{
      image(bottomPipe, posX, topY, w, h);
    }
    */
    rect(posX, topY, w, h);
  }
  void move(float speed){
    posX -= speed;
  }
  
  void update(){
    move(4);
    show();
  }
  
  
  boolean colliding(Bird p){
    if(p.posX + bird.width/2 >= posX && p.posX <= posX + w){
      if(!isTopPipe && p.posY + bird.height/2 >= topY){
        return true;
      }
      if(isTopPipe && p.posY - bird.height/2 <= bottomY){
        return true;
      }
    }
    return false;
  }


}

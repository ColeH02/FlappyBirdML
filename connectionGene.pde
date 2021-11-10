class connectionGene {
  Node from;
  Node to;
  float weight;
  int inno;
  boolean enabled = true;
  
  connectionGene(Node fromNode, Node toNode, float w, int innovationNumber){
    from = fromNode;
    to = toNode;
    weight = w;
    inno = innovationNumber;
  }
  
  //mutate the weight
  void mutateWeight(){
    float rand = random(1);
    //change the weight completely 10% of the time
    if(rand < 0.1){ 
       weight = random(-1, 1);
    }else{ //change the weight slightly
      weight += randomGaussian()/50;
      if(weight > 1){
         weight = 1;
      }
      if(weight < -1){
        weight = -1;
      }
    }
  }
  
  connectionGene clone(Node from, Node to){
    connectionGene clone = new connectionGene(from, to, weight, inno);
    clone.enabled = enabled;
    return clone;
  }


}

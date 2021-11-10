class Node {
  int number;
  float inputSum = 0;
  float outputValue = 0;
  ArrayList<connectionGene> outputConnections = new ArrayList<connectionGene>();
  int layer = 0;
  
  Node(int num){
    number = num;
  }
  
  void engage(){
    if(layer != 0){
      outputValue = sigmoid(inputSum);
    }
    for(int i = 0; i < outputConnections.size(); i++){
      if(outputConnections.get(i).enabled){
        outputConnections.get(i).to.inputSum += outputConnections.get(i).weight * outputValue;
      }
    }
  }
  
  boolean isConnected(Node node){
    //obv nodes in same layer cant be connected
    if(node.layer == layer){
      return false;
    }
    //check all nodes in other layers
    if(node.layer < layer){
      for(int i = 0; i < outputConnections.size(); i++){
        if(outputConnections.get(i).to == this){
          return true;
        }
      }
    } else{
      for(int i = 0; i < outputConnections.size(); i++){
        if(outputConnections.get(i).from == node){
          return true;
        }
      }
    }
    return false;
  }
  
  float sigmoid(float x){
    return 1/ (1 + pow((float)Math.E, -4.9*x));
  }
  
  Node clone(){
    Node clone = new Node(number);
    clone.layer = layer;
    return clone;
  }


}

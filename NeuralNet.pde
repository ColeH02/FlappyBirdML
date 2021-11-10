class NeuralNet {
  ArrayList<connectionGene> genes = new ArrayList<connectionGene>();
  ArrayList<connectionHistory> innovationHistory;
  ArrayList<Node> nodes = new ArrayList<Node>();
  ArrayList<Node> network  = new ArrayList<Node>();;
  int inputs;
  int outputs;
  int layers = 2;
  int nextNode = 0;
  int biasNode;
  
  NeuralNet(int in, int out, boolean crossover){
    inputs = in;
    outputs = out;
    
    if(crossover){
      return;
    }
    
    
    for(int i = 0; i < inputs; i++){
      nodes.add(new Node(i));
      nextNode++;
      nodes.get(i).layer = 0;
    }
    
    for(int i = 0; i < outputs; i++){
      nodes.add(new Node(i + inputs));
      this.nodes.get(i + this.inputs).layer = 1;
      nextNode++;
    }
    
    //bias node
    nodes.add(new Node(nextNode));
    biasNode = nextNode;
    nextNode++;
    nodes.get(biasNode).layer = 0;
    
  }
  
  void connectNodes(){
    for(int i = 0; i < nodes.size(); i++){
      nodes.get(i).outputConnections.clear();
    }
    
    for(int i = 0; i < genes.size(); i++){
      genes.get(i).from.outputConnections.add(genes.get(i));
    }
  }
  
  Node getNode(int num){
    for(int i = 0; i < nodes.size(); i++){
      if(nodes.get(i).number == num){
        return nodes.get(i);
      }
    }
    return null;
  }
  
  ArrayList<Float> feedForward(ArrayList<Float> inputValues){
    for(int i = 0; i < inputs; i++){
      nodes.get(i).outputValue = inputValues.get(i);
    }
    nodes.get(biasNode).outputValue = 1;
    
    //engage each node in the neural net
    for(int i = 0; i < network.size(); i++){
      network.get(i).engage();
    }
    
    ArrayList<Float> outs = new ArrayList<>();
    for(int i = 0; i < outputs; i++){
      double outval = nodes.get(inputs + i).outputValue;
      outs.add(i, (float)outval);
    }
    for(int i = 0; i < nodes.size(); i++){
      nodes.get(i).inputSum = 0;
    }
    return outs;
  }
  
  void generateNetwork(){
    connectNodes();
    network = new ArrayList<>();
    for(int i = 0; i < layers; i++){
      for(int j = 0; j < nodes.size(); j++){
        if(nodes.get(j).layer == i){
          network.add(this.nodes.get(j));
        }
      }
    }
  }
  
  void mutate(ArrayList<connectionHistory> innovationHistory){
    if(genes.size() == 0){
      addConnection(innovationHistory);
    }
    
    float rand1 = random(1);
    if(rand1 < 0.8){  
      for(int i = 0; i < genes.size(); i++){
        genes.get(i).mutateWeight();
      }
    }
    
    float rand2 = random(1);
    if(rand2 < 0.08){
      addConnection(innovationHistory);
    }
    
    float rand3 = random(1);
    if(rand3 < 0.02){
      addNode(innovationHistory);
    }
  
  }
  
  int getInnovationNumber(ArrayList<connectionHistory> innovationHistory, Node from, Node to){
    boolean isNew = true;
    int nextConnectionNo = 0;
    int connectionInnovationNumber = nextConnectionNo;
    for(int i = 0; i < innovationHistory.size(); i++){
      if(innovationHistory.get(i).matches(this, from, to)){
        isNew = false;
        connectionInnovationNumber = innovationHistory.get(i).inno;
        break;
      }
    }
    
    if(isNew){
      ArrayList<Integer> innoNumbers = new ArrayList<>();
      for(int i = 0; i < genes.size(); i++){
        innoNumbers.add(genes.get(i).inno);
      }
      
      innovationHistory.add(new connectionHistory(from.number, to.number, connectionInnovationNumber, innoNumbers));
      nextConnectionNo++;
    }
    return connectionInnovationNumber;
  }
  
  boolean fullyConnected(){
    int maxConnections = 0;
    int[] nodesInLayers = new int[layers];//array which stored the amount of nodes in each layer

    //populate array
    for (int i =0; i < nodes.size(); i++) {
      nodesInLayers[nodes.get(i).layer] +=1;
    }

    //for each layer the maximum amount of connections is the number in this layer * the number of nodes infront of it
    //so lets add the max for each layer together and then we will get the maximum amount of connections in the network
    for (int i = 0; i < layers-1; i++) {
      int nodesInFront = 0;
      for (int j = i+1; j < layers; j++) {//for each layer infront of this layer
        nodesInFront += nodesInLayers[j];//add up nodes
      }

      maxConnections += nodesInLayers[i] * nodesInFront;
    }

    if (maxConnections == genes.size()) {//if the number of connections is equal to the max number of connections possible then it is full
      return true;
    }
    return false;
  }
  
  void addNode(ArrayList<connectionHistory> innovationHistory){
    if(genes.size() == 0){
      addConnection(innovationHistory);
      return;
    }
    
    int randomConnection = floor(random(genes.size()));
    while(genes.get(randomConnection).from == nodes.get(biasNode) && genes.size() != 1){ //cant disconnect bias node!!
      randomConnection = floor(random(genes.size()));
    }
    
    genes.get(randomConnection).enabled = false;
    
    int newNodeNo = nextNode;
    nodes.add(new Node(newNodeNo));
    nextNode++;
    //add a new connection
    int connectionInnovationNumber = getInnovationNumber(innovationHistory, genes.get(randomConnection).from, getNode(newNodeNo));
    genes.add(new connectionGene(genes.get(randomConnection).from, getNode(newNodeNo), 1, connectionInnovationNumber));
    
    connectionInnovationNumber = getInnovationNumber(innovationHistory, getNode(newNodeNo), genes.get(randomConnection).to);
    genes.add(new connectionGene(getNode(newNodeNo), genes.get(randomConnection).to, genes.get(randomConnection).weight, connectionInnovationNumber));
    getNode(newNodeNo).layer = genes.get(randomConnection).from.layer + 1;
    
    connectionInnovationNumber = getInnovationNumber(innovationHistory, nodes.get(biasNode), getNode(newNodeNo));
    genes.add(new connectionGene(nodes.get(biasNode), getNode(newNodeNo), 0, connectionInnovationNumber));
    
    
    if(getNode(newNodeNo).layer == genes.get(randomConnection).to.layer){
      for(int i = 0; i < nodes.size() - 1; i++){//exclude newest node
        if(nodes.get(i).layer >= this.getNode(newNodeNo).layer){
          nodes.get(i).layer++;
        }
      }
      layers++;
    }
    connectNodes();
  }
  
  void addConnection(ArrayList<connectionHistory> innovationHistory){
    if(fullyConnected()){
      println("connection failed");
      return;
    }
    int randNode1 = floor(random(nodes.size()));
    int randNode2 = floor(random(nodes.size()));
    
    while(randomConnectionLol(randNode1, randNode2)){ //while these dont work
      //grab some new ones
      randNode1 = floor(random(nodes.size()));
      randNode2 = floor(random(nodes.size()));
    }
    int temp;
    if(nodes.get(randNode1).layer > nodes.get(randNode2).layer){
      //flip em
      temp = randNode2;
      randNode2 = randNode1;
      randNode1 = temp;
    }
    
    int connectionInnovationNumber = getInnovationNumber(innovationHistory, nodes.get(randNode1), nodes.get(randNode2));
    genes.add(new connectionGene(nodes.get(randNode1), nodes.get(randNode2), random(-1, 1), connectionInnovationNumber));
    connectNodes();
  }
  
  boolean randomConnectionLol(int r1, int r2){
    if(nodes.get(r1).layer == nodes.get(r2).layer){
      return true;
    }
    if(nodes.get(r1).isConnected(nodes.get(r2))){
      return true;
    }
    return false;
  }
  
  NeuralNet clone(){
    NeuralNet clone = new NeuralNet(this.inputs, this.outputs, true);
    for(int i = 0; i < this.nodes.size(); i++){
      clone.nodes.add(this.nodes.get(i).clone());
    }
    
    for(int i = 0; i < this.genes.size(); i++){
      //christ
      clone.genes.add(this.genes.get(i).clone(clone.getNode(this.genes.get(i).from.number), clone.getNode(this.genes.get(i).to.number)));
    }
    clone.layers = this.layers;
    clone.nextNode = this.nextNode;
    clone.biasNode = this.biasNode;
    clone.connectNodes();
    
    return clone;
  }
  
  NeuralNet crossover(NeuralNet parent2){
    NeuralNet child = new NeuralNet(inputs, outputs, true);
    child.genes.clear();
    child.nodes.clear();
    child.layers = layers;
    child.nextNode = nextNode;
    child.biasNode = biasNode;
    
    ArrayList<connectionGene> childGenes = new ArrayList<>();
    ArrayList<Boolean> isEnabled = new ArrayList<>();
    
    for(int i = 0; i < genes.size(); i++){
      boolean setEnabled = true;
      
      int parent2gene = matchingGene(parent2, genes.get(i).inno);
      if(parent2gene != -1){
        if(!genes.get(i).enabled || !parent2.genes.get(parent2gene).enabled){
          if(random(1) < 0.75){
            setEnabled = false;
          }
          
        }
        float rand = random(1);
        if(rand < 0.5){
          childGenes.add(genes.get(i));
        }
        else{
          childGenes.add(parent2.genes.get(parent2gene));
          
        }
      }else{
        childGenes.add(genes.get(i));
        setEnabled = genes.get(i).enabled;
        
      }
      isEnabled.add(setEnabled);
    }
    
    for(int i = 0; i < nodes.size(); i++){
      child.nodes.add(nodes.get(i).clone());
    }
    
    for(int i = 0; i < childGenes.size(); i++){
      child.genes.add(childGenes.get(i).clone(child.getNode(childGenes.get(i).from.number), child.getNode(childGenes.get(i).to.number)));
      child.genes.get(i).enabled = isEnabled.get(i);
      
    }
    child.connectNodes();
    return child;
  }
  
  int matchingGene(NeuralNet parent2, int innovationNumber){
    for(int i = 0; i < parent2.genes.size(); i++){
      if(parent2.genes.get(i).inno == innovationNumber){
        return i;
      }
    }
    return -1;
  }


}

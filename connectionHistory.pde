class connectionHistory{
  int fromNode;
  int toNode;
  int inno;
  ArrayList<Integer> innoNums = new ArrayList<>();
  
  connectionHistory(int from, int to, int innovationNumber, ArrayList<Integer> innovationNumbers){
    fromNode = from;
    toNode = to;
    inno = innovationNumber;
    innoNums = (ArrayList)innovationNumbers.clone(); //copy array
  }
  
  boolean matches(NeuralNet genome, Node from, Node to){
    if(genome.genes.size() == innoNums.size()){
      if(from.number == fromNode && to.number == toNode){
        for(int i = 0; i < genome.genes.size(); i++){
          if(!innoNums.contains(genome.genes.get(i).inno)){
            return false;
          }
        }
        return true;
      }
    }
    return false;
  }


}

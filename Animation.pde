import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;

public static class Animation extends WallAnimation {

  // First, we add metadata to be used in the MoMath system. Change these
  // strings for your behavior.
  String behaviorName = "Sorting a Dynamic Wall";
  String author = "Celine Lee";
  String description = "Demonstrating Various Sorts on a Dynamic Wall";

  // Number of wall slats
  int wallLength = 128;

  float[] depths = new float[128]; // stores the depths of each wall (used in sorting)
  float[] original = new float[128]; // depths used in drawing

  // where we are located in the sort
  int move = 0;
  boolean merge = false;

  // stores all the moves of the sort (pre-computed)
  ArrayList<List<Integer>> moves = new ArrayList<List<Integer>>();

  // shuffles the depths of the wall
  void createDepths(){
    for(int i = 0; i < wallLength; i++)
      depths[i] = i/128.0; 
    for(int i = 0; i < wallLength; i++){
      int index = (int)(Math.random() * depths.length);
      float tmp = depths[i];
      depths[i] = depths[index];
      depths[index] = tmp;
    }
  }

  // sets the depths of the wall
  void setDepth(DWSlat slat, float depth){
    slat.setBottom(depth);
    slat.setTop(depth);
  }

  void swap(int i, int j, float[] arr){
     float tmp = arr[i];
     arr[i] = arr[j];
     arr[j] = tmp;
  }

  void bubbleSort(){
    for(int i = 0; i < 128; i++){
       for(int j = 0; j < 128 - i - 1; j++){
         if(depths[j] > depths[j+1]){
            swap(j+1, j, depths);
            moves.add(Arrays.asList(j+1, j));
         }
       }
    }
  }

  void quickSort(int l, int r){
    //System.out.printf("%d %d\n", l, r);
    if(l >= r)
      return;
    int pivot = partition(l, r);
    quickSort(l, pivot - 1);
    quickSort(pivot + 1, r);
  }

  void selectionSort(){
    for(int i = 0; i < 128; i++){
      int min = i;
      for(int j = i + 1; j < 128; j++){
        if (depths[j] < depths[min])
          min = j;
      }
      swap(min, i, depths);
      moves.add(Arrays.asList(min, i));
    }
  }

  void insertionSort(){
    for(int i = 0; i < 128; i++){
      for(int j = i; j > 0; j--){
        if(depths[j - 1] > depths[j])
        {
          swap(j - 1, j, depths);
          moves.add(Arrays.asList(j - 1, j));
        }
        else
          break;
      }
    }
  }
  
  void mergeSort(){
    ms(0, wallLength - 1);
  }
  
  void ms(int l, int r){
    if (l >= r)
      return;
    int mid = (l + r) / 2;
    ms(l, mid);
    ms(mid + 1, r);
    merge(l, mid + 1, r);
  }
  
  void merge(int l, int m, int r){
    float[] temp = new float[r - l + 1];
    int i = l;
    int j = m;
    int index = 0;
    while (i < m && j <= r){
      if (depths[i] < depths[j])
        temp[index++] = depths[i++];
      else
      temp[index++] = depths[j++];
    }
    while (i < m)
      temp[index++] = depths[i++];
    while (j <= r)
      temp[index++] = depths[j++];
    for (i = 0; i < temp.length; i++){
      depths[l + i] = temp[i];
      moves.add(Arrays.asList(l + i, (int)(temp[i] * 128)));
    }
  }

  int partition(int l, int r){
    float p = depths[l];
    int i = l + 1;
    int j = r;
    while(i <= j){
      if(depths[i] <= p)
        i++;
      else{
         swap(i, j, depths);
         moves.add(Arrays.asList(i, j));
         j--;
      }
    }
    swap(l, j, depths);
    moves.add(Arrays.asList(l, j));
    return j;
  }

  // The setup block runs at the beginning of the animation. You could
  // also use this function to initialize variables, load data, etc.
  void setup() {
    createDepths();
    merge = false;
    moves = new ArrayList<List<Integer>>();
    original = Arrays.copyOf(depths, wallLength);
    System.out.println(Arrays.toString(depths));
    for(int i = 0; i < wallLength; i++){
       setDepth(wall.slats[i], depths[i]);
    }
    int choice = (int)(Math.random() * 5);
    if(choice == 0){
      System.out.println("bubble sort");
      bubbleSort();
    }
    else if(choice == 1){
      System.out.println("quick sort");
      quickSort(0, wallLength - 1);
    }
    else if (choice == 2){
      System.out.println("selection sort");
      selectionSort();
    }
    else if (choice == 3){
      System.out.println("insertion sort");
      insertionSort();
    }
    else if (choice == 4){
      System.out.println("merge sort");
      merge = true;
      mergeSort();
    }
    move = 0;
  }

  // The update block will be repeated for each frame. This is where the
  // action should be programmed.
  void update() {
    // if we are done with the sort
    if(move == moves.size()){
      setup();
      System.out.println("Done");
    }
    else if (merge){
      List<Integer> nextMove = moves.get(move);
      int index = nextMove.get(0);
      float height = nextMove.get(1) / 128.0;
      setDepth(wall.slats[index], height);
      move++;
    }
    else{
      // get the next move and simulates on the wall
      // then updates the array of floats (original)
      List<Integer> nextMove = moves.get(move);
      int first = nextMove.get(0);
      int second = nextMove.get(1);
      System.out.printf("%d %d\n", first, second);
      setDepth(wall.slats[first], original[second]);
      setDepth(wall.slats[second], original[first]);
      swap(first, second, original);
      move++;
    }
  }

  // Leave this function blank
  void exit() {
  }

  // You can ignore everything from here.
  String getBehaviorName() {
    return behaviorName;
  }

  String getAuthorName() {
    return author;
  }

  String getDescription() {
    return description;
  }
}

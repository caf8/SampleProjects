//class which inclused dungeon and room and creates the room/dungeon based on Conway's game of life
public abstract class Place {

  boolean [][] map;
  int birthNum = 4;
  int deathNum = 4;
  float chanceToStartAlive;
  int numberOfSimulations = 10;
  int stoneHeight;
  int stoneWidth;

  Place(float chanceToStartAlive, int stoneHeight, int stoneWidth) {
    this.chanceToStartAlive = chanceToStartAlive;
    this.stoneHeight = stoneHeight;
    this.stoneWidth = stoneWidth;
  }

  //create room/dungeon
  void initialise(boolean finalRoom) {
    if (map != null) destroyMap();
    map = new boolean[width/stoneWidth][height/stoneHeight];
    if (!finalRoom) {
      for (int k = 0; k < 10; k++) {
        makeMap();
        if (checkMap()) { 
          setWalls();
          break;
        }
      }
    } else{
      setWalls();
    }
  }

  //make the room/dungeon
  public void makeMap() {
    destroyMap();
    initialiseMap();
    for (int i = 0; i < numberOfSimulations; i++) {
      simulation();
    }
  }

  //destroy the room/dungeon
  public void destroyMap() {
    for (int x=0; x<map.length; x++) {
      for (int y=0; y<map[x].length; y++) {
        map[x][y] = false;
      }
    }
  }

  //initalise the room/dungeon
  public void initialiseMap() {
    for (int i = 0; i < map.length; i++) {
      for (int j = 0; j < map[i].length; j++) {
        if (random(0, 1) < chanceToStartAlive) {
          map[i][j] = true;
        }
      }
    }
  }

  //simulate conway's game of life
  public void simulation() {
    boolean [][] newMap = new boolean[width/stoneWidth][height/stoneHeight];
    for (int i = 0; i < map.length; i++) {
      for (int j = 0; j < map[i].length; j++) {
        int numNeighbours = countNeighbours(i, j);
        if (map[i][j]) {
          if (numNeighbours < deathNum) {
            newMap[i][j] = false;
          } else {
            newMap[i][j] = true;
          }
        } else {
          if (numNeighbours > birthNum) {
            newMap[i][j] = true;
          } else {
            newMap[i][j] = false;
          }
        }
      }
    }
    map = newMap;
  }

  //check map is valid
  public boolean checkMap() {
    boolean[][] checkMap = copyMap(map);
    checkMap = floodFill((int) random(0, checkMap.length), (int) random(0, checkMap[0].length), checkMap);
    for (int i = 0; i < checkMap[0].length; i++) {
      for (int j = 0; j < checkMap[i].length; j++) {
        if (checkMap[i][j] == false) {
          return false;
        }
      }
    }
    return true;
  }

  //copy room/dungeon
  public boolean[][] copyMap(boolean[][] input) {
    boolean[][] target = new boolean[input.length][];
    for (int i=0; i <input.length; i++) {
      target[i] = Arrays.copyOf(input[i], input[i].length);
    }
    return target;
  }

  //floodFill
  public boolean[][] floodFill(int num1, int num2, boolean[][] checkMap) {
    if (checkMap[num1][num2] == false) {
      checkMap[num1][num2] = true;
      if (num1 < checkMap.length-1) {
        floodFill(num1+1, num2, checkMap);
      }
      if (num1 > 0) {
        floodFill(num1-1, num2, checkMap);
      }
      if (num2 < checkMap[0].length-1) {
        floodFill(num1, num2+1, checkMap);
      }
      if (num2 > 0) {
        floodFill(num1, num2-1, checkMap);
      }
    }
    return checkMap;
  }

  public int countNeighbours(int i, int j) {
    int count = 0;
    for (int m=-1; m<2; m++) {
      for (int n=-1; n<2; n++) {
        int neighbourX = i+m;
        int neighbourY = j+n;
        if (m == 0 && n == 0) {
        } else if (neighbourX < 0 || neighbourY < 0 || neighbourX >= map.length || neighbourY >= map[0].length) {
          count = count +1;
        } else if (map[neighbourX][neighbourY]) {
          count = count + 1;
        }
      }
    }
    return count;
  }

  //set the walls in the room/dungeon
  public void setWalls() {
    for (int i = 0; i < map.length; i++) {
      for (int j = 0; j < map[0].length; j++) {
        if (i == 0) {
          map[0][j] = true;
        } else if (i == map.length-1) {
          map[map.length-1][j] = true;
        }
        if (j == 0) {
          map[i][0] = true;
        } else if (j == map[0].length-1) {
          map[i][map[0].length-1] = true;
        }
      }
    }
  }
}
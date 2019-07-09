import java.util.Arrays;

final float chanceToStartAliveDungeon = 0.4;
final int stoneHeightDungeon = 80;
final int stoneWidthDungeon = 80;
  int numBlocksWidth;
  int numBlocksHeight;

//Dungeon class which contains the rooms
public class Dungeon extends Place {
  
  
  public Dungeon() {
    super(chanceToStartAliveDungeon, stoneHeightDungeon, stoneWidthDungeon);
    numBlocksWidth = width/stoneWidthDungeon;
    numBlocksHeight = height/stoneHeightDungeon;
    initialise(false);
    
  }

}
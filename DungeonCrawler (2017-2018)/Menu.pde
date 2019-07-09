//Menu class used for start and pause menu
class Menu {

  boolean showMenu;
  boolean instructions;

  //draw the menu
  void drawMenu(boolean start) {
    background(220);
    fill(0);
    textSize(40);
    if (instructions) {
      drawInstructions();
    } else {
      drawMainScreen(start);
    }
  }

  //check which key has been pressed when you are in menu
  void checkKey(int k) {
    switch(k) {
    case 'Q':
      exit();
      break;
    case 'I':
      instructions = !instructions;
      break;
    case ENTER:
      showMenu = false;
      break;
    }
  }

  //draw the starting screen
  void drawMainScreen(boolean start) {
    String verb;
    if (start) {
      text("ESCAPE THE COLE MINE!", 200, 100);
      verb = "start";
    } else {
      text("GAME PAUSED", 400, 100);
      verb = "continue";
    }
    textSize(32);
    text("'I'                  for instructions", 200, 300);
    text("'Q'                to quit the game", 200, 350);
    text("'ENTER'         to " + verb + " the game", 200, 400);
  }

  //draw instructions
  void drawInstructions() {
    textSize(32);
    text("Instructions", 200, 100);

  }
}
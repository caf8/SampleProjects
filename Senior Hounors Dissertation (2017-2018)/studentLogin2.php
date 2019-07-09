<?php
//Setting up connection to the databases
$DB_HOST = "localhost";
$DB_USER = "caf8";
$DB_PASSWORD = "wFucTKR9G2w.Qm";
$DB_NAME = "caf8_admin_centre";
$dbc = mysqli_connect($DB_HOST, $DB_USER, $DB_PASSWORD) or die (mysql_error());
mysqli_select_db($dbc,$DB_NAME);
//Retriveing information from the form that launched the PHP file.
$username = $_POST['student_name'];
$password = $_POST['student_password'];
//Setting up querry that will be used to check if the student exists or not
$sql_expr_str1 = "SELECT * FROM student where name='".$username."' and password='".$password."'" ;
$sql_expr_str1 = str_replace("\'","",$sql_expr_str1);
//Execution of querry
$result1 = mysqli_query($dbc, $sql_expr_str1);
//If there were any results returned then the student account exists.
if(mysqli_num_rows($result1) > 0){
?>
<?php 
//Fetches all the layouts from the studentLevel on conditions involving the level and students name table and places them inside an array
$layoutArray= array();
$sql_expr_str2 = "SELECT layout FROM studentLevel join Level on Levelname = Level_name where student_name='".$username."'" ;
$sql_expr_str2 = str_replace("\'","",$sql_expr_str2);
$result2 = mysqli_query($dbc, $sql_expr_str2);
if(mysqli_num_rows($result2) > 0){
while($row = mysqli_fetch_array($result2)) {
array_push($layoutArray,$row[0]);
}
}
//Fetches all the levelnames from the studentLevel on conditions involving the level and students name table and places them inside an array
$levelNameArray= array();
$sql_expr_str2 = "SELECT Level_name FROM studentLevel join Level on Levelname = Level_name where student_name='".$username."'" ;
$sql_expr_str2 = str_replace("\'","",$sql_expr_str2);
$result2 = mysqli_query($dbc, $sql_expr_str2);
if(mysqli_num_rows($result2) > 0){
while($row = mysqli_fetch_array($result2)) {
array_push($levelNameArray,$row[0]);
}
}
//Fetches all the skins from the studentLevel on conditions involving the level and students name table and places them inside an array
$tileMapArray= array();
$sql_expr_str3 = "SELECT skin FROM studentLevel join Level on Levelname = Level_name where student_name='".$username."'" ;
$sql_expr_str3 = str_replace("\'","",$sql_expr_str3);
$result3 = mysqli_query($dbc, $sql_expr_str3);
if(mysqli_num_rows($result3) > 0){
while($row = mysqli_fetch_array($result3)) {
array_push($tileMapArray,$row[0]);
}
}
//Fetches all the level solutions from the studentLevel on conditions involving the level and students name table and places them inside an array
$levelSolutionArray= array();
$sql_expr_str4 = "SELECT solution FROM studentLevel join Level on Levelname = Level_name where student_name='".$username."'" ;
$sql_expr_str4 = str_replace("\'","",$sql_expr_str4);
$result4 = mysqli_query($dbc, $sql_expr_str4);
if(mysqli_num_rows($result4) > 0){
while($row = mysqli_fetch_array($result4)) {
array_push($levelSolutionArray,$row[0]);
}
}
//Fetches all the student Names from the studentLevel on conditions involving the level and students name table and places them inside an array
$studentNameArray= array();
$sql_expr_str5 = "SELECT student_name FROM studentLevel join Level on Levelname = Level_name where student_name='".$username."'" ;
$sql_expr_str5 = str_replace("\'","",$sql_expr_str5);
$result5 = mysqli_query($dbc, $sql_expr_str5);
if(mysqli_num_rows($result5) > 0){
while($row = mysqli_fetch_array($result5)) {
array_push($studentNameArray,$row[0]);
}
}
//Fetches all the level difficulties from the studentLevel on conditions involving the level and students name table and places them inside an array
$levelDifficultyArray= array();
$sql_expr_str6 = "SELECT Difficulty FROM studentLevel join Level on Levelname = Level_name where student_name='".$username."'" ;
$sql_expr_str6 = str_replace("\'","",$sql_expr_str6);
$result6 = mysqli_query($dbc, $sql_expr_str6);
if(mysqli_num_rows($result6) > 0){
while($row = mysqli_fetch_array($result6)) {
array_push($levelDifficultyArray,$row[0]);
}
}
//Fetches all the best solutions from the studentLevel on conditions involving the level and students name table and places them inside an array
$currentBestSolution= array();
$sql_expr_str7 = "SELECT best_solution FROM studentLevel join Level on Levelname = Level_name where student_name='".$username."'" ;
$sql_expr_str7 = str_replace("\'","",$sql_expr_str7);
$result7 = mysqli_query($dbc, $sql_expr_str7);
if(mysqli_num_rows($result7) > 0){
while($row = mysqli_fetch_array($result7)) {
array_push($currentBestSolution,$row[0]);
}
}
}else{
?> 
<p> student login failed 
</p>
<?php 
exit(0);
}
?>
<html>
  <style>
    button{
      position: fixed;
      right: 157px;
      top: 10px;
      width: 7%;
      height: 7%;
      background-color: #3465A4;
      color: white;
      font-weight: bold;
      font-size: 18px;
    }
    button:hover{
      background-color: #8465A4;
    }
    /*
    heading and paragraph tags used to style and position text on the html page.
    */
    p1{
      color: #3465A4;
      font-weight: bold;
      font-size: 18px;
      position: fixed;
      left: 400px;
      top: 10px;
      width: 40%;
    }
    p2{
      color: #3465A4;
      font-weight: bold;
      font-size: 18px;
      position: fixed;
      left: 400px;
      top: 40px;
      width: 40%;
    }
    p3{
      color: #3465A4;
      font-weight: bold;
      font-size: 18px;
      position: fixed;
      left: 650px;
      top: 9px;
      width: 40%;
    }
    p4{
      color: #3465A4;
      font-weight: bold;
      font-size: 18px;
      position: fixed;
      left: 690px;
      top: 42px;
      width: 40%;
    }
    p5{
      color: #3465A4;
      font-weight: bold;
      font-size: 18px;
      position: fixed;
      right: 90px;
      top: 44px;
      width: 40%;
    }
    p6{
      color: #3465A4;
      font-weight: bold;
      font-size: 18px;
      position: fixed;
      right: 100px;
      top: 10px;
      width: 40%;
    }
    /*
    Colour, Padding and position of forms places on the screen. 
    inputs with the type of submit, change colour when hovered over to highlight them to users.
    */
    input[type=text], select {
      width: 20%;
      display: inline-block;
      border: 1px solid #ccc;
      border-radius: 4px;
      box-sizing: border-box;
    }
    input[type=submit] {
      width: 20%;
      background-color: #3465A4;
      color: white;
      padding: 14px 20px;
      margin: 8px 0;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }
    input[type=submit]:hover {
      background-color: #8465A4;
    }
    div {
      border-radius: 5px;
      background-color: #f2f2f2;
      padding: 20px;
    }
  </style>
  <!--This form when submitted lauches PHP file  where the best solutions from each student level is submitted-->
  <!--Form uses POST to keep account details hidden-->
  <body>
    <button id='nextLevel' type="button" onclick="nextLevel()"  disabled = true;>NextLevel!
    </button>
    <button id='resetLevel' type="button" onclick="resetLevel()" style="right: 30px">Reset!
    </button>
    <form action="best_solution.php"; method="POST">
      <p1>Student: 
        <input type="text" id="Student" name="Student" value="" readonly>
      </p1>
      <p2>Level Name: 
        <input  type="text" id="LevelName" name="LevelName" value="" readonly>
      </p2>
      <p3>Difficulty: 
        <input type="text" id="LevelDifficulty" name="LevelDifficulty" value="" readonly>
      </p3>
      <p4>Current Best Score: 
        <input type="text" id="currentBestScore"  name="currentBestScore" value="" readonly>
      </p4>
      <p5>Best Solution Reached: 
        <input type="text" id="BestSolution" name="BestSolution" value="" readonly>
      </p5>
      <input type="text" id="bestSolutionArray" name="bestSolutionArray" value="" style="display: none">
      <input type="text" id="bestSolutionLNameArray" name="bestSolutionLNameArray" value="" style="display: none">
      <input type="submit" value="Submit" id='finishGame' disabled = true;>
    </form> 
  </body>
</html>
<!--Including the Phaser framework in the page-->
<script type="text/javascript" src="lib/phaser.js">
</script>
<script type="text/javascript" src="Phasetips-master/Phasetips.js">
</script>
<script>
  //Defining the arrays then popultaing them with information that was retrieved from the PHP.
  //Each index in the arrays represents a level.
  var layout = new Array(2);
  var levelName = new Array();
  var tileMapArray = new Array();
  var levelDifficultyArray = new Array();
  var levelSolutionArray = new Array();
  var studentNameArray = new Array();
  var currentBestSolutionArray = new Array();
  tileMapArray = <?php echo json_encode($tileMapArray );
  ?>;
  levelName = <?php echo json_encode($levelNameArray );
  ?>;
  layout = <?php echo json_encode($layoutArray );
  ?>;
  levelDifficultyArray = <?php echo json_encode($levelDifficultyArray );
  ?>;
  levelSolutionArray = <?php echo json_encode($levelSolutionArray );
  ?>;
  studentNameArray = <?php echo json_encode($studentNameArray );
  ?>;
  currentBestSolutionArray = <?php echo json_encode($currentBestSolution );
  ?>;
  //Defining Phaser game.
  //Sets size of game, and the create and update functions
  var game = new Phaser.Game(1600, 576, Phaser.CANVAS, 'phaser-example', {
    preload: preload, create: create, update: update, render: render }
                            );
  //Preload function is run when the page is loaded.
  function preload() {
    //Loads different json file depending on what option was selected on the previous page.
    //The different json files represent different json files
    if(tileMapArray[0] == 'Tileset1'){
      game.load.tilemap('desert', 'TileMap1.json', null, Phaser.Tilemap.TILED_JSON);
    }
    else if(tileMapArray[0] == 'Tileset2'){
      game.load.tilemap('desert', 'TileMap2.json', null, Phaser.Tilemap.TILED_JSON);
    }
    else if(tileMapArray[0] == 'Tileset3'){
      game.load.tilemap('desert', 'TileMap3.json', null, Phaser.Tilemap.TILED_JSON);
    }
    else if(tileMapArray[0] == 'Tileset4'){
      game.load.tilemap('desert', 'TileMap4.json', null, Phaser.Tilemap.TILED_JSON);
    }
    else if(tileMapArray[0] == 'Tileset5'){
      game.load.tilemap('desert', 'TileMap5.json', null, Phaser.Tilemap.TILED_JSON);
    }
    //Loading images that will be used for the assests of the game.
    //Images used to represent tilemap, input objects and background.
    game.load.image('tiles1','characterBackground2.png');
    game.load.image('tiles', 'landscape1.png');
    game.load.image('tile2', 'colours.png');
    game.load.image('tilesWhite', 'white.png');
    game.load.image('characterTiles','sandTile.png');
    game.load.image('basicColours', 'basic.png');
    game.load.image('grid', 'new_background1.png');
    game.load.image('atari', 'upArrow.png');
    game.load.image('sonic', 'assets/sprites/sonic_havok_sanity.png');
    game.load.spritesheet('button', 'button_sprite_sheetEdited1.png', 191, 70);
    game.load.image('num1', '1.png');
    game.load.image('num2', '2.png');
    game.load.image('num3', '3.png');
    game.load.image('num4', '4.png');
    game.load.image('num5', '5.png');
    game.load.image('num6', '6.png');
    game.load.image('num7', '7.png');
    game.load.image('num8', '8.png');
    game.load.image('num9', '9.png');
    game.load.image('start', 'Start.png');
    game.load.image('end', 'End.png');
    game.load.image('clockwise', 'Clockwise.png');
    game.load.image('anticlockwise', 'AntiClockwise.png');
  }
  //Setting up the arrays that will be used throughout the program.
  var levelNumber = 0;
  var levelDetail = layout[levelNumber]
  var levelArray = new Array(24)
  for (i=0; i < 24; i++){
    levelArray[i]=new Array(18);
  }
  var levelDetailArray = levelDetail.split(',');
  var starCounteri = 0;
  var starCounterj = 0;
  for (i=19; i < levelDetailArray.length-1; i++){
    if(i%19 == 0){
      starCounteri=0;
      starCounterj++;
    }
    levelArray[starCounterj][starCounteri] = levelDetailArray[i]
    starCounteri++;
  }
  var currentlevelArray = new Array(24)
  for (i=0; i < 24; i++){
    currentlevelArray[i]=new Array(18);
  }
  for (var j = 1; j < 24; j++){
    for (var k = 0; k < 18; k++){
      currentlevelArray[j][k] = levelArray[j][k]
    }
  }
  for(var k = 0; k < levelSolutionArray.length; k++){
    levelSolutionArray[k] = levelSolutionArray[k].split(",")
  }
  //Assigns the information from the first level into the HTML elements that display it.
  document.getElementById("Student").value = studentNameArray[0];
  document.getElementById("LevelName").value = levelName[0];
  document.getElementById("LevelDifficulty").value = levelDifficultyArray[0];
  document.getElementById("currentBestScore").value = currentBestSolutionArray[0];
  if(currentBestSolutionArray[0] < levelSolutionArray[0].length){
    document.getElementById("BestSolution").value = "Yes";
  }
  else{
    document.getElementById("BestSolution").value = "No";
  }
  //Defining global varaiables to be used throught the page.
  var commandArrayResult;
  var moveEnabled = "false";
  var tileOnTopOfTemp
  var firstMove = "yes";
  var terrainTile = "obstacle6";
  var tileOnTopOf;
  var characterDirection = "up";
  var characterX = 0;
  var characterY = 0;
  var characterName;
  var characterTile;
  var map;
  var layer;
  var marker;
  var currentTile;
  var tempTile;
  var checkTile;
  var cursors;
  var bestSolutions = [];
  var bestSolutionLevelName = [];
  var commandArray = [];
  var commmandCoorArray = [];
  var result = '';
  var numOfSymbol = 0;
  var sTip;
  var eTip;
  var upTip;
  var cwTip;
  var acwTip;
  var _1Tip;
  var _2Tip;
  var _3Tip;
  var _4Tip;
  var _5Tip;
  var sToolTipArray = new Array(20);
  var eToolTipArray = new Array(20);
  var upToolTipArray = new Array(20);
  var cwToolTipArray = new Array(20);
  var acwToolTipArray = new Array(20);
  var _1ToolTipArray = new Array(20);
  var _2ToolTipArray = new Array(20);
  var _3ToolTipArray = new Array(20);
  var _4ToolTipArray = new Array(20);
  var _5ToolTipArray = new Array(20);
  var upKey;
  var downKey;
  var character1Tile;
  var character2Tile;
  var character3Tile;
  var character4Tile;
  var character5Tile;
  var goal1Tile;
  var goal2Tile;
  var obstacle1Tile;
  var obstacle3Tile;
  var obstacle4Tile;
  var obstacle5Tile;
  var obstacle6Tile;
  var terrain1Tile;
  var terrain2Tile;
  var terrain3Tile;
  var terrain4Tile;
  var terrain5Tile;
  var instruction1 = "To move an input object click \nthe mouse on a symbol and \ndrag it to the green area.";
  var instruction2 = "To find out more information \nabout each symbol have a \nlook at the tooltips! To \nactivate the tooltips press the \ndown key, to deactivate them \nthe up key";
  var instruction3 = "To input solution click run!";
  var instruction4 = "Once you have seen the \nwinners alert, click next level, \nif the map area fills with \nobstacle tiiles, you have \ncompleted the last level. When \nthis occurs click submit to \nfinish your lesson";
  var button;
  var winner;
  //Create functions runs after the preloads function.
  //The create function defines and creates the tilemap that is used to create the level.
  //The create function also defines and creates the input objects. 
  function create() {
    //Defining keys that will be used to able and disable tooltipping on objects
    upKey = game.input.keyboard.addKey(Phaser.Keyboard.UP);
    downKey = game.input.keyboard.addKey(Phaser.Keyboard.DOWN);
    var background =  game.add.sprite(0, 0, 'grid');
    text1 = game.add.text(1320, 0, instruction1, {
      font: "16px; Arial", fill: "orange" }
                         );
    text2 = game.add.text(1320, 80, instruction2, {
      font: "16px; Arial", fill: "orange" }
                         );
    text3 = game.add.text(1320, 235, instruction3, {
      font: "16px; Arial", fill: "orange" }
                         );
    text4 = game.add.text(1320, 262, instruction4, {
      font: "16px; Arial", fill: "orange" }
                         );
    //Creating a group that the objects will be added too.
    group = game.add.group();
    group.inputEnableChildren = true;
    //Adding the structure of the tileset to the map
    map = game.add.tilemap('desert');
    //Conditional structure that is used to set the skin that will be used on the tileset
    if(tileMapArray[0]== 'Tileset1'){
      map.addTilesetImage('characters2','characterTiles')
      map.addTilesetImage('white', 'basicColours');
      map.addTilesetImage('characters', 'tiles1');
      map.addTilesetImage('terrain', 'tiles');
    }
    else if(tileMapArray[0] == 'Tileset2'){
      map.addTilesetImage('characters2','characterTiles');
      map.addTilesetImage('whiteTileSet2', 'basicColours');
      map.addTilesetImage('characters', 'tiles1');
      map.addTilesetImage('terrain', 'tiles');
    }
    else if(tileMapArray[0] == 'Tileset3'){
      map.addTilesetImage('character2','characterTiles');
      map.addTilesetImage('white', 'basicColours');
      map.addTilesetImage('characters', 'tiles1');
      map.addTilesetImage('terrain', 'tiles');
    }
    else if(tileMapArray[0] == 'Tileset4'){
      map.addTilesetImage('white', 'basicColours');
      map.addTilesetImage('colours', 'tile2');
    }
    else if(tileMapArray[0] == 'Tileset5'){
      map.addTilesetImage('white', 'basicColours');
      map.addTilesetImage('colours', 'tile2');
    }
    //Add layer to the tilemap.
    layer = map.createLayer('Ground');
    //Gets the tiles that will be used to produce the tilemaps after the menu bar is covered up at the side.
    character1Tile = map.getTile(layer.getTileX(0), layer.getTileY(0));
    character2Tile = map.getTile(layer.getTileX(0), layer.getTileY(32));
    character3Tile = map.getTile(layer.getTileX(0), layer.getTileY(64));
    character4Tile = map.getTile(layer.getTileX(0), layer.getTileY(96));
    character5Tile = map.getTile(layer.getTileX(0), layer.getTileY(128));
    goal1Tile = map.getTile(layer.getTileX(0), layer.getTileY(160));
    goal2Tile = map.getTile(layer.getTileX(0), layer.getTileY(192));
    obstacle1Tile = map.getTile(layer.getTileX(0), layer.getTileY(224));
    obstacle2Tile = map.getTile(layer.getTileX(0), layer.getTileY(256));
    obstacle3Tile = map.getTile(layer.getTileX(0), layer.getTileY(288));
    obstacle4Tile = map.getTile(layer.getTileX(0), layer.getTileY(320));
    obstacle5Tile = map.getTile(layer.getTileX(0), layer.getTileY(352));
    obstacle6Tile = map.getTile(layer.getTileX(0), layer.getTileY(384));
    terrain1Tile = map.getTile(layer.getTileX(0), layer.getTileY(416));
    terrain2Tile = map.getTile(layer.getTileX(0), layer.getTileY(448));
    terrain3Tile = map.getTile(layer.getTileX(0), layer.getTileY(512));
    terrain4Tile = map.getTile(layer.getTileX(0), layer.getTileY(544));
    terrain5Tile = map.getTile(layer.getTileX(0), layer.getTileY(576));
    //Add phaser button to the page, that when clicked on, launches the function actionOnClick
    //Then adds button to the group.
    button = game.make.button(770, 490, 'button', actionOnClick, this, 2, 1, 0);
    group.add(button);
    //For loop that creates and places the input objects into the game.
    //Adds event handelers to each of the objects.
    for (var i = 0; i < 20; i++)
    {
      //Up arrow added to the Phaser game
      var atari = group.create(5, 5, 'atari');
      atari.name = ("up");
      atari.scale.x = 1;
      atari.scale.y = 1;
      atari.inputEnabled = true;
      atari.input.enableDrag();
      atari.input.enableSnap(32, 32, false, true);
      atari.position.x = 768;
      atari.position.y = 64;
      atari.events.onDragStart.add(onDragStart, this);
      atari.events.onDragStop.add(onDragStopUpArrow, this);
      //Number 1 added to the Phaser game
      var num1 = group.create(32,2, 'num1');
      num1.name = ("1");
      num1.scale.x = 1;
      num1.scale.y = 1;
      num1.inputEnabled = true;
      num1.input.enableDrag();
      num1.position.x = 768;
      num1.position.y = 160;
      num1.input.enableSnap(32, 32, false, true);
      num1.events.onDragStart.add(onDragStart, this);
      num1.events.onDragStop.add(onDragStopNum1, this);
      //Number 2 added to the Phaser game
      var num2 = group.create(64,2, 'num2');
      num2.name = ("2");
      num2.scale.x = 1;
      num2.scale.y = 1;
      num2.inputEnabled = true;
      num2.input.enableDrag();
      num2.input.enableSnap(32, 32, false, true);
      num2.position.x = 768;
      num2.position.y = 192;
      num2.events.onDragStart.add(onDragStart, this);
      num2.events.onDragStop.add(onDragStopNum2, this);
      //Number 3 added to the Phaser game
      var num3 = group.create(64,2, 'num3');
      num3.name = ("3");
      num3.scale.x = 1;
      num3.scale.y = 1;
      num3.inputEnabled = true;
      num3.input.enableDrag();
      num3.input.enableSnap(32, 32, false, true);
      num3.position.x = 768;
      num3.position.y = 224;
      num3.events.onDragStart.add(onDragStart, this);
      num3.events.onDragStop.add(onDragStopNum3, this);
      //Number 4 added to the Phaser game
      var num4 = group.create(64,2, 'num4');
      num4.name = ("4");
      num4.scale.x = 1;
      num4.scale.y = 1;
      num4.inputEnabled = true;
      num4.input.enableDrag();
      num4.input.enableSnap(32, 32, false, true);
      num4.position.x = 768;
      num4.position.y = 256;
      num4.events.onDragStart.add(onDragStart, this);
      num4.events.onDragStop.add(onDragStopNum4, this);
      //Number 5 added to the Phaser game
      var num5 = group.create(64,2, 'num5');
      num5.name = ("5");
      num5.scale.x = 1;
      num5.scale.y = 1;
      num5.inputEnabled = true;
      num5.input.enableDrag();
      num5.input.enableSnap(32, 32, false, true);
      num5.position.x = 768;
      num5.position.y = 288;
      num5.events.onDragStart.add(onDragStart, this);
      num5.events.onDragStop.add(onDragStopNum5, this);
      //Number 6 added to the Phaser game
      var num6 = group.create(64,2, 'num6');
      num6.name = ("6");
      num6.scale.x = 1;
      num6.scale.y = 1;
      num6.inputEnabled = true;
      num6.input.enableDrag();
      num6.input.enableSnap(32, 32, false, true);
      num6.position.x = 768;
      num6.position.y = 320;
      num6.events.onDragStart.add(onDragStart, this);
      num6.events.onDragStop.add(onDragStopNum6, this);
      //Number 7 added to the Phaser game
      var num7 = group.create(64,2, 'num7');
      num7.name = ("7");
      num7.scale.x = 1;
      num7.scale.y = 1;
      num7.inputEnabled = true;
      num7.input.enableDrag();
      num7.input.enableSnap(32, 32, false, true);
      num7.position.x = 768;
      num7.position.y = 352;
      num7.events.onDragStart.add(onDragStart, this);
      num7.events.onDragStop.add(onDragStopNum7, this);
      //Number 8 added to the Phaser game
      var num8 = group.create(64,2, 'num8');
      num8.name = ("8");
      num8.scale.x = 1;
      num8.scale.y = 1;
      num8.inputEnabled = true;
      num8.input.enableDrag();
      num8.input.enableSnap(32, 32, false, true);
      num8.position.x = 768;
      num8.position.y = 384;
      num8.events.onDragStart.add(onDragStart, this);
      num8.events.onDragStop.add(onDragStopNum8, this);
      //Number 9 added to the Phaser game
      var num9 = group.create(64,2, 'num9');
      num9.name = ("9");
      num9.scale.x = 1;
      num9.scale.y = 1;
      num9.inputEnabled = true;
      num9.input.enableDrag();
      num9.input.enableSnap(32, 32, false, true);
      num9.position.x = 768;
      num9.position.y = 416;
      num9.events.onDragStart.add(onDragStart, this);
      num9.events.onDragStop.add(onDragStopNum9, this);
      //Start of loop added to the Phaser game
      var start = group.create(96,2, 'start');
      start.name = ("start");
      start.scale.x = 1;
      start.scale.y = 1;
      start.inputEnabled = true;
      start.input.enableDrag();
      start.input.enableSnap(32, 32, false, true);
      start.position.x = 768;
      start.position.y = 0;
      start.events.onDragStart.add(onDragStart, this);
      start.events.onDragStop.add(onDragStopStart, this);
      //End of loop added to the Phaser game
      var end = group.create(128,2, 'end');
      end.name = ("end");
      end.scale.x = 1;
      end.scale.y = 1;
      end.inputEnabled = true;
      end.input.enableDrag();
      end.position.x = 768;
      end.position.y = 32;
      end.input.enableSnap(32, 32, false, true);
      end.events.onDragStart.add(onDragStart, this);
      end.events.onDragStop.add(onDragStopEnd, this);
      //Clockwise turn added to the Phaser game
      var clockwise = group.create(160,2, 'clockwise');
      clockwise.name = ('clockwise');
      clockwise.scale.x = 1;
      clockwise.scale.y = 1;
      clockwise.inputEnabled = true;
      clockwise.input.enableDrag();
      clockwise.input.enableSnap(32,32,false,true);
      clockwise.position.x = 768;
      clockwise.position.y = 128;
      clockwise.events.onDragStart.add(onDragStart, this);
      clockwise.events.onDragStop.add(onDragStopClock, this);
      //Anti-Clockwise turn added to the Phaser game
      var anticlockwise = group.create(192,2, 'anticlockwise');
      anticlockwise.name = ('anticlockwise');
      anticlockwise.scale.x = 1;
      anticlockwise.scale.y = 1;
      anticlockwise.inputEnabled = true;
      anticlockwise.input.enableDrag();
      anticlockwise.input.enableSnap(32,32,false,true);
      anticlockwise.position.x = 768;
      anticlockwise.position.y = 96;
      anticlockwise.events.onDragStart.add(onDragStart, this);
      anticlockwise.events.onDragStop.add(onDragStopAnti, this);
      //Defining and setting the properties of the tooltips that will be used on the input objects
      //Each individual object is assigned a tooltip throughout the loop
      eTip = new Phasetips(game, {
        targetObject: end,
        context: "Marks the end of the loop, needs placed inline with an S above it",
        strokeColor: 0xff0000,
        position: "right",
        enableCursor: true,
      }
                          );
      eToolTipArray[i] = eTip;
      sTip = new Phasetips(game, {
        targetObject: start,
        context: "Marks the start of the loop, needs to have a number placed beside it and E inline underneath it",
        strokeColor: 0xff0000,
        position: "right",
        enableCursor: true,
      }
                          );
      sToolTipArray[i] = sTip;
      upTip = new Phasetips(game, {
        targetObject: atari,
        context: "Moves character forward one tile in the direction it is facing",
        strokeColor: 0xff0000,
        position: "right",
        enableCursor: true,
      }
                           );
      upToolTipArray[i] = upTip;
      cwTip = new Phasetips(game, {
        targetObject: clockwise,
        context: "Rotates character one tile clockwise",
        strokeColor: 0xff0000,
        position: "right",
        enableCursor: true,
      }
                           );
      cwToolTipArray[i] = cwTip;
      acwToolTipArray[i] = acwTip;
      acwTip = new Phasetips(game, {
        targetObject: anticlockwise,
        context: "Rotates character one tile anticlockwise",
        strokeColor: 0xff0000,
        position: "right",
        enableCursor: true,
      }
                            );
      acwToolTipArray[i] = acwTip;
      _1Tip = new Phasetips(game, {
        targetObject: num1,
        context: "Represent one interation of a loop (Duplicates contents of loop once) Needs placed next to an S",
        strokeColor: 0xff0000,
        position: "right",
        enableCursor: true,
      }
                           );
      _1ToolTipArray[i] = _1Tip;
      _2Tip = new Phasetips(game, {
        targetObject: num2,
        context: "Represent two interations of a loop (Duplicates contents of loop twice) Needs placed next to an S",
        strokeColor: 0xff0000,
        position: "right",
        enableCursor: true,
      }
                           );
      _2ToolTipArray[i] = _2Tip;
      _3Tip = new Phasetips(game, {
        targetObject: num3,
        context: "Represent three interations of a loop (Duplicates contents of loop 3 times) Needs placed next to an S",
        strokeColor: 0xff0000,
        position: "right",
        enableCursor: true,
      }
                           );
      _3ToolTipArray[i] = _3Tip;
      _4Tip = new Phasetips(game, {
        targetObject: num4,
        context: "Represent four interations of a loop (Duplicates contents of loop 4 times) Needs placed next to an S",
        strokeColor: 0xff0000,
        position: "right",
        enableCursor: true,
      }
                           );
      _4ToolTipArray[i] = _4Tip;
      _5Tip = new Phasetips(game, {
        targetObject: num5,
        context: "Represent five interations of a loop (Duplicates contents of loop 5 times) Needs placed next to an S",
        strokeColor: 0xff0000,
        position: "right",
        enableCursor: true,
      }
                           );
      _5ToolTipArray[i] = _5Tip;
    }
    cursors = game.input.keyboard.createCursorKeys();
  }
  //This function resets the current level the user is playing.
  //It does this by resetting the variables used throughout the level.
  function resetLevel(){
    document.getElementById("nextLevel").disabled = true;
    button.inputEnabled = true;
    tileOnTopOf = "";
    tileOnTopOfTemp = "";
    characterName = "";
    firstMove = "yes"
    characterDirection = "up"
    commandArray = [];
    commmandCoorArray = [];
    for (var j = 1; j < 24; j++){
      for (var k = 0; k < 18; k++){
        levelArray[j][k] = currentlevelArray[j][k]
      }
    }
  }
  //This function sets all the values that desribe the level to the next level in a user's lesson.
  function nextLevel(){
    //If the number of symbols used is less than the best solution, then update the best solution to later be written to the database.
    if(numOfSymbol < currentBestSolutionArray[levelNumber]){
      bestSolutions[levelNumber] = numOfSymbol;
    }
    else{
      bestSolutions[levelNumber] = currentBestSolutionArray[levelNumber];
    }
    bestSolutionLevelName[levelNumber] = levelName[levelNumber];
    resetLevel()
    levelNumber = levelNumber + 1
    if(levelNumber == layout.length){
      var compressedMyArray = "";
      compressedMyArray += bestSolutions[0]
      for (var j = 1; j < bestSolutions.length; j++){
        compressedMyArray +=  ("," + bestSolutions[j]);
      }
      var compressedMyArrayLName = "";
      compressedMyArrayLName += bestSolutionLevelName[0]
      for (var j = 1; j < bestSolutionLevelName.length; j++){
        compressedMyArrayLName +=  ("," + bestSolutionLevelName[j]);
      }
      //Update Level information that will be used to advnace to the next level
      document.getElementById("bestSolutionArray").value = compressedMyArray;
      document.getElementById("bestSolutionLNameArray").value = compressedMyArrayLName;
      document.getElementById("finishGame").disabled = false;
      document.getElementById("nextLevel").disabled = true;
    }
    levelDetail = layout[levelNumber]
    levelArray = new Array(24)
    for (i=0; i < 24; i++){
      levelArray[i]=new Array(18);
    }
    levelDetailArray = levelDetail.split(',');
    starCounteri = 0;
    starCounterj = 0;
    for (i=19; i < levelDetailArray.length-1; i++){
      if(i%19 == 0){
        starCounteri=0;
        starCounterj++;
      }
      levelArray[starCounterj][starCounteri] = levelDetailArray[i]
      starCounteri++;
    }
    for (var j = 1; j < 24; j++){
      for (var k = 0; k < 18; k++){
        currentlevelArray[j][k] = levelArray[j][k]
      }
    }
    //Update Level information that is displayed in the HTML fields at the top of the level.
    document.getElementById("Student").value = studentNameArray[levelNumber];
    document.getElementById("LevelName").value = levelName[levelNumber];
    document.getElementById("LevelDifficulty").value = levelDifficultyArray[levelNumber];
    document.getElementById("currentBestScore").value = currentBestSolutionArray[levelNumber];
    document.getElementById("BestSolution").value = "No";
    document.getElementById("nextLevel").disabled = true;
    //Shows the user whether or not they have achieved the best score possible on the level.
    if(currentBestSolutionArray[levelNumber] < levelSolutionArray[levelNumber].length){
      document.getElementById("BestSolution").value = "Yes";
    }
    else{
      document.getElementById("BestSolution").value = "No";
    }
    button.inputEnabled = true;
  }
  //This function runs continously on the webpage. It updates the state of the game, including the tile map and objects.
  function update() {
    //This nested loop updates the array that the tilemap is generated from. It also sets the position of a character if
    //it is a character tile being placed.
    for (var j = 1; j < 24; j++){
      for (var k = 0; k < 18; k++){
        if(levelArray[j][k] == "character1"){
          currentTile = character1Tile;
          characterX = j;
          characterY = k;
          characterName = "character1"
        }
        else if(levelArray[j][k] == "character2"){
          currentTile = character2Tile;
          characterX = j;
          characterY = k;
          characterName = "character2"
        }
        else if(levelArray[j][k] == "character3"){
          currentTile = character3Tile;
          characterX = j;
          characterY = k;
          characterName = "character3"
        }
        else if(levelArray[j][k] == "charcater4"){
          currentTile = character4Tile;
          characterX = j;
          characterY = k;
          characterName = "character4"
        }
        else if(levelArray[j][k] == "character5"){
          currentTile = character5Tile;
          characterX = j;
          characterY = k;
          characterName = "character5"
        }
        else if(levelArray[j][k] == "goal1"){
          currentTile = goal1Tile;
        }
        else if(levelArray[j][k] == "goal2"){
          currentTile = goal2Tile;
        }
        else if(levelArray[j][k] == "obstacle1"){
          currentTile = obstacle1Tile;
        }
        else if(levelArray[j][k] == "obstacle2"){
          currentTile = obstacle2Tile;
        }
        else if(levelArray[j][k] == "obstacle3"){
          currentTile = obstacle3Tile;
        }
        else if(levelArray[j][k] == "obstacle4"){
          currentTile = obstacle4Tile;
        }
        else if(levelArray[j][k] == "obstacle5"){
          currentTile = obstacle5Tile;
        }
        else if(levelArray[j][k] == "obstacle6"){
          currentTile = obstacle6Tile;
        }
        else if(levelArray[j][k] == "terrain1"){
          currentTile = terrain1Tile;
        }
        else if(levelArray[j][k] == "terrain2"){
          currentTile = terrain2Tile;
        }
        else if(levelArray[j][k] == "terrain3"){
          currentTile = terrain3Tile;
        }
        else if(levelArray[j][k] == "terrain4"){
          currentTile = terrain4Tile;
        }
        else if(levelArray[j][k] == "terrain5"){
          currentTile = terrain5Tile;
        }
        //Updating the tilemap to represent the new array that has just been generated.
        map.putTile(currentTile, layer.getTileX(j*32), layer.getTileY(k*32));
        map.putTile(terrain5Tile,layer.getTileX(0), layer.getTileY(0));
        map.putTile(terrain5Tile,layer.getTileX(0), layer.getTileY(32));
        map.putTile(terrain5Tile,layer.getTileX(0), layer.getTileY(64));
        map.putTile(terrain5Tile,layer.getTileX(0), layer.getTileY(96));
        map.putTile(terrain5Tile,layer.getTileX(0), layer.getTileY(128));
        map.putTile(terrain5Tile,layer.getTileX(0), layer.getTileY(160));
        map.putTile(terrain5Tile,layer.getTileX(0), layer.getTileY(192));
        map.putTile(terrain5Tile,layer.getTileX(0), layer.getTileY(224));
        map.putTile(terrain5Tile,layer.getTileX(0), layer.getTileY(256));
        map.putTile(terrain5Tile,layer.getTileX(0), layer.getTileY(288));
        map.putTile(terrain5Tile,layer.getTileX(0), layer.getTileY(320));
        map.putTile(terrain5Tile,layer.getTileX(0), layer.getTileY(352));
        map.putTile(terrain5Tile,layer.getTileX(0), layer.getTileY(384));
        map.putTile(terrain5Tile,layer.getTileX(0), layer.getTileY(416));
        map.putTile(terrain5Tile,layer.getTileX(0), layer.getTileY(448));
        map.putTile(terrain5Tile,layer.getTileX(0), layer.getTileY(512));
        map.putTile(terrain5Tile,layer.getTileX(0), layer.getTileY(544));
        map.putTile(terrain5Tile,layer.getTileX(0), layer.getTileY(576));
      }
    }
    //If the character is aloud to move, then the moveCharacter function is called.
    if(moveEnabled == "true"){
      moveCharacter();
      moveEnabled = "false"
    }
    //If the up key is pressed, then the tooltips will become hidden
    if (upKey.isDown)
    {
      for(var m =0; m <upToolTipArray.length; m++){
        sToolTipArray[m].hideTooltip();
        eToolTipArray[m].hideTooltip();
        upToolTipArray[m].hideTooltip();
        cwToolTipArray[m].hideTooltip();
        acwToolTipArray[m].hideTooltip();
        _1ToolTipArray[m].hideTooltip();
        _2ToolTipArray[m].hideTooltip();
        _3ToolTipArray[m].hideTooltip();
        _4ToolTipArray[m].hideTooltip();
        _5ToolTipArray[m].hideTooltip();
      }
    }
    //If the down key is pressed, then the tooltips will become hidden
    else if (downKey.isDown)
    {
      for(var n =0; n <upToolTipArray.length; n++){
        sToolTipArray[n].showTooltip();
        sToolTipArray[n].simulateOnHoverOut();
        eToolTipArray[n].showTooltip();
        eToolTipArray[n].simulateOnHoverOut();
        upToolTipArray[n].showTooltip();
        upToolTipArray[n].simulateOnHoverOut();
        cwToolTipArray[n].showTooltip();
        cwToolTipArray[n].simulateOnHoverOut();
        acwToolTipArray[n].showTooltip();
        acwToolTipArray[n].simulateOnHoverOut();
        _1ToolTipArray[n].showTooltip();
        _1ToolTipArray[n].simulateOnHoverOut();
        _2ToolTipArray[n].showTooltip();
        _2ToolTipArray[n].simulateOnHoverOut();
        _3ToolTipArray[n].showTooltip();
        _3ToolTipArray[n].simulateOnHoverOut();
        _4ToolTipArray[n].showTooltip();
        _4ToolTipArray[n].simulateOnHoverOut();
        _5ToolTipArray[n].showTooltip();
        _5ToolTipArray[n].simulateOnHoverOut();
      }
    }
  }
  //Function that is called when the Anti-Clockwise symbol is placed.
  //The function checks if it has been placed in a valid position.
  //If the object is not in a valid position it is returned to the side bar menu.
  function onDragStopAnti(sprite, pointer){
    if (sprite.x <  960 || sprite.x > 1280)
    {
      sprite.x = 768;
      sprite.y = 96;
    }
    group.forEach(function(item){
      if(item.y == sprite.y){
        if(item.name == "startP" || item.name == "start" || item.name == "end" || item.name == "endP"){
          sprite.x = 768;
          sprite.y = 96;
          return;
        }
      }
    }
                  ,this);
  }
  //Function that is called when the Clockwise symbol is placed.
  //The function checks if it has been placed in a valid position.
  //If the object is not in a valid position it is returned to the side bar menu.
  function onDragStopClock(sprite, pointer){
    if (sprite.x <  960 || sprite.x > 1280)
    {
      sprite.x = 768;
      sprite.y = 128;
    }
    group.forEach(function(item){
      if(item.y == sprite.y){
        if(item.name == "startP" || item.name == "start" || item.name == "end" || item.name == "endP"){
          sprite.x = 768;
          sprite.y = 128;
          return;
        }
      }
    }
                  ,this);
  }
  //Function for when a objects is started to be dragged on the screen.
  function onDragStart(sprite, pointer) {
    //result = "Dragging " + sprite.x;
  }
  //Function that is called when the Up arrow symbol is placed.
  //The function checks if it has been placed in a valid position.
  //If the object is not in a valid position it is returned to the side bar menu.
  function onDragStopUpArrow(sprite, pointer){
    if (sprite.x <  960 || sprite.x > 1280)
    {
      sprite.x = 768;
      sprite.y = 64;
    }
    else{
      upArrowTip.hideTooltip();
    }
    group.forEach(function(item){
      if(item.y == sprite.y){
        if(item.name == "startP" || item.name == "start" || item.name == "end" || item.name == "endP"){
          sprite.x = 768;
          sprite.y = 64;
          return;
        }
      }
    }
                  ,this);
  }
  //Function that is called when the End symbol is placed.
  //The function checks if it has been placed in a valid position.
  //If the object is not in a valid position it is returned to the side bar menu.s
  function onDragStopEnd(sprite, pointer){
    if (sprite.x <  960 || sprite.x > 1280)
    {
      if(sprite.name == "end"){
        sprite.x = 768;
        sprite.y = 32;
      }
    }
    var numS = 0;
    var numE = 0;
    var valid = "true";
    var xToCheck = sprite.x;
    var yToCheck = sprite.y;
    group.forEach(function(item)
                  {
      if(item.name == "start" && item.y != 0){
        if(sprite.x != item.x){
          valid = "false";
        }
        if(item.name != "start"){
          valid = "false";
        }
        if(sprite.y < item.y){
          valid = "false"
        }
        if(sprite.y == (item.y+32)){
          valid = "false"
        }
        if(valid == "false"){
          sprite.x= 768;
          sprite.y = 32;
        }
        else{
          item.name = "startP";
        }
      }
      valid = "true";
    }
                  ,this);
  }
  //Function that is called when the Start symbol is placed.
  //The function checks if it has been placed in a valid position.
  //If the object is not in a valid position it is returned to the side bar menu.
  function onDragStopStart(sprite, pointer){
    if (sprite.x <  960 || sprite.x > 1280)
    {
      if(sprite.name == "start"){
        sprite.x = 768;
        sprite.y = 0;
        sprite.name = "start";
      }
    }
  }
  //Function that is called when the number 9 symbol is placed.
  //The function checks if it has been placed in a valid position.
  //If the object is not in a valid position it is returned to the side bar menu.
  function onDragStopNum9(sprite, pointer){
    if (sprite.x <  960 || sprite.x > 1216)
    {
      if(sprite.name == "9"){
        console.log(sprite.name);
        sprite.x = 768;
        sprite.y = 416;
      }
    }
    var xToCheck = sprite.x;
    var yToCheck = sprite.y;
    var found = "false";
    group.forEach(function(item){
      if(item.name == "startP"){
        if(item.x == (xToCheck-32) && item.y == yToCheck){
          found = true;
        }
      }
    }
                  ,this);
    if(found == "false"){
      sprite.x = 768;
      sprite.y = 416;
    }
  }
  //Function that is called when the number 8 symbol is placed.
  //The function checks if it has been placed in a valid position.
  //If the object is not in a valid position it is returned to the side bar menu.
  function onDragStopNum8(sprite, pointer){
    if (sprite.x <  960 || sprite.x > 1216)
    {
      if(sprite.name == "8"){
        console.log(sprite.name);
        sprite.x = 768;
        sprite.y = 384;
      }
    }
    var xToCheck = sprite.x;
    var yToCheck = sprite.y;
    var found = "false";
    group.forEach(function(item){
      if(item.name == "startP"){
        if(item.x == (xToCheck-32) && item.y == yToCheck){
          found = true;
        }
      }
    }
                  ,this);
    if(found == "false"){
      sprite.x = 768;
      sprite.y = 384;
    }
  }
  //Function that is called when the number 7 symbol is placed.
  //The function checks if it has been placed in a valid position.
  //If the object is not in a valid position it is returned to the side bar menu.
  function onDragStopNum7(sprite, pointer){
    if (sprite.x <  960 || sprite.x > 1216)
    {
      if(sprite.name == "7"){
        console.log(sprite.name);
        sprite.x = 768;
        sprite.y = 352;
      }
    }
    var xToCheck = sprite.x;
    var yToCheck = sprite.y;
    var found = "false";
    group.forEach(function(item){
      if(item.name == "startP"){
        if(item.x == (xToCheck-32) && item.y == yToCheck){
          found = true;
        }
      }
    }
                  ,this);
    if(found == "false"){
      sprite.x = 768;
      sprite.y = 352;
    }
  }
  //Function that is called when the number 6 symbol is placed.
  //The function checks if it has been placed in a valid position.
  //If the object is not in a valid position it is returned to the side bar menu.
  function onDragStopNum6(sprite, pointer){
    if (sprite.x <  960 || sprite.x > 1216)
    {
      if(sprite.name == "6"){
        console.log(sprite.name);
        sprite.x = 768;
        sprite.y = 320;
      }
    }
    var xToCheck = sprite.x;
    var yToCheck = sprite.y;
    var found = "false";
    group.forEach(function(item){
      if(item.name == "startP"){
        if(item.x == (xToCheck-32) && item.y == yToCheck){
          found = true;
        }
      }
    }
                  ,this);
    if(found == "false"){
      sprite.x = 768;
      sprite.y = 320;
    }
  }
  //Function that is called when the number 5 symbol is placed.
  //The function checks if it has been placed in a valid position.
  //If the object is not in a valid position it is returned to the side bar menu.
  function onDragStopNum5(sprite, pointer){
    if (sprite.x <  960 || sprite.x > 1216)
    {
      if(sprite.name == "5"){
        console.log(sprite.name);
        sprite.x = 768;
        sprite.y = 288;
      }
    }
    var xToCheck = sprite.x;
    var yToCheck = sprite.y;
    var found = "false";
    group.forEach(function(item){
      if(item.name == "startP"){
        if(item.x == (xToCheck-32) && item.y == yToCheck){
          found = true;
        }
      }
    }
                  ,this);
    if(found == "false"){
      sprite.x = 768;
      sprite.y = 288;
    }
  }
  //Function that is called when the number 4 symbol is placed.
  //The function checks if it has been placed in a valid position.
  //If the object is not in a valid position it is returned to the side bar menu.
  function onDragStopNum4(sprite, pointer){
    if (sprite.x <  960 || sprite.x > 1216)
    {
      if(sprite.name == "4"){
        console.log(sprite.name);
        sprite.x = 768;
        sprite.y = 256;
      }
    }
    var xToCheck = sprite.x;
    var yToCheck = sprite.y;
    var found = "false";
    group.forEach(function(item){
      if(item.name == "startP"){
        if(item.x == (xToCheck-32) && item.y == yToCheck){
          found = true;
        }
      }
    }
                  ,this);
    if(found == "false"){
      sprite.x = 768;
      sprite.y = 256;
    }
  }
  //Function that is called when the number 3 symbol is placed.
  //The function checks if it has been placed in a valid position.
  //If the object is not in a valid position it is returned to the side bar menu.
  function onDragStopNum3(sprite, pointer){
    if (sprite.x <  960 || sprite.x > 1216)
    {
      if(sprite.name == "3"){
        console.log(sprite.name);
        sprite.x = 768;
        sprite.y = 224;
      }
    }
    var xToCheck = sprite.x;
    var yToCheck = sprite.y;
    var found = "false";
    group.forEach(function(item){
      if(item.name == "startP"){
        if(item.x == (xToCheck-32) && item.y == yToCheck){
          found = true;
        }
      }
    }
                  ,this);
    if(found == "false"){
      sprite.x = 768;
      sprite.y = 224;
    }
  }
  //Function that is called when the number 2 symbol is placed.
  //The function checks if it has been placed in a valid position.
  //If the object is not in a valid position it is returned to the side bar menu.
  function onDragStopNum2(sprite, pointer){
    if (sprite.x <  960 || sprite.x > 1216)
    {
      if(sprite.name == "2"){
        console.log(sprite.name);
        sprite.x = 768;
        sprite.y = 192;
      }
    }
    var xToCheck = sprite.x;
    var yToCheck = sprite.y;
    var found = "false";
    group.forEach(function(item){
      if(item.name == "startP"){
        if(item.x == (xToCheck-32) && item.y == yToCheck){
          found = true;
        }
      }
    }
                  ,this);
    if(found == "false"){
      sprite.x = 768;
      sprite.y = 192;
    }
  }
  //Function that is called when the number 1 symbol is placed.
  //The function checks if it has been placed in a valid position.
  //If the object is not in a valid position it is returned to the side bar menu.
  function onDragStopNum1(sprite, pointer){
    if (sprite.x <  960 || sprite.x > 1216)
    {
      if(sprite.name == "1"){
        sprite.x = 768;
        sprite.y = 160;
      }
    }
    var xToCheck = sprite.x;
    var yToCheck = sprite.y;
    var found = "false";
    group.forEach(function(item){
      if(item.name == "startP"){
        if(item.x == (xToCheck-32) && item.y == yToCheck){
          found = true;
        }
      }
    }
                  ,this);
    if(found == "false"){
      sprite.x = 768;
      sprite.y = 160;
    }
  }
  //Function that is called when the Phaser button is pressed.
  //This function sets up the arrays that will be used to parse the symbols that have been placed on the screen.
  function actionOnClick(){
    moveEnabled = "true"
    commandArray = [];
    commmandCoorArray = [];
    for(var y = 0; y < 961; y = y + 32){
      for(var x = 960; x < 1281; x = x +32){
        group.forEach(function(item){
          if(item.x == x && item.y == y){
            commandArray.push(item.name);
            commmandCoorArray.push(item.x);
          }
        }
                      ,this);
      }
    }
    numOfSymbol = 0;
    for(var z = 0; z < commandArray.length; z++){
      if(commandArray[z] == "up" || commandArray[z] == "clockwise" || commandArray[z] == 'anticlockwise'){
        numOfSymbol++;
      }
    }
    commandArrayResult = filterArray();
    moveEnabled = "true";
  }
  //This function hadnles the time loop that is used to delay movements of the character
  function moveCharacter(){
    winner = "false";
    moveEnabled = "false";
    var i = 0;
    //Loop that will done until the character is done moving and all the move commands have been read through.
    //A pause time of 1 second per movement is used.
    var intervalId = setInterval(function(){
      if(i === commandArrayResult.length){
        clearInterval(intervalId);
        if(winner == "false"){
          resetLevel();
        }
      }
      processMovement(i)
      i++;
    }
                                 , 1000);
  }
  //This function is responsible for moving the character around the screen. Depending on which direction the character is facing, will decide which values
  //in the array representing the level will ba changed.
  //The tile the character will move onto is stored so it can be put back in place once the character has moved off it again.
  //If the character finishes on what is called a goal section, then the ability to move to the next level is activated.
  function processMovement(i){
    update();
    if(commandArrayResult[i] == "up"){
      if(firstMove == "yes"){
        firstMove = "no"
        if(characterDirection == "up"){
          tileOnTopOf = levelArray[characterX][characterY-1];
          if(tileOnTopOf.indexOf("goal") > -1){
            document.getElementById("nextLevel").disabled = false;
            levelArray[characterX][characterY-1] = characterName;
            levelArray[characterX][characterY] = terrainTile;
            button.inputEnabled = false;
            winner = "true";
            alert("WINNER")
          }
          else if(tileOnTopOf.indexOf("obstacle") > -1){
            alert("INCORRECT");
            resetLevel()
          }
          levelArray[characterX][characterY-1] = characterName;
          levelArray[characterX][characterY] = terrainTile;
          characterY = characterY-1;
        }
        else if(characterDirection == "right"){
          tileOnTopOf = levelArray[characterX+1][characterY];
          if(tileOnTopOf.indexOf("goal") > -1){
            document.getElementById("nextLevel").disabled = false;
            levelArray[characterX+1][characterY] = characterName;
            levelArray[characterX][characterY] = terrainTile;
            button.inputEnabled = false;
            winner = "true";
            alert("WINNER")
          }
          else if(tileOnTopOf.indexOf("obstacle") > -1){
            alert("INCORRECT");
            resetLevel()
          }
          levelArray[characterX+1][characterY] = characterName;
          levelArray[characterX][characterY] = terrainTile;
          characterX = characterX+1;
        }
        else if(characterDirection == "down"){
          tileOnTopOf = levelArray[characterX][characterY+1];
          if(tileOnTopOf.indexOf("goal") > -1){
            document.getElementById("nextLevel").disabled = false;
            levelArray[characterX][characterY+1] = characterName;
            levelArray[characterX][characterY] = terrainTile;
            button.inputEnabled = false;
            winner = "true";
            alert("WINNER")
          }
          else if(tileOnTopOf.indexOf("obstacle") > -1){
            alert("INCORRECT");
            resetLevel()
          }
          levelArray[characterX][characterY+1] = characterName;
          levelArray[characterX][characterY] = terrainTile;
          characterY = characterY+1;
        }
        else if(characterDirection == "left"){
          tileOnTopOf = levelArray[characterX-1][characterY];
          if(tileOnTopOf.indexOf("goal") > -1){
            document.getElementById("nextLevel").disabled = false;
            levelArray[characterX-1][characterY] = characterName;
            levelArray[characterX][characterY] = terrainTile;
            button.inputEnabled = false;
            winner = "true";
            alert("WINNER")
          }
          else if(tileOnTopOf.indexOf("obstacle") > -1){
            alert("INCORRECT");
            resetLevel()
          }
          levelArray[characterX-1][characterY] = characterName;
          levelArray[characterX][characterY] = terrainTile;
          characterX = characterX-1;
        }
      }
      else{
        if(characterDirection == "up"){
          tileOnTopOfTemp = levelArray[characterX][characterY-1];
          if(tileOnTopOfTemp.indexOf("goal") > -1){
            document.getElementById("nextLevel").disabled = false;
            levelArray[characterX][characterY-1] = characterName;
            levelArray[characterX][characterY] = tileOnTopOf;
            button.inputEnabled = false;
            winner = "true";
            alert("WINNER")
          }
          else if(tileOnTopOfTemp.indexOf("obstacle") > -1){
            alert("INCORRECT");
            resetLevel()
          }
          levelArray[characterX][characterY-1] = characterName;
          levelArray[characterX][characterY] = tileOnTopOf;
          tileOnTopOf = tileOnTopOfTemp;
          characterY = characterY-1;
        }
        else if(characterDirection == "right"){
          tileOnTopOfTemp = levelArray[characterX+1][characterY];
          if(tileOnTopOfTemp.indexOf("goal") > -1){
            document.getElementById("nextLevel").disabled = false;
            levelArray[characterX+1][characterY] = characterName;
            levelArray[characterX][characterY] = tileOnTopOf;
            button.inputEnabled = false;
            winner = "true";
            alert("WINNER")
          }
          else if(tileOnTopOfTemp.indexOf("obstacle") > -1){
            alert("INCORRECT");
            resetLevel()
          }
          levelArray[characterX+1][characterY] = characterName;
          levelArray[characterX][characterY] = tileOnTopOf;
          tileOnTopOfTemp = tileOnTopOfTemp;
          characterX = characterX+1
        }
        else if(characterDirection == "down"){
          tileOnTopOfTemp = levelArray[characterX][characterY+1];
          if(tileOnTopOfTemp.indexOf("goal") > -1){
            document.getElementById("nextLevel").disabled = false;
            levelArray[characterX][characterY+1] = characterName;
            levelArray[characterX][characterY] = tileOnTopOf;
            button.inputEnabled = false;
            winner = "true";
            alert("WINNER")
          }
          else if(tileOnTopOfTemp.indexOf("obstacle") > -1){
            alert("INCORRECT");
            resetLevel()
          }
          levelArray[characterX][characterY+1] = characterName;
          levelArray[characterX][characterY] = tileOnTopOf;
          tileOnTopOfTemp = tileOnTopOfTemp;
          characterY = characterY+1
        }
        else if(characterDirection == "left"){
          tileOnTopOfTemp = levelArray[characterX-1][characterY];
          if(tileOnTopOfTemp.indexOf("goal") > -1){
            document.getElementById("nextLevel").disabled = false;
            levelArray[characterX-1][characterY] = characterName;
            levelArray[characterX][characterY] = tileOnTopOf;
            button.inputEnabled = false;
            winner = "true";
            alert("WINNER")
          }
          else if(tileOnTopOfTemp.indexOf("obstacle") > -1){
            alert("INCORRECT");
            resetLevel()
          }
          levelArray[characterX-1][characterY] = characterName;
          levelArray[characterX][characterY] = tileOnTopOf;
          tileOnTopOf = tileOnTopOfTemp;
          characterX = characterX-1
        }
      }
      //If a clockwise or anticlockwise symbol is being read then the current direction that the character is facing changes.
    }
    else if(commandArrayResult[i] == "clockwise"){
      if(characterDirection == "up"){
        characterDirection = "right"
      }
      else if(characterDirection == "right"){
        characterDirection = "down"
      }
      else if(characterDirection == "down"){
        characterDirection = "left"
      }
      else if(characterDirection == "left"){
        characterDirection = "up"
      }
    }
    else if(commandArrayResult[i] == "anticlockwise"){
      if(characterDirection == "up"){
        characterDirection = "left"
      }
      else if(characterDirection == "right"){
        characterDirection = "up"
      }
      else if(characterDirection == "down"){
        characterDirection = "right"
      }
      else if(characterDirection == "left"){
        characterDirection = "down";
      }
    }
  }
  //This function parses and simplifies a list that contains all symbols that were placed on the screen.
  //Goes through the list until only up arrows, and rotating symbols are left.
  function filterArray(){
    var Sslot;
    var Numslot;
    var loopNumber;
    var Eslot;
    var found = "false"
    //Gets loop number from loop structure that was placed on the screen
    for (var i = 0; i < commandArray.length; i++){
      if(commandArray[i] == "startP"){
        found = "true"
        Sslot = i;
        Numslot = i+1;
        if(commandArray[i+1] == "1"){
          loopNumber  = 1;
        }
        else if(commandArray[i+1] == "2"){
          loopNumber = 2
        }
        else if(commandArray[i+1] == "3"){
          loopNumber = 3;
        }
        else if(commandArray[i+1] == "4"){
          loopNumber = 4;
        }
        else if(commandArray[i+1] == "5"){
          loopNumber = 5;
        }
        else if(commandArray[i+1] == "6"){
          loopNumber = 6;
        }
        else if(commandArray[i+1] == "7"){
          loopNumber = 7;
        }
        else if(commandArray[i+1] == "8"){
          loopNumber = 8;
        }
        else if(commandArray[i+1] == "9"){
          loopNumber = 9;
        }
        break;
      }
    }
    if(found == "true"){
      for(var j = commandArray.length-1; j > 0; j--){
        if(commandArray[j] == "end"){
          if(commmandCoorArray[Sslot] == commmandCoorArray[j]){
            Eslot = j;
            break;
          }
        }
      }
      //Defining arrays that will be used to filter down the array of symbols
      var firstPartArray = [];
      var middlePartArray = [];
      var endPartArray = [];
      var newCommandArray = [];
      var firstCoorArray = [];
      var middleCoorArray = [];
      var endCoorArray = [];
      var newCoorArray = [];
      //Splits the array of symbols into a start, middle and end section of a loop.
      firstPartArray.push(commandArray.slice(0,Sslot));
      middlePartArray.push(commandArray.slice(Numslot+1, Eslot));
      endPartArray.push(commandArray.slice(Eslot+1, commandArray.length));
      firstCoorArray.push(commmandCoorArray.slice(0,Sslot));
      middleCoorArray.push(commmandCoorArray.slice(Numslot+1, Eslot));
      endCoorArray.push(commmandCoorArray.slice(Eslot+1, commmandCoorArray.length));
      var combinedMiddle = [];
      var combinedCoorMiddle  = [];
      //Duplicates everything that was inside the loop, the number of times the loop would run for
      for(var m =0; m < loopNumber; m++){
        for(var p = 0; p < middlePartArray.length; p++){
          combinedMiddle = combinedMiddle.concat(middlePartArray[p]);
          combinedCoorMiddle = combinedCoorMiddle.concat(middleCoorArray[p]);
        }
      }
      var addionatalCounter = 1;
      for(var n1 = 0; n1 < combinedMiddle.length; n1++){
        if(combinedMiddle[n1] == "startP"){
          combinedCoorMiddle[n1] += addionatalCounter;
        }
        if(combinedMiddle[n1] == "end"){
          combinedCoorMiddle[n1] += addionatalCounter;
          addionatalCounter++;
        }
      }
      //Sets up new array of symbols, that is either the finished soluion, or a list that is still being altered.
      for(var n = 0; n < firstPartArray.length; n++){
        newCommandArray = newCommandArray.concat(firstPartArray[n]);
        newCoorArray = newCoorArray.concat(firstCoorArray[n]);
      }
      for(var p1 = 0; p1 < combinedMiddle.length; p1++){
        newCommandArray = newCommandArray.concat(combinedMiddle[p1]);
        newCoorArray = newCoorArray.concat(combinedCoorMiddle[p1]);
      }
      for(var q = 0; q < endPartArray.length; q++){
        newCommandArray = newCommandArray.concat(endPartArray[q]);
        newCoorArray = newCoorArray.concat(endCoorArray[q]);
      }
      commandArray = newCommandArray;
      commmandCoorArray = newCoorArray;
      //If there are still symbols that still need to be removed, the function is called again.	
      if(found == "true"){
        filterArray();
      }
    }
    return commandArray;
  }
  function render() {
  }
</script>
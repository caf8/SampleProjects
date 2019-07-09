<?php
//Retriveing information from the form that launched the PHP file.
$username = $_POST["teacher_name"];
$level_name = $_POST["level_name"];
$difficulty = $_POST["difficulty"];
$skin = $_POST["skin"];
?>
<html>
  <style>
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
  </style>
  <!--This form when submitted lauches PHP file where the teacher assigns the level they just built to a user-->
  <!--Form uses POST to keep account details hidden-->
  <form action="AssignLevelsOnly.php" method="POST"> 
    <input type="hidden" id='level_solution' name="level_solution" readonly>
    <input  type="hidden" id="mapDetail" name="mapDetail" readonly>
    <input  type="hidden" id="teacher_name" name ="teacher_name" value = "<?php echo $_POST['teacher_name'] ?>">
    <input  type="hidden" id="level_name" name="level_name" value= "<?php echo $_POST['level_name'] ?>">
    <input  type="hidden" id="difficulty" name="difficulty" value= "<?php echo $_POST['difficulty'] ?>">
    <input  type="hidden" id="skin" name="skin" value= "<?php echo $_POST['skin'] ?>">
    <input  type="hidden" id="AddLevel" name="AddLevel" value= "newLevel">
    <input  type="submit" value="Submit">
  </form> 
  <a href="https://caf8.host.cs.st-andrews.ac.uk/CS4099/homePage.html" >
    <img  src="home.png" alt="University Logo" style="width: 50px; position: absolute; right: 30px; top: 5px">
  </a>
</html>
<!--Including the Phaser framework in the page-->
<script type="text/javascript" src="lib/phaser.js">
</script>
<script>
  //Defining Phaser game.
  //Sets size of game, and the create and update functions
  var game = new Phaser.Game(1600, 576, Phaser.CANVAS, 'phaser-example', {
    preload: preload, create: create, update: update, render: render }
                            );
  //Preload function is run when the page is loaded.
  function preload() {
    //Loads different json file depending on what option was selected on the previous page.
    //The different json files represent different json files
    if(<?php echo json_encode($skin);
    ?> == 'Tileset1'){
      game.load.tilemap('desert', 'TileMap1.json', null, Phaser.Tilemap.TILED_JSON);
    }
    else if(<?php echo json_encode($skin);
    ?> == 'Tileset2'){
      game.load.tilemap('desert', 'TileMap2.json', null, Phaser.Tilemap.TILED_JSON);
    }
    else if(<?php echo json_encode($skin);
    ?> == 'Tileset3'){
      game.load.tilemap('desert', 'TileMap3.json', null, Phaser.Tilemap.TILED_JSON);
    }
    else if(<?php echo json_encode($skin);
    ?> == 'Tileset4'){
      game.load.tilemap('desert', 'TileMap4.json', null, Phaser.Tilemap.TILED_JSON);
    }
    else if(<?php echo json_encode($skin);
    ?> == 'Tileset5'){
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
  //Defining global varaiables to be used throught the page.
  var map;
  var layer;
  var marker;
  var currentTile;
  var tempTile;
  var checkTile;
  var cursors;
  var myArray = new Array(24);
  var compressedMyArray;
  var compressedMapDetail;
  var finalcompressedMyArray;
  var finalcompreseedMapDetail;
  var markerDestroyed = "false"
  var commandArray = [];
  var commmandCoorArray = [];
  var result = '';
  var itemSelected = "";
  var instruction1 = "To draw with a tile, \nhold down shift and click on a \ntile from the pallet.";
  var instruction2 = "To draw with a tile, hold down \nthe left mouse button and \nmove the mouse across the \nMap Area.";
  var instruction3 = "The colour of the marker, \nshows the type of tile selected: \nBlue = Chracter; Red = Goal; \nGreen = Obstacle; and \nMagenta = Terrain";
  var instruction4 = "To move an input object click \nthe mouse on a symbol and \ndrag it to the green area.";
  var instruction5 = "To find out more information \nabout each symbol have a \nlook at the tooltips! To \nactivate the tooltips press the \ndown key, to deactivate them \nthe up key";
  var instruction6 = "To input solution click run!";
  //Creating and filling 2D array that will be used store level details
  for (i=0; i < 24; i++){
    myArray[i]=new Array(18);
  }
  for (var j = 0; j < 24; j++){
    for (var k = 0; k < 18; k++){
      myArray[j][k] = "";
    }
  }
  //Create functions runs after the preloads function.
  //The create function defines and creates the tilemap that is used to create the level.
  //The create function also defines and creates the input objects. 
  function create() {
    var background =  game.add.sprite(0, 0, 'grid');
    //Creating a group that the objects will be added too.
    group = game.add.group();
    group.inputEnableChildren = true;
    //Adding the structure of the tileset to the map
    map = game.add.tilemap('desert');
    text1 = game.add.text(1320, 0, instruction1, {
      font: "16px; Arial", fill: "orange" }
                         );
    text2 = game.add.text(1320, 80, instruction2, {
      font: "16px; Arial", fill: "orange" }
                         );
    text3 = game.add.text(1320, 192, instruction3, {
      font: "16px; Arial", fill: "orange" }
                         );
    text4 = game.add.text(1320, 320, instruction4, {
      font: "16px; Arial", fill: "orange" }
                         );
    text5 = game.add.text(1320, 394, instruction6, {
      font: "16px; Arial", fill: "orange" }
                         );

                    
    //Conditional structure that is used to set the skin that will be used on the tileset
    //PHP used to get the information to decide this from the form that launched the page.
    if(<?php echo json_encode($skin);
    ?> == 'Tileset1'){
      map.addTilesetImage('characters2','characterTiles')
      map.addTilesetImage('white', 'basicColours');
      map.addTilesetImage('characters', 'tiles1');
      map.addTilesetImage('terrain', 'tiles');
    }
    else if(<?php echo json_encode($skin);
    ?> == 'Tileset2'){
      map.addTilesetImage('characters2','characterTiles');
      map.addTilesetImage('whiteTileSet2', 'basicColours');
      map.addTilesetImage('characters', 'tiles1');
      map.addTilesetImage('terrain', 'tiles');
    }
    else if(<?php echo json_encode($skin);
    ?> == 'Tileset3'){
      map.addTilesetImage('character2','characterTiles');
      map.addTilesetImage('white', 'basicColours');
      map.addTilesetImage('characters', 'tiles1');
      map.addTilesetImage('terrain', 'tiles');
    }
    else if(<?php echo json_encode($skin);
    ?> == 'Tileset4'){
      map.addTilesetImage('white', 'basicColours');
      map.addTilesetImage('colours', 'tile2');
    }
    else if(<?php echo json_encode($skin);
    ?> == 'Tileset5'){
      map.addTilesetImage('white', 'basicColours');
      map.addTilesetImage('colours', 'tile2');
    }
    currentTile = map.getTile(1, 3);
    //Add layer to the tilemap.
    layer = map.createLayer('Ground');
    //Add phaser button to the page, that when clicked on, launches the function actionOnClick
    //Then adds button to the group.
    var button = game.make.button(770, 490, 'button', actionOnClick, this, 2, 1, 0);
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
    }
    //Adding marker that is used to select tiles to place from the tilemap
    marker = game.add.graphics();
    marker.lineStyle(2, 0x000000, 1);
    marker.drawRect(0, 0, 32, 32);
    marker.lineStyle(10, 0x456325, 1);
    cursors = game.input.keyboard.createCursorKeys();
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
      // console.log('input disabled on', sprite.key);
      // sprite.input.enabled = false;
      // if(sprite.name == "up"){
      sprite.x = 768;
      sprite.y = 64;
      // }
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
  //If the object is not in a valid position it is returned to the side bar menu.
  function onDragStopEnd(sprite, pointer){
    if (sprite.x <  960 || sprite.x > 1280)
    {
      if(sprite.name == "end"){
        console.log("Helllloooooo");
        sprite.x = 768;
        sprite.y = 32;
      }
    }
    console.log("TEST");
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
    commandArrayResult = filterArray();
    moveEnabled = "true";
  }
  //This function parses and simplifies a list that contains all symbols that were placed on the screen.
  //Goes through the list until only up arrows, and rotating symbols are left.
  function filterArray(){
    var Sslot;
    var Numslot;
    var loopNumber;
    var Eslot;
    var found = "false"
    for (var i = 0; i < commandArray.length; i++){
      if(commandArray[i] == "startP"){
        found = "true"
        Sslot = i;
        Numslot = i+1;
        //Gets loop number from loop structure that was placed on the screen
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
    document.getElementById("level_solution").value = commandArray;
    return commandArray;
  }
  //This function runs continously on the webpage. It updates the state of the game, including the tile map and objects.
  function update() {
    //Checks if the cursor of the user is in the part of the screen tiles can be selected from.
    //If the cursor is not in this area, destroy the marker. Else create the marker again.
    //Colour of marker represents the type of tile selected; Character, goal, obstacle or terrain.
    if(game.input.mousePointer.x < 768){
      if(markerDestroyed == "true"){
        markerDestroyed = "false";
        if(itemSelected.indexOf("character") > -1){
          marker = game.add.graphics();
          marker.lineStyle(4, 0x3465A4, 1);
          marker.drawRect(0, 0, 32, 32);
        }
        else if(itemSelected.indexOf("goal") > -1){
          marker = game.add.graphics();
          marker.lineStyle(4, 0xff0000, 1);
          marker.drawRect(0, 0, 32, 32);
        }
        else if(itemSelected.indexOf("obstacle") > -1){
          marker = game.add.graphics();
          marker.lineStyle(4, 0xff00, 1);
          marker.drawRect(0, 0, 32, 32);
        }
        else if(itemSelected.indexOf("terrain") > -1){
          marker = game.add.graphics();
          marker.lineStyle(4, 0xff00ff, 1);
          marker.drawRect(0, 0, 32, 32);
        }
      }
      //Gets the current position of the marker on the screen,
      marker.x = layer.getTileX(game.input.activePointer.worldX) * 32;
      marker.y = layer.getTileY(game.input.activePointer.worldY) * 32;
      //When the mouse is clicked, the tile the mouse was clicked on becomes the currentyl selected tile
      if (game.input.mousePointer.isDown)
      {
        if (game.input.keyboard.isDown(Phaser.Keyboard.SHIFT))
        {
          tempTile = map.getTile(layer.getTileX(marker.x), layer.getTileY(marker.y));
          if(tempTile.x == 0){
            currentTile = map.getTile(layer.getTileX(marker.x), layer.getTileY(marker.y));
          }
          else{
          }
        }
        else
        {
          checkTile = map.getTile(layer.getTileX(marker.x), layer.getTileY(marker.y));
          //If a tile has been selected, sets and identifier for which tile has been selected.
          if (map.getTile(layer.getTileX(marker.x), layer.getTileY(marker.y)).index != currentTile.index && checkTile.x != 0)
          {
            var tileType = "";
            if(currentTile.y == 0){
              tileType = "character1";
              itemSelected = "character";
              marker.destroy();
              markerDestroyed = "true";
            }
            else if(currentTile.y == 1){
              tileType = "character2";
              itemSelected = "character";
              marker.destroy();
              markerDestroyed = "true";
            }
            else if(currentTile.y == 2){
              tileType = "character3";
              itemSelected = "character";
              marker.destroy();
              markerDestroyed = "true";
            }
            else if(currentTile.y == 3){
              tileType = "character4";
              itemSelected = "character";
              marker.destroy();
              markerDestroyed = "true";
            }
            else if(currentTile.y == 4){
              tileType = "character5";
              itemSelected = "character";
              marker.destroy();
              markerDestroyed = "true";
            }
            else if(currentTile.y == 5){
              tileType = "goal1";
              itemSelected = "goal"
              marker.destroy();
              markerDestroyed = "true";
            }
            else if(currentTile.y == 6){
              tileType = "goal2";
              itemSelected = "goal"
              marker.destroy();
              markerDestroyed = "true";
            }
            else if(currentTile.y == 7){
              tileType = "obstacle1";
              itemSelected = "obstacle"
              marker.destroy();
              markerDestroyed = "true";
            }
            else if(currentTile.y == 8){
              tileType = "obstacle2";
              itemSelected = "obstacle"
              marker.destroy();
              markerDestroyed = "true";
            }
            else if(currentTile.y == 9){
              tileType = "obstacle3";
              itemSelected = "obstacle"
              marker.destroy();
              markerDestroyed = "true";
            }
            else if(currentTile.y == 10){
              tileType = "obstacle4";
              itemSelected = "obstacle"
              marker.destroy();
              markerDestroyed = "true";
            }
            else if(currentTile.y == 11){
              tileType = "obstacle5";
              itemSelected = "obstacle"
              marker.destroy();
              markerDestroyed = "true";
            }
            else if(currentTile.y == 12){
              tileType = "obstacle6";
              itemSelected = "obstacle"
              marker.destroy();
              markerDestroyed = "true";
            }
            else if(currentTile.y == 13){
              tileType = "terrain1";
              itemSelected = "terrain"
              marker.destroy();
              markerDestroyed = "true";
            }
            else if(currentTile.y == 14){
              tileType = "terrain2";
              itemSelected = "terrain"
              marker.destroy();
              markerDestroyed = "true";
            }
            else if(currentTile.y == 15){
              tileType = "terrian3";
              itemSelected = "terrain"
              marker.destroy();
              markerDestroyed = "true";
            }
            else if(currentTile.y == 16){
              tileType = "terrain4";
              itemSelected = "terrain"
              marker.destroy();
              markerDestroyed = "true";
            }
            else if(currentTile.y == 17){
              tileType = "terrain5";
              itemSelected = "terrain"
              marker.destroy();
              markerDestroyed = "true";
            }
            //The following code decides whether or not the selected is allowed to placed. I.e can only have one character and one goal on screen.
            var valid = "true";
            if(tileType.indexOf("character") > -1){
              for (var j = 0; j < 24; j++){
                for (var k = 0; k < 18; k++){
                  if(myArray[j][k].indexOf("character") > -1){
                    valid = "false"
                  }
                }
              }
            }
            else if(tileType.indexOf("goal") > -1){
              for (var j = 0; j < 24; j++){
                for (var k = 0; k < 18; k++){
                  if(myArray[j][k].indexOf("goal") > -1){
                    valid = "false"
                  }
                }
              }
            }
            //The tile selected and the place the tile will be placed is valid, the tile is placed.
            if(valid == "true"){
              map.putTile(currentTile, layer.getTileX(marker.x), layer.getTileY(marker.y));
              myArray[marker.x/32][marker.y/32] = tileType;
            }
            //Compresses array in order for it to be placed inside an element for the PHP form
            compressedMyArray = "";
            for (var j = 0; j < 24; j++){
              for (var k = 0; k < 18; k++){
                compressedMyArray += ("," + myArray[j][k]);
              }
              compressedMyArray += ("," + "*");
            }
            finalcompressedMyArray = compressedMyArray;
            document.getElementById("mapDetail").value = finalcompressedMyArray;
          }
        }
      }
      if (cursors.left.isDown)
      {
        game.camera.x -= 4;
      }
      else if (cursors.right.isDown)
      {
        game.camera.x += 4;
      }
      if (cursors.up.isDown)
      {
        game.camera.y -= 4;
      }
      else if (cursors.down.isDown)
      {
        game.camera.y += 4;
      }
    }
    else{
      marker.destroy()
      markerDestroyed = "true"
    }
  }
  function render() {
  }
</script>

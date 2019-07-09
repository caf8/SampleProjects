<?php
//Setting up connection to the databases
$DB_HOST = "localhost";
$DB_USER = "caf8";
$DB_PASSWORD = "wFucTKR9G2w.Qm";
$DB_NAME = "caf8_admin_centre";
$dbc = mysqli_connect($DB_HOST, $DB_USER, $DB_PASSWORD) or die (mysql_error());
mysqli_select_db($dbc,$DB_NAME);
//Retriveing information from the form that launched the PHP file.
$username = $_POST["teacher_name"];
$password = $_POST["teacher_password"];
//Setting up querry that will be used to check if the teacher exists or not
$sql_expr_str1 = "SELECT * FROM teacher where name='".$username."' and password='".$password."'" ;
$sql_expr_str1 = str_replace("\'","",$sql_expr_str1);
//Execution of querry
$result1 = mysqli_query($dbc, $sql_expr_str1);
//If there were any results returned then the teacher account exists.
if(mysqli_num_rows($result1) > 0){
//echo file_get_contents('https://caf8.host.cs.st-andrews.ac.uk/CS4099/createLevel.html');
}else{
?> 
<p> teacher login failed 
</p>
<?php 
exit(0);
}
?>
<hmtl>
  <style>
    /*
    heading and paragraph tags used to style and position text on the html page.
    */
    p1{
      color: #3465A4;
      font-weight: bold;
    }
    p2{
      color: #3465A4;
      font-weight: bold;
    }
    p3{
      color: #3465A4;
      font-weight: bold;
    }
    h3{
      color: #3465A4;
      font-size: 34px;
      font-size: 2vw;
    }
    /*
    Adds colour and position of the menus and buttons on the page.
    */
    #skin{
      color: white;
      background-color: #3465A4;
      border: 1px solid #E5E5E5;
      border-radius: 5px 5px 5px 5px;
      height: 40px;
      margin: 0 0 0 25px;
      padding: 10px;
      width: 400px;
    }
    #skin:hover{
      background-color: #8465A4;
    }
    #difficulty{
      color: white;
      background-color: #3465A4;
      border: 1px solid #E5E5E5;
      border-radius: 5px 5px 5px 5px;
      height: 40px;
      margin: 0 0 0 25px;
      padding: 10px;
      width: 400px;
    }
    #difficulty:hover{
      background-color: #8465A4;
    }
    #level_name{
      width: 400px;
    }
    input[type=submit] {
      font-size: 18px;
      font-weight: bold;
      width: 200px;
      background-color: #3465A4;
      color: white;
      padding: 14px 20px;
      margin: 8px 0;
      border: none;
      border-radius: 4px;
    }
    input[type=submit]:hover {
      background-color: #8465A4;
    }
    .levelName{
      width: 33%;
      float: right;
      height: 75px;
    }
    .levelTileset{
      width: 33%;
      float:right;
      height: 75px;
    }
    .build{
      width: 100%;
      text-align: center;
    }
    .difficulty{
      width: 33%;
      float: right;
      height: 75px;
    }
    .logo{
      width: 100%;
      height:450px;
      text-align: center;
    }
  </style>
  <!--This form when submitted lauches PHP file where it takes the teacher to the area to build levels-->
  <!--Form uses POST to keep account details hidden-->
  <div class="logo">
    <h3>Admin Centre for Customisable GBL Material
    </h3>
    <img src="Unilogo.png" alt="University Logo" style="width: 250px;">
  </div>
  <form action="buildLevels.php" method="POST";>
    <div class="levelName">
      <p1>Level Name
      </p1>
      <input type="text" autocomplete="off" id = "level_name" name="level_name" >
    </div>
    <div class="levelTileset">
      <p2>Level Tileset
      </p2>
      <select id="skin" name="skin">
        <option value="Tileset1">Tileset1
        </option>
        <option value="Tileset2">Tileset2
        </option>
        <option value="Tileset3">Tileset3
        </option>
        <option value="Tileset4">Tileset4
        </option>
        <option value="Tileset5">Tileset5
        </option>
      </select>
    </div>
    <div class="difficulty">
      <p3>Difficulty
      </p3>
      <select id = "difficulty" name="difficulty">
        <option value="1">1
        </option>
        <option value="2">2
        </option>
        <option value="3">3
        </option>
        <option value="4">4
        </option>
        <option value="5">5
        </option>
      </select>
      </select>
    </div>
  <input type="hidden" name="teacher_name" value="<?php echo $_POST['teacher_name'] ?>">
  <div class="build">
    <input type="submit" value="Build Level!">
  </div>
  </form> 
<a href="https://caf8.host.cs.st-andrews.ac.uk/CS4099/homePage.html" >
  <img  src="home.png" alt="University Logo" style="width: 50px; position: absolute; right: 30px; top: 5px">
</a>
</hmtl>
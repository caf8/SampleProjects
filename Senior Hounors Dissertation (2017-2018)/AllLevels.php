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
}else{
?> 
<p> teacher login failed 
</p>
<?php 
exit(0);
}

//Fetches all the names of levels from the Level table and places them inside an array
$levels= array();
$sql_expr_str6 = "SELECT Level_name FROM Level";
$sql_expr_str6 = str_replace("\'","",$sql_expr_str6);
$result6 = mysqli_query($dbc, $sql_expr_str6);
if(mysqli_num_rows($result6) > 0){
while($row = mysqli_fetch_array($result6)) {
array_push($levels,$row[0]);
}
}
?>
<html>
  <style>
    /*
    heading and paragraph tags used to style and position text on the html page.
    */
    h3{
      color: #3465A4;
      font-size: 34px;
      font-size: 2vw;
    }
    h1{
      color: #3465A4;
      font-size: 34px;
      font-size: 2vw;
    }
    h2{
      color: #3465A4;
      font-size: 34px;
      font-size: 2vw;
    }
    /*
    Adds colour and position of the menus and buttons on the page.
    */
    #level_name {
      color: white;
      background-color: #3465A4;
      border: 1px solid #E5E5E5;
      border-radius: 5px 5px 5px 5px;
      height: 40px;
      margin: 0 0 0 25px;
      padding: 10px;
      width: 400px;
    }
    #level_name:hover{
      background-color: #8465A4;
    }
    #currentLevelAdd{
      background-color: #3465A4;
      color: white;
      height: 40px;
      margin: 0 0 0 25px;
      padding: 10px;
      width: 200px;
    }
    #currentLevelAdd:hover{
      background-color: #8465A4;
    }
    #buildLevel{
      background-color: #3465A4;
      color: white;
      width: 200px;
      height: 40px;
      margin: 0 0 0 25px;
      padding: 10px;
      width: 200px;
    }
    #buildLevel:hover{
      background-color: #8465A4;
    }
    .logo{
      width: 100%;
      height:450px;
      text-align: center;
    }
    .dropdown{
      width: 40%;
      float: right;
    }
    .buildingLevel{
      width: 55%;
      float: right;
    }
  </style>
  <div class="logo">
    <h3>Admin Centre for Customisable GBL Material
    </h3>
    <img src="Unilogo.png" alt="University Logo" style="width: 250px;">
  </div>
  <a href="https://caf8.host.cs.st-andrews.ac.uk/CS4099/homePage.html" >
    <img  src="home.png" alt="University Logo" style="width: 50px; position: absolute; right: 30px; top: 5px">
  </a>
  <form id="myForm" action="AssignLevelsOnly.php" method="POST";>
    <div class="dropdown">
      <h1>
        Choose Level to Add Student to
      </h1>
      <select id="level_name" name="level_name">
      </select>
      <input  id ="currentLevelAdd" type="submit" value="Next">
    </div>
  </form>
  </hmtl>
<!--This form when submitted lauches PHP file where it takes the teacher to the area where they define the information for a level-->
<!--Form uses POST to keep account details hidden-->
<form id="myForm" action="CreateLevel.php" method="POST";>
  <div class="buildingLevel">
    <h2>
      Create New Level
    </h2>
    <input  id ="buildLevel" type="submit" value="Build Level">
  </div>
  <input  type="hidden" id="teacher_name" name="teacher_name" value= "<?php echo $_POST['teacher_name'] ?>">
  <input  type="hidden" id="teacher_password" name="teacher_password" value= "<?php echo $_POST['teacher_password'] ?>">
  </select>
</form>
<script>
  var levelName = document.getElementById("level_name");
  var levels = new Array();
  levels = <?php echo json_encode($levels);
  ?>;
  for(var i = 0; i < levels.length; i++) {
    var opt = levels[i];
    var el = document.createElement("option");
    el.textContent = opt;
    el.value = opt;
    levelName.appendChild(el);
  }
</script>
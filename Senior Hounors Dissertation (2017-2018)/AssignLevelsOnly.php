<?php
$DB_HOST = "localhost";
$DB_USER = "caf8";
$DB_PASSWORD = "wFucTKR9G2w.Qm";
$DB_NAME = "caf8_admin_centre";
$dbc = mysqli_connect($DB_HOST, $DB_USER, $DB_PASSWORD) or die (mysql_error());
mysqli_select_db($dbc,$DB_NAME);
$level_name = $_POST["level_name"];
if ( isset($_POST["AddLevel"]) ) {
$username = $_POST["teacher_name"];
$difficulty = $_POST["difficulty"];
$skin = $_POST["skin"];
$level_solution = $_POST["level_solution"];
$layout = $_POST["mapDetail"];
$sql_expr_str2 = "INSERT INTO Level VALUES('$level_name', '$level_solution','$difficulty', '$layout', '$username', '$skin' )";
$result2 = mysqli_query($dbc, $sql_expr_str2);
if($result2){
$info = $level_name . " was added";
}else{
die(mysqli_error( $dbc ));
$info = "Sorry there was an issue";
}
}
else if ( isset($_POST["AddStudent"] ) ) {
$studentName = $_POST["studentName"];
$tilemap = $_POST['tilemaps'];
$level_name = $_POST["level_name"];
$sql_expr_str1 = "INSERT INTO studentLevel VALUES('$studentName', '$level_name','$tilemap',100000 )";
$result1 = mysqli_query($dbc, $sql_expr_str1);
if($result1){
$info = $level_name . " was added to " . $studentName  . "'s lesson plan!";
}else{
die(mysqli_error( $dbc ));
$info = "Sorry there was an issue";
}
}
$studentNameArray= array();
$sql_expr_str5 = "SELECT student_name FROM studentLevel where Levelname='".$level_name."'";
$sql_expr_str5 = str_replace("\'","",$sql_expr_str5);
$result5 = mysqli_query($dbc, $sql_expr_str5);
if(mysqli_num_rows($result5) > 0){
while($row = mysqli_fetch_array($result5)) {
array_push($studentNameArray,$row[0]);
}
}else{
}
$skin= array();
$sql_expr_str6 = "SELECT skin FROM studentLevel where Levelname='".$level_name."'";
$sql_expr_str6 = str_replace("\'","",$sql_expr_str6);
$result6 = mysqli_query($dbc, $sql_expr_str6);
if(mysqli_num_rows($result6) > 0){
while($row = mysqli_fetch_array($result6)) {
array_push($skin,$row[0]);
}
}else{
}
$solved= array();
$sql_expr_str7 = "SELECT best_solution  FROM studentLevel where Levelname='".$level_name."'";
$sql_expr_str7 = str_replace("\'","",$sql_expr_str7);
$result7 = mysqli_query($dbc, $sql_expr_str7);
if(mysqli_num_rows($result7) > 0){
while($row = mysqli_fetch_array($result7)) {
array_push($solved,$row[0]);
}
}else{
}
$studentArray= array();
$sql_expr_str4 = "Select name from student where NOT EXISTS (Select 1 from studentLevel where student_name = name and Levelname = '".$level_name."')";
$sql_expr_str4 = str_replace("\'","",$sql_expr_str4);
$result4 = mysqli_query($dbc, $sql_expr_str4);
if(mysqli_num_rows($result4) > 0){
while($row = mysqli_fetch_array($result4)) {
array_push($studentArray,$row[0]);
}
}else{
echo "Goodbye";
exit();
}
?>
<html>
  <style>
    p1{
      color: #3465A4;
      font-weight: bold;
    }
    p2{
      color: #3465A4;
      font-weight: bold;
    }
    #submit{
      background-color: #3465A4;
      color: white;
      height: 40px;
      margin: 0 0 0 25px;
      padding: 10px;
      width: 200px;
      font-weight: bold;
    }
    #submit:hover{
      background-color: #8465A4;
    }
    #tilemaps:hover{
      background-color: #8465A4;
    }
    #tilemaps{
      background-color: #3465A4;
      color: white;
      /* position: fixed;
      right: 860px;
      top: 448px; */
      height: 40px;
      margin: 0 0 0 25px;
      padding: 10px;
      width: 200px;
      font-weight: bold;
    }
    #studentName{
      background-color: #3465A4;
      color: white;
      /* position: fixed;
      left: 250px;
      top: 450px; */
      height: 40px;
      margin: 0 0 0 25px;
      padding: 10px;
      width: 200px;
      font-weight: bold;
    }
    #studentName:hover{
      background-color: #8465A4;
    }
    h1{
      color: #3465A4;
      font-size: 34px;
      font-size: 2vw;
    }
    #levelsTable{
      /* position:fixed;
      right:740px;
      top: 120px; */
      border-collapse: collapse;
      border: 2px solid black;
    }
    #levelsTable  th{
      background-color: #3465A4;
      padding: 8px;
      text-align: center;
      font-size: 25px;
      vertical-align:middle;
    }
    #levelsTable td{
      padding: 8px;
      text-align: center;
      font-size: 20px;
      vertical-align:middle;
    }
    .table{
      float:right;
      width: 100%;
      padding-bottom: 2%;
      text-align: center;
      margin: 0 auto;
    }
    .table1{
      width: 30%;
      text-align: center;
      margin: 0 auto;
      padding-bottom: 50px;
    }
    .studentname{
      width: 30%;
      float: right;
    }
    .tilemap{
      width: 30%;
      float: right;
    }
    .addPlayer{
      width: 30%;
      float: right;
    }
  </style>
  <a href="https://caf8.host.cs.st-andrews.ac.uk/CS4099/homePage.html" >
    <img  src="home.png" alt="University Logo" style="width: 50px; position: absolute; right: 30px; top: 5px">
  </a>
  <div class="table">
    <h1>Students Assigned to  
      <?php echo $level_name ?>
    </h1>
    <table class = "table1" id="levelsTable" border="1">
      <tr>
        <th>Student
        </th>
        <th>Tileset
        </th>
        <th>Solved/Not Solved
        </th>
      </tr>
      <script language="javascript" type="text/javascript">
        var studentNameArray = new Array();
        studentNameArray = <?php echo json_encode($studentNameArray);
        ?>;
        var skin = new Array();
        skin = <?php echo json_encode($skin);
        ?>;
        var solved = new Array();
        solved = <?php echo json_encode($solved);
        ?>;
        for(var j =0; j < solved.length; j++){
          if(solved[j] == 100000){
            solved[j] = "Not SOLVED!"
          }
          else{
            solved[j] = "SOLVED!"
          }
        }
        for (var i=0; i< studentNameArray.length; i++) {
          document.write("<tr><td>" + studentNameArray[i] + "</td>");
          document.write("<td>" + skin[i] + "</td>");
          document.write("<td>" + solved[i] + "</td></tr>");
        }
        document.getElementById(levelsTable).style.height = 450 + studentNameArray.length*5;
      </script>
    </table>
  </div>
  <form id="myForm" action="AssignLevelsOnly.php" method="POST";>
    <input type="hidden" id="AddStudent" name="AddStudent" value="AddStudent">
    <div class="addPlayer">
      <input  id="submit" type="submit" value="Add to Player">
    </div>
    <div class="tilemap">
      <p2>Tileset for Player
      </p2>
      <select id="tilemaps" name="tilemaps">
      </select>
    </div>
    <div class="studentname">
      <p1>Player to Add to Level
      </p1>
      <select id="studentName" name="studentName">
      </select>
    </div>
    <input  type="hidden" id="level_name" name="level_name" value= "<?php echo $level_name ?>">
  </form>
</html>
<script>
  var studentName = document.getElementById("studentName");
  var tileMap = document.getElementById("tilemaps");
  var studentArray = new Array();
  studentArray = <?php echo json_encode($studentArray);
  ?>;
  var tileMapArray = ["Tileset1","Tileset2","Tileset3","Tileset4","Tileset5"]
  for(var i = 0; i < studentArray.length; i++) {
    var opt = studentArray[i];
    var el = document.createElement("option");
    el.textContent = opt;
    el.value = opt;
    studentName.appendChild(el);
  }
  for(var i = 0; i < tileMapArray.length; i++) {
    var opt = tileMapArray[i];
    var el = document.createElement("option");
    el.textContent = opt;
    el.value = opt;
    tileMap.appendChild(el);
  }
</script>
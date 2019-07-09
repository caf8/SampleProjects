<?php
//Setting up connection to the databases
$DB_HOST = "localhost";
$DB_USER = "caf8";
$DB_PASSWORD = "wFucTKR9G2w.Qm";
$DB_NAME = "caf8_admin_centre";
$dbc = mysqli_connect($DB_HOST, $DB_USER, $DB_PASSWORD) or die (mysql_error());
mysqli_select_db($dbc,$DB_NAME);
ini_set('display_errors',1);
error_reporting(E_ALL);
//Retriveing information from the form that launched the PHP file.
$levelName = $_POST['bestSolutionLNameArray'];
$username = $_POST['Student'];
$best_solution1 = $_POST['bestSolutionArray'];
//Data read in from the database, then exploded on commas to create an array
$best_solution_array = explode(',', $best_solution1);
$best_solution_level_name_array = explode(',', $levelName);
//Loops through the best solution array that was created, and updates each of the entries in the database to contain their new best solution
$length = count($best_solution_level_name_array);
for ($i = 0; $i < $length; $i++) {
$sql_expr_str1 = "UPDATE studentLevel SET best_solution = '$best_solution_array[$i]' WHERE student_name='".$username."' and Levelname='".$best_solution_level_name_array[$i]."'";
$result1 = mysqli_query($dbc, $sql_expr_str1);
if($result1){
$info = "Congratulations to ". $username . " for completing your lesson!" 
?> 
<?php 
}else{
die(mysqli_error( $dbc ));
$info = "Sorry there was an issue";
}
}
?>
<hmtl>
  <style>
    p{
      text-align: center;
      color: #3465A4;
      font-weight: bold;
      font-size: 24px;
      width:100%;
    }
    h3{
      color: #3465A4;
      font-size: 34px;
      font-size: 2vw;
    }
    .logo{
      width: 100%;
      height:450px;
      text-align: center;
    }
  </style>
     <a href="https://caf8.host.cs.st-andrews.ac.uk/CS4099/homePage.html" >
    <img  src="home.png" alt="University Logo" style="width: 50px; position: absolute; right: 30px; top: 5px">
  </a>
  <div class="logo">
    <h3>Admin Centre for Customisable GBL Material
    </h3>
    <img src="Unilogo.png" alt="University Logo" style="width: 250px;">
  </div>
  </html>
<script>
  var info = "<?php echo $info ?>";
  p = document.createElement("p");
  p.innerHTML = info;
  document.body.appendChild(p);
</script>
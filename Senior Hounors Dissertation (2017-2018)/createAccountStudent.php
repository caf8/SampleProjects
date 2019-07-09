<?php
//Setting up connection to the databases
$DB_HOST = "localhost";
$DB_USER = "caf8";
$DB_PASSWORD = "wFucTKR9G2w.Qm";
$DB_NAME = "caf8_admin_centre";
$dbc = mysqli_connect($DB_HOST, $DB_USER, $DB_PASSWORD) or die (mysql_error());
mysqli_select_db($dbc,$DB_NAME);
//Retriveing information from the form that launched the PHP file.
$username = $_POST['create_name_student'];
$password = $_POST['create_password_student'];
//Setting up querry to insert data into database to create a student account 
$sql_expr_str1 = "INSERT INTO student VALUES('$username', '$password')";
$result1 = mysqli_query($dbc, $sql_expr_str1);
//Assinging message to show if querry was successful.
if($result1){
$info = "Congratulations you have created your account, get ready to learn!";
?> 
<?php 
}else{
$info = "Sorry, someone has already used these detials to register, please try again with different details";
}
?>
<hmtl>
  <style>
    /*
    heading and paragraph tags used to style and position text on the html page.
    */
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
</hmtl>
<script>
  var info = "<?php echo $info ?>";
  p = document.createElement("p");
  p.innerHTML = info;
  document.body.appendChild(p);
</script>

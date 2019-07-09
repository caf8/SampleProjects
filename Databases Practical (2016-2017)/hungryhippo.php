<!DOCTYPE html>

<html lang="en">
<head>
  <title>Hungry Hippos</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <style>
  table, th, td {
  border: 1px solid black;
  }
  </style>
  <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body  style="background-color:powderblue;">

     <?php
     session_start();
     $_SESSION["account_name"] = $_POST["name"] ?>
<script type="text/javascript">


    function hideDivCu(){
         var elements = document.getElementsByClassName('Cupar')
        for(var i = 0; i < elements.length; i++){
            if (elements[i].style.display === 'none') {
                elements[i].style.display = 'block';
            } else {
                elements[i].style.display = 'none';
            }
        }
    }

    function hideDivSt(){
         var elements = document.getElementsByClassName('St Andrews')
        for(var i = 0; i < elements.length; i++){
            if (elements[i].style.display === 'none') {
                elements[i].style.display = 'block';
            } else {
                elements[i].style.display = 'none';
            }
        }
    }
</script>
    <?php
    $DB_HOST = "localhost";
    $DB_USER = "caf8";
    $DB_PASSWORD = "wFucTKR9G2w.Qm";
    $DB_NAME = "caf8_cs3101_db2";
    $dbc = mysql_connect($DB_HOST, $DB_USER, $DB_PASSWORD) or die (mysql_error());
    mysql_select_db($DB_NAME);
    $dbc = mysql_connect($DB_HOST, $DB_USER, $DB_PASSWORD) or die (mysql_error());
    mysql_select_db($DB_NAME);
    ?>
    <nav class="navbar navbar-inverse">
      <div class="container-fluid">
        <div class="navbar-header">
          <a class="navbar-brand" href="https://caf8.host.cs.st-andrews.ac.uk/cs3101/login.php">Hungry Hippos</a>
        </div>
        <ul class="nav navbar-nav">
           <li><a href="https://caf8.host.cs.st-andrews.ac.uk/cs3101/hungryhippoorders.html">Order</a></li>
           <li><a href="https://caf8.host.cs.st-andrews.ac.uk/cs3101/hungryhippopopular.php">Most Popular Restaurant</a></li>
            <li><a href="https://caf8.host.cs.st-andrews.ac.uk/cs3101/hungryhippoaccountorders.php">Account Orders</a></li>
        </ul>

          <div class="form-group">
              <form id="search" method = "post" action = "hungryhippo1.php">
            <input type="text" name = "dish" class="form-control" placeholder="Search for Menu Items">
          </div>
          <button form = "search" type="submit" onclick= class="btn btn-default">Submit</button>
        </form>
      </div>
    </nav>

<p>Please select the regions you want to see restaurants from.<p>
<input type="checkbox" name="apple" id="apple" onclick="hideDivCu()"/> Cupar
<input type="checkbox" name="apple" id="apple" onclick="hideDivSt()"/> St Andrews

<div style="display: none;" id="container" class="<?php
$sql_expr_str = "SELECT city from `Restaurant` where restaurant_name = 'Courtyard'";
$result = mysql_query($sql_expr_str);
$row=mysql_fetch_array($result);
echo $row[0];?>">

  <h2>Courtyard</h2>
  <p>Little Cafe hidden off the main street in St Andrews.</p>
  <button type="button" class="btn btn-info" data-toggle="collapse" data-target="#demo">Menu</button>
  <div id="demo" class="collapse">
      <?php
      $sql_expr_str = "SELECT restaurant_name, name, description, price from Restaurant natural join offers natural join Menu_Item where restaurant_name = 'Courtyard'";
      $result = mysql_query($sql_expr_str);
      ?>

     <?php
echo "<table>";
     while($row = mysql_fetch_array($result)){
 echo "<tr><td>" . $row['name'] . "</td><td>" . $row['description'] . "</td><td>" . $row['price'] . "</td></tr>";
 }
 echo "</table>";
    ?>
  </div>
</div>

<div style="display: none;" id="container" class="<?php
$sql_expr_str = "SELECT city from `Restaurant` where restaurant_name = ' Dervish'";
$result = mysql_query($sql_expr_str);
$row=mysql_fetch_array($result);
echo $row[0];?>">

  <h2>Dervish</h2>
  <p>Turkish restaurant situated on Bell Street</p>
  <button type="button" class="btn btn-info" data-toggle="collapse" data-target="#demo3">Menu</button>
  <div id="demo3" class="collapse">
      <?php
      $sql_expr_str = "SELECT restaurant_name, name, description, price from Restaurant natural join offers natural join Menu_Item where restaurant_name = ' Dervish'";
      $result = mysql_query($sql_expr_str);
      echo "<table>";
           while($row = mysql_fetch_array($result)){
       echo "<tr><td>" . $row['name'] . "</td><td>" . $row['description'] . "</td><td>" . $row['price'] . "</td></tr>";
       }
       echo "</table>";
    ?>
  </div>
</div>

<div style="display: none;" id="container" class="<?php
$sql_expr_str = "SELECT city from `Restaurant` where restaurant_name = 'Empire'";
$result = mysql_query($sql_expr_str);
$row=mysql_fetch_array($result);
echo $row[0];?>">
  <h2>Empire</h2>
  <p>The student late night eatary across from the Union.</p>
  <button type="button" class="btn btn-info" data-toggle="collapse" data-target="#demo4">Menu</button>
  <div id="demo4" class="collapse">
      <?php
      $sql_expr_str = "SELECT restaurant_name, name, description, price from Restaurant natural join offers natural join Menu_Item where restaurant_name = 'Empire'";
      $result = mysql_query($sql_expr_str);

      echo "<table>";
           while($row = mysql_fetch_array($result)){
       echo "<tr><td>" . $row['name'] . "</td><td>" . $row['description'] . "</td><td>" . $row['price'] . "</td></tr>";
       }
       echo "</table>";
    ?>
  </div>
</div>

<div style="display: none;" id="container" class="<?php
$sql_expr_str = "SELECT city from `Restaurant` where restaurant_name = 'Little Italy'";
$result = mysql_query($sql_expr_str);
$row=mysql_fetch_array($result);
echo $row[0];?>" style="hidden">
  <h2>Little Italy</h2>
  <p>An Italian Gem hiden inside St Andrews.</p>
  <button type="button" class="btn btn-info" data-toggle="collapse" data-target="#demo5">Menu</button>
  <div id="demo5" class="collapse">
      <?php
      $sql_expr_str = "SELECT restaurant_name, name, description, price from Restaurant natural join offers natural join Menu_Item where restaurant_name = 'Little Italy'";
      $result = mysql_query($sql_expr_str);

      echo "<table>";
           while($row = mysql_fetch_array($result)){
       echo "<tr><td>" . $row['name'] . "</td><td>" . $row['description'] . "</td><td>" . $row['price'] . "</td></tr>";
       }
       echo "</table>";
    ?>
  </div>
</div>

<div style="display: none;" id="container" class="<?php
$sql_expr_str = "SELECT city from `Restaurant` where restaurant_name = 'Nandos'";
$result = mysql_query($sql_expr_str);
$row=mysql_fetch_array($result);
echo $row[0];?>">
  <h2>Nandos</h2>
  <p>Cheeky Restaurant for you and your mates.</p>
  <button type="button" class="btn btn-info" data-toggle="collapse" data-target="#demo6">Menu</button>
  <div id="demo6" class="collapse">
      <?php
      $sql_expr_str = "SELECT restaurant_name, name, description, price from Restaurant natural join offers natural join Menu_Item where restaurant_name = 'Nandos'";
      $result = mysql_query($sql_expr_str);
      echo "<table>";
           while($row = mysql_fetch_array($result)){
       echo "<tr><td>" . $row['name'] . "</td><td>" . $row['description'] . "</td><td>" . $row['price'] . "</td></tr>";
       }
       echo "</table>";
    ?>
  </div>
</div>

<div style="display: none;" id="container" class="<?php
$sql_expr_str = "SELECT city from `Restaurant` where restaurant_name = 'The Rule'";
$result = mysql_query($sql_expr_str);
$row=mysql_fetch_array($result);
echo $row[0];?>">
  <h2>The Rule</h2>
  <p>Greast Place to get a discount drink.</p>
  <button type="button" class="btn btn-info" data-toggle="collapse" data-target="#demo7">Menu</button>
  <div id="demo7" class="collapse">
      <?php
      $sql_expr_str = "SELECT restaurant_name, name, description, price from Restaurant natural join offers natural join Menu_Item where restaurant_name = 'The Rule'";
      $result = mysql_query($sql_expr_str);
      echo "<table>";
           while($row = mysql_fetch_array($result)){
       echo "<tr><td>" . $row['name'] . "</td><td>" . $row['description'] . "</td><td>" . $row['price'] . "</td></tr>";
       }
       echo "</table>";
    ?>
  </div>
</div>


<div style="display: none;" id="container" class="<?php
$sql_expr_str = "SELECT city from `Restaurant` where restaurant_name = 'Toastie Bar'";
$result = mysql_query($sql_expr_str);
$row=mysql_fetch_array($result);
echo $row[0];?>">
  <h2>Toastie Bar</h2>
  <p>Cheap and cheerful food for late at night, procedes go to charity.</p>
  <button type="button" class="btn btn-info" data-toggle="collapse" data-target="#demo2">Menu</button>
  <div id="demo2" class="collapse">
      <?php
      $sql_expr_str = "SELECT restaurant_name, name, description, price from Restaurant natural join offers natural join Menu_Item where restaurant_name = 'Toastie Bar'";
      $result = mysql_query($sql_expr_str);
      echo "<table>";
           while($row = mysql_fetch_array($result)){
       echo "<tr><td>" . $row['name'] . "</td><td>" . $row['description'] . "</td><td>" . $row['price'] . "</td></tr>";
       }
       echo "</table>";
    ?>
  </div>
</div>

<div style="display: none;" id="container" class="<?php
$sql_expr_str = "SELECT city from `Restaurant` where restaurant_name = 'Union'";
$result = mysql_query($sql_expr_str);
$row=mysql_fetch_array($result);
echo $row[0];?>">
  <h2>Union</h2>
  <p>The best food for a chilled out lunch and a good plce for a drink</p>
  <button type="button" class="btn btn-info" data-toggle="collapse" data-target="#demo1">Menu</button>
  <div id="demo1" class="collapse">
      <?php
      $sql_expr_str = "SELECT restaurant_name, name, description, price from Restaurant natural join offers natural join Menu_Item where restaurant_name = 'Union'";

      $result = mysql_query($sql_expr_str);
      echo "<table>";
           while($row = mysql_fetch_array($result)){
       echo "<tr><td>" . $row['name'] . "</td><td>" . $row['description'] . "</td><td>" . $row['price'] . "</td></tr>";
       }
       echo "</table>";
    ?>
  </div>
</div>

<div style="display: none;" id="container" class="<?php
$sql_expr_str = "SELECT city from `Restaurant` where restaurant_name = 'Vic'";
$result = mysql_query($sql_expr_str);
$row=mysql_fetch_array($result);
echo $row[0];?>">
  <h2>Vic</h2>
  <p>Good for food at all times of the day</p>
  <button type="button" class="btn btn-info" data-toggle="collapse" data-target="#demo8">Menu</button>
  <div id="demo8" class="collapse">
      <?php
      $sql_expr_str = "SELECT restaurant_name, name, description, price from Restaurant natural join offers natural join Menu_Item where restaurant_name = 'Vic'";

      $result = mysql_query($sql_expr_str);
      echo "<table>";
           while($row = mysql_fetch_array($result)){
       echo "<tr><td>" . $row['name'] . "</td><td>" . $row['description'] . "</td><td>" . $row['price'] . "</td></tr>";
       }
       echo "</table>";
    ?>
  </div>
</div>


<div style="display: none;" id="container" class="<?php
$sql_expr_str = "SELECT city from `Restaurant` where restaurant_name = 'Waffle Company'";
$result = mysql_query($sql_expr_str);
$row=mysql_fetch_array($result);
echo $row[0];?>">
  <h2>Waffle Company</h2>
  <p>Unbelievable breakfast can be had here, savoury or sweet</p>
  <button type="button" class="btn btn-info" data-toggle="collapse" data-target="#demo9">Menu</button>
  <div id="demo9" class="collapse">
      <?php
      $sql_expr_str = "SELECT restaurant_name, name, description, price from Restaurant natural join offers natural join Menu_Item where restaurant_name = 'Waffle Company'";

      $result = mysql_query($sql_expr_str);
      echo "<table>";
           while($row = mysql_fetch_array($result)){
       echo "<tr><td>" . $row['name'] . "</td><td>" . $row['description'] . "</td><td>" . $row['price'] . "</td></tr>";
       }
       echo "</table>";
    ?>
  </div>
</div>


</body>
</html>

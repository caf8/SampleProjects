<!DOCTYPE html>

<html>

<head>
    <title>Order Confirmation Screen</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
<style>
p {
    font-size: 30px;
}
table, th, td {
border: 1px solid black;
}
</style>
<meta charset="UTF-8">
<title>Reciept for transactions</title>


</head>

<body  style="background-color:powderblue;">
    <nav class="navbar navbar-inverse">
      <div class="container-fluid">
        <div class="navbar-header">
          <a class="navbar-brand" href="https://caf8.host.cs.st-andrews.ac.uk/cs3101/login.php">Hungry Hippos</a>
        </div>
        <ul class="nav navbar-nav">
           <li><a href="https://caf8.host.cs.st-andrews.ac.uk/cs3101/hungryhippoorders.html">Order</a></li>
           <li><a href="https://caf8.host.cs.st-andrews.ac.uk/cs3101/hungryhippopopular.php">Most Popular Restaurant</a></li>
        </ul>

          <div class="form-group">
              <form id="search" method = "post" action = "hungryhippo1.php">
            <input type="text" name = "dish" class="form-control" placeholder="Search for Menu Items">
          </div>
          <button form = "search" type="submit" onclick= class="btn btn-default">Submit</button>
        </form>
      </div>
    </nav>
<?php
    function getFormInfo($v) {
        return isset($_POST[$v]) ? htmlspecialchars($_POST[$v]) : null;
    }

    $menuItem = getFormInfo("menuItem");
    $restaurant = getFormInfo("restaurant");
    $num = rand(0,2000);



    $DB_HOST = "localhost";
    $DB_USER = "caf8";
    $DB_PASSWORD = "wFucTKR9G2w.Qm";
    $DB_NAME = "caf8_cs3101_db2";
    $dbc = mysql_connect($DB_HOST, $DB_USER, $DB_PASSWORD) or die (mysql_error());
    mysql_select_db($DB_NAME);

    $sql_expr_str1 = "SELECT price from Menu_Item where name = '$menuItem'";
    $result1 = mysql_query($sql_expr_str1);
    $row=mysql_fetch_array($result1);
    $date = date("H:i:s ");

    $sql_expr_str2 = "INSERT INTO Orders VALUES($num, $row[0], '$date', '$date', '$date', '$restaurant' )";
    $result2 = mysql_query($sql_expr_str2);

    if($result2 && $result1){
        ?> <p>Congrats your order was successful!</p>
        <?php
    }else{
        ?>
        <p>That was an invlaid order, please return to the order page to try again, maybe check the menu to check the order again.</p>
        <img src="sad-hippo.png" alt="Mountain View" style="width:304px;height:228px;">
        <?php
    }



    $sql_expr_str = "INSERT INTO contains VALUES($num, '$menuItem', '$restaurant')";
    $result = mysql_query($sql_expr_str);








    ?>

</body>

</html>

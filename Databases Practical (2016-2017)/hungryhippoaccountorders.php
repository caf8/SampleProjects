<!DOCTYPE html>

<html>

<head>
    <title>Account Orders Details</title>
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
<?php session_start(); $account =  $_SESSION["account_name"];


    $DB_HOST = "localhost";
    $DB_USER = "caf8";
    $DB_PASSWORD = "wFucTKR9G2w.Qm";
    $DB_NAME = "caf8_cs3101_db2";
    $dbc = mysql_connect($DB_HOST, $DB_USER, $DB_PASSWORD) or die (mysql_error());
    mysql_select_db($DB_NAME);

    $sql_expr_str = "SELECT person_id, name from places natural join contains where person_id = $account";
    $result = mysql_query($sql_expr_str);


    if(mysql_num_rows($result)!=0){
    echo "<table>";
    echo "<th>Account ID</th>
    <th>Dish Ordered</th>";
        while($row = mysql_fetch_array($result)){
    echo "<tr><td>" . $row['person_id'] . "</td><td>" . $row['name'] . "</td></tr>";
    }

    echo "</table>";
}else{
    ?>
        <p>The following account does not exist, enter valid account details before trying the Account Orders tab again.</p>
        <img src="sad-hippo.png" alt="Mountain View" style="width:304px;height:228px;">
        <?php
}

?>

</body>

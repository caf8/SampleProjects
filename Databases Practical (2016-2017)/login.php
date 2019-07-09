<!DOCTYPE html>

<html>

<head>
    <title>Hungry Hippo Log In</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
<style>
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
<form action="https://caf8.host.cs.st-andrews.ac.uk/cs3101/hungryhippo.php" method="post">
Account Number: <input type="text" name="name" required>
<input type="submit">
</form>

</body>
</html>

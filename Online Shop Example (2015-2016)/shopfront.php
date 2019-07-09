<!DOCTYPE html>

<html>

<head>
<meta charset="UTF-8">
<title>Reciept for transactions</title>
<link rel="stylesheet" href="shopfront.css">

</head>

<body>

<?php

function getFormInfo($v) {
    return isset($_POST[$v]) ? htmlspecialchars($_POST[$v]) : null;
}

function getFormNumber($v){
     return htmlspecialchars($_POST[$v]);
}

if (!($surname = getFormInfo("surname")) ||
    !($firstname = getFormInfo("firstname")) ||
    !($email = getFormInfo("email")) ||
    !($payment_method = getFormInfo("payment_method")) ||
	!($card_name = getFormInfo("card_name")) ||
    !($card_number = getFormInfo("card_number")) ||
	!($sec_code = getFormInfo("sec_code")) ||
    !($ship_address = getFormInfo("ship_address")) ||
	!($ship_city = getFormInfo("ship_city")) ||
	!($ship_region = getFormInfo("ship_region")) ||
    !($ship_postcode = getFormInfo("ship_postcode")) ||
    !($ship_country = getFormInfo("ship_country"))
    ) {
    echo "<p>Some essential information is missing - please check!</p>";    
}

else {
    
    $vat = getFormNumber("vat");
    $crawdadQuantity = getFormNumber("crawdadQuantity");
    $gorillaQuantity = getFormNumber("gorillaQuantity");
    $ninjaQuantity = getFormNumber("ninjaQuantity");
    $psionQuantity = getFormNumber("psionQuantity");
    $totemQuantity = getFormNumber("totemQuantity"); 
    $subtotal = getFormNumber("subtotal");
    $delivery = getFormNumber("delivery");
    $total_cost = getFormNumber("total_cost");
    
    
 echo"
    <table>
        <tr>
            <td>Reciept generated at: </td>
            <td>". date("d/m/Y H:i:s ") ."</td>
        </tr>
        <tr> </tr>
        <tr>
            <td>The following items were purchased</td>
            <td>$crawdadQuantity crawdad at 4.50 each.</td>
            <tr></tr>
            <td></td>
            <td>$gorillaQuantity gorilla at 8.50 each.</td>
            <tr></tr>
            <td></td>
            <td>$ninjaQuantity ninja at 12.50 each.</td>
            <tr></tr>
            <td></td>
            <td>$psionQuantity psion at 110.00 each.</td>
            <tr></tr>
            <td></td>
            <td>$totemQuantity totem at 150.00 each</td>
            <tr></tr>
            <td>Total Costings:</td>
            <td>VAT (20%)</td>
            <td>$vat</td>
            <tr></tr>
            <td></td>
            <td>Subtotal</td>
            <td>$subtotal</td>
            <tr></tr>
            <td></td>
            <td>Delivery Charge</td>
            <td>$delivery</td>
            <tr></tr>
            <td></td>
            <td>Total cost</td>
            <td>$total_cost</td>
            <tr></tr>
            <td></td>
            <td>Credit Card Number</td>
            <td>". substr($card_number,0,2) . 'XXXXXXXXXXXX' . substr($card_number,-2)."</td>
            <tr></tr>
            <td>Send to:</td>
            <tr></tr>
            <td>$ship_address</td>
            <tr></tr>
            <td>$ship_city</td>
            <tr></tr>
            <td>$ship_region</td>
            <tr></tr>
            <td>$ship_postcode</td>
            <tr></tr>
            <td>$ship_country</td>   
            
        </tr>
    </table>
    ";
}

?>

</body>

</html>


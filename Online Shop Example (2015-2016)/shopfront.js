//Author 140012021

//This function calculates the total cost of each item, using its price and 
//how many of them were ordered.

function priceCalculation(priceName, quantityName, totalName) {


	var price = document.getElementById(priceName).value;
	var quantity = document.getElementById(quantityName).value;

	var cost = price * quantity;  //Calculating the total cost of the item passed into the function.

	//Updating the html page to show the new costs of the items.

	document.getElementById(totalName).value = cost.toFixed(2);


	//Calling the totals function.

	totals();


}

//This function calculates all the discount, VAT, subtotal, delivery charge and Total cost variables,
//to be shown on the main html page.

function totals() {
	
	//Intialsing variables to be used in the totals method.
	
	var totalCostOfItems = 0;
	var totalCharge = 0;
	var deliveryCharge;
	var discount;
	var subTotal;

	//Getting the combined total costs of the all the items.

	totalCostOfItems = parseFloat(document.getElementById("crawdadTotal").value) + parseFloat(document.getElementById("gorillaTotal").value) + parseFloat(document.getElementById("ninjaTotal").value) +
	parseFloat(document.getElementById("psionTotal").value) + parseFloat(document.getElementById("totemTotal").value);

	//Getting the total number of items ordered.

	var totalNumberOfItems = parseFloat(document.getElementById("crawdadQuantity").value) + parseFloat(document.getElementById("gorillaQuantity").value) + parseFloat(document.getElementById("ninjaQuantity").value) +
		parseFloat(document.getElementById("psionQuantity").value) + parseFloat(document.getElementById("totemQuantity").value);

	var VAT = totalCostOfItems * 0.2; 	//Calculating VAT using the total costs of the items and the standard VAT value.

	//Calculating the discount value, depending on how many items are ordered in total.

	if (totalNumberOfItems > 2 && totalNumberOfItems < 6) {
		discount = 5;
	} else if (totalNumberOfItems > 5) {
		discount = 10
	} else {
		discount = 0;
	}

	//Updating the discount value on the html page, depending on how many items are ordered in total.

	if (discount != 0) {
		document.getElementById("discount").value = discount;
		subTotal = (totalCostOfItems + VAT) / 100 * (100 - discount);
	} else {
		document.getElementById("discount").value = "N/A";
		subTotal = totalCostOfItems + VAT;
	}

	//Calculating the delivery charge, depending on how many items are ordered in total.

	if (totalCostOfItems > 250) {
		deliveryCharge = 0;
	} else {
		deliveryCharge = totalNumberOfItems * 1.5;
	}

	totalCharge = subTotal + deliveryCharge; 	//Calculating the final charge.

	//Updating the html page to show the new values for VAT, Subtotal, Delivery Charge and Total Cost. 

	document.getElementById("VAT").value = VAT.toFixed(2);

	document.getElementById("subTotal").value = subTotal.toFixed(2);

	document.getElementById("deliveryCharge").value = deliveryCharge.toFixed(2);

	document.getElementById("totalCost").value = totalCharge.toFixed(2);


}

//This function validates the credit card information entered by the user.

function validateCreditCard() {

//Getting the variable information for the card validation process.

	var paymentMethod = document.getElementById("paymentMethod").value;

	var cardNumber = document.getElementById("cardNumber").value;

//Validation checks depending on which payment method is chosen. Checks that the card
//number is of the correct length and if it is in the correct format.

	if (paymentMethod == ("amex")) {
		if (cardNumber.substring(0, 1) != ("3") || cardNumber.length != ("16")) {
			alert("Please enter he correct format of an amex card.");
			return false;
		}
	} else if (paymentMethod == ("mastercard")) {
		if (cardNumber.substring(0, 1) != ("5") || cardNumber.length != ("16")) {
			alert("Please enter he correct format of an MasterCard card.");
			return false;
		}
	} else {
		if (cardNumber.substring(0, 1) != ("4") || cardNumber.length != ("16")) {
			alert("Please enter he correct format of an Visa card.");
			return false;
		}
	}


}


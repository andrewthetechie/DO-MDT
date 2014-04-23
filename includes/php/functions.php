<?php
	include("config.php");

	//Validation functions

	//checks if a string passes the basic requirements to be a domain name
	//returns true if yes, false if no
	function isDomainName($domain_name)
	{
	    return (
		preg_match("/^([a-z\d](-*[a-z\d])*)(\.([a-z\d](-*[a-z\d])*))*$/i", $domain_name) //valid chars check
		    && preg_match("/^.{1,253}$/", $domain_name) //overall length check
		    && preg_match("/^[^\.]{1,63}(\.[^\.]{1,63})*$/", $domain_name)   ); //length of each label
	}


	//checks if a passed IP is private
	//returns true if IP is private, false otherwise
	function isPrivateIP ($ip) {
	    $pri_addrs = array (
			      '10.0.0.0|10.255.255.255', 
			      '172.16.0.0|172.31.255.255', 
			      '192.168.0.0|192.168.255.255', 
			      '169.254.0.0|169.254.255.255',
			      '127.0.0.0|127.255.255.255' 
			     );

	    $long_ip = ip2long ($ip);
	    if ($long_ip != -1) {

		foreach ($pri_addrs AS $pri_addr) {
		    list ($start, $end) = explode('|', $pri_addr);

		     // IF IS PRIVATE
		     if ($long_ip >= ip2long ($start) && 
				$long_ip <= ip2long ($end)) {
			 return true;
		     }
		}
	    }

	    return false;
	}


	//HTML writing functions

	//outputs the input form
	//directly echos, no return
	function writeInputForm()
	{
		echo "<form class='form-horizontal' name='MDT' ";
			echo "action='result.php' method='POST'>";
		echo "<fieldset>";

		echo "<legend>Master Diagnostic Tool</legend>";


		echo "<div class='control-group'>";
		echo "<label class='control-label' for='toCheck'>Check This:";
			echo "</label>";
		echo "<div class='controls'>";
		echo "<input id='toCheck' name='toCheck' type='text' ";
			echo "placeholder='google.com' class='input-xlarge' ";
			echo "required=''>";
		echo "<p class='help-block'>Domain, IP, or URL</p>";
		echo "</div>";
		echo "</div>";

		echo "<div class='control-group'>";
		echo "<label class='control-label' for='submit'></label>";
		echo "<div class='controls'>";
		echo "<button id='submit' name='submit' ";
			echo "class='btn btn-success'>Run Diag</button>";
		echo "</div>";
		echo "</div>";

		echo "</fieldset>";
		echo "</form>";

	}	

?>

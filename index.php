<?php

if (isset($_GET['domain'])) {

	$q = trim($_GET['domain']);
	echo $domain;
} else {
//no query
echo <<< EOECHO
<form name="hi1" method="get">
<input type="text" value="" name="domain" size=12>
<br>
<input type="submit" value="go!">
</form>
EOECHO
;
die('no question asked.');
}


echo "<pre>";
$response = system('./includes/sh/checkscript.sh' . $q, $retval);
echo "</pre>";

//echo $output1;


?>
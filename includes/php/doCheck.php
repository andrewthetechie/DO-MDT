<?php
	include("functions.php");
	if(!isset($_GET['toCheck'])&& !isset($_GET['type']))
	{
		echo "Invalid referral";
		//exit();
	}

	$path = APPLICATIONPATH . DIRECTORY_SEPARATOR;
	$path .= "includes/sh/";

	$q = urldecode($_GET['toCheck']);
	$type=urldecode($_GET['type']);


	switch($type)
	{
		case 'domain':
			$retval=shell_exec($path .'checkDomainInfo.sh ' . $q);	
			break;

		case 'ip':
			$retval=shell_exec($path .'checkIPInfo.sh ' . $q);	
			break;
		
		case 'dns':
			$retval=shell_exec($path .'checkDNSInfo.sh ' . $q);	
			break;
		
		case 'port':
			$retval=shell_exec($path .'checkPortInfo.sh ' . $q);	
			break;

	}

	$info = json_decode($retval ,TRUE);
	switch($type)
	{
		case 'domain':
			echo "Expiration: " . $info['Expiration'];
			echo "<br />Registrar: " . $info['Registrar'];		
			break;

		case 'ip':
			$retval=shell_exec($path .'checkIPInfo.sh ' . $q);	
			break;
		
		case 'dns':
			echo "<h5>A Records</h5>";
			$arecs = explode(",",$info['A']);
			echo "<ul>";
			for($i=0; $i<count($arecs);$i++)
			{
				echo "<li>".$arecs[$i]."</li>";
			}
			echo "</ul>";

			$mxrecs = explode(",",$info['MX']);
			echo "<h5>MX Records</h5>";
			echo "<ul>";

			for($i=0; $i<count($mxrecs);$i++)
			{
				$mxrecord = explode(" ",trim($mxrecs[$i]));
				
				echo "<li>".$mxrecord[1]."&nbsp;&nbsp;-&nbsp;";
				echo "&nbsp;Priority: ".$mxrecord[0]."</li>";
				

			}
			echo "</ul>";

			$txtrecs = explode(",",$info['TXT']);
			echo "<h5>TXT Records</h5>";
			echo "<ul>";
			for($i=0; $i<count($txtrecs); $i++)
			{
				echo "<li>".$txtrecs[$i]."</li>";
			}
			echo "</ul>";
			echo "<h5>rDNS Info Hosting Provider</h5> " . $info['Hosting'];		
			break;
		
		case 'port':
			$ports = explode(",",$info['Open Ports']);
			echo "<ul>";
			for($i=0; $i<count($ports); $i++)
				echo "<li>".$ports[$i]."</li>";
			echo "</ul>";
			break;

	}

	
?>

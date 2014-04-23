<?php 

	require_once("includes/php/functions.php");

	if(isset($_POST['toCheck']))
	{
		if(filter_var($_POST['toCheck'],FILTER_VALIDATE_URL))
		{
			$parsed = parse_url($_POST['toCheck']);
			$_POST['toCheck']=$parsed['host'];
		}

		if(filter_var($_POST['toCheck'],FILTER_VALIDATE_IP))
		{
			if(isPrivateIP($_POST['toCheck']))
			{
				header("Location: index.php?error=privateIP");
			}
			$type = "IP";
		}else if(isDomainName($_POST['toCheck']))
		{
			if(!checkdnsrr($_POST['toCheck'],"NS") 
				&& !checkdnsrr($_POST['toCheck'],"A"))
			{
				header("Location: index.php?error=badDomain");
			}	
			$type="Domain";
		}
		else
		{
			header("Location: index.php?error=badInput");
		}

	}else
	{
		header("Location: index.php?error=noInput");
	}

?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>MDT - Master Diagnostic Tool</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- CSS -->
    <link href="assets/css/bootstrap.css" rel="stylesheet">
    <style type="text/css">

      /* Sticky footer styles
      -------------------------------------------------- */

      html,
      body {
        height: 100%;
        /* The html and body elements cannot have any padding or margin. */
      }

      /* Wrapper for page content to push down footer */
      #wrap {
        min-height: 100%;
        height: auto !important;
        height: 100%;
        /* Negative indent footer by it's height */
        margin: 0 auto -60px;
      }

      /* Set the fixed height of the footer here */
      #push,
      #footer {
        height: 60px;
      }
      #footer {
        background-color: #f5f5f5;
      }

      /* Lastly, apply responsive CSS fixes as necessary */
      @media (max-width: 767px) {
        #footer {
          margin-left: -20px;
          margin-right: -20px;
          padding-left: 20px;
          padding-right: 20px;
        }
      }



      /* Custom page CSS
      -------------------------------------------------- */
      /* Not required for template or sticky footer method. */

      .container {
        width: auto;
        max-width: 680px;
      }
      .container .credit {
        margin: 20px 0;
      }

    </style>
    <link href="assets/css/bootstrap-responsive.css" rel="stylesheet">

    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="assets/js/html5shiv.js"></script>
    <![endif]-->

    <!-- Fav and touch icons -->
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="assets/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="assets/ico/apple-touch-icon-114-precomposed.png">
      <link rel="apple-touch-icon-precomposed" sizes="72x72" href="assets/ico/apple-touch-icon-72-precomposed.png">
                    <link rel="apple-touch-icon-precomposed" href="assets/ico/apple-touch-icon-57-precomposed.png">
                                   <link rel="shortcut icon" href="assets/ico/favicon.png">
  </head>

  <body>


    <!-- Part 1: Wrap all page content here -->
    <div id="wrap">

      <!-- Begin page content -->
      <div class="container">
        <div class="page-header">
          <h1>Results for <?php echo $_POST['toCheck']; ?></h1>
		<form name="goback" action="index.php" method="POST">
		    <button id="singlebutton" name="singlebutton" 
			class="btn btn-success">Test Another Domain</button>
		</form>
        </div>
	<h3><?php echo $type; ?> information</h3>
	<div id="domainResult"
		<?php if($type=="IP") echo "style='display: none;'"; ?>
		><img src="assets/img/loading.gif" width="250" height="250"/></div>
	<div id="ipResult"
		<?php if($type=="Domain") echo "style='display: none;'"; ?>
	><img src="assets/img/loading.gif" width="250" height="250"/></div>
	<h3
		<?php if($type=="IP") echo "style='display: none;'"; ?>
	>DNS Information</h3>
	<div id="dnsResult"
		<?php if($type=="IP") echo "style='display: none;'"; ?>
	><img src="assets/img/loading.gif" width="250" height="250"/></div>
	<h3>Port Scan Results</h3>
	<div id="portResult"><img src="assets/img/loading.gif" width="250" height="250"/></div>
      </div>
      <div id="push"></div>
    </div>

    <div id="footer">
      <div class="container">
        <p class="muted credit">Original Script courtesy of Tyler Crandall
	<br />Modified for stage and screen by 
	<a href="http://andrewherrington.com" target=_blank>Andrew Herrington</a></p>
      </div>
    </div>



    <!-- Le javascript
    ================================================== -->
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
	<script>
		$(document).ready(function() {
		    $("#ipResult").load("includes/php/doCheck.php?type=ip&toCheck=<?php echo urlencode($_POST['toCheck']); ?>");
		});
		$(document).ready(function() {
		    $("#domainResult").load("includes/php/doCheck.php?type=domain&toCheck=<?php echo urlencode($_POST['toCheck']); ?>");
		});
		$(document).ready(function() {
		    $("#dnsResult").load("includes/php/doCheck.php?type=dns&toCheck=<?php echo urlencode($_POST['toCheck']); ?>");
		});
		$(document).ready(function() {
		    $("#portResult").load("includes/php/doCheck.php?type=port&toCheck=<?php echo urlencode($_POST['toCheck']); ?>");
		});
	</script>
  </body>
</html>

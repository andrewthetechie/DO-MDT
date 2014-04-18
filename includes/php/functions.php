<?php



	//HTML writing functions

	//outputs the input form
	//directly echos, no return
	function writeInputForm()
	{
		echo "<form class='form-horizontal' name='MDT' ";
			echo "action='index.php' method='POST'>";
		echo "<fieldset>";

		echo "<legend>Master Diagnostic Tool</legend>";


		echo "<div class='control-group'>";
		echo "<label class='control-label' for='toCheck'>Domain or IP";
			echo "</label>";
		echo "<div class='controls'>";
		echo "<input id='toCheck' name='toCheck' type='text' ";
			echo "placeholder='google.com' class='input-xlarge' ";
			echo "required=''>";
		echo "<p class='help-block'>Domain or IP Address</p>";
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

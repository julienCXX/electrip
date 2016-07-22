<?php include 'inc/db.php';
    $res = $MySQLiconn->query("SELECT * FROM vehicle");
//     while($row=$res->fetch_array())
//            {
//
//
//                    echo $row['nom_voiture'];
//                     echo $row['vitesse'];
//
//            }
//
$inputNbrYear =  5;
if(isset($_GET['id']) && $_GET['id'] == 'compare'){
    $inputNbrYear = $_POST['inputNbrYear'];
    $brand1 = $_POST['brand1'];
    $brand2 = $_POST['brand2'];
    $model1 = $_POST['model1'];
    $model2 = $_POST['model2'];
    $year1  = $_POST['year1'];
    $year2  = $_POST['year2'];
    $voiture1 = $MySQLiconn->query("SELECT * FROM vehicle where brand = '$brand1' and model='$model1' and year = '$year1'");
    $voiture1  = $voiture1->fetch_assoc();
    $voiture2 = $MySQLiconn->query("SELECT * FROM vehicle where brand = '$brand2' and model='$model2' and year = '$year2'");
    $voiture2  = $voiture2->fetch_assoc();
}
?>
<!DOCTYPE html>
<!--
This is a starter template page. Use this page to start your new project from
scratch. This page gets rid of all links and provides the needed markup only.
-->
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Challenge Open DATA</title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Bootstrap 3.3.5 -->
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
    <!-- Ionicons -->
    <link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins. We have chosen the skin-blue for this starter
          page. However, you can choose any other skin. Make sure you
          apply the skin class to the body tag so the changes take effect.
    -->
    <link rel="stylesheet" href="dist/css/skins/skin-blue.min.css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
	<script>
		function validateCompare(){
			$('.brand1, .brand2, .model1, .model2, .year1, .year2').css('borderColor', '');
			if($('.brand1').val() == ''){
				$('.brand1').css('borderColor', 'red');
				return false;
			}
			if($('.brand2').val() == ''){
				$('.brand2').css('borderColor', 'red');
				return false;
			}
			if($('.model1').val() == ''){
				$('.model1').css('borderColor', 'red');
				return false;
			}
			if($('.model2').val() == ''){
				$('.model2').css('borderColor', 'red');
				return false;
			}
			if($('.year1').val() == ''){
				$('.year1').css('borderColor', 'red');
				return false;
			}
			if($('.year2').val() == ''){
				$('.year2').css('borderColor', 'red');
				return false;
			}
			$('.formCompare').submit();
		}
		
		function validateCompare2(){
			$('.brand1, .brand2, .model1, .model2, .year1, .year2').css('borderColor', '');
			if($('.brand1').val() == ''){
				$('.brand1').css('borderColor', 'red');
				return false;
			}
			if($('.brand2').val() == ''){
				$('.brand2').css('borderColor', 'red');
				return false;
			}
			if($('.model1').val() == ''){
				$('.model1').css('borderColor', 'red');
				return false;
			}
			if($('.model2').val() == ''){
				$('.model2').css('borderColor', 'red');
				return false;
			}
			if($('.year1').val() == ''){
				$('.year1').css('borderColor', 'red');
				return false;
			}
			if($('.year2').val() == ''){
				$('.year2').css('borderColor', 'red');
				return false;
			}
			$('.inputNbrYear').val($('.nbr_years').val());
			$('.formCompare').submit();
		}
	</script>
  <style type="text/css">
      /*General styles*/


      #main
      {
        width: 960px;
        margin: 20px auto 0 auto;
        background: white;
        -moz-border-radius: 8px;
        -webkit-border-radius: 8px;
        padding: 30px;
        border: 1px solid #adaa9f;
        -moz-box-shadow: 0 2px 2px #9c9c9c;
        -webkit-box-shadow: 0 2px 2px #9c9c9c;
      }

      /*Features table------------------------------------------------------------*/
      .features-table
      {
        width: 100%;
        margin: 0 auto;
        border-collapse: separate;
        border-spacing: 0;
        text-shadow: 0 1px 0 #fff;
        color: #2a2a2a;
        background: #fafafa;
        background-image: -moz-linear-gradient(top, #fff, #eaeaea, #fff); /* Firefox 3.6 */
        background-image: -webkit-gradient(linear,center bottom,center top,from(#fff),color-stop(0.5, #eaeaea),to(#fff));
      }

      .features-table td
      {
        height: 50px;
        line-height: 50px;
        padding: 0 20px;
        border-bottom: 1px solid #cdcdcd;
        box-shadow: 0 1px 0 white;
        -moz-box-shadow: 0 1px 0 white;
        -webkit-box-shadow: 0 1px 0 white;
        white-space: nowrap;
        text-align: center;
      }

      /*Body*/
      .features-table tbody td
      {
        text-align: center;
        font: normal 12px Verdana, Arial, Helvetica;
        width: 150px;
      }

      .features-table tbody td:first-child
      {
        width: auto;
        text-align: left;
      }

      .features-table td:nth-child(2), .features-table td:nth-child(3), .features-table td:nth-child(4)
      {
        background: #efefef;
        background: rgba(144,144,144,0.15);
        border-right: 1px solid white;
      }




      /*Header*/
      .features-table thead td
      {
        font: bold 1.3em 'trebuchet MS', 'Lucida Sans', Arial;
        -moz-border-radius-topright: 10px;
        -moz-border-radius-topleft: 10px;
        border-top-right-radius: 10px;
        border-top-left-radius: 10px;
        border-top: 1px solid #eaeaea;
      }

      .features-table thead td:first-child
      {
        border-top: none;
      }

      /*Footer*/
      .features-table tfoot td
      {
        font: bold 1.4em Georgia;
        -moz-border-radius-bottomright: 10px;
        -moz-border-radius-bottomleft: 10px;
        border-bottom-right-radius: 10px;
        border-bottom-left-radius: 10px;
        border-bottom: 1px solid #dadada;
      }

      .features-table tfoot td:first-child
      {
        border-bottom: none;
      }
    </style>
    
  </head>
  <!--
  BODY TAG OPTIONS:
  =================
  Apply one or more of the following classes to get the
  desired effect
  |---------------------------------------------------------|
  | SKINS         | skin-blue                               |
  |               | skin-black                              |
  |               | skin-purple                             |
  |               | skin-yellow                             |
  |               | skin-red                                |
  |               | skin-green                              |
  |---------------------------------------------------------|
  |LAYOUT OPTIONS | fixed                                   |
  |               | layout-boxed                            |
  |               | layout-top-nav                          |
  |               | sidebar-collapse                        |
  |               | sidebar-mini                            |
  |---------------------------------------------------------|
  -->
  <body class="hold-transition skin-blue sidebar-mini">
    <div class="wrapper">

      <!-- Main Header -->
      <header class="main-header">

        <!-- Logo -->
        <a href="index.php" class="logo">
          <!-- mini logo for sidebar mini 50x50 pixels -->
          <span class="logo-mini"><b>Open</b> Open Data</span>
          <!-- logo for regular state and mobile devices -->
          <span class="logo-lg"><b>Open</b> Data</span>
        </a>

        <!-- Header Navbar -->
        <nav class="navbar navbar-static-top" role="navigation">
          <!-- Sidebar toggle button-->
          <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
            <span class="sr-only">Toggle navigation</span>
          </a>
          <!-- Navbar Right Menu -->
         </nav>
      </header>
      <!-- Left side column. contains the logo and sidebar -->
      <aside class="main-sidebar">

        <!-- sidebar: style can be found in sidebar.less -->
        <section class="sidebar">

          <!-- Sidebar user panel (optional) -->
          <div class="user-panel">
            <div class="pull-left image">
            <!--  <img src="dist/img/user2-160x160.jpg" class="img-circle" alt="User Image"> -->
            </div>
          </div>
          <!-- Sidebar Menu -->
          <ul class="sidebar-menu">
            <li class="header">Menu</li>
            <!-- Optionally, you can add icons to the links -->
            <li><a href="index.php"><i class="fa fa-link"></i> <span>Open Street MAP</span></a></li>
            <li class="active"><a href="comparateur.php"><i class="fa fa-link"></i> <span>Comparateur</span></a></li>
            <li><a href="about.html"><i class="fa fa-link"></i> <span>A propos de l'application</span></a></li>
          </ul>
		  <!-- /.sidebar-menu -->
        </section>
        <!-- /.sidebar -->
      </aside>

      <!-- Content Wrapper. Contains page content -->
      <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
          <h1>
            Comparateur de voitures électriques
            <small></small>
          </h1>
        </section>
		
        <!-- Main content -->
        <section class="content">
			
			
			<!-- BAR CHART -->
              <div class="box box-success">
                <div class="box-header with-border">
                  <h3 class="box-title">Comparaison entre voitures électriques</h3>
				  <div style="clear:both"></div>
				  <br />
				  Comparer: 
				  <div style="clear:both"></div>
				  <br />
				  <div class="col-sm-3">
                    <form method="post" action="?id=compare" class="formCompare">
					<input type="hidden" name="inputNbrYear" class="inputNbrYear" value="5"/>
				  <select class="form-control brand1" name="brand1">
					<option value="">Brand 1</option>
                      <?php
                      $res = $MySQLiconn->query("SELECT DISTINCT brand from vehicle");
					  while($row=$res->fetch_array())
                      { ?>
                          <option <?php if(isset($brand1) && $row['brand'] == $brand1) echo 'selected';?> value="<?php echo $row['brand']; ?>"><?php echo $row['brand']; ?></option>
                    <?php } ?>
				  </select>
				  </div>
				  <div class="col-sm-3">
				  <select class="form-control brand2" name="brand2" >
					<option value="">Brand 2</option>
                      <?php
                      $res = $MySQLiconn->query("SELECT DISTINCT brand from vehicle");
                      while($row=$res->fetch_array())
                      { ?>
                          <option <?php if(isset($brand2) && $row['brand'] == $brand2) echo 'selected';?> value="<?php echo $row['brand']; ?>"><?php echo $row['brand']; ?></option>
                      <?php } ?>
				  </select>
				  </div>
				  <div style="clear:both"></div>
				  <br />
				  <div class="col-sm-3">
					<select class="form-control model1" name="model1" <?php echo isset($model1) ? '' : 'disabled'; ?>>
					<option value="">Model 1</option>
                      <?php
                      $res = $MySQLiconn->query("SELECT * from vehicle");
					  while($row=$res->fetch_array())
                      { ?>
                          <option <?php if(isset($model1) && $row['model'] == $model1) echo 'selected';?> style="display:none" value="<?php echo $row['model']; ?>" brand="<?php echo $row['brand']; ?>" ><?php echo $row['model']; ?></option>
                    <?php } ?>
					</select>
				  </div>
				  <div class="col-sm-3">
				  <select class="form-control model2" name="model2" <?php echo isset($model2) ? '' : 'disabled'; ?>>
					  <option value="">Model 2</option>
                      <?php
                      $res = $MySQLiconn->query("SELECT * from vehicle");
                      while($row=$res->fetch_array())
                      { ?>
                          <option <?php if(isset($model2) && $row['model'] == $model2) echo 'selected';?> style="display:none" value="<?php echo $row['model']; ?>" brand="<?php echo $row['brand']; ?>"><?php echo $row['model']; ?></option>
                      <?php } ?>
				  </select>
				  </div>
				  <div style="clear:both"></div>
				  <br />
				  <div class="col-sm-3">
				  <select class="form-control year1" name="year1" <?php echo isset($year1) ? '' : 'disabled'; ?>>
					<option value="">Year 1</option>
                      <?php
					  $res = $MySQLiconn->query("SELECT * from vehicle");
                      while($row=$res->fetch_array())
                      { ?>
                          <option <?php if(isset($year1) &&  $row['year'] == $year1) echo 'selected';?>  style="display:none" value="<?php echo $row['year']; ?>" model="<?php echo $row['model']; ?>"><?php echo $row['year']; ?></option>
                    <?php } ?>
				  </select>
				  </div>
				  <div class="col-sm-3">
				  <select class="form-control year2" name="year2" <?php echo isset($year2) ? '' : 'disabled'; ?>>
					<option value="">Year 2</option>
                      <?php
                      $res = $MySQLiconn->query("SELECT * FROM vehicle");
                      while($row=$res->fetch_array())
                      { ?>
                          <option <?php if(isset($year2) && $row['year'] == $year2) echo 'selected';?> style="display:none" value="<?php echo $row['year']; ?>" model="<?php echo $row['model']; ?>"><?php echo $row['year']; ?></option>
                      <?php } ?>
				  </select>
				  </div>
				  <div class="col-sm-3">
				 <button onclick="validateCompare()" type="button" class="btn btn-primary">Comparer</button>
                      </form>
                  </div>
				 <br />
				 <br />
                  <div class="box-tools pull-right">
                    <button class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>
                    <button class="btn btn-box-tool" data-widget="remove"><i class="fa fa-times"></i></button>
                  </div>
                
                <div class="col-sm-4 box-body">
                  <div class="chart">
                    <canvas id="barChart1" style="height:230px; width:340;" height="230" width="340"></canvas>
                  </div>
                </div>
                <div class="col-sm-4 box-body">
                  <div class="chart">
                    <canvas id="barChart2" style="height:230px; width:340;" height="230" width="340"></canvas>
                  </div>
                </div>
                <div class="col-sm-4 box-body">
                  <div class=" chart">
                    <canvas id="barChart3" style="height:230px; width:340;" height="230" width="340"></canvas>
                  </div>
                </div>
				<!-- /.box-body -->
              </div><!-- /.box -->
			  
			  
				 <br />
				<div style="margin-left:40%">
					<h1 style="font-size:15px;width:10px;height:10px;background-color:#d2d6de;display:inline">&nbsp;&nbsp;&nbsp;</h1> <?php echo isset($voiture1['brand']) ? $voiture1['brand'] : '';?> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<h1 style="font-size:15px;width:10px;height:10px;background-color:#00a65a;display:inline">&nbsp;&nbsp;&nbsp;</h1> <?php echo isset($voiture2['brand']) ? $voiture2['brand'] : '';?> 
				</div>
          <!-- Your Page Content Here -->
				<div style="clear:both"></div>
				<br />
				<br />
				<br />
				<?php if(isset($_GET['id']) && $_GET['id'] == 'compare'){ ?>
				<div class="col-sm-6">
					Nombre d'année:
                    <div style="clear:both"></div>
				<br />
					<form method="post" action="?id=compare" class="formCompare2">
					  <select class="col-sm-6 form-control nbr_years" style="width:50% !important">
						<option value="1" <?php if(isset($inputNbrYear) && (int) $inputNbrYear == 1) echo 'selected';?>>1</option>
						<option value="2" <?php if(isset($inputNbrYear) && (int) $inputNbrYear == 2) echo 'selected';?>>2</option>
						<option value="3" <?php if(isset($inputNbrYear) && (int) $inputNbrYear == 3) echo 'selected';?>>3</option>
						<option value="4" <?php if(isset($inputNbrYear) && (int) $inputNbrYear == 4) echo 'selected';?>>4</option>
						<option value="5" <?php if(isset($inputNbrYear) && (int) $inputNbrYear == 5) echo 'selected';?>>5</option>
						<option value="6" <?php if(isset($inputNbrYear) && (int) $inputNbrYear == 6) echo 'selected';?>>6</option>
						<option value="7" <?php if(isset($inputNbrYear) && (int) $inputNbrYear == 7) echo 'selected';?>>7</option>
						<option value="8" <?php if(isset($inputNbrYear) && (int) $inputNbrYear == 8) echo 'selected';?>>8</option>
						<option value="9" <?php if(isset($inputNbrYear) && (int) $inputNbrYear == 9) echo 'selected';?>>9</option>
						<option value="10" <?php if(isset($inputNbrYear) && (int) $inputNbrYear == 10) echo 'selected';?>>10</option>
					  </select>
					  &nbsp;&nbsp;&nbsp;&nbsp;
					  &nbsp;&nbsp;&nbsp;&nbsp;
						<button onclick="validateCompare2()" type="button" style="float:right" class="col-sm-5 btn btn-primary">Valider</button>
                      </form>
                </div>
				
				<div class="col-sm-6 box-body">  
                  <div class=" chart">
                    <canvas id="barChart4" style="height:230px; width:340;" height="230" width="340"></canvas>
                  </div>
				</div>
				<?php }?>
				<div style="clear:both"></div>
				
				<div id="data-table">
                  <div id="main">
                    <?php if(isset($_GET['id']) && $_GET['id'] == 'compare'){ ?>
                    <table class="features-table">
                      <thead>
                      <tr>
                        <td>Modèle</td>
                        <td><?php echo $voiture1['model'];?></td>
                        <td><?php echo $voiture2['model'];?></td>
                      </tr>
                      </thead>
                      <tbody>
                      <tr>
                        <td>Marque</td>
                        <td border="1"><?php echo $voiture1['brand'];?></td>
                        <td border="1"><?php echo $voiture2['brand'];?></td>
                      </tr>
                      <tr>
                        <td>Année</td>
                        <td border="1"><?php echo $voiture1['year'];?></td>
                        <td border="1"><?php echo $voiture2['year'];?></td>
                      <tr>
                        <td>Drive Range (km)</td>
                        <td border="1"><?php echo 1.61*$voiture1['drive_range'];?></td>
                        <td border="1"><?php echo 1.61*$voiture2['drive_range'];?></td>
                      </tr>
                      <tr>
                      <tr>
                        <td>Fuel Cost ($)</td>
                        <td><?php echo $voiture1['fuel_cost']; ?></td>
                        <td><?php echo $voiture2['fuel_cost']; ?></td>
                      </tr>
                      <tr>
                        <td>Motor Power (kW)</td>
                        <td><?php echo $voiture1['motor_power']; ?></td>
                        <td><?php echo $voiture2['motor_power']; ?></td>
                      </tr>
                      <tr>
                        <td>Amount Saved ($)</td>
                        <td><?php echo $voiture1['amount_saved']; ?></td>
                        <td><?php echo $voiture2['amount_saved']; ?></td>
                      </tr>
                      <tr>
                        <td>Charge time (hours)</td>
                        <td><?php echo $voiture1['charge_time']; ?></td>
                        <td><?php echo $voiture2['charge_time']; ?></td>
                      </tr>
                      </tbody>
                    </table>
                    <?php }?>

                  </div>
				</br>
				</br>
                </div>
              </div><!-- /.box -->
			  
        </section><!-- /.content -->
      </div><!-- /.content-wrapper -->

      <!-- Main Footer -->
      <footer class="main-footer">
        <!-- To the right -->
        <div class="pull-right hidden-xs">
          Challenge Open Data
        </div>
        <!-- Default to the left -->
        <strong>Copyright &copy; 2016 <a href="#"></a>.</strong>
      </footer>

     <div class="control-sidebar-bg"></div>
    </div><!-- ./wrapper -->

    <!-- REQUIRED JS SCRIPTS -->

    <!-- jQuery 2.1.4 -->
    <script src="plugins/jQuery/jQuery-2.1.4.min.js"></script>
    <!-- Bootstrap 3.3.5 -->
    <script src="bootstrap/js/bootstrap.min.js"></script>
    <!-- AdminLTE App -->
    <script src="dist/js/app.min.js"></script>

    <!-- Optionally, you can add Slimscroll and FastClick plugins.
         Both of these plugins are recommended to enhance the
         user experience. Slimscroll is required when using the
         fixed layout. -->
		 
 <!-- REQUIRED JS SCRIPTS -->

    <!-- jQuery 2.1.4 -->
    <script src="plugins/jQuery/jQuery-2.1.4.min.js"></script>
    <!-- Bootstrap 3.3.5 -->
    <script src="bootstrap/js/bootstrap.min.js"></script>
    <!-- AdminLTE App -->
    <script src="dist/js/app.min.js"></script>
 <!-- ChartJS 1.0.1 -->
    <script src="plugins/chartjs/Chart.min.js"></script>
    <!-- FastClick -->
    <script src="plugins/fastclick/fastclick.min.js"></script>
    <!-- AdminLTE App -->
    <script src="dist/js/app.min.js"></script>
    <!-- AdminLTE for demo purposes -->
    <script src="dist/js/demo.js"></script>
    <!-- page script -->
    <script>
      $(function () {
        $('.brand1').on('change', function(){
			$('.model1').prop("disabled", false);
			$('.model1 option').each(function(){
				if($(this).attr('brand') == $('.brand1').val()){
					$(this).css('display', '');
				}
			})
		})
        $('.brand2').on('change', function(){
			$('.model2').prop("disabled", false);
			$('.model2 option').each(function(){
				if($(this).attr('brand') == $('.brand2').val()){
					$(this).css('display', '');
				}
			})
		})
        $('.model1').on('change', function(){
			$('.year1').prop("disabled", false);
			$('.year1 option').each(function(){
				if($(this).attr('model') == $('.model1').val()){
					$(this).css('display', '');
				}
			})
		})
        $('.model2').on('change', function(){
			$('.year2').prop("disabled", false);
			$('.year2 option').each(function(){
				if($(this).attr('model') == $('.model2').val()){
					$(this).css('display', '');
				}
			})
		})
		
		/* ChartJS
         * -------
         * Here we will create a few charts using ChartJS
         */
		 
		var areaChartData1 = {
          labels: ["Motor Power (kW)"],
          datasets: [
            {
              label: "<?php echo isset($voiture1['brand']) ? $voiture1['brand'] : '';?>",
              fillColor: "rgba(210, 214, 222, 1)",
              strokeColor: "rgba(210, 214, 222, 1)",
              pointColor: "rgba(210, 214, 222, 1)",
              pointStrokeColor: "#c1c7d1",
              pointHighlightFill: "#fff",
              pointHighlightStroke: "rgba(220,220,220,1)",
              data: [<?php echo (int) isset($voiture1['motor_power']) ? $voiture1['motor_power'] : 0;?>]
            },
            {
                label: "<?php echo isset($voiture2['brand']) ? $voiture2['brand'] : '';?>",
              fillColor: "rgba(60,141,188,0.9)",
              strokeColor: "rgba(60,141,188,0.8)",
              pointColor: "#3b8bba",
              pointStrokeColor: "rgba(60,141,188,1)",
              pointHighlightFill: "#fff",
              pointHighlightStroke: "rgba(60,141,188,1)",
              data: [<?php echo (int) isset($voiture2['motor_power']) ? $voiture2['motor_power'] : 0;?>]
            },
          ]
        };
		
		var areaChartData2 = {
          labels: ["Drive Range (km)"],
          datasets: [
            {
              label: "<?php echo isset($voiture1['brand']) ? $voiture1['brand'] : '';?>",
              fillColor: "rgba(210, 214, 222, 1)",
              strokeColor: "rgba(210, 214, 222, 1)",
              pointColor: "rgba(210, 214, 222, 1)",
              pointStrokeColor: "#c1c7d1",
              pointHighlightFill: "#fff",
              pointHighlightStroke: "rgba(220,220,220,1)",
			  data: [<?php echo (int) isset($voiture1['drive_range']) ? 1.61*$voiture1['drive_range'] : 0;?>]
            },
            {
                label: "<?php echo isset($voiture2['brand']) ? $voiture2['brand'] : '';?>",
              fillColor: "rgba(60,141,188,0.9)",
              strokeColor: "rgba(60,141,188,0.8)",
              pointColor: "#3b8bba",
              pointStrokeColor: "rgba(60,141,188,1)",
              pointHighlightFill: "#fff",
              pointHighlightStroke: "rgba(60,141,188,1)",
              data: [<?php echo (int) isset($voiture2['drive_range']) ? 1.61*$voiture2['drive_range'] : 0;?>]
            },
          ]
        };
		
		var areaChartData3 = {
          labels: ["Fuel Cost ($)"],
          datasets: [
            {
              label: "<?php echo isset($voiture1['brand']) ? $voiture1['brand'] : '';?>",
              fillColor: "rgba(210, 214, 222, 1)",
              strokeColor: "rgba(210, 214, 222, 1)",
              pointColor: "rgba(210, 214, 222, 1)",
              pointStrokeColor: "#c1c7d1",
              pointHighlightFill: "#fff",
              pointHighlightStroke: "rgba(220,220,220,1)",
			  data: [<?php echo (int) isset($voiture1['fuel_cost']) ? $voiture1['fuel_cost'] : 0;?>]
            },
            {
                label: "<?php echo isset($voiture2['brand']) ? $voiture2['brand'] : '';?>",
              fillColor: "rgba(60,141,188,0.9)",
              strokeColor: "rgba(60,141,188,0.8)",
              pointColor: "#3b8bba",
              pointStrokeColor: "rgba(60,141,188,1)",
              pointHighlightFill: "#fff",
              pointHighlightStroke: "rgba(60,141,188,1)",
              data: [<?php echo (int) isset($voiture2['fuel_cost']) ? $voiture2['fuel_cost'] : 0;?>]
            },
          ]
        };
		
		var areaChartData4 = {
          labels: ["Amount Saved ($)"],
          datasets: [
            {
              label: "<?php echo isset($voiture1['brand']) ? $voiture1['brand'] : '';?>",
              fillColor: "rgba(210, 214, 222, 1)",
              strokeColor: "rgba(210, 214, 222, 1)",
              pointColor: "rgba(210, 214, 222, 1)",
              pointStrokeColor: "#c1c7d1",
              pointHighlightFill: "#fff",
              pointHighlightStroke: "rgba(220,220,220,1)",
			  data: [<?php echo (int) isset($voiture1['amount_saved']) ? ($inputNbrYear == 5) ? $voiture1['amount_saved'] : ( $inputNbrYear * $voiture1['amount_saved'] / 5 ) : 0;?>]
            },
            {
                label: "<?php echo isset($voiture2['brand']) ? $voiture2['brand'] : '';?>",
              fillColor: "rgba(60,141,188,0.9)",
              strokeColor: "rgba(60,141,188,0.8)",
              pointColor: "#3b8bba",
              pointStrokeColor: "rgba(60,141,188,1)",
              pointHighlightFill: "#fff",
              pointHighlightStroke: "rgba(60,141,188,1)",
              data: [<?php echo (int) isset($voiture2['amount_saved']) ? ($inputNbrYear == 5) ? $voiture2['amount_saved'] : ( $inputNbrYear * $voiture2['amount_saved'] / 5 ) : 0;?>]
            },
          ]
        };

		
        //-------------
        //- BAR CHART -
        //-------------
        var barChartCanvas1 = $("#barChart1").get(0).getContext("2d");
        var barChart1 = new Chart(barChartCanvas1);
        var barChartData1 = areaChartData1;
        barChartData1.datasets[1].fillColor = "#00a65a";
        barChartData1.datasets[1].strokeColor = "#00a65a";
        barChartData1.datasets[1].pointColor = "#00a65a";
        var barChartOptions1 = {
          //Boolean - Whether the scale should start at zero, or an order of magnitude down from the lowest value
          scaleBeginAtZero: true,
          //Boolean - Whether grid lines are shown across the chart
          scaleShowGridLines: true,
          //String - Colour of the grid lines
          scaleGridLineColor: "rgba(0,0,0,.05)",
          //Number - Width of the grid lines
          scaleGridLineWidth: 1,
          //Boolean - Whether to show horizontal lines (except X axis)
          scaleShowHorizontalLines: true,
          //Boolean - Whether to show vertical lines (except Y axis)
          scaleShowVerticalLines: true,
          //Boolean - If there is a stroke on each bar
          barShowStroke: true,
          //Number - Pixel width of the bar stroke
          barStrokeWidth: 2,
          //Number - Spacing between each of the X value sets
          barValueSpacing: 5,
          //Number - Spacing between data sets within X values
          barDatasetSpacing: 1,
          //String - A legend template
          legendTemplate: "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<datasets.length; i++){%><li><span style=\"background-color:<%=datasets[i].fillColor%>\"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>",
          //Boolean - whether to make the chart responsive
          responsive: true,
          maintainAspectRatio: true
        };

        // barChartOptions1.datasetFill = false;
        barChart1.Bar(barChartData1, barChartOptions1);
		
		//-------------
        //- BAR CHART -
        //-------------
        var barChartCanvas2 = $("#barChart2").get(0).getContext("2d");
        var barChart2 = new Chart(barChartCanvas2);
        var barChartData2 = areaChartData2;
        barChartData2.datasets[1].fillColor = "#00a65a";
        barChartData2.datasets[1].strokeColor = "#00a65a";
        barChartData2.datasets[1].pointColor = "#00a65a";
        var barChartOptions2 = {
          //Boolean - Whether the scale should start at zero, or an order of magnitude down from the lowest value
          scaleBeginAtZero: true,
          //Boolean - Whether grid lines are shown across the chart
          scaleShowGridLines: true,
          //String - Colour of the grid lines
          scaleGridLineColor: "rgba(0,0,0,.05)",
          //Number - Width of the grid lines
          scaleGridLineWidth: 1,
          //Boolean - Whether to show horizontal lines (except X axis)
          scaleShowHorizontalLines: true,
          //Boolean - Whether to show vertical lines (except Y axis)
          scaleShowVerticalLines: true,
          //Boolean - If there is a stroke on each bar
          barShowStroke: true,
          //Number - Pixel width of the bar stroke
          barStrokeWidth: 2,
          //Number - Spacing between each of the X value sets
          barValueSpacing: 5,
          //Number - Spacing between data sets within X values
          barDatasetSpacing: 1,
          //String - A legend template
          legendTemplate: "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<datasets.length; i++){%><li><span style=\"background-color:<%=datasets[i].fillColor%>\"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>",
          //Boolean - whether to make the chart responsive
          responsive: true,
          maintainAspectRatio: true
        };

        // barChartOptions.datasetFill = false;
        barChart2.Bar(barChartData2, barChartOptions2);
		
		//-------------
        //- BAR CHART -
        //-------------
        var barChartCanvas3 = $("#barChart3").get(0).getContext("2d");
        var barChart3 = new Chart(barChartCanvas3);
        var barChartData3 = areaChartData3;
        barChartData3.datasets[1].fillColor = "#00a65a";
        barChartData3.datasets[1].strokeColor = "#00a65a";
        barChartData3.datasets[1].pointColor = "#00a65a";
        var barChartOptions3 = {
          //Boolean - Whether the scale should start at zero, or an order of magnitude down from the lowest value
          scaleBeginAtZero: true,
          //Boolean - Whether grid lines are shown across the chart
          scaleShowGridLines: true,
          //String - Colour of the grid lines
          scaleGridLineColor: "rgba(0,0,0,.05)",
          //Number - Width of the grid lines
          scaleGridLineWidth: 1,
          //Boolean - Whether to show horizontal lines (except X axis)
          scaleShowHorizontalLines: true,
          //Boolean - Whether to show vertical lines (except Y axis)
          scaleShowVerticalLines: true,
          //Boolean - If there is a stroke on each bar
          barShowStroke: true,
          //Number - Pixel width of the bar stroke
          barStrokeWidth: 2,
          //Number - Spacing between each of the X value sets
          barValueSpacing: 5,
          //Number - Spacing between data sets within X values
          barDatasetSpacing: 1,
          //String - A legend template
          legendTemplate: "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<datasets.length; i++){%><li><span style=\"background-color:<%=datasets[i].fillColor%>\"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>",
          //Boolean - whether to make the chart responsive
          responsive: true,
          maintainAspectRatio: true
        };

        // barChartOptions3.datasetFill = false;
        barChart3.Bar(barChartData3, barChartOptions3);
		
		
		//-------------
        //- BAR CHART -
        //-------------
        var barChartCanvas4 = $("#barChart4").get(0).getContext("2d");
        var barChart4 = new Chart(barChartCanvas4);
        var barChartData4 = areaChartData4;
        barChartData4.datasets[1].fillColor = "#00a65a";
        barChartData4.datasets[1].strokeColor = "#00a65a";
        barChartData4.datasets[1].pointColor = "#00a65a";
        var barChartOptions4 = {
          //Boolean - Whether the scale should start at zero, or an order of magnitude down from the lowest value
          scaleBeginAtZero: true,
          //Boolean - Whether grid lines are shown across the chart
          scaleShowGridLines: true,
          //String - Colour of the grid lines
          scaleGridLineColor: "rgba(0,0,0,.05)",
          //Number - Width of the grid lines
          scaleGridLineWidth: 1,
          //Boolean - Whether to show horizontal lines (except X axis)
          scaleShowHorizontalLines: true,
          //Boolean - Whether to show vertical lines (except Y axis)
          scaleShowVerticalLines: true,
          //Boolean - If there is a stroke on each bar
          barShowStroke: true,
          //Number - Pixel width of the bar stroke
          barStrokeWidth: 2,
          //Number - Spacing between each of the X value sets
          barValueSpacing: 5,
          //Number - Spacing between data sets within X values
          barDatasetSpacing: 1,
          //String - A legend template
          legendTemplate: "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<datasets.length; i++){%><li><span style=\"background-color:<%=datasets[i].fillColor%>\"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>",
          //Boolean - whether to make the chart responsive
          responsive: true,
          maintainAspectRatio: true
        };

        // barChartOptions3.datasetFill = false;
        barChart4.Bar(barChartData4, barChartOptions4);
      });
    </script>
  </body>
</html>

<!DOCTYPE html>
<!-- #include file = "consulta_documento_proc.asp" -->
<%
	Set consulta_controlador = new Controlador_Consulta
	
	documentos = consulta_controlador.Consultar()
	if request.Form("Documento") <> "" then
		response.write "<script>alert('Espere estamos procesando la consulta');</script>"
		
		if request.Form("Documento") <> "39" AND request.Form("Documento") <> "41" then
			consulta_controlador.enviar_dte request.Form("Documento"), request.Form("Folio"), request.Form("Monto"), request.Form("Fecha")
		else
			consulta_controlador.enviar_boleta request.Form("Documento"), request.Form("Folio"), request.Form("Monto"), request.Form("Fecha")
		end if 
	end if
	if request.QueryString("texto")= 1 then
		response.redirect "http://fangorn.upacifico.cl/sigaupa/documentos_electronicos/consulta_documentos/notfound.html"
	end if
	
%>
<html lang="es">
	<head>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<meta charset="utf-8">
		<title>Consultar Documentos Electrónicos</title>
		<link rel="icon" href="http://web.upacifico.cl/animated_favicon1.gif" type="image/gif" >
		<meta name="generator" content="" />
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
		<link href='http://fonts.googleapis.com/css?family=Roboto:400,100,300,700' rel='stylesheet' type='text/css'>
		<link href="css/bootstrap.css" rel="stylesheet">
		<!--[if lt IE 9]>
			<script src="//html5shim.googlecode.com/svn/trunk/html5.js"></script>
		<![endif]-->
		<link href="css/prettify.css" rel="stylesheet">
		<link href="css/datepicker.css" rel="stylesheet">
		
		<script src="js/prettify.js"></script>
		<script src="js/jquery.js"></script>
		<script src="js/bootstrap-datepicker.js"></script>
		<script src="js/bootstrap-datepicker.es.min.js"></script>
		<script language="JavaScript">
			function Solo_Numerico(variable){
				Numer=parseInt(variable);
				if (isNaN(Numer)){
					return "";
				}
				return Numer;
			}
			
			function esnumero(Control){
				Control.value=Solo_Numerico(Control.value);
			}
			
			function Obligatorio()
			{
				if(document.getElementById("Documento").value=="-1")
				{
					alert('Seleccione un tipo de documento');
					return false;
				}
				inputs = document.getElementsByTagName('input');
				for (index = 0; index < inputs.length; ++index) {
					if(document.getElementById(inputs[index].id).className.indexOf("Obli")!= -1 && document.getElementById(inputs[index].id).value=="")
					{
						alert('Ingrese '+inputs[index].id);
						return false;
					}
				}
				return true;
			}
		</script>
	</head>
	<body>
<!--login modal-->
<div id="loginModal" class="modal show" tabindex="-1" role="dialog" aria-hidden="true" >
  <div class="modal-dialog">
  <div class="modal-content" >
      <div class="modal-header">
          
           <h1 class="text-center"><img src="img/logo.png"  /></h1>
		   <div class="well">
		   <h1 class="text-center">Consultar Documentos Electrónicos</h1>
		   </div>
      </div>
      <div class="modal-body">
          <form class="form col-md-12 center-block" method="post" action="index.asp" name="formulario" id="formulario" onsubmit="return Obligatorio();">
			<div  style="float:left">
				<table>
					<tr>
						<td>
							<div class="well2">
								<h2 class="text-center">Ingrese Valores</h2>
							</div>
							<table>
								<tr>
                                	<td>Empresa</td>
                                    <td>:</td>
									<td>
									
										<div class="form-group">
											<input type="text" class="form-control input-lg Obli" placeholder="Empresa" id="Empresa" name="Empresa" value="Universidad del Pacífico" readonly>
										</div>
									</td>
								</tr>
								<tr>
									<td>Documento</td>
                                    <td>:</td>
									<td>
										<div class="form-group">
											<select class="form-control input-lg O" placeholder="Documento" id="Documento" name="Documento" >
												<option value="-1">Seleccione un Documento</option>
												<%
													for each documento IN documentos
														response.write "<option value="&documento(0)&">"&documento(1)&"</option>"
													next
												%>
											</select>
										</div>
									</td>
								</tr>
								<tr>
									<td>Folio</td>
                                    <td>:</td>
									<td>
										<div class="form-group">
											<input type="text" class="form-control input-lg Obli" placeholder="Folio" id="Folio" name="Folio" onKeyDown="esnumero(this)" onBlur="esnumero(this)" onKeyUp="esnumero(this)">
										</div>
									</td>
								</tr>
								<tr>
									<td>Monto</td>
									<td>:</td>
									<td>
										<div class="form-group">
											<input type="text" class="form-control input-lg Obli" placeholder="Monto" id="Monto" name="Monto" onKeyDown="esnumero(this)" onBlur="esnumero(this)" onKeyUp="esnumero(this)">
										</div>
									</td>
								</tr>
								<tr>
									<td>Fecha Emisión</td>
									<td>:</td>
									<td>
										<div class="form-group">
											<input type="text" id="Fecha" name="Fecha"  class="Obli" readonly/>
										</div>
									</td>
								</tr>
							</table>
						</td>
						<td>
							
							<div class="well" style="float: left; margin-left: 50px; height: 270px; width: 220px;">
								<div id="dp6" name="dp6" data-date-format="yyyy-mm-dd" class="Obli"></div>
							</div>
							
						</td>
					</tr>
				</table>
                <hr>
				<div style="clear:both"></div>
				<div class="form-group">
					<input type="submit" class="btn btn-primary btn-lg btn-block" value="Buscar" />
				</div>
            </div> 
          </form>
      </div>
      <div class="modal-footer">
          <div class="col-md-12">
			<button class="btn" data-dismiss="modal" aria-hidden="true" onClick="javascript:window.location='http://www.upacifico.cl';">Volver</button>
		  </div>	
      </div>
  </div>
  </div>
</div>
	<!-- scripts -->
	<script>
		$(function(){
			window.prettyPrint && prettyPrint();               
            //inline    
            $('#dp6').datepicker({
                todayBtn: 'linked',
				language: 'es'
            });
			
			$("#dp6").on("changeDate", function(event) {
				$("#Fecha").val(
					$("#dp6").datepicker('getFormattedDate')
				 )
			});  
		});
	</script>
	</body>
</html>
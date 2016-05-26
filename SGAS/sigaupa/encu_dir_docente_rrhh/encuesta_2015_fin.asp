<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<% 
'------------------------------------------------------
origen = request.QueryString("origen")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'EndTime = Now() + (16/ (24 * 60* 60)) '8 seconds
'Do While Now() < EndTime
'Do nothing
'Loop
'Response.Redirect("responder_encuesta_2015.asp")

if (origen = 1) then
	mensaje = "No existen docentes a evaluar."
else
	mensaje = "Gracias por responder la encuesta, sus datos fueron enviados con éxito."	
end if
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Evaluaci&oacute;n docente</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumnos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
var t_parametros;

function Inicio()
{
	t_parametros = new CTabla("p")
}

function dibujar(formulario){
	document.getElementById("texto_alerta").style.visibility="visible";
	formulario.submit();
}

function ayuda (valor)
{ var mensaje="";
    mensaje = "AYUDA\nComo una forma de modernizar y entregar mayor flexibilidad al instrumento de evaluación docente, se ha generado esta función para que los alumnos evaluen directamente a los profesores que les impartieron clases durante el presente año, esta evaluación es pre-requisito para la toma de carga de periodos siguientes. El proceso a seguir es el siguiente:\n\n" +
	       	  "- Del listado de asignaturas, seleccionar alguna que tenga la columna 'Avance' con cuadros en blanco.\n"+
			  "- Avanzar por las páginas contestando la encuesta y dejar algunos comentarios, luego de esto presionar el botón cerrar encuesta."+
			  "\n\n\n Recuerde evaluar todas sus asignaturas ya que el no hacerlo puede presentar problemas cuando intente tomar carga académica";
		   
	alert(mensaje);
} 
function validar_ingreso()
{
  var plec = '<%=plec_ccod_enc%>';
  /*if (plec == '2')
    { 
	  alert("El proceso de evaluación docente 2do Semestre se abrirá a mediados del semestre.");
	}
  else
    {*/ 
  document.edicion.submit();
	//}
}
function redirect(){
	timer = setTimeout(redirije,3000);	
}

function redirije(){
	location.href="portada_encuesta.asp";
}
</script>
<style type="text/css">
#menu div.barraMenu,
#menu div.barraMenu a.botonMenu {
font-family: sans-serif, Verdana, Arial;
font-size: 8pt;
color: white;
}

#menu div.barraMenu {
text-align: left;
}

#menu div.barraMenu a.botonMenu {
background-color: #4b73a6;
border-bottom-style:double;
border-color:#FFFFFF;
color: white;
cursor: pointer;
padding: 4px 6px 2px 5px;
text-decoration: none;
}

#menu div.barraMenu a.botonMenu:hover {
background-color: #FFFFFF;
color:#4b73a6;
}

#menu div.barraMenu a.botonMenu:active {
background-color: #637D4D;
color: black;
}
</style>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" background="imagenes/fondo.jpg" onLoad="javascript:redirect();">
<center>
<table align="center" width="700">
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>Evaluaci&oacute;n de desempe&ntilde;o docente</strong></font></td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<!--Antecedentes educacionales-->
	<tr>
		<td width="100%" align="left">&nbsp;</td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="left">
			<table width="700" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
						
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
                                        
										   <td width="84%"><div align="center"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong><%=mensaje%></strong></font></div></td>
										   
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">&nbsp;</td>
							</tr>

						</table>
					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>
		</td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
</table>
</center>
</body>
</html>


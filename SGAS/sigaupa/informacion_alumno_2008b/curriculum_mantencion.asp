<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<% 
'------------------------------------------------------

 q_npag	= Request.QueryString("npag")
 traspaso 	= Request.QueryString("traspaso")
 if traspaso = "" then
 	tipo_traspaso="0"
 else
 	tipo_traspaso="1"
 end if	

 
 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores

 set negocio = new CNegocio
 negocio.Inicializa conexion


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Bienvenido a Universidad del Pac&iacute;fico Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumnos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function mensaje(){
	<%if es_alumno = 0 then%>
	alert('La persona ingresada no se ha matriculado en el período académico actual.')
	<%end if%>
}

function irPagina2(){
	window.location = '<%=dir_JS%>';
}

function salir_aplicacion(){
    var tipo_traspaso = '<%=tipo_traspaso%>';
	if (tipo_traspaso=='0')
	 {window.location = '../lanzadera/lanzadera.asp';}
	else
	 {window.close();} 
}
function ayuda (valor)
{ var mensaje="";
    mensaje = "AYUDA\nLa Ficha de antecedentes personales, le entrega información al alumnado de cuales son los datos que tenemos registrados en el sistema;\n" +
	       	  "Datos que deben ser corroborados por cada alumno y en caso de presentar alguna anomalía o que requiera ser cambiado, rogamos comunicarse con departamento de registro curricular\n"+
		      "Los botones de esta función permiten navegar entre las dos páginas, para ver datos personales, domicilios, datos académicos y familiares.\n"+
		      "En una futura versión se pretende desarrollar la opción para que el alumno modifique sus datos directamente desde cualquier PC conectado a Internet.";
		   
		   
	alert(mensaje);
}
function maximaLongitud(texto,maxlong) {
var tecla, in_value, out_value;

if (texto.value.length > maxlong) {
in_value = texto.value.toUpperCase();
out_value = in_value.substring(0,maxlong);
texto.value = out_value;

return false;
}
return true;
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

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" background="imagenes/fondo.jpg">
<center>
<table align="center" width="700">
<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
									  <tr><td height="20" colspan="4">&nbsp;</td></tr>
									  <tr>
									       <td height="20" colspan="4" align="center">
									  			<table width="90%" border="0" bordercolor="#496da6">
													<tr>
													  <td width="5%"><img src="imagenes/alert.png" width="178" height="174" /></td>
													  <td width="95%"   align="center"><div align="center">
            <p><font color="#333333" size="3" face="Verdana, Arial, Helvetica, sans-serif"><strong>Disculpe las molestias</strong></font></p>
            <p><strong><font color="#333333" size="3" face="Verdana, Arial, Helvetica, sans-serif">En este momento estamos realizando mantenciones a Curriculum Virtual.</font></strong></p>
          </div>				  </td>
												    </tr>
											 </table>
									       </td>
									  </tr>
									  <tr>
									  		<td height="20" colspan="2">&nbsp;</td>
									  		<td width="40%" height="20" colspan="2"><a href="javascript:_Navegar(this, 'mensajes.asp', 'FALSE');"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
										 <img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME">	</td>
									  </tr>
									  <tr><td height="20" colspan="4">&nbsp;</td></tr>
                                  
								  </table>
                  
								</td>
							</tr>
</table>
</center>
</body>
</html>


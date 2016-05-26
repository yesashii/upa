<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<% 
'------------------------------------------------------
	'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
	'next
	
	cscu_ncorr	= Request.QueryString("cscu_ncorr")
	q_pers_nrut = Request.QueryString("pers_nrut")
	'response.write("cscu_ncorr="&cscu_ncorr)
'response.End()
 
 
 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores

 set negocio = new CNegocio
 negocio.Inicializa conexion

 
  if esVacio(q_pers_nrut) then
	 q_pers_xdv = conexion.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
  end if
 

 '-- Botones de la pagina -----------
 set f_botonera = new CFormulario
 f_botonera.Carga_Parametros "curriculum_alumno.xml", "botonera"
 

'---------------------------------------------------------------------------------------------------

 set f_seminario = new CFormulario
 f_seminario.Carga_Parametros "curriculum_alumno.xml", "seminario_curso"
 f_seminario.Inicializar conexion

 if cscu_ncorr ="" then
	selec_seminario="select ''"
 else				
 	selec_seminario="select cscu_ncorr,cscu_tnombre,pers_ncorr,cscu_ano,cscu_tinstitucion,ticu_ccod from curso_seminario_curriculum where cscu_ncorr="&cscu_ncorr&""
 end if
 f_seminario.Consultar selec_seminario
 f_seminario.Siguiente

 '------------------------------------------------------------------------------------------ 
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
	<form name="curso_diplomado">
	<input type="hidden" name="semi[0][cscu_ncorr]" value="<%=cscu_ncorr%>">
	<input type="hidden" name="semi[0][pers_nrut]" value="<%=q_pers_nrut%>">
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
										    <td width="37%" height="23"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Formacion Extra Acad&eacute;mica </strong></font></td>
										    <td width="52%"><hr></td>
										   <TD width="11%">
										   		<%POS_IMAGEN = 0%>
										   		<a href="javascript:ayuda(1)"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda2.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda1.png';return true ">
												<img src="imagenes/ayuda1.png" border="0" width="38" height="38" alt="¿Cómo funciona?">												</a>										  </TD>
										</tr>
									</table>								</td>
							</tr>
							<tr>
								<td width="100%" align="center" colspan="2">
									<table width="100%" border="0" cellpadding="1" cellspacing="3">
									  <tr> 
										
										
										<td colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Tipo</strong></font></td>
										<td colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nombre</strong></font></td>
										
									  </tr>
									  <tr valign="top" > 
											<td colspan="2"> 
												 <table width="100%" border="0" cellpadding="0" cellspacing="0">
													<tr> 
													 <td ><%f_seminario.dibujaCampo("ticu_ccod")%></td>
													</tr>
											  </table>											</td>
											<td colspan="2">
												 <table width="80%" border="0" cellpadding="0" cellspacing="0" >
													<tr>
													<td ><%f_seminario.dibujaCampo("cscu_tnombre")%></td></tr>
									    </table>										</td>
											
											
									  </tr>
                                      <tr> 
									  <tr valign="top" > 
										<td height="20" colspan="2"> <table width="100%" border="0" cellpadding="0" cellspacing="0" >
											<tr><td width="36%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Institucion</strong></font></td></tr>
									    </table>									    </td>
										 <td colspan="2"> <table width="100%" border="0" cellpadding="0" cellspacing="0" >
											<tr><td width="36%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Año</strong></font></td></tr>
										  </table>									    </td>
										  
										
									  </tr>
									  <td colspan="2"> 
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" >
													<tr> 
													  <td ><%f_seminario.dibujaCampo("cscu_tinstitucion")%></td>
													</tr>
											  </table>											</td>
											<td colspan="2">
												 <table width="80%" border="0" cellpadding="0" cellspacing="0" >
													<tr><td ><%f_seminario.dibujaCampo("cscu_ano")%></td></tr>
									    </table>										</td>
											
											
									  </tr>
									   <tr>
										<td height="10" colspan="1"></td>
										<td height="10" colspan="2"><hr></td>
										<td height="10" colspan="1"></td>
									   
									  </tr>
									  <td width="33%"></td>
									  <td width="17%"></td>
								        <td width="21%" height="10" align="right">
										<%POS_IMAGEN = POS_IMAGEN + 1%>
										<a href="javascript:_Guardar(this, document.forms['curso_diplomado'], 'proc_curso_diplomado.asp','', '', '', 'FALSE');"
																onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/GUARDAR2.png';return true "
																onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/GUARDAR1.png';return true "><img src="imagenes/GUARDAR1.png" border="0" width="70" height="70" alt="Guardar"></a></td>
										
    <td width="29%" height="10" align="left"><%POS_IMAGEN = POS_IMAGEN + 1%>
      <a href="javascript:_Navegar(this, 'curriculum.asp?npag=2', 'FALSE');"
												onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
												onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true "> <img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> </a> </td>
                                       <tr>
								  </table>								</td>
							</tr>
						</table>					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>		</td>
	</tr>
	</form >
	
	<!--Datos entregados para admisión-->
	<tr>
		<td width="100%" align="left">		</td>
	</tr>
</table>

</center>
</body>
</html>


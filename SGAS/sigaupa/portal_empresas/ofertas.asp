<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_empresa.asp" -->
<% 
'------------------------------------------------------

 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores

 set negocio = new CNegocio
 negocio.Inicializa conexion


q_rut=negocio.obtenerUsuario
'  q_rut =Request("daem[0][rut]")
'  q_dv=Request("daem[0][dv]")

 '-- Botones de la pagina -----------
 set f_botonera = new CFormulario
 f_botonera.Carga_Parametros "empresa.xml", "botonera"
 
 '---------------------------------------------------------------------------------------------------
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "empresa.xml", "busqueda"
 f_busqueda.Inicializar conexion

 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 empr_ncorr=conexion.ConsultaUno("select empr_ncorr from empresas where empr_nrut="&q_rut&"")

'---------------------------------------------------------------------------------------------------
set f_oferta_trabajo = new CFormulario
 f_oferta_trabajo.Carga_Parametros "empresa.xml", "muestra_oferta"
 f_oferta_trabajo.Inicializar conexion
 
				 selec_antecedentes="select * from ofertas_laborales where convert(datetime,protic.trunc(ofta_fcaducidad_oferta),103)>=convert(datetime,getdate(),103)and empr_ncorr="&empr_ncorr&" and ofta_estado=2 order by ofta_fcreacion desc"
			
 f_oferta_trabajo.Consultar selec_antecedentes
' f_oferta_trabajo.Siguiente
 'response.write(selec_antecedentes)
'-----------------------------------------------------------------------------------------------
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Bienvenido a Universidad del Pac&iacute;fico Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" src="../biblioteca/dicc_ciudades.js"></script>
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">
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
body {
	background-color: #FFFFFF;
}
</style>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" background="imagenes/fondo.jpg">
 <form name="oferta_trabajo">
 <input type="hidden" name="ofta[0][empre_ncorr]" value="<%=empr_ncorr%>">
<input type="hidden" name="ofta[0][pers_nrut]" value="<%=pers_nrut%>">
<center>

  <table width="793"  align="center">
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>MEN&Uacute; PRINCIPAL </strong></font></td>
	</tr>
	<tr valign="top">
		<td width="100%"  align="left">
			<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="97%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="50%" align="center">
									<table width="70%">
										<tr>
											<td align="right">Paginas: <%f_oferta_trabajo.accesopagina%></td>
										</tr>
										<tr>
											<td align="center" valign="top">
												<%f_oferta_trabajo.DibujaTabla()%>	
											</td>
										</tr>
							  	  </table>
							  </td>
							</tr>
							<tr>
								<td>
									
									<table width="718">
										<tr>
										  <td width="434" height="10">&nbsp;</td>
										  <td width="129" height="10" align="center"><%POS_IMAGEN = 0%>
										  <a href="javascript:_Navegar(this, 'inicio_empresa.asp', 'FALSE');"
														onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
														onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true "> <img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> </a>										  </td>
										  <td width="139" height="10" align="left"><%POS_IMAGEN = POS_IMAGEN + 1%>
										   <a href="javascript:_Eliminar(this, document.forms['oferta_trabajo'], 'proc_eliminar_oferta.asp', 'Despues de Borrar no podra Recuperar la Información', 'true');"
														onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ELIMINAR2.png';return true "
														onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ELIMINAR1.png';return true "> <img src="imagenes/ELIMINAR1.png" border="0" width="70" height="70" alt=""> </a>
  										  </td>
										</tr>
								  </table>								
								  </td>
							</tr>
				 		</table>
	 				</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>		
		</td>
	</tr>
</table>
</center>
 <form>
</body>
</html>

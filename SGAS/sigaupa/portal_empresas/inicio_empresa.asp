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
'---------------------------------------------------------------------------------------------------
set f_oferta_trabajo = new CFormulario
 f_oferta_trabajo.Carga_Parametros "empresa.xml", "f_oferta_trabajo"
 f_oferta_trabajo.Inicializar conexion
 
				 selec_antecedentes="select ''"
			
 f_oferta_trabajo.Consultar selec_antecedentes
 f_oferta_trabajo.Siguiente
 'response.write(exiete_empre_daem)
'-----------------------------------------------------------------------------------------------
consulta_ciudades = "select regi_ccod, ciud_ccod, ciud_tdesc, ciud_tcomuna from ciudades order by ciud_tdesc asc"
empr_ncorr=conexion.ConsultaUno("select empr_ncorr from empresas where empr_nrut="&q_rut&"")
pers_nrut=conexion.ConsultaUno("select daem_pers_nrut_contacto from datos_empresa where empr_ncorr="&empr_ncorr&"")
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

  <table width="593"  align="center">
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
							 <td width="50%" align="right">
									<table width="35%" height="156" >
										<tr>
											<td align="center" height="80%" valign="bottom">
												<a href="javascript:_Navegar(this, 'ofertas.asp', 'FALSE');"> 
													<img src="imagenes/oferta.png"  alt="" width="173" height="125" border="0">												</a>											</td>
										</tr>
					  	       </table>
							  </td>
							  <td width="50%" valign="top">
									<table width="35%" height="164" >
										<tr>
											<td align="center" valign="bottom">
												<a href="javascript:_Navegar(this, 'publica_1.asp', 'FALSE');"> 
													<img src="imagenes/crea_oferta.png" alt="" width="180" height="125"  border="0">												</a>											 </td>
										</tr>
								</table>
							  </td>
							   <td width="50%">
									<table width="25%" height="150" >
										<tr>
											<td align="center" height="80%" valign="bottom">
												<a href="javascript:_Navegar(this, 'salida.asp', 'FALSE');"> 
													<img src="imagenes/salir.png"  alt="" width="69" height="69" border="0">												
												</a>
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

<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Edicion comentarios"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

'set negocio = new CNegocio
'negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "cuenta_corriente_alumno.xml", "botonera"

'---------------------------------------------------------------------------------------------------
cod_comentario = Request.QueryString("come_ncorr")


set formulario = new CFormulario
formulario.Carga_Parametros "cuenta_corriente_alumno.xml", "edita_datos_comentario"
formulario.Inicializar conexion

if cod_comentario <> "" then
	 consulta = "select * from comentarios where come_ncorr="&cod_comentario
else  'modificar
  consulta = " select ''"
end if

formulario.Consultar consulta
formulario.Siguiente

v_editable=formulario.obtenervalor("come_beditable")
'response.Write(v_editable)


%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>EDICIÓN COMENTARIOS</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumnos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function cerrarVentana()
{
	window.close();
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
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>Detalle Comentario</strong></font></td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<!--Antecedentes educacionales-->
	<tr>
		<td width="100%" align="center">
			<table width="680" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="25%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Detalle Comentario</strong></font></td>
										   <td><hr></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
									  <tr valign="top">
									      <td colspan="4">
										  <form name="edicion">
											<%formulario.DibujaCampo("pers_ncorr")  %>
											<%formulario.DibujaCampo("come_ncorr")  %>
											<table width="100%" border="0">
											  <tr valign="top"> 
												<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Observacion</strong></font></td>
												<td><strong>:</strong></td>
												<td><%formulario.DibujaCampo("COME_TCOMENTARIO")  %> </td>
											  </tr>
											  <tr> 
												<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Fecha</strong></font></td>
												<td><strong>:</strong></td>
												<td><%formulario.DibujaCampo("COME_FCOMENTARIO")  %> (dd/mm/aaaa) </td>
											  </tr>
											  <tr> 
												<td width="17%"><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Tipo</strong></font></td>
												<td width="3%"><strong>:</strong></td>
												<td width="80%"><%formulario.DibujaCampo("TICO_CCOD")  %></td>
											  </tr>
											</table>
											</form>
										  <br>				  
										  </td>
									  </tr>
									  <tr> 
										<td colspan="4" align="center"><%botonera.dibujaboton "cancelar"%></td>
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
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
</table>

</center>
</body>
</html>
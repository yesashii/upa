<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
pers_ncorr=request.QueryString("pers_ncorr")
set pagina = new CPagina
pagina.Titulo = "Agregar Unidad"

set botonera =  new CFormulario
botonera.carga_parametros "responsable_unidad.xml", "btn_edita_modulos"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
periodo = negocio.obtenerPeriodoAcademico("Postulacion")
'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "responsable_unidad.xml", "agrega"
formulario.inicializar conexion

consulta= "SELECT email_upa as email from correo_responsables_otec a where pers_ncorr="&pers_ncorr&" " 

'response.write("<pre>"&consulta&"</pre>")
formulario.consultar consulta 

formulario.siguiente
nombre=conexion.ConsultaUno("select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno from personas where pers_ncorr="&pers_ncorr&"")
'response.Write("doras "&horas_Asignatura&" duracion "&duracion_asignatura)
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="380" border="0" align="center" cellpadding="0" cellspacing="0" >
  <tr valign="middle">
    <td valign="top" bgcolor="#EAEAEA">
		<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
		  <tr>
			<td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
			<td height="8" background="../imagenes/top_r1_c2.gif"></td>
			<td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
		  </tr>
		  <tr>
			<td width="9" background="../imagenes/izq.gif">&nbsp;</td>
			<td>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td height="2" background="../imagenes/top_r3_c2.gif"></td>
					  </tr>
					  <tr>
						<td>
				<table width="100%"  border="0">
					  <tr>
						<td>&nbsp;</td>
					  </tr>
					  <tr>
						<td><%pagina.DibujarSubtitulo "Editar Responsable"%></td>
					  </tr>
					  <tr>
						<td>&nbsp;</td>
					  </tr>
				 </table>
	
				 <form name="edicion" >
				 <input type="hidden" value="<%=pers_ncorr%>" name="a[0][pers_ncorr]">
				 <table width="100%">
				 	<tr>
						<td align="right">Nombre</td>
						<td><strong><%=nombre%></strong></td>
					</tr>
					<tr>
						<td align="right" width="16%">Email</td>
						<td width="84%"><%formulario.DibujaCampo("email")%></td>
					</tr>
				 	
					<tr>
						<td colspan="2" align="right">&nbsp;</td>
					</tr>
				 </table>
				 </form>
							  
				
				</td>
			</tr>
			</table></td>
			<td width="7" background="../imagenes/der.gif">&nbsp;</td>
		  </tr>
		  <tr>
			<td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
			<td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
			  <tr>
				<td width="38%" height="20"><div align="center">
				  <table width="90%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
					  <td><div align="center"><%botonera.dibujaboton "volver1"%></div></td>
					  <td><div align="center"><%botonera.dibujaboton "guardar3"%></div></td>
					  <td><div align="center"></div></td>
					</tr>
				  </table>
				</div></td>
				<td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
				</tr>
			  <tr>
				<td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
			  </tr>
			</table></td>
			<td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
		  </tr>
		</table>
	</td>
  </tr>  
</table>
</body>
</html>

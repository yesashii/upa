<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
codigo= request.QueryString("codigo")

set pagina = new CPagina
pagina.Titulo = "Unidades"

set errores = new CErrores

set botonera =  new CFormulario
botonera.carga_parametros "agrega_unidades.xml", "btn_edita_modulos"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
periodo = negocio.obtenerPeriodoAcademico("Postulacion")
'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "agrega_unidades.xml", "unidades"
formulario.inicializar conexion

consulta= "SELECT UDPO_ccod, CASE WHEN UDPO_BHABILITADO='S' THEN  UDPO_tdesc WHEN UDPO_BHABILITADO='N' THEN  UDPO_tdesc+' (DESHABILITADO)' END AS UDPO_tdesc " & vbCrlf & _
		  " FROM UNIDADES_DICTAN_PROGRAMAS_OTEC order by  UDPO_tdesc" 

'response.write("<pre>"&consulta&"</pre>")
formulario.consultar consulta 

'formulario.siguiente

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
function Validar_Eliminacion(form){
mensaje="eliminar";
	if (verifica_check(form,mensaje)){
		return true;
	}
	
	return false;
}
function Validar_deshabilitar(form){
mensaje="deshabilitar";
	if (verifica_check(form,mensaje)){
		return true;
	}
	
	return false;
}
function Validar_habilitar(form){
mensaje="habilitar";
	if (verifica_check(form,mensaje)){
		return true;
	}
	
	return false;
}
function volver(){
	CerrarActualizar();
}

function validaCambios(){
	alert("..");
	return false;
}

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="380" border="0" align="center" cellpadding="0" cellspacing="0" >
  <tr valign="middle">
    <td valign="top" bgcolor="#EAEAEA" align="left">
	<br><br>
		<table width="98%"  border="0" align="left" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
				<form name="edicion" method="post"><table width="100%"  border="0">
					  <tr>
						<td>&nbsp;</td>
					  </tr>
					  <tr>
						<td><%pagina.DibujarSubtitulo "Unidades"%></td>
					  </tr>
					  <tr>
						<td>&nbsp;</td>
					  </tr>
				 </table>
	
				 <table width="98%" align="center">
					 <tr>
                             <td align="right">P&aacute;gina:<%formulario.accesopagina%></td>
                        </tr>
					  <tr> 
						 <td colspan="2" align="center"><%formulario.DibujaTabla%></td>
					  </tr>
					  <tr> 
						 <td valign="top" colspan="2">&nbsp;</td>
					  </tr>
				  </table>
							  
				</form>
				</td>
			</tr>
			</table></td>
			<td width="7" background="../imagenes/der.gif">&nbsp;</td>
		  </tr>
		  <tr>
			<td width="9" height="35"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="41"></td>
			<td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
			  <tr>
				<td width="97%" height="20"><div align="center">
				  <table width="90%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
					  <td><div align="center"><%botonera.dibujaboton "ir"%></div></td>
					  <td><div align="center"><%botonera.dibujaboton "eliminar"%></div></td>
					</tr>
					<tr>
					  <td><div align="center"><%botonera.dibujaboton "deshabilitar"%></div></td>
					  <td><div align="center"><%botonera.dibujaboton "habilitar"%></div></td>
					</tr>
				  </table>
				
				</td>
				<td width="3%" rowspan="5" ><img src="../imagenes/abajo_r1_c3.gif" width="12" height="40"></td>
			  </tr>
			  <tr>
				<td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
			  </tr>
			</table></td>
			<td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="47"></td>
		  </tr>
		</table>
	</td>
  </tr>  
</table>
</body>
</html>

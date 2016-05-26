<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set pagina = new CPagina
ip_usuario=Request.ServerVariables("REMOTE_ADDR")

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.InicializaPortal conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "matricula_breve.xml", "botonera"

set errores = new CErrores
'---------------Realizado para diferenciar las CARRERAS de Pregrado y Postgrado
tipo = request.QueryString("tipo")

if	not EsVacio(tipo) then
	session("tipo") = tipo
	if tipo = "1" then
	    ano_muestra="2009"
	else
		ano_muestra="2009"  
	end if		
end if

if esVacio(ano_muestra) then
	ano_muestra="2009"   
end if
'response.Write("tipo :" & session("tipo"))
'---------------------------------------------------------------------------------------------------
'----------------------iniciamos una variable de session para el periodo 2do semestre 2006 --------------
'session("periodo_postulacion") = "210"
session("periodo_postulacion") = "214"
%>
<html>
<head>
<title>Bienvenidos al proceso de admisión 2009</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>
<script language="JavaScript">
function clave() {
  direccion = "olvido_clave.asp";
  window.open(direccion ,"ventana1","width=370,height=310,scrollbars=no, left=313, top=200");
}
function salir() {
  window.close();
}
</script>
 
<style type="text/css">
<!--
.Estilo2 {
	color: #000000;
	font-weight: bold;
}
.Estilo4 {font-family: "Book Antiqua"; color: #000000; }
-->
</style>
</head>
<body background="../imagenes/bg.png" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">  
  <tr>
    <td valign="top" background="../imagenes/bg.png">
    <table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
	  <tr>
		<td colspan="3" valign="top" width="750" align="center" background="../imagenes/ventana_postulacion_01.gif">
		  <object type="application/x-shockwave-flash" data="../imagenes/banner_postulacion.swf" width="750" height="100">
						<param name="movie" value="../imagenes/banner_postulacion.swf" />
						<param name="quality" value="high" />
		  </object>
		</td>
	  </tr>
	  <tr valign="top">
	  	<td colspan="3" width="750" height="354" background="../imagenes/ventana_postulacion_02.gif">&nbsp;
				<table width="750" height="354" border="0" align="center" cellpadding="0" cellspacing="0">
				 	<tr>
						<td width="100%">&nbsp;</td>
					</tr>
                    <tr>
						<td width="100%">
							<form name="edicion" id="edicion">
							
                    <table width="65%" align="center" cellpadding="0" cellspacing="0" border="0">
                      <tr> 
                        <td colspan="3" align="center"><font size="4" face="Verdana, Arial, Helvetica, sans-serif" color="#0066FF"><strong>Antecedentes 
                          de Matricula</strong></font></td>
                      </tr>
                      <tr> 
                        <td colspan="3" align="center">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3" align="center"><font size="3" color="#000000" face="Times New Roman, Times, serif">Ingresa 
                          los datos de acceso solicitados</font></td>
                      </tr>
                      <tr> 
                        <td colspan="3" align="center">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3" align="center">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="55%" align="right"><input name="usuario" type="text" id="TO-N" size="25" maxlength="25" onBlur="this.value=this.value.toUpperCase();" tabindex="1"> 
                        </td>
                        <td width="22%" align="left"><font size="2" color="#000000" face="Times New Roman, Times, serif"><strong>&nbsp;USUARIO 
                          </strong></font> </td>
                        <td width="23%" align="left"><input type="button" name="aceptar" value="Ingresar" onClick="_Guardar(this, document.forms['edicion'], 'proc_index_matricula_breve.asp','', '', '', 'FALSE')" tabindex="3"></td>
                      </tr>
					  <tr> 
                        <td colspan="3" align="center">&nbsp;&nbsp;</td>
                      </tr>
                      <tr> 
                        <td align="right"><input name="clave" type="password" id="TO-N" size="25" maxlength="8" tabindex="2"> 
                          <font size="2" color="#000000" face="Times New Roman, Times, serif"><strong> 
                          </strong></font> </td>
                        <td colspan="2" align="left"><font size="2" color="#000000" face="Times New Roman, Times, serif"><strong>&nbsp;CLAVE 
                          </strong></font></td>
                      </tr>
                      
                      <tr> 
                        <td colspan="3" align="center">&nbsp;&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3" align="center">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3" align="center">&nbsp;</td>
                      </tr>
                    </table>
							</form>
						</td>
					</tr>
					<tr>
						<td width="100%">&nbsp;</td>
					</tr>

					<tr>
						
                <td width="100%" height="20" align="center"> <span class="pie"><font face="Verdana, Arial, Helvetica, sans-serif" color="#FFFFFF" size="1">Sede 
                  Las Condes 3665315 &#8226; Sede Melipilla 3524900 &#8226; Campus 
                  Lyon 3306400 &#8226; Campus Baquedano 3526900 </font></span></td>
					</tr>
					<tr>
						<td width="100%">&nbsp;</td>
					</tr> 
				</table>
		
		
		</td>
	  </tr>
	  
  
  
  
</table>
</td>
</tr>
</table>
</body>
</html>
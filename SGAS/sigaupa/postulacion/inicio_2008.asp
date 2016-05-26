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
	    ano_muestra="2008"
	else
		ano_muestra="2008"  
	end if		
end if

if esVacio(ano_muestra) then
	ano_muestra="2008"   
end if
'response.Write("tipo :" & session("tipo"))
'---------------------------------------------------------------------------------------------------
'----------------------iniciamos una variable de session para el periodo 2do semestre 2006 --------------
'session("periodo_postulacion") = "210"
session("periodo_postulacion") = "212"
%>
<html>
<head>
<title>Bienvenidos al proceso de admisión 2008</title>
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
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">  
  <tr>
    <td valign="top" bgcolor="#e1eae0">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td colspan="3" valign="top" bgcolor="#003366" width="750" align="center">
      <img src="../imagenes/vineta2_r1_c1_2008.jpg" width="750" height="100" alt="Admisión 2008" />
	</td>
  </tr>
  <tr>
    <td width="3%" valign="top" bgcolor="#CCCCCC">&nbsp;</td>
    <td width="42%" align="center" valign="top" bgcolor="#CCCCCC">
		<table width="95%" border="00">

		     <tr>
			     <td><br>
			       <span class="Estilo2"><font size="3" face="Times New Roman, Times, serif">Bienvenido 
                            al Proceso de Admisi&oacute;n<br>
                            Segundo Semestre <%=ano_muestra%></font></span></td>
			 </tr>
			 <tr>
			     <td><hr></td>
			 </tr>
			 <tr>

			     <td><font size="2"><span class="Estilo4">Te invitamos a ingresar tus datos a la <strong>Ficha de Postulación.</strong></span></font></td>
			 </tr>
			 <tr>
			     <td height="40" align="center"><%f_botonera.DibujaBoton("registrarse")%></td>
			 </tr>
			 <tr>

			     <td><font size="2"><span class="Estilo4">Es muy importante la veracidad de los datos que ingreses, ya que estos te permitir&aacute;n
								                   agilizar todos los procesos asociados a la postulaci&oacute;n en nuestra Universidad.</span></font></td>
			 </tr>
			
			 <tr>
			     <td><font size="2"><span class="Estilo4">Si ya te encuentras <strong>"Registrado"</strong> y deseas completar tu postulaci&oacute;n
								                                         o verificar el estado de esta, ingresa tus datos a continuaci&oacute;n.</span></font></td>
			 </tr>
		</table>	</td>
    <td width="55%" rowspan="2" align="justify" valign="bottom" bgcolor="#bf1a19"><img src="../imagenes/derecha_superior_2008.jpg" width="422" height="242" border="0"></td> 
  </tr>
  <tr>
    <td height="25"  colspan="2" valign="bottom" bgcolor="#CCCCCC"><img src="../imagenes/esquina_izquierda_2007.gif" width="89" height="18" border="0"></td>
  </tr>
  <tr>

    <td  colspan="2" rowspan="2" valign="top" bgcolor="#003366">
		<table width="95%">
		<tr>
		  <td width="25%" align="center" valign="middle"><img src="../imagenes/flecha.jpg" width="56" height="56" border="0"></td>
		  <td valign="middle" width="3%">&nbsp;</td>

		  <td valign="top" width="72%">
		  		<table width="100%" border="0">
					<tr>
						<td width="10%"><img src="../imagenes/a1.jpg" width="13" height="13" border="0"></td>
						<td width="2%">&nbsp;</td>
						<td><font size="2" color="#FFFFFF" face="Times New Roman, Times, serif">Escriba su Login de usuario y Clave.</font></td>
					</tr>
					<tr>

						<td width="10%"><img src="../imagenes/a2.jpg" width="13" height="13" border="0"></td>
						<td width="2%">&nbsp;</td>
						<td><font size="2" color="#FFFFFF" face="Times New Roman, Times, serif">Presione Aceptar.</font></td>
					</tr>
					<tr>
						<td width="10%"><img src="../imagenes/a3.jpg" width="13" height="13" border="0"></td>
						<td width="2%">&nbsp;</td>
						<td><font size="2" color="#FFFFFF" face="Times New Roman, Times, serif">Si olvido su clave presione el botón Correspondiente.</font></td>
					</tr>
				</table>		  </td>
		</tr>
	</table></td>
    <td bgcolor="#CCCCCC" width="55%" align="justify">&nbsp;</td> 
  </tr>
   <tr>
    <form name="edicion" id="edicion">
    <td bgcolor="#CCCCCC" width="55%" align="center">
		<table width="98%">
			<tr>

				<td width="32%"><input name="usuario" type="text" id="TO-N" size="25" maxlength="25" onBlur="this.value=this.value.toUpperCase();"></td>
				<td width="47%"><font size="2" color="#000000" face="Times New Roman, Times, serif"><strong>USUARIO </strong></font>(Ej:12345678-9)</td>
				<td width="21%"><%
				f_botonera.AgregaBotonParam "aceptar", "url", "proc_index_matricula_breve.asp"
				f_botonera.DibujaBoton("aceptar")
				%></td>
			</tr>
			<tr>
				<td width="32%"><input name="clave" type="password" id="TO-N" size="25" maxlength="8"></td>
				<td width="47%"><font size="2" color="#000000" face="Times New Roman, Times, serif"><strong>CLAVE</strong></font>&nbsp;<font color="#CCCCCC"><%'=ip_usuario%></font></td>

				<td width="21%"><%f_botonera.DibujaBoton("olvido_clave")%></td>
			</tr>
			<tr>
				<td  colspan="3"><hr></td>
			</tr>
		</table>	</td>
	</form> 
  </tr>
  <tr>
    <td  colspan="3" valign="top" background="../imagenes/BARRA.gif"><div align="center" class="Estilo2"><font size="2" face="Times New Roman, Times, serif" color="#FFFFFF">Resolución Óptima 800x600 - Derechos Reservados Universidad del Pacífico Chile</font></div></td>
  </tr>
</table>
</td>
</tr>
</table>
</body>
</html>
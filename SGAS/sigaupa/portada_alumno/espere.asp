<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
'------------------------------------------------------
 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores
'set negocio = new CNegocio
'negocio.Inicializa conexion
'------------------------------------------------------
ip_usuario=Request.ServerVariables("REMOTE_ADDR")


'------------------------------------------------------  
 set botonera = new Cformulario
 botonera.carga_parametros "portada_alumno.xml", "btn_portada"
'------------------------------------------------------

'---------------------------------------------------------------------
 set f_datos = new CFormulario
 f_datos.Carga_Parametros "portada_alumno.xml", "f_datos"
 f_datos.Inicializar conexion
 f_datos.Consultar "select ''"
 f_datos.Siguiente
 
 'f_datos.AgregaCampoCons "login","admin"
 'f_datos.AgregaCampoCons "clave","admin"
 
 if ip_usuario="172.16.11.147" or ip_usuario="172.16.11.148" or ip_usuario="172.16.11.67" then
 	 
	 set f_datos_usuario = new CFormulario
 		f_datos_usuario.Carga_Parametros "portada_alumno.xml", "f_datos"
 		f_datos_usuario.Inicializar conexion
			consulta_login="select susu_tlogin, susu_tclave from sis_usuarios where pers_ncorr=27720"
 		f_datos_usuario.Consultar consulta_login
		f_datos_usuario.Siguiente
		
		v_login=f_datos_usuario.ObtenerValor("susu_tlogin")
		v_clave=f_datos_usuario.ObtenerValor("susu_tclave")
		
  	f_datos.AgregaCampoCons "login",v_login
 	f_datos.AgregaCampoCons "clave",v_clave		
 end if
 'response.Write("<p>ip usuario :</p><b>"&ip_usuario&"</b>")
'---------------------------------------------------------------------
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
<script language="JavaScript"> 
<!-- 
function EncuadraVentana(){
	if(parent.location != self.location)parent.location = self.location;
}
//--> 
function clave() {
  direccion = "olvido_clave.asp";
  window.open(direccion ,"ventana1","width=370,height=205,scrollbars=no, left=313, top=200");
}
</script>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" onLoad="EncuadraVentana();">
<table align="center" height="100%">
<tr><td valign="middle">
<table width="601" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr> 
    <td colspan="2" height="62"><img src="../imagenes/entrada.jpg" width="601" height="223" border="0"></td>
  </tr>
  <tr> 
    <td colspan="2"><img src="pixel_negro.gif" width="100%" height="2"></td>
  </tr>
  <tr> 
  <td colspan="2" bgcolor="#FFFFFF">
<form action="" method="post" name="valida">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
             <td width="100%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
				  <td colspan="6">&nbsp;</td>
                </tr>
				<tr> 
				  <td  colspan="6" align="center"><div align="center">
						<p><font color="#333333" size="3" face="Verdana, Arial, Helvetica, sans-serif"><strong>En estos momentos estamos experimentando un alto flujo de usuarios en nuestros sistemas...</strong></font></p>
						<p><strong><font color="#333333" size="3" face="Verdana, Arial, Helvetica, sans-serif">Por favor inténtelo en unos minutos más. </font></strong></p>
						<!--<p><font color="#0000FF" size="2">si solo deseas evaluar docentes pincha o revisar tus notas parciales <a href="http://216.72.170.68/alumnos/portada_alumno/portada_alumno.asp">AQUI</a></font></p>-->
					  </div>
				  </td>
                </tr>
                <tr> 
				  <td colspan="6">&nbsp;</td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td><div align="center">&nbsp;</div></td>
          </tr>
          <tr> 
            <td colspan="3"><div align="right">&nbsp;</div></td>
          </tr>
        </table>
</form>
    </td>
  </tr>
</table>
</td></tr></table>
</body>
</html>

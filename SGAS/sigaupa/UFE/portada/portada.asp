<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
'------------------------------------------------------
 set conexion = new CConexion
 conexion.Inicializar "upacifico"

'set negocio = new CNegocio
'negocio.Inicializa conexion
'------------------------------------------------------
ip_usuario=Request.ServerVariables("REMOTE_ADDR")
 set errores = new CErrores
'response.Write(ip_usuario)
'------------------------------------------------------  
 set botonera = new Cformulario
 botonera.carga_parametros "portada.xml", "btn_portada"
'------------------------------------------------------

'---------------------------------------------------------------------
 set f_datos = new CFormulario
 f_datos.Carga_Parametros "portada.xml", "f_datos"
 f_datos.Inicializar conexion
 f_datos.Consultar "select ''"
 f_datos.Siguiente
 
 'f_datos.AgregaCampoCons "login","admin"
 'f_datos.AgregaCampoCons "clave","admin"
 
 if ip_usuario="172.16.100.91" or ip_usuario="172.16.100.82" or ip_usuario="172.16.100.160" or ip_usuario="172.16.10.199" then
		if ip_usuario="172.16.100.91" then
			v_persenecor=30126 	 
		end if
		if ip_usuario="172.16.100.82" then
			v_persenecor=95794 	 
		end if
		if ip_usuario="172.16.100.160" then
			v_persenecor=123361 	 
		end if
		if ip_usuario="172.16.10.199" then
			v_persenecor=110228 	 
		end if

	 set f_datos_usuario = new CFormulario
 		f_datos_usuario.Carga_Parametros "portada.xml", "f_datos"
 		f_datos_usuario.Inicializar conexion
			consulta_login="select susu_tlogin, susu_tclave from sis_usuarios where pers_ncorr="&v_persenecor
 		f_datos_usuario.Consultar consulta_login
		f_datos_usuario.Siguiente
		
		v_login=f_datos_usuario.ObtenerValor("susu_tlogin")
		if ip_usuario <> "172.16.10.199" then
			v_clave=f_datos_usuario.ObtenerValor("susu_tclave")
		end if
		
  	f_datos.AgregaCampoCons "login",v_login
 	f_datos.AgregaCampoCons "clave",v_clave		
 end if
 'response.Write("<p>ip usuario :</p><b>"&ip_usuario&"</b>")
'---------------------------------------------------------------------
 sexos = conexion.consultaUno("select count(*) from sexos ")
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Autentificaci&oacute;n</title>
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

// Obtención de la URL.
url = document.location.href ;
// División en trozos con la barra como delimitador.
partes = url.split('/');
// Obtención del nombre de la página y sus parámetros.
v_name_server=partes[2]+'/'+partes[3];
if(v_name_server=='fangorn/sigaupa'){
	url="http://fangorn.upacifico.cl/sigaupa/";
	window.location= url;
}


</script>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" onLoad="EncuadraVentana();">
<table width="750" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr> 
    <td colspan="2" height="62"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <tr> 
    <td colspan="2"><table width="750" border="0" cellspacing="0" cellpadding="0" bgcolor="#EAEAEA">
        <tr bgcolor="#EAEAEA"> 
          <td height="200"> <div align="center"><font color="#333333" size="3" face="Verdana, Arial, Helvetica, sans-serif"><strong>FINANCIAMIENTO Y BECAS</strong></font></div>
          </td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td colspan="2"><img src="pixel_negro.gif" width="100%" height="2"></td>
  </tr>
  <tr> 
    <td width="251" background="../portada/fondo_izq.gif"><p>&nbsp;</p>
      <p><font color="#333333" size="1" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;INGRESE LOGIN Y CLAVE</font></p>
      <p>&nbsp;</p>
      <p>&nbsp;</p>
    </td>
    <td width="499" bgcolor="#BFBFBF">
<form action="" method="post" name="valida">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td width="131"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="20%">&nbsp;</td>
                  <td width="80%">&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
              </table></td>
            <td width="135"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td>LOGIN </td>
                  <td width="81"> <%f_datos.dibujaCampo "login"%> 
                    <!--<input name="login" type="text" size="12"></td>-->
                </tr>
                <tr> 
                  <td>CLAVE</td>
                  <td> <%f_datos.dibujaCampo "clave"%> </tr>
              </table></td>
            <td width="46"><% botonera.dibujaboton "aceptar"%> </td>
          </tr>
          <tr> 
            <td colspan="3"><div align="center"></div></td>
          </tr>
          <tr> 
            <td colspan="3"><div align="center"></div></td>
          </tr>
        </table>
</form>
    </td>
  </tr>
</table>
<center><p>Sistema desarrollado para Internet Explorer 6.0 y versiones superiores
<br/>Resolución óptima: 1280 x 1024 pixeles<%=sexos%></p></center>
</body>
</html>

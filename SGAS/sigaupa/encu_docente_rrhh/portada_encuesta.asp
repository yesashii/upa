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
 botonera.carga_parametros "encuesta_docente_rr_hh.xml", "botonera"
'------------------------------------------------------

'---------------------------------------------------------------------
 set f_datos = new CFormulario
 f_datos.Carga_Parametros "encuesta_docente_rr_hh.xml", "busqueda"
 f_datos.Inicializar conexion
 f_datos.Consultar "select ''"
 f_datos.Siguiente
 
 'f_datos.AgregaCampoCons "login","admin"
 'f_datos.AgregaCampoCons "clave","admin"
 
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
<script type="text/javascript" src="portada/js/jquery.js"></script>
<script type="text/javascript" src="portada/js/funciones_1.js" ></script>
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

<style type="text/css">
<!--
body {
	background-color: #dae4fa;
}
-->
</style></head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="EncuadraVentana();">
<table align="center" height="100%">
<tr><td valign="middle">
<table width="601" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr> 
    <td width="95%"><span id="controlversion"> </span></td>
  </tr> 
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
				  <td colspan="4">&nbsp;</td>
                </tr>
				<tr> 
				  <td width="40%" align="right"><strong>Ingrese su RUT</strong></td>
                  <td width="1%"><strong>:</strong></td>
                  <td align="left" width="30%">&nbsp;&nbsp;<%f_datos.dibujaCampo "pers_nrut"%>-<%f_datos.dibujaCampo "pers_xdv"%> </td>
				  <td align="left"> <% botonera.dibujaboton "ir1"%>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td><div align="center">&nbsp;</div></td>
          </tr>
          <tr> 
            <td colspan="3">&nbsp;</td>
          </tr>
        </table>
</form>
    </td>
  </tr>
</table>
</td></tr></table>
</body>
</html>

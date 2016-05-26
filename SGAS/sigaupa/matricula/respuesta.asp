<!--#include file="../biblioteca/_conexion.asp" -->

<% 
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_consulta = new CFormulario
f_consulta.Carga_Parametros "consulta.xml", "consulta"
f_consulta.Inicializar conexion


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "matricula-inicio.xml", "botonera_pregunta_clave"


rut = Request("rut")
respuesta = trim(request("respuesta"))


texto = " select USUA_TUSUARIO as usuario,USUA_TCLAVE as clave " _
      & " from usuarios where USUA_TUSUARIO ='"& rut &"' " _
      & " and upper(USUA_TRESPUESTA) ='"& UCase(respuesta) &"'"
	  
f_consulta.Consultar texto
f_consulta.Siguiente


if f_consulta.NroFilas = 0 then
	session("mensajeError") = "Error.\nLa respuesta es incorrecta."
	Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
else
    usuario = f_consulta.ObtenerValor("usuario")
	clave   = f_consulta.ObtenerValor("clave")
end if

%>
<html>
<head>
<title>Contrase&ntilde;as</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="estilos/estilos.css" type="text/css">
</head>
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript">
</script>
<body bgcolor="#EAEAEA"  text="#000000" leftmargin="10" topmargin="10" marginwidth="0" marginheight="0" link ="#FFFFFF" alink="#FFFFFF" vlink= "#FFFFFF">
<form name="form1" method="post" action="proc_respuesta.asp">
  <table width="367" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF">
    <tr> 
      <td> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td width="5%">&nbsp;</td>
            <td width="89%" height="5">&nbsp;</td>
            <td width="6%">&nbsp;</td>
          </tr>
          <tr> 
            <td width="5%">&nbsp;</td>
            <td width="89%"> 
              <table width="100%" border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
                <tr> 
                  <td height="30" bgcolor="#ebebeb"> 
                    <div align="center"><b>TU NOMBRE DE USUARIO Y CLAVE SON LOS 
                      SIGUIENTES:</b></div>
                  </td>
                </tr>
                <tr> 
                  <td> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="17%" height="20"><b> </b></td>
                        <td width="83%">&nbsp; </td>
                      </tr>
                      <tr> 
                        <td width="17%" height="20"><b>&nbsp;&nbsp;&nbsp;Usuario</b></td>
                        <td width="83%"> : <b><%=usuario%></b></td>
                      </tr>
                      <tr> 
                        <td width="17%" height="15"><b>&nbsp;&nbsp;&nbsp;Clave</b></td>
                        <td width="83%">: <b><%=clave%></b></td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td height="25"><font color="#FFFFFF"><b> </b></font></td>
                </tr>
                <tr> 
                  <td height="30"> 
                    <div align="center"><%f_botonera.DibujaBoton("cerrar")%></div>
                  </td>
                </tr>
              </table>
            </td>
            <td width="6%">&nbsp;</td>
          </tr>
          <tr> 
            <td width="5%" height="5">&nbsp;</td>
            <td width="89%">&nbsp;</td>
            <td width="6%">&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
</body>
</html>

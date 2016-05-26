<!-- #include file = "../biblioteca/de_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_evalua.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Ocupaciones"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")

		   
'---------------------------------------------------------------------------------------------------
set f_padre = new CFormulario
f_padre.Carga_Parametros "tus_datos.xml", "sitocupaciones"
f_padre.Inicializar conexion

consulta = "select sitocup_ccod,sitocup_tdesc from tipos_situacion_padres "
'response.Write("<pre>" & consulta & "</pre>")
  
f_padre.Consultar consulta



%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Tipos de Ocupaciones</title>
<style type="text/css">
<!--

body {
	background-color: #dae4fa;
}

}
-->
</style>



</head>

<body>
<table width="90%" border="0" bgcolor="#FFFFFF">
			<table width="75%" border="1">
  <tr> 
   <td width="8%"><div align="center"><strong>Codigo</strong></div></td>
  <td width="92%"><div align="center"><strong>Descripcion</strong></div></td>
 
  </tr>
	<%  while f_padre.Siguiente %>
  <tr> 
    <td><div align="left"><%=f_padre.ObtenerValor("sitocup_ccod")%></div></td>
    <td><div align="left"><%=f_padre.ObtenerValor("sitocup_tdesc")%></div></td>    
  </tr>
   <%  wend %>
			  </table>
</body>

</html>

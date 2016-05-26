<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'------------------------------------ que cierre la seccion-------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

%>
<html>
<head>
<%
res = request.querystring("resolucion")

'response.Write("resolucion = "&res&)
'response.End
'--

%>
<title>SISTEMA ADMINISTRATIVO OTEC</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<frameset rows="75,*" frameborder="NO" border="0" framespacing="0"> 
  <frame src="titulo.asp"  scrolling="no" name="superior_frame" frameborder="no" noresize>
  <frame src="inferior.asp?resolucion=<%=res%>" name="inferior_frame" scrolling="yes" noresize>
</frameset>
<noframes><body>

</body></noframes>
</html>

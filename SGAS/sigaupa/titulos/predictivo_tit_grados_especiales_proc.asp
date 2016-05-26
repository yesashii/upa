<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

pers_ncorr = request.form("pers_ncorr")
carr_ccod = request.form("carr_ccod")
plan_ccod = request.form("plan_ccod")

c_excepcion = " Insert into EXCEPCIONES_EGRESO (PERS_NCORR,PLAN_CCOD,CARR_CCOD,EEGR_FEXCEPCION,AUDI_TUSUARIO,AUDI_FMODIFICACION) "&_
              " VALUES("&pers_ncorr&","&plan_ccod&",'"&carr_ccod&"',getDate(),'"&negocio.obtenerUsuario&"',getDate())"
conexion.ejecutaS c_excepcion
  


response.Redirect(Request.ServerVariables("HTTP_REFERER"))
			   
%>

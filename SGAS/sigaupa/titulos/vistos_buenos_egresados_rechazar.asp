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

cegr_ncorr = conexion.consultaUno("select cegr_ncorr from CANDIDATOS_EGRESO where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_ccod&"' and carr_ccod='"&carr_ccod&"'")

c_rechazo = "update CANDIDATOS_EGRESO set eceg_ccod=3, cegr_nvb_titulos = 3,CEGR_NTOTAL_RECHAZOS = ISNULL(CEGR_NTOTAL_RECHAZOS,0) + 1, audi_tusuario='"&negocio.obtenerUsuario&"',audi_fmodificacion = getdate() where cast(cegr_ncorr as varchar)='"&cegr_ncorr&"'"
conexion.ejecutaS c_rechazo
  


response.Redirect(Request.ServerVariables("HTTP_REFERER"))
			   
%>

<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

'response.End()

'-------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

peri_ccod=request.Form("comision[0][peri_ccod]")
pers_ncorr=request.Form("comision[0][pers_ncorr]")
plan_ccod=request.Form("comision[0][plan_ccod]")
'conexion.estadoTransaccion false
set f_practica = new CFormulario
f_practica.Carga_Parametros "detalle_egreso_titulacion.xml", "comision_tesis"
f_practica.Inicializar conexion
f_practica.ProcesaForm
if request.Form("comision[0][ctes_ncorr]") = "" then 
	ctes_ncorr = conexion.consultaUno("execute obtenersecuencia 'comision_tesis'") 	
	f_practica.AgregaCampoFilaPost 0, "ctes_ncorr", ctes_ncorr
end if

f_practica.MantieneTablas false


pers_nrut= conexion.consultaUno("select pers_nrut from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
pers_xdv = conexion.consultaUno("select pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")

url = "Detalle_egreso_titulacion.asp?plan_ccod="&plan_ccod&"&peri_ccod="&peri_ccod&"&pers_nrut="&pers_nrut&"&pers_xdv="&pers_xdv&""
'response.End()

response.Redirect(url)
%>

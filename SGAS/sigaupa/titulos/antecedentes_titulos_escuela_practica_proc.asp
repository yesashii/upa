<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.end
asig_ccod=request.Form("egreso[0][asig_ccod]")
peri_ccod=request.Form("egreso[0][peri_ccod]")
sitf_ccod=request.Form("egreso[0][sitf_ccod]")
pers_ncorr=request.Form("egreso[0][pers_ncorr]")
plan_ccod=request.Form("egreso[0][plan_ccod]")
saca_ncorr=request.Form("saca_ncorr")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

carr_ccod = conexion.consultaUno("select carr_ccod from planes_estudio a, especialidades b where a.espe_ccod=b.espe_ccod and cast(a.plan_ccod as varchar)='"&plan_ccod&"'")

nombre_empresa=request.Form("egreso[0][nombre_empresa]")

if not EsVacio(nombre_empresa) or not EsVacio(fecha_egreso)  then 
	set f_practica = new CFormulario
	f_practica.Carga_Parametros "antecedentes_titulados_escuela.xml", "detalle_datos_practica"
	f_practica.Inicializar conexion
	f_practica.ProcesaForm
	f_practica.AgregaCampoFilaPost 0, "carr_ccod", carr_ccod
	f_practica.MantieneTablas false				
end if

'response.End()

if conexion.obtenerEstadoTransaccion then
	session("msjOk")="Los datos han sido grabados exitosamente"
end if

response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>


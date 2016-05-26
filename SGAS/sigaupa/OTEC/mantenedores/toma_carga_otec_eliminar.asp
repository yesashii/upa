<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set formulario = new cformulario
formulario.carga_parametros "toma_carga_otec.xml", "carga_tomada"
formulario.inicializar conectar
formulario.procesaForm
for i=0 to formulario.cuentaPost - 1
	pote_ncorr=formulario.obtenerValorPost(i,"pote_ncorr")
	seot_ncorr=formulario.obtenerValorPost(i,"seot_ncorr")
	if not EsVacio(pote_ncorr) and not EsVacio(seot_ncorr)  then
		SQL="DELETE cargas_academicas_otec WHERE cast(pote_ncorr as varchar)='"&pote_ncorr&"' and cast(seot_ncorr as varchar)='"&seot_ncorr&"' and isnull(sitf_ccod,'N')='N'"
		'response.Write("<br>"&SQL)
		conectar.EstadoTransaccion conectar.EjecutaS(SQL)
	end if
next
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

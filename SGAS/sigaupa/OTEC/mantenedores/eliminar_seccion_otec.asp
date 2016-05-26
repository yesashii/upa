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
formulario.carga_parametros "secciones_otec.xml", "edita_secciones"
formulario.inicializar conectar
formulario.procesaForm
for i=0 to formulario.cuentaPost - 1
	seot_ncorr=formulario.obtenerValorPost(i,"codigo")
	if not EsVacio(seot_ncorr) then
	 	consulta_eliminacion = "delete from secciones_otec where cast(seot_ncorr as varchar)='"&seot_ncorr&"'"
		conectar.ejecutaS consulta_eliminacion
	end if
next	


'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

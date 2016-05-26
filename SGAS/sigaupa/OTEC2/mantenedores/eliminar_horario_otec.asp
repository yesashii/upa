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
sede_borrar = request.Form("sede_borrar")
set formulario = new cformulario
formulario.carga_parametros "horarios_otec.xml", "lista_horarios"
formulario.inicializar conectar
formulario.procesaForm
for i=0 to formulario.cuentaPost - 1
	hora_ccod=formulario.obtenerValorPost(i,"hora_ccod")
	if not EsVacio(hora_ccod) and not EsVacio(sede_borrar) then
		SQL="DELETE horarios_sedes_otec WHERE cast(hora_ccod as varchar)='"&hora_ccod&"' and sede_ccod ='"&sede_borrar&"'"
		'response.Write("<br>"&SQL)
		conectar.EstadoTransaccion conectar.EjecutaS(SQL)
	end if
next
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

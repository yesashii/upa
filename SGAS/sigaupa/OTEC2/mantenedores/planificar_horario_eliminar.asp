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
formulario.carga_parametros "planificar_programa.xml", "f_horario"
formulario.inicializar conectar
formulario.procesaForm
for i=0 to formulario.cuentaPost - 1
	bhot_ccod = formulario.obtenerValorPost(i,"bhot_ccod")
	if bhot_ccod <> "" then 
		SQL="DELETE bloques_horarios_otec WHERE cast(bhot_ccod as varchar)='"&bhot_ccod&"'"
		conectar.EstadoTransaccion conectar.EjecutaS(SQL)
		'response.Write("<br>"&SQL)
	end if	
next

'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

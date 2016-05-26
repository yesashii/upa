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
formulario.carga_parametros "asignar_relator_programa.xml", "f_relatores_horario"
formulario.inicializar conectar
formulario.procesaForm

for i=0 to formulario.cuentaPost - 1
	clave=formulario.obtenerValorPost(i,"pers_ncorr")
	bhot_ccod=formulario.obtenerValorPost(i,"bhot_ccod")
	if not EsVacio(clave)  then
		SQL="DELETE bloques_relatores_otec WHERE cast(pers_ncorr as varchar)='"&clave&"' and cast(bhot_ccod as varchar)='"&bhot_ccod&"'"
		'response.Write("<br>"&SQL)
		'----- antes de borrar a un docente habilitado en cierto programa debemos ver si tiene algun bloque asignado
		conectar.EstadoTransaccion conectar.EjecutaS(SQL)
	end if
next
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

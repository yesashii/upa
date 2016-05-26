<!-- #include file = "../biblioteca/_conexion.asp" -->

<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

set conectar = new CConexion
conectar.Inicializar "upacifico"

set formulario = new CFormulario
formulario.carga_parametros "adm_tipos_salidas.xml", "eliminar_salidas"
formulario.inicializar conectar
formulario.procesaForm

v_tran = formulario.mantienetablas 	(false)
'response.End()
if v_tran = False then
	Session("mensajeError") = "Imposible Eliminar\nVerifique que el tipo de salida no tenga salidas creadas para alguna carrera"
end if 
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>


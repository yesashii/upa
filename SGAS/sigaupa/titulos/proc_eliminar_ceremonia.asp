<!-- #include file = "../biblioteca/_conexion.asp" -->

<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
''next
'response.End()

set conectar = new CConexion
conectar.Inicializar "upacifico"
total_con_carga = 0
for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
	total_con_carga = total_con_carga + cint(conectar.consultaUno("select count(*) from detalles_titulacion_carrera where id_ceremonia='"&request.Form(k)&"'"))
next
'response.Write(total_con_carga)
'response.End()
if total_con_carga = 0 then 
	set formulario = new CFormulario
	formulario.carga_parametros "adm_fecha_ceremonia.xml", "eliminar_ceremonia"
	formulario.inicializar conectar
	formulario.procesaForm
	v_tran = formulario.mantienetablas 	(false)
else
	Session("mensajeError") = "Imposible Eliminar\nVerifique que dicha ceremonia ceremonia no tenga alumnos asociados"
end if 
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>


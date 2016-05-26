<!-- #include file="../biblioteca/_conexion.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

formulario.carga_parametros "paulo.xml", "eliminar_bloque"
formulario.inicializar conectar
formulario.procesaForm 
msj_error = ""
for fi=0 to formulario.cuentaPost - 1
    bloq_ccod=formulario.obtenerValorPost(fi,"bloq_ccod")
	tiene_asignado_laboratorio =  conectar.consultaUno("select count(*) from bloques_horarios where cast(bloq_ccod as varchar)='"&bloq_ccod&"' and sala_ccod in (30,32,31,29,43,274,65,25,175,176,102,161,85,133,167,266)")
    if bloq_ccod <> "" then
		if tiene_asignado_laboratorio <> "0" then
			tiene_asignado_profesor =  conectar.consultaUno("select count(*) from bloques_profesores where cast(bloq_ccod as varchar)='"&bloq_ccod&"' ")
			if tiene_asignado_profesor = "0" then
			   c_eliminar = "Delete from bloques_horarios where cast(bloq_ccod as varchar)='"&bloq_ccod&"' "
			   conectar.ejecutaS c_eliminar
			else
				msj_error = msj_error & "\n Uno o más bloques tienen asignado docente en el sistema."	
			end if
		else
		  msj_error = msj_error & "\n Uno o más bloques están asociados a salas o talleres, los que deben ser liberados por dirección de docencia."
		end if
	end if
next	
'formulario.mantienetablas false
if msj_error <> "" then
	conectar.MensajeError "Se presentaron los siguientes errores:"&msj_error
end if
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
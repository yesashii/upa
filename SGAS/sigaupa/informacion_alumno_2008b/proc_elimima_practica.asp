<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'-----------------------------------------------------
'	for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next
'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


set f_agrega = new CFormulario
f_agrega.Carga_Parametros "curriculum_alumno.xml", "practica_muestra"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm

for filai = 0 to f_agrega.CuentaPost - 1


pers_ncorr =f_agrega.ObtenerValorPost (filai, "pers_ncorr")
dlpr_ncorr =f_agrega.ObtenerValorPost (filai, "dlpr_ncorr")

if pers_ncorr <> "" then
	p_exaldelete="delete from experiencia_alumno where dlpr_ncorr="&dlpr_ncorr&""
	p_dlpr_delete="delete from direccion_laboral_profesionales where dlpr_ncorr="&dlpr_ncorr&""	
	'response.Write("<pre>practica</pre>")
	'response.Write("<pre>"&p_exaldelete&"</pre>")
	'response.Write("<pre>"&p_dlpr_delete&"</pre>")
	conectar.ejecutaS (p_exaldelete)
 	conectar.ejecutaS (p_dlpr_delete)
end if		  
	
'response.Write("respuesta "&Respuesta)	



next

'response.End()














Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
'response.Write("respuesta "&Respuesta)


if Respuesta = true then
session("mensajeerror")="El Borrado ha sido exitoso" 
else
  session("mensajeerror")= "Error al guardar "
end if
'response.End()


'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("curriculum.asp?npag=2")
%>


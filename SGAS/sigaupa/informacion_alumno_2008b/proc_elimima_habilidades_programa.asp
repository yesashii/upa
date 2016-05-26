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
f_agrega.Carga_Parametros "curriculum_alumno.xml", "habilidades_programas_muestra"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm

for filai = 0 to f_agrega.CuentaPost - 1


pers_ncorr =f_agrega.ObtenerValorPost (filai, "pers_ncorr")
cdpa_ncorr =f_agrega.ObtenerValorPost (filai, "cdpa_ncorr")

if pers_ncorr <> "" then
	p_cdpa_delete="delete from curriculum_dominio_programa_alumno where cdpa_ncorr="&cdpa_ncorr&""

	'response.Write("<pre>practica</pre>")
	'response.Write("<pre>"&p_exaldelete&"</pre>")
	'response.Write("<pre>"&p_dlpr_delete&"</pre>")
	conectar.ejecutaS (p_cdpa_delete)

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


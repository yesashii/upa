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
f_agrega.Carga_Parametros "curriculum_alumno.xml", "habilidades"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm

for filai = 0 to f_agrega.CuentaPost -1

pers_nrut=f_agrega.ObtenerValorPost (filai, "pers_nrut")
chal_thabilidades_profesionales = f_agrega.ObtenerValorPost (filai, "chal_thabilidades_profesionales")
chal_thabilidades_tecnica = f_agrega.ObtenerValorPost (filai, "chal_thabilidades_tecnica")
chal_thabilidades_personales = f_agrega.ObtenerValorPost (filai, "chal_thabilidades_personales")
chal_tarea_trabajo = f_agrega.ObtenerValorPost (filai, "chal_tarea_trabajo")
'chal_ncorr = f_agrega.ObtenerValorPost (filai, "chal_ncorr")
pers_ncorr = conectar.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")


chal_ncorr = conectar.consultaUno("select chal_ncorr from curriculum_habilidades_alumno where pers_ncorr="&pers_ncorr&" ")

'response.write("<br>"&chal_ncorr)

	
	if chal_ncorr <> "" then
	
		p_update_chal="update  curriculum_habilidades_alumno set chal_tarea_trabajo='"&chal_tarea_trabajo&"',chal_thabilidades_tecnica='"&chal_thabilidades_tecnica&"',chal_thabilidades_personales='"&chal_thabilidades_personales&"',chal_thabilidades_profesionales='"&chal_thabilidades_profesionales&"' where chal_ncorr="&chal_ncorr&""		  
	
	'response.Write("<pre>"&p_update_chal&"</pre>")
	
	conectar.ejecutaS (p_update_chal)
	
	

	else
	chal_ncorr = conectar.ConsultaUno("exec ObtenerSecuencia 'curriculum_programa'")
	
	
	
	
insert_chal="insert into curriculum_habilidades_alumno (chal_ncorr,chal_tarea_trabajo,chal_thabilidades_tecnica,chal_thabilidades_personales,chal_thabilidades_profesionales,pers_ncorr) values("&chal_ncorr&",'"&chal_tarea_trabajo&"','"&chal_thabilidades_tecnica&"','"&chal_thabilidades_personales&"','"&chal_thabilidades_profesionales&"',"&pers_ncorr&")"



	'response.Write("<pre>"&insert_chal&"</pre>")	
	
	conectar.ejecutaS (insert_chal)

end if
'response.Write("respuesta "&Respuesta)	



next


'response.End()














Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
'response.Write("respuesta "&Respuesta)
'response.End()

if Respuesta = true then
session("mensajeerror")="Tus Datos fueron Guardados Satisfactoriamente" 
else
  session("mensajeerror")= "Error al guardar "
end if
'response.End()


'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("curriculum.asp?npag=2")
%>


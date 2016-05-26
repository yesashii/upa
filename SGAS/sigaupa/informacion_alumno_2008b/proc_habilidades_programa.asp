<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'-----------------------------------------------------
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next
'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


set f_agrega = new CFormulario
f_agrega.Carga_Parametros "curriculum_alumno.xml", "habilidades_programas"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1
pers_nrut=f_agrega.ObtenerValorPost (filai, "pers_nrut")
cdpa_ncorr =f_agrega.ObtenerValorPost (filai, "cdpa_ncorr")
cdpa_tprograma = f_agrega.ObtenerValorPost (filai, "cdpa_tprograma")
nidi_ccod = f_agrega.ObtenerValorPost (filai, "nidi_ccod")



	
	if cdpa_ncorr ="" then
	
	cdpa_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'curriculum_programa'")
	
	
	pers_ncorr = conectar.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")
	
	insert_cdpa="insert into curriculum_dominio_programa_alumno (cdpa_ncorr,cdpa_tprograma,nidi_ccod,pers_ncorr) values("&cdpa_ncorr&",'"&cdpa_tprograma&"',"&nidi_ccod&","&pers_ncorr&")"


	'response.Write("<pre>"&insert_cdpa&"</pre>")	
	
	conectar.ejecutaS (insert_cdpa)
	else
	
	p_update_cdpa="update  curriculum_dominio_programa_alumno set cdpa_tprograma='"&cdpa_tprograma&"',nidi_ccod='"&nidi_ccod&"' where cdpa_ncorr="&cdpa_ncorr&""		  
	
	'response.Write("<pre>"&p_update_cdpa&"</pre>")
	
	conectar.ejecutaS (p_update_cdpa)
end if
'response.Write("respuesta "&Respuesta)	



next

'response.End()














Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
'response.Write("respuesta "&Respuesta)


if Respuesta = true then
session("mensajeerror")="Tus Datos fueron Guardados Satisfactoriamente" 
else
  session("mensajeerror")= "Error al guardar "
end if
'response.End()


'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("curriculum.asp?npag=2")
%>


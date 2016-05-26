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
f_agrega.Carga_Parametros "curriculum_alumno.xml", "laboral_practica_pasantia"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1
pers_nrut=f_agrega.ObtenerValorPost (filai, "pers_nrut")
dlpr_ncorr =f_agrega.ObtenerValorPost (filai, "dlpr_ncorr")
dlpr_nombre_empresa = f_agrega.ObtenerValorPost (filai, "dlpr_nombre_empresa")
dlpr_rubro_empresa = f_agrega.ObtenerValorPost (filai, "dlpr_rubro_empresa")
dlpr_cargo_empresa = f_agrega.ObtenerValorPost (filai, "dlpr_cargo_empresa")
dlpr_web_empresa = f_agrega.ObtenerValorPost (filai, "dlpr_web_empresa")
tiea_ccod=f_agrega.ObtenerValorPost (filai, "tiea_ccod")
exal_fini=f_agrega.ObtenerValorPost (filai, "exal_fini")
exal_ffin=f_agrega.ObtenerValorPost (filai, "exal_ffin")
pais_ccod=f_agrega.ObtenerValorPost (filai, "pais_ccod")
ciud_ccod=f_agrega.ObtenerValorPost (filai, "ciud_ccod")
tiea_ccod=f_agrega.ObtenerValorPost (filai, "tiea_ccod")
exal_tactividad=f_agrega.ObtenerValorPost (filai, "exal_tactividad")

if ciud_ccod ="" then
ciud_ccod=0
end if


if tiea_ccod="" then
tiea_ccod=1
end if

if exal_ffin="" then
exal_ffin =null
end if
	
	if dlpr_ncorr ="" then
	
	dlpr_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'direccion_laboral_profesionales'")
	exal_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'experiencia_alumno'")
	
	pers_ncorr = conectar.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")
	
insert_dlpr="insert into direccion_laboral_profesionales (dlpr_ncorr,pers_ncorr,pais_ccod,ciud_ccod,dlpr_nombre_empresa,dlpr_rubro_empresa,dlpr_cargo_empresa,dlpr_web_empresa) values("&dlpr_ncorr&","&pers_ncorr&","&pais_ccod&",'"&ciud_ccod&"','"&dlpr_nombre_empresa&"','"&dlpr_rubro_empresa&"','"&dlpr_cargo_empresa&"','"&dlpr_web_empresa&"')"

insert_exal="insert into experiencia_alumno (exal_ncorr,dlpr_ncorr,exal_fini,exal_ffin,tiea_ccod,exal_tactividad) values ("&exal_ncorr&","&dlpr_ncorr&",'"&exal_fini&"','"&exal_ffin&"',"&tiea_ccod&",'"&exal_tactividad&"')"

	'response.Write("<pre>"&insert_dlpr&"</pre>")	
	'response.Write("<pre>"&insert_exal&"</pre>")
	conectar.ejecutaS (insert_dlpr)
	conectar.ejecutaS (insert_exal)
	else
	
	p_update_dlpr="update  direccion_laboral_profesionales set pais_ccod='"&pais_ccod&"',ciud_ccod='"&ciud_ccod&"',dlpr_nombre_empresa='"&dlpr_nombre_empresa&"',dlpr_rubro_empresa='"&dlpr_rubro_empresa&"',dlpr_web_empresa= '"&dlpr_web_empresa&"',dlpr_cargo_empresa='"&dlpr_cargo_empresa&"' where dlpr_ncorr="&dlpr_ncorr&""		  
	
	p_update_exal="update experiencia_alumno set  exal_fini='"&exal_fini&"',exal_ffin='"&exal_ffin&"',exal_tactividad='"&exal_tactividad&"' where dlpr_ncorr="&dlpr_ncorr&" "
	'response.Write("<pre>"&p_update_dlpr&"</pre>")
	'response.Write("<pre>"&p_update_exal&"</pre>")
	conectar.ejecutaS (p_update_dlpr)
	conectar.ejecutaS (p_update_exal)
end if
'response.Write("respuesta "&Respuesta)	



next


'
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


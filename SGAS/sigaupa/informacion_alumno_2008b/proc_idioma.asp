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
f_agrega.Carga_Parametros "curriculum_alumno.xml", "idioma"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1

idal_ncorr =f_agrega.ObtenerValorPost (filai, "idal_ncorr")
idio_ccod = f_agrega.ObtenerValorPost (filai, "idio_ccod")
nidi_ccod = f_agrega.ObtenerValorPost (filai, "nidi_ccod")
idal_habla = f_agrega.ObtenerValorPost (filai, "idal_habla")
idal_escribe = f_agrega.ObtenerValorPost (filai, "idal_escribe")
idal_lee=f_agrega.ObtenerValorPost (filai, "idal_lee")
pers_nrut=f_agrega.ObtenerValorPost (filai, "pers_nrut")
idal_otro=f_agrega.ObtenerValorPost (filai, "idal_otro")
	
	if idal_ncorr ="" then
	
	idal_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'idioma_alumno'")
	
	pers_ncorr = conectar.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")
	
	st_insert="insert into idioma_alumno (idal_ncorr,pers_ncorr,idio_ccod,nidi_ccod,idal_habla,idal_lee,idal_escribe,idal_otro) values("&idal_ncorr&","&pers_ncorr&","&idio_ccod&","&nidi_ccod&",'"&idal_habla&"','"&idal_lee&"','"&idal_escribe&"','"&idal_otro&"')"
	'response.Write(st_insert)	
	conectar.ejecutaS (st_insert)
	
	else
	
	p_update="update  idioma_alumno set idal_otro='"&idio_otro&"',nidi_ccod="&nidi_ccod&",idal_habla='"&idal_habla&"',idal_lee='"&idal_lee&"',idal_escribe= '"&idal_escribe&"' where idal_ncorr="&idal_ncorr&""		  
	'response.Write("<pre>"&p_update&"</pre>")
	conectar.ejecutaS (p_update)
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


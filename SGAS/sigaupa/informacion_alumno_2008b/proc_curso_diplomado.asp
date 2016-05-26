<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'-----------------------------------------------------
'for each k in request.form
'response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


set f_agrega = new CFormulario
f_agrega.Carga_Parametros "curriculum_alumno.xml", "seminario_curso"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1

cscu_ncorr = f_agrega.ObtenerValorPost (filai, "cscu_ncorr")
cscu_tinstitucion = f_agrega.ObtenerValorPost (filai, "cscu_tinstitucion")
ticu_ccod = f_agrega.ObtenerValorPost (filai, "ticu_ccod")
cscu_tnombre = f_agrega.ObtenerValorPost (filai, "cscu_tnombre")
cscu_ano=  f_agrega.ObtenerValorPost (filai, "cscu_ano")
pers_nrut=  f_agrega.ObtenerValorPost (filai, "pers_nrut")

	
	if cscu_ncorr ="" then
	
	cscu_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'curso_seminario_curriculum'")
	
	pers_ncorr = conectar.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")
	st_insert="insert into curso_seminario_curriculum (cscu_ncorr,pers_ncorr,cscu_tnombre,cscu_tinstitucion,cscu_ano,ticu_ccod) values("&cscu_ncorr&","&pers_ncorr&",'"&cscu_tnombre&"','"&cscu_tinstitucion&"',"&cscu_ano&","&ticu_ccod&")"
	'response.Write(st_insert)	
	conectar.ejecutaS (st_insert)
	
	else
	
	p_update="update  curso_seminario_curriculum set cscu_tnombre='"&cscu_tnombre&"',cscu_tinstitucion='"&cscu_tinstitucion&"',cscu_ano="&cscu_ano&",ticu_ccod="&ticu_ccod&" where cscu_ncorr="&cscu_ncorr&""		  
	'response.Write("<pre>"&p_update&"</pre>")
	conectar.ejecutaS (p_update)
end if
response.Write("respuesta "&Respuesta)	


'response.End()	
next

















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


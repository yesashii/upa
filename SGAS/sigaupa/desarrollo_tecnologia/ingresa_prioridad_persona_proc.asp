<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

for each k in request.form
response.Write(k&" = "&request.Form(k)&"<br>")
next
'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
pers_nrut=request.Form("test[0][pers_nrut]")
existe_personas=conexion.ConsultaUno("select count( pers_ncorr) from personas where pers_nrut="&pers_nrut&"")
response.Write("existe_personas====="&existe_personas) 

if cint(existe_personas)>0 then
			
				set f_peticion = new CFormulario
				f_peticion.Carga_Parametros "solicita_soporte.xml", "ingresa_prioridad_persona_proc"
				f_peticion.Inicializar conexion
				f_peticion.ProcesaForm
				
				
				response.Write("pers_nrut====="&pers_nrut) 
				pers_ncorr=conexion.ConsultaUno("select pers_ncorr from personas where pers_nrut="&pers_nrut&"")
				tiene_inus=conexion.ConsultaUno("select count(*) from info_usuarios_soporte where pers_ncorr="&pers_ncorr&"")
				
				
				if tiene_inus="0" then
				inus_ncorr= conexion.ConsultaUno("execute obtenersecuencia 'info_usuarios_soporte'")
				else
				inus_ncorr=conexion.ConsultaUno("select inus_ncorr from info_usuarios_soporte where pers_ncorr="&pers_ncorr&"")
				end if
				
				f_peticion.agregacampopost "pers_ncorr",pers_ncorr
				f_peticion.agregacampopost "inus_ncorr",inus_ncorr
				f_peticion.MantieneTablas false
				'conexion.estadotransaccion true
	Respuesta = conexion.ObtenerEstadoTransaccion()

'response.Write("</br>"&Respuesta)
	'response.End()
	if Respuesta  then
	session("mensajeerror")= "La prioridad a sido asignada exitosamente"
	else
	  session("mensajeerror")= "Error al guardar "
	end if
	
else
session("mensajeerror")= "La persona debe ser creada en SGA primero"
end if
Response.Redirect("ingresa_prioridad_persona.asp")
%>

<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

for each k in request.form
response.Write(k&" = "&request.Form(k)&"<br>")
next
'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set conexion2 = new CConexion
conexion2.Inicializar "upacifico"


set negocio = new CNegocio
negocio.Inicializa conexion

				
				 'response.write(maqu_ncorr&"<hr>")'
				set f_peticion = new CFormulario
				f_peticion.Carga_Parametros "solicita_soporte.xml", "tomar_solicitudes_proc"
				f_peticion.Inicializar conexion
				f_peticion.ProcesaForm
				
				for filai = 0 to f_peticion.CuentaPost - 1
				
				inci_ccod = f_peticion.ObtenerValorPost (filai, "inci_ccod")
				folio = f_peticion.ObtenerValorPost (filai, "folio")
				
					if inci_ccod<>"" and folio<>"" then
						usu=negocio.ObtenerUsuario()
						pers_ncorr_responsable=conexion.consultaUno("select protic.obtener_pers_ncorr("&usu&")")
						persona_tecnico=conexion.consultaUno("select pers_tnombre+' '+pers_tape_paterno from personas where pers_ncorr=protic.obtener_pers_ncorr("&usu&")")
						
						insert_petiocion_soporte="update PETICION_SOPORTE set pers_ncorr_responsable="&pers_ncorr_responsable&" where inci_ccod='"&inci_ccod&"'"
						insert_persona_tecnico="update incidentes set personal_tecnico='"&persona_tecnico&"' where inci_ccod='"&inci_ccod&"'"
						
						
						conexion.EjecutaS(insert_petiocion_soporte)
						conexion2.EjecutaS(insert_persona_tecnico)
						
						Respuesta = conexion.ObtenerEstadoTransaccion()
						
						Respuesta2 = conexion2.ObtenerEstadoTransaccion()
						
						
						if Respuesta2 =false then
						delete_petiocion_soporte="update PETICION_SOPORTE set pers_ncorr_responsable=null where inci_ccod='"&inci_ccod&"'"
						conexion.EjecutaS(delete_petiocion_soporte)
						end if
						
						if Respuesta =false then
						delete_persona_tecnico="update incidentes set personal_tecnico=null where inci_ccod='"&inci_ccod&"'"
						conexion.EjecutaS(delete_persona_tecnico)
						end if
						'response.Write(insert_petiocion_soporte&"</br>")
						
						
					end if
				
				next
				
				
				'conexion.estadotransaccion true

'response.Write("</br>"&Respuesta)
'response.End()
if Respuesta=true and  Respuesta2=true then
session("mensajeerror")= "Has tomado las peticiones seleccionadas"
else
  session("mensajeerror")= "Error al tomar las peticiones "
end if
Response.Redirect("peticiones.asp")


%>

<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'-----------------------------------------------------
	for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
	next
'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar


set f_elimina = new CFormulario
f_elimina.Carga_Parametros "edicion_talleres.xml", "listado"
f_elimina.Inicializar conectar
f_elimina.ProcesaForm
for filai = 0 to f_elimina.CuentaPost - 1

tdsi_ncorr = f_elimina.ObtenerValorPost (filai, "tdsi_ncorr")
pers_ncorr = f_elimina.ObtenerValorPost (filai, "pers_ncorr")

if tdsi_ncorr <>"" and pers_ncorr <>"" then

	p_delete="delete from alumnos_talleres_psicologia where tdsi_ncorr ="&tdsi_ncorr&" and pers_ncorr="&pers_ncorr&""		  
	response.Write("<pre>"&p_delete&"</pre>")
	conectar.ejecutaS (p_delete)
end if
'response.Write("respuesta "&Respuesta)	


	
next

'response.End()















Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
'response.Write("respuesta "&Respuesta)


if Respuesta = true then
session("mensajeerror")= " El Alumno fue eliminado con Éxito"
else
  session("mensajeerror")= "Error al Eliminar "
end if
'response.End()


'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("edicion_alumnos_talleres.asp?tdsi_ncorr="&tdsi_ncorr&"")
%>



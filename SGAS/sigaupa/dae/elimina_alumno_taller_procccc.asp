<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%

	for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
	next
'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


set f_agrega = new CFormulario
f_agrega.Carga_Parametros "talleres.xml", "cheques"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1
tdsi_ncorr = f_agrega.ObtenerValorPost (filai, "tdsi_ncorr")
pers_ncorr = f_agrega.ObtenerValorPost (filai, "pers_ncorr")

	p_delete="delete from alumnos_talleres_psicologia where tdsi_ncorr ="&tdsi_ncorr&" and pers_ncorr="&pers_ncorr&""		  
	response.Write("<pre>"&p_delete&"</pre>")
	'conectar.ejecutaS (p_delete)

'response.Write("respuesta "&Respuesta)	


next	


'response.End()















Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
'response.Write("respuesta "&Respuesta)


if Respuesta = true then
session("mensajeerror")= " El Taller fue eliminado con Éxito"
else
  session("mensajeerror")= "Error al Eliminar "
end if
'response.End()


'response.Redirect(request.ServerVariables("HTTP_REFERER"))
'response.Redirect("talleres.asp")
%>



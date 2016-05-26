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


set f_agrega = new CFormulario
f_agrega.Carga_Parametros "edicion_becas_mantencion.xml", "cheques"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1

monto_bene = f_agrega.ObtenerValorPost (filai, "monto_bene")
observacion = f_agrega.ObtenerValorPost (filai, "observacion")
acre_ncorr = f_agrega.ObtenerValorPost (filai, "acre_ncorr")









 usu=negocio.obtenerUsuario
	p_insert="update  alumno_credito set monto_bene='"&monto_bene&"',observacion='"&observacion&"',audi_tusuario='"&usu&"',audi_fmodificacion=getDate() where acre_ncorr="&acre_ncorr&""		  
	'response.Write("<pre>"&p_insert&"</pre>")
	conectar.ejecutaS (p_insert)

'response.Write("respuesta "&Respuesta)	


	
next

'response.End()















Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
'response.Write("respuesta "&Respuesta)


if Respuesta = true then
session("mensajeerror")= " El alumno fue ingresado con Éxito"
else
  session("mensajeerror")= "Error al guardar "
end if
'response.End()


'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("becas_mantencion_externas.asp")
%>



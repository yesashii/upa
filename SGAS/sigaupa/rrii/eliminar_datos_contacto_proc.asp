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
f_agrega.Carga_Parametros "convenios_rrii.xml", "agrega_contacto"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1

euco_ncorr = f_agrega.ObtenerValorPost (filai, "euco_ncorr")
daco_ncorr = f_agrega.ObtenerValorPost (filai, "daco_ncorr")
 'acre_ncorr=1000
 usu=negocio.obtenerUsuario
 if  euco_ncorr<>"" then
	p_insert="delete from  encargado_universidad_convenio  where euco_ncorr="&euco_ncorr&""		  
	response.Write("<pre>"&p_insert&"</pre>")
	conectar.ejecutaS (p_insert)
	Respuesta = conectar.ObtenerEstadoTransaccion()
end if
next


'----------------------------------------------------
'response.Write("respuesta "&Respuesta)
'response.End()
if Respuesta = true then
'session("mensajeerror")= " La Carrera fue Borrada"
else
  session("mensajeerror")= "Error al Borrar "
end if

'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("agrega_datos_contacto.asp?b%5B0%5D%5Bdaco_ncorr%5D="&daco_ncorr&"")









%>



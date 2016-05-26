<!-- #include file = "../biblioteca/_conexion.asp" -->
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
f_agrega.Carga_Parametros "convenios_rrii.xml", "agrega_contacto"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1

daco_ncorr=f_agrega.ObtenerValorPost (filai,"daco_ncorr")
euco_ncorr = f_agrega.ObtenerValorPost (filai,"euco_ncorr")
euco_tnombre = f_agrega.ObtenerValorPost (filai,"nombre")
euco_tcargo = f_agrega.ObtenerValorPost (filai,"cargo")
euco_direccion= f_agrega.ObtenerValorPost (filai,"dire")
euco_temail= f_agrega.ObtenerValorPost (filai,"email")
euco_tfono= f_agrega.ObtenerValorPost (filai,"fono")
euco_tfax= f_agrega.ObtenerValorPost (filai,"fax")
 'acre_ncorr=1000
 usu=negocio.obtenerUsuario
 
	p_insert="update encargado_universidad_convenio set euco_tnombre='"&euco_tnombre&"',euco_tcargo='"&euco_tcargo&"',euco_direccion='"&euco_direccion&"',euco_temail='"&euco_temail&"',euco_tfono='"&euco_tfono&"',euco_tfax='"&euco_tfax&"',audi_tusuario='"&usu&"',audi_fmodificacion=getDate() where euco_ncorr="&euco_ncorr&""		  
	response.Write("<pre>"&p_insert&"</pre>")
	conectar.ejecutaS (p_insert)

next

Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
response.Write("respuesta "&Respuesta)
'response.End()
if Respuesta = true then
session("mensajeerror")= "Los Datos se guardaron con exito"
else
  session("mensajeerror")= "Error al Guardar "
end if

'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("editar_datos_contacto.asp?daco_ncorr="&daco_ncorr&"&euco_ncorr="&euco_ncorr&"")









%>



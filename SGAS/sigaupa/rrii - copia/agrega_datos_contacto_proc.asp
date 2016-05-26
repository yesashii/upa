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

daco_ncorr = f_agrega.ObtenerValorPost (filai, "daco_ncorr")
euco_tnombre = f_agrega.ObtenerValorPost (filai, "nombre")
euco_tcargo= f_agrega.ObtenerValorPost (filai, "cargo")
euco_direccion= f_agrega.ObtenerValorPost (filai, "dire")
euco_temail= f_agrega.ObtenerValorPost (filai, "email")
euco_tfono= f_agrega.ObtenerValorPost (filai, "fono")
euco_tfax= f_agrega.ObtenerValorPost (filai, "fax")

 euco_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'encargado_universidad_convenio'")
 'acre_ncorr=1000
 usu=negocio.obtenerUsuario
 
	p_insert="insert into encargado_universidad_convenio(euco_ncorr,daco_ncorr,euco_tnombre,euco_tcargo,euco_direccion,euco_temail,euco_tfono,euco_tfax,audi_tusuario,audi_fmodificacion) values("&euco_ncorr&","&daco_ncorr&",'"&euco_tnombre&"','"&euco_tcargo&"','"&euco_direccion&"','"&euco_temail&"','"&euco_tfono&"','"&euco_tfax&"','"&usu&"',getDate())"		  
	'response.Write("<pre>"&p_insert&"</pre>")
	conectar.ejecutaS (p_insert)
	Respuesta = conectar.ObtenerEstadoTransaccion()

next


'----------------------------------------------------
'response.Write("respuesta "&Respuesta)
'response.End()
if Respuesta = true then
session("mensajeerror")= " El Contacto fue Guardado"
else
  session("mensajeerror")= "Error al Guardar "
end if

'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("agrega_datos_contacto.asp?b%5B0%5D%5Bdaco_ncorr%5D="&daco_ncorr&"")









%>



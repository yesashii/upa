<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'-----------------------------------------------------
	'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next
'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


set f_agrega = new CFormulario
f_agrega.Carga_Parametros "mensajeria_sicologo.xml", "enviar_mensaje"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1

pers_ncorr_destino = f_agrega.ObtenerValorPost (filai, "pers_ncorr_destino")
mensaje = f_agrega.ObtenerValorPost (filai, "mensaje")
asunto = f_agrega.ObtenerValorPost (filai, "asunto")







mesi_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'mensaje_sicologos'")
 usu=negocio.obtenerUsuario
 pers_ncorr_origen=conectar.ConsultaUno("select protic.obtener_pers_ncorr("&usu&")")
	p_insert="insert into mensajeria_sicologos (mesi_ncorr,pers_ncorr_origen,pers_ncorr_destino,mesi_mensaje,mesi_titulo,esme_ccod,audi_fmodificacion) values ("&mesi_ncorr&","&pers_ncorr_origen&","&pers_ncorr_destino&",'"&mensaje&"','"&asunto&"',1,getDate())"		  
	'response.Write("<pre>"&p_insert&"</pre>")
	conectar.ejecutaS (p_insert)

'response.Write("respuesta "&Respuesta)	


	
next

'response.End()















Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
'response.Write("respuesta "&Respuesta)


if Respuesta = true then
session("mensajeerror")= " El Mensaje fue enviado"
else
  session("mensajeerror")= "Error al enviar "
end if
'response.End()


'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("redactar_mensaje.asp?cerrar=1&mesi_ncorr="&mesi_ncorr&"")
%>



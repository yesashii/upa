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
f_agrega.Carga_Parametros "convenios_rrii.xml", "agrega_ciudad_extranjera"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1

ciex_ccod = f_agrega.ObtenerValorPost (filai, "ciex_ccod")
ciex_tdesc = f_agrega.ObtenerValorPost (filai, "ciex_tdesc")
pais_ccod = f_agrega.ObtenerValorPost (filai, "pais_ccod")

 'acre_ncorr=1000
 usu=negocio.obtenerUsuario
 
	p_insert="update ciudades_extranjeras set ciex_tdesc='"&ciex_tdesc&"',audi_tusuario='"&usu&"',audi_fmodificacion=getDate() where ciex_ccod="&ciex_ccod&""		  
	response.Write("<pre>"&p_insert&"</pre>")
	conectar.ejecutaS (p_insert)

next

Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
response.Write("respuesta "&Respuesta)
'response.End()
if Respuesta = true then
session("mensajeerror")= " La Ciudad fue Guardada"
else
  session("mensajeerror")= "Error al Guardar "
end if

'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("agrega_ciudad_convenio.asp?b%5B0%5D%5Bpais_ccod%5D="&pais_ccod&"")









%>



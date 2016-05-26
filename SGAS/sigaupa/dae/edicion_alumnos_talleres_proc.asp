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
f_agrega.Carga_Parametros "edicion_talleres.xml", "dictados"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1

tasi_ncorr = f_agrega.ObtenerValorPost (filai, "tasi_ncorr")
tdsi_ncorr = f_agrega.ObtenerValorPost (filai, "tdsi_ncorr")
peri_ccod = f_agrega.ObtenerValorPost (filai, "peri_ccod")
sede_ccod = f_agrega.ObtenerValorPost (filai, "sede_ccod")
fecha=  f_agrega.ObtenerValorPost (filai, "fecha")
 usu=negocio.obtenerUsuario
	p_insert="update  talleres_dictados_sicologia set tasi_ncorr="&tasi_ncorr&",peri_ccod='"&peri_ccod&"',sede_ccod='"&sede_ccod&"',fecha='"&fecha&"',audi_tusuario='"&usu&"',audi_fmodificacion=getDate() where tdsi_ncorr="&tdsi_ncorr&""		  
	'response.Write("<pre>"&p_insert&"</pre>")
	conectar.ejecutaS (p_insert)

'response.Write("respuesta "&Respuesta)	


	
next

'response.End()















Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
'response.Write("respuesta "&Respuesta)


if Respuesta = true then
session("mensajeerror")= " El Taller fue Actualizado con Éxito"
else
  session("mensajeerror")= "Error al guardar "
end if
'response.End()


'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("edicion_alumnos_talleres.asp?tdsi_ncorr="&tdsi_ncorr&"")
%>



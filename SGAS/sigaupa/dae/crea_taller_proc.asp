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
f_agrega.Carga_Parametros "crea_taller.xml", "busqueda"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1

tasi_tdesc = f_agrega.ObtenerValorPost (filai, "tasi_tdesc")








tasi_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'talleres_sicologia'")
 usu=negocio.obtenerUsuario
	p_insert="insert into talleres_sicologia (tasi_ncorr,tasi_tdesc,audi_tusuario,audi_fmodificacion) values("&tasi_ncorr&",'"&tasi_tdesc&"','"&usu&"',getDate())"		  
	'response.Write("<pre>"&p_insert&"</pre>")
	conectar.ejecutaS (p_insert)

'response.Write("respuesta "&Respuesta)	


	
next

'response.End()















Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
'response.Write("respuesta "&Respuesta)


if Respuesta = true then
session("mensajeerror")= " El Taller fue creado con Éxito"
else
  session("mensajeerror")= "Error al guardar "
end if
'response.End()


'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("talleres.asp")
%>



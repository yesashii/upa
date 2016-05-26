<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'-----------------------------------------------------
q_tasi_ncorr= request.QueryString("tasi_ncorr")	
	
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

tasi_tdesc = f_agrega.ObtenerValorPost (filai, "tasi_tdesc")
tasi_ncorr = f_agrega.ObtenerValorPost (filai, "tasi_ncorr")

if tasi_tdesc <>"" and  tasi_ncorr<>"" then
	p_delete="delete from talleres_sicologia where tasi_ncorr ="&tasi_ncorr&""		  
	'response.Write("<pre>"&p_delete&"</pre>")
	conectar.ejecutaS (p_delete)
end if
'response.Write("<pre>"&q_tasi_ncorr&"</pre>")	
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
response.Redirect("talleres.asp")
%>



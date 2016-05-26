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
f_agrega.Carga_Parametros "mensajeria_sicologo.xml", "elimina_mensaje"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1

mesi_ncorr = f_agrega.ObtenerValorPost (filai, "mesi_ncorr")
borrar = f_agrega.ObtenerValorPost (filai, "borrar")
'response.Write("<pre>"&mesi_ncorr&"</pre>")

 if borrar="Si" then
	p_insert="update mensajeria_sicologos set esme_ccod=3 where mesi_ncorr="&mesi_ncorr&""		  
	'response.Write("<pre>"&p_insert&"</pre>")
	conectar.ejecutaS (p_insert)
	
	'response.Write("respuesta "&Respuesta)	
end if

Respuesta = conectar.ObtenerEstadoTransaccion()	
next

'response.End()



'----------------------------------------------------
'response.Write("respuesta "&Respuesta)


if Respuesta = true then
session("mensajeerror")= " El o Los  Mensajes fueron borrados"
else
  session("mensajeerror")= "Error al borrar "
end if
'response.End()


'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("mensajeria.asp")
%>



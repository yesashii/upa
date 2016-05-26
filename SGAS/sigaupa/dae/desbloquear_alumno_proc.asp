<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'	for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next
'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


set f_agrega = new CFormulario
f_agrega.Carga_Parametros "desbloquea_alumno.xml", "bloqueo"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1

albs_ncorr = f_agrega.ObtenerValorPost (filai, "albs_ncorr")
pers_ncorr = f_agrega.ObtenerValorPost (filai, "pers_ncorr")
'response.Write("<pre>"&mesi_ncorr&"</pre>")

 if albs_ncorr<>"" then
	p_insert="update alumno_bloqueo_sicologos set albs_fdesbloque=getdate() where pers_ncorr="&pers_ncorr&" and albs_ncorr="&albs_ncorr&""		  
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
session("mensajeerror")= " El Bloqueo fue exitoso"
else
  session("mensajeerror")= "Error al Bloquear "
end if
'response.End()


'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("desbloquea_alumno.asp")
%>



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
f_agrega.Carga_Parametros "agrega_alumnos_taller.xml", "cheques"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm

for filai = 0 to f_agrega.CuentaPost - 1

tdsi_ncorr = f_agrega.ObtenerValorPost (filai, "tdsi_ncorr")
pers_ncorr = f_agrega.ObtenerValorPost (filai, "pers_ncorr")
pagi = f_agrega.ObtenerValorPost (filai, "pagi")

 atsi_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'alumnos_talleres_psicologia'")
 'acre_ncorr=10000
 usu=negocio.obtenerUsuario
 
	p_insert="insert into alumnos_talleres_psicologia(tdsi_ncorr,atsi_ncorr,pers_ncorr,audi_fmodificacion,audi_tusuario) values("&tdsi_ncorr&","&atsi_ncorr&","&pers_ncorr&",'"&usu&"',getDate())"		  
	'response.Write("<pre>"&p_insert&"</pre>")
	conectar.ejecutaS (p_insert)

	





next
'response.End()
	



















Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
response.Write("respuesta "&Respuesta)


if Respuesta = true then
session("mensajeerror")= " El alumno fue ingresado con Éxito"
else
  session("mensajeerror")= "Error al guardar "
end if
'response.End()

if pagi="2" then
if Respuesta = true then
response.Redirect("agrega_alumnos_taller.asp?tdsi_ncorr="&tdsi_ncorr&"&pagi="&pagi&"")
else
response.Redirect("edicion_alumnos_talleres.asp?tdsi_ncorr="&tdsi_ncorr&"&pagi="&pagi&"")
end if
else
if Respuesta = true then
response.Redirect("agrega_alumnos_taller.asp?tdsi_ncorr="&tdsi_ncorr&"")
else
response.Redirect("agrega_alumnos_taller.asp?tdsi_ncorr="&tdsi_ncorr&"")
end if
end if




%>



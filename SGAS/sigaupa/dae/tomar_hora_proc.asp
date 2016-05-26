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

hoto_ncorr=conectar.consultaUno("exec obtenerSecuencia 'HORAS_TOMADAS'")
blsi_ncorr=request.QueryString("blsi_ncorr")
pers_ncorr=request.QueryString("pers_ncorr")
hoto_fecha=request.QueryString("fecha_hora")
dias_ccod=request.QueryString("dias_ccod")
peri_ccod=request.QueryString("peri_ccod")
q_sede_ccod=request.QueryString("q_sede_ccod")
fecha_consulta_r=request.QueryString("fecha_consulta_r")
rut=request.QueryString("rut")
dv=request.QueryString("dv")


'response.Write("<br>fecha_consulta_r='"&fecha_consulta_r&"'<br>")

existe_bloque=conectar.ConsultaUno("select case count(*) when 0 then 'N' else 'S' end  from horas_tomadas where blsi_ncorr="&blsi_ncorr&" and esho_ccod in (1,2) and dias_ccod="&dias_ccod&" and protic.trunc(hoto_fecha)=protic.trunc('"&hoto_fecha&"')")

if existe_bloque="N" then
	usu=negocio.ObtenerUsuario()
	p_delete="insert into horas_tomadas (hoto_ncorr,blsi_ncorr,pers_ncorr,hoto_fecha,dias_ccod,esho_ccod,audi_fmodificacion,audi_tusuario) values ("&hoto_ncorr&","&blsi_ncorr&","&pers_ncorr&",'"&hoto_fecha&"','"&dias_ccod&"',1,getdate(),'"&usu&"')"		  
	'response.Write("<pre>"&p_delete&"</pre>")
	conectar.ejecutaS (p_delete)
'response.End()

Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
'response.Write("respuesta "&Respuesta)
if Respuesta = true then
session("mensajeerror")= "La Hora fue Tomada"
response.Redirect("http://admision.upacifico.cl/peticion_horas/www/envia_aviso_hora_tomada_correo_asp.php?hoto_ncorr="&hoto_ncorr&"&peri_ccod="&peri_ccod&"&q_sede_ccod="&q_sede_ccod&"&fecha_consulta_r="&fecha_consulta_r&"&rut="&rut&"&dv="&dv&"&usuario_asp="&usu&"")

else
  session("mensajeerror")= "Error al Tomar la hora"
  response.Redirect("tomar_hora.asp")
end if

else
  session("mensajeerror")= "El bloque seleccionado ya fue asignado"
  response.Redirect("tomar_hora.asp")

end if
'response.End()


'response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>



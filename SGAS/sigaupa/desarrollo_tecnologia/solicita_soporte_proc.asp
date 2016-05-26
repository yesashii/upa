<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'for each k in request.form
'response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

				usuario=negocio.ObtenerUsuario
				nombre_persona=conexion.ConsultaUno("select pers_tnombre+' '+pers_tape_paterno from personas where pers_nrut="&usuario&"")
				pers_ncorr=conexion.ConsultaUno("select pers_ncorr from personas where pers_nrut="&usuario&"")
				peso_ncorr= conexion.ConsultaUno("execute obtenersecuencia 'peticion_soporte'")
				inci_ccod = conexion.consultaUno("select isnull(max(folio),499) + 1  from incidentes ")
				folio = inci_ccod
				inci_ccod = "INC0"&folio
				fecha_peticion=conexion.consultaUno("select protic.trunc(getdate())")
				hora_peticion=conexion.consultaUno("select SUBSTRING ( CONVERT(char(38),getdate(),121), 12,5)")
				incidente=request.form("b[0][peso_tdescripcion]")
				solicita=request.form("solicita")
				 'response.write(maqu_ncorr&"<hr>")'
				set f_peticion = new CFormulario
				f_peticion.Carga_Parametros "solicita_soporte.xml", "solicita_proc"
				f_peticion.Inicializar conexion
				f_peticion.ProcesaForm
				
				sede_ccod=request.Form("b[0][sede_ccod]") 
				pers_nrut_solicitante=request.Form("b[0][pers_nrut]") 
				email=request.Form("b[0][peso_temail]")
				
				
				email_soporte_sede=conexion.ConsultaUno("select csse_email from correos_soporte_sedes where sede_ccod="&sede_ccod&"")
				if pers_nrut_solicitante<>"" then
				pers_ncorr=conexion.ConsultaUno("select pers_ncorr from personas where pers_nrut="&pers_nrut_solicitante&"")
				nombre_persona=conexion.ConsultaUno("select pers_tnombre+' '+pers_tape_paterno from personas where pers_nrut="&pers_nrut_solicitante&"")
				end if
				f_peticion.agregacampopost "inci_ccod",inci_ccod
				f_peticion.agregacampopost "peso_ncorr",peso_ncorr
				f_peticion.agregacampopost "pers_ncorr",pers_ncorr
				f_peticion.agregacampopost "fecha_incidente",fecha_peticion
				f_peticion.agregacampopost "hora_incidente", hora_peticion
				f_peticion.agregacampopost "incidente",incidente
				f_peticion.agregacampopost "folio",folio
				f_peticion.agregacampopost "EINC_CCOD",1
				f_peticion.MantieneTablas false
				'conexion.estadotransaccion true
Respuesta = conexion.ObtenerEstadoTransaccion()

'response.Write("</br>"&Respuesta)
'response.End()

if Respuesta  then
session("mensajeerror")= " La Solicitud ha sido enviada con exito"
response.Redirect("http://www.upacifico.cl/super_test/motor_envia_aviso_soporte2.php?nom_usuario="&nombre_persona&"&codigo_solicitud="&inci_ccod&"&correo_upa="&email&"&correo_soporte="&email_soporte_sede&"")

else
  session("mensajeerror")= "Error al guardar"
  response.Redirect("solicita_soporte.asp")
end if
%>

<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()

reun_ncorr=request.form("a[0][reun_ncorr]")
dgso_ncorr=request.form("a[0][dgso_ncorr]")

set pagina = new CPagina
pagina.Titulo = "Mantenedor De Salas"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
usu=negocio.ObtenerUsuario()
'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "agrega_unidades.xml", "unidades"
formulario.inicializar conexion


existe=conexion.ConsultaUno("select case count(*) when 0 then 'N' else 'S' end from responsable_programa where reun_ncorr="&reun_ncorr&" and dgso_ncorr="&dgso_ncorr&"")

if existe="N" then
		
		Sinsert=" insert into RESPONSABLE_PROGRAMA (reun_ncorr,dgso_ncorr,esre_ccod,audi_tusuario,audi_fmodificacion) "& vbCrlf & _
		"values ("&reun_ncorr&","&dgso_ncorr&",1,'"&usu&"',getdate())"
						'response.Write("<br>"&Sinsert)
						conexion.ejecutaS(Sinsert)
						
		resultado=conexion.ObtenerEstadoTransaccion
		'response.Write("<br>"&resultado)
		'response.End()
		
		if conexion.ObtenerEstadoTransaccion  then
			session("mensajeError")="El responsable se ha Agregado"
		else
			session("mensajeError")="El responsable no se ha Guardado."
		end if
'response.End()
else
Sinsert="update RESPONSABLE_PROGRAMA  set esre_ccod=1, audi_tusuario='"&usu&"' , audi_fmodificacion=getdate() where reun_ncorr="&reun_ncorr&" and dgso_ncorr="&dgso_ncorr&""
			conexion.ejecutaS(Sinsert)
						
		resultado=conexion.ObtenerEstadoTransaccion
		'response.Write("<br>"&resultado)
		'response.End()
		
		if conexion.ObtenerEstadoTransaccion  then
			session("mensajeError")="El responsable se ha Agregado"
		else
			session("mensajeError")="El responsable no se ha Guardado."
		end if
end if
response.Redirect("responsable_programa.asp")				
'%>



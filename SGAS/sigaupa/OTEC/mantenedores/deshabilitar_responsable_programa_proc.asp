<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
for each k in request.form
	response.write(k&"="&request.Form(k)&"<br>")
next
'response.End()

'reun_ncorr=request.form("a[0][reun_ncorr]")
'dgso_ncorr=request.form("a[0][dgso_ncorr]")

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
formulario.ProcesaForm
for filai = 0 to formulario.CuentaPost - 1


reun_ncorr = formulario.ObtenerValorPost (filai, "reun_ncorr")
dgso_ncorr = formulario.ObtenerValorPost (filai, "dgso_ncorr")


	if 	reun_ncorr<>"" and 	dgso_ncorr<>"" then
			Sinsert=" update RESPONSABLE_PROGRAMA  set esre_ccod=2, audi_tusuario='"&usu&"' , audi_fmodificacion=getdate() where reun_ncorr="&reun_ncorr&" and dgso_ncorr="&dgso_ncorr&""
							response.Write("<br>"&Sinsert)
							conexion.ejecutaS(Sinsert)
							
			resultado=conexion.ObtenerEstadoTransaccion
			response.Write("<br>"&resultado)
			'response.End()
			
			if conexion.ObtenerEstadoTransaccion  then
				session("mensajeError")="El responsable se ha Deshabilitado"
			else
				session("mensajeError")="El responsable no se ha Deshabilitado."
			end if
	end if
	

next
'response.End()
response.Redirect("responsable_programa.asp")				
'%>



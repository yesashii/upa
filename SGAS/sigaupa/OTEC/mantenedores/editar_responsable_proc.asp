<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()

pers_ncorr=request.form("a[0][pers_ncorr]")
email=request.form("a[0][email]")

set pagina = new CPagina
pagina.Titulo = "Mantenedor De Salas"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set conexion2 = new CConexion
conexion2.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
usu=negocio.ObtenerUsuario()
'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "agrega_unidades.xml", "unidades"
formulario.inicializar conexion

		
		Sinsert2="update correo_responsables_otec  set email_upa='"&email&"' where pers_ncorr="&pers_ncorr&""
		conexion.ejecutaS(Sinsert2)	
		resultado=conexion.ObtenerEstadoTransaccion
		'response.Write("<br>"&Sinsert2)
		'response.End()
		
		if conexion.ObtenerEstadoTransaccion  then
			session("mensajeError")="El responsable se ha Modificado"
		else
			session("mensajeError")="El responsable no se ha Modificado."
		end if
'response.End()
response.Redirect("responsable_unidad.asp")				
'%>



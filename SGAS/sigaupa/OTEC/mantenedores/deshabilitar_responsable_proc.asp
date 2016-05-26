<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
for each k in request.form
	response.write(k&"="&request.Form(k)&"<br>")
next
'response.End()
'udpo_tdesc=request.form("agregar_unidad[0][UDPO_TDESC]")
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
usu=negocio.ObtenerUsuario()
'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "responsable_unidad.xml", "habilita"
formulario.inicializar conexion
formulario.ProcesaForm
for filai = 0 to formulario.CuentaPost - 1

UDPO_CCOD = formulario.ObtenerValorPost (filai, "UDPO_CCOD")
pers_ncorr = formulario.ObtenerValorPost (filai, "pers_ncorr")

	if UDPO_CCOD<>"" and pers_ncorr<>"" then
	'usuario=negocio.ObtenerUsuario()
	Sinsert="update   responsable_unidad set esre_ccod='2', audi_tusuario='"&usu&"', audi_fmodificacion=getdate() where udpo_ccod="&UDPO_CCOD&" and pers_ncorr="&pers_ncorr&""
					'response.Write("<br>"&Sinsert)
					conexion.ejecutaS(Sinsert)
					
		if conexion.ObtenerEstadoTransaccion  then
		session("mensajeError")="El Responsable fue Deshabilitado"
		else'
			session("mensajeError")="El Responsable NO fue Deshabilitado."
		end if
	
	end if
 
next

'response.End()
response.Redirect("responsable_unidad.asp")				
'%>



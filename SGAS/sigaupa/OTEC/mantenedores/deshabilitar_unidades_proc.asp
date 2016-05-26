<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
for each k in request.form
	response.write(k&"="&request.Form(k)&"<br>")
next
'response.End()
'udpo_tdesc=request.form("agregar_unidad[0][UDPO_TDESC]")
usu=negocio.ObtenerUsuario()
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "agrega_unidades.xml", "unidades"
formulario.inicializar conexion
formulario.ProcesaForm
for filai = 0 to formulario.CuentaPost - 1

UDPO_CCOD = formulario.ObtenerValorPost (filai, "UDPO_CCOD")
UDPO_TDESC = formulario.ObtenerValorPost (filai, "UDPO_TDESC")

	
	'usuario=negocio.ObtenerUsuario()
	Sinsert="update   unidades_dictan_programas_otec set udpo_bhabilitado='N', audi_tusuario='"&usu&"', audi_fmodificacion=getdate()  where udpo_ccod="&UDPO_CCOD&""
					response.Write("<br>"&Sinsert)
					conexion.ejecutaS(Sinsert)
	'elseif existe_en_ofertas="S" then
	'unidad=unidad&" "&UDPO_TDESC
	'	session("mensajeError")="El o las unidades "&unidad&" no pueden ser eliminadas por estar asociadas una oferta, \n solo puedes deshabilitarla."
	'end if
 
next

'if conexion.ObtenerEstadoTransaccion  then
	'session("mensajeError")="La Unidad se ha Agregado"
'else'
	session("mensajeError")="La Unidad se ha Deshabilitado."
'end if
'response.End()
response.Redirect("unidades.asp")				
'%>



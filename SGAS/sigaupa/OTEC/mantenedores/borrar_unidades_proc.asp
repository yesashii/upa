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

'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "agrega_unidades.xml", "unidades"
formulario.inicializar conexion
formulario.ProcesaForm
for filai = 0 to formulario.CuentaPost - 1

UDPO_CCOD = formulario.ObtenerValorPost (filai, "UDPO_CCOD")
UDPO_TDESC = formulario.ObtenerValorPost (filai, "UDPO_TDESC")


's_existe="select case count(*) when '0' then 'N' else 'S' from ofertas_otec where udpo_ccod="&&""

if UDPO_CCOD<>"" and UDPO_TDESC<>"" then

	existe_en_ofertas=conexion.consultaUno("select case count(*) when '0' then 'N' else 'S' end from ofertas_otec where udpo_ccod="&UDPO_CCOD&"")


	if existe_en_ofertas="N" then
	'usuario=negocio.ObtenerUsuario()
	Sinsert="delete from unidades_dictan_programas_otec where udpo_ccod="&UDPO_CCOD&""
					response.Write("<br>"&Sinsert)
					conexion.ejecutaS(Sinsert)
	elseif existe_en_ofertas="S" then
	unidad=unidad&" "&UDPO_TDESC
		session("mensajeError")="El o las unidades "&unidad&" no pueden ser eliminadas por estar asociadas una oferta, \n solo puedes deshabilitarla."
	end if
end if
next

'if conexion.ObtenerEstadoTransaccion  then
	'session("mensajeError")="La Unidad se ha Agregado"
'else'
	'session("mensajeError")="La Unidad no se ha guardado."
'end if
'response.End()
response.Redirect("unidades.asp")				
'%>



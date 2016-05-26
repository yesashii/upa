<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next

udpo_tdesc=request.form("agregar_unidad[0][UDPO_TDESC]")

set pagina = new CPagina
pagina.Titulo = "Mantenedor De Salas"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "agrega_unidades.xml", "unidades"
formulario.inicializar conexion


udpo_tdesc=UCASE(udpo_tdesc)
UDPO_CCOD=conexion.ConsultaUno("exec ObtenerSecuencia 'UNIDADES_DICTAN_PROGRAMAS_OTEC'")
usuario=negocio.ObtenerUsuario()
Sinsert="insert into UNIDADES_DICTAN_PROGRAMAS_OTEC (UDPO_CCOD,UDPO_TDESC,AUDI_TUSUARIO,UDPO_BHABILITADO,AUDI_FMODIFICACION) values("&UDPO_CCOD&",'"&udpo_tdesc&"','"&usuario&"','S',getdate())"
				'response.Write("<br>"&Sinsert)
				conexion.ejecutaS(Sinsert)
				
resultado=conexion.ObtenerEstadoTransaccion
'response.Write("<br>"&resultado)
'response.End()

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="La Unidad se ha Agregado"
else
	session("mensajeError")="La Unidad no se ha guardado."
end if
'response.End()
response.Redirect("unidades.asp")				
'%>



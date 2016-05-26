<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next

udpo_tdesc=request.form("agregar_unidad[0][UDPO_TDESC]")
udpo_ccod=request.form("agregar_unidad[0][udpo_ccod]")



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
usuario=negocio.ObtenerUsuario()


Sinsert="update UNIDADES_DICTAN_PROGRAMAS_OTEC set UDPO_TDESC='"&udpo_tdesc&"', audi_tusuario='"&usuario&"' , audi_fmodificacion=getdate() where UDPO_CCOD="&UDPO_CCOD&""		
				
				'response.Write("<br>"&Sinsert)
				conexion.ejecutaS(Sinsert)
				
resultado=conexion.ObtenerEstadoTransaccion
'response.Write("<br>"&resultado)
'response.End()

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="La Unidad fue Actualizada"
else
	session("mensajeError")="La Unidad no se ha Actualizado."
end if
'response.End()
response.Redirect("editar_unidades.asp?udpo_ccod="&UDPO_CCOD&"")				
'%>



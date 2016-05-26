<!-- #include file = "../biblioteca/_conexion_sbd01.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

for each k in request.form
response.Write(k&" = "&request.Form(k)&"<br>")
next


set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion




tavi_ncorr= conexion.ConsultaUno("execute obtenersecuencia 'tarjeta_video'")
' response.write(maqu_ncorr&"<hr>")'


mtvi_ccod=request.form("b[0][mtvi_ccod]")
tavi_tmodelo=request.form("b[0][tavi_tmodelo]")
tavi_ttam_memoria=request.form("b[0][tavi_ttam_memoria]")
tavi_tnserie=request.form("b[0][tavi_tnserie]")

usuario=negocio.Obtenerusuario()

'response.End()'
sql="insert into tarjeta_video (tavi_ncorr,tavi_tnserie,mtvi_ccod,tavi_tmodelo,tavi_ttam_memoria,tavi_bactivo,audi_tusuario,audi_fmodificacion) values ("&tavi_ncorr&",'"&tavi_tnserie&"',"&mtvi_ccod&",'"&tavi_tmodelo&"','"&tavi_ttam_memoria&"',1,'"&usuario&"',getdate())"

'response.write(sql)'
'response.End()'

conexion.EjecutaS(sql)

Respuesta = conexion.ObtenerEstadoTransaccion()
'----------------------------------------------------
response.Write("respuesta "&Respuesta)

'response.End()
if Respuesta = true then
response.Redirect("tvideo_ingresado.asp?tavi="&tavi_ncorr&"")
else
  session("mensajeerror")= "Error al guardar "
  response.Redirect(request.ServerVariables("HTTP_REFERER"))
end if

'

%>

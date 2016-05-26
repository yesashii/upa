<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

for each k in request.form
response.Write(k&" = "&request.Form(k)&"<br>")
next


set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion




' response.write(maqu_ncorr&"<hr>")'


empr_ncorr = request.form("b[0][empr_ncorr]")
dgso_ncorr = request.form("b[0][dgso_ncorr]")
nord_compra = request.form("b[0][nord_compra]")
ocot_nro_registro_sence = request.form("b[0][ocot_nro_registro_sense]")

usuario=negocio.Obtenerusuario()

'response.End()'
sql="update  ordenes_compras_otec set ocot_nro_registro_sence='"&ocot_nro_registro_sence&"' where dgso_ncorr="&dgso_ncorr&" and nord_compra="&nord_compra&" and empr_ncorr="&empr_ncorr&""

'response.write(sql)'
'response.End()'

conexion.EjecutaS(sql)

Respuesta = conexion.ObtenerEstadoTransaccion()
'----------------------------------------------------
'response.Write("respuesta "&Respuesta)

'response.End()
if Respuesta = true then

  session("mensajeerror")= "La informacion se ha guardado exitosamente"
  response.Redirect("buscar_oc.ASP")
else
  session("mensajeerror")= "Error al guardar "
response.Redirect("buscar_oc.ASP")
end if

'

%>

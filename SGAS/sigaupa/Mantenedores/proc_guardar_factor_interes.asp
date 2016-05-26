<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
v_nuevo_rango=request.QueryString("nuevo_rango")

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()
i=0
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.ObtenerUsuario()

'response.Write("<hr>")
if v_nuevo_rango="S" then
'actualiza rango activo a terminado
	sql_update="Update factor_interes set efin_ccod=2, audi_tusuario='"&usuario&"', audi_fmodificacion=getdate() where efin_ccod=1"
	conexion.EjecutaS(sql_update)
	' INSERTAR
	fint_ncorr 		= conexion.consultauno("exec ObtenerSecuencia 'factor_interes'")
	for each k in request.form
		i=i+1	
		sql_inserta_rango	= " insert into factor_interes (fint_ncorr,rafi_ccod,efin_ccod,anos_ccod,fint_nfactor_anual,audi_tusuario, audi_fmodificacion) "&_ 
								" values("&fint_ncorr&","&i&",1,datepart(year,getdate()),'"&request.Form(k)&"','"&usuario&"',getdate() )"
	'	response.Write("<br>"&sql_inserta_rango)
		conexion.EjecutaS(sql_inserta_rango)
	next
else

	'ACTUALIZAR
	for each k in request.form
		i=i+1	
		sql_actualiza_rango	= 	" Update factor_interes set fint_nfactor_anual='"&request.Form(k)&"', audi_tusuario='"&usuario&"', audi_fmodificacion=getdate() "&_
								" Where efin_ccod=1 and rafi_ccod="&i&" " 
		'response.Write("<br>"&sql_actualiza_rango)
		conexion.EjecutaS(sql_actualiza_rango)
	next

end if


'conexion.estadoTransaccion false

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="Los Rangos para los intereses selecionados fueron guardadas correctamente."
else
	session("mensajeError")="Ocurrio un error al intentar actualizar uno o mas rangos.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
'response.End()
response.Redirect("mantenedor_factor_interes.asp")
%>
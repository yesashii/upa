<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

v_pers_nrut	= request.Form("pers_nrut")
v_pers_ncorr= request.Form("pers_ncorr")
v_peri_ccod	= request.Form("test[0][peri_ccod]")
v_sede_ccod	= request.Form("test[0][sede_ccod]")

set conectar = new CConexion
conectar.Inicializar "upacifico"	

set negocio = new CNegocio
negocio.Inicializa conectar

rut_usuario = negocio.ObtenerUsuario

		estado = conectar.ConsultaUno("select top 1 EMAT_CCOD from alumnos where pers_ncorr = "&v_pers_ncorr&" order by alum_fmatricula desc")
		matr_ncorr = conectar.ConsultaUno("select top 1 matr_ncorr from alumnos where pers_ncorr = "&v_pers_ncorr&" order by alum_fmatricula desc")		
		'response.Write("<br>"&estado)
		'response.Write("<br>"&matr_ncorr)
		
		'response.End()
		'*****************CAMBIO ESTADO A ACTIVO PARA PODER GENERAR MATRICULA*****************
	if estado <> "1" then
		cambioUNO="UPDATE alumnos SET emat_ccod = 1 WHERE pers_ncorr = "&v_pers_ncorr&" AND matr_ncorr = "&matr_ncorr&""
		conectar.EstadoTransaccion conectar.EjecutaS(cambioUNO)
		'response.Write("<br>"&cambioUNO)
		'response.End()
		end if
		
		'*****************EJECUTA PROCEDIMIENTO PARA REALIZAR LA MATRICULA*****************
		SQL="exec CREAR_MATRICULA_ajuste "&v_sede_ccod&","&v_pers_nrut&","&v_peri_ccod&","&v_pers_ncorr&",'"&rut_usuario&"'"
		'response.Write(SQL)
		'response.End()
		conectar.EstadoTransaccion conectar.EjecutaS(SQL)
		'conectar.ConsultaUno(SQL)
		'response.Write("<br>"&SQL)		
		'response.Write("<br>"&v_salida)
		'response.End()
		'*****************CAMBIO A ESTADO ANTERIOR*****************
	if estado <> "1" then
		cambioDos="UPDATE alumnos SET emat_ccod = "&estado&" WHERE pers_ncorr = "&v_pers_ncorr&" AND matr_ncorr = "&matr_ncorr&""
		'response.Write("<br>"&estado)
		'response.Write("<br>"&matr_ncorr)
		conectar.EstadoTransaccion conectar.EjecutaS(cambioDos)
		'response.Write("<br>"&cambioDos)
		end if	
		
		'response.End()

if conectar.ObtenerEstadoTransaccion = true then 'and v_salida = "1" then
	session("mensaje_error") = "Se Realizo la creacion de matricula con exito..."
else
	session("mensaje_error") = "Ocurrio un error al intentar crear la matricula, Vuelva a intentarlo..."
end if
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
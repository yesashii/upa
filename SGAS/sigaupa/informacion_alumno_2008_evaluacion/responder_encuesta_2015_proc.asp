<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_encuesta_2015.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 

'------------------------------------------------------
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conexion = new CConexion
conexion.inicializar "upacifico"

arr_secc_ccod	=	request.Form("arr_secc_ccod")
arr_pers_ncorr_prof	=	request.Form("arr_pers_ncorr_prof")
pers_temporal	=	request.Form("pers_ncorr_temporal")
observacion		=	request.Form("observaciones")
'response.write("arr: "&arr_secc_ccod&"<br>")


arr_secciones	=	Split(arr_secc_ccod, ",")
arr_profesores	=	Split(arr_pers_ncorr_prof, ",")

Dim respuestas(19)

for i = 0 to Ubound(arr_secciones)
'print_r secc_ccod, 0
sql_insert = "insert into evaluacion_docente_alumnos_2015 values ("&Ltrim(arr_secciones(i))&","&Ltrim(pers_temporal)&","&Ltrim(arr_profesores(i))&""

	cont_secc	=	i+1
	
	for j = 0 to 19
		cont	=	j+1
		'response.Write(Left(request.Form("nota["&cont&"]["&cont_secc&"]"),1)&"<br>")
		if Len(request.Form("nota["&cont&"]["&cont_secc&"]")) > 1 then
			respuestas(j)	=	Left(request.Form("nota["&cont&"]["&cont_secc&"]"),1)
		else
			respuestas(j)	=	request.Form("nota["&cont&"]["&cont_secc&"]")
		end if
		'response.Write("nota"&j&": "&respuestas(j)&"<br>")
		sql_insert = sql_insert & ","&respuestas(j)&""
	next
	sql_insert = sql_insert & ",'"&observacion&"',getdate());"

	'response.Write(sql_insert&"<br>")
	conexion.EjecutaS(sql_insert)
next

'response.Write(arr_secciones(0))
'response.End()
if conexion.ObtenerEstadoTransaccion then
	Response.Redirect("encuesta_2015_fin.asp")
	
else
	response.write("Se presento un error al grabar su encuesta, favor cierre sesion y vuelva a intentarlo")
	EndTime = Now() + (8/ (24 * 60* 60)) '8 seconds
		Do While Now() < EndTime
			'Do nothing
		Loop
	Response.Redirect("encuesta_2015_fin.asp")
end if
%>
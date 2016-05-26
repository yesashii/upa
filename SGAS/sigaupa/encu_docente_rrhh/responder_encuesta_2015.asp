<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
'------------------------------------------------------
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conexion = new CConexion
conexion.Inicializar "upacifico"


peri_ccod		=	request.Form("peri_ccod")
pers_ncorr		=	request.Form("pers_ncorr")
obs1			=	request.Form("texto1_mejora")
obs2			=	request.Form("texto2_mejora")
'response.write("arr: "&arr_secc_ccod&"<br>")

'Dim arr_carreras(3)

arr_carreras	=	Split(carr_ccod, ",")
arr_profesores	=	Split(arr_pers_ncorr_prof, ",")

'response.Write(arr_carreras(0))
'response.End()

Dim respuestas(13)

'for i = 0 to Ubound(arr_profesores)
'print_r secc_ccod, 0
sql_insert = "insert into autoevaluacion_docente_2015 values ("&peri_ccod&","&pers_ncorr&""
'response.Write(sql_insert)
'response.End()
	cont_secc	=	i+1
	
	for j = 0 to 12
		cont	=	j+1
		'response.Write(Left(request.Form("nota["&cont&"]["&cont_secc&"]"),1)&"<br>")
		if Len(request.Form("nota["&cont&"]")) > 1 then
			respuestas(j)	=	Left(request.Form("nota["&cont&"]"),1)
		else
			respuestas(j)	=	request.Form("nota["&cont&"]")
		end if
		'response.Write("nota"&j&": "&respuestas(j)&"<br>")
		sql_insert = sql_insert & ","&respuestas(j)&""
	next
	sql_insert = sql_insert & ", '" & obs1 & "','" & obs2 & "'"
	sql_insert = sql_insert & ",getdate());"

	'response.Write(sql_insert&"<br>")
	'response.End()
	conexion.EjecutaS(sql_insert)
'next

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
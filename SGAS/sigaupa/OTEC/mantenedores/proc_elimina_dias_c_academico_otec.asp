<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"
'-------------------------------------------------------------------
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
'-------------------------------------------------------------------
seot_ncorr = request.Form("b[0][seot_ncorr]")
consulta_1 = "" & vbCrLf & _
"select count(pcot_ncorr)            " & vbCrLf & _
"from   programacion_calendario_otec " & vbCrLf & _
"where  seot_ncorr = '"&seot_ncorr&"'          " 
hasta = conexion.consultauno(consulta_1)


set f_tipos_detalle = new CFormulario
f_tipos_detalle.Carga_Parametros "calendario_academico_otec.xml", "programa"
f_tipos_detalle.Inicializar conexion
f_tipos_detalle.ProcesaForm

'------------------------------------------------------------------------------------------------
for i = 0 to hasta -1
'	pcot_ncorr = f_tipos_detalle.ObtenerValorPost(i_, "pcot_ncorr")	
	pcot_ncorr = Request.Form("p["&i&"][pcot_ncorr]")
	if pcot_ncorr <> "" then
		consulta_delete1 = "" & vbCrLf & _
		"delete programacion_calendario_detalle_otec 	" & vbCrLf & _
		"where pcot_ncorr =  '"&pcot_ncorr&"'    		" 
		conexion.ejecutaS(consulta_delete1)
		consulta_delete2 = "" & vbCrLf & _
		"delete programacion_calendario_otec 	" & vbCrLf & _
		"where pcot_ncorr = '"&pcot_ncorr&"'	"
		conexion.ejecutaS(consulta_delete2)
	end if
	'response.Write("pcot_ncorr["&i&"] = "& pcot_ncorr)
next
'------------------------------------------------------------------------------------------------

'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
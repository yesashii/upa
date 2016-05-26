<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/funciones_formateo.asp" -->

<%
'---------------------------------------------------------------------------------------------------------------------------------
q_envi_ncorr = Request.QueryString("envi_ncorr")
q_todos = Request.QueryString("todos")

Response.AddHeader "Content-Disposition", "attachment;filename=exportar_sueldos_2006.txt"
Response.ContentType = "text/plain"
'for each x in request.Form
'	response.Write("<br>"& x &"->"&request.Form(x))
'next

'---------------------------------------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "consulta.xml", "consulta"
f_consulta.Inicializar conexion



consulta = "select '71704700' as rut_empresa,'1' as dv_e," & vbCrLf &_
			" STUFF(rut_trabajador, 1, 0,REPLICATE('0',cast(8-len(rut_trabajador) as numeric))) as rut_trabajador,dv_t, " & vbCrLf &_
			" '00000' as correlativo_t, " & vbCrLf &_
			" substring(paterno_t,0,60) as paterno_t,substring(materno_t,0,40) as materno_t,substring(nombres_t,0,40) as nombres_t, " & vbCrLf &_
			" STUFF(mes_renta, 1, 0,REPLICATE('0',cast(2-len(mes_renta) as numeric))) as mes_renta, " & vbCrLf &_
			" STUFF(total_sueldo, 1, 0,REPLICATE('0',cast(12-len(total_sueldo) as numeric))) as total_sueldo, " & vbCrLf &_
			" STUFF(total_imponible, 1, 0,REPLICATE('0',cast(12-len(total_imponible) as numeric))) as total_imponible, " & vbCrLf &_
			" STUFF(total_retenido, 1, 0,REPLICATE('0',cast(12-len(total_retenido) as numeric))) as total_retenido, " & vbCrLf &_
			" STUFF(mayor_retencion, 1, 0,REPLICATE('0',cast(12-len(mayor_retencion) as numeric))) as mayor_retencion, " & vbCrLf &_
			" STUFF(renta_total_exenta, 1, 0,REPLICATE('0',cast(12-len(renta_total_exenta) as numeric))) as renta_total_exenta, " & vbCrLf &_
			" STUFF(rebajas_zonas, 1, 0,REPLICATE('0',cast(12-len(rebajas_zonas) as numeric))) as rebajas_zonas, " & vbCrLf &_
			" STUFF(numero_certificado, 1, 0,REPLICATE('0',cast(7-len(numero_certificado) as numeric))) as numero_certificado " & vbCrLf &_
			" from sd_base_sueldos " 



		   
consulta = consulta & "order by rut_trabajador asc,mes_renta asc"

'Response.Write("<pre>" &consulta&"</pre>")
f_consulta.Consultar consulta


while f_consulta.Siguiente
    Response.Write(Ac(f_consulta.ObtenerValor("rut_empresa"),8,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("dv_e"),1,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("rut_trabajador"),8,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("dv_t"),1,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("correlativo_t"),5,"I"))	
	Response.Write(Ac(f_consulta.ObtenerValor("paterno_t"),60,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("materno_t"),40,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("nombres_t"),40,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("mes_renta"),2,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("total_sueldo"),12,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("total_imponible"),12,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("total_retenido"),12,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("mayor_retencion"),12,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("renta_total_exenta"),12,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("rebajas_zonas"),12,"I"))
	Response.Write(Ac(f_consulta.ObtenerValor("numero_certificado"),7,"I"))
	Response.Write(vbCrLf)
wend

'Response.Write("</pre>")
%>

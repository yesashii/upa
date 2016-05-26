<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'-----------------------------------------------------
q_tasi_ncorr= request.QueryString("tasi_ncorr")	
	
'	for each k in request.QueryString
'	response.Write(k&" = "&request.QueryString(k)&"<br>")
'	next
'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"


set negocio = new CNegocio
negocio.Inicializa conectar


set f_agrega = new CFormulario
f_agrega.Carga_Parametros "talleres.xml", "cheques"
f_agrega.Inicializar conectar

peri=request.QueryString("peri")
sede=request.QueryString("sede")
fecha_b=request.QueryString("fecha_b")
blsi_ncorr=request.QueryString("blsi_ncorr")
fecha_hora=request.QueryString("fecha_hora")


'response.Write("<br>fecha_consulta_r='"&fecha_consulta_r&"'<br>")
	p_insert="insert into bloqueo_hora_dia (blsi_ncorr,fecha_hora) values ("&blsi_ncorr&",'"&fecha_hora&"')"		  
	'response.Write("<pre>"&p_delete&"</pre>")
	conectar.ejecutaS (p_insert)
'response.End()

Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
'response.Write("respuesta "&Respuesta)
if Respuesta = true then
session("mensajeerror")= "La fecha fue bloqeada"

else
  session("mensajeerror")= "Error al bloquear"
  
end if
'response.End()
'31%2F08%2F2010

fecha_b2=REPLACE(fecha_b,"/","%2F") 
response.Redirect("bloquea_dia_hora.asp?a%5B0%5D%5Bq_sede_ccod%5D="&sede&"&a%5B0%5D%5Bperi_ccod%5D="&peri&"&a%5B0%5D%5Bfecha_consulta_r%5D="&fecha_b2&"&fecha_consulta_oculta="&fecha_b2&"")

'response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>



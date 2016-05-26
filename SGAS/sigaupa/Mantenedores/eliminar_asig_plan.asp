<!-- #include file="../biblioteca/_conexion.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

set conectar = new cconexion
set var_m	 = new cvariables

set freq = new cformulario
set fasig = new cformulario
set req = new cformulario
n_asig=request.Form("n_asig")

conectar.inicializar "upacifico"



fasig.carga_parametros "crear_malla.xml", "elim_asig"
fasig.inicializar conectar
fasig.procesaform

freq.carga_parametros "crear_malla.xml", "elim_req"
freq.inicializar conectar
freq.procesaform

var_m.procesaform

req.carga_parametros "crear_malla.xml", "tabla"
req.inicializar conectar

if var_m.nrofilas("EM") > 0 then
	for k=0 to n_asig-1
		if var_m.obtenervalor("em",k,"mall_ccod") <> "" then
		        mall_ccod=var_m.obtenervalor("em",k,"mall_ccod")
				es_req="select mall_crequisito from requisitos where mall_ccod='"&mall_ccod&"'" 
				response.Write(es_req)
				req.consultar es_req
				for r=0 to req.nrofilas-1
				  req.siguiente
				  response.Write(r)
				  es_requisito=req.obtenervalor("mall_crequisito")
				  response.Write(es_requisito&"<br>")
				  'estado=conectar.ejecutaS("delete from requisitos where mall_ccod='"&es_requisito&"'")
				  estado=conectar.ejecutaS("delete from requisitos where mall_crequisito='"&es_requisito&"' and mall_ccod='"&mall_ccod&"'")
				   response.Write(estado)
				  'freq.agregaCampoFilaPost r,"mall_crequisito",  es_requisito
				  'freq.agregaCampoFilaPost r,"mall_ccod",mall_ccod
				next
				'freq.ListarPost
				'freq.mantieneTablas  true
				tiene_req="select mall_ccod from requisitos where mall_crequisito='"&mall_ccod&"'" 
				response.Write("<br>")
				response.Write(tiene_req)
				
				req.consultar tiene_req
				for r=1 to req.nrofilas
				  req.siguiente
				  response.Write(r)
				  mall_crequisito=req.obtenervalor("mall_ccod")
				  response.Write(mall_crequisito)
				  estado=conectar.ejecutaS("delete from requisitos where mall_ccod='"&mall_crequisito&"' and mall_crequisito='"&mall_ccod&"'")
				  response.Write(estado)
				  'freq.agregaCampoPost "mall_crequisito", mall_ccod
				  'freq.agregaCampoPost "mall_ccod", mall_crequisito
				  'freq.mantieneTablas  true
				next
				fasig.agregaCampoPost "mall_ccod", mall_ccod
				fasig.mantieneTablas  false
		end if
	next
end if
response.redirect(request.ServerVariables("HTTP_REFERER"))

%>
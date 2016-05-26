<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'-----------------------------------------------------
	'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
	'next
'response.End()

sede_ccod=request.Form("sede_ccod")
jorn_ccod=request.Form("jorn_ccod")
car_ing_ncorr=request.Form("car_ing_ncorr")
ttie_ccod=request.Form("ttie_ccod")
anos_ccod=request.Form("anos_ccod")
'cod_carrera_min="555"

'sede_ccod=2
'jorn_ccod=1
'car_ing_ncorr=2
'ttie_ccod=1


set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


set f_carreras  = new cformulario
f_carreras.carga_parametros "tabla_vacia.xml", "tabla" 
f_carreras.inicializar conectar	

sql="select case when count(*)>0 then 'S' end as existe,ofai_ncorr from  ufe_oferta_academica_ing where sede_ccod="&sede_ccod&   vbCrlf & _
	" and jorn_ccod= "&jorn_ccod&   vbCrlf & _
	" and car_ing_ncorr="&car_ing_ncorr&   vbCrlf & _
	" and ttie_ccod="&ttie_ccod&   vbCrlf & _
	" and anos_ccod="&anos_ccod&   vbCrlf & _
	" group by ofai_ncorr"
			
'response.Write(sql)
'response.End()						
f_carreras.consultar sql	
f_carreras.siguiente
'response.Write(sql)
'response.End()

xml="<?xml version='1.0' encoding='ISO-8859-1'?>"
xml=xml&"<datos>"
xml=xml&"<oferta existe="""&f_carreras.ObtenerValor("existe")&""" ofai_ncorr="""&f_carreras.ObtenerValor("ofai_ncorr")&"""/>"
xml=xml&"</datos>"
response.ContentType = "text/xml"
response.Write(xml)
%>
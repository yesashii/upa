<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'-----------------------------------------------------
	'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
	'next
'response.End()

cod_carrera_min=request.Form("cod_carrera_min")
'cod_carrera_min="555"
set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


set f_carreras  = new cformulario
f_carreras.carga_parametros "tabla_vacia.xml", "tabla" 
f_carreras.inicializar conectar	

sql="select case when count(cod_carrera_min)>0 then 'S' end as existe,car_min_ncorr ,cod_carrera_min,nom_carrera_min from ufe_carreras_mineduc where cod_carrera_min='"&cod_carrera_min&"' group by cod_carrera_min,nom_carrera_min,car_min_ncorr"
						
f_carreras.consultar sql	
f_carreras.siguiente
'response.Write(sql)
'response.End()

xml="<?xml version='1.0' encoding='ISO-8859-1'?>"
xml=xml&"<datos>"
xml=xml&"<carrera existe="""&f_carreras.ObtenerValor("existe")&""" cod_carrera_min="""&f_carreras.ObtenerValor("cod_carrera_min")&""" nom_carrera_min="""&f_carreras.ObtenerValor("nom_carrera_min")&""" car_min_ncorr="""&f_carreras.ObtenerValor("car_min_ncorr")&"""/>"
xml=xml&"</datos>"
response.ContentType = "text/xml"
response.Write(xml)
%>
<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new Cconexion
conexion.Inicializar "upacifico"

rut	= request.Form("rut")

set f_rut = new cFormulario
f_rut.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_rut.inicializar conexion


sql_datos_persona= "select isnull(protic.obtener_nombre_carrera(protic.ultima_oferta_matriculado(pers_ncorr),'CJ'), 'sin carrera') as carrera, "&_
					" protic.obtener_nombre_completo(pers_ncorr,'n') as nombre, pers_xdv as digito "&_
					" from personas "&_
					" where pers_nrut="&rut
						
'RESPONSE.WRITE(sql_datos_persona)
'RESPONSE.END()
	
f_rut.consultar sql_datos_persona
f_rut.Siguiente	
					
v_nombre	=f_rut.obtenerValor("nombre")
v_xdv		=f_rut.obtenerValor("digito")
v_carrera	=f_rut.obtenerValor("carrera")


xml="<?xml version='1.0' encoding='ISO-8859-1'?>"
xml=xml&"<datos>"
xml=xml&"<nombre><![CDATA["&v_nombre&"]]></nombre>"
xml=xml&"<digito><![CDATA["&v_xdv&"]]></digito>"
xml=xml&"<carrera><![CDATA["&v_carrera&"]]></carrera>"
xml=xml&"</datos>"
response.ContentType = "text/xml"
response.Write(xml)
%>
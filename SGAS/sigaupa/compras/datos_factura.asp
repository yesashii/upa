<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new Cconexion
conexion.Inicializar "upacifico"

rut	= request.Form("rut")
valor = request.Form("valor")

set f_rut = new cFormulario
f_rut.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_rut.inicializar conexion

'sql_datos_persona= "select isnull(protic.obtener_nombre_carrera(protic.ultima_oferta_matriculado(pers_ncorr),'CJ'), 'sin carrera') as carrera, "&_
'					" protic.obtener_nombre_completo(pers_ncorr,'n') as nombre, pers_xdv as digito "&_
'					" from personas "&_
'					" where pers_nrut="&rut
					
SQL= " select COUNT(*) as cuenta "&_
					" from ocag_solicitud_giro a "&_
					" INNER JOIN personas b "&_
					" ON a.pers_ncorr_proveedor = b.pers_ncorr "&_
					" INNER JOIN ocag_detalle_solicitud_giro c "&_
					" ON a.sogi_ncorr = c.sogi_ncorr "&_
					" and b.pers_nrut ="&rut&" AND c.dsgi_ndocto ="&valor
						
'RESPONSE.WRITE(SQL)
'RESPONSE.END()
	
f_rut.consultar SQL
f_rut.Siguiente	
					
v_nombre	=f_rut.obtenerValor("cuenta")
'v_xdv		=f_rut.obtenerValor("digito")
'v_carrera	=f_rut.obtenerValor("carrera")

xml="<?xml version='1.0' encoding='ISO-8859-1'?>"
xml=xml&"<datos>"
xml=xml&"<nombre><![CDATA["&v_nombre&"]]></nombre>"
xml=xml&"</datos>"
response.ContentType = "text/xml"
response.Write(xml)
%>
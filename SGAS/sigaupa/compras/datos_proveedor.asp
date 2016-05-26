<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->

<%
set conexion = new Cconexion2
conexion.Inicializar "upacifico"

rut	= request.Form("rut")

set f_rut = new cFormulario
f_rut.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_rut.inicializar conexion

sql_datos_persona= " select CODAUX AS pers_nrut, RIGHT(RUTAUX,1) AS pers_xdv, NOMAUX AS pers_tnombre, NOMAUX AS v_nombre "&_
								" from softland.cwtauxi where cast(CodAux as varchar)='"&rut&"'"
						
'RESPONSE.WRITE(sql_datos_persona)
'RESPONSE.END()

f_rut.consultar sql_datos_persona
f_rut.Siguiente	
					
v_nombre	=f_rut.obtenerValor("v_nombre")

xml="<?xml version='1.0' encoding='ISO-8859-1'?>"
xml=xml&"<datos>"
xml=xml&"<nombre><![CDATA["&v_nombre&"]]></nombre>"
xml=xml&"</datos>"
response.ContentType = "text/xml"
response.Write(xml)
%>
<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
set conexion = new Cconexion
conexion.Inicializar "upacifico"
devi_ccod	= request.Form("devi_ccod")


set f_costos = new cFormulario
f_costos.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_costos.inicializar conexion

sql_costos_viaticos= " select *, tmon_tdesc as moneda from ocag_destino_viatico a, ocag_tipo_moneda b "&_
				   	 " where a.devi_ccod="&devi_ccod&" "&_
					 " and a.tmon_ccod=b.tmon_ccod"
						
f_costos.consultar sql_costos_viaticos
f_costos.Siguiente	
					
devi_mmonto=f_costos.ObtenerValor("devi_mmonto")
moneda=f_costos.obtenerValor("moneda")

xml="<?xml version='1.0' encoding='ISO-8859-1'?>"
xml=xml&"<datos>"
xml=xml&"<devi_mmonto><![CDATA["&devi_mmonto&"]]></devi_mmonto>"
xml=xml&"<moneda><![CDATA["&moneda&"]]></moneda>"
xml=xml&"</datos>"
response.ContentType = "text/xml"
response.Write(xml)
%>
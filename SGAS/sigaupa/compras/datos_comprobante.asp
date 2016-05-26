<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new Cconexion
conexion.Inicializar "upacifico"

valor = request.Form("valor")

set f_valor = new cFormulario
f_valor.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_valor.inicializar conexion

SQL= " select INGR_NFOLIO_REFERENCIA as comprobante, protic.trunc(a.INGR_FPAGO) as fecha,protic.obtener_rut(a.PERS_NCORR) as rut,cast(a.INGR_MTOTAL as numeric) as monto  "&_
			" from ingresos a, abonos b, compromisos c, detalles d "&_
			" where a.INGR_NFOLIO_REFERENCIA="&valor&" "&_
			" and a.ingr_ncorr=b.INGR_NCORR "&_
			" and b.COMP_NDOCTO=c.COMP_NDOCTO "&_
			" and b.INST_CCOD=c.INST_CCOD "&_
			" and b.TCOM_CCOD=c.TCOM_CCOD "&_
			" and c.COMP_NDOCTO=d.COMP_NDOCTO "&_
			" and c.TCOM_CCOD=d.TCOM_CCOD "&_
			" and c.INST_CCOD=d.INST_CCOD "&_
			" and d.tdet_ccod=1219"
						
'RESPONSE.WRITE(SQL)
'RESPONSE.END()
	
f_valor.consultar SQL
f_valor.Siguiente	
					
v_comprobante	=f_valor.obtenerValor("comprobante")
v_fecha		=f_valor.obtenerValor("fecha")
v_rut			=f_valor.obtenerValor("rut")
v_monto		=f_valor.obtenerValor("monto")


xml="<?xml version='1.0' encoding='ISO-8859-1'?>"
xml=xml&"<datos>"
xml=xml&"<comprobante><![CDATA["&v_comprobante&"]]></comprobante>"
xml=xml&"<fecha><![CDATA["&v_fecha&"]]></fecha>"
xml=xml&"<rut><![CDATA["&v_rut&"]]></rut>"
xml=xml&"<monto><![CDATA["&v_monto&"]]></monto>"
xml=xml&"</datos>"
response.ContentType = "text/xml"
response.Write(xml)
%>
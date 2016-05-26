<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "funcion.asp" -->
<%
ciex_ccod=Request.form("ciex")
'ciex_ccod="5"
'tici_ccod="1"
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_ciudad = new CFormulario
f_ciudad.Carga_Parametros "tabla_vacia.xml", "tabla" 
f_ciudad.Inicializar conexion



sql_descuentos="select d.univ_ccod,univ_tdesc"& vbcrlf & _
				"from paises a,"& vbcrlf & _
				"ciudades_extranjeras b,"& vbcrlf & _
				"universidad_ciudad c,"& vbcrlf & _
				"universidades d"& vbcrlf & _
				"where a.pais_ccod=b.pais_ccod"& vbcrlf & _
				"and b.ciex_ccod=c.ciex_ccod"& vbcrlf & _
				"and c.univ_ccod=d.univ_ccod"& vbcrlf & _
				"and c.ciex_ccod="&ciex_ccod&""& vbcrlf & _
				"group by d.univ_ccod,univ_tdesc order by d.univ_ccod "	
	'response.Write(sql_descuentos)	
							
f_ciudad.Consultar sql_descuentos


repta="<option value="&CHR(034)&""&CHR(034)&">Seleccione</option>"
		while f_ciudad.siguiente
			univ_ccod=f_ciudad.ObtenerValor("univ_ccod")
			univ_tdesc=f_ciudad.ObtenerValor("univ_tdesc")
			repta=repta&"<option value="&CHR(034)&""&univ_ccod&""&CHR(034)&">"&ExtraeAcentosCaracteres(univ_tdesc)&"</option>"
		wend
		
		response.Write(repta)
		
%>
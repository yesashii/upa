<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "funcion.asp" -->
<%
pais_ccod=Request.form("pais")
tici_ccod=Request.form("tici")
'pais_ccod="8"
'tici_ccod="1"
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_ciudad = new CFormulario
f_ciudad.Carga_Parametros "tabla_vacia.xml", "tabla" 
f_ciudad.Inicializar conexion


if tici_ccod="1" then

sql_descuentos="select b.ciex_ccod,ciex_tdesc"& vbcrlf & _
				"from paises a,"& vbcrlf & _
				"ciudades_extranjeras b,"& vbcrlf & _
				"universidad_ciudad c,"& vbcrlf & _
				"universidades d"& vbcrlf & _
				"where a.pais_ccod=b.pais_ccod"& vbcrlf & _
				"and b.ciex_ccod=c.ciex_ccod"& vbcrlf & _
				"and c.univ_ccod=d.univ_ccod"& vbcrlf & _
				"and a.pais_ccod="&pais_ccod&""& vbcrlf & _
				"group by b.ciex_ccod,ciex_tdesc order by ciex_tdesc "	
	'response.Write(sql_descuentos)	
elseif tici_ccod="2" then

sql_descuentos="select distinct ciex_ccod,ciex_tdesc from paises a,ciudades_extranjeras b where a.pais_ccod=b.pais_ccod and a.pais_ccod="&pais_ccod&" order by ciex_tdesc"
				
end if				
							
f_ciudad.Consultar sql_descuentos


repta="<option value="&CHR(034)&""&CHR(034)&">Seleccione</option>"
		while f_ciudad.siguiente
			ciex_ccod=f_ciudad.ObtenerValor("ciex_ccod")
			ciex_tdesc=f_ciudad.ObtenerValor("ciex_tdesc")
			repta=repta&"<option value="&CHR(034)&""&ciex_ccod&""&CHR(034)&">"&ExtraeAcentosCaracteres(ciex_tdesc)&"</option>"
		wend
		
		response.Write(repta)
		
%>
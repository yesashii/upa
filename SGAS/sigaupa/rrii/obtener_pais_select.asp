<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "funcion.asp" -->
<%
tici_ccod=Request.form("tici")

'tici_ccod="1"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_pais = new CFormulario
f_pais.Carga_Parametros "tabla_vacia.xml", "tabla" 
f_pais.Inicializar conexion


if tici_ccod="1" then

sql_descuentos="select a.pais_ccod,pais_tdesc"& vbcrlf & _
				"from paises a,"& vbcrlf & _
				"ciudades_extranjeras b,"& vbcrlf & _
				"universidad_ciudad c,"& vbcrlf & _
				"universidades d"& vbcrlf & _
				"where a.pais_ccod=b.pais_ccod"& vbcrlf & _
				"and b.ciex_ccod=c.ciex_ccod"& vbcrlf & _
				"and c.univ_ccod=d.univ_ccod"& vbcrlf & _
				"group by a.pais_ccod,pais_tdesc order by pais_tdesc "	
		
elseif tici_ccod="2" then

sql_descuentos="select distinct a.pais_ccod,pais_tdesc from paises a,ciudades_extranjeras b where a.pais_ccod=b.pais_ccod"
				
end if				
							
f_pais.Consultar sql_descuentos


repta="<option value="&CHR(034)&""&CHR(034)&">Seleccione</option>"
		while f_pais.siguiente
			pais_ccod=f_pais.ObtenerValor("pais_ccod")
			pais_tdesc=f_pais.ObtenerValor("pais_tdesc")
			repta=repta&"<option value="&CHR(034)&""&pais_ccod&""&CHR(034)&">"&ExtraeAcentosCaracteres(pais_tdesc)&"</option>"
		wend
		
		response.Write(repta)
		
%>
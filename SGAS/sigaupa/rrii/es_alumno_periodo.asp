<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
	'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
	'next
'response.End()

peri_ccod=request.form("b[0][peri_ccod]")
pers_nrut=request.form("b[0][pers_nrut]")

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar

set formulario = new CFormulario
formulario.Carga_Parametros "tabla_vacia.xml", "tabla"
formulario.Inicializar conectar



'response.Write("ciex_ccod="&ciex_ccod&"  univ_ccod="&univ_ccod&"  pais_ccod="&pais_ccod&"")
query_exec="select case count(*)when 0 then 'N' else 'S' end existe"& vbCrLf &_
"from personas a,"& vbCrLf &_
"alumnos b,"& vbCrLf &_
"ofertas_academicas c"& vbCrLf &_
"where a.PERS_NCORR=b.PERS_NCORR"& vbCrLf &_
"and b.OFER_NCORR=c.OFER_NCORR"& vbCrLf &_
"and a.PERS_NRUT="&pers_nrut&""& vbCrLf &_
"and c.PERI_CCOD="&peri_ccod&""
'response.Write(query_exec&"<br>")
formulario.Consultar query_exec
formulario.siguiente

'link=conectar.consultaUno(query_exec)
existe=formulario.obtenervalor("existe")



t_json="{"&CHR(034)&"esalumno"&CHR(034)&":"&CHR(034)&""&existe&""&CHR(034)&"}"
response.Write(t_json)
%>
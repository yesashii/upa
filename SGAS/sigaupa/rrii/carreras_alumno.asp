<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "funcion.asp" -->



<%
Response.ContentType = "text/html; charset=utf-8"
'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
	'next
'response.End()

peri_ccod=request.form("b[0][peri_ccod]")
pers_nrut=request.form("b[0][pers_nrut]")
'peri_ccod=226
'pers_nrut=14712631

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar

set formulario = new CFormulario
formulario.Carga_Parametros "tabla_vacia.xml", "tabla"
formulario.Inicializar conectar


'response.Write("ciex_ccod="&ciex_ccod&"  univ_ccod="&univ_ccod&"  pais_ccod="&pais_ccod&"")
query_exec="select e.carr_ccod,carr_tdesc"& vbCrLf &_
"from personas a,"& vbCrLf &_
"alumnos b,"& vbCrLf &_
"ofertas_academicas c,"& vbCrLf &_
"especialidades d,"& vbCrLf &_
"carreras e"& vbCrLf &_
"where a.PERS_NCORR=b.PERS_NCORR"& vbCrLf &_
"and b.OFER_NCORR=c.OFER_NCORR"& vbCrLf &_
"and c.ESPE_CCOD=d.ESPE_CCOD"& vbCrLf &_
"and d.CARR_CCOD=e.CARR_CCOD"& vbCrLf &_
"and a.PERS_NRUT="&pers_nrut&""& vbCrLf &_
"and c.PERI_CCOD="&peri_ccod&""& vbCrLf &_
"group by e.carr_ccod,carr_tdesc"
'response.Write(query_exec&"<br>")
formulario.Consultar query_exec

'link=conectar.consultaUno(query_exec)


opciones=""
while formulario.siguiente
carr_ccod=formulario.obtenervalor("carr_ccod")
carr_tdesc=formulario.obtenervalor("carr_tdesc")
carr_tdesc= ExtraeAcentosCaracteres (carr_tdesc)
opciones=opciones&"<option  value='"&carr_ccod&"'>"&carr_tdesc&"</option>"
wend

response.Write(opciones)
%>

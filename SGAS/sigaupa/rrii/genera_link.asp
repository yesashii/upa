<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
	'for each k in request.querystring
	'response.Write(k&" = "&request.querystring(k)&"<br>")
	'next
'response.End()

peri_ccod=request.form("a[0][peri_ccod]")
ciex_ccod=request.form("a[0][ciex_ccod]")
univ_ccod=request.form("a[0][univ_ccod]")
univ_ccod2=request.form("a[0][univ_ccod2]")
pais_ccod=request.form("a[0][pais_ccod]")
lipe_idioma=request.form("a[0][idio_ccod]")
lipe_ncorr=request.form("a[0][lipe_ncorr]")
lipe_fexpiracion=request.form("a[0][lipe_fexpiracion]")
tici_ccod=Request.form("a[0][tici_ccod]")
dasa_ncorr=Request.form("a[0][tici_ccod]")


'peri_ccod=request.querystring("a[0][peri_ccod]")
'ciex_ccod=request.querystring("a[0][ciex_ccod]")
'univ_ccod=request.querystring("a[0][univ_ccod]")
'univ_ccod2=request.querystring("a[0][univ_ccod2]")
'pais_ccod=request.querystring("a[0][pais_ccod]")
'lipe_idioma=request.querystring("a[0][idio_ccod]")
'lipe_ncorr=request.querystring("a[0][lipe_ncorr]")
'lipe_fexpiracion=request.querystring("a[0][lipe_fexpiracion]")
'tici_ccod=Request.querystring("a[0][tici_ccod]")
'dasa_ncorr=Request.querystring("a[0][tici_ccod]")

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar

set formulario = new CFormulario
formulario.Carga_Parametros "tabla_vacia.xml", "tabla"
formulario.Inicializar conectar

if EsVacio(lipe_ncorr) then
lipe_ncorr="null"
end if

if EsVacio(dasa_ncorr) then
dasa_ncorr="null"
end if

if EsVacio(lipe_fexpiracion) then
lipe_fexpiracion="null"
else
lipe_fexpiracion="'"&lipe_fexpiracion&"'"
end if


'response.Write("ciex_ccod="&ciex_ccod&"  univ_ccod="&univ_ccod&"  pais_ccod="&pais_ccod&"")
if tici_ccod= "1" then
query_exec="exec GeneraLinkPostulacionExtranjero "&lipe_ncorr&","&peri_ccod&","&ciex_ccod&","&univ_ccod&","&pais_ccod&","&lipe_idioma&","&lipe_fexpiracion&","&tici_ccod&""
else
univ_ccod=univ_ccod2
query_exec="exec GeneraLinkPostulacionExtranjeroStudyAbroad "&lipe_ncorr&","&peri_ccod&","&ciex_ccod&",'"&univ_ccod&"',"&pais_ccod&","&lipe_idioma&","&lipe_fexpiracion&","&tici_ccod&","&dasa_ncorr&""
end if

'response.Write(query_exec&"<br>")
formulario.Consultar query_exec
formulario.siguiente

'link=conectar.consultaUno(query_exec)
link=formulario.obtenervalor("resultado")
fecha=formulario.obtenervalor("fecha")



t_json="{"&CHR(034)&"link"&CHR(034)&":"&CHR(034)&""&link&""&CHR(034)&","&CHR(034)&"fecha"&CHR(034)&":"&CHR(034)&""&fecha&""&CHR(034)&"}"
response.Write(t_json)
%>
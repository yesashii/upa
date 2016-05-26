<!-- #include file="../biblioteca/_conexion.asp" -->
<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
matr_ncorr	=	request.Form("matr_ncorr")
registros	=	request.form("registros")

set conectar 	= new cconexion
set formulario 	= new cformulario
set secciones 	= new cvariables

conectar.inicializar "upacifico"

formulario.carga_parametros "eliminar_equivalencias.xml", "e_equivalencias"
formulario.inicializar conectar

secciones.procesaform

dim elisecc()
if secciones.nrofilas("D") > 0 then'
	for i=0 to registros
		redim preserve elisecc(i)
		if secciones.obtenervalor("d",i,"secc_ccod") <> "" then
			elisecc(i)=secciones.obtenervalor("d",i,"secc_ccod")
		end if
	next
end if

formulario.procesaForm
for j=0 to registros-1
	formulario.agregacampopost	"matr_ncorr" ,matr_ncorr
	formulario.agregacampopost	"secc_ccod"	,elisecc(j)
	'formulario.listarpost
	formulario.mantienetablas 	false
next
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set formulario = new CFormulario
formulario.carga_parametros "m_asignaturas_comunes.xml", "asignaturas_comunes"
formulario.inicializar conectar
formulario.procesaForm

for i=0 to formulario.cuentaPost - 1
	mall_ccod = formulario.obtenerValorPost(i,"mall_ccod")
		
	if not EsVacio(mall_ccod) then
		consulta_delete = " delete from  asignaturas_comunes " &_
                          " where cast(mall_ccod as varchar)='"&mall_ccod&"'"
		
		conectar.ejecutaS consulta_delete
		'response.Write(consulta_delete)
		
	end if 
next 

'response.End()
response.redirect(request.ServerVariables("HTTP_REFERER"))

%>
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
formulario.carga_parametros "m_asignaturas_comunes.xml", "asignaturas_plan"
formulario.inicializar conectar
formulario.procesaForm
 
cod_carrera = request.Form("cod_carrera")

for i=0 to formulario.cuentaPost - 1
	mall_ccod = formulario.obtenerValorPost(i,"mall_ccod")
	asig_ccod=formulario.obtenerValorPost(i,"asig_ccod")
	plan_ccod = formulario.obtenerValorPost(i,"plan_ccod")
    usuario = negocio.obtenerUsuario
	
	if not EsVacio(cod_carrera) and not EsVacio(mall_ccod) then
		consulta_insert = " insert into asignaturas_comunes (mall_ccod,carr_ccod,asig_ccod,plan_ccod,audi_tusuario,audi_fmodificacion) " &_
                          " values ("&mall_ccod&",'"&cod_carrera&"','"&asig_ccod&"',"&plan_ccod&",'"&usuario&"',getDate())"
		
		conectar.ejecutaS consulta_insert
		'response.Write(consulta_insert)
		
	end if 
next 

'response.End()
response.redirect(request.ServerVariables("HTTP_REFERER"))

%>
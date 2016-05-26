<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
v_secc_ccod=request.Form("secc_ccod")
cali_ncorr=request.Form("cali_ncorr")
cali_nponderacion=request.Form("m[0][cali_nponderacion]")


set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

formulario.carga_parametros "procesa_evaluacion.xml", "agregar_eval"
formulario.inicializar conectar


	formulario.procesaForm

	if (cali_ncorr<>"") then
		v_cali_ncorr=cali_ncorr
	else	
		v_cali_ncorr=conectar.consultauno("execute obtenerSecuencia 'calificaciones_seccion'")
	end if
    'response.Write("<br>cali_ncorr "&v_cali_ncorr&" secc_ccod "&v_secc_ccod)
	formulario.AgregaCampoPost "cali_ncorr", v_cali_ncorr
	formulario.AgregaCampoPost "secc_ccod", v_secc_ccod

	'formulario.ListarPost

	formulario.mantienetablas false
	
	'response.End()
	url="agregar_evaluacion.asp?secc_ccod="&v_secc_ccod

'response.Redirect(url)
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
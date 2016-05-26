<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
on error resume next
set conectar = new cconexion
conectar.inicializar "upacifico"


set formulario = new cformulario




set negocio = new CNegocio
negocio.Inicializa conectar

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next


v_dcur_tdesc = request.Form("m[0][dcur_tdesc]")
v_dcur_ncorr = request.Form("m[0][dcur_ncorr]")
mensaje=""
if v_dcur_tdesc <> "" and v_dcur_ncorr ="" then
	existe = conectar.consultaUno("select count(*) from diplomados_cursos where dcur_tdesc like '%"&v_dcur_tdesc&"%'")
	if existe > "0" then
		mensaje = "Ya existe un diplomado o curso con un nombre similar al ingresado haga el favor de agregar al nombre la versión correspondiente"
		response.Redirect("editar_diplomados_curso.asp?mensaje="&mensaje)
	end if
end if

	formulario.carga_parametros "m_diplomados_curso.xml", "mantiene_diplomados_curso"
	formulario.inicializar conectar
	formulario.procesaForm
	
	if v_dcur_ncorr = "" then
		dcur_ncorr = conectar.consultaUno("exec obtenerSecuencia 'diplomados_cursos'")
		formulario.agregaCampoPost "dcur_ncorr",dcur_ncorr
	else
		dcur_ncorr = v_dcur_ncorr
	end if
	formulario.mantienetablas false
		
	if conectar.obtenerEstadoTransaccion then 
		conectar.MensajeError "Módulo guardado exitosamente"
	end if

%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
	CerrarActualizar();
</script>
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Título de la página"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set t_convalidaciones = new CFormulario
t_convalidaciones.Carga_Parametros "acta_convalidacion_editar.xml", "convalidaciones"
t_convalidaciones.Inicializar conexion
t_convalidaciones.ProcesaForm



for i_ = 0 to t_convalidaciones.CuentaPost - 1

	consulta = "select b.tres_ccod from actas_convalidacion a, resoluciones b where a.reso_ncorr = b.reso_ncorr and cast(a.acon_ncorr as varchar)= '" & t_convalidaciones.ObtenerValorPost(i_, "acon_ncorr") & "'"		
	v_tres_ccod = CInt(conexion.ConsultaUno(consulta))	
		
	if (v_tres_ccod = 7) and IsNumeric(t_convalidaciones.ObtenerValorPost(i_, "conv_nnota")) then
		if (CSng(t_convalidaciones.ObtenerValorPost(i_, "conv_nnota")) < 4) then
			t_convalidaciones.AgregaCampoFilaPost i_, "sitf_ccod", "RC"
		else
			t_convalidaciones.AgregaCampoFilaPost i_, "sitf_ccod", "AC"
		end if
	end if
	
	if (v_tres_ccod = "3") and not esVacio(request.Form("reprobada")) then
		t_convalidaciones.AgregaCampoFilaPost i_, "sitf_ccod", "RC"
	elseif (v_tres_ccod = "3") and esVacio(request.Form("reprobada")) then
		t_convalidaciones.AgregaCampoFilaPost i_, "sitf_ccod", "A"
	end if
	if (v_tres_ccod = "6") and not esVacio(request.Form("reprobada")) then
		t_convalidaciones.AgregaCampoFilaPost i_, "sitf_ccod", "RS"
	elseif (v_tres_ccod = "6") and esVacio(request.Form("reprobada")) then
		t_convalidaciones.AgregaCampoFilaPost i_, "sitf_ccod", "S"	
	end if
			profesor = request.Form("profesor")
			t_convalidaciones.AgregaCampoFilaPost i_, "conv_tdocente", profesor	

	
	t_convalidaciones.AgregaCampoFilaPost i_, "conv_nnota", Replace(t_convalidaciones.ObtenerValorPost(i_, "conv_nnota"), ",", ".")	
next


t_convalidaciones.MantieneTablas false
'conexion.estadotransaccion false  'roolback  


'-------------------------------------------------------------------------------------------------------------------
%>

<script language="JavaScript">
opener.location.reload();
close();
</script>

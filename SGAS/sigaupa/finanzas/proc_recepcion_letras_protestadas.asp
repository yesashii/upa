<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'conexion.EstadoTransaccion false


'---------------------------------------------------------------------------------------------------------------
set f_letras = new CFormulario
f_letras.Carga_Parametros "recepcion_letras_protestadas.xml", "letras"
f_letras.Inicializar conexion
f_letras.ProcesaForm

set f_cargos_protesto = new CFormulario
f_cargos_protesto.Carga_Parametros "recepcion_letras_protestadas.xml", "cargo_protesto"
f_cargos_protesto.Inicializar conexion
f_cargos_protesto.ProcesaForm

'---------------------------------------------------------------------------------------------------------------
f_letras.AgregaCampoPost "edin_ccod", "49"
' agrega sede fija Las condes por defecto (se puede agregar dependiendo de la sede en la sesion)
f_letras.AgregaCampoPost "sede_actual", "8"
f_letras.MantieneTablas false


for i_ = 0 to f_cargos_protesto.CuentaPost - 1
	v_ding_ndocto = f_cargos_protesto.ObtenerValorPost(i_, "ding_ndocto")
'	v_monto_protesto = f_cargos_protesto.ObtenerValorPost(i_, "reca_mmonto")
	
	if not EsVacio(v_ding_ndocto) and v_monto_protesto <> 0  then
		'v_reca_ncorr = conexion.ConsultaUno("select multas_intereses_seq.nextval from dual")
		v_reca_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'referencias_cargos'")
		
		f_cargos_protesto.AgregaCampoFilaPost i_, "tcom_ccod", "5"
		f_cargos_protesto.AgregaCampoFilaPost i_, "inst_ccod", "1"
		f_cargos_protesto.AgregaCampoFilaPost i_, "comp_ndocto", v_reca_ncorr
		f_cargos_protesto.AgregaCampoFilaPost i_, "reca_ncorr", v_reca_ncorr
		f_cargos_protesto.AgregaCampoFilaPost i_, "ecom_ccod", "1"
		f_cargos_protesto.AgregaCampoFilaPost i_, "comp_fdocto", negocio.ObtenerFechaActual
		f_cargos_protesto.AgregaCampoFilaPost i_, "comp_ncuotas", "1"
		f_cargos_protesto.AgregaCampoFilaPost i_, "comp_mneto", v_monto_protesto
		f_cargos_protesto.AgregaCampoFilaPost i_, "comp_mdocumento", v_monto_protesto
		f_cargos_protesto.AgregaCampoFilaPost i_, "sede_ccod", negocio.ObtenerSede
		
		f_cargos_protesto.AgregaCampoFilaPost i_, "tdet_ccod", "13"
		f_cargos_protesto.AgregaCampoFilaPost i_, "deta_ncantidad", "1"
		f_cargos_protesto.AgregaCampoFilaPost i_, "deta_mvalor_unitario", v_monto_protesto
		f_cargos_protesto.AgregaCampoFilaPost i_, "deta_mvalor_detalle", v_monto_protesto
		f_cargos_protesto.AgregaCampoFilaPost i_, "deta_msubtotal", v_monto_protesto
		
		f_cargos_protesto.AgregaCampoFilaPost i_, "dcom_ncompromiso", "1"
		f_cargos_protesto.AgregaCampoFilaPost i_, "dcom_fcompromiso", negocio.ObtenerFechaActual
		f_cargos_protesto.AgregaCampoFilaPost i_, "dcom_mneto", v_monto_protesto
		f_cargos_protesto.AgregaCampoFilaPost i_, "dcom_mcompromiso", v_monto_protesto
		f_cargos_protesto.AgregaCampoFilaPost i_, "peri_ccod", negocio.ObtenerPeriodoAcademico("CLASES18")
		
	else
		f_cargos_protesto.EliminaFilaPost i_
	end if
next


f_cargos_protesto.MantieneTablas false

'------------------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>


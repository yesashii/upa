<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

'conexion.EstadoTransaccion false

set negocio = new CNegocio
negocio.Inicializa conexion

set f_cargo = new CFormulario
f_cargo.Carga_Parametros "agregar_cargo_cc.xml", "cargo"
f_cargo.Inicializar conexion
f_cargo.ProcesaForm
 
set f_cargo_caja = new CFormulario
f_cargo_caja.Carga_Parametros "agregar_cargo_cc.xml", "cargo"
f_cargo_caja.Inicializar conexion
f_cargo_caja.ProcesaForm
'************************** agregado el 13/10/2004 por error de fechas y error al grabar 
'**************************  problemas entre el día y el mes
fechita=conexion.consultaUno("Select convert(varchar,getDate(),103)")
'**********************************************************************************
f_cargo.AgregaCampoPost "ecom_ccod", "1"
f_cargo.AgregaCampoPost "comp_fdocto",fechita' negocio.ObtenerFechaActual
f_cargo.AgregaCampoPost "comp_ncuotas", "1"
f_cargo.AgregaCampoPost "comp_mdescuento", "0"
f_cargo.AgregaCampoPost "comp_mintereses", "0"
f_cargo.ClonaColumnaPost "deta_msubtotal", "comp_mneto"
f_cargo.ClonaColumnaPost "deta_msubtotal", "comp_mdocumento"
f_cargo.AgregaCampoPost "sede_ccod", negocio.ObtenerSede

f_cargo.AgregaCampoPost "dcom_ncompromiso", "1"
f_cargo.AgregaCampoPost "dcom_fcompromiso", fechita'negocio.ObtenerFechaActual
f_cargo.ClonaColumnaPost "deta_msubtotal", "dcom_mneto"
f_cargo.AgregaCampoPost "dcom_mintereses", "0"
f_cargo.ClonaColumnaPost "deta_msubtotal", "dcom_mcompromiso"
f_cargo.AgregaCampoPost "peri_ccod", negocio.ObtenerPeriodoAcademico("CLASES18")

f_cargo.ClonaColumnaPost "deta_mvalor_unitario", "deta_mvalor_detalle"


for i_ = 0 to f_cargo.CuentaPost - 1
	v_tdet_ccod = f_cargo.ObtenerValorPost(i_, "tdet_ccod")
	
	if not EsVacio(v_tdet_ccod) then
	'response.Write("aca 1")
		v_tcom_ccod = conexion.ConsultaUno("select tcom_ccod from tipos_detalle where tdet_ccod = '" & v_tdet_ccod & "'")		
		f_cargo.AgregaCampoFilaPost i_, "tcom_ccod", CInt(v_tcom_ccod)		
	else
	'response.Write("aca 2")
		f_cargo.EliminaFilaPost i_
	end if
next

f_cargo.MantieneTablas false
'conexion.EstadoTransaccion false
'response.End()
if conexion.ObtenerEstadoTransaccion=true then
	session("MensajeError")="El o los compromisos fueron creados correctamente"
else
	session("MensajeError")="Error!! No fue posible realizar la operación, vuelva a intentarlo. "
end if
%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
	CerrarActualizar();
</script>


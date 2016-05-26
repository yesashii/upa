<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%


set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set f_ingresos = new CFormulario
f_ingresos.Carga_Parametros "notas_credito.xml", "ingresos"
f_ingresos.Inicializar conexion
f_ingresos.ProcesaForm


'sql = "select a.ingr_ncorr as ingr_ncorr_documento, a.pers_ncorr, f.tcom_ccod, f.inst_ccod, f.comp_ndocto, f.dcom_ncompromiso, f.abon_mabono " & vbCrLf &_
'      "from ingresos a, detalle_ingresos b, movimientos_cajas c, estados_detalle_ingresos d, tipos_ingresos e, abonos f  " & vbCrLf &_
'	  "where a.ingr_ncorr = b.ingr_ncorr (+)  " & vbCrLf &_
'	  "  and a.mcaj_ncorr = c.mcaj_ncorr  " & vbCrLf &_
'	  "  and b.edin_ccod = d.edin_ccod (+)  " & vbCrLf &_
'	  "  and b.ting_ccod = e.ting_ccod (+)  " & vbCrLf &_
'	  "  and a.ingr_ncorr = f.ingr_ncorr " & vbCrLf &_
'	  "  and (a.eing_ccod = 1 or (a.eing_ccod = 4 and b.ting_ccod is not null and isnull(b.ding_bpacta_cuota, 'N') = 'N') ) " & vbCrLf &_
'	  "  and isnull(b.edin_ccod, 0) <> 9 " & vbCrLf &_
'	  "  and ("

sql ="select a.ingr_ncorr as ingr_ncorr_documento, a.pers_ncorr, f.tcom_ccod, f.inst_ccod, f.comp_ndocto, f.dcom_ncompromiso, f.abon_mabono " & vbCrLf &_
" From ingresos a " & vbCrLf &_
" left outer join detalle_ingresos b " & vbCrLf &_
"     on a.ingr_ncorr = b.ingr_ncorr " & vbCrLf &_
" join movimientos_cajas c " & vbCrLf &_
"     on a.mcaj_ncorr = c.mcaj_ncorr " & vbCrLf &_
" left outer join estados_detalle_ingresos d " & vbCrLf &_
"     on b.edin_ccod = d.edin_ccod " & vbCrLf &_
" left outer join tipos_ingresos e " & vbCrLf &_
"     on b.ting_ccod = e.ting_ccod   " & vbCrLf &_
" join abonos f " & vbCrLf &_
"     on a.ingr_ncorr = f.ingr_ncorr " & vbCrLf &_
	  "  where (a.eing_ccod = 1 or (a.eing_ccod = 4 and b.ting_ccod is not null and isnull(b.ding_bpacta_cuota, 'N') = 'N') ) " & vbCrLf &_
	  "  and isnull(b.edin_ccod, 0) <> 9 " & vbCrLf &_
	  "  and ("


for i_ = 0 to f_ingresos.CuentaPost - 1
	v_ingr_nfolio_referencia = f_ingresos.ObtenerValorPost(i_, "ingr_nfolio_referencia")
	
	if not EsVacio(v_ingr_nfolio_referencia) then
		sql = sql & "(a.ting_ccod = '" & f_ingresos.ObtenerValorPost(i_, "ting_ccod") & "' and a.ingr_nfolio_referencia = '" & f_ingresos.ObtenerValorPost(i_, "ingr_nfolio_referencia") & "' and a.pers_ncorr = '" & f_ingresos.ObtenerValorPost(i_, "pers_ncorr") & "') or "
	end if
	
next

sql = Left(sql, InStrRev(sql, "or") - 1) & ")"

'response.Write("<pre>"&sql&"</pre>")
'--------------------------------------------------------------------------------------------------------------
'--------------------------------------------------------------------------------------------------------------
set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede

set variables = new CVariables
variables.ProcesaForm

'conexion.EstadoTransaccion false

v_mcaj_ncorr = cajero.ObtenerCajaAbierta
v_ting_ccod = variables.ObtenerValor("TIPO_NOTA", 0, "ting_ccod")
'v_ingr_nfolio_referencia = conexion.ConsultaUno("select ingr_nfolio_referencia_seq.nextval from dual")
v_ingr_nfolio_referencia = conexion.ConsultaUno("execute obtenersecuencia 'ingresos_referencia'")

set f_consulta = new CFormulario
f_consulta.Carga_Parametros "consulta.xml", "consulta"
f_consulta.Inicializar conexion
f_consulta.Consultar sql

set f_notas_credito = new CFormulario
f_notas_credito.Carga_Parametros "notas_credito.xml", "notas_credito"
f_notas_credito.Inicializar conexion
f_notas_credito.ProcesaForm

v_fecha_actual = conexion.consultaUno("select protic.trunc(getdate()) as fecha")
'v_fecha_actual = conexion.consultaUno("select getdate() as fecha")
'f_notas_credito.CreaFilaPost
'f_notas_credito.ListarPost

i_ = 0
while f_consulta.Siguiente
	if i_ > 0 then
		f_notas_credito.ClonaFilaPost 0
	end if
	
	'v_ingr_ncorr = conexion.ConsultaUno("select ingr_ncorr_seq.nextval from dual")
	v_ingr_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'ingresos'")
	
	f_notas_credito.AgregaCampoFilaPost i_, "ingr_ncorr", v_ingr_ncorr
	f_notas_credito.AgregaCampoFilaPost i_, "ingr_ncorr_notacredito", v_ingr_ncorr
	f_notas_credito.AgregaCampoFilaPost i_, "ingr_ncorr_documento", CLng(f_consulta.ObtenerValor("ingr_ncorr_documento"))
	f_notas_credito.AgregaCampoFilaPost i_, "tcom_ccod", CInt(f_consulta.ObtenerValor("tcom_ccod"))
	f_notas_credito.AgregaCampoFilaPost i_, "inst_ccod", CInt(f_consulta.ObtenerValor("inst_ccod"))
	f_notas_credito.AgregaCampoFilaPost i_, "comp_ndocto", CLng(f_consulta.ObtenerValor("comp_ndocto"))
	f_notas_credito.AgregaCampoFilaPost i_, "dcom_ncompromiso", CLng(f_consulta.ObtenerValor("dcom_ncompromiso"))
	f_notas_credito.AgregaCampoFilaPost i_, "eing_ccod", "1"
	
	f_notas_credito.AgregaCampoFilaPost i_, "ingr_mdocto", CLng(f_consulta.ObtenerValor("abon_mabono"))
	f_notas_credito.AgregaCampoFilaPost i_, "ingr_mtotal", CLng(f_consulta.ObtenerValor("abon_mabono"))
	f_notas_credito.AgregaCampoFilaPost i_, "abon_mabono", CLng(f_consulta.ObtenerValor("abon_mabono"))
	
	f_notas_credito.AgregaCampoFilaPost i_, "ingr_fpago", v_fecha_actual
	f_notas_credito.AgregaCampoFilaPost i_, "pers_ncorr", CStr(f_consulta.ObtenerValor("pers_ncorr"))
	f_notas_credito.AgregaCampoFilaPost i_, "abon_fabono", v_fecha_actual
	f_notas_credito.AgregaCampoFilaPost i_, "peri_ccod", negocio.ObtenerPeriodoAcademico("CLASES18")
	
	i_ = i_ + 1
wend


f_notas_credito.AgregaCampoPost "ting_ccod", v_ting_ccod
f_notas_credito.AgregaCampoPost "ingr_nfolio_referencia", v_ingr_nfolio_referencia
f_notas_credito.AgregaCampoPost "mcaj_ncorr", v_mcaj_ncorr

'f_notas_credito.AgregaCampoPost "tcom_ccod", "9"
'response.Write("<br>"&conexion.obtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'f_notas_credito.ListarPost
f_notas_credito.MantieneTablas false

'response.Write("<br>"&conexion.obtenerEstadoTransaccion)




'conexion.EstadoTransaccion false
'response.End()
'------------------------------------------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
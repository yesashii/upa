<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%

'for each k in request.Form
'	response.Write(k&"->"&request.Form(k)&"<br>")
'next
'response.End()

set conexion = new CConexion
conexion.Inicializar "desauas"

set f_requisito = new CFormulario
f_requisito.Carga_Parametros "requisitos_titulacion.xml", "edicion_requisitos"
f_requisito.Inicializar conexion
f_requisito.ProcesaForm


'------------------------------------------------------------------------------------------------------------

v_treq_ccod = f_requisito.ObtenerValorPost(0, "treq_ccod")
v_egre_ncorr = f_requisito.ObtenerValorPost(0, "egre_ncorr")

consulta = "select b.repl_ncorr " & vbCrLf &_
           "from egresados a, requisitos_plan b " & vbCrLf &_
		   "where a.plan_ccod = b.plan_ccod " & vbCrLf &_
		   "  and a.sede_ccod = b.sede_ccod " & vbCrLf &_
		   "  and a.peri_ccod = b.peri_ccod " & vbCrLf &_
		   "  and a.egre_ncorr = '" & v_egre_ncorr & "' " & vbCrLf &_
		   "  and b.treq_ccod = '" & v_treq_ccod & "'"

v_repl_ncorr = conexion.ConsultaUno(consulta)

f_requisito.AgregaCampoPost "repl_ncorr", v_repl_ncorr

'------------------------------------------------------------------------------------------------------------

v_reti_ncorr = f_requisito.ObtenerValorPost(0, "reti_ncorr")

if v_reti_ncorr = "" or IsNull(v_reti_ncorr) or IsEmpty(v_reti_ncorr) then
	v_reti_ncorr = conexion.ConsultaUno("select reti_ncorr_seq.nextval from dual")
	f_requisito.AgregaCampoPost "reti_ncorr", v_reti_ncorr
end if


'------------------------------------------------------------------------------------------------------------

f_requisito.MantieneTablas false
%>
<script language="JavaScript">
opener.location.reload();
close();
</script>
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.Form
'	response.Write(k&"->"&request.Form(k)&"<br>")
'next

set conexion = new CConexion
conexion.Inicializar "desauas"


set f_requisito = new CFormulario
f_requisito.Carga_Parametros "requisitos_titulacion.xml", "edicion_requisitos"
f_requisito.Inicializar conexion
f_requisito.ProcesaForm

v_reti_ncorr = f_requisito.ObtenerValorPost(0, "reti_ncorr")

if v_reti_ncorr = "" or IsNull(v_reti_ncorr) or IsEmpty(v_reti_ncorr) then
	v_reti_ncorr = conexion.ConsultaUno("select reti_ncorr_seq.nextval from dual")
	f_requisito.AgregaCampoPost "reti_ncorr", v_reti_ncorr
end if

f_requisito.MantieneTablas false
'conexion.estadotransaccion false
%>

<script language="JavaScript">
opener.location.reload();
close();
</script>
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
set conexion = new CConexion
conexion.Inicializar "upacifico"
v_treq_ccod=request.Form("tr[0][treq_ccod]")
if esVacio(v_treq_ccod) then
	v_treq_ccod=conexion.consultaUno("execute obtenerSecuencia 'tipos_requisitos_titulo'")
end if
set f_tipo = new CFormulario
f_tipo.Carga_Parametros "adm_tipos_requisitos.xml", "tipo_requisito"
f_tipo.Inicializar conexion
f_tipo.ProcesaForm
f_tipo.agregaCampoPost "treq_ccod",v_treq_ccod


f_tipo.MantieneTablas false
%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>
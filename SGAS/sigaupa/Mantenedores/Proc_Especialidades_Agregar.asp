<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_especialidades = new CFormulario
f_especialidades.Carga_Parametros "Especialidades.xml", "f_nueva"
f_especialidades.Inicializar conexion
f_especialidades.ProcesaForm
'f_especialidades.ListarPost

espe_ccod = request.querystring("espe_ccod")
f_especialidades.AgregaCampoPost "espe_ccod", espe_ccod
'f_especialidades.AgregaCampoPost "eesp_ccod", 1
examen = f_especialidades.ObtenerValorPost (0, "espe_bexamen_adm")

if espe_ccod = "" then
   espe_ccod = conexion.consultauno("execute obtenersecuencia 'especialidades'")
   f_especialidades.AgregaCampoPost "espe_ccod", espe_ccod
end if

if examen = "1" then
   f_especialidades.AgregaCampoPost "espe_bexamen_adm", "S"
else
   f_especialidades.AgregaCampoPost "espe_bexamen_adm", ""
end if

f_especialidades.MantieneTablas false
'conexion.estadotransaccion false  'roolback 
%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
 CerrarActualizar();
</script>
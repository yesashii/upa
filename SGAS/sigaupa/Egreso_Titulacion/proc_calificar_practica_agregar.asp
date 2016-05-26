<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'for each k in request.Form()
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_especialidades = new CFormulario
f_especialidades.Carga_Parametros "calificar_practica.xml", "f_nueva"
f_especialidades.Inicializar conexion
f_especialidades.ProcesaForm
'f_especialidades.ListarPost

no_esta_en_concentracion = conexion.consultaUno("Select cpla_pertenece_certificado from configuracion_planes where cast(mall_ccod as varchar)='"&request.Form("p[0][mall_ccod]")&"'")

if no_esta_en_concentracion <> "" and no_esta_en_concentracion <> "0" then
	f_especialidades.agregaCampoPost "carg_noculto",1
end if

no_afecta_promedio = conexion.consultaUno("Select cpla_con_nota from configuracion_planes where cast(mall_ccod as varchar)='"&request.Form("p[0][mall_ccod]")&"'")

if no_afecta_promedio <> "" then
	f_especialidades.agregaCampoPost "carg_afecta_promedio","N"
end if

f_especialidades.MantieneTablas false
'conexion.estadotransaccion false  'roolback 
'response.End()
%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
 CerrarActualizar();
</script>
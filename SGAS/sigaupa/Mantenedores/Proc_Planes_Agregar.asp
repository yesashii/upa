<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_planes = new CFormulario
f_planes.Carga_Parametros "Planes.xml", "f_nuevo"
f_planes.Inicializar conexion
f_planes.ProcesaForm
'f_planes.ListarPost

espe_ccod = request.querystring("espe_ccod")
plan_ccod = request.querystring("plan_ccod")

 f_planes.AgregaCampoPost "espe_ccod", espe_ccod
 'f_planes.AgregaCampoPost "epes_ccod", 1

mencion=request.Form("_planes[0][incluir_mencion]")
if mencion="1" then
	f_planes.AgregaCampoPost "incluir_mencion", "1"
else
	f_planes.AgregaCampoPost "incluir_mencion", "0"
end if

if plan_ccod = "" then
   plan_ccod = conexion.consultauno("exec ObtenerSecuencia 'planes_estudio'")
   f_planes.AgregaCampoPost "plan_ccod", plan_ccod
   cantidad_planes = conexion.consultauno("select isnull(max(plan_ncorrelativo),0) from planes_estudio where espe_ccod='" & espe_ccod & "'")
   'response.Write("select nvl(max(plan_ncorrelativo),0) from planes_estudio where espe_ccod='" & espe_ccod & "'")
   'response.End()
   if cantidad_planes = "" then
     cantidad_planes = 0
	end if
   cantidad_planes = cint(cantidad_planes) + 1    
   f_planes.AgregaCampoPost "plan_ncorrelativo", cantidad_planes   
else
   f_planes.AgregaCampoPost "plan_ccod", plan_ccod
end if


f_planes.MantieneTablas false
'conexion.estadotransaccion false  'roolback 
'response.End()
%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>
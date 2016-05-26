<!-- #include file = "../biblioteca/_conexion.asp" -->

<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_incidentes = new CFormulario
f_incidentes.Carga_Parametros "mantenedor_incidentes.xml", "f_nuevo"
f_incidentes.Inicializar conexion
f_incidentes.ProcesaForm
'f_planes.ListarPost

'ciud_ccod = request.querystring("ciud_ccod")
'cole_ccod = request.querystring("cole_ccod")

' f_planes.AgregaCampoPost "ciud_ccod", ciud_ccod

'if cole_ccod = "" then
'   cole_ccod = conexion.consultauno("exec ObtenerSecuencia 'COLE_CCOD'")
'   f_planes.AgregaCampoPost "cole_ccod", cole_ccod
'   cantidad_planes = conexion.consultauno("select isnull(max(plan_ncorrelativo),0) from planes_estudio where espe_ccod='" & espe_ccod & "'")
   'response.Write("select nvl(max(plan_ncorrelativo),0) from planes_estudio where espe_ccod='" & espe_ccod & "'")
   'response.End()
'   if cantidad_planes = "" then
'     cantidad_planes = 0
'	end if
'   cantidad_planes = cint(cantidad_planes) + 1    
'   f_planes.AgregaCampoPost "plan_ncorrelativo", cantidad_planes   
'else
'   f_planes.AgregaCampoPost "cole_ccod", cole_ccod
'end if


f_incidentes.MantieneTablas false
'conexion.estadotransaccion false
'response.end
'  'roolback 
%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>
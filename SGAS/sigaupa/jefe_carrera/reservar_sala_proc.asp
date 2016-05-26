<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->
<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio	= new cnegocio		
negocio.inicializa conexion

sala_ccod = request.form("sala_ccod")
dias_ccod = request.form("dias_ccod")
hora_ccod = request.form("hora_ccod")
responsable = request.form("responsable")
fecha1 = request.form("fecha")
motivo = request.form("motivo")
num_nalumnos = request.form("num_nalumnos")
periodo = negocio.obtenerPeriodoAcademico("PLANIFICACION")
c_topon = "select protic.detalle_sala_con_carrera("&sala_ccod&","&dias_ccod&","&hora_ccod&",'"&fecha&"','"&fecha&"',"&periodo&") as topon"
topon = conexion.consultaUno(c_topon)

if topon = "" then
	rsla_ncorr = conexion.consultaUno("execute obtenerSecuencia 'RESERVA_HORAS_LABORATORIOS'")											
	c_insert = " insert into RESERVA_HORAS_LABORATORIOS (RHLA_NCORR,HORA_CCOD,DIAS_CCOD,SALA_CCOD,FECHA_RESERVA,MOTIVO,RESPONSABLE,NUM_NALUMNOS,AUDI_TUSUARIO, AUDI_FMODIFICACION)"&_
			   " values ("&rsla_ncorr&","&hora_ccod&","&dias_ccod&","&sala_ccod&",convert(datetime,'"&fecha1&"',103),'"&motivo&"','"&responsable&"',"&num_nalumnos&",'"&negocio.obtenerUsuario&"',getDate())"
	
	conexion.ejecutaS c_insert
	'response.Write(c_insert)
end if
'response.End()
'response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
 CerrarActualizar();
</script>

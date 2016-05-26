<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'for each k in request.form
'response.Write(k&" = "&request.Form(k)&"<br>")
'next'


set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

pare_ccod=request.form("b[0][pare_ccod]")

				
				
				if pare_ccod=""then
					pare_ccod= conexion.ConsultaUno("execute obtenersecuencia 'ocag_perfiles_areas'")
				end if
				
				set f_maquina = new CFormulario
				f_maquina.Carga_Parametros "areas_gastos.xml", "perfiles_areas_i"
				f_maquina.Inicializar conexion
				f_maquina.ProcesaForm
				f_maquina.agregacampopost "pare_ccod" , pare_ccod
		
				f_maquina.MantieneTablas false

'response.Write("<br><b>"&conexion.obtenerEstadoTransaccion&"</b>")
'conexion.estadotransaccion false
'response.End()
'Response.Redirect("agregar_centro_costos_compras.asp")'


%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>
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

tgas_ccod=request.form("b[0][tgas_ccod]")

				
				
				if tgas_ccod=""then
					tgas_ccod= conexion.ConsultaUno("execute obtenersecuencia 'ocag_tipos_gastos'")
				 end if
				set f_maquina = new CFormulario
				f_maquina.Carga_Parametros "areas_gastos.xml", "tipos_gastos_i"
				f_maquina.Inicializar conexion
				f_maquina.ProcesaForm
				f_maquina.agregacampopost "tgas_ccod" , tgas_ccod
		
				f_maquina.MantieneTablas false

'response.End()'
'Response.Redirect("agregar_centro_costos_compras.asp")'


%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>
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

ccos_tcodigo=request.form("b[0][ccos_tcodigo]")
rusu_ccod=request.form("b[0][rusu_ccod]")

				
				
				if rusu_ccod=""then
				rusu_ccod= conexion.ConsultaUno("execute obtenersecuencia 'ocag_roles_usuarios'")
				 'response.write(maqu_ncorr&"<hr>")'
				 end if
				set f_maquina = new CFormulario
				f_maquina.Carga_Parametros "roles_compra.xml", "rol"
				f_maquina.Inicializar conexion
				f_maquina.ProcesaForm
				f_maquina.agregacampopost "rusu_ccod" , rusu_ccod
		
				f_maquina.MantieneTablas false


'response.End()'
'Response.Redirect("agregar_centro_costos_compras.asp")'


%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>
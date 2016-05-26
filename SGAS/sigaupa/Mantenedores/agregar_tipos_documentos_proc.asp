<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.form'
'response.Write(k&" = "&request.Form(k)&"<br>")'
'next



set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

tdoc_ccod=request.form("b[0][tdoc_ccod]")

				
				
				if tdoc_ccod="" or EsVacio(tdoc_ccod) then
					tdoc_ccod= conexion.ConsultaUno("execute obtenersecuencia 'ocag_tipo_documento'")
					 'response.write(maqu_ncorr&"<hr>")'
				end if
				set f_maquina = new CFormulario
				f_maquina.Carga_Parametros "areas_gastos.xml", "i_tipos_documentos"
				f_maquina.Inicializar conexion
				f_maquina.ProcesaForm
				f_maquina.agregacampopost "tdoc_ccod" , tdoc_ccod
		
				f_maquina.MantieneTablas false

'response.Write("<br/><b> 2: "&conexion.obtenerEstadoTransaccion&"</b>")
'conexion.estadotransaccion false
'response.End()

%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>
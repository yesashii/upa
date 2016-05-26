<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		: Mantenedor de Cursos Diplomado
'FECHA CREACIÓN		: 12/11/2013
'CREADO POR 		: Michael Shaw Rojas
'ENTRADA		:NA
'SALIDA			:NA
'MODULO OTEC
'*******************************************************************

'for each k in request.form
'response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

mdcu_ncorr=request.form("b[0][mdcu_ncorr]")
dcur_ncorr2=request.form("b[0][dcur_ncorr]")

mdcu_estado = request.form("datos[0][mdcu_estado]") 
dcur_ncorr=request.form("datos[0][dcur_ncorr]")

				if mdcu_ncorr=""then

					mdcu_ncorr= conexion.ConsultaUno("execute obtenersecuencia 'mantenedor_diplomados_cursos'")
				 end if
				 
				set f_maquina = new CFormulario
				f_maquina.Carga_Parametros "mantenedor_diplomado_cursos.xml", "agrega_cursos"
				f_maquina.Inicializar conexion
				f_maquina.ProcesaForm
				
				f_maquina.agregacampopost "mdcu_ncorr" , mdcu_ncorr
				if dcur_ncorr2 <> ""then
				f_maquina.agregacampopost "dcur_ncorr" , dcur_ncorr2
				end if
				f_maquina.agregacampopost "mdcu_estado" , mdcu_estado
				
				f_maquina.MantieneTablas false
				'conexion.estadotransaccion false

'response.End()
%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>
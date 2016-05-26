<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		: Mantenedor de Cursos Diplomado
'FECHA CREACIÓN		: 12/12/2013
'CREADO POR 		: Michael Shaw Rojas
'ENTRADA		:NA
'SALIDA			:NA
'MODULO OTEC
'*******************************************************************

for each k in request.form
response.Write(k&" = "&request.Form(k)&"<br>")
next
'response.End()
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

ting_ccod = request.form("datos[0][ting_ccod]") 

				if ting_ccod=""then

					ting_ccod= conexion.ConsultaUno("execute obtenersecuencia 'tipo_ingreso'")
				 end if
				 
				set f_maquina = new CFormulario
				f_maquina.Carga_Parametros "agrega_tipo_ingreso.xml", "agrega_cursos"
				f_maquina.Inicializar conexion
				f_maquina.ProcesaForm
				
				f_maquina.agregacampopost "ting_ccod" , ting_ccod
				
				f_maquina.MantieneTablas false
				'conexion.estadotransaccion false

'response.End()
%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>
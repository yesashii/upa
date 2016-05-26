<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "desauas"

conexion.EstadoTransaccion false

set negocio = new CNegocio
negocio.Inicializa conexion

set f_cargo = new CFormulario
f_cargo.Carga_Parametros "agregar_cargo_pactacion.xml", "cargo"
f_cargo.Inicializar conexion
f_cargo.ProcesaForm

'------------------------------------------------------------------------------------------------------------------------------

f_cargo.ListarPost
f_cargo.MantieneTablas true


%>

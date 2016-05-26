<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "desauas"														

set f_homologacion = new CFormulario
f_homologacion.Carga_Parametros "editar_malla.xml", "f_agregar_homologacion"
f_homologacion.Inicializar conexion
f_homologacion.ProcesaForm
f_homologacion.agregaCampoPost "thom_ccod" , 1

'-------------------------------------------------------------------------
set f_homologacion_destino = new CFormulario
f_homologacion_destino.Carga_Parametros "editar_malla.xml", "f_homologacion_destino"
f_homologacion_destino.Inicializar conexion
f_homologacion_destino.ProcesaForm
'-------------------------------------------------------------------------

homo_ccod = f_homologacion.ObtenerValorPost (0, "homo_ccod")
destino = f_homologacion.ObtenerValorPost (0, "destino")
if homo_ccod = "NUEVA"  then
   homo_ccod =  conexion.consultaUno ("select homo_ccod_seq.nextval from dual")
   f_homologacion.agregaCampoPost "homo_ccod" , homo_ccod
   f_homologacion_destino.agregaCampoPost "homo_ccod" , homo_ccod  
   f_homologacion_destino.agregaCampoPost "asig_ccod" , destino 
   f_homologacion_destino.MantieneTablas false 
end if

for fila = 0 to f_homologacion.CuentaPost - 1
   asig_ccod = f_homologacion.ObtenerValorPost (fila, "asig_ccod")
   if asig_ccod <> "" then      
   else
      f_homologacion.EliminaFilaPost fila 
	  f_homologacion_destino.EliminaFilaPost fila 
   end if 
next


f_homologacion.MantieneTablas false

'conexion.estadotransaccion false  'roolback 
%>

<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
 document.location.reload("Homologacion_Editar.asp?homo_ccod=<%=homo_ccod%>");
//CerrarActualizar();
</script>

<!-- #include file = "../biblioteca/_conexion.asp" -->
<%

set conexion = new CConexion
conexion.Inicializar "upacifico"
	
set formulario = new CFormulario
formulario.Carga_Parametros "Mant_Usuarios.xml", "f1_edicion"
formulario.Inicializar conexion
formulario.ProcesaForm
'formulario.listarpost


 login = formulario.ObtenerValorPost (0, "susu_tlogin")
 clave = formulario.ObtenerValorPost (0, "susu_tclave")
 pers_ncorr = formulario.ObtenerValorPost (0, "pers_ncorr")

sql_existe="select count(*) as existe from sis_usuarios where susu_tlogin='"&login&"' and pers_ncorr <> "&pers_ncorr&" "
v_existe=conexion.ConsultaUno(sql_existe)

if v_existe>0 then
	session("mensajeError")="El Login ingresado ya se encuentra registrado para otro usuario del Sistema."
	Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
end if

 formulario.agregacampopost "susu_tlogin", login
 formulario.agregacampopost "susu_tclave", clave
 formulario.agregacampopost "susu_fmodificacion", date
  
 
for fila = 0 to formulario.CuentaPost - 1
   check = formulario.ObtenerValorPost (fila, "tiene_sede")
   if check = "1" then
      sede_ccod = formulario.ObtenerValorPost (fila, "sede_ccod")
   else
      sede_ccod = formulario.ObtenerValorPost (fila, "sede_ccod")
	  sql = "DELETE FROM sis_sedes_usuarios where pers_ncorr ='" & pers_ncorr & "' AND sede_ccod= '"&sede_ccod&"'"
      conexion.EstadoTransaccion conexion.EjecutaS(sql)    
	  formulario.EliminaFilaPost fila 
   end if
next


formulario.MantieneTablas false
'conexion.estadotransaccion false  'roolback 
%>

<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>




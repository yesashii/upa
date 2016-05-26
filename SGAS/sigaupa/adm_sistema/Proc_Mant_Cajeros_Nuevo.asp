<!-- #include file = "../biblioteca/_conexion.asp" -->
<%

set conexion = new CConexion
conexion.Inicializar "upacifico"
set formulario = new CFormulario
formulario.Carga_Parametros "Mant_Cajeros.xml", "f_sedes_cajero"
formulario.Inicializar conexion
formulario.ProcesaForm
'formulario.listarpost

 pers_ncorr = formulario.ObtenerValorPost (0, "pers_ncorr")

 caje_ccod = conexion.consultauno("SELECT caje_ccod FROM cajeros WHERE pers_ncorr =" & pers_ncorr)
 if caje_ccod <> "" then  
    'response.Write("")
 else
   caje_ccod = conexion.consultauno("SELECT caje_ccod_seq.nextval FROM dual")
 end if
  
  formulario.agregacampopost "caje_ccod", caje_ccod
  formulario.agregacampopost "caje_cestado", 1
  for fila = 0 to formulario.CuentaPost - 1
    check = formulario.ObtenerValorPost (fila, "tiene_sede")
    if check = "1" then
      'sede_ccod = formulario.ObtenerValorPost (fila, "sede_ccod")
    else
      sede_ccod = formulario.ObtenerValorPost (fila, "sede_ccod")
	  sql = "DELETE FROM cajeros where pers_ncorr ='" & pers_ncorr & "' AND sede_ccod= '"&sede_ccod&"'"
      'response.Write(sql & "<BR><BR>")
	  conexion.EstadoTransaccion conexion.EjecutaS(sql)    
	  formulario.EliminaFilaPost fila 
    end if
  next

formulario.MantieneTablas false
'conexion.estadotransaccion false  'roolback 
'response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>






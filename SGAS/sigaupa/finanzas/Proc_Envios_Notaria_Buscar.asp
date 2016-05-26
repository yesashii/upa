<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
  folio_envio = request.querystring("folio_envio")
  set conexion = new CConexion
  conexion.Inicializar "upacifico"
  set formulario = new CFormulario
  formulario.Carga_Parametros "Envios_Notaria.xml", "f_letras"
  formulario.Inicializar conexion
  formulario.ProcesaForm
  for fila = 0 to formulario.CuentaPost - 1
    envio   = formulario.ObtenerValorPost (fila, "envi_ncorr")
	if envio <> "" then
	else
     formulario.EliminaFilaPost fila    
    end if 
  next
  formulario.MantieneTablas false
  'conexion.estadotransaccion true  'roolback   

response.Redirect(request.ServerVariables("HTTP_REFERER"))   
%>

<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
 //document.location.reload("Envios_Notaria_Buscar.asp?folio_envio=<%=folio_envio%>");
</script>

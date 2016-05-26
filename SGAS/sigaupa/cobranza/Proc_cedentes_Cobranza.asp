<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "uapcifico"
'---------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "devueltas_cobranza.xml", "f_listado"
formulario.Inicializar conexion
formulario.ProcesaForm
'formulario.ListarPost

for fila = 0 to formulario.CuentaPost - 1
   num_doc = formulario.ObtenerValorPost (fila, "ding_ndocto")
   if num_doc = "" then
      formulario.EliminaFilaPost fila
   else    
      'estado = formulario.ObtenerValorPost (fila, "edin_ccod")
	  'if estado = 6 then
  	    ' formulario.AgregaCampoFilaPost fila, "eing_ccod", 1
	 ' else
   	    'formulario.AgregaCampoFilaPost fila, "eing_ccod", 2
		formulario.AgregaCampoFilaPost fila, "edin_ccod", 13
	  'end if	
   end if 
next

formulario.MantieneTablas true
conexion.estadotransaccion false  'roolback  

'response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
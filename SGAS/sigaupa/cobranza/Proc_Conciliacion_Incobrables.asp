<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"
'---------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "ingreso_doc_incobrables.xml", "f_listado"
formulario.Inicializar conexion
formulario.ProcesaForm
'formulario.ListarPost

for fila = 0 to formulario.CuentaPost - 1
   num_doc = formulario.ObtenerValorPost (fila, "ding_ndocto")
   if num_doc = "" then
      formulario.EliminaFilaPost fila
   else    
      formulario.AgregaCampoFilaPost fila, "edin_ccod", 14
	  	
   end if 
next

formulario.MantieneTablas false
'conexion.estadotransaccion false  'roolback  
'response.End()

response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
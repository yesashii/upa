<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.ObtenerUsuario()

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()

set formulario = new CFormulario
formulario.Carga_Parametros "detalle_contratos_docentes.xml", "detalle_anexos_contratos"
formulario.Inicializar conexion
formulario.ProcesaForm		


for fila = 0 to formulario.CuentaPost - 1
   v_anex_ncorr	= formulario.ObtenerValorPost (fila, "anex_ncorr")
   v_cdoc_ncorr	= formulario.ObtenerValorPost (fila, "cdoc_ncorr")
   v_pers_ncorr	= formulario.ObtenerValorPost (fila, "pers_ncorr")

   if v_anex_ncorr <> "" and v_cdoc_ncorr <> "" then
   
   	sql_anula= "update bloques_profesores set bloq_anexo=null, cdoc_ncorr=null "& vbCrLf &_ 
				"where bloq_ccod in( "& vbCrLf &_ 
				"    select bloq_ccod from bloques_profesores where cdoc_ncorr="&v_cdoc_ncorr&" and bloq_anexo="&v_anex_ncorr&" ) "& vbCrLf &_ 
				"and cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'"
	'Response.Write("<br> Cadena :<pre>"&sql_anula&"</pre>")			
	conexion.EstadoTransaccion conexion.EjecutaS(sql_anula)
				
	formulario.AgregaCampoFilaPost fila , "EANE_CCOD", "3"
		
   end if
next
formulario.MantieneTablas false
'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'Response.End()

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="Los Anexos selecionados fueron anulados correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar anular uno o mas anexos para este contrato."
end if
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
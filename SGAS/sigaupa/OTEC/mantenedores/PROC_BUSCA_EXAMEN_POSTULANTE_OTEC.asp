<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'*************'
'* VARIABLES *'
'*************'
estado = request.Form("em[0][Eepo_ccod]")
usuario_c = request.Form("audi_tusuario")
pote_ncorr_capturado = request.Form("em[0][pote_ncorr]")
'*************'

set conexion = new CConexion
conexion.Inicializar "upacifico" 
'********************'
'* si está aprobado *'
'* Requerimiento eliminado por Guillermo Araya según reunión del día 01-07-2013 (Marcelo) *'
'********************'  
if estado = "2" then
	consulta = "update postulacion_otec           " & vbCrlf & _
	"set    epot_ccod = "&estado&",               " & vbCrlf & _
	"       audi_tusuario = '"&usuario_c&"',      " & vbCrlf & _
	"       audi_fmodificacion = getdate()        " & vbCrlf & _
	"where  pote_ncorr = "&pote_ncorr_capturado&  " "
	
	conexion.ejecutas(consulta)
end if 
'********************'          
set formulario = new cFormulario
formulario.carga_parametros	"BUSCA_EXAMEN_POSTULANTE_OTEC_2.XML","tabla_valores"
formulario.Inicializar conexion
formulario.ProcesaForm          
            v_estado_transaccion=formulario.MantieneTablas (false)
			'response.End()
            'response.Write("<b>estado:</b>"&conexion.obtenerEstadoTransaccion)
'            
'            
            if v_estado_transaccion=false  then
            	session("mensaje_error")="El examen no pudo ser ingresado correctamente.\nVuelva a intentarlo."
            else	
            	session("mensaje_error")="El examen fue ingresado correctamente."
            end if
            
            'conexion.estadoTransaccion false
            'response.End()
            response.Redirect(request.ServerVariables("HTTP_REFERER"))
            
            

%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
	self.opener.location.reload();
	window.close();
</script>

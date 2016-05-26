<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_periodos = new CFormulario
f_periodos.Carga_Parametros "periodos_egreso.xml", "f_periodo_egreso"
f_periodos.Inicializar conexion
f_periodos.ProcesaForm
'f_planes.ListarPost
cont = 0
for fila = 0 to f_periodos.CuentaPost - 1
   pegr_ncorr = f_periodos.ObtenerValorPost (fila, "pegr_ncorr")
   if len(pegr_ncorr) > o then
      conexion.ejecutaS "delete from pre_periodos_egreso where pegr_ncorr="+pegr_ncorr
    end if   
next
'f_periodos.MantieneTablas true
'response.End()
'conexion.estadotransaccion false  'roolback 

response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>

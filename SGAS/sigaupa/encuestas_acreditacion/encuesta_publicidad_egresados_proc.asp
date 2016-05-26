<!-- #include file = "../biblioteca/_conexion.asp" -->


<%
'-----------------------------------------------------
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"

'conectar.estadoTransaccion false

set formulario = new cformulario
formulario.carga_parametros "encuestas_acreditacion_publicidad.xml", "guardar_encuesta_egresados"
formulario.inicializar conectar
formulario.procesaForm
epeg_ncorr = conectar.ConsultaUno("execute obtenerSecuencia 'encuesta_publicidad_egresados' ") 
formulario.AgregaCampoPost "epeg_ncorr", epeg_ncorr
formulario.AgregaCampoPost "fecha_grabado", Date'conectar.consultaUno("select convert(datetime,getDate(),103)")
formulario.MantieneTablas false

'response.End()
pers_ncorr = request.Form("e[0][pers_ncorr]")

rut = conectar.consultaUno("select pers_nrut from personas where cast(pers_ncorr as varchar)= '"&pers_ncorr&"'")
xdv = conectar.consultaUno("select pers_xdv from personas where cast(pers_ncorr as varchar)= '"&pers_ncorr&"'")
'----------------------------------------------------
'response.Write("rut "&rut&" xdv "&xdv)
'response.End()
%>

<script language="JavaScript" type="text/JavaScript">
  rut= <%=rut%>;
  xdv= <%=xdv%>;
  location.href = "encuesta_publicidad_egresados.asp?devuelto=1&busqueda[0][pers_nrut]="+rut+"&busqueda[0][pers_xdv]="+xdv;
</script>


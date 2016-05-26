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

carr_ccod = request.Form("busqueda[0][carr_ccod]")

set formulario = new cformulario
formulario.carga_parametros "encuesta_egresados.xml", "guardar_encuesta"
formulario.inicializar conectar
formulario.procesaForm
eegr_ncorr = conectar.ConsultaUno("execute obtenerSecuencia 'encuestas_egresados' ") 
formulario.AgregaCampoPost "eegr_ncorr", eegr_ncorr
formulario.AgregaCampoPost "carr_ccod", carr_ccod
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
  location.href = "encuesta_egresados.asp?devuelto=1&busqueda[0][pers_nrut]="+rut+"&busqueda[0][pers_xdv]="+xdv;
</script>


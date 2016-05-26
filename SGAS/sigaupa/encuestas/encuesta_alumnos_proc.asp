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
formulario.carga_parametros "encuesta_alumnos.xml", "guardar_encuesta"
formulario.inicializar conectar
formulario.procesaForm
ealu_ncorr = conectar.ConsultaUno("execute obtenerSecuencia 'encuestas_alumnos' ") 
formulario.AgregaCampoPost "ealu_ncorr", ealu_ncorr
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
  xdv= '<%=xdv%>';
  location.href = "encuesta_alumnos.asp?devuelto=1";
</script>


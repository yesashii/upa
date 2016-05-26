<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next


set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
f_consulta.Inicializar conexion
'----------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "eventos_upa.xml", "f_eventos"
formulario.Inicializar conexion
formulario.ProcesaForm
'tengo que buscar si tienen alumnos, si tienen no los elimino
cont = 0
for fila = 0 to formulario.CuentaPost - 1
  even_ncorr = formulario.ObtenerValorPost (fila, "even_ncorr")
  if even_ncorr <> "" then
     SQL = "select count(even_ncorr) as total from eventos_alumnos where even_ncorr=" & even_ncorr
	 f_consulta.consultar SQL
	' response.Write("<hr> consulta: --->  "&SQL)
	 f_consulta.siguiente
	 documentos = f_consulta.ObtenerValor ("total")
	 if documentos = 0 then
        SQL = "delete from eventos_upa where even_ncorr=" & even_ncorr 
		conexion.EstadoTransaccion conexion.EjecutaS(SQL) 
	 else
	    cont =cont + 1
		cad = cad & even_ncorr & "   "
	 end if	 
  end if
next 
if cont > 0 then
  	mensage = " Los siguientes eventos no se eliminaron porque contenían alumnos asociados..." & "\n N°: " & cad 
  	session("mensajeError")= mensage
ELSE
 	session("mensajeError")= "El o los eventos seleccionados fueron eliminados correctamente"
end if

'conexion.EstadoTransaccion false
'response.End()
'formulario.MantieneTablas true
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>

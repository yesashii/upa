<!-- #include file = "../biblioteca/_conexion.asp" -->
<%

'Response.AddHeader "Content-Disposition", "attachment;filename=reporte_usuarios_grl.txt"
'Response.ContentType = "text/plain"
Server.ScriptTimeOut = 150000

set conexion = new CConexion
conexion.Inicializar "upacifico"
comillas=""""
'------------------------------------------------------------------------------------
fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "tabla_vacia.xml", "tabla"
formulario.Inicializar conexion

consulta = "select b.pers_ncorr,a.rut from mis_datos_2009 a, personas b  where a.rut=b.pers_nrut ORDER BY APaterno,AMaterno"



response.Write("<pre>"&consulta&"</pre>")
'response.Write("<pre>"&consulta2&"</pre>")
'response.Write("<pre>"&consulta3&"</pre>")
'response.End()
formulario.Consultar consulta 
while formulario.siguiente
'response.write("update mis_datos_2009 set pers_ncorr="&formulario.ObtenerValor("pers_ncorr")&" where rut="&formulario.ObtenerValor("rut")&" ")
conexion.ejecutaS("update mis_datos_2009 set pers_ncorr="&formulario.obtenerValor("pers_ncorr")&" where rut="&formulario.obtenerValor("rut")&" ")

wend

%>

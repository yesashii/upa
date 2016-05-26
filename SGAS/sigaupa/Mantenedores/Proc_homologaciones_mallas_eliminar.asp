<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_planes = new CFormulario
f_planes.Carga_Parametros "m_homologaciones_malla.xml", "f_homologacion"
f_planes.Inicializar conexion
f_planes.ProcesaForm
'f_planes.ListarPost

'response.End()
mensage = ""
cont = 0
for fila = 0 to f_planes.CuentaPost - 1
	'response.Write("<br>contador a:" & cont)
   homo_ccod = f_planes.ObtenerValorPost (fila, "homo_ccod")
   homo_nresolucion = f_planes.ObtenerValorPost (fila, "homo_nresolucion")
   'response.Write("homo_ccod=" & homo_ccod & "<br>")
   'plan_tcoduas = f_planes.ObtenerValorPost (fila, "c_plan_tcoduas")
   if 	homo_ccod <> "" then
   		sql = " Select count(a.homo_ccod) as contador " & vbcrlf & _
       		  "	from homologacion_fuente a, homologacion b " & vbcrlf & _
       		  "	where b.homo_ccod<>" & homo_ccod & " and a.homo_ccod=b.homo_ccod and cast(b.homo_nresolucion as varchar)='" & homo_nresolucion & "'"
       
	  resultado = conexion.ConsultaUno(sql) 
  
	  sql_d = " Select count(a.homo_ccod) as contador " & vbcrlf & _
       		  "	from homologacion_destino a, homologacion b " & vbcrlf & _
       		  "	where b.homo_ccod<>" & homo_ccod & " and a.homo_ccod=b.homo_ccod and cast(b.homo_nresolucion as varchar)='" & homo_nresolucion & "'"
	  resultado_d = conexion.ConsultaUno(sql_d) 
	  
	  if  cint(resultado) > 0 or cint(resultado_d) > 0  then
          f_planes.EliminaFilaPost fila 		 
	      cad = cad & homo_nresolucion  & "  "
		  cont = cint(cont)  + 1 
		  'response.Write("<BR>"&resultado&" No se puede:" & homo_ccod) 
		  'response.Flush()
	  end if
   else
     f_planes.EliminaFilaPost fila 
   end if 
next
'response.Write("<br>contador:" & cont)
'response.End()
if cont > 0 then
  mensage = "Las siguientes Resoluciones no se eliminaron, porque existen homologaciones destino o fuente relacionadas..." & "\n" & cad 
  session("mensajeError")= mensage
end if

'verifica_fuente = conexion.consultaUno("Select homo_ccod from homologacion_fuente where cast(homo_ccod as varchar)='" & homo_ccod & "'")
conexion.EstadoTransaccion f_planes.MantieneTablas(false)
transaccion = conexion.obtenerEstadoTransaccion

'transaccion = transaccion and f_planes.MantieneTablas(false)

'response.End()
if transaccion=TRUE then
	if cont = 0 then
		session("mensajeError") = "Homologación eliminada con éxito."
	end if
else
	session("mensajeError") = "Error, Homologación no fue eliminada.\nDebe tener registros asociados."
end if

'conexion.estadotransaccion false  'roolback 
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
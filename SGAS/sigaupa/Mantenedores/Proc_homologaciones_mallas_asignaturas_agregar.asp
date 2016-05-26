<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

homo_nresolucion = request.Form("homo_nresolucion")
'response.Write("homo_nresolucion=" & homo_nresolucion)

set f_origen = new CFormulario
f_origen.Carga_Parametros "m_homologaciones_malla.xml", "f_fuente"
f_origen.Inicializar conexion
f_origen.ProcesaForm

set f_destino = new CFormulario
f_destino.Carga_Parametros "m_homologaciones_malla.xml", "f_destino"
f_destino.Inicializar conexion
f_destino.ProcesaForm

'f_origen.ListarPost
'f_destino.ListarPost
'response.End()

usuario = negocio.obtenerUsuario
'homo_ccod = conexion.consultauno("exec protic.ObtenerSecuencia 'homologacion'")

'sql_insert_efec = " Insert into homologacion Select * from (Select " & homo_ccod & " as homo_ccod,thom_ccod,'" & usuario & "' as audi_tusuario,getdate() as audi_fmodificacion," & vbcrlf & _
'			      " null as area_ccod,homo_nresolucion,homo_fresolucion,esho_ccod,PLAN_CCOD_FUENTE,PLAN_CCOD_DESTINO" & vbcrlf & _
'				  " from homologacion a " & vbcrlf & _
'				  " where cast(a.homo_nresolucion as varchar)='" & homo_nresolucion & "' group by homo_nresolucion,homo_fresolucion,esho_ccod,thom_ccod,PLAN_CCOD_FUENTE,PLAN_CCOD_DESTINO ) as tabla"
'conexion.EstadoTransaccion conexion.EjecutaS(sql_insert_efec)

'for fila = 0 to f_origen.CuentaPost - 1
 '  f_origen.AgregaCampoFilaPost fila, "homo_ccod",homo_ccod
   'envio = formulario.ObtenerValorPost (fila, "envi_ncorr")
'next   

'for fila = 0 to f_destino.CuentaPost - 1
'	asig_ccod = f_destino.ObtenerValorPost (fila, "asig_ccod")
'	if 	asig_ccod <> "" then
 '  		f_destino.AgregaCampoFilaPost fila, "homo_ccod",homo_ccod
	'end if
'next   

for fila = 0 to f_origen.CuentaPost - 1
	num_origen = f_origen.ObtenerValorPost (fila, "num_fuente")
	asig_ccod = f_origen.ObtenerValorPost (fila, "asig_ccod")
	'response.Write("-----------num_origen:"&num_origen&"-----------<br>")
	'response.Write("-----------asig_ccod:"&asig_ccod&"-----------<br>")
	if	asig_ccod <> "" and num_origen <> "" then
		homo_ccod = f_origen.ObtenerValorPost (fila, "homo_ccod")
		'response.Write("-----------homo_ccod:"&homo_ccod&"-----------<br>")
		if	EsVacio(homo_ccod) then
			homo_ccod = conexion.consultauno("exec ObtenerSecuencia 'homologacion'")
			'response.Write("-----------homo_ccod:"&homo_ccod&"-----------<br>")
			sql_insert_efec = " Insert into homologacion Select * from (Select " & homo_ccod & " as homo_ccod,thom_ccod,'" & usuario & "' as audi_tusuario,getdate() as audi_fmodificacion," & vbcrlf & _
				      " null as area_ccod,homo_nresolucion,homo_fresolucion,esho_ccod,PLAN_CCOD_FUENTE,PLAN_CCOD_DESTINO" & vbcrlf & _
					  " from homologacion a " & vbcrlf & _
					  " where cast(a.homo_nresolucion as varchar)='" & homo_nresolucion & "' group by homo_nresolucion,homo_fresolucion,esho_ccod,thom_ccod,PLAN_CCOD_FUENTE,PLAN_CCOD_DESTINO ) as tabla"
			conexion.EstadoTransaccion conexion.EjecutaS(sql_insert_efec)
			f_origen.AgregaCampoFilaPost fila, "homo_ccod",homo_ccod
		end if
		
		for fila_1 = 0 to f_origen.CuentaPost - 1
			num_origen_1 = f_origen.ObtenerValorPost (fila_1, "num_fuente")
			asig_ccod_1 = f_origen.ObtenerValorPost (fila_1, "asig_ccod")
			if	asig_ccod_1 <> "" and num_origen_1 = num_origen then
				homo_ccod_1 = f_origen.ObtenerValorPost (fila_1, "homo_ccod")
				if	homo_ccod_1 = "" then
					f_origen.AgregaCampoFilaPost fila_1, "homo_ccod",homo_ccod
				end if
			end if
		next
		
		for fila_2 = 0 to f_destino.CuentaPost - 1
			num_destino = f_destino.ObtenerValorPost (fila_2,"num_destino")
			asig_ccod_2 = f_destino.ObtenerValorPost (fila_2, "asig_ccod")
			if 	asig_ccod_2 <> "" and num_destino <> "" then
				homo_ccod_2 = f_destino.ObtenerValorPost (fila_2, "homo_ccod")	
				if	homo_ccod_2 = "" and num_destino = num_origen then
			   		f_destino.AgregaCampoFilaPost fila_2, "homo_ccod",homo_ccod
				end if
			end if
		next   
		
	end if
	
   	'f_origen.AgregaCampoFilaPost fila, "homo_ccod",homo_ccod
   'envio = formulario.ObtenerValorPost (fila, "envi_ncorr")
next   



'f_origen.ListarPost
'f_destino.ListarPost
'conexion.estadotransaccion false  'roolback 
'response.End()


conexion.EstadoTransaccion f_origen.MantieneTablas(false)
conexion.EstadoTransaccion f_destino.MantieneTablas(false)
'conexion.estadotransaccion false  'roolback 
transaccion = conexion.obtenerEstadoTransaccion
'response.End()
if 	transaccion=TRUE then
	session("mensajeError") = "Homologación creada con éxito."
else
	session("mensajeError") = "Error, Homologación no fue creada.\nFavor intentarlo nuevamente."
end if
'conexion.estadotransaccion false  'roolback 
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
//CerrarActualizar();
</script>
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_rutas.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new Cnegocio
negocio.Inicializa conexion

set f_consulta = new CFormulario
f_consulta.Carga_Parametros "consulta.xml", "consulta"
f_consulta.Inicializar conexion	
	
	'SQL = "select * from traspasos_cajas where mcaj_ncorr = '" & p_mcaj_ncorr & "' order by ingr_nfolio_referencia asc, trca_nlinea asc"	
	SQL = "select envi_ncorr,eenv_ccod,envi_fenvio from envios where eenv_ccod in (2,4) and tenv_ccod=2 and envi_fenvio > '13-12-2004' and tdep_ccod in (1,2,3)"
	f_consulta.Consultar SQL
	
	while f_consulta.Siguiente
		  envio = f_consulta.ObtenerValor("envi_ncorr")
		  conexion.ConsultaUno("exec guardar_movimientos_cheques "&envio)' inserta registros en tabla movimientos_cheques		  
	   	  verificador=TablaAArchivo(envio, conexion) 
		  response.Write("Archivo generado : "&envio&"<br>")
		  response.Flush()
	wend


Function TablaAArchivo(envi_ncorr, p_conexion)
	Dim f_consulta
	Dim fso, archivo_salida, o_texto_archivo
	Dim delimitador
	Dim linea
	
	On Error Resume Next	
	
	fecha_envio = p_conexion.consultauno("Select envi_fenvio from envios where envi_ncorr="&envi_ncorr)
	archivo_salida 		= fecha_envio&"_deposito_"&envi_ncorr&".txt"
	set fso = Server.CreateObject("Scripting.FileSystemObject")
	set o_texto_archivo = fso.CreateTextFile(RUTA_ARCHIVOS_SALIDA01 & "\" & archivo_salida)

	if Err.Number <> 0 then
			response.Write("error :"&Err.Description):response.Flush()
			TablaAArchivo = false
			Exit Function
	end if
	'--------------------------------------------------------------------------------------------------------------
	
	set f_consulta = new CFormulario
	f_consulta.Carga_Parametros "consulta.xml", "consulta"
	f_consulta.Inicializar p_conexion	
	
	SQL = "Select * from movimientos_cheques where cast(envi_ncorr as varchar) = '"&envi_ncorr&"' " &vbcrlf&_
       	  " Order by banc_tdesc,ding_ndocto,rut_alumno "
	f_consulta.Consultar SQL
	
	while f_consulta.Siguiente
		linea = ""
		linea = linea & f_consulta.ObtenerValor("envi_ncorr") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("ccte_tdesc") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("banc_ccod_envio") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("inen_tdesc") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("envi_fenvio") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("ding_ndocto") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("ding_tcuenta_corriente") & DELIMITADOR_CAMPOS		
		linea = linea & f_consulta.ObtenerValor("ding_mdocto") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("ding_fdocto") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("banc_tdesc") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("banc_ccod") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("rut_alumno") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("nombre_alumno") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("envi_tglosa") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("tipo_deposito") & DELIMITADOR_CAMPOS
		o_texto_archivo.WriteLine(linea)
		
	wend

	o_texto_archivo.Close
	
	'----------------------------------------------------------------------------------------------------------------
	set o_texto_archivo = Nothing
	set fso = Nothing
	set f_consulta = Nothing
	
	TablaAArchivo = true
	
End Function
%>
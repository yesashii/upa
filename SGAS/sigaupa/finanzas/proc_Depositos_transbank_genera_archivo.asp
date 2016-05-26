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
	SQL = "select envi_ncorr,eenv_ccod,envi_fenvio from envios where eenv_ccod=2 and tenv_ccod=2 and tdep_ccod in (1,2) and envi_fenvio > '03-01-2005' and envi_fenvio='05-01-2005'"
	
 
	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=6 "		  

	SQL = 	" select envi_ncorr,eenv_ccod,envi_fenvio from envios "& vbcrlf & _
			" where eenv_ccod in (2,4)  and tenv_ccod=6  "& vbcrlf & _
			" and envi_fenvio >= convert(datetime,'01-03-2005',103) "& vbcrlf & _
			" and envi_fenvio < convert(datetime,'16-09-2005',103) "

	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=6 and envi_ncorr in (1383,2810)"		  
		  
	f_consulta.Consultar SQL
	
	while f_consulta.Siguiente
		  envio = f_consulta.ObtenerValor("envi_ncorr")
		  conexion.ConsultaUno("exec guardar_movimientos_pag_trans_softland "&envio)' inserta registros en tabla movimientos_cheques		  
	  	  verificador01=TablaAArchivoSoftland(envio, conexion)  
		  response.Write("Archivo generado : "&envio&"<br>")
		  response.Flush()
	wend
Function TablaAArchivoSoftland(envi_ncorr, p_conexion)
	Dim f_consulta
	Dim fso, archivo_salida, o_texto_archivo
	Dim delimitador
	Dim linea
	
	On Error Resume Next	
	
	
	sql_cta_cte = "SELECT   e.ccte_tcontableasoc   FROM envios a, instituciones_envio c,cuentas_corrientes e  " & vbcrlf & _
			  " WHERE a.inen_ccod = c.inen_ccod  " & vbcrlf & _
			  "	  and a.ccte_ccod = e.ccte_ccod  " & vbcrlf & _
			  "	  and a.envi_ncorr = " & envi_ncorr 
	sql_suma_dep = "Select sum(moch_mdocto) as sum_dep from movimiento_cheque_softland where moch_ndeposito=" & envi_ncorr
	suma_depo = p_conexion.consultauno(sql_suma_dep)
	
	'cta_contable = p_conexion.consultauno(sql_cta_cte)'cuenta usada antes de corregirla (Banco)
	
	cta_contable="1-10-010-10-000001" ' correcion cajas suplementarias pagares Transbank (Efectivo)

	fecha_envio = p_conexion.consultauno("Select envi_fenvio from envios where envi_ncorr="&envi_ncorr)
	glosa_envio = p_conexion.consultauno("Select substring(envi_tdescripcion+'-'+cast(envi_ncorr as varchar),0,60) as aux from envios where envi_ncorr="&envi_ncorr)
	archivo_salida 		= fecha_envio&"_deposito_tbk_reprocesado_"&envi_ncorr&".txt"
	set fso = Server.CreateObject("Scripting.FileSystemObject")
	set o_texto_archivo = fso.CreateTextFile(RUTA_ARCHIVOS_SALIDA_MASIVA & "\pag_repro\" & archivo_salida)
	
	if Err.Number <> 0 then
			response.Write("error :"&Err.Description):response.Flush()
			TablaAArchivoSoftland = false
			Exit Function
	end if
	'--------------------------------------------------------------------------------------------------------------
	
	set f_consulta = new CFormulario
	f_consulta.Carga_Parametros "consulta.xml", "consulta"
	f_consulta.Inicializar p_conexion	
	
	'SQL = "select * from traspasos_cajas where mcaj_ncorr = '" & p_mcaj_ncorr & "' order by ingr_nfolio_referencia asc, trca_nlinea asc"	
	SQL = "Select moch_mdocto,protic.trunc(moch_fdeposito) as moch_fdeposito,moch_ndocref,moch_tdocref,moch_cenc_ccod_softland,moch_nrutalumno from movimiento_cheque_softland where cast(moch_ndeposito as varchar) = '"&envi_ncorr&"' " &vbcrlf&_
       	  " Order by moch_ndocref "
	f_consulta.Consultar SQL
	
	linea = ""
	
   '######## para cuenta banco , si lleva algunos atributos ################
   '	linea = cta_contable & "," & suma_depo & ",," & glosa_envio & ",1,,,,,,1-01-00009,,,,,,DE," & envi_ncorr & ",,,,,,,,,,,,,,,,,,,,,1"
   '	o_texto_archivo.WriteLine(linea)
	
	'######## cuenta caja , no lleva atributos ################
	linea = cta_contable & "," & suma_depo & ",," & glosa_envio & ",1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,1"
	o_texto_archivo.WriteLine(linea)
	
	linea = ""
	cont_lineas = 1
	agrupacion = 1
	suma_cuotas = 0
	diferencia = 0
	
	while f_consulta.Siguiente
		if 	cont_lineas = 49 then
			cont_lineas = 1
			linea = ""
			diferencia = clng(suma_depo) - clng(suma_cuotas)
			
			'response.Flush()
			linea = "9-10-010-10-000001,," & diferencia & "," & glosa_envio & ",1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,," & agrupacion
			o_texto_archivo.WriteLine(linea)
			agrupacion = agrupacion +1
			linea = "9-10-010-10-000001," & diferencia & ",," & glosa_envio & ",1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,," & agrupacion
			o_texto_archivo.WriteLine(linea)
			'response.Write("dif :" & diferencia & " = " & cint(suma_depo) & "-" & cint(suma_cuotas) & "<br>")
		end if
		suma_cuotas = clng(suma_cuotas) + clng(f_consulta.ObtenerValor("moch_mdocto"))
		'response.Write("suma cuota :" & suma_cuotas & "<br>")
		tipo_tarjeta = f_consulta.ObtenerValor("moch_tdocref")
		linea = ""
		linea = linea & "1-10-050-40-" &f_consulta.ObtenerValor("moch_cenc_ccod_softland")& ",," & f_consulta.ObtenerValor("moch_mdocto") 
		linea = linea & "," & glosa_envio & ",1,,,,,,,,,,,,,," & f_consulta.ObtenerValor("moch_nrutalumno") & ",DE," & envi_ncorr & "," & f_consulta.ObtenerValor("moch_fdeposito") 
		linea = linea & "," & f_consulta.ObtenerValor("moch_fdeposito") & "," & f_consulta.ObtenerValor("moch_tdocref") & "," & f_consulta.ObtenerValor("moch_ndocref") 
		linea = linea & ",,,,,,,,,,,,,," & agrupacion
		o_texto_archivo.WriteLine(linea)
		cont_lineas = cont_lineas + 1 
		'response.Write(linea&"<br>")
	wend

	o_texto_archivo.Close
	'o_texto_archivo_2.Close
	
	'----------------------------------------------------------------------------------------------------------------
	set o_texto_archivo = Nothing
	set fso = Nothing
	'set o_texto_archivo_2 = Nothing
	'set fso2 = Nothing
	set f_consulta = Nothing
	
	TablaAArchivoSoftland = true
	
End Function

%>
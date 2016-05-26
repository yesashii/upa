<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_rutas.asp" -->
<%
server.ScriptTimeout = 2000
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
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2) and envi_fenvio > '02-01-2005' and envi_fenvio<'06-01-2005'"

	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2) and envi_ncorr=469"
		  
	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2) and envi_fenvio > '05-01-2005' and envi_fenvio<'01-02-2005'"	  

	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2) and envi_fenvio > '31-01-2005' and envi_fenvio<'04-03-2005'"	  
  
	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2) and envi_ncorr in (469,471,529,637)"
		  
	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2) and envi_fenvio > '02-01-2005' and envi_fenvio<'01-02-2005'"

	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2)" & vbcrlf & _
          " and envi_fenvio > '31-01-2005' and envi_fenvio<'01-03-2005'"

	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2)" & vbcrlf & _
          " and envi_fenvio > '31-03-2005' and envi_fenvio<'01-05-2005'"
	
	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2,3)" & vbcrlf & _
          " and envi_ncorr=751"
		  
	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2,3)" & vbcrlf & _
          " and envi_ncorr=732"		 
	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2,3)" & vbcrlf & _
          " and envi_ncorr=797"
		  
	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2,3) " & vbcrlf & _
          " and envi_ncorr=741"
		  		   		  
	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2,3) " & vbcrlf & _
          " and envi_ncorr=930"
	
	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2,3) " & vbcrlf & _
          " and envi_ncorr=1062"			  
	
	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2,3) " & vbcrlf & _
          " and envi_ncorr in (1133,1134)"
	
	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2,3) " & vbcrlf & _
          " and envi_ncorr in (1170)"
	
	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2,3) " & vbcrlf & _
          " and envi_ncorr in (790)"

	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2,3) " & vbcrlf & _
          " and envi_ncorr in (1207)"
		  
	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2,3) " & vbcrlf & _
          " and envi_ncorr in (1243)"		  
	
		SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2,3) " & vbcrlf & _
          " and envi_ncorr in (1297)"		  
		
		SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2,3) " & vbcrlf & _
          " and envi_ncorr in (1252)"
		  
 		SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2,3) " & vbcrlf & _
          " and envi_ncorr in (1288)"
	
		SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
			  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2)" & vbcrlf & _
			  " and envi_fenvio > '01-05-2005' and envi_fenvio<'21-05-2005'"
			  
		SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		      " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2,3) " & vbcrlf & _
			  " and envi_ncorr in (1508)"

		SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		      " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2,3) " & vbcrlf & _
			  " and envi_ncorr in (1862,1835,2024,2155)"
		
		SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		      " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2,3) " & vbcrlf & _
			  " and envi_ncorr in (2191)"


		SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		      " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2,3) " & vbcrlf & _
			  " and envi_ncorr in (2232)"

		SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		      " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2,3) " & vbcrlf & _
			  " and envi_ncorr in (2376)"
		
	   SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		      " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2,3) " & vbcrlf & _
			  " and envi_ncorr in (2486)"	  

	   SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		      " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2,3) " & vbcrlf & _
			  " and envi_ncorr in (2536)"	

	   SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		      " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2,3) " & vbcrlf & _
			  " and envi_ncorr in (2538)"	

	   SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		      " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2,3) " & vbcrlf & _
			  " and envi_ncorr in (1973)"	

	   SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
			  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2)" & vbcrlf & _
			  " and envi_fenvio > '26-01-2006'"

	   SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		      " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (2) " & vbcrlf & _
			  " and envi_ncorr in (10213,10222,10224,10227,10229)"	
			  
	   SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		      " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (2) " & vbcrlf & _
			  " and envi_ncorr in (10568,10569)"			  

	   SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		      " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (2) " & vbcrlf & _
			  " and envi_ncorr in (10459)"			

	   SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		      " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (2) " & vbcrlf & _
			  " and envi_ncorr in (10676,10677,10678,10679)"			

	   SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		      " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (2) " & vbcrlf & _
			  " and envi_ncorr in (11539)"					

	   SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		      " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (2) " & vbcrlf & _
			  " and envi_ncorr in (11951,11952,11953)"	
			  
	   SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		      " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2) " & vbcrlf & _
			  " and envi_ncorr in (24010)"		


	   SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		      " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod in (1,2) " & vbcrlf & _
			  " and envi_ncorr in (46069)"				  		  
  			  					  
	f_consulta.Consultar SQL
	
	while f_consulta.Siguiente
		  envio = f_consulta.ObtenerValor("envi_ncorr")
		  conexion.ConsultaUno("exec guardar_movimiento_cheque_softland "&envio)' inserta registros en tabla movimientos_cheques		  
	   	  verificador=TablaAArchivoSoftland(envio, conexion) 
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
	cta_contable = p_conexion.consultauno(sql_cta_cte)
	fecha_envio = p_conexion.consultauno("Select envi_fenvio from envios where envi_ncorr="&envi_ncorr)
	glosa_envio = p_conexion.consultauno("Select substring(envi_tdescripcion+'-'+cast(envi_ncorr as varchar),0,60) as aux from envios where envi_ncorr="&envi_ncorr)
	archivo_salida	= fecha_envio&"_deposito_"&envi_ncorr&".txt"
	set fso 		= Server.CreateObject("Scripting.FileSystemObject")
	set o_texto_archivo = fso.CreateTextFile(RUTA_ARCHIVOS_SALIDA_SOFTLAND01 & "\" & archivo_salida)
	
	if Err.Number <> 0 then
			response.Write("error :"&Err.Description):response.Flush()
			TablaAArchivoSoftland = false
			Exit Function
	end if
	'--------------------------------------------------------------------------------------------------------------
	
	set f_consulta = new CFormulario
	f_consulta.Carga_Parametros "consulta.xml", "consulta"
	f_consulta.Inicializar p_conexion	
	
	SQL = "Select moch_mdocto,protic.trunc(moch_fdeposito) as moch_fdeposito,moch_ndocref,moch_tdocref,moch_cenc_ccod_softland,moch_nrutalumno from movimiento_cheque_softland where cast(moch_ndeposito as varchar) = '"&envi_ncorr&"' " &vbcrlf&_
       	  " Order by moch_ndocref "
	f_consulta.Consultar SQL
	
	linea = ""
	linea = cta_contable & "," & suma_depo & ",," & glosa_envio & ",1,,,,,,1-01-00009,,,,,,DE," & envi_ncorr & ",,,,,,,,,,,,,,,,,,,,,1"
	o_texto_archivo.WriteLine(linea)
	linea = ""
	linea = "1-10-010-10-000001,," & suma_depo & "," & glosa_envio & ",1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,1"
	o_texto_archivo.WriteLine(linea)
	linea = ""
	linea = "1-10-010-10-000001," & suma_depo & ",," & glosa_envio & ",1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,1"
	o_texto_archivo.WriteLine(linea)
	cont_lineas = 3
	agrupacion 	= 1
	suma_cuotas = 0
	diferencia 	= 0
	
	while f_consulta.Siguiente
		if 	cont_lineas = 49 then
			cont_lineas = 1
			linea = ""
			diferencia = clng(suma_depo) - clng(suma_cuotas)
			
			linea = "9-10-010-10-000001,," & diferencia & "," & glosa_envio & ",1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,," & agrupacion
			o_texto_archivo.WriteLine(linea)
			agrupacion = agrupacion +1
			linea = "9-10-010-10-000001," & diferencia & ",," & glosa_envio & ",1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,," & agrupacion
			o_texto_archivo.WriteLine(linea)
		end if

		suma_cuotas = clng(suma_cuotas) + clng(f_consulta.ObtenerValor("moch_mdocto"))
		linea = ""
		
		if	f_consulta.ObtenerValor("moch_cenc_ccod_softland") = "101200" then ' este centro de costo es para funcionarios
			linea = linea & "1-10-050-05-" &f_consulta.ObtenerValor("moch_cenc_ccod_softland")& ",," & f_consulta.ObtenerValor("moch_mdocto") 
		else
			linea = linea & "1-10-050-10-" &f_consulta.ObtenerValor("moch_cenc_ccod_softland")& ",," & f_consulta.ObtenerValor("moch_mdocto") 
		end if

		linea = linea & "," & glosa_envio & ",1,,,,,,,,,,,,,," & f_consulta.ObtenerValor("moch_nrutalumno") & ",DE," & envi_ncorr & "," & f_consulta.ObtenerValor("moch_fdeposito") 
		linea = linea & "," & f_consulta.ObtenerValor("moch_fdeposito") & "," & f_consulta.ObtenerValor("moch_tdocref") & "," & f_consulta.ObtenerValor("moch_ndocref") 
		linea = linea & ",,,,,,,,,,,,,," & agrupacion
		o_texto_archivo.WriteLine(linea)
		cont_lineas = cont_lineas + 1 
	wend

	o_texto_archivo.Close
	
	'----------------------------------------------------------------------------------------------------------------
	set o_texto_archivo = Nothing
	set fso = Nothing
	set f_consulta = Nothing
	
	TablaAArchivoSoftland = true
	
End Function
%>
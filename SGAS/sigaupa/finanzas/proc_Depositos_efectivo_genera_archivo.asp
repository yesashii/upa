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
	
	'SQL = "select envi_ncorr,eenv_ccod,envi_fenvio from envios where eenv_ccod=2 and tenv_ccod=2 and tdep_ccod in (1,2) and envi_fenvio > '03-01-2005' and envi_fenvio='05-01-2005'"

	
	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod=3 and envi_fenvio > '02-01-2005' and envi_fenvio<'06-01-2005'"
	  
	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod=3 and envi_fenvio >= '01-01-2005' and envi_fenvio <= '31-01-2005'"
	
	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod=3 and envi_ncorr=751"

    SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod=3 and envi_fenvio >= '01-05-2005' and envi_fenvio <= '31-05-2005'"

    SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod=3 and envi_fenvio >= '09-05-2005' and envi_fenvio <= '31-05-2005'"
    
	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod=3 and envi_fenvio >= '02-05-2005' and envi_fenvio <= '09-05-2005'"

	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod=3 and envi_ncorr in (10221,10223,10225,10226,10228) "
  
	SQL = " select envi_ncorr,eenv_ccod,envi_fenvio from envios " & vbcrlf & _
		  " where eenv_ccod in (2,4) and tenv_ccod=2 and tdep_ccod=3 and envi_ncorr in (10676,10677,10678) "

	f_consulta.Consultar SQL
	
	while f_consulta.Siguiente
		  envio = f_consulta.ObtenerValor("envi_ncorr")
		  
		  sql_limpia= "delete movimiento_cheque_softland where moch_ndeposito="& envio
		  conexion.EjecutaS(sql_limpia)' limpia la tabla de movimientos_cheques antes de insertar
		  
		  sql_insert_efec = "insert into movimiento_cheque_softland " & vbcrlf & _
							  " select  0 as rut_alumno,'DE' as moch_ttipodoc,envi_ncorr,envi_fenvio,'EF' as moch_tdocref, " & vbcrlf & _
							  " 0 	as ding_ndocto,envi_mefectivo,'' as cenc_ccod_softland_simple " & vbcrlf & _
                    		  " from envios where envi_ncorr=" & envio
							  
		  conexion.EjecutaS(sql_insert_efec)' inserta registros en tabla movimientos_cheques		  
	   	  verificador02=TablaAArchivoEfectivo(envio, conexion) 
		  response.Write("Archivo generado : "&envio&"<br>")
		  response.Flush()
	wend


Function TablaAArchivoEfectivo(envi_ncorr, p_conexion) 
	Dim f_consulta
	Dim fso, archivo_salida, o_texto_archivo
	Dim delimitador
	Dim linea
	
	On Error Resume Next	
	
	sql_cta_cte = "SELECT   e.ccte_tcontableasoc   FROM envios a, instituciones_envio c,cuentas_corrientes e  " & vbcrlf & _
			  " WHERE a.inen_ccod = c.inen_ccod  " & vbcrlf & _
			  "	  and a.ccte_ccod = e.ccte_ccod  " & vbcrlf & _
			  "	  and a.envi_ncorr = " & envi_ncorr 
	cta_contable = p_conexion.consultauno(sql_cta_cte)
	'response.Write(suma_depo&","&banc_ccod&","&cta_contable)
	fecha_envio = p_conexion.consultauno("Select envi_fenvio from envios where envi_ncorr="&envi_ncorr)
	glosa_envio = p_conexion.consultauno("Select substring(envi_tdescripcion+'-'+cast(envi_ncorr as varchar),0,60) as aux from envios where envi_ncorr="&envi_ncorr)
	archivo_salida 		= fecha_envio&"_deposito_efec_"&envi_ncorr&".txt"
	'archivo_salida_2 	= v_apoderado&"_"& p_mcaj_ncorr & ".txt"
	'response.Write("archivo salida: "&RUTA_ARCHIVOS_SALIDA_MASIVA & "\" & archivo_salida)
	set fso = Server.CreateObject("Scripting.FileSystemObject")
	set o_texto_archivo = fso.CreateTextFile(RUTA_ARCHIVOS_SALIDA_MASIVA & "\" & archivo_salida)
		
	if Err.Number <> 0 then
			response.Write("error :"&Err.Description):response.Flush()
			TablaAArchivoEfectivo = false
			Exit Function
	end if
	'--------------------------------------------------------------------------------------------------------------
	
	set f_consulta = new CFormulario
	f_consulta.Carga_Parametros "consulta.xml", "consulta"
	f_consulta.Inicializar p_conexion	
	
	'SQL = "select * from traspasos_cajas where mcaj_ncorr = '" & p_mcaj_ncorr & "' order by ingr_nfolio_referencia asc, trca_nlinea asc"	
	SQL = "Select moch_mdocto,protic.trunc(moch_fdeposito) as moch_fdeposito,moch_ndocref from movimiento_cheque_softland where cast(moch_ndeposito as varchar) = '"&envi_ncorr&"' " &vbcrlf&_
       	  " Order by moch_ndocref "
	f_consulta.Consultar SQL
	
	linea = ""
	total_efectivo = 0
	while f_consulta.Siguiente
		linea = cta_contable & "," & f_consulta.ObtenerValor("moch_mdocto") & ",," & glosa_envio & ",1,,,,,,1-01-00009,,,,,,DE," & envi_ncorr & ",,,,,,,,,,,,,,,,,,,,,1"
		o_texto_archivo.WriteLine(linea)
		total_efectivo = clng(total_efectivo) + clng(f_consulta.ObtenerValor("moch_mdocto"))
		'response.Write(linea&"<br>")
	wend
	
	linea = ""
	linea = "1-10-010-10-000001,," & total_efectivo & "," & glosa_envio & ",1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,1"
	o_texto_archivo.WriteLine(linea)
	o_texto_archivo.Close
	'----------------------------------------------------------------------------------------------------------------
	set o_texto_archivo = Nothing
	set fso = Nothing
	set f_consulta = Nothing
	
	TablaAArchivoEfectivo = true
End Function
%>
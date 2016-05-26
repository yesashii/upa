<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_rutas.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

folio=request.QueryString("folio_envio")
set negocio = new CNegocio
negocio.Inicializa conexion

set cajero = new CCajero
cajero.inicializar conexion, negocio.obtenerUsuario, negocio.obtenerSede

'---------------------------------------------------------------------
caja_abierta = cajero.obtenerCajaAbierta
'response.Write("caja:"&caja_abierta)
usuario = negocio.ObtenerUsuario()

v_cajero  = caja_abierta
if v_cajero="" then
	conexion.MensajeError "No existe una caja abierta para procesar las cuotas Transbank"
	response.Redirect(request.ServerVariables("HTTP_REFERER"))
end if

'---------------------------------------------------------------------
		set f_documentos = new CFormulario
		f_documentos.Carga_Parametros "parametros.xml", "tabla"
		
		set formulario = new CFormulario
		formulario.Carga_Parametros "consulta.xml", "consulta"
'---------------------------------------------------------------------
set f_formulario = new CFormulario
f_formulario.Carga_Parametros "depositos_transbank.xml", "f_enviar"
f_formulario.Inicializar conexion
f_formulario.ProcesaForm


for fila = 0 to f_formulario.CuentaPost - 1
   envio = f_formulario.ObtenerValorPost (fila, "envi_ncorr")
   v_estado_envio = f_formulario.ObtenerValorPost (fila, "eenv_ccod")
   if envio <> "" and v_estado_envio=1 then

		
		consulta = "select  c.ingr_ncorr,c.ting_ccod,c.ding_ndocto,g.banc_ccod,c.ding_tcuenta_corriente  " & vbCrLf &_
				" from envios a,detalle_envios b,detalle_ingresos c, " & vbCrLf &_
				" ingresos d,estados_detalle_ingresos c1,bancos g " & vbCrLf &_
				" where a.envi_ncorr = b.envi_ncorr " & vbCrLf &_
				" and b.ting_ccod = c.ting_ccod   " & vbCrLf &_
				" and b.ding_ndocto = c.ding_ndocto   " & vbCrLf &_
				" and b.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_
				" and c.ingr_ncorr = d.ingr_ncorr   " & vbCrLf &_
				" and b.edin_ccod = c1.edin_ccod " & vbCrLf &_
				" and c.banc_ccod *= g.banc_ccod " & vbCrLf &_
				" and c.DING_NCORRELATIVO > 0 " & vbCrLf &_
				" and a.envi_ncorr="&envio
		'---------------------------------------------------------------------
		'" and b.edin_ccod in (1,12) " & vbCrLf &_
		

		formulario.Inicializar conexion
		formulario.consultar consulta

		'response.Write("<br><pre>"&consulta&"</pre><b>estado : " & conexion.ObtenerEstadoTRansaccion & "</b>")  
		while formulario.siguiente
		 'response.Write("<br> Entro")  
		   v_ingr_ncorr   	= 	formulario.ObtenerValor("ingr_ncorr")
		   v_cuenta 		= 	formulario.ObtenerValor("ding_tcuenta_corriente")
		   
		   v_cajero  = caja_abierta
		   if v_cajero="" then
				v_cajero=0
		   end if
		   'response.Write("<br><b>estado : " & conexion.ObtenerEstadoTRansaccion & "</b>") 
		   
		   
		   if esVacio(v_ingr_ncorr) = false then
			'response.Write("<br>No entra")
		   nuevo_folio_referencia = conexion.ConsultaUno("execute obtenersecuencia 'ingresos_referencia'")
		 
			   '---------------- ACTUALIZAR ESTADO DETALLE_INGRESOS = 6 -----------------
			   sql_update = "UPDATE detalle_ingresos "& vbCrLf  &_ 
					 "SET edin_ccod = 6, "& vbCrLf  &_ 
					 "    audi_tusuario = '" & usuario & "', "& vbCrLf  &_ 
					 "    audi_fmodificacion = getdate() "& vbCrLf  &_ 
					 "WHERE ingr_ncorr = "&v_ingr_ncorr 
					
			'response.Write("<br><pre>"&sql_update&"</pre>")
			conexion.EstadoTransaccion conexion.EjecutaS(sql_update)
			   '-------------- aqui pegar info de datos.txt -------------------
				 sql_datos = " select a.ding_tcuenta_corriente, a.ding_nsecuencia, a.ding_ncorrelativo, c.tcom_ccod, c.inst_ccod,"& vbCrLf  &_
					" c.comp_ndocto, c.dcom_ncompromiso, protic.total_recepcionar_cuota(c.tcom_ccod ,c.inst_ccod,c.comp_ndocto,c.dcom_ncompromiso) as abon_mabono, c.pers_ncorr, c.peri_ccod, isnull(b.inem_ccod,0) as inem_ccod "& vbCrLf  &_  
					" from detalle_ingresos a, ingresos b, abonos c "& vbCrLf  &_ 
					" where a.ingr_ncorr = b.ingr_ncorr "& vbCrLf  &_ 
					"  and b.ingr_ncorr = c.ingr_ncorr   "& vbCrLf  &_ 
					"  and a.ingr_ncorr ="& v_ingr_ncorr			


				'response.Write("<br><br><pre>"&sql&"</pre>")  
					f_documentos.Inicializar conexion
					f_documentos.consultar sql_datos
					'--------- POR CADA HERMANO DEL DOCUMENTO -------
			while f_documentos.Siguiente       
				'---------------- NUEVO INGR_NCORR -------------------
			 	nuevo_ingr_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'ingresos'")
				  '------------------------------------------------------------------		  
				 sql = "INSERT INTO ingresos(ingr_ncorr, mcaj_ncorr, eing_ccod, ingr_fpago, ingr_mdocto, ingr_mtotal, ingr_nestado, ingr_nfolio_referencia, ting_ccod, inst_ccod, pers_ncorr,  inem_ccod, audi_tusuario, audi_fmodificacion) "& vbCrLf  &_  
						 "(SELECT " & nuevo_ingr_ncorr & ",'" & v_cajero & "' ,1 , getdate() ,'" &  f_documentos.obtenervalor("abon_mabono") & "','" & f_documentos.obtenervalor("abon_mabono") & "','1'," & nuevo_folio_referencia  & ", 8, '" & f_documentos.obtenervalor("inst_ccod") & "','" & f_documentos.obtenervalor("pers_ncorr") & "','" & f_documentos.obtenervalor("inem_ccod") & "'," & usuario & ", getdate())"& vbCrLf
			
						'response.Write("<br><pre>"&sql&"</pre>")
						conexion.EstadoTransaccion conexion.EjecutaS(sql)						
													
				   sql = "INSERT INTO abonos (ingr_ncorr, tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, abon_fabono, abon_mabono, pers_ncorr, peri_ccod, inem_ccod, audi_tusuario, audi_fmodificacion) "& vbCrLf &_
						  "(SELECT " & nuevo_ingr_ncorr & ",'" & f_documentos.obtenervalor("tcom_ccod") & "','" & f_documentos.obtenervalor("inst_ccod")  & "','" & f_documentos.obtenervalor("comp_ndocto")  & "','"& f_documentos.obtenervalor("dcom_ncompromiso") & "', getdate() ,'" &  f_documentos.obtenervalor("abon_mabono") & "','" & f_documentos.obtenervalor("pers_ncorr") & "','" & f_documentos.obtenervalor("peri_ccod") & "','" & f_documentos.obtenervalor("inem_ccod") & "','" & usuario & "', getdate())"& vbCrLf
						'response.Write("<br><pre>"&sql&"</pre>")		
						conexion.EstadoTransaccion conexion.EjecutaS(sql)
					
					ding_nsecuencia = conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
					sql = "INSERT INTO detalle_ingresos (ingr_ncorr, ting_ccod, ding_ndocto, ding_nsecuencia, ding_ncorrelativo, ding_fdocto, ding_mdetalle, ding_mdocto, ding_tcuenta_corriente, edin_ccod, audi_tusuario, audi_fmodificacion) "& vbCrLf &_
						   "(SELECT " & nuevo_ingr_ncorr & ", 8, '" & f_documentos.obtenervalor("ding_nsecuencia") & "', "&ding_nsecuencia&",'" & f_documentos.obtenervalor("ding_ncorrelativo") & "', getdate() ,'" &  f_documentos.obtenervalor("abon_mabono") & "','" & f_documentos.obtenervalor("abon_mabono") & "','" & v_cuenta & "', 16 ," & usuario & ", getdate())"& vbCrLf
						'response.Write("<br><pre>"&sql&"</pre>")						   
						conexion.EstadoTransaccion conexion.EjecutaS(sql) 
				
			  wend  ' Datos Documentos
			   '-------------- aqui pegar info de datos.txt -------------------			
		  
			   consulta_estado = "UPDATE detalle_envios SET edin_ccod = 6, AUDI_TUSUARIO='" & audi_tusuario  & "', audi_fmodificacion = getdate()  WHERE envi_ncorr='" & envio & "'"
			   conexion.EstadoTransaccion conexion.EjecutaS(consulta_estado)
		  end if 
		  
		wend
	'response.Write("<br><b>estado : " & conexion.ObtenerEstadoTRansaccion & "</b>") 
	 conexion.ConsultaUno("exec guardar_movimientos_pag_trans_softland "&envio)' inserta registros en tabla movimientos_cheques		  
  	 verificador01=TablaAArchivoSoftland(envio, conexion) 
	 'response.Write("exec guardar_movimientos_pag_trans_softland "&envio)
   end if 
next
f_formulario.AgregaCampoPost "eenv_ccod" , 4
f_formulario.MantieneTablas false
'response.Write("<hr><b>estado Final : " & conexion.ObtenerEstadoTRansaccion & "</b>") 
'conexion.EstadoTransaccion false ' esta linea se debe comentar ( O J O )
'response.End()
if conexion.ObtenerEstadoTransaccion then
	session("mensaje_error")="Los documentos fueron conciliados correctamente"
else
	session("mensaje_error")="Ocurrio un error al intentar conciliar los documentos, vuelva a intentarlo."
end if

'response.Write("<br><b>estado : " & conexion.ObtenerEstadoTransaccion & "</b>")  
'conexion.EstadoTransaccion false
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

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
	archivo_salida 		= fecha_envio&"_deposito_tbk_"&envi_ncorr&".txt"
	set fso = Server.CreateObject("Scripting.FileSystemObject")
	set o_texto_archivo = fso.CreateTextFile(RUTA_ARCHIVOS_SALIDA_TARJETA & "\" & archivo_salida)

	
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
	
	'----------------------------------------------------------------------------------------------------------------
	set o_texto_archivo = Nothing
	set fso = Nothing
	set f_consulta = Nothing
	
	TablaAArchivoSoftland = true
	
End Function

%>

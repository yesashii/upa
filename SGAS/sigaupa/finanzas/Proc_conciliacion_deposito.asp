<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_rutas.asp" -->
<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:GESTIÓN DE DOCUMENTOS
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:28/03/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:108
'*******************************************************************
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
'---------------------------------------------------------------------


'---------------------------------------------------------------------
set f_documentos = new CFormulario
f_documentos.Carga_Parametros "parametros.xml", "tabla"

set formulario = new CFormulario
formulario.Carga_Parametros "consulta.xml", "consulta"

set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
f_consulta.Inicializar conexion
'-----------------------------------------------------------------------------		 
set f_formulario = new CFormulario
f_formulario.Carga_Parametros "Depositos.xml", "f_depositar"
f_formulario.Inicializar conexion
f_formulario.ProcesaForm

'response.Write("<hr> <h3>esta pagina esta siendo depurada, intente su operacion en algunos segundos mas...</h3> <hr>")
'response.end()
for fila = 0 to f_formulario.CuentaPost - 1
   	envio = f_formulario.ObtenerValorPost (fila, "envi_ncorr")
   	v_estado_envio = f_formulario.ObtenerValorPost (fila, "eenv_ccod")
	v_estado_envio=2
	
	if envio <> "" and v_estado_envio=2 then
	 'response.Write("<hr>"&v_estado_envio&"<->"&envio&"<hr>")	
		   SQL = "select count(a.envi_ncorr) as total_doc from envios a,  detalle_envios b where a.envi_ncorr = b.envi_ncorr "&_  
            "and cast(a.envi_ncorr as varchar)='" & envio & "'"
	   	 

	   f_consulta.consultar  SQL
	   f_consulta.siguiente
	   cantidad = f_consulta.ObtenerValor("total_doc") 

 		sql_tipo="select tdep_ccod from envios a where cast(a.envi_ncorr as varchar)='" & envio & "'"
	  	v_tipo_deposito=conexion.consultaUno(sql_tipo)

	  if cantidad > 0 or v_tipo_deposito="3" then
	   
		  sql_tipo="select tdep_ccod from envios a where cast(a.envi_ncorr as varchar)='" & envio & "'"
		  v_tipo_deposito=conexion.consultaUno(sql_tipo)
	
'			consulta = "select  c.ingr_ncorr,c.ting_ccod,c.ding_ndocto,g.banc_ccod,c.ding_tcuenta_corriente  " & vbCrLf &_
'					" from envios a,detalle_envios b,detalle_ingresos c, " & vbCrLf &_
'					" ingresos d,estados_detalle_ingresos c1,bancos g " & vbCrLf &_
'					" where a.envi_ncorr = b.envi_ncorr " & vbCrLf &_
'					" and b.ting_ccod = c.ting_ccod   " & vbCrLf &_
'					" and b.ding_ndocto = c.ding_ndocto   " & vbCrLf &_
'					" and b.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_
'					" and c.ingr_ncorr = d.ingr_ncorr   " & vbCrLf &_
'					" and b.edin_ccod = c1.edin_ccod " & vbCrLf &_
'					" and c.banc_ccod *= g.banc_ccod " & vbCrLf &_
'					" and c.DING_NCORRELATIVO = 1 " & vbCrLf &_
'					" and c.edin_ccod not in (6,9) " & vbCrLf &_
'					" and protic.documento_pagado_x_otro(c.ingr_ncorr,isnull(c.ding_bpacta_cuota,'N'),'P') = 0 "& vbCrLf  &_
'					" and a.envi_ncorr="&envio

			consulta = "select  c.ingr_ncorr,c.ting_ccod,c.ding_ndocto,g.banc_ccod,c.ding_tcuenta_corriente  " & vbCrLf &_
					" from envios a " & vbCrLf &_
					" INNER JOIN detalle_envios b " & vbCrLf &_
					" ON a.envi_ncorr = b.envi_ncorr and a.envi_ncorr = "&envio&" " & vbCrLf &_
					" INNER JOIN detalle_ingresos c " & vbCrLf &_
					" ON b.ting_ccod = c.ting_ccod " & vbCrLf &_
					" and b.ding_ndocto = c.ding_ndocto " & vbCrLf &_
					" and b.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_
					" and c.DING_NCORRELATIVO = 1 " & vbCrLf &_
					" and c.edin_ccod not in (6,9) " & vbCrLf &_
					" and protic.documento_pagado_x_otro(c.ingr_ncorr,isnull(c.ding_bpacta_cuota,'N'),'P') = 0 " & vbCrLf &_
					" INNER JOIN ingresos d " & vbCrLf &_
					" ON c.ingr_ncorr = d.ingr_ncorr " & vbCrLf &_
					" INNER JOIN estados_detalle_ingresos c1 " & vbCrLf &_
					" ON b.edin_ccod = c1.edin_ccod " & vbCrLf &_
					" LEFT OUTER JOIN bancos g " & vbCrLf &_
					" ON c.banc_ccod = g.banc_ccod "
					
				formulario.Inicializar conexion
				formulario.consultar consulta
	
	 
			while formulario.siguiente
			   'response.Write("<hr>")
			   tipo_ingreso =   formulario.ObtenerValor("ting_ccod")
			   num_doc = formulario.ObtenerValor("ding_ndocto")
			   banco   = formulario.ObtenerValor("banc_ccod")
			   cuenta = formulario.ObtenerValor("ding_tcuenta_corriente")
			   
			   v_ingr_ncorr   	= 	formulario.ObtenerValor("ingr_ncorr")
			   v_cuenta 		= 	formulario.ObtenerValor("ding_tcuenta_corriente")
			
			   
			   v_cajero  = caja_abierta
			   if v_cajero="" then
					v_cajero=0
			   end if
			  ' response.Write("<br>tipo_ingreso "&tipo_ingreso&" num_doc "&num_doc&" banco "&banco&" cuenta "& cuenta &" cajero "&cajero)
			   
			   if esVacio(num_doc) = false then
			
			   nuevo_folio_referencia = conexion.ConsultaUno("execute obtenersecuencia 'ingresos_referencia'")
			 
				  
				   
				   '-------------- BUSCO HERMANOS DEL DOCUMENTO -------------------
				
					 sql_datos = " select a.ding_tcuenta_corriente, a.ding_nsecuencia, a.ding_ncorrelativo, c.tcom_ccod, c.inst_ccod,"& vbCrLf  &_
						" c.comp_ndocto, c.dcom_ncompromiso, c.abon_mabono, c.pers_ncorr, c.peri_ccod, isnull(b.inem_ccod,0) as inem_ccod"& vbCrLf  &_  
						" from detalle_ingresos a, ingresos b, abonos c "& vbCrLf  &_ 
						" where a.ingr_ncorr = b.ingr_ncorr "& vbCrLf  &_ 
						"  and b.ingr_ncorr = c.ingr_ncorr   "& vbCrLf  &_ 
						"  and a.ding_ncorrelativo > 0   "& vbCrLf  &_ 
						"  and a.edin_ccod not in (6,8) "& vbCrLf  &_
						"  and a.ting_ccod = '" & tipo_ingreso & "'  "& vbCrLf  &_
						"  and b.eing_ccod not in (3,6) "& vbCrLf  &_ 
						"  and a.ding_ndocto = '" & num_doc & "' "& vbCrLf  &_ 
						"  and ISNULL(cast(a.banc_ccod AS varchar), '') = '" & banco & "' "& vbCrLf  &_ 
						"  and ISNULL(cast(a.ding_tcuenta_corriente AS varchar), '') = '" & cuenta & "'" 			
	
	'response.Write("<br><pre>"&sql_datos&"</pre>")
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
								   "(SELECT " & nuevo_ingr_ncorr & ", 8, '" & f_documentos.obtenervalor("ding_nsecuencia") & "', "&ding_nsecuencia&",'" & f_documentos.obtenervalor("ding_ncorrelativo") & "', getdate() ,'" &  f_documentos.obtenervalor("abon_mabono") & "','" & f_documentos.obtenervalor("abon_mabono") & "','" & cuenta & "', 16 ," & usuario & ", getdate())"& vbCrLf
								'response.Write("<br><pre>"&sql&"</pre>")						   
								conexion.EstadoTransaccion conexion.EjecutaS(sql) 
								
					'response.Write("<br><b>estado : " & conexion.ObtenerEstadoTRansaccion & "</b>")
				  wend  ' FIN DE WHILE HERMANOS
				   consulta_estado = "UPDATE detalle_envios SET edin_ccod = 6, AUDI_TUSUARIO='" & audi_tusuario  & "', audi_fmodificacion = getdate()  WHERE envi_ncorr='" & envio & "'"
				   conexion.EstadoTransaccion conexion.EjecutaS(consulta_estado)
				
				 '---------------- ACTUALIZAR ESTADO DETALLE_INGRESOS = 6 -----------------
				   sql_update = "UPDATE detalle_ingresos "& vbCrLf  &_ 
						 "SET edin_ccod = 6, "& vbCrLf  &_ 
						 "    audi_tusuario = '" & usuario & "', "& vbCrLf  &_ 
						 "    audi_fmodificacion = getdate() "& vbCrLf  &_ 
						 " WHERE ding_ncorrelativo > 0   "& vbCrLf  &_ 
						 "  and ting_ccod = '" & tipo_ingreso & "'  "& vbCrLf  &_ 
						 "  and ding_ndocto = '" & num_doc & "' "& vbCrLf  &_ 
						 "  and ISNULL(cast(banc_ccod AS varchar), '') = '" & banco & "' "& vbCrLf  &_ 
						 "  and ISNULL(cast(ding_tcuenta_corriente AS varchar), '')= '" & cuenta & "' "& vbCrLf 
				
				 conexion.EstadoTransaccion conexion.EjecutaS(sql_update)
				 
			  end if 
			  
			wend
	
			if v_tipo_deposito ="3" then ' DEPOSITO EN EFECTIVO
				' se inserta registro en movimiento_cheque_softland necesario para generar archivo para softland
				sql_insert_efec = "" & vbcrlf & _
						"insert into movimiento_cheque_softland " & vbcrlf & _
						"select 0    as rut_alumno,             " & vbcrlf & _
						"       'DE' as moch_ttipodoc,          " & vbcrlf & _
						"       envi_ncorr,                     " & vbcrlf & _
						"       envi_fenvio,                    " & vbcrlf & _
						"       'EF' as moch_tdocref,           " & vbcrlf & _
						"       0    as ding_ndocto,            " & vbcrlf & _
						"       envi_mefectivo,                 " & vbcrlf & _
						"       '' as cenc_ccod_softland_simple " & vbcrlf & _
						"from   envios                          " & vbcrlf & _
						"where  envi_ncorr=" & envio
				
				conexion.EstadoTransaccion conexion.EjecutaS(sql_insert_efec)							  
				verificador02=TablaAArchivoEfectivo(envio, conexion)' se genera archivo para deposito efectivo SOFTLAND 
			else
				conexion.ConsultaUno("exec guardar_movimiento_cheque_softland "&envio)' inserta registros en tabla movimiento_cheque_softland
				verificador01=TablaAArchivoSoftland(envio, conexion) 
			end if
		else
			
			error_vacio="Uno o mas depositos seleccionados no contenian documentos asociados \n"
			conexion.EstadoTransaccion false
		end if
   end if 
next

if error_vacio="" then
	f_formulario.AgregaCampoPost "eenv_ccod" , 4
	f_formulario.MantieneTablas FALSE
end if

if conexion.ObtenerEstadoTransaccion then
	session("mensaje_error")="Los documentos fueron conciliados correctamente"
else
	session("mensaje_error")=error_vacio&"Ocurrio un error al intentar conciliar los documentos, vuelva a intentarlo."
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
	cta_contable = p_conexion.consultauno(sql_cta_cte)
	fecha_envio = p_conexion.consultauno("Select replace(protic.trunc(envi_fenvio),'/','-') from envios where envi_ncorr="&envi_ncorr)
	glosa_envio = p_conexion.consultauno("Select substring(envi_tdescripcion+'-'+cast(envi_ncorr as varchar),0,60) as aux from envios where envi_ncorr="&envi_ncorr)
	archivo_salida 		= fecha_envio&"_deposito_"&envi_ncorr&".txt"
	set fso = Server.CreateObject("Scripting.FileSystemObject")
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
	
	SQL = "" &vbcrlf&_
	"select moch_mdocto,                                       " &vbcrlf&_
	"       protic.trunc(moch_fdeposito) as moch_fdeposito,    " &vbcrlf&_
	"       moch_ndocref,                                      " &vbcrlf&_
	"       moch_tdocref,                                      " &vbcrlf&_
	"       moch_cenc_ccod_softland,                           " &vbcrlf&_
	"       moch_nrutalumno                                    " &vbcrlf&_
	"from   movimiento_cheque_softland                         " &vbcrlf&_
	"where  Cast(moch_ndeposito as varchar) = '"&envi_ncorr&"' " &vbcrlf&_
	"order  by moch_ndocref 								   "
	'response.write("aca")
	'response.end()
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
	agrupacion = 1
	suma_cuotas = 0
	diferencia = 0
	
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

	fecha_envio = p_conexion.consultauno("Select replace(protic.trunc(envi_fenvio),'/','-') from envios where envi_ncorr="&envi_ncorr)
	glosa_envio = p_conexion.consultauno("Select substring(envi_tdescripcion+'-'+cast(envi_ncorr as varchar),0,60) as aux from envios where envi_ncorr="&envi_ncorr)
	archivo_salida 		= fecha_envio&"_deposito_efec_"&envi_ncorr&".txt"

	set fso = Server.CreateObject("Scripting.FileSystemObject")
'response.Write(RUTA_ARCHIVOS_SALIDA_SOFTLAND01 & "\" & archivo_salida)
'response.Flush()
	set o_texto_archivo = fso.CreateTextFile(RUTA_ARCHIVOS_SALIDA_SOFTLAND01 & "\" & archivo_salida)
		
	if Err.Number <> 0 then
			response.Write("error :"&Err.Description):response.Flush()
			TablaAArchivoEfectivo = false
			Exit Function
	end if
	'--------------------------------------------------------------------------------------------------------------
	
	set f_consulta = new CFormulario
	f_consulta.Carga_Parametros "consulta.xml", "consulta"
	f_consulta.Inicializar p_conexion	
	
	SQL = "Select moch_mdocto,protic.trunc(moch_fdeposito) as moch_fdeposito,moch_ndocref from movimiento_cheque_softland where cast(moch_ndeposito as varchar) = '"&envi_ncorr&"' " &vbcrlf&_
       	  " Order by moch_ndocref "
	f_consulta.Consultar SQL
	
	linea = ""
	total_efectivo = 0
	while f_consulta.Siguiente
		linea = cta_contable & "," & f_consulta.ObtenerValor("moch_mdocto") & ",," & glosa_envio & ",1,,,,,,1-01-00009,,,,,,DE," & envi_ncorr & ",,,,,,,,,,,,,,,,,,,,,1"
		o_texto_archivo.WriteLine(linea)
		total_efectivo = clng(total_efectivo) + clng(f_consulta.ObtenerValor("moch_mdocto"))
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

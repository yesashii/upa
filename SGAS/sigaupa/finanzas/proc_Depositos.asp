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
'LINEA			:96
'*******************************************************************
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new Cnegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
f_consulta.Inicializar conexion
'---------------------------------------------------------------------

set f_documentos = new CFormulario
f_documentos.Carga_Parametros "tabla_vacia.xml", "tabla"
'-----------------------------------------------------------------------
set formulario_origen = new CFormulario
formulario_origen.Carga_Parametros "consulta.xml", "consulta"
'------------------------------------------------------------------------


audi_tusuario = negocio.ObtenerUsuario

set formulario = new CFormulario
formulario.Carga_Parametros "Depositos.xml", "f_depositar"
formulario.Inicializar conexion
formulario.ProcesaForm
formulario.AgregaCampoPost "eenv_ccod" , 2

for fila = 0 to formulario.CuentaPost - 1
   envio = formulario.ObtenerValorPost (fila, "envi_ncorr")
   if envio <> "" then
   
   	  sql_tipo="select tdep_ccod from envios a where cast(a.envi_ncorr as varchar)='" & envio & "'"
	  v_tipo_deposito=conexion.consultaUno(sql_tipo)
      
	   SQL = "select count(a.envi_ncorr) as total_doc from envios a,  detalle_envios b where a.envi_ncorr = b.envi_ncorr "&_  
            "and cast(a.envi_ncorr as varchar)='" & envio & "'"
	   
	   f_consulta.consultar  SQL
	   f_consulta.siguiente
	   cantidad = f_consulta.ObtenerValor("total_doc") 
	   
	   if cantidad <> 0 then
	 
	 	  consulta = "UPDATE detalle_envios SET edin_ccod = 12, AUDI_TUSUARIO='" & audi_tusuario  & "', audi_fmodificacion = getDate()  WHERE cast(envi_ncorr as varchar)='" & envio & "'"
          conexion.EstadoTransaccion conexion.EjecutaS(consulta)
		  
		  '#####################################################################################################
		  '#################	Marcar todos como depositados. cheque correlativo 1 y sus hermanos    ##########
		  
'		  consulta_origen = "select  c.ingr_ncorr,c.ting_ccod,c.ding_ndocto,g.banc_ccod,c.ding_tcuenta_corriente  " & vbCrLf &_
'							" from envios a,detalle_envios b,detalle_ingresos c, ingresos d,bancos g " & vbCrLf &_
'							" where a.envi_ncorr = b.envi_ncorr " & vbCrLf &_
'							" and b.ting_ccod = c.ting_ccod   " & vbCrLf &_
'							" and b.ding_ndocto = c.ding_ndocto   " & vbCrLf &_
'							" and b.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_
'							" and c.ingr_ncorr = d.ingr_ncorr   " & vbCrLf &_
'							" and c.banc_ccod *= g.banc_ccod " & vbCrLf &_
'							" and c.DING_NCORRELATIVO = 1 " & vbCrLf &_
'							" and c.edin_ccod not in (9) " & vbCrLf &_
'							" and a.envi_ncorr="&envio

		  consulta_origen = "select  c.ingr_ncorr,c.ting_ccod,c.ding_ndocto,g.banc_ccod,c.ding_tcuenta_corriente  " & vbCrLf &_
							" from envios a " & vbCrLf &_
							" INNER JOIN detalle_envios b " & vbCrLf &_
							" ON a.envi_ncorr = b.envi_ncorr and a.envi_ncorr = "&envio&" " & vbCrLf &_
							" INNER JOIN detalle_ingresos c " & vbCrLf &_
							" ON b.ting_ccod = c.ting_ccod " & vbCrLf &_
							" and b.ding_ndocto = c.ding_ndocto " & vbCrLf &_
							" and b.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_
							" and c.DING_NCORRELATIVO = 1 " & vbCrLf &_
							" and c.edin_ccod not in (9) " & vbCrLf &_
							" INNER JOIN ingresos d " & vbCrLf &_
							" ON c.ingr_ncorr = d.ingr_ncorr " & vbCrLf &_
							" LEFT OUTER JOIN bancos g " & vbCrLf &_
							" ON c.banc_ccod = g.banc_ccod "
				
			formulario_origen.Inicializar conexion
			formulario_origen.consultar consulta_origen

 
		while formulario_origen.siguiente
				'response.Write("<br><pre>"&consulta_origen&"</pre>")	

		   tipo_ingreso =   formulario_origen.ObtenerValor("ting_ccod")
		   num_doc 		= 	formulario_origen.ObtenerValor("ding_ndocto")
		   banco   		= 	formulario_origen.ObtenerValor("banc_ccod")
		   cuenta 		= 	formulario_origen.ObtenerValor("ding_tcuenta_corriente")
		   
		   if esVacio(num_doc) = false then
		
			   '-------------- BUSCO HERMANOS DEL DOCUMENTO -------------------
				 sql_datos = " select a.ingr_ncorr,a.ding_tcuenta_corriente, a.ding_nsecuencia, a.ding_ncorrelativo, c.tcom_ccod, c.inst_ccod,"& vbCrLf  &_
							" c.comp_ndocto, c.dcom_ncompromiso, c.abon_mabono, c.pers_ncorr, c.peri_ccod, isnull(b.inem_ccod,0) as inem_ccod"& vbCrLf  &_  
							" from detalle_ingresos a, ingresos b, abonos c "& vbCrLf  &_ 
							" where a.ingr_ncorr = b.ingr_ncorr "& vbCrLf  &_ 
							"  and b.ingr_ncorr = c.ingr_ncorr   "& vbCrLf  &_ 
							"  and a.ding_ncorrelativo > 0   "& vbCrLf  &_ 
							"  and a.edin_ccod not in (6) "& vbCrLf  &_
							"  and a.ting_ccod = '" & tipo_ingreso & "'  "& vbCrLf  &_
							"  and b.eing_ccod not in (3,6) "& vbCrLf  &_ 
							"  and a.ding_ndocto = '" & num_doc & "' "& vbCrLf  &_ 
							"  and ISNULL(cast(a.banc_ccod AS varchar), '') = '" & banco & "' "& vbCrLf  &_ 
							"  and ISNULL(cast(a.ding_tcuenta_corriente AS varchar), '') = '" & cuenta & "'" 			

					f_documentos.Inicializar conexion
					f_documentos.consultar sql_datos
		 
			  '--------- POR CADA HERMANO DEL DOCUMENTO -------
			  while f_documentos.Siguiente       
					'response.Write("<br><pre>"&sql_datos&"</pre>")	
					v_ingreso_hermano=f_documentos.obtenervalor("ingr_ncorr")
					consulta_hmno = "UPDATE detalle_ingresos SET edin_ccod = 12, AUDI_TUSUARIO='" & audi_tusuario  & "', audi_fmodificacion = getDate()  WHERE edin_ccod not in (6,12) and cast(ingr_ncorr as varchar)='" & v_ingreso_hermano & "'"
          			'response.Write("<br><pre>"&consulta_hmno&"</pre>")	
					conexion.EstadoTransaccion conexion.EjecutaS(consulta_hmno)
							
			  wend  ' FIN DE WHILE HERMANOS
			
			end if 
			
		 wend 
		  '##############################################################################################
		  
		  consulta = "UPDATE detalle_ingresos SET edin_ccod = 12, AUDI_TUSUARIO='" & audi_tusuario  & "', audi_fmodificacion = getDate()  WHERE edin_ccod not in (6,12) and cast(envi_ncorr as varchar)='" & envio & "'"
          conexion.EstadoTransaccion conexion.EjecutaS(consulta)
		  
		  conexion.ConsultaUno("exec guardar_movimiento_cheque_softland "&envio)' inserta registros en tabla movimiento_cheque_softland
		  verificador01=TablaAArchivoSoftland(envio, conexion) 
		  
		  sql_actualiza_efec="update ENVIOS set EENV_CCOD = 2, AUDI_FMODIFICACION = getdate(), AUDI_TUSUARIO='" & audi_tusuario  & "' WHERE cast(envi_ncorr as varchar)='" & envio & "'"
		  conexion.EstadoTransaccion conexion.EjecutaS(sql_actualiza_efec)

	   end if

		if v_tipo_deposito ="3" then ' DEPOSITO EN EFECTIVO
			
			' se inserta registro en movimiento_cheque_softland necesario para generar archivo para softland
			sql_insert_efec = "insert into movimiento_cheque_softland " & vbcrlf & _
							  " select  0 as rut_alumno,'DE' as moch_ttipodoc,envi_ncorr,envi_fenvio,'EF' as moch_tdocref, " & vbcrlf & _
							  " 0 	as ding_ndocto,envi_mefectivo,'' as cenc_ccod_softland_simple " & vbcrlf & _
                    		  " from envios where envi_ncorr=" & envio
			
			conexion.EstadoTransaccion conexion.EjecutaS(sql_insert_efec)							  
			verificador02=TablaAArchivoEfectivo(envio, conexion)' se genera archivo para deposito efectivo SOFTLAND 
			
			sql_actualiza_efec="update ENVIOS set EENV_CCOD = 2, AUDI_FMODIFICACION = getdate(), AUDI_TUSUARIO='" & audi_tusuario  & "' WHERE cast(envi_ncorr as varchar)='" & envio & "'"
		  	conexion.EstadoTransaccion conexion.EjecutaS(sql_actualiza_efec)
		end if
	end if 
	
  next
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
	fecha_envio = p_conexion.consultauno("Select envi_fenvio from envios where envi_ncorr="&envi_ncorr)
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

	fecha_envio = p_conexion.consultauno("Select envi_fenvio from envios where envi_ncorr="&envi_ncorr)
	glosa_envio = p_conexion.consultauno("Select substring(envi_tdescripcion+'-'+cast(envi_ncorr as varchar),0,60) as aux from envios where envi_ncorr="&envi_ncorr)
	archivo_salida 		= fecha_envio&"_deposito_efec_"&envi_ncorr&".txt"

	set fso = Server.CreateObject("Scripting.FileSystemObject")
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
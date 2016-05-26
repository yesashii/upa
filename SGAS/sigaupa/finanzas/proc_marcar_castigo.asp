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
'LINEA			:98
'*******************************************************************
set conexion = new CConexion
conexion.Inicializar "upacifico"

folio=request.QueryString("folio_envio")
set negocio = new CNegocio
negocio.Inicializa conexion

'for each x in request.Form
'	response.Write("<br>clave:"&x&"->"&request.Form(x))
'next
'response.End()

'set cajero = new CCajero
'cajero.inicializar conexion, negocio.obtenerUsuario, negocio.obtenerSede

'---------------------------------------------------------------------
'caja_abierta = cajero.obtenerCajaAbierta
'response.Write("caja:"&caja_abierta)
usuario = negocio.ObtenerUsuario()

'v_cajero  = caja_abierta
'if v_cajero="" then
'	conexion.MensajeError "No existe una caja abierta para procesar las cuotas Transbank"
'	response.Redirect(request.ServerVariables("HTTP_REFERER"))
'end if

'-----------------------------------------------------------------------
set f_documentos = new CFormulario
f_documentos.Carga_Parametros "tabla_vacia.xml", "tabla"

set formulario_origen = new CFormulario
formulario_origen.Carga_Parametros "consulta.xml", "consulta"
'------------------------------------------------------------------------

'---------------------------------------------------------------------
set f_formulario = new CFormulario
f_formulario.Carga_Parametros "castigos_documentos.xml", "f_enviar"
f_formulario.Inicializar conexion
f_formulario.ProcesaForm


for fila = 0 to f_formulario.CuentaPost - 1
   envio = f_formulario.ObtenerValorPost (fila, "envi_ncorr")
   v_estado_envio = f_formulario.ObtenerValorPost (fila, "eenv_ccod")
   if envio <> "" and v_estado_envio=1 then
		   
	'---------------- ACTUALIZAR ESTADO DOCTO EN DETALLE_INGRESOS Y DETALLE_ENVIOS  55=castigado -----------------
	
	consulta_estado 	= "UPDATE detalle_envios SET edin_ccod = 55, audi_tusuario='" & audi_tusuario  & "', audi_fmodificacion = getdate()  WHERE envi_ncorr='" & envio & "'"
	conexion.EstadoTransaccion conexion.EjecutaS(consulta_estado)
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
		   
		   if esVacio(num_doc) = false and tipo_ingreso <> "4" then
		
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
					consulta_hmno = "UPDATE detalle_ingresos SET edin_ccod = 55, AUDI_TUSUARIO='" & audi_tusuario  & "', audi_fmodificacion = getDate()  WHERE edin_ccod not in (6,12) and cast(ingr_ncorr as varchar)='" & v_ingreso_hermano & "'"
          			'response.Write("<br><pre>"&consulta_hmno&"</pre>")	
					conexion.EstadoTransaccion conexion.EjecutaS(consulta_hmno)
							
			  wend  ' FIN DE WHILE HERMANOS
			
			end if 
			
		 wend 
		  '##############################################################################################
' actualiza todo lo que no sea cheque
		sql_update 		= "UPDATE detalle_ingresos SET edin_ccod = 55, audi_tusuario = '" & usuario & "',  audi_fmodificacion = getdate() WHERE envi_ncorr='" & envio & "' and ting_ccod not in (3,14,38)"
		conexion.EstadoTransaccion conexion.EjecutaS(sql_update)
		'response.Write("<br><pre>"&sql_update&"</pre>")


	conexion.ConsultaUno("exec guardar_movimiento_castigos_softland "&envio)' inserta registros en tabla movimientos_castigos		  
	verificador01=TablaAArchivoSoftland(envio, conexion) 

   end if 
next

f_formulario.AgregaCampoPost "eenv_ccod" , 5
f_formulario.MantieneTablas false

if conexion.ObtenerEstadoTransaccion then
	session("mensaje_error")="Los documentos fueron castigados correctamente"
else
	session("mensaje_error")="Ocurrio un error al intentar castigar los documentos, vuelva a intentarlo."
end if


response.Redirect(Request.ServerVariables("HTTP_REFERER"))

Function TablaAArchivoSoftland(envi_ncorr, p_conexion)
	Dim f_consulta
	Dim fso, archivo_salida, o_texto_archivo
	Dim delimitador
	Dim linea
	
	On Error Resume Next	
	
	
	
	'sql_suma_dep = "Select sum(moch_mdocto) as sum_dep from movimiento_cheque_softland where moch_ndeposito=" & envi_ncorr
	'suma_depo = p_conexion.consultauno(sql_suma_dep)
	'cta_contable="1-10-010-10-000001" ' correcion cajas suplementarias pagares Transbank (va contra Efectivo)
	
	
	fecha_envio = p_conexion.consultauno("Select replace(protic.trunc(envi_fenvio),'/','-') from envios where envi_ncorr="&envi_ncorr)
	glosa_envio = p_conexion.consultauno("Select substring('Castigo de Documentos'+'-'+cast(envi_ncorr as varchar),0,60) as aux from envios where envi_ncorr="&envi_ncorr)
	archivo_salida 		= fecha_envio&"_deposito_castigo_"&envi_ncorr&".txt"
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
	
	SQL = "Select b.ting_cuenta_softland,moch_mdocto,protic.trunc(moch_fdeposito) as moch_fdeposito, " &vbcrlf&_
			" moch_ndocref,moch_tdocref,moch_cenc_ccod_softland,moch_nrutalumno, " &vbcrlf&_
			" protic.trunc(fecha_pago) as pago,protic.trunc(fecha_vencimiento) as vencimiento " &vbcrlf&_
			" from movimiento_castigos_softland a, tipos_ingresos b " &vbcrlf&_
			" where cast(moch_ndeposito as varchar) = '"&envi_ncorr&"' " &vbcrlf&_
			" and a.moch_tdocref=b.ting_tipos_softland "	&vbcrlf&_		
			" and ting_ccod not in (39) " &vbcrlf&_
       	  	" Order by moch_ndocref "
	f_consulta.Consultar SQL
	
	'linea = ""
	
	'######## cuenta caja , no lleva atributos ################
	'linea = cta_contable & "," & suma_depo & ",," & glosa_envio & ",1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,1"
	'o_texto_archivo.WriteLine(linea)

	linea = ""

	cont_lineas = 1
	agrupacion = 1
	suma_cuotas = 0
	diferencia = 0
	
	while f_consulta.Siguiente
		if 	cont_lineas = 49 then
			'cont_lineas = 1
			'linea = ""
			'diferencia = clng(suma_depo) - clng(suma_cuotas)
			
			''response.Flush()
			'linea = "9-10-010-10-000001,," & diferencia & "," & glosa_envio & ",1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,," & agrupacion
			'o_texto_archivo.WriteLine(linea)
			'agrupacion = agrupacion +1
			'linea = "9-10-010-10-000001," & diferencia & ",," & glosa_envio & ",1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,," & agrupacion
			'o_texto_archivo.WriteLine(linea)
			''response.Write("dif :" & diferencia & " = " & cint(suma_depo) & "-" & cint(suma_cuotas) & "<br>")
		end if
		
		
		suma_cuotas = clng(suma_cuotas) + clng(f_consulta.ObtenerValor("moch_mdocto"))
		'response.Write("suma cuota :" & suma_cuotas & "<br>")
		tipo_tarjeta = f_consulta.ObtenerValor("moch_tdocref")
		linea = ""
		'######################################
		'************ HABER ****************
		linea = linea & ""&f_consulta.ObtenerValor("ting_cuenta_softland")&"-999999," &f_consulta.ObtenerValor("moch_mdocto")& ",," & glosa_envio & "" 
		linea = linea & ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,," & cont_lineas
		o_texto_archivo.WriteLine(linea)
		
		'######################################
		'************ HABER ****************
		linea2=""
		linea2 = linea2 & ""&f_consulta.ObtenerValor("ting_cuenta_softland")&"-"&f_consulta.ObtenerValor("moch_cenc_ccod_softland")& ",," & f_consulta.ObtenerValor("moch_mdocto") 
		linea2 = linea2 & "," & glosa_envio & ",,,,,,,,,,,,,,," & f_consulta.ObtenerValor("moch_nrutalumno") & ",CA," & f_consulta.ObtenerValor("moch_ndocref") & "," & f_consulta.ObtenerValor("pago") 
		linea2 = linea2 & "," & f_consulta.ObtenerValor("vencimiento") & "," & f_consulta.ObtenerValor("moch_tdocref") & "," & f_consulta.ObtenerValor("moch_ndocref") 
		linea2 = linea2 & ",,,,,,,,,,,,,," & cont_lineas
		o_texto_archivo.WriteLine(linea2)
		'response.Write(linea&"<br>")
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

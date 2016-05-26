<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_rutas.asp" -->

<%
Server.ScriptTimeout = 2000 
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario = negocio.ObtenerUsuario


'------------------------------------------------------------------------------------
Function TablaAArchivo(p_mcaj_ncorr, p_conexion)
	Dim f_consulta
	Dim fso, archivo_salida, o_texto_archivo
	Dim delimitador
	Dim linea
	
	On Error Resume Next	
	
sql_nombre= " Select SUBSTRING(per.pers_tnombre, 1, 1)+''+per.pers_tape_paterno+'_'+per.pers_tape_materno+'_'+cast(day(mc.mcaj_finicio) as varchar)+'-'+cast(month(mc.mcaj_finicio)as varchar)+'-'+cast(year(mc.mcaj_finicio)as varchar) as nombre "& vbCrLf &_
			" From cajeros caj , personas per ,movimientos_cajas mc "& vbCrLf &_
			" where caj.pers_ncorr=per.pers_ncorr "& vbCrLf &_
			" and mc.caje_ccod=caj.caje_ccod "& vbCrLf &_
			" and mc.mcaj_ncorr='"&p_mcaj_ncorr&"'"
'response.Write("<pre>"&sql_nombre&"</pre>")
'response.End()
	
	v_nombre_cajero	=	p_conexion.ConsultaUno(sql_nombre)
	v_apoderado		=	"aux"
	archivo_salida 		= v_nombre_cajero&"_"& p_mcaj_ncorr & ".txt"
	archivo_salida_2 	= v_apoderado&"_"& p_mcaj_ncorr & ".txt"
	'response.Write("archivo salida: "&RUTA_ARCHIVOS_SALIDA & "\" & archivo_salida)
	set fso = Server.CreateObject("Scripting.FileSystemObject")
	set o_texto_archivo = fso.CreateTextFile(RUTA_ARCHIVOS_SALIDA_SOFTLAND & "\anulaciones\" & archivo_salida)
	' segundo archivo datos apoderado
	set fso2 = Server.CreateObject("Scripting.FileSystemObject")
	set o_texto_archivo_2 = fso2.CreateTextFile(RUTA_ARCHIVOS_SALIDA_SOFTLAND & "\anulaciones\" & archivo_salida_2)

	
	if Err.Number <> 0 then
			response.Write("error :"&Err.Description):response.Flush()
			TablaAArchivo = false
			Exit Function
	end if
	'--------------------------------------------------------------------------------------------------------------
	
	set f_consulta = new CFormulario
	f_consulta.Carga_Parametros "consulta.xml", "consulta"
	f_consulta.Inicializar p_conexion	
	
	SQL = 	"Select protic.trunc(TSOF_FECHA_EMISION) as TSOF_FECHA_EMISION_CORTA," & vbCrLf &_
			" protic.trunc(TSOF_FECHA_VENCIMIENTO) as TSOF_FECHA_VENCIMIENTO_CORTA, * "& vbCrLf &_
			" From traspasos_cajas_softland where mcaj_ncorr = '" & p_mcaj_ncorr & "' order by ting_ccod desc, ingr_nfolio_referencia asc, tsof_nro_agrupador, trca_nlinea asc"	
	f_consulta.Consultar SQL
	
	
	while f_consulta.Siguiente
		linea = ""

		
		
		linea = linea & f_consulta.ObtenerValor("tsof_plan_cuenta") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("tsof_debe") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_HABER") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_GLOSA") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_EQUIVALENCIA") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_DEBE_ADICIONAL") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_HABER_ADICIONAL") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_COD_CONDICION_VENTA") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_COD_VENDEDOR") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_COD_UBICACION") & DELIMITADOR_CAMPOS_SOFT		
		linea = linea & f_consulta.ObtenerValor("TSOF_COD_CONCEPTO_CAJA") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_COD_INSTRUMENTO_FINAN") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_CANT_INSTRUMENTO_FINAN") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_COD_DETALLE_GASTO") & DELIMITADOR_CAMPOS_SOFT		
		linea = linea & f_consulta.ObtenerValor("TSOF_CANT_CONCEPTO_GASTO") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_COD_CENTRO_COSTO") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_TIPO_DOC_CONCILIACION") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_NRO_DOC_CONCILIACION") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_COD_AUXILIAR") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_TIPO_DOCUMENTO") & DELIMITADOR_CAMPOS_SOFT		
		linea = linea & f_consulta.ObtenerValor("TSOF_NRO_DOCUMENTO") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_FECHA_EMISION_CORTA") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_FECHA_VENCIMIENTO_CORTA") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_TIPO_DOC_REFERENCIA") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_NRO_DOC_REFERENCIA") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_NRO_CORRELATIVO") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_MONTO_DET_LIBRO1") & DELIMITADOR_CAMPOS_SOFT		
		linea = linea & f_consulta.ObtenerValor("TSOF_MONTO_DET_LIBRO2") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_MONTO_DET_LIBRO3") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_MONTO_DET_LIBRO4") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_MONTO_DET_LIBRO5") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_MONTO_DET_LIBRO6") & DELIMITADOR_CAMPOS_SOFT		
		linea = linea & f_consulta.ObtenerValor("TSOF_MONTO_DET_LIBRO7") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_MONTO_DET_LIBRO8") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_MONTO_DET_LIBRO9") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_MONTO_SUMA_DET_LIBRO") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_NRO_DOCUMENTO_DESDE") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_NRO_DOCUMENTO_HASTA") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_NRO_AGRUPADOR") 

				
		o_texto_archivo.WriteLine(linea)
		
		if f_consulta.ObtenerValor("TSOF_ACTIVA") = "S" and f_consulta.ObtenerValor("pers_nrut") <> "" then
			linea2 = ""
			linea2 = linea2 & f_consulta.ObtenerValor("pers_nrut") & DELIMITADOR_CAMPOS_SOFT
			if f_consulta.ObtenerValor("trca_nombre_a")<>"" then
				linea2 = linea2 & f_consulta.ObtenerValor("trca_paterno_a")& " " & f_consulta.ObtenerValor("trca_materno_a")& " " & f_consulta.ObtenerValor("trca_nombre_a") & DELIMITADOR_CAMPOS_SOFT
			else
				linea2 = linea2 & f_consulta.ObtenerValor("trca_paterno_c")& " " & f_consulta.ObtenerValor("trca_materno_c")& " " & f_consulta.ObtenerValor("trca_nombre_c") & DELIMITADOR_CAMPOS_SOFT
			end if
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & f_consulta.ObtenerValor("pers_nrut") & "-" & f_consulta.ObtenerValor("pers_xdv") & DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & f_consulta.ObtenerValor("TSOF_ACTIVA") & DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT	
			linea2 = linea2 & f_consulta.ObtenerValor("TSOF_CLASIFICA_CLIENTE") & DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & f_consulta.ObtenerValor("TSOF_CLASIFICA_PROVEEDOR") & DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & f_consulta.ObtenerValor("TSOF_CLASIFICA_EMPLEADO") & DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & f_consulta.ObtenerValor("TSOF_CLASIFICA_SOCIO") & DELIMITADOR_CAMPOS_SOFT		
			linea2 = linea2 & f_consulta.ObtenerValor("TSOF_CLASIFICA_DISTRIBUIDOR") & DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & f_consulta.ObtenerValor("TSOF_CLASIFICA_OTRO") & DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""
				
		o_texto_archivo_2.WriteLine(linea2)
		
		end if
	wend

	o_texto_archivo.Close
	o_texto_archivo_2.Close
	
	'----------------------------------------------------------------------------------------------------------------
	set o_texto_archivo = Nothing
	set fso = Nothing
	set o_texto_archivo_2 = Nothing
	set fso2 = Nothing
	set f_consulta = Nothing
	
	TablaAArchivo = true
	
End Function


'------------------------------------------------------------------------------------
set f_cajas = new CFormulario
f_cajas.Carga_Parametros "traspaso_cajas.xml", "cajas"
f_cajas.Inicializar conexion
f_cajas.ProcesaForm

msj_error = ""
for i_ = 0 to f_cajas.CuentaPost - 1
	v_mcaj_ncorr = f_cajas.ObtenerValorPost(i_, "mcaj_ncorr")
	v_tcaj_ccod = f_cajas.ObtenerValorPost(i_, "tcaj_ccod")

	
	if not EsVacio(v_mcaj_ncorr) then
		set con2 = new CConexion
		con2.Inicializar "upacifico"
		if v_tcaj_ccod="1001" then
			sentencia = "exec TRASPASAR_CAJA_SOLFTLAND_ANULACION " & v_mcaj_ncorr & ", '" & v_usuario & "'"
		else
			sentencia = "exec TRASPASAR_CAJA_SOLFTLAND " & v_mcaj_ncorr & ", '" & v_usuario & "'"
		end if
		'response.Write("<pre>"&sentencia&"</pre>")
		'response.End()
		v_salida=con2.ConsultaUno(sentencia)

		if cint(v_salida) = 0 then
			if TablaAArchivo(v_mcaj_ncorr, con2) then
				sentencia = "update movimientos_cajas set eren_ccod=4, mcaj_barchivo_creado_softland = 'S' where mcaj_ncorr = '" & v_mcaj_ncorr & "'"
			else
				sentencia = "update movimientos_cajas set mcaj_barchivo_creado_softland = 'N' where mcaj_ncorr = '" & v_mcaj_ncorr & "'"
			end if
			
			con2.ejecutas(sentencia)
		else
			msj_error = msj_error &" Caja : "& v_mcaj_ncorr & "\n"	
		end if
		
		set con2 = Nothing	
		
	end if	
next

'response.Write(v_salida)
'response.Flush()
if msj_error <> "" then
	conexion.EstadoTransaccion false
	session("mensaje_error")=" ha ocurrido uno o mas errores y no se han creado archivos de salida \n para las siguientes cajas : \n"&msj_error
else
	session("mensaje_error")=" Las cajas seleccionadas fueron traspasadas correctamente  al formato softland"
end if

'conexion.EstadoTransaccion false
'response.End()
'conexion.MensajeError msj_error

'------------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>


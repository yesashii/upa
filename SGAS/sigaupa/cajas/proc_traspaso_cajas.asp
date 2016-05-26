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
	
sql_nombre= " Select SUBSTRING(per.pers_tnombre, 1, 1)+''+per.pers_tape_paterno "& vbCrLf &_
			" From cajeros caj , personas per ,movimientos_cajas mc "& vbCrLf &_
			" where caj.pers_ncorr=per.pers_ncorr "& vbCrLf &_
			" and mc.caje_ccod=caj.caje_ccod "& vbCrLf &_
			" and mc.mcaj_ncorr='"&p_mcaj_ncorr&"'"
	
	v_nombre_cajero	=	p_conexion.ConsultaUno(sql_nombre)
	v_apoderado		=	"apo"
	archivo_salida 		= v_nombre_cajero&"_"& p_mcaj_ncorr & ".txt"
	archivo_salida_2 	= v_apoderado&"_"& p_mcaj_ncorr & ".txt"
	'response.Write("archivo salida: "&RUTA_ARCHIVOS_SALIDA & "\" & archivo_salida)
	set fso = Server.CreateObject("Scripting.FileSystemObject")
	set o_texto_archivo = fso.CreateTextFile(RUTA_ARCHIVOS_SALIDA & "\" & archivo_salida)
	' segundo archivo datos apoderado
	set fso2 = Server.CreateObject("Scripting.FileSystemObject")
	set o_texto_archivo_2 = fso2.CreateTextFile(RUTA_ARCHIVOS_SALIDA & "\" & archivo_salida_2)

	
	if Err.Number <> 0 then
			response.Write("error :"&Err.Description):response.Flush()
			TablaAArchivo = false
			Exit Function
	end if
	'--------------------------------------------------------------------------------------------------------------
	
	set f_consulta = new CFormulario
	f_consulta.Carga_Parametros "consulta.xml", "consulta"
	f_consulta.Inicializar p_conexion	
	
	SQL = "select * from traspasos_cajas where mcaj_ncorr = '" & p_mcaj_ncorr & "' order by ingr_nfolio_referencia asc, trca_nlinea asc"	
	f_consulta.Consultar SQL
	
	
	while f_consulta.Siguiente
		linea = ""
		linea = linea & f_consulta.ObtenerValor("mcaj_ncorr") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("ingr_nfolio_referencia") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("ting_ccod") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("trca_nlinea") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("trca_ttipo") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("trca_ndocto_compromiso") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("trca_mdebe") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("trca_mhaber") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("pers_nrut") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("pers_xdv") & DELIMITADOR_CAMPOS		
		linea = linea & f_consulta.ObtenerValor("caje_ccod") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("sede_ccod") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("banc_ccod") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("carr_ccod") & DELIMITADOR_CAMPOS		
		linea = linea & f_consulta.ObtenerValor("trca_ncomprobante_caja") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("trca_tglosa") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("trca_finicio") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("trca_numero_doc") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("trca_fecha_ingreso") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("trca_fecha_vence") & DELIMITADOR_CAMPOS		
		linea = linea & f_consulta.ObtenerValor("trca_tipo_ingreso") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("trca_nombre_a") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("trca_paterno_a") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("trca_materno_a") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("trca_fono_a") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("trca_direccion_a") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("trca_comuna_a") & DELIMITADOR_CAMPOS		
		linea = linea & f_consulta.ObtenerValor("trca_ciudad_a") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("trca_doc_paga") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("TRCA_CARRERA_ASOCIADA") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("TRCA_SEDE_CARRERA") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("TRCA_JORNADA_CARRERA") & DELIMITADOR_CAMPOS		
		linea = linea & f_consulta.ObtenerValor("TRCA_TIPO_DETALLE") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("trca_banco_pacta") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("trca_fecha_pacta") & DELIMITADOR_CAMPOS
		linea = linea & f_consulta.ObtenerValor("trca_documento") & DELIMITADOR_CAMPOS
		

				
		o_texto_archivo.WriteLine(linea)
		
		linea2 = ""
		linea2 = linea2 & f_consulta.ObtenerValor("pers_nrut") & DELIMITADOR_CAMPOS
		linea2 = linea2 & f_consulta.ObtenerValor("pers_xdv") & DELIMITADOR_CAMPOS
		linea2 = linea2 & f_consulta.ObtenerValor("carr_ccod") & DELIMITADOR_CAMPOS
		linea2 = linea2 & f_consulta.ObtenerValor("trca_nrut_c") & DELIMITADOR_CAMPOS
		linea2 = linea2 & f_consulta.ObtenerValor("trca_xdv_c") & DELIMITADOR_CAMPOS
		linea2 = linea2 & f_consulta.ObtenerValor("trca_nombre_c") & DELIMITADOR_CAMPOS
		linea2 = linea2 & f_consulta.ObtenerValor("trca_paterno_c") & DELIMITADOR_CAMPOS
		linea2 = linea2 & f_consulta.ObtenerValor("trca_materno_c") & DELIMITADOR_CAMPOS
		linea2 = linea2 & f_consulta.ObtenerValor("trca_fono_c") & DELIMITADOR_CAMPOS
		linea2 = linea2 & f_consulta.ObtenerValor("trca_direccion_c") & DELIMITADOR_CAMPOS
		linea2 = linea2 & f_consulta.ObtenerValor("trca_comuna_c") & DELIMITADOR_CAMPOS		
		linea2 = linea2 & f_consulta.ObtenerValor("trca_ciudad_c") & DELIMITADOR_CAMPOS
		
		o_texto_archivo_2.WriteLine(linea2)
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
	
	if not EsVacio(v_mcaj_ncorr) then
		set con2 = new CConexion
		con2.Inicializar "upacifico"
		
		sentencia = "exec traspasar_caja " & v_mcaj_ncorr & ", '" & v_usuario & "'"
		v_salida=con2.ConsultaUno(sentencia)

		if cint(v_salida) = 0 then
			if TablaAArchivo(v_mcaj_ncorr, con2) then
				sentencia = "update movimientos_cajas set mcaj_barchivo_creado = 'S' where mcaj_ncorr = '" & v_mcaj_ncorr & "'"
			else
				sentencia = "update movimientos_cajas set mcaj_barchivo_creado = 'N' where mcaj_ncorr = '" & v_mcaj_ncorr & "'"
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
	session("mensaje_error")=" Las cajas seleccionadas fueron traspasadas correctamente  "
end if

'response.End()
'conexion.MensajeError msj_error

'------------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>


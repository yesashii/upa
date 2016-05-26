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
	
	

	v_apoderado		=	"auxiliares"

	archivo_salida_2 	= v_apoderado&"_2005.txt"

	' segundo archivo datos apoderado
	set fso2 = Server.CreateObject("Scripting.FileSystemObject")
	set o_texto_archivo_2 = fso2.CreateTextFile(RUTA_ARCHIVOS_SALIDA_SOFTLAND & "\" & archivo_salida_2)
	'--------------------------------------------------------------------------------------------------------------
	
	set f_consulta = new CFormulario
	f_consulta.Carga_Parametros "consulta.xml", "consulta"
	f_consulta.Inicializar p_conexion	
	
	
	SQL =    "select * from ("& vbCrLf &_
			" Select pers_nrut ,pers_tnombre,pers_tape_paterno, pers_tape_materno pers_xdv "& vbCrLf &_
			" from personas"& vbCrLf &_
			" union"& vbCrLf &_
			" Select pers_nrut ,pers_tnombre,pers_tape_paterno, pers_tape_materno pers_xdv "& vbCrLf &_
			" from personas_postulante"& vbCrLf &_
			") a"
	f_consulta.Consultar SQL
	
	
	while f_consulta.Siguiente
		
			linea2 = ""
			linea2 = linea2 & f_consulta.ObtenerValor("pers_nrut") & DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & f_consulta.ObtenerValor("pers_tape_paterno")& " " & f_consulta.ObtenerValor("pers_tape_materno")& " " & f_consulta.ObtenerValor("pers_tnombre") & DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & f_consulta.ObtenerValor("pers_nrut") & "-" & f_consulta.ObtenerValor("pers_xdv") & DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & "S" & DELIMITADOR_CAMPOS_SOFT
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
			linea2 = linea2 & "S" & DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & "N" & DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & "N" & DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & "N" & DELIMITADOR_CAMPOS_SOFT		
			linea2 = linea2 & "N" & DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & "N" & DELIMITADOR_CAMPOS_SOFT
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
		

	wend

	o_texto_archivo_2.Close
	
	'----------------------------------------------------------------------------------------------------------------

	set o_texto_archivo_2 = Nothing
	set fso2 = Nothing
	set f_consulta = Nothing
	
	TablaAArchivo = true
	
End Function


'------------------------------------------------------------------------------------
v_mcaj_ncorr=1

set con2 = new CConexion
con2.Inicializar "upacifico"

			if TablaAArchivo(v_mcaj_ncorr, con2) then
				response.Write("<hr>Fue creado con exito<hr>")
			else
				response.Write("<hr>ERROR<hr>")
			end if
			

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


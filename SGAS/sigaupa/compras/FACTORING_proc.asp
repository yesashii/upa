<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_rutas.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

'Server.ScriptTimeout = 2000 
set conexion = new CConexion
conexion.Inicializar "upacifico"

set conectar = new Cconexion2
conectar.Inicializar "upacifico"

set p_conexion = new CConexion
p_conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario = negocio.ObtenerUsuario

' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

set f_solicitud = new cFormulario
f_solicitud.Carga_Parametros "factorizar_documentos.xml", "cheques"
f_solicitud.inicializar conectar
f_solicitud.procesaForm

for fila = 0 to f_solicitud.CuentaPost - 1

v_pers_nrut	= f_solicitud.ObtenerValorPost (fila, "pers_nrut")
v_rut = f_solicitud.ObtenerValorPost (fila, "rut")
v_nombre = f_solicitud.ObtenerValorPost (fila, "nombre")
v_sogi_ncorr = f_solicitud.ObtenerValorPost (fila, "sogi_ncorr")
v_solicitud = f_solicitud.ObtenerValorPost (fila, "solicitud")
v_tmon_ccod = f_solicitud.ObtenerValorPost (fila, "tmon_ccod")

v_tdoc_tdesc	= f_solicitud.ObtenerValorPost (fila, "tdoc_tdesc")
v_dsgi_ndocto = f_solicitud.ObtenerValorPost (fila, "dsgi_ndocto")
v_dsgi_mdocto = f_solicitud.ObtenerValorPost (fila, "dsgi_mdocto")
v_dsgi_mexento = f_solicitud.ObtenerValorPost (fila, "dsgi_mexento")
v_dsgi_mafecto = f_solicitud.ObtenerValorPost (fila, "dsgi_mafecto")
v_dsgi_miva = f_solicitud.ObtenerValorPost (fila, "dsgi_miva")

v_dogi_fecha_documento	= f_solicitud.ObtenerValorPost (fila, "dogi_fecha_documento")
v_total = f_solicitud.ObtenerValorPost (fila, "total")
v_dpva_fpago = f_solicitud.ObtenerValorPost (fila, "dpva_fpago")

v_pers_nrut_02		= request.Form("datos_1[0][pers_nrut]")
v_pers_xdv		= request.Form("datos_1[0][pers_xdv]")
v_nombre_02		= request.Form("datos_1[0][nombre_02]")

'8888888888888888888888
'8888888888888888888888

v_fact_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_factorizacion'")

IF v_sogi_ncorr<>"" THEN

			sql_cheques	=	" INSERT INTO [dbo].[ocag_factorizacion] "&_
										" ([fact_ncorr], [pers_nrut], [rut], [nombre], [sogi_ncorr] "&_
										" ,[solicitud], [tmon_ccod], [tdoc_tdesc], [dsgi_ndocto], [dsgi_mdocto] "&_
										" ,[dsgi_mexento], [dsgi_mafecto], [dsgi_miva], [dogi_fecha_documento], [total] "&_
										" ,[dpva_fpago], [pers_nrut_02], [pers_xdv_02], [nombre_02]) "&_
										" VALUES "&_
										" ("&v_fact_ncorr&", "&v_pers_nrut&", '"&v_rut&"', '"&v_nombre&"', "&v_sogi_ncorr&" "&_
										" ,"&v_solicitud&", "&v_tmon_ccod&", '"&v_tdoc_tdesc&"', "&v_dsgi_ndocto&", "&v_dsgi_mdocto&" "&_
										" ,"&v_dsgi_mexento&", "&v_dsgi_mafecto&", "&v_dsgi_miva&", '"&v_dogi_fecha_documento&"', "&v_total&" "&_
										" ,'"&v_dpva_fpago&"', "&v_pers_nrut_02&", '"&v_pers_xdv&"', '"&v_nombre_02&"') "
										
		conexion.estadotransaccion	conexion.ejecutas(sql_cheques)

END IF

next

'RESPONSE.WRITE("sql_cheques: "&sql_cheques&"<BR>")

' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

sql_nombre= "Select PERS_TAPE_PATERNO + '_' + SUBSTRING(PERS_TNOMBRE,1,1) as NOMBRE from personas "& vbCrLf &_
			"where cast(pers_nrut as varchar)='"&v_usuario&"'"

'RESPONSE.WRITE("1. sql_nombre : "&sql_nombre&"<BR>")

v_ano_caja = p_conexion.ConsultaUno("select year(getDate())")
v_mes_caja = p_conexion.ConsultaUno("select month(getDate())")

'RESPONSE.WRITE("2. v_ano_caja : "&v_ano_caja&"<BR>")
'RESPONSE.WRITE("3. v_mes_caja : "&v_mes_caja&"<BR>")

Select Case v_mes_caja
  Case "1"
	v_mes_caja = "01_ENERO"
  Case "2"
	v_mes_caja = "02_FEBRERO"
  Case "3"
	v_mes_caja = "03_MARZO"
  Case "4"
	v_mes_caja = "04_ABRIL"
  Case "5"
	v_mes_caja = "05_MAYO"
  Case "6"
	v_mes_caja = "06_JUNIO"
  Case "7"
	v_mes_caja = "07_JULIO"
  Case "8"
	v_mes_caja = "08_AGOSTO"
  Case "9"
	v_mes_caja = "09_SEPTIEMBRE"
  Case "10"
	v_mes_caja = "10_OCTUBRE"
  Case "11"
	v_mes_caja = "11_NOVIEMBRE"
  Case "12"
	v_mes_caja = "12_DICIEMBRE"
End Select

v_dia_caja = p_conexion.ConsultaUno("select day(getDate())")

'RESPONSE.WRITE("3. v_dia_caja : "&v_dia_caja&"<BR>")

' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

	Set CreaCarpeta = CreateObject("Scripting.FileSystemObject")

	If Not CreaCarpeta.FolderExists(RUTA_ARCHIVOS_FACTORIZAR&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja) Then
	' si no existe el directorio Año/Mes/Dia, evaluamos si existe el mes	
	
		If CreaCarpeta.FolderExists(RUTA_ARCHIVOS_FACTORIZAR&"\"&v_ano_caja&"\"&v_mes_caja) Then
			
			'Existe directorio .../Año/mes/
			'se debe crear entonces el directorio /dia
			Set Carpeta = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_FACTORIZAR&"\"&v_ano_caja&"\"&v_mes_caja)
			Set subcarpera = Carpeta.subFolders
			subcarpera.add(v_dia_caja)
		
		else
			' sino, se evalua si existe el año por si solo
			If CreaCarpeta.FolderExists(RUTA_ARCHIVOS_FACTORIZAR&"\"&v_ano_caja) Then
			'Existe directorio .../Año

				'se debe crear entonces el directorio /mes
				Set Carpeta = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_FACTORIZAR&"\"&v_ano_caja)
				Set subcarpera = Carpeta.subFolders
				subcarpera.add(v_mes_caja)
				
				'se debe crear entonces el directorio /mes/dia
				Set Carpeta2 = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_FACTORIZAR&"\"&v_ano_caja&"\"&v_mes_caja)
				Set subcarpera2 = Carpeta2.subFolders
				subcarpera2.add(v_dia_caja)
				
			else
			
				' 88888888888888888888888888888888
				' response.Write("1.2.2. ACA "&"<BR>")
				' 88888888888888888888888888888888
				
				' se crea el directorio /año
				CreaCarpeta.CreateFolder(RUTA_ARCHIVOS_FACTORIZAR&"\"&v_ano_caja)

				' se crea el sub-directorio /mes
				Set Carpeta = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_FACTORIZAR&"\"&v_ano_caja)
				Set subcarpera = Carpeta.subFolders
				subcarpera.add(v_mes_caja)

				' se crea el sub-directorio /dia
				Set Carpeta2 = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_FACTORIZAR&"\"&v_ano_caja&"\"&v_mes_caja)
				Set subcarpera2 = Carpeta2.subFolders
				subcarpera2.add(v_dia_caja)
							
			End if
			
		End if
		
	End If
	
	v_ruta_salida_nueva		=	RUTA_ARCHIVOS_FACTORIZAR&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja
	
	'RESPONSE.WRITE("6. v_ruta_salida_nueva : "&v_ruta_salida_nueva&"<BR>")
	'RESPONSE.END()
	
	'******************************************
	v_nombre_cajero	=	p_conexion.ConsultaUno(sql_nombre)
	archivo_salida 		= v_nombre_cajero&"_"&v_dsgi_ndocto&"_"&v_solicitud & ".txt"

	' Creacion de archivos de cajas
	set fso = Server.CreateObject("Scripting.FileSystemObject")
	set o_texto_archivo = fso.CreateTextFile(v_ruta_salida_nueva & "\" & archivo_salida)

' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
								
										linea = linea & "2-10-070-10-000002" & DELIMITADOR_CAMPOS_SOFT
										linea = linea & "0" & DELIMITADOR_CAMPOS_SOFT
										linea = linea & v_total & DELIMITADOR_CAMPOS_SOFT
										linea = linea & v_tdoc_tdesc & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT		
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT		
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & v_pers_nrut_02 & DELIMITADOR_CAMPOS_SOFT
										linea = linea & "BC" & DELIMITADOR_CAMPOS_SOFT		
										linea = linea & v_solicitud & DELIMITADOR_CAMPOS_SOFT
										linea = linea & replace(v_dogi_fecha_documento,"-","/") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & replace(v_dpva_fpago,"-","/") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & "BC" & DELIMITADOR_CAMPOS_SOFT
										linea = linea & v_solicitud & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT		
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT		
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & "1" & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
			
										o_texto_archivo.WriteLine(linea)
										
										linea=""

										linea = linea & "2-10-070-10-000002" & DELIMITADOR_CAMPOS_SOFT
										linea = linea & v_total & DELIMITADOR_CAMPOS_SOFT
										linea = linea & "0" & DELIMITADOR_CAMPOS_SOFT
										linea = linea & v_tdoc_tdesc & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT		
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT		
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & v_pers_nrut & DELIMITADOR_CAMPOS_SOFT
										linea = linea & "TR" & DELIMITADOR_CAMPOS_SOFT		
										linea = linea & v_solicitud & DELIMITADOR_CAMPOS_SOFT
										linea = linea & replace(v_dogi_fecha_documento,"-","/") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & replace(v_dpva_fpago,"-","/") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & "BC" & DELIMITADOR_CAMPOS_SOFT
										linea = linea & v_solicitud & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT		
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT		
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & "1" & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
										linea = linea & DELIMITADOR_CAMPOS_SOFT
			
										o_texto_archivo.WriteLine(linea)

'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
										
	o_texto_archivo.Close ' Escritura en archivo base de la caja

	'----------------------------------------------------------------------------------------------------------------
	set o_texto_archivo = Nothing
	set fso = Nothing

    Set Carpeta = Nothing
	Set subcarpera = Nothing
	Set subcarpera2 = Nothing 
	Set CreaCarpeta = Nothing

' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

if conexion.ObtenerEstadoTransaccion=false  then
	session("mensaje_error")=" ha ocurrido uno o mas errores y la factura N° "&v_dsgi_ndocto&" no pudo factorizar : \n"
else
	session("mensaje_error")=" La factura N° "&v_dsgi_ndocto&"  fue factorizada correctamente"
end if

'conexion.EstadoTransaccion false

'response.End()
'conexion.MensajeError msj_error
url_final="FACTORING.ASP"

response.Redirect(url_final)

'------------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>


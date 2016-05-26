<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_rutas.asp" -->
<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:COMPRAS Y AUT. DE GIRO
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:03/10/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			:73
'*******************************************************************
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

'8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
'8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
'8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888


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

'------------------------------------------------------------------------------------

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

ind2=0
for each k in request.form

v_solicitud=request.Form("datos["&ind2&"][cod_numero]")
eche_ncorr=request.Form("datos["&ind2&"][eche_ncorr]")

'RESPONSE.WRITE(ind2&". cod_solicitud : "&v_solicitud&"<BR>")
'RESPONSE.WRITE(ind2&". eche_ncorr : "&eche_ncorr&"<BR>")
'RESPONSE.END()

'if v_solicitud <> "" then
if eche_ncorr <> "" then

' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

'select case eche_ncorr

'	Case 16: ' Pago Proveedores
	
		txt_tipo="Cheque_Remitido"

					
sql_efes_faltantes= "SELECT '2-10-070-10-000002' as tsof_plan_cuenta   "&_
							", 'REEMISION DE CHEQUE VENCIDO' as TSOF_GLOSA_SIN_ACENTO  "&_
							", 0 as tsof_debe  "&_
							", eche_mmonto as TSOF_HABER   "&_
							", CajCod as cod_pre, pers_nrut as TSOF_COD_AUXILIAR, "&_ 
							"'BC' as TSOF_TIPO_DOCUMENTO, eche_ndocto as TSOF_NRO_DOCUMENTO, protic.trunc(eche_fdocto) as TSOF_FECHA_EMISION_CORTA,  "&_
							" protic.trunc(eche_fdocto) as TSOF_FECHA_VENCIMIENTO_CORTA,  'BC' AS TSOF_TIPO_DOC_REFERENCIA, eche_ndocto AS TSOF_NRO_DOC_REFERENCIA "&_
							"FROM ocag_entrega_cheques a inner join "&_
							"    ocag_bancos_softland b "&_
							"    on a.banc_ccod=b.banc_tcodigo "&_
							"WHERE eche_ndocto="&v_solicitud&" "&_
							"UNION  "&_
							"SELECT b.cta_pasivo  as tsof_plan_cuenta  "&_
							", 'REEMISION DE CHEQUE VENCIDO' as TSOF_GLOSA_SIN_ACENTO  "&_
							", eche_mmonto as tsof_debe  "&_
							", 0 as TSOF_HABER   "&_
							", CajCod as cod_pre, pers_nrut as TSOF_COD_AUXILIAR,  "&_
							"'TR' as TSOF_TIPO_DOCUMENTO, eche_ndocto as TSOF_NRO_DOCUMENTO, protic.trunc(eche_fdocto) as TSOF_FECHA_EMISION_CORTA, "&_ 
							" protic.trunc(eche_fdocto) as TSOF_FECHA_VENCIMIENTO_CORTA,  'CV' AS TSOF_TIPO_DOC_REFERENCIA, eche_ndocto AS TSOF_NRO_DOC_REFERENCIA "&_
							"FROM ocag_entrega_cheques a inner join "&_
							"    ocag_bancos_softland b "&_
							"    on a.banc_ccod=b.banc_tcodigo "&_
							"WHERE eche_ndocto="&v_solicitud
					  

'response.Write(sql_efes_faltantes)
'response.End()
'end select

' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

'******************************************
	Set CreaCarpeta = CreateObject("Scripting.FileSystemObject")

	If Not CreaCarpeta.FolderExists(RUTA_ARCHIVOS_CHEQUES_REMITIDOS&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja) Then
	' si no existe el directorio Año/Mes/Dia, evaluamos si existe el mes	
	
		If CreaCarpeta.FolderExists(RUTA_ARCHIVOS_CHEQUES_REMITIDOS&"\"&v_ano_caja&"\"&v_mes_caja) Then
			
			'Existe directorio .../Año/mes/
			'se debe crear entonces el directorio /dia
			Set Carpeta = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_CHEQUES_REMITIDOS&"\"&v_ano_caja&"\"&v_mes_caja)
			Set subcarpera = Carpeta.subFolders
			subcarpera.add(v_dia_caja)
		
		else
			' sino, se evalua si existe el año por si solo
			If CreaCarpeta.FolderExists(RUTA_ARCHIVOS_CHEQUES_REMITIDOS&"\"&v_ano_caja) Then
			'Existe directorio .../Año

				'se debe crear entonces el directorio /mes
				Set Carpeta = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_CHEQUES_REMITIDOS&"\"&v_ano_caja)
				Set subcarpera = Carpeta.subFolders
				subcarpera.add(v_mes_caja)
				
				'se debe crear entonces el directorio /mes/dia
				Set Carpeta2 = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_CHEQUES_REMITIDOS&"\"&v_ano_caja&"\"&v_mes_caja)
				Set subcarpera2 = Carpeta2.subFolders
				subcarpera2.add(v_dia_caja)
				
			else
			
				' 88888888888888888888888888888888
				 'response.Write("1.2.2. ACA "&"<BR>")
				' 88888888888888888888888888888888
				
				' se crea el directorio /año
				CreaCarpeta.CreateFolder(RUTA_ARCHIVOS_CHEQUES_REMITIDOS&"\"&v_ano_caja)

				' se crea el sub-directorio /mes
				Set Carpeta = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_CHEQUES_REMITIDOS&"\"&v_ano_caja)
				Set subcarpera = Carpeta.subFolders
				subcarpera.add(v_mes_caja)

				' se crea el sub-directorio /dia
				Set Carpeta2 = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_CHEQUES_REMITIDOS&"\"&v_ano_caja&"\"&v_mes_caja)
				Set subcarpera2 = Carpeta2.subFolders
				subcarpera2.add(v_dia_caja)
							
			End if
			
		End if
		
	End If

	v_ruta_salida_nueva		=	RUTA_ARCHIVOS_CHEQUES_REMITIDOS&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja
	
	'RESPONSE.WRITE("<br/> 6. v_ruta_salida_nueva : "&v_ruta_salida_nueva&"<BR>")
	'response.End()
	'******************************************
	v_nombre_cajero	=	p_conexion.ConsultaUno(sql_nombre)
	archivo_salida 		= v_nombre_cajero&"_"&txt_tipo&"_"&v_solicitud & ".txt"

	' Creacion de archivos de cajas
	set fso = Server.CreateObject("Scripting.FileSystemObject")
	set o_texto_archivo = fso.CreateTextFile(v_ruta_salida_nueva & "\" & archivo_salida)

	'--------------------------------------------------------------------------------------------------------------

								set f_efes_2 = new CFormulario
								f_efes_2.Carga_Parametros "consulta.xml", "consulta"
								f_efes_2.Inicializar p_conexion	

								'f_efes.Consultar SQL
								f_efes_2.Consultar sql_efes_faltantes

								ind=0
								v_total=0
								AGRUPADOR_CAMPOS_SOFT=1

								while f_efes_2.Siguiente 

										linea = ""
										linea = linea & f_efes_2.ObtenerValor("tsof_plan_cuenta") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("tsof_debe") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_HABER") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_GLOSA_SIN_ACENTO") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_EQUIVALENCIA") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_DEBE_ADICIONAL") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_HABER_ADICIONAL") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_COD_CONDICION_VENTA") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_COD_VENDEDOR") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_COD_UBICACION") & DELIMITADOR_CAMPOS_SOFT		
										linea = linea & f_efes_2.ObtenerValor("TSOF_COD_CONCEPTO_CAJA") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_COD_INSTRUMENTO_FINAN") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_CANT_INSTRUMENTO_FINAN") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_COD_DETALLE_GASTO") & DELIMITADOR_CAMPOS_SOFT		
										linea = linea & f_efes_2.ObtenerValor("TSOF_CANT_CONCEPTO_GASTO") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_COD_CENTRO_COSTO") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_TIPO_DOC_CONCILIACION") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_NRO_DOC_CONCILIACION") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_COD_AUXILIAR") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_TIPO_DOCUMENTO") & DELIMITADOR_CAMPOS_SOFT		
										linea = linea & f_efes_2.ObtenerValor("TSOF_NRO_DOCUMENTO") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_FECHA_EMISION_CORTA") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_FECHA_VENCIMIENTO_CORTA") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_TIPO_DOC_REFERENCIA") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_NRO_DOC_REFERENCIA") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_NRO_CORRELATIVO") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_MONTO_DET_LIBRO1") & DELIMITADOR_CAMPOS_SOFT		
										linea = linea & f_efes_2.ObtenerValor("TSOF_MONTO_DET_LIBRO2") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_MONTO_DET_LIBRO3") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_MONTO_DET_LIBRO4") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_MONTO_DET_LIBRO5") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_MONTO_DET_LIBRO6") & DELIMITADOR_CAMPOS_SOFT		
										linea = linea & f_efes_2.ObtenerValor("TSOF_MONTO_DET_LIBRO7") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_MONTO_DET_LIBRO8") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_MONTO_DET_LIBRO9") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_MONTO_SUMA_DET_LIBRO") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_NRO_DOCUMENTO_DESDE") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_NRO_DOCUMENTO_HASTA") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & AGRUPADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_bullshet1") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_bullshet2") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_bullshet3") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes_2.ObtenerValor("TSOF_cod_mesano") & DELIMITADOR_CAMPOS_SOFT ' mes+año (aca si van los valores)
										linea = linea & f_efes_2.ObtenerValor("TSOF_monto_presupuesto") ' monto (aca si van los valores)
			
										o_texto_archivo.WriteLine(linea)

								wend


'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

										
	o_texto_archivo.Close ' Escritura en archivo base de la caja

	'o_texto_archivo_2.Close

	'----------------------------------------------------------------------------------------------------------------
	set o_texto_archivo = Nothing
	set fso = Nothing
	set f_efes_2 = Nothing
	
	
    Set Carpeta = Nothing
	Set subcarpera = Nothing
	Set subcarpera2 = Nothing 
	Set CreaCarpeta = Nothing


'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

end if

ind2=ind2+1
next

'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

'------------------------------------------------------------------------------------

set negocio = new CNegocio
'negocio.Inicializa conectar
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

set f_datos_cheques = new cFormulario
f_datos_cheques.carga_parametros "reemitir_cheques_vencidos.xml", "reemitir_cheques_vencidos"
'f_datos_cheques.inicializar conectar
f_datos_cheques.inicializar conexion
f_datos_cheques.procesaForm

'**************************** SE RECORRE LOS REGISTROS DE LA PERSONA PARA INSERTAR DATOS DE LA OC *************
for fila = 0 to f_datos_cheques.CuentaPost - 1
	eche_ncorr			= f_datos_cheques.ObtenerValorPost (fila, "eche_ncorr")
	cod_numero 			= f_datos_cheques.ObtenerValorPost (fila, "cod_numero")
	fecha_anterior		= f_datos_cheques.ObtenerValorPost (fila, "eche_fdocto")
	eche_mmonto		= f_datos_cheques.ObtenerValorPost (fila, "eche_mmonto")
	cod_proveedor		= f_datos_cheques.ObtenerValorPost (fila, "cod_proveedor")
	rche_frevalidacion	= f_datos_cheques.ObtenerValorPost (fila, "rche_frevalidacion")
	rche_tobservacion	= f_datos_cheques.ObtenerValorPost (fila, "rche_tobservacion")	
	cpbnum				= f_datos_cheques.ObtenerValorPost (fila, "cpbnum")

	if 	eche_ncorr<>"" and eche_ncorr<>"S" then
	'CHEQUES ENTREGADOS
	'response.Write("<hr>aaa"&eche_ccod)
	
		'v_rche_ncorr=conectar.consultauno("exec obtenersecuencia 'ocag_reemision_cheques'")
		v_rche_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_reemision_cheques'")
		
		'inserta datos del cheque y su revalidacion
		if v_rche_ncorr <>"" then
		
									
			sql_revalidacion	=	" insert into ocag_reemision_cheques(rche_ncorr, eche_ncorr, cpbnum, eche_ndocto, rche_nreemision, "&_
									" rche_fanterior, rche_freemision, rche_tobservacion, audi_tusuario, audi_fmodificacion) "&_
									" values("&v_rche_ncorr&",'"&eche_ncorr&"','"&cpbnum&"',"&cod_numero&",1,convert(datetime,'"&fecha_anterior&"',103), "&_
									" convert(datetime,'"&rche_frevalidacion&"',103),'"&rche_tobservacion&"','"&v_usuario&"', getdate() ) "

			'conectar.estadotransaccion	conectar.ejecutas(sql_revalidacion)
			conexion.estadotransaccion	conexion.ejecutas(sql_revalidacion)
			
			sql_actualiza="update ocag_entrega_cheques set eche_ccod=6,  audi_fmodificacion=convert(datetime,'"&rche_frevalidacion&"',103) where eche_ncorr="&eche_ncorr
			
			'conectar.estadotransaccion	conectar.ejecutas(sql_actualiza)
			conexion.estadotransaccion	conexion.ejecutas(sql_actualiza)
			
			'response.Write("<br>"&sql_revalidacion&"<br>")
			'response.Write("<br>"&sql_actualiza&"<br>")
			
		end if
		
	END IF
	

	if 	eche_ncorr="S" then
	' CHEQUES NO ENTREGADOS
	
		'v_eche_ncorr=conectar.consultauno("exec obtenersecuencia 'ocag_entrega_cheques'")
		v_eche_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_entrega_cheques'")

		'inserta datos del cheque y su observacion
		if v_eche_ncorr <>"" then
						  
						  
				sql_banc_ccod=" select c.pccodi "& vbCrLf &_ 
						  "from softland.cwmovim a "& vbCrLf &_ 
						  "INNER JOIN softland.cwtauxi b "& vbCrLf &_ 
						  "ON a.codaux = b.codaux "& vbCrLf &_ 
						  "AND a.ttdcod LIKE 'CV'  "& vbCrLf &_ 
						  "AND a.cpbano >= 2013 and a.movfv is not null  "& vbCrLf &_ 
						  "AND datediff(dd, a.movfv,getdate()) >= 120 "& vbCrLf &_ 
						  "AND a.NumDoc ='"&cod_numero&"' "& vbCrLf &_
						  "AND a.cpbnum='"&cpbnum&"'"& vbCrLf &_
						  "AND a.MovHaber > 0 "& vbCrLf &_ 
						  "and a.cpbnum not in ( '00000000' ) "& vbCrLf &_ 
						  "INNER JOIN softland.cwpctas c "& vbCrLf &_ 
						  "ON a.pctcod = c.pccodi "
			
			'banco_ccod=conexion.consultaUno(sql_banc_ccod)
			banco_ccod=conectar.consultaUno(sql_banc_ccod)
			
			sql_cheques	=	" insert into ocag_entrega_cheques(eche_ncorr,cpbnum, eche_ndocto, eche_fdocto, eche_mmonto, banc_ccod "& vbCrLf &_
								" , pers_nrut, eche_ccod, eche_tanotacion_retiro "& vbCrLf &_
								" , audi_tusuario, audi_fmodificacion, eche_fentrega) "& vbCrLf &_
								" values("&v_eche_ncorr&", '"&cpbnum&"' ,"&cod_numero&" ,convert(datetime,'"&fecha_anterior&"',103), "&eche_mmonto&" ,'"&banco_ccod&"', "& vbCrLf &_
								" "&cod_proveedor&" , 6,'"&rche_tobservacion&"', "& vbCrLf &_
								" '"&v_usuario&"',getdate(), getdate() ) "
			
			'conectar.estadotransaccion	conectar.ejecutas(sql_cheques)
			conexion.estadotransaccion	conexion.ejecutas(sql_cheques)
			
			v_rche_ncorr=conectar.consultauno("exec obtenersecuencia 'ocag_reemision_cheques'")
			
			sql_revalidacion	=	" insert into ocag_reemision_cheques(rche_ncorr, eche_ncorr, cpbnum, eche_ndocto, rche_nreemision, "&_
									" rche_fanterior, rche_freemision,rche_tobservacion,audi_tusuario,audi_fmodificacion) "&_
									" values("&v_rche_ncorr&", "&v_eche_ncorr&" ,'"&cpbnum&"',"&cod_numero&",1,convert(datetime,'"&fecha_anterior&"',103), "&_
									" convert(datetime,'"&rche_frevalidacion&"',103),'"&rche_tobservacion&"','"&v_usuario&"', getdate() ) "

			'conectar.estadotransaccion	conectar.ejecutas(sql_revalidacion)
			conexion.estadotransaccion	conexion.ejecutas(sql_revalidacion)
			
			'RESPONSE.WRITE("1. sql_cheques : "&sql_cheques&"<BR>")
			'RESPONSE.WRITE("2. sql_revalidacion : "&sql_revalidacion&"<BR>")

		end if
	
	end if

next

'conectar.estadotransaccion false
'response.End()

'v_estado_transaccion = conectar.ObtenerEstadoTransaccion
v_estado_transaccion = conexion.ObtenerEstadoTransaccion

if v_estado_transaccion=false  then
'if conectar.ObtenerEstadoTransaccion  then
	session("mensaje_error")="No se pudo revalidar el o los cheques seleccionados.\nVuelva a intentarlo."
else	
	session("mensaje_error")="Los cheques seleccionados fueron revalidados correctamente."
end if

response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
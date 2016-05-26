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
'LINEA			:  79
'*******************************************************************
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

set conexion = new Cconexion2
conexion.Inicializar "upacifico"

set conectar = new cconexion
conectar.inicializar "upacifico"

set p_conexion = new CConexion
p_conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar
'negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

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

set f_datos_cheques = new cFormulario
f_datos_cheques.carga_parametros "traspasar_cheques.xml", "traspasar_cheques"
f_datos_cheques.inicializar conectar
'f_datos_cheques.inicializar conexion
f_datos_cheques.procesaForm

'**************************** SE RECORRE LOS REGISTROS DE LA PERSONA PARA INSERTAR DATOS DE LA OC *************
for fila = 0 to f_datos_cheques.CuentaPost - 1

	eche_ncorr			= f_datos_cheques.ObtenerValorPost (fila, "eche_ncorr")
	cod_numero 			= f_datos_cheques.ObtenerValorPost (fila, "cod_numero")
	codaux 		= f_datos_cheques.ObtenerValorPost (fila, "codaux")
	eche_fdocto			= f_datos_cheques.ObtenerValorPost (fila, "eche_fdocto")
	eche_mmonto		= f_datos_cheques.ObtenerValorPost (fila, "eche_mmonto")
	cod_proveedor		= f_datos_cheques.ObtenerValorPost (fila, "cod_proveedor")
	tche_ftraspaso		= f_datos_cheques.ObtenerValorPost (fila, "tche_ftraspaso")
	tche_tobservacion	= f_datos_cheques.ObtenerValorPost (fila, "tche_tobservacion")	
	cpbnum				= f_datos_cheques.ObtenerValorPost (fila, "cpbnum")
	
	'RESPONSE.WRITE("0. eche_ncorr : "&eche_ncorr&"<BR>")
	
	if 	eche_ncorr<>"" and eche_ncorr<>"S" then
	
	'CHEQUES ENTREGADOS
	
		v_tche_ncorr=conectar.consultauno("exec obtenersecuencia 'ocag_traspaso_cheques'")

		
		'RESPONSE.WRITE("0. v_tche_ncorr : "&v_tche_ncorr&"<BR>")
		
		'inserta datos del cheque y su revalidacion
		
			'sql_actualiza="update ocag_entrega_cheques set eche_ccod=5,  eche_fdocto=convert(datetime,'"&tche_ftraspaso&"',103) where eche_ncorr="&eche_ncorr
			
			sql_actualiza="update ocag_entrega_cheques set eche_ccod=5 ,  audi_fmodificacion=convert(datetime,'"&tche_ftraspaso&"',103) where eche_ncorr="&eche_ncorr
			
			'RESPONSE.WRITE("1. sql_actualiza : "&sql_actualiza&"<BR>")
			
			conectar.estadotransaccion	conectar.ejecutas(sql_actualiza)
			'conexion.estadotransaccion	conexion.ejecutas(sql_actualiza)
		
			sql_traspaso	=	" insert into ocag_traspaso_cheques(tche_ncorr,eche_ncorr,cpbnum,eche_ndocto, "&_
									" tche_fdocto,tche_ftraspaso,tche_tobservacion,audi_tusuario,audi_fmodificacion) "&_
									" values("&v_tche_ncorr&",'"&eche_ncorr&"','"&cpbnum&"',"&cod_numero&",convert(datetime,'"&eche_fdocto&"',103), "&_
									" convert(datetime,'"&tche_ftraspaso&"',103),'"&tche_tobservacion&"','"&v_usuario&"', getdate() ) "

			conectar.estadotransaccion	conectar.ejecutas(sql_traspaso)
			'conexion.estadotransaccion	conexion.ejecutas(sql_traspaso)
			
			'RESPONSE.WRITE("2. sql_traspaso : "&sql_traspaso&"<BR>") 
			
	END IF

'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

	if 	eche_ncorr="S" then
	
	' CHEQUES NO ENTREGADOS
	
		v_eche_ncorr = conectar.consultauno("exec obtenersecuencia 'ocag_entrega_cheques'")
		'v_eche_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_entrega_cheques'")
		
		'RESPONSE.WRITE("3. v_eche_ncorr : "&v_eche_ncorr&"<BR>")

		'inserta datos del cheque y su observacion
		if v_eche_ncorr <>"" then
						  
				sql_banc_ccod=" select TOP 1 a.pctcod "& vbCrLf &_ 
						  "from softland.cwmovim a "& vbCrLf &_ 
						  "WHERE a.tipdoccb = 'CP' and a.cpbano >= 2013 "& vbCrLf &_ 
						  "AND datediff(dd, a.movfv,getdate()) >= 91 "& vbCrLf &_ 
						  "AND a.NumDocCb ='"&cod_numero&"' "& vbCrLf &_
						  "AND a.cpbnum ='"&cpbnum&"'"& vbCrLf &_
						  "AND a.movfv is not null "
						  
			'RESPONSE.WRITE("4. sql_banc_ccod : "&sql_banc_ccod&"<BR>")
			
			banco_ccod=conexion.consultaUno(sql_banc_ccod)
			'banco_ccod=conectar.consultaUno(sql_banc_ccod)
			
			'RESPONSE.WRITE("5. banco_ccod : "&banco_ccod&"<BR>")
			
						'CODIGO PRESUPUESTARIO
							
						cod_presupuesto=" select TOP 1 a.CajCod "& vbCrLf &_ 
								"from softland.cwmovim a "& vbCrLf &_ 
								"WHERE a.tipdoccb = 'CP' and a.cpbano >= 2013 "& vbCrLf &_ 
								"AND datediff(dd, a.movfv,getdate()) >= 91 "& vbCrLf &_ 
								"AND a.NumDocCb ='"&cod_numero&"' "& vbCrLf &_
								"AND a.cpbnum ='"&cpbnum&"'"& vbCrLf &_
								"AND a.movfv is not null "
									  
							'RESPONSE.WRITE("6. cod_presupuesto : "&cod_presupuesto&"<BR>")
						
							v_cod_presupuesto =conexion.consultaUno(cod_presupuesto)
							'v_cod_presupuesto =conectar.consultaUno(cod_presupuesto)
							
							'RESPONSE.WRITE("7. v_cod_presupuesto : "&v_cod_presupuesto&"<BR>")
							
							'CODIGO CENTRO DE COSTO
							
							cod_ccosto="select max(a.CcCod) as cod_ccosto "& vbCrLf &_ 
									  " 	from softland.cwmovim a "& vbCrLf &_ 
									  " 	where a.codaux = '"&codaux&"' "& vbCrLf &_ 
									  " 	and a.cpbnum = '"&cpbnum&"' "
									  
							'RESPONSE.WRITE("8. cod_ccosto : "&cod_ccosto&"<BR>")
						
							v_cod_ccosto = conexion.consultaUno(cod_ccosto)
							'v_cod_ccosto = conectar.consultaUno(cod_ccosto)
							
							'RESPONSE.WRITE("9. v_cod_ccosto : "&v_cod_ccosto&"<BR>")
			
			sql_cheques	=	" insert into ocag_entrega_cheques(eche_ncorr,cpbnum, eche_ndocto, eche_fdocto, eche_mmonto, banc_ccod "& vbCrLf &_
								" , pers_nrut, eche_ccod, eche_tanotacion_retiro "& vbCrLf &_
								" , audi_tusuario, audi_fmodificacion, eche_fentrega, rche_nentrega, CajCod, CcCod) "& vbCrLf &_
								" values("&v_eche_ncorr&", '"&cpbnum&"' ,"&cod_numero&" ,convert(datetime,'"&eche_fdocto&"',103), "&eche_mmonto&" ,'"&banco_ccod&"', "& vbCrLf &_
								" "&cod_proveedor&" , 5,'"&tche_tobservacion&"', "& vbCrLf &_
								" '"&v_usuario&"',getdate(), getdate(), 1 , '"&v_cod_presupuesto&"', '"&v_cod_ccosto&"' ) "
								
			'RESPONSE.WRITE("10. sql_cheques : "&sql_cheques&"<BR>")
			
			conectar.estadotransaccion	conectar.ejecutas(sql_cheques)
			'conexion.estadotransaccion	conexion.ejecutas(sql_cheques)
			
			v_rche_ncorr=conectar.consultauno("exec obtenersecuencia 'ocag_traspaso_cheques'")
			'v_rche_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_traspaso_cheques'")
			
			'RESPONSE.WRITE("11. v_rche_ncorr : "&v_rche_ncorr&"<BR>")
			
			sql_revalidacion	=	" insert into ocag_traspaso_cheques(tche_ncorr, eche_ncorr, cpbnum, eche_ndocto, tche_fdocto, tche_ftraspaso "&_
									" , tche_tobservacion, audi_tusuario, audi_fmodificacion) "&_
									" values("&v_rche_ncorr&", "&v_eche_ncorr&" ,'"&cpbnum&"',"&cod_numero&",convert(datetime,'"&eche_fdocto&"',103), "&_
									" convert(datetime,'"&tche_ftraspaso&"',103),'"&tche_tobservacion&"','"&v_usuario&"', getdate() ) "

			conectar.estadotransaccion	conectar.ejecutas(sql_revalidacion)
			'conexion.estadotransaccion	conexion.ejecutas(sql_revalidacion)
			
			'RESPONSE.WRITE("12. sql_revalidacion : "&sql_revalidacion&"<BR>")

		end if

'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

	end if

if eche_ncorr="S" then
	' CHEQUES NO ENTREGADOS
	'v_solicitud=v_eche_ncorr
	eche_ncorr=v_eche_ncorr
ELSE
	'v_solicitud=eche_ncorr
	eche_ncorr=eche_ncorr
END IF

v_solicitud=cod_numero

' AHORA COMIENZA EL DOCUMENTO DE TEXTO

'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

	if eche_ncorr <> "" then

			txt_tipo="Cheques_Vencidos"
								
			sql_doctos = "SELECT 1 as orden,b.cta_pasivo  as tsof_plan_cuenta, 'REGISTRO DE CHEQUES VENCIDOS' as TSOF_GLOSA_SIN_ACENTO, 0 as tsof_debe   "&_
								" , eche_mmonto as TSOF_HABER, '' as TSOF_COD_CONCEPTO_CAJA, '' AS TSOF_TIPO_DOC_CONCILIACION, NULL AS TSOF_NRO_DOC_CONCILIACION  "&_
								" , pers_nrut as TSOF_COD_AUXILIAR, 'CV' as TSOF_TIPO_DOCUMENTO, eche_ndocto as TSOF_NRO_DOCUMENTO, protic.trunc(eche_fdocto) as TSOF_FECHA_EMISION_CORTA "&_
								" , protic.trunc(eche_fdocto) as TSOF_FECHA_VENCIMIENTO_CORTA, 'CV' AS TSOF_TIPO_DOC_REFERENCIA, eche_ndocto AS TSOF_NRO_DOC_REFERENCIA "&_
								" FROM ocag_entrega_cheques a  "&_
								" inner join ocag_bancos_softland b on a.banc_ccod=b.banc_tcodigo  "&_
								" WHERE eche_ndocto="&v_solicitud&_
								" UNION   "&_
								" SELECT 2 as orden,a.banc_ccod  as tsof_plan_cuenta, 'REGISTRO DE CHEQUES VENCIDOS' as TSOF_GLOSA_SIN_ACENTO, eche_mmonto as tsof_debe   "&_
								" , 0 as TSOF_HABER, CajCod as TSOF_COD_CONCEPTO_CAJA, 'CP' AS TSOF_TIPO_DOC_CONCILIACION, eche_ndocto AS TSOF_NRO_DOC_CONCILIACION "&_
								" , null as TSOF_COD_AUXILIAR, '' as TSOF_TIPO_DOCUMENTO, NULL as TSOF_NRO_DOCUMENTO, null as TSOF_FECHA_EMISION_CORTA "&_
								" , null as TSOF_FECHA_VENCIMIENTO_CORTA, '' AS TSOF_TIPO_DOC_REFERENCIA, NULL AS TSOF_NRO_DOC_REFERENCIA "&_
								" FROM ocag_entrega_cheques a  "&_
								" inner join ocag_bancos_softland b on a.banc_ccod=b.banc_tcodigo  "&_
								" WHERE eche_ndocto="&v_solicitud
								
				'response.Write("<pre>"&sql_doctos&"</pre>")
				'RESPONSE.END()
								
	'******************************************
		Set CreaCarpeta = CreateObject("Scripting.FileSystemObject")
	
		If Not CreaCarpeta.FolderExists(RUTA_ARCHIVOS_CHEQUES_VENCIDOS&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja) Then
		' si no existe el directorio Año/Mes/Dia, evaluamos si existe el mes	
		
			If CreaCarpeta.FolderExists(RUTA_ARCHIVOS_CHEQUES_VENCIDOS&"\"&v_ano_caja&"\"&v_mes_caja) Then
				
				'Existe directorio .../Año/mes/
				'se debe crear entonces el directorio /dia
				Set Carpeta = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_CHEQUES_VENCIDOS&"\"&v_ano_caja&"\"&v_mes_caja)
				Set subcarpera = Carpeta.subFolders
				subcarpera.add(v_dia_caja)
			
			else
				' sino, se evalua si existe el año por si solo
				If CreaCarpeta.FolderExists(RUTA_ARCHIVOS_CHEQUES_VENCIDOS&"\"&v_ano_caja) Then
				'Existe directorio .../Año
	
					'se debe crear entonces el directorio /mes
					Set Carpeta = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_CHEQUES_VENCIDOS&"\"&v_ano_caja)
					Set subcarpera = Carpeta.subFolders
					subcarpera.add(v_mes_caja)
					
					'se debe crear entonces el directorio /mes/dia
					Set Carpeta2 = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_CHEQUES_VENCIDOS&"\"&v_ano_caja&"\"&v_mes_caja)
					Set subcarpera2 = Carpeta2.subFolders
					subcarpera2.add(v_dia_caja)
					
				else
				
					' se crea el directorio /año
					CreaCarpeta.CreateFolder(RUTA_ARCHIVOS_CHEQUES_VENCIDOS&"\"&v_ano_caja)
	
					' se crea el sub-directorio /mes
					Set Carpeta = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_CHEQUES_VENCIDOS&"\"&v_ano_caja)
					Set subcarpera = Carpeta.subFolders
					subcarpera.add(v_mes_caja)
	
					' se crea el sub-directorio /dia
					Set Carpeta2 = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_CHEQUES_VENCIDOS&"\"&v_ano_caja&"\"&v_mes_caja)
					Set subcarpera2 = Carpeta2.subFolders
					subcarpera2.add(v_dia_caja)
								
				End if
				
			End if
			
		End If
		
		v_ruta_salida_nueva		=	RUTA_ARCHIVOS_CHEQUES_VENCIDOS&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja
		
		'RESPONSE.WRITE("<br> 6. v_ruta_salida_nueva : "&v_ruta_salida_nueva&"<BR>")
		
		'******************************************
		v_nombre_cajero	=	p_conexion.ConsultaUno(sql_nombre)
		archivo_salida 		= v_nombre_cajero&"_"&txt_tipo&"_"&v_solicitud & ".txt"
		
		'RESPONSE.WRITE("<br> 7. archivo_salida : "&archivo_salida&"<BR>")
	
		' Creacion de archivos de cajas
		set fso = Server.CreateObject("Scripting.FileSystemObject")
		set o_texto_archivo = fso.CreateTextFile(v_ruta_salida_nueva & "\" & archivo_salida)
	
		'--------------------------------------------------------------------------------------------------------------
	

									set f_efes_2 = new CFormulario
									f_efes_2.Carga_Parametros "consulta.xml", "consulta"
									f_efes_2.Inicializar conectar	
	
									'f_efes.Consultar SQL
									f_efes_2.Consultar sql_doctos
	
									AGRUPADOR_CAMPOS_SOFT="1"
	
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

											o_texto_archivo.WriteLine(linea)

									wend

	'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
											
		o_texto_archivo.Close ' Escritura en archivo base de la caja
	
		'----------------------------------------------------------------------------------------------------------------
		set o_texto_archivo = Nothing
		set fso = Nothing
		set f_efes_2 = Nothing
		
		
		Set Carpeta = Nothing
		Set subcarpera = Nothing
		Set subcarpera2 = Nothing 
		Set CreaCarpeta = Nothing
	
	
	'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	' AHORA TERMINA EL DOCUMENTO DE TEXTO
	end if

'ind2=ind2+1
next

'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

'------------------------------------------------------------------------------------

'conectar.estadotransaccion false
'response.End()

v_estado_transaccion = conectar.ObtenerEstadoTransaccion
'v_estado_transaccion = conexion.ObtenerEstadoTransaccion

if v_estado_transaccion=false  then
'if conectar.ObtenerEstadoTransaccion  then
	session("mensaje_error")="No se pudo traspasar a vencidos el o los cheques seleccionados.\nVuelva a intentarlo."
else	
	session("mensaje_error")="Los cheques seleccionados fueron traspasado a vencidos correctamente."
end if

response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
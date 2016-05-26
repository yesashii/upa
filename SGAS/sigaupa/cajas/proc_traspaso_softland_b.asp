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

v_ruta_salida_nueva=""
	
sql_nombre= " Select SUBSTRING(per.pers_tnombre, 1, 1)+''+per.pers_tape_paterno+'_'+per.pers_tape_materno+'_'+cast(day(mc.mcaj_finicio) as varchar)+'-'+cast(month(mc.mcaj_finicio)as varchar)+'-'+cast(year(mc.mcaj_finicio)as varchar) as nombre "& vbCrLf &_
			" From cajeros caj , personas per ,movimientos_cajas mc "& vbCrLf &_
			" where caj.pers_ncorr=per.pers_ncorr "& vbCrLf &_
			" and mc.caje_ccod=caj.caje_ccod "& vbCrLf &_
			" and mc.mcaj_ncorr='"&p_mcaj_ncorr&"'"
'response.Write("<pre>"&sql_nombre&"</pre>")
'response.End()

v_dia_caja =p_conexion.consultaUno("select day(mcaj_finicio) from movimientos_cajas where mcaj_ncorr='"&p_mcaj_ncorr&"'")
'v_mes_caja =p_conexion.ConsultaUno("select month(mcaj_finicio) from movimientos_cajas where mcaj_ncorr='"&p_mcaj_ncorr&"'")
v_mes_caja =p_conexion.ConsultaUno("select mes_tdesc from movimientos_cajas a, meses b where month(mcaj_finicio)=mes_ccod and a.mcaj_ncorr='"&p_mcaj_ncorr&"'")
v_ano_caja =p_conexion.ConsultaUno("select year(mcaj_finicio) from movimientos_cajas where mcaj_ncorr='"&p_mcaj_ncorr&"'")
v_editorial= "editorial"
'******************************************
	Set CreaCarpeta = CreateObject("Scripting.FileSystemObject")

	If Not CreaCarpeta.FolderExists(RUTA_ARCHIVOS_SALIDA_SOFTLAND&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja) Then
' si no existe el directorio Año/Mes/Dia, evaluamos si existe el mes	
	
		If CreaCarpeta.FolderExists(RUTA_ARCHIVOS_SALIDA_SOFTLAND&"\"&v_ano_caja&"\"&v_mes_caja) Then
			'response.Write("<li>Existe directorio medio : "&RUTA_ARCHIVOS_SALIDA_SOFTLAND&"\"&v_ano_caja&"\"&v_mes_caja)
			'Existe directorio .../Año/mes/
			'se debe crear entonces el directorio /dia
			Set Carpeta = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_SALIDA_SOFTLAND&"\"&v_ano_caja&"\"&v_mes_caja)
			Set subcarpera = Carpeta.subFolders
			subcarpera.add(v_dia_caja)
			
			'se debe crear entonces el directorio /dia/editorial
			Set Carpeta3 = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_SALIDA_SOFTLAND&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja)
			Set subcarpera3 = Carpeta3.subFolders
			subcarpera3.add(v_editorial)
		else
			' sino, se evalua si existe el año por si solo
			If CreaCarpeta.FolderExists(RUTA_ARCHIVOS_SALIDA_SOFTLAND&"\"&v_ano_caja) Then
			'Existe directorio .../Año

				'se debe crear entonces el directorio /mes
				Set Carpeta = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_SALIDA_SOFTLAND&"\"&v_ano_caja)
				Set subcarpera = Carpeta.subFolders
				subcarpera.add(v_mes_caja)
				
				'se debe crear entonces el directorio /mes/dia
				Set Carpeta2 = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_SALIDA_SOFTLAND&"\"&v_ano_caja&"\"&v_mes_caja)
				Set subcarpera2 = Carpeta2.subFolders
				subcarpera2.add(v_dia_caja)
				
				'se debe crear entonces el directorio /dia/editorial
				Set Carpeta3 = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_SALIDA_SOFTLAND&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja)
				Set subcarpera3 = Carpeta3.subFolders
				subcarpera3.add(v_editorial)
				
			else
				' se crea el directorio /año
				CreaCarpeta.CreateFolder(RUTA_ARCHIVOS_SALIDA_SOFTLAND&"\"&v_ano_caja)

				' se crea el sub-directorio /mes
				Set Carpeta = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_SALIDA_SOFTLAND&"\"&v_ano_caja)
				Set subcarpera = Carpeta.subFolders
				subcarpera.add(v_mes_caja)

				' se crea el sub-directorio /dia
				Set Carpeta2 = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_SALIDA_SOFTLAND&"\"&v_ano_caja&"\"&v_mes_caja)
				Set subcarpera2 = Carpeta2.subFolders
				subcarpera2.add(v_dia_caja)
				
				' se crea el sub-directorio /editorial
				Set Carpeta3 = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_SALIDA_SOFTLAND&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja)
				Set subcarpera3 = Carpeta3.subFolders
				subcarpera3.add(v_editorial)
			End if
		End if
	else
		If not CreaCarpeta.FolderExists(RUTA_ARCHIVOS_SALIDA_SOFTLAND&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja&"\"&v_editorial) Then
			
			Set Carpeta = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_SALIDA_SOFTLAND&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja)
			Set subcarpera = Carpeta.subFolders
			subcarpera.add(v_editorial)
			
		end if
		
	End If
		


v_ruta_salida_nueva=RUTA_ARCHIVOS_SALIDA_SOFTLAND&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja
v_ruta_salida_empre=RUTA_ARCHIVOS_SALIDA_SOFTLAND&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja&"\"&v_editorial

'******************************************
'response.End()	
	v_nombre_cajero	=	p_conexion.ConsultaUno(sql_nombre)
	v_apoderado		=	"aux"
	archivo_salida 		= v_nombre_cajero&"_"& p_mcaj_ncorr & ".txt"
	archivo_salida_empre= v_nombre_cajero&"_editorial_"& p_mcaj_ncorr & ".txt"
	archivo_salida_2 	= v_apoderado&"_"& p_mcaj_ncorr & ".txt"

	set fso = Server.CreateObject("Scripting.FileSystemObject")
	set o_texto_archivo = fso.CreateTextFile(v_ruta_salida_nueva & "\" & archivo_salida)
	
	set fso_empre = Server.CreateObject("Scripting.FileSystemObject")
	set o_texto_archivo_empre = fso.CreateTextFile(v_ruta_salida_empre & "\" & archivo_salida_empre)

'response.Write("<br> archivo salida: "&v_ruta_salida_nueva & "\" & archivo_salida)
'response.Flush()
	' segundo archivo datos apoderado
	set fso2 = Server.CreateObject("Scripting.FileSystemObject")
	set o_texto_archivo_2 = fso2.CreateTextFile(v_ruta_salida_nueva & "\" & archivo_salida_2)
'response.Write("<br> archivo salida: "&v_ruta_salida_nueva & "\" & archivo_salida_2)
'response.Flush()
	
	if Err.Number <> 0 then
		response.Write("<br> Error :"&Err.Description):response.Flush()
		TablaAArchivo = false
		Exit Function
	end if
	'--------------------------------------------------------------------------------------------------------------
	
	set f_consulta = new CFormulario
	f_consulta.Carga_Parametros "consulta.xml", "consulta"
	f_consulta.Inicializar p_conexion	
	
	SQL = 	"Select protic.trunc(TSOF_FECHA_EMISION) as TSOF_FECHA_EMISION_CORTA," & vbCrLf &_
			" protic.trunc(TSOF_FECHA_VENCIMIENTO) as TSOF_FECHA_VENCIMIENTO_CORTA, "& vbCrLf &_
			" protic.extrae_acentos(TSOF_GLOSA) as TSOF_GLOSA_SIN_ACENTO, "& vbCrLf &_
			" protic.extrae_acentos(replace(trca_nombre_a,'-','_')) as trca_nombre_acento,protic.extrae_acentos(replace(trca_nombre_c,'-','_')) as trca_nombre_cacento,"& vbCrLf &_
			" protic.extrae_acentos(replace(trca_paterno_a,'-','_')) as trca_paterno_acento,protic.extrae_acentos(replace(trca_materno_a,'-','_')) as trca_materno_acento, "& vbCrLf &_
			" protic.extrae_acentos(replace(trca_paterno_c,'-','_')) as trca_paterno_cacento,protic.extrae_acentos(replace(trca_materno_c,'-','_')) as trca_materno_cacento, *  "& vbCrLf &_
			" From traspasos_cajas_softland where mcaj_ncorr = '" & p_mcaj_ncorr & "' " & vbCrLf &_ 
			" and tsof_empresa is null " & vbCrLf &_
			" order by ting_ccod desc, ingr_nfolio_referencia asc, tsof_nro_agrupador, trca_nlinea asc"	
	f_consulta.Consultar SQL
	
	
	while f_consulta.Siguiente
		linea = ""
		
		linea = linea & f_consulta.ObtenerValor("tsof_plan_cuenta") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("tsof_debe") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_HABER") & DELIMITADOR_CAMPOS_SOFT
		linea = linea & f_consulta.ObtenerValor("TSOF_GLOSA_SIN_ACENTO") & DELIMITADOR_CAMPOS_SOFT
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
		

	wend

	o_texto_archivo.Close


set f_consulta_empre = new CFormulario
	f_consulta_empre.Carga_Parametros "consulta.xml", "consulta"
	f_consulta_empre.Inicializar p_conexion	
	
	SQL = 	"Select protic.trunc(TSOF_FECHA_EMISION) as TSOF_FECHA_EMISION_CORTA," & vbCrLf &_
			" protic.trunc(TSOF_FECHA_VENCIMIENTO) as TSOF_FECHA_VENCIMIENTO_CORTA, "& vbCrLf &_
			" protic.extrae_acentos(TSOF_GLOSA) as TSOF_GLOSA_SIN_ACENTO, "& vbCrLf &_
			" protic.extrae_acentos(replace(trca_nombre_a,'-','_')) as trca_nombre_acento,protic.extrae_acentos(replace(trca_nombre_c,'-','_')) as trca_nombre_cacento,"& vbCrLf &_
			" protic.extrae_acentos(replace(trca_paterno_a,'-','_')) as trca_paterno_acento,protic.extrae_acentos(replace(trca_materno_a,'-','_')) as trca_materno_acento, "& vbCrLf &_
			" protic.extrae_acentos(replace(trca_paterno_c,'-','_')) as trca_paterno_cacento,protic.extrae_acentos(replace(trca_materno_c,'-','_')) as trca_materno_cacento, *  "& vbCrLf &_
			" From traspasos_cajas_softland where mcaj_ncorr = '" & p_mcaj_ncorr & "' " & vbCrLf &_ 
			" and tsof_empresa =1 " & vbCrLf &_
			" order by ting_ccod desc, ingr_nfolio_referencia asc, tsof_nro_agrupador, trca_nlinea asc"	
			
	f_consulta_empre.Consultar SQL
	
	
	while f_consulta_empre.Siguiente
		linea_empre = ""
		
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("tsof_plan_cuenta") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("tsof_debe") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_HABER") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_GLOSA_SIN_ACENTO") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_EQUIVALENCIA") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_DEBE_ADICIONAL") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_HABER_ADICIONAL") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_COD_CONDICION_VENTA") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_COD_VENDEDOR") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_COD_UBICACION") & DELIMITADOR_CAMPOS_SOFT		
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_COD_CONCEPTO_CAJA") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_COD_INSTRUMENTO_FINAN") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_CANT_INSTRUMENTO_FINAN") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_COD_DETALLE_GASTO") & DELIMITADOR_CAMPOS_SOFT		
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_CANT_CONCEPTO_GASTO") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_COD_CENTRO_COSTO") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_TIPO_DOC_CONCILIACION") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_NRO_DOC_CONCILIACION") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_COD_AUXILIAR") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_TIPO_DOCUMENTO") & DELIMITADOR_CAMPOS_SOFT		
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_NRO_DOCUMENTO") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_FECHA_EMISION_CORTA") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_FECHA_VENCIMIENTO_CORTA") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_TIPO_DOC_REFERENCIA") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_NRO_DOC_REFERENCIA") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_NRO_CORRELATIVO") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_MONTO_DET_LIBRO1") & DELIMITADOR_CAMPOS_SOFT		
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_MONTO_DET_LIBRO2") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_MONTO_DET_LIBRO3") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_MONTO_DET_LIBRO4") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_MONTO_DET_LIBRO5") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_MONTO_DET_LIBRO6") & DELIMITADOR_CAMPOS_SOFT		
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_MONTO_DET_LIBRO7") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_MONTO_DET_LIBRO8") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_MONTO_DET_LIBRO9") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_MONTO_SUMA_DET_LIBRO") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_NRO_DOCUMENTO_DESDE") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_NRO_DOCUMENTO_HASTA") & DELIMITADOR_CAMPOS_SOFT
		linea_empre = linea_empre & f_consulta_empre.ObtenerValor("TSOF_NRO_AGRUPADOR") 

			
		o_texto_archivo_empre.WriteLine(linea_empre)
		

	wend

	o_texto_archivo_empre.Close	

set f_auxiliares = new CFormulario
	f_auxiliares.Carga_Parametros "consulta.xml", "consulta"
	f_auxiliares.Inicializar p_conexion	
	

 sql_aux = "Select distinct TSOF_ACTIVA,TSOF_CLASIFICA_CLIENTE,TSOF_CLASIFICA_PROVEEDOR,TSOF_CLASIFICA_EMPLEADO,"& vbCrLf &_
		" TSOF_CLASIFICA_SOCIO,TSOF_CLASIFICA_DISTRIBUIDOR,TSOF_CLASIFICA_OTRO,pers_nrut,pers_xdv, "& vbCrLf &_
       	" max(protic.extrae_acentos(replace(trca_nombre_a,'-','_'))) as trca_nombre_acento, "& vbCrLf &_
	   	" max(protic.extrae_acentos(replace(trca_paterno_a,'-','_'))) as trca_paterno_acento, "& vbCrLf &_
       	" max(protic.extrae_acentos(replace(trca_materno_a,'-','_'))) as trca_materno_acento "& vbCrLf &_  
	  	" From traspasos_cajas_softland where mcaj_ncorr = '" & p_mcaj_ncorr & "' "& vbCrLf &_
		" and pers_nrut >0 "& vbCrLf &_
      	" group by TSOF_ACTIVA,TSOF_CLASIFICA_CLIENTE,TSOF_CLASIFICA_PROVEEDOR,TSOF_CLASIFICA_EMPLEADO,TSOF_CLASIFICA_SOCIO,TSOF_CLASIFICA_DISTRIBUIDOR,TSOF_CLASIFICA_OTRO,pers_nrut,pers_xdv "& vbCrLf &_
  "union  "& vbCrLf &_
 		"Select distinct TSOF_ACTIVA,TSOF_CLASIFICA_CLIENTE,TSOF_CLASIFICA_PROVEEDOR,TSOF_CLASIFICA_EMPLEADO,"& vbCrLf &_
		" TSOF_CLASIFICA_SOCIO,TSOF_CLASIFICA_DISTRIBUIDOR,TSOF_CLASIFICA_OTRO,pers_nrut,pers_xdv, "& vbCrLf &_
       	" max(protic.extrae_acentos(replace(trca_nombre_c,'-','_'))) as trca_nombre_acento, "& vbCrLf &_
  	    " max(protic.extrae_acentos(replace(trca_paterno_c,'-','_'))) as trca_paterno_acento, "& vbCrLf &_
       	" max(protic.extrae_acentos(replace(trca_materno_c,'-','_'))) as trca_materno_acento "& vbCrLf &_   
  		" From traspasos_cajas_softland where mcaj_ncorr = '" & p_mcaj_ncorr & "' "& vbCrLf &_
		" and pers_nrut >0 "& vbCrLf &_
     	" group by TSOF_ACTIVA,TSOF_CLASIFICA_CLIENTE,TSOF_CLASIFICA_PROVEEDOR,TSOF_CLASIFICA_EMPLEADO,TSOF_CLASIFICA_SOCIO,TSOF_CLASIFICA_DISTRIBUIDOR,TSOF_CLASIFICA_OTRO,pers_nrut,pers_xdv "

	f_auxiliares.Consultar sql_aux
	
	
	while f_auxiliares.Siguiente

		if f_auxiliares.ObtenerValor("TSOF_ACTIVA") = "S" and f_auxiliares.ObtenerValor("pers_nrut") <> "" and f_auxiliares.ObtenerValor("trca_nombre_acento") <> "" then
			linea2 = ""
			linea2 = linea2 & f_auxiliares.ObtenerValor("pers_nrut") & DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & f_auxiliares.ObtenerValor("trca_paterno_acento")& " " & f_auxiliares.ObtenerValor("trca_materno_acento")& " " & f_auxiliares.ObtenerValor("trca_nombre_acento") & DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & ""&DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & f_auxiliares.ObtenerValor("pers_nrut") & "-" & f_auxiliares.ObtenerValor("pers_xdv") & DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & f_auxiliares.ObtenerValor("TSOF_ACTIVA") & DELIMITADOR_CAMPOS_SOFT
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
			linea2 = linea2 & f_auxiliares.ObtenerValor("TSOF_CLASIFICA_CLIENTE") & DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & f_auxiliares.ObtenerValor("TSOF_CLASIFICA_PROVEEDOR") & DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & f_auxiliares.ObtenerValor("TSOF_CLASIFICA_EMPLEADO") & DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & f_auxiliares.ObtenerValor("TSOF_CLASIFICA_SOCIO") & DELIMITADOR_CAMPOS_SOFT		
			linea2 = linea2 & f_auxiliares.ObtenerValor("TSOF_CLASIFICA_DISTRIBUIDOR") & DELIMITADOR_CAMPOS_SOFT
			linea2 = linea2 & f_auxiliares.ObtenerValor("TSOF_CLASIFICA_OTRO") & DELIMITADOR_CAMPOS_SOFT
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
	o_texto_archivo_2.Close

	'----------------------------------------------------------------------------------------------------------------
	set o_texto_archivo = Nothing
	set fso = Nothing
	set o_texto_archivo_empre = Nothing
	set fso_empre = Nothing
	set o_texto_archivo_2 = Nothing
	set fso2 = Nothing
	set f_consulta = Nothing
	set f_consulta_empre = Nothing
	set f_auxiliares = Nothing
	
    Set Carpeta = Nothing
	Set subcarpera = Nothing
	Set subcarpera2 = Nothing 
	Set CreaCarpeta = Nothing

	TablaAArchivo = true
	
End Function


'------------------------------------------------------------------------------------
set f_cajas = new CFormulario
f_cajas.Carga_Parametros "traspaso_cajas.xml", "cajas"
f_cajas.Inicializar conexion
f_cajas.ProcesaForm

msj_error = ""
'for i_ = 0 to f_cajas.CuentaPost - 1
'	v_mcaj_ncorr = f_cajas.ObtenerValorPost(i_, "mcaj_ncorr")
'	v_tcaj_ccod = f_cajas.ObtenerValorPost(i_, "tcaj_ccod")
v_mcaj_ncorr=10710
v_tcaj_ccod=1000

	if not EsVacio(v_mcaj_ncorr) then
		set con2 = new CConexion
		con2.Inicializar "upacifico"
'		if v_tcaj_ccod="1001" then
'			sentencia = "exec TRASPASAR_CAJA_SOLFTLAND_ANULACION " & v_mcaj_ncorr & ", '" & v_usuario & "'"
'		else
'			sentencia = "exec TRASPASAR_CAJA_SOLFTLAND " & v_mcaj_ncorr & ", '" & v_usuario & "'"
'		end if
'		response.Write("<pre>"&sentencia&"</pre>")
'		
'		v_salida=con2.ConsultaUno(sentencia)
'response.End()
'		if cint(v_salida) = 0 then
			if TablaAArchivo(v_mcaj_ncorr, con2) then
				sentencia = "update movimientos_cajas set eren_ccod=4, mcaj_barchivo_creado_softland = 'S' where mcaj_ncorr = '" & v_mcaj_ncorr & "'"
			else
				sentencia = "update movimientos_cajas set mcaj_barchivo_creado_softland = 'N' where mcaj_ncorr = '" & v_mcaj_ncorr & "'"
			end if
			
			con2.ejecutas(sentencia)
'		else
'			msj_error = msj_error &" Caja : "& v_mcaj_ncorr & "\n"	
'		end if
		
		set con2 = Nothing	
		
	end if	
'next

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


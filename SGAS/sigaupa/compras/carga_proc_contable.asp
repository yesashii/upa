<!-- #include file = "generador.asp" -->
<%
	
	'---------- CONEXION A SOFTLAND ----------'
	set conectarse = new Cconexion2
	conectarse.Inicializar "upacifico"
	
	'---------- CONEXION A SIGAUPA ----------'
	set conexion = new Cconexion
	conexion.Inicializar "upacifico"
	
	set p_conexion = new CConexion
	p_conexion.Inicializar "upacifico"
	'---------- CREAR FORMULARIO ----------'
	
	set grilla20 = new CFormulario
	grilla20.Carga_Parametros "tabla_vacia.xml", "tabla"
	grilla20.Inicializar conexion
	
	
	v_ano_caja = p_conexion.ConsultaUno("select year(getDate())")
	v_mes_caja = p_conexion.ConsultaUno("select month(getDate())")

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
%>
<html>
	<head>
		<title>Tabla CWPCTAS Softland</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
		<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
		<style>
			.Mimetismo { background-color:#ADADAD;border: 1px #ADADAD solid; font-size:10px; font-style:oblique; font:bold;}
		</style>
		<script language="JavaScript" src="../biblioteca/tabla.js"></script>
		<script language="JavaScript" src="../biblioteca/funciones.js"></script>
		<script language="JavaScript" src="../biblioteca/validadores.js"></script>
		<script language="JavaScript" src="generador.js"></script>
		<script type="text/javascript" src="http://code.jquery.com/jquery-1.10.1.min.js"></script>
	</head>
	<body style="text-align:center">
		<%
			ind2=0
			for each k in request.form
				v_boleta = ""
				v_boleta=request.Form("datos["&ind2&"][sogi_bboleta_honorario]")				
				solicitud=request.Form("datos["&ind2&"][tsol_ccod]")
				numer=request.Form("datos["&ind2&"][cod_solicitud]")
				'response.write numer &" "&solicitud&"<br>"
				if numer <> "" then
					select case solicitud
						case 1 :
							txt_tipo="Pago_Proveedores"
						case 2 :
							txt_tipo="Reembolso_Gatos"
						case 3 :
							txt_tipo="Fondos_Rendir"
						case 4 :
							txt_tipo="Solicitud_Viaticos"
						case 5 :
							txt_tipo="Devolucion_alumnos"
						case 6 :
							txt_tipo="Fondo_Fijo"
						case 7 :
							txt_tipo="Rendicion_Fondos_Rendir"
						case 8 :
							txt_tipo="Rendicion_Fondo_Fijo"
					end select
					debe=0
					haber=0
					
					'---------- CREAR ARCHIVO ----------'
					Set CreaCarpeta = CreateObject("Scripting.FileSystemObject")
		            
					If Not CreaCarpeta.FolderExists(RUTA_ARCHIVOS_CARGA_CONTABLE&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja) Then
						' si no existe el directorio Año/Mes/Dia, evaluamos si existe el mes	
						If CreaCarpeta.FolderExists(RUTA_ARCHIVOS_CARGA_CONTABLE&"\"&v_ano_caja&"\"&v_mes_caja) Then
								
							'Existe directorio .../Año/mes/
							'se debe crear entonces el directorio /dia
							Set Carpeta = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_CARGA_CONTABLE&"\"&v_ano_caja&"\"&v_mes_caja)
							Set subcarpera = Carpeta.subFolders
							subcarpera.add(v_dia_caja)
						else
							' sino, se evalua si existe el año por si solo
							If CreaCarpeta.FolderExists(RUTA_ARCHIVOS_CARGA_CONTABLE&"\"&v_ano_caja) Then
								'Existe directorio .../Año
								'se debe crear entonces el directorio /mes
								Set Carpeta = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_CARGA_CONTABLE&"\"&v_ano_caja)
								Set subcarpera = Carpeta.subFolders
								subcarpera.add(v_mes_caja)

								'se debe crear entonces el directorio /mes/dia
								Set Carpeta2 = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_CARGA_CONTABLE&"\"&v_ano_caja&"\"&v_mes_caja)
								Set subcarpera2 = Carpeta2.subFolders
								subcarpera2.add(v_dia_caja)		
							else
								' se crea el directorio /año
								CreaCarpeta.CreateFolder(RUTA_ARCHIVOS_CARGA_CONTABLE&"\"&v_ano_caja)
								' se crea el sub-directorio /mes
								Set Carpeta = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_CARGA_CONTABLE&"\"&v_ano_caja)
								Set subcarpera = Carpeta.subFolders
								subcarpera.add(v_mes_caja)
								' se crea el sub-directorio /dia
								Set Carpeta2 = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_CARGA_CONTABLE&"\"&v_ano_caja&"\"&v_mes_caja)
								Set subcarpera2 = Carpeta2.subFolders
								subcarpera2.add(v_dia_caja)
							End if
						End if
					End If
				    
					v_ruta_salida_nueva		=	RUTA_ARCHIVOS_CARGA_CONTABLE&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja
				    
					' Creacion de archivos de cajas
					set fso = Server.CreateObject("Scripting.FileSystemObject")
					
					
					set negocio = new CNegocio
					negocio.Inicializa conexion
	                
					v_usuario = negocio.ObtenerUsuario
					sql_nombre= "Select PERS_TAPE_PATERNO + '_' + SUBSTRING(PERS_TNOMBRE,1,1) as NOMBRE from personas "& vbCrLf &_
					"where cast(pers_nrut as varchar)='"&v_usuario&"'"
					v_nombre_cajero	=	p_conexion.ConsultaUno(sql_nombre)
					archivo_salida 		= v_nombre_cajero&"_"&txt_tipo&"_"&numer & ".txt"
					
					set salidad = fso.CreateTextFile(v_ruta_salida_nueva & "\" & archivo_salida)
					'---------- FIN CREAR ARCHIVO ----------'
					
					'---------- CREAR ENCABEZADO ----------'
					sql_encabezados = generarsqlencabezado(solicitud, numer)
					response.write "<pre>"&sql_encabezados &"</pre><br>"
					set grilla20 = new CFormulario
					grilla20.Carga_Parametros "tabla_vacia.xml", "tabla"
					grilla20.Inicializar conexion
					grilla20.Consultar sql_encabezados
					
					while grilla20.siguiente
						debe = CStr(grilla20.obtenerValor("TSOF_DEBE"))+debe
						haber= CStr(grilla20.obtenerValor("TSOF_HABER"))+haber
						codigo=grilla20.obtenerValor("TSOF_PLAN_CUENTA")
						linea = ""
						linea = linea & grilla20.obtenerValor("TSOF_PLAN_CUENTA")&  DELIMITADOR_CAMPOS_SOFT
						linea = linea & ROUND(grilla20.obtenerValor("TSOF_DEBE"))& DELIMITADOR_CAMPOS_SOFT
						linea = linea & ROUND(grilla20.obtenerValor("TSOF_HABER"))& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_GLOSA_SIN_ACENTO")& DELIMITADOR_CAMPOS_SOFT
						if obtener(codigo, "pcmone") then
							linea = linea & grilla20.obtenerValor("TSOF_EQUIVALENCIA")& DELIMITADOR_CAMPOS_SOFT
						else
							linea = linea & DELIMITADOR_CAMPOS_SOFT
						end if
						linea = linea & grilla20.obtenerValor("TSOF_DEBE_ADICIONAL")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_HABER_ADICIONAL")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_COD_CONDICION_VENTA")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_COD_VENDEDOR")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_COD_UBICACION")& DELIMITADOR_CAMPOS_SOFT
						if obtener(codigo, "pcprec") then
							linea = linea & grilla20.obtenerValor("TSOF_COD_CONCEPTO_CAJA")& DELIMITADOR_CAMPOS_SOFT
						else
							linea = linea & DELIMITADOR_CAMPOS_SOFT
						end if
						if obtener(codigo, "pcifin") then
							linea = linea & grilla20.obtenerValor("TSOF_COD_INSTRUMENTO_FINAN")& DELIMITADOR_CAMPOS_SOFT
							linea = linea & grilla20.obtenerValor("TSOF_CANT_INSTRUMENTO_FINAN")& DELIMITADOR_CAMPOS_SOFT
						else
							linea = linea & DELIMITADOR_CAMPOS_SOFT
							linea = linea & DELIMITADOR_CAMPOS_SOFT
						end if
						if obtener(codigo, "pcdteg") then 
							linea = linea & grilla20.obtenerValor("TSOF_COD_DETALLE_GASTO")& DELIMITADOR_CAMPOS_SOFT
							linea = linea & grilla20.obtenerValor("TSOF_CANT_CONCEPTO_GASTO")& DELIMITADOR_CAMPOS_SOFT
						else
							linea = linea & DELIMITADOR_CAMPOS_SOFT
							linea = linea & DELIMITADOR_CAMPOS_SOFT
						end if
						if obtener(codigo, "pcccos") then 	
							linea = linea & grilla20.obtenerValor("TSOF_COD_CENTRO_COSTO")& DELIMITADOR_CAMPOS_SOFT
						else
							linea = linea & DELIMITADOR_CAMPOS_SOFT
						end if
						if obtener(codigo, "pcconb") then
							linea = linea & grilla20.obtenerValor("TSOF_TIPO_DOC_CONCILIACION")& DELIMITADOR_CAMPOS_SOFT
							linea = linea & grilla20.obtenerValor("TSOF_NRO_DOC_CONCILIACION")& DELIMITADOR_CAMPOS_SOFT
						else
							linea = linea & DELIMITADOR_CAMPOS_SOFT
							linea = linea & DELIMITADOR_CAMPOS_SOFT
						end if
						if obtener(codigo, "pcauxi") then	
						linea = linea & grilla20.obtenerValor("TSOF_COD_AUXILIAR")& DELIMITADOR_CAMPOS_SOFT
						else
							linea = linea & DELIMITADOR_CAMPOS_SOFT
						end if
						if obtener(codigo, "pccdoc") then	
						linea = linea & grilla20.obtenerValor("TSOF_TIPO_DOCUMENTO")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_NRO_DOCUMENTO")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_FECHA_EMISION_CORTA")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_FECHA_VENCIMIENTO_CORTA")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_TIPO_DOC_REFERENCIA")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_NRO_DOC_REFERENCIA")& DELIMITADOR_CAMPOS_SOFT
						else
							linea = linea & DELIMITADOR_CAMPOS_SOFT
							linea = linea & DELIMITADOR_CAMPOS_SOFT
							linea = linea & DELIMITADOR_CAMPOS_SOFT
							linea = linea & DELIMITADOR_CAMPOS_SOFT
							linea = linea & DELIMITADOR_CAMPOS_SOFT
							linea = linea & DELIMITADOR_CAMPOS_SOFT
						end if
						if obtener(codigo, "pcdinba") then
							if grilla20.obtenerValor("TSOF_TIPO_DOCUMENTO") = "FL" OR grilla20.obtenerValor("TSOF_TIPO_DOCUMENTO") = "FE" OR grilla20.obtenerValor("TSOF_TIPO_DOCUMENTO") = "FI" OR grilla20.obtenerValor("TSOF_TIPO_DOCUMENTO") = "FP" then
								linea = linea & grilla20.obtenerValor("TSOF_NRO_CORRELATIVO")& DELIMITADOR_CAMPOS_SOFT
							else
								linea = linea &  DELIMITADOR_CAMPOS_SOFT
							end if
						else
							linea = linea &  DELIMITADOR_CAMPOS_SOFT
						end if
						if grilla20.obtenerValor("TSOF_TIPO_DOC_REFERENCIA") = "FL" OR grilla20.obtenerValor("TSOF_TIPO_DOC_REFERENCIA") = "FE" OR grilla20.obtenerValor("TSOF_TIPO_DOC_REFERENCIA") = "FI" OR grilla20.obtenerValor("TSOF_TIPO_DOC_REFERENCIA") = "FP" then
							linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO1")& DELIMITADOR_CAMPOS_SOFT
							linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO2")& DELIMITADOR_CAMPOS_SOFT
							linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO3")& DELIMITADOR_CAMPOS_SOFT
						else
							linea = linea & DELIMITADOR_CAMPOS_SOFT
							linea = linea & DELIMITADOR_CAMPOS_SOFT
							linea = linea & DELIMITADOR_CAMPOS_SOFT
						end if
						linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO4")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO5")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO6")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO7")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO8")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO9")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_MONTO_SUMA_DET_LIBRO")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_NRO_DOCUMENTO_DESDE")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_NRO_DOCUMENTO_HASTA")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_NRO_AGRUPADOR")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_bullshet1")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_bullshet2")& DELIMITADOR_CAMPOS_SOFT
						if obtener(codigo, "pcprec") then	
						linea = linea & grilla20.obtenerValor("TSOF_COD_MESANO")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_MONTO_PRESUPUESTO")&""
						else
							linea = linea & DELIMITADOR_CAMPOS_SOFT
							linea = linea & ""
						end if
						if grilla20.obtenerValor("RETE") = "1" AND grilla20.obtenerValor("boleta") = "1" then
							salidad.WriteLine(linea)
							linea = ""
							linea = linea & "2-10-120-10-000003"&  DELIMITADOR_CAMPOS_SOFT
							linea = linea & 0 & DELIMITADOR_CAMPOS_SOFT
							linea = linea & ROUND(clng(grilla20.obtenerValor("TSOF_DEBE"))*0.1)& DELIMITADOR_CAMPOS_SOFT
							linea = linea & grilla20.obtenerValor("TSOF_GLOSA_SIN_ACENTO")& DELIMITADOR_CAMPOS_SOFT
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
							linea = linea & DELIMITADOR_CAMPOS_SOFT
							linea = linea & DELIMITADOR_CAMPOS_SOFT
							linea = linea & DELIMITADOR_CAMPOS_SOFT
							linea = linea & DELIMITADOR_CAMPOS_SOFT
							linea = linea & DELIMITADOR_CAMPOS_SOFT
							linea = linea & DELIMITADOR_CAMPOS_SOFT
							linea = linea & 1 & DELIMITADOR_CAMPOS_SOFT
							linea = linea & ""& DELIMITADOR_CAMPOS_SOFT
							linea = linea & ""& DELIMITADOR_CAMPOS_SOFT
							linea = linea & DELIMITADOR_CAMPOS_SOFT
							linea = linea & ""
						end if
						salidad.WriteLine(linea)
					wend
					dif = debe - haber
					
					response.write dif & "<br>"
					sql="SELECT b.ordc_ncorr AS orden, CASE WHEN a.cpag_ccod = 25 THEN '1-10-010-30-100001' ELSE '2-10-070-10-000002' END AS valor FROM ocag_solicitud_giro a"&_
					" INNER JOIN ocag_detalle_orden_compra b "&_
					" ON b.ordc_ncorr =a.ordc_ncorr"&_
					" WHERE a.sogi_ncorr ="&numer
					'response.write sql
					sql_encabezados = generadorpresupuesto(solicitud, numer)

					response.write "<pre>"&sql_encabezados &"</pre>"
					grilla20.Carga_Parametros "tabla_vacia.xml", "tabla"
					grilla20.Inicializar conexion
					grilla20.Consultar sql_encabezados
					while grilla20.siguiente
						linea = ""
						linea = linea & grilla20.obtenerValor("TSOF_PLAN_CUENTA")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & ROUND(grilla20.obtenerValor("TSOF_DEBE"))& DELIMITADOR_CAMPOS_SOFT
						linea = linea & ROUND(grilla20.obtenerValor("TSOF_HABER"))& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_GLOSA_SIN_ACENTO")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_EQUIVALENCIA")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_DEBE_ADICIONAL")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_HABER_ADICIONAL")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_COD_CONDICION_VENTA")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_COD_VENDEDOR")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_COD_UBICACION")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_COD_CONCEPTO_CAJA")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_COD_INSTRUMENTO_FINAN")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_CANT_INSTRUMENTO_FINAN")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_COD_DETALLE_GASTO")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_CANT_CONCEPTO_GASTO")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_COD_CENTRO_COSTO")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_TIPO_DOC_CONCILIACION")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_NRO_DOC_CONCILIACION")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_COD_AUXILIAR")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_TIPO_DOCUMENTO")& DELIMITADOR_CAMPOS_SOFT
						if grilla20.obtenerValor("TSOF_NRO_DOCUMENTO") <> "0" then 
							linea = linea & grilla20.obtenerValor("TSOF_NRO_DOCUMENTO")& DELIMITADOR_CAMPOS_SOFT
						else
							linea = linea &  DELIMITADOR_CAMPOS_SOFT
						end if
						linea = linea & grilla20.obtenerValor("TSOF_FECHA_EMISION_CORTA")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_FECHA_VENCIMIENTO_CORTA")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_TIPO_DOC_REFERENCIA")& DELIMITADOR_CAMPOS_SOFT
						if grilla20.obtenerValor("TSOF_NRO_DOC_REFERENCIA") <> "0" then 
							linea = linea & grilla20.obtenerValor("TSOF_NRO_DOC_REFERENCIA")& DELIMITADOR_CAMPOS_SOFT
						else
							linea = linea &  DELIMITADOR_CAMPOS_SOFT
						end if
						if grilla20.obtenerValor("TSOF_TIPO_DOCUMENTO") = "FL" OR grilla20.obtenerValor("TSOF_TIPO_DOCUMENTO") = "FE" OR grilla20.obtenerValor("TSOF_TIPO_DOCUMENTO") = "FI" OR grilla20.obtenerValor("TSOF_TIPO_DOCUMENTO") = "FP" OR grilla20.obtenerValor("TSOF_TIPO_DOCUMENTO") = "FX" then
							linea = linea & grilla20.obtenerValor("TSOF_NRO_CORRELATIVO")& DELIMITADOR_CAMPOS_SOFT
						else
							linea = linea &  DELIMITADOR_CAMPOS_SOFT
						end if
						if grilla20.obtenerValor("TSOF_TIPO_DOCUMENTO") <> "BC"then
							linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO1")& DELIMITADOR_CAMPOS_SOFT
							linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO2")& DELIMITADOR_CAMPOS_SOFT
							linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO3")& DELIMITADOR_CAMPOS_SOFT
						else
							linea = linea &  DELIMITADOR_CAMPOS_SOFT
							linea = linea &  DELIMITADOR_CAMPOS_SOFT
							linea = linea &  DELIMITADOR_CAMPOS_SOFT
						end if
						linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO4")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO5")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO6")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO7")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO8")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO9")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_MONTO_SUMA_DET_LIBRO")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_NRO_DOCUMENTO_DESDE")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_NRO_DOCUMENTO_HASTA")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_NRO_AGRUPADOR")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_bullshet1")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_bullshet2")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_COD_MESANO")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_MONTO_PRESUPUESTO")&""
						salidad.WriteLine(linea)
					wend
					
					sql_encabezados = generadorpresupuestototal(solicitud, numer, dife)

					response.write "<pre>"&sql_encabezados &"</pre>"
					grilla20.Carga_Parametros "tabla_vacia.xml", "tabla"
					grilla20.Inicializar conexion
					grilla20.Consultar sql_encabezados
					while grilla20.siguiente
						linea = ""
						linea = linea & grilla20.obtenerValor("TSOF_PLAN_CUENTA")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & ROUND(grilla20.obtenerValor("TSOF_DEBE"))& DELIMITADOR_CAMPOS_SOFT
						linea = linea & ROUND(grilla20.obtenerValor("TSOF_HABER"))& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_GLOSA_SIN_ACENTO")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_EQUIVALENCIA")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_DEBE_ADICIONAL")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_HABER_ADICIONAL")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_COD_CONDICION_VENTA")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_COD_VENDEDOR")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_COD_UBICACION")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_COD_CONCEPTO_CAJA")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_COD_INSTRUMENTO_FINAN")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_CANT_INSTRUMENTO_FINAN")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_COD_DETALLE_GASTO")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_CANT_CONCEPTO_GASTO")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_COD_CENTRO_COSTO")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_TIPO_DOC_CONCILIACION")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_NRO_DOC_CONCILIACION")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_COD_AUXILIAR")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_TIPO_DOCUMENTO")& DELIMITADOR_CAMPOS_SOFT
						if grilla20.obtenerValor("TSOF_NRO_DOCUMENTO") <> "0" then 
							linea = linea & grilla20.obtenerValor("TSOF_NRO_DOCUMENTO")& DELIMITADOR_CAMPOS_SOFT
						else
							linea = linea &  DELIMITADOR_CAMPOS_SOFT
						end if
						linea = linea & grilla20.obtenerValor("TSOF_FECHA_EMISION_CORTA")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_FECHA_VENCIMIENTO_CORTA")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_TIPO_DOC_REFERENCIA")& DELIMITADOR_CAMPOS_SOFT
						if grilla20.obtenerValor("TSOF_NRO_DOC_REFERENCIA") <> "0" then 
							linea = linea & grilla20.obtenerValor("TSOF_NRO_DOC_REFERENCIA")& DELIMITADOR_CAMPOS_SOFT
						else
							linea = linea &  DELIMITADOR_CAMPOS_SOFT
						end if
						if grilla20.obtenerValor("TSOF_TIPO_DOCUMENTO") = "FL" OR grilla20.obtenerValor("TSOF_TIPO_DOCUMENTO") = "FE" OR grilla20.obtenerValor("TSOF_TIPO_DOCUMENTO") = "FI" OR grilla20.obtenerValor("TSOF_TIPO_DOCUMENTO") = "FP" OR grilla20.obtenerValor("TSOF_TIPO_DOCUMENTO") = "FX" then
							linea = linea & grilla20.obtenerValor("TSOF_NRO_CORRELATIVO")& DELIMITADOR_CAMPOS_SOFT
						else
							linea = linea &  DELIMITADOR_CAMPOS_SOFT
						end if
						if grilla20.obtenerValor("TSOF_TIPO_DOCUMENTO") <> "BC"then
							linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO1")& DELIMITADOR_CAMPOS_SOFT
							linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO2")& DELIMITADOR_CAMPOS_SOFT
							linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO3")& DELIMITADOR_CAMPOS_SOFT
						else
							linea = linea &  DELIMITADOR_CAMPOS_SOFT
							linea = linea &  DELIMITADOR_CAMPOS_SOFT
							linea = linea &  DELIMITADOR_CAMPOS_SOFT
						end if
						linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO4")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO5")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO6")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO7")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO8")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_MONTO_DET_LIBRO9")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_MONTO_SUMA_DET_LIBRO")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_NRO_DOCUMENTO_DESDE")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_NRO_DOCUMENTO_HASTA")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_NRO_AGRUPADOR")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_bullshet1")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_bullshet2")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_COD_MESANO")& DELIMITADOR_CAMPOS_SOFT
						linea = linea & grilla20.obtenerValor("TSOF_MONTO_PRESUPUESTO")&""
						salidad.WriteLine(linea)
					wend
					
					
					salidad.Close
					Set fso = Nothing
					Set salidad = Nothing
				end if 
				ind2=ind2+1
			next
			
			fecha_actual=conexion.consultaUno("select protic.trunc(getDate())")
			set f_solicitud = new cFormulario
			f_solicitud.carga_parametros "carga_contable.xml", "autoriza_solicitud_giro"
			f_solicitud.inicializar conexion
			f_solicitud.procesaForm
            'response.end
			for fila = 0 to f_solicitud.CuentaPost - 1
            
				v_cod_solicitud	= f_solicitud.ObtenerValorPost (fila, "cod_solicitud")
				v_aprueba	= f_solicitud.ObtenerValorPost (fila, "aprueba")
				v_tsol_ccod		= f_solicitud.ObtenerValorPost (fila, "tsol_ccod")
				v_observaciones = f_solicitud.ObtenerValorPost (fila, "asgi_tobservaciones")
				asgi_nestado	= f_solicitud.ObtenerValorPost (fila, "asgi_nestado")
            
				if v_cod_solicitud<>"" then
					if EsVacio(asgi_nestado) or asgi_nestado="" then
						asgi_nestado=1
					end if
					if v_aprueba="2" then
						vibo_ccod=7
						f_solicitud.AgregaCampoFilaPost fila, "vibo_ccod", vibo_ccod
						f_solicitud.AgregaCampoFilaPost fila, "asgi_nestado", asgi_nestado
						f_solicitud.AgregaCampoFilaPost fila, "asgi_observaciones", v_observaciones
						f_solicitud.AgregaCampoFilaPost fila, "asgi_fautorizado", fecha_actual					
					else
					vibo_ccod=7
					f_solicitud.AgregaCampoFilaPost fila,"vibo_ccod", vibo_ccod
					f_solicitud.AgregaCampoFilaPost fila,"asgi_nestado", asgi_nestado
					f_solicitud.AgregaCampoFilaPost fila,"asgi_fautorizado", fecha_actual	
					end if
					Select Case v_tsol_ccod
						Case 1:
							sql_update	=	"update ocag_solicitud_giro set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&" where sogi_ncorr="&v_cod_solicitud	
						Case 2:
							sql_update	=	"update ocag_reembolso_gastos set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&" where rgas_ncorr="&v_cod_solicitud	
						Case 3:
							sql_update	=	"update ocag_fondos_a_rendir set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&" where fren_ncorr="&v_cod_solicitud	
						Case 4:
							sql_update	=	"update ocag_solicitud_viatico set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&" where sovi_ncorr="&v_cod_solicitud	
						Case 5:
							sql_update	=	"update ocag_devolucion_alumno set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&" where dalu_ncorr="&v_cod_solicitud	
						Case 6:
							sql_update	=	"update ocag_fondo_fijo set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&" where ffij_ncorr="&v_cod_solicitud
						Case 7:
							sql_update	=	"update ocag_rendicion_fondos_a_rendir set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&" where rfre_ncorr="&v_cod_solicitud			
						Case 8:
							sql_update	=	"update ocag_rendicion_fondo_fijo set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&" where rffi_ncorr="&v_cod_solicitud
					End Select
					conexion.estadotransaccion  conexion.ejecutaS(sql_update)
				end if
			next
			f_solicitud.MantieneTablas false
			v_estado_transaccion = conexion.ObtenerEstadoTransaccion
			if v_estado_transaccion=false  then
				session("mensaje_error")="No se pudo ingresar el estado a la solicitud de giro.\nVuelva a intentarlo."
			else	
				session("mensaje_error")="El estado de la Solicitud de Giro fue ingresado correctamente."
			end if
			response.Redirect(request.ServerVariables("HTTP_REFERER"))
		%>
	</body>
</html>
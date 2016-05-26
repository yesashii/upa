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

'select case tsol_ccod

'	Case 16: ' Pago Proveedores
	
		txt_tipo="Cheques_Vencidos"
		
'		sql_doctos = "select * from ( "&_
'					" select tgas_cod_cuenta as cuenta,tgas_tdesc as descripcion,b.pers_nrut as auxiliar, "&_
'					" case when dorc_bafecta=1 then cast((dorc_nprecio_neto)*1.19 as numeric)  else dorc_nprecio_neto end as debe,0 as haber "&_
'					" , protic.trunc(ocag_fingreso) as fecha_solicitud "&_
'					" , e.ccos_tcodigo, 'PP' AS TDOCUMENTO "&_
'					" FROM ocag_solicitud_giro a "&_
'					" INNER JOIN personas b "&_
'					" ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr ="&v_solicitud&" "&_
'					" INNER JOIN ocag_detalle_solicitud_ag c "&_
'					" ON a.sogi_ncorr = c.sogi_ncorr "&_
'					" INNER JOIN ocag_tipo_gasto d "&_
'					" ON c.tgas_ccod = d.tgas_ccod "&_
'					" INNER JOIN ocag_centro_costo e "&_
'					" ON c.ccos_ncorr = e.ccos_ncorr "&_
'					" union  "&_
'					" select "&_
 ' 					"  CASE WHEN a.cpag_ccod = 25 THEN '1-10-010-30-100001' ELSE '2-10-070-10-000002' END as cuenta "&_
'					" ,CASE WHEN a.cpag_ccod = 25 THEN 'Banco de Chile ( 1-16264-00 -U ) cc' ELSE 'Cuentas por Pagar (Sist.Computac.)' END as descripcion	"&_
'					" ,b.pers_nrut as auxiliar,0 as debe, sogi_mgiro as haber, protic.trunc(ocag_fingreso) as fecha_solicitud "&_
'					" , '' AS ccos_tcodigo, 'PP' AS TDOCUMENTO "&_
'					" from ocag_solicitud_giro a "&_
'					" INNER JOIN personas b "&_
'					" ON a.pers_ncorr_proveedor = b.pers_ncorr and sogi_ncorr="&v_solicitud&" "&_
'					" ) as tabla "&_
'					" order by  debe desc "	
					
		sql_doctos = "SELECT banc_ccod  as cuenta "&_
					", 'REEMISION DE CHEQUE VENCIDO GENERICO' as descripcion "&_
					", pers_nrut AS auxiliar "&_
					", eche_mmonto as debe "&_
					", 0 as haber  "&_
					", protic.trunc(eche_fdocto) as fecha_solicitud "&_
					", CajCod as ccos_tcodigo "&_
					", 'CV' AS TDOCUMENTO "&_
					"FROM ocag_entrega_cheques "&_
					"WHERE eche_ndocto= "&v_solicitud&" "&_
					"union "&_
					"SELECT banc_ccod  as cuenta "&_
					", 'REEMISION DE CHEQUE VENCIDO GENERICO' as descripcion "&_
					", pers_nrut AS auxiliar "&_
					", 0 as debe "&_
					", eche_mmonto as haber  "&_
					", protic.trunc(eche_fdocto) as fecha_solicitud "&_
					", '' as ccos_tcodigo "&_
					", 'CV' AS TDOCUMENTO "&_
					"FROM ocag_entrega_cheques "&_
					"WHERE eche_ndocto="&v_solicitud
		
'		sql_efes=" select * from ( "&_
'					" select '2-10-070-10-000004' as cuenta,'Cuentas por Pagar con Control Presup.origen(Sist.Computac.)' as descripcion, "&_
'					" psol_mpresupuesto as debe,0 as haber,cod_pre,protic.trunc('01/'+cast(mes_ccod as varchar)+'/'+cast(anos_ccod as varchar)) as fecha, "&_
'					" case when mes_ccod<10 then '0'+cast(mes_ccod as varchar) else cast(mes_ccod as varchar) end  +cast(anos_ccod as varchar) as flujo "&_
'					" , 'PP' AS TDOCUMENTO "&_
'					"  from ocag_presupuesto_solicitud  "&_
'					" where cod_solicitud="&v_solicitud&" and tsol_ccod=1 "&_
'					" union "&_
'					" select '2-10-070-10-000004' as cuenta,'Cuentas por Pagar con Control Presup.origen(Sist.Computac.)' as descripcion, "&_
'					" 0 as debe,psol_mpresupuesto as haber,cod_pre,protic.trunc('01/'+cast(mes_ccod as varchar)+'/'+cast(anos_ccod as varchar)) as fecha, "&_
'					" case when mes_ccod<10 then '0'+cast(mes_ccod as varchar) else cast(mes_ccod as varchar) end  +cast(anos_ccod as varchar) as flujo "&_
'					" , 'PP' AS TDOCUMENTO "&_
'					" from ocag_presupuesto_solicitud  "&_
'					" where cod_solicitud="&v_solicitud&" and tsol_ccod=1 "&_
'					") as tabla "&_
'					" order by cod_pre, debe desc "
					
		sql_efes="SELECT banc_ccod  as cuenta "&_
					", 'REEMISION DE CHEQUE VENCIDO GENERICO' as descripcion "&_
					", eche_mmonto as debe "&_
					", 0 as haber  "&_
					", CajCod as cod_pre "&_
					", protic.trunc(eche_fdocto) as fecha "&_
					", case when MONTH(eche_fdocto)<10 then '0' + cast(MONTH(eche_fdocto) as varchar) "&_
 					" else cast(MONTH(eche_fdocto) as varchar) "&_
 					" end +cast(YEAR(eche_fdocto) as varchar) as flujo "&_
					", 'CV' AS TDOCUMENTO "&_
					"FROM ocag_entrega_cheques "&_
					"WHERE eche_ndocto= "&v_solicitud&" "&_
					"UNION "&_
					"SELECT banc_ccod  as cuenta "&_
					", 'REEMISION DE CHEQUE VENCIDO GENERICO' as descripcion "&_
					", 0 as debe "&_
					", eche_mmonto as haber  "&_
					", CajCod as cod_pre "&_
					", protic.trunc(eche_fdocto) as fecha "&_
					", case when MONTH(eche_fdocto)<10 then '0' + cast(MONTH(eche_fdocto) as varchar) "&_
					"  else cast(MONTH(eche_fdocto) as varchar) "&_
					"  end +cast(YEAR(eche_fdocto) as varchar) as flujo "&_
					", 'CV' AS TDOCUMENTO "&_
					"FROM ocag_entrega_cheques "&_
					"WHERE eche_ndocto="&v_solicitud
					
'		sql_auxiliar= "select top 1 pers_nrut from ocag_solicitud_giro a, personas b "&_
'					  "	where a.pers_ncorr_proveedor=b.pers_ncorr "&_
'					  "	and sogi_ncorr="&v_solicitud
					  
		sql_auxiliar= "select top 1 a.pers_nrut from ocag_entrega_cheques a WHERE a.eche_ndocto="&v_solicitud

'		sql_centro_costo= 	" select top 1 c.ccos_tcodigo from ocag_validacion_contable a, ocag_centro_costo_validacion b, ocag_centro_costo c "&_
'							"	where a.vcon_ncorr=b.vcon_ncorr "&_
'							"	and b.ccos_ncorr=c.ccos_ncorr "&_
'							"	and cod_solicitud="&v_solicitud&" "&_
'							"	and isnull(tsol_ccod,1)=1 "					  
							
		sql_centro_costo= 	" select top 1 a.CcCod as ccos_tcodigo "&_
							" from ocag_entrega_cheques a "&_
							" WHERE a.eche_ndocto="&v_solicitud

'		sql_documentos= 	" select c.tdoc_tdesc_softland as tipo,dsgi_ndocto as docto,protic.trunc(a.sogi_fecha_solicitud) as fecha "&_
'							" from ocag_solicitud_giro a, ocag_detalle_solicitud_giro b, ocag_tipo_documento c "&_
'							"	where a.sogi_ncorr=b.sogi_ncorr "&_
'							"	and b.tdoc_ccod=c.tdoc_ccod "&_
'							"	and a.sogi_ncorr="&v_solicitud&" "&_
'							"	and isnull(a.tsol_ccod,1)=1 "		
							
		sql_documentos= 	" select TOP 1 a.movtipdocref as tipo  "&_
							"	, a.NumDoc as docto "&_
							"	, CONVERT(CHAR(10), GETDATE(), 103) AS fecha  "&_
							"from softland.cwmovim a  "&_
							"where a.ttdcod = 'CP'  "&_
							"and a.cpbano>=2013  "&_
							"and a.movfv is not null and a.movdebe > 0  "&_
							"and NumDoc="&v_solicitud

'end select

'RESPONSE.WRITE("1. txt_tipo : "&txt_tipo&"<BR>") 
'RESPONSE.WRITE("2. sql_doctos : "&sql_doctos&"<BR>")
'RESPONSE.WRITE("3. sql_efes : "&sql_efes&"<BR>")
'RESPONSE.WRITE("4. sql_auxiliar : "&sql_auxiliar&"<BR>")
'RESPONSE.WRITE("5. sql_centro_costo : "&sql_centro_costo&"<BR>")
'RESPONSE.WRITE("6. sql_documentos : "&sql_documentos&"<BR>")
'RESPONSE.END()

' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

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
			
				' 88888888888888888888888888888888
				' response.Write("1.2.2. ACA "&"<BR>")
				' 88888888888888888888888888888888
				
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
	
	'RESPONSE.WRITE("6. v_ruta_salida_nueva : "&v_ruta_salida_nueva&"<BR>")
	
	'******************************************
	v_nombre_cajero	=	p_conexion.ConsultaUno(sql_nombre)
	archivo_salida 		= v_nombre_cajero&"_"&txt_tipo&"_"&v_solicitud & ".txt"

	' Creacion de archivos de cajas
	set fso = Server.CreateObject("Scripting.FileSystemObject")
	set o_texto_archivo = fso.CreateTextFile(v_ruta_salida_nueva & "\" & archivo_salida)

	'--------------------------------------------------------------------------------------------------------------

'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	
								set f_consulta = new CFormulario
								f_consulta.Carga_Parametros "consulta.xml", "consulta"
								f_consulta.Inicializar p_conexion	

								'f_consulta.Consultar SQL
								f_consulta.Consultar sql_doctos

								ind=0
								v_total=0

'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
								while f_consulta.Siguiente
'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
								  
								  v_auxiliar=""
								  v_centro_costo=""
								  controla_doc=null
								  
								  sql_atributos2="select pccodi as cuenta,pcdesc as nombre_cuenta, isnull(pcccos,'N') as usa_centro_costo,   "&_
													"  isnull(pcauxi,'N') as usa_auxiliar,isnull(pccdoc,'N') as usa_maneja_doc,isnull(pcconb,'N') as usa_conciliacion,   "&_
													"  isnull(pcdetg,'N') as usa_detalle_gasto,isnull(pcprec,'N') as usa_presupuesto,   "&_
													"  isnull(pcacti,'N') as usa_activa,isnull(pcafeefe,'N') as usa_flujo_efectivo   "&_
													" from softland.cwpctas where pccodi='"&f_consulta.obtenerValor("cuenta")&"'"
	
									 set f_atributos2 = new CFormulario
										 f_atributos2.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
										 f_atributos2.Inicializar conectar
										 f_atributos2.Consultar sql_atributos2
										 f_atributos2.siguiente 
										 
								 		 	if f_atributos2.ObtenerValor("usa_centro_costo")="S" then
												v_centro_costo= conexion.consultaUno(sql_centro_costo)	
											else
												v_centro_costo=""
											end if
											
											if f_atributos2.ObtenerValor("usa_auxiliar")="S" then
												v_auxiliar= conexion.consultaUno(sql_auxiliar)			  
											else
												v_auxiliar=""
											end if 
											
											if f_atributos2.ObtenerValor("usa_maneja_doc")="S" then
												 
												 set f_documentos = new CFormulario
												 f_documentos.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
												 'f_documentos.Inicializar conexion
												 f_documentos.Inicializar conectar
												 f_documentos.Consultar sql_documentos
												 f_documentos.siguiente 
												
												v_tipo_doc	=	f_documentos.ObtenerValor("tipo")
												v_num_doc	=	f_documentos.ObtenerValor("docto")
												fecha_doc	=	f_documentos.ObtenerValor("fecha")
												 
												controla_doc=v_tipo_doc&","&v_num_doc&","&fecha_doc&","&fecha_doc&","&v_tipo_doc&","&v_num_doc												
											else
												controla_doc=",,,,,"
											end if
											
											'if f_atributos2.ObtenerValor("usa_conciliacion")="S" then
											'	response.Write("<br>usa_conciliacion :"&f_atributos2.ObtenerValor("usa_conciliacion"))
											'end if

											'if f_atributos2.ObtenerValor("usa_detalle_gasto")="S" then
											'	response.Write("<br>usa_detalle_gasto :"&f_atributos2.ObtenerValor("usa_detalle_gasto"))
											'end if

											'28/08/2013
											'8888888888888888888888888888888888
											cuenta3=f_consulta.obtenerValor("cuenta")
											if cuenta3="1-10-010-20-000003" or cuenta3="1-10-060-10-000002" or cuenta3="5-30-020-10-002022" then
												fijovariable="Fijo"
											else 
												fijovariable="Variable"
											end if
											
											if cuenta3="1-10-010-30-100001" then
												fijovariable=""
											end if

											if cuenta3="2-10-070-10-000002" then
												ccos_tcodigo3=""
											else
												ccos_tcodigo3=f_consulta.obtenerValor("ccos_tcodigo")
											end if
											'8888888888888888888888888888888888

											if f_atributos2.ObtenerValor("usa_presupuesto")="S" then
											'	response.Write("<br>usa_presupuesto :"&f_atributos2.ObtenerValor("usa_presupuesto"))
											else
												v_cod_pre=""
											end if

											if f_atributos2.ObtenerValor("usa_activa")="S" then
												v_activa="S"
											else
												v_activa=""
											end if

											if f_atributos2.ObtenerValor("usa_flujo_efectivo")="S" then
											'	response.Write("<br>usa_flujo_efectivo :"&f_atributos2.ObtenerValor("usa_flujo_efectivo"))
											else
												v_flujo=""
											end if				

										ind=ind+1  

'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

										linea = ""

										linea = linea & f_consulta.ObtenerValor("cuenta") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_consulta.ObtenerValor("descripcion") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_consulta.ObtenerValor("debe") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_consulta.ObtenerValor("haber") & DELIMITADOR_CAMPOS_SOFT
										
										linea = linea & fijovariable& DELIMITADOR_CAMPOS_SOFT
										
										linea = linea &v_auxiliar&","&v_centro_costo&","&controla_doc&","&v_cod_pre&","&v_activa&","&v_flujo& DELIMITADOR_CAMPOS_SOFT
										
										linea = linea & ccos_tcodigo3& DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_consulta.ObtenerValor("TDOCUMENTO") 
									
										o_texto_archivo.WriteLine(linea)

'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
										wend
'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

								set f_efes = new CFormulario
								f_efes.Carga_Parametros "consulta.xml", "consulta"
								f_efes.Inicializar p_conexion	

								'f_efes.Consultar SQL
								f_efes.Consultar sql_efes

								ind=0
								v_total=0

'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
								while f_efes.Siguiente 
'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

									  sql_atributos="select pccodi as cuenta,pcdesc as nombre_cuenta, isnull(pcccos,'N') as usa_centro_costo,   "&_
													"  isnull(pcauxi,'N') as usa_auxiliar,isnull(pccdoc,'N') as usa_maneja_doc,isnull(pcconb,'N') as usa_conciliacion,   "&_
													"  isnull(pcdetg,'N') as usa_detalle_gasto,isnull(pcprec,'N') as usa_presupuesto,   "&_
													"  isnull(pcacti,'N') as usa_activa,isnull(pcafeefe,'N') as usa_flujo_efectivo   "&_
													" from softland.cwpctas where pccodi='"&f_efes.obtenerValor("cuenta")&"'"
													
									'RESPONSE.WRITE("3. sql_atributos : "&sql_atributos&"<BR>")
									
									 set f_atributos = new CFormulario
										 f_atributos.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
										 f_atributos.Inicializar conectar
										 f_atributos.Consultar sql_atributos
										 f_atributos.siguiente 
										 
										if (f_atributos.nroFilas>0) then

											if f_atributos.ObtenerValor("usa_auxiliar")="S" then
												v_auxiliar= conexion.consultaUno(sql_auxiliar)			  
											End if
											
											if f_atributos.ObtenerValor("usa_maneja_doc")="S" then
												if f_efes.ObtenerValor("cuenta")="2-10-070-10-000004" then
													v_documento="PP"
													fecha_doc=f_efes.ObtenerValor("fecha")
												end if
												controla_doc=v_documento&","&v_solicitud&","&fecha_doc&","&fecha_doc&","&v_documento&","&v_solicitud												
											End if
											
											'28/08/2013
											'8888888888888888888888888888888888
											cuenta3=f_efes.obtenerValor("cuenta")
											if cuenta3="1-10-010-20-000003" or cuenta3="1-10-060-10-000002" or cuenta3="5-30-020-10-002022" then
												fijovariable="Fijo"
											else 
												fijovariable="Variable"
											end if
											'8888888888888888888888888888888888

											if f_atributos.ObtenerValor("usa_presupuesto")="S" then
												v_cod_pre=f_efes.obtenerValor("cod_pre")
											End if
											
											if f_atributos.ObtenerValor("usa_activa")="S" then
												v_activa="S"
											End if
											
											if f_atributos.ObtenerValor("usa_flujo_efectivo")="S" then
												v_flujo=f_efes.obtenerValor("flujo")
											End if																						

										end if										 
								
										ind=ind+1

'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

										linea = ""

										linea = linea & f_efes.ObtenerValor("cuenta") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes.ObtenerValor("descripcion") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes.ObtenerValor("debe") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes.ObtenerValor("haber") & DELIMITADOR_CAMPOS_SOFT
										
										linea = linea & fijovariable & DELIMITADOR_CAMPOS_SOFT
										
										linea = linea &v_auxiliar&",,"&controla_doc&","&v_cod_pre&","&v_activa&","&v_flujo& DELIMITADOR_CAMPOS_SOFT									
										
										linea = linea & f_efes.ObtenerValor("cod_pre") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes.ObtenerValor("TDOCUMENTO") 
									
										o_texto_archivo.WriteLine(linea)

'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
								wend		
'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
										
	o_texto_archivo.Close ' Escritura en archivo base de la caja

	'o_texto_archivo_2.Close

	'----------------------------------------------------------------------------------------------------------------
	set o_texto_archivo = Nothing
	set fso = Nothing
	
	
	set f_consulta = Nothing
	set f_efes = Nothing
	
	
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
	'RESPONSE.END()

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


<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_rutas.asp" -->

<%
	Server.ScriptTimeOut = 120	
	'------------ OBTENER NUMERO CORRELATIVO DE SOFTLAND
	function numeross()
		'---------- CONEXION A SOFTLAND ----------'
		set conectar1 = new Cconexion2
		conectar1.Inicializar "upacifico"
	
		'---------- CREAR FORMULARIO ----------'
		set grilla = new CFormulario
		grilla.Carga_Parametros "tabla_vacia.xml", "tabla"
		grilla.Inicializar conectar1
	
		'---------- CONSULTAR A SOFTLAND ----------'
		sql_softland1 = "SELECT TOP 1 DLICOINT "& vbCrLf &_   
							" FROM softland.cwdetli "&_ 
							" WHERE YEAR(dlifedoc)=YEAR(GETDATE()) AND MONTH(dlifedoc)=MONTH(GETDATE()) "& vbCrLf &_   
							" ORDER BY DLICOINT DESC"
		grilla.Consultar sql_softland1
		grilla.siguiente
		if grilla.obtenerValor("DLICOINT") = "" then
			num = 1
		else
			num = grilla.obtenerValor("DLICOINT") + 1
		end if
		numeross = num
	end function
	
	function es_orden_compra(cod,tipo_solicitud)
		set conectar = new Cconexion
		conectar.Inicializar "upacifico"
		sql = "SELECT DISTINCT c.tgas_cod_cuenta AS valor"& vbCrLf&_
				" FROM ocag_detalle_solicitud_ag a"&_
				" INNER JOIN ocag_presupuesto_solicitud b"& vbCrLf&_
				" ON b.cod_solicitud =a.sogi_ncorr"& vbCrLf&_
				" INNER JOIN ocag_tipo_gasto c ON a.tgas_ccod=c.tgas_ccod"& vbCrLf&_
				" WHERE b.tsol_ccod=1 AND sogi_ncorr = "&cod & vbCrLf
		set grilla1 = new CFormulario
		grilla1.Carga_Parametros "tabla_vacia.xml", "tabla"
		grilla1.Inicializar conectar
		response.write sql
		grilla1.Consultar sql
		grilla1.siguiente
		estad=false
		if grilla1.obtenerValor("valor") = "" and tipo_solicitud = 1 then
			estad=true
		end if
		es_orden_compra= estad
	end function
	
	function generarsqlencabezado(tipo_solicitud, numero)
		texto = "SELECT * FROM (" & vbCrLf
		select case tipo_solicitud
			case 1:
				texto = texto & costopagoproveedor(numero) & vbCrLf
			case 2:
				texto = texto & costoreembolso(numero) & vbCrLf
			case 3:
				texto = texto & costofondorendir(numero) & vbCrLf
			case 4:
				texto = texto & costosolicitud(numero) & vbCrLf
			case 5:
				texto = texto & costodevolucionalumno(numero) & vbCrLf
			case 6:
				texto = texto & costofondofijo(numero) & vbCrLf
			case 7:
				texto = texto + costorendicionfondorendir(numero) & vbCrlf
			case 8:
				texto = texto & costorendicionfondofijo(numero) & vbCrLf
		end select
		texto = texto & ") AS tabla ORDER BY TSOF_HABER DESC, TSOF_COD_CENTRO_COSTO DESC, TSOF_DEBE DESC"
		generarsqlencabezado=texto
	end function
	
	function generadorpresupuesto(tipo_solicitud, numero)
		texto = "SELECT * FROM (" & vbCrLf
		select case tipo_solicitud
			case 1:
				texto = texto & presupuestopagoproveedor(numero) & vbCrLf
			case 2:
				texto = texto & presupuestoreembolso(numero) & vbCrLf
			case 3:
				texto = texto & presupuestofondorendir() & vbCrLf
			case 4:
				texto = texto & presupuestosolicitudviatico() & vbCrLf
			case 5:
				texto = texto & presupuestodevolucionalumno() & vbCrLf
			case 6:
				texto = texto & presupuestofondofijo() & vbCrLf
			case 7:
				texto = texto & presupuestorendicionfondorendir(numero) & vbCrLf
			case 8:
				texto = texto & presupuestorendicionfondofijo(numero) & vbCrLf
		end select
		texto = texto & ") AS tabla ORDER BY TSOF_NRO_DOC_REFERENCIA ASC, TSOF_TIPO_DOC_REFERENCIA DESC, TSOF_COD_CENTRO_COSTO DESC, TSOF_HABER DESC, TSOF_DEBE DESC"
		generadorpresupuesto=texto
	end function
	
	function generadorpresupuestototal(tipo_solicitud, numero, diferencia)
		texto = "SELECT * FROM (" & vbCrLf
		select case tipo_solicitud
			case 1:
				texto = texto & presupuestopagoproveedortotal(numero) & vbCrLf
			case 2:
				texto = texto & presupuestoreembolsototal(numero) & vbCrLf
			case 3:
				texto = texto & presupuestofondorendirtotal(numero) & vbCrLf
			case 4:
				texto = texto & presupuestosolicitudviaticototal(numero) & vbCrLf
			case 5:
				texto = texto & presupuestodevolucionalumnototal(numero) & vbCrLf
			case 6:
				texto = texto & presupuestofondofijototal(numero) & vbCrLf
			case 7:
				texto = texto & presupuestorendicionfondorendirtotal(numero, diferencia) & vbCrLf
			case 8:
				texto = texto & presupuestorendicionfondofijototal(numero) & vbCrLf
		end select
		texto = texto & ") AS tabla ORDER BY tsof_plan_cuenta DESC, TSOF_NRO_DOC_REFERENCIA DESC, TSOF_TIPO_DOC_REFERENCIA DESC, TSOF_COD_CENTRO_COSTO DESC, TSOF_HABER DESC, TSOF_DEBE DESC"
		generadorpresupuestototal=texto
	end function
	
	function costopagoproveedor(numero)
		texto = "SELECT g.dsag_ncorr,"& vbCrLf &_
			" LTRIM(RTRIM(h.tgas_cod_cuenta)) AS TSOF_PLAN_CUENTA,"& vbCrLf &_ 
			" CASE WHEN a.sogi_bboleta_honorario = 1 THEN g.dorc_nprecio_neto ELSE g.dorc_nprecio_neto*1.19 END AS TSOF_DEBE,"& vbCrLf &_ 
			" 0 AS TSOF_HABER,"& vbCrLf &_ 
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_ 
			" protic.extrae_acentos(LTRIM(RTRIM(g.dorc_tdesc))) AS TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_ 
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_ 
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_ 
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_ 
			" null AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_ 
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_ 
			" null AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_ 
			" i.ccos_tcodigo AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_ 
			" null AS TSOF_COD_AUXILIAR,"& vbCrLf &_ 
			" null AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
			" null AS TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_ 
			" null AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_ 
			" null AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_ 
			" null AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_ 
			" null TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOCUMENTO_DESDE,"& vbCrLf &_ 
			" null TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_ 
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_ 
			" null AS TSOF_bullshet1,"& vbCrLf &_ 
			" null AS TSOF_bullshet2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_ 
			" null AS TSOF_COD_MESANO,"& vbCrLf &_ 
			" g.dorc_bafecta AS RETE,"& vbCrLf &_
			" a.sogi_bboleta_honorario AS boleta"& vbCrLf &_
			" from ocag_solicitud_giro a"& vbCrLf &_ 
			" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr="&numero& vbCrLf &_ 
			" INNER JOIN ocag_validacion_contable c ON a.sogi_ncorr=c.cod_solicitud AND isnull(c.tsol_ccod,1)=1"& vbCrLf &_ 
			" INNER JOIN ocag_detalle_pago_validacion d ON c.vcon_ncorr = d.vcon_ncorr"& vbCrLf &_ 
			" INNER JOIN ocag_detalle_solicitud_giro e ON a.sogi_ncorr=e.sogi_ncorr"& vbCrLf &_ 
			" INNER JOIN ocag_tipo_documento f ON e.tdoc_ccod=f.tdoc_ccod"& vbCrLf &_ 
			" INNER JOIN ocag_detalle_solicitud_ag g ON a.sogi_ncorr=g.sogi_ncorr"& vbCrLf &_ 
			" INNER JOIN ocag_tipo_gasto h ON g.tgas_ccod = h.tgas_ccod"& vbCrLf &_ 
			" INNER JOIN ocag_centro_costo i ON g.ccos_ncorr = i.ccos_ncorr"& vbCrLf &_
			" UNION"& vbCrLf &_
			"SELECT TOP 1 1,"& vbCrLf &_ 
			" CASE WHEN a.cpag_ccod = 25 THEN '1-10-010-30-100001' ELSE '2-10-070-10-000002' END AS TSOF_PLAN_CUENTA,"& vbCrLf &_ 
			" 0 AS TSOF_DEBE,"& vbCrLf &_ 
			" a.sogi_mgiro AS TSOF_HABER,"& vbCrLf &_ 
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_ 
			" protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) AS TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_ 
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_ 
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_ 
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_ 
			" null AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_ 
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_ 
			" null AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_ 
			" null AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_ 
			" CAST(b.pers_nrut AS VARCHAR) AS TSOF_COD_AUXILIAR,"& vbCrLf &_ 
			" LTRIM(RTRIM('bc')) AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" CAST(a.sogi_ncorr AS VARCHAR) AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
			" protic.trunc(a.sogi_fecha_solicitud) AS TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_ 
			" protic.trunc(f.dpva_fpago) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" LTRIM(RTRIM('BC')) AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_ 
			" CAST(a.sogi_ncorr AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_ 
			" "&numeross()&" AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_ 
			" null TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOCUMENTO_DESDE,"& vbCrLf &_ 
			" null TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_ 
			" '1' AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_ 
			" null AS TSOF_bullshet1,"& vbCrLf &_ 
			" null AS TSOF_bullshet2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_ 
			" null AS TSOF_COD_MESANO,"& vbCrLf &_ 
			" null AS RETE,"& vbCrLf &_
			" a.sogi_bboleta_honorario AS boleta"& vbCrLf &_
			" FROM ocag_solicitud_giro a"& vbCrLf &_ 
			" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr ="&numero&" and isnull(a.tsol_ccod,1)=1"& vbCrLf &_ 
			" INNER JOIN ocag_detalle_solicitud_ag c ON a.sogi_ncorr = c.sogi_ncorr"& vbCrLf &_ 
			" INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod"& vbCrLf &_ 
			" INNER JOIN ocag_centro_costo e ON c.ccos_ncorr = e.ccos_ncorr"& vbCrLf &_ 
			" INNER JOIN ocag_validacion_contable g ON a.sogi_ncorr=g.cod_solicitud AND isnull(g.tsol_ccod,1)=1"& vbCrLf &_ 
			" INNER JOIN ocag_detalle_pago_validacion f ON g.vcon_ncorr = f.vcon_ncorr"
		costopagoproveedor = texto
	end function
	
	function costoreembolso(numero)
		texto="select DISTINCT h.tgas_cod_cuenta as tsof_plan_cuenta,"& vbCrLf &_ 
			" 0 as TSOF_HABER,"& vbCrLf &_ 
			" ABS(d.drga_mdocto*1.19) as tsof_debe,"& vbCrLf &_ 
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_ 
			" protic.extrae_acentos(LTRIM(RTRIM(h.tgas_tdesc))) AS TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_ 
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_ 
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_ 
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_ 
			" null AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_ 
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_ 
			" null AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_ 
			" CONVERT(VARCHAR(32),i.ccos_tcodigo) AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_ 
			" CONVERT(VARCHAR(20),c.PERS_NRUT) AS TSOF_COD_AUXILIAR,"& vbCrLf &_ 
			" otd.tdoc_tdesc_softland AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" CAST(b.rgas_ncorr AS VARCHAR) AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
			" protic.trunc(b.ocag_fingreso) AS TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_ 
			" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_ 
			" otd.tdoc_tdesc_softland as TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_ 
			" d.rgas_ncorr as TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_ 
			" 1 AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_ 
			" NULL AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_ 
			" NULL AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_ 
			" NULL AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_ 
			" NULL TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOCUMENTO_DESDE,"& vbCrLf &_ 
			" null TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_ 
			" '1' AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_ 
			" null AS TSOF_bullshet1,"& vbCrLf &_ 
			" null AS TSOF_bullshet2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_ 
			" null AS TSOF_COD_MESANO,"& vbCrLf &_ 
			" 1 AS boleta,"& vbCrLf &_ 
			" 0 AS rete"& vbCrLf &_ 
			" from ocag_presupuesto_solicitud a"& vbCrLf &_ 
			"		INNER JOIN ocag_reembolso_gastos b ON a.cod_solicitud = b.rgas_ncorr AND cod_solicitud = "&numero&" AND a.tsol_ccod = 2"& vbCrLf &_ 
			"		INNER JOIN ocag_presupuesto_solicitud e ON e.cod_solicitud=b.rgas_ncorr AND e.tsol_ccod = 2"& vbCrLf &_ 
			"		INNER JOIN ocag_detalle_reembolso_gasto d ON b.rgas_ncorr = d.rgas_ncorr"& vbCrLf &_ 
			"		INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr"& vbCrLf &_ 
			"		INNER JOIN ocag_tipo_documento otd ON otd.tdoc_ccod=d.tdoc_ccod"& vbCrLf &_ 
			"		INNER JOIN ocag_tipo_gasto h ON h.tgas_ccod = d.tgas_ccod"& vbCrLf &_ 
			"		INNER JOIN ocag_centro_costo i ON i.ccos_ncorr=d.ccos_ncorr"& vbCrLf &_ 
			" UNION"& vbCrLf &_ 
			" select TOP 1 '2-10-070-10-000002' as tsof_plan_cuenta,"& vbCrLf &_ 
			" ABS(b.rgas_mgiro) as tsof_debe,"& vbCrLf &_ 
			" 0 as TSOF_HABER,"& vbCrLf &_ 
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_ 
			" protic.extrae_acentos(LTRIM(RTRIM('Reembolso'))) AS TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_ 
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_ 
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_ 
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_ 
			" null AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_ 
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_ 
			" null AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_ 
			" CONVERT(VARCHAR(32),i.ccos_tcodigo) AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_ 
			" CONVERT(VARCHAR(20),c.PERS_NRUT) AS TSOF_COD_AUXILIAR,"& vbCrLf &_ 
			" 'BC' AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" CAST(b.rgas_ncorr AS VARCHAR) AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
			" protic.trunc(b.ocag_fingreso) AS TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_ 
			" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_ 
			" 'BC' as TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_ 
			" d.rgas_ncorr as TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_ 
			" null AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_ 
			" null TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOCUMENTO_DESDE,"& vbCrLf &_ 
			" null TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_ 
			" '1' AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_ 
			" null AS TSOF_bullshet1,"& vbCrLf &_ 
			" null AS TSOF_bullshet2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_ 
			" null AS TSOF_COD_MESANO,"& vbCrLf &_ 
			" 1 AS boleta,"& vbCrLf &_ 
			" 0 AS rete"& vbCrLf &_ 
			" from ocag_presupuesto_solicitud a"& vbCrLf &_ 
			" INNER JOIN ocag_reembolso_gastos b ON a.cod_solicitud = b.rgas_ncorr AND cod_solicitud = "&numero&" AND a.tsol_ccod = 2"& vbCrLf &_ 
			" INNER JOIN ocag_presupuesto_solicitud e ON e.cod_solicitud=b.rgas_ncorr AND e.tsol_ccod = 2"& vbCrLf &_ 
			" INNER JOIN ocag_detalle_reembolso_gasto d ON b.rgas_ncorr = d.rgas_ncorr"& vbCrLf &_ 
			" INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr"& vbCrLf &_ 
			" INNER JOIN ocag_tipo_documento otd ON otd.tdoc_ccod=d.tdoc_ccod"& vbCrLf &_ 
			" INNER JOIN ocag_tipo_gasto h ON h.tgas_ccod = d.tgas_ccod"& vbCrLf &_ 
			" INNER JOIN ocag_centro_costo i ON i.ccos_ncorr=d.ccos_ncorr"
		costoreembolso=texto
	end function
	
	function costofondorendir(numero)
		texto="select '1-10-060-10-000002' as tsof_plan_cuenta,"& vbCrLf &_ 
			"   d.ccva_mmonto as tsof_debe,"& vbCrLf &_ 
			"   0 as TSOF_HABER,"& vbCrLf &_ 
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_ 
			" protic.extrae_acentos(LTRIM(RTRIM(a.fren_tdescripcion_actividad))) AS TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_ 
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_ 
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_ 
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_ 
			" null AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_ 
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_ 
			" null AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_ 
			" e.ccos_tcodigo AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_ 
			" CONVERT(VARCHAR(32),b.pers_nrut) AS TSOF_COD_AUXILIAR,"& vbCrLf &_ 
			" 'FR' AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" a.fren_ncorr AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
			" protic.trunc(a.ocag_fingreso) AS TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_ 
			" protic.trunc(a.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_ 
			" 'FR' as TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_ 
			" a.fren_ncorr as TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_ 
			" NULL AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_ 
			" NULL AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_ 
			" NULL AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_ 
			" NULL AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_ 
			" NULL TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOCUMENTO_DESDE,"& vbCrLf &_ 
			" null TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_ 
			" '1' AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_ 
			" null AS TSOF_bullshet1,"& vbCrLf &_ 
			" null AS TSOF_bullshet2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_ 
			" null AS TSOF_COD_MESANO,"& vbCrLf &_ 
			"	1 AS boleta,"& vbCrLf &_ 
			"	0 AS rete"& vbCrLf &_ 
			" from ocag_fondos_a_rendir a  "& vbCrLf &_
			" INNER JOIN personas b ON a.pers_ncorr = b.pers_ncorr and fren_ncorr="&numero& vbCrLf &_
			" INNER JOIN ocag_validacion_contable c on a.fren_ncorr = c.cod_solicitud and isnull(c.tsol_ccod,3)=3"& vbCrLf &_
			" INNER JOIN ocag_centro_costo_validacion d ON c.vcon_ncorr=d.vcon_ncorr"& vbCrLf &_
			" INNER JOIN ocag_centro_costo e ON d.ccos_ncorr=e.ccos_ncorr" & vbCrLf &_
			" UNION"& vbCrLf &_ 
			" select TOP 1 '2-10-070-10-000002' as tsof_plan_cuenta,"& vbCrLf &_ 
			" 0 as tsof_debe,"& vbCrLf &_ 
			" fren_mmonto as TSOF_HABER,"& vbCrLf &_ 
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_ 
			" protic.extrae_acentos(LTRIM(RTRIM(a.fren_tdescripcion_actividad))) AS TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_ 
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_ 
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_ 
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_ 
			" null AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_ 
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_ 
			" null AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_ 
			" null AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_ 
			" CONVERT(VARCHAR(32),b.pers_nrut) AS TSOF_COD_AUXILIAR,"& vbCrLf &_ 
			" 'BC' AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" a.fren_ncorr AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
			" protic.trunc(a.ocag_fingreso) AS TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_ 
			" protic.trunc(x.dpva_fpago) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_ 
			" 'BC' as TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_ 
			" a.fren_ncorr as TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_ 
			" null AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_ 
			" null TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOCUMENTO_DESDE,"& vbCrLf &_ 
			" null TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_ 
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_ 
			" null AS TSOF_bullshet1,"& vbCrLf &_ 
			" null AS TSOF_bullshet2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_ 
			" null AS TSOF_COD_MESANO,"& vbCrLf &_ 
			" 1 AS boleta,"& vbCrLf &_ 
			" 0 AS rete"& vbCrLf &_ 
			" from ocag_fondos_a_rendir a  "&_
			" INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and fren_ncorr="&numero&vbCrLf &_
			" INNER JOIN ocag_validacion_contable w ON a.fren_ncorr=w.cod_solicitud AND isnull(w.tsol_ccod,3)=3  "&vbCrLf &_
			" INNER JOIN ocag_detalle_pago_validacion x ON w.vcon_ncorr = x.vcon_ncorr "
		costofondorendir = texto
	end function
	
	function costosolicitud(numero)
		texto = "SELECT LTRIM(RTRIM('5-30-020-10-002022')) AS TSOF_PLAN_CUENTA,"& vbCrLf &_ 
			" psol_mpresupuesto AS TSOF_DEBE,"& vbCrLf &_ 
			" 0 AS TSOF_HABER,"& vbCrLf &_ 
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_ 
			" protic.extrae_acentos(LTRIM(RTRIM(a.sovi_tmotivo))) AS TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_ 
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_ 
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_ 
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_ 
			" null AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_ 
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_ 
			" null AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_ 
			" c.cod_pre AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_ 
			" CONVERT(VARCHAR(32),b.pers_nrut) AS TSOF_COD_AUXILIAR,"& vbCrLf &_ 
			" 'SV' AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" CONVERT(VARCHAR(32),a.sovi_ncorr) AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
			" protic.trunc(a.ocag_fingreso) AS TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_ 
			" protic.trunc(a.ocag_fingreso) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_ 
			" 'SV' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_ 
			" CONVERT(VARCHAR(32),a.sovi_ncorr) AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_ 
			" null AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_ 
			" null TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOCUMENTO_DESDE,"& vbCrLf &_ 
			" null TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_ 
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_ 
			" null AS TSOF_bullshet1,"& vbCrLf &_ 
			" null AS TSOF_bullshet2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_ 
			" null AS TSOF_COD_MESANO,"& vbCrLf &_ 
			" NULL AS RETE,"& vbCrLf &_
			" NULL AS boleta"& vbCrLf &_
			" From ocag_solicitud_viatico a "&_
			"  INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and A.sovi_ncorr="&numero&" "&_
			"  INNER JOIN ocag_presupuesto_solicitud c ON c.cod_solicitud=a.sovi_ncorr AND c.tsol_ccod=4"& vbCrLf &_
			" UNION"& vbCrLf &_
			" SELECT TOP 1 '2-10-070-10-000002' AS TSOF_PLAN_CUENTA,"& vbCrLf &_ 
			" 0 AS TSOF_DEBE,"& vbCrLf &_ 
			" a.sovi_mmonto_pesos AS TSOF_HABER,"& vbCrLf &_ 
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_ 
			" protic.extrae_acentos(LTRIM(RTRIM(a.sovi_tmotivo))) AS TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_ 
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_ 
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_ 
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_ 
			" null AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_ 
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_ 
			" null AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_ 
			" null AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_ 
			" CONVERT(VARCHAR(32),b.pers_nrut) AS TSOF_COD_AUXILIAR,"& vbCrLf &_ 
			" LTRIM(RTRIM('BC')) AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" CONVERT(VARCHAR(32),a.sovi_ncorr) AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
			" protic.trunc(a.ocag_fingreso) AS TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_ 
			" protic.trunc(a.ocag_fingreso) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" LTRIM(RTRIM('BC')) AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_ 
			" CONVERT(VARCHAR(32),a.sovi_ncorr) AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_ 
			" "&numeross()&" AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_ 
			" null TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOCUMENTO_DESDE,"& vbCrLf &_ 
			" null TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_ 
			" '1' AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_ 
			" null AS TSOF_bullshet1,"& vbCrLf &_ 
			" null AS TSOF_bullshet2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_ 
			" null AS TSOF_COD_MESANO,"& vbCrLf &_ 
			" null AS RETE,"& vbCrLf &_
			" NULL AS boleta"& vbCrLf &_
			" From ocag_solicitud_viatico a "&_
			" INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and A.sovi_ncorr="&numero
		costosolicitud = texto
	end function
	
	function costodevolucionalumno(numero)
		texto = "SELECT '2-10-140-09-120001' AS TSOF_PLAN_CUENTA,"& vbCrLf &_ 
			" a.dalu_mmonto_pesos AS TSOF_DEBE,"& vbCrLf &_ 
			" 0 AS TSOF_HABER,"& vbCrLf &_ 
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_ 
			" protic.extrae_acentos(LTRIM(RTRIM(a.dalu_tmotivo))) AS TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_ 
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_ 
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_ 
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_ 
			" null AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_ 
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" 'AR-01-02' AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_ 
			" 1 AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_ 
			" e.ccos_tcodigo AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_ 
			" null AS TSOF_COD_AUXILIAR,"& vbCrLf &_ 
			" null AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
			" null AS TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_ 
			" null AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_ 
			" null AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_ 
			" null AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_ 
			" null TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOCUMENTO_DESDE,"& vbCrLf &_ 
			" null TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_ 
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_ 
			" null AS TSOF_bullshet1,"& vbCrLf &_ 
			" null AS TSOF_bullshet2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_ 
			" null AS TSOF_COD_MESANO,"& vbCrLf &_ 
			" null AS RETE,"& vbCrLf &_
			" null AS boleta"& vbCrLf &_
			" from ocag_devolucion_alumno a "& vbCrLf &_
			" INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and dalu_ncorr="&numero&" "& vbCrLf &_
			" INNER JOIN ocag_validacion_contable c on a.dalu_ncorr = c.cod_solicitud and isnull(c.tsol_ccod,5)=5 "& vbCrLf &_
			" INNER JOIN ocag_centro_costo_validacion d ON c.vcon_ncorr=d.vcon_ncorr "& vbCrLf &_
			" INNER JOIN ocag_centro_costo e ON d.ccos_ncorr=e.ccos_ncorr"& vbCrLf &_
			" UNION"& vbCrLf &_
			" SELECT TOP 1 '2-10-070-10-000002' AS TSOF_PLAN_CUENTA,"& vbCrLf &_ 
			" 0 AS TSOF_DEBE,"& vbCrLf &_ 
			" dalu_mmonto_pesos AS TSOF_HABER,"& vbCrLf &_ 
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_ 
			" protic.extrae_acentos(LTRIM(RTRIM(a.dalu_tmotivo))) AS TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_ 
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_ 
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_ 
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_ 
			" null AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_ 
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_ 
			" null AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_ 
			" null AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_ 
			" CAST(b.pers_nrut AS VARCHAR) AS TSOF_COD_AUXILIAR,"& vbCrLf &_ 
			" LTRIM(RTRIM('BC')) AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" CAST(a.dalu_ncorr AS VARCHAR) AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
			" protic.trunc(a.ocag_fingreso) AS TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_ 
			" protic.trunc(x.dpva_fpago) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" LTRIM(RTRIM('BC')) AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_ 
			" CAST(a.dalu_ncorr AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_ 
			" "&numeross()&" AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_ 
			" null TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOCUMENTO_DESDE,"& vbCrLf &_ 
			" null TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_ 
			" '1' AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_ 
			" null AS TSOF_bullshet1,"& vbCrLf &_ 
			" null AS TSOF_bullshet2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_ 
			" null AS TSOF_COD_MESANO,"& vbCrLf &_ 
			" null AS RETE,"& vbCrLf &_
			" null AS boleta"& vbCrLf &_
			" from ocag_devolucion_alumno a "& vbCrLf &_
			"INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and dalu_ncorr="&numero&" "& vbCrLf &_
			"INNER JOIN ocag_validacion_contable w ON a.dalu_ncorr=w.cod_solicitud AND isnull(w.tsol_ccod,5)=5 "& vbCrLf &_
			"INNER JOIN ocag_detalle_pago_validacion x ON w.vcon_ncorr = x.vcon_ncorr"
		costodevolucionalumno= texto
	end function
	
	function costofondofijo(numero)
		texto ="SELECT '1-10-010-20-000003' AS TSOF_PLAN_CUENTA,"& vbCrLf &_ 
			" a.ffij_mmonto_pesos AS TSOF_DEBE,"& vbCrLf &_ 
			" 0 AS TSOF_HABER,"& vbCrLf &_ 
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_ 
			" protic.extrae_acentos(LTRIM(RTRIM(a.ffij_tdetalle_presu))) AS TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_ 
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_ 
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_ 
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_ 
			" null AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_ 
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_ 
			" null AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_ 
			" e.ccos_tcodigo AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_ 
			" CAST(b.pers_nrut AS VARCHAR) AS TSOF_COD_AUXILIAR,"& vbCrLf &_ 
			" 'FF' AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" CAST(a.ffij_ncorr AS VARCHAR) AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
			" protic.trunc(a.ocag_fingreso) AS TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_ 
			" protic.trunc(a.ocag_fingreso) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_ 
			" 'FF' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_ 
			" CAST(a.ffij_ncorr AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_ 
			" "&numeross()&" AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_ 
			" null TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOCUMENTO_DESDE,"& vbCrLf &_ 
			" null TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_ 
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_ 
			" null AS TSOF_bullshet1,"& vbCrLf &_ 
			" null AS TSOF_bullshet2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_ 
			" null AS TSOF_COD_MESANO,"& vbCrLf &_ 
			" null AS RETE,"& vbCrLf &_
			" null AS boleta"& vbCrLf &_
			" FROM ocag_fondo_fijo a "&_
			" INNER JOIN personas b "&_
			" ON a.pers_ncorr=b.pers_ncorr and ffij_ncorr="&numero&" "& vbCrLf &_
			" INNER JOIN ocag_validacion_contable c  "& vbCrLf &_
			" on a.ffij_ncorr = c.cod_solicitud and isnull(c.tsol_ccod,6)=6 "& vbCrLf &_
			" INNER JOIN ocag_centro_costo_validacion d "& vbCrLf &_
			" ON c.vcon_ncorr=d.vcon_ncorr "& vbCrLf &_
			" INNER JOIN ocag_centro_costo e "& vbCrLf &_
			" ON d.ccos_ncorr=e.ccos_ncorr "& vbCrLf &_
			" UNION"& vbCrLf &_
			" SELECT TOP 1 '2-10-070-10-000002' AS TSOF_PLAN_CUENTA,"& vbCrLf &_ 
			" 0 AS TSOF_DEBE,"& vbCrLf &_ 
			" a.ffij_mmonto_pesos AS TSOF_HABER,"& vbCrLf &_ 
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_ 
			" protic.extrae_acentos(LTRIM(RTRIM(a.ffij_tdetalle_presu))) AS TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_ 
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_ 
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_ 
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_ 
			" null AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_ 
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_ 
			" null AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_ 
			" null AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_ 
			" CAST(b.pers_nrut AS VARCHAR) AS TSOF_COD_AUXILIAR,"& vbCrLf &_ 
			" LTRIM(RTRIM('BC')) AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" CAST(a.ffij_ncorr AS VARCHAR) AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
			" protic.trunc(a.ocag_fingreso) AS TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_ 
			" protic.trunc(x.dpva_fpago) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" LTRIM(RTRIM('BC')) AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_ 
			" CAST(a.ffij_ncorr AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_ 
			" "&numeross()&" AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_ 
			" null TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOCUMENTO_DESDE,"& vbCrLf &_ 
			" null TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_ 
			" '1' AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_ 
			" null AS TSOF_bullshet1,"& vbCrLf &_ 
			" null AS TSOF_bullshet2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_ 
			" null AS TSOF_COD_MESANO,"& vbCrLf &_ 
			" null AS RETE,"& vbCrLf &_
			" null AS boleta"& vbCrLf &_
			" FROM ocag_fondo_fijo a "&_
			" INNER JOIN personas b "& vbCrLf &_
			" ON a.pers_ncorr=b.pers_ncorr and ffij_ncorr="&numero&" "& vbCrLf &_
			" INNER JOIN ocag_validacion_contable w "& vbCrLf &_
			" ON a.ffij_ncorr=w.cod_solicitud AND isnull(w.tsol_ccod,6)=6 "& vbCrLf &_
			" INNER JOIN ocag_detalle_pago_validacion x ON w.vcon_ncorr = x.vcon_ncorr"
		costofondofijo = texto
	end function
	
	function costorendicionfondorendir(numero)
		texto ="SELECT d.tgas_cod_cuenta AS TSOF_PLAN_CUENTA,"& vbCrLf &_ 
			" c.drfr_mdocto AS TSOF_DEBE,"& vbCrLf &_ 
			" 0 AS TSOF_HABER,"& vbCrLf &_ 
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_ 
			" protic.extrae_acentos(LTRIM(RTRIM(d.tgas_tdesc))) AS TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_ 
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_ 
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_ 
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_ 
			" null AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_ 
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_ 
			" null AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_ 
			" e.ccos_tcodigo AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_ 
			" CAST(b.PERS_NRUT AS VARCHAR) AS TSOF_COD_AUXILIAR,"& vbCrLf &_ 
			" 'RFF' AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" CAST(z.rfre_ncorr AS VARCHAR) AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
			" null AS TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_ 
			" null AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_ 
			" null AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_ 
			" CAST(z.fren_ncorr AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_ 
			" "&numeross()&" AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_ 
			" null TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOCUMENTO_DESDE,"& vbCrLf &_ 
			" null TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_ 
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_ 
			" null AS TSOF_bullshet1,"& vbCrLf &_ 
			" null AS TSOF_bullshet2,"& vbCrLf &_ 
			" z.psol_mpresupuesto AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_ 
			" null AS TSOF_COD_MESANO,"& vbCrLf &_ 
			" null AS RETE,"& vbCrLf &_
			" null AS boleta"& vbCrLf &_
			" from ocag_rendicion_fondos_a_rendir z  "&_
			" INNER JOIN ocag_fondos_a_rendir a ON z.fren_ncorr = a.fren_ncorr and z.rfre_ncorr ="&numero	&" "&_
			" INNER JOIN personas b ON a.pers_ncorr = b.pers_ncorr  "&_
			" INNER JOIN ocag_detalle_rendicion_fondo_rendir c ON a.fren_ncorr = c.fren_ncorr  "&_
			" INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod  "&_
			" INNER JOIN ocag_centro_costo e ON a.ccos_ncorr = e.ccos_ncorr "&_
			" UNION"& vbCrLf &_
			" SELECT TOP 1 '1-10-060-10-000002' AS TSOF_PLAN_CUENTA,"& vbCrLf &_ 
			" 0 AS TSOF_DEBE,"& vbCrLf &_ 
			" z.rfre_mmonto AS TSOF_HABER,"& vbCrLf &_ 
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_ 
			" protic.extrae_acentos(LTRIM(RTRIM(c.drfr_tdesc))) AS TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_ 
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_ 
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_ 
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_ 
			" null AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_ 
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_ 
			" null AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_ 
			" e.ccos_tcodigo AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_ 
			" CAST(b.pers_nrut AS VARCHAR) AS TSOF_COD_AUXILIAR,"& vbCrLf &_ 
			" LTRIM(RTRIM('TR')) AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" CAST(z.rfre_ncorr AS VARCHAR) AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
			" protic.trunc(c.drfr_fdocto) AS TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_ 
			" protic.trunc(c.drfr_fdocto) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" LTRIM(RTRIM('FR')) AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_ 
			" CAST(z.fren_ncorr AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_ 
			" "&numeross()&" AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_ 
			" null TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOCUMENTO_DESDE,"& vbCrLf &_ 
			" null TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_ 
			" '1' AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_ 
			" null AS TSOF_bullshet1,"& vbCrLf &_ 
			" null AS TSOF_bullshet2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_ 
			" null AS TSOF_COD_MESANO,"& vbCrLf &_ 
			" null AS RETE,"& vbCrLf &_
			" null AS boleta"& vbCrLf &_
			" from ocag_rendicion_fondos_a_rendir z  "&_
			" INNER JOIN ocag_fondos_a_rendir a ON z.fren_ncorr = a.fren_ncorr and z.rfre_ncorr ="&numero&" "&_
			" INNER JOIN personas b ON a.pers_ncorr = b.pers_ncorr  "&_
			" INNER JOIN ocag_detalle_rendicion_fondo_rendir c ON a.fren_ncorr = c.fren_ncorr  "&_
			" INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod  "&_
			" INNER JOIN ocag_centro_costo e ON a.ccos_ncorr = e.ccos_ncorr "
		costorendicionfondorendir = texto
	end function
	
	function costorendicionfondofijo(numero)
		texto="SELECT d.tgas_cod_cuenta AS TSOF_PLAN_CUENTA,"& vbCrLf &_ 
			" w.drff_mdocto AS TSOF_DEBE,"& vbCrLf &_ 
			" 0 AS TSOF_HABER,"& vbCrLf &_ 
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_ 
			" protic.extrae_acentos(LTRIM(RTRIM(d.tgas_tdesc))) AS TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_ 
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_ 
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_ 
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_ 
			" null AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_ 
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_ 
			" null AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_ 
			" y.ccos_tcodigo AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_ 
			" CAST(b.pers_nrut AS VARCHAR) AS TSOF_COD_AUXILIAR,"& vbCrLf &_ 
			" 'RFF' AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" CAST(a.ffij_ncorr AS VARCHAR) AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
			" protic.trunc(z.ocag_fingreso) AS TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_ 
			" protic.trunc(z.ocag_fingreso) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_ 
			" 'RFF' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_ 
			" CAST(a.ffij_ncorr AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_ 
			" "&numeross()&" AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_ 
			" null TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOCUMENTO_DESDE,"& vbCrLf &_ 
			" null TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_ 
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_ 
			" null AS TSOF_bullshet1,"& vbCrLf &_ 
			" null AS TSOF_bullshet2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_ 
			" null AS TSOF_COD_MESANO,"& vbCrLf &_ 
			" null AS RETE,"& vbCrLf &_
			" null AS boleta"& vbCrLf &_
			" from ocag_rendicion_fondo_fijo z   "&_
			" inner join ocag_detalle_rendicion_fondo_fijo w ON Z.rffi_ncorr = W.rffi_ncorr"& vbCrLf &_
			" INNER JOIN ocag_fondo_fijo a ON W.ffij_ncorr = a.ffij_ncorr and z.rffi_ncorr ="&numero& vbCrLf &_
			" INNER JOIN personas b ON a.pers_ncorr = b.pers_ncorr"& vbCrLf &_
			" INNER JOIN ocag_tipo_gasto d ON W.tgas_ccod = d.tgas_ccod"& vbCrLf &_
			" INNER JOIN ocag_validacion_contable c on z.rffi_ncorr = c.cod_solicitud and isnull(c.tsol_ccod,8)=8"& vbCrLf &_
			" INNER JOIN ocag_centro_costo_validacion x ON c.vcon_ncorr=x.vcon_ncorr"& vbCrLf &_
			" INNER JOIN ocag_centro_costo y ON x.ccos_ncorr=y.ccos_ncorr"& vbCrLf &_
			" UNION"& vbCrLf &_
			" SELECT TOP 1 '2-10-070-10-000002' AS TSOF_PLAN_CUENTA,"& vbCrLf &_ 
			" 0 AS TSOF_DEBE,"& vbCrLf &_ 
			" CONVERT(INT, ROUND((SELECT SUM(CASE WHEN tdoc_ccod = 11 THEN odff.drff_mdocto*0.9 ELSE odff.drff_mdocto END) FROM ocag_detalle_rendicion_fondo_fijo odff WHERE rffi_ncorr=42),0)) AS TSOF_HABER,"& vbCrLf &_ 
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_ 
			" protic.extrae_acentos(LTRIM(RTRIM(d.tgas_tdesc))) AS TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_ 
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_ 
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_ 
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_ 
			" null AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_ 
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_ 
			" null AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_ 
			" null AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_ 
			" CAST(b.pers_nrut AS VARCHAR) AS TSOF_COD_AUXILIAR,"& vbCrLf &_ 
			" LTRIM(RTRIM('BC')) AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" CAST(a.ffij_ncorr AS VARCHAR) AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
			" protic.trunc(a.ocag_fingreso) AS TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_ 
			" protic.trunc(a.ocag_fingreso) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" LTRIM(RTRIM('BC')) AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_ 
			" CAST(a.ffij_ncorr AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_ 
			" "&numeross()&" AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_ 
			" null TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOCUMENTO_DESDE,"& vbCrLf &_ 
			" null TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_ 
			" '1' AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_ 
			" null AS TSOF_bullshet1,"& vbCrLf &_ 
			" null AS TSOF_bullshet2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_ 
			" null AS TSOF_COD_MESANO,"& vbCrLf &_ 
			" null AS RETE,"& vbCrLf &_
			" null AS boleta"& vbCrLf &_
			" from ocag_rendicion_fondo_fijo z"& vbCrLf &_
			" inner join ocag_detalle_rendicion_fondo_fijo w ON Z.rffi_ncorr = W.rffi_ncorr"& vbCrLf &_
			" INNER JOIN ocag_fondo_fijo a ON z.ffij_ncorr = a.ffij_ncorr and z.rffi_ncorr ="&numero& vbCrLf &_
			" INNER JOIN personas b ON a.pers_ncorr = b.pers_ncorr"& vbCrLf &_
			" INNER JOIN ocag_tipo_gasto d ON W.tgas_ccod = d.tgas_ccod  "
		costorendicionfondofijo = texto
	end function
	
	function presupuestorendicionfondofijo(numero)
		texo = "select '2-10-070-10-000002' as tsof_plan_cuenta,"& vbCrLf &_
			"CASE WHEN x.tdoc_ccod = 11 OR x.tdoc_ccod = 1 THEN CONVERT(INT, ROUND(x.drff_mdocto*0.9,0)) ELSE x.drff_mdocto END AS tsof_debe,"& vbCrLf &_
			" 0 as TSOF_HABER,"& vbCrLf &_
			" protic.extrae_acentos(RTRIM(LTRIM(d.tgas_tdesc))) as TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_
			" b.pers_nrut as TSOF_COD_AUXILIAR,"& vbCrLf &_
			" 'TR' as TSOF_TIPO_DOCUMENTO,"& vbCrLf &_
			" w.rffi_ncorr as TSOF_NRO_DOCUMENTO,"& vbCrLf &_
			" protic.trunc(a.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_
			" protic.trunc(a.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" e.tdoc_tdesc_softland AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" x.drff_ndocto AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" '' as TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" NULL as TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_
			" "&numeross()&" AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_
			" x.drff_mdocto AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_
			" CASE WHEN e.tdoc_tdesc_softland='BE' OR e.tdoc_tdesc_softland='BH' THEN x.drff_mdocto*0.1 ELSE NULL END AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_
			" NULL AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_
			" CASE WHEN e.tdoc_tdesc_softland='BE' OR e.tdoc_tdesc_softland='BH' THEN x.drff_mdocto*0.9 ELSE x.drff_mdocto END AS TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_
			" NULL AS TSOF_cod_mesano,"& vbCrLf &_
			" NULL as TSOF_monto_presupuesto"& vbCrLf &_
			" from ocag_rendicion_fondo_fijo w "& vbCrLf &_
			" INNER JOIN ocag_detalle_rendicion_fondo_fijo x ON w.rffi_ncorr = X.rffi_ncorr and w.rffi_ncorr ="&numer& vbCrLf &_
			" inner join ocag_presupuesto_solicitud z ON X.ffij_ncorr = Z.cod_solicitud  and z.tsol_ccod=6"& vbCrLf &_
			" INNER JOIN ocag_fondo_fijo a ON z.cod_solicitud = a.ffij_ncorr"& vbCrLf &_
			" INNER JOIN personas b ON x.pers_nrut = b.pers_nrut"& vbCrLf &_
			" INNER JOIN ocag_tipo_gasto d ON x.tgas_ccod = d.tgas_ccod"& vbCrLf &_
			" INNER JOIN ocag_tipo_documento e ON x.tdoc_ccod = e.tdoc_ccod"& vbCrLf &_
			" union"& vbCrLf &_
			" select '2-10-070-10-000002' as tsof_plan_cuenta,"& vbCrLf &_
			" 0 as tsof_debe,"& vbCrLf &_
			" CASE WHEN w.tdoc_ccod = 11 OR w.tdoc_ccod = 1 THEN CONVERT(INT, ROUND(w.drff_mdocto*0.9,0)) ELSE w.drff_mdocto END as TSOF_HABER,"& vbCrLf &_
			" protic.extrae_acentos(RTRIM(LTRIM(d.tgas_tdesc))) as TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_
			" b.pers_nrut as TSOF_COD_AUXILIAR,"& vbCrLf &_
			" e.tdoc_tdesc_softland as TSOF_TIPO_DOCUMENTO,"& vbCrLf &_
			" w.drff_ndocto as TSOF_NRO_DOCUMENTO,"& vbCrLf &_
			" protic.trunc(a.ocag_fingreso)as TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_
			" protic.trunc(a.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" e.tdoc_tdesc_softland AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" w.drff_ndocto AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" '' as TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" NULL as TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_
			" "&numeross()&" AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_
			" w.drff_mdocto AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_
			" CASE WHEN e.tdoc_tdesc_softland='BE' OR e.tdoc_tdesc_softland='BH' THEN w.drff_mdocto*0.1 ELSE NULL END AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_
			" NULL AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_
			" CASE WHEN e.tdoc_tdesc_softland='BE' OR e.tdoc_tdesc_softland='BH' THEN w.drff_mdocto*0.9 ELSE w.drff_mdocto END as TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_
			" NULL AS TSOF_cod_mesano,"& vbCrLf &_
			" NULL as TSOF_monto_presupuesto"& vbCrLf &_
			" from  ocag_detalle_rendicion_fondo_fijo w"& vbCrLf &_
			" inner join ocag_presupuesto_solicitud z ON w.ffij_ncorr = Z.cod_solicitud and w.rffi_ncorr ="&numer&" and z.tsol_ccod=6"& vbCrLf &_
			" INNER JOIN ocag_fondo_fijo a ON z.cod_solicitud = a.ffij_ncorr"& vbCrLf &_
			" INNER JOIN personas b ON w.pers_nrut = b.pers_nrut"& vbCrLf &_
			" inner join ocag_rendicion_fondo_fijo c ON a.ffij_ncorr = c.ffij_ncorr"& vbCrLf &_
			" INNER JOIN ocag_tipo_gasto d ON w.tgas_ccod = d.tgas_ccod"& vbCrLf &_
			" INNER JOIN ocag_tipo_documento e ON w.tdoc_ccod = e.tdoc_ccod"& vbCrLf &_
			" union"& vbCrLf &_
			" select '2-10-120-10-000003' as tsof_plan_cuenta,"& vbCrLf &_
			" 0 as tsof_debe,"& vbCrLf &_
			" CASE WHEN w.tdoc_ccod = 11 OR w.tdoc_ccod = 1 THEN CONVERT(INT, ROUND(w.drff_mdocto*0.1,0)) ELSE w.drff_mdocto END AS TSOF_HABER,"& vbCrLf &_
			" protic.extrae_acentos(RTRIM(LTRIM(d.tgas_tdesc))) AS TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_
			" NULL as TSOF_COD_AUXILIAR,"& vbCrLf &_
			" NULL as TSOF_TIPO_DOCUMENTO,"& vbCrLf &_
			" NULL as TSOF_NRO_DOCUMENTO,"& vbCrLf &_
			" NULL AS TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_
			" NULL as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" NULL AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" NULL AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" NULL as TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" NULL as TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_
			" NULL AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_
			" NULL AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_
			" NULL AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_
			" NULL AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_
			" NULL as TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_
			" NULL AS TSOF_cod_mesano,"& vbCrLf &_
			" NULL as TSOF_monto_presupuesto"& vbCrLf &_
			" from  ocag_detalle_rendicion_fondo_fijo w"& vbCrLf &_
			" inner join ocag_presupuesto_solicitud z ON w.ffij_ncorr = Z.cod_solicitud and w.rffi_ncorr ="&numer&" and z.tsol_ccod=6"& vbCrLf &_
			" INNER JOIN ocag_fondo_fijo a ON z.cod_solicitud = a.ffij_ncorr"& vbCrLf &_
			" INNER JOIN personas b ON a.pers_ncorr = b.pers_ncorr"& vbCrLf &_
			" inner join ocag_rendicion_fondo_fijo c ON a.ffij_ncorr = c.ffij_ncorr"& vbCrLf &_
			" INNER JOIN ocag_tipo_gasto d ON w.tgas_ccod = d.tgas_ccod"& vbCrLf &_
			" WHERE (w.tdoc_ccod = 11 OR w.tdoc_ccod = 1)"
		presupuestorendicionfondofijo=texto
	end function
	
	function presupuestopagoproveedor(numero)
		texto = "select '2-10-070-10-000002' as tsof_plan_cuenta,"& vbCrLf &_
			" CASE WHEN otd.tdoc_tdesc_softland = 'CR' OR otd.tdoc_tdesc_softland = 'BD' THEN ABS(d.dsgi_mdocto) ELSE e.psol_mpresupuesto END as tsof_debe,"& vbCrLf &_
			" 0 as TSOF_HABER,"& vbCrLf &_
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_ 
			" protic.extrae_acentos(LTRIM(RTRIM(b.sogi_tobservaciones))) AS TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_ 
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_ 
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_ 
			" null AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_ 
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_ 
			" null AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_ 
			" NULL AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_ 
			" CONVERT(VARCHAR(20),c.PERS_NRUT) AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			" CASE WHEN otd.tdoc_tdesc_softland = 'CR' THEN LTRIM(RTRIM('CR')) ELSE LTRIM(RTRIM('TR')) END AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" CAST(b.sogi_ncorr AS VARCHAR) AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
			" protic.trunc(b.sogi_fecha_solicitud) AS TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_
			" protic.trunc(b.sogi_fecha_solicitud) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" CASE WHEN d.tdoc_ref_ccod IS NOT NULL THEN h.tdoc_tdesc_softland ELSE otd.tdoc_tdesc_softland END as TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" CASE WHEN d.tdoc_ref_ccod IS NOT NULL THEN d.dsgi_ref_ndocto ELSE d.dsgi_ndocto END as TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" "&numeross()&" AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_ 
			" CASE WHEN otd.tdoc_tdesc_softland='FI' OR otd.tdoc_tdesc_softland='CR' THEN ABS(d.dsgi_mdocto + d.dsgi_mretencion) ELSE NULL END AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_ 
			" CASE WHEN otd.tdoc_tdesc_softland='FI' OR otd.tdoc_tdesc_softland='CR' THEN ABS(d.dsgi_mafecto) ELSE ABS(d.dsgi_mdocto +d.dsgi_mretencion) END AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_ 
			" CASE WHEN otd.tdoc_tdesc_softland='FI' OR otd.tdoc_tdesc_softland='CR' THEN ABS(d.dsgi_miva) ELSE ABS(d.dsgi_mretencion) END AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_ 
			" CASE WHEN f.tdoc_ref_ccod IS NOT NULL AND f.tdoc_ref_ccod = d.tdoc_ccod THEN ABS(d.dsgi_mdocto)-ABS(f.dsgi_mdocto) ELSE ABS(d.dsgi_mdocto) END TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOCUMENTO_DESDE,"& vbCrLf &_ 
			" null TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_ 
			" '1' AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_ 
			" null AS TSOF_bullshet1,"& vbCrLf &_ 
			" null AS TSOF_bullshet2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_ 
			" null AS TSOF_COD_MESANO,"& vbCrLf &_ 
			"	b.sogi_bboleta_honorario AS boleta,"& vbCrLf &_
			"	0 AS rete"& vbCrLf &_
			"	from ocag_presupuesto_solicitud a"& vbCrLf &_
			"		INNER JOIN ocag_solicitud_giro b ON a.cod_solicitud = b.sogi_ncorr AND cod_solicitud = "& numero &" AND a.tsol_ccod = 1"& vbCrLf &_
			"		INNER JOIN ocag_presupuesto_solicitud e ON e.cod_solicitud=b.sogi_ncorr AND e.tsol_ccod = 1"& vbCrLf &_
			"		INNER JOIN ocag_detalle_solicitud_giro d ON b.sogi_ncorr = d.sogi_ncorr"& vbCrLf &_
			"		INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr"& vbCrLf &_
			"		INNER JOIN ocag_tipo_documento otd ON otd.tdoc_ccod=d.tdoc_ccod"& vbCrLf &_
			"		INNER JOIN ocag_detalle_solicitud_ag g ON g.sogi_ncorr=b.sogi_ncorr"& vbCrLf &_
			"		LEFT JOIN ocag_detalle_solicitud_giro f ON f.sogi_ncorr=b.sogi_ncorr AND f.tdoc_ref_ccod = d.tdoc_ccod"& vbCrLf &_
			"		LEFT JOIN ocag_tipo_documento h ON h.tdoc_ccod=d.tdoc_ref_ccod"& vbCrLf &_
			" union  "& vbCrLf &_
			" select '2-10-070-10-000002' as tsof_plan_cuenta,"& vbCrLf &_
			"   0 as tsof_debe,"& vbCrLf &_
			"   CASE WHEN otd.tdoc_tdesc_softland = 'CR' OR otd.tdoc_tdesc_softland = 'BD' THEN ABS(d.dsgi_mdocto) ELSE e.psol_mpresupuesto END as TSOF_HABER,"& vbCrLf &_
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_ 
			" protic.extrae_acentos(LTRIM(RTRIM(b.sogi_tobservaciones))) AS TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_ 
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_ 
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_ 
			" null AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_ 
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_ 
			" null AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_
			" null AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_
			" CONVERT(VARCHAR(20),c.PERS_NRUT) AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			" otd.tdoc_tdesc_softland AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" CAST(b.sogi_ncorr AS VARCHAR) AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
			" protic.trunc(b.sogi_fecha_solicitud) AS TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_
			"	protic.trunc(b.sogi_fecha_solicitud) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			"   otd.tdoc_tdesc_softland as TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			"   d.dsgi_ndocto as TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" "&numeross()&" AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_ 
			" CASE WHEN otd.tdoc_tdesc_softland='FI' OR otd.tdoc_tdesc_softland='FL' OR otd.tdoc_tdesc_softland='CR' THEN d.dsgi_mdocto + d.dsgi_mretencion ELSE NULL END AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_ 
			" CASE WHEN otd.tdoc_tdesc_softland='FI' OR otd.tdoc_tdesc_softland='FL' OR otd.tdoc_tdesc_softland='CR' THEN d.dsgi_mafecto ELSE d.dsgi_mdocto +d.dsgi_mretencion END AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_ 
			" CASE WHEN otd.tdoc_tdesc_softland='FI' OR otd.tdoc_tdesc_softland='FL' OR otd.tdoc_tdesc_softland='CR' THEN d.dsgi_miva ELSE d.dsgi_mretencion END AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_ 
			" d.dsgi_mdocto TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOCUMENTO_DESDE,"& vbCrLf &_ 
			" null TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_ 
			" '1' AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_ 
			" null AS TSOF_bullshet1,"& vbCrLf &_ 
			" null AS TSOF_bullshet2,"& vbCrLf &_ 
			" null AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_ 
			" null AS TSOF_COD_MESANO,"& vbCrLf &_ 
			"	b.sogi_bboleta_honorario AS boleta,"& vbCrLf &_
			"	0 AS rete"& vbCrLf &_
			"	from ocag_presupuesto_solicitud a"& vbCrLf &_
			"		INNER JOIN ocag_solicitud_giro b ON a.cod_solicitud = b.sogi_ncorr AND cod_solicitud = "& numero &" AND a.tsol_ccod = 1" & vbCrLf &_
			"		INNER JOIN ocag_presupuesto_solicitud e ON e.cod_solicitud=b.sogi_ncorr AND e.tsol_ccod = 1 "& vbCrLf &_
			"		INNER JOIN ocag_detalle_solicitud_giro d ON b.sogi_ncorr = d.sogi_ncorr"& vbCrLf &_
			"		INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr"& vbCrLf &_
			"		INNER JOIN ocag_tipo_documento otd ON otd.tdoc_ccod=d.tdoc_ccod"& vbCrLf &_
			"		INNER JOIN ocag_detalle_solicitud_ag g ON g.sogi_ncorr=b.sogi_ncorr"& vbCrLf &_
			"		LEFT JOIN ocag_detalle_solicitud_giro f ON f.sogi_ncorr=b.sogi_ncorr AND f.tdoc_ref_ccod=NULL"& vbCrLf &_
			"	WHERE d.tdoc_ccod <> 7"
		presupuestopagoproveedor = texto
	end function
	
	function presupuestoreembolso(numero)
		texto ="select '2-10-070-10-000002' as tsof_plan_cuenta,"& vbCrLf &_
			" d.drga_mdocto + d.drga_mretencion as tsof_debe,"& vbCrLf &_
			" 0 as TSOF_HABER,"& vbCrLf &_
			" protic.extrae_acentos(LTRIM(RTRIM(d.drga_tdescripcion))) as TSOF_GLOSA_SIN_ACENTO,"&_
			" NULL AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_
			" c.pers_nrut as TSOF_COD_AUXILIAR,"& vbCrLf &_
			" 'TR' as TSOF_TIPO_DOCUMENTO,"& vbCrLf &_
			" d.drga_ndocto as TSOF_NRO_DOCUMENTO,"& vbCrLf &_
			" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_
			" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" otd.tdoc_tdesc_softland AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" d.drga_ndocto AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" null as TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" "&numeross()&" AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_
			" CASE WHEN otd.tdoc_tdesc_softland='FI' THEN d.drga_mdocto + d.drga_mretencion ELSE NULL END AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_
			" CASE WHEN otd.tdoc_tdesc_softland='FI' THEN null ELSE d.drga_mdocto END AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_
			" CASE WHEN otd.tdoc_tdesc_softland='FI' THEN null ELSE d.drga_mretencion END AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_
			" d.drga_mdocto + d.drga_mretencion as TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_
			" CASE WHEN otd.tdoc_tdesc_softland='BC' THEN CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) ELSE NULL END AS TSOF_cod_mesano,"& vbCrLf &_
			" CASE WHEN otd.tdoc_tdesc_softland='BC' THEN d.drga_mdocto END AS TSOF_monto_presupuesto"& vbCrLf &_
			" from ocag_presupuesto_solicitud a "& vbCrLf &_
			" INNER JOIN ocag_reembolso_gastos b ON a.cod_solicitud = b.rgas_ncorr AND cod_solicitud ="&numer&"  AND a.tsol_ccod = 2"& vbCrLf &_
			" INNER JOIN ocag_detalle_reembolso_gasto d ON b.rgas_ncorr = d.rgas_ncorr "& vbCrLf &_
			" INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr INNER JOIN ocag_tipo_documento otd ON otd.tdoc_ccod=d.tdoc_ccod "& vbCrLf & vbCrLf &_
			" union"& vbCrLf &_
			" select '2-10-070-10-000002' as tsof_plan_cuenta,"& vbCrLf &_
			" 0 as tsof_debe,"& vbCrLf &_
			" d.drga_mdocto + d.drga_mretencion as TSOF_HABER,"& vbCrLf &_
			" protic.extrae_acentos(LTRIM(RTRIM(d.drga_tdescripcion))) as TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_
			" NULL AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_
			" c.pers_nrut as TSOF_COD_AUXILIAR,"& vbCrLf &_
			" otd.tdoc_tdesc_softland as TSOF_TIPO_DOCUMENTO,"& vbCrLf &_
			" d.drga_ndocto as TSOF_NRO_DOCUMENTO,"& vbCrLf &_
			" protic.trunc(b.ocag_fingreso)as TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_
			" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" otd.tdoc_tdesc_softland AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" d.drga_ndocto AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" null as TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" "&numeross()&" AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_
			" CASE WHEN otd.tdoc_tdesc_softland='FI' THEN d.drga_mdocto + d.drga_mretencion ELSE NULL END AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_
			" CASE WHEN otd.tdoc_tdesc_softland='FI' THEN null ELSE d.drga_mdocto END AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_
			" CASE WHEN otd.tdoc_tdesc_softland='FI' THEN null ELSE d.drga_mretencion END AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_
			" d.drga_mdocto + d.drga_mretencion as TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_
			" CASE WHEN otd.tdoc_tdesc_softland='BC' THEN CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) ELSE NULL END AS TSOF_cod_mesano,"& vbCrLf &_
			" CASE WHEN otd.tdoc_tdesc_softland='BC' THEN d.drga_mdocto END AS TSOF_monto_presupuesto  "& vbCrLf &_
			" from ocag_presupuesto_solicitud a  "& vbCrLf &_
			" INNER JOIN ocag_reembolso_gastos b ON a.cod_solicitud = b.rgas_ncorr AND cod_solicitud ="&numero&"  AND a.tsol_ccod = 2  "& vbCrLf &_
			" INNER JOIN ocag_detalle_reembolso_gasto d ON b.rgas_ncorr = d.rgas_ncorr "& vbCrLf &_
			" INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr INNER JOIN ocag_tipo_documento otd ON otd.tdoc_ccod=d.tdoc_ccod"
		presupuestoreembolso = texto
	end function
	
	function presupuestofondorendir()
		texto = "select NULL AS TSOF_NRO_DOC_REFERENCIA, NULL AS TSOF_TIPO_DOC_REFERENCIA, NULL AS TSOF_COD_CENTRO_COSTO, NULL AS TSOF_HABER, NULL AS TSOF_DEBE WHERE 1=2"
		presupuestofondorendir= texto
	end function
	
	function presupuestosolicitudviatico()
		texto = "select NULL AS TSOF_NRO_DOC_REFERENCIA, NULL AS TSOF_TIPO_DOC_REFERENCIA, NULL AS TSOF_COD_CENTRO_COSTO, NULL AS TSOF_HABER, NULL AS TSOF_DEBE WHERE 1=2"
		presupuestosolicitudviatico = texto
	end function
	
	function presupuestodevolucionalumno()
		texto = "select NULL AS TSOF_NRO_DOC_REFERENCIA, NULL AS TSOF_TIPO_DOC_REFERENCIA, NULL AS TSOF_COD_CENTRO_COSTO, NULL AS TSOF_HABER, NULL AS TSOF_DEBE WHERE 1=2"
		presupuestodevolucionalumno = texto
	end function
	
	function presupuestofondofijo()
		texto = "select NULL AS TSOF_NRO_DOC_REFERENCIA, NULL AS TSOF_TIPO_DOC_REFERENCIA, NULL AS TSOF_COD_CENTRO_COSTO, NULL AS TSOF_HABER, NULL AS TSOF_DEBE WHERE 1=2"
		presupuestofondofijo = texto
	end function
	
	function presupuestorendicionfondorendir(numero)
		texto ="SELECT 0 AS numero, '2-10-070-10-000002' AS TSOF_PLAN_CUENTA,"& vbCrLf &_
			" CASE WHEN b.tdoc_tdesc_softland='BE' THEN drfr_mdocto-drfr_mretencion ELSE drfr_mdocto END AS TSOF_DEBE,"& vbCrLf &_
			" 0 AS TSOF_HABER,"& vbCrLf &_
			" protic.extrae_acentos(RTRIM(LTRIM(c.tgas_tdesc))) AS TSOF_GLOSA_SIN_ACENTO,"&_
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_
			" null AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"&_
			" null AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_
			" null AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_
			" null AS TSOF_COD_CENTRO_COSTO,"&_
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_
			" replace(a.drfr_trut, right(a.drfr_trut,2),'') AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			" 'TR' AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_
			" a.drfr_ndocto AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_
			" CONVERT(VARCHAR(32),protic.trunc(a.drfr_fdocto)) AS TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_
			" CONVERT(VARCHAR(32),protic.trunc(a.drfr_fdocto)) AS TSOF_FECHA_VENCIMIENTO_CORTA,"&_
			" b.tdoc_tdesc_softland AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" a.drfr_ndocto AS TSOF_NRO_DOC_REFERENCIA, "&_
			" null AS TSOF_NRO_CORRELATIVO, "&_
			" CASE WHEN b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH' THEN CONVERT(VARCHAR(32),drfr_mdocto) ELSE '' END AS TSOF_MONTO_DET_LIBRO1, "&_ 
			" CASE WHEN b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH' THEN CONVERT(VARCHAR(32),drfr_mretencion) ELSE CONVERT(VARCHAR(32),CONVERT(INT,ROUND(drfr_mdocto/1.19,0))) END  AS TSOF_MONTO_DET_LIBRO2, "&_
			" CASE WHEN b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH' THEN '' ELSE CONVERT(VARCHAR(32), CONVERT(INT,ROUND(drfr_mdocto*0.19/1.19,0))) END AS TSOF_MONTO_DET_LIBRO3,"&_
			" null AS TSOF_MONTO_DET_LIBRO4,"&_
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO9,"&_
			" CASE WHEN b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH' THEN drfr_mdocto-drfr_mretencion ELSE drfr_mdocto END AS TSOF_MONTO_SUMA_DET_LIBRO,'' AS TSOF_NRO_DOCUMENTO_DESDE,"&_
			" null AS TSOF_NRO_DOCUMENTO_HASTA,1 AS TSOF_NRO_AGRUPADOR,'' AS TSOF_bullshet1,''  AS TSOF_bullshet2,'' AS TSOF_MONTO_PRESUPUESTO,'' AS TSOF_COD_MESANO "&_
			" FROM ocag_detalle_rendicion_fondo_rendir a INNER JOIN ocag_tipo_documento b ON a.tdoc_ccod=b.tdoc_ccod "&_
			" INNER JOIN ocag_tipo_gasto c ON a.tgas_ccod=c.tgas_ccod WHERE fren_ncorr="&numero&" AND (b.tdoc_tdesc_softland = 'BE' OR b.tdoc_tdesc_softland = 'BH' OR b.tdoc_tdesc_softland = 'FL' OR b.tdoc_tdesc_softland = 'FE' OR b.tdoc_tdesc_softland = 'FI' OR b.tdoc_tdesc_softland = 'FP') "& vbCrLf &_
			" UNION "&_
			" SELECT 0 AS numero, '2-10-070-10-000002' AS TSOF_PLAN_CUENTA,"& vbCrLf &_
			" 0 AS TSOF_DEBE,"& vbCrLf &_
			" CASE WHEN b.tdoc_tdesc_softland='BE' THEN drfr_mdocto-drfr_mretencion ELSE drfr_mdocto END AS TSOF_HABER,"& vbCrLf &_
			" protic.extrae_acentos(RTRIM(LTRIM(c.tgas_tdesc))) AS TSOF_GLOSA_SIN_ACENTO,"&_
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_
			" null AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_
			" null AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_
			" null AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_
			" null AS TSOF_COD_CENTRO_COSTO,"&_
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_
			" replace(a.drfr_trut, right(a.drfr_trut,2),'') AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			" b.tdoc_tdesc_softland AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_
			" a.drfr_ndocto AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_
			" CONVERT(VARCHAR(32),protic.trunc(a.drfr_fdocto)) AS TSOF_FECHA_EMISION_CORTA,"&_
			" CONVERT(VARCHAR(32),protic.trunc(a.drfr_fdocto)) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" b.tdoc_tdesc_softland AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" a.drfr_ndocto AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" '"&numeross()&"' AS TSOF_NRO_CORRELATIVO, "&_
			" CASE WHEN b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH' THEN CONVERT(VARCHAR(32),drfr_mdocto) ELSE '' END AS TSOF_MONTO_DET_LIBRO1, "&_
			" CASE WHEN b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH' THEN CONVERT(VARCHAR(32),drfr_mretencion) ELSE CONVERT(VARCHAR(32),CONVERT(INT,ROUND(drfr_mdocto/1.19,0))) END  AS TSOF_MONTO_DET_LIBRO2, "&_
			" CASE WHEN b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH' THEN '' ELSE CONVERT(VARCHAR(32), CONVERT(INT,ROUND(drfr_mdocto*0.19/1.19,0))) END AS TSOF_MONTO_DET_LIBRO3,"&_
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO8, "&_
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_
			" CASE WHEN b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH' THEN drfr_mdocto-drfr_mretencion ELSE drfr_mdocto END AS TSOF_MONTO_SUMA_DET_LIBRO,'' AS TSOF_NRO_DOCUMENTO_DESDE,"&_
			" null AS TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_
			" null AS TSOF_bullshet1,"& vbCrLf &_
			" null AS TSOF_bullshet2,"& vbCrLf &_
			" null AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_
			" null AS TSOF_COD_MESANO "&_
			" FROM ocag_detalle_rendicion_fondo_rendir a INNER JOIN ocag_tipo_documento b ON a.tdoc_ccod=b.tdoc_ccod "&_
			" INNER JOIN ocag_tipo_gasto c ON a.tgas_ccod=c.tgas_ccod WHERE fren_ncorr="&numero&" AND (b.tdoc_tdesc_softland = 'BE' OR b.tdoc_tdesc_softland = 'BH' OR b.tdoc_tdesc_softland = 'FL' OR b.tdoc_tdesc_softland = 'FE' OR b.tdoc_tdesc_softland = 'FI' OR b.tdoc_tdesc_softland = 'FP') "& vbCrLf &_
			" UNION "&_
			" SELECT 0 AS numero, '2-10-120-10-000003' AS TSOF_PLAN_CUENTA,"& vbCrLf &_
			" 0 AS TSOF_DEBE,"& vbCrLf &_
			" CASE WHEN (b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH') THEN drfr_mretencion ELSE 0 END AS TSOF_HABER,"& vbCrLf &_
			" protic.extrae_acentos(RTRIM(LTRIM(c.tgas_tdesc))) AS TSOF_GLOSA_SIN_ACENTO,"&_
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_
			" null AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_
			" null AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_
			" null AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_
			" null AS TSOF_COD_CENTRO_COSTO,"&_
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_
			" null AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			" null AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_
			" 0 AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_
			" null AS TSOF_FECHA_EMISION_CORTA,"&_
			" null AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" null AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			"0 AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" null AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO1,"&_
			" null AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO9,"&_
			" null AS TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_
			" null AS TSOF_NRO_DOCUMENTO_DESDE,"&_
			" null AS TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_
			" null AS TSOF_bullshet1,"& vbCrLf &_
			" null AS TSOF_bullshet2,"& vbCrLf &_
			" null AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_
			" null AS TSOF_COD_MESANO "&_
			" FROM ocag_detalle_rendicion_fondo_rendir a"& vbCrLf &_
			" INNER JOIN ocag_tipo_documento b ON a.tdoc_ccod=b.tdoc_ccod "&_
			" INNER JOIN ocag_tipo_gasto c ON a.tgas_ccod=c.tgas_ccod"& vbCrLf &_
			" WHERE fren_ncorr="&numero&" AND (b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH')" 
		presupuestorendicionfondorendir = texto
	end function
	
	function presupuestopagoproveedortotal(numero)
		texto = "SELECT '2-10-070-10-000004' AS TSOF_PLAN_CUENTA,"& vbCrLf &_
			" e.psol_mpresupuesto AS TSOF_DEBE,"& vbCrLf &_
			" 0 AS TSOF_HABER, "& vbCrLf &_
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_ 
			" protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) AS TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_ 
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_ 
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_ 
			" null AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_ 
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_ 
			" null AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_
			" e.cod_pre AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_
			" CONVERT(VARCHAR(20),b.PERS_NRUT) AS TSOF_COD_AUXILIAR, "& vbCrLf &_
			" LTRIM(RTRIM('TR')) AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" CAST(a.sogi_ncorr AS VARCHAR) AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_
			" protic.trunc(a.sogi_fecha_solicitud) AS TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_
			" protic.trunc(a.sogi_fecha_solicitud) AS TSOF_FECHA_VENCIMIENTO_CORTA, "& vbCrLf &_
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" CAST(a.sogi_ncorr AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" "&numeross()&" AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_ 
			" NULL AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_ 
			" NULL AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_ 
			" NULL AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_ 
			" null TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOCUMENTO_DESDE,"& vbCrLf &_ 
			" null TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_ 
			" '1' AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_ 
			" null AS TSOF_bullshet1,"& vbCrLf &_ 
			" null AS TSOF_bullshet2,"& vbCrLf &_ 
			" e.psol_mpresupuesto AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_ 
			" CASE WHEN MONTH(a.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(a.ocag_fingreso) AS VARCHAR) + CAST(YEAR(a.ocag_fingreso) AS VARCHAR) AS TSOF_COD_MESANO,"& vbCrLf &_
			"	0 AS rete,"& vbCrLf &_
			"	a.sogi_bboleta_honorario AS boleta "& vbCrLf &_
			"	FROM ocag_solicitud_giro a "& vbCrLf &_
			"		INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr ="& numero & vbCrLf &_
			"		INNER JOIN ocag_detalle_solicitud_ag c ON a.sogi_ncorr = c.sogi_ncorr "& vbCrLf &_
			"		INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod "& vbCrLf &_
			"		INNER JOIN ocag_presupuesto_solicitud e ON e.cod_solicitud=a.sogi_ncorr AND e.tsol_ccod=1"& vbCrLf &_ 
			"		INNER JOIN ocag_detalle_solicitud_giro f ON f.sogi_ncorr=a.sogi_ncorr"& vbCrLf &_ 
			"		INNER JOIN ocag_tipo_documento g ON g.tdoc_ccod = f.tdoc_ccod"& vbCrLf &_ 
			"UNION"& vbCrLf &_
			"SELECT '2-10-070-10-000004' AS TSOF_PLAN_CUENTA,"& vbCrLf &_
			"	0 AS TSOF_DEBE,"& vbCrLf &_
			"	e.psol_mpresupuesto AS TSOF_HABER, "& vbCrLf &_
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_ 
			" protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) AS TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_ 
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_ 
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_ 
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_ 
			" null AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_ 
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_ 
			" null AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_ 
			" null AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_
			" e.cod_pre AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_
			"	CONVERT(VARCHAR(20),b.PERS_NRUT) AS TSOF_COD_AUXILIAR, "& vbCrLf &_
			" LTRIM(RTRIM('BC')) AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" CAST(a.sogi_ncorr AS VARCHAR) AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_
			" protic.trunc(a.sogi_fecha_solicitud) AS TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_
			"	protic.trunc(a.sogi_fecha_solicitud) AS TSOF_FECHA_VENCIMIENTO_CORTA, "& vbCrLf &_
			"	'BC' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			"	CAST(a.sogi_ncorr AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" "&numeross()&" AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_ 
			" NULL AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_ 
			" NULL AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_ 
			" NULL AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_ 
			" null TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_  
			" null AS TSOF_NRO_DOCUMENTO_DESDE,"& vbCrLf &_ 
			" null TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_ 
			" '1' AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_ 
			" null AS TSOF_bullshet1,"& vbCrLf &_ 
			" null AS TSOF_bullshet2,"& vbCrLf &_ 
			" e.psol_mpresupuesto AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_ 
			" CASE WHEN MONTH(a.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(a.ocag_fingreso) AS VARCHAR) + CAST(YEAR(a.ocag_fingreso) AS VARCHAR) AS TSOF_COD_MESANO,"& vbCrLf &_ 
			"	0 AS rete,"& vbCrLf &_
			"	a.sogi_bboleta_honorario AS boleta "& vbCrLf &_
			"	FROM ocag_solicitud_giro a "& vbCrLf &_
			"		INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr ="& numero & vbCrLf &_
			"		INNER JOIN ocag_detalle_solicitud_ag c ON a.sogi_ncorr = c.sogi_ncorr "& vbCrLf &_
			"		INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod "& vbCrLf &_
			"		INNER JOIN ocag_presupuesto_solicitud e ON e.cod_solicitud=a.sogi_ncorr AND e.tsol_ccod=1"& vbCrLf &_ 
			"		INNER JOIN ocag_detalle_solicitud_giro f ON f.sogi_ncorr=a.sogi_ncorr"& vbCrLf &_ 
			"		INNER JOIN ocag_tipo_documento g ON g.tdoc_ccod = f.tdoc_ccod"& vbCrLf &_ 
			"	WHERE g.tdoc_ccod <> 7"
		presupuestopagoproveedortotal = texto
	end function
	
	function presupuestoreembolsototal(numero)
		texto = " select '2-10-070-10-000004' as tsof_plan_cuenta,"& vbCrLf &_ 
			" b.rgas_mgiro as tsof_debe,"& vbCrLf &_ 
			" 0 as TSOF_HABER, "&_
			" protic.extrae_acentos(LTRIM(RTRIM((SELECT TOP 1 drga_tdescripcion FROM ocag_detalle_reembolso_gasto WHERE rgas_ncorr="&numer&")))) as TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_ 
			" ops.cod_pre AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_ 
			" c.pers_nrut as TSOF_COD_AUXILIAR,"&_
			" 'TR' as TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" b.rgas_ncorr as TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
			" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA, "&_
			" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_ 
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA, "&_
			" b.rgas_ncorr AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_ 
			" null as TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			" NULL AS TSOF_NRO_CORRELATIVO, "&_
			" NULL AS TSOF_MONTO_DET_LIBRO1,"&_
			" NULL AS TSOF_MONTO_DET_LIBRO2,"&_
			" NULL TSOF_MONTO_DET_LIBRO3,"&_
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO7, "&_
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_ 
			" NULL as TSOF_MONTO_SUMA_DET_LIBRO, "&_
			" 1 AS TSOF_NRO_AGRUPADOR  , "&_
			" CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) TSOF_cod_mesano, "&_
			" b.rgas_mgiro AS TSOF_monto_presupuesto  "&_
			" from ocag_presupuesto_solicitud a "&_
			" INNER JOIN ocag_reembolso_gastos b ON a.cod_solicitud = b.rgas_ncorr AND cod_solicitud ="&numero&"  AND a.tsol_ccod = 2  "&_
			" INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr "&_
			" INNER JOIN ocag_presupuesto_solicitud ops ON b.rgas_ncorr=ops.cod_solicitud AND ops.tsol_ccod = 2"& vbCrLf &_
			"UNION "&_
			" select '2-10-070-10-000004' as tsof_plan_cuenta,"& vbCrLf &_ 
			" 0 as tsof_debe,"& vbCrLf &_ 
			" b.rgas_mgiro as TSOF_HABER, "&_
			" protic.extrae_acentos(LTRIM(RTRIM((SELECT TOP 1 drga_tdescripcion FROM ocag_detalle_reembolso_gasto WHERE rgas_ncorr="&numer&")))) as TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_ 
			" ops.cod_pre AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_ 
			" c.pers_nrut as TSOF_COD_AUXILIAR,"&_
			" 'BC' as TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" b.rgas_ncorr as TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
			" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA, "&_
			" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_ 
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA, "&_
			" b.rgas_ncorr AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_ 
			" null as TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			" NULL AS TSOF_NRO_CORRELATIVO, "&_
			" NULL AS TSOF_MONTO_DET_LIBRO1,"&_
			" NULL AS TSOF_MONTO_DET_LIBRO2,"&_
			" NULL TSOF_MONTO_DET_LIBRO3,"&_
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO7, "&_
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_ 
			" null AS TSOF_MONTO_DET_LIBRO9, NULL as TSOF_MONTO_SUMA_DET_LIBRO, "&_
			" 1 AS TSOF_NRO_AGRUPADOR, "&_
			" CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) TSOF_cod_mesano, "&_
			" b.rgas_mgiro AS TSOF_monto_presupuesto  "&_
			" from ocag_presupuesto_solicitud a "&_
			" INNER JOIN ocag_reembolso_gastos b ON a.cod_solicitud = b.rgas_ncorr AND cod_solicitud ="&numero&"  AND a.tsol_ccod = 2  "&_
			" INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr "&_
			" INNER JOIN ocag_presupuesto_solicitud ops ON b.rgas_ncorr=ops.cod_solicitud AND ops.tsol_ccod = 2"
		presupuestoreembolsototal = texto
	end function
	
	function presupuestofondorendirtotal(numero)
		texto ="select '2-10-070-10-000004' as tsof_plan_cuenta,"&_
			" a.psol_mpresupuesto as tsof_debe,"&_
			" 0 as TSOF_HABER,"&_
			" protic.extrae_acentos(LTRIM(RTRIM(b.fren_tdescripcion_actividad))) as TSOF_GLOSA_SIN_ACENTO,"&_
			" c.pers_nrut as TSOF_COD_AUXILIAR,"&_
			" 'TR' as TSOF_TIPO_DOCUMENTO,"&_
			" b.fren_ncorr as TSOF_NRO_DOCUMENTO,"&_
			" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA,"&_
			" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA,"&_
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA,"&_
			" b.fren_ncorr AS TSOF_NRO_DOC_REFERENCIA,"&_
			" '' as TSOF_COD_CENTRO_COSTO,"&_
			" a.cod_pre as TSOF_COD_CONCEPTO_CAJA,"&_
			" 1 AS TSOF_NRO_AGRUPADOR,"&_
			" CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano,"&_
			" a.psol_mpresupuesto as TSOF_monto_presupuesto"&_
			" from ocag_presupuesto_solicitud a"&_
			" INNER JOIN ocag_fondos_a_rendir b ON a.cod_solicitud = b.fren_ncorr AND cod_solicitud ="&numer&" and a.tsol_ccod=3"&_
			" INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr"&_
			" union"&_
			" select '2-10-070-10-000004' as tsof_plan_cuenta,"&_
			" 0 as tsof_debe,"&_
			" a.psol_mpresupuesto as TSOF_HABER,"&_
			" protic.extrae_acentos(LTRIM(RTRIM(b.fren_tdescripcion_actividad))) as TSOF_GLOSA_SIN_ACENTO,"&_
			" c.pers_nrut as TSOF_COD_AUXILIAR,"&_
			" 'BC' as TSOF_TIPO_DOCUMENTO,"&_
			" b.fren_ncorr as TSOF_NRO_DOCUMENTO,"&_
			" protic.trunc(b.ocag_fingreso)as TSOF_FECHA_EMISION_CORTA,"&_
			" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA,"&_
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA,"&_
			" b.fren_ncorr AS TSOF_NRO_DOC_REFERENCIA,"&_
			" '' as TSOF_COD_CENTRO_COSTO,"&_
			" a.cod_pre as TSOF_COD_CONCEPTO_CAJA,"&_
			" 1 AS TSOF_NRO_AGRUPADOR,"&_
			" CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano,"&_
			" a.psol_mpresupuesto as TSOF_monto_presupuesto"&_
			" from ocag_presupuesto_solicitud a"&_
			" INNER JOIN ocag_fondos_a_rendir b ON a.cod_solicitud = b.fren_ncorr AND cod_solicitud ="&numer&" AND a.tsol_ccod = 3"&_
			" INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr"
		presupuestofondorendirtotal = texto
	end function
	
	function presupuestosolicitudviaticototal(numero)
		texto ="select '2-10-070-10-000004' as tsof_plan_cuenta,"& vbCrLf &_ 
			" psol_mpresupuesto as tsof_debe,"& vbCrLf &_ 
			" 0 as TSOF_HABER,"& vbCrLf &_ 
			" protic.extrae_acentos(LTRIM(RTRIM(b.sovi_tmotivo))) as TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_
			" c.pers_nrut as TSOF_COD_AUXILIAR,"& vbCrLf &_ 
			" 'TR' as TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" b.sovi_ncorr as TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
			" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_
			" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_ 
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_ 
			" b.sovi_ncorr AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_ 
			" null as TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			" a.cod_pre as TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_ 
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_
			" CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano,"& vbCrLf &_
			" a.psol_mpresupuesto as TSOF_monto_presupuesto "& vbCrLf &_
			" from ocag_presupuesto_solicitud  a "& vbCrLf &_
			" INNER JOIN ocag_solicitud_viatico b ON a.cod_solicitud = b.sovi_ncorr AND cod_solicitud ="&numero&" AND a.tsol_ccod = 4 "& vbCrLf &_
			" INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr  "& vbCrLf &_
			"  union "&_
			" select '2-10-070-10-000004' as tsof_plan_cuenta,"& vbCrLf &_ 
			" 0 as tsof_debe,"& vbCrLf &_ 
			" a.psol_mpresupuesto as TSOF_HABER,"& vbCrLf &_ 
			" protic.extrae_acentos(LTRIM(RTRIM(b.sovi_tmotivo))) as TSOF_GLOSA_SIN_ACENTO,"&_
			" c.pers_nrut as TSOF_COD_AUXILIAR,"& vbCrLf &_ 
			" 'BC' as TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" b.sovi_ncorr as TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
			" protic.trunc(b.ocag_fingreso)as TSOF_FECHA_EMISION_CORTA,"&_
			" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_ 
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_ 
			" b.sovi_ncorr AS TSOF_NRO_DOC_REFERENCIA,"&_
			" null as TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			" a.cod_pre as TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_ 
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf&_
			" CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano,"& vbCrLf&_
			" a.psol_mpresupuesto as TSOF_monto_presupuesto  "& vbCrLf&_
			" from ocag_presupuesto_solicitud a "& vbCrLf&_
			" INNER JOIN ocag_solicitud_viatico b ON a.cod_solicitud = b.sovi_ncorr AND cod_solicitud ="&numero&" AND a.tsol_ccod = 4 "& vbCrLf&_
			" INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr"
		presupuestosolicitudviaticototal = texto
	end function
	
	function presupuestodevolucionalumnototal(numero)
		texto =  "select 0 AS numero, '1-10-040-30-' + RTRIM(LTRIM(c.CCOS_TCODIGO)) as tsof_plan_cuenta,"& vbCrLf &_
			" dalu_mmonto_pesos as tsof_debe,"& vbCrLf &_
			" 0 as TSOF_HABER, "& vbCrLf &_
			" protic.extrae_acentos(RTRIM(LTRIM(c.CCOS_TDESC))) as TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_
			" a.pers_nrut_alu as TSOF_COD_AUXILIAR,"& vbCrLf &_
			" null as TSOF_TIPO_DOCUMENTO,"& vbCrLf &_
			" null as TSOF_NRO_DOCUMENTO,"& vbCrLf &_
			" null as TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_
			" null as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" null AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" null AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" null as TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" null as TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_
			" null AS TSOF_cod_mesano,"& vbCrLf &_
			" null as TSOF_monto_presupuesto "& vbCrLf &_
			"from ocag_devolucion_alumno a "& vbCrLf &_
			"INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and a.dalu_ncorr ="&numero&" "& vbCrLf &_
			"INNER JOIN CENTROS_COSTO c on a.ccos_ccod = c.CCOS_CCOD "& vbCrLf &_
			"union "& vbCrLf &_
			"select 0 AS numero, '1-10-040-30-' + LTRIM(c.CCOS_TCODIGO) as tsof_plan_cuenta,"& vbCrLf &_
			" 0 as tsof_debe,"& vbCrLf &_
			" dalu_mmonto_pesos as TSOF_HABER,"& vbCrLf &_
			" protic.extrae_acentos(RTRIM(LTRIM(c.CCOS_TDESC))) as TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_
			" a.pers_nrut_alu as TSOF_COD_AUXILIAR,"& vbCrLf &_
			" null as TSOF_TIPO_DOCUMENTO,"& vbCrLf &_
			" null as TSOF_NRO_DOCUMENTO,"& vbCrLf &_
			" null as TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_
			" null as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" null AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" null AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" null as TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" null as TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_
			" null AS TSOF_cod_mesano,"& vbCrLf &_
			" null as TSOF_monto_presupuesto"& vbCrLf &_
			" from ocag_devolucion_alumno a"& vbCrLf &_
			" INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and a.dalu_ncorr ="&numero&" "& vbCrLf &_
			" INNER JOIN CENTROS_COSTO c on a.ccos_ccod = c.CCOS_CCOD"
		presupuestodevolucionalumnototal = texto
	end function
	
	function presupuestofondofijototal(numero)
		texto =  " select 0 AS numero, '2-10-070-10-000004' as tsof_plan_cuenta,"& vbCrLf &_
			" 0 as tsof_debe,"& vbCrLf &_
			" a.psol_mpresupuesto as TSOF_HABER,"& vbCrLf &_
			" protic.extrae_acentos(LTRIM(RTRIM(b.ffij_tdetalle_presu))) as TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_
			" c.pers_nrut as TSOF_COD_AUXILIAR,"& vbCrLf &_
			" 'BC' as TSOF_TIPO_DOCUMENTO,"& vbCrLf &_
			" b.ffij_ncorr as TSOF_NRO_DOCUMENTO,"& vbCrLf &_
			" protic.trunc(b.ocag_fingreso)as TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_
			" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" b.ffij_ncorr AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" null as TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" a.cod_pre as TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_
			" CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano,"& vbCrLf &_
			" a.psol_mpresupuesto as TSOF_monto_presupuesto "& vbCrLf &_
			" FROM ocag_presupuesto_solicitud a "& vbCrLf &_
			" INNER JOIN ocag_fondo_fijo b "& vbCrLf &_
			" ON a.cod_solicitud = b.ffij_ncorr AND cod_solicitud ="&numero&" AND a.tsol_ccod = 6 "& vbCrLf &_
			" INNER JOIN personas c "& vbCrLf &_
			" ON b.pers_ncorr=c.pers_ncorr "& vbCrLf &_
			" UNION "& vbCrLf &_
			" select 0 AS numero, '2-10-070-10-000004' as tsof_plan_cuenta,"& vbCrLf &_
			" a.psol_mpresupuesto as tsof_debe,"& vbCrLf &_
			" 0 as TSOF_HABER,"& vbCrLf &_
			" protic.extrae_acentos(LTRIM(RTRIM(b.ffij_tdetalle_presu))) as TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_
			" c.pers_nrut as TSOF_COD_AUXILIAR,"& vbCrLf &_
			" 'TR' as TSOF_TIPO_DOCUMENTO,"& vbCrLf &_
			" b.ffij_ncorr as TSOF_NRO_DOCUMENTO,"& vbCrLf &_
			" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_
			" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" b.ffij_ncorr AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" null as TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" a.cod_pre as TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_
			" CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano,"& vbCrLf &_
			" a.psol_mpresupuesto as TSOF_monto_presupuesto "& vbCrLf &_
			" FROM ocag_presupuesto_solicitud a "& vbCrLf &_
			" INNER JOIN ocag_fondo_fijo b "& vbCrLf &_
			" ON a.cod_solicitud = b.ffij_ncorr AND cod_solicitud ="&numero&" AND a.tsol_ccod = 6 "& vbCrLf &_
			" INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr"
		presupuestofondofijototal = texto
	end function
	
	function presupuestorendicionfondorendirtotal(numero, diferencia)
		if diferencia>0 then
			codigopre = "2-10-070-10-000004"
		else
			if diferencia <0 then
				codigopre = "2-10-070-10-000003"
			end if
		end if
		texto ="select * from ("& vbCrLf &_
			"SELECT TOP 1 1 AS numero, '"&codigopre&"' AS TSOF_PLAN_CUENTA,"& vbCrLf &_
			" 0 AS TSOF_DEBE,"& vbCrLf &_
			" CASE WHEN b.tdoc_tdesc_softland='BE' THEN '"&diferencia&"' ELSE 0 END AS TSOF_HABER,"& vbCrLf &_
			" protic.extrae_acentos(RTRIM(LTRIM(c.tgas_tdesc))) AS TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_
			" z.cod_pre AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_
			" null AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_
			" null AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_
			" null AS TSOF_COD_CENTRO_COSTO,"&_
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_
			" replace(a.drfr_trut, right(a.drfr_trut,2),'') AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			" 'BC' AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_
			" a.rfre_ncorr AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_
			" CONVERT(VARCHAR(32),protic.trunc(a.drfr_fdocto)) AS TSOF_FECHA_EMISION_CORTA,"&_
			" CONVERT(VARCHAR(32),protic.trunc(a.drfr_fdocto)) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" a.rfre_ncorr AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" null AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO1,"&_
			" null AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_
			" NULL AS TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_
			" null AS TSOF_NRO_DOCUMENTO_DESDE,"&_
			" null AS TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_
			" null AS TSOF_bullshet1,"& vbCrLf &_
			" null AS TSOF_bullshet2,"& vbCrLf &_
			" '"&diferencia&"' AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_
			" CASE WHEN MONTH(w.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(w.ocag_fingreso) AS VARCHAR) + CAST(YEAR(w.ocag_fingreso) AS VARCHAR) AS TSOF_COD_MESANO "&_
			" FROM ocag_detalle_rendicion_fondo_rendir a INNER JOIN ocag_tipo_documento b ON a.tdoc_ccod=b.tdoc_ccod "&_
			" INNER JOIN ocag_presupuesto_solicitud z ON a.fren_ncorr = z.cod_solicitud "&_
			" INNER JOIN ocag_tipo_gasto c ON a.tgas_ccod=c.tgas_ccod INNER JOIN ocag_rendicion_fondos_a_rendir w ON w.fren_ncorr = z.cod_solicitud WHERE a.fren_ncorr="&numeros&" AND b.tdoc_tdesc_softland='BE'"& vbCrLf &_
			" UNION "&_
			" SELECT TOP 1 1 AS numero, '"&codigopre&"' AS TSOF_PLAN_CUENTA,"& vbCrLf &_
			" CASE WHEN b.tdoc_tdesc_softland='BE' THEN '"&diferencia&"' ELSE 0 END AS TSOF_DEBE,"& vbCrLf &_
			" 0 AS TSOF_HABER,"& vbCrLf &_
			" protic.extrae_acentos(RTRIM(LTRIM(c.tgas_tdesc))) AS TSOF_GLOSA_SIN_ACENTO,"&_
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_
			" null AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_
			" null AS TSOF_HABER_ADICIONAL,"& vbCrLf &_
			" null AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_
			" null AS TSOF_COD_VENDEDOR,"& vbCrLf &_
			" null AS TSOF_COD_UBICACION,"& vbCrLf &_
			" z.cod_pre AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_
			" null AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_
			" null AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_
			" null AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_
			" null AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_
			" null AS TSOF_COD_CENTRO_COSTO,"&_
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_
			" replace(a.drfr_trut, right(a.drfr_trut,2),'') AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			" 'TR' AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_
			" a.rfre_ncorr AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_
			" CONVERT(VARCHAR(32),protic.trunc(a.drfr_fdocto)) AS TSOF_FECHA_EMISION_CORTA,"&_
			" CONVERT(VARCHAR(32),protic.trunc(a.drfr_fdocto)) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" a.rfre_ncorr AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" null AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO1,"&_
			" null AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_
			" null AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_
			" NULL AS TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_
			" null AS TSOF_NRO_DOCUMENTO_DESDE,"&_
			" null AS TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_
			" null AS TSOF_bullshet1,"& vbCrLf &_
			" null  AS TSOF_bullshet2,'"&diferencia&"' AS TSOF_MONTO_PRESUPUESTO,CASE WHEN MONTH(w.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(w.ocag_fingreso) AS VARCHAR) + CAST(YEAR(w.ocag_fingreso) AS VARCHAR) AS TSOF_COD_MESANO "&_
			" FROM ocag_detalle_rendicion_fondo_rendir a INNER JOIN ocag_tipo_documento b ON a.tdoc_ccod=b.tdoc_ccod "&_
			" INNER JOIN ocag_presupuesto_solicitud z ON a.fren_ncorr = z.cod_solicitud "&_
			" INNER JOIN ocag_tipo_gasto c ON a.tgas_ccod=c.tgas_ccod INNER JOIN ocag_rendicion_fondos_a_rendir w ON w.fren_ncorr = z.cod_solicitud WHERE a.fren_ncorr="&numeros&" AND b.tdoc_tdesc_softland='BE' "& vbCrLf &_
			" UNION "&_
			" SELECT TOP 1 2 AS numero, '2-10-070-10-000003' AS TSOF_PLAN_CUENTA, "&_
			" e.fren_mmonto-d.rfre_mmonto AS TSOF_DEBE,"& vbCrLf &_
			" 0 AS TSOF_HABER, "&_
			" protic.extrae_acentos(RTRIM(LTRIM(c.tgas_tdesc))) AS TSOF_GLOSA_SIN_ACENTO,"&_
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_
			" '' AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_
			" '' AS TSOF_HABER_ADICIONAL,"& vbCrLf &_
			" '' AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_
			" '' AS TSOF_COD_VENDEDOR,"& vbCrLf &_
			" '' AS TSOF_COD_UBICACION,"& vbCrLf &_
			" z.cod_pre AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_
			" '' AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_
			" '' AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_
			" '' AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_
			" '' AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_
			" '' AS TSOF_COD_CENTRO_COSTO,"&_
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_
			" '' AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_
			" replace(a.drfr_trut, right(a.drfr_trut,2),'') AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			" 'TR' AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_
			" a.rfre_ncorr AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_
			" CONVERT(VARCHAR(32),protic.trunc(a.drfr_fdocto)) AS TSOF_FECHA_EMISION_CORTA,"&_
			" CONVERT(VARCHAR(32),protic.trunc(a.drfr_fdocto)) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" a.rfre_ncorr AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" '' AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO1,"&_
			" null AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_
			" NULL AS TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_
			" '' AS TSOF_NRO_DOCUMENTO_DESDE,"&_
			" null AS TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_
			" '' AS TSOF_bullshet1,"& vbCrLf &_
			" ''  AS TSOF_bullshet2,"& vbCrLf &_
			" NULL AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_
			" NULL AS TSOF_COD_MESANO "&_
			" FROM ocag_detalle_rendicion_fondo_rendir a INNER JOIN ocag_tipo_documento b ON a.tdoc_ccod=b.tdoc_ccod "&_
			" INNER JOIN ocag_tipo_gasto c ON a.tgas_ccod=c.tgas_ccod "&_
			" INNER JOIN ocag_rendicion_fondos_a_rendir d ON a.rfre_ncorr=d.rfre_ncorr "&_
			" INNER JOIN ocag_fondos_a_rendir e ON e.fren_ncorr=d.fren_ncorr "&_
			" INNER JOIN ocag_presupuesto_solicitud z ON a.fren_ncorr = z.cod_solicitud "&_
			" WHERE d.fren_ncorr="&numero&" AND (b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH') AND ((SELECT a.fren_mmonto FROM ocag_fondos_a_rendir a  WHERE a.fren_ncorr="&numeros&")-(SELECT a.rfre_mmonto FROM ocag_rendicion_fondos_a_rendir a  WHERE a.fren_ncorr="&numeros&"))<>0"& vbCrLf &_
			" UNION "&_
			" SELECT TOP 1 2 AS numero, '2-10-070-10-000003' AS TSOF_PLAN_CUENTA, "&_
			" 0 AS TSOF_DEBE,"& vbCrLf &_
			" e.fren_mmonto-d.rfre_mmonto AS TSOF_HABER, "&_
			" protic.extrae_acentos(RTRIM(LTRIM(c.tgas_tdesc))) AS TSOF_GLOSA_SIN_ACENTO,"&_
			" null AS TSOF_EQUIVALENCIA,"& vbCrLf &_
			" '' AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_
			" '' AS TSOF_HABER_ADICIONAL,"& vbCrLf &_
			" '' AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_
			" '' AS TSOF_COD_VENDEDOR,"& vbCrLf &_
			" '' AS TSOF_COD_UBICACION,"& vbCrLf &_
			" z.cod_pre AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_
			" '' AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_
			" '' AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_
			" '' AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_
			" '' AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_
			" '' AS TSOF_COD_CENTRO_COSTO,"&_
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_
			" '' AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_
			" replace(a.drfr_trut, right(a.drfr_trut,2),'') AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			" 'BC' AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_
			" a.rfre_ncorr AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_
			" CONVERT(VARCHAR(32),"& vbCrLf &_
			" protic.trunc(a.drfr_fdocto)) AS TSOF_FECHA_EMISION_CORTA,"&_
			" CONVERT(VARCHAR(32),protic.trunc(a.drfr_fdocto)) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" a.rfre_ncorr AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" '' AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO1,"&_
			" null AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_
			" NULL AS TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_
			" '' AS TSOF_NRO_DOCUMENTO_DESDE,"&_
			" null AS TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_
			" '' AS TSOF_bullshet1,"& vbCrLf &_
			" ''  AS TSOF_bullshet2,"& vbCrLf &_
			" NULL AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_
			" NULL AS TSOF_COD_MESANO "&_
			" FROM ocag_detalle_rendicion_fondo_rendir a INNER JOIN ocag_tipo_documento b ON a.tdoc_ccod=b.tdoc_ccod "&_
			" INNER JOIN ocag_tipo_gasto c ON a.tgas_ccod=c.tgas_ccod "&_
			" INNER JOIN ocag_rendicion_fondos_a_rendir d ON a.rfre_ncorr=d.rfre_ncorr "&_
			" INNER JOIN ocag_fondos_a_rendir e ON e.fren_ncorr=d.fren_ncorr "&_
			" INNER JOIN ocag_presupuesto_solicitud z ON a.fren_ncorr = z.cod_solicitud "&_
			" WHERE d.fren_ncorr="&numero&" AND (b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH') AND (e.fren_mmonto-d.rfre_mmonto<>0)"&_
			" ) AS tabla ORDER BY numero ASC"
		presupuestorendicionfondorendirtotal = texto
	end function
	
	function presupuestorendicionfondofijototal(numero)
		texto ="select TOP 1 '2-10-070-10-000004' as tsof_plan_cuenta,"& vbCrLf &_
			" CONVERT(INT, ROUND((SELECT SUM(CASE WHEN tdoc_ccod = 11 THEN odff.drff_mdocto*0.9 ELSE odff.drff_mdocto END) FROM ocag_detalle_rendicion_fondo_fijo odff WHERE rffi_ncorr="&numer&"),0)) as tsof_debe,"& vbCrLf &_
			" 0 as TSOF_HABER,"& vbCrLf &_
			" protic.extrae_acentos(LTRIM(RTRIM(d.drff_tdesc))) as TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_
			" c.pers_nrut as TSOF_COD_AUXILIAR,"& vbCrLf &_
			" 'TR' as TSOF_TIPO_DOCUMENTO,"& vbCrLf &_
			" b.ffij_ncorr as TSOF_NRO_DOCUMENTO,"& vbCrLf &_
			" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_
			" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" b.ffij_ncorr AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" '' as TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" a.cod_pre as TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_
			" NULL AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_
			" NULL AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_
			" NULL AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_
			" NULL AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_
			" NULL as TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_
			" CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano,"& vbCrLf &_
			" CONVERT(INT, ROUND((SELECT SUM(CASE WHEN tdoc_ccod = 11 THEN odff.drff_mdocto*0.9 ELSE odff.drff_mdocto END) FROM ocag_detalle_rendicion_fondo_fijo odff WHERE rffi_ncorr="&numer&"),0)) as TSOF_monto_presupuesto"& vbCrLf &_
			" FROM ocag_presupuesto_solicitud a"& vbCrLf &_
			" INNER JOIN ocag_fondo_fijo b ON a.cod_solicitud = b.ffij_ncorr AND a.tsol_ccod = 6"& vbCrLf &_
			" INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr"& vbCrLf &_
			"INNER JOIN ocag_detalle_rendicion_fondo_fijo d ON d.ffij_ncorr=b.ffij_ncorr AND d.rffi_ncorr="&numer & vbCrLf&_
			" UNION"& vbCrLf &_
			" select TOP 1 '2-10-070-10-000004' as tsof_plan_cuenta,"& vbCrLf &_
			" 0 as tsof_debe,"& vbCrLf &_
			" CONVERT(INT, ROUND((SELECT SUM(CASE WHEN tdoc_ccod = 11 THEN odff.drff_mdocto*0.9 ELSE odff.drff_mdocto END) FROM ocag_detalle_rendicion_fondo_fijo odff WHERE rffi_ncorr="&numer&"),0)) as TSOF_HABER,"& vbCrLf &_
			" protic.extrae_acentos(LTRIM(RTRIM(d.drff_tdesc))) as TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_
			" c.pers_nrut as TSOF_COD_AUXILIAR,"& vbCrLf &_
			" 'BC' as TSOF_TIPO_DOCUMENTO,"& vbCrLf &_
			" b.ffij_ncorr as TSOF_NRO_DOCUMENTO,"& vbCrLf &_
			" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_
			" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" b.ffij_ncorr AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" '' as TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" a.cod_pre as TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_
			" 1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_
			" NULL AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_
			" NULL AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_
			" NULL AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_
			" NULL AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_
			" '' AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_
			" NULL as TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_
			" CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano,"& vbCrLf &_
			" CONVERT(INT, ROUND((SELECT SUM(CASE WHEN tdoc_ccod = 11 THEN odff.drff_mdocto*0.9 ELSE odff.drff_mdocto END) FROM ocag_detalle_rendicion_fondo_fijo odff WHERE rffi_ncorr="&numer&"),0)) as TSOF_monto_presupuesto"& vbCrLf &_
			" FROM ocag_presupuesto_solicitud a"& vbCrLf &_
			" INNER JOIN ocag_fondo_fijo b ON a.cod_solicitud = b.ffij_ncorr AND a.tsol_ccod = 6"& vbCrLf &_
			" INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr"& vbCrLf &_
			" INNER JOIN ocag_detalle_rendicion_fondo_fijo d ON d.ffij_ncorr=b.ffij_ncorr AND d.rffi_ncorr="&numero
		presupuestorendicionfondofijototal = texto
	end function
	
	function obtener(codigo, registro)
		'---------- CONEXION A SOFTLAND ----------'
		set conectar = new Cconexion2
		conectar.Inicializar "upacifico"
	
		'---------- CREAR FORMULARIO ----------'
		set grilla = new CFormulario
		grilla.Carga_Parametros "tabla_vacia.xml", "tabla"
		grilla.Inicializar conectar
	
		'---------- CONSULTAR A SOFTLAND ----------'
		sql_softland = "SELECT TOP 1 pccodi,pcnivel,pclnivel,pcdesc,pctipo,pcccos,pcauxi,pccdoc,pcedoc,pcconb,pcmone,pcdetg,pcprec,pceprc,pcifin,pccomon,"& vbCrLf&_
		"pctpcm,pccapp,pcacti,pccmon,pccodc,pcdinba,pccmcp,pcidma,pccbadici,pcajustedifc,pcfijamonbase,pcafeefe,pcconefe,pcefesvs FROM softland.cwpctas "& vbCrLf&_
		"WHERE pccodi LIKE '%" & codigo & "%'"
		grilla.Consultar sql_softland
		
		'---------- LOGICA ----------'
		
		while grilla.siguiente
			pccodi=grilla.obtenerValor("pccodi")
			pcdesc=grilla.obtenerValor("pcdesc")
			pctipo=grilla.obtenerValor("pctipo")
			pcccos=grilla.obtenerValor("pcccos")
			pcauxi=grilla.obtenerValor("pcauxi")
			pccdoc=grilla.obtenerValor("pccdoc")
			pcedoc=grilla.obtenerValor("pcedoc")
			pcconb=grilla.obtenerValor("pcconb")
			pcmone=grilla.obtenerValor("pcmone")
			pcdetg=grilla.obtenerValor("pcdetg")
			pcprec=grilla.obtenerValor("pcprec")
			pceprc=grilla.obtenerValor("pceprc")
			pcifin=grilla.obtenerValor("pcifin")
			pccomon=grilla.obtenerValor("pccomon")
			pctpcm=grilla.obtenerValor("pctpcm")
			pccapp=grilla.obtenerValor("pccapp")
			pcacti=grilla.obtenerValor("pcacti")
			pccmon=grilla.obtenerValor("pccmon")
			pccodc=grilla.obtenerValor("pccodc")
			pcdinba=grilla.obtenerValor("pcdinba")
			pccmcp=grilla.obtenerValor("pccmcp")
			pcidma=grilla.obtenerValor("pcidma")
			pccbadici=grilla.obtenerValor("pccbadici")
			pcajustedifc=grilla.obtenerValor("pcajustedifc")
			pcfijamonbase=grilla.obtenerValor("pcfijamonbase")
			pcafeefe=grilla.obtenerValor("pcafeefe")
			pcconefe=grilla.obtenerValor("pcconefe")
			pcefesvs=grilla.obtenerValor("pcefesvs")
		wend
		if pctipo="S" AND registro="pctipo" then
			estado=true
		else
			if pcccos="S" AND registro="pcccos" then 
				estado=true
			else
				if pcauxi="S" AND registro="pcauxi" then 
					estado=true
				else
					if pccdoc="S" AND registro="pccdoc" then 
						estado=true
					else
						if pcedoc="S" AND registro="pcedoc" then 
							estado=true
						else
							if pcconb="S" AND registro="pcconb" then 
								estado=true
							else
								if pcmone="S" AND registro="pcmone" then 
									estado=true
								else
									if pcdetg="S" AND registro="pcdetg" then 
										estado=true
									else
										if pcprec="S" AND registro="pcprec" then 
											estado=true
										else
											if pceprc="S" AND registro="pceprc" then 
												estado=true
											else
												if pcifin="S" AND registro="pcifin" then 
													estado=true
												else
													if pccomon="S" AND registro="pccomon" then 
														estado=true
													else
														if pctpcm="S" AND registro="pctpcm" then 
															estado=true
														else
															if pccapp="S" AND registro="pccapp" then 
																estado=true
															else
																if pcacti="S" AND registro="pcacti" then 
																	estado=true
																else
																	if pccmon="S" AND registro="pccmon" then 
																		estado=true
																	else
																		if pccodc="S" AND registro="pccodc" then 
																			estado=true
																		else
																			if pcdinba="S" AND registro="pcdinba" then 
																				estado=true
																			else
																				if pccmcp="S" AND registro="pccmcp" then 
																					estado=true
																				else
																					if pcidma="S" AND registro="pcidma" then 
																						estado=true
																					else
																						if pccbadici="S" AND registro="pccbadici" then 
																							estado=true
																						else
																							if pcajustedifc="S" AND registro="pcajustedifc" then 
																								estado=true
																							else	
																								if pcfijamonbase="S" AND registro="pcfijamonbase" then 
																									estado=true
																								else
																									if pcafeefe="S" AND registro="pcafeefe" then 
																										estado=true	
																									else
																										if pcconefe="S" AND registro="pcconefe" then 
																											estado=true
																										else
																											if pcefesvs="S" AND registro="pcefesvs" then 
																												estado=true
																											else
																												estado=false
																											end if
																										end if
																									end if
																								end if
																							end if
																						end if
																					end if
																				end if
																			end if
																		end if
																	end if
																end if
															end if
														end if
													end if
												end if
											end if
										end if
									end if
								end if
							end if
						end if
					end if
				end if
			end if
		end if
		obtener=estado
	end function
%>

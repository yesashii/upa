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
				texto = texto & costosolicitudviatico(numero) & vbCrLf
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
				texto = texto & presupuestofondorendir(numero) & vbCrLf
			case 4:
				texto = texto & presupuestosolicitudviaticototal(numero) & vbCrLf
			case 5:
				texto = texto & presupuestodevolucionalumnototal(numero) & vbCrLf
			case 6:
				texto = texto & presupuestofondofijototal(numero) & vbCrLf
			case 7:
				texto = texto & presupuestorendicionfondorendir(numero) & vbCrLf
			case 8:
				texto = texto & presupuestorendicionfondofijo(numero) & vbCrLf
		end select
		texto = texto & ") AS tabla ORDER BY TSOF_NRO_DOC_REFERENCIA ASC, TSOF_TIPO_DOC_REFERENCIA DESC, TSOF_COD_CENTRO_COSTO DESC, TSOF_HABER DESC, TSOF_DEBE DESC"
		generadorpresupuesto=texto
	end function
	
	function generadorpresupuestototal(tipo_solicitud, numero)
		texto = "SELECT * FROM (" & vbCrLf
		select case tipo_solicitud
			case 1:
				texto = texto & presupuestopagoproveedortotal(numero) & vbCrLf
			case 2:
				texto = texto & presupuestoreembolsototal(numero) & vbCrLf
			case 3:
				texto = texto & presupuestofondorendir(numero) & vbCrLf
			case 4:
				texto = texto & presupuestosolicitudviaticototal(numero) & vbCrLf
			case 5:
				texto = texto & presupuestodevolucionalumnototal(numero) & vbCrLf
			case 6:
				texto = texto & presupuestofondofijototal(numero) & vbCrLf
			case 7:
				texto = texto & presupuestorendicionfondorendirtotal(numero) & vbCrLf
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
	
	function presupuestopagoproveedor(numero)
		texto = "select '2-10-070-10-000002' as tsof_plan_cuenta,"& vbCrLf &_
			" CASE WHEN f.tdoc_ref_ccod IS NOT NULL AND f.tdoc_ref_ccod = d.tdoc_ccod THEN ABS(d.dsgi_mdocto)-ABS(f.dsgi_mdocto) ELSE ABS(d.dsgi_mdocto) END as tsof_debe,"& vbCrLf &_
			" 0 as TSOF_HABER,"& vbCrLf &_
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
			" NULL AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_ 
			" CONVERT(VARCHAR(20),c.PERS_NRUT) +'-'+c.PERS_XDV AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			" LTRIM(RTRIM('bc')) AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" CAST(a.sogi_ncorr AS VARCHAR) AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
			" protic.trunc(a.sogi_fecha_solicitud) AS TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_
			" protic.ocag_retorna_fecha_normal(GETDATE(),1) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" otd.tdoc_tdesc_softland as TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" d.dsgi_ndocto as TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
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
			"	b.sogi_bboleta_honorario AS boleta,"& vbCrLf &_
			"	0 AS rete"& vbCrLf &_
			"	from ocag_presupuesto_solicitud a"& vbCrLf &_
			"		INNER JOIN ocag_solicitud_giro b ON a.cod_solicitud = b.sogi_ncorr AND cod_solicitud = "& numero &" AND a.tsol_ccod = 1"& vbCrLf &_
			"		INNER JOIN ocag_presupuesto_solicitud e ON e.cod_solicitud=b.sogi_ncorr"& vbCrLf &_
			"		INNER JOIN ocag_detalle_solicitud_giro d ON b.sogi_ncorr = d.sogi_ncorr"& vbCrLf &_
			"		INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr"& vbCrLf &_
			"		INNER JOIN ocag_tipo_documento otd ON otd.tdoc_ccod=d.tdoc_ccod"& vbCrLf &_
			"		LEFT JOIN ocag_detalle_solicitud_giro f ON f.sogi_ncorr=b.sogi_ncorr AND f.tdoc_ref_ccod = d.tdoc_ccod"& vbCrLf &_
			"union  "& vbCrLf &_
			"select '2-10-070-10-000002' as tsof_plan_cuenta,"& vbCrLf &_
			"   0 as tsof_debe,"& vbCrLf &_
			"   CASE WHEN f.tdoc_ref_ccod IS NULL THEN ABS(d.dsgi_mdocto) ELSE NULL END as TSOF_HABER,"& vbCrLf &_
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
			" null AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" null AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_ 
			" null AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_
			" CONVERT(VARCHAR(20),c.PERS_NRUT) +'-'+c.PERS_XDV AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			" LTRIM(RTRIM('bc')) AS TSOF_TIPO_DOCUMENTO,"& vbCrLf &_ 
			" CAST(a.sogi_ncorr AS VARCHAR) AS TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
			" protic.trunc(a.sogi_fecha_solicitud) AS TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_
			"	protic.ocag_retorna_fecha_normal(GETDATE(),1) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			"   otd.tdoc_tdesc_softland as TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			"   d.dsgi_ndocto as TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
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
			"	b.sogi_bboleta_honorario AS boleta,"& vbCrLf &_
			"	0 AS rete"& vbCrLf &_
			"	from ocag_presupuesto_solicitud a"& vbCrLf &_
			"		INNER JOIN ocag_solicitud_giro b ON a.cod_solicitud = b.sogi_ncorr AND cod_solicitud = "& numero &" AND a.tsol_ccod = 1" & vbCrLf &_
			"		INNER JOIN ocag_presupuesto_solicitud e ON e.cod_solicitud=b.sogi_ncorr"& vbCrLf &_
			"		INNER JOIN ocag_detalle_solicitud_giro d ON b.sogi_ncorr = d.sogi_ncorr"& vbCrLf &_
			"		INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr"& vbCrLf &_
			"		INNER JOIN ocag_tipo_documento otd ON otd.tdoc_ccod=d.tdoc_ccod"& vbCrLf &_
			"		LEFT JOIN ocag_detalle_solicitud_giro f ON f.sogi_ncorr=b.sogi_ncorr AND f.tdoc_ref_ccod=NULL"& vbCrLf &_
			"	WHERE d.tdoc_ccod <> 7"
		presupuestopagoproveedor = texto
	end function
	
	function codigoverificar(cod, estado, solicitud,bolet)
		'---------- CONEXION A SOFTLAND ----------'
		set conectar = new Cconexion
		conectar.Inicializar "upacifico"
	
		'---------- CREAR FORMULARIO ----------'
		set grilla = new CFormulario
		grilla.Carga_Parametros "tabla_vacia.xml", "tabla"
		grilla.Inicializar conectar
	
		'---------- CONSULTAR A SOFTLAND ----------'
		select case solicitud
			case 1:
				sql_softland = "SELECT DISTINCT c.tgas_cod_cuenta AS valor "& vbCrLf &_
					" FROM ocag_detalle_solicitud_ag a"& vbCrLf &_
					" INNER JOIN ocag_presupuesto_solicitud b"& vbCrLf &_
					" ON b.cod_solicitud =a.sogi_ncorr"& vbCrLf &_
					" INNER JOIN ocag_tipo_gasto c ON a.tgas_ccod=c.tgas_ccod"& vbCrLf &_
					" WHERE b.tsol_ccod=1 AND sogi_ncorr = "&cod & vbCrLf 
			case 2:
				sql_softland = "SELECT c.tgas_cod_cuenta AS valor FROM ocag_reembolso_gastos a"& vbCrLf &_
					" INNER JOIN ocag_detalle_reembolso_gasto b"& vbCrLf &_
					" ON a.rgas_ncorr=b.rgas_ncorr"& vbCrLf &_
					" INNER JOIN ocag_tipo_gasto c"& vbCrLf &_
					" ON b.tgas_ccod = c.tgas_ccod"& vbCrLf &_
					" WHERE a.rgas_ncorr="&cod& vbCrLf 
			case 3:
				sql_softland = "SELECT DISTINCT c.tgas_cod_cuenta AS valor FROM ocag_fondos_a_rendir a"& vbCrLf &_
					 " INNER JOIN ocag_presupuesto_solicitud b"& vbCrLf &_
					 " ON b.cod_solicitud =a.fren_ncorr"& vbCrLf &_
					 " INNER JOIN ocag_tipo_gasto c"& vbCrLf &_
					 " ON tgas_tdesc LIKE '%FONDO A RENDIR%'"& vbCrLf &_
					 " WHERE b.tsol_ccod=3 AND fren_ncorr ="& vbCrLf &cod
			case 4: 
				sql_softland = "SELECT c.tgas_cod_cuenta AS valor FROM ocag_solicitud_viatico a"& vbCrLf &_
					" INNER JOIN ocag_presupuesto_solicitud b"& vbCrLf &_
					" ON b.cod_solicitud =a.sovi_ncorr"& vbCrLf &_
					" INNER JOIN ocag_tipo_gasto c"&_
					" ON tgas_tdesc LIKE '%Viaticos %'"& vbCrLf &_
					" WHERE b.tsol_ccod=4 AND sovi_ncorr = "&cod & vbCrLf 
			case 5:
				sql_softland = "SELECT DISTINCT c.tgas_cod_cuenta AS valor FROM ocag_devolucion_alumno a"& vbCrLf &_
					" INNER JOIN ocag_presupuesto_solicitud b"& vbCrLf &_
					" ON b.cod_solicitud =a.dalu_ncorr"& vbCrLf &_
					" INNER JOIN ocag_tipo_gasto c"& vbCrLf &_
					" ON c.tgas_tdesc LIKE '%Devoluciones a Alumnos%'"& vbCrLf &_
					" WHERE a.tsol_ccod=5 AND a.dalu_ncorr = "& vbCrLf &cod
			case 6:
				sql_softland = "SELECT '1-10-010-20-000003' AS valor"
			case 7:
				sql_softland = "SELECT c.tgas_cod_cuenta AS valor FROM ocag_fondo_fijo a"& vbCrLf &_
					" INNER JOIN ocag_detalle_rendicion_fondo_rendir b"& vbCrLf &_
					" ON a.ffij_ncorr=b.rfre_ncorr"& vbCrLf &_
					" INNER JOIN ocag_tipo_gasto c"& vbCrLf &_
					" ON b.tgas_ccod = c.tgas_ccod"& vbCrLf &_
					" WHERE a.ffij_ncorr="&cod & vbCrLf 
			case 8:
				sql_softland = "SELECT c.tgas_cod_cuenta AS valor FROM ocag_rendicion_fondo_fijo a" & vbCrLf &_
					" INNER JOIN ocag_detalle_rendicion_fondo_fijo b" & vbCrLf &_
					" ON a.rffi_ncorr=b.rffi_ncorr" & vbCrLf &_
					" INNER JOIN ocag_tipo_gasto c" & vbCrLf &_
					" ON b.tgas_ccod = c.tgas_ccod" & vbCrLf &_
					" WHERE a.rffi_ncorr ="&cod & vbCrLf 
		end select
		'response.write sql_softland
		grilla.Consultar sql_softland
		ordc=es_orden_compra(cod,solicitud)
		valor = ""
		response.write ordc
		if ordc then
			grilla.siguiente
			valor = "select CASE WHEN a.cpag_ccod = 25 THEN '1-10-010-30-100001' ELSE '2-10-070-10-000002' END as tsof_plan_cuenta,"& vbCrLf &_
						" 0 as tsof_debe "&_
						" , a.sogi_mgiro as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO "&_
						" , CAST(b.pers_nrut AS VARCHAR) as TSOF_COD_AUXILIAR, LTRIM(RTRIM('bc')) as TSOF_TIPO_DOCUMENTO "&_
						" , CAST(a.sogi_ncorr AS VARCHAR) as TSOF_NRO_DOCUMENTO, protic.trunc(a.sogi_fecha_solicitud) as TSOF_FECHA_EMISION_CORTA "&_
						" , protic.trunc(d.dpva_fpago) as TSOF_FECHA_VENCIMIENTO_CORTA, LTRIM(RTRIM('bc')) AS TSOF_TIPO_DOC_REFERENCIA "&_
						" , CAST(a.sogi_ncorr AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA"&_
						" , NULL AS TSOF_NRO_CORRELATIVO"&_
						" , NULL AS TSOF_MONTO_DET_LIBRO1 "&_
						" , NULL AS TSOF_MONTO_DET_LIBRO2"&_
						" , NULL AS TSOF_MONTO_DET_LIBRO3"&_
						" , NULL AS TSOF_MONTO_SUMA_DET_LIBRO, NULL as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR "&_
						" from ocag_solicitud_giro a "&_
						" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr="&cod&" "&_
						" INNER JOIN ocag_validacion_contable c ON a.sogi_ncorr=c.cod_solicitud AND isnull(c.tsol_ccod,1)=1 "&_
						" INNER JOIN ocag_detalle_pago_validacion d ON c.vcon_ncorr = d.vcon_ncorr "& vbCrLf &_
						" UNION "& vbCrLf &_
						" select CASE WHEN a.cpag_ccod = 25 THEN '1-10-010-30-100001' ELSE '2-10-070-10-000002' END as tsof_plan_cuenta "&_
						" , c.dsgi_mdocto as tsof_debe "&_
						" , 0 as TSOF_HABER  "&_
						" , protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO, CAST(b.pers_nrut AS VARCHAR) as TSOF_COD_AUXILIAR "&_
						" , LTRIM(RTRIM('TR')) as TSOF_TIPO_DOCUMENTO, CAST(c.dsgi_ndocto AS VARCHAR) as TSOF_NRO_DOCUMENTO "&_
						" , protic.trunc(c.dogi_fecha_documento) as TSOF_FECHA_EMISION_CORTA, protic.trunc(f.dpva_fpago) as TSOF_FECHA_VENCIMIENTO_CORTA "&_
						" , LTRIM(RTRIM(d.tdoc_tdesc_softland)) AS TSOF_TIPO_DOC_REFERENCIA, CAST(c.dsgi_ndocto AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA "&_
						" , NULL AS TSOF_NRO_CORRELATIVO"&_
						" , CASE WHEN c.dsgi_mhonorarios IS NULL THEN c.dsgi_mexento ELSE c.dsgi_mhonorarios END AS TSOF_MONTO_DET_LIBRO1 "&_
						" , CASE WHEN c.dsgi_mhonorarios IS NULL  THEN CONVERT(INT,ROUND(c.dsgi_mdocto/1.19,0)) ELSE c.dsgi_mretencion END AS TSOF_MONTO_DET_LIBRO2 "&_
						" , CASE WHEN c.dsgi_mhonorarios IS NULL  THEN c.dsgi_miva ELSE NULL END AS TSOF_MONTO_DET_LIBRO3"&_
						" , c.dsgi_mdocto as TSOF_MONTO_SUMA_DET_LIBRO "&_
						" , NULL as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR "&_
						" from ocag_solicitud_giro a "&_
						" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.ordc_ncorr ="&grilla4.obtenerValor("orden")&" AND a.sogi_ncorr ="&cod&" "&_
						" INNER JOIN ocag_detalle_solicitud_giro c ON a.sogi_ncorr=c.sogi_ncorr "&_
						" INNER JOIN ocag_tipo_documento d ON c.tdoc_ccod=d.tdoc_ccod "&_
						" INNER JOIN ocag_validacion_contable e ON a.sogi_ncorr=e.cod_solicitud AND isnull(e.tsol_ccod,1)=1 "&_
						" INNER JOIN ocag_detalle_pago_validacion f ON e.vcon_ncorr = f.vcon_ncorr "& vbCrLf &_
						" UNION "& vbCrLf &_
						" select CASE WHEN a.cpag_ccod = 25 THEN '1-10-010-30-100001' ELSE '2-10-070-10-000002' END as tsof_plan_cuenta "&_
						" , 0 as tsof_debe "&_
						" , c.dsgi_mdocto as TSOF_HABER "&_
						" , protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO, CAST(b.pers_nrut AS VARCHAR) as TSOF_COD_AUXILIAR "&_
						" , LTRIM(RTRIM(d.tdoc_tdesc_softland)) as TSOF_TIPO_DOCUMENTO, CAST(c.dsgi_ndocto AS VARCHAR) as TSOF_NRO_DOCUMENTO  "&_
						" , protic.trunc(c.dogi_fecha_documento) as TSOF_FECHA_EMISION_CORTA, protic.trunc(f.dpva_fpago) as TSOF_FECHA_VENCIMIENTO_CORTA "&_
						" , LTRIM(RTRIM(d.tdoc_tdesc_softland)) AS TSOF_TIPO_DOC_REFERENCIA, CAST(c.dsgi_ndocto AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA "&_
						" , "&numeross()&" AS TSOF_NRO_CORRELATIVO"&_
						" , CASE WHEN c.dsgi_mhonorarios IS NULL THEN c.dsgi_mexento ELSE c.dsgi_mhonorarios END AS TSOF_MONTO_DET_LIBRO1 "&_
						" , CASE WHEN c.dsgi_mhonorarios IS NULL  THEN CONVERT(INT,ROUND(c.dsgi_mdocto/1.19,0)) ELSE c.dsgi_mretencion END AS TSOF_MONTO_DET_LIBRO2 "&_
						" , CASE WHEN c.dsgi_mhonorarios IS NULL  THEN c.dsgi_miva ELSE NULL END AS TSOF_MONTO_DET_LIBRO3"&_
						" , c.dsgi_mdocto as TSOF_MONTO_SUMA_DET_LIBRO "&_
						" , NULL as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR "&_
						" from ocag_solicitud_giro a "&_
						" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.ordc_ncorr ='"&grilla4.obtenerValor("orden")&"' AND a.sogi_ncorr ="&cod&" "&_
						" INNER JOIN ocag_detalle_solicitud_giro c ON a.sogi_ncorr=c.sogi_ncorr "&_
						" INNER JOIN ocag_tipo_documento d ON c.tdoc_ccod=d.tdoc_ccod "&_
						" INNER JOIN ocag_validacion_contable e ON a.sogi_ncorr=e.cod_solicitud AND isnull(e.tsol_ccod,1)=1 "&_
						" INNER JOIN ocag_detalle_pago_validacion f ON e.vcon_ncorr = f.vcon_ncorr "& vbCrLf &_
						" UNION "& vbCrLf &_
						" select d.tgas_cod_cuenta as tsof_plan_cuenta, CONVERT(INT,ROUND(c.dorc_nprecio_neto*1.19,0)) as tsof_debe "&_
						" , 0 as TSOF_HABER "&_
						" , protic.extrae_acentos(LTRIM(RTRIM(c.dorc_tdesc))) as TSOF_GLOSA_SIN_ACENTO, '' as TSOF_COD_AUXILIAR, '' as TSOF_TIPO_DOCUMENTO  "&_
						" , '' as TSOF_NRO_DOCUMENTO, '' as TSOF_FECHA_EMISION_CORTA, '' as TSOF_FECHA_VENCIMIENTO_CORTA, '' AS TSOF_TIPO_DOC_REFERENCIA "&_
						" , '' AS TSOF_NRO_DOC_REFERENCIA "&_
						" , NULL AS TSOF_NRO_CORRELATIVO"&_
						" , NULL AS TSOF_MONTO_DET_LIBRO1 "&_
						" , NULL AS TSOF_MONTO_DET_LIBRO2 "&_
						" , NULL AS TSOF_MONTO_DET_LIBRO3"&_
						" , NULL AS TSOF_MONTO_SUMA_DET_LIBRO "&_
						" , e.ccos_tcodigo as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR  "&_
						" FROM ocag_solicitud_giro a "&_
						" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.ordc_ncorr ='"&grilla4.obtenerValor("orden")&"' AND A.SOGI_NCORR ="&cod&" and isnull(a.tsol_ccod,1)=1 "&_
						" INNER JOIN ocag_detalle_orden_compra c ON a.ordc_ncorr = c.ordc_ncorr "&_
						" INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod "&_
						" INNER JOIN ocag_centro_costo e ON c.ccos_ncorr = e.ccos_ncorr "
		else
			if estado = 1 then
				auxiliar=""
				while grilla.siguiente
					aux=sqldebeencabezado(grilla.obtenerValor("valor"), solicitud, cod, bolet)
					if auxiliar<>aux then
						if solicitud = 7 then
							valor = valor + diferencial(3, cod)
						end if
						valor= valor + "  " + sqldebeencabezado(grilla.obtenerValor("valor"), solicitud, cod,bolet) + " UNION "
					end if
					auxiliar=aux
					
				wend
				valor = left(valor, len(valor)-7)
			else
				valor= valor + "  " + sqlhaberencabezado("1-10-060-10-000002", solicitud, cod,bolet) + "        "
			end if
			if solicitud = 1 then
				select case bolet
					case 1:
						texto = texto + "UNION select CASE WHEN a.cpag_ccod = 25 THEN '1-10-010-30-100001' ELSE '2-10-070-10-000002' END as tsof_plan_cuenta,"& vbCrLf &_
							" 0 as tsof_debe,"& vbCrLf &_
							" e.dsgi_mdocto as TSOF_HABER,"& vbCrLf &_
							" protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_
							"'' AS TSOF_EQUIVALENCIA,"& vbCrLf &_
							"'' AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_
							"'' AS TSOF_HABER_ADICIONAL,"& vbCrLf &_
							"'' AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_
							"'' AS TSOF_COD_VENDEDOR,"& vbCrLf &_
							"'' AS TSOF_COD_UBICACION,"& vbCrLf &_
							"'' AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_
							"'' AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_
							"'' AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_
							"'' AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_
							"'' AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_
							"'' AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
							"'' AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_
							"'' AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_
							" CAST(b.pers_nrut AS VARCHAR) as TSOF_COD_AUXILIAR,"& vbCrLf &_
							" LTRIM(RTRIM(f.tdoc_tdesc_softland)) as TSOF_TIPO_DOCUMENTO, "& vbCrLf &_
							" CAST(e.dsgi_ndocto AS VARCHAR) as TSOF_NRO_DOCUMENTO,"& vbCrLf &_
							" protic.trunc(e.dogi_fecha_documento) as TSOF_FECHA_EMISION_CORTA, "& vbCrLf &_
							" protic.trunc(d.dpva_fpago) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
							" LTRIM(RTRIM(f.tdoc_tdesc_softland)) AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
							" CAST(e.dsgi_ndocto AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
							" "&numeross()&" AS TSOF_NRO_CORRELATIVO,"&_ 
							" e.dsgi_mhonorarios AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_
							" e.dsgi_mretencion AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_
							"null AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_
							"'' AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_
							"'' AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_
							"'' AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_
							"'' AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_
							"'' AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_
							"'' AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_
							" e.dsgi_mdocto as TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_
							"'' AS TSOF_NRO_DOCUMENTO_DESDE,"& vbCrLf &_
							"'' TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_
							"1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_
							"'' AS TSOF_bullshet1,"& vbCrLf &_
							"'' AS TSOF_bullshet2,"& vbCrLf &_
							"'' AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_
							"'' AS TSOF_COD_MESANO"& vbCrLf &_
							" from ocag_solicitud_giro a  "&_
							" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr="&numero&" "&_
							" INNER JOIN ocag_validacion_contable c ON a.sogi_ncorr=c.cod_solicitud AND isnull(c.tsol_ccod,1)=1 "&_
							" INNER JOIN ocag_detalle_pago_validacion d ON c.vcon_ncorr = d.vcon_ncorr "&_
							" INNER JOIN ocag_detalle_solicitud_giro e ON a.sogi_ncorr=e.sogi_ncorr "&_
							" INNER JOIN ocag_tipo_documento f ON e.tdoc_ccod=f.tdoc_ccod "&_
							" UNION "&_
							" select '2-10-120-10-000003' as tsof_plan_cuenta,"& vbCrLf &_
							" 0 as tsof_debe,"& vbCrLf &_
							" CAST(c.dorc_nprecio_neto*0.1 AS INT) as TSOF_HABER, "& vbCrLf &_
							" protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_
							"'' AS TSOF_EQUIVALENCIA,"& vbCrLf &_
							"'' AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_
							"'' AS TSOF_HABER_ADICIONAL,"& vbCrLf &_
							"'' AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_
							"'' AS TSOF_COD_VENDEDOR,"& vbCrLf &_
							"'' AS TSOF_COD_UBICACION,"& vbCrLf &_
							"'' AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_
							"'' AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_
							"'' AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_
							"'' AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_
							"'' AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_
							"e.ccos_tcodigo AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
							"'' AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_
							"'' AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_
							" '' as TSOF_COD_AUXILIAR,"& vbCrLf &_
							" '' as TSOF_TIPO_DOCUMENTO,"&_
							" '' as TSOF_NRO_DOCUMENTO,"& vbCrLf &_
							" '' as TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_
							" '' as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
							" '' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
							" '' AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
							" '' AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_
							" NULL AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_
							" NULL AS TSOF_MONTO_DET_LIBRO2,"&_
							" null AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_
							" '' AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_
							" '' AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_
							" '' AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_
							" '' AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_
							" '' AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_
							" '' AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_
							" NULL AS TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_
							"'' AS TSOF_NRO_DOCUMENTO_DESDE,"& vbCrLf &_
							"'' TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_
							"1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_
							"'' AS TSOF_bullshet1,"& vbCrLf &_
							"'' AS TSOF_bullshet2,"& vbCrLf &_
							"'' AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_
							"'' AS TSOF_COD_MESANO"& vbCrLf &_
							" FROM ocag_solicitud_giro a "&_
							" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr ="&numero&" and isnull(a.tsol_ccod,1)=1 "&_
							" INNER JOIN ocag_detalle_solicitud_ag c ON a.sogi_ncorr = c.sogi_ncorr "&_
							" INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod "&_
							" INNER JOIN ocag_centro_costo e ON c.ccos_ncorr = e.ccos_ncorr "
					case 2:
						texto = texto + "UNION SELECT CASE WHEN a.cpag_ccod = 25 THEN '1-10-010-30-100001' ELSE '2-10-070-10-000002' END as tsof_plan_cuenta,"& vbCrLf &_
							"0 as tsof_debe,"& vbCrLf &_
							"e.dsgi_mdocto as TSOF_HABER,"& vbCrLf &_
							"protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_
							"'' AS TSOF_EQUIVALENCIA,"& vbCrLf &_
							"'' AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_
							"'' AS TSOF_HABER_ADICIONAL,"& vbCrLf &_
							"'' AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_
							"'' AS TSOF_COD_VENDEDOR,"& vbCrLf &_
							"'' AS TSOF_COD_UBICACION,"& vbCrLf &_
							"'' AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_
							"'' AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_
							"'' AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_
							"'' AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_
							"'' AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_
							"'' AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
							"'' AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_
							"'' AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_
							"CAST(b.pers_nrut AS VARCHAR) as TSOF_COD_AUXILIAR,"& vbCrLf &_
							"LTRIM(RTRIM(f.tdoc_tdesc_softland)) as TSOF_TIPO_DOCUMENTO,"& vbCrLf &_
							"CAST(e.dsgi_ndocto AS VARCHAR) as TSOF_NRO_DOCUMENTO,"& vbCrLf &_
							"protic.trunc(e.dogi_fecha_documento) as TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_
							"protic.trunc(d.dpva_fpago) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
							"LTRIM(RTRIM(f.tdoc_tdesc_softland)) AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
							"CAST(e.dsgi_ndocto AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
							"'' AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_
							"e.dsgi_mafecto AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_
							"e.dsgi_miva AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_
							"null AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_
							"'' AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_
							"'' AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_
							"'' AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_
							"'' AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_
							"'' AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_
							"'' AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_
							"e.dsgi_mdocto as TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_
							"'' AS TSOF_NRO_DOCUMENTO_DESDE,"& vbCrLf &_
							"'' TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_
							"1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_
							"'' AS TSOF_bullshet1,"& vbCrLf &_
							"'' AS TSOF_bullshet2,"& vbCrLf &_
							"'' AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_
							"'' AS TSOF_COD_MESANO"& vbCrLf &_
							" from ocag_solicitud_giro a"& vbCrLf &_
							"INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr="&numero& vbCrLf &_
							"INNER JOIN ocag_validacion_contable c ON a.sogi_ncorr=c.cod_solicitud AND isnull(c.tsol_ccod,1)=1"& vbCrLf &_
							"INNER JOIN ocag_detalle_pago_validacion d ON c.vcon_ncorr = d.vcon_ncorr"& vbCrLf &_
							"INNER JOIN ocag_detalle_solicitud_giro e ON a.sogi_ncorr=e.sogi_ncorr "& vbCrLf &_
							"INNER JOIN ocag_tipo_documento f ON e.tdoc_ccod=f.tdoc_ccod "& vbCrLf &_
							"UNION select CASE WHEN a.cpag_ccod = 25 THEN '1-10-010-30-100001' ELSE '2-10-070-10-000002' END as tsof_plan_cuenta, e.dsgi_mdocto as tsof_debe,"& vbCrLf &_
							"0 as TSOF_HABER,"& vbCrLf &_
							"protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO,"& vbCrLf &_
							"'' AS TSOF_EQUIVALENCIA,"& vbCrLf &_
							"'' AS TSOF_DEBE_ADICIONAL,"& vbCrLf &_
							"'' AS TSOF_HABER_ADICIONAL,"& vbCrLf &_
							"'' AS TSOF_COD_CONDICION_VENTA,"& vbCrLf &_
							"'' AS TSOF_COD_VENDEDOR,"& vbCrLf &_
							"'' AS TSOF_COD_UBICACION,"& vbCrLf &_
							"'' AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_
							"'' AS TSOF_COD_INSTRUMENTO_FINAN,"& vbCrLf &_
							"'' AS TSOF_CANT_INSTRUMENTO_FINAN,"& vbCrLf &_
							"'' AS TSOF_COD_DETALLE_GASTO,"& vbCrLf &_
							"'' AS TSOF_CANT_CONCEPTO_GASTO,"& vbCrLf &_
							"'' AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
							"'' AS TSOF_TIPO_DOC_CONCILIACION,"& vbCrLf &_
							"'' AS TSOF_NRO_DOC_CONCILIACION,"& vbCrLf &_
							"CAST(b.pers_nrut AS VARCHAR) as TSOF_COD_AUXILIAR,"& vbCrLf &_
							"LTRIM(RTRIM('TR')) as TSOF_TIPO_DOCUMENTO,"& vbCrLf &_
							"CAST(e.dsgi_ndocto AS VARCHAR) as TSOF_NRO_DOCUMENTO,"& vbCrLf &_
							"protic.trunc(e.dogi_fecha_documento) as TSOF_FECHA_EMISION_CORTA,"& vbCrLf &_
							"protic.trunc(d.dpva_fpago) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
							"LTRIM(RTRIM(f.tdoc_tdesc_softland)) AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
							"CAST(e.dsgi_ndocto AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
							"'' AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_
							"e.dsgi_mafecto AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_
							"e.dsgi_miva AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_
							"null AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_
							"'' AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_
							"'' AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_
							"'' AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_
							"'' AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_
							"'' AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_
							"'' AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_
							"e.dsgi_mdocto as TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_
							"'' AS TSOF_NRO_DOCUMENTO_DESDE,"& vbCrLf &_
							"'' TSOF_NRO_DOCUMENTO_HASTA,"& vbCrLf &_
							"1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_
							"'' AS TSOF_bullshet1,"& vbCrLf &_
							"'' AS TSOF_bullshet2,"& vbCrLf &_
							"'' AS TSOF_MONTO_PRESUPUESTO,"& vbCrLf &_
							"'' AS TSOF_COD_MESANO"& vbCrLf &_
							"from ocag_solicitud_giro a"& vbCrLf &_
							"INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr="&numero& vbCrLf &_
							"INNER JOIN ocag_validacion_contable c ON a.sogi_ncorr=c.cod_solicitud AND isnull(c.tsol_ccod,1)=1 "& vbCrLf &_
							"INNER JOIN ocag_detalle_pago_validacion d ON c.vcon_ncorr = d.vcon_ncorr  "& vbCrLf &_
							"INNER JOIN ocag_detalle_solicitud_giro e ON a.sogi_ncorr=e.sogi_ncorr "& vbCrLf &_
							"INNER JOIN ocag_tipo_documento f ON e.tdoc_ccod=f.tdoc_ccod "
					end select
			end if 
		end if
		codigoverificar = valor
	end function
	
	function diferencial(solicitud, numero)
		'---------- CONEXION A SOFTLAND ----------'
		set conectar = new Cconexion
		conectar.Inicializar "upacifico"
	
		'---------- CREAR FORMULARIO ----------'
		set grilla = new CFormulario
		grilla.Carga_Parametros "tabla_vacia.xml", "tabla"
		grilla.Inicializar conectar
		sql = "SELECT CONVERT(INT, (SELECT psol_mpresupuesto FROM ocag_presupuesto_solicitud WHERE cod_solicitud_origen = (SELECT TOP 1 fren_ncorr FROM ocag_detalle_rendicion_fondo_rendir WHERE rfre_ncorr="& numero &")) - psol_mpresupuesto) AS diferencia FROM ocag_presupuesto_solicitud WHERE cod_solicitud=(SELECT TOP 1 fren_ncorr FROM ocag_detalle_rendicion_fondo_rendir WHERE rfre_ncorr="& numero &") AND tsol_ccod = "&solicitud
		response.write sql&"<br>"
		grilla.CONSULTAR sql
		grilla.siguiente
		valor =""
		response.write grilla.obtenerValor("diferencia")&"<br>"
		if grilla.obtenerValor("diferencia") > 0 then
			valor ="SELECT TOP 1 '2-10-070-10-000002' AS TSOF_PLAN_CUENTA, '0' AS TSOF_DEBE,"&_ 
				grilla.obtenerValor("diferencia") &" AS TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(c.drfr_tdesc))) AS TSOF_GLOSA_SIN_ACENTO,"&_ 
				" '' AS TSOF_EQUIVALENCIA, '' AS TSOF_DEBE_ADICIONAL, '' AS TSOF_HABER_ADICIONAL, '' AS TSOF_COD_CONDICION_VENTA,"&_ 
				" '' AS TSOF_COD_VENDEDOR, '' AS TSOF_COD_UBICACION, '' AS TSOF_COD_CONCEPTO_CAJA, '' AS TSOF_COD_INSTRUMENTO_FINAN,"&_ 
				" '' AS TSOF_CANT_INSTRUMENTO_FINAN, '' AS TSOF_COD_DETALLE_GASTO, '' AS TSOF_CANT_CONCEPTO_GASTO,"&_ 
				" NULL AS TSOF_COD_CENTRO_COSTO, '' AS TSOF_TIPO_DOC_CONCILIACION, '' AS TSOF_NRO_DOC_CONCILIACION,"&_ 
				" CONVERT(VARCHAR(32),b.PERS_NRUT) AS TSOF_COD_AUXILIAR, 'BC' AS TSOF_TIPO_DOCUMENTO, CONVERT(VARCHAR(32),"&_ 
				" z.rfre_ncorr) AS TSOF_NRO_DOCUMENTO, CONVERT(VARCHAR(32),protic.trunc(c.drfr_fdocto)) AS TSOF_FECHA_EMISION_CORTA,"&_ 
				" CONVERT(VARCHAR(32),protic.trunc(c.drfr_fdocto)) AS TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA,"&_ 
				" CONVERT(VARCHAR(32),z.fren_ncorr) AS TSOF_NRO_DOC_REFERENCIA, '130' AS TSOF_NRO_CORRELATIVO,"&_ 
				" null AS TSOF_MONTO_DET_LIBRO1, null AS TSOF_MONTO_DET_LIBRO2, null AS TSOF_MONTO_DET_LIBRO3,"&_ 
				" '' AS TSOF_MONTO_DET_LIBRO4, '' AS TSOF_MONTO_DET_LIBRO5, '' AS TSOF_MONTO_DET_LIBRO6,"&_ 
				" '' AS TSOF_MONTO_DET_LIBRO7, '' AS TSOF_MONTO_DET_LIBRO8, '' AS TSOF_MONTO_DET_LIBRO9,"&_ 
				" '' TSOF_MONTO_SUMA_DET_LIBRO, '' AS TSOF_NRO_DOCUMENTO_DESDE, '' TSOF_NRO_DOCUMENTO_HASTA,"&_ 
				" '1' AS TSOF_NRO_AGRUPADOR, '' AS TSOF_bullshet1, '' AS TSOF_bullshet2, '' AS TSOF_MONTO_PRESUPUESTO,"&_ 
				" '' AS TSOF_COD_MESANO from ocag_rendicion_fondos_a_rendir z"&_ 
				"  INNER JOIN ocag_fondos_a_rendir a ON z.fren_ncorr = a.fren_ncorr and z.rfre_ncorr ="&numer &_ 
				" INNER JOIN personas b ON a.pers_ncorr = b.pers_ncorr "&_ 
				" INNER JOIN ocag_detalle_rendicion_fondo_rendir c ON a.fren_ncorr = c.fren_ncorr "&_ 
				" INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod "&_ 
				" INNER JOIN ocag_centro_costo e ON a.ccos_ncorr = e.ccos_ncorr UNION "& vbCrLf 
		end if
		diferencial = valor
	end function
	
	function sqldebeencabezado(codigo, solicitud, nume, bolet)
		v_solicitud=nume
		estado = 1
		texto = "SELECT "
		'------- CADA LINEA DE TEXTO ES UNA COLUMNA DE EN EL ARCHIVO PLANO -------'
		texto = texto + registros(solicitud, "TSOF_PLAN_CUENTA",estado,bolet) + " AS TSOF_PLAN_CUENTA, "														'-- 1° Columna --'
		texto = texto + registros(solicitud, "TSOF_DEBE",estado,bolet) +" AS TSOF_DEBE, "																		'-- 2° Columna --'
		texto = texto + registros(solicitud, "TSOF_HABER",estado,bolet) +" AS TSOF_HABER, "																	'-- 3° Columna --'
		texto = texto + "protic.extrae_acentos(LTRIM(RTRIM(" + registros(solicitud, "TSOF_GLOSA_SIN_ACENTO",estado,bolet) + "))) AS TSOF_GLOSA_SIN_ACENTO, "	'-- 4° Columna --'
		if obtener(codigo, "pcmone") then	
			texto = texto + registros(solicitud, "TSOF_EQUIVALENCIA",estado,bolet) + " AS TSOF_EQUIVALENCIA, "												'-- 5° Columna --'
		else										
			texto = texto + "'' AS TSOF_EQUIVALENCIA, "																									'-- 5° Columna --'
		end if										
		texto = texto + "'' AS TSOF_DEBE_ADICIONAL, "																									'-- 6° Columna --'
		texto = texto + "'' AS TSOF_HABER_ADICIONAL, " 																									'-- 7° Columna --'
		texto = texto + "'' AS TSOF_COD_CONDICION_VENTA, "																								'-- 8° Columna --'
		texto = texto + "'' AS TSOF_COD_VENDEDOR, "																										'-- 9° Columna --'
		texto = texto + "'' AS TSOF_COD_UBICACION, "																									'-- 10° Columna --'
		if obtener(codigo, "pcprec") then										
			texto = texto + registros(solicitud, "TSOF_COD_CONCEPTO_CAJA",estado,bolet) + " AS TSOF_COD_CONCEPTO_CAJA, "										'-- 11° Columna --'
		else										
			texto = texto + "'' AS TSOF_COD_CONCEPTO_CAJA, "																							'-- 11° Columna --'
		end if									
		if obtener(codigo, "pcifin") then									
			texto = texto + registros(solicitud, "TSOF_COD_INSTRUMENTO_FINAN",estado,bolet) + " AS TSOF_COD_INSTRUMENTO_FINAN, "								'-- 12° Columna --'
			texto = texto + registros(solicitud, "TSOF_CANT_INSTRUMENTO_FINAN",estado,bolet) + " AS TSOF_CANT_INSTRUMENTO_FINAN, "							'-- 13° Columna --'
		else									
			texto = texto + "'' AS TSOF_COD_INSTRUMENTO_FINAN, "																						'-- 12° Columna --'
			texto = texto + "'' AS TSOF_CANT_INSTRUMENTO_FINAN, "																						'-- 13° Columna --'
		end if									
		if obtener(codigo, "pcdteg") then 									
			texto = texto + registros(solicitud, "TSOF_COD_DETALLE_GASTO",estado,bolet) + " AS TSOF_COD_DETALLE_GASTO, "										'-- 14° Columna --'
			texto = texto + registros(solicitud, "TSOF_CANT_CONCEPTO_GASTO",estado,bolet) + " AS TSOF_CANT_CONCEPTO_GASTO, "									'-- 15° Columna --'
		else									
			texto = texto + "'' AS TSOF_COD_DETALLE_GASTO, "																							'-- 14° Columna --'
			texto = texto + "'' AS TSOF_CANT_CONCEPTO_GASTO, "																							'-- 15° Columna --'
		end if									
		if obtener(codigo, "pcccos") then 		
			texto = texto + registros(solicitud, "TSOF_COD_CENTRO_COSTO",estado,bolet) + " AS TSOF_COD_CENTRO_COSTO, "										'-- 16° Columna --'
		else									
			texto = texto + "'' AS TSOF_COD_CENTRO_COSTO, "																								'-- 16° Columna --'
		end if									
		if obtener(codigo, "pcconb") then 									
			texto = texto + registros(solicitud, "TSOF_TIPO_DOC_CONCILIACION",estado,bolet) + " AS TSOF_TIPO_DOC_CONCILIACION, "								'-- 17° Columna --'
			texto = texto + registros(solicitud, "TSOF_NRO_DOC_CONCILIACION",estado,bolet) + " AS TSOF_NRO_DOC_CONCILIACION, "								'-- 18° Columna --'
		else									
			texto = texto + "'' AS TSOF_TIPO_DOC_CONCILIACION, "																						'-- 17° Columna --'
			texto = texto + "'' AS TSOF_NRO_DOC_CONCILIACION, "																							'-- 18° Columna --'
		end if									
		if obtener(codigo, "pcauxi") then									
			texto = texto + registros(solicitud, "TSOF_COD_AUXILIAR",estado,bolet) + " AS TSOF_COD_AUXILIAR, "												'-- 19° Columna --'
		else									
			texto = texto + "'' AS TSOF_COD_AUXILIAR, "																									'-- 19° Columna --'
		end if									
		if obtener(codigo, "pccdoc") then									
			texto = texto + registros(solicitud, "TSOF_TIPO_DOCUMENTO",estado,bolet) + " AS TSOF_TIPO_DOCUMENTO, "											'-- 20° Columna --'
			texto = texto + registros(solicitud, "TSOF_NRO_DOCUMENTO",estado,bolet) + " AS TSOF_NRO_DOCUMENTO, "												'-- 21° Columna --'
			texto = texto + registros(solicitud, "TSOF_FECHA_EMISION_CORTA",estado,bolet) + " AS TSOF_FECHA_EMISION_CORTA, "									'-- 22° Columna --'
			texto = texto + registros(solicitud, "TSOF_FECHA_VENCIMIENTO_CORTA",estado,bolet) + " AS TSOF_FECHA_VENCIMIENTO_CORTA, "							'-- 23° Columna --'
			texto = texto + registros(solicitud, "TSOF_TIPO_DOC_REFERENCIA",estado,bolet) + " AS TSOF_TIPO_DOC_REFERENCIA, "									'-- 24° Columna --'
			texto = texto + registros(solicitud, "TSOF_NRO_DOC_REFERENCIA",estado,bolet) + " AS TSOF_NRO_DOC_REFERENCIA, "									'-- 25° Columna --'
		else									
			texto = texto + "'' AS TSOF_TIPO_DOCUMENTO, "																								'-- 20° Columna --'
			texto = texto + "'' AS TSOF_NRO_DOCUMENTO, "																								'-- 21° Columna --'
			texto = texto + "'' AS TSOF_FECHA_EMISION_CORTA, "																							'-- 22° Columna --'
			texto = texto + "'' AS TSOF_FECHA_VENCIMIENTO_CORTA, "																						'-- 23° Columna --'
			texto = texto + "'' AS TSOF_TIPO_DOC_REFERENCIA, "																							'-- 24° Columna --'
			texto = texto + "'' AS TSOF_NRO_DOC_REFERENCIA, "																							'-- 25° Columna --
		end if									
		if obtener(codigo, "pcdinba") then									
			texto = texto + registros(solicitud, "TSOF_NRO_CORRELATIVO",estado,bolet) + " AS TSOF_NRO_CORRELATIVO, "											'-- 26° Columna --'
		else									
			texto = texto + "'	' AS TSOF_NRO_CORRELATIVO, "																							'-- 26° Columna --'
		end if									
		texto = texto + "null AS TSOF_MONTO_DET_LIBRO1, "																									'-- 27° Columna --'
		texto = texto + "null AS TSOF_MONTO_DET_LIBRO2, "																									'-- 28° Columna --'
		texto = texto + "null AS TSOF_MONTO_DET_LIBRO3, "																									'-- 29° Columna --'
		texto = texto + "'' AS TSOF_MONTO_DET_LIBRO4, "																									'-- 30° Columna --'
		texto = texto + "'' AS TSOF_MONTO_DET_LIBRO5, "																									'-- 31° Columna --'
		texto = texto + "'' AS TSOF_MONTO_DET_LIBRO6, "																									'-- 32° Columna --'
		texto = texto + "'' AS TSOF_MONTO_DET_LIBRO7, "																									'-- 33° Columna --'
		texto = texto + "'' AS TSOF_MONTO_DET_LIBRO8, "																									'-- 34° Columna --'
		texto = texto + "'' AS TSOF_MONTO_DET_LIBRO9, "																									'-- 35° Columna --'
		
		'---- SI es boleta restar libro 1 y libro 2, todo lo demas sumar libro 1 y libro 2									
		
		texto = texto + registros(solicitud, "TSOF_MONTO_SUMA_DET_LIBRO",estado,bolet) + " TSOF_MONTO_SUMA_DET_LIBRO, "																			'-- 36° Columna --'
		texto = texto + "'' AS TSOF_NRO_DOCUMENTO_DESDE, "																								'-- 37° Columna --'
		texto = texto + "'' TSOF_NRO_DOCUMENTO_HASTA, "																									'-- 38° Columna --'
		texto = texto + "1 AS TSOF_NRO_AGRUPADOR, "																									'-- 39° Columna --'
		texto = texto + "'' AS TSOF_bullshet1, "																										'-- 40° Columna --'
		texto = texto + "'' AS TSOF_bullshet2, "																										'-- 41° Columna --'
		if obtener(codigo, "pcprec") then										
			texto = texto + registros(solicitud, "TSOF_MONTO_PRESUPUESTO",estado,bolet) + " AS TSOF_MONTO_PRESUPUESTO, "										'-- 42° Columna --'
			texto = texto + registros(solicitud, "TSOF_COD_MESANO",estado,bolet) + " AS TSOF_COD_MESANO, "													'-- 43° Columna --'
		else
			texto = texto + "'' AS TSOF_MONTO_PRESUPUESTO, "																							'-- 42° Columna --'
			texto = texto + "'' AS TSOF_COD_MESANO, "																									'-- 43° Columna --'
		end if
		texto = left(texto, len(texto)-2)
		select case solicitud
			case 1:
				texto = pago_proveedor_debe_sql_encabezado(v_solicitud)
			case 2:
				texto = reembolso_solicitud_debe_sql_encabezado(v_solicitud)
			case 3:
				texto = texto + " from ocag_fondos_a_rendir a  "&_
					" INNER JOIN personas b   "&_
					" ON a.pers_ncorr = b.pers_ncorr and fren_ncorr="&v_solicitud&" "&_
					" INNER JOIN ocag_validacion_contable c on a.fren_ncorr = c.cod_solicitud and isnull(c.tsol_ccod,3)=3   "&_
					" INNER JOIN ocag_centro_costo_validacion d ON c.vcon_ncorr=d.vcon_ncorr   "&_
					" INNER JOIN ocag_centro_costo e ON d.ccos_ncorr=e.ccos_ncorr "
			case 4:
				texto = texto + " From ocag_solicitud_viatico a "&_
					"  INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and A.sovi_ncorr="&v_solicitud&" "&_
					"  INNER JOIN ocag_presupuesto_solicitud c ON c.cod_solicitud=a.sovi_ncorr AND c.tsol_ccod=4"
			case 5:
				texto = texto + " from ocag_devolucion_alumno a "&_
					"INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and dalu_ncorr="&v_solicitud&" "&_
					"INNER JOIN ocag_validacion_contable c on a.dalu_ncorr = c.cod_solicitud and isnull(c.tsol_ccod,5)=5 "&_
					"INNER JOIN ocag_centro_costo_validacion d ON c.vcon_ncorr=d.vcon_ncorr "&_
					"INNER JOIN ocag_centro_costo e ON d.ccos_ncorr=e.ccos_ncorr "
			case 6:
				texto = texto + " FROM ocag_fondo_fijo a "&_
					" INNER JOIN personas b "&_
					" ON a.pers_ncorr=b.pers_ncorr and ffij_ncorr="&v_solicitud&" "&_
					" INNER JOIN ocag_validacion_contable c  "&_
					" on a.ffij_ncorr = c.cod_solicitud and isnull(c.tsol_ccod,6)=6 "&_
					" INNER JOIN ocag_centro_costo_validacion d "&_
					" ON c.vcon_ncorr=d.vcon_ncorr "&_
					" INNER JOIN ocag_centro_costo e "&_
					" ON d.ccos_ncorr=e.ccos_ncorr "
			case 7:
				texto = texto + " from ocag_rendicion_fondos_a_rendir z  "&_
					"INNER JOIN ocag_fondos_a_rendir a ON z.fren_ncorr = a.fren_ncorr and z.rfre_ncorr ="&v_solicitud&" "&_
					"INNER JOIN personas b ON a.pers_ncorr = b.pers_ncorr  "&_
					"INNER JOIN ocag_detalle_rendicion_fondo_rendir c ON a.fren_ncorr = c.fren_ncorr  "&_
					"INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod  "&_
					"INNER JOIN ocag_centro_costo e ON a.ccos_ncorr = e.ccos_ncorr "&_
					" WHERE d.tgas_cod_cuenta = '"&codigo&"' "
			case 8:
				texto = texto + " from ocag_rendicion_fondo_fijo z   "&_
					" inner join ocag_detalle_rendicion_fondo_fijo w ON Z.rffi_ncorr = W.rffi_ncorr   "&_
					" INNER JOIN ocag_fondo_fijo a ON W.ffij_ncorr = a.ffij_ncorr and z.rffi_ncorr ="&v_solicitud&" "&_
					" INNER JOIN personas b ON a.pers_ncorr = b.pers_ncorr   "&_
					" INNER JOIN ocag_tipo_gasto d ON W.tgas_ccod = d.tgas_ccod  "&_
					" INNER JOIN ocag_validacion_contable c on z.rffi_ncorr = c.cod_solicitud and isnull(c.tsol_ccod,8)=8   "&_
					" INNER JOIN ocag_centro_costo_validacion x ON c.vcon_ncorr=x.vcon_ncorr   "&_
					" INNER JOIN ocag_centro_costo y ON x.ccos_ncorr=y.ccos_ncorr "
		end select
		sqldebeencabezado = texto
	end function
	
	function sqlhaberencabezado(codigo, solicitud, nume, bolet)
		v_solicitud=nume
		estado = 2
		texto = "SELECT TOP 1 "
		'------- CADA LINEA DE TEXTO ES UNA COLUMNA DE EN EL ARCHIVO PLANO -------'
		texto = texto + registros(solicitud, "TSOF_PLAN_CUENTA",estado,bolet) + " AS TSOF_PLAN_CUENTA, "														'-- 1° Columna --'
		texto = texto + registros(solicitud, "TSOF_DEBE",estado,bolet) +" AS TSOF_DEBE, "																		'-- 2° Columna --'
		texto = texto + registros(solicitud, "TSOF_HABER",estado,bolet) +" AS TSOF_HABER, "																	    '-- 3° Columna --'
		texto = texto + "protic.extrae_acentos(LTRIM(RTRIM(" + registros(solicitud, "TSOF_GLOSA_SIN_ACENTO",estado,bolet) + "))) AS TSOF_GLOSA_SIN_ACENTO, "  '-- 4° Columna --'
		if obtener(codigo, "pcmone") then	
			texto = texto + registros(solicitud, "TSOF_EQUIVALENCIA",estado,bolet) + " AS TSOF_EQUIVALENCIA, "												'-- 5° Columna --'
		else										
			texto = texto + "'' AS TSOF_EQUIVALENCIA, "																								    '-- 5° Columna --'
		end if										
		texto = texto + "'' AS TSOF_DEBE_ADICIONAL, "																								    '-- 6° Columna --'
		texto = texto + "'' AS TSOF_HABER_ADICIONAL, " 																									'-- 7° Columna --'
		texto = texto + "'' AS TSOF_COD_CONDICION_VENTA, "																								'-- 8° Columna --'
		texto = texto + "'' AS TSOF_COD_VENDEDOR, "																										'-- 9° Columna --'
		texto = texto + "'' AS TSOF_COD_UBICACION, "																									'-- 10° Columna --'
		if obtener(codigo, "pcprec") then										
			texto = texto + registros(solicitud, "TSOF_COD_CONCEPTO_CAJA",estado,bolet) + " AS TSOF_COD_CONCEPTO_CAJA, "										'-- 11° Columna --'
		else										
			texto = texto + "'' AS TSOF_COD_CONCEPTO_CAJA, "																							'-- 11° Columna --'
		end if									
		if obtener(codigo, "pcifin") then									
			texto = texto + registros(solicitud, "TSOF_COD_INSTRUMENTO_FINAN",estado,bolet) + " AS TSOF_COD_INSTRUMENTO_FINAN, "								'-- 12° Columna --'
			texto = texto + registros(solicitud, "TSOF_CANT_INSTRUMENTO_FINAN",estado,bolet) + " AS TSOF_CANT_INSTRUMENTO_FINAN, "							'-- 13° Columna --'
		else									
			texto = texto + "'' AS TSOF_COD_INSTRUMENTO_FINAN, "																						'-- 12° Columna --'
			texto = texto + "'' AS TSOF_CANT_INSTRUMENTO_FINAN, "																						'-- 13° Columna --'
		end if									
		if obtener(codigo, "pcdteg") then 									
			texto = texto + registros(solicitud, "TSOF_COD_DETALLE_GASTO",estado,bolet) + " AS TSOF_COD_DETALLE_GASTO, "										'-- 14° Columna --'
			texto = texto + registros(solicitud, "TSOF_CANT_CONCEPTO_GASTO",estado,bolet) + " AS TSOF_CANT_CONCEPTO_GASTO, "									'-- 15° Columna --'
		else									
			texto = texto + "'' AS TSOF_COD_DETALLE_GASTO, "																							'-- 14° Columna --'
			texto = texto + "'' AS TSOF_CANT_CONCEPTO_GASTO, "																							'-- 15° Columna --'
		end if									
		if obtener(codigo, "pcccos") then 									
			texto = texto + registros(solicitud, "TSOF_COD_CENTRO_COSTO",estado,bolet) + " AS TSOF_COD_CENTRO_COSTO, "										'-- 16° Columna --'
		else									
			texto = texto + "'' AS TSOF_COD_CENTRO_COSTO, "																								'-- 16° Columna --'
		end if									
		if obtener(codigo, "pcconb") then 									
			texto = texto + registros(solicitud, "TSOF_TIPO_DOC_CONCILIACION",estado,bole) + " AS TSOF_TIPO_DOC_CONCILIACION, "								'-- 17° Columna --'
			texto = texto + registros(solicitud, "TSOF_NRO_DOC_CONCILIACION",estado,bolet) + " AS TSOF_NRO_DOC_CONCILIACION, "								'-- 18° Columna --'
		else									
			texto = texto + "'' AS TSOF_TIPO_DOC_CONCILIACION, "																						'-- 17° Columna --'
			texto = texto + "'' AS TSOF_NRO_DOC_CONCILIACION, "																							'-- 18° Columna --'
		end if							
		if obtener(codigo, "pcauxi") then	
			texto = texto + registros(solicitud, "TSOF_COD_AUXILIAR",estado,bolet) + " AS TSOF_COD_AUXILIAR, "												'-- 19° Columna --'
		else									
			texto = texto + "'' AS TSOF_COD_AUXILIAR, "																									'-- 19° Columna --'
		end if									
		if obtener(codigo, "pccdoc") then									
			texto = texto + registros(solicitud, "TSOF_TIPO_DOCUMENTO",estado,bolet) + " AS TSOF_TIPO_DOCUMENTO, "											'-- 20° Columna --'
			texto = texto + registros(solicitud, "TSOF_NRO_DOCUMENTO",estado,bolet) + " AS TSOF_NRO_DOCUMENTO, "												'-- 21° Columna --'
			texto = texto + registros(solicitud, "TSOF_FECHA_EMISION_CORTA",estado,bolet) + " AS TSOF_FECHA_EMISION_CORTA, "									'-- 22° Columna --'
			texto = texto + registros(solicitud, "TSOF_FECHA_VENCIMIENTO_CORTA",estado,bolet) + " AS TSOF_FECHA_VENCIMIENTO_CORTA, "							'-- 23° Columna --'
			texto = texto + registros(solicitud, "TSOF_TIPO_DOC_REFERENCIA",estado,bolet) + " AS TSOF_TIPO_DOC_REFERENCIA, "									'-- 24° Columna --'
			texto = texto + registros(solicitud, "TSOF_NRO_DOC_REFERENCIA",estado,bolet) + " AS TSOF_NRO_DOC_REFERENCIA, "									'-- 25° Columna --'
		else									
			texto = texto + "'' AS TSOF_TIPO_DOCUMENTO, "																								'-- 20° Columna --'
			texto = texto + "'' AS TSOF_NRO_DOCUMENTO, "																								'-- 21° Columna --'
			texto = texto + "'' AS TSOF_FECHA_EMISION_CORTA, "																							'-- 22° Columna --'
			texto = texto + "'' AS TSOF_FECHA_VENCIMIENTO_CORTA, "																						'-- 23° Columna --'
			texto = texto + "'' AS TSOF_TIPO_DOC_REFERENCIA, "																							'-- 24° Columna --'
			texto = texto + "'' AS TSOF_NRO_DOC_REFERENCIA, "																							'-- 25° Columna --
		end if									
		if obtener(codigo, "pcdinba") then	
			texto = texto + registros(solicitud, "TSOF_NRO_CORRELATIVO",estado,bolet) + " AS TSOF_NRO_CORRELATIVO, "											'-- 26° Columna --'
		else									
			texto = texto + "'' AS TSOF_NRO_CORRELATIVO, "																							'-- 26° Columna --'
		end if									
		texto = texto + "null AS TSOF_MONTO_DET_LIBRO1, "																									'-- 27° Columna --'
		texto = texto + "null AS TSOF_MONTO_DET_LIBRO2, "																									'-- 28° Columna --'
		texto = texto + "null AS TSOF_MONTO_DET_LIBRO3, "																									'-- 29° Columna --'
		texto = texto + "'' AS TSOF_MONTO_DET_LIBRO4, "																									'-- 30° Columna --'
		texto = texto + "'' AS TSOF_MONTO_DET_LIBRO5, "																									'-- 31° Columna --'
		texto = texto + "'' AS TSOF_MONTO_DET_LIBRO6, "																									'-- 32° Columna --'
		texto = texto + "'' AS TSOF_MONTO_DET_LIBRO7, "																									'-- 33° Columna --'
		texto = texto + "'' AS TSOF_MONTO_DET_LIBRO8, "																									'-- 34° Columna --'
		texto = texto + "'' AS TSOF_MONTO_DET_LIBRO9, "																									'-- 35° Columna --'
		'---- SI es boleta restar libro 1 y libro 2, todo lo demas sumar libro 1 y libro 2									
		texto = texto + registros(solicitud, "TSOF_MONTO_SUMA_DET_LIBRO",estado,bolet) + " TSOF_MONTO_SUMA_DET_LIBRO, "										'-- 36° Columna --'
		texto = texto + "'' AS TSOF_NRO_DOCUMENTO_DESDE, "																								'-- 37° Columna --'
		texto = texto + "'' TSOF_NRO_DOCUMENTO_HASTA, "																									'-- 38° Columna --'
		texto = texto + "'1' AS TSOF_NRO_AGRUPADOR, "																									'-- 39° Columna --'
		texto = texto + "'' AS TSOF_bullshet1, "																										'-- 40° Columna --'
		texto = texto + "'' AS TSOF_bullshet2, "																										'-- 41° Columna --'
		if obtener(codigo, "pcprec") then										
			texto = texto + registros(solicitud, "TSOF_MONTO_PRESUPUESTO",estado, bolet) + " AS TSOF_MONTO_PRESUPUESTO, "										'-- 42° Columna --'
			texto = texto + registros(solicitud, "TSOF_COD_MESANO",estado,bolet) + " AS TSOF_COD_MESANO, "													'-- 43° Columna --'
		else
			texto = texto + "'' AS TSOF_MONTO_PRESUPUESTO, "													'-- 42° Columna --'
			texto = texto + "'' AS TSOF_COD_MESANO, "															'-- 43° Columna --'
		end if
		'---- HACER LOGICA PARA QUITAR ULTIMO 2 CARACTERES ----'
		texto = left(texto, len(texto)-2)
		select case solicitud
			case 1:
				'texto = pago_proveedor_haber_sql_encabezado(v_solicitud)
			case 2:
				texto = reembolso_solicitud_haber_sql_encabezado(v_solicitud)
			case 3:
				texto = texto + " from ocag_fondos_a_rendir a  "&_
					" INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and fren_ncorr="&v_solicitud&" "&_
					" INNER JOIN ocag_validacion_contable w ON a.fren_ncorr=w.cod_solicitud AND isnull(w.tsol_ccod,3)=3  "&_
					" INNER JOIN ocag_detalle_pago_validacion x ON w.vcon_ncorr = x.vcon_ncorr "
			case 4:
				texto = texto + " From ocag_solicitud_viatico a "&_
					"  INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and A.sovi_ncorr="&v_solicitud&" "
			case 5:
				texto = texto + " from ocag_devolucion_alumno a "&_
					"INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and dalu_ncorr="&v_solicitud&" "&_
					"INNER JOIN ocag_validacion_contable w ON a.dalu_ncorr=w.cod_solicitud AND isnull(w.tsol_ccod,5)=5 "&_
					"INNER JOIN ocag_detalle_pago_validacion x ON w.vcon_ncorr = x.vcon_ncorr  "
			case 6:
				texto = texto + " FROM ocag_fondo_fijo a "&_
					" INNER JOIN personas b "&_
					" ON a.pers_ncorr=b.pers_ncorr and ffij_ncorr="&v_solicitud&" "&_
					" INNER JOIN ocag_validacion_contable w "&_
					" ON a.ffij_ncorr=w.cod_solicitud AND isnull(w.tsol_ccod,6)=6 "&_
					" INNER JOIN ocag_detalle_pago_validacion x ON w.vcon_ncorr = x.vcon_ncorr"
			case 7:
				texto = texto + " from ocag_rendicion_fondos_a_rendir z  "&_
					"INNER JOIN ocag_fondos_a_rendir a ON z.fren_ncorr = a.fren_ncorr and z.rfre_ncorr ="&v_solicitud&" "&_
					"INNER JOIN personas b ON a.pers_ncorr = b.pers_ncorr  "&_
					"INNER JOIN ocag_detalle_rendicion_fondo_rendir c ON a.fren_ncorr = c.fren_ncorr  "&_
					"INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod  "&_
					"INNER JOIN ocag_centro_costo e ON a.ccos_ncorr = e.ccos_ncorr "
			case 8:
				texto = texto + " from ocag_rendicion_fondo_fijo z  "&_
					" inner join ocag_detalle_rendicion_fondo_fijo w ON Z.rffi_ncorr = W.rffi_ncorr  "&_
					" INNER JOIN ocag_fondo_fijo a ON z.ffij_ncorr = a.ffij_ncorr and z.rffi_ncorr ="&v_solicitud&" "&_
					" INNER JOIN personas b ON a.pers_ncorr = b.pers_ncorr  "&_
					" INNER JOIN ocag_tipo_gasto d ON W.tgas_ccod = d.tgas_ccod  "
		end select
		sqlhaberencabezado = texto
	end function
	
	function registros(solicitud, reg, estado, bole)
		texto = ""
		select case estado
			CASE 1:
				select case solicitud
					CASE 1:
						select case bole
							case 1:
								if reg="TSOF_PLAN_CUENTA" then
									texto = "g.dsag_ncorr, LTRIM(RTRIM(h.tgas_cod_cuenta))"
								end if
								if reg="TSOF_DEBE" then
									texto = "g.dorc_nprecio_netoCASE WHEN a.sogi_bboleta_honorario = 1 THEN g.dorc_nprecio_neto ELSE g.dorc_nprecio_neto*1.19 END"
								end if
								if reg="TSOF_HABER" then
									texto = "0"
								end if
								if reg="TSOF_GLOSA_SIN_ACENTO" then
									texto = "g.dorc_tdesc"
								end if
								if reg="TSOF_EQUIVALENCIA" then
									texto = "''"
								end if
								if reg="TSOF_COD_CONCEPTO_CAJA" then
									texto = "i.ccos_tcodigo"
								end if
								if reg="TSOF_COD_INSTRUMENTO_FINAN" then
									texto = "''"
								end if
								if reg="TSOF_CANT_INSTRUMENTO_FINAN" then
									texto = "''"
								end if
								if reg="TSOF_COD_DETALLE_GASTO" then
									texto = "''"
								end if
								if reg="TSOF_CANT_CONCEPTO_GASTO" then
									texto = "''"
								end if
								if reg="TSOF_COD_CENTRO_COSTO" then
									texto = "i.ccos_tcodigo"
								end if
								if reg="TSOF_TIPO_DOC_CONCILIACION" then
									texto = "''"
								end if
								if reg="TSOF_NRO_DOC_CONCILIACION" then
									texto = "''"
								end if
								if reg="TSOF_COD_AUXILIAR" then
									texto = "CAST(b.pers_nrut AS VARCHAR)"
								end if
								if reg="TSOF_TIPO_DOCUMENTO" then
									texto = "LTRIM(RTRIM('TR'))"
								end if
								if reg="TSOF_NRO_DOCUMENTO" then
									texto = "CAST(a.sogi_ncorr AS VARCHAR)"
								end if
								if reg="TSOF_FECHA_EMISION_CORTA" then
									texto = "protic.trunc(a.sogi_fecha_solicitud)"
								end if
								if reg="TSOF_FECHA_VENCIMIENTO_CORTA" then
									texto = "protic.trunc(d.dpva_fpago)"
								end if
								if reg="TSOF_TIPO_DOC_REFERENCIA" then
									texto ="LTRIM(RTRIM(CASE WHEN h.tgas_cod_cuenta = '2-10-070-20-000001' THEN 'CO' ELSE 'BC' END))"
								end if
								if reg="TSOF_NRO_DOC_REFERENCIA" then
									texto ="''"
								end if
								if reg="TSOF_NRO_CORRELATIVO" then
									texto = "'"&numeross()&"'"
								end if
								if reg="TSOF_MONTO_DET_LIBRO1" then
									texto = "null"
								end if
								if reg="TSOF_MONTO_DET_LIBRO2" then
									texto = "null"
								end if
								if reg="TSOF_MONTO_DET_LIBRO3" then
									texto = "null"
								end if
								if reg="TSOF_MONTO_SUMA_DET_LIBRO" then
									texto = "null"
								end if
								if reg="TSOF_MONTO_PRESUPUESTO" then
									texto = "null"
								end if
								if reg="TSOF_COD_MESANO" then
									texto = "''"
								end if
							case 2:
								if reg="TSOF_PLAN_CUENTA" then
									texto = "LTRIM(RTRIM(d.tgas_cod_cuenta))"
								end if
								if reg="TSOF_DEBE" then
									texto = "CONVERT(INT, ROUND(CASE WHEN a.sogi_bboleta_honorario = 1 THEN c.dorc_nprecio_neto ELSE c.dorc_nprecio_neto*1.19 END,0))"
								end if
								if reg="TSOF_HABER" then
									texto = "0"
								end if
								if reg="TSOF_GLOSA_SIN_ACENTO" then
									texto = "a.sogi_tobservaciones"
								end if
								if reg="TSOF_EQUIVALENCIA" then
									texto = "''"
								end if
								if reg="TSOF_COD_CONCEPTO_CAJA" then
									texto = "''"
								end if
								if reg="TSOF_COD_INSTRUMENTO_FINAN" then
									texto = "''"
								end if
								if reg="TSOF_CANT_INSTRUMENTO_FINAN" then
									texto = "''"
								end if
								if reg="TSOF_COD_DETALLE_GASTO" then
									texto = "''"
								end if
								if reg="TSOF_CANT_CONCEPTO_GASTO" then
									texto = "''"
								end if
								if reg="TSOF_COD_CENTRO_COSTO" then
									texto = "i.ccos_tcodigo"
								end if
								if reg="TSOF_TIPO_DOC_CONCILIACION" then
									texto = "''"
								end if
								if reg="TSOF_NRO_DOC_CONCILIACION" then
									texto = "''"
								end if
								if reg="TSOF_COD_AUXILIAR" then
									texto = "CAST(b.pers_nrut AS VARCHAR)"
								end if
								if reg="TSOF_TIPO_DOCUMENTO" then
									texto = "LTRIM(RTRIM('TR'))"
								end if
								if reg="TSOF_NRO_DOCUMENTO" then
									texto = "CAST(a.sogi_ncorr AS VARCHAR)"
								end if
								if reg="TSOF_FECHA_EMISION_CORTA" then
									texto = "protic.trunc(a.sogi_fecha_solicitud)"
								end if
								if reg="TSOF_FECHA_VENCIMIENTO_CORTA" then
									texto = "protic.trunc(f.dpva_fpago)"
								end if
								if reg="TSOF_TIPO_DOC_REFERENCIA" then
									texto ="LTRIM(RTRIM(CASE WHEN d.tgas_cod_cuenta = '2-10-070-20-000001' THEN 'CO' ELSE 'BC' END))"
								end if
								if reg="TSOF_NRO_DOC_REFERENCIA" then
									texto ="''"
								end if
								if reg="TSOF_NRO_CORRELATIVO" then
									texto = "'"&numeross()&"'"
								end if
								if reg="TSOF_MONTO_DET_LIBRO1" then
									texto = "null"
								end if
								if reg="TSOF_MONTO_DET_LIBRO2" then
									texto = "null"
								end if
								if reg="TSOF_MONTO_DET_LIBRO3" then
									texto = "null"
								end if
								if reg="TSOF_MONTO_SUMA_DET_LIBRO" then
									texto = "null"
								end if
								if reg="TSOF_MONTO_PRESUPUESTO" then
									texto = "null"
								end if
								if reg="TSOF_COD_MESANO" then
									texto = "''"
								end if
						end select
					CASE 2:
						if reg="TSOF_PLAN_CUENTA" then
							texto = "d.tgas_cod_cuenta"
						end if
						if reg="TSOF_DEBE" then
							texto = "c.drga_mdocto + c.drga_mretencion"
						end if
						if reg="TSOF_HABER" then
							texto = "0"
						end if
						if reg="TSOF_GLOSA_SIN_ACENTO" then
							texto = "d.tgas_tdesc"
						end if
						if reg="TSOF_EQUIVALENCIA" then
							texto = "''"
						end if
						if reg="TSOF_COD_CONCEPTO_CAJA" then
							texto = "''"
						end if
						if reg="TSOF_COD_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_CANT_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_COD_DETALLE_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_CANT_CONCEPTO_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_COD_CENTRO_COSTO" then
							texto = "CONVERT(VARCHAR(32),e.ccos_tcodigo)"
						end if
						if reg="TSOF_TIPO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_NRO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_COD_AUXILIAR" then
							texto = "NULL"
						end if
						if reg="TSOF_TIPO_DOCUMENTO" then
							texto = "''"
						end if
						if reg="TSOF_NRO_DOCUMENTO" then
							texto = "CONVERT(VARCHAR(32),a.rgas_ncorr)"
						end if
						if reg="TSOF_FECHA_EMISION_CORTA" then
							texto = "protic.trunc(a.ocag_fingreso)"
						end if
						if reg="TSOF_FECHA_VENCIMIENTO_CORTA" then
							texto = "protic.trunc(a.ocag_fingreso)"
						end if
						if reg="TSOF_TIPO_DOC_REFERENCIA" then
							texto ="''"
						end if
						if reg="TSOF_NRO_DOC_REFERENCIA" then
							texto ="CONVERT(VARCHAR(32),a.rgas_ncorr)"
						end if
						if reg="TSOF_NRO_CORRELATIVO" then
							texto = "'"&numeross()&"'"
						end if
						if reg="TSOF_MONTO_DET_LIBRO1" then
							texto = "null"
						end if
						if reg="TSOF_MONTO_DET_LIBRO2" then
							texto = "null"
						end if
						if reg="TSOF_MONTO_DET_LIBRO3" then
							texto = "null"
						end if
						if reg="TSOF_MONTO_SUMA_DET_LIBRO" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_PRESUPUESTO" then
							texto = ""
						end if
						if reg="TSOF_COD_MESANO" then
							texto = "''"
						end if
					CASE 3:
						if reg="TSOF_PLAN_CUENTA" then
							texto = "'1-10-060-10-000002'"
						end if
						if reg="TSOF_DEBE" then
							texto = "d.ccva_mmonto"
						end if
						if reg="TSOF_HABER" then
							texto = "0"
						end if
						if reg="TSOF_GLOSA_SIN_ACENTO" then
							texto = "a.fren_tdescripcion_actividad"
						end if
						if reg="TSOF_EQUIVALENCIA" then
							texto = "''"
						end if
						if reg="TSOF_COD_CONCEPTO_CAJA" then
							texto = "''"
						end if
						if reg="TSOF_COD_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_CANT_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_COD_DETALLE_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_CANT_CONCEPTO_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_COD_CENTRO_COSTO" then
							texto = "e.ccos_tcodigo"
						end if
						if reg="TSOF_TIPO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_NRO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_COD_AUXILIAR" then
							texto = "CONVERT(VARCHAR(32),b.pers_nrut)"
						end if
						if reg="TSOF_TIPO_DOCUMENTO" then
							texto = "'FR'"
						end if
						if reg="TSOF_NRO_DOCUMENTO" then
							texto = "a.fren_ncorr"
						end if
						if reg="TSOF_FECHA_EMISION_CORTA" then
							texto = "protic.trunc(a.ocag_fingreso)"
						end if
						if reg="TSOF_FECHA_VENCIMIENTO_CORTA" then
							texto = "protic.trunc(a.ocag_fingreso)"
						end if
						if reg="TSOF_TIPO_DOC_REFERENCIA" then
							texto ="'FR'"
						end if
						if reg="TSOF_NRO_DOC_REFERENCIA" then
							texto ="a.fren_ncorr"
						end if
						if reg="TSOF_NRO_CORRELATIVO" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO1" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO1" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO2" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO3" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_SUMA_DET_LIBRO" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_PRESUPUESTO" then
							texto = ""
						end if
						if reg="TSOF_COD_MESANO" then
							texto = "''"
						end if
					CASE 4:
						if reg="TSOF_PLAN_CUENTA" then
							texto = "'5-30-020-10-002022'"
						end if
						if reg="TSOF_DEBE" then
							texto = "psol_mpresupuesto "
						end if
						if reg="TSOF_HABER" then
							texto = "0"
						end if
						if reg="TSOF_GLOSA_SIN_ACENTO" then
							texto = "a.sovi_tmotivo"
						end if
						if reg="TSOF_EQUIVALENCIA" then
							texto = "''"
						end if
						if reg="TSOF_COD_CONCEPTO_CAJA" then
							texto = "''"
						end if
						if reg="TSOF_COD_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_CANT_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_COD_DETALLE_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_CANT_CONCEPTO_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_COD_CENTRO_COSTO" then
							texto = "c.cod_pre"
						end if
						if reg="TSOF_TIPO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_NRO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_COD_AUXILIAR" then
							texto = "CONVERT(VARCHAR(32),b.pers_nrut)"
						end if
						if reg="TSOF_TIPO_DOCUMENTO" then
							texto = "'SV'"
						end if
						if reg="TSOF_NRO_DOCUMENTO" then
							texto = "CONVERT(VARCHAR(32),a.sovi_ncorr)"
						end if
						if reg="TSOF_FECHA_EMISION_CORTA" then
							texto = "protic.trunc(a.ocag_fingreso)"
						end if
						if reg="TSOF_FECHA_VENCIMIENTO_CORTA" then
							texto = "protic.trunc(a.ocag_fingreso)"
						end if
						if reg="TSOF_TIPO_DOC_REFERENCIA" then
							texto ="'SV'"
						end if
						if reg="TSOF_NRO_DOC_REFERENCIA" then
							texto ="CONVERT(VARCHAR(32),a.sovi_ncorr)"
						end if
						if reg="TSOF_NRO_CORRELATIVO" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO1" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO1" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO2" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO3" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_SUMA_DET_LIBRO" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_PRESUPUESTO" then
							texto = "''"
						end if
						if reg="TSOF_COD_MESANO" then
							texto = "''"
						end if
					CASE 5:
						if reg="TSOF_PLAN_CUENTA" then
							texto = "'2-10-140-09-120001'"
						end if
						if reg="TSOF_DEBE" then
							texto = "a.dalu_mmonto_pesos"
						end if
						if reg="TSOF_HABER" then
							texto = "0"
						end if
						if reg="TSOF_GLOSA_SIN_ACENTO" then
							texto = "a.dalu_tmotivo"
						end if
						if reg="TSOF_EQUIVALENCIA" then
							texto = "''"
						end if
						if reg="TSOF_COD_CONCEPTO_CAJA" then
							texto = "''"
						end if
						if reg="TSOF_COD_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_CANT_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_COD_DETALLE_GASTO" then
							texto = "'AR-01-02'"
						end if
						if reg="TSOF_CANT_CONCEPTO_GASTO" then
							texto = "'1'"
						end if
						if reg="TSOF_COD_CENTRO_COSTO" then
							texto = "e.ccos_tcodigo"
						end if
						if reg="TSOF_TIPO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_NRO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_COD_AUXILIAR" then
							texto = "''"
						end if
						if reg="TSOF_TIPO_DOCUMENTO" then
							texto = "''"
						end if
						if reg="TSOF_NRO_DOCUMENTO" then
							texto = "''"
						end if
						if reg="TSOF_FECHA_EMISION_CORTA" then
							texto = "''"
						end if
						if reg="TSOF_FECHA_VENCIMIENTO_CORTA" then
							texto = "''"
						end if
						if reg="TSOF_TIPO_DOC_REFERENCIA" then
							texto ="''"
						end if
						if reg="TSOF_NRO_DOC_REFERENCIA" then
							texto ="''"
						end if
						if reg="TSOF_NRO_CORRELATIVO" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO1" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO1" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO2" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO3" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_SUMA_DET_LIBRO" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_PRESUPUESTO" then
							texto = "''"
						end if
						if reg="TSOF_COD_MESANO" then
							texto = "''"
						end if
					CASE 6:
						if reg="TSOF_PLAN_CUENTA" then
							texto = "'1-10-010-20-000003'"
						end if
						if reg="TSOF_DEBE" then
							texto = "a.ffij_mmonto_pesos"
						end if
						if reg="TSOF_HABER" then
							texto = "0"
						end if
						if reg="TSOF_GLOSA_SIN_ACENTO" then
							texto = "a.ffij_tdetalle_presu"
						end if
						if reg="TSOF_EQUIVALENCIA" then
							texto = "''"
						end if
						if reg="TSOF_COD_CONCEPTO_CAJA" then
							texto = "''"
						end if
						if reg="TSOF_COD_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_CANT_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_COD_DETALLE_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_CANT_CONCEPTO_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_COD_CENTRO_COSTO" then
							texto = "e.ccos_tcodigo"
						end if
						if reg="TSOF_TIPO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_NRO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_COD_AUXILIAR" then
							texto = "CONVERT(VARCHAR(32),b.pers_nrut)"
						end if
						if reg="TSOF_TIPO_DOCUMENTO" then
							texto = "'FF'"
						end if
						if reg="TSOF_NRO_DOCUMENTO" then
							texto = "CONVERT(VARCHAR(32),a.ffij_ncorr)"
						end if
						if reg="TSOF_FECHA_EMISION_CORTA" then
							texto = "protic.trunc(a.ocag_fingreso)"
						end if
						if reg="TSOF_FECHA_VENCIMIENTO_CORTA" then
							texto = "protic.trunc(a.ocag_fingreso)"
						end if
						if reg="TSOF_TIPO_DOC_REFERENCIA" then
							texto ="'FF'"
						end if
						if reg="TSOF_NRO_DOC_REFERENCIA" then
							texto ="CONVERT(VARCHAR(32),a.ffij_ncorr)"
						end if
						if reg="TSOF_NRO_CORRELATIVO" then
							texto = "'"&numeross()&"'"
						end if
						if reg="TSOF_MONTO_DET_LIBRO1" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO1" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO2" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO3" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_SUMA_DET_LIBRO" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_PRESUPUESTO" then
							texto = "''"
						end if
						if reg="TSOF_COD_MESANO" then
							texto = "''"
						end if
					CASE 7:
						if reg="TSOF_PLAN_CUENTA" then
							texto = "d.tgas_cod_cuenta"
						end if
						if reg="TSOF_DEBE" then
							texto = "c.drfr_mdocto"
						end if
						if reg="TSOF_HABER" then
							texto = "'0'"
						end if
						if reg="TSOF_GLOSA_SIN_ACENTO" then
							texto = "d.tgas_tdesc"
						end if
						if reg="TSOF_EQUIVALENCIA" then
							texto = "''"
						end if
						if reg="TSOF_COD_CONCEPTO_CAJA" then
							texto = "''"
						end if
						if reg="TSOF_COD_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_CANT_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_COD_DETALLE_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_CANT_CONCEPTO_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_COD_CENTRO_COSTO" then
							texto = "e.ccos_tcodigo"
						end if
						if reg="TSOF_TIPO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_NRO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_COD_AUXILIAR" then
							texto = "CONVERT(VARCHAR(32),b.PERS_NRUT)"
						end if
						if reg="TSOF_TIPO_DOCUMENTO" then
							texto = "'RFF'"
						end if
						if reg="TSOF_NRO_DOCUMENTO" then
							texto = "CONVERT(VARCHAR(32),z.rfre_ncorr)"
						end if
						if reg="TSOF_FECHA_EMISION_CORTA" then
							texto = "''"
						end if
						if reg="TSOF_FECHA_VENCIMIENTO_CORTA" then
							texto = "''"
						end if
						if reg="TSOF_TIPO_DOC_REFERENCIA" then
							texto ="''"
						end if
						if reg="TSOF_NRO_DOC_REFERENCIA" then
							texto ="CONVERT(VARCHAR(32),z.fren_ncorr)"
						end if
						if reg="TSOF_NRO_CORRELATIVO" then
							texto = "'"&numeross()&"'"
						end if
						if reg="TSOF_MONTO_DET_LIBRO1" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO1" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO2" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO3" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_SUMA_DET_LIBRO" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_PRESUPUESTO" then
							texto = "z.psol_mpresupuesto"
						end if
						if reg="TSOF_COD_MESANO" then
							texto = "''"
						end if
					CASE 8:
						if reg="TSOF_PLAN_CUENTA" then
							texto = "d.tgas_cod_cuenta"
						end if
						if reg="TSOF_DEBE" then
							texto = "w.drff_mdocto"
						end if
						if reg="TSOF_HABER" then
							texto = "0"
						end if
						if reg="TSOF_GLOSA_SIN_ACENTO" then
							texto = "d.tgas_tdesc"
						end if
						if reg="TSOF_EQUIVALENCIA" then
							texto = "''"
						end if
						if reg="TSOF_COD_CONCEPTO_CAJA" then
							texto = "''"
						end if
						if reg="TSOF_COD_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_CANT_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_COD_DETALLE_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_CANT_CONCEPTO_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_COD_CENTRO_COSTO" then
							texto = "y.ccos_tcodigo"
						end if
						if reg="TSOF_TIPO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_NRO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_COD_AUXILIAR" then
							texto = "CONVERT(VARCHAR(32),b.pers_nrut)"
						end if
						if reg="TSOF_TIPO_DOCUMENTO" then
							texto = "'RFF'"
						end if
						if reg="TSOF_NRO_DOCUMENTO" then
							texto = "CONVERT(VARCHAR(32),a.ffij_ncorr)"
						end if
						if reg="TSOF_FECHA_EMISION_CORTA" then
							texto = "CONVERT(VARCHAR(32),protic.trunc(z.ocag_fingreso))"
						end if
						if reg="TSOF_FECHA_VENCIMIENTO_CORTA" then
							texto = "CONVERT(VARCHAR(32),protic.trunc(z.ocag_fingreso))"
						end if
						if reg="TSOF_TIPO_DOC_REFERENCIA" then
							texto ="'RFF'"
						end if
						if reg="TSOF_NRO_DOC_REFERENCIA" then
							texto ="CONVERT(VARCHAR(32),a.ffij_ncorr)"
						end if
						if reg="TSOF_NRO_CORRELATIVO" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO1" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO2" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO3" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_SUMA_DET_LIBRO" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_PRESUPUESTO" then
							texto = "''"
						end if
						if reg="TSOF_COD_MESANO" then
							texto = "''"
						end if
				end select
			CASE 2:
				select case solicitud
					CASE 1:
						select case bole
							case 1:
								if reg="TSOF_PLAN_CUENTA" then
									texto = "1, CASE WHEN a.cpag_ccod = 25 THEN '1-10-010-30-100001' ELSE '2-10-070-10-000002' END"
								end if
								if reg="TSOF_DEBE" then
									texto = "0"
								end if
								if reg="TSOF_HABER" then
									texto = "a.sogi_mgiro"
								end if
								if reg="TSOF_GLOSA_SIN_ACENTO" then
									texto = "a.sogi_tobservaciones"
								end if
								if reg="TSOF_EQUIVALENCIA" then
									texto = "''"
								end if
								if reg="TSOF_COD_CONCEPTO_CAJA" then
									texto = "''"
								end if
								if reg="TSOF_COD_INSTRUMENTO_FINAN" then
									texto = "''"
								end if
								if reg="TSOF_CANT_INSTRUMENTO_FINAN" then
									texto = "''"
								end if
								if reg="TSOF_COD_DETALLE_GASTO" then
									texto = "''"
								end if
								if reg="TSOF_CANT_CONCEPTO_GASTO" then
									texto = "''"
								end if
								if reg="TSOF_COD_CENTRO_COSTO" then
									texto = "''"
								end if
								if reg="TSOF_TIPO_DOC_CONCILIACION" then
									texto = "''"
								end if
								if reg="TSOF_NRO_DOC_CONCILIACION" then
									texto = "''"
								end if
								if reg="TSOF_COD_AUXILIAR" then
									texto = "CAST(b.pers_nrut AS VARCHAR)"
								end if
								if reg="TSOF_TIPO_DOCUMENTO" then
									texto = "LTRIM(RTRIM('bc'))"
								end if
								if reg="TSOF_NRO_DOCUMENTO" then
									texto = "CAST(a.sogi_ncorr AS VARCHAR)"
								end if
								if reg="TSOF_FECHA_EMISION_CORTA" then
									texto = "protic.trunc(a.sogi_fecha_solicitud)"
								end if
								if reg="TSOF_FECHA_VENCIMIENTO_CORTA" then
									texto = "protic.trunc(f.dpva_fpago)"
								end if
								if reg="TSOF_TIPO_DOC_REFERENCIA" then
									texto ="LTRIM(RTRIM('BC'))"
								end if
								if reg="TSOF_NRO_DOC_REFERENCIA" then
									texto ="CAST(a.sogi_ncorr AS VARCHAR)"
								end if
								if reg="TSOF_NRO_CORRELATIVO" then
									texto = "'"&numeross()&"'"
								end if
								if reg="TSOF_MONTO_DET_LIBRO1" then
									texto = "null"
								end if
								if reg="TSOF_MONTO_DET_LIBRO2" then
									texto = "null"
								end if
								if reg="TSOF_MONTO_DET_LIBRO3" then
									texto = "null"
								end if
								if reg="TSOF_MONTO_SUMA_DET_LIBRO" then
									texto = "null"
								end if
								if reg="TSOF_MONTO_PRESUPUESTO" then
									texto = ""
								end if
								if reg="TSOF_COD_MESANO" then
									texto = "''"
								end if
							case 2:
								if reg="TSOF_PLAN_CUENTA" then
									texto = "CASE WHEN a.cpag_ccod = 25 THEN '1-10-010-30-100001' ELSE '2-10-070-10-000002' END"
								end if
								if reg="TSOF_DEBE" then
									texto = "0"
								end if
								if reg="TSOF_HABER" then
									texto = "a.sogi_mgiro"
								end if
								if reg="TSOF_GLOSA_SIN_ACENTO" then
									texto = "a.sogi_tobservaciones"
								end if
								if reg="TSOF_EQUIVALENCIA" then
									texto = "''"
								end if
								if reg="TSOF_COD_CONCEPTO_CAJA" then
									texto = "''"
								end if
								if reg="TSOF_COD_INSTRUMENTO_FINAN" then
									texto = "''"
								end if
								if reg="TSOF_CANT_INSTRUMENTO_FINAN" then
									texto = "''"
								end if
								if reg="TSOF_COD_DETALLE_GASTO" then
									texto = "''"
								end if
								if reg="TSOF_CANT_CONCEPTO_GASTO" then
									texto = "''"
								end if
								if reg="TSOF_COD_CENTRO_COSTO" then
									texto = "''"
								end if
								if reg="TSOF_TIPO_DOC_CONCILIACION" then
									texto = "''"
								end if
								if reg="TSOF_NRO_DOC_CONCILIACION" then
									texto = "''"
								end if
								if reg="TSOF_COD_AUXILIAR" then
									texto = "CAST(b.pers_nrut AS VARCHAR)"
								end if
								if reg="TSOF_TIPO_DOCUMENTO" then
									texto = "LTRIM(RTRIM('bc'))"
								end if
								if reg="TSOF_NRO_DOCUMENTO" then
									texto = "CAST(a.sogi_ncorr AS VARCHAR)"
								end if
								if reg="TSOF_FECHA_EMISION_CORTA" then
									texto = "protic.trunc(a.sogi_fecha_solicitud)"
								end if
								if reg="TSOF_FECHA_VENCIMIENTO_CORTA" then
									texto = "protic.trunc(d.dpva_fpago)"
								end if
								if reg="TSOF_TIPO_DOC_REFERENCIA" then
									texto ="LTRIM(RTRIM('BC'))"
								end if
								if reg="TSOF_NRO_DOC_REFERENCIA" then
									texto ="CAST(a.sogi_ncorr AS VARCHAR)"
								end if
								if reg="TSOF_NRO_CORRELATIVO" then
									texto = "'"&numeross()&"'"
								end if
								if reg="TSOF_MONTO_DET_LIBRO1" then
									texto = "null"
								end if
								if reg="TSOF_MONTO_DET_LIBRO2" then
									texto = "null"
								end if
								if reg="TSOF_MONTO_DET_LIBRO3" then
									texto = "null"
								end if
								if reg="TSOF_MONTO_SUMA_DET_LIBRO" then
									texto = "null"
								end if
								if reg="TSOF_MONTO_PRESUPUESTO" then
									texto = ""
								end if
								if reg="TSOF_COD_MESANO" then
									texto = "''"
								end if
						end select
					CASE 2:
						if reg="TSOF_PLAN_CUENTA" then
							texto = "'2-10-070-10-000002'"
						end if
						if reg="TSOF_DEBE" then
							texto = "0"
						end if
						if reg="TSOF_HABER" then
							texto = "a.rgas_mgiro"
						end if
						if reg="TSOF_GLOSA_SIN_ACENTO" then
							texto = "c.drga_tdescripcion"
						end if
						if reg="TSOF_EQUIVALENCIA" then
							texto = "''"
						end if
						if reg="TSOF_COD_CONCEPTO_CAJA" then
							texto = "''"
						end if
						if reg="TSOF_COD_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_CANT_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_COD_DETALLE_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_CANT_CONCEPTO_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_COD_CENTRO_COSTO" then
							texto = "''"
						end if
						if reg="TSOF_TIPO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_NRO_DOC_CONCILIACION" then
							texto = "CONVERT(VARCHAR(32),a.rgas_ncorr)"
						end if
						if reg="TSOF_COD_AUXILIAR" then
							texto = "CONVERT(VARCHAR(32),b.pers_nrut)"
						end if
						if reg="TSOF_TIPO_DOCUMENTO" then
							texto = "'BC'"
						end if
						if reg="TSOF_NRO_DOCUMENTO" then
							texto = "CONVERT(VARCHAR(32),a.rgas_ncorr)"
						end if
						if reg="TSOF_FECHA_EMISION_CORTA" then
							texto = "protic.trunc(a.ocag_fingreso)"
						end if
						if reg="TSOF_FECHA_VENCIMIENTO_CORTA" then
							texto = "protic.trunc(a.ocag_fingreso)"
						end if
						if reg="TSOF_TIPO_DOC_REFERENCIA" then
							texto ="'BC'"
						end if
						if reg="TSOF_NRO_DOC_REFERENCIA" then
							texto ="CONVERT(VARCHAR(32),a.rgas_ncorr)"
						end if
						if reg="TSOF_NRO_CORRELATIVO" then
							texto = "'"&numeross()&"'"
						end if
						if reg="TSOF_MONTO_DET_LIBRO1" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO1" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO2" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO3" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_SUMA_DET_LIBRO" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_PRESUPUESTO" then
							texto = "''"
						end if
						if reg="TSOF_COD_MESANO" then
							texto = "''"
						end if
				case 3:
						if reg="TSOF_PLAN_CUENTA" then
							texto = "'2-10-070-10-000002'"
						end if
						if reg="TSOF_DEBE" then
							texto = "0"
						end if
						if reg="TSOF_HABER" then
							texto = "fren_mmonto"
						end if
						if reg="TSOF_GLOSA_SIN_ACENTO" then
							texto = "a.fren_tdescripcion_actividad"
						end if
						if reg="TSOF_EQUIVALENCIA" then
							texto = "''"
						end if
						if reg="TSOF_COD_CONCEPTO_CAJA" then
							texto = "''"
						end if
						if reg="TSOF_COD_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_CANT_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_COD_DETALLE_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_CANT_CONCEPTO_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_COD_CENTRO_COSTO" then
							texto = "''"
						end if
						if reg="TSOF_TIPO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_NRO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_COD_AUXILIAR" then
							texto = "CONVERT(VARCHAR(32),b.pers_nrut)"
						end if
						if reg="TSOF_TIPO_DOCUMENTO" then
							texto = "'BC'"
						end if
						if reg="TSOF_NRO_DOCUMENTO" then
							texto = "a.fren_ncorr"
						end if
						if reg="TSOF_FECHA_EMISION_CORTA" then
							texto = "protic.trunc(a.ocag_fingreso)"
						end if
						if reg="TSOF_FECHA_VENCIMIENTO_CORTA" then
							texto = "protic.trunc(x.dpva_fpago)"
						end if
						if reg="TSOF_TIPO_DOC_REFERENCIA" then
							texto ="'BC'"
						end if
						if reg="TSOF_NRO_DOC_REFERENCIA" then
							texto ="a.fren_ncorr"
						end if
						if reg="TSOF_NRO_CORRELATIVO" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO1" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO1" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO2" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO3" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_SUMA_DET_LIBRO" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_PRESUPUESTO" then
							texto = ""
						end if
						if reg="TSOF_COD_MESANO" then
							texto = "''"
						end if
					CASE 4:
						if reg="TSOF_PLAN_CUENTA" then
							texto = "'2-10-070-10-000002'"
						end if
						if reg="TSOF_DEBE" then
							texto = "0"
						end if
						if reg="TSOF_HABER" then
							texto = "a.sovi_mmonto_pesos"
						end if
						if reg="TSOF_GLOSA_SIN_ACENTO" then
							texto = "a.sovi_tmotivo"
						end if
						if reg="TSOF_EQUIVALENCIA" then
							texto = "''"
						end if
						if reg="TSOF_COD_CONCEPTO_CAJA" then
							texto = "''"
						end if
						if reg="TSOF_COD_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_CANT_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_COD_DETALLE_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_CANT_CONCEPTO_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_COD_CENTRO_COSTO" then
							texto = "''"
						end if
						if reg="TSOF_TIPO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_NRO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_COD_AUXILIAR" then
							texto = "CONVERT(VARCHAR(32),b.pers_nrut)"
						end if
						if reg="TSOF_TIPO_DOCUMENTO" then
							texto = "'BC'"
						end if
						if reg="TSOF_NRO_DOCUMENTO" then
							texto = "CONVERT(VARCHAR(32),a.sovi_ncorr)"
						end if
						if reg="TSOF_FECHA_EMISION_CORTA" then
							texto = "protic.trunc(a.ocag_fingreso)"
						end if
						if reg="TSOF_FECHA_VENCIMIENTO_CORTA" then
							texto = "protic.trunc(a.ocag_fingreso)"
						end if
						if reg="TSOF_TIPO_DOC_REFERENCIA" then
							texto ="'BC'"
						end if
						if reg="TSOF_NRO_DOC_REFERENCIA" then
							texto ="CONVERT(VARCHAR(32),a.sovi_ncorr)"
						end if
						if reg="TSOF_NRO_CORRELATIVO" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO1" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO1" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO2" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO3" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_SUMA_DET_LIBRO" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_PRESUPUESTO" then
							texto = "''"
						end if
						if reg="TSOF_COD_MESANO" then
							texto = "''"
						end if
					CASE 5:
						if reg="TSOF_PLAN_CUENTA" then
							texto = "'2-10-070-10-000002'"
						end if
						if reg="TSOF_DEBE" then
							texto = "0"
						end if
						if reg="TSOF_HABER" then
							texto = "dalu_mmonto_pesos"
						end if
						if reg="TSOF_GLOSA_SIN_ACENTO" then
							texto = "a.dalu_tmotivo"
						end if
						if reg="TSOF_EQUIVALENCIA" then
							texto = "''"
						end if
						if reg="TSOF_COD_CONCEPTO_CAJA" then
							texto = "''"
						end if
						if reg="TSOF_COD_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_CANT_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_COD_DETALLE_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_CANT_CONCEPTO_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_COD_CENTRO_COSTO" then
							texto = "''"
						end if
						if reg="TSOF_TIPO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_NRO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_COD_AUXILIAR" then
							texto = "cast(b.pers_nrut as varchar)"
						end if
						if reg="TSOF_TIPO_DOCUMENTO" then
							texto = "'BC'"
						end if
						if reg="TSOF_NRO_DOCUMENTO" then
							texto = "CAST(a.dalu_ncorr AS VARCHAR)"
						end if
						if reg="TSOF_FECHA_EMISION_CORTA" then
							texto = "protic.trunc(a.ocag_fingreso)"
						end if
						if reg="TSOF_FECHA_VENCIMIENTO_CORTA" then
							texto = "protic.trunc(x.dpva_fpago)"
						end if
						if reg="TSOF_TIPO_DOC_REFERENCIA" then
							texto ="'BC'"
						end if
						if reg="TSOF_NRO_DOC_REFERENCIA" then
							texto ="CAST(a.dalu_ncorr AS VARCHAR)"
						end if
						if reg="TSOF_NRO_CORRELATIVO" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO1" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO1" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO2" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO3" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_SUMA_DET_LIBRO" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_PRESUPUESTO" then
							texto = "''"
						end if
						if reg="TSOF_COD_MESANO" then
							texto = "''"
						end if
					CASE 6:
						if reg="TSOF_PLAN_CUENTA" then
							texto = "'2-10-070-10-000002'"
						end if
						if reg="TSOF_DEBE" then
							texto = "0"
						end if
						if reg="TSOF_HABER" then
							texto = "a.ffij_mmonto_pesos"
						end if
						if reg="TSOF_GLOSA_SIN_ACENTO" then
							texto = "a.ffij_tdetalle_presu"
						end if
						if reg="TSOF_EQUIVALENCIA" then
							texto = "''"
						end if
						if reg="TSOF_COD_CONCEPTO_CAJA" then
							texto = "''"
						end if
						if reg="TSOF_COD_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_CANT_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_COD_DETALLE_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_CANT_CONCEPTO_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_COD_CENTRO_COSTO" then
							texto = "''"
						end if
						if reg="TSOF_TIPO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_NRO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_COD_AUXILIAR" then
							texto = "CONVERT(VARCHAR(32),b.pers_nrut)"
						end if
						if reg="TSOF_TIPO_DOCUMENTO" then
							texto = "'BC'"
						end if
						if reg="TSOF_NRO_DOCUMENTO" then
							texto = "CONVERT(VARCHAR(32),a.ffij_ncorr)"
						end if
						if reg="TSOF_FECHA_EMISION_CORTA" then
							texto = "protic.trunc(a.ocag_fingreso)"
						end if
						if reg="TSOF_FECHA_VENCIMIENTO_CORTA" then
							texto = "protic.trunc(x.dpva_fpago)"
						end if
						if reg="TSOF_TIPO_DOC_REFERENCIA" then
							texto ="'BC'"
						end if
						if reg="TSOF_NRO_DOC_REFERENCIA" then
							texto ="CONVERT(VARCHAR(32),a.ffij_ncorr)"
						end if
						if reg="TSOF_NRO_CORRELATIVO" then
							texto = "'"&numeross()&"'"
						end if
						if reg="TSOF_MONTO_DET_LIBRO1" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO1" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO2" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO3" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_SUMA_DET_LIBRO" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_PRESUPUESTO" then
							texto = "''"
						end if
						if reg="TSOF_COD_MESANO" then
							texto = "''"
						end if
					CASE 7:
						if reg="TSOF_PLAN_CUENTA" then
							texto = "'1-10-060-10-000002'"
						end if
						if reg="TSOF_DEBE" then
							texto = "'0'"
						end if
						if reg="TSOF_HABER" then
							texto = "z.rfre_mmonto"
						end if
						if reg="TSOF_GLOSA_SIN_ACENTO" then
							texto = "c.drfr_tdesc"
						end if
						if reg="TSOF_EQUIVALENCIA" then
							texto = "''"
						end if
						if reg="TSOF_COD_CONCEPTO_CAJA" then
							texto = "''"
						end if
						if reg="TSOF_COD_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_CANT_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_COD_DETALLE_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_CANT_CONCEPTO_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_COD_CENTRO_COSTO" then
							texto = "e.ccos_tcodigo"
						end if
						if reg="TSOF_TIPO_DOC_CONCILIACION" then
							texto = ""
						end if
						if reg="TSOF_NRO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_COD_AUXILIAR" then
							texto = "CONVERT(VARCHAR(32),b.PERS_NRUT)"
						end if
						if reg="TSOF_TIPO_DOCUMENTO" then
							texto = "'TR'"
						end if
						if reg="TSOF_NRO_DOCUMENTO" then
							texto = "CONVERT(VARCHAR(32),z.rfre_ncorr)"
						end if
						if reg="TSOF_FECHA_EMISION_CORTA" then
							texto = "CONVERT(VARCHAR(32),protic.trunc(c.drfr_fdocto))"
						end if
						if reg="TSOF_FECHA_VENCIMIENTO_CORTA" then
							texto = "CONVERT(VARCHAR(32),protic.trunc(c.drfr_fdocto))"
						end if
						if reg="TSOF_TIPO_DOC_REFERENCIA" then
							texto ="'FR'"
						end if
						if reg="TSOF_NRO_DOC_REFERENCIA" then
							texto ="CONVERT(VARCHAR(32),z.fren_ncorr)"
						end if
						if reg="TSOF_NRO_CORRELATIVO" then
							texto = "'"&numeross()&"'"
						end if
						if reg="TSOF_MONTO_DET_LIBRO1" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO2" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO3" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_SUMA_DET_LIBRO" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_PRESUPUESTO" then
							texto = "''"
						end if
						if reg="TSOF_COD_MESANO" then
							texto = "''"
						end if
					CASE 8:
						if reg="TSOF_PLAN_CUENTA" then
							texto = "'2-10-070-10-000002'"
						end if
						if reg="TSOF_DEBE" then
							texto = "0"
						end if
						if reg="TSOF_HABER" then
							texto = "CONVERT(INT, ROUND((SELECT SUM(CASE WHEN tdoc_ccod = 11 THEN odff.drff_mdocto*0.9 ELSE odff.drff_mdocto END) FROM ocag_detalle_rendicion_fondo_fijo odff WHERE rffi_ncorr=42),0))"
						end if
						if reg="TSOF_GLOSA_SIN_ACENTO" then
							texto = "d.tgas_tdesc"
						end if
						if reg="TSOF_EQUIVALENCIA" then
							texto = "''"
						end if
						if reg="TSOF_COD_CONCEPTO_CAJA" then
							texto = "''"
						end if
						if reg="TSOF_COD_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_CANT_INSTRUMENTO_FINAN" then
							texto = "''"
						end if
						if reg="TSOF_COD_DETALLE_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_CANT_CONCEPTO_GASTO" then
							texto = "''"
						end if
						if reg="TSOF_COD_CENTRO_COSTO" then
							texto = "''"
						end if
						if reg="TSOF_TIPO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_NRO_DOC_CONCILIACION" then
							texto = "''"
						end if
						if reg="TSOF_COD_AUXILIAR" then
							texto = "CONVERT(VARCHAR(32),b.pers_nrut)"
						end if
						if reg="TSOF_TIPO_DOCUMENTO" then
							texto = "'BC'"
						end if
						if reg="TSOF_NRO_DOCUMENTO" then
							texto = "CONVERT(VARCHAR(32),a.ffij_ncorr)"
						end if
						if reg="TSOF_FECHA_EMISION_CORTA" then
							texto = "CONVERT(VARCHAR(32),protic.trunc(a.ocag_fingreso))"
						end if
						if reg="TSOF_FECHA_VENCIMIENTO_CORTA" then
							texto = "CONVERT(VARCHAR(32),protic.trunc(a.ocag_fingreso))"
						end if
						if reg="TSOF_TIPO_DOC_REFERENCIA" then
							texto ="'BC'"
						end if
						if reg="TSOF_NRO_DOC_REFERENCIA" then
							texto ="CONVERT(VARCHAR(32),a.ffij_ncorr)"
						end if
						if reg="TSOF_NRO_CORRELATIVO" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO1" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO2" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_DET_LIBRO3" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_SUMA_DET_LIBRO" then
							texto = "''"
						end if
						if reg="TSOF_MONTO_PRESUPUESTO" then
							texto = "''"
						end if
						if reg="TSOF_COD_MESANO" then
							texto = "''"
						end if
				end select
		end select
		registros = texto
	end function
	
	function numerodetallesql(solicitud, numero)
		'---------- CONEXION A SOFTLAND ----------'
		set conectar2 = new Cconexion
		conectar2.Inicializar "upacifico"
	
		'---------- CREAR FORMULARIO ----------'
		set grilla5 = new CFormulario
		grilla5.Carga_Parametros "tabla_vacia.xml", "tabla"
		select case solicitud
			CASE 7:
				sql="SELECT fren_ncorr AS valor FROM ocag_detalle_rendicion_fondo_rendir WHERE rfre_ncorr="&numero
			case else: 
				sql="SELECT TOP 1 '1' AS valor FROM personas"
		end select
		grilla5.Inicializar conectar2
		grilla5.CONSULTAR sql
		grilla5.siguiente
		numerodetallesql= grilla5.obtenerValor("valor")
	end function
	
	function codigoverificardetalle(solicitud, numer, dife,est)
		numeros=numerodetallesql(solicitud, numer)
		diferencia=dife
		if diferencia>0 then
			codigopre = "2-10-070-10-000004"
		else
			if diferencia <0 then
				codigopre = "2-10-070-10-000003"
			end if
		end if
		valor = " select * from ("
		select case solicitud
			case 1:
				if est then
					valor = valor + " select 0 AS numero, '2-10-070-10-000004' as tsof_plan_cuenta, a.sogi_mgiro as tsof_debe, 0 as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO , c.pers_nrut as TSOF_COD_AUXILIAR, 'TR' as TSOF_TIPO_DOCUMENTO, a.sogi_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(a.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA , protic.trunc(a.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, a.sogi_ncorr AS TSOF_NRO_DOC_REFERENCIA , '' as TSOF_COD_CENTRO_COSTO, a.cod_pre as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR , CASE WHEN MONTH(a.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(a.ocag_fingreso) AS VARCHAR) + CAST(YEAR(a.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano , a.sogi_mgiro as TSOF_monto_presupuesto"&_
						" from ocag_solicitud_giro a"&_
						" INNER JOIN personas c ON a.pers_ncorr_proveedor=c.pers_ncorr"&_
						" INNER JOIN ocag_detalle_solicitud_giro d ON d.sogi_ncorr=a.sogi_ncorr"&_
						" INNER JOIN ocag_tipo_documento e ON e.tdoc_ccod=d.tdoc_ccod"&_
						" WHERE a.sogi_ncorr="&numer&_
						" union "& vbCrLf &_
						" select 0 AS numero, '2-10-070-10-000004' as tsof_plan_cuenta, 0 as tsof_debe, a.sogi_mgiro as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO , c.pers_nrut as TSOF_COD_AUXILIAR, 'BC' as TSOF_TIPO_DOCUMENTO, a.sogi_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(a.ocag_fingreso)as TSOF_FECHA_EMISION_CORTA , protic.trunc(a.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, a.sogi_ncorr AS TSOF_NRO_DOC_REFERENCIA , '' as TSOF_COD_CENTRO_COSTO, a.cod_pre as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR , CASE WHEN MONTH(a.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(a.ocag_fingreso) AS VARCHAR) + CAST(YEAR(a.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano , a.sogi_mgiro as TSOF_monto_presupuesto"&_
						" from ocag_solicitud_giro a"&_
						" INNER JOIN personas c ON a.pers_ncorr_proveedor=c.pers_ncorr "&_
						" INNER JOIN ocag_detalle_solicitud_giro d ON d.sogi_ncorr=a.sogi_ncorr "&_
						" INNER JOIN ocag_tipo_documento e ON e.tdoc_ccod=d.tdoc_ccod"&_
						" WHERE a.sogi_ncorr="&numer
				else
					valor = valor +" select 0 AS numero, '2-10-070-10-000002' as tsof_plan_cuenta,d.dsgi_mdocto as tsof_debe, 0 as TSOF_HABER,"&_
						" protic.extrae_acentos(LTRIM(RTRIM(b.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO"&_
						" , NULL AS TSOF_COD_CONCEPTO_CAJA, c.pers_nrut as TSOF_COD_AUXILIAR,"&_
						"'TR' as TSOF_TIPO_DOCUMENTO, d.dsgi_ndocto as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA"&_
						" , protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA,"&_
						"otd.tdoc_tdesc_softland AS TSOF_TIPO_DOC_REFERENCIA, d.dsgi_ndocto AS TSOF_NRO_DOC_REFERENCIA"&_
						" , '' as TSOF_COD_CENTRO_COSTO"&_
						" , "&numeross()&" AS TSOF_NRO_CORRELATIVO"&_
						" , CASE WHEN otd.tdoc_tdesc_softland='FI' THEN d.dsgi_mdocto + d.dsgi_mretencion ELSE NULL END AS TSOF_MONTO_DET_LIBRO1"&_
						" ,CASE WHEN otd.tdoc_tdesc_softland='FI' THEN null ELSE d.dsgi_mdocto +d.dsgi_mretencion END AS TSOF_MONTO_DET_LIBRO2"&_
						" ,CASE WHEN otd.tdoc_tdesc_softland='FI' THEN null ELSE d.dsgi_mretencion END AS TSOF_MONTO_DET_LIBRO3"&_
						" , '' AS TSOF_MONTO_DET_LIBRO4"&_
						" , '' AS TSOF_MONTO_DET_LIBRO5"&_
						" , '' AS TSOF_MONTO_DET_LIBRO6"&_
						" , '' AS TSOF_MONTO_DET_LIBRO7"&_
						" , '' AS TSOF_MONTO_DET_LIBRO8"&_
						" , '' AS TSOF_MONTO_DET_LIBRO9"&_
						" , CASE WHEN otd.tdoc_tdesc_softland='FI' THEN d.dsgi_mdocto + d.dsgi_mretencion ELSE d.dsgi_mdocto END as TSOF_MONTO_SUMA_DET_LIBRO"&_
						" , 1 AS TSOF_NRO_AGRUPADOR"&_
						" , CASE WHEN otd.tdoc_tdesc_softland='BC' THEN CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) ELSE NULL END AS TSOF_cod_mesano"&_
						" , CASE WHEN otd.tdoc_tdesc_softland='BC' THEN d.dsgi_mdocto END AS TSOF_monto_presupuesto"&_
						" from ocag_presupuesto_solicitud a"&_
						" INNER JOIN ocag_solicitud_giro b ON a.cod_solicitud = b.sogi_ncorr AND cod_solicitud = "&numer&" AND a.tsol_ccod = 1"&_
						" INNER JOIN ocag_detalle_solicitud_giro d ON b.sogi_ncorr = d.sogi_ncorr"&_
						" INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr"&_
						" INNER JOIN ocag_tipo_documento otd ON otd.tdoc_ccod=d.tdoc_ccod"& vbCrLf &_
						" union  "&_
						" select 0 AS numero, '2-10-070-10-000002' as tsof_plan_cuenta, 0 as tsof_debe, d.dsgi_mdocto as TSOF_HABER,"&_
						" protic.extrae_acentos(LTRIM(RTRIM(b.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO"&_
						" , NULL AS TSOF_COD_CONCEPTO_CAJA, c.pers_nrut as TSOF_COD_AUXILIAR, otd.tdoc_tdesc_softland as TSOF_TIPO_DOCUMENTO, d.dsgi_ndocto as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA"&_
						" , protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, otd.tdoc_tdesc_softland AS TSOF_TIPO_DOC_REFERENCIA, d.dsgi_ndocto AS TSOF_NRO_DOC_REFERENCIA"&_
						" , '' as TSOF_COD_CENTRO_COSTO"&_
						" , "&numeross()&" AS TSOF_NRO_CORRELATIVO"&_
						" , CASE WHEN otd.tdoc_tdesc_softland='FI' THEN d.dsgi_mdocto + d.dsgi_mretencion ELSE NULL END AS TSOF_MONTO_DET_LIBRO1"&_
						" ,CASE WHEN otd.tdoc_tdesc_softland='FI' THEN null ELSE d.dsgi_mdocto + d.dsgi_mretencion END AS TSOF_MONTO_DET_LIBRO2"&_
						" ,CASE WHEN otd.tdoc_tdesc_softland='FI' THEN null ELSE d.dsgi_mretencion END AS TSOF_MONTO_DET_LIBRO3"&_
						" , '' AS TSOF_MONTO_DET_LIBRO4"&_
						" , '' AS TSOF_MONTO_DET_LIBRO5"&_
						" , '' AS TSOF_MONTO_DET_LIBRO6"&_
						" , '' AS TSOF_MONTO_DET_LIBRO7"&_
						" , '' AS TSOF_MONTO_DET_LIBRO8"&_
						" , '' AS TSOF_MONTO_DET_LIBRO9"&_
						" , CASE WHEN otd.tdoc_tdesc_softland='FI' THEN d.dsgi_mdocto + d.dsgi_mretencion ELSE d.dsgi_mdocto END as TSOF_MONTO_SUMA_DET_LIBRO"&_
						" , 1 AS TSOF_NRO_AGRUPADOR"&_
						" , CASE WHEN otd.tdoc_tdesc_softland='BC' THEN CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) ELSE NULL END AS TSOF_cod_mesano"&_
						" , CASE WHEN otd.tdoc_tdesc_softland='BC' THEN d.dsgi_mdocto END AS TSOF_monto_presupuesto"&_
						" from ocag_presupuesto_solicitud a"&_
						" INNER JOIN ocag_solicitud_giro b ON a.cod_solicitud = b.sogi_ncorr AND cod_solicitud = "&numer&" AND a.tsol_ccod = 1"&_
						" INNER JOIN ocag_detalle_solicitud_giro d ON b.sogi_ncorr = d.sogi_ncorr"&_
						" INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr"&_
						" INNER JOIN ocag_tipo_documento otd ON otd.tdoc_ccod=d.tdoc_ccod"& vbCrLf &_
						" UNION "&_
						" select DISTINCT 1 AS numero, '2-10-070-10-000004' as tsof_plan_cuenta, osa.dorc_nprecio_neto as tsof_debe, 0 as TSOF_HABER, "&_
						" protic.extrae_acentos(LTRIM(RTRIM((SELECT TOP 1 dorc_tdesc FROM ocag_detalle_solicitud_ag WHERE sogi_ncorr="&numer&")))) as TSOF_GLOSA_SIN_ACENTO, a.cod_pre AS TSOF_COD_CONCEPTO_CAJA, c.pers_nrut as TSOF_COD_AUXILIAR,"&_
						" 'TR' as TSOF_TIPO_DOCUMENTO, b.sogi_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA, "&_
						" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, "&_
						" b.sogi_ncorr AS TSOF_NRO_DOC_REFERENCIA  , '' as TSOF_COD_CENTRO_COSTO , NULL AS TSOF_NRO_CORRELATIVO, "&_
						" NULL AS TSOF_MONTO_DET_LIBRO1,"&_
						" NULL AS TSOF_MONTO_DET_LIBRO2,"&_
						" NULL TSOF_MONTO_DET_LIBRO3,"&_
						" '' AS TSOF_MONTO_DET_LIBRO4, '' AS TSOF_MONTO_DET_LIBRO5, '' AS TSOF_MONTO_DET_LIBRO6, '' AS TSOF_MONTO_DET_LIBRO7, "&_
						" '' AS TSOF_MONTO_DET_LIBRO8, '' AS TSOF_MONTO_DET_LIBRO9, NULL as TSOF_MONTO_SUMA_DET_LIBRO, "&_
						" 1 AS TSOF_NRO_AGRUPADOR  , "&_
						" CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) TSOF_cod_mesano, "&_
						" osa.dorc_nprecio_neto AS TSOF_monto_presupuesto  "&_
						" from ocag_presupuesto_solicitud a "&_
						" INNER JOIN ocag_solicitud_giro b ON a.cod_solicitud = b.sogi_ncorr AND cod_solicitud ="&numer&"  AND a.tsol_ccod = 1  "&_
						" INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr "&_
						" INNER JOIN ocag_detalle_solicitud_ag osa ON b.sogi_ncorr=osa.sogi_ncorr AND a.psol_mpresupuesto=osa.dorc_nprecio_unidad"& vbCrLf&_
						" UNION "& vbCrLf&_
						" select DISTINCT 1 AS numero, '2-10-070-10-000004' as tsof_plan_cuenta, 0 as tsof_debe, osa.dorc_nprecio_neto as TSOF_HABER, "&_
						" protic.extrae_acentos(LTRIM(RTRIM((SELECT TOP 1 dorc_tdesc FROM ocag_detalle_solicitud_ag WHERE sogi_ncorr="&numer&")))) as TSOF_GLOSA_SIN_ACENTO, a.cod_pre AS TSOF_COD_CONCEPTO_CAJA, c.pers_nrut as TSOF_COD_AUXILIAR,"&_
						" 'BC' as TSOF_TIPO_DOCUMENTO, b.sogi_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA, "&_
						" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, "&_
						" b.sogi_ncorr AS TSOF_NRO_DOC_REFERENCIA  , '' as TSOF_COD_CENTRO_COSTO , NULL AS TSOF_NRO_CORRELATIVO, "&_
						" NULL AS TSOF_MONTO_DET_LIBRO1,"&_
						" NULL AS TSOF_MONTO_DET_LIBRO2,"&_
						" NULL TSOF_MONTO_DET_LIBRO3,"&_
						" '' AS TSOF_MONTO_DET_LIBRO4, '' AS TSOF_MONTO_DET_LIBRO5, '' AS TSOF_MONTO_DET_LIBRO6, '' AS TSOF_MONTO_DET_LIBRO7, "&_
						" '' AS TSOF_MONTO_DET_LIBRO8, '' AS TSOF_MONTO_DET_LIBRO9, NULL as TSOF_MONTO_SUMA_DET_LIBRO, "&_
						" 1 AS TSOF_NRO_AGRUPADOR  , "&_
						" CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) TSOF_cod_mesano, "&_
						" osa.dorc_nprecio_neto AS TSOF_monto_presupuesto"& vbCrLf&_
						" from ocag_presupuesto_solicitud a "& vbCrLf&_
						" INNER JOIN ocag_solicitud_giro b ON a.cod_solicitud = b.sogi_ncorr AND cod_solicitud ="&numer&"  AND a.tsol_ccod = 1  "& vbCrLf&_
						" INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr "& vbCrLf&_
						" INNER JOIN ocag_detalle_solicitud_ag osa ON b.sogi_ncorr=osa.sogi_ncorr AND a.psol_mpresupuesto=osa.dorc_nprecio_unidad"
						if es_orden_compra(numer,solicitud) then
							valor = valor +" UNION "& vbCrLf&_
							" select DISTINCT 0 AS numero,'2-10-120-10-000003' as tsof_plan_cuenta, 0 as tsof_debe,"&_ 
							" e.dsgi_mretencion  AS TSOF_HABER, protic.extrae_acentos(RTRIM(LTRIM(d.tgas_tdesc))) AS TSOF_GLOSA_SIN_ACENTO "&_
							" , NULL AS TSOF_COD_CONCEPTO_CAJA, NULL as TSOF_COD_AUXILIAR, NULL as TSOF_TIPO_DOCUMENTO, NULL as TSOF_NRO_DOCUMENTO, NULL AS TSOF_FECHA_EMISION_CORTA "&_
							" , NULL as TSOF_FECHA_VENCIMIENTO_CORTA, NULL AS TSOF_TIPO_DOC_REFERENCIA, NULL AS TSOF_NRO_DOC_REFERENCIA , NULL as TSOF_COD_CENTRO_COSTO "&_
							" , NULL AS TSOF_NRO_CORRELATIVO"&_
							" , NULL AS TSOF_MONTO_DET_LIBRO1"&_
							" , NULL AS TSOF_MONTO_DET_LIBRO2"&_
							" , NULL AS TSOF_MONTO_DET_LIBRO3"&_
							" , '' AS TSOF_MONTO_DET_LIBRO4"&_
							" , '' AS TSOF_MONTO_DET_LIBRO5"&_
							" , '' AS TSOF_MONTO_DET_LIBRO6"&_
							" , '' AS TSOF_MONTO_DET_LIBRO7"&_
							" , '' AS TSOF_MONTO_DET_LIBRO8"&_
							" , '' AS TSOF_MONTO_DET_LIBRO9"&_
							" , NULL as TSOF_MONTO_SUMA_DET_LIBRO"&_
							" , 1 AS TSOF_NRO_AGRUPADOR"&_
							" , NULL AS TSOF_cod_mesano "&_
							" , NULL as TSOF_monto_presupuesto "&_
							" from  ocag_detalle_solicitud_ag w "&_
							" inner join ocag_presupuesto_solicitud z ON w.sogi_ncorr = Z.cod_solicitud and w.sogi_ncorr ="&numer&" and z.tsol_ccod=1"&_
							" INNER JOIN ocag_solicitud_giro a ON z.cod_solicitud = a.sogi_ncorr  "&_
							" INNER JOIN ocag_tipo_gasto d ON w.tgas_ccod = d.tgas_ccod "&_
							" INNER JOIN ocag_detalle_solicitud_giro e ON e.sogi_ncorr=w.sogi_ncorr"
						end if
				end if
				
				valor = "select * from (select 0 AS numero, '2-10-070-10-000002' as tsof_plan_cuenta,"& vbCrLf &_
					"   CASE WHEN f.tdoc_ref_ccod IS NOT NULL AND f.tdoc_ref_ccod = d.tdoc_ccod THEN ABS(d.dsgi_mdocto)-ABS(f.dsgi_mdocto) ELSE ABS(d.dsgi_mdocto) END as tsof_debe,"& vbCrLf &_
					"   1 as TSOF_HABER,"& vbCrLf &_
					"	protic.extrae_acentos(LTRIM(RTRIM(b.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO,"&_
					"	NULL AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_
					"   NULL AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
					"	CONVERT(VARCHAR(20),c.PERS_NRUT) +'-'+c.PERS_XDV AS TSOF_COD_AUXILIAR,"& vbCrLf &_
					"	'TR' as TSOF_TIPO_DOCUMENTO,"& vbCrLf &_
					"	d.dsgi_ndocto as TSOF_NRO_DOCUMENTO,"& vbCrLf &_ 
					"	protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA"& vbCrLf &_
					"   protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
					"   otd.tdoc_tdesc_softland as TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
					"   d.dsgi_ndocto as TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
					"	, "&numeross()&" AS TSOF_NRO_CORRELATIVO"& vbCrLf &_
					", CASE WHEN otd.tdoc_tdesc_softland='FI' THEN d.dsgi_mdocto + d.dsgi_mretencion ELSE NULL END AS TSOF_MONTO_DET_LIBRO1"&_
					"	,CASE WHEN otd.tdoc_tdesc_softland='FI' THEN null ELSE d.dsgi_mdocto +d.dsgi_mretencion END AS TSOF_MONTO_DET_LIBRO2"&_
					"	,CASE WHEN otd.tdoc_tdesc_softland='FI' THEN null ELSE d.dsgi_mretencion END AS TSOF_MONTO_DET_LIBRO3"&_
					"	, '' AS TSOF_MONTO_DET_LIBRO4"&_
					"	, '' AS TSOF_MONTO_DET_LIBRO5"&_
					"	, '' AS TSOF_MONTO_DET_LIBRO6"&_
					"	, '' AS TSOF_MONTO_DET_LIBRO7"&_
					"	, '' AS TSOF_MONTO_DET_LIBRO8"&_
					"	, '' AS TSOF_MONTO_DET_LIBRO9"&_
					"	, CASE WHEN otd.tdoc_tdesc_softland='FI' THEN d.dsgi_mdocto + d.dsgi_mretencion ELSE d.dsgi_mdocto END as TSOF_MONTO_SUMA_DET_LIBRO"&_
					"	, 1 AS TSOF_NRO_AGRUPADOR"&_
					"	, CASE WHEN otd.tdoc_tdesc_softland='BC' THEN CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) ELSE NULL END AS TSOF_cod_mesano"&_
					"	, CASE WHEN otd.tdoc_tdesc_softland='BC' THEN d.dsgi_mdocto END AS TSOF_monto_presupuesto,"&_
					"	b.sogi_bboleta_honorario AS boleta,"& vbCrLf &_
					"	0 AS rete"& vbCrLf &_
					"	from ocag_presupuesto_solicitud a"&_
					"	INNER JOIN ocag_solicitud_giro b ON a.cod_solicitud = b.sogi_ncorr AND cod_solicitud = "&numer&" AND a.tsol_ccod = 1"&_
					"	INNER JOIN ocag_detalle_solicitud_giro d ON b.sogi_ncorr = d.sogi_ncorr"&_
					"	INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr"&_
					"	INNER JOIN ocag_tipo_documento otd ON otd.tdoc_ccod=d.tdoc_ccod"& vbCrLf &_
					"	INNER JOIN ocag_presupuesto_solicitud e ON e.cod_solicitud=b.sogi_ncorr"& vbCrLf &_
					"	LEFT JOIN ocag_detalle_solicitud_giro f ON f.sogi_ncorr=b.sogi_ncorr AND f.tdoc_ref_ccod = d.tdoc_ccod"& vbCrLf &_
					"union  "& vbCrLf &_
					"select 1 AS numero, '2-10-070-10-000002' as tsof_plan_cuenta,"& vbCrLf &_
					"   0 as tsof_debe,"& vbCrLf &_
					"   CASE WHEN f.tdoc_ref_ccod IS NULL THEN ABS(d.dsgi_mdocto) ELSE NULL END as TSOF_HABER,"& vbCrLf &_
					" 	NULL AS TSOF_COD_CONCEPTO_CAJA,"& vbCrLf &_
					"   null AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
					"	CONVERT(VARCHAR(20),c.PERS_NRUT) +'-'+c.PERS_XDV AS TSOF_COD_AUXILIAR,"& vbCrLf &_
					"	otd.tdoc_tdesc_softland as TSOF_TIPO_DOCUMENTO,"& vbCrLf &_
					"	d.dsgi_ndocto as TSOF_NRO_DOCUMENTO,"& vbCrLf &_
					"	protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA"&_
					"	protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
					"   otd.tdoc_tdesc_softland as TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
					"   d.dsgi_ndocto as TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
					"	"&numeross()&" AS TSOF_NRO_CORRELATIVO,"& vbCrLf &_
					" 	CASE WHEN otd.tdoc_tdesc_softland='FI' THEN d.dsgi_mdocto + d.dsgi_mretencion ELSE NULL END AS TSOF_MONTO_DET_LIBRO1,"& vbCrLf &_
					" 	CASE WHEN otd.tdoc_tdesc_softland='FI' THEN null ELSE d.dsgi_mdocto + d.dsgi_mretencion END AS TSOF_MONTO_DET_LIBRO2,"& vbCrLf &_
					" 	CASE WHEN otd.tdoc_tdesc_softland='FI' THEN null ELSE d.dsgi_mretencion END AS TSOF_MONTO_DET_LIBRO3,"& vbCrLf &_
					" 	NULL AS TSOF_MONTO_DET_LIBRO4,"& vbCrLf &_
					" 	'' AS TSOF_MONTO_DET_LIBRO5,"& vbCrLf &_
					" 	'' AS TSOF_MONTO_DET_LIBRO6,"& vbCrLf &_
					" 	'' AS TSOF_MONTO_DET_LIBRO7,"& vbCrLf &_
					" 	'' AS TSOF_MONTO_DET_LIBRO8,"& vbCrLf &_
					" 	'' AS TSOF_MONTO_DET_LIBRO9,"& vbCrLf &_
					" 	CASE WHEN otd.tdoc_tdesc_softland='FI' THEN d.dsgi_mdocto + d.dsgi_mretencion ELSE d.dsgi_mdocto END as TSOF_MONTO_SUMA_DET_LIBRO,"& vbCrLf &_
					" 	1 AS TSOF_NRO_AGRUPADOR,"& vbCrLf &_
					" 	CASE WHEN otd.tdoc_tdesc_softland='BC' THEN CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) ELSE NULL END AS TSOF_cod_mesano,"& vbCrLf &_
					" 	CASE WHEN otd.tdoc_tdesc_softland='BC' THEN d.dsgi_mdocto END AS TSOF_monto_presupuesto,"& vbCrLf &_
					"	b.sogi_bboleta_honorario AS boleta,"& vbCrLf &_
					"	0 AS rete"& vbCrLf &_
					"	from ocag_presupuesto_solicitud a"& vbCrLf &_
					"		INNER JOIN ocag_solicitud_giro b ON a.cod_solicitud = b.sogi_ncorr AND cod_solicitud = "& numero &" AND a.tsol_ccod = 1" & vbCrLf &_
					"		INNER JOIN ocag_presupuesto_solicitud e ON e.cod_solicitud=b.sogi_ncorr"& vbCrLf &_
					"		INNER JOIN ocag_detalle_solicitud_giro d ON b.sogi_ncorr = d.sogi_ncorr"& vbCrLf &_
					"		INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr"& vbCrLf &_
					"		INNER JOIN ocag_tipo_documento otd ON otd.tdoc_ccod=d.tdoc_ccod"& vbCrLf &_
					"		LEFT JOIN ocag_detalle_solicitud_giro f ON f.sogi_ncorr=b.sogi_ncorr AND f.tdoc_ref_ccod=NULL"& vbCrLf &_
					"	WHERE d.tdoc_ccod <> 7"
			case 2:
				valor = valor + "select 0 AS numero, '2-10-070-10-000002' as tsof_plan_cuenta, d.drga_mdocto + d.drga_mretencion as tsof_debe, 0 as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(d.drga_tdescripcion))) as TSOF_GLOSA_SIN_ACENTO  "&_
					", NULL AS TSOF_COD_CONCEPTO_CAJA, c.pers_nrut as TSOF_COD_AUXILIAR, 'TR' as TSOF_TIPO_DOCUMENTO, d.drga_ndocto as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA  "&_
					", protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, otd.tdoc_tdesc_softland AS TSOF_TIPO_DOC_REFERENCIA, d.drga_ndocto AS TSOF_NRO_DOC_REFERENCIA  "&_
					", '' as TSOF_COD_CENTRO_COSTO "&_
					", "&numeross()&" AS TSOF_NRO_CORRELATIVO"&_ 
					", CASE WHEN otd.tdoc_tdesc_softland='FI' THEN d.drga_mdocto + d.drga_mretencion ELSE NULL END AS TSOF_MONTO_DET_LIBRO1"&_
					",CASE WHEN otd.tdoc_tdesc_softland='FI' THEN null ELSE d.drga_mdocto END AS TSOF_MONTO_DET_LIBRO2"&_
					",CASE WHEN otd.tdoc_tdesc_softland='FI' THEN null ELSE d.drga_mretencion END AS TSOF_MONTO_DET_LIBRO3"&_
					", '' AS TSOF_MONTO_DET_LIBRO4"&_
					", '' AS TSOF_MONTO_DET_LIBRO5"&_
					", '' AS TSOF_MONTO_DET_LIBRO6"&_
					", '' AS TSOF_MONTO_DET_LIBRO7"&_
					", '' AS TSOF_MONTO_DET_LIBRO8"&_
					", '' AS TSOF_MONTO_DET_LIBRO9"&_
					", d.drga_mdocto + d.drga_mretencion as TSOF_MONTO_SUMA_DET_LIBRO"&_
					", 1 AS TSOF_NRO_AGRUPADOR  "&_
					", CASE WHEN otd.tdoc_tdesc_softland='BC' THEN CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) ELSE NULL END AS TSOF_cod_mesano  "&_
					", CASE WHEN otd.tdoc_tdesc_softland='BC' THEN d.drga_mdocto END AS TSOF_monto_presupuesto  "&_
					"from ocag_presupuesto_solicitud a "&_
					"INNER JOIN ocag_reembolso_gastos b ON a.cod_solicitud = b.rgas_ncorr AND cod_solicitud ="&numer&"  AND a.tsol_ccod = 2  "&_
					"INNER JOIN ocag_detalle_reembolso_gasto d ON b.rgas_ncorr = d.rgas_ncorr "&_
					"INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr INNER JOIN ocag_tipo_documento otd ON otd.tdoc_ccod=d.tdoc_ccod "& vbCrLf &_
					"union  "&_
					"select 0 AS numero, '2-10-070-10-000002' as tsof_plan_cuenta, 0 as tsof_debe, d.drga_mdocto + d.drga_mretencion as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(d.drga_tdescripcion))) as TSOF_GLOSA_SIN_ACENTO  "&_
					", NULL AS TSOF_COD_CONCEPTO_CAJA, c.pers_nrut as TSOF_COD_AUXILIAR, otd.tdoc_tdesc_softland as TSOF_TIPO_DOCUMENTO, d.drga_ndocto as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso)as TSOF_FECHA_EMISION_CORTA  "&_
					", protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, otd.tdoc_tdesc_softland AS TSOF_TIPO_DOC_REFERENCIA, d.drga_ndocto AS TSOF_NRO_DOC_REFERENCIA  "&_
					", '' as TSOF_COD_CENTRO_COSTO"&_ 
					", "&numeross()&" AS TSOF_NRO_CORRELATIVO"&_ 
					",CASE WHEN otd.tdoc_tdesc_softland='FI' THEN d.drga_mdocto + d.drga_mretencion ELSE NULL END AS TSOF_MONTO_DET_LIBRO1"&_
					",CASE WHEN otd.tdoc_tdesc_softland='FI' THEN null ELSE d.drga_mdocto END AS TSOF_MONTO_DET_LIBRO2"&_
					",CASE WHEN otd.tdoc_tdesc_softland='FI' THEN null ELSE d.drga_mretencion END AS TSOF_MONTO_DET_LIBRO3"&_
					",'' AS TSOF_MONTO_DET_LIBRO4"&_
					",'' AS TSOF_MONTO_DET_LIBRO5"&_
					",'' AS TSOF_MONTO_DET_LIBRO6"&_
					",'' AS TSOF_MONTO_DET_LIBRO7"&_
					",'' AS TSOF_MONTO_DET_LIBRO8"&_
					",'' AS TSOF_MONTO_DET_LIBRO9"&_
					",d.drga_mdocto + d.drga_mretencion as TSOF_MONTO_SUMA_DET_LIBRO"&_
					",1 AS TSOF_NRO_AGRUPADOR  "&_
					", CASE WHEN otd.tdoc_tdesc_softland='BC' THEN CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) ELSE NULL END AS TSOF_cod_mesano  "&_
					", CASE WHEN otd.tdoc_tdesc_softland='BC' THEN d.drga_mdocto END AS TSOF_monto_presupuesto  "&_
					"from ocag_presupuesto_solicitud a  "&_
					"INNER JOIN ocag_reembolso_gastos b ON a.cod_solicitud = b.rgas_ncorr AND cod_solicitud ="&numer&"  AND a.tsol_ccod = 2  "&_
					"INNER JOIN ocag_detalle_reembolso_gasto d ON b.rgas_ncorr = d.rgas_ncorr "&_
					"INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr INNER JOIN ocag_tipo_documento otd ON otd.tdoc_ccod=d.tdoc_ccod"& vbCrLf &_
					"UNION "&_
					" select 0 AS numero, '2-10-070-10-000004' as tsof_plan_cuenta, b.rgas_mgiro as tsof_debe, 0 as TSOF_HABER, "&_
					" protic.extrae_acentos(LTRIM(RTRIM((SELECT TOP 1 drga_tdescripcion FROM ocag_detalle_reembolso_gasto WHERE rgas_ncorr="&numer&")))) as TSOF_GLOSA_SIN_ACENTO, ops.cod_pre AS TSOF_COD_CONCEPTO_CAJA, c.pers_nrut as TSOF_COD_AUXILIAR,"&_
					" 'TR' as TSOF_TIPO_DOCUMENTO, b.rgas_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA, "&_
					" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, "&_
					" b.rgas_ncorr AS TSOF_NRO_DOC_REFERENCIA  , '' as TSOF_COD_CENTRO_COSTO , NULL AS TSOF_NRO_CORRELATIVO, "&_
					" NULL AS TSOF_MONTO_DET_LIBRO1,"&_
					" NULL AS TSOF_MONTO_DET_LIBRO2,"&_
					" NULL TSOF_MONTO_DET_LIBRO3,"&_
					" '' AS TSOF_MONTO_DET_LIBRO4, '' AS TSOF_MONTO_DET_LIBRO5, '' AS TSOF_MONTO_DET_LIBRO6, '' AS TSOF_MONTO_DET_LIBRO7, "&_
					" '' AS TSOF_MONTO_DET_LIBRO8, '' AS TSOF_MONTO_DET_LIBRO9, NULL as TSOF_MONTO_SUMA_DET_LIBRO, "&_
					" 1 AS TSOF_NRO_AGRUPADOR  , "&_
					" CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) TSOF_cod_mesano, "&_
					" b.rgas_mgiro AS TSOF_monto_presupuesto  "&_
					" from ocag_presupuesto_solicitud a "&_
					" INNER JOIN ocag_reembolso_gastos b ON a.cod_solicitud = b.rgas_ncorr AND cod_solicitud ="&numer&"  AND a.tsol_ccod = 2  "&_
					" INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr "&_
					" INNER JOIN ocag_presupuesto_solicitud ops ON b.rgas_ncorr=ops.cod_solicitud"& vbCrLf &_
					"UNION "&_
					" select 0 AS numero, '2-10-070-10-000004' as tsof_plan_cuenta, 0 as tsof_debe, b.rgas_mgiro as TSOF_HABER, "&_
					" protic.extrae_acentos(LTRIM(RTRIM((SELECT TOP 1 drga_tdescripcion FROM ocag_detalle_reembolso_gasto WHERE rgas_ncorr="&numer&")))) as TSOF_GLOSA_SIN_ACENTO, ops.cod_pre AS TSOF_COD_CONCEPTO_CAJA, c.pers_nrut as TSOF_COD_AUXILIAR,"&_
					" 'BC' as TSOF_TIPO_DOCUMENTO, b.rgas_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA, "&_
					" protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, "&_
					" b.rgas_ncorr AS TSOF_NRO_DOC_REFERENCIA  , '' as TSOF_COD_CENTRO_COSTO , NULL AS TSOF_NRO_CORRELATIVO, "&_
					" NULL AS TSOF_MONTO_DET_LIBRO1,"&_
					" NULL AS TSOF_MONTO_DET_LIBRO2,"&_
					" NULL TSOF_MONTO_DET_LIBRO3,"&_
					" '' AS TSOF_MONTO_DET_LIBRO4, '' AS TSOF_MONTO_DET_LIBRO5, '' AS TSOF_MONTO_DET_LIBRO6, '' AS TSOF_MONTO_DET_LIBRO7, "&_
					" '' AS TSOF_MONTO_DET_LIBRO8, '' AS TSOF_MONTO_DET_LIBRO9, NULL as TSOF_MONTO_SUMA_DET_LIBRO, "&_
					" 1 AS TSOF_NRO_AGRUPADOR  , "&_
					" CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) TSOF_cod_mesano, "&_
					" b.rgas_mgiro AS TSOF_monto_presupuesto  "&_
					" from ocag_presupuesto_solicitud a "&_
					" INNER JOIN ocag_reembolso_gastos b ON a.cod_solicitud = b.rgas_ncorr AND cod_solicitud ="&numer&"  AND a.tsol_ccod = 2  "&_
					" INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr "&_
					" INNER JOIN ocag_presupuesto_solicitud ops ON b.rgas_ncorr=ops.cod_solicitud"
			case 3:
				valor = valor + " select 0 AS numero, '2-10-070-10-000004' as tsof_plan_cuenta, a.psol_mpresupuesto as tsof_debe, 0 as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(b.fren_tdescripcion_actividad))) as TSOF_GLOSA_SIN_ACENTO "&_
					" , c.pers_nrut as TSOF_COD_AUXILIAR, 'TR' as TSOF_TIPO_DOCUMENTO, b.fren_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA  "&_
					" , protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, b.fren_ncorr AS TSOF_NRO_DOC_REFERENCIA "&_
					" , '' as TSOF_COD_CENTRO_COSTO, a.cod_pre as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR  "&_
					" , CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano  "&_
					" , a.psol_mpresupuesto as TSOF_monto_presupuesto  "&_
					" from ocag_presupuesto_solicitud a "&_
					" INNER JOIN ocag_fondos_a_rendir b ON a.cod_solicitud = b.fren_ncorr AND cod_solicitud ="&numer&" and a.tsol_ccod=3  "&_
					" INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr  "& vbCrLf &_
					" union  "&_
					" select 0 AS numero, '2-10-070-10-000004' as tsof_plan_cuenta, 0 as tsof_debe, a.psol_mpresupuesto as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(b.fren_tdescripcion_actividad))) as TSOF_GLOSA_SIN_ACENTO  "&_
					" , c.pers_nrut as TSOF_COD_AUXILIAR, 'BC' as TSOF_TIPO_DOCUMENTO, b.fren_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso)as TSOF_FECHA_EMISION_CORTA  "&_
					" , protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, b.fren_ncorr AS TSOF_NRO_DOC_REFERENCIA  "&_
					" , '' as TSOF_COD_CENTRO_COSTO, a.cod_pre as TSOF_COD_CONCEPTO_CAJA , 1 AS TSOF_NRO_AGRUPADOR "&_
					" , CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano  "&_
					" , a.psol_mpresupuesto as TSOF_monto_presupuesto "&_
					" from ocag_presupuesto_solicitud a "&_
					" INNER JOIN ocag_fondos_a_rendir b ON a.cod_solicitud = b.fren_ncorr AND cod_solicitud ="&numer&" AND a.tsol_ccod = 3 "&_
					" INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr "
			case 4:
				valor = valor +"select 0 AS numero, '2-10-070-10-000004' as tsof_plan_cuenta, psol_mpresupuesto as tsof_debe, 0 as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(b.sovi_tmotivo))) as TSOF_GLOSA_SIN_ACENTO  "&_
					" , c.pers_nrut as TSOF_COD_AUXILIAR, 'TR' as TSOF_TIPO_DOCUMENTO, b.sovi_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA  "&_
					" , protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, b.sovi_ncorr AS TSOF_NRO_DOC_REFERENCIA  "&_
					" , '' as TSOF_COD_CENTRO_COSTO, a.cod_pre as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR "&_
					" , CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano  "&_
					" , a.psol_mpresupuesto as TSOF_monto_presupuesto "&_
					" from ocag_presupuesto_solicitud  a "&_
					" INNER JOIN ocag_solicitud_viatico b ON a.cod_solicitud = b.sovi_ncorr AND cod_solicitud ="&numer&" AND a.tsol_ccod = 4 "&_
					" INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr  "&_
					"  union "&_
					" select 0 AS numero, '2-10-070-10-000004' as tsof_plan_cuenta, 0 as tsof_debe, a.psol_mpresupuesto as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(b.sovi_tmotivo))) as TSOF_GLOSA_SIN_ACENTO  "&_
					" , c.pers_nrut as TSOF_COD_AUXILIAR, 'BC' as TSOF_TIPO_DOCUMENTO, b.sovi_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso)as TSOF_FECHA_EMISION_CORTA  "&_
					" , protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, b.sovi_ncorr AS TSOF_NRO_DOC_REFERENCIA  "&_
					" , '' as TSOF_COD_CENTRO_COSTO, a.cod_pre as TSOF_COD_CONCEPTO_CAJA , 1 AS TSOF_NRO_AGRUPADOR  "&_
					" , CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano  "&_
					" , a.psol_mpresupuesto as TSOF_monto_presupuesto  "&_
					" from ocag_presupuesto_solicitud a "&_
					" INNER JOIN ocag_solicitud_viatico b ON a.cod_solicitud = b.sovi_ncorr AND cod_solicitud ="&numer&" AND a.tsol_ccod = 4 "&_
					" INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr  "
			case 5:
				valor = valor +" select 0 AS numero, '1-10-040-30-' + RTRIM(LTRIM(c.CCOS_TCODIGO)) as tsof_plan_cuenta, dalu_mmonto_pesos as tsof_debe, 0 as TSOF_HABER "&_
					", protic.extrae_acentos(RTRIM(LTRIM(c.CCOS_TDESC))) as TSOF_GLOSA_SIN_ACENTO , a.pers_nrut_alu as TSOF_COD_AUXILIAR "&_
					", '' as TSOF_TIPO_DOCUMENTO, '' as TSOF_NRO_DOCUMENTO, '' as TSOF_FECHA_EMISION_CORTA, '' as TSOF_FECHA_VENCIMIENTO_CORTA "&_
					", '' AS TSOF_TIPO_DOC_REFERENCIA, '' AS TSOF_NRO_DOC_REFERENCIA, '' as TSOF_COD_CENTRO_COSTO, '' as TSOF_COD_CONCEPTO_CAJA "&_
					", 1 AS TSOF_NRO_AGRUPADOR, '' AS TSOF_cod_mesano, '' as TSOF_monto_presupuesto "&_
					"from ocag_devolucion_alumno a "&_
					"INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and a.dalu_ncorr ="&numer&" "&_
					"INNER JOIN CENTROS_COSTO c on a.ccos_ccod = c.CCOS_CCOD "&_
					"union "&_
					"select 0 AS numero, '1-10-040-30-' + LTRIM(c.CCOS_TCODIGO) as tsof_plan_cuenta, 0 as tsof_debe, dalu_mmonto_pesos as TSOF_HABER "&_
					", protic.extrae_acentos(RTRIM(LTRIM(c.CCOS_TDESC))) as TSOF_GLOSA_SIN_ACENTO , a.pers_nrut_alu as TSOF_COD_AUXILIAR "&_
					", '' as TSOF_TIPO_DOCUMENTO, '' as TSOF_NRO_DOCUMENTO, '' as TSOF_FECHA_EMISION_CORTA, '' as TSOF_FECHA_VENCIMIENTO_CORTA "&_
					", '' AS TSOF_TIPO_DOC_REFERENCIA, '' AS TSOF_NRO_DOC_REFERENCIA, '' as TSOF_COD_CENTRO_COSTO, '' as TSOF_COD_CONCEPTO_CAJA "&_
					", 1 AS TSOF_NRO_AGRUPADOR, '' AS TSOF_cod_mesano, '' as TSOF_monto_presupuesto "&_
					"from ocag_devolucion_alumno a "&_
					"INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and a.dalu_ncorr ="&numer&" "&_
					"INNER JOIN CENTROS_COSTO c on a.ccos_ccod = c.CCOS_CCOD  "
			case 6:
				valor = valor + " select 0 AS numero, '2-10-070-10-000004' as tsof_plan_cuenta, 0 as tsof_debe, a.psol_mpresupuesto as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(b.ffij_tdetalle_presu))) as TSOF_GLOSA_SIN_ACENTO "&_
					" , c.pers_nrut as TSOF_COD_AUXILIAR, 'BC' as TSOF_TIPO_DOCUMENTO, b.ffij_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso)as TSOF_FECHA_EMISION_CORTA "&_
					" , protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, b.ffij_ncorr AS TSOF_NRO_DOC_REFERENCIA "&_
					" , '' as TSOF_COD_CENTRO_COSTO, a.cod_pre as TSOF_COD_CONCEPTO_CAJA , 1 AS TSOF_NRO_AGRUPADOR "&_
					" , CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano "&_
					" , a.psol_mpresupuesto as TSOF_monto_presupuesto "&_
					" FROM ocag_presupuesto_solicitud a "&_
					" INNER JOIN ocag_fondo_fijo b "&_
					" ON a.cod_solicitud = b.ffij_ncorr AND cod_solicitud ="&numer&" AND a.tsol_ccod = 6 "&_
					" INNER JOIN personas c "&_
					" ON b.pers_ncorr=c.pers_ncorr "&_
					" UNION "&_
					" select 0 AS numero, '2-10-070-10-000004' as tsof_plan_cuenta, a.psol_mpresupuesto as tsof_debe, 0 as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(b.ffij_tdetalle_presu))) as TSOF_GLOSA_SIN_ACENTO "&_
					" , c.pers_nrut as TSOF_COD_AUXILIAR, 'TR' as TSOF_TIPO_DOCUMENTO, b.ffij_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA "&_
					" , protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, b.ffij_ncorr AS TSOF_NRO_DOC_REFERENCIA "&_
					" , '' as TSOF_COD_CENTRO_COSTO, a.cod_pre as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR "&_
					" , CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano "&_
					" , a.psol_mpresupuesto as TSOF_monto_presupuesto "&_
					" FROM ocag_presupuesto_solicitud a "&_
					" INNER JOIN ocag_fondo_fijo b "&_
					" ON a.cod_solicitud = b.ffij_ncorr AND cod_solicitud ="&numer&" AND a.tsol_ccod = 6 "&_
					" INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr "
			case 7:
				valor = valor + "SELECT 0 AS numero, '2-10-070-10-000002' AS TSOF_PLAN_CUENTA, CASE WHEN b.tdoc_tdesc_softland='BE' THEN drfr_mdocto-drfr_mretencion ELSE drfr_mdocto END AS TSOF_DEBE, 0 AS TSOF_HABER, protic.extrae_acentos(RTRIM(LTRIM(c.tgas_tdesc))) AS TSOF_GLOSA_SIN_ACENTO,"&_
					"'' AS TSOF_EQUIVALENCIA,'' AS TSOF_DEBE_ADICIONAL,'' AS TSOF_HABER_ADICIONAL,'' AS TSOF_COD_CONDICION_VENTA,'' AS TSOF_COD_VENDEDOR,'' AS TSOF_COD_UBICACION,'' AS TSOF_COD_CONCEPTO_CAJA,'' AS TSOF_COD_INSTRUMENTO_FINAN,'' AS TSOF_CANT_INSTRUMENTO_FINAN,"&_
					"'' AS TSOF_COD_DETALLE_GASTO,'' AS TSOF_CANT_CONCEPTO_GASTO,'' AS TSOF_COD_CENTRO_COSTO,"&_
					"'' AS TSOF_TIPO_DOC_CONCILIACION,'' AS TSOF_NRO_DOC_CONCILIACION,replace(a.drfr_trut, right(a.drfr_trut,2),'') AS TSOF_COD_AUXILIAR,'TR' AS TSOF_TIPO_DOCUMENTO,a.drfr_ndocto AS TSOF_NRO_DOCUMENTO,CONVERT(VARCHAR(32),protic.trunc(a.drfr_fdocto)) AS TSOF_FECHA_EMISION_CORTA,CONVERT(VARCHAR(32),protic.trunc(a.drfr_fdocto)) AS TSOF_FECHA_VENCIMIENTO_CORTA,"&_
					"b.tdoc_tdesc_softland AS TSOF_TIPO_DOC_REFERENCIA, a.drfr_ndocto AS TSOF_NRO_DOC_REFERENCIA, "&_
					"'' AS TSOF_NRO_CORRELATIVO, "&_
					"CASE WHEN b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH' THEN CONVERT(VARCHAR(32),drfr_mdocto) ELSE '' END AS TSOF_MONTO_DET_LIBRO1, "&_ 
					"CASE WHEN b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH' THEN CONVERT(VARCHAR(32),drfr_mretencion) ELSE CONVERT(VARCHAR(32),CONVERT(INT,ROUND(drfr_mdocto/1.19,0))) END  AS TSOF_MONTO_DET_LIBRO2, "&_
					"CASE WHEN b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH' THEN '' ELSE CONVERT(VARCHAR(32), CONVERT(INT,ROUND(drfr_mdocto*0.19/1.19,0))) END AS TSOF_MONTO_DET_LIBRO3,"&_
					"'' AS TSOF_MONTO_DET_LIBRO4,"&_
					"'' AS TSOF_MONTO_DET_LIBRO5,'' AS TSOF_MONTO_DET_LIBRO6,'' AS TSOF_MONTO_DET_LIBRO7,'' AS TSOF_MONTO_DET_LIBRO8,'' AS TSOF_MONTO_DET_LIBRO9,"&_
					"CASE WHEN b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH' THEN drfr_mdocto-drfr_mretencion ELSE drfr_mdocto END AS TSOF_MONTO_SUMA_DET_LIBRO,'' AS TSOF_NRO_DOCUMENTO_DESDE,"&_
					"'' AS TSOF_NRO_DOCUMENTO_HASTA,1 AS TSOF_NRO_AGRUPADOR,'' AS TSOF_bullshet1,''  AS TSOF_bullshet2,'' AS TSOF_MONTO_PRESUPUESTO,'' AS TSOF_COD_MESANO "&_
					"FROM ocag_detalle_rendicion_fondo_rendir a INNER JOIN ocag_tipo_documento b ON a.tdoc_ccod=b.tdoc_ccod "&_
					"INNER JOIN ocag_tipo_gasto c ON a.tgas_ccod=c.tgas_ccod WHERE fren_ncorr="&numeros&" AND (b.tdoc_tdesc_softland = 'BE' OR b.tdoc_tdesc_softland = 'BH' OR b.tdoc_tdesc_softland = 'FL' OR b.tdoc_tdesc_softland = 'FE' OR b.tdoc_tdesc_softland = 'FI' OR b.tdoc_tdesc_softland = 'FP') "& vbCrLf &_
					"UNION "&_
					"SELECT 0 AS numero, '2-10-070-10-000002' AS TSOF_PLAN_CUENTA, 0 AS TSOF_DEBE, CASE WHEN b.tdoc_tdesc_softland='BE' THEN drfr_mdocto-drfr_mretencion ELSE drfr_mdocto END AS TSOF_HABER, protic.extrae_acentos(RTRIM(LTRIM(c.tgas_tdesc))) AS TSOF_GLOSA_SIN_ACENTO,"&_
					"'' AS TSOF_EQUIVALENCIA,'' AS TSOF_DEBE_ADICIONAL,'' AS TSOF_HABER_ADICIONAL,'' AS TSOF_COD_CONDICION_VENTA,'' AS TSOF_COD_VENDEDOR,'' AS TSOF_COD_UBICACION,'' AS TSOF_COD_CONCEPTO_CAJA,'' AS TSOF_COD_INSTRUMENTO_FINAN,'' AS TSOF_CANT_INSTRUMENTO_FINAN,'' AS TSOF_COD_DETALLE_GASTO,'' AS TSOF_CANT_CONCEPTO_GASTO,'' AS TSOF_COD_CENTRO_COSTO,"&_
					"'' AS TSOF_TIPO_DOC_CONCILIACION,'' AS TSOF_NRO_DOC_CONCILIACION,replace(a.drfr_trut, right(a.drfr_trut,2),'') AS TSOF_COD_AUXILIAR, b.tdoc_tdesc_softland AS TSOF_TIPO_DOCUMENTO,a.drfr_ndocto AS TSOF_NRO_DOCUMENTO,CONVERT(VARCHAR(32),protic.trunc(a.drfr_fdocto)) AS TSOF_FECHA_EMISION_CORTA,"&_
					"CONVERT(VARCHAR(32),protic.trunc(a.drfr_fdocto)) AS TSOF_FECHA_VENCIMIENTO_CORTA, b.tdoc_tdesc_softland AS TSOF_TIPO_DOC_REFERENCIA,a.drfr_ndocto AS TSOF_NRO_DOC_REFERENCIA,'"&numeross()&"' AS TSOF_NRO_CORRELATIVO, "&_
					"CASE WHEN b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH' THEN CONVERT(VARCHAR(32),drfr_mdocto) ELSE '' END AS TSOF_MONTO_DET_LIBRO1, "&_
					"CASE WHEN b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH' THEN CONVERT(VARCHAR(32),drfr_mretencion) ELSE CONVERT(VARCHAR(32),CONVERT(INT,ROUND(drfr_mdocto/1.19,0))) END  AS TSOF_MONTO_DET_LIBRO2, "&_
					"CASE WHEN b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH' THEN '' ELSE CONVERT(VARCHAR(32), CONVERT(INT,ROUND(drfr_mdocto*0.19/1.19,0))) END AS TSOF_MONTO_DET_LIBRO3,"&_
					"'' AS TSOF_MONTO_DET_LIBRO4,'' AS TSOF_MONTO_DET_LIBRO5,'' AS TSOF_MONTO_DET_LIBRO6,'' AS TSOF_MONTO_DET_LIBRO7,'' AS TSOF_MONTO_DET_LIBRO8, "&_
					"'' AS TSOF_MONTO_DET_LIBRO9,CASE WHEN b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH' THEN drfr_mdocto-drfr_mretencion ELSE drfr_mdocto END AS TSOF_MONTO_SUMA_DET_LIBRO,'' AS TSOF_NRO_DOCUMENTO_DESDE,"&_
					"'' AS TSOF_NRO_DOCUMENTO_HASTA,1 AS TSOF_NRO_AGRUPADOR,'' AS TSOF_bullshet1,''  AS TSOF_bullshet2,'' AS TSOF_MONTO_PRESUPUESTO,'' AS TSOF_COD_MESANO "&_
					"FROM ocag_detalle_rendicion_fondo_rendir a INNER JOIN ocag_tipo_documento b ON a.tdoc_ccod=b.tdoc_ccod "&_
					"INNER JOIN ocag_tipo_gasto c ON a.tgas_ccod=c.tgas_ccod WHERE fren_ncorr="&numeros&" AND (b.tdoc_tdesc_softland = 'BE' OR b.tdoc_tdesc_softland = 'BH' OR b.tdoc_tdesc_softland = 'FL' OR b.tdoc_tdesc_softland = 'FE' OR b.tdoc_tdesc_softland = 'FI' OR b.tdoc_tdesc_softland = 'FP') "& vbCrLf &_
					"UNION "&_
					"SELECT 0 AS numero, '2-10-120-10-000003' AS TSOF_PLAN_CUENTA, 0 AS TSOF_DEBE, CASE WHEN (b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH') THEN drfr_mretencion ELSE 0 END AS TSOF_HABER, protic.extrae_acentos(RTRIM(LTRIM(c.tgas_tdesc))) AS TSOF_GLOSA_SIN_ACENTO,"&_
					"'' AS TSOF_EQUIVALENCIA,'' AS TSOF_DEBE_ADICIONAL,'' AS TSOF_HABER_ADICIONAL,'' AS TSOF_COD_CONDICION_VENTA,'' AS TSOF_COD_VENDEDOR,'' AS TSOF_COD_UBICACION,'' AS TSOF_COD_CONCEPTO_CAJA,'' AS TSOF_COD_INSTRUMENTO_FINAN,'' AS TSOF_CANT_INSTRUMENTO_FINAN,'' AS TSOF_COD_DETALLE_GASTO,'' AS TSOF_CANT_CONCEPTO_GASTO,'' AS TSOF_COD_CENTRO_COSTO,"&_
					"'' AS TSOF_TIPO_DOC_CONCILIACION,'' AS TSOF_NRO_DOC_CONCILIACION,'' AS TSOF_COD_AUXILIAR,'' AS TSOF_TIPO_DOCUMENTO, 0 AS TSOF_NRO_DOCUMENTO,'' AS TSOF_FECHA_EMISION_CORTA,"&_
					"'' AS TSOF_FECHA_VENCIMIENTO_CORTA,'' AS TSOF_TIPO_DOC_REFERENCIA,0 AS TSOF_NRO_DOC_REFERENCIA,'' AS TSOF_NRO_CORRELATIVO,'' AS TSOF_MONTO_DET_LIBRO1,"&_
					"'' AS TSOF_MONTO_DET_LIBRO2,'' AS TSOF_MONTO_DET_LIBRO3,'' AS TSOF_MONTO_DET_LIBRO4,'' AS TSOF_MONTO_DET_LIBRO5,'' AS TSOF_MONTO_DET_LIBRO6,'' AS TSOF_MONTO_DET_LIBRO7,'' AS TSOF_MONTO_DET_LIBRO8,'' AS TSOF_MONTO_DET_LIBRO9,"&_
					"NULL AS TSOF_MONTO_SUMA_DET_LIBRO,'' AS TSOF_NRO_DOCUMENTO_DESDE,"&_
					"'' AS TSOF_NRO_DOCUMENTO_HASTA,1 AS TSOF_NRO_AGRUPADOR,'' AS TSOF_bullshet1,''  AS TSOF_bullshet2,'' AS TSOF_MONTO_PRESUPUESTO,'' AS TSOF_COD_MESANO "&_
					"FROM ocag_detalle_rendicion_fondo_rendir a INNER JOIN ocag_tipo_documento b ON a.tdoc_ccod=b.tdoc_ccod "&_
					"INNER JOIN ocag_tipo_gasto c ON a.tgas_ccod=c.tgas_ccod WHERE fren_ncorr="&numeros&" AND (b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH')"& vbCrLf 
					if diferencia <> 0 then
						valor = valor + "UNION SELECT TOP 1 1 AS numero, '"&codigopre&"' AS TSOF_PLAN_CUENTA, 0 AS TSOF_DEBE, CASE WHEN b.tdoc_tdesc_softland='BE' THEN '"&diferencia&"' ELSE 0 END AS TSOF_HABER, protic.extrae_acentos(RTRIM(LTRIM(c.tgas_tdesc))) AS TSOF_GLOSA_SIN_ACENTO,"&_
						"'' AS TSOF_EQUIVALENCIA,'' AS TSOF_DEBE_ADICIONAL,'' AS TSOF_HABER_ADICIONAL,'' AS TSOF_COD_CONDICION_VENTA,'' AS TSOF_COD_VENDEDOR,'' AS TSOF_COD_UBICACION,z.cod_pre AS TSOF_COD_CONCEPTO_CAJA,'' AS TSOF_COD_INSTRUMENTO_FINAN,'' AS TSOF_CANT_INSTRUMENTO_FINAN,'' AS TSOF_COD_DETALLE_GASTO,'' AS TSOF_CANT_CONCEPTO_GASTO,'' AS TSOF_COD_CENTRO_COSTO,"&_
						"'' AS TSOF_TIPO_DOC_CONCILIACION,'' AS TSOF_NRO_DOC_CONCILIACION,replace(a.drfr_trut, right(a.drfr_trut,2),'') AS TSOF_COD_AUXILIAR,'BC' AS TSOF_TIPO_DOCUMENTO,a.rfre_ncorr AS TSOF_NRO_DOCUMENTO,CONVERT(VARCHAR(32),protic.trunc(a.drfr_fdocto)) AS TSOF_FECHA_EMISION_CORTA,"&_
						"CONVERT(VARCHAR(32),protic.trunc(a.drfr_fdocto)) AS TSOF_FECHA_VENCIMIENTO_CORTA,'BC' AS TSOF_TIPO_DOC_REFERENCIA,a.rfre_ncorr AS TSOF_NRO_DOC_REFERENCIA,'' AS TSOF_NRO_CORRELATIVO,'' AS TSOF_MONTO_DET_LIBRO1,"&_
						"'' AS TSOF_MONTO_DET_LIBRO2,'' AS TSOF_MONTO_DET_LIBRO3,'' AS TSOF_MONTO_DET_LIBRO4,'' AS TSOF_MONTO_DET_LIBRO5,'' AS TSOF_MONTO_DET_LIBRO6,'' AS TSOF_MONTO_DET_LIBRO7,'' AS TSOF_MONTO_DET_LIBRO8,'' AS TSOF_MONTO_DET_LIBRO9,NULL AS TSOF_MONTO_SUMA_DET_LIBRO,'' AS TSOF_NRO_DOCUMENTO_DESDE,"&_
						"'' AS TSOF_NRO_DOCUMENTO_HASTA,1 AS TSOF_NRO_AGRUPADOR,'' AS TSOF_bullshet1,''  AS TSOF_bullshet2,'"&diferencia&"' AS TSOF_MONTO_PRESUPUESTO, CASE WHEN MONTH(w.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(w.ocag_fingreso) AS VARCHAR) + CAST(YEAR(w.ocag_fingreso) AS VARCHAR) AS TSOF_COD_MESANO "&_
						"FROM ocag_detalle_rendicion_fondo_rendir a INNER JOIN ocag_tipo_documento b ON a.tdoc_ccod=b.tdoc_ccod "&_
						"INNER JOIN ocag_presupuesto_solicitud z ON a.fren_ncorr = z.cod_solicitud "&_
						"INNER JOIN ocag_tipo_gasto c ON a.tgas_ccod=c.tgas_ccod INNER JOIN ocag_rendicion_fondos_a_rendir w ON w.fren_ncorr = z.cod_solicitud WHERE a.fren_ncorr="&numeros&" AND b.tdoc_tdesc_softland='BE'"& vbCrLf &_
						"UNION "&_
						"SELECT TOP 1 1 AS numero, '"&codigopre&"' AS TSOF_PLAN_CUENTA, CASE WHEN b.tdoc_tdesc_softland='BE' THEN '"&diferencia&"' ELSE 0 END AS TSOF_DEBE, 0 AS TSOF_HABER, protic.extrae_acentos(RTRIM(LTRIM(c.tgas_tdesc))) AS TSOF_GLOSA_SIN_ACENTO,"&_
						"'' AS TSOF_EQUIVALENCIA,'' AS TSOF_DEBE_ADICIONAL,'' AS TSOF_HABER_ADICIONAL,'' AS TSOF_COD_CONDICION_VENTA,'' AS TSOF_COD_VENDEDOR,'' AS TSOF_COD_UBICACION,z.cod_pre AS TSOF_COD_CONCEPTO_CAJA,'' AS TSOF_COD_INSTRUMENTO_FINAN,'' AS TSOF_CANT_INSTRUMENTO_FINAN,'' AS TSOF_COD_DETALLE_GASTO,'' AS TSOF_CANT_CONCEPTO_GASTO,'' AS TSOF_COD_CENTRO_COSTO,"&_
						"'' AS TSOF_TIPO_DOC_CONCILIACION,'' AS TSOF_NRO_DOC_CONCILIACION,replace(a.drfr_trut, right(a.drfr_trut,2),'') AS TSOF_COD_AUXILIAR,'TR' AS TSOF_TIPO_DOCUMENTO,a.rfre_ncorr AS TSOF_NRO_DOCUMENTO,CONVERT(VARCHAR(32),protic.trunc(a.drfr_fdocto)) AS TSOF_FECHA_EMISION_CORTA,"&_
						"CONVERT(VARCHAR(32),protic.trunc(a.drfr_fdocto)) AS TSOF_FECHA_VENCIMIENTO_CORTA,'BC' AS TSOF_TIPO_DOC_REFERENCIA,a.rfre_ncorr AS TSOF_NRO_DOC_REFERENCIA,'' AS TSOF_NRO_CORRELATIVO,'' AS TSOF_MONTO_DET_LIBRO1,"&_
						"'' AS TSOF_MONTO_DET_LIBRO2,'' AS TSOF_MONTO_DET_LIBRO3,'' AS TSOF_MONTO_DET_LIBRO4,'' AS TSOF_MONTO_DET_LIBRO5,'' AS TSOF_MONTO_DET_LIBRO6,'' AS TSOF_MONTO_DET_LIBRO7,'' AS TSOF_MONTO_DET_LIBRO8,'' AS TSOF_MONTO_DET_LIBRO9,NULL AS TSOF_MONTO_SUMA_DET_LIBRO,'' AS TSOF_NRO_DOCUMENTO_DESDE,"&_
						"'' AS TSOF_NRO_DOCUMENTO_HASTA,1 AS TSOF_NRO_AGRUPADOR,'' AS TSOF_bullshet1,''  AS TSOF_bullshet2,'"&diferencia&"' AS TSOF_MONTO_PRESUPUESTO,CASE WHEN MONTH(w.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(w.ocag_fingreso) AS VARCHAR) + CAST(YEAR(w.ocag_fingreso) AS VARCHAR) AS TSOF_COD_MESANO "&_
						"FROM ocag_detalle_rendicion_fondo_rendir a INNER JOIN ocag_tipo_documento b ON a.tdoc_ccod=b.tdoc_ccod "&_
						"INNER JOIN ocag_presupuesto_solicitud z ON a.fren_ncorr = z.cod_solicitud "&_
						"INNER JOIN ocag_tipo_gasto c ON a.tgas_ccod=c.tgas_ccod INNER JOIN ocag_rendicion_fondos_a_rendir w ON w.fren_ncorr = z.cod_solicitud WHERE a.fren_ncorr="&numeros&" AND b.tdoc_tdesc_softland='BE' "& vbCrLf &_
						"UNION "&_
						"SELECT TOP 1 2 AS numero, '2-10-070-10-000003' AS TSOF_PLAN_CUENTA, "&_
						"e.fren_mmonto-d.rfre_mmonto AS TSOF_DEBE, 0 AS TSOF_HABER, "&_
						"protic.extrae_acentos(RTRIM(LTRIM(c.tgas_tdesc))) AS TSOF_GLOSA_SIN_ACENTO,"&_
						"'' AS TSOF_EQUIVALENCIA,'' AS TSOF_DEBE_ADICIONAL,'' AS TSOF_HABER_ADICIONAL,'' AS TSOF_COD_CONDICION_VENTA,'' AS TSOF_COD_VENDEDOR,'' AS TSOF_COD_UBICACION,z.cod_pre AS TSOF_COD_CONCEPTO_CAJA,'' AS TSOF_COD_INSTRUMENTO_FINAN,'' AS TSOF_CANT_INSTRUMENTO_FINAN,'' AS TSOF_COD_DETALLE_GASTO,'' AS TSOF_CANT_CONCEPTO_GASTO,'' AS TSOF_COD_CENTRO_COSTO,"&_
						"'' AS TSOF_TIPO_DOC_CONCILIACION,'' AS TSOF_NRO_DOC_CONCILIACION,replace(a.drfr_trut, right(a.drfr_trut,2),'') AS TSOF_COD_AUXILIAR,'TR' AS TSOF_TIPO_DOCUMENTO,a.rfre_ncorr AS TSOF_NRO_DOCUMENTO,CONVERT(VARCHAR(32),protic.trunc(a.drfr_fdocto)) AS TSOF_FECHA_EMISION_CORTA,"&_
						"CONVERT(VARCHAR(32),protic.trunc(a.drfr_fdocto)) AS TSOF_FECHA_VENCIMIENTO_CORTA,'BC' AS TSOF_TIPO_DOC_REFERENCIA,a.rfre_ncorr AS TSOF_NRO_DOC_REFERENCIA,'' AS TSOF_NRO_CORRELATIVO,'' AS TSOF_MONTO_DET_LIBRO1,"&_
						"'' AS TSOF_MONTO_DET_LIBRO2,'' AS TSOF_MONTO_DET_LIBRO3,'' AS TSOF_MONTO_DET_LIBRO4,'' AS TSOF_MONTO_DET_LIBRO5,'' AS TSOF_MONTO_DET_LIBRO6,'' AS TSOF_MONTO_DET_LIBRO7,'' AS TSOF_MONTO_DET_LIBRO8,'' AS TSOF_MONTO_DET_LIBRO9,NULL AS TSOF_MONTO_SUMA_DET_LIBRO,'' AS TSOF_NRO_DOCUMENTO_DESDE,"&_
						"'' AS TSOF_NRO_DOCUMENTO_HASTA,1 AS TSOF_NRO_AGRUPADOR,'' AS TSOF_bullshet1,''  AS TSOF_bullshet2,NULL AS TSOF_MONTO_PRESUPUESTO,NULL AS TSOF_COD_MESANO "&_
						"FROM ocag_detalle_rendicion_fondo_rendir a INNER JOIN ocag_tipo_documento b ON a.tdoc_ccod=b.tdoc_ccod "&_
						"INNER JOIN ocag_tipo_gasto c ON a.tgas_ccod=c.tgas_ccod "&_
						"INNER JOIN ocag_rendicion_fondos_a_rendir d ON a.rfre_ncorr=d.rfre_ncorr "&_
						"INNER JOIN ocag_fondos_a_rendir e ON e.fren_ncorr=d.fren_ncorr "&_
						"INNER JOIN ocag_presupuesto_solicitud z ON a.fren_ncorr = z.cod_solicitud "&_
						"WHERE d.fren_ncorr="&numeros&" AND (b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH') AND ((SELECT a.fren_mmonto FROM ocag_fondos_a_rendir a  WHERE a.fren_ncorr="&numeros&")-(SELECT a.rfre_mmonto FROM ocag_rendicion_fondos_a_rendir a  WHERE a.fren_ncorr="&numeros&"))<>0"& vbCrLf &_
						"UNION "&_
						"SELECT TOP 1 2 AS numero, '2-10-070-10-000003' AS TSOF_PLAN_CUENTA, "&_
						"0 AS TSOF_DEBE, e.fren_mmonto-d.rfre_mmonto AS TSOF_HABER, "&_
						"protic.extrae_acentos(RTRIM(LTRIM(c.tgas_tdesc))) AS TSOF_GLOSA_SIN_ACENTO,"&_
						"'' AS TSOF_EQUIVALENCIA,'' AS TSOF_DEBE_ADICIONAL,'' AS TSOF_HABER_ADICIONAL,'' AS TSOF_COD_CONDICION_VENTA,'' AS TSOF_COD_VENDEDOR,'' AS TSOF_COD_UBICACION,z.cod_pre AS TSOF_COD_CONCEPTO_CAJA,'' AS TSOF_COD_INSTRUMENTO_FINAN,'' AS TSOF_CANT_INSTRUMENTO_FINAN,'' AS TSOF_COD_DETALLE_GASTO,'' AS TSOF_CANT_CONCEPTO_GASTO,'' AS TSOF_COD_CENTRO_COSTO,"&_
						"'' AS TSOF_TIPO_DOC_CONCILIACION,'' AS TSOF_NRO_DOC_CONCILIACION,replace(a.drfr_trut, right(a.drfr_trut,2),'') AS TSOF_COD_AUXILIAR,'BC' AS TSOF_TIPO_DOCUMENTO,a.rfre_ncorr AS TSOF_NRO_DOCUMENTO,CONVERT(VARCHAR(32),protic.trunc(a.drfr_fdocto)) AS TSOF_FECHA_EMISION_CORTA,"&_
						"CONVERT(VARCHAR(32),protic.trunc(a.drfr_fdocto)) AS TSOF_FECHA_VENCIMIENTO_CORTA,'BC' AS TSOF_TIPO_DOC_REFERENCIA,a.rfre_ncorr AS TSOF_NRO_DOC_REFERENCIA,'' AS TSOF_NRO_CORRELATIVO,'' AS TSOF_MONTO_DET_LIBRO1,"&_
						"'' AS TSOF_MONTO_DET_LIBRO2,'' AS TSOF_MONTO_DET_LIBRO3,'' AS TSOF_MONTO_DET_LIBRO4,'' AS TSOF_MONTO_DET_LIBRO5,'' AS TSOF_MONTO_DET_LIBRO6,'' AS TSOF_MONTO_DET_LIBRO7,'' AS TSOF_MONTO_DET_LIBRO8,'' AS TSOF_MONTO_DET_LIBRO9,NULL AS TSOF_MONTO_SUMA_DET_LIBRO,'' AS TSOF_NRO_DOCUMENTO_DESDE,"&_
						"'' AS TSOF_NRO_DOCUMENTO_HASTA,1 AS TSOF_NRO_AGRUPADOR,'' AS TSOF_bullshet1,''  AS TSOF_bullshet2,NULL AS TSOF_MONTO_PRESUPUESTO,NULL AS TSOF_COD_MESANO "&_
						"FROM ocag_detalle_rendicion_fondo_rendir a INNER JOIN ocag_tipo_documento b ON a.tdoc_ccod=b.tdoc_ccod "&_
						"INNER JOIN ocag_tipo_gasto c ON a.tgas_ccod=c.tgas_ccod "&_
						"INNER JOIN ocag_rendicion_fondos_a_rendir d ON a.rfre_ncorr=d.rfre_ncorr "&_
						"INNER JOIN ocag_fondos_a_rendir e ON e.fren_ncorr=d.fren_ncorr "&_
						"INNER JOIN ocag_presupuesto_solicitud z ON a.fren_ncorr = z.cod_solicitud "&_
						"WHERE d.fren_ncorr="&numeros&" AND (b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH') AND (e.fren_mmonto-d.rfre_mmonto<>0)"
					end if
				case 8:
					valor = valor + " select 0 AS numero, '2-10-070-10-000002' as tsof_plan_cuenta, CASE WHEN x.tdoc_ccod = 11 OR x.tdoc_ccod = 1 THEN CONVERT(INT, ROUND(x.drff_mdocto*0.9,0)) ELSE x.drff_mdocto END AS tsof_debe, 0 as TSOF_HABER, protic.extrae_acentos(RTRIM(LTRIM(d.tgas_tdesc))) as TSOF_GLOSA_SIN_ACENTO "&_
					" , b.pers_nrut as TSOF_COD_AUXILIAR, 'TR' as TSOF_TIPO_DOCUMENTO, w.rffi_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(a.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA  "&_
					" , protic.trunc(a.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, e.tdoc_tdesc_softland AS TSOF_TIPO_DOC_REFERENCIA, x.drff_ndocto AS TSOF_NRO_DOC_REFERENCIA  "&_
					" , '' as TSOF_COD_CENTRO_COSTO, NULL as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR  "&_
					", "&numeross()&" AS TSOF_NRO_CORRELATIVO"&_
					",x.drff_mdocto AS TSOF_MONTO_DET_LIBRO1"&_
					",CASE WHEN e.tdoc_tdesc_softland='BE' OR e.tdoc_tdesc_softland='BH' THEN x.drff_mdocto*0.1 ELSE NULL END AS TSOF_MONTO_DET_LIBRO2"&_
					",NULL AS TSOF_MONTO_DET_LIBRO3"&_
					",'' AS TSOF_MONTO_DET_LIBRO4"&_
					",'' AS TSOF_MONTO_DET_LIBRO5"&_
					",'' AS TSOF_MONTO_DET_LIBRO6"&_
					",'' AS TSOF_MONTO_DET_LIBRO7"&_
					",'' AS TSOF_MONTO_DET_LIBRO8"&_
					",'' AS TSOF_MONTO_DET_LIBRO9"&_
					",CASE WHEN e.tdoc_tdesc_softland='BE' OR e.tdoc_tdesc_softland='BH' THEN x.drff_mdocto*0.9 ELSE x.drff_mdocto END AS TSOF_MONTO_SUMA_DET_LIBRO"&_
					" , NULL AS TSOF_cod_mesano "&_
					" , NULL as TSOF_monto_presupuesto "&_
					" from ocag_rendicion_fondo_fijo w "&_
					" INNER JOIN ocag_detalle_rendicion_fondo_fijo x ON w.rffi_ncorr = X.rffi_ncorr and w.rffi_ncorr ="&numer&" "&_
					" inner join ocag_presupuesto_solicitud z ON X.ffij_ncorr = Z.cod_solicitud  and z.tsol_ccod=6 "&_
					" INNER JOIN ocag_fondo_fijo a ON z.cod_solicitud = a.ffij_ncorr  "&_
					" INNER JOIN personas b ON x.pers_nrut = b.pers_nrut "&_
					" INNER JOIN ocag_tipo_gasto d ON x.tgas_ccod = d.tgas_ccod "&_
					" INNER JOIN ocag_tipo_documento e ON x.tdoc_ccod = e.tdoc_ccod "& vbCrLf &_
					"  union "&_
					" select 0 AS numero, '2-10-070-10-000002' as tsof_plan_cuenta, 0 as tsof_debe, CASE WHEN w.tdoc_ccod = 11 OR w.tdoc_ccod = 1 THEN CONVERT(INT, ROUND(w.drff_mdocto*0.9,0)) ELSE w.drff_mdocto END as TSOF_HABER, protic.extrae_acentos(RTRIM(LTRIM(d.tgas_tdesc))) as TSOF_GLOSA_SIN_ACENTO "&_
					" , b.pers_nrut as TSOF_COD_AUXILIAR, e.tdoc_tdesc_softland as TSOF_TIPO_DOCUMENTO, w.drff_ndocto as TSOF_NRO_DOCUMENTO, protic.trunc(a.ocag_fingreso)as TSOF_FECHA_EMISION_CORTA "&_
					" , protic.trunc(a.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, e.tdoc_tdesc_softland AS TSOF_TIPO_DOC_REFERENCIA, w.drff_ndocto AS TSOF_NRO_DOC_REFERENCIA , '' as TSOF_COD_CENTRO_COSTO "&_
					" , NULL as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR  "&_
					", "&numeross()&" AS TSOF_NRO_CORRELATIVO"&_
					",w.drff_mdocto AS TSOF_MONTO_DET_LIBRO1"&_
					",CASE WHEN e.tdoc_tdesc_softland='BE' OR e.tdoc_tdesc_softland='BH' THEN w.drff_mdocto*0.1 ELSE NULL END AS TSOF_MONTO_DET_LIBRO2"&_
					",NULL AS TSOF_MONTO_DET_LIBRO3"&_
					",'' AS TSOF_MONTO_DET_LIBRO4"&_
					",'' AS TSOF_MONTO_DET_LIBRO5"&_
					",'' AS TSOF_MONTO_DET_LIBRO6"&_
					",'' AS TSOF_MONTO_DET_LIBRO7"&_
					",'' AS TSOF_MONTO_DET_LIBRO8"&_
					",'' AS TSOF_MONTO_DET_LIBRO9"&_
					",CASE WHEN e.tdoc_tdesc_softland='BE' OR e.tdoc_tdesc_softland='BH' THEN w.drff_mdocto*0.9 ELSE w.drff_mdocto END as TSOF_MONTO_SUMA_DET_LIBRO"&_
					" , NULL AS TSOF_cod_mesano "&_
					" , NULL as TSOF_monto_presupuesto "&_
					" from  ocag_detalle_rendicion_fondo_fijo w "&_
					" inner join ocag_presupuesto_solicitud z ON w.ffij_ncorr = Z.cod_solicitud and w.rffi_ncorr ="&numer&" and z.tsol_ccod=6 "&_
					" INNER JOIN ocag_fondo_fijo a ON z.cod_solicitud = a.ffij_ncorr  "&_
					" INNER JOIN personas b ON w.pers_nrut = b.pers_nrut  "&_
					" inner join ocag_rendicion_fondo_fijo c ON a.ffij_ncorr = c.ffij_ncorr "&_
					" INNER JOIN ocag_tipo_gasto d ON w.tgas_ccod = d.tgas_ccod "&_
					" INNER JOIN ocag_tipo_documento e ON w.tdoc_ccod = e.tdoc_ccod "& vbCrLf &_
					"  union "&_
					" select 0 AS numero, '2-10-120-10-000003' as tsof_plan_cuenta, 0 as tsof_debe, CASE WHEN w.tdoc_ccod = 11 OR w.tdoc_ccod = 1 THEN CONVERT(INT, ROUND(w.drff_mdocto*0.1,0)) ELSE w.drff_mdocto END AS TSOF_HABER, protic.extrae_acentos(RTRIM(LTRIM(d.tgas_tdesc))) AS TSOF_GLOSA_SIN_ACENTO "&_
					" , NULL as TSOF_COD_AUXILIAR, NULL as TSOF_TIPO_DOCUMENTO, NULL as TSOF_NRO_DOCUMENTO, NULL AS TSOF_FECHA_EMISION_CORTA "&_
					" , NULL as TSOF_FECHA_VENCIMIENTO_CORTA, NULL AS TSOF_TIPO_DOC_REFERENCIA, NULL AS TSOF_NRO_DOC_REFERENCIA , NULL as TSOF_COD_CENTRO_COSTO "&_
					" , NULL as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR  "&_
					", NULL AS TSOF_NRO_CORRELATIVO"&_
					" , NULL AS TSOF_MONTO_DET_LIBRO1"&_
					" , NULL AS TSOF_MONTO_DET_LIBRO2"&_
					" , NULL AS TSOF_MONTO_DET_LIBRO3"&_
					" , '' AS TSOF_MONTO_DET_LIBRO4"&_
					" , '' AS TSOF_MONTO_DET_LIBRO5"&_
					" , '' AS TSOF_MONTO_DET_LIBRO6"&_
					" , '' AS TSOF_MONTO_DET_LIBRO7"&_
					" , '' AS TSOF_MONTO_DET_LIBRO8"&_
					" , '' AS TSOF_MONTO_DET_LIBRO9"&_
					" , NULL as TSOF_MONTO_SUMA_DET_LIBRO"&_
					" , NULL AS TSOF_cod_mesano "&_
					" , NULL as TSOF_monto_presupuesto "&_
					" from  ocag_detalle_rendicion_fondo_fijo w "&_
					" inner join ocag_presupuesto_solicitud z ON w.ffij_ncorr = Z.cod_solicitud and w.rffi_ncorr ="&numer&" and z.tsol_ccod=6 "&_
					" INNER JOIN ocag_fondo_fijo a ON z.cod_solicitud = a.ffij_ncorr  "&_
					" INNER JOIN personas b ON a.pers_ncorr = b.pers_ncorr  "&_
					" inner join ocag_rendicion_fondo_fijo c ON a.ffij_ncorr = c.ffij_ncorr "&_
					" INNER JOIN ocag_tipo_gasto d ON w.tgas_ccod = d.tgas_ccod "&_
					" WHERE (w.tdoc_ccod = 11 OR w.tdoc_ccod = 1)"& vbCrLf &_
					" UNION "&_
					" select TOP 1 1 AS numero,'2-10-070-10-000004' as tsof_plan_cuenta, CONVERT(INT, ROUND((SELECT SUM(CASE WHEN tdoc_ccod = 11 THEN odff.drff_mdocto*0.9 ELSE odff.drff_mdocto END) FROM ocag_detalle_rendicion_fondo_fijo odff WHERE rffi_ncorr="&numer&"),0)) as tsof_debe, 0 as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(d.drff_tdesc))) as TSOF_GLOSA_SIN_ACENTO "&_
					" , c.pers_nrut as TSOF_COD_AUXILIAR, 'TR' as TSOF_TIPO_DOCUMENTO, b.ffij_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA "&_
					" , protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, b.ffij_ncorr AS TSOF_NRO_DOC_REFERENCIA "&_
					" , '' as TSOF_COD_CENTRO_COSTO, a.cod_pre as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR "&_
					", NULL AS TSOF_NRO_CORRELATIVO"&_
					" , NULL AS TSOF_MONTO_DET_LIBRO1"&_
					" , NULL AS TSOF_MONTO_DET_LIBRO2"&_
					" , NULL AS TSOF_MONTO_DET_LIBRO3"&_
					" , '' AS TSOF_MONTO_DET_LIBRO4"&_
					" , '' AS TSOF_MONTO_DET_LIBRO5"&_
					" , '' AS TSOF_MONTO_DET_LIBRO6"&_
					" , '' AS TSOF_MONTO_DET_LIBRO7"&_
					" , '' AS TSOF_MONTO_DET_LIBRO8"&_
					" , '' AS TSOF_MONTO_DET_LIBRO9"&_
					" , NULL as TSOF_MONTO_SUMA_DET_LIBRO"&_
					" , CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano "&_
					" , CONVERT(INT, ROUND((SELECT SUM(CASE WHEN tdoc_ccod = 11 THEN odff.drff_mdocto*0.9 ELSE odff.drff_mdocto END) FROM ocag_detalle_rendicion_fondo_fijo odff WHERE rffi_ncorr="&numer&"),0)) as TSOF_monto_presupuesto "&_
					" FROM ocag_presupuesto_solicitud a "&_
					" INNER JOIN ocag_fondo_fijo b ON a.cod_solicitud = b.ffij_ncorr AND a.tsol_ccod = 6 "&_
					" INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr "&_
					"INNER JOIN ocag_detalle_rendicion_fondo_fijo d ON d.ffij_ncorr=b.ffij_ncorr AND d.rffi_ncorr="&numer & vbCrLf&_
					" UNION "&_
					" select TOP 1 1 AS numero, '2-10-070-10-000004' as tsof_plan_cuenta, 0 as tsof_debe, CONVERT(INT, ROUND((SELECT SUM(CASE WHEN tdoc_ccod = 11 THEN odff.drff_mdocto*0.9 ELSE odff.drff_mdocto END) FROM ocag_detalle_rendicion_fondo_fijo odff WHERE rffi_ncorr="&numer&"),0)) as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(d.drff_tdesc))) as TSOF_GLOSA_SIN_ACENTO "&_
					" , c.pers_nrut as TSOF_COD_AUXILIAR, 'BC' as TSOF_TIPO_DOCUMENTO, b.ffij_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA "&_
					" , protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, b.ffij_ncorr AS TSOF_NRO_DOC_REFERENCIA "&_
					" , '' as TSOF_COD_CENTRO_COSTO, a.cod_pre as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR "&_
					", NULL AS TSOF_NRO_CORRELATIVO"&_
					" , NULL AS TSOF_MONTO_DET_LIBRO1"&_
					" , NULL AS TSOF_MONTO_DET_LIBRO2"&_
					" , NULL AS TSOF_MONTO_DET_LIBRO3"&_
					" , '' AS TSOF_MONTO_DET_LIBRO4"&_
					" , '' AS TSOF_MONTO_DET_LIBRO5"&_
					" , '' AS TSOF_MONTO_DET_LIBRO6"&_
					" , '' AS TSOF_MONTO_DET_LIBRO7"&_
					" , '' AS TSOF_MONTO_DET_LIBRO8"&_
					" , '' AS TSOF_MONTO_DET_LIBRO9"&_
					" , NULL as TSOF_MONTO_SUMA_DET_LIBRO"&_
					" , CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano "&_
					" , CONVERT(INT, ROUND((SELECT SUM(CASE WHEN tdoc_ccod = 11 THEN odff.drff_mdocto*0.9 ELSE odff.drff_mdocto END) FROM ocag_detalle_rendicion_fondo_fijo odff WHERE rffi_ncorr="&numer&"),0)) as TSOF_monto_presupuesto "&_
					" FROM ocag_presupuesto_solicitud a "&_
					" INNER JOIN ocag_fondo_fijo b ON a.cod_solicitud = b.ffij_ncorr AND a.tsol_ccod = 6 "&_
					" INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr "&_
					"INNER JOIN ocag_detalle_rendicion_fondo_fijo d ON d.ffij_ncorr=b.ffij_ncorr AND d.rffi_ncorr="&numer
					
			end select
			valor = valor + vbCrLf&") AS tabla ORDER BY numero ASC, TSOF_COD_CONCEPTO_CAJA DESC, TSOF_GLOSA_SIN_ACENTO ASC, TSOF_PLAN_CUENTA ASC, TSOF_HABER DESC, TSOF_NRO_DOCUMENTO ASC"
		codigoverificardetalle = valor
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

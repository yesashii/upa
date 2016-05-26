<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_rutas.asp" -->

<%
	Server.ScriptTimeOut = 120	
	'------------ OBTENER NUMERO CORRELATIVO DE SOFTLAND
	function muestravalor(cuenta, registro)
		'---------- CONEXION A SOFTLAND ----------'
		set conectar = new Cconexion2
		conectar.Inicializar "upacifico"
	
		'---------- CREAR FORMULARIO ----------'
		set grilla = new CFormulario
		grilla.Carga_Parametros "tabla_vacia.xml", "tabla"
		grilla.Inicializar conectar
	
		'---------- CONSULTAR A SOFTLAND ----------'
		sql_softland = "SELECT TOP 1 pcccos,pcauxi,pccdoc, pcprec FROM softland.cwpctas "& vbCrLf&_
			"WHERE pccodi LIKE '%" & cuenta & "%'"
		'response.write "<pre>"&sql_softland& vbCrLf&"<pre>"
		grilla.Consultar sql_softland
		
		'---------- LOGICA ----------'
		
		while grilla.siguiente
			pcccos=grilla.obtenerValor("pcccos")
			pcauxi=grilla.obtenerValor("pcauxi")
			pccdoc=grilla.obtenerValor("pccdoc")
			pcprec=grilla.obtenerValor("pcprec")
			pcdetg=grilla.obtenerValor("pcdetg")
		wend
		if pcccos="S" AND registro="pcccos" then 
			estado=true
		else
			if pcauxi="S" AND registro="pcauxi" then 
				estado=true
			else
				if pccdoc="S" AND registro="pccdoc" then 
					estado=true
				else
					if pcprec="S" AND registro="pcprec" then 
						estado=true
					else
						estado=false
					end if
				end if
			end if
		end if
		'response.write "<pre>"&estado &"<-"& registro& " "& cuenta &"<pre>"
		muestravalor=estado
	end function
	
	function nombre(codigo)
		set conectar = new Cconexion2
		conectar.Inicializar "upacifico"

		'---------- CREAR FORMULARIO ----------'
		set grilla = new CFormulario
		grilla.Carga_Parametros "tabla_vacia.xml", "tabla"
		grilla.Inicializar conectar

		'---------- CONSULTAR A SOFTLAND ----------'
		sql_softland1 = "SELECT LTRIM(RTRIM(pcdesc)) AS descr "& vbCrLf &_   
			" FROM softland.cwpctas WHERE pccodi LIKE '%"&codigo&"%'"
		grilla.Consultar sql_softland1
		grilla.siguiente
		nombre = grilla.obtenerValor("descr")
	end function
	
	function generadorcosto(tipo_solicitud, numero)
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
		generadorcosto=texto
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
		texto = "SELECT LTRIM(RTRIM(d.tgas_cod_cuenta)) AS TSOF_PLAN_CUENTA,"& vbCrLf &_
			"	CASE WHEN a.sogi_bboleta_honorario = 1 THEN c.dorc_nprecio_neto ELSE c.dorc_nprecio_neto*1.19 END AS TSOF_DEBE,"& vbCrLf &_
			"	0 AS TSOF_HABER, "& vbCrLf &_
			"	c.dorc_bafecta AS rete, "& vbCrLf &_
			"	e.ccos_tcodigo AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			"	CONVERT(VARCHAR(20),b.PERS_NRUT) +'-'+b.PERS_XDV AS TSOF_COD_AUXILIAR, "& vbCrLf &_
			"	protic.ocag_retorna_fecha_normal(GETDATE(),1) AS TSOF_FECHA_VENCIMIENTO_CORTA, "& vbCrLf &_
			"	CASE WHEN g.tdoc_tdesc_softland='CR' THEN 'FL' ELSE g.tdoc_tdesc_softland END AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			"	CASE WHEN g.tdoc_tdesc_softland='CR' THEN NULL ELSE CAST(f.dsgi_ndocto AS VARCHAR) END AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			"	a.sogi_bboleta_honorario AS boleta "& vbCrLf &_
			"	FROM ocag_solicitud_giro a "& vbCrLf &_
			"		INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr ="& numero & vbCrLf &_
			"		INNER JOIN ocag_detalle_solicitud_ag c ON a.sogi_ncorr = c.sogi_ncorr "& vbCrLf &_
			"		INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod "& vbCrLf &_
			"		INNER JOIN ocag_centro_costo e ON c.ccos_ncorr = e.ccos_ncorr"& vbCrLf &_ 
			"		INNER JOIN ocag_detalle_solicitud_giro f ON f.sogi_ncorr=a.sogi_ncorr"& vbCrLf &_ 
			"		INNER JOIN ocag_tipo_documento g ON g.tdoc_ccod = f.tdoc_ccod"& vbCrLf &_ 
			"	WHERE g.tdoc_tdesc_softland <> 'CR'"& vbCrLf &_ 
			"UNION"& vbCrLf &_
			"SELECT TOP 1 CASE WHEN a.cpag_ccod = 25 THEN '1-10-010-30-100001' ELSE '2-10-070-10-000002' END AS TSOF_PLAN_CUENTA,"& vbCrLf &_
			"0 AS TSOF_DEBE,"& vbCrLf &_
			"CASE when a.sogi_bboleta_honorario=1 then a.sogi_mgiro ELSE a.sogi_mgiro/0.9 END AS TSOF_HABER, "& vbCrLf &_
			"null AS rete, "& vbCrLf &_
			"'' AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			"CONVERT(VARCHAR(20),b.PERS_NRUT) +'-'+b.PERS_XDV AS TSOF_COD_AUXILIAR, "& vbCrLf &_
			"protic.ocag_retorna_fecha_normal(GETDATE(),1) AS TSOF_FECHA_VENCIMIENTO_CORTA, "& vbCrLf &_
			"'' AS TSOF_TIPO_DOC_REFERENCIA, '' AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			"	a.sogi_bboleta_honorario AS boleta "& vbCrLf &_
			"FROM ocag_solicitud_giro a "& vbCrLf &_
			"	INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr ="& numero & vbCrLf &_
			"	INNER JOIN ocag_detalle_solicitud_ag c ON a.sogi_ncorr = c.sogi_ncorr "& vbCrLf &_
			"	INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod "& vbCrLf &_
			"	INNER JOIN ocag_centro_costo e ON c.ccos_ncorr = e.ccos_ncorr"
		costopagoproveedor = texto
	end function
	
	function costoreembolso(numero)
		texto = "SELECT LTRIM(RTRIM(d.tgas_cod_cuenta)) AS TSOF_PLAN_CUENTA,"& vbCrLf &_ 
			" c.drga_mdocto*1.19 AS TSOF_DEBE,"& vbCrLf &_ 
			" 0 AS TSOF_HABER,  "& vbCrLf &_ 
			" 1 AS boleta,"& vbCrLf &_ 
			" NULL AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			" CONVERT(VARCHAR(20),b.pers_nrut) +'-'+b.pers_xdv AS TSOF_COD_AUXILIAR, "& vbCrLf &_ 
			" protic.ocag_retorna_fecha_normal(GETDATE(),2) AS TSOF_FECHA_VENCIMIENTO_CORTA, "& vbCrLf &_ 
			" g.tdoc_tdesc_softland AS TSOF_TIPO_DOC_REFERENCIA, CAST(c.drga_ndocto AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_ 
			" 0 AS rete"& vbCrLf &_
			"FROM ocag_reembolso_gastos a "& vbCrLf &_ 
			"	INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.rgas_ncorr =" & numero & vbCrLf &_ 
			"	INNER JOIN ocag_detalle_reembolso_gasto c ON a.rgas_ncorr = c.rgas_ncorr "& vbCrLf &_ 
			"	INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod "& vbCrLf &_ 
			"	INNER JOIN ocag_tipo_documento g ON g.tdoc_ccod = c.tdoc_ccod"& vbCrLf &_ 
			"UNION"& vbCrLf &_
			"SELECT TOP 1 '2-10-070-10-000002' AS TSOF_PLAN_CUENTA,"& vbCrLf &_
			"0 AS TSOF_DEBE,"& vbCrLf &_
			"a.rgas_mgiro AS TSOF_HABER,"& vbCrLf &_ 
			" 1 AS boleta,"& vbCrLf &_ 
			"'' AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			"CONVERT(VARCHAR(20),b.PERS_NRUT) +'-'+b.PERS_XDV AS TSOF_COD_AUXILIAR, "& vbCrLf &_
			"protic.ocag_retorna_fecha_normal(GETDATE(),2) AS TSOF_FECHA_VENCIMIENTO_CORTA, "& vbCrLf &_
			"'' AS TSOF_TIPO_DOC_REFERENCIA, '' AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			"	0 AS rete"& vbCrLf &_
			"FROM ocag_reembolso_gastos a "& vbCrLf &_
			"	INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.rgas_ncorr =" & numero & vbCrLf &_
			"	INNER JOIN ocag_detalle_reembolso_gasto c ON a.rgas_ncorr = c.rgas_ncorr "& vbCrLf &_
			"	INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod"
		costoreembolso = texto
	end function
	
	function costofondorendir(numero)
		texto = "  SELECT '1-10-060-10-000002' AS TSOF_PLAN_CUENTA,"& vbCrLf &_
			" fren_mmonto AS TSOF_DEBE,"& vbCrLf &_ 
			" 0 AS TSOF_HABER,"& vbCrLf &_ 
			" protic.ocag_retorna_fecha_normal(GETDATE(),3) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_ 
			" CONVERT(VARCHAR(20),b.PERS_NRUT) +'-'+b.PERS_XDV AS TSOF_COD_AUXILIAR,"& vbCrLf &_ 
			" e.ccos_tcodigo AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			" 'FR' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_ 
			" a.fren_ncorr AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			"	0 AS rete,"& vbCrLf &_
			"	0 AS boleta "& vbCrLf &_
			" FROM ocag_fondos_a_rendir a"& vbCrLf &_ 
			" INNER JOIN personas b ON a.pers_ncorr = b.pers_ncorr and fren_ncorr=" & numero & vbCrLf &_ 
			" INNER JOIN ocag_centro_costo e ON a.ccos_ncorr=e.ccos_ncorr "& vbCrLf &_
			"UNION"& vbCrLf &_
			"SELECT TOP 1 '2-10-070-10-000002' AS TSOF_PLAN_CUENTA,"& vbCrLf &_
			" 0 AS TSOF_DEBE,"& vbCrLf &_
			" fren_mmonto AS TSOF_HABER,"& vbCrLf &_
			" protic.ocag_retorna_fecha_normal(GETDATE(),3) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" CONVERT(VARCHAR(20),b.PERS_NRUT) +'-'+b.PERS_XDV AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			" '' AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" a.fren_ncorr AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			"	0 AS rete,"& vbCrLf &_
			"	0 AS boleta "& vbCrLf &_
			" from ocag_fondos_a_rendir a"& vbCrLf &_
			" INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and fren_ncorr="& numero
		costofondorendir = texto
	end function
	
	function costosolicitudviatico(numero)
		texto = "SELECT '5-30-020-10-002022'as tsof_plan_cuenta,"& vbCrLf &_
			" psol_mpresupuesto AS TSOF_DEBE,"& vbCrLf &_
			" 0 AS TSOF_HABER,"& vbCrLf &_
			" c.cod_pre AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" CONVERT(VARCHAR(20),b.PERS_NRUT) +'-'+b.PERS_XDV AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			" protic.ocag_retorna_fecha_normal(GETDATE(),4) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" 'SV' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" CONVERT(VARCHAR(32),a.sovi_ncorr) AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" 0 AS rete,"& vbCrLf &_
			" 0 AS boleta "& vbCrLf &_
			" From ocag_solicitud_viatico a "& vbCrLf &_
			" INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and A.sovi_ncorr="&numero& vbCrLf &_
			" INNER JOIN ocag_presupuesto_solicitud c ON c.cod_solicitud=a.sovi_ncorr AND c.tsol_ccod=4"& vbCrLf &_
			" UNION"& vbCrLf &_
			" SELECT '2-10-070-10-000002'as tsof_plan_cuenta,"& vbCrLf &_
			" 0 AS TSOF_DEBE,"& vbCrLf &_
			" a.sovi_mmonto_pesos AS TSOF_HABER,"& vbCrLf &_
			" NULL AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" CONVERT(VARCHAR(20),b.PERS_NRUT) +'-'+b.PERS_XDV AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			" protic.ocag_retorna_fecha_normal(GETDATE(),4) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" CONVERT(VARCHAR(32),a.sovi_ncorr) AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" 0 AS rete,"& vbCrLf &_
			" 0 AS boleta "& vbCrLf &_
			" FROM ocag_solicitud_viatico a "&_
			" INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and A.sovi_ncorr="&numero
		costosolicitudviatico = texto
	end function
	
	function costodevolucionalumno(numero)
		texto ="SELECT '2-10-140-09-120001'as tsof_plan_cuenta,"& vbCrLf &_
			" a.dalu_mmonto_pesos AS TSOF_DEBE,"& vbCrLf &_
			" 0 AS TSOF_HABER,"& vbCrLf &_
			" c.ccos_tcompuesto AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" CONVERT(VARCHAR(20),b.PERS_NRUT) +'-'+b.PERS_XDV AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			" protic.ocag_retorna_fecha_normal(GETDATE(),5) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" NULL AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" NULL AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" 0 AS rete,"& vbCrLf &_
			" 0 AS boleta "& vbCrLf &_
			" From ocag_devolucion_alumno a "& vbCrLf &_
			" INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr AND a.dalu_ncorr="&numero& vbCrLf &_
			" INNER JOIN centros_costo c ON a.ccos_ccod = c.ccos_ccod"& vbCrLf &_
			" UNION"& vbCrLf &_
			" SELECT '2-10-070-10-000002' as tsof_plan_cuenta,"& vbCrLf &_
			" 0 AS TSOF_DEBE,"& vbCrLf &_
			" a.dalu_mmonto_pesos AS TSOF_HABER,"& vbCrLf &_
			" NULL AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" CONVERT(VARCHAR(20),b.PERS_NRUT) +'-'+b.PERS_XDV AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			" protic.ocag_retorna_fecha_normal(GETDATE(),5) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" CAST(a.dalu_ncorr AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" 0 AS rete,"& vbCrLf &_
			" 0 AS boleta "& vbCrLf &_
			" FROM ocag_devolucion_alumno a "&_
			" INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and A.dalu_ncorr="&numero
		costodevolucionalumno = texto
	end function
	
	function costofondofijo(numero)
		texto ="SELECT '1-10-010-20-000003' as tsof_plan_cuenta,"& vbCrLf &_
			" a.ffij_mmonto_pesos AS TSOF_DEBE,"& vbCrLf &_
			" 0 AS TSOF_HABER,"& vbCrLf &_
			" (select c.ccos_tcodigo from ocag_validacion_contable a, ocag_centro_costo_validacion b, ocag_centro_costo c "& vbCrLf &_
			"	where a.vcon_ncorr=b.vcon_ncorr "& vbCrLf &_
			"	and b.ccos_ncorr=c.ccos_ncorr "& vbCrLf &_
			"	and cod_solicitud="& numero&	 vbCrLf &_
			"	and isnull(tsol_ccod,6)=6) AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" CONVERT(VARCHAR(20),b.PERS_NRUT) +'-'+b.PERS_XDV AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			" protic.ocag_retorna_fecha_normal(GETDATE(),6) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" 'FF' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" a.ffij_ncorr AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			"	0 AS rete,"& vbCrLf &_
			"	0 AS boleta "& vbCrLf &_
			" FROM ocag_fondo_fijo a"& vbCrLf &_
			" INNER JOIN personas b ON b.pers_ncorr=a.pers_ncorr"& vbCrLf &_
			" WHERE ffij_ncorr="& numero& vbCrLf &_
			" UNION"& vbCrLf &_
			" SELECT '2-10-070-10-000002' as tsof_plan_cuenta,"& vbCrLf &_
			" 0 AS TSOF_DEBE,"& vbCrLf &_
			" a.ffij_mmonto_pesos AS TSOF_HABER,"& vbCrLf &_
			" (select c.ccos_tcodigo from ocag_validacion_contable a, ocag_centro_costo_validacion b, ocag_centro_costo c "& vbCrLf &_
			"	where a.vcon_ncorr=b.vcon_ncorr "& vbCrLf &_
			"	and b.ccos_ncorr=c.ccos_ncorr "& vbCrLf &_
			"	and cod_solicitud="& numero&	 vbCrLf &_
			"	and isnull(tsol_ccod,6)=6) AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" CONVERT(VARCHAR(20),b.PERS_NRUT) +'-'+b.PERS_XDV AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			" protic.ocag_retorna_fecha_normal(GETDATE(),6) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" 'FF' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" a.ffij_ncorr AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			"	0 AS rete,"& vbCrLf &_
			"	0 AS boleta "& vbCrLf &_
			" FROM ocag_fondo_fijo a"& vbCrLf &_
			" INNER JOIN personas b ON b.pers_ncorr=a.pers_ncorr"& vbCrLf &_
			" WHERE ffij_ncorr="& numero
			costofondofijo = texto
	end function
	
	function costorendicionfondorendir(numero)
		texto = "SELECT LTRIM(RTRIM(d.tgas_cod_cuenta)) AS TSOF_PLAN_CUENTA,"& vbCrLf &_
			" c.drfr_mdocto-c.drfr_mretencion AS TSOF_DEBE,"& vbCrLf &_
			" 0 AS TSOF_HABER, "& vbCrLf &_
			" e.ccos_tcodigo AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" CONVERT(VARCHAR(20),b.PERS_NRUT) +'-'+b.PERS_XDV AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			" protic.ocag_retorna_fecha_normal(GETDATE(),7) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" 'RFF' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" a.fren_ncorr AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			"	0 AS rete,"& vbCrLf &_
			"	0 AS boleta "& vbCrLf &_
			"FROM ocag_rendicion_fondos_a_rendir a"& vbCrLf &_
			"	INNER JOIN personas b ON a.pers_nrut = b.pers_nrut AND a.rfre_ncorr ="&numero & vbCrLf &_
			"	Inner JOIN ocag_fondos_a_rendir h ON h.fren_ncorr= a.fren_ncorr"& vbCrLf &_
			"	INNER JOIN ocag_detalle_rendicion_fondo_rendir c ON a.rfre_ncorr = c.rfre_ncorr"& vbCrLf &_
			"	INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod"& vbCrLf &_
			"	INNER JOIN ocag_centro_costo e ON h.ccos_ncorr = e.ccos_ncorr"& vbCrLf &_ 
			"UNION"& vbCrLf &_
			" SELECT TOP 1 '1-10-060-10-000002' AS TSOF_PLAN_CUENTA,"& vbCrLf &_
			" 0 AS TSOF_DEBE,"& vbCrLf &_
			" a.rfre_mmonto AS TSOF_HABER,"& vbCrLf &_
			" '' AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" CONVERT(VARCHAR(20),b.PERS_NRUT) +'-'+b.PERS_XDV AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			" protic.ocag_retorna_fecha_normal(GETDATE(),7) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" '' AS TSOF_TIPO_DOC_REFERENCIA, null AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" 0 AS rete,"& vbCrLf &_
			" 0 AS boleta "& vbCrLf &_
			"FROM ocag_rendicion_fondos_a_rendir a"& vbCrLf &_
					"INNER JOIN personas b ON a.pers_nrut = b.pers_nrut AND a.rfre_ncorr ="& numero & vbCrLf &_
					"Inner JOIN ocag_fondos_a_rendir h ON h.fren_ncorr= a.fren_ncorr"& vbCrLf &_
					"INNER JOIN ocag_detalle_rendicion_fondo_rendir c ON a.rfre_ncorr = c.rfre_ncorr "& vbCrLf &_
					"INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod "& vbCrLf &_
					"INNER JOIN ocag_centro_costo e ON h.ccos_ncorr = e.ccos_ncorr"
		costorendicionfondorendir = texto
	end function
	
	function costorendicionfondofijo(numero)
		texto = "SELECT d.tgas_cod_cuenta AS TSOF_PLAN_CUENTA,"& vbCrLf &_
			"w.drff_mdocto AS TSOF_DEBE,"& vbCrLf &_
			"0 AS TSOF_HABER,"& vbCrLf &_
			"y.ccos_tcodigo AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			"NULL AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			"protic.ocag_retorna_fecha_normal(GETDATE(),8) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			"NULL AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			"NULL AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			"CASE WHEN w.tdoc_ccod = 11 OR w.tdoc_ccod = 1 THEN 1 ELSE 0 END AS rete,"& vbCrLf &_
			"CASE WHEN w.tdoc_ccod = 11 OR w.tdoc_ccod = 1 THEN 1 ELSE 0 END AS boleta"& vbCrLf &_
			"from ocag_rendicion_fondo_fijo z"& vbCrLf &_
			"inner join ocag_detalle_rendicion_fondo_fijo w ON Z.rffi_ncorr = W.rffi_ncorr"& vbCrLf &_
			"INNER JOIN ocag_fondo_fijo a ON W.ffij_ncorr = a.ffij_ncorr and z.rffi_ncorr ="& numero&""& vbCrLf &_
			"INNER JOIN personas b ON a.pers_ncorr = b.pers_ncorr"& vbCrLf &_
			"INNER JOIN ocag_tipo_gasto d ON W.tgas_ccod = d.tgas_ccod"& vbCrLf &_
			"INNER JOIN ocag_validacion_contable c on z.rffi_ncorr = c.cod_solicitud and isnull(c.tsol_ccod,8)=8"& vbCrLf &_
			"INNER JOIN ocag_centro_costo_validacion x ON c.vcon_ncorr=x.vcon_ncorr"& vbCrLf &_
			"INNER JOIN ocag_centro_costo y ON x.ccos_ncorr=y.ccos_ncorr "& vbCrLf &_
			"UNION "& vbCrLf &_
			"SELECT TOP 1 '2-10-070-10-000002' AS TSOF_PLAN_CUENTA,"& vbCrLf &_
			"0 AS TSOF_DEBE,"& vbCrLf &_
			"CONVERT(INT, ROUND((SELECT SUM(CASE WHEN tdoc_ccod = 11 THEN odff.drff_mdocto*0.9 ELSE odff.drff_mdocto END) FROM ocag_detalle_rendicion_fondo_fijo odff WHERE rffi_ncorr="& numero&"),0)) AS TSOF_HABER,"& vbCrLf &_
			"NULL AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			"CONVERT(VARCHAR(20),b.PERS_NRUT) +'-'+b.PERS_XDV AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			"protic.ocag_retorna_fecha_normal(GETDATE(),8) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			"'BC' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			"CONVERT(VARCHAR(32),a.ffij_ncorr) AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			"0 AS rete,"& vbCrLf &_
			"0 AS boleta"& vbCrLf &_
			"from ocag_rendicion_fondo_fijo z   inner join ocag_detalle_rendicion_fondo_fijo w ON Z.rffi_ncorr = W.rffi_ncorr   INNER JOIN ocag_fondo_fijo a ON z.ffij_ncorr = a.ffij_ncorr and z.rffi_ncorr ="& numero&"  INNER JOIN personas b ON a.pers_ncorr = b.pers_ncorr   INNER JOIN ocag_tipo_gasto d ON W.tgas_ccod = d.tgas_ccod"
		costorendicionfondofijo = texto
	end function
	
	function presupuestopagoproveedor(numero)
		texto = "select '2-10-070-10-000002' as tsof_plan_cuenta,"& vbCrLf &_
			"   CASE WHEN f.tdoc_ref_ccod IS NOT NULL AND f.tdoc_ref_ccod = d.tdoc_ccod THEN ABS(d.dsgi_mdocto)-ABS(f.dsgi_mdocto) ELSE ABS(d.dsgi_mdocto) END as tsof_debe,"& vbCrLf &_
			"   0 as TSOF_HABER,"& vbCrLf &_
			"   NULL AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			"	CONVERT(VARCHAR(20),c.PERS_NRUT) +'-'+c.PERS_XDV AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			"   protic.ocag_retorna_fecha_normal(GETDATE(),1) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			"   otd.tdoc_tdesc_softland as TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			"   d.dsgi_ndocto as TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
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
			"   null AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			"	CONVERT(VARCHAR(20),c.PERS_NRUT) +'-'+c.PERS_XDV AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			"	protic.ocag_retorna_fecha_normal(GETDATE(),1) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			"   otd.tdoc_tdesc_softland as TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			"   d.dsgi_ndocto as TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
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
	
	function presupuestoreembolso(numero)
		texto = "SELECT '2-10-070-10-000004' AS TSOF_PLAN_CUENTA,"& vbCrLf &_ 
			"	c.drga_mdocto + c.drga_mretencion AS TSOF_DEBE,"& vbCrLf &_ 
			"	0 AS TSOF_HABER, "& vbCrLf &_ 
			"	e.cod_pre AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			"	CONVERT(VARCHAR(20),b.PERS_NRUT) +'-'+b.PERS_XDV AS TSOF_COD_AUXILIAR, "& vbCrLf &_ 
			"	protic.ocag_retorna_fecha_normal(GETDATE(),2) AS TSOF_FECHA_VENCIMIENTO_CORTA, "& vbCrLf &_ 
			"	g.tdoc_tdesc_softland AS TSOF_TIPO_DOC_REFERENCIA, CAST(c.drga_ndocto AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			"	0 AS rete,"& vbCrLf &_
			"	1 AS boleta "& vbCrLf &_ 
			"	FROM ocag_reembolso_gastos a "& vbCrLf &_ 
			"		INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.rgas_ncorr ="& numero & vbCrLf &_
			"		INNER JOIN ocag_detalle_reembolso_gasto c ON a.rgas_ncorr = c.rgas_ncorr "& vbCrLf &_ 
			"		INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod "& vbCrLf &_ 
			"		INNER JOIN ocag_presupuesto_solicitud e ON e.cod_solicitud=a.rgas_ncorr AND e.tsol_ccod=2"& vbCrLf &_ 
			"		INNER JOIN ocag_tipo_documento g ON g.tdoc_ccod = c.tdoc_ccod"& vbCrLf &_ 
			"UNION"& vbCrLf &_ 
			"SELECT '2-10-070-10-000004' AS TSOF_PLAN_CUENTA,"& vbCrLf &_ 
			"	0 AS TSOF_DEBE,"& vbCrLf &_ 
			"	c.drga_mdocto + c.drga_mretencion AS TSOF_HABER, "& vbCrLf &_ 
			"	e.cod_pre AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			"	CONVERT(VARCHAR(20),b.PERS_NRUT) +'-'+b.PERS_XDV AS TSOF_COD_AUXILIAR, "& vbCrLf &_ 
			"	protic.ocag_retorna_fecha_normal(GETDATE(),2) AS TSOF_FECHA_VENCIMIENTO_CORTA, "& vbCrLf &_ 
			"	g.tdoc_tdesc_softland AS TSOF_TIPO_DOC_REFERENCIA, CAST(c.drga_ndocto AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			"	0 AS rete,"& vbCrLf &_
			"	1 AS boleta "& vbCrLf &_
			"	FROM ocag_reembolso_gastos a "& vbCrLf &_ 
			"		INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.rgas_ncorr ="& numero & vbCrLf &_
			"		INNER JOIN ocag_detalle_reembolso_gasto c ON a.rgas_ncorr = c.rgas_ncorr "& vbCrLf &_ 
			"		INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod "& vbCrLf &_ 
			"		INNER JOIN ocag_presupuesto_solicitud e ON e.cod_solicitud=a.rgas_ncorr AND e.tsol_ccod=2"& vbCrLf &_ 
			"		INNER JOIN ocag_tipo_documento g ON g.tdoc_ccod = c.tdoc_ccod"
		presupuestoreembolso = texto
	end function
	
	function presupuestofondorendir(numero)
		texto = "select '2-10-070-10-000004' as tsof_plan_cuenta,"& vbCrLf &_
			"	a.psol_mpresupuesto as tsof_debe,"& vbCrLf &_
			"	0 as TSOF_HABER,"& vbCrLf &_
			"	protic.ocag_retorna_fecha_normal(GETDATE(),3) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			"	CONVERT(VARCHAR(20),c.PERS_NRUT) +'-'+c.PERS_XDV as TSOF_COD_AUXILIAR,"& vbCrLf &_
			"	a.cod_pre as TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			"	'BC' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			"	b.fren_ncorr AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			"	0 AS rete,"& vbCrLf &_
			"	0 AS boleta"& vbCrLf &_
			"	from ocag_presupuesto_solicitud a "& vbCrLf &_
			"	INNER JOIN ocag_fondos_a_rendir b ON a.cod_solicitud = b.fren_ncorr AND cod_solicitud ="& numero & " and a.tsol_ccod=3"& vbCrLf &_
			"	INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr "& vbCrLf &_ 
			"UNION"& vbCrLf &_
			"select '2-10-070-10-000004' as tsof_plan_cuenta,"& vbCrLf &_ 
			" 0 as tsof_debe,"& vbCrLf &_ 
			" a.psol_mpresupuesto as TSOF_HABER,"& vbCrLf &_ 
			" protic.ocag_retorna_fecha_normal(GETDATE(),3) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_ 
			" CONVERT(VARCHAR(20),c.PERS_NRUT) +'-'+c.PERS_XDV as TSOF_COD_AUXILIAR,"& vbCrLf &_ 
			" a.cod_pre as TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_ 
			" b.fren_ncorr AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			"	0 AS rete,"& vbCrLf &_
			"	0 AS boleta"& vbCrLf &_
			" from ocag_presupuesto_solicitud a"& vbCrLf &_ 
			" INNER JOIN ocag_fondos_a_rendir b ON a.cod_solicitud = b.fren_ncorr AND cod_solicitud ="& numero & " AND a.tsol_ccod = 3"& vbCrLf &_ 
			" INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr "
		presupuestofondorendir = texto
	end function
	
		function presupuestorendicionfondorendir(numero)
		texto = "SELECT '2-10-070-10-000002' AS TSOF_PLAN_CUENTA,"& vbCrLf &_
			"drfr_mdocto AS TSOF_DEBE,"& vbCrLf &_ 
			"0 AS TSOF_HABER,"& vbCrLf &_ 
			"null AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			"replace(a.drfr_trut, right(a.drfr_trut,2),'') AS TSOF_COD_AUXILIAR,"& vbCrLf &_ 
			"protic.ocag_retorna_fecha_normal(GETDATE(),7) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_ 
			"b.tdoc_tdesc_softland AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_ 
			"a.drfr_ndocto AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_ 
			"CASE WHEN (b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH') THEN 1 ELSE 0 END AS rete,"& vbCrLf &_ 
			" CASE WHEN (b.tdoc_tdesc_softland = 'BE' OR b.tdoc_tdesc_softland = 'BH') THEN 1 ELSE 0 END AS boleta"& vbCrLf &_
			"FROM ocag_detalle_rendicion_fondo_rendir a"& vbCrLf &_ 
			"INNER JOIN ocag_tipo_documento b ON a.tdoc_ccod=b.tdoc_ccod "& vbCrLf &_ 
			"INNER JOIN ocag_tipo_gasto c ON a.tgas_ccod=c.tgas_ccod "& vbCrLf &_ 
			"WHERE fren_ncorr=(SELECT TOP 1 fren_ncorr AS valor FROM ocag_detalle_rendicion_fondo_rendir WHERE rfre_ncorr="& numero & ") AND (b.tdoc_tdesc_softland = 'BE' OR b.tdoc_tdesc_softland = 'BH' OR b.tdoc_tdesc_softland = 'FL' OR b.tdoc_tdesc_softland = 'FE' OR b.tdoc_tdesc_softland = 'FI' OR b.tdoc_tdesc_softland = 'FP')"& vbCrLf &_ 
		"UNION "& vbCrLf &_ 
			"SELECT '2-10-070-10-000002' AS TSOF_PLAN_CUENTA,"& vbCrLf &_
			"0 AS TSOF_DEBE,"& vbCrLf &_ 
			"drfr_mdocto AS TSOF_HABER,"& vbCrLf &_ 
			"null AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_ 
			"replace(a.drfr_trut, right(a.drfr_trut,2),'') AS TSOF_COD_AUXILIAR,"& vbCrLf &_ 
			"protic.ocag_retorna_fecha_normal(GETDATE(),7) AS TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_ 
			"b.tdoc_tdesc_softland AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_ 
			"a.drfr_ndocto AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_ 
			"0 as rete,"& vbCrLf &_
			" CASE WHEN (b.tdoc_tdesc_softland = 'BE' OR b.tdoc_tdesc_softland = 'BH') THEN 1 ELSE 0 END AS boleta"& vbCrLf &_
			"FROM ocag_detalle_rendicion_fondo_rendir a"& vbCrLf &_ 
			"INNER JOIN ocag_tipo_documento b ON a.tdoc_ccod=b.tdoc_ccod "& vbCrLf &_ 
			"INNER JOIN ocag_tipo_gasto c ON a.tgas_ccod=c.tgas_ccod"& vbCrLf &_ 
			"WHERE fren_ncorr=(SELECT TOP 1 fren_ncorr AS valor FROM ocag_detalle_rendicion_fondo_rendir WHERE rfre_ncorr="& numero & ") AND (b.tdoc_tdesc_softland = 'BE' OR b.tdoc_tdesc_softland = 'BH' OR b.tdoc_tdesc_softland = 'FL' OR b.tdoc_tdesc_softland = 'FE' OR b.tdoc_tdesc_softland = 'FI' OR b.tdoc_tdesc_softland = 'FP')"
		presupuestorendicionfondorendir = texto
	end function
	
	function presupuestorendicionfondofijo(numero)
		texto = " select '2-10-070-10-000002' as tsof_plan_cuenta,"& vbCrLf &_
			" 0 AS tsof_debe,"& vbCrLf &_
			" CASE WHEN x.tdoc_ccod = 11 OR x.tdoc_ccod = 1 THEN CONVERT(INT, ROUND(x.drff_mdocto*0.9,0)) ELSE x.drff_mdocto END as TSOF_HABER,"& vbCrLf &_
			" CONVERT(VARCHAR(20),b.PERS_NRUT) +'-'+b.PERS_XDV as TSOF_COD_AUXILIAR,"& vbCrLf &_
			" protic.ocag_retorna_fecha_normal(GETDATE(),8) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" e.tdoc_tdesc_softland AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" x.drff_ndocto AS TSOF_NRO_DOC_REFERENCIA,  "&_
			" null as TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" 0 AS rete,"& vbCrLf &_
			" 0 AS boleta"& vbCrLf &_
			" from ocag_rendicion_fondo_fijo w "&_
			" INNER JOIN ocag_detalle_rendicion_fondo_fijo x ON w.rffi_ncorr = X.rffi_ncorr and w.rffi_ncorr ="&numero&" "&_
			" inner join ocag_presupuesto_solicitud z ON X.ffij_ncorr = Z.cod_solicitud  and z.tsol_ccod=6 "& vbCrLf &_
			" INNER JOIN ocag_fondo_fijo a ON z.cod_solicitud = a.ffij_ncorr"& vbCrLf &_
			" INNER JOIN personas b ON x.pers_nrut = b.pers_nrut"& vbCrLf &_
			" INNER JOIN ocag_tipo_documento e ON x.tdoc_ccod = e.tdoc_ccod" & vbCrLf &_
			" UNION "& vbCrLf &_
			" select '2-10-070-10-000002' as tsof_plan_cuenta,"& vbCrLf &_
			" w.drff_mdocto AS tsof_debe,"& vbCrLf &_
			" 0 as TSOF_HABER,"& vbCrLf &_
			" CONVERT(VARCHAR(20),b.PERS_NRUT) +'-'+b.PERS_XDV as TSOF_COD_AUXILIAR,"& vbCrLf &_
			" protic.ocag_retorna_fecha_normal(GETDATE(),8) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" e.tdoc_tdesc_softland AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" w.drff_ndocto AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			" NULL as TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" CASE WHEN w.tdoc_ccod = 11 OR w.tdoc_ccod = 1 THEN 1 ELSE 0 END AS rete,"& vbCrLf &_
			" CASE WHEN w.tdoc_ccod = 11 OR w.tdoc_ccod = 1 THEN 1 ELSE 0 END AS boleta"& vbCrLf &_
			" from  ocag_detalle_rendicion_fondo_fijo w"& vbCrLf &_
			" INNER JOIN ocag_presupuesto_solicitud z ON w.ffij_ncorr = Z.cod_solicitud and w.rffi_ncorr =42 and z.tsol_ccod=6"& vbCrLf &_
			" INNER JOIN ocag_fondo_fijo a ON w.ffij_ncorr = a.ffij_ncorr"& vbCrLf &_
			" INNER JOIN personas b ON w.pers_nrut = b.pers_nrut"& vbCrLf &_
			" INNER JOIN ocag_tipo_documento e ON w.tdoc_ccod = e.tdoc_ccod "
		presupuestorendicionfondofijo = texto
	end function
	
	function presupuestopagoproveedortotal(numero)
		texto = "SELECT '2-10-070-10-000004' AS TSOF_PLAN_CUENTA,"& vbCrLf &_
			" e.psol_mpresupuesto AS TSOF_DEBE,"& vbCrLf &_
			" 0 AS TSOF_HABER, "& vbCrLf &_
			" e.cod_pre AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" CONVERT(VARCHAR(20),b.PERS_NRUT) +'-'+b.PERS_XDV AS TSOF_COD_AUXILIAR, "& vbCrLf &_
			" protic.ocag_retorna_fecha_normal(GETDATE(),1) AS TSOF_FECHA_VENCIMIENTO_CORTA, "& vbCrLf &_
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" CAST(a.sogi_ncorr AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
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
			"	e.cod_pre AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			"	CONVERT(VARCHAR(20),b.PERS_NRUT) +'-'+b.PERS_XDV AS TSOF_COD_AUXILIAR, "& vbCrLf &_
			"	protic.ocag_retorna_fecha_normal(GETDATE(),1) AS TSOF_FECHA_VENCIMIENTO_CORTA, "& vbCrLf &_
			"	'BC' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			"	CAST(a.sogi_ncorr AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			"	0 AS rete,"& vbCrLf &_
			"	a.sogi_bboleta_honorario AS boleta "& vbCrLf &_
			"	FROM ocag_solicitud_giro a "& vbCrLf &_
			"		INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr ="& numero & vbCrLf &_
			"		INNER JOIN ocag_detalle_solicitud_ag c ON a.sogi_ncorr = c.sogi_ncorr "& vbCrLf &_
			"		INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod "& vbCrLf &_
			"		INNER JOIN ocag_presupuesto_solicitud e ON e.cod_solicitud=a.sogi_ncorr AND e.tsol_ccod=1"& vbCrLf &_ 
			"		INNER JOIN ocag_detalle_solicitud_giro f ON f.sogi_ncorr=a.sogi_ncorr"& vbCrLf &_ 
			"		INNER JOIN ocag_tipo_documento g ON g.tdoc_ccod = f.tdoc_ccod"
		presupuestopagoproveedortotal = texto
	end function	
	
	function presupuestoreembolsototal(numero)
		texto = "select '2-10-070-10-000002' as tsof_plan_cuenta,"& vbCrLf &_
			"	b.rgas_mgiro as tsof_debe,"& vbCrLf &_
			"	0 as TSOF_HABER, "& vbCrLf &_
			"	protic.ocag_retorna_fecha_normal(GETDATE(),2) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			"	CONVERT(VARCHAR(20),c.PERS_NRUT) +'-'+c.PERS_XDV AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			"   null AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			"	'BC' AS TSOF_TIPO_DOC_REFERENCIA, "& vbCrLf &_
			"	b.rgas_ncorr AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			"	0 AS rete,"& vbCrLf &_
			"	0 AS boleta"& vbCrLf &_
			"	from ocag_presupuesto_solicitud a "& vbCrLf &_
			"	INNER JOIN ocag_reembolso_gastos b ON a.cod_solicitud = b.rgas_ncorr AND cod_solicitud ="& numero &"  AND a.tsol_ccod = 2  "& vbCrLf &_
			"	INNER JOIN ocag_detalle_reembolso_gasto d ON d.rgas_ncorr = b.rgas_ncorr"& vbCrLf &_
			"	INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr "& vbCrLf &_
			"	INNER JOIN ocag_presupuesto_solicitud ops ON b.rgas_ncorr=ops.cod_solicitud"& vbCrLf &_
			"UNION"& vbCrLf &_
			"select '2-10-070-10-000002' as tsof_plan_cuenta,"& vbCrLf &_
			"	0 as tsof_debe,"& vbCrLf &_
			"	b.rgas_mgiro as TSOF_HABER,"& vbCrLf &_ 
			"	protic.ocag_retorna_fecha_normal(GETDATE(),2) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			"	CONVERT(VARCHAR(20),c.PERS_NRUT) +'-'+c.PERS_XDV AS TSOF_COD_AUXILIAR,"& vbCrLf &_
			"   null AS TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			"	'BC' AS TSOF_TIPO_DOC_REFERENCIA, "& vbCrLf &_
			"	b.rgas_ncorr AS TSOF_NRO_DOC_REFERENCIA,"& vbCrLf &_
			"	0 AS rete,"& vbCrLf &_
			"	0 AS boleta"& vbCrLf &_
			"	from ocag_presupuesto_solicitud a "& vbCrLf &_
			"	INNER JOIN ocag_reembolso_gastos b ON a.cod_solicitud = b.rgas_ncorr AND cod_solicitud ="& numero &"  AND a.tsol_ccod = 2  "& vbCrLf &_
			"	INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr "& vbCrLf &_
			"	INNER JOIN ocag_presupuesto_solicitud ops ON b.rgas_ncorr=ops.cod_solicitud"
		presupuestoreembolsototal = texto
	end function
	
	function presupuestosolicitudviaticototal(numero)
		texto ="select '2-10-070-10-000004' as tsof_plan_cuenta," & vbCrLf &_
			" psol_mpresupuesto as tsof_debe," & vbCrLf &_
			" 0 as TSOF_HABER," & vbCrLf &_
			" CONVERT(VARCHAR(20),c.PERS_NRUT) +'-'+c.PERS_XDV as TSOF_COD_AUXILIAR," & vbCrLf &_
			" protic.ocag_retorna_fecha_normal(GETDATE(),4) as TSOF_FECHA_VENCIMIENTO_CORTA," & vbCrLf &_
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA," & vbCrLf &_
			" b.sovi_ncorr AS TSOF_NRO_DOC_REFERENCIA," & vbCrLf &_
			" a.cod_pre as TSOF_COD_CENTRO_COSTO" & vbCrLf &_
			" from ocag_presupuesto_solicitud  a" & vbCrLf &_
			" INNER JOIN ocag_solicitud_viatico b ON a.cod_solicitud = b.sovi_ncorr AND cod_solicitud ="&numero&" AND a.tsol_ccod = 4" & vbCrLf &_
			" INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr" & vbCrLf &_
			" union" & vbCrLf &_
			" select '2-10-070-10-000004' as tsof_plan_cuenta," & vbCrLf &_
			" 0 as tsof_debe," & vbCrLf &_
			" a.psol_mpresupuesto as TSOF_HABER," & vbCrLf &_
			" CONVERT(VARCHAR(20),c.PERS_NRUT) +'-'+c.PERS_XDV as TSOF_COD_AUXILIAR," & vbCrLf &_
			" protic.ocag_retorna_fecha_normal(GETDATE(),4) as TSOF_FECHA_VENCIMIENTO_CORTA," & vbCrLf &_
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA," & vbCrLf &_
			" b.sovi_ncorr AS TSOF_NRO_DOC_REFERENCIA," & vbCrLf &_
			" a.cod_pre as TSOF_COD_CENTRO_COSTO" & vbCrLf &_
			" from ocag_presupuesto_solicitud a " & vbCrLf &_
			" INNER JOIN ocag_solicitud_viatico b ON a.cod_solicitud = b.sovi_ncorr AND cod_solicitud ="&numero&" AND a.tsol_ccod = 4" & vbCrLf &_
			" INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr"
		presupuestosolicitudviaticototal = texto
	end function
	
	function presupuestodevolucionalumnototal(numero)
		texto="select '1-10-040-30-' + RTRIM(LTRIM(c.CCOS_TCODIGO)) as tsof_plan_cuenta," & vbCrLf &_
			" dalu_mmonto_pesos as tsof_debe," & vbCrLf &_
			" 0 as TSOF_HABER,"&_
			" a.pers_nrut_alu as TSOF_COD_AUXILIAR,"&_
			" protic.ocag_retorna_fecha_normal(GETDATE(),5) as TSOF_FECHA_VENCIMIENTO_CORTA,"&_
			" '' AS TSOF_TIPO_DOC_REFERENCIA," & vbCrLf &_
			" '' AS TSOF_NRO_DOC_REFERENCIA," & vbCrLf &_
			" '' as TSOF_COD_CENTRO_COSTO" & vbCrLf &_
			" from ocag_devolucion_alumno a "&_
			" INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and a.dalu_ncorr ="&numero&_
			" INNER JOIN CENTROS_COSTO c on a.ccos_ccod = c.CCOS_CCOD"&_
			" union"&_
			" select '1-10-040-30-' + LTRIM(c.CCOS_TCODIGO) as tsof_plan_cuenta," & vbCrLf &_
			" 0 as tsof_debe," & vbCrLf &_
			" dalu_mmonto_pesos as TSOF_HABER,"&_
			" a.pers_nrut_alu as TSOF_COD_AUXILIAR,"&_
			" protic.ocag_retorna_fecha_normal(GETDATE(),5) as TSOF_FECHA_VENCIMIENTO_CORTA,"&_
			" '' AS TSOF_TIPO_DOC_REFERENCIA," & vbCrLf &_
			" '' AS TSOF_NRO_DOC_REFERENCIA," & vbCrLf &_
			" '' as TSOF_COD_CENTRO_COSTO"& vbCrLf &_
			" from ocag_devolucion_alumno a "& vbCrLf &_
			" INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and a.dalu_ncorr ="&numero& vbCrLf &_
			" INNER JOIN CENTROS_COSTO c on a.ccos_ccod = c.CCOS_CCOD"
		presupuestodevolucionalumnototal = texto
	end function
	
	function presupuestofondofijototal(numero)
		texto ="select '2-10-070-10-000004' as tsof_plan_cuenta," & vbCrLf &_
			" 0 as tsof_debe," & vbCrLf &_
			" a.psol_mpresupuesto as TSOF_HABER," & vbCrLf &_
			" a.cod_pre as TSOF_COD_CENTRO_COSTO," & vbCrLf &_
			" CONVERT(VARCHAR(20),c.PERS_NRUT) +'-'+c.PERS_XDV as TSOF_COD_AUXILIAR," & vbCrLf &_
			" protic.ocag_retorna_fecha_normal(GETDATE(),6) as TSOF_FECHA_VENCIMIENTO_CORTA," & vbCrLf &_
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA," & vbCrLf &_
			" b.ffij_ncorr AS TSOF_NRO_DOC_REFERENCIA "&_
			" FROM ocag_presupuesto_solicitud a "&_
			" INNER JOIN ocag_fondo_fijo b ON a.cod_solicitud = b.ffij_ncorr AND cod_solicitud ="&numero&" AND a.tsol_ccod = 6 "& vbCrLf &_
			" INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr "& vbCrLf &_
			" UNION "&_
			" select '2-10-070-10-000004' as tsof_plan_cuenta," & vbCrLf &_
			" a.psol_mpresupuesto as tsof_debe," & vbCrLf &_
			" 0 as TSOF_HABER," & vbCrLf &_
			" a.cod_pre as TSOF_COD_CENTRO_COSTO," & vbCrLf &_
			" CONVERT(VARCHAR(20),c.PERS_NRUT) +'-'+c.PERS_XDV as TSOF_COD_AUXILIAR," & vbCrLf &_
			" protic.ocag_retorna_fecha_normal(GETDATE(),6) as TSOF_FECHA_VENCIMIENTO_CORTA," & vbCrLf &_
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA," & vbCrLf &_
			" b.ffij_ncorr AS TSOF_NRO_DOC_REFERENCIA "&_
			" FROM ocag_presupuesto_solicitud a "&_
			" INNER JOIN ocag_fondo_fijo b "&_
			" ON a.cod_solicitud = b.ffij_ncorr AND cod_solicitud ="&numero&" AND a.tsol_ccod = 6 "&_
			" INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr"
		presupuestofondofijototal = texto
	end function

	function presupuestorendicionfondorendirtotal(numero)
		texto ="SELECT TOP 1 '2-10-070-10-000004' AS TSOF_PLAN_CUENTA," & vbCrLf &_
			" (SELECT (SELECT SUM(CASE WHEN b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH' THEN drfr_mretencion ELSE 0 END) AS TSOF_HABER FROM ocag_detalle_rendicion_fondo_rendir a INNER JOIN ocag_tipo_documento b ON a.tdoc_ccod=b.tdoc_ccod AND a.rfre_ncorr="&numero&") FROM ocag_fondos_a_rendir WHERE fren_ncorr = (SELECT TOP 1 fren_ncorr FROM ocag_detalle_rendicion_fondo_rendir WHERE rfre_ncorr="&numero&")) AS TSOF_DEBE," & vbCrLf &_
			" 0 AS TSOF_HABER," & vbCrLf &_
			" f.cod_pre AS TSOF_COD_CENTRO_COSTO," & vbCrLf &_
			" replace(a.drfr_trut, right(a.drfr_trut,2),'') AS TSOF_COD_AUXILIAR," & vbCrLf &_
			" protic.ocag_retorna_fecha_normal(GETDATE(),7) AS TSOF_FECHA_VENCIMIENTO_CORTA," & vbCrLf &_
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA," & vbCrLf &_
			" "& numero &" AS TSOF_NRO_DOC_REFERENCIA," & vbCrLf &_
			" 0 AS rete," & vbCrLf &_
			" 0 AS boleta" & vbCrLf &_
			" FROM ocag_detalle_rendicion_fondo_rendir a INNER JOIN ocag_tipo_documento b ON a.tdoc_ccod=b.tdoc_ccod" & vbCrLf &_
			" INNER JOIN ocag_tipo_gasto c ON a.tgas_ccod=c.tgas_ccod" & vbCrLf &_
			" INNER JOIN ocag_rendicion_fondos_a_rendir e ON e.fren_ncorr=a.fren_ncorr AND a.rfre_ncorr=" & numero & vbCrLf &_
			" INNER JOIN ocag_presupuesto_solicitud f ON f.cod_solicitud = a.fren_ncorr AND f.tsol_ccod=3" & vbCrLf &_
			" UNION " & vbCrLf &_
			" SELECT TOP 1 '2-10-070-10-000004' AS TSOF_PLAN_CUENTA," & vbCrLf &_
			" 0 AS TSOF_DEBE," & vbCrLf &_
			" 	(SELECT (SELECT SUM(CASE WHEN b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH' THEN drfr_mretencion ELSE 0 END) AS TSOF_HABER FROM ocag_detalle_rendicion_fondo_rendir a INNER JOIN ocag_tipo_documento b ON a.tdoc_ccod=b.tdoc_ccod AND a.rfre_ncorr="&numero&") FROM ocag_fondos_a_rendir WHERE fren_ncorr = (SELECT TOP 1 fren_ncorr FROM ocag_detalle_rendicion_fondo_rendir WHERE rfre_ncorr="&numero&")) AS TSOF_HABER," & vbCrLf &_
			" f.cod_pre AS TSOF_COD_CENTRO_COSTO," & vbCrLf &_
			" replace(a.drfr_trut, right(a.drfr_trut,2),'') AS TSOF_COD_AUXILIAR," & vbCrLf &_
			" protic.ocag_retorna_fecha_normal(GETDATE(),7) AS TSOF_FECHA_VENCIMIENTO_CORTA," & vbCrLf &_
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA," & vbCrLf &_
			" "& numero &" AS TSOF_NRO_DOC_REFERENCIA," & vbCrLf &_
			" 0 AS rete," & vbCrLf &_
			" 0 AS boleta" & vbCrLf &_
			" FROM ocag_detalle_rendicion_fondo_rendir a" & vbCrLf &_
			" INNER JOIN ocag_tipo_documento b ON a.tdoc_ccod=b.tdoc_ccod "&_
			" INNER JOIN ocag_tipo_gasto c ON a.tgas_ccod=c.tgas_ccod" & vbCrLf &_
			" INNER JOIN ocag_rendicion_fondos_a_rendir e ON e.fren_ncorr=a.fren_ncorr AND a.rfre_ncorr=" & numero & vbCrLf &_
			" INNER JOIN ocag_presupuesto_solicitud f ON f.cod_solicitud = a.fren_ncorr AND f.tsol_ccod=3"
		arreglo = diferencia(numero)
		if arreglo(0) then
			texto = texto & "UNION SELECT TOP 1 '"&arreglo(1)&"' AS TSOF_PLAN_CUENTA," & vbCrLf &_
				" '"&arreglo(2)&"' AS TSOF_DEBE," & vbCrLf &_
				" 0 AS TSOF_HABER," & vbCrLf &_
				" f.cod_pre AS TSOF_COD_CENTRO_COSTO," & vbCrLf &_
				" replace(a.drfr_trut, right(a.drfr_trut,2),'') AS TSOF_COD_AUXILIAR," & vbCrLf &_
				" protic.ocag_retorna_fecha_normal(GETDATE(),7) AS TSOF_FECHA_VENCIMIENTO_CORTA," & vbCrLf &_
				" 'BC' AS TSOF_TIPO_DOC_REFERENCIA," & vbCrLf &_
				" "& numero &" AS TSOF_NRO_DOC_REFERENCIA," & vbCrLf &_
				" 0 AS rete," & vbCrLf &_
				" 0 AS boleta" & vbCrLf &_
				" FROM ocag_detalle_rendicion_fondo_rendir a INNER JOIN ocag_tipo_documento b ON a.tdoc_ccod=b.tdoc_ccod" & vbCrLf &_
				" INNER JOIN ocag_tipo_gasto c ON a.tgas_ccod=c.tgas_ccod" & vbCrLf &_
				" INNER JOIN ocag_rendicion_fondos_a_rendir e ON e.fren_ncorr=a.fren_ncorr AND a.rfre_ncorr=" & numero & vbCrLf &_
				" INNER JOIN ocag_presupuesto_solicitud f ON f.cod_solicitud = a.fren_ncorr AND f.tsol_ccod=3" & vbCrLf &_
				" UNION " & vbCrLf &_
				" SELECT TOP 1 '"&arreglo(1)&"' AS TSOF_PLAN_CUENTA," & vbCrLf &_
				" 0 AS TSOF_DEBE," & vbCrLf &_
				" '"&arreglo(2)&"' AS TSOF_HABER," & vbCrLf &_
				" f.cod_pre AS TSOF_COD_CENTRO_COSTO," & vbCrLf &_
				" replace(a.drfr_trut, right(a.drfr_trut,2),'') AS TSOF_COD_AUXILIAR," & vbCrLf &_
				" protic.ocag_retorna_fecha_normal(GETDATE(),7) AS TSOF_FECHA_VENCIMIENTO_CORTA," & vbCrLf &_
				" 'BC' AS TSOF_TIPO_DOC_REFERENCIA," & vbCrLf &_
				" "& numero &" AS TSOF_NRO_DOC_REFERENCIA," & vbCrLf &_
				" 0 AS rete," & vbCrLf &_
				" 0 AS boleta" & vbCrLf &_
				" FROM ocag_detalle_rendicion_fondo_rendir a" & vbCrLf &_
				" INNER JOIN ocag_tipo_documento b ON a.tdoc_ccod=b.tdoc_ccod "&_
				" INNER JOIN ocag_tipo_gasto c ON a.tgas_ccod=c.tgas_ccod" & vbCrLf &_
				" INNER JOIN ocag_rendicion_fondos_a_rendir e ON e.fren_ncorr=a.fren_ncorr AND a.rfre_ncorr=" & numero & vbCrLf &_
				" INNER JOIN ocag_presupuesto_solicitud f ON f.cod_solicitud = a.fren_ncorr AND f.tsol_ccod=3"
		end if
		presupuestorendicionfondorendirtotal = texto
	end function
	
	function presupuestorendicionfondofijototal(numero)
		texto = " select '2-10-070-10-000004' as tsof_plan_cuenta,"& vbCrLf &_
			" CONVERT(INT, ROUND((SELECT SUM(CASE WHEN tdoc_ccod = 11 THEN odff.drff_mdocto*0.9 ELSE odff.drff_mdocto END) FROM ocag_detalle_rendicion_fondo_fijo odff WHERE rffi_ncorr="&numero&"),0)) as tsof_debe,"& vbCrLf &_
			" 0 as TSOF_HABER,"& vbCrLf &_
			" CONVERT(VARCHAR(20),c.PERS_NRUT) +'-'+c.PERS_XDV as TSOF_COD_AUXILIAR,"& vbCrLf &_
			" protic.ocag_retorna_fecha_normal(GETDATE(),8) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" b.ffij_ncorr AS TSOF_NRO_DOC_REFERENCIA, a.cod_pre as TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" 0 AS rete,"& vbCrLf &_
		 	" 0 AS boleta"& vbCrLf &_
			"FROM ocag_presupuesto_solicitud a"& vbCrLf &_
			"INNER JOIN ocag_fondo_fijo b ON a.cod_solicitud = b.ffij_ncorr AND cod_solicitud =(SELECT ffij_ncorr FROM ocag_rendicion_fondo_fijo WHERE rffi_ncorr="&numero&" ) AND a.tsol_ccod = 6"& vbCrLf &_
			"INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr"& vbCrLf &_
			"INNER JOIN ocag_detalle_rendicion_fondo_fijo d ON d.ffij_ncorr=b.ffij_ncorr" & vbCrLf &_
			" UNION "& vbCrLf &_
			" select '2-10-070-10-000004' as tsof_plan_cuenta,"& vbCrLf &_
			" 0 as tsof_debe,"& vbCrLf &_
			" CONVERT(INT, ROUND((SELECT SUM(CASE WHEN tdoc_ccod = 11 THEN odff.drff_mdocto*0.9 ELSE odff.drff_mdocto END) FROM ocag_detalle_rendicion_fondo_fijo odff WHERE rffi_ncorr="&numero&"),0)) as TSOF_HABER,"& vbCrLf &_
			" CONVERT(VARCHAR(20),c.PERS_NRUT) +'-'+c.PERS_XDV as TSOF_COD_AUXILIAR,"& vbCrLf &_
			" protic.ocag_retorna_fecha_normal(GETDATE(),8) as TSOF_FECHA_VENCIMIENTO_CORTA,"& vbCrLf &_
			" 'BC' AS TSOF_TIPO_DOC_REFERENCIA,"& vbCrLf &_
			" b.ffij_ncorr AS TSOF_NRO_DOC_REFERENCIA, a.cod_pre as TSOF_COD_CENTRO_COSTO,"& vbCrLf &_
			" 0 AS rete,"& vbCrLf &_
		 	" 0 AS boleta"& vbCrLf &_
			"FROM ocag_presupuesto_solicitud a"& vbCrLf &_
			"INNER JOIN ocag_fondo_fijo b ON a.cod_solicitud = b.ffij_ncorr AND cod_solicitud =(SELECT ffij_ncorr FROM ocag_rendicion_fondo_fijo WHERE rffi_ncorr="&numero&" ) AND a.tsol_ccod = 6"& vbCrLf &_
			"INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr"& vbCrLf &_
			"INNER JOIN ocag_detalle_rendicion_fondo_fijo d ON d.ffij_ncorr=b.ffij_ncorr"
		presupuestorendicionfondofijototal = texto
	end function
	
	function diferencia(numero)
		Dim array(2)
		set conectar = new cconexion
		conectar.inicializar "upacifico"
		
		set grilla = new CFormulario
		grilla.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
		grilla.Inicializar conectar

		sql = "SELECT fren_mmonto-"& vbCrLf &_
			"	(SELECT SUM(CASE WHEN b.tdoc_tdesc_softland='BE' OR b.tdoc_tdesc_softland='BH' THEN drfr_mdocto-drfr_mretencion ELSE drfr_mdocto END) AS TSOF_HABER"& vbCrLf &_
			"		FROM ocag_detalle_rendicion_fondo_rendir a "& vbCrLf &_
			"		INNER JOIN ocag_tipo_documento b ON a.tdoc_ccod=b.tdoc_ccod AND a.rfre_ncorr="&numero&") AS TSOF_HABER"& vbCrLf &_
			"FROM ocag_fondos_a_rendir WHERE fren_ncorr = (SELECT TOP 1 fren_ncorr FROM ocag_detalle_rendicion_fondo_rendir WHERE rfre_ncorr="&numero&")"
		response.write sql
		grilla.Consultar sql
		grilla.siguiente
		
		if clng(grilla.obtenerValor("TSOF_HABER")) <> 0 then
			array(0) = true
			if clng(grilla.obtenerValor("TSOF_HABER")) > 0 then
				array(1) = "2-10-070-10-000003"
				array(2) = grilla.obtenerValor("TSOF_HABER")
			else
				array(1) = "2-10-070-10-000004"
				array(2) = clng(grilla.obtenerValor("TSOF_HABER"))*(-1)
			end if
		else
			array(0) = false
			array(1) = "0"
			array(2) = "0"
		end if
		for i=0 to 2
			response.write array(i)
		next
		diferencia = array
	end function
%>
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_rutas.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Server.ScriptTimeout = 2000 

set conexion = new CConexion
conexion.Inicializar "upacifico"

set conectar = new Cconexion2
conectar.Inicializar "upacifico"

set p_conexion = new CConexion
p_conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario = negocio.ObtenerUsuario

' 888888888888888888888888888888888888888888888888888888888888888888888888888888888

sql_softland	=	"SELECT TOP 1 DLICOINT "& vbCrLf &_   
							" FROM softland.cwdetli WHERE YEAR(cpbFEC)=YEAR(getdate()) AND MONTH(cpbfec)=MONTH(getdate()) "& vbCrLf &_   
							" ORDER BY DLICOINT DESC "

set f_cheques = new CFormulario
f_cheques.Carga_Parametros "carga_contable.xml", "cheques"

f_cheques.Inicializar conectar

f_cheques.Consultar sql_softland
f_cheques.siguiente
V_DLICOINT=f_cheques.obtenerValor("DLICOINT")
	
IF V_DLICOINT="" then
V_DLICOINT=0
END IF

' 888888888888888888888888888888888888888888888888888888888888888888888888888888888

'------------------------------------------------------------------------------------

sql_nombre= "Select PERS_TAPE_PATERNO + '_' + SUBSTRING(PERS_TNOMBRE,1,1) as NOMBRE from personas "& vbCrLf &_
			"where cast(pers_nrut as varchar)='"&v_usuario&"'"

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

'RESPONSE.WRITE("1. sql_nombre : "&sql_nombre&"<BR>")
'RESPONSE.WRITE("2. v_ano_caja : "&v_ano_caja&"<BR>")
'RESPONSE.WRITE("3. v_mes_caja : "&v_mes_caja&"<BR>")
'RESPONSE.WRITE("4. v_dia_caja : "&v_dia_caja&"<BR>")

' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

ind2=0
for each k in request.form

	v_solicitud=request.Form("datos["&ind2&"][cod_solicitud]")
	tsol_ccod=request.Form("datos["&ind2&"][tsol_ccod]")
	v_boleta=request.Form("datos["&ind2&"][sogi_bboleta_honorario]")

	RESPONSE.WRITE(ind2&". cod_solicitud : "&v_solicitud&"<BR>")
	RESPONSE.WRITE(ind2&". tsol_ccod : "&tsol_ccod&"<BR>")
	RESPONSE.WRITE(ind2&". v_boleta : "&v_boleta&"<BR>")
	'RESPONSE.END()

	' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

	if v_solicitud <> "" then

		select case tsol_ccod
		
			Case 1: ' Pago Proveedores
		
				txt_tipo="Pago_Proveedores"
		
				pago_boleta="select DISTINCT ISNULL(a.ordc_ncorr,0) as ordc_ncorr "&_
					" from ocag_solicitud_giro a "&_
					" LEFT JOIN ocag_detalle_solicitud_ag b "&_
					" ON a.sogi_ncorr=B.sogi_ncorr WHERE cast(a.sogi_ncorr as varchar)='"&v_solicitud&"'"
										
				IF CInt(v_boleta)  = 1 THEN			
					sql_doctos = "select * from (  "&_
						" select CASE WHEN a.cpag_ccod = 25 THEN '1-10-010-30-100001' ELSE '2-10-070-10-000002' END as tsof_plan_cuenta, 0 as tsof_debe "&_
						" , a.sogi_mgiro as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO "&_
						" , CAST(b.pers_nrut AS VARCHAR) as TSOF_COD_AUXILIAR, LTRIM(RTRIM('bc')) as TSOF_TIPO_DOCUMENTO "&_
						" , CAST(a.sogi_ncorr AS VARCHAR) as TSOF_NRO_DOCUMENTO, protic.trunc(a.sogi_fecha_solicitud) as TSOF_FECHA_EMISION_CORTA "&_
						" , protic.trunc(d.dpva_fpago) as TSOF_FECHA_VENCIMIENTO_CORTA, LTRIM(RTRIM('bc')) AS TSOF_TIPO_DOC_REFERENCIA "&_
						" , CAST(a.sogi_ncorr AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA, NULL AS TSOF_MONTO_DET_LIBRO1 "&_
						" , NULL AS TSOF_MONTO_DET_LIBRO2,NULL AS TSOF_MONTO_SUMA_DET_LIBRO, '' as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR "&_
						" , '' AS TSOF_NRO_CORRELATIVO"&_
						" from ocag_solicitud_giro a  "&_
						" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr="&v_solicitud&" "&_
						" INNER JOIN ocag_validacion_contable c ON a.sogi_ncorr=c.cod_solicitud AND isnull(c.tsol_ccod,1)=1 "&_
						" INNER JOIN ocag_detalle_pago_validacion d ON c.vcon_ncorr = d.vcon_ncorr "&_
						" UNION "&_
						" select CASE WHEN a.cpag_ccod = 25 THEN '1-10-010-30-100001' ELSE '2-10-070-10-000002' END as tsof_plan_cuenta, e.dsgi_mdocto as tsof_debe "&_
						" , 0 as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO "&_
						" , CAST(b.pers_nrut AS VARCHAR) as TSOF_COD_AUXILIAR, LTRIM(RTRIM('bc')) as TSOF_TIPO_DOCUMENTO "&_
						" , CAST(e.dsgi_ndocto AS VARCHAR) as TSOF_NRO_DOCUMENTO, protic.trunc(e.dogi_fecha_documento) as TSOF_FECHA_EMISION_CORTA "&_
						" , protic.trunc(d.dpva_fpago) as TSOF_FECHA_VENCIMIENTO_CORTA, LTRIM(RTRIM(f.tdoc_tdesc_softland)) AS TSOF_TIPO_DOC_REFERENCIA "&_
						" , CAST(e.dsgi_ndocto AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA, e.dsgi_mhonorarios AS TSOF_MONTO_DET_LIBRO1 "&_
						" , e.dsgi_mretencion AS TSOF_MONTO_DET_LIBRO2, e.dsgi_mdocto as TSOF_MONTO_SUMA_DET_LIBRO "&_
						" , '' as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR  "&_
						" , '' AS TSOF_NRO_CORRELATIVO"&_
						" from ocag_solicitud_giro a "&_
						" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr="&v_solicitud&" "&_
						" INNER JOIN ocag_validacion_contable c ON a.sogi_ncorr=c.cod_solicitud AND isnull(c.tsol_ccod,1)=1 "&_
						" INNER JOIN ocag_detalle_pago_validacion d ON c.vcon_ncorr = d.vcon_ncorr "&_
						" INNER JOIN ocag_detalle_solicitud_giro e ON a.sogi_ncorr=e.sogi_ncorr "&_
						" INNER JOIN ocag_tipo_documento f ON e.tdoc_ccod=f.tdoc_ccod "&_
						" union "&_
						" select CASE WHEN a.cpag_ccod = 25 THEN '1-10-010-30-100001' ELSE '2-10-070-10-000002' END as tsof_plan_cuenta, 0 as tsof_debe "&_
						" , e.dsgi_mdocto as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO "&_
						" , CAST(b.pers_nrut AS VARCHAR) as TSOF_COD_AUXILIAR , LTRIM(RTRIM(f.tdoc_tdesc_softland)) as TSOF_TIPO_DOCUMENTO "&_
						" , CAST(e.dsgi_ndocto AS VARCHAR) as TSOF_NRO_DOCUMENTO, protic.trunc(e.dogi_fecha_documento) as TSOF_FECHA_EMISION_CORTA "&_
						" , protic.trunc(d.dpva_fpago) as TSOF_FECHA_VENCIMIENTO_CORTA, LTRIM(RTRIM(f.tdoc_tdesc_softland)) AS TSOF_TIPO_DOC_REFERENCIA  "&_
						" , CAST(e.dsgi_ndocto AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA, e.dsgi_mhonorarios AS TSOF_MONTO_DET_LIBRO1 "&_
						" , e.dsgi_mretencion AS TSOF_MONTO_DET_LIBRO2, e.dsgi_mdocto as TSOF_MONTO_SUMA_DET_LIBRO, '' as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR "&_
						" , "&V_DLICOINT&" AS TSOF_NRO_CORRELATIVO"&_ 
						" from ocag_solicitud_giro a  "&_
						" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr="&v_solicitud&" "&_
						" INNER JOIN ocag_validacion_contable c ON a.sogi_ncorr=c.cod_solicitud AND isnull(c.tsol_ccod,1)=1 "&_
						" INNER JOIN ocag_detalle_pago_validacion d ON c.vcon_ncorr = d.vcon_ncorr "&_
						" INNER JOIN ocag_detalle_solicitud_giro e ON a.sogi_ncorr=e.sogi_ncorr "&_
						" INNER JOIN ocag_tipo_documento f ON e.tdoc_ccod=f.tdoc_ccod "&_
						" UNION "&_
						" select '2-10-120-10-000003' as tsof_plan_cuenta, 0 as tsof_debe, CAST(c.dorc_nprecio_neto*0.1 AS INT) as TSOF_HABER "&_
						" , protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO, '' as TSOF_COD_AUXILIAR, '' as TSOF_TIPO_DOCUMENTO "&_
						" , '' as TSOF_NRO_DOCUMENTO, '' as TSOF_FECHA_EMISION_CORTA, '' as TSOF_FECHA_VENCIMIENTO_CORTA "&_
						" , '' AS TSOF_TIPO_DOC_REFERENCIA, '' AS TSOF_NRO_DOC_REFERENCIA, NULL AS TSOF_MONTO_DET_LIBRO1, NULL AS TSOF_MONTO_DET_LIBRO2 "&_
						" , NULL AS TSOF_MONTO_SUMA_DET_LIBRO, e.ccos_tcodigo as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR "&_
						" , '' AS TSOF_NRO_CORRELATIVO"&_
						" FROM ocag_solicitud_giro a "&_
						" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr ="&v_solicitud&" and isnull(a.tsol_ccod,1)=1 "&_
						" INNER JOIN ocag_detalle_solicitud_ag c ON a.sogi_ncorr = c.sogi_ncorr "&_
						" INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod "&_
						" INNER JOIN ocag_centro_costo e ON c.ccos_ncorr = e.ccos_ncorr "&_
						" UNION "&_
						" select d.tgas_cod_cuenta as tsof_plan_cuenta "&_
						" , c.dorc_nprecio_neto as tsof_debe, 0 as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(c.dorc_tdesc))) as TSOF_GLOSA_SIN_ACENTO "&_
						" , '' as TSOF_COD_AUXILIAR, '' as TSOF_TIPO_DOCUMENTO, '' as TSOF_NRO_DOCUMENTO, '' as TSOF_FECHA_EMISION_CORTA "&_
						" , '' as TSOF_FECHA_VENCIMIENTO_CORTA , '' AS TSOF_TIPO_DOC_REFERENCIA, '' AS TSOF_NRO_DOC_REFERENCIA, NULL AS TSOF_MONTO_DET_LIBRO1 "&_
						" , NULL AS TSOF_MONTO_DET_LIBRO2, NULL AS TSOF_MONTO_SUMA_DET_LIBRO, e.ccos_tcodigo as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR  "&_
						" , '' AS TSOF_NRO_CORRELATIVO"&_
						" FROM ocag_solicitud_giro a "&_
						" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr ="&v_solicitud&" and isnull(a.tsol_ccod,1)=1 "&_
						" INNER JOIN ocag_detalle_solicitud_ag c ON a.sogi_ncorr = c.sogi_ncorr "&_
						" INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod  "&_
						" INNER JOIN ocag_centro_costo e ON c.ccos_ncorr = e.ccos_ncorr  "&_
						" ) as tabla order by TSOF_HABER desc"	
						
				END IF
				
				IF CInt(v_boleta)  = 2 THEN
					sql_doctos = "select * from (  "&_
						" select CASE WHEN a.cpag_ccod = 25 THEN '1-10-010-30-100001' ELSE '2-10-070-10-000002' END as tsof_plan_cuenta, 0 as tsof_debe "&_
						" , a.sogi_mgiro as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO "&_
						" , CAST(b.pers_nrut AS VARCHAR) as TSOF_COD_AUXILIAR, LTRIM(RTRIM('bc')) as TSOF_TIPO_DOCUMENTO "&_
						" , CAST(a.sogi_ncorr AS VARCHAR) as TSOF_NRO_DOCUMENTO, protic.trunc(a.sogi_fecha_solicitud) as TSOF_FECHA_EMISION_CORTA "&_
						" , protic.trunc(d.dpva_fpago) as TSOF_FECHA_VENCIMIENTO_CORTA, LTRIM(RTRIM('bc')) AS TSOF_TIPO_DOC_REFERENCIA "&_
						" , CAST(a.sogi_ncorr AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA "&_
						" , NULL AS TSOF_MONTO_DET_LIBRO1 "&_
						" , NULL AS TSOF_MONTO_DET_LIBRO2 "&_
						" , NULL AS TSOF_MONTO_SUMA_DET_LIBRO "&_
						" , '' as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR "&_
						" , '' AS TSOF_NRO_CORRELATIVO"&_
						" from ocag_solicitud_giro a "&_
						" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr="&v_solicitud&" "&_
						" INNER JOIN ocag_validacion_contable c ON a.sogi_ncorr=c.cod_solicitud AND isnull(c.tsol_ccod,1)=1 "&_
						" INNER JOIN ocag_detalle_pago_validacion d ON c.vcon_ncorr = d.vcon_ncorr "&_
						" UNION "&_
						" select CASE WHEN a.cpag_ccod = 25 THEN '1-10-010-30-100001' ELSE '2-10-070-10-000002' END as tsof_plan_cuenta, e.dsgi_mdocto as tsof_debe "&_
						" , 0 as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO  "&_
						" , CAST(b.pers_nrut AS VARCHAR) as TSOF_COD_AUXILIAR, LTRIM(RTRIM('bc')) as TSOF_TIPO_DOCUMENTO  "&_
						" , CAST(e.dsgi_ndocto AS VARCHAR) as TSOF_NRO_DOCUMENTO, protic.trunc(e.dogi_fecha_documento) as TSOF_FECHA_EMISION_CORTA "&_
						" , protic.trunc(d.dpva_fpago) as TSOF_FECHA_VENCIMIENTO_CORTA, LTRIM(RTRIM(f.tdoc_tdesc_softland)) AS TSOF_TIPO_DOC_REFERENCIA  "&_
						" , CAST(e.dsgi_ndocto AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA, e.dsgi_mafecto AS TSOF_MONTO_DET_LIBRO1 "&_
						" , e.dsgi_miva AS TSOF_MONTO_DET_LIBRO2, e.dsgi_mdocto as TSOF_MONTO_SUMA_DET_LIBRO "&_
						" , '' as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR "&_
						" , '' AS TSOF_NRO_CORRELATIVO"&_
						" from ocag_solicitud_giro a "&_
						" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr="&v_solicitud&" "&_
						" INNER JOIN ocag_validacion_contable c ON a.sogi_ncorr=c.cod_solicitud AND isnull(c.tsol_ccod,1)=1 "&_
						" INNER JOIN ocag_detalle_pago_validacion d ON c.vcon_ncorr = d.vcon_ncorr  "&_
						" INNER JOIN ocag_detalle_solicitud_giro e ON a.sogi_ncorr=e.sogi_ncorr "&_
						" INNER JOIN ocag_tipo_documento f ON e.tdoc_ccod=f.tdoc_ccod "&_
						" union "&_
						" select CASE WHEN a.cpag_ccod = 25 THEN '1-10-010-30-100001' ELSE '2-10-070-10-000002' END as tsof_plan_cuenta, 0 as tsof_debe "&_
						" , e.dsgi_mdocto as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO "&_
						" , CAST(b.pers_nrut AS VARCHAR) as TSOF_COD_AUXILIAR , LTRIM(RTRIM(f.tdoc_tdesc_softland)) as TSOF_TIPO_DOCUMENTO "&_
						" , CAST(e.dsgi_ndocto AS VARCHAR) as TSOF_NRO_DOCUMENTO, protic.trunc(e.dogi_fecha_documento) as TSOF_FECHA_EMISION_CORTA "&_
						" , protic.trunc(d.dpva_fpago) as TSOF_FECHA_VENCIMIENTO_CORTA, LTRIM(RTRIM(f.tdoc_tdesc_softland)) AS TSOF_TIPO_DOC_REFERENCIA "&_
						" , CAST(e.dsgi_ndocto AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA, e.dsgi_mafecto AS TSOF_MONTO_DET_LIBRO1 "&_
						" , e.dsgi_miva AS TSOF_MONTO_DET_LIBRO2, e.dsgi_mdocto as TSOF_MONTO_SUMA_DET_LIBRO, '' as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR "&_
						" , '' AS TSOF_NRO_CORRELATIVO"&_ 
						" from ocag_solicitud_giro a "&_
						" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr="&v_solicitud&" "&_
						" INNER JOIN ocag_validacion_contable c ON a.sogi_ncorr=c.cod_solicitud AND isnull(c.tsol_ccod,1)=1 "&_
						" INNER JOIN ocag_detalle_pago_validacion d ON c.vcon_ncorr = d.vcon_ncorr "&_
						" INNER JOIN ocag_detalle_solicitud_giro e ON a.sogi_ncorr=e.sogi_ncorr "&_
						" INNER JOIN ocag_tipo_documento f ON e.tdoc_ccod=f.tdoc_ccod "&_
						" UNION "&_
						" select d.tgas_cod_cuenta as tsof_plan_cuenta "&_
						" , case when c.dorc_bafecta=1 then cast((c.dorc_nprecio_neto)*1.19 as numeric) else c.dorc_nprecio_neto end as tsof_debe , 0 as TSOF_HABER "&_
						" , protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO , '' as TSOF_COD_AUXILIAR, '' as TSOF_TIPO_DOCUMENTO "&_
						" , '' as TSOF_NRO_DOCUMENTO, '' as TSOF_FECHA_EMISION_CORTA, '' as TSOF_FECHA_VENCIMIENTO_CORTA , '' AS TSOF_TIPO_DOC_REFERENCIA "&_
						" , '' AS TSOF_NRO_DOC_REFERENCIA "&_
						" , NULL AS TSOF_MONTO_DET_LIBRO1 "&_
						" , NULL AS TSOF_MONTO_DET_LIBRO2 "&_
						" , NULL AS TSOF_MONTO_SUMA_DET_LIBRO "&_
						" , '' as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR "&_
						" , '' AS TSOF_NRO_CORRELATIVO"&_
						" FROM ocag_solicitud_giro a "&_
						" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr ="&v_solicitud&" and isnull(a.tsol_ccod,1)=1 "&_
						" INNER JOIN ocag_detalle_solicitud_ag c ON a.sogi_ncorr = c.sogi_ncorr "&_
						" INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod "&_
						" INNER JOIN ocag_centro_costo e ON c.ccos_ncorr = e.ccos_ncorr "&_
						" ) as tabla order by TSOF_HABER desc"
						
				END IF
					sql_efes=" select * from (  "&_
						" select '2-10-070-10-000004' as tsof_plan_cuenta, a.psol_mpresupuesto as tsof_debe, 0 as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(b.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO  "&_
						" , c.pers_nrut as TSOF_COD_AUXILIAR, 'TR' as TSOF_TIPO_DOCUMENTO, a.cod_solicitud as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA  "&_
						" , protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, a.cod_solicitud AS TSOF_NRO_DOC_REFERENCIA  "&_
						" , '' as TSOF_COD_CENTRO_COSTO, a.cod_pre as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR  "&_
						" , CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano  "&_
						" , a.psol_mpresupuesto as TSOF_monto_presupuesto  "&_
						" from ocag_presupuesto_solicitud a "&_
						" INNER JOIN ocag_solicitud_giro b ON a.cod_solicitud = b.sogi_ncorr AND a.cod_solicitud ="&v_solicitud&"  AND a.tsol_ccod = 1  "&_
						" INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr  "&_
						" union  "&_
						" select '2-10-070-10-000004' as tsof_plan_cuenta, 0 as tsof_debe, psol_mpresupuesto as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(b.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO  "&_
						" , c.pers_nrut as TSOF_COD_AUXILIAR, 'BC' as TSOF_TIPO_DOCUMENTO, a.cod_solicitud as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso)as TSOF_FECHA_EMISION_CORTA  "&_
						" , protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, a.cod_solicitud AS TSOF_NRO_DOC_REFERENCIA  "&_
						" , '' as TSOF_COD_CENTRO_COSTO, a.cod_pre as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR  "&_
						" , CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano  "&_
						" , a.psol_mpresupuesto as TSOF_monto_presupuesto  "&_
						" from ocag_presupuesto_solicitud a "&_
						" INNER JOIN ocag_solicitud_giro b ON a.cod_solicitud = b.sogi_ncorr AND a.cod_solicitud ="&v_solicitud&"  AND a.tsol_ccod = 1  "&_
						" INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr  "&_
						" ) as tabla  "&_
						" order by TSOF_HABER desc  "
			Case 2: ' Reembolso de gatos
				txt_tipo="Reembolso_Gatos"
						
				sql_doctos = "select * from (  "&_
					" select d.tgas_cod_cuenta as tsof_plan_cuenta, c.drga_mdocto + c.drga_mretencion as tsof_debe, 0 as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(d.tgas_tdesc))) as TSOF_GLOSA_SIN_ACENTO "&_					
					" , NULL as TSOF_COD_AUXILIAR, '' as TSOF_TIPO_DOCUMENTO, a.rgas_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(a.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA  "&_
					" , protic.trunc(a.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, '' AS TSOF_TIPO_DOC_REFERENCIA, a.rgas_ncorr AS TSOF_NRO_DOC_REFERENCIA  "&_
					" , e.ccos_tcodigo as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR  "&_
					" FROM ocag_reembolso_gastos a  "&_
					" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.rgas_ncorr = "&v_solicitud&" "&_
					" INNER JOIN ocag_detalle_reembolso_gasto c ON a.rgas_ncorr = c.rgas_ncorr  "&_
					" INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod  "&_
					" INNER JOIN ocag_centro_costo e ON c.ccos_ncorr = e.ccos_ncorr  "&_
					" union "&_
					" select '2-10-070-10-000002' as tsof_plan_cuenta, 0 as tsof_debe, a.rgas_mgiro as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(C.drga_tdescripcion))) as TSOF_GLOSA_SIN_ACENTO "&_
					" , b.pers_nrut as TSOF_COD_AUXILIAR, 'BC' as TSOF_TIPO_DOCUMENTO, a.rgas_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(a.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA  "&_
					" , protic.trunc(a.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, a.rgas_ncorr AS TSOF_NRO_DOC_REFERENCIA  "&_
					" , '' as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR "&_
					" from ocag_reembolso_gastos a  "&_
					" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr and rgas_ncorr = "&v_solicitud&" "&_
					" INNER JOIN ocag_detalle_reembolso_gasto c ON a.rgas_ncorr = c.rgas_ncorr  "&_
					" ) as tabla order by tsof_debe desc "
			
				sql_efes=" select * from (  "&_
					"select '2-10-070-10-000004' as tsof_plan_cuenta, d.drga_mdocto + d.drga_mretencion as tsof_debe, 0 as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(d.drga_tdescripcion))) as TSOF_GLOSA_SIN_ACENTO  "&_
					", c.pers_nrut as TSOF_COD_AUXILIAR, otd.tdoc_tdesc_softland as TSOF_TIPO_DOCUMENTO, b.rgas_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA  "&_
					", protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, b.rgas_ncorr AS TSOF_NRO_DOC_REFERENCIA  "&_
					", '' as TSOF_COD_CENTRO_COSTO, a.cod_pre as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR  "&_
					", CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano  "&_
					", d.drga_mdocto as TSOF_monto_presupuesto  "&_
					"from ocag_presupuesto_solicitud a "&_
					"INNER JOIN ocag_reembolso_gastos b ON a.cod_solicitud = b.rgas_ncorr AND cod_solicitud ="&v_solicitud&"  AND a.tsol_ccod = 2  "&_
					"INNER JOIN ocag_detalle_reembolso_gasto d ON b.rgas_ncorr = d.rgas_ncorr "&_
					"INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr INNER JOIN ocag_tipo_documento otd ON otd.tdoc_ccod=d.tdoc_ccod "&_
					"union  "&_
					"select '2-10-070-10-000004' as tsof_plan_cuenta, 0 as tsof_debe, d.drga_mdocto + d.drga_mretencion as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(d.drga_tdescripcion))) as TSOF_GLOSA_SIN_ACENTO  "&_
					", c.pers_nrut as TSOF_COD_AUXILIAR, 'BC' as TSOF_TIPO_DOCUMENTO, b.rgas_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso)as TSOF_FECHA_EMISION_CORTA  "&_
					", protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, b.rgas_ncorr AS TSOF_NRO_DOC_REFERENCIA  "&_
					", '' as TSOF_COD_CENTRO_COSTO, a.cod_pre as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR  "&_
					", CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano  "&_
					", d.drga_mdocto as TSOF_monto_presupuesto  "&_
					"from ocag_presupuesto_solicitud a  "&_
					"INNER JOIN ocag_reembolso_gastos b ON a.cod_solicitud = b.rgas_ncorr AND cod_solicitud ="&v_solicitud&"  AND a.tsol_ccod = 2  "&_
					"INNER JOIN ocag_detalle_reembolso_gasto d ON b.rgas_ncorr = d.rgas_ncorr "&_
					"INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr  "&_
					") as tabla order by TSOF_COD_CONCEPTO_CAJA, tsof_debe desc  "		
		
			Case 3: ' Fondos a rendir
				txt_tipo="Fondos_Rendir"		
						
				sql_doctos = "select * from (   "&_
					" select '1-10-060-10-000002' as tsof_plan_cuenta, d.ccva_mmonto as tsof_debe, 0 as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(a.fren_tdescripcion_actividad))) as TSOF_GLOSA_SIN_ACENTO   "&_
					" , b.pers_nrut as TSOF_COD_AUXILIAR, 'FR' as TSOF_TIPO_DOCUMENTO, a.fren_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(a.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA   "&_
					" , protic.trunc(a.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'FR' AS TSOF_TIPO_DOC_REFERENCIA, a.fren_ncorr AS TSOF_NRO_DOC_REFERENCIA   "&_
					" , '' AS TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR  "&_
					" from ocag_fondos_a_rendir a  "&_
					" INNER JOIN personas b   "&_
					" ON a.pers_ncorr = b.pers_ncorr and fren_ncorr="&v_solicitud&" "&_
					" INNER JOIN ocag_validacion_contable c on a.fren_ncorr = c.cod_solicitud and isnull(c.tsol_ccod,3)=3   "&_
					" INNER JOIN ocag_centro_costo_validacion d ON c.vcon_ncorr=d.vcon_ncorr   "&_
					" INNER JOIN ocag_centro_costo e ON d.ccos_ncorr=e.ccos_ncorr   "&_
					" union   "&_
					" select '2-10-070-10-000002' as tsof_plan_cuenta, 0 as tsof_debe, fren_mmonto as TSOF_HABER "&_
					" , protic.extrae_acentos(LTRIM(RTRIM(a.fren_tdescripcion_actividad))) as TSOF_GLOSA_SIN_ACENTO , b.pers_nrut as TSOF_COD_AUXILIAR "&_
					" , 'BC' as TSOF_TIPO_DOCUMENTO, a.fren_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(a.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA  "&_
					" , protic.trunc(x.dpva_fpago) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, a.fren_ncorr AS TSOF_NRO_DOC_REFERENCIA  "&_
					" , '' as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR  "&_
					" from ocag_fondos_a_rendir a  "&_
					" INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and fren_ncorr="&v_solicitud&" "&_
					" INNER JOIN ocag_validacion_contable w ON a.fren_ncorr=w.cod_solicitud AND isnull(w.tsol_ccod,3)=3  "&_
					" INNER JOIN ocag_detalle_pago_validacion x ON w.vcon_ncorr = x.vcon_ncorr "&_
					" ) as tabla order by TSOF_HABER desc  "		
			
				sql_efes=" select * from ( "&_
					" select '2-10-070-10-000004' as tsof_plan_cuenta, a.psol_mpresupuesto as tsof_debe, 0 as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(b.fren_tdescripcion_actividad))) as TSOF_GLOSA_SIN_ACENTO "&_
					" , c.pers_nrut as TSOF_COD_AUXILIAR, 'TR' as TSOF_TIPO_DOCUMENTO, b.fren_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA  "&_
					" , protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, b.fren_ncorr AS TSOF_NRO_DOC_REFERENCIA "&_
					" , '' as TSOF_COD_CENTRO_COSTO, '' as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR  "&_
					" , CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano  "&_
					" , a.psol_mpresupuesto as TSOF_monto_presupuesto  "&_
					" from ocag_presupuesto_solicitud a "&_
					" INNER JOIN ocag_fondos_a_rendir b ON a.cod_solicitud = b.fren_ncorr AND cod_solicitud ="&v_solicitud&" and a.tsol_ccod=3  "&_
					" INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr  "&_
					" union  "&_
					" select '2-10-070-10-000004' as tsof_plan_cuenta, 0 as tsof_debe, a.psol_mpresupuesto as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(b.fren_tdescripcion_actividad))) as TSOF_GLOSA_SIN_ACENTO  "&_
					" , c.pers_nrut as TSOF_COD_AUXILIAR, 'BC' as TSOF_TIPO_DOCUMENTO, b.fren_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso)as TSOF_FECHA_EMISION_CORTA  "&_
					" , protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, b.fren_ncorr AS TSOF_NRO_DOC_REFERENCIA  "&_
					" , '' as TSOF_COD_CENTRO_COSTO, '' as TSOF_COD_CONCEPTO_CAJA , 1 AS TSOF_NRO_AGRUPADOR "&_
					" , CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano  "&_
					" , a.psol_mpresupuesto as TSOF_monto_presupuesto "&_
					" from ocag_presupuesto_solicitud a "&_
					" INNER JOIN ocag_fondos_a_rendir b ON a.cod_solicitud = b.fren_ncorr AND cod_solicitud ="&v_solicitud&" AND a.tsol_ccod = 3 "&_
					" INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr "&_
					" ) as tabla order by TSOF_COD_CONCEPTO_CAJA, tsof_debe desc  "		
		
			Case 4: ' Viaticos
				txt_tipo="Solicitud_Viaticos"
						
				sql_doctos = "select * from (  "&_
					"  select '5-30-020-10-002022' as tsof_plan_cuenta, sovi_mmonto_pesos as tsof_debe, 0 as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(a.sovi_tmotivo))) as TSOF_GLOSA_SIN_ACENTO  "&_
					"  , b.pers_nrut as TSOF_COD_AUXILIAR, 'SV' as TSOF_TIPO_DOCUMENTO, a.sovi_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(a.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA  "&_
					"  , protic.trunc(a.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'SV' AS TSOF_TIPO_DOC_REFERENCIA, a.sovi_ncorr AS TSOF_NRO_DOC_REFERENCIA  "&_
					"  , e.ccos_tcodigo as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR "&_
					"  From ocag_solicitud_viatico a "&_
					"  INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and A.sovi_ncorr="&v_solicitud&" "&_
					"  INNER JOIN ocag_detalle_reembolso_gasto c ON a.sovi_ncorr = c.rgas_ncorr  "&_
					"  INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod  "&_
					"  INNER JOIN ocag_centro_costo e ON c.ccos_ncorr = e.ccos_ncorr "&_
					"  	union  "&_
					"  select '2-10-070-10-000002' as tsof_plan_cuenta, 0 as tsof_debe, a.sovi_mmonto_pesos as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(a.sovi_tmotivo))) as TSOF_GLOSA_SIN_ACENTO "&_
					"  , b.pers_nrut as TSOF_COD_AUXILIAR, 'BC' as TSOF_TIPO_DOCUMENTO, a.sovi_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(a.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA  "&_
					"  , protic.trunc(a.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, a.sovi_ncorr AS TSOF_NRO_DOC_REFERENCIA  "&_
					"  , '' as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR  "&_
					"  from ocag_solicitud_viatico a "&_
					"  INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and sovi_ncorr="&v_solicitud&" "&_
					"  	) as tabla order by tsof_debe desc  "	
			
				sql_efes=" select * from ( "&_
					" select '2-10-070-10-000004' as tsof_plan_cuenta, psol_mpresupuesto as tsof_debe, 0 as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(b.sovi_tmotivo))) as TSOF_GLOSA_SIN_ACENTO  "&_
					" , c.pers_nrut as TSOF_COD_AUXILIAR, 'TR' as TSOF_TIPO_DOCUMENTO, b.sovi_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA  "&_
					" , protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, b.sovi_ncorr AS TSOF_NRO_DOC_REFERENCIA  "&_
					" , '' as TSOF_COD_CENTRO_COSTO, a.cod_pre as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR "&_
					" , CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano  "&_
					" , a.psol_mpresupuesto as TSOF_monto_presupuesto "&_
					" from ocag_presupuesto_solicitud  a "&_
					" INNER JOIN ocag_solicitud_viatico b ON a.cod_solicitud = b.sovi_ncorr AND cod_solicitud ="&v_solicitud&" AND a.tsol_ccod = 4 "&_
					" INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr  "&_
					"  union "&_
					" select '2-10-070-10-000004' as tsof_plan_cuenta, 0 as tsof_debe, a.psol_mpresupuesto as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(b.sovi_tmotivo))) as TSOF_GLOSA_SIN_ACENTO  "&_
					" , c.pers_nrut as TSOF_COD_AUXILIAR, 'BC' as TSOF_TIPO_DOCUMENTO, b.sovi_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso)as TSOF_FECHA_EMISION_CORTA  "&_
					" , protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, b.sovi_ncorr AS TSOF_NRO_DOC_REFERENCIA  "&_
					" , '' as TSOF_COD_CENTRO_COSTO, a.cod_pre as TSOF_COD_CONCEPTO_CAJA , 1 AS TSOF_NRO_AGRUPADOR  "&_
					" , CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano  "&_
					" , a.psol_mpresupuesto as TSOF_monto_presupuesto  "&_
					" from ocag_presupuesto_solicitud a "&_
					" INNER JOIN ocag_solicitud_viatico b ON a.cod_solicitud = b.sovi_ncorr AND cod_solicitud ="&v_solicitud&" AND a.tsol_ccod = 4 "&_
					" INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr  "&_
					" ) as tabla order by TSOF_COD_CONCEPTO_CAJA, tsof_debe desc  "
			Case 5: ' devolucion alumnos
				txt_tipo="Devolucion_alumnos"	
						
				sql_doctos =  "select * from (  "&_
					"select '2-10-140-09-120001' as tsof_plan_cuenta, a.dalu_mmonto_pesos as tsof_debe, 0 as TSOF_HABER  "&_
					", protic.extrae_acentos(LTRIM(RTRIM(a.dalu_tmotivo))) as TSOF_GLOSA_SIN_ACENTO , '' as TSOF_COD_AUXILIAR , '' as TSOF_TIPO_DOCUMENTO "&_
					", '' TSOF_NRO_DOCUMENTO, '' as TSOF_FECHA_EMISION_CORTA, '' as TSOF_FECHA_VENCIMIENTO_CORTA , '' AS TSOF_TIPO_DOC_REFERENCIA "&_
					", '' TSOF_NRO_DOC_REFERENCIA, 'AR-01-02' AS TSOF_COD_DETALLE_GASTO, '1' AS TSOF_CANT_CONCEPTO_GASTO, e.ccos_tcodigo as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR  "&_
					"from ocag_devolucion_alumno a "&_
					"INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and dalu_ncorr="&v_solicitud&" "&_
					"INNER JOIN ocag_validacion_contable c on a.dalu_ncorr = c.cod_solicitud and isnull(c.tsol_ccod,5)=5 "&_
					"INNER JOIN ocag_centro_costo_validacion d ON c.vcon_ncorr=d.vcon_ncorr "&_
					"INNER JOIN ocag_centro_costo e ON d.ccos_ncorr=e.ccos_ncorr "&_
					"union "&_
					"select '2-10-070-10-000002' as tsof_plan_cuenta, 0 as tsof_debe, dalu_mmonto_pesos as TSOF_HABER "&_
					", protic.extrae_acentos(LTRIM(RTRIM(a.dalu_tmotivo))) as TSOF_GLOSA_SIN_ACENTO , cast(b.pers_nrut as varchar) as TSOF_COD_AUXILIAR , 'BC' as TSOF_TIPO_DOCUMENTO "&_
					", CAST(a.dalu_ncorr AS VARCHAR) as TSOF_NRO_DOCUMENTO, protic.trunc(a.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA "&_
					", protic.trunc(x.dpva_fpago) as TSOF_FECHA_VENCIMIENTO_CORTA , 'BC' AS TSOF_TIPO_DOC_REFERENCIA "&_
					", CAST(a.dalu_ncorr AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA , '' AS TSOF_COD_DETALLE_GASTO, '' AS TSOF_CANT_CONCEPTO_GASTO, '' as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR  "&_
					"from ocag_devolucion_alumno a "&_
					"INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and dalu_ncorr="&v_solicitud&" "&_
					"INNER JOIN ocag_validacion_contable w ON a.dalu_ncorr=w.cod_solicitud AND isnull(w.tsol_ccod,5)=5 "&_
					"INNER JOIN ocag_detalle_pago_validacion x ON w.vcon_ncorr = x.vcon_ncorr  "&_
					") as tabla order by TSOF_HABER desc  "
						
				sql_efes= "select * from (  "&_
					"select '1-10-040-30-' + RTRIM(LTRIM(c.CCOS_TCODIGO)) as tsof_plan_cuenta, dalu_mmonto_pesos as tsof_debe, 0 as TSOF_HABER "&_
					", protic.extrae_acentos(RTRIM(LTRIM(c.CCOS_TDESC))) as TSOF_GLOSA_SIN_ACENTO , a.pers_nrut_alu as TSOF_COD_AUXILIAR "&_
					", '' as TSOF_TIPO_DOCUMENTO, '' as TSOF_NRO_DOCUMENTO, '' as TSOF_FECHA_EMISION_CORTA, '' as TSOF_FECHA_VENCIMIENTO_CORTA "&_
					", '' AS TSOF_TIPO_DOC_REFERENCIA, '' AS TSOF_NRO_DOC_REFERENCIA, '' as TSOF_COD_CENTRO_COSTO, '' as TSOF_COD_CONCEPTO_CAJA "&_
					", 1 AS TSOF_NRO_AGRUPADOR, '' AS TSOF_cod_mesano, '' as TSOF_monto_presupuesto "&_
					"from ocag_devolucion_alumno a "&_
					"INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and a.dalu_ncorr ="&v_solicitud&" "&_
					"INNER JOIN CENTROS_COSTO c on a.ccos_ccod = c.CCOS_CCOD "&_
					"union "&_
					"select '1-10-040-30-' + LTRIM(c.CCOS_TCODIGO) as tsof_plan_cuenta, 0 as tsof_debe, dalu_mmonto_pesos as TSOF_HABER "&_
					", protic.extrae_acentos(RTRIM(LTRIM(c.CCOS_TDESC))) as TSOF_GLOSA_SIN_ACENTO , a.pers_nrut_alu as TSOF_COD_AUXILIAR "&_
					", '' as TSOF_TIPO_DOCUMENTO, '' as TSOF_NRO_DOCUMENTO, '' as TSOF_FECHA_EMISION_CORTA, '' as TSOF_FECHA_VENCIMIENTO_CORTA "&_
					", '' AS TSOF_TIPO_DOC_REFERENCIA, '' AS TSOF_NRO_DOC_REFERENCIA, '' as TSOF_COD_CENTRO_COSTO, '' as TSOF_COD_CONCEPTO_CAJA "&_
					", 1 AS TSOF_NRO_AGRUPADOR, '' AS TSOF_cod_mesano, '' as TSOF_monto_presupuesto "&_
					"from ocag_devolucion_alumno a "&_
					"INNER JOIN personas b ON a.pers_ncorr=b.pers_ncorr and a.dalu_ncorr ="&v_solicitud&" "&_
					"INNER JOIN CENTROS_COSTO c on a.ccos_ccod = c.CCOS_CCOD  "&_
					") as tabla order by TSOF_COD_CONCEPTO_CAJA, tsof_debe desc  "		
		
			Case 6: ' Fondo Fijo
				txt_tipo="Fondo_Fijo"
							
				sql_doctos=" select * from ( "&_
					" select '1-10-010-20-000003' as tsof_plan_cuenta, a.ffij_mmonto_pesos as tsof_debe, 0 as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(a.ffij_tdetalle_presu))) as TSOF_GLOSA_SIN_ACENTO "&_
					" , b.pers_nrut as TSOF_COD_AUXILIAR, 'FF' as TSOF_TIPO_DOCUMENTO, a.ffij_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(a.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA "&_
					" , protic.trunc(a.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'FF' AS TSOF_TIPO_DOC_REFERENCIA, a.ffij_ncorr AS TSOF_NRO_DOC_REFERENCIA "&_
					" , e.ccos_tcodigo as TSOF_COD_CENTRO_COSTO  "&_
					" , 1 AS TSOF_NRO_AGRUPADOR "&_
					" FROM ocag_fondo_fijo a "&_
					" INNER JOIN personas b "&_
					" ON a.pers_ncorr=b.pers_ncorr and ffij_ncorr="&v_solicitud&" "&_
					" INNER JOIN ocag_validacion_contable c  "&_
					" on a.ffij_ncorr = c.cod_solicitud and isnull(c.tsol_ccod,6)=6 "&_
					" INNER JOIN ocag_centro_costo_validacion d "&_
					" ON c.vcon_ncorr=d.vcon_ncorr "&_
					" INNER JOIN ocag_centro_costo e "&_
					" ON d.ccos_ncorr=e.ccos_ncorr  "&_
					" UNION "&_				
					" select '2-10-070-10-000002' as tsof_plan_cuenta, 0 as tsof_debe, a.ffij_mmonto_pesos as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(a.ffij_tdetalle_presu))) as TSOF_GLOSA_SIN_ACENTO "&_
					" , b.pers_nrut as TSOF_COD_AUXILIAR, 'BC' as TSOF_TIPO_DOCUMENTO, a.ffij_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(a.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA "&_
					" , protic.trunc(x.dpva_fpago) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, a.ffij_ncorr AS TSOF_NRO_DOC_REFERENCIA "&_
					" , '' as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR "&_
					" FROM ocag_fondo_fijo a "&_
					" INNER JOIN personas b "&_
					" ON a.pers_ncorr=b.pers_ncorr and ffij_ncorr="&v_solicitud&" "&_
					" INNER JOIN ocag_validacion_contable w "&_
					" ON a.ffij_ncorr=w.cod_solicitud AND isnull(w.tsol_ccod,6)=6 "&_
					" INNER JOIN ocag_detalle_pago_validacion x ON w.vcon_ncorr = x.vcon_ncorr"&_
					" ) as tabla order by TSOF_HABER desc "	
		
				sql_efes= " select * from ( "&_
					" select '2-10-070-10-000004' as tsof_plan_cuenta, 0 as tsof_debe, a.psol_mpresupuesto as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(b.ffij_tdetalle_presu))) as TSOF_GLOSA_SIN_ACENTO "&_
					" , c.pers_nrut as TSOF_COD_AUXILIAR, 'BC' as TSOF_TIPO_DOCUMENTO, b.ffij_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso)as TSOF_FECHA_EMISION_CORTA "&_
					" , protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, b.ffij_ncorr AS TSOF_NRO_DOC_REFERENCIA "&_
					" , '' as TSOF_COD_CENTRO_COSTO, a.cod_pre as TSOF_COD_CONCEPTO_CAJA , 1 AS TSOF_NRO_AGRUPADOR "&_
					" , CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano "&_
					" , a.psol_mpresupuesto as TSOF_monto_presupuesto "&_
					" FROM ocag_presupuesto_solicitud a "&_
					" INNER JOIN ocag_fondo_fijo b "&_
					" ON a.cod_solicitud = b.ffij_ncorr AND cod_solicitud ="&v_solicitud&" AND a.tsol_ccod = 6 "&_
					" INNER JOIN personas c "&_
					" ON b.pers_ncorr=c.pers_ncorr "&_
					" UNION "&_
					" select '2-10-070-10-000004' as tsof_plan_cuenta, a.psol_mpresupuesto as tsof_debe, 0 as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(b.ffij_tdetalle_presu))) as TSOF_GLOSA_SIN_ACENTO "&_
					" , c.pers_nrut as TSOF_COD_AUXILIAR, 'TR' as TSOF_TIPO_DOCUMENTO, b.ffij_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA "&_
					" , protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, b.ffij_ncorr AS TSOF_NRO_DOC_REFERENCIA "&_
					" , '' as TSOF_COD_CENTRO_COSTO, a.cod_pre as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR "&_
					" , CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano "&_
					" , a.psol_mpresupuesto as TSOF_monto_presupuesto "&_
					" FROM ocag_presupuesto_solicitud a "&_
					" INNER JOIN ocag_fondo_fijo b "&_
					" ON a.cod_solicitud = b.ffij_ncorr AND cod_solicitud ="&v_solicitud&" AND a.tsol_ccod = 6 "&_
					" INNER JOIN personas c ON b.pers_ncorr=c.pers_ncorr "&_
					" ) as tabla  "			
			
			' 888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
		
			Case 7: ' RENDICION FONDO A RENDIR
		
				txt_tipo="Rendicion_Fondos_Rendir"	
		
				sql_doctos = "SELECT * FROM ("& vbCrLf&_ 
					"select d.tgas_cod_cuenta as tsof_plan_cuenta, c.drfr_mdocto as tsof_debe, 0 as TSOF_HABER, protic.extrae_acentos(RTRIM(LTRIM(d.tgas_tdesc))) as TSOF_GLOSA_SIN_ACENTO "&_
					", '' as TSOF_COD_AUXILIAR, '' as TSOF_TIPO_DOCUMENTO, '' as TSOF_NRO_DOCUMENTO, '' as TSOF_FECHA_EMISION_CORTA  "&_
					", '' as TSOF_FECHA_VENCIMIENTO_CORTA, '' AS TSOF_TIPO_DOC_REFERENCIA, '' AS TSOF_NRO_DOC_REFERENCIA  "&_
					", e.ccos_tcodigo as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR  "&_
					"from ocag_rendicion_fondos_a_rendir z  "&_
					"INNER JOIN ocag_fondos_a_rendir a ON z.fren_ncorr = a.fren_ncorr and z.rfre_ncorr ="&v_solicitud&" "&_
					"INNER JOIN personas b ON a.pers_ncorr = b.pers_ncorr  "&_
					"INNER JOIN ocag_detalle_rendicion_fondo_rendir c ON a.fren_ncorr = c.fren_ncorr  "&_
					"INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod  "&_
					"INNER JOIN ocag_centro_costo e ON a.ccos_ncorr = e.ccos_ncorr "& vbCrLf&_
					"union "& vbCrLf&_
					"select top 1 d.tgas_cod_cuenta as tsof_plan_cuenta, 0 as tsof_debe, z.rfre_mmonto as TSOF_HABER, protic.extrae_acentos(RTRIM(LTRIM(a.fren_tdescripcion_actividad))) as TSOF_GLOSA_SIN_ACENTO "&_
					", '' as TSOF_COD_AUXILIAR, '' as TSOF_TIPO_DOCUMENTO, '' as TSOF_NRO_DOCUMENTO, '' as TSOF_FECHA_EMISION_CORTA  "&_
					", '' as TSOF_FECHA_VENCIMIENTO_CORTA, '' AS TSOF_TIPO_DOC_REFERENCIA, '' AS TSOF_NRO_DOC_REFERENCIA  "&_
					", e.ccos_tcodigo as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR  "&_
					"from ocag_rendicion_fondos_a_rendir z  "&_
					"INNER JOIN ocag_fondos_a_rendir a ON z.fren_ncorr = a.fren_ncorr and z.rfre_ncorr ="&v_solicitud&" "&_
					"INNER JOIN personas b ON a.pers_ncorr = b.pers_ncorr  "&_
					"INNER JOIN ocag_detalle_rendicion_fondo_rendir c ON a.fren_ncorr = c.fren_ncorr  "&_
					"INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod  "&_
					"INNER JOIN ocag_centro_costo e ON a.ccos_ncorr = e.ccos_ncorr "&_
					") as tabla order by tsof_debe desc"
					
				sql_efes=" select * from (   "&_
					"select d.tgas_cod_cuenta as tsof_plan_cuenta, z.psol_mpresupuesto as tsof_debe, 0 as TSOF_HABER, protic.extrae_acentos(RTRIM(LTRIM(d.tgas_tdesc))) as TSOF_GLOSA_SIN_ACENTO   "&_
					", b.pers_nrut as TSOF_COD_AUXILIAR, 'TR' as TSOF_TIPO_DOCUMENTO, w.rfre_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(w.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA   "&_
					", protic.trunc(w.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, w.rfre_ncorr AS TSOF_NRO_DOC_REFERENCIA   "&_
					", '' as TSOF_COD_CENTRO_COSTO, z.cod_pre as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR   "&_
					", CASE WHEN MONTH(w.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(w.ocag_fingreso) AS VARCHAR) + CAST(YEAR(w.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano   "&_
					", z.psol_mpresupuesto as TSOF_monto_presupuesto   "&_
					"from ocag_rendicion_fondos_a_rendir w   "&_
					"INNER JOIN ocag_presupuesto_solicitud z ON w.fren_ncorr = z.cod_solicitud and w.rfre_ncorr="&v_solicitud&"  and w.tsol_ccod=7   "&_
					"INNER JOIN ocag_fondos_a_rendir a ON z.cod_solicitud = a.fren_ncorr   "&_
					"INNER JOIN personas b ON a.pers_ncorr = b.pers_ncorr   "&_
					"INNER JOIN ocag_detalle_rendicion_fondo_rendir c ON a.fren_ncorr = c.fren_ncorr    "&_
					"INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod   "&_
					"INNER JOIN ocag_centro_costo e ON a.ccos_ncorr = e.ccos_ncorr   "&_
					"union   "&_
					"select d.tgas_cod_cuenta as tsof_plan_cuenta, 0 as tsof_debe, z.psol_mpresupuesto as TSOF_HABER, protic.extrae_acentos(RTRIM(LTRIM(d.tgas_tdesc))) as TSOF_GLOSA_SIN_ACENTO   "&_
					", B.pers_nrut as TSOF_COD_AUXILIAR, 'BC' as TSOF_TIPO_DOCUMENTO, w.rfre_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(w.ocag_fingreso)as TSOF_FECHA_EMISION_CORTA   "&_
					", protic.trunc(w.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, w.rfre_ncorr AS TSOF_NRO_DOC_REFERENCIA   "&_
					", '' as TSOF_COD_CENTRO_COSTO, Z.cod_pre as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR   "&_
					", CASE WHEN MONTH(w.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(w.ocag_fingreso) AS VARCHAR) + CAST(YEAR(w.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano   "&_
					", z.psol_mpresupuesto as TSOF_monto_presupuesto   "&_
					"from ocag_rendicion_fondos_a_rendir w   "&_
					"INNER JOIN ocag_presupuesto_solicitud z ON w.fren_ncorr = z.cod_solicitud and w.rfre_ncorr="&v_solicitud&" and w.tsol_ccod=7   "&_
					"INNER JOIN ocag_fondos_a_rendir a ON z.cod_solicitud = a.fren_ncorr   "&_
					"INNER JOIN personas b ON a.pers_ncorr = b.pers_ncorr   "&_
					"INNER JOIN ocag_detalle_rendicion_fondo_rendir c ON a.fren_ncorr = c.fren_ncorr   "&_
					"INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod   "&_
					"INNER JOIN ocag_centro_costo e ON a.ccos_ncorr = e.ccos_ncorr   "&_
					") as tabla order by TSOF_COD_CONCEPTO_CAJA, tsof_debe desc  "		
		
			Case 8: ' RENDICION FONDO FIJO
		
				txt_tipo="Rendicion Fondo_Fijo"
		
				sql_doctos = "select * from (   "&_
					" select d.tgas_cod_cuenta as tsof_plan_cuenta, w.drff_mdocto as tsof_debe, 0 as TSOF_HABER, protic.extrae_acentos(RTRIM(LTRIM(d.tgas_tdesc))) as TSOF_GLOSA_SIN_ACENTO   "&_
					" , b.pers_nrut as TSOF_COD_AUXILIAR, 'RFF' as TSOF_TIPO_DOCUMENTO, a.ffij_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(z.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA   "&_
					" , protic.trunc(z.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'RFF' AS TSOF_TIPO_DOC_REFERENCIA, a.ffij_ncorr AS TSOF_NRO_DOC_REFERENCIA   "&_
					" , y.ccos_tcodigo as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR   "&_
					" from ocag_rendicion_fondo_fijo z   "&_
					" inner join ocag_detalle_rendicion_fondo_fijo w ON Z.rffi_ncorr = W.rffi_ncorr   "&_
					" INNER JOIN ocag_fondo_fijo a ON W.ffij_ncorr = a.ffij_ncorr and z.rffi_ncorr ="&v_solicitud&" "&_
					" INNER JOIN personas b ON a.pers_ncorr = b.pers_ncorr   "&_
					" INNER JOIN ocag_tipo_gasto d ON W.tgas_ccod = d.tgas_ccod  "&_
					" INNER JOIN ocag_validacion_contable c on z.rffi_ncorr = c.cod_solicitud and isnull(c.tsol_ccod,8)=8   "&_
					" INNER JOIN ocag_centro_costo_validacion x ON c.vcon_ncorr=x.vcon_ncorr   "&_
					" INNER JOIN ocag_centro_costo y ON x.ccos_ncorr=y.ccos_ncorr   "&_
					" union  "&_
					" select d.tgas_cod_cuenta as tsof_plan_cuenta, 0 as tsof_debe, W.drff_mdocto as TSOF_HABER, protic.extrae_acentos(RTRIM(LTRIM(d.tgas_tdesc))) as TSOF_GLOSA_SIN_ACENTO  "&_
					" , b.pers_nrut as TSOF_COD_AUXILIAR, 'BC' as TSOF_TIPO_DOCUMENTO, a.ffij_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(a.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA  "&_
					" , protic.trunc(a.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, a.ffij_ncorr AS TSOF_NRO_DOC_REFERENCIA  "&_
					" , '' as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR  "&_
					" from ocag_rendicion_fondo_fijo z  "&_
					" inner join ocag_detalle_rendicion_fondo_fijo w ON Z.rffi_ncorr = W.rffi_ncorr  "&_
					" INNER JOIN ocag_fondo_fijo a ON z.ffij_ncorr = a.ffij_ncorr and z.rffi_ncorr ="&v_solicitud&" "&_
					" INNER JOIN personas b ON a.pers_ncorr = b.pers_ncorr  "&_
					" INNER JOIN ocag_tipo_gasto d ON W.tgas_ccod = d.tgas_ccod  "&_
					" ) as tabla order by tsof_debe desc "
						
				sql_efes=" select * from ( "&_
					" select d.tgas_cod_cuenta as tsof_plan_cuenta, z.psol_mpresupuesto as tsof_debe, 0 as TSOF_HABER, protic.extrae_acentos(RTRIM(LTRIM(d.tgas_tdesc))) as TSOF_GLOSA_SIN_ACENTO "&_
					" , B.pers_nrut as TSOF_COD_AUXILIAR, 'TR' as TSOF_TIPO_DOCUMENTO, w.rffi_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(a.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA  "&_
					" , protic.trunc(a.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, w.rffi_ncorr AS TSOF_NRO_DOC_REFERENCIA  "&_
					" , '' as TSOF_COD_CENTRO_COSTO, z.cod_pre as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR  "&_
					" , CASE WHEN MONTH(a.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(a.ocag_fingreso) AS VARCHAR) + CAST(YEAR(a.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano  "&_
					" , z.psol_mpresupuesto as TSOF_monto_presupuesto "&_
					" from ocag_rendicion_fondo_fijo w "&_
					" INNER JOIN ocag_detalle_rendicion_fondo_fijo x ON w.rffi_ncorr = X.rffi_ncorr and w.rffi_ncorr ="&v_solicitud&" "&_
					" inner join ocag_presupuesto_solicitud z ON X.ffij_ncorr = Z.cod_solicitud  and z.tsol_ccod=6 "&_
					" INNER JOIN ocag_fondo_fijo a ON z.cod_solicitud = a.ffij_ncorr  "&_
					" INNER JOIN personas b ON a.pers_ncorr = b.pers_ncorr "&_
					" INNER JOIN ocag_tipo_gasto d ON x.tgas_ccod = d.tgas_ccod "&_
					"  union "&_
					" select d.tgas_cod_cuenta as tsof_plan_cuenta, 0 as tsof_debe, z.psol_mpresupuesto as TSOF_HABER, protic.extrae_acentos(RTRIM(LTRIM(d.tgas_tdesc))) as TSOF_GLOSA_SIN_ACENTO "&_
					" , b.pers_nrut as TSOF_COD_AUXILIAR, 'BC' as TSOF_TIPO_DOCUMENTO, W.rffi_ncorr as TSOF_NRO_DOCUMENTO, protic.trunc(a.ocag_fingreso)as TSOF_FECHA_EMISION_CORTA "&_
					" , protic.trunc(a.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, W.rffi_ncorr AS TSOF_NRO_DOC_REFERENCIA , '' as TSOF_COD_CENTRO_COSTO "&_
					" , Z.cod_pre as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR  "&_
					" , CASE WHEN MONTH(a.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(a.ocag_fingreso) AS VARCHAR) + CAST(YEAR(a.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano "&_
					" , z.psol_mpresupuesto as TSOF_monto_presupuesto "&_
					" from  ocag_detalle_rendicion_fondo_fijo w "&_
					" inner join ocag_presupuesto_solicitud z ON w.ffij_ncorr = Z.cod_solicitud and w.rffi_ncorr ="&v_solicitud&" and z.tsol_ccod=6 "&_
					" INNER JOIN ocag_fondo_fijo a ON z.cod_solicitud = a.ffij_ncorr  "&_
					" INNER JOIN personas b ON a.pers_ncorr = b.pers_ncorr  "&_
					" inner join ocag_rendicion_fondo_fijo c ON a.ffij_ncorr = c.ffij_ncorr "&_
					" INNER JOIN ocag_tipo_gasto d ON w.tgas_ccod = d.tgas_ccod "&_
					" ) as tabla order by TSOF_COD_CONCEPTO_CAJA, tsof_debe desc  "
		
		
		' 888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

		Case 9: ' Orden de Compra
			txt_tipo="Orden_Compra"
					
			sql_doctos = "select * from ( "&_
				" select '1-10-010-20-000003' as cuenta,'Fondo fijo en Pesos' as descripcion, "&_
				"   b.pers_nrut as auxiliar, ordc_mmonto as debe,0 as haber, protic.trunc(ocag_fingreso) as fecha_solicitud "&_
				"	from ocag_orden_compra a, personas b "&_
				"	where a.pers_ncorr=b.pers_ncorr "&_
				"	and ordc_ncorr="&v_solicitud&" "&_
				"	union  "&_
				"	select '2-10-070-10-000002' as cuenta ,'Cuentas por Pagar (Sist.Computac.)' as descripcion, "&_
				"   b.pers_nrut as auxiliar,0 as debe, ordc_mmonto as haber, protic.trunc(ocag_fingreso) as fecha_solicitud "&_
				"	from ocag_orden_compra a, personas b "&_
				"	where a.pers_ncorr=b.pers_ncorr "&_
				"	and ordc_ncorr="&v_solicitud&" "&_
				"	) as tabla "&_
				" order by  debe desc "

			sql_efes=" select * from ( "&_
				" select '2-10-070-10-000004' as cuenta,'Cuentas por Pagar con Control Presup.origen(Sist.Computac.)' as descripcion, "&_
				" porc_mpresupuesto as debe,0 as haber,cod_pre,protic.trunc('01/'+cast(mes_ccod as varchar)+'/'+cast(anos_ccod as varchar)) as fecha "&_
				" from ocag_presupuesto_orden_compra  "&_
				" where ordc_ncorr="&v_solicitud&" "&_
				" union "&_
				" select '2-10-070-10-000004' as cuenta,'Cuentas por Pagar con Control Presup.origen(Sist.Computac.)' as descripcion, "&_
				" 0 as debe,porc_mpresupuesto as haber,cod_pre,protic.trunc('01/'+cast(mes_ccod as varchar)+'/'+cast(anos_ccod as varchar)) as fecha "&_
				" from ocag_presupuesto_orden_compra  "&_
				" where ordc_ncorr="&v_solicitud&"  "&_
				") as tabla "&_
				" order by cod_pre, debe desc "

		end select

		RESPONSE.WRITE("<pre>5. sql_doctos : "&sql_doctos&"</pre>")
		RESPONSE.WRITE("6. sql_efes : "&sql_efes&"<BR>")
		'RESPONSE.WRITE("7. sql_auxiliar : "&sql_auxiliar&"<BR>")
		'RESPONSE.WRITE("8. sql_centro_costo : "&sql_centro_costo&"<BR>")
		'RESPONSE.END()

		' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

		'******************************************
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
					' 88888888888888888888888888888888
					' response.Write("1.2.2. ACA "&"<BR>")
					' 88888888888888888888888888888888
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
	
		'RESPONSE.WRITE("6. v_ruta_salida_nueva : "&v_ruta_salida_nueva&"<BR>")
	
		'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	
		v_nombre_cajero	=	p_conexion.ConsultaUno(sql_nombre)
		archivo_salida 		= v_nombre_cajero&"_"&txt_tipo&"_"&v_solicitud & ".txt"
	
		' Creacion de archivos de cajas
		set fso = Server.CreateObject("Scripting.FileSystemObject")
		set o_texto_archivo = fso.CreateTextFile(v_ruta_salida_nueva & "\" & archivo_salida)
	
	
		'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
		
		set f_consulta = new CFormulario
		f_consulta.Carga_Parametros "consulta.xml", "consulta"
		f_consulta.Inicializar p_conexion	
		' 8888888888888888888888888888888888888888888888888888888
		'PAGO A PROVEEDORES
		if tsol_ccod =1 then
			detalle_022= conexion.consultaUno (pago_boleta)
			RESPONSE.WRITE("detalle_022 : "&detalle_022&"<BR>")
			IF detalle_022 = "0" THEN
				RESPONSE.WRITE("sql_doctos 1: "&sql_doctos&"<BR>")
				f_consulta.Consultar sql_doctos
			ELSE
				
				IF CInt(v_boleta)  = 1 THEN									
					sql_doctos = "select * from (  "&_
						" select CASE WHEN a.cpag_ccod = 25 THEN '1-10-010-30-100001' ELSE '2-10-070-10-000002' END as tsof_plan_cuenta, 0 as tsof_debe "&_
						" , a.sogi_mgiro as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO "&_
						" , CAST(b.pers_nrut AS VARCHAR) as TSOF_COD_AUXILIAR, LTRIM(RTRIM('bc')) as TSOF_TIPO_DOCUMENTO "&_
						" , CAST(a.sogi_ncorr AS VARCHAR) as TSOF_NRO_DOCUMENTO, protic.trunc(a.sogi_fecha_solicitud) as TSOF_FECHA_EMISION_CORTA "&_
						" , protic.trunc(d.dpva_fpago) as TSOF_FECHA_VENCIMIENTO_CORTA, LTRIM(RTRIM('bc')) AS TSOF_TIPO_DOC_REFERENCIA "&_
						" , CAST(a.sogi_ncorr AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA, NULL AS TSOF_MONTO_DET_LIBRO1 "&_
						" , NULL AS TSOF_MONTO_DET_LIBRO2,NULL AS TSOF_MONTO_SUMA_DET_LIBRO, '' as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR "&_
						" from ocag_solicitud_giro a "&_
						" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr="&v_solicitud&" "&_
						" INNER JOIN ocag_validacion_contable c ON a.sogi_ncorr=c.cod_solicitud AND isnull(c.tsol_ccod,1)=1 "&_
						" INNER JOIN ocag_detalle_pago_validacion d ON c.vcon_ncorr = d.vcon_ncorr "&_
						" UNION "&_
						" select CASE WHEN a.cpag_ccod = 25 THEN '1-10-010-30-100001' ELSE '2-10-070-10-000002' END as tsof_plan_cuenta "&_
						" , c.dsgi_mdocto as tsof_debe "&_
						" , 0 as TSOF_HABER  "&_
						" , protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO, CAST(b.pers_nrut AS VARCHAR) as TSOF_COD_AUXILIAR "&_
						" , LTRIM(RTRIM('bc')) as TSOF_TIPO_DOCUMENTO, CAST(c.dsgi_ndocto AS VARCHAR) as TSOF_NRO_DOCUMENTO "&_
						" , protic.trunc(c.dogi_fecha_documento) as TSOF_FECHA_EMISION_CORTA, protic.trunc(f.dpva_fpago) as TSOF_FECHA_VENCIMIENTO_CORTA "&_
						" , LTRIM(RTRIM(d.tdoc_tdesc_softland)) AS TSOF_TIPO_DOC_REFERENCIA, CAST(c.dsgi_ndocto AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA "&_
						" , C.dsgi_mhonorarios AS TSOF_MONTO_DET_LIBRO1 "&_
						" , c.dsgi_mretencion AS TSOF_MONTO_DET_LIBRO2 "&_
						" , c.dsgi_mdocto as TSOF_MONTO_SUMA_DET_LIBRO "&_
						" , '' as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR "&_
						" from ocag_solicitud_giro a "&_
						" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.ordc_ncorr ='"&detalle_022&"' AND a.sogi_ncorr ="&v_solicitud&" "&_
						" INNER JOIN ocag_detalle_solicitud_giro c ON a.sogi_ncorr=c.sogi_ncorr "&_
						" INNER JOIN ocag_tipo_documento d ON c.tdoc_ccod=d.tdoc_ccod "&_
						" INNER JOIN ocag_validacion_contable e ON a.sogi_ncorr=e.cod_solicitud AND isnull(e.tsol_ccod,1)=1 "&_
						" INNER JOIN ocag_detalle_pago_validacion f ON e.vcon_ncorr = f.vcon_ncorr "&_
						" UNION "&_
						" select CASE WHEN a.cpag_ccod = 25 THEN '1-10-010-30-100001' ELSE '2-10-070-10-000002' END as tsof_plan_cuenta "&_
						" , 0 as tsof_debe "&_
						" , c.dsgi_mdocto as TSOF_HABER "&_
						" , protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO, CAST(b.pers_nrut AS VARCHAR) as TSOF_COD_AUXILIAR "&_
						" , LTRIM(RTRIM(d.tdoc_tdesc_softland)) as TSOF_TIPO_DOCUMENTO, CAST(c.dsgi_ndocto AS VARCHAR) as TSOF_NRO_DOCUMENTO  "&_
						" , protic.trunc(c.dogi_fecha_documento) as TSOF_FECHA_EMISION_CORTA, protic.trunc(f.dpva_fpago) as TSOF_FECHA_VENCIMIENTO_CORTA "&_
						" , LTRIM(RTRIM(d.tdoc_tdesc_softland)) AS TSOF_TIPO_DOC_REFERENCIA, CAST(c.dsgi_ndocto AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA "&_
						" , C.dsgi_mhonorarios AS TSOF_MONTO_DET_LIBRO1 "&_
						" , c.dsgi_mretencion AS TSOF_MONTO_DET_LIBRO2 "&_
						" , c.dsgi_mdocto as TSOF_MONTO_SUMA_DET_LIBRO "&_
						" , '' as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR "&_
						" from ocag_solicitud_giro a "&_
						" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.ordc_ncorr ='"&detalle_022&"' AND a.sogi_ncorr ="&v_solicitud&" "&_
						" INNER JOIN ocag_detalle_solicitud_giro c ON a.sogi_ncorr=c.sogi_ncorr "&_
						" INNER JOIN ocag_tipo_documento d ON c.tdoc_ccod=d.tdoc_ccod "&_
						" INNER JOIN ocag_validacion_contable e ON a.sogi_ncorr=e.cod_solicitud AND isnull(e.tsol_ccod,1)=1 "&_
						" INNER JOIN ocag_detalle_pago_validacion f ON e.vcon_ncorr = f.vcon_ncorr "&_
						" union "&_
						" select '2-10-120-10-000003' as tsof_plan_cuenta "&_
						" , 0 as tsof_debe "&_
						" , CAST(c.dorc_nprecio_neto*0.1 AS INT) as TSOF_HABER  "&_
						" , protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO, '' as TSOF_COD_AUXILIAR, '' as TSOF_TIPO_DOCUMENTO  "&_
						" , '' as TSOF_NRO_DOCUMENTO, '' as TSOF_FECHA_EMISION_CORTA, '' as TSOF_FECHA_VENCIMIENTO_CORTA, '' AS TSOF_TIPO_DOC_REFERENCIA  "&_
						" , '' AS TSOF_NRO_DOC_REFERENCIA "&_
						" , NULL AS TSOF_MONTO_DET_LIBRO1 "&_
						" , NULL AS TSOF_MONTO_DET_LIBRO2 "&_
						" , NULL AS TSOF_MONTO_SUMA_DET_LIBRO "&_
						" , e.ccos_tcodigo as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR "&_
						" FROM ocag_solicitud_giro a "&_
						" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.ordc_ncorr ='"&detalle_022&"' AND A.SOGI_NCORR ="&v_solicitud&" and isnull(a.tsol_ccod,1)=1 "&_
						" INNER JOIN ocag_detalle_orden_compra c ON a.ordc_ncorr = c.ordc_ncorr  "&_
						" INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod "&_
						" INNER JOIN ocag_centro_costo e ON c.ccos_ncorr = e.ccos_ncorr "&_
						" UNION "&_
						" select d.tgas_cod_cuenta as tsof_plan_cuenta, c.dorc_nprecio_neto as tsof_debe "&_
						" , 0 as TSOF_HABER "&_
						" , protic.extrae_acentos(LTRIM(RTRIM(c.dorc_tdesc))) as TSOF_GLOSA_SIN_ACENTO, '' as TSOF_COD_AUXILIAR, '' as TSOF_TIPO_DOCUMENTO  "&_
						" , '' as TSOF_NRO_DOCUMENTO, '' as TSOF_FECHA_EMISION_CORTA, '' as TSOF_FECHA_VENCIMIENTO_CORTA, '' AS TSOF_TIPO_DOC_REFERENCIA "&_
						" , '' AS TSOF_NRO_DOC_REFERENCIA "&_
						" , NULL AS TSOF_MONTO_DET_LIBRO1 "&_
						" , NULL AS TSOF_MONTO_DET_LIBRO2 "&_
						" , NULL AS TSOF_MONTO_SUMA_DET_LIBRO "&_
						" , e.ccos_tcodigo as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR  "&_
						" FROM ocag_solicitud_giro a "&_
						" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.ordc_ncorr ='"&detalle_022&"' AND A.SOGI_NCORR ="&v_solicitud&" and isnull(a.tsol_ccod,1)=1 "&_
						" INNER JOIN ocag_detalle_orden_compra c ON a.ordc_ncorr = c.ordc_ncorr "&_
						" INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod "&_
						" INNER JOIN ocag_centro_costo e ON c.ccos_ncorr = e.ccos_ncorr "&_
						" ) as tabla order by TSOF_HABER desc"	
				END IF
										
				IF CInt(v_boleta)  = 2 THEN
					sql_doctos = "select * from (  "&_
						" select CASE WHEN a.cpag_ccod = 25 THEN '1-10-010-30-100001' ELSE '2-10-070-10-000002' END as tsof_plan_cuenta, 0 as tsof_debe "&_
						" , a.sogi_mgiro as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO "&_
						" , CAST(b.pers_nrut AS VARCHAR) as TSOF_COD_AUXILIAR, LTRIM(RTRIM('bc')) as TSOF_TIPO_DOCUMENTO , CAST(a.sogi_ncorr AS VARCHAR) as TSOF_NRO_DOCUMENTO "&_
						" , protic.trunc(a.sogi_fecha_solicitud) as TSOF_FECHA_EMISION_CORTA , protic.trunc(d.dpva_fpago) as TSOF_FECHA_VENCIMIENTO_CORTA "&_
						" , LTRIM(RTRIM('bc')) AS TSOF_TIPO_DOC_REFERENCIA , CAST(a.sogi_ncorr AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA "&_
						" , NULL AS TSOF_MONTO_DET_LIBRO1, NULL AS TSOF_MONTO_DET_LIBRO2, NULL AS TSOF_MONTO_SUMA_DET_LIBRO , '' as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR "&_
						" from ocag_solicitud_giro a INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr="&v_solicitud&" "&_
						" INNER JOIN ocag_validacion_contable c ON a.sogi_ncorr=c.cod_solicitud AND isnull(c.tsol_ccod,1)=1 "&_
						" INNER JOIN ocag_detalle_pago_validacion d ON c.vcon_ncorr = d.vcon_ncorr  "&_
						" UNION "&_
						" select CASE WHEN a.cpag_ccod = 25 THEN '1-10-010-30-100001' ELSE '2-10-070-10-000002' END as tsof_plan_cuenta, c.dsgi_mdocto as tsof_debe "&_
						" , 0 as TSOF_HABER , protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO "&_
						" , CAST(b.pers_nrut AS VARCHAR) as TSOF_COD_AUXILIAR , LTRIM(RTRIM('TR')) as TSOF_TIPO_DOCUMENTO "&_
						" , CAST(c.dsgi_ndocto AS VARCHAR) as TSOF_NRO_DOCUMENTO , protic.trunc(c.dogi_fecha_documento) as TSOF_FECHA_EMISION_CORTA "&_
						" , protic.trunc(f.dpva_fpago) as TSOF_FECHA_VENCIMIENTO_CORTA , LTRIM(RTRIM(d.tdoc_tdesc_softland)) AS TSOF_TIPO_DOC_REFERENCIA "&_
						" , CAST(c.dsgi_ndocto AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA "&_
						" , c.dsgi_mafecto AS TSOF_MONTO_DET_LIBRO1, c.dsgi_miva AS TSOF_MONTO_DET_LIBRO2, c.dsgi_mdocto as TSOF_MONTO_SUMA_DET_LIBRO "&_
						" , '' as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR "&_
						" from ocag_solicitud_giro a "&_
						" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.ordc_ncorr ='"&detalle_022&"' AND a.sogi_ncorr ="&v_solicitud&" "&_
						" INNER JOIN ocag_detalle_solicitud_giro c ON a.sogi_ncorr=c.sogi_ncorr "&_
						" INNER JOIN ocag_tipo_documento d ON c.tdoc_ccod=d.tdoc_ccod "&_
						" INNER JOIN ocag_validacion_contable e ON a.sogi_ncorr=e.cod_solicitud AND isnull(e.tsol_ccod,1)=1 "&_
						" INNER JOIN ocag_detalle_pago_validacion f ON e.vcon_ncorr = f.vcon_ncorr "&_
						" union "&_
						" select CASE WHEN a.cpag_ccod = 25 THEN '1-10-010-30-100001' ELSE '2-10-070-10-000002' END as tsof_plan_cuenta "&_
						" , 0 as tsof_debe "&_
						" , c.dsgi_mdocto as TSOF_HABER , protic.extrae_acentos(LTRIM(RTRIM(a.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO "&_
						" , CAST(b.pers_nrut AS VARCHAR) as TSOF_COD_AUXILIAR , LTRIM(RTRIM(d.tdoc_tdesc_softland)) as TSOF_TIPO_DOCUMENTO "&_
						" , CAST(c.dsgi_ndocto AS VARCHAR) as TSOF_NRO_DOCUMENTO , protic.trunc(c.dogi_fecha_documento) as TSOF_FECHA_EMISION_CORTA "&_
						" , protic.trunc(f.dpva_fpago) as TSOF_FECHA_VENCIMIENTO_CORTA , LTRIM(RTRIM(d.tdoc_tdesc_softland)) AS TSOF_TIPO_DOC_REFERENCIA "&_
						" , CAST(c.dsgi_ndocto AS VARCHAR) AS TSOF_NRO_DOC_REFERENCIA "&_
						" , c.dsgi_mafecto AS TSOF_MONTO_DET_LIBRO1, c.dsgi_miva AS TSOF_MONTO_DET_LIBRO2, c.dsgi_mdocto as TSOF_MONTO_SUMA_DET_LIBRO "&_
						" , '' as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR "&_
						" from ocag_solicitud_giro a INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr "&_
						" AND a.ordc_ncorr ='"&detalle_022&"' AND a.sogi_ncorr ="&v_solicitud&"  INNER JOIN ocag_detalle_solicitud_giro c ON a.sogi_ncorr=c.sogi_ncorr "&_
						" INNER JOIN ocag_tipo_documento d ON c.tdoc_ccod=d.tdoc_ccod "&_
						" INNER JOIN ocag_validacion_contable e ON a.sogi_ncorr=e.cod_solicitud AND isnull(e.tsol_ccod,1)=1 "&_
						" INNER JOIN ocag_detalle_pago_validacion f ON e.vcon_ncorr = f.vcon_ncorr "&_
						" UNION "&_
						" select d.tgas_cod_cuenta as tsof_plan_cuenta, ROUND(c.dorc_nprecio_neto + Cast(c.dorc_nprecio_neto*0.19 AS INT),-1) as tsof_debe, 0 as TSOF_HABER "&_
						" , protic.extrae_acentos(LTRIM(RTRIM(c.dorc_tdesc))) as TSOF_GLOSA_SIN_ACENTO, '' as TSOF_COD_AUXILIAR, '' as TSOF_TIPO_DOCUMENTO "&_
						" , '' as TSOF_NRO_DOCUMENTO, '' as TSOF_FECHA_EMISION_CORTA, '' as TSOF_FECHA_VENCIMIENTO_CORTA, '' AS TSOF_TIPO_DOC_REFERENCIA  "&_
						" , '' AS TSOF_NRO_DOC_REFERENCIA, NULL AS TSOF_MONTO_DET_LIBRO1, NULL AS TSOF_MONTO_DET_LIBRO2, NULL AS TSOF_MONTO_SUMA_DET_LIBRO "&_
						" , '' as TSOF_COD_CENTRO_COSTO, 1 AS TSOF_NRO_AGRUPADOR "&_
						" FROM ocag_solicitud_giro a "&_
						" INNER JOIN personas b ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.ordc_ncorr ='"&detalle_022&"' AND A.SOGI_NCORR ="&v_solicitud&"and isnull(a.tsol_ccod,1)=1 "&_
						" INNER JOIN ocag_detalle_orden_compra c ON a.ordc_ncorr = c.ordc_ncorr "&_
						" INNER JOIN ocag_tipo_gasto d ON c.tgas_ccod = d.tgas_ccod "&_
						" INNER JOIN ocag_centro_costo e ON c.ccos_ncorr = e.ccos_ncorr "&_
						" ) as tabla order by TSOF_HABER desc"	
				END IF
				
				'RESPONSE.WRITE("sql_doctos 1: "&sql_doctos&"<BR>")
				'response.end()
				f_consulta.Consultar sql_doctos
			END IF
		ELSE
			' 8888888888888888888888888888888888888888888888888888888								
			f_consulta.Consultar sql_doctos
		END IF
	
		ind=0
		v_total=0
	
		RESPONSE.WRITE("sql_doctos 2 : "&sql_doctos&"<BR>")
		RESPONSE.WRITE("sql_efes 3 : "&sql_efes&"<BR>")
		'response.end()
				
		'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
		softland=  "select TOP 1 dlicoint  from softland.cwdetli ORDER BY CpbFec DESC"
		'valor = Cstr(conexion.ConsultaUno(softland))
		valor = Cstr(conectar.ConsultaUno(softland))
		'response.write valor & "<br>"
		while f_consulta.Siguiente
			'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
			'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
			linea = ""
			'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

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
			'linea = linea & valor & DELIMITADOR_CAMPOS_SOFT
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
			linea = linea & f_consulta.ObtenerValor("TSOF_NRO_AGRUPADOR")  & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_consulta.ObtenerValor("TSOF_bullshet1")  & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_consulta.ObtenerValor("TSOF_bullshet2")  & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_consulta.ObtenerValor("TSOF_cod_mesano")  & DELIMITADOR_CAMPOS_SOFT ' mes+año (no van aca, solo en los efes)
			linea = linea & f_consulta.ObtenerValor("TSOF_monto_presupuesto")   ' monto (no van aca, solo en los efes)	
			'linea = linea & f_consulta.ObtenerValor("TSOF_bullshet3")  
			
			o_texto_archivo.WriteLine(linea)
	
			'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
		wend
		'RESPONSE.WRITE "OK"
		'response.end()
		'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	
		set f_efes = new CFormulario
		f_efes.Carga_Parametros "consulta.xml", "consulta"
		f_efes.Inicializar p_conexion	
		
		'f_efes.Consultar SQL
		
		' 8888888888888888888888888888888888888888888888888888888
		
		'PAGO A PROVEEDORES
		if tsol_ccod =1 then
			
			IF detalle_022 = "0" THEN
				f_efes.Consultar sql_efes
				
			ELSE
			
				IF CInt(v_boleta)  = 1 THEN	
					sql_efes=" select * from (  "&_
						" select '2-10-070-10-000004' as tsof_plan_cuenta, a.psol_mpresupuesto as tsof_debe, 0 as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(b.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO  "&_
						" , c.pers_nrut as TSOF_COD_AUXILIAR, 'TR' as TSOF_TIPO_DOCUMENTO, a.cod_solicitud as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA  "&_
						" , protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, a.cod_solicitud AS TSOF_NRO_DOC_REFERENCIA  "&_
						" , '' as TSOF_COD_CENTRO_COSTO, a.cod_pre as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR  "&_
						" , CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano  "&_
						" , a.psol_mpresupuesto as TSOF_monto_presupuesto  "&_
						" from ocag_presupuesto_solicitud a "&_
						" INNER JOIN ocag_solicitud_giro b "&_
						" ON a.cod_solicitud = b.ordc_ncorr AND a.cod_solicitud ='"&detalle_022&"' AND b.sogi_ncorr="&v_solicitud&" and  a.tsol_ccod = 9 "&_
						" INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr "&_
						" union  "&_
						" select '2-10-070-10-000004' as tsof_plan_cuenta, 0 as tsof_debe, psol_mpresupuesto as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(b.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO  "&_
						" , c.pers_nrut as TSOF_COD_AUXILIAR, 'BC' as TSOF_TIPO_DOCUMENTO, a.cod_solicitud as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso)as TSOF_FECHA_EMISION_CORTA  "&_
						" , protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, a.cod_solicitud AS TSOF_NRO_DOC_REFERENCIA  "&_
						" , '' as TSOF_COD_CENTRO_COSTO, a.cod_pre as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR  "&_
						" , CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano  "&_
						" , a.psol_mpresupuesto as TSOF_monto_presupuesto  "&_
						" from ocag_presupuesto_solicitud a "&_
						" INNER JOIN ocag_solicitud_giro b ON a.cod_solicitud = b.ordc_ncorr AND a.cod_solicitud ='"&detalle_022&"' AND b.sogi_ncorr="&v_solicitud&" and  a.tsol_ccod = 9 "&_
						" INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr  "&_
						" ) as tabla  "&_
						" order by TSOF_HABER desc  "
				END IF
										
				IF CInt(v_boleta)  = 2 THEN	
	
					sql_efes=" select * from (  "&_
						" select '2-10-070-10-000004' as tsof_plan_cuenta, CAST(a.psol_mpresupuesto AS INT) as tsof_debe, 0 as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(b.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO  "&_
						" , c.pers_nrut as TSOF_COD_AUXILIAR, 'TR' as TSOF_TIPO_DOCUMENTO, a.cod_solicitud as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso) as TSOF_FECHA_EMISION_CORTA  "&_
						" , protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, a.cod_solicitud AS TSOF_NRO_DOC_REFERENCIA  "&_
						" , '' as TSOF_COD_CENTRO_COSTO, a.cod_pre as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR  "&_
						" , CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano  "&_
						" , a.psol_mpresupuesto as TSOF_monto_presupuesto  "&_
						" from ocag_presupuesto_solicitud a "&_
						" INNER JOIN ocag_solicitud_giro b "&_
						" ON a.cod_solicitud = b.ordc_ncorr AND a.cod_solicitud ='"&detalle_022&"' AND b.sogi_ncorr="&v_solicitud&" and  a.tsol_ccod = 9 "&_
						" INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr "&_
						" union  "&_
						" select '2-10-070-10-000004' as tsof_plan_cuenta, 0 as tsof_debe, CAST(a.psol_mpresupuesto AS INT) as TSOF_HABER, protic.extrae_acentos(LTRIM(RTRIM(b.sogi_tobservaciones))) as TSOF_GLOSA_SIN_ACENTO  "&_
						" , c.pers_nrut as TSOF_COD_AUXILIAR, 'BC' as TSOF_TIPO_DOCUMENTO, a.cod_solicitud as TSOF_NRO_DOCUMENTO, protic.trunc(b.ocag_fingreso)as TSOF_FECHA_EMISION_CORTA  "&_
						" , protic.trunc(b.ocag_fingreso) as TSOF_FECHA_VENCIMIENTO_CORTA, 'BC' AS TSOF_TIPO_DOC_REFERENCIA, a.cod_solicitud AS TSOF_NRO_DOC_REFERENCIA  "&_
						" , '' as TSOF_COD_CENTRO_COSTO, a.cod_pre as TSOF_COD_CONCEPTO_CAJA, 1 AS TSOF_NRO_AGRUPADOR  "&_
						" , CASE WHEN MONTH(b.ocag_fingreso) < 10 THEN '0' ELSE '' END + CAST(MONTH(b.ocag_fingreso) AS VARCHAR) + CAST(YEAR(b.ocag_fingreso) AS VARCHAR) AS TSOF_cod_mesano  "&_
						" , a.psol_mpresupuesto as TSOF_monto_presupuesto  "&_
						" from ocag_presupuesto_solicitud a "&_
						" INNER JOIN ocag_solicitud_giro b ON a.cod_solicitud = b.ordc_ncorr AND a.cod_solicitud ='"&detalle_022&"' AND b.sogi_ncorr="&v_solicitud&" and  a.tsol_ccod = 9 "&_
						" INNER JOIN personas c ON b.pers_ncorr_proveedor=c.pers_ncorr  "&_
						" ) as tabla  "&_
						" order by TSOF_HABER desc  "
												
				END IF
										
				'RESPONSE.WRITE("4. sql_efes : "&sql_efes&"<BR>")
				f_efes.Consultar sql_efes
											
			END IF
										
		ELSE
	
			' 8888888888888888888888888888888888888888888888888888888
			f_efes.Consultar sql_efes
						
		END IF
	
		ind=0
		v_total=0
	
		'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
		softland=  "select TOP 1 dlicoint  from softland.cwdetli ORDER BY CpbFec DESC"
		'valor = Cstr(conexion.ConsultaUno(softland))
		valor = Cstr(conectar.ConsultaUno(softland))
		while f_efes.Siguiente 
		
			'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
			'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
			linea = ""
			'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
			linea = linea & f_efes.ObtenerValor("tsof_plan_cuenta") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("tsof_debe") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_HABER") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_GLOSA_SIN_ACENTO") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_EQUIVALENCIA") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_DEBE_ADICIONAL") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_HABER_ADICIONAL") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_COD_CONDICION_VENTA") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_COD_VENDEDOR") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_COD_UBICACION") & DELIMITADOR_CAMPOS_SOFT		
			linea = linea & f_efes.ObtenerValor("TSOF_COD_CONCEPTO_CAJA") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_COD_INSTRUMENTO_FINAN") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_CANT_INSTRUMENTO_FINAN") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_COD_DETALLE_GASTO") & DELIMITADOR_CAMPOS_SOFT		
			linea = linea & f_efes.ObtenerValor("TSOF_CANT_CONCEPTO_GASTO") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_COD_CENTRO_COSTO") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_TIPO_DOC_CONCILIACION") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_NRO_DOC_CONCILIACION") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_COD_AUXILIAR") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_TIPO_DOCUMENTO") & DELIMITADOR_CAMPOS_SOFT		
			linea = linea & f_efes.ObtenerValor("TSOF_NRO_DOCUMENTO") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_FECHA_EMISION_CORTA") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_FECHA_VENCIMIENTO_CORTA") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_TIPO_DOC_REFERENCIA") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_NRO_DOC_REFERENCIA") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_NRO_CORRELATIVO") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_MONTO_DET_LIBRO1") & DELIMITADOR_CAMPOS_SOFT		
			linea = linea & f_efes.ObtenerValor("TSOF_MONTO_DET_LIBRO2") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_MONTO_DET_LIBRO3") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_MONTO_DET_LIBRO4") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_MONTO_DET_LIBRO5") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_MONTO_DET_LIBRO6") & DELIMITADOR_CAMPOS_SOFT		
			linea = linea & f_efes.ObtenerValor("TSOF_MONTO_DET_LIBRO7") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_MONTO_DET_LIBRO8") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_MONTO_DET_LIBRO9") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_MONTO_SUMA_DET_LIBRO") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_NRO_DOCUMENTO_DESDE") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_NRO_DOCUMENTO_HASTA") & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_NRO_AGRUPADOR")  & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_bullshet1")  & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_bullshet2")  & DELIMITADOR_CAMPOS_SOFT
			linea = linea & f_efes.ObtenerValor("TSOF_cod_mesano") & DELIMITADOR_CAMPOS_SOFT ' mes+año (aca si van los valores)
			linea = linea & f_efes.ObtenerValor("TSOF_monto_presupuesto")  ' monto (aca si van los valores)
			linea = linea & f_efes.ObtenerValor("TSOF_bullshet3")  
			
			o_texto_archivo.WriteLine(linea)
	
		wend		
		
		'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
		o_texto_archivo.Close ' Escritura en archivo base de la caja
		
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
RESPONSE.WRITE "OK"
RESPONSE.END()
'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
' inicio 20140107

'v_usuario=negocio.ObtenerUsuario()

fecha_actual=conexion.consultaUno("select protic.trunc(getDate())")

set f_solicitud = new cFormulario
f_solicitud.carga_parametros "carga_contable.xml", "autoriza_solicitud_giro"
f_solicitud.inicializar conexion
f_solicitud.procesaForm

for fila = 0 to f_solicitud.CuentaPost - 1

	v_cod_solicitud	= f_solicitud.ObtenerValorPost (fila, "cod_solicitud")
	v_aprueba	= f_solicitud.ObtenerValorPost (fila, "aprueba")
	'v_tsol_ccod = f_solicitud.ObtenerValorPost (fila, "tipo")
	v_tsol_ccod		= f_solicitud.ObtenerValorPost (fila, "tsol_ccod")
	v_observaciones = f_solicitud.ObtenerValorPost (fila, "asgi_tobservaciones")
	asgi_nestado	= f_solicitud.ObtenerValorPost (fila, "asgi_nestado")

	'if v_cod_solicitud<>"" and v_tipo_solicitud<>"" then
	'Response.Write("<br> Se debe traspasar esta solicitud: "&v_cod_solicitud& " del tipo :"&v_tipo_solicitud&" ")
	'end if
	
	if v_cod_solicitud<>"" then

		if EsVacio(asgi_nestado) or asgi_nestado="" then
			asgi_nestado=1
		end if
		
		if v_aprueba="2" then
			' Rechaza la solicitud, Valores asgi_nestado (1= Aprobado, 3 = Rechazado, 5 = Observado)
			' validar si es con observaciones o no
			vibo_ccod=7
			f_solicitud.AgregaCampoFilaPost fila, "vibo_ccod", vibo_ccod
			f_solicitud.AgregaCampoFilaPost fila, "asgi_nestado", asgi_nestado
			f_solicitud.AgregaCampoFilaPost fila, "asgi_observaciones", v_observaciones
			f_solicitud.AgregaCampoFilaPost fila, "asgi_fautorizado", fecha_actual					
		else
			' Aprueba la solicitud, estado finanzas 4 = aprobado finanzas
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
				'sql_update	=	"update ocag_rendicion_fondos_a_rendir set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&" where fren_ncorr="&v_cod_solicitud				
				sql_update	=	"update ocag_rendicion_fondos_a_rendir set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&" where rfre_ncorr="&v_cod_solicitud			
			Case 8:
				'sql_update	=	"update ocag_rendicion_fondo_fijo set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&" where ffij_ncorr="&v_cod_solicitud
				sql_update	=	"update ocag_rendicion_fondo_fijo set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&" where rffi_ncorr="&v_cod_solicitud
			Case 9:
				sql_update	=	"update ocag_orden_compra set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&" where ordc_ncorr="&v_cod_solicitud					
		End Select
		
		'Response.Write(sql_update)
		conexion.estadotransaccion  conexion.ejecutaS(sql_update)
	end if

next

' INSERTA REGISTROS EN LA TABLA "ocag_autoriza_solicitud_giro"
f_solicitud.MantieneTablas false

v_estado_transaccion = conexion.ObtenerEstadoTransaccion
	
if v_estado_transaccion=false  then
	'response.Write("<br>Todo MAL")
	session("mensaje_error")="No se pudo ingresar el estado a la solicitud de giro.\nVuelva a intentarlo."
else	
	'response.Write("<br>Todo bien")
	session("mensaje_error")="El estado de la Solicitud de Giro fue ingresado correctamente."
end if

'RESPONSE.END()

response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>


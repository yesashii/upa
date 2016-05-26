<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

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
'FECHA ACTUALIZACION 	:03/09/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			: 312
'*******************************************************************
set pagina = new CPagina
pagina.Titulo = "Consultas de autorizacion de giro y O.C."

v_solicitud	= request.querystring("busqueda[0][solicitud]")
v_tipo		= request.querystring("busqueda[0][tsol_ccod]")
v_anos		= request.querystring("busqueda[0][anos_ccod]")

'RESPONSE.WRITE("0. v_solicitud : "&v_solicitud&"<BR>")
'RESPONSE.WRITE("0. v_tipo : "&v_tipo&"<BR>")
'RESPONSE.WRITE("0. v_anos : "&v_anos&"<BR>")

set botonera = new CFormulario
botonera.carga_parametros "consultas.xml", "botonera"

set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new cnegocio
negocio.Inicializa conectar

set conexion = new Cconexion2
conexion.Inicializar "upacifico"

v_usuario=negocio.ObtenerUsuario()

set f_datos = new CFormulario
f_datos.Carga_Parametros "consultas.xml", "info_solicitud"
f_datos.Inicializar conectar

set f_solicitudes = new CFormulario
f_solicitudes.Carga_Parametros "consultas.xml", "solicitudes"
f_solicitudes.Inicializar conectar

if request.QueryString<>"" then


' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888


	Select Case v_tipo
	   Case 1:
		' PAGO PROVEEDORES
		EXISTE=" SELECT MAX(PERS_NRUT) AS PERS_NRUT , MAX(ocag_baprueba_rector) AS ocag_baprueba_rector  FROM ( "&_		
								"  SELECT B.PERS_NRUT, ISNULL(ocag_baprueba_rector, 2) AS ocag_baprueba_rector FROM ocag_solicitud_giro A "&_
								"  INNER JOIN PERSONAS B "&_
								"  ON A.pers_ncorr_proveedor=B.PERS_NCORR "&_
								"  WHERE A.sogi_ncorr ="&v_solicitud&" "&_
								"  UNION SELECT 0 AS PERS_NRUT , 0 AS ocag_baprueba_rector  ) AS TABLA"
								
	   Case 2:
		' REEMBOLSO DE GASTOS
		EXISTE=" SELECT MAX(PERS_NRUT) AS PERS_NRUT , MAX(ocag_baprueba_rector) AS ocag_baprueba_rector FROM ( "&_		
								"  SELECT B.PERS_NRUT, ISNULL(ocag_baprueba_rector, 2) AS ocag_baprueba_rector  FROM ocag_reembolso_gastos A "&_
								"  INNER JOIN PERSONAS B "&_
								"  ON A.pers_ncorr_proveedor=B.PERS_NCORR "&_
								"  WHERE A.rgas_ncorr ="&v_solicitud&" "&_
								"  UNION SELECT 0 AS PERS_NRUT , 0 AS ocag_baprueba_rector  ) AS TABLA"
								
	   Case 3:
		' FONDO A RENDIR
		EXISTE=" SELECT MAX(PERS_NRUT) AS PERS_NRUT , MAX(ocag_baprueba_rector) AS ocag_baprueba_rector FROM ( "&_				
								"  SELECT B.PERS_NRUT , ISNULL(ocag_baprueba_rector, 2) AS ocag_baprueba_rector  FROM ocag_fondos_a_rendir A "&_
								"  INNER JOIN PERSONAS B "&_
								"  ON A.PERS_NCORR=B.PERS_NCORR "&_
								"  WHERE A.fren_ncorr ="&v_solicitud&" "&_
								"  UNION SELECT 0 AS PERS_NRUT , 0 AS ocag_baprueba_rector  ) AS TABLA"
								
	   Case 4:
		' SOLICITUD DE VIATICO
		EXISTE=" SELECT MAX(PERS_NRUT) AS PERS_NRUT, MAX(ocag_baprueba_rector) AS ocag_baprueba_rector  FROM ( "&_			
								"  SELECT B.PERS_NRUT, ISNULL(ocag_baprueba_rector, 2) AS ocag_baprueba_rector  FROM ocag_solicitud_viatico A "&_
								"  INNER JOIN PERSONAS B "&_
								"  ON A.PERS_NCORR=B.PERS_NCORR "&_
								"  WHERE A.sovi_ncorr ="&v_solicitud&" "&_
								"  UNION SELECT 0 AS PERS_NRUT , 0 AS ocag_baprueba_rector  ) AS TABLA"
								
	   Case 5:
		' DEVOLUCION ALUMNO
		EXISTE=" SELECT MAX(PERS_NRUT) AS PERS_NRUT , MAX(ocag_baprueba_rector) AS ocag_baprueba_rector FROM ( "&_	
								"  SELECT B.PERS_NRUT , ISNULL(ocag_baprueba_rector, 2) AS ocag_baprueba_rector FROM ocag_devolucion_alumno A "&_
								"  INNER JOIN PERSONAS B "&_
								"  ON A.PERS_NCORR=B.PERS_NCORR "&_
								"  WHERE A.dalu_ncorr ="&v_solicitud&" "&_
								"  UNION SELECT 0 AS PERS_NRUT , 0 AS ocag_baprueba_rector  ) AS TABLA"
								
	   Case 6:
		' NUEVO FONDO FIJO
		EXISTE=" SELECT MAX(PERS_NRUT) AS PERS_NRUT , MAX(ocag_baprueba_rector) AS ocag_baprueba_rector  FROM ( "&_	
								"  SELECT B.PERS_NRUT , ISNULL(ocag_baprueba_rector, 2) AS ocag_baprueba_rector  FROM ocag_fondo_fijo A "&_
								"  INNER JOIN PERSONAS B "&_
								"  ON A.PERS_NCORR=B.PERS_NCORR "&_
								"  WHERE A.ffij_ncorr ="&v_solicitud&" "&_
								"  UNION SELECT 0 AS PERS_NRUT , 0 AS ocag_baprueba_rector  ) AS TABLA"
								
	   Case 7:
		' RENDICION DE FONDO RENDIR
		EXISTE=" SELECT MAX(PERS_NRUT) AS PERS_NRUT , MAX(ocag_baprueba_rector) AS ocag_baprueba_rector  FROM ( "&_	
								"  SELECT B.pers_nrut , ISNULL(x.ocag_baprueba_rector, 2) AS ocag_baprueba_rector  FROM ocag_rendicion_fondos_a_rendir X "&_
								"  INNER JOIN ocag_fondos_a_rendir A "&_
								"  ON X.fren_ncorr = A.fren_ncorr AND X.rfre_ncorr = "&v_solicitud&" "&_
								"  INNER JOIN PERSONAS B "&_
								"  ON A.PERS_NCORR=B.PERS_NCORR "&_
								"  UNION SELECT 0 AS PERS_NRUT , 0 AS ocag_baprueba_rector ) AS TABLA"
								
	   Case 8:
		' RENDICION FONDO FIJO
		EXISTE=" SELECT MAX(PERS_NRUT) AS PERS_NRUT , MAX(ocag_baprueba_rector) AS ocag_baprueba_rector  FROM ( "&_	
								"  SELECT B.pers_nrut , ISNULL(x.ocag_baprueba_rector, 2) AS ocag_baprueba_rector  FROM ocag_rendicion_fondo_fijo X "&_
								"  INNER JOIN ocag_fondo_fijo A "&_
								"  ON X.ffij_ncorr = A.ffij_ncorr AND X.rffi_ncorr = "&v_solicitud&" "&_
								"  INNER JOIN PERSONAS B "&_
								"  ON A.PERS_NCORR=B.PERS_NCORR "&_	
								"  UNION SELECT 0 AS PERS_NRUT , 0 AS ocag_baprueba_rector ) AS TABLA"
								
	   Case 9:
		' ORDEN DE COMPRA
		EXISTE=" SELECT 0 AS PERS_NRUT "
		
 		EXISTE=" SELECT MAX(PERS_NRUT) AS PERS_NRUT , MAX(ocag_baprueba_rector) AS ocag_baprueba_rector FROM "&_	
								"  ( 		"&_	
  								" SELECT B.PERS_NRUT , ISNULL(ocag_baprueba_rector, 2) AS ocag_baprueba_rector FROM ocag_orden_compra A "&_	
  								" INNER JOIN PERSONAS B "&_	
  								" ON A.PERS_NCORR=B.PERS_NCORR "&_	
  								" WHERE A.ordc_ncorr = "&v_solicitud&" "&_
  								" UNION "&_	
  								" SELECT 0 AS PERS_NRUT , 0 AS ocag_baprueba_rector "&_	
  								" ) AS TABLA "
								
	End Select
	
			'RESPONSE.WRITE("1. EXISTE: "&EXISTE&"<BR>")
	
			'v_EXISTE=conectar2.consultaUno(EXISTE)
			'ocag_baprueba_rector=conectar3.consultaUno(EXISTE)
		
		set f_personas3 = new CFormulario
		f_personas3.carga_parametros "tabla_vacia.xml", "tabla_vacia"
		f_personas3.inicializar conectar
		
		f_personas3.consultar EXISTE
		f_personas3.Siguiente

		
		v_EXISTE = f_personas3.obtenerValor("PERS_NRUT")
		ocag_baprueba_rector = f_personas3.obtenerValor("ocag_baprueba_rector")

			'RESPONSE.WRITE("1. EXISTE : "&EXISTE&"<BR>")			
			'RESPONSE.WRITE("1. v_EXISTE : "&v_EXISTE&"<BR><BR>")
			'RESPONSE.WRITE("1. ocag_baprueba_rector : "&ocag_baprueba_rector&"<BR><BR>")
			'RESPONSE.END()

' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

		CHEQUE=" SELECT 0 AS N_SOLICITUD "
								
		IF v_tipo = 1 THEN

		' PAGO PROVEEDORES

		CHEQUE=" SELECT MAX(N_SOLICITUD) AS N_SOLICITUD FROM ( "&_
								" Select DISTINCT ISNULL(d.movfv,0) AS N_SOLICITUD "&_
								"  FROM softland.cwmovim a "&_
								"  INNER JOIN softland.cwmovim d "&_
								"  ON a.codaux = d.codaux AND a.codaux='"&v_EXISTE&"' "&_
								"  and a.NumDoc = d.MovNumDocRef "&_
								"  and a.ttdcod = d.MovTipDocRef "&_
								"  AND a.cpbano >= 2013  "&_
								"  and a.movfv is not null  "&_
								"  and a.movHaber > 0 "&_
								"  AND a.ttdcod in ('BH','FP','FL','BE') "&_
								"  AND a.MovTipDocRef in ('BH','FP','FL','BE') "&_
								"  and d.cpbano >= 2013  "&_
								"  and d.movfv is not null  "&_
								"  and d.MovDebe > 0 "&_
								"  AND d.ttdcod in ('CP') "&_
								"  AND d.MovTipDocRef in ('BH','FP','FL','BE') "&_
								"  AND d.NumDoc ="&v_solicitud&" "&_
								"  UNION SELECT 0 AS N_SOLICITUD ) AS TABLA"
								
	   ELSE
	   
		' REEMBOLSO DE GASTOS
		' FONDO A RENDIR
		' SOLICITUD DE VIATICO
		' DEVOLUCION ALUMNO
		' NUEVO FONDO FIJO
		' RENDICION DE FONDO RENDIR
		' RENDICION FONDO FIJO

		CHEQUE=" SELECT MAX(N_SOLICITUD) AS N_SOLICITUD FROM ( "&_
								" Select DISTINCT ISNULL(a.movfv,0) AS N_SOLICITUD  "&_
								"  FROM softland.cwmovim a  "&_
								"  INNER JOIN softland.cwpctas c  "&_
								"  on a.pctcod= c.pccodi  "&_
								"  WHERE a.codaux ='"&v_EXISTE&"' "&_
								"  AND a.ttdcod in ('BC','RG','FR','SV','DV','FF','RFR','RFF') "&_
								"  and a.cpbano >= 2013  "&_
								"  and a.movfv is not null  "&_
								"  and a.movHaber > 0 "&_
								"  and a.NumDoc ="&v_solicitud&" "&_
								"  UNION SELECT 0 AS N_SOLICITUD ) AS TABLA"

		END IF

		V_CHEQUE=conexion.consultaUno(CHEQUE)
		
		IF V_CHEQUE = "01-01-1900"  THEN
		V_CHEQUE=0
		END IF
		
		'RESPONSE.WRITE("1. V_CHEQUE : "&CHEQUE&"<BR>")
		'RESPONSE.WRITE("2. V_CHEQUE : "&V_CHEQUE&"<BR>")
		'RESPONSE.END()
		

' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
		'RESPONSE.WRITE("v_tipo : "&v_tipo&"<BR>")
		
	Select Case v_tipo
	   Case 1:
		'solicitud a proveedores
		
		'	sql_solicitudes="	select a.vibo_ccod,case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado,  "& vbCrLf &_
		'						"  protic.trunc(asgi_fautorizado) as fecha_valida "& vbCrLf &_
		'						" from ocag_visto_bueno a "& vbCrLf &_
		'						" left outer join ocag_autoriza_solicitud_giro b  "& vbCrLf &_
		'						"	on b.cod_solicitud="&v_solicitud&" "& vbCrLf &_
		'						"   and a.vibo_ccod  = b.vibo_ccod  "& vbCrLf &_
		'						"   and isnull(tsol_ccod,1) ="&v_tipo&" "& vbCrLf &_
		'						" 	where a.vibo_ccod not in (5,10,11,12) order by vibo_norden asc"		
		
			' ocag_baprueba_rector = 2;  NO Aprueba rector.
			IF ocag_baprueba_rector  = 2 THEN 
			
			sql_solicitudes="select 1 AS COLUMNA, a.vibo_ccod "&_
								" 	, case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
								" 	, protic.trunc(asgi_fautorizado) as fecha_valida  "&_
								" 	from ocag_visto_bueno a  "&_
								" 	LEFT outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,1) ="&v_tipo&"  "&_
								" 	where a.vibo_ccod not in (5,7,8,9,10,11,12)  "&_
								" 	UNION "&_
								" 	select 3 AS COLUMNA, a.vibo_ccod "&_
								" 	, case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
								" 	, protic.trunc(asgi_fautorizado) as fecha_valida  "&_
								" 	from ocag_visto_bueno a  "&_
								" 	LEFT outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,1) ="&v_tipo&"  "&_
								" 	where a.vibo_ccod = 7 "&_
								" 	UNION "&_
								" 	select 4 AS COLUMNA, a.vibo_ccod "&_
								" 	, case when "&V_CHEQUE&" <> 0 then 'OK' else 'Pendiente' end as estado "&_
								" 	, case when "&V_CHEQUE&" <> 0 then protic.trunc('"&V_CHEQUE&"') else '' end as fecha_valida "&_
								" 	from ocag_visto_bueno a  "&_
								" 	LEFT outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,1) ="&v_tipo&"  "&_
								" 	where a.vibo_ccod in (8)  "&_
								" 	UNION "&_
								" 	select 5 AS COLUMNA, a.vibo_ccod "&_
								" 	, case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
								" 	, protic.trunc(asgi_fautorizado) as fecha_valida  "&_
								" 	from ocag_visto_bueno a  "&_
								" 	LEFT outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,1) ="&v_tipo&"  "&_
								" 	where a.vibo_ccod in (9) "&_		
								" 	ORDER BY COLUMNA, vibo_ccod "
								
			END IF
			
			' ocag_baprueba_rector = 1;  SI Aprueba rector.
			IF ocag_baprueba_rector  = 1 THEN 
			
			sql_solicitudes="select 1 AS COLUMNA, a.vibo_ccod "&_
								" 	, case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
								" 	, protic.trunc(asgi_fautorizado) as fecha_valida  "&_
								" 	from ocag_visto_bueno a  "&_
								" 	LEFT outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,1) ="&v_tipo&"  "&_
								" 	where a.vibo_ccod not in (5,7,8,9,10,11,12)  "&_
								" 	UNION "&_
								" 	select 2 AS COLUMNA, a.vibo_ccod "&_
								" 	, case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
								" 	, protic.trunc(asgi_fautorizado) as fecha_valida  "&_
								" 	from ocag_visto_bueno a  "&_
								" 	LEFT outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,1) ="&v_tipo&"  "&_
								" 	where a.vibo_ccod = 11 "&_
								" 	UNION "&_
								" 	select 3 AS COLUMNA, a.vibo_ccod "&_
								" 	, case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
								" 	, protic.trunc(asgi_fautorizado) as fecha_valida  "&_
								" 	from ocag_visto_bueno a  "&_
								" 	LEFT outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,1) ="&v_tipo&"  "&_
								" 	where a.vibo_ccod = 7 "&_
								" 	UNION "&_
								" 	select 4 AS COLUMNA, a.vibo_ccod "&_
								" 	, case when "&V_CHEQUE&" <> 0 then 'OK' else 'Pendiente' end as estado "&_
								" 	, case when "&V_CHEQUE&" <> 0 then protic.trunc('"&V_CHEQUE&"') else '' end as fecha_valida "&_
								" 	from ocag_visto_bueno a  "&_
								" 	LEFT outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,1) ="&v_tipo&"  "&_
								" 	where a.vibo_ccod in (8)  "&_
								" 	UNION "&_
								" 	select 5 AS COLUMNA, a.vibo_ccod "&_
								" 	, case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
								" 	, protic.trunc(asgi_fautorizado) as fecha_valida  "&_
								" 	from ocag_visto_bueno a  "&_
								" 	LEFT outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,1) ="&v_tipo&"  "&_
								" 	where a.vibo_ccod in (9) "&_		
								" 	ORDER BY COLUMNA, vibo_ccod "
			
			END IF
			

			sql_datos="	select sogi_mgiro as  monto,protic.obtener_nombre_completo(pers_ncorr_proveedor,'n') as proveedor "& vbCrLf &_
						" from ocag_solicitud_giro a "& vbCrLf &_
						"	where a.sogi_ncorr="&v_solicitud
					  
	   Case 2:
		'reembolso gastos
'			sql_solicitudes="	select a.vibo_ccod,case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado, "& vbCrLf &_
'							"  protic.trunc(asgi_fautorizado) as fecha_valida "& vbCrLf &_
'							" from ocag_visto_bueno a "& vbCrLf &_
'							" left outer join ocag_autoriza_solicitud_giro b  "& vbCrLf &_
'							"	on b.cod_solicitud="&v_solicitud&" "& vbCrLf &_
'							"   and a.vibo_ccod  = b.vibo_ccod  "& vbCrLf &_
'							"   and isnull(tsol_ccod,2) ="&v_tipo&" "& vbCrLf &_
'							" 	where a.vibo_ccod not in (5,10,11,12) order by vibo_norden asc"	

			' ocag_baprueba_rector = 2;  NO Aprueba rector.
			IF ocag_baprueba_rector  = 2 THEN 
							
			sql_solicitudes=" select 1 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida "&_
							" from ocag_visto_bueno a "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,2) ="&v_tipo&" "&_
							" where a.vibo_ccod not in (5,7,8,9,10,11,12)  "&_
							" UNION "&_
							" select 3 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida "&_
							" from ocag_visto_bueno a "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,2) ="&v_tipo&" "&_
							" where a.vibo_ccod =7 "&_
							" UNION "&_
							" select 4 AS COLUMNA, a.vibo_ccod "&_
								" 	, case when "&V_CHEQUE&" <> 0 then 'OK' else 'Pendiente' end as estado "&_
								" 	, case when "&V_CHEQUE&" <> 0 then protic.trunc('"&V_CHEQUE&"') else '' end as fecha_valida "&_
							" from ocag_visto_bueno a "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,2) ="&v_tipo&" "&_
							" where a.vibo_ccod in (8) "&_
							" UNION "&_
							" select 5 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida "&_
							" from ocag_visto_bueno a "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,2) ="&v_tipo&" "&_
							" where a.vibo_ccod in (9) "&_		
								" 	ORDER BY COLUMNA, vibo_ccod "	

			END IF
			
			' ocag_baprueba_rector = 1;  SI Aprueba rector.
			IF ocag_baprueba_rector  = 1 THEN 

			sql_solicitudes=" select 1 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida "&_
							" from ocag_visto_bueno a "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,2) ="&v_tipo&" "&_
							" where a.vibo_ccod not in (5,7,8,9,10,11,12)  "&_
							" UNION "&_
							" select 2 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida "&_
							" from ocag_visto_bueno a "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,2) ="&v_tipo&" "&_
							" where a.vibo_ccod =11 "&_
							" UNION "&_
							" select 3 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida "&_
							" from ocag_visto_bueno a "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,2) ="&v_tipo&" "&_
							" where a.vibo_ccod =7 "&_
							" UNION "&_
							" select 4 AS COLUMNA, a.vibo_ccod "&_
								" 	, case when "&V_CHEQUE&" <> 0 then 'OK' else 'Pendiente' end as estado "&_
								" 	, case when "&V_CHEQUE&" <> 0 then protic.trunc('"&V_CHEQUE&"') else '' end as fecha_valida "&_
							" from ocag_visto_bueno a "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,2) ="&v_tipo&" "&_
							" where a.vibo_ccod in (8) "&_
							" UNION "&_
							" select 5 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida "&_
							" from ocag_visto_bueno a "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,2) ="&v_tipo&" "&_
							" where a.vibo_ccod in (9) "&_		
								" 	ORDER BY COLUMNA, vibo_ccod "	
			
			end if

			sql_datos="	select rgas_mgiro as  monto,protic.obtener_nombre_completo(pers_ncorr_proveedor,'n') as proveedor "& vbCrLf &_
						" from ocag_reembolso_gastos a "& vbCrLf &_
						"	where a.rgas_ncorr="&v_solicitud
					
	   Case 3:
		'fondos a rendir
'			sql_solicitudes="	select a.vibo_ccod,case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado,  "& vbCrLf &_
'							"  protic.trunc(asgi_fautorizado) as fecha_valida "& vbCrLf &_
'							" from ocag_visto_bueno a "& vbCrLf &_
'							" left outer join ocag_autoriza_solicitud_giro b  "& vbCrLf &_
'							"	on b.cod_solicitud="&v_solicitud&" "& vbCrLf &_
'							"   and a.vibo_ccod  = b.vibo_ccod  "& vbCrLf &_
'							"   and isnull(tsol_ccod,3) ="&v_tipo&" "& vbCrLf &_
'							" 	where a.vibo_ccod not in (5,10,11,12) order by vibo_norden asc"	

			' ocag_baprueba_rector = 2;  NO Aprueba rector.
			IF ocag_baprueba_rector  = 2 THEN 
			
			sql_solicitudes=" select 1 AS COLUMNA, a.vibo_ccod "&_
							" ,case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida "&_
							" from ocag_visto_bueno a "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,3) ="&v_tipo&" "&_
							" where a.vibo_ccod not in (5,7,8,9,10,11,12)  "&_
							" UNION "&_
							" select 3 AS COLUMNA, a.vibo_ccod "&_
							" ,case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida "&_
							" from ocag_visto_bueno a "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,3) ="&v_tipo&" "&_
							" where a.vibo_ccod =7 "&_
							" UNION "&_
							" select 4 AS COLUMNA, a.vibo_ccod "&_
								" 	, case when "&V_CHEQUE&" <> 0 then 'OK' else 'Pendiente' end as estado "&_
								" 	, case when "&V_CHEQUE&" <> 0 then protic.trunc('"&V_CHEQUE&"') else '' end as fecha_valida "&_
							" from ocag_visto_bueno a "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,3) ="&v_tipo&" "&_
							" where a.vibo_ccod in (8) "&_
							" UNION "&_
							" select 5 AS COLUMNA, a.vibo_ccod "&_
							" ,case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida "&_
							" from ocag_visto_bueno a "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,3) ="&v_tipo&" "&_
							" where a.vibo_ccod in (9) "&_		
								" 	ORDER BY COLUMNA, vibo_ccod "	
								
			END IF
			
			' ocag_baprueba_rector = 1;  SI Aprueba rector.
			IF ocag_baprueba_rector  = 1 THEN 

			sql_solicitudes=" select 1 AS COLUMNA, a.vibo_ccod "&_
							" ,case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida "&_
							" from ocag_visto_bueno a "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,3) ="&v_tipo&" "&_
							" where a.vibo_ccod not in (5,7,8,9,10,11,12)  "&_
							" UNION "&_
							" select 2 AS COLUMNA, a.vibo_ccod "&_
							" ,case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida "&_
							" from ocag_visto_bueno a "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,3) ="&v_tipo&" "&_
							" where a.vibo_ccod =11  "&_
							" UNION "&_
							" select 3 AS COLUMNA, a.vibo_ccod "&_
							" ,case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida "&_
							" from ocag_visto_bueno a "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,3) ="&v_tipo&" "&_
							" where a.vibo_ccod =7 "&_
							" UNION "&_
							" select 4 AS COLUMNA, a.vibo_ccod "&_
								" 	, case when "&V_CHEQUE&" <> 0 then 'OK' else 'Pendiente' end as estado "&_
								" 	, case when "&V_CHEQUE&" <> 0 then protic.trunc('"&V_CHEQUE&"') else '' end as fecha_valida "&_
							" from ocag_visto_bueno a "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,3) ="&v_tipo&" "&_
							" where a.vibo_ccod in (8) "&_
							" UNION "&_
							" select 5 AS COLUMNA, a.vibo_ccod "&_
							" ,case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida "&_
							" from ocag_visto_bueno a "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,3) ="&v_tipo&" "&_
							" where a.vibo_ccod in (9) "&_		
								" 	ORDER BY COLUMNA, vibo_ccod "	
			
			END IF

			sql_datos="	select fren_mmonto as  monto,protic.obtener_nombre_completo(pers_ncorr,'n') as proveedor "& vbCrLf &_
						" from ocag_fondos_a_rendir a "& vbCrLf &_
						"	where  a.fren_ncorr="&v_solicitud
	   Case 4:
		'viaticos
'			sql_solicitudes="	select a.vibo_ccod,case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado, "& vbCrLf &_
'							"  protic.trunc(asgi_fautorizado) as fecha_valida "& vbCrLf &_
'							" from ocag_visto_bueno a "& vbCrLf &_
'							" left outer join ocag_autoriza_solicitud_giro b  "& vbCrLf &_
'							"	on b.cod_solicitud="&v_solicitud&" "& vbCrLf &_
'							"   and a.vibo_ccod  = b.vibo_ccod  "& vbCrLf &_
'							"   and isnull(tsol_ccod,4) ="&v_tipo&" "& vbCrLf &_
'							" 	where a.vibo_ccod not in (5,10,11,12) order by vibo_norden asc"	

			' ocag_baprueba_rector = 2;  NO Aprueba rector.
			IF ocag_baprueba_rector  = 2 THEN 
			
			sql_solicitudes="select 1 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,4) ="&v_tipo&"   "&_
							" where a.vibo_ccod not in (5,7,8,9,10,11,12)  "&_
							" UNION "&_
							"select 3 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,4) ="&v_tipo&"   "&_
							" where a.vibo_ccod =7  "&_
							" UNION "&_
							" select 4 AS COLUMNA, a.vibo_ccod "&_
								" 	, case when "&V_CHEQUE&" <> 0 then 'OK' else 'Pendiente' end as estado "&_
								" 	, case when "&V_CHEQUE&" <> 0 then protic.trunc('"&V_CHEQUE&"') else '' end as fecha_valida "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,4) ="&v_tipo&"   "&_
							" where a.vibo_ccod in (8)  "&_
							" UNION "&_
							" select 5 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,4) ="&v_tipo&"   "&_
							" where a.vibo_ccod in (9) "&_		
								" 	ORDER BY COLUMNA, vibo_ccod "
								
			END IF
			
			' ocag_baprueba_rector = 1;  SI Aprueba rector.
			IF ocag_baprueba_rector  = 1 THEN 

			sql_solicitudes="select 1 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,4) ="&v_tipo&"   "&_
							" where a.vibo_ccod not in (5,7,8,9,10,11,12)  "&_
							" UNION "&_
							"select 2 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,4) ="&v_tipo&"   "&_
							" where a.vibo_ccod =11 "&_
							" UNION "&_
							"select 3 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,4) ="&v_tipo&"   "&_
							" where a.vibo_ccod =7  "&_
							" UNION "&_
							" select 4 AS COLUMNA, a.vibo_ccod "&_
								" 	, case when "&V_CHEQUE&" <> 0 then 'OK' else 'Pendiente' end as estado "&_
								" 	, case when "&V_CHEQUE&" <> 0 then protic.trunc('"&V_CHEQUE&"') else '' end as fecha_valida "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,4) ="&v_tipo&"   "&_
							" where a.vibo_ccod in (8)  "&_
							" UNION "&_
							" select 5 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,4) ="&v_tipo&"   "&_
							" where a.vibo_ccod in (9) "&_		
								" 	ORDER BY COLUMNA, vibo_ccod "

			END IF
							
			sql_datos="	select sovi_mmonto_pesos as  monto,protic.obtener_nombre_completo(pers_ncorr,'n') as proveedor "& vbCrLf &_
						" from ocag_solicitud_viatico a "& vbCrLf &_
						"	where a.sovi_ncorr="&v_solicitud
	   Case 5:
		'devolucion alumnos
'			sql_solicitudes="	select a.vibo_ccod,case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado, "& vbCrLf &_
'							"  protic.trunc(asgi_fautorizado) as fecha_valida "& vbCrLf &_
'							" from ocag_visto_bueno a "& vbCrLf &_
'							" left outer join ocag_autoriza_solicitud_giro b  "& vbCrLf &_
'							"	on b.cod_solicitud="&v_solicitud&" "& vbCrLf &_
'							"   and a.vibo_ccod  = b.vibo_ccod  "& vbCrLf &_
'							"   and isnull(tsol_ccod,5) ="&v_tipo&" "& vbCrLf &_
'							" 	where a.vibo_ccod not in (5,10,11,12) order by vibo_norden asc "	

			' ocag_baprueba_rector = 2;  NO Aprueba rector.
			IF ocag_baprueba_rector  = 2 THEN 
							
			sql_solicitudes=" select 1 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,5) ="&v_tipo&"  "&_
							" where a.vibo_ccod not in (5,7,8,9,10,11,12)  "&_
							" UNION "&_
							" select 3 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,5) ="&v_tipo&"  "&_
							" where a.vibo_ccod =7  "&_
							" UNION "&_
							" select 4 AS COLUMNA, a.vibo_ccod "&_
								" 	, case when "&V_CHEQUE&" <> 0 then 'OK' else 'Pendiente' end as estado "&_
								" 	, case when "&V_CHEQUE&" <> 0 then protic.trunc('"&V_CHEQUE&"') else '' end as fecha_valida "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,5) ="&v_tipo&"   "&_
							" where a.vibo_ccod in (8)  "&_
							" UNION "&_
							" select 5 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,5) ="&v_tipo&"   "&_
							" where a.vibo_ccod in (9) "&_		
								" 	ORDER BY COLUMNA, vibo_ccod "	
								
			END IF
			
			' ocag_baprueba_rector = 1;  SI Aprueba rector.
			IF ocag_baprueba_rector  = 1 THEN 
			
			sql_solicitudes=" select 1 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,5) ="&v_tipo&"  "&_
							" where a.vibo_ccod not in (5,7,8,9,10,11,12)  "&_
							" UNION "&_
							" select 2 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,5) ="&v_tipo&"  "&_
							" where a.vibo_ccod =11 "&_
							" UNION "&_
							" select 3 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,5) ="&v_tipo&"  "&_
							" where a.vibo_ccod =7  "&_
							" UNION "&_
							" select 4 AS COLUMNA, a.vibo_ccod "&_
								" 	, case when "&V_CHEQUE&" <> 0 then 'OK' else 'Pendiente' end as estado "&_
								" 	, case when "&V_CHEQUE&" <> 0 then protic.trunc('"&V_CHEQUE&"') else '' end as fecha_valida "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,5) ="&v_tipo&"   "&_
							" where a.vibo_ccod in (8)  "&_
							" UNION "&_
							" select 5 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,5) ="&v_tipo&"   "&_
							" where a.vibo_ccod in (9) "&_		
								" 	ORDER BY COLUMNA, vibo_ccod "	

			END IF

			sql_datos="	select dalu_mmonto_pesos as  monto,protic.obtener_nombre_completo(pers_ncorr,'n') as proveedor "& vbCrLf &_
						" from ocag_devolucion_alumno a "& vbCrLf &_
						"	where a.dalu_ncorr="&v_solicitud
	   Case 6:
		'fondo fijo
'			sql_solicitudes="	select a.vibo_ccod,case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado, "& vbCrLf &_
'							"  protic.trunc(asgi_fautorizado) as fecha_valida "& vbCrLf &_
'							" from ocag_visto_bueno a "& vbCrLf &_
'							" left outer join ocag_autoriza_solicitud_giro b  "& vbCrLf &_
'							"	on b.cod_solicitud="&v_solicitud&" "& vbCrLf &_
'							"   and a.vibo_ccod  = b.vibo_ccod  "& vbCrLf &_
'							"   and isnull(tsol_ccod,6) ="&v_tipo&" "& vbCrLf &_
'							" 	where a.vibo_ccod not in (5,10,11,12) order by vibo_norden asc"	

			' ocag_baprueba_rector = 2;  NO Aprueba rector.
			IF ocag_baprueba_rector  = 2 THEN 
			
			sql_solicitudes=" select 1 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&"  and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,6) ="&v_tipo&" "&_
							" where a.vibo_ccod not in (5,7,8,9,10,11,12)  "&_
							" UNION "&_
							" select 3 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&"  and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,6) ="&v_tipo&" "&_
							" where a.vibo_ccod =7 "&_
							" UNION "&_
							" select 4 AS COLUMNA, a.vibo_ccod "&_
								" 	, case when "&V_CHEQUE&" <> 0 then 'OK' else 'Pendiente' end as estado "&_
								" 	, case when "&V_CHEQUE&" <> 0 then protic.trunc('"&V_CHEQUE&"') else '' end as fecha_valida "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&"  and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,6) ="&v_tipo&"  "&_
							" where a.vibo_ccod in (8)  "&_
							" UNION "&_
							" select 5 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&"  and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,6) ="&v_tipo&"  "&_
							" where a.vibo_ccod in (9) "&_		
								" 	ORDER BY COLUMNA, vibo_ccod "	
								
			END IF
			
			' ocag_baprueba_rector = 1;  SI Aprueba rector.
			IF ocag_baprueba_rector  = 1 THEN 
			
			sql_solicitudes=" select 1 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&"  and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,6) ="&v_tipo&" "&_
							" where a.vibo_ccod not in (5,7,8,9,10,11,12)  "&_
							" UNION "&_
							" select 2 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&"  and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,6) ="&v_tipo&" "&_
							" where a.vibo_ccod =11 "&_
							" UNION "&_
							" select 3 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&"  and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,6) ="&v_tipo&" "&_
							" where a.vibo_ccod =7 "&_
							" UNION "&_
							" select 4 AS COLUMNA, a.vibo_ccod "&_
								" 	, case when "&V_CHEQUE&" <> 0 then 'OK' else 'Pendiente' end as estado "&_
								" 	, case when "&V_CHEQUE&" <> 0 then protic.trunc('"&V_CHEQUE&"') else '' end as fecha_valida "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&"  and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,6) ="&v_tipo&"  "&_
							" where a.vibo_ccod in (8)  "&_
							" UNION "&_
							" select 5 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&"  and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,6) ="&v_tipo&"  "&_
							" where a.vibo_ccod in (9) "&_		
								" 	ORDER BY COLUMNA, vibo_ccod "	

			END IF

			sql_datos="	select ffij_mmonto_pesos as  monto,protic.obtener_nombre_completo(pers_ncorr,'n') as proveedor "& vbCrLf &_
						" from ocag_fondo_fijo a "& vbCrLf &_
						"   where a.ffij_ncorr="&v_solicitud

	   Case 7:
		' Rendicion fondo a rendir
'			sql_solicitudes="	select a.vibo_ccod,case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado, "& vbCrLf &_
'							"  protic.trunc(asgi_fautorizado) as fecha_valida "& vbCrLf &_
'							" from ocag_visto_bueno a "& vbCrLf &_
'							" left outer join ocag_autoriza_solicitud_giro b  "& vbCrLf &_
'							"	on b.cod_solicitud="&v_solicitud&" "& vbCrLf &_
'							"   and a.vibo_ccod  = b.vibo_ccod  "& vbCrLf &_
'							"   and isnull(tsol_ccod,7) ="&v_tipo&" "& vbCrLf &_
'							" 	where a.vibo_ccod not in (5,10,11,12) order by vibo_norden asc"	

			' ocag_baprueba_rector = 2;  NO Aprueba rector.
			IF ocag_baprueba_rector  = 2 THEN 
			
			sql_solicitudes=" select 0 AS COLUMNA, 0 as vibo_ccod "&_
							" , 'OK' as estado "&_
							" , protic.trunc(ocag_fingreso) as fecha_valida "&_
							" from ocag_rendicion_fondos_a_rendir where rfre_ncorr="&v_solicitud&" "&_
							" UNION "&_
							" select 1 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,7) ="&v_tipo&"   "&_
							" where a.vibo_ccod not in (0,5,7,8,9,10,11,12)  "&_
							" UNION "&_
							" select 3 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,7) ="&v_tipo&"   "&_
							" where a.vibo_ccod =7  "&_
							" UNION "&_
							" select 4 AS COLUMNA, a.vibo_ccod "&_
								" 	, case when "&V_CHEQUE&" <> 0 then 'OK' else 'Pendiente' end as estado "&_
								" 	, case when "&V_CHEQUE&" <> 0 then protic.trunc('"&V_CHEQUE&"') else '' end as fecha_valida "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&"  and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,7) ="&v_tipo&"   "&_
							" where a.vibo_ccod in (8)  "&_
							" UNION "&_
							" select 5 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&"  and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,7) ="&v_tipo&"   "&_
							" where a.vibo_ccod in (9) "&_		
								" 	ORDER BY COLUMNA, vibo_ccod "	
								
			END IF
			
			' ocag_baprueba_rector = 1;  SI Aprueba rector.
			IF ocag_baprueba_rector  = 1 THEN 
			
			sql_solicitudes=" select 0 AS COLUMNA, 0 as vibo_ccod "&_
							" , 'OK' as estado "&_
							" , protic.trunc(ocag_fingreso) as fecha_valida "&_
							" from ocag_rendicion_fondos_a_rendir where rfre_ncorr="&v_solicitud&" "&_
							" UNION "&_
							" select 1 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,7) ="&v_tipo&"   "&_
							" where a.vibo_ccod not in (0,5,7,8,9,10,11,12)  "&_
							" UNION "&_
							" select 2 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,7) ="&v_tipo&"   "&_
							" where a.vibo_ccod =11 "&_
							" UNION "&_
							" select 3 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&" and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,7) ="&v_tipo&"   "&_
							" where a.vibo_ccod =7  "&_
							" UNION "&_
							" select 4 AS COLUMNA, a.vibo_ccod "&_
								" 	, case when "&V_CHEQUE&" <> 0 then 'OK' else 'Pendiente' end as estado "&_
								" 	, case when "&V_CHEQUE&" <> 0 then protic.trunc('"&V_CHEQUE&"') else '' end as fecha_valida "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&"  and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,7) ="&v_tipo&"   "&_
							" where a.vibo_ccod in (8)  "&_
							" UNION "&_
							" select 5 AS COLUMNA, a.vibo_ccod "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on b.cod_solicitud="&v_solicitud&"  and a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,7) ="&v_tipo&"   "&_
							" where a.vibo_ccod in (9) "&_		
								" 	ORDER BY COLUMNA, vibo_ccod "	
			
			END IF

			sql_datos="	select rfre_mmonto as  monto, "& vbCrLf &_
						" ( select protic.obtener_nombre_completo(fr.pers_ncorr,'n') from ocag_fondos_a_rendir fr where fr.fren_ncorr= a.fren_ncorr)as proveedor "& vbCrLf &_
						" from ocag_rendicion_fondos_a_rendir a "& vbCrLf &_
						"   where a.rfre_ncorr="&v_solicitud
						
	   Case 8:
		' Rendicion fondo FIJO
'			sql_solicitudes="	select a.vibo_ccod "& vbCrLf &_
'							",case "& vbCrLf &_
'							"when b.asgi_nestado=5 then 'Observado' "& vbCrLf &_
'							"when b.asgi_nestado=3 then 'Rechazado' "& vbCrLf &_
'							"when b.asgi_nestado=1 then 'OK' "& vbCrLf &_
'							"else 'Pendiente' end as estado "& vbCrLf &_
'							", protic.trunc(asgi_fautorizado) as fecha_valida "& vbCrLf &_
'							"from ocag_visto_bueno a "& vbCrLf &_
'							"left outer join ocag_autoriza_solicitud_giro b "& vbCrLf &_
'							"on a.vibo_ccod = b.vibo_ccod "& vbCrLf &_
'							"and isnull(tsol_ccod,8) ="&v_tipo&" "& vbCrLf &_
'							"and b.cod_solicitud= "&v_solicitud&" "& vbCrLf &_
'							"where a.vibo_ccod not in (5,10,11,12) "& vbCrLf &_
'							"order by vibo_norden asc"	

			' ocag_baprueba_rector = 2;  NO Aprueba rector.
			IF ocag_baprueba_rector  = 2 THEN 
			
			sql_solicitudes=" select 0 AS COLUMNA, 0 as vibo_ccod "&_
							" , 'OK' as estado "&_
							" , protic.trunc(ocag_fingreso) as fecha_valida "&_
							" from ocag_rendicion_fondo_fijo where rffi_ncorr="&v_solicitud&" "&_
							" UNION "&_
							" select 1 AS COLUMNA, a.vibo_ccod  "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado  "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,8) ="&v_tipo&" and b.cod_solicitud="&v_solicitud&"  "&_
							" where a.vibo_ccod not in (0,5,7,8,9,10,11,12)  "&_
							" UNION "&_
							" select 3 AS COLUMNA, a.vibo_ccod  "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado  "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,8) ="&v_tipo&" and b.cod_solicitud="&v_solicitud&"  "&_
							" where a.vibo_ccod =7 "&_
							" UNION "&_
							" select 4 AS COLUMNA, a.vibo_ccod  "&_
								" 	, case when "&V_CHEQUE&" <> 0 then 'OK' else 'Pendiente' end as estado "&_
								" 	, case when "&V_CHEQUE&" <> 0 then protic.trunc('"&V_CHEQUE&"') else '' end as fecha_valida "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,8) ="&v_tipo&"  and b.cod_solicitud="&v_solicitud&"  "&_
							" where a.vibo_ccod in (8)  "&_
							" UNION "&_
							" select 5 AS COLUMNA, a.vibo_ccod  "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado  "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,8) ="&v_tipo&"  and b.cod_solicitud="&v_solicitud&"  "&_
							" where a.vibo_ccod in (9) "&_		
								" 	ORDER BY COLUMNA, vibo_ccod "	
								
			END IF

			' ocag_baprueba_rector = 1;  SI Aprueba rector.
			IF ocag_baprueba_rector  = 1 THEN 
			
			sql_solicitudes=" select 0 AS COLUMNA, 0 as vibo_ccod "&_
							" , 'OK' as estado "&_
							" , protic.trunc(ocag_fingreso) as fecha_valida "&_
							" from ocag_rendicion_fondo_fijo where rffi_ncorr="&v_solicitud&" "&_
							" UNION "&_
							" select 1 AS COLUMNA, a.vibo_ccod  "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado  "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,8) ="&v_tipo&" and b.cod_solicitud="&v_solicitud&"  "&_
							" where a.vibo_ccod not in (0,5,7,8,9,10,11,12)  "&_
							" UNION "&_
							" select 2 AS COLUMNA, a.vibo_ccod  "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado  "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,8) ="&v_tipo&" and b.cod_solicitud="&v_solicitud&"  "&_
							" where a.vibo_ccod =11  "&_
							" UNION "&_
							" select 3 AS COLUMNA, a.vibo_ccod  "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado  "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,8) ="&v_tipo&" and b.cod_solicitud="&v_solicitud&"  "&_
							" where a.vibo_ccod =7 "&_
							" UNION "&_
							" select 4 AS COLUMNA, a.vibo_ccod  "&_
								" 	, case when "&V_CHEQUE&" <> 0 then 'OK' else 'Pendiente' end as estado "&_
								" 	, case when "&V_CHEQUE&" <> 0 then protic.trunc('"&V_CHEQUE&"') else '' end as fecha_valida "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,8) ="&v_tipo&"  and b.cod_solicitud="&v_solicitud&"  "&_
							" where a.vibo_ccod in (8)  "&_
							" UNION "&_
							" select 5 AS COLUMNA, a.vibo_ccod  "&_
							" , case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado  "&_
							" , protic.trunc(asgi_fautorizado) as fecha_valida  "&_
							" from ocag_visto_bueno a  "&_
							" left outer join ocag_autoriza_solicitud_giro b on a.vibo_ccod = b.vibo_ccod and isnull(tsol_ccod,8) ="&v_tipo&"  and b.cod_solicitud="&v_solicitud&"  "&_
							" where a.vibo_ccod in (9) "&_		
								" 	ORDER BY COLUMNA, vibo_ccod "	

			END IF
			
			sql_datos=" select rffi_mmonto as monto, (  "& vbCrLf &_
						"select protic.obtener_nombre_completo(fr.pers_ncorr,'n')  "& vbCrLf &_
						"from ocag_fondos_a_rendir fr "& vbCrLf &_
						"where fr.fren_ncorr= a.ffij_ncorr)as proveedor "& vbCrLf &_
						"from ocag_rendicion_fondo_fijo a "& vbCrLf &_
						"where a.ffij_ncorr="&v_solicitud

		Case 9:
				'Orden de Compra
				
			' ocag_baprueba_rector = 2;  NO Aprueba rector.
			IF ocag_baprueba_rector  = 2 THEN 
			
					sql_solicitudes="	select a.vibo_ccod,case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado, "& vbCrLf &_
									"  protic.trunc(asgi_fautorizado) as fecha_valida "& vbCrLf &_
									" from ocag_visto_bueno a "& vbCrLf &_
									" left outer join ocag_autoriza_solicitud_giro b  "& vbCrLf &_
									"	on b.cod_solicitud="&v_solicitud&" "& vbCrLf &_
									"   and a.vibo_ccod  = b.vibo_ccod  "& vbCrLf &_
									"   and isnull(tsol_ccod,9) ="&v_tipo&" "& vbCrLf &_
									" 	where a.vibo_ccod not in (3,5,7,8,9,10,11,12) order by vibo_norden asc"	
									
			END IF

			' ocag_baprueba_rector = 1;  SI Aprueba rector.
			IF ocag_baprueba_rector  = 1 THEN 
			
					sql_solicitudes="	select a.vibo_ccod,case when b.asgi_nestado=5 then 'Observado' when b.asgi_nestado=3 then 'Rechazado' when b.asgi_nestado=1 then 'OK' else 'Pendiente' end as estado, "& vbCrLf &_
									"  protic.trunc(asgi_fautorizado) as fecha_valida "& vbCrLf &_
									" from ocag_visto_bueno a "& vbCrLf &_
									" left outer join ocag_autoriza_solicitud_giro b  "& vbCrLf &_
									"	on b.cod_solicitud="&v_solicitud&" "& vbCrLf &_
									"   and a.vibo_ccod  = b.vibo_ccod  "& vbCrLf &_
									"   and isnull(tsol_ccod,9) ="&v_tipo&" "& vbCrLf &_
									" 	where a.vibo_ccod not in (3,5,7,8,9,10,12) order by vibo_norden asc"	

			END IF

					sql_datos="	select ordc_mmonto as  monto,protic.obtener_nombre_completo(pers_ncorr,'n') as proveedor "& vbCrLf &_
								" from ocag_orden_compra a "& vbCrLf &_
								"   where a.ordc_ncorr="&v_solicitud						
	End Select
else
	sql_solicitudes	= "select '' "
	sql_datos	= "select '' "
	
end if

'RESPONSE.WRITE("1. sql_solicitudes : "&sql_solicitudes&"<BR>")
'RESPONSE.WRITE("2. sql_datos : "&sql_datos&"<BR>")

'sql_solicitudes	= "select '' "
f_solicitudes.Consultar sql_solicitudes
f_datos.Consultar sql_datos
f_datos.Siguiente 
if f_datos.obtenerValor("proveedor") = "" AND v_solicitud <> "" then
	response.write("<script>alert('No existe registro');</script>")
end if
set f_buscador = new CFormulario
f_buscador.Carga_Parametros "consultas.xml", "buscador"
f_buscador.Inicializar conectar
f_buscador.Consultar " select '' "
f_buscador.Siguiente

f_buscador.agregaCampoCons "solicitud", v_solicitud
f_buscador.agregaCampoCons "tsol_ccod", v_tipo
f_buscador.agregaCampoCons "anos_ccod", v_anos
 
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function Enviar(){
	return true;
}

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
          <td>
		  <table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Solicitud de viaticos</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				  <br>
                    <div align="center"><font size="+1">
                      <%pagina.DibujarTituloPagina()%> 
                      </font>                    </div>
                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
						<tr> 
							  <td>
								<form name="buscador"> 
								<table width="100%">
									<tr>
										<td width="17%">Numero Solicitud :</td>
										<td width="18%"><%f_buscador.dibujaCampo("solicitud")%></td>
										<td width="15%">Año :</td>
									    <td width="18%"><%f_buscador.dibujaCampo("anos_ccod")%></td>									
										<td width="15%">Tipo Solicitud :</td>
									    <td width="20%"><%f_buscador.dibujaCampo("tsol_ccod")%></td>
									    <td width="30%" rowspan="2"><%botonera.DibujaBoton "buscar" %></td>
									</tr>
								</table>
							  </form>
							  <hr/>
							  </td>
							</tr>
						<tr> 
						<td><strong><font color="000000" size="1"> </font></strong>
							<form name="datos">
							
							
								<table width="98%"  border="0" align="center">
								  <tr>
									<td><div align="center"><strong>Proveedor:&nbsp;</strong> <%f_datos.DibujaCampo("proveedor")%>&nbsp;&nbsp;&nbsp;&nbsp; <strong>Monto:&nbsp;</strong><%f_datos.DibujaCampo("monto")%></div></td>
								  </tr>								
								  <tr>
									<td><div align="right">P&aacute;ginas : <%f_solicitudes.AccesoPagina%></div></td>
								  </tr>
								  <tr>
									<td><div align="center"><%f_solicitudes.DibujaTabla%></div></td>
								  </tr>
								  <tr>
									<td><div align="center">
									  <%f_solicitudes.Pagina%>
									</div></td>
								  </tr>
								</table>
							</form>
							<br>
							<table width="98%"  border="0" align="center">
							  <tr>
								<td><div align="right">
									<%
										'botonera.DibujaBoton "traspasar_solicitudes"
									%>
								</div></td>
							  </tr>
							</table>							
						</td>
                  </tr>
                </table>
	  <br/>
				  
				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="108" bgcolor="#D8D8DE">
				  <table width="23%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
					  <td><%botonera.dibujaboton "salir"%></td>
                    </tr>
                  </table>                </td>
                  <td width="252" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="317" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td height="8" valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
			<p><br>
			<p><br>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>

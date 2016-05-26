<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Documentos por Pagar"

v_solicitud	= request.querystring("busqueda[0][solicitud]")
pers_nrut	= request.querystring("busqueda[0][pers_nrut]")
pers_xdv	= request.querystring("busqueda[0][pers_xdv]")
tsol_ccod	= request.querystring("busqueda[0][tsol_ccod]")
pers_tnombre	= request.querystring("busqueda[0][pers_tnombre]")

marca	= request.querystring("busqueda[0][marca]")

v_filtro = request.querystring("busqueda[0][v_paso]")

'response.Write(v_filtro)

set botonera = new CFormulario
botonera.carga_parametros "documentos_x_pagar.xml", "botonera"

set negocio = new cnegocio
set conectar = new cconexion
set formulario = new cformulario

'8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

conectar.inicializar "upacifico"

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "documentos_x_pagar.xml", "datos_solicitud"
 f_busqueda.Inicializar conectar

 '8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
 
set conexion = new Cconexion2
conexion.Inicializar "upacifico"
 
	set f_cheques_entregados = new CFormulario
	f_cheques_entregados.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
	f_cheques_entregados.Inicializar conexion
	
	' ACA  PREGUNTA POR LOS CHEQUES Y  RESCATA EL N DE SOLICITUD

	sql_cheques_entregados= " Select "&_
								" DISTINCT a.codaux, d.NumDoc "&_
								" FROM softland.cwmovim a "&_
								" INNER JOIN softland.cwmovim d "&_
								" ON a.codaux = d.codaux "&_
								" and a.NumDoc = d.MovNumDocRef "&_
								" and a.ttdcod = d.MovTipDocRef "&_
								" AND a.cpbano >= 2013 "&_
								" and a.movfv is not null and a.movHaber > 0 "&_
								" AND a.ttdcod in ('BH','FP','FL','BE') "&_
								" AND a.MovTipDocRef in ('BH','FP','FL','BE') "&_
								" and d.cpbano >= 2013 "&_
								" and d.movfv is not null and d.MovDebe > 0 "&_
								" AND d.ttdcod in ('CP') AND d.MovTipDocRef in ('BH','FP','FL','BE') "&_
								" UNION"&_
								" Select "&_
								" DISTINCT a.codaux, a.NumDoc"&_
								" FROM softland.cwmovim a "&_
								" INNER JOIN softland.cwpctas c "&_
								" on a.pctcod= c.pccodi "&_
								" AND a.ttdcod in ('BC','RG','FR','SV','DV','FF','RFR','RFF') "&_
								" and a.cpbano >= 2013 "&_
								" and a.movfv is not null and a.movHaber > 0 "&_
								" UNION "&_
								" SELECT '0' AS codaux, '0' AS NumDoc "

'	sql_cheques_entregados= " AND NOT EXISTS (SELECT TABLA_02.codaux, TABLA_02.NumDoc FROM ( "&_								
'								" Select "&_
'								" DISTINCT a.codaux, d.NumDoc "&_
'								" FROM dbo.cwmovim a "&_
'								" INNER JOIN dbo.cwmovim d "&_
'								" ON a.codaux = d.codaux "&_
'								" and a.NumDoc = d.MovNumDocRef "&_
'								" and a.ttdcod = d.MovTipDocRef "&_
'								" AND a.cpbano >= 2013 "&_
'								" and a.movfv is not null and a.movHaber > 0 "&_
'								" AND a.ttdcod in ('BH','FP','FL','BE') "&_
'								" AND a.MovTipDocRef in ('BH','FP','FL','BE') "&_
'								" and d.cpbano >= 2013 "&_
'								" and d.movfv is not null and d.MovDebe > 0 "&_
'								" AND d.ttdcod in ('CP') AND d.MovTipDocRef in ('BH','FP','FL','BE') "&_
'								" UNION"&_
'								" Select "&_
'								" DISTINCT a.codaux, a.NumDoc"&_
'								" FROM dbo.cwmovim a "&_
'								" WHERE a.ttdcod in ('BC','RG','FR','SV','DV','FF','RFR','RFF') "&_
'								" and a.cpbano >= 2013 "&_
'								" and a.movfv is not null and a.movHaber > 0 "&_
'								" UNION "&_
'								" SELECT '0' AS codaux, '0' AS NumDoc ) AS TABLA_02 WHERE TABLA_02.NumDoc = CAST(num_solicitud AS VARCHAR) AND TABLA_02.CodAux = CAST(TABLA.PERS_NRUT AS VARCHAR) )"
								
	'RESPONSE.WRITE("sql_cheques_entregados: "&sql_cheques_entregados&"<BR>")
	
	f_cheques_entregados.Consultar sql_cheques_entregados
	'f_cheques_entregados.siguiente

	' ACA CONSTRUYE EL FILTRO PARA DEJAR FUERA LOS CHEQUES ENTREGADOS
'	if f_cheques_entregados.nrofilas>0 then
'		for fila = 0 to f_cheques_entregados.nrofilas - 1

'			inicio_filtro_02=" AND ocag_generador not in ( "

'			if fila=0 then
'				filtro_sga= "'"&f_cheques_entregados.ObtenerValor("codaux")&"'"
'			else
'				filtro_sga= filtro_sga&",'"&f_cheques_entregados.ObtenerValor("codaux")&"'"
'			end if
'			fin_filtro= ") "
'			sql_filtro_CHEQUE_1= inicio_filtro&" "&filtro_sga&" "&fin_filtro


'			inicio_filtro=" AND sogi_ncorr not in ( "

'			if fila=0 then
'				filtro_sga_2= "'"&f_cheques_entregados.ObtenerValor("NumDoc")&"'"
'			else
'				filtro_sga_2= filtro_sga_2&",'"&f_cheques_entregados.ObtenerValor("NumDoc")&"'"
'			end if
'			fin_filtro_02= ") "
'			sql_filtro_CHEQUE_2= inicio_filtro_02&" "&filtro_sga_2&" "&fin_filtro_02
	
'			f_cheques_entregados.siguiente
'		next
'	end if

	'RESPONSE.WRITE("1. sql_filtro_CHEQUE_1 : "&sql_filtro_CHEQUE_1&"<BR>")
	'RESPONSE.WRITE("2. sql_filtro_CHEQUE_2 : "&sql_filtro_CHEQUE_2&"<BR>")
	'RESPONSE.END()
 '8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
 
 
' 88888888888888888888888888888888888888888888888888888888888888
'RESPONSE.WRITE("marca: "&marca&"<BR>")
  
if marca <>1 then

'RESPONSE.WRITE("Entro: <BR>")

		set conexion_1 = new CConexion
		conexion_1.Inicializar "upacifico"

		set negocio_01 = new CNegocio
		negocio_01.Inicializa conexion_1

		sql_trunc="truncate table Ocag_Solicitudes"

		conexion_1.estadotransaccion	conexion_1.ejecutas(sql_trunc)

		f_cheques_entregados.primero

		while f_cheques_entregados.Siguiente 

				v_codaux=f_cheques_entregados.ObtenerValor("codaux")
				v_numdoc=f_cheques_entregados.ObtenerValor("numdoc")

							sql_INSERT="INSERT INTO [dbo].[Ocag_Solicitudes] "&_
									" ([CodAux], [NumDoc]) "&_
									" VALUES "&_
									" ("&v_codaux&", "&v_numdoc&") "

				'RESPONSE.WRITE("sql: "&sql&"<BR>")
									
				conexion_1.estadotransaccion	conexion_1.ejecutas(sql_INSERT)


		wend
		marca=1
		
end if

' 88888888888888888888888888888888888888888888888888888888888888

 
 ' 88888888888888888888888888888888888888888888888888888888888888
 
'FILTRO POR NUMERO DE SOLICITUD
if v_solicitud<>"" then

	sql_filtro=" and cod_solicitud="&v_solicitud
	
end if

'FILTRO POR RUT
if pers_nrut<>"" then
	sql_filtro=sql_filtro& " and c.pers_nrut="&pers_nrut
end if

'FILTRO POR TIPO DE SOLICITUD
if tsol_ccod<>"" then
	sql_filtro=sql_filtro& " and b.tsol_ccod="&tsol_ccod
end if

'FILTRO POR NOMBRE
if pers_tnombre<>"" then
	sql_filtro=sql_filtro& " and c.pers_tnombre LIKE '%"&pers_tnombre&"%'"
end if

' 88888888888888888888888888888888888888888888888888888888888888
 
' sql_solicitudes="select * from ( " & vbCrLf &_
'				"    select sogi_ncorr as cod_solicitud,sogi_ncorr as num_solicitud,Upper(b.vibo_tdesc) as etapa, asgi_tdesc as estado, isnull(a.vibo_ccod,0) as vibo_ccod, ocag_generador as usuario, " & vbCrLf &_
'				"	'1' as tipo,1 as tsol_ccod, sogi_mgiro as monto,mes_ccod, anos_ccod, protic.obtener_nombre_completo(pers_ncorr_proveedor, 'n') as pers_tnombre,pers_ncorr_proveedor as pers_ncorr,  " & vbCrLf &_
'				"   '<a href=""javascript:VerDatosDocumento('+cast(a.sogi_ncorr as varchar)+',1);"">ver</a>' as solicitud,protic.trunc(ocag_fingreso) as fecha_solicitud, protic.trunc(a.audi_fmodificacion) as fecha_cambio " & vbCrLf &_
'				"   ,(select protic.trunc(min(dpva_fpago)) as dpva_fpago from ocag_detalle_pago_validacion dpv, ocag_validacion_contable vc where dpv.vcon_ncorr=vc.vcon_ncorr and cod_solicitud=sogi_ncorr and tsol_ccod=1) as fecha_pago " & vbCrLf &_
'				"	from ocag_solicitud_giro a , ocag_visto_bueno b, ocag_autoriza_solicitud_giro c,ocag_estado_autorizacion d " & vbCrLf &_
'				"   where a.vibo_ccod=b.vibo_ccod    " & vbCrLf &_
'				"	and a.tsol_ccod=c.tsol_ccod " & vbCrLf &_
'				"	and a.sogi_ncorr=c.cod_solicitud " & vbCrLf &_
'				"	and a.vibo_ccod=c.vibo_ccod " & vbCrLf &_
'				"	and c.asgi_nestado=d.asgi_nestado " & vbCrLf &_	
'				"Union    " & vbCrLf &_
'				"	select rgas_ncorr as cod_solicitud,rgas_ncorr as num_solicitud,Upper(b.vibo_tdesc) as etapa, asgi_tdesc as estado, isnull(a.vibo_ccod,0) as vibo_ccod,ocag_generador as usuario,   " & vbCrLf &_
'				"	'2' as tipo,'2' as tsol_ccod, rgas_mgiro as monto,mes_ccod, anos_ccod, protic.obtener_nombre_completo(pers_ncorr_proveedor, 'n') as pers_tnombre,pers_ncorr_proveedor as pers_ncorr, " & vbCrLf &_
'				"   '<a href=""javascript:VerDatosDocumento('+cast(a.rgas_ncorr as varchar)+',2);"">ver</a>' as solicitud,protic.trunc(ocag_fingreso) as fecha_solicitud, protic.trunc(a.audi_fmodificacion) as fecha_cambio " & vbCrLf &_
'				"   ,(select protic.trunc(min(dpva_fpago)) as dpva_fpago from ocag_detalle_pago_validacion dpv, ocag_validacion_contable vc where dpv.vcon_ncorr=vc.vcon_ncorr and cod_solicitud=rgas_ncorr and tsol_ccod=2) as fecha_pago " & vbCrLf &_
'				"	from ocag_reembolso_gastos a , ocag_visto_bueno b, ocag_autoriza_solicitud_giro c,ocag_estado_autorizacion d " & vbCrLf &_
'				"   where a.vibo_ccod=b.vibo_ccod " & vbCrLf &_
'				"	and a.tsol_ccod=c.tsol_ccod " & vbCrLf &_
'				"	and a.rgas_ncorr=c.cod_solicitud " & vbCrLf &_
'				"	and a.vibo_ccod=c.vibo_ccod " & vbCrLf &_				
'				"	and c.asgi_nestado=d.asgi_nestado " & vbCrLf &_	
'				"Union   " & vbCrLf &_
'				"	select fren_ncorr as cod_solicitud,fren_ncorr as num_solicitud,Upper(b.vibo_tdesc) as etapa,asgi_tdesc as estado, isnull(a.vibo_ccod,0) as vibo_ccod,ocag_generador as usuario,  " & vbCrLf &_
'				"	'3' as tipo,'3' as tsol_ccod, fren_mmonto as monto,mes_ccod, anos_ccod, protic.obtener_nombre_completo(pers_ncorr, 'n') as pers_tnombre,pers_ncorr as pers_ncorr, " & vbCrLf &_
'				"   '<a href=""javascript:VerDatosDocumento('+cast(a.fren_ncorr as varchar)+',3);"">ver</a>' as solicitud,protic.trunc(ocag_fingreso) as fecha_solicitud, protic.trunc(a.audi_fmodificacion) as fecha_cambio " & vbCrLf &_
'				"   ,(select protic.trunc(min(dpva_fpago)) as dpva_fpago from ocag_detalle_pago_validacion dpv, ocag_validacion_contable vc where dpv.vcon_ncorr=vc.vcon_ncorr and cod_solicitud=fren_ncorr and tsol_ccod=3) as fecha_pago " & vbCrLf &_
'				"	from ocag_fondos_a_rendir a , ocag_visto_bueno b, ocag_autoriza_solicitud_giro c,ocag_estado_autorizacion d " & vbCrLf &_
'				"   where a.vibo_ccod=b.vibo_ccod    " & vbCrLf &_
'				"	and a.tsol_ccod=c.tsol_ccod " & vbCrLf &_
'				"	and a.fren_ncorr=c.cod_solicitud " & vbCrLf &_
'				"	and a.vibo_ccod=c.vibo_ccod " & vbCrLf &_
'				"	and c.asgi_nestado=d.asgi_nestado " & vbCrLf &_	
'				"Union   " & vbCrLf &_
'				"	select sovi_ncorr as cod_solicitud,sovi_ncorr as num_solicitud, Upper(b.vibo_tdesc) as etapa,asgi_tdesc as estado, isnull(a.vibo_ccod,0) as vibo_ccod,ocag_generador as usuario,  " & vbCrLf &_
'				"	'4' as tipo,'4' as tsol_ccod, sovi_mmonto_pesos as monto,mes_ccod, anos_ccod, protic.obtener_nombre_completo(pers_ncorr, 'n') as pers_tnombre,pers_ncorr as pers_ncorr, " & vbCrLf &_
'				"   '<a href=""javascript:VerDatosDocumento('+cast(a.sovi_ncorr as varchar)+',4);"">ver</a>' as solicitud,protic.trunc(ocag_fingreso) as fecha_solicitud, protic.trunc(a.audi_fmodificacion) as fecha_cambio " & vbCrLf &_
'				"   ,(select protic.trunc(min(dpva_fpago)) as dpva_fpago from ocag_detalle_pago_validacion dpv, ocag_validacion_contable vc where dpv.vcon_ncorr=vc.vcon_ncorr and cod_solicitud=sovi_ncorr and tsol_ccod=4) as fecha_pago " & vbCrLf &_
'				"	from ocag_solicitud_viatico a , ocag_visto_bueno b, ocag_autoriza_solicitud_giro c,ocag_estado_autorizacion d " & vbCrLf &_
'				"   where a.vibo_ccod=b.vibo_ccod   " & vbCrLf &_
'				"	and a.tsol_ccod=c.tsol_ccod " & vbCrLf &_
'				"	and a.sovi_ncorr=c.cod_solicitud " & vbCrLf &_
'				"	and a.vibo_ccod=c.vibo_ccod " & vbCrLf &_				
'				"	and c.asgi_nestado=d.asgi_nestado " & vbCrLf &_	
'				"Union   " & vbCrLf &_
'				"	select dalu_ncorr as cod_solicitud,dalu_ncorr as num_solicitud,Upper(b.vibo_tdesc) as etapa,asgi_tdesc as estado, isnull(a.vibo_ccod,0) as vibo_ccod, ocag_generador as usuario, " & vbCrLf &_
'				"	'5' as tipo,'5' as tsol_ccod, dalu_mmonto_pesos as monto,mes_ccod, anos_ccod, protic.obtener_nombre_completo(pers_ncorr, 'n') as pers_tnombre,pers_ncorr as pers_ncorr, " & vbCrLf &_
'				"   '<a href=""javascript:VerDatosDocumento('+cast(a.dalu_ncorr as varchar)+',5);"">ver</a>' as solicitud,protic.trunc(ocag_fingreso) as fecha_solicitud, protic.trunc(a.audi_fmodificacion) as fecha_cambio " & vbCrLf &_
'				"   ,(select protic.trunc(min(dpva_fpago)) as dpva_fpago from ocag_detalle_pago_validacion dpv, ocag_validacion_contable vc where dpv.vcon_ncorr=vc.vcon_ncorr and cod_solicitud=dalu_ncorr and tsol_ccod=5) as fecha_pago " & vbCrLf &_
'				"	from ocag_devolucion_alumno a , ocag_visto_bueno b, ocag_autoriza_solicitud_giro c,ocag_estado_autorizacion d " & vbCrLf &_
'				"   where a.vibo_ccod=b.vibo_ccod    " & vbCrLf &_
'				"	and a.tsol_ccod=c.tsol_ccod " & vbCrLf &_
'				"	and a.dalu_ncorr=c.cod_solicitud " & vbCrLf &_
'				"	and a.vibo_ccod=c.vibo_ccod " & vbCrLf &_				
'				"	and c.asgi_nestado=d.asgi_nestado " & vbCrLf &_	
'				"Union   " & vbCrLf &_
'				"	select ffij_ncorr as cod_solicitud,ffij_ncorr as num_solicitud,Upper(b.vibo_tdesc) as etapa,asgi_tdesc as estado, isnull(a.vibo_ccod,0) as vibo_ccod, ocag_generador as usuario,  " & vbCrLf &_
'				"	'6' as tipo,'6' as tsol_ccod, ffij_mmonto_pesos as monto,mes_ccod, anos_ccod, protic.obtener_nombre_completo(pers_ncorr, 'n') as pers_tnombre,pers_ncorr as pers_ncorr, " & vbCrLf &_
'				"   '<a href=""javascript:VerDatosDocumento('+cast(a.ffij_ncorr as varchar)+',6);"">ver</a>' as solicitud,protic.trunc(ocag_fingreso) as fecha_solicitud , protic.trunc(a.audi_fmodificacion) as fecha_cambio" & vbCrLf &_
'				"   ,(select protic.trunc(min(dpva_fpago)) as dpva_fpago from ocag_detalle_pago_validacion dpv, ocag_validacion_contable vc where dpv.vcon_ncorr=vc.vcon_ncorr and cod_solicitud=ffij_ncorr and tsol_ccod=6) as fecha_pago " & vbCrLf &_
'				"	from ocag_fondo_fijo a , ocag_visto_bueno b, ocag_autoriza_solicitud_giro c,ocag_estado_autorizacion d " & vbCrLf &_
'				"   where a.vibo_ccod=b.vibo_ccod   " & vbCrLf &_
'				"	and a.tsol_ccod=c.tsol_ccod " & vbCrLf &_
'				"	and a.ffij_ncorr=c.cod_solicitud " & vbCrLf &_
'				"	and a.vibo_ccod=c.vibo_ccod " & vbCrLf &_				
'				"	and c.asgi_nestado=d.asgi_nestado " & vbCrLf &_	
'				"Union   " & vbCrLf &_
'				"select rfre_ncorr as cod_solicitud,rfre_ncorr as num_solicitud,Upper(b.vibo_tdesc) as etapa,asgi_tdesc as estado, isnull(a.vibo_ccod,0) as vibo_ccod, ocag_generador as usuario, " & vbCrLf &_
'				"'7' as tipo,'7' as tsol_ccod, rfre_mmonto as monto,1 as mes_ccod, 1 as anos_ccod, protic.obtener_nombre_completo(protic.obtener_pers_ncorr2(ocag_generador), 'n') as pers_tnombre,protic.obtener_pers_ncorr2(ocag_generador) as pers_ncorr, " & vbCrLf &_
'			   "'<a href=""javascript:VerDatosDocumento('+cast(a.rfre_ncorr as varchar)+',7);"">ver</a>' as solicitud,protic.trunc(ocag_fingreso) as fecha_solicitud , protic.trunc(a.audi_fmodificacion) as fecha_cambio " & vbCrLf &_
'			  " ,(select protic.trunc(min(dpva_fpago)) as dpva_fpago from ocag_detalle_pago_validacion dpv, ocag_validacion_contable vc where dpv.vcon_ncorr=vc.vcon_ncorr and cod_solicitud=rfre_ncorr and tsol_ccod=6) as fecha_pago " & vbCrLf &_
'				"from ocag_rendicion_fondos_a_rendir a , ocag_visto_bueno b, ocag_autoriza_solicitud_giro c,ocag_estado_autorizacion d " & vbCrLf &_
'			  	"where a.vibo_ccod=b.vibo_ccod   " & vbCrLf &_
'			  	"and a.tsol_ccod=c.tsol_ccod " & vbCrLf &_
'			  	"and a.rfre_ncorr=c.cod_solicitud " & vbCrLf &_
'			  	"and a.vibo_ccod=c.vibo_ccod " & vbCrLf &_
'			    "and c.asgi_nestado=d.asgi_nestado " & vbCrLf &_				
'				"Union   " & vbCrLf &_
'				"select rffi_ncorr as cod_solicitud,rffi_ncorr as num_solicitud,Upper(b.vibo_tdesc) as etapa,asgi_tdesc as estado, isnull(a.vibo_ccod,0) as vibo_ccod, ocag_generador as usuario,  " & vbCrLf &_
'				"'8' as tipo,'8' as tsol_ccod, rffi_mmonto as monto, 1 as mes_ccod, 1 as anos_ccod, protic.obtener_nombre_completo(protic.obtener_pers_ncorr2(ocag_generador), 'n') as pers_tnombre,protic.obtener_pers_ncorr2(ocag_generador) as pers_ncorr, " & vbCrLf &_
'			   "'<a href=""javascript:VerDatosDocumento('+cast(a.rffi_ncorr as varchar)+',8);"">ver</a>' as solicitud,protic.trunc(ocag_fingreso) as fecha_solicitud , protic.trunc(a.audi_fmodificacion) as fecha_cambio " & vbCrLf &_
'			   ",(select protic.trunc(min(dpva_fpago)) as dpva_fpago from ocag_detalle_pago_validacion dpv, ocag_validacion_contable vc where dpv.vcon_ncorr=vc.vcon_ncorr and cod_solicitud=rffi_ncorr and tsol_ccod=6) as fecha_pago " & vbCrLf &_
'				"from ocag_rendicion_fondo_fijo a , ocag_visto_bueno b, ocag_autoriza_solicitud_giro c,ocag_estado_autorizacion d " & vbCrLf &_
'				"where a.vibo_ccod=b.vibo_ccod " & vbCrLf &_
'				"and a.tsol_ccod=c.tsol_ccod " & vbCrLf &_
'				"and a.rffi_ncorr=c.cod_solicitud " & vbCrLf &_
'				"and a.vibo_ccod=c.vibo_ccod " & vbCrLf &_
'				"and c.asgi_nestado=d.asgi_nestado " & vbCrLf &_
'				"Union   " & vbCrLf &_
'				"	select ordc_ncorr as cod_solicitud,ordc_ncorr as num_solicitud,Upper(b.vibo_tdesc) as etapa,asgi_tdesc as estado, isnull(a.vibo_ccod,0) as vibo_ccod, ocag_generador as usuario, " & vbCrLf &_  
'				"	'9' as tipo,9 as tsol_ccod, ordc_mmonto as monto,year(fecha_solicitud) as anos_ccod, month(fecha_solicitud) as mes_ccod, protic.obtener_nombre_completo(pers_ncorr, 'n') as pers_tnombre,pers_ncorr as pers_ncorr,  " & vbCrLf &_  
'				"	'<a href=  javascript:VerDatosDocumento('+cast(a.ordc_ncorr as varchar)+',9);  >ver</a>' as solicitud,protic.trunc(ocag_fingreso) as fecha_solicitud , protic.trunc(a.audi_fmodificacion) as fecha_cambio  " & vbCrLf &_
'				"   ,protic.ocag_retorna_fecha_normal(fecha_solicitud,9) as fecho_pago " & vbCrLf &_
'				"	from ocag_orden_compra a , ocag_visto_bueno b, ocag_autoriza_solicitud_giro c,ocag_estado_autorizacion d " & vbCrLf &_
'				"   where a.vibo_ccod=b.vibo_ccod " & vbCrLf &_
'				"	and a.tsol_ccod=c.tsol_ccod " & vbCrLf &_
'				"	and a.ordc_ncorr=c.cod_solicitud " & vbCrLf &_
'				"	and a.vibo_ccod=c.vibo_ccod " & vbCrLf &_
'				"	and c.asgi_nestado=d.asgi_nestado " & vbCrLf &_					
'				"	) as tabla, ocag_tipo_solicitud b, personas c " & vbCrLf &_
'				"	where cast(tabla.tsol_ccod as numeric)= b.tsol_ccod " & vbCrLf &_
'				"   and tabla.pers_ncorr=c.pers_ncorr "&sql_filtro&" "&sql_cheques_entregados

if v_filtro = "1" then
				
 sql_solicitudes="select cod_solicitud ,num_solicitud, etapa, estado, vibo_ccod, usuario, tipo, ('F' + cast(TABLA.tsol_ccod as varchar)) as tsol_ccod, monto, mes_ccod, anos_ccod	"& vbCrLf &_
			" ,TABLA.pers_tnombre, TABLA.pers_ncorr, solicitud, fecha_solicitud, fecha_cambio, fecha_pago, TABLA.PERS_NRUT  from ( 	"& vbCrLf &_
 			" select sogi_ncorr as cod_solicitud,sogi_ncorr as num_solicitud,Upper(b.vibo_tdesc) as etapa, asgi_tdesc as estado, isnull(a.vibo_ccod,0) as vibo_ccod, ocag_generador as usuario, 	"& vbCrLf &_
			" '1' as tipo,1 as tsol_ccod, sogi_mgiro as monto,mes_ccod, anos_ccod, protic.obtener_nombre_completo(A.pers_ncorr_proveedor, 'n') as pers_tnombre,A.pers_ncorr_proveedor as pers_ncorr,  	"& vbCrLf &_
			" '<a href=""javascript:VerDatosDocumento('+cast(a.sogi_ncorr as varchar)+',1);"">ver</a>' as solicitud,protic.trunc(ocag_fingreso) as fecha_solicitud, protic.trunc(a.audi_fmodificacion) as fecha_cambio 	"& vbCrLf &_
			" ,(select protic.trunc(min(dpva_fpago)) as dpva_fpago from ocag_detalle_pago_validacion dpv, ocag_validacion_contable vc where dpv.vcon_ncorr=vc.vcon_ncorr and cod_solicitud=sogi_ncorr and tsol_ccod=1) as fecha_pago, PERS_NRUT 	"& vbCrLf &_
			" from ocag_solicitud_giro a 	"& vbCrLf &_
			" INNER JOIN ocag_visto_bueno b 	"& vbCrLf &_
			" ON a.vibo_ccod=b.vibo_ccod    	"& vbCrLf &_
			" INNER JOIN ocag_autoriza_solicitud_giro c 	"& vbCrLf &_
			" ON a.tsol_ccod=c.tsol_ccod and a.sogi_ncorr=c.cod_solicitud and a.vibo_ccod=c.vibo_ccod 	"& vbCrLf &_
			" INNER JOIN ocag_estado_autorizacion d 	"& vbCrLf &_
			" ON c.asgi_nestado=d.asgi_nestado 		"& vbCrLf &_
			" INNER JOIN PERSONAS X 	"& vbCrLf &_
			" ON A.pers_ncorr_proveedor=X.PERS_NCORR 		"& vbCrLf &_
			" Union    	"& vbCrLf &_
			" select rgas_ncorr as cod_solicitud,rgas_ncorr as num_solicitud,Upper(b.vibo_tdesc) as etapa, asgi_tdesc as estado, isnull(a.vibo_ccod,0) as vibo_ccod,ocag_generador as usuario,   	"& vbCrLf &_
			" '2' as tipo,'2' as tsol_ccod, rgas_mgiro as monto,mes_ccod, anos_ccod, protic.obtener_nombre_completo(A.pers_ncorr_proveedor, 'n') as pers_tnombre,A.pers_ncorr_proveedor as pers_ncorr, 	"& vbCrLf &_
			" '<a href=""javascript:VerDatosDocumento('+cast(a.rgas_ncorr as varchar)+',2);"">ver</a>' as solicitud,protic.trunc(ocag_fingreso) as fecha_solicitud, protic.trunc(a.audi_fmodificacion) as fecha_cambio 	"& vbCrLf &_
			" ,(select protic.trunc(min(dpva_fpago)) as dpva_fpago from ocag_detalle_pago_validacion dpv, ocag_validacion_contable vc where dpv.vcon_ncorr=vc.vcon_ncorr and cod_solicitud=rgas_ncorr and tsol_ccod=2) as fecha_pago , PERS_NRUT	"& vbCrLf &_
			" from ocag_reembolso_gastos a 	"& vbCrLf &_
			" INNER JOIN ocag_visto_bueno b 	"& vbCrLf &_
			" ON a.vibo_ccod=b.vibo_ccod 	"& vbCrLf &_
			" INNER JOIN ocag_autoriza_solicitud_giro c 	"& vbCrLf &_
			" ON a.tsol_ccod=c.tsol_ccod and a.rgas_ncorr=c.cod_solicitud and a.vibo_ccod=c.vibo_ccod 					"& vbCrLf &_
			" INNER JOIN ocag_estado_autorizacion d 	"& vbCrLf &_
			" ON c.asgi_nestado=d.asgi_nestado 		"& vbCrLf &_
			" INNER JOIN PERSONAS X  	"& vbCrLf &_
			" ON A.pers_ncorr_proveedor=X.PERS_NCORR 		"& vbCrLf &_
			" Union   	"& vbCrLf &_
			" select fren_ncorr as cod_solicitud,fren_ncorr as num_solicitud,Upper(b.vibo_tdesc) as etapa,asgi_tdesc as estado, isnull(a.vibo_ccod,0) as vibo_ccod,ocag_generador as usuario,  	"& vbCrLf &_
			" '3' as tipo,'3' as tsol_ccod, fren_mmonto as monto,mes_ccod, anos_ccod, protic.obtener_nombre_completo(A.pers_ncorr, 'n') as pers_tnombre, A.pers_ncorr as pers_ncorr, 	"& vbCrLf &_
			" '<a href=""javascript:VerDatosDocumento('+cast(a.fren_ncorr as varchar)+',3);"">ver</a>' as solicitud,protic.trunc(ocag_fingreso) as fecha_solicitud, protic.trunc(a.audi_fmodificacion) as fecha_cambio 	"& vbCrLf &_
			" ,(select protic.trunc(min(dpva_fpago)) as dpva_fpago from ocag_detalle_pago_validacion dpv, ocag_validacion_contable vc where dpv.vcon_ncorr=vc.vcon_ncorr and cod_solicitud=fren_ncorr and tsol_ccod=3) as fecha_pago , PERS_NRUT 	"& vbCrLf &_
			" from ocag_fondos_a_rendir a 	"& vbCrLf &_
			" INNER JOIN ocag_visto_bueno b	"& vbCrLf &_
			" ON a.vibo_ccod=b.vibo_ccod    	"& vbCrLf &_
			" INNER JOIN ocag_autoriza_solicitud_giro c 	"& vbCrLf &_
			" ON a.tsol_ccod=c.tsol_ccod and a.fren_ncorr=c.cod_solicitud and a.vibo_ccod=c.vibo_ccod 	"& vbCrLf &_
			" INNER JOIN ocag_estado_autorizacion d 	"& vbCrLf &_
			" ON c.asgi_nestado=d.asgi_nestado 		"& vbCrLf &_
			" INNER JOIN PERSONAS X  	"& vbCrLf &_
			" ON A.PERS_NCORR=X.PERS_NCORR 		"& vbCrLf &_
			" Union   	"& vbCrLf &_
			" select sovi_ncorr as cod_solicitud,sovi_ncorr as num_solicitud, Upper(b.vibo_tdesc) as etapa,asgi_tdesc as estado, isnull(a.vibo_ccod,0) as vibo_ccod,ocag_generador as usuario,  	"& vbCrLf &_
			" '4' as tipo,'4' as tsol_ccod, sovi_mmonto_pesos as monto,mes_ccod, anos_ccod, protic.obtener_nombre_completo(A.pers_ncorr, 'n') as pers_tnombre, A.pers_ncorr as pers_ncorr, 	"& vbCrLf &_
			" '<a href=""javascript:VerDatosDocumento('+cast(a.sovi_ncorr as varchar)+',4);"">ver</a>' as solicitud,protic.trunc(ocag_fingreso) as fecha_solicitud, protic.trunc(a.audi_fmodificacion) as fecha_cambio 	"& vbCrLf &_
			" ,(select protic.trunc(min(dpva_fpago)) as dpva_fpago from ocag_detalle_pago_validacion dpv, ocag_validacion_contable vc where dpv.vcon_ncorr=vc.vcon_ncorr and cod_solicitud=sovi_ncorr and tsol_ccod=4) as fecha_pago , PERS_NRUT 	"& vbCrLf &_
			" from ocag_solicitud_viatico a 	"& vbCrLf &_
			" INNER JOIN ocag_visto_bueno b 	"& vbCrLf &_
			" ON a.vibo_ccod=b.vibo_ccod   	"& vbCrLf &_
			" INNER JOIN ocag_autoriza_solicitud_giro c 	"& vbCrLf &_
			" ON  a.tsol_ccod=c.tsol_ccod and a.sovi_ncorr=c.cod_solicitud and a.vibo_ccod=c.vibo_ccod 					"& vbCrLf &_
			" INNER JOIN ocag_estado_autorizacion d 	"& vbCrLf &_
			" ON c.asgi_nestado=d.asgi_nestado 		"& vbCrLf &_
			" INNER JOIN PERSONAS X  	"& vbCrLf &_
			" ON A.PERS_NCORR=X.PERS_NCORR 		"& vbCrLf &_
			" Union   	"& vbCrLf &_
			" select dalu_ncorr as cod_solicitud,dalu_ncorr as num_solicitud,Upper(b.vibo_tdesc) as etapa,asgi_tdesc as estado, isnull(a.vibo_ccod,0) as vibo_ccod, ocag_generador as usuario, 	"& vbCrLf &_
			" '5' as tipo,'5' as tsol_ccod, dalu_mmonto_pesos as monto,mes_ccod, anos_ccod, protic.obtener_nombre_completo(A.pers_ncorr, 'n') as pers_tnombre, A.pers_ncorr as pers_ncorr, 	"& vbCrLf &_
			" '<a href=""javascript:VerDatosDocumento('+cast(a.dalu_ncorr as varchar)+',5);"">ver</a>' as solicitud,protic.trunc(ocag_fingreso) as fecha_solicitud, protic.trunc(a.audi_fmodificacion) as fecha_cambio 	"& vbCrLf &_
			" ,(select protic.trunc(min(dpva_fpago)) as dpva_fpago from ocag_detalle_pago_validacion dpv, ocag_validacion_contable vc where dpv.vcon_ncorr=vc.vcon_ncorr and cod_solicitud=dalu_ncorr and tsol_ccod=5) as fecha_pago , PERS_NRUT 	"& vbCrLf &_
			" from ocag_devolucion_alumno a 	"& vbCrLf &_
			" INNER JOIN ocag_visto_bueno b 	"& vbCrLf &_
			" ON a.vibo_ccod=b.vibo_ccod    	"& vbCrLf &_
			" INNER JOIN ocag_autoriza_solicitud_giro c 	"& vbCrLf &_
			" ON a.tsol_ccod=c.tsol_ccod 	"& vbCrLf &_
			" and a.dalu_ncorr=c.cod_solicitud 	"& vbCrLf &_
			" and a.vibo_ccod=c.vibo_ccod 					"& vbCrLf &_
			" INNER JOIN ocag_estado_autorizacion d 	"& vbCrLf &_
			" ON c.asgi_nestado=d.asgi_nestado 		"& vbCrLf &_
			" INNER JOIN PERSONAS X  	"& vbCrLf &_
			" ON A.PERS_NCORR=X.PERS_NCORR 		"& vbCrLf &_
			" Union   	"& vbCrLf &_
			" select ffij_ncorr as cod_solicitud,ffij_ncorr as num_solicitud,Upper(b.vibo_tdesc) as etapa,asgi_tdesc as estado, isnull(a.vibo_ccod,0) as vibo_ccod, ocag_generador as usuario,  	"& vbCrLf &_
			" '6' as tipo,'6' as tsol_ccod, ffij_mmonto_pesos as monto,mes_ccod, anos_ccod, protic.obtener_nombre_completo(A.pers_ncorr, 'n') as pers_tnombre, A.pers_ncorr as pers_ncorr, 	"& vbCrLf &_
			" '<a href=""javascript:VerDatosDocumento('+cast(a.ffij_ncorr as varchar)+',6);"">ver</a>' as solicitud,protic.trunc(ocag_fingreso) as fecha_solicitud , protic.trunc(a.audi_fmodificacion) as fecha_cambio	"& vbCrLf &_
			" ,(select protic.trunc(min(dpva_fpago)) as dpva_fpago from ocag_detalle_pago_validacion dpv, ocag_validacion_contable vc where dpv.vcon_ncorr=vc.vcon_ncorr and cod_solicitud=ffij_ncorr and tsol_ccod=6) as fecha_pago , PERS_NRUT 	"& vbCrLf &_
			" from ocag_fondo_fijo a 	"& vbCrLf &_
			" INNER JOIN ocag_visto_bueno b 	"& vbCrLf &_
			" ON a.vibo_ccod=b.vibo_ccod   	"& vbCrLf &_
			" INNER JOIN ocag_autoriza_solicitud_giro c 	"& vbCrLf &_
			" ON a.tsol_ccod=c.tsol_ccod 	"& vbCrLf &_
			" and a.ffij_ncorr=c.cod_solicitud 	"& vbCrLf &_
			" and a.vibo_ccod=c.vibo_ccod 					"& vbCrLf &_
			" INNER JOIN ocag_estado_autorizacion d 	"& vbCrLf &_
			" ON c.asgi_nestado=d.asgi_nestado 		"& vbCrLf &_
			" INNER JOIN PERSONAS X  	"& vbCrLf &_
			" ON A.PERS_NCORR=X.PERS_NCORR 		"& vbCrLf &_
			" Union   	"& vbCrLf &_
			" select rfre_ncorr as cod_solicitud,rfre_ncorr as num_solicitud,Upper(b.vibo_tdesc) as etapa,asgi_tdesc as estado, isnull(a.vibo_ccod,0) as vibo_ccod, a.ocag_generador as usuario, 	"& vbCrLf &_
			" '7' as tipo,'7' as tsol_ccod, rfre_mmonto as monto,1 as mes_ccod, 1 as anos_ccod, protic.obtener_nombre_completo(protic.obtener_pers_ncorr2(a.ocag_generador), 'n') as pers_tnombre,protic.obtener_pers_ncorr2(a.ocag_generador) as pers_ncorr, 	"& vbCrLf &_
			" '<a href=""javascript:VerDatosDocumento('+cast(a.rfre_ncorr as varchar)+',7);"">ver</a>' as solicitud,protic.trunc(a.ocag_fingreso) as fecha_solicitud , protic.trunc(a.audi_fmodificacion) as fecha_cambio 	"& vbCrLf &_
			" ,(select protic.trunc(min(dpva_fpago)) as dpva_fpago from ocag_detalle_pago_validacion dpv, ocag_validacion_contable vc where dpv.vcon_ncorr=vc.vcon_ncorr and cod_solicitud=rfre_ncorr and tsol_ccod=6) as fecha_pago , Z.PERS_NRUT	"& vbCrLf &_
			" from ocag_rendicion_fondos_a_rendir a 	"& vbCrLf &_
			" INNER JOIN ocag_visto_bueno b 	"& vbCrLf &_
			" ON a.vibo_ccod=b.vibo_ccod   	"& vbCrLf &_
			" INNER JOIN ocag_autoriza_solicitud_giro c 	"& vbCrLf &_
			" ON a.tsol_ccod=c.tsol_ccod and a.rfre_ncorr=c.cod_solicitud and a.vibo_ccod=c.vibo_ccod 	"& vbCrLf &_
			" INNER JOIN ocag_estado_autorizacion d 	"& vbCrLf &_
			" ON c.asgi_nestado=d.asgi_nestado 					"& vbCrLf &_
			" INNER JOIN ocag_fondos_a_rendir X	"& vbCrLf &_
			" ON a.fren_ncorr = X.fren_ncorr 		"& vbCrLf &_
			" INNER JOIN PERSONAS Z  	"& vbCrLf &_
			" ON X.PERS_NCORR=Z.PERS_NCORR		"& vbCrLf &_
			" Union   	"& vbCrLf &_
			" select rffi_ncorr as cod_solicitud,rffi_ncorr as num_solicitud,Upper(b.vibo_tdesc) as etapa,asgi_tdesc as estado, isnull(a.vibo_ccod,0) as vibo_ccod, a.ocag_generador as usuario,  	"& vbCrLf &_
			" '8' as tipo,'8' as tsol_ccod, rffi_mmonto as monto, 1 as mes_ccod, 1 as anos_ccod, protic.obtener_nombre_completo(protic.obtener_pers_ncorr2(a.ocag_generador), 'n') as pers_tnombre,protic.obtener_pers_ncorr2(a.ocag_generador) as pers_ncorr, 	"& vbCrLf &_
			" '<a href=""javascript:VerDatosDocumento('+cast(a.rffi_ncorr as varchar)+',8);"">ver</a>' as solicitud,protic.trunc(a.ocag_fingreso) as fecha_solicitud , protic.trunc(a.audi_fmodificacion) as fecha_cambio 	"& vbCrLf &_
			" ,(select protic.trunc(min(dpva_fpago)) as dpva_fpago from ocag_detalle_pago_validacion dpv, ocag_validacion_contable vc where dpv.vcon_ncorr=vc.vcon_ncorr and cod_solicitud=rffi_ncorr and tsol_ccod=6) as fecha_pago , Z.PERS_NRUT	"& vbCrLf &_
			" from ocag_rendicion_fondo_fijo a 	"& vbCrLf &_
			" INNER JOIN ocag_visto_bueno b	"& vbCrLf &_
			" ON a.vibo_ccod=b.vibo_ccod 	"& vbCrLf &_
			" INNER JOIN ocag_autoriza_solicitud_giro c 	"& vbCrLf &_
			" ON a.tsol_ccod=c.tsol_ccod and a.rffi_ncorr=c.cod_solicitud and a.vibo_ccod=c.vibo_ccod 	"& vbCrLf &_
			" INNER JOIN ocag_estado_autorizacion d 	"& vbCrLf &_
			" ON c.asgi_nestado=d.asgi_nestado 	"& vbCrLf &_
			" INNER JOIN ocag_fondo_fijo X	"& vbCrLf &_
			" ON A.ffij_ncorr = X.ffij_ncorr 		"& vbCrLf &_
			" INNER JOIN  PERSONAS Z  	"& vbCrLf &_
			" ON X.PERS_NCORR=Z.PERS_NCORR		"& vbCrLf &_
			" Union   	"& vbCrLf &_
			" select ordc_ncorr as cod_solicitud,ordc_ncorr as num_solicitud,Upper(b.vibo_tdesc) as etapa,asgi_tdesc as estado, isnull(a.vibo_ccod,0) as vibo_ccod, ocag_generador as usuario,   	"& vbCrLf &_
			" '9' as tipo,9 as tsol_ccod, ordc_mmonto as monto,year(fecha_solicitud) as anos_ccod, month(fecha_solicitud) as mes_ccod, protic.obtener_nombre_completo(A.pers_ncorr, 'n') as pers_tnombre, A.pers_ncorr as pers_ncorr,    	"& vbCrLf &_
			" '<a href=  javascript:VerDatosDocumento('+cast(a.ordc_ncorr as varchar)+',9);  >ver</a>' as solicitud,protic.trunc(ocag_fingreso) as fecha_solicitud , protic.trunc(a.audi_fmodificacion) as fecha_cambio  	"& vbCrLf &_
			" ,protic.ocag_retorna_fecha_normal(fecha_solicitud,9) as fecha_pago , PERS_NRUT 	"& vbCrLf &_
			" from ocag_orden_compra a 	"& vbCrLf &_
			" INNER JOIN ocag_visto_bueno b 	"& vbCrLf &_
			" ON a.vibo_ccod=b.vibo_ccod 	"& vbCrLf &_
			" INNER JOIN ocag_autoriza_solicitud_giro c 	"& vbCrLf &_
			" ON a.tsol_ccod=c.tsol_ccod 	"& vbCrLf &_
			" and a.ordc_ncorr=c.cod_solicitud 	"& vbCrLf &_
			" and a.vibo_ccod=c.vibo_ccod 	"& vbCrLf &_
			" INNER JOIN ocag_estado_autorizacion d 	"& vbCrLf &_
			" ON c.asgi_nestado=d.asgi_nestado 						"& vbCrLf &_
			" INNER JOIN PERSONAS X 	"& vbCrLf &_
			" ON A.PERS_NCORR=X.PERS_NCORR		"& vbCrLf &_
			" ) as tabla	"& vbCrLf &_
			" INNER JOIN ocag_tipo_solicitud b 	"& vbCrLf &_
			" ON cast(tabla.tsol_ccod as numeric)= b.tsol_ccod 	"& vbCrLf &_
			" INNER JOIN personas c 	"& vbCrLf &_
			" ON tabla.pers_ncorr=c.pers_ncorr "&sql_filtro&" "& vbCrLf &_
			" AND NOT EXISTS (SELECT TABLA_02.codaux, TABLA_02.NumDoc "& vbCrLf &_
			" FROM Ocag_Solicitudes AS TABLA_02 "& vbCrLf &_
			" WHERE TABLA_02.NumDoc = TABLA.num_solicitud "& vbCrLf &_
			" AND TABLA_02.CodAux =TABLA.PERS_NRUT) "	

else

	sql_solicitudes = "Select '' where 1=2 "
	
end if			
 'response.Write("<pre>"&sql_solicitudes&"</pre>")
 'response.End()
 
'RESPONSE.WRITE("1. sql_solicitudes : "&sql_solicitudes&"<BR>")
'RESPONSE.WRITE("2. sql_filtro : "&sql_filtro&"<BR>")

 f_busqueda.Consultar sql_solicitudes
 'f_busqueda.Siguiente


set f_buscador = new CFormulario
f_buscador.Carga_Parametros "documentos_x_pagar.xml", "buscador"
f_buscador.Inicializar conectar
f_buscador.Consultar " select '' "
f_buscador.Siguiente

f_buscador.agregaCampoCons "solicitud", v_solicitud
f_buscador.agregaCampoCons "pers_nrut", pers_nrut
f_buscador.agregaCampoCons "pers_xdv", pers_xdv
f_buscador.agregaCampoCons "tsol_ccod", tsol_ccod
f_buscador.agregaCampoCons "pers_tnombre", pers_tnombre
f_buscador.agregaCampoCons "v_paso", "1"

f_buscador.agregaCampoCons "marca", marca

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

function VerDatosDocumento(codigo,tsol_ccod){
	window.open("ver_datos_documento.asp?solicitud="+codigo+"&tsol_ccod="+tsol_ccod,"solicitud",'scrollbars=yes, menubar=no, resizable=yes, width=800,height=500');
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Solicitudes Pendientes </font></div></td>
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
                    <td><strong><font color="000000" size="1"> </font></strong>
					
                      <table width="100%" border="0">
                        <tr> 
                          <td>
						<form name="buscador"> 
							<table width="90%" border='1' bordercolor='#999999'>
							<tr  bgcolor='#ADADAD'>
								<th colspan="5">Criterios de busqueda por Rut</th>
								<input type="hidden" name="busqueda[0][marca]" value=<%=marca%>>
							</tr>
								<tr>
								  <td>Rut:</td>
								  <td><%f_buscador.dibujaCampo("pers_nrut")%>
								    -
							        <%f_buscador.dibujaCampo("pers_xdv")%></td>
								  <td width="18%">N° Docto: </td>
								  <td><%f_buscador.dibujaCampo("solicitud") %></td>
								  <td><%botonera.DibujaBoton "buscar" %></td>
								  </tr>
								<tr> 
									<td width="9%">Nombre:</td>
									<td width="26%"><%f_buscador.dibujaCampo("pers_tnombre") %></td>
								    <td>Tipo de Solicitud:</td>
									<td width="21%"><%f_buscador.dibujaCampo("tsol_ccod") %> </td>
								    <td width="26%"><%f_buscador.dibujaCampo("v_paso")%></td>
								</tr>
							</table>
					  </form>
						  
						  <hr/>
						  </td>
                        </tr>
						<tr>
							<td>
							<table border ="0" align="center" width="100%">
								<tr valign="top">
								<td>
								<form name="datos" method="post">
								<center><%f_busqueda.DibujaTabla()%></center>
							
								</form>
									</td>
								</tr>
								<tr>
									<td><font color="#0000FF" size="-2" style="font-family:"Courier New", Courier, monospace">F1=Pago a proveedores&nbsp;&nbsp; F2=Reembolso de gastos&nbsp;&nbsp;F3=Fondo a rendir&nbsp;&nbsp;F4=Solicitud de viatico&nbsp;&nbsp;F5=Devolucion alumno&nbsp;&nbsp;F6=Nuevo fondo fijo&nbsp;&nbsp;F7=Rendicion Fondo a Rendir&nbsp;&nbsp;F8=Rendicion Fondo Fijo&nbsp;&nbsp;F9=Orden de Compra</font></td>
								</tr>								
							  </table>
								
							</td>
						</tr>
                      </table>
                      </td>
                  </tr>
                </table>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="241" bgcolor="#D8D8DE">
				  <table width="49%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="30%">&nbsp;</td>
                      <td width="30%"><%botonera.dibujaboton "salir"%></td>
                    </tr>
                  </table>                </td>
                  <td width="121" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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

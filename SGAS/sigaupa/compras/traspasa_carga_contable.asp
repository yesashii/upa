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
'Function TablaAArchivo(p_mcaj_ncorr, p_conexion)
'Function TablaAArchivo(cod_solicitud, p_conexion)
'	Dim f_consulta
'	Dim fso, archivo_salida, o_texto_archivo
'	Dim delimitador
'	Dim linea
	
'	On Error Resume Next	

'v_ruta_salida_nueva=""
	
'sql_nombre= " Select SUBSTRING(per.pers_tnombre, 1, 1)+''+per.pers_tape_paterno+'_'+per.pers_tape_materno+'_'+cast(day(mc.mcaj_finicio) as varchar)+'-'+cast(month(mc.mcaj_finicio)as varchar)+'-'+cast(year(mc.mcaj_finicio)as varchar) as nombre "& vbCrLf &_
'			" From cajeros caj , personas per ,movimientos_cajas mc "& vbCrLf &_
'			" where caj.pers_ncorr=per.pers_ncorr "& vbCrLf &_
'			" and mc.caje_ccod=caj.caje_ccod "& vbCrLf &_
'			" and mc.mcaj_ncorr='"&p_mcaj_ncorr&"'"

sql_nombre= "Select PERS_TAPE_PATERNO + '_' + SUBSTRING(PERS_TNOMBRE,1,1) as NOMBRE from personas "& vbCrLf &_
			"where cast(pers_nrut as varchar)='"&v_usuario&"'"

'v_dia_caja 	=	p_conexion.consultaUno("select day(mcaj_finicio) from movimientos_cajas where mcaj_ncorr='"&p_mcaj_ncorr&"'")
'v_mes_caja =p_conexion.ConsultaUno("select month(mcaj_finicio) from movimientos_cajas where mcaj_ncorr='"&p_mcaj_ncorr&"'")
'v_mes_caja 	=	p_conexion.ConsultaUno("select mes_tdesc from movimientos_cajas a, meses b where month(mcaj_finicio)=mes_ccod and a.mcaj_ncorr='"&p_mcaj_ncorr&"'")
'v_ano_caja 	=	p_conexion.ConsultaUno("select year(mcaj_finicio) from movimientos_cajas where mcaj_ncorr='"&p_mcaj_ncorr&"'")
'v_editorial	= 	"editorial"
'v_ichisame	= 	"ichisame"

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

' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

ind2=0
for each k in request.form

v_solicitud=request.Form("datos["&ind2&"][cod_solicitud]")
tsol_ccod=request.Form("datos["&ind2&"][tsol_ccod]")

'RESPONSE.WRITE(ind2&". cod_solicitud : "&v_solicitud&"<BR>")
'RESPONSE.WRITE(ind2&". tsol_ccod : "&tsol_ccod&"<BR>")

if v_solicitud <> "" then

' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

select case tsol_ccod
	Case 1: ' Pago Proveedores
		txt_tipo="Pago_Proveedores"
		
		sql_doctos = "select * from ( "&_
					" select tgas_cod_cuenta as cuenta,tgas_tdesc as descripcion,b.pers_nrut as auxiliar, "&_
					" case when dorc_bafecta=1 then cast((dorc_nprecio_neto)*1.19 as numeric)  else dorc_nprecio_neto end as debe,0 as haber "&_
					" , protic.trunc(ocag_fingreso) as fecha_solicitud "&_
					" , e.ccos_tcodigo, 'PP' AS TDOCUMENTO "&_
					" FROM ocag_solicitud_giro a "&_
					" INNER JOIN personas b "&_
					" ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.sogi_ncorr ="&v_solicitud&" "&_
					" INNER JOIN ocag_detalle_solicitud_ag c "&_
					" ON a.sogi_ncorr = c.sogi_ncorr "&_
					" INNER JOIN ocag_tipo_gasto d "&_
					" ON c.tgas_ccod = d.tgas_ccod "&_
					" INNER JOIN ocag_centro_costo e "&_
					" ON c.ccos_ncorr = e.ccos_ncorr "&_
					" union  "&_
					" select '2-10-070-10-000002' as cuenta ,'Cuentas por Pagar (Sist.Computac.)' as descripcion, "&_
					" b.pers_nrut as auxiliar,0 as debe, sogi_mgiro as haber, protic.trunc(ocag_fingreso) as fecha_solicitud "&_
					" , '' AS ccos_tcodigo, 'PP' AS TDOCUMENTO "&_
					" from ocag_solicitud_giro a "&_
					" INNER JOIN personas b "&_
					" ON a.pers_ncorr_proveedor = b.pers_ncorr and sogi_ncorr="&v_solicitud&" "&_
					" ) as tabla "&_
					" order by  debe desc "	
		
		sql_efes=" select * from ( "&_
					" select '2-10-070-10-000004' as cuenta,'Cuentas por Pagar con Control Presup.origen(Sist.Computac.)' as descripcion, "&_
					" psol_mpresupuesto as debe,0 as haber,cod_pre,protic.trunc('01/'+cast(mes_ccod as varchar)+'/'+cast(anos_ccod as varchar)) as fecha, "&_
					" case when mes_ccod<10 then '0'+cast(mes_ccod as varchar) else cast(mes_ccod as varchar) end  +cast(anos_ccod as varchar) as flujo "&_
					" , 'PP' AS TDOCUMENTO "&_
					"  from ocag_presupuesto_solicitud  "&_
					" where cod_solicitud="&v_solicitud&" and tsol_ccod=1 "&_
					" union "&_
					" select '2-10-070-10-000004' as cuenta,'Cuentas por Pagar con Control Presup.origen(Sist.Computac.)' as descripcion, "&_
					" 0 as debe,psol_mpresupuesto as haber,cod_pre,protic.trunc('01/'+cast(mes_ccod as varchar)+'/'+cast(anos_ccod as varchar)) as fecha, "&_
					" case when mes_ccod<10 then '0'+cast(mes_ccod as varchar) else cast(mes_ccod as varchar) end  +cast(anos_ccod as varchar) as flujo "&_
					" , 'PP' AS TDOCUMENTO "&_
					" from ocag_presupuesto_solicitud  "&_
					" where cod_solicitud="&v_solicitud&" and tsol_ccod=1 "&_
					") as tabla "&_
					" order by cod_pre, debe desc "
					
		sql_auxiliar= "select top 1 pers_nrut from ocag_solicitud_giro a, personas b "&_
					  "	where a.pers_ncorr_proveedor=b.pers_ncorr "&_
					  "	and sogi_ncorr="&v_solicitud

		sql_centro_costo= 	" select top 1 c.ccos_tcodigo from ocag_validacion_contable a, ocag_centro_costo_validacion b, ocag_centro_costo c "&_
							"	where a.vcon_ncorr=b.vcon_ncorr "&_
							"	and b.ccos_ncorr=c.ccos_ncorr "&_
							"	and cod_solicitud="&v_solicitud&" "&_
							"	and isnull(tsol_ccod,1)=1 "					  

		sql_documentos= 	" select c.tdoc_tdesc_softland as tipo,dsgi_ndocto as docto,protic.trunc(a.sogi_fecha_solicitud) as fecha "&_
							" from ocag_solicitud_giro a, ocag_detalle_solicitud_giro b, ocag_tipo_documento c "&_
							"	where a.sogi_ncorr=b.sogi_ncorr "&_
							"	and b.tdoc_ccod=c.tdoc_ccod "&_
							"	and a.sogi_ncorr="&v_solicitud&" "&_
							"	and isnull(a.tsol_ccod,1)=1 "		
		
	Case 2: ' Reembolso de gatos
		txt_tipo="Reembolso_Gatos"
		
		sql_doctos = "select * from ( "&_
							" select d.tgas_cod_cuenta as cuenta, d.tgas_tdesc as descripcion, b.pers_nrut as auxiliar, c.drga_mdocto as debe, 0 as haber "&_
							" , protic.trunc(a.ocag_fingreso) as fecha_solicitud , 'RG' AS TDOCUMENTO , e.ccos_tcodigo "&_
							" FROM ocag_reembolso_gastos a "&_
							" INNER JOIN personas b "&_
							" ON a.pers_ncorr_proveedor = b.pers_ncorr AND a.rgas_ncorr = "&v_solicitud&" "&_
							" INNER JOIN ocag_detalle_reembolso_gasto c "&_
							" ON a.rgas_ncorr = c.rgas_ncorr "&_
							" INNER JOIN ocag_tipo_gasto d "&_
							" ON c.tgas_ccod = d.tgas_ccod "&_
							" INNER JOIN ocag_centro_costo e "&_
							" ON c.ccos_ncorr = e.ccos_ncorr "&_
							" union "&_
							" select '2-10-070-10-000002' as cuenta ,'Cuentas por Pagar (Sist.Computac.)' as descripcion, b.pers_nrut as auxiliar, 0 as debe, a.rgas_mgiro as haber "&_
							" , protic.trunc(a.ocag_fingreso) as fecha_solicitud , 'RG' AS TDOCUMENTO , e.ccos_tcodigo "&_
							" from ocag_reembolso_gastos a "&_
							" INNER JOIN personas b "&_
							" ON a.pers_ncorr_proveedor = b.pers_ncorr and rgas_ncorr = "&v_solicitud&" "&_
							" INNER JOIN ocag_detalle_reembolso_gasto c "&_
							" ON a.rgas_ncorr = c.rgas_ncorr "&_
							" INNER JOIN ocag_centro_costo e "&_
							" ON c.ccos_ncorr = e.ccos_ncorr "&_
							" ) as tabla order by debe desc "
		
		sql_efes=" select * from ( "&_
					" select '2-10-070-10-000004' as cuenta,'Cuentas por Pagar con Control Presup.origen(Sist.Computac.)' as descripcion, "&_
					" psol_mpresupuesto as debe,0 as haber,cod_pre,protic.trunc('01/'+cast(mes_ccod as varchar)+'/'+cast(anos_ccod as varchar)) as fecha, "&_
					" case when mes_ccod<10 then '0'+cast(mes_ccod as varchar) else cast(mes_ccod as varchar) end  +cast(anos_ccod as varchar) as flujo "&_
					" , 'RG' AS TDOCUMENTO "&_
					" from ocag_presupuesto_solicitud  "&_
					" where cod_solicitud="&v_solicitud&" and tsol_ccod=2 "&_
					" union "&_
					" select '2-10-070-10-000004' as cuenta,'Cuentas por Pagar con Control Presup.origen(Sist.Computac.)' as descripcion, "&_
					" 0 as debe,psol_mpresupuesto as haber,cod_pre,protic.trunc('01/'+cast(mes_ccod as varchar)+'/'+cast(anos_ccod as varchar)) as fecha, "&_
					" case when mes_ccod<10 then '0'+cast(mes_ccod as varchar) else cast(mes_ccod as varchar) end  +cast(anos_ccod as varchar) as flujo "&_
					" , 'RG' AS TDOCUMENTO "&_
					" from ocag_presupuesto_solicitud  "&_
					" where cod_solicitud="&v_solicitud&" and tsol_ccod=2 "&_
					") as tabla "&_
					" order by cod_pre, debe desc "		

		sql_auxiliar= "select top 1 pers_nrut from ocag_reembolso_gastos a, personas b "&_
					  "	where a.pers_ncorr_proveedor=b.pers_ncorr "&_
					  "	and rgas_ncorr="&v_solicitud
							
		sql_centro_costo= 	" select top 1 c.ccos_tcodigo from ocag_validacion_contable a, ocag_centro_costo_validacion b, ocag_centro_costo c "&_
							"	where a.vcon_ncorr=b.vcon_ncorr "&_
							"	and b.ccos_ncorr=c.ccos_ncorr "&_
							"	and cod_solicitud="&v_solicitud&" "&_
							"	and isnull(tsol_ccod,2)=2 "		

		sql_documentos= 	" select '' "	

	Case 3: ' Fondos a rendir
		txt_tipo="Fondos_Rendir"
		
		sql_doctos = "select * from ( "&_
					" select '1-10-060-10-000002' as cuenta,'Fondo Rendir en Pesos' as descripcion, "&_
					"   b.pers_nrut as auxiliar, fren_mmonto as debe,0 as haber, protic.trunc(ocag_fingreso) as fecha_solicitud "&_
					"   , '' AS ccos_tcodigo, 'FR' AS TDOCUMENTO "&_
					"	from ocag_fondos_a_rendir a, personas b "&_
					"	where a.pers_ncorr=b.pers_ncorr "&_
					"	and fren_ncorr="&v_solicitud&" "&_
					"	union  "&_
					"	select '2-10-070-10-000002' as cuenta ,'Cuentas por Pagar (Sist.Computac.)' as descripcion, "&_
					"   b.pers_nrut as auxiliar,0 as debe, fren_mmonto as haber, protic.trunc(ocag_fingreso) as fecha_solicitud "&_
					"   , '' AS ccos_tcodigo, 'FR' AS TDOCUMENTO "&_
					"	from ocag_fondos_a_rendir a, personas b "&_
					"	where a.pers_ncorr=b.pers_ncorr "&_
					"	and fren_ncorr="&v_solicitud&" "&_
					"	) as tabla "		
		
		sql_efes=" select * from ( "&_
					" select '2-10-070-10-000004' as cuenta,'Cuentas por Pagar con Control Presup.origen(Sist.Computac.)' as descripcion, "&_
					" psol_mpresupuesto as debe,0 as haber,cod_pre,protic.trunc('01/'+cast(mes_ccod as varchar)+'/'+cast(anos_ccod as varchar)) as fecha, "&_
					" case when mes_ccod<10 then '0'+cast(mes_ccod as varchar) else cast(mes_ccod as varchar) end  +cast(anos_ccod as varchar) as flujo "&_
					", 'FR' AS TDOCUMENTO "&_
					" from ocag_presupuesto_solicitud  "&_
					" where cod_solicitud="&v_solicitud&" and tsol_ccod=3 "&_
					" union "&_
					" select '2-10-070-10-000004' as cuenta,'Cuentas por Pagar con Control Presup.origen(Sist.Computac.)' as descripcion, "&_
					" 0 as debe,psol_mpresupuesto as haber,cod_pre,protic.trunc('01/'+cast(mes_ccod as varchar)+'/'+cast(anos_ccod as varchar)) as fecha, "&_
					" case when mes_ccod<10 then '0'+cast(mes_ccod as varchar) else cast(mes_ccod as varchar) end  +cast(anos_ccod as varchar) as flujo "&_
					", 'FR' AS TDOCUMENTO "&_
					" from ocag_presupuesto_solicitud  "&_
					" where cod_solicitud="&v_solicitud&" and tsol_ccod=3 "&_
					") as tabla "&_
					" order by cod_pre, debe desc "				

		sql_auxiliar= "select top 1 pers_nrut from ocag_fondos_a_rendir a, personas b "&_
					  "	where a.pers_ncorr=b.pers_ncorr "&_
					  "	and fren_ncorr="&v_solicitud
							

		sql_centro_costo= 	" select top 1 c.ccos_tcodigo from ocag_validacion_contable a, ocag_centro_costo_validacion b, ocag_centro_costo c "&_
							"	where a.vcon_ncorr=b.vcon_ncorr "&_
							"	and b.ccos_ncorr=c.ccos_ncorr "&_
							"	and cod_solicitud="&v_solicitud&" "&_
							"	and isnull(tsol_ccod,3)=3 "		
							
		sql_documentos= 	" select '' "	

	Case 4: ' Viaticos
		txt_tipo="Solicitud_Viaticos"
		
		sql_doctos = "select * from ( "&_
					" select '5-30-020-10-002022' as cuenta,'Viaticos' as descripcion, "&_
					"   b.pers_nrut as auxiliar, sovi_mmonto_pesos as debe,0 as haber, protic.trunc(ocag_fingreso) as fecha_solicitud "&_
					"   , '' AS ccos_tcodigo, 'SV' AS TDOCUMENTO "&_
					"	from ocag_solicitud_viatico a, personas b "&_
					"	where a.pers_ncorr=b.pers_ncorr "&_
					"	and sovi_ncorr="&v_solicitud&" "&_
					"	union  "&_
					"	select '2-10-070-10-000002' as cuenta ,'Cuentas por Pagar (Sist.Computac.)' as descripcion, "&_
					"   b.pers_nrut as auxiliar,0 as debe, sovi_mmonto_pesos as haber, protic.trunc(ocag_fingreso) as fecha_solicitud "&_
					"   , '' AS ccos_tcodigo, 'SV' AS TDOCUMENTO "&_
					"	from ocag_solicitud_viatico a, personas b "&_
					"	where a.pers_ncorr=b.pers_ncorr "&_
					"	and sovi_ncorr="&v_solicitud&" "&_
					"	) as tabla "&_
					" order by  debe desc "	
		
		sql_efes=" select * from ( "&_
					" select '2-10-070-10-000004' as cuenta,'Cuentas por Pagar con Control Presup.origen(Sist.Computac.)' as descripcion, "&_
					" psol_mpresupuesto as debe,0 as haber,cod_pre,protic.trunc('01/'+cast(mes_ccod as varchar)+'/'+cast(anos_ccod as varchar)) as fecha, "&_
					" case when mes_ccod<10 then '0'+cast(mes_ccod as varchar) else cast(mes_ccod as varchar) end  +cast(anos_ccod as varchar) as flujo "&_
					" , 'SV' AS TDOCUMENTO "&_
					" from ocag_presupuesto_solicitud  "&_
					" where cod_solicitud="&v_solicitud&" and tsol_ccod=4 "&_
					" union "&_
					" select '2-10-070-10-000004' as cuenta,'Cuentas por Pagar con Control Presup.origen(Sist.Computac.)' as descripcion, "&_
					" 0 as debe,psol_mpresupuesto as haber,cod_pre,protic.trunc('01/'+cast(mes_ccod as varchar)+'/'+cast(anos_ccod as varchar)) as fecha, "&_
					" case when mes_ccod<10 then '0'+cast(mes_ccod as varchar) else cast(mes_ccod as varchar) end  +cast(anos_ccod as varchar) as flujo "&_
					" , 'SV' AS TDOCUMENTO "&_
					" from ocag_presupuesto_solicitud  "&_
					" where cod_solicitud="&v_solicitud&" and tsol_ccod=4 "&_
					") as tabla "&_
					" order by cod_pre, debe desc "

		sql_auxiliar= "select top 1 pers_nrut from ocag_solicitud_viatico a, personas b "&_
					  "	where a.pers_ncorr=b.pers_ncorr "&_
					  "	and sovi_ncorr="&v_solicitud
					

		sql_centro_costo= 	" select top 1 c.ccos_tcodigo from ocag_validacion_contable a, ocag_centro_costo_validacion b, ocag_centro_costo c "&_
							"	where a.vcon_ncorr=b.vcon_ncorr "&_
							"	and b.ccos_ncorr=c.ccos_ncorr "&_
							"	and cod_solicitud="&v_solicitud&" "&_
							"	and isnull(tsol_ccod,4)=4 "		
							
		sql_documentos= 	" select '' "	

	Case 5: ' devolucion alumnos
		txt_tipo="Devolucion_alumnos"
		
		sql_doctos =  "select * from ( "&_
					" select '1-10-010-20-000003' as cuenta,'Fondo fijo en Pesos' as descripcion, "&_
					"   b.pers_nrut as auxiliar, dalu_mmonto_pesos as debe,0 as haber, protic.trunc(ocag_fingreso) as fecha_solicitud "&_
					"   , '' AS ccos_tcodigo, 'DV' AS TDOCUMENTO "&_
					"	from ocag_devolucion_alumno a, personas b "&_
					"	where a.pers_ncorr=b.pers_ncorr "&_
					"	and dalu_ncorr="&v_solicitud&" "&_
					"	union  "&_
					"	select '2-10-070-10-000002' as cuenta ,'Cuentas por Pagar (Sist.Computac.)' as descripcion, "&_
					"   b.pers_nrut as auxiliar,0 as debe, dalu_mmonto_pesos as haber, protic.trunc(ocag_fingreso) as fecha_solicitud "&_
					"   , '' AS ccos_tcodigo, 'DV' AS TDOCUMENTO "&_
					"	from ocag_devolucion_alumno a, personas b "&_
					"	where a.pers_ncorr=b.pers_ncorr "&_
					"	and dalu_ncorr="&v_solicitud&" "&_
					"	) as tabla "&_
					" order by  debe desc "
		
		sql_efes= "select * from ( "&_
					"select '1-10-040-30-' + LTRIM(c.CCOS_TCODIGO) as cuenta, LTRIM(c.CCOS_TDESC) as descripcion, b.pers_nrut as auxiliar, dalu_mmonto_pesos as debe,0 as haber "&_
					", protic.trunc(ocag_fingreso) as fecha_solicitud , c.CCOS_TCOMPUESTO AS ccos_tcodigo, 'DV' AS TDOCUMENTO "&_
					"from ocag_devolucion_alumno a "&_
					"INNER JOIN personas b "&_
					"ON a.pers_ncorr=b.pers_ncorr and a.dalu_ncorr ="&v_solicitud&" "&_
					"INNER JOIN CENTROS_COSTO c "&_
					"on a.ccos_ccod = c.CCOS_CCOD "&_
					"union "&_
					"select '1-10-040-30-' + LTRIM(c.CCOS_TCODIGO) as cuenta ,LTRIM(c.CCOS_TDESC) as descripcion, b.pers_nrut as auxiliar,0 as debe, dalu_mmonto_pesos as haber "&_
					", protic.trunc(ocag_fingreso) as fecha_solicitud , c.CCOS_TCOMPUESTO AS ccos_tcodigo, 'DV' AS TDOCUMENTO "&_
					"from ocag_devolucion_alumno a "&_
					"INNER JOIN personas b "&_
					"ON a.pers_ncorr=b.pers_ncorr and a.dalu_ncorr ="&v_solicitud&" "&_
					"INNER JOIN CENTROS_COSTO c "&_
					"on a.ccos_ccod = c.CCOS_CCOD "&_
					") as tabla order by debe desc "		

		sql_auxiliar= "select top 1 pers_nrut from ocag_devolucion_alumno a, personas b "&_
					  "	where a.pers_ncorr=b.pers_ncorr "&_
					  "	and dalu_ncorr="&v_solicitud


		sql_centro_costo= 	" select top 1 c.ccos_tcodigo from ocag_validacion_contable a, ocag_centro_costo_validacion b, ocag_centro_costo c "&_
							"	where a.vcon_ncorr=b.vcon_ncorr "&_
							"	and b.ccos_ncorr=c.ccos_ncorr "&_
							"	and cod_solicitud="&v_solicitud&" "&_
							"	and isnull(tsol_ccod,5)=5 "										
							
		sql_documentos= 	" select '' "	

	Case 6: ' Fondo Fijo
		txt_tipo="Fondo_Fijo"
		
		sql_doctos = "select * from ( "&_
					" select '1-10-010-20-000003' as cuenta,'Fondo fijo en Pesos' as descripcion, "&_
					"   b.pers_nrut as auxiliar, ffij_mmonto_pesos as debe,0 as haber, protic.trunc(ocag_fingreso) as fecha_solicitud "&_
					"   , '' AS ccos_tcodigo, 'FF' AS TDOCUMENTO "&_
					"	from ocag_fondo_fijo a, personas b "&_
					"	where a.pers_ncorr=b.pers_ncorr "&_
					"	and ffij_ncorr="&v_solicitud&" "&_
					"	union  "&_
					"	select '2-10-070-10-000002' as cuenta ,'Cuentas por Pagar (Sist.Computac.)' as descripcion, "&_
					"   b.pers_nrut as auxiliar,0 as debe, ffij_mmonto_pesos as haber, protic.trunc(ocag_fingreso) as fecha_solicitud "&_
					"  , '' AS ccos_tcodigo, 'FF' AS TDOCUMENTO "&_
					"	from ocag_fondo_fijo a, personas b "&_
					"	where a.pers_ncorr=b.pers_ncorr "&_
					"	and ffij_ncorr="&v_solicitud&" "&_
					"	) as tabla "
		
		sql_efes=" select * from "&_
					"( "&_
					"select '2-10-070-10-000004' as cuenta,'Cuentas por Pagar con Control Presup.origen(Sist.Computac.)' as descripcion "&_
					", psol_mpresupuesto as debe, 0 as haber "&_
					", cod_pre, 'FF' AS TDOCUMENTO "&_
					"from ocag_presupuesto_solicitud where cod_solicitud="&v_solicitud&" and tsol_ccod=6 "&_
					"union "&_
					"select '2-10-070-10-000004' as cuenta,'Cuentas por Pagar con Control Presup.origen(Sist.Computac.)' as descripcion "&_
					", 0 as debe, psol_mpresupuesto as haber "&_
					", cod_pre, 'FF' AS TDOCUMENTO "&_
					"from ocag_presupuesto_solicitud where cod_solicitud="&v_solicitud&" and tsol_ccod=6 "&_
					") "&_
					"as tabla order by cod_pre, debe desc "
							
		sql_auxiliar= "select top 1 pers_nrut from ocag_fondo_fijo a, personas b "&_
					  "	where a.pers_ncorr=b.pers_ncorr "&_
					  "	and ffij_ncorr="&v_solicitud

		sql_centro_costo= 	" select c.ccos_tcodigo from ocag_validacion_contable a, ocag_centro_costo_validacion b, ocag_centro_costo c "&_
							"	where a.vcon_ncorr=b.vcon_ncorr "&_
							"	and b.ccos_ncorr=c.ccos_ncorr "&_
							"	and cod_solicitud="&v_solicitud&" "&_
							"	and isnull(tsol_ccod,6)=6 "							
							
		sql_documentos= 	" select '' "	


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

		sql_auxiliar= "select top 1 pers_nrut from ocag_orden_compra a, personas b "&_
					  "	where a.pers_ncorr_proveedor=b.pers_ncorr "&_
					  "	and ordc_ncorr="&v_solicitud
					
		sql_centro_costo= 	" select top 1 c.ccos_tcodigo from ocag_validacion_contable a, ocag_centro_costo_validacion b, ocag_centro_costo c "&_
							"	where a.vcon_ncorr=b.vcon_ncorr "&_
							"	and b.ccos_ncorr=c.ccos_ncorr "&_
							"	and cod_solicitud="&v_solicitud&" "&_
							"	and isnull(tsol_ccod,9)=9 "		

end select

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
			
			'se debe crear entonces el directorio /dia/editorial
			'Set Carpeta3 = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_CARGA_CONTABLE&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja)
			'Set subcarpera3 = Carpeta3.subFolders
			'subcarpera3.add(v_editorial)
			
			'se debe crear entonces el directorio /dia/ichisame
			'Set Carpeta4 = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_CARGA_CONTABLE&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja)
			'Set subcarpera4 = Carpeta4.subFolders
			'subcarpera4.add(v_ichisame)			
		
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
				
				'se debe crear entonces el directorio /dia/editorial
				'Set Carpeta3 = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_CARGA_CONTABLE&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja)
				'Set subcarpera3 = Carpeta3.subFolders
				'subcarpera3.add(v_editorial)

				'se debe crear entonces el directorio /dia/ichisame
				'Set Carpeta4 = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_CARGA_CONTABLE&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja)
				'Set subcarpera4 = Carpeta4.subFolders
				'subcarpera4.add(v_ichisame)					
				
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
				
				' se crea el sub-directorio /editorial
				'Set Carpeta3 = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_CARGA_CONTABLE&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja)
				'Set subcarpera3 = Carpeta3.subFolders
				'subcarpera3.add(v_editorial)

				'se debe crear entonces el directorio /ichisame
				'Set Carpeta4 = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_CARGA_CONTABLE&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja)
				'Set subcarpera4 = Carpeta4.subFolders
				'subcarpera4.add(v_ichisame)	
							
			End if
			
		End if
		
	'else
	
		'If not CreaCarpeta.FolderExists(RUTA_ARCHIVOS_CARGA_CONTABLE&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja&"\"&v_editorial) Then
		
		'response.Write("2.1.1. ACA "&"<BR>")
			
		'	Set Carpeta = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_CARGA_CONTABLE&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja)
		'	Set subcarpera = Carpeta.subFolders
		'	subcarpera.add(v_editorial)
			
		'end if

		'If not CreaCarpeta.FolderExists(RUTA_ARCHIVOS_CARGA_CONTABLE&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja&"\"&v_ichisame) Then
		
		'response.Write("2.2.1. ACA "&"<BR>")
			
		'	Set Carpeta1 = CreaCarpeta.GetFolder(RUTA_ARCHIVOS_CARGA_CONTABLE&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja)
		'	Set subcarpera1 = Carpeta1.subFolders
		'	subcarpera1.add(v_ichisame)
			
		'end if
		
	End If

v_ruta_salida_nueva		=	RUTA_ARCHIVOS_CARGA_CONTABLE&"\"&v_ano_caja&"\"&v_mes_caja&"\"&v_dia_caja

'RESPONSE.WRITE("6. v_ruta_salida_nueva : "&v_ruta_salida_nueva&"<BR>")

'******************************************

	v_nombre_cajero	=	p_conexion.ConsultaUno(sql_nombre)
	'v_auxiliar		=	"aux"
	archivo_salida 		= v_nombre_cajero&"_"&txt_tipo&"_"&v_solicitud & ".txt"
	'archivo_salida_empre= v_nombre_cajero&"_editorial_"& cod_solicitud & ".txt"
	'archivo_salida_2 	= v_auxiliar&"_"& cod_solicitud & ".txt"
	'archivo_salida_ichisame= v_nombre_cajero&"_ichisame_"& cod_solicitud & ".txt"

	' Creacion de archivos de cajas
	set fso = Server.CreateObject("Scripting.FileSystemObject")
	set o_texto_archivo = fso.CreateTextFile(v_ruta_salida_nueva & "\" & archivo_salida)
	
'	set fso_empre = Server.CreateObject("Scripting.FileSystemObject")
'	set o_texto_archivo_empre = fso.CreateTextFile(v_ruta_salida_empre & "\" & archivo_salida_empre)

'	set fso_ichisame = Server.CreateObject("Scripting.FileSystemObject")
'	set o_texto_archivo_ichisame = fso.CreateTextFile(v_ruta_salida_ichisame & "\" & archivo_salida_ichisame)

'	' Archivo datos auxiliares generico
'	set fso2 = Server.CreateObject("Scripting.FileSystemObject")
'	set o_texto_archivo_2 = fso2.CreateTextFile(v_ruta_salida_nueva & "\" & archivo_salida_2)

'response.Flush()

	'if Err.Number <> 0 then
	'	response.Write("<br> Error :"&Err.Description):response.Flush()
	'	TablaAArchivo = false
	'Exit Function
	'end if

	'--------------------------------------------------------------------------------------------------------------
	
	'SQL = 	"Select protic.trunc(TSOF_FECHA_EMISION) as TSOF_FECHA_EMISION_CORTA," & vbCrLf &_
	'		" protic.trunc(TSOF_FECHA_VENCIMIENTO) as TSOF_FECHA_VENCIMIENTO_CORTA, "& vbCrLf &_
	'		" protic.extrae_acentos(TSOF_GLOSA) as TSOF_GLOSA_SIN_ACENTO, "& vbCrLf &_
	'		" protic.extrae_acentos(replace(trca_nombre_a,'-','_')) as trca_nombre_acento,protic.extrae_acentos(replace(trca_nombre_c,'-','_')) as trca_nombre_cacento,"& vbCrLf &_
	'		" protic.extrae_acentos(replace(trca_paterno_a,'-','_')) as trca_paterno_acento,protic.extrae_acentos(replace(trca_materno_a,'-','_')) as trca_materno_acento, "& vbCrLf &_
	'		" protic.extrae_acentos(replace(trca_paterno_c,'-','_')) as trca_paterno_cacento,protic.extrae_acentos(replace(trca_materno_c,'-','_')) as trca_materno_cacento, *  "& vbCrLf &_
	'		" From traspasos_cajas_softland where mcaj_ncorr = '" & p_mcaj_ncorr & "' " & vbCrLf &_ 
	'		" and isnull(tsof_empresa,1)=1 " & vbCrLf &_
	'		" order by ting_ccod desc, ingr_nfolio_referencia asc, tsof_nro_agrupador, trca_nlinea asc"	

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
												 f_documentos.Inicializar conexion
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
										linea = linea & fijovariable& DELIMITADOR_CAMPOS_SOFT
										
										linea = linea & f_consulta.ObtenerValor("debe") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_consulta.ObtenerValor("haber") & DELIMITADOR_CAMPOS_SOFT
										
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
										linea = linea & fijovariable & DELIMITADOR_CAMPOS_SOFT

										linea = linea & f_efes.ObtenerValor("debe") & DELIMITADOR_CAMPOS_SOFT
										linea = linea & f_efes.ObtenerValor("haber") & DELIMITADOR_CAMPOS_SOFT
										
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
	
	'Archivo editorial
'	set o_texto_archivo_empre = Nothing
'	set fso_empre = Nothing
	
	'Archivo ichisame
	'set o_texto_archivo_ichisame = Nothing
	'set fso_ichisame = Nothing
		
	'Auxiliar Editorial
	'set o_texto_archivo_2 = Nothing
	'set fso2 = Nothing
	
	set f_consulta = Nothing
	set f_efes = Nothing
	
'	set f_consulta_empre = Nothing
'	set f_consulta_ichisame = Nothing
'	set f_auxiliares = Nothing
	
    Set Carpeta = Nothing
	Set subcarpera = Nothing
	Set subcarpera2 = Nothing 
	Set CreaCarpeta = Nothing

	'TablaAArchivo = true
	
'End Function

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


<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO: MODULO TESORERO
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:06/02/2013
'ACTUALIZADO POR		:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:182,183,184 - 480 - 528 - 676,677,678
'********************************************************************
Class CCuentaCorriente
	Private conexion, v_pers_ncorr, p_periodo_especifico
	Private sql_detalle_compromisos, sql_creditos, sql_becas_descuentos
	Private sql_compromisos_pendientes_no_pagar, sql_compromisos_pagar, sql_compromisos_en_cobranza
	Private sql_resumen_detalle_compromisos,sql_resumen_caja_pendiente,sql_resumen_caja_otros_pendiente
	Private formulario
	Private nFilasDibujadas
	Private sql_todos_compromisos_pendientes
	
	Sub Inicializar(p_conexion, p_pers_nrut,p_periodo_especifico)
		set conexion = p_conexion
		v_pers_ncorr = conexion.ConsultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar) = '" & p_pers_nrut & "'")
		if v_pers_ncorr="" or isnull(v_pers_ncorr) or isempty(v_pers_ncorr) then
				v_pers_ncorr = conexion.ConsultaUno("select pers_ncorr from personas_postulante where cast(pers_nrut as varchar) = '" & p_pers_nrut & "'")
		end if
		if p_periodo_especifico <>""  then
			v_sql=" and b.peri_ccod='"&p_periodo_especifico&"'"
			'v_sql_resumen=" and a.peri_ccod='"&p_periodo_especifico&"'"
			v_sql_credito= " where peri_ccod='"&p_periodo_especifico&"'"
			'response.Write("<br><hr>"&v_sql&"-->"&v_sql_credito&"<hr>")
		end if
		
		
		sql_compromisos_en_cobranza = " select b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, b.comp_ndocto as c_comp_ndocto, b.tcom_ccod as c_tcom_ccod," & vbCrLf &_
									  " cast(b.dcom_ncompromiso as varchar)+ ' / ' + cast(a.comp_ncuotas as varchar) as ncuota, a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso," & vbCrLf &_
									  " protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod," & vbCrLf &_
									  " protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as ding_ndocto," & vbCrLf &_
									  " protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos," & vbCrLf &_
									  " protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado," & vbCrLf &_
									  " protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo, " & vbCrLf &_
									  " d.edin_ccod, d.edin_tdesc, d.udoc_ccod, d.fedi_ccod " & vbCrLf &_
									  " from" & vbCrLf &_
									  " compromisos a join detalle_compromisos b" & vbCrLf &_
									  "    on a.tcom_ccod = b.tcom_ccod and a.inst_ccod = b.inst_ccod and a.comp_ndocto = b.comp_ndocto and a.ecom_ccod=b.ecom_ccod" & vbCrLf &_
									  " left outer join detalle_ingresos c" & vbCrLf &_
									  "    on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod   " & vbCrLf &_
									  "    and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto  " & vbCrLf &_
									  "    and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr" & vbCrLf &_
									  " left outer join estados_detalle_ingresos d " & vbCrLf &_
									  "    on c.edin_ccod = d.edin_ccod" & vbCrLf &_
									  " where protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0 " & vbCrLf &_
									  " and ((d.fedi_ccod = 10) or " & vbCrLf &_
									  " (exists (select 1 " & vbCrLf &_
									  "          from " & vbCrLf &_
								  	  "          compromisos a2 join detalle_compromisos b2" & vbCrLf &_
									  "               on a2.tcom_ccod = b2.tcom_ccod and a2.inst_ccod = b2.inst_ccod and a2.comp_ndocto = b2.comp_ndocto" & vbCrLf &_
									  "          left outer join detalle_ingresos c2" & vbCrLf &_
									  "               on protic.documento_asociado_cuota(b2.tcom_ccod, b2.inst_ccod, b2.comp_ndocto, b2.dcom_ncompromiso, 'ting_ccod') = c2.ting_ccod  " & vbCrLf &_
									  "                  and protic.documento_asociado_cuota(b2.tcom_ccod, b2.inst_ccod, b2.comp_ndocto, b2.dcom_ncompromiso, 'ding_ndocto') = c2.ding_ndocto  " & vbCrLf &_
									  "                  and protic.documento_asociado_cuota(b2.tcom_ccod, b2.inst_ccod, b2.comp_ndocto, b2.dcom_ncompromiso, 'ingr_ncorr') = c2.ingr_ncorr" & vbCrLf &_
									  "          left outer join estados_detalle_ingresos d2" & vbCrLf &_
									  "               on c2.edin_ccod = d2.edin_ccod" & vbCrLf &_
									  "          join referencias_cargos e2" & vbCrLf &_
									  "               on c2.ting_ccod = e2.ting_ccod and c2.ingr_ncorr = e2.ingr_ncorr and c2.ding_ndocto = e2.ding_ndocto" & vbCrLf &_
									  "          join compromisos f2" & vbCrLf &_
									  "               on e2.reca_ncorr = f2.comp_ndocto and f2.comp_ndocto = a.comp_ndocto and f2.inst_ccod = a.inst_ccod and f2.tcom_ccod = a.tcom_ccod" & vbCrLf &_
									  " where  f2.tcom_ccod = 5 " & vbCrLf &_
									  " and protic.total_recepcionar_cuota(b2.tcom_ccod, b2.inst_ccod, b2.comp_ndocto, b2.dcom_ncompromiso) > 0" & vbCrLf &_
									  " and d2.fedi_ccod = 10 " & vbCrLf &_
									  " and a2.ecom_ccod = 1" & vbCrLf &_
									  " and b2.ecom_ccod = 1" & vbCrLf &_
									  " and cast(a2.pers_ncorr as varchar)= '"&v_pers_ncorr&"') " & vbCrLf &_
									  " ) " & vbCrLf &_
									  " ) " & vbCrLf &_
									  " and a.ecom_ccod = 1  " & vbCrLf &_
									  " and cast(a.pers_ncorr as varchar) = '"&v_pers_ncorr&"'"										
										
										'"              and a.pers_ncorr = '1'"

       'response.Write("<pre>"&sql_compromisos_en_cobranza &"</pre>")
		
		'sql_compromisos_en_cobranza =  "select b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, b.comp_ndocto as c_comp_ndocto, b.tcom_ccod as c_tcom_ccod, b.dcom_ncompromiso || ' / ' || a.comp_ncuotas as ncuota, a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso, " & vbCrLf &_
		'                                      "       documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod,   " & vbCrLf &_
		'									  "       documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as ding_ndocto,   " & vbCrLf &_
		'									  "       total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos, " & vbCrLf &_
		'									  "       total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado, " & vbCrLf &_
		'									  "	   total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo, " & vbCrLf &_
		'									  "	   d.edin_ccod, d.edin_tdesc, d.udoc_ccod   " & vbCrLf &_
		'									  "from compromisos a, detalle_compromisos b, detalle_ingresos c, estados_detalle_ingresos d  " & vbCrLf &_
		'									  "where c.edin_ccod = '10'    " & vbCrLf &_
		'									  "  and a.tcom_ccod = b.tcom_ccod   " & vbCrLf &_
		'									  "  and a.inst_ccod = b.inst_ccod   " & vbCrLf &_
		'									  "  and a.comp_ndocto = b.comp_ndocto   " & vbCrLf &_
		'									  "  and documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod (+) " & vbCrLf &_
		'									  "  and documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto (+) " & vbCrLf &_
		'									  "  and documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr (+) " & vbCrLf &_
		'									  "  and c.edin_ccod = d.edin_ccod (+) " & vbCrLf &_
		'									  "  and total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0 " & vbCrLf &_
		'									  "  and a.ecom_ccod = '1' " & vbCrLf &_
		'									  "  and b.ecom_ccod = '1' " & vbCrLf &_
		'									  "  and a.pers_ncorr = '" & v_pers_ncorr & "'"
				
		'TODOS LOS COMPROMISOS DE LA PERSONA, PAGADOS Y NO PAGADOS
		
'		sql_detalle_compromisos = "select b.inst_ccod, b.comp_ndocto,b.tcom_ccod, case when b.tcom_ccod in (1,2) then cast(b.comp_ndocto as varchar)+ ' ('+protic.numero_contrato(b.comp_ndocto)+')'else cast(b.comp_ndocto as varchar) end as ncompromiso, " & vbCrLf &_
'								"     case " & vbCrLf &_
'								"   when b.tcom_ccod=25 or b.tcom_ccod=4 or b.tcom_ccod=5 or b.tcom_ccod=8 or b.tcom_ccod=10 or b.tcom_ccod=26 or b.tcom_ccod=34 or b.tcom_ccod=35 or b.tcom_ccod=15 " & vbCrLf &_
'        						"		then " & vbCrLf &_
'							    "       (Select a1.tdet_tdesc from tipos_detalle a1,detalles a2 where a2.tcom_ccod=a.tcom_ccod and a2.inst_ccod=a.inst_ccod " & vbCrLf &_
'							    "        and a2.comp_ndocto=a.comp_ndocto and a1.tdet_ccod=a2.tdet_ccod) " & vbCrLf &_
'							    " 	when b.tcom_ccod=37 then (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod)+'-'+protic.obtener_nombre_carrera(a.ofer_ncorr,'CJ') "& vbCrLf &_
'								"   else " & vbCrLf &_
'							    "        (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod) " & vbCrLf &_
'							    "    end as tcom_tdesc, " & vbCrLf &_
'								"    b.dcom_ncompromiso,cast(b.dcom_ncompromiso as varchar) + '/' + cast(a.comp_ncuotas as varchar)  as ncuota," & vbCrLf &_
'								"    a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso," & vbCrLf &_
'								"    protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod," & vbCrLf &_
'								"    case  "& vbCrLf &_
'								"    when a.tcom_ccod=2 and  protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')=52 "& vbCrLf &_
'								"        then  "& vbCrLf &_
'								"          (select pag.PAGA_NCORR from  pagares pag 	where  pag.cont_ncorr =a.comp_ndocto) "& vbCrLf &_
'								"        else "& vbCrLf &_
'								"            protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') "& vbCrLf &_
'								"        end as ding_ndocto, "& vbCrLf &_
'								"    protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos, " & vbCrLf &_
'								"    protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado," & vbCrLf &_
'								"    isnull(b.dcom_mcompromiso, 0) - protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo, " & vbCrLf &_
'								"(select d.edin_ccod from  estados_detalle_ingresos d" & vbCrLf &_
'								"    where c.edin_ccod = d.edin_ccod) as edin_ccod," & vbCrLf &_
'								"(select d.edin_tdesc+protic.obtener_institucion(c.ingr_ncorr) from estados_detalle_ingresos d" & vbCrLf &_
'								"    where c.edin_ccod = d.edin_ccod) as edin_tdesc " & vbCrLf &_
'								" from compromisos a,detalle_compromisos b,detalle_ingresos c" & vbCrLf &_
'								" where a.tcom_ccod = b.tcom_ccod" & vbCrLf &_
'								"    and a.inst_ccod = b.inst_ccod " & vbCrLf &_
'								"    and a.comp_ndocto = b.comp_ndocto" & vbCrLf &_
'								"    and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') *= c.ting_ccod" & vbCrLf &_
'								"    and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') *= c.ding_ndocto" & vbCrLf &_
'								"    and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') *= c.ingr_ncorr" & vbCrLf &_
'								"    and a.ecom_ccod = '1' "&v_sql&" " & vbCrLf &_
'								"    and b.ecom_ccod <> '3' " & vbCrLf &_
'								"    and cast(a.pers_ncorr as varchar) ='" & v_pers_ncorr & "'" & vbCrLf &_
'								"    order by b.dcom_fcompromiso desc"

		sql_detalle_compromisos = "select b.inst_ccod, b.comp_ndocto,b.tcom_ccod, case when b.tcom_ccod in (1,2) then cast(b.comp_ndocto as varchar)+ ' ('+protic.numero_contrato(b.comp_ndocto)+')'else cast(b.comp_ndocto as varchar) end as ncompromiso, " & vbCrLf &_
								"     case " & vbCrLf &_
								"   when b.tcom_ccod=25 or b.tcom_ccod=4 or b.tcom_ccod=5 or b.tcom_ccod=8 or b.tcom_ccod=10 or b.tcom_ccod=26 or b.tcom_ccod=34 or b.tcom_ccod=35 or b.tcom_ccod=15 " & vbCrLf &_
        						"		then " & vbCrLf &_
							    "       (Select a1.tdet_tdesc from tipos_detalle a1,detalles a2 where a2.tcom_ccod=a.tcom_ccod and a2.inst_ccod=a.inst_ccod " & vbCrLf &_
							    "        and a2.comp_ndocto=a.comp_ndocto and a1.tdet_ccod=a2.tdet_ccod) " & vbCrLf &_
							    " 	when b.tcom_ccod=37 then (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod)+'-'+protic.obtener_nombre_carrera(a.ofer_ncorr,'CJ') "& vbCrLf &_
								"   else " & vbCrLf &_
							    "        (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod) " & vbCrLf &_
							    "    end as tcom_tdesc, " & vbCrLf &_
								"    b.dcom_ncompromiso,cast(b.dcom_ncompromiso as varchar) + '/' + cast(a.comp_ncuotas as varchar)  as ncuota," & vbCrLf &_
								"    a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso," & vbCrLf &_
								"    protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod," & vbCrLf &_
								"    case  "& vbCrLf &_
								"    when a.tcom_ccod=2 and  protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')=52 "& vbCrLf &_
								"        then  "& vbCrLf &_
								"          (select pag.PAGA_NCORR from  pagares pag 	where  pag.cont_ncorr =a.comp_ndocto) "& vbCrLf &_
								"        else "& vbCrLf &_
								"            protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') "& vbCrLf &_
								"        end as ding_ndocto, "& vbCrLf &_
								"    protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos, " & vbCrLf &_
								"    protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado," & vbCrLf &_
								"    isnull(b.dcom_mcompromiso, 0) - protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo, " & vbCrLf &_
								"(select d.edin_ccod from  estados_detalle_ingresos d" & vbCrLf &_
								"    where c.edin_ccod = d.edin_ccod) as edin_ccod," & vbCrLf &_
								"(select d.edin_tdesc+protic.obtener_institucion(c.ingr_ncorr) from estados_detalle_ingresos d" & vbCrLf &_
								"    where c.edin_ccod = d.edin_ccod) as edin_tdesc " & vbCrLf &_
								" from compromisos a INNER JOIN detalle_compromisos b " & vbCrLf &_
								"	ON a.tcom_ccod = b.tcom_ccod " & vbCrLf &_
								"    and a.inst_ccod = b.inst_ccod " & vbCrLf &_
								"    and a.comp_ndocto = b.comp_ndocto " & vbCrLf &_
								"    LEFT OUTER JOIN detalle_ingresos c " & vbCrLf &_
								"    ON protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod " & vbCrLf &_
								"    and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto " & vbCrLf &_
								"    and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr " & vbCrLf &_
								"    WHERE a.ecom_ccod = '1' "&v_sql&" " & vbCrLf &_
								"    and b.ecom_ccod <> '3' " & vbCrLf &_
								"    and cast(a.pers_ncorr as varchar) ='" & v_pers_ncorr & "'" & vbCrLf &_
								"    order by b.dcom_fcompromiso desc"

         ' response.Write("<pre>"&sql_detalle_compromisos&"</pre>")

'"    protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as ding_ndocto," & vbCrLf &_

							
		'sql_detalle_compromisos = "select b.inst_ccod, b.comp_ndocto, b.tcom_ccod, b.dcom_ncompromiso, b.dcom_ncompromiso || '/' || a.comp_ncuotas as ncuota, a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso, " & vbCrLf &_
		'                          	"       documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod, " & vbCrLf &_
		'						  	"       documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as ding_ndocto, " & vbCrLf &_
		'                        	"      total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos, " & vbCrLf &_
		'						  	"       total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado, " & vbCrLf &_
		'						  	"	      nvl(b.dcom_mcompromiso, 0) - total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo, " & vbCrLf &_
		'						  	"       d.edin_ccod, d.edin_tdesc   " & vbCrLf &_
		'						  	"from compromisos a, detalle_compromisos b, detalle_ingresos c, estados_detalle_ingresos d " & vbCrLf &_
		'						  	"where a.tcom_ccod = b.tcom_ccod " & vbCrLf &_
		'						  	"  and a.inst_ccod = b.inst_ccod " & vbCrLf &_
		'						  	"  and a.comp_ndocto = b.comp_ndocto " & vbCrLf &_
		'						  	"  and documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod (+)  " & vbCrLf &_
        '                        	"  and documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto (+)  " & vbCrLf &_
        '                        	"  and documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr (+)  " & vbCrLf &_
        '                          	"  and c.edin_ccod = d.edin_ccod (+)   " & vbCrLf &_
		'						  	"  and a.ecom_ccod = '1' " & vbCrLf &_
		'						  	"  and a.pers_ncorr = '" & v_pers_ncorr & "'" & vbCrLf &_
		'						  	"order by b.dcom_fcompromiso desc"
		'response.Write("<pre>"&sql_detalle_compromisos&"</pre>")		
								  
		'TODOS LOS COMPROMISOS QUE EL CAJERO PUEDE RECEPCIONAR
'		 sql_compromisos_pagar = "select b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, cast(b.comp_ndocto as varchar) as c_comp_ndocto," & vbCrLf &_
'							"        cast(b.tcom_ccod as varchar) as c_tcom_ccod, cast(b.dcom_ncompromiso as varchar) + ' / ' + cast(a.comp_ncuotas as varchar) as ncuota," & vbCrLf &_
'								"        a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso," & vbCrLf &_
'								"        protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod," & vbCrLf &_
'								"        protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as ding_ndocto," & vbCrLf &_
'								"        protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos," & vbCrLf &_
'								"        protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado," & vbCrLf &_
'								"	    protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo," & vbCrLf &_
'								"(select d.edin_ccod" & vbCrLf &_
'								"from estados_detalle_ingresos d" & vbCrLf &_
'								"where c.edin_ccod = d.edin_ccod " & vbCrLf &_
'								"and ( (c.ting_ccod is null) or (c.ting_ccod in(3,4) and d.edin_ccod not in (6) ))" & vbCrLf &_
'								"and isnull(d.udoc_ccod, 1) = 1  ) as edin_ccod," & vbCrLf &_
'								"(select d.edin_tdesc" & vbCrLf &_
'								"from estados_detalle_ingresos d" & vbCrLf &_
'								"where c.edin_ccod = d.edin_ccod" & vbCrLf &_
'								"and ( (c.ting_ccod is null) or (c.ting_ccod in(3,4) and d.edin_ccod not in (6) )) " & vbCrLf &_
'								"and isnull(d.udoc_ccod, 1) = 1  ) as edin_tdesc," & vbCrLf &_
'								"(select d.udoc_ccod" & vbCrLf &_
'								"from estados_detalle_ingresos d" & vbCrLf &_
'								"where c.edin_ccod = d.edin_ccod" & vbCrLf &_
'								"and ( (c.ting_ccod is null) or (c.ting_ccod in(3,4) and d.edin_ccod not in (6) ))  " & vbCrLf &_
'								"and isnull(d.udoc_ccod, 1) = 1 ) as udoc_ccod" & vbCrLf &_
'								"from compromisos a,detalle_compromisos b,detalle_ingresos c" & vbCrLf &_
'								"where a.tcom_ccod = b.tcom_ccod" & vbCrLf &_
'								"	and a.inst_ccod = b.inst_ccod" & vbCrLf &_
'								"	and a.comp_ndocto = b.comp_ndocto" & vbCrLf &_
'								"  	and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') *= c.ting_ccod" & vbCrLf &_
'								"  	and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') *= c.ding_ndocto" & vbCrLf &_
'								"  	and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') *= c.ingr_ncorr " & vbCrLf &_
'								"  	and isnull(protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod'), 6) <> 3  " & vbCrLf &_
'								"  	and protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0 " & vbCrLf &_
'								"  	and a.ecom_ccod = '1' " & vbCrLf &_
'								"  	and b.ecom_ccod = '1' " & vbCrLf &_
' 								"  	and cast(a.pers_ncorr  as varchar)= '" & v_pers_ncorr & "'"

	sql_compromisos_pagar = " select  "& vbCrLf &_
							"     case " & vbCrLf &_
							"   when b.tcom_ccod=25 or b.tcom_ccod=4 or b.tcom_ccod=5 or b.tcom_ccod=8 or b.tcom_ccod=10 or b.tcom_ccod=26 or b.tcom_ccod=34 or b.tcom_ccod=35" & vbCrLf &_
        					"		then " & vbCrLf &_
						    "       (Select a1.tdet_tdesc from tipos_detalle a1,detalles a2 where a2.tcom_ccod=a.tcom_ccod and a2.inst_ccod=a.inst_ccod " & vbCrLf &_
						    "        and a2.comp_ndocto=a.comp_ndocto and a1.tdet_ccod=a2.tdet_ccod) " & vbCrLf &_
						    " 	when b.tcom_ccod=37 then (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod)+'-'+protic.obtener_nombre_carrera(a.ofer_ncorr,'CJ') "& vbCrLf &_
							"   else " & vbCrLf &_
						    "        (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod) " & vbCrLf &_
						    "    end as tcom_tdesc, " & vbCrLf &_
							"			b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, b.comp_ndocto as c_comp_ndocto, b.tcom_ccod as c_tcom_ccod, cast(b.dcom_ncompromiso as varchar) + ' / '+ cast(a.comp_ncuotas as varchar) as ncuota, a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso, "& vbCrLf &_
							"			protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod,"& vbCrLf &_   
							"			protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as ding_ndocto,  "& vbCrLf &_ 
							"			protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos, "& vbCrLf &_
    						"			protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado, "& vbCrLf &_
							"			 protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo, "& vbCrLf &_
     						"		   d.edin_ccod, d.edin_tdesc, d.udoc_ccod   "& vbCrLf &_
							"		   "& vbCrLf &_
							"	 from "& vbCrLf &_
							"		compromisos a "& vbCrLf &_
							"		join detalle_compromisos b "& vbCrLf &_
							"			on a.tcom_ccod = b.tcom_ccod   "& vbCrLf &_ 
							"			and a.inst_ccod = b.inst_ccod    "& vbCrLf &_
							"			and a.comp_ndocto = b.comp_ndocto "& vbCrLf &_
							"		left outer join detalle_ingresos c "& vbCrLf &_
							"			on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod   "& vbCrLf &_
							"			   and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto  "& vbCrLf &_
							"			   and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr    "& vbCrLf &_
							"		left join estados_detalle_ingresos d   "& vbCrLf &_
							"			on c.edin_ccod = d.edin_ccod "& vbCrLf &_
							"	 where protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0  "& vbCrLf &_
							"	   and isnull(d.udoc_ccod, 1) = 1  "& vbCrLf &_
							"	   and ( (c.ting_ccod is null) or  "& vbCrLf &_
							"			 (c.ting_ccod = 4 and d.edin_ccod not in (6) ) or  "& vbCrLf &_
							"			 (c.ting_ccod = 5 and d.edin_ccod not in (6) ) or  "& vbCrLf &_
							"			  (c.ting_ccod in (2, 50)) or  "& vbCrLf &_
							"			  (c.ting_ccod in (3,38) and d.edin_ccod not in (6, 12, 51)) or  "& vbCrLf &_
							"    		  (c.ting_ccod = 52 and d.edin_ccod not in (6) ) or "& vbCrLf &_
							"    		  (c.ting_ccod = 87 and d.edin_ccod not in (6) ) or "& vbCrLf &_
							"    		  (c.ting_ccod = 88 and d.edin_ccod not in (6) ) "& vbCrLf &_
							"			)  "& vbCrLf &_
							"	   and a.ecom_ccod = '1'  "& vbCrLf &_
							"	   and b.ecom_ccod = '1'  "& vbCrLf &_
							"  	and cast(a.pers_ncorr  as varchar)= '" & v_pers_ncorr & "'"& vbCrLf &_
							"	order by b.dcom_fcompromiso asc, b.dcom_ncompromiso asc, b.tcom_ccod asc "

'response.Write("<pre>"&sql_compromisos_pagar&"</pre>")
	
	sql_compromisos_pagar_sinorder = " select  "& vbCrLf &_
							"			b.tcom_ccod+ b.inst_ccod+ b.comp_ndocto+ b.dcom_ncompromiso "& vbCrLf &_
							"	 from "& vbCrLf &_
							"		compromisos a "& vbCrLf &_
							"		join detalle_compromisos b "& vbCrLf &_
							"			on a.tcom_ccod = b.tcom_ccod   "& vbCrLf &_ 
							"			and a.inst_ccod = b.inst_ccod    "& vbCrLf &_
							"			and a.comp_ndocto = b.comp_ndocto "& vbCrLf &_
							"		left outer join detalle_ingresos c "& vbCrLf &_
							"			on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod   "& vbCrLf &_
							"			   and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto  "& vbCrLf &_
							"			   and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr    "& vbCrLf &_
							"		left join estados_detalle_ingresos d   "& vbCrLf &_
							"			on c.edin_ccod = d.edin_ccod "& vbCrLf &_
							"	 where protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0  "& vbCrLf &_
							"	   and isnull(d.udoc_ccod, 1) = 1  "& vbCrLf &_
							"	   and ( (c.ting_ccod is null) or  "& vbCrLf &_
							"			 (c.ting_ccod = 4 and d.edin_ccod not in (6) ) or  "& vbCrLf &_
							"			 (c.ting_ccod = 5 and d.edin_ccod not in (6) ) or  "& vbCrLf &_
							"			  (c.ting_ccod in (2, 50)) or  "& vbCrLf &_
							"			  (c.ting_ccod in(3,38) and d.edin_ccod not in (6, 12, 51)) or "& vbCrLf &_
							"    		  (c.ting_ccod = 52 and d.edin_ccod not in (6) ) or "& vbCrLf &_
							"    		  (c.ting_ccod = 87 and d.edin_ccod not in (6) ) or "& vbCrLf &_
							"    		  (c.ting_ccod = 88 and d.edin_ccod not in (6) ) " & vbCrLf &_
							"			)  "& vbCrLf &_
							"	   and a.ecom_ccod = '1'  "& vbCrLf &_
							"	   and b.ecom_ccod = '1'  "& vbCrLf &_
							"  	and cast(a.pers_ncorr  as varchar)= '" & v_pers_ncorr & "'"


								'response.Write("<pre>"&sql_compromisos_pagar&"</pre>")
								'"  --order by dcom_fcompromiso asc, dcom_ncompromiso asc, b.tcom_ccod asc"
		
		'sql_compromisos_pagar = "select b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, b.comp_ndocto as c_comp_ndocto, b.tcom_ccod as c_tcom_ccod, b.dcom_ncompromiso || ' / ' || a.comp_ncuotas as ncuota, a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso, " & vbCrLf &_
		'                            "       documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod,   " & vbCrLf &_
		'							 "       documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as ding_ndocto,   " & vbCrLf &_
		'							 "       total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos, " & vbCrLf &_
		'							 "       total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado, " & vbCrLf &_
		'							 "	     total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo, " & vbCrLf &_
		'							 "	   d.edin_ccod, d.edin_tdesc, d.udoc_ccod   " & vbCrLf &_
		'							 "from compromisos a, detalle_compromisos b, detalle_ingresos c, estados_detalle_ingresos d  " & vbCrLf &_
		'							 "where a.tcom_ccod = b.tcom_ccod   " & vbCrLf &_
		'							 "  and a.inst_ccod = b.inst_ccod   " & vbCrLf &_
		'							 "  and a.comp_ndocto = b.comp_ndocto   " & vbCrLf &_
		'							 "  and documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod (+) " & vbCrLf &_
		'							 "  and documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto (+) " & vbCrLf &_
		'							 "  and documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr (+) " & vbCrLf &_
		'							 "  and c.edin_ccod = d.edin_ccod (+) " & vbCrLf &_
		'							 "  and nvl(documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod'), 6) <> 3  " & vbCrLf &_
		'							 "  and total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0 " & vbCrLf &_
		'							 "  and nvl(d.udoc_ccod, 1) = 1 " & vbCrLf &_
		'							 "  --and nvl(d.edin_ccod, 0) = decode(c.ting_ccod, 4, 3, 0)  " & vbCrLf &_
		'							 "  --and ( (nvl(d.edin_ccod, 0) = decode(c.ting_ccod, 4, 3, 0)) or (nvl(d.edin_ccod, 0) = decode(c.ting_ccod, 4, 1, 0)) ) " & vbCrLf &_
		'							 "  and ( (c.ting_ccod is null) or (c.ting_ccod = 4 and d.edin_ccod not in (6) )) " & vbCrLf &_
		'							 "  and a.ecom_ccod = '1' " & vbCrLf &_
		'							 "  and b.ecom_ccod = '1' " & vbCrLf &_
		'							 "  and a.pers_ncorr = '" & v_pers_ncorr & "' " & vbCrLf &_
		'							 "order by dcom_fcompromiso asc, dcom_ncompromiso asc, tcom_ccod asc"

								
		'TODOS LOS COMPROMISOS PENDIENTES


sql_todos_compromisos_pendientes ="			select   b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, b.comp_ndocto as c_comp_ndocto, b.tcom_ccod as c_tcom_ccod,  " & vbCrLf &_
								  "  			 cast(b.dcom_ncompromiso as varchar) + ' / ' + cast(a.comp_ncuotas as varchar) as ncuota, a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso,   " & vbCrLf &_
								  " 				 protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod,     " & vbCrLf &_
								  "				 protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as ding_ndocto,     " & vbCrLf &_
								  "				 protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos,   " & vbCrLf &_
								  "				 protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado,  " & vbCrLf &_ 
								  "			   protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo,   " & vbCrLf &_
								  "			   d.edin_ccod, d.edin_tdesc, d.udoc_ccod     " & vbCrLf &_
								  "		  from  " & vbCrLf &_
								  "		  compromisos a  " & vbCrLf &_
								  "		  join detalle_compromisos b  " & vbCrLf &_
								  "			on a.tcom_ccod = b.tcom_ccod     " & vbCrLf &_
								  "				and a.inst_ccod = b.inst_ccod     " & vbCrLf &_
								  "				and a.comp_ndocto = b.comp_ndocto " & vbCrLf &_
								  "		  left outer join detalle_ingresos c " & vbCrLf &_
								  "				on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')    = c.ting_ccod    " & vbCrLf &_
								  "				and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto    " & vbCrLf &_
								  "				and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')  = c.ingr_ncorr   " & vbCrLf &_
								  "		 left outer join estados_detalle_ingresos d  " & vbCrLf &_
								  "				on c.edin_ccod = d.edin_ccod " & vbCrLf &_
								  "		  where protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0   " & vbCrLf &_
								  "			and a.ecom_ccod = '1'   " & vbCrLf &_
								  "			and b.ecom_ccod = '1'   " & vbCrLf &_
					              "    and cast(a.pers_ncorr as varchar) = '" & v_pers_ncorr & "'"
							


'		sql_todos_compromisos_pendientes = "select b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, b.comp_ndocto as c_comp_ndocto," & vbCrLf &_
'											"        b.tcom_ccod as c_tcom_ccod, cast(b.dcom_ncompromiso as varchar) + ' / ' + cast(a.comp_ncuotas  as varchar) as ncuota," & vbCrLf &_
'											"        a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso," & vbCrLf &_
'											"        protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod," & vbCrLf &_
'											"        protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as ding_ndocto," & vbCrLf &_
'											"        protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos," & vbCrLf &_
'											"        protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado," & vbCrLf &_
'											"	    protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo," & vbCrLf &_
'											"(select d.edin_ccod" & vbCrLf &_
'											"from estados_detalle_ingresos d" & vbCrLf &_
'											"where c.edin_ccod = d.edin_ccod ) as edin_ccod," & vbCrLf &_
'											"(select d.edin_tdesc" & vbCrLf &_
'											"from estados_detalle_ingresos d" & vbCrLf &_
'											"where c.edin_ccod = d.edin_ccod ) as edin_tdesc," & vbCrLf &_
'											"(select d.udoc_ccod" & vbCrLf &_
'											"from estados_detalle_ingresos d" & vbCrLf &_
'											"where c.edin_ccod = d.edin_ccod ) as udoc_ccod" & vbCrLf &_
'											"from compromisos a, detalle_compromisos b,detalle_ingresos c" & vbCrLf &_
'											"where a.tcom_ccod = b.tcom_ccod" & vbCrLf &_
'											"    and a.inst_ccod = b.inst_ccod" & vbCrLf &_
'											"    and a.comp_ndocto = b.comp_ndocto" & vbCrLf &_
'											"    and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') *= c.ting_ccod" & vbCrLf &_
'											"    and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') *= c.ding_ndocto" & vbCrLf &_
'											"    and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') *= c.ingr_ncorr" & vbCrLf &_
'											"    and protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0" & vbCrLf &_
'											"    and a.ecom_ccod = '1'" & vbCrLf &_
'											"    and b.ecom_ccod = '1'" & vbCrLf &_
'											"    and cast(a.pers_ncorr as varchar) = '" & v_pers_ncorr & "'"
		'response.Write("<pre>"&sql_todos_compromisos_pendientes&"</pre>")																						
		'sql_todos_compromisos_pendientes = "select b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, b.comp_ndocto as c_comp_ndocto, b.tcom_ccod as c_tcom_ccod, b.dcom_ncompromiso || ' / ' || a.comp_ncuotas as ncuota, a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso, " & vbCrLf &_
		'                                      "       documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod,   " & vbCrLf &_
		'									  "       documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as ding_ndocto,   " & vbCrLf &_
		'									  "       total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos, " & vbCrLf &_
		'									  "       total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado, " & vbCrLf &_
		'									  "	   total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo, " & vbCrLf &_
		'									  "	   d.edin_ccod, d.edin_tdesc, d.udoc_ccod   " & vbCrLf &_
		'									  "from compromisos a, detalle_compromisos b, detalle_ingresos c, estados_detalle_ingresos d  " & vbCrLf &_
		'									  "where a.tcom_ccod = b.tcom_ccod   " & vbCrLf &_
		'									  "  and a.inst_ccod = b.inst_ccod   " & vbCrLf &_
		'									  "  and a.comp_ndocto = b.comp_ndocto   " & vbCrLf &_
		'									  "  and documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod (+) " & vbCrLf &_
		'									  "  and documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto (+) " & vbCrLf &_
		'									  "  and documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr (+) " & vbCrLf &_
		'									  "  and c.edin_ccod = d.edin_ccod (+) " & vbCrLf &_
		'									  "  and total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0 " & vbCrLf &_
		'									  "  and a.ecom_ccod = '1' " & vbCrLf &_
		'									  "  and b.ecom_ccod = '1' " & vbCrLf &_
		'									  "  and a.pers_ncorr = '" & v_pers_ncorr & "'"
														  
											  
		'LOS COMPROMISOS PENDIENTES QUE NO PUEDEN SER RECEPCIONADOS POR EL CAJERO 				  
		sql_compromisos_pendientes_no_pagar = sql_todos_compromisos_pendientes & vbCrLf &_
											  "and b.tcom_ccod+ b.inst_ccod+ b.comp_ndocto+ b.dcom_ncompromiso NOT in (" & vbCrLf &_
											  sql_compromisos_pagar_sinorder&")"
											  'response.Write("<hr><pre>"&sql_compromisos_pendientes_no_pagar&"</pre>")
							  
		'CREDITOS en uf
		
'		sql_creditos = "select b.cont_ncorr, d.paga_ncorr, d.paga_npagare, e.stde_ccod, e.stde_tdesc," & vbCrLf &_
'						"        isnull(c.bene_mmonto_matricula, 0) + isnull(c.bene_mmonto_colegiatura, 0) as bene_mmonto," & vbCrLf &_
'						"        c.mone_ccod, c.bene_nporcentaje_colegiatura as bene_nporcentaje, c.ufom_ncorr, " & vbCrLf &_
'						"        e.tben_ccod, c.bene_fbeneficio, f.sdes_mcolegiatura, g.ufom_mvalor," & vbCrLf &_
'						"        (isnull(c.bene_mmonto_matricula, 0) + isnull(c.bene_mmonto_colegiatura, 0)) * g.ufom_mvalor as monto_credito," & vbCrLf &_
'						"        d.epag_ccod, c.bene_mmonto_acum_colegiatura " & vbCrLf &_
'						"            from postulantes a, contratos b, beneficios c, pagares d, stipos_descuentos e, sdescuentos f, uf g " & vbCrLf &_
'						"            where a.post_ncorr = b.post_ncorr " & vbCrLf &_
'						"              and b.cont_ncorr = c.cont_ncorr " & vbCrLf &_
'						"              and c.paga_ncorr *= d.paga_ncorr " & vbCrLf &_
'						"              and c.stde_ccod = e.stde_ccod " & vbCrLf &_
'						"              and a.post_ncorr = f.post_ncorr " & vbCrLf &_
'						"              and a.ofer_ncorr = f.ofer_ncorr " & vbCrLf &_
'						"              and c.stde_ccod = f.stde_ccod " & vbCrLf &_
'						"              and c.ufom_ncorr = g.ufom_ncorr " & vbCrLf &_
'						"              and e.tben_ccod = 1 " & vbCrLf &_
'						"              and b.econ_ccod = '1' " & vbCrLf &_
'						"              and c.eben_ccod = '1' " & vbCrLf &_
'						"              and cast(a.pers_ncorr as varchar) = '" & v_pers_ncorr & "'" & vbCrLf &_
'						"            order by c.bene_fbeneficio asc"

			sql_creditos = "select b.cont_ncorr, d.paga_ncorr, d.paga_npagare, e.stde_ccod, e.stde_tdesc," & vbCrLf &_
						"        isnull(c.bene_mmonto_matricula, 0) + isnull(c.bene_mmonto_colegiatura, 0) as bene_mmonto," & vbCrLf &_
						"        c.mone_ccod, c.bene_nporcentaje_colegiatura as bene_nporcentaje, c.ufom_ncorr, " & vbCrLf &_
						"        e.tben_ccod, c.bene_fbeneficio, f.sdes_mcolegiatura, g.ufom_mvalor," & vbCrLf &_
						"        (isnull(c.bene_mmonto_matricula, 0) + isnull(c.bene_mmonto_colegiatura, 0)) * g.ufom_mvalor as monto_credito," & vbCrLf &_
						"        d.epag_ccod, c.bene_mmonto_acum_colegiatura " & vbCrLf &_
						"            from postulantes a INNER JOIN contratos b " & vbCrLf &_
						"              ON a.post_ncorr = b.post_ncorr " & vbCrLf &_
						"              INNER JOIN beneficios c " & vbCrLf &_
						"              ON b.cont_ncorr = c.cont_ncorr " & vbCrLf &_
						"              LEFT OUTER JOIN pagares d " & vbCrLf &_
						"              ON c.paga_ncorr = d.paga_ncorr " & vbCrLf &_
						"              INNER JOIN stipos_descuentos e " & vbCrLf &_
						"              ON c.stde_ccod = e.stde_ccod " & vbCrLf &_
						"              INNER JOIN  sdescuentos f " & vbCrLf &_
						"              ON a.post_ncorr = f.post_ncorr and a.ofer_ncorr = f.ofer_ncorr and c.stde_ccod = f.stde_ccod " & vbCrLf &_
						"              INNER JOIN uf g " & vbCrLf &_
						"              ON c.ufom_ncorr = g.ufom_ncorr " & vbCrLf &_
						"              WHERE e.tben_ccod = 1 " & vbCrLf &_
						"              and b.econ_ccod = '1' " & vbCrLf &_
						"              and c.eben_ccod = '1' " & vbCrLf &_
						"              and cast(a.pers_ncorr as varchar) = '" & v_pers_ncorr & "'" & vbCrLf &_
						"            order by c.bene_fbeneficio asc"

   '---------------------------------------------------------------------------------------------------------------
   'CREDITOS en pesos 
   'SOLICITADO PARA UPACIFICO
		
'		sql_creditos = "select b.cont_ncorr, d.paga_ncorr, d.paga_npagare, e.stde_ccod, e.stde_tdesc," & vbCrLf &_
'						"        isnull(c.bene_mmonto_matricula, 0) + isnull(c.bene_mmonto_colegiatura, 0) as bene_mmonto," & vbCrLf &_
'						"        c.mone_ccod, c.bene_nporcentaje_colegiatura as bene_nporcentaje, c.ufom_ncorr, " & vbCrLf &_
'						"        e.tben_ccod, c.bene_fbeneficio, f.sdes_mcolegiatura, " & vbCrLf &_
'						"        (isnull(c.bene_mmonto_matricula, 0) + isnull(c.bene_mmonto_colegiatura, 0)) as monto_credito," & vbCrLf &_
'						"        d.epag_ccod, c.bene_mmonto_acum_colegiatura " & vbCrLf &_
'						"            from postulantes a, contratos b, beneficios c, pagares d, stipos_descuentos e, sdescuentos f " & vbCrLf &_
'						"            where a.post_ncorr = b.post_ncorr " & vbCrLf &_
'						"              and b.cont_ncorr = c.cont_ncorr " & vbCrLf &_
'						"              and c.paga_ncorr *= d.paga_ncorr " & vbCrLf &_
'						"              and c.stde_ccod = e.stde_ccod " & vbCrLf &_
'						"              and a.post_ncorr = f.post_ncorr " & vbCrLf &_
'						"              and a.ofer_ncorr = f.ofer_ncorr " & vbCrLf &_
'						"              and c.stde_ccod = f.stde_ccod " & vbCrLf &_
'						"              and e.tben_ccod = 1 " & vbCrLf &_
'						"              and b.econ_ccod = '1' " & vbCrLf &_
'						"              and c.eben_ccod = '1' " & vbCrLf &_
'						"              and cast(a.pers_ncorr as varchar) = '" & v_pers_ncorr & "'" & vbCrLf &_
'						"            order by c.bene_fbeneficio asc"

		sql_creditos = "select b.cont_ncorr, d.paga_ncorr, d.paga_npagare, e.stde_ccod, e.stde_tdesc," & vbCrLf &_
						"        isnull(c.bene_mmonto_matricula, 0) + isnull(c.bene_mmonto_colegiatura, 0) as bene_mmonto," & vbCrLf &_
						"        c.mone_ccod, c.bene_nporcentaje_colegiatura as bene_nporcentaje, c.ufom_ncorr, " & vbCrLf &_
						"        e.tben_ccod, c.bene_fbeneficio, f.sdes_mcolegiatura, " & vbCrLf &_
						"        (isnull(c.bene_mmonto_matricula, 0) + isnull(c.bene_mmonto_colegiatura, 0)) as monto_credito," & vbCrLf &_
						"        d.epag_ccod, c.bene_mmonto_acum_colegiatura " & vbCrLf &_
						"            from postulantes a INNER JOIN contratos b " & vbCrLf &_
						"              ON a.post_ncorr = b.post_ncorr " & vbCrLf &_
						"              INNER JOIN beneficios c " & vbCrLf &_
						"              ON b.cont_ncorr = c.cont_ncorr " & vbCrLf &_
						"              LEFT OUTER JOIN pagares d " & vbCrLf &_
						"              ON c.paga_ncorr = d.paga_ncorr " & vbCrLf &_
						"              INNER JOIN stipos_descuentos e " & vbCrLf &_
						"              ON c.stde_ccod = e.stde_ccod " & vbCrLf &_
						"              INNER JOIN sdescuentos f " & vbCrLf &_
						"              ON a.post_ncorr = f.post_ncorr and a.ofer_ncorr = f.ofer_ncorr and c.stde_ccod = f.stde_ccod " & vbCrLf &_
						"              WHERE e.tben_ccod = 1 " & vbCrLf &_
						"              and b.econ_ccod = '1' " & vbCrLf &_
						"              and c.eben_ccod = '1' " & vbCrLf &_
						"              and cast(a.pers_ncorr as varchar) = '" & v_pers_ncorr & "'" & vbCrLf &_
						"            order by c.bene_fbeneficio asc"

    '---------------------------------------------------------------------------------------------------------------  
   		 'response.Write("<pre>" & sql_creditos & "</pre>")				
		
		'sql_creditos = "select b.cont_ncorr, d.paga_ncorr, d.paga_npagare, e.stde_ccod, e.stde_tdesc, nvl(c.bene_mmonto_matricula, 0) + nvl(c.bene_mmonto_colegiatura, 0) as bene_mmonto, c.mone_ccod, c.bene_nporcentaje_colegiatura as bene_nporcentaje, c.ufom_ncorr, " & vbCrLf &_
		'               "       e.tben_ccod, c.bene_fbeneficio, f.sdes_mcolegiatura, g.ufom_mvalor, (nvl(c.bene_mmonto_matricula, 0) + nvl(c.bene_mmonto_colegiatura, 0)) * g.ufom_mvalor as monto_credito, d.epag_ccod, c.bene_mmonto_acum_colegiatura " & vbCrLf &_
		'			   "from postulantes a, contratos b, beneficios c, pagares d, stipos_descuentos e, sdescuentos f, uf g " & vbCrLf &_
		'			   "where a.post_ncorr = b.post_ncorr " & vbCrLf &_
		'			   "  and b.cont_ncorr = c.cont_ncorr " & vbCrLf &_
		'			   "  and c.paga_ncorr = d.paga_ncorr (+) " & vbCrLf &_
		'			   "  and c.stde_ccod = e.stde_ccod " & vbCrLf &_
		'			   "  and a.post_ncorr = f.post_ncorr " & vbCrLf &_
		'			   "  and a.ofer_ncorr = f.ofer_ncorr " & vbCrLf &_
		'			   "  and c.stde_ccod = f.stde_ccod " & vbCrLf &_
		'			   "  and c.ufom_ncorr = g.ufom_ncorr " & vbCrLf &_					   
		'			   "  and e.tben_ccod = 1 " & vbCrLf &_
		'			   "  and b.econ_ccod = '1' " & vbCrLf &_
		'			   "  and c.eben_ccod = '1' " & vbCrLf &_
		'			   "  and a.pers_ncorr = '" & v_pers_ncorr & "'" & vbCrLf &_
		'			   "order by c.bene_fbeneficio asc"
							
		'BECAS Y DESCUENTOS 
		
		sql_becas_descuentos = 	" Select contrato,cont_ncorr, stde_ccod, stde_tdesc, bene_mmonto,mone_ccod,bene_nporcentaje_matricula,bene_nporcentaje_colegiatura,tben_ccod,max(bene_fbeneficio) as bene_fbeneficio "& vbCrLf &_
								" From ( "& vbCrLf &_
								" select isnull(b.contrato,b.cont_ncorr) as contrato,b.peri_ccod,b.cont_ncorr, e.stde_ccod, e.stde_tdesc," & vbCrLf &_
								"        isnull(c.bene_mmonto_matricula, 0) + isnull(c.bene_mmonto_colegiatura, 0) as bene_mmonto," & vbCrLf &_
								"        c.mone_ccod, c.bene_nporcentaje_matricula, c.bene_nporcentaje_colegiatura, e.tben_ccod, c.bene_fbeneficio " & vbCrLf &_
								"            from postulantes a, contratos b, beneficios c, stipos_descuentos e " & vbCrLf &_
								"            where a.post_ncorr = b.post_ncorr " & vbCrLf &_
								"              and b.cont_ncorr = c.cont_ncorr " & vbCrLf &_
								"              and c.stde_ccod = e.stde_ccod " & vbCrLf &_
								"              and e.tben_ccod <> 1 " & vbCrLf &_
								"              and b.econ_ccod = '1' " & vbCrLf &_
								"              and c.eben_ccod = '1' " & vbCrLf &_
								"              and b.econ_ccod <> 3 " & vbCrLf &_
								"              and cast(a.pers_ncorr as varchar) = '" & v_pers_ncorr & "'" & vbCrLf &_			
								"union " & vbCrLf &_
								"	select isnull(k.contrato,k.cont_ncorr) as contrato,k.peri_ccod, k.cont_ncorr, a.stde_ccod, b.tdet_tdesc as stde_tdesc, " & vbCrLf &_
								"		cast(isnull(a.sdes_mmatricula, 0) + isnull(a.sdes_mcolegiatura, 0) as int) as bene_mmonto, " & vbCrLf &_
								"			1 as mone_ccod,a.sdes_nporc_matricula as bene_nporcentaje_matricula,a.sdes_nporc_colegiatura as bene_nporcentaje_colegiatura, " & vbCrLf &_
								"		i.tben_ccod, cont_fcontrato as bene_fbeneficio " & vbCrLf &_
								"		from sdescuentos a,tipos_detalle b,sestados_descuentos c, " & vbCrLf &_
								"			  postulantes d,ofertas_academicas e,personas_postulante f, " & vbCrLf &_
								"			  especialidades g,carreras h,tipos_beneficios i,sedes j, contratos k " & vbCrLf &_
								"		where a.stde_ccod = b.tdet_ccod " & vbCrLf &_
								"			and a.esde_ccod = c.esde_ccod  " & vbCrLf &_
								"			and a.post_ncorr = d.post_ncorr  " & vbCrLf &_
								"			and a.ofer_ncorr = d.ofer_ncorr " & vbCrLf &_
								"			and d.ofer_ncorr = e.ofer_ncorr  " & vbCrLf &_
								"			and d.pers_ncorr = f.pers_ncorr " & vbCrLf &_
								"			and e.espe_ccod = g.espe_ccod  " & vbCrLf &_
								"			and g.carr_ccod = h.carr_ccod " & vbCrLf &_
								"			and e.sede_ccod = j.sede_ccod   " & vbCrLf &_
								"			and b.tben_ccod = i.tben_ccod  " & vbCrLf &_
								"			and d.post_ncorr= k.post_ncorr " & vbCrLf &_
								"			and k.econ_ccod <> 3 " & vbCrLf &_
								"			and a.esde_ccod=1 " & vbCrLf &_
								"			and cast(f.pers_ncorr as varchar) ='" & v_pers_ncorr & "'" & vbCrLf &_													
								" ) as tabla  "&v_sql_credito&" " & vbCrLf &_
 								" group by contrato,cont_ncorr, stde_ccod, stde_tdesc, bene_mmonto,mone_ccod,bene_nporcentaje_matricula,bene_nporcentaje_colegiatura,tben_ccod"

		
		
		'response.Write("<pre>"&sql_becas_descuentos&"</pre>")								
		  
						   
		   
		sql_resumen_detalle_compromisos = "select a.pers_ncorr, " & vbCrLf &_
		                                  "       sum(b.dcom_mcompromiso) as total_compromisos,  " & vbCrLf &_
										  "       sum(protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)) as abonos, " & vbCrLf &_
										  "       sum(protic.total_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)) as documentado, " & vbCrLf &_
										  "	   sum(isnull(b.dcom_mcompromiso, 0) - protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)) as saldo  " & vbCrLf &_
										  "from compromisos a, detalle_compromisos b  " & vbCrLf &_
										  "where a.tcom_ccod = b.tcom_ccod  " & vbCrLf &_
										  "  and a.inst_ccod = b.inst_ccod  " & vbCrLf &_
										  "  and a.comp_ndocto = b.comp_ndocto   " & vbCrLf &_
										  "  and a.ecom_ccod = '1'  " & vbCrLf &_
										  "  and b.ecom_ccod = '1'  " & vbCrLf &_
										  "  and cast(a.pers_ncorr as varchar) = '" & v_pers_ncorr & "' " & vbCrLf &_
										  " "&v_sql&" "& vbCrLf &_										  
										  "group by a.pers_ncorr"						
										  'response.Write("<pre>"&sql_resumen_detalle_compromisos&"</pre>")
										  
'		sql_morosos = "select a.pers_ncorr,b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso," & vbCrLf &_
'					"        b.comp_ndocto as c_comp_ndocto, b.tcom_ccod as c_tcom_ccod," & vbCrLf &_
'					"        cast(b.dcom_ncompromiso as varchar)+ ' / ' + a.comp_ncuotas as c_dcom_ncompromiso," & vbCrLf &_
'					"        a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso," & vbCrLf &_
'					"        protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod,   " & vbCrLf &_
'					"		protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as ding_ndocto," & vbCrLf &_
'					"        isnull(b.dcom_mcompromiso, 0) - protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo," & vbCrLf &_
'					"    (select d.edin_ccod from estados_detalle_ingresos d" & vbCrLf &_
'					"        where c.edin_ccod = d.edin_ccod" & vbCrLf &_
'					"            and isnull(d.udoc_ccod, 1) = 1 " & vbCrLf &_
'					"            and isnull(d.edin_ccod, 0) = case c.ting_ccod when 4 then 3 else 0 end) as edin_ccod," & vbCrLf &_
'					"    (select d.edin_tdesc from estados_detalle_ingresos d" & vbCrLf &_
'					"        where c.edin_ccod = d.edin_ccod" & vbCrLf &_
'					"            and isnull(d.udoc_ccod, 1) = 1 " & vbCrLf &_
'					"            and isnull(d.edin_ccod, 0) = case c.ting_ccod when 4 then 3 else 0 end) as edin_tdesc," & vbCrLf &_
'					"    (select d.udoc_ccod from estados_detalle_ingresos d" & vbCrLf &_
'					"        where c.edin_ccod = d.edin_ccod" & vbCrLf &_
'					"            and isnull(d.udoc_ccod, 1) = 1 " & vbCrLf &_
'					"            and isnull(d.edin_ccod, 0) = case c.ting_ccod when 4 then 3 else 0 end) as udoc_ccod" & vbCrLf &_
'					"    from compromisos a,detalle_compromisos b,detalle_ingresos c" & vbCrLf &_
'					"        where a.tcom_ccod = b.tcom_ccod" & vbCrLf &_
'					"            and a.inst_ccod = b.inst_ccod" & vbCrLf &_
'					"            and a.comp_ndocto = b.comp_ndocto     " & vbCrLf &_
'					"            and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') *= c.ting_ccod" & vbCrLf &_
'					"            and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') *= c.ding_ndocto" & vbCrLf &_
'					"            and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') *= c.ingr_ncorr" & vbCrLf &_
'					"            and isnull(protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod'), 6) <> 3  " & vbCrLf &_
'					"            and isnull(b.dcom_mcompromiso, 0) - protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0 " & vbCrLf &_
'					"            and a.ecom_ccod = '1' " & vbCrLf &_
'					"            and b.ecom_ccod = '1' " & vbCrLf &_
'					"            and convert(datetime,b.dcom_fcompromiso,103) < convert(datetime,'31/01/2004',103)"

		sql_morosos = "select a.pers_ncorr,b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso," & vbCrLf &_
					"        b.comp_ndocto as c_comp_ndocto, b.tcom_ccod as c_tcom_ccod," & vbCrLf &_
					"        cast(b.dcom_ncompromiso as varchar)+ ' / ' + a.comp_ncuotas as c_dcom_ncompromiso," & vbCrLf &_
					"        a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso," & vbCrLf &_
					"        protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod,   " & vbCrLf &_
					"		protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as ding_ndocto," & vbCrLf &_
					"        isnull(b.dcom_mcompromiso, 0) - protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo," & vbCrLf &_
					"    (select d.edin_ccod from estados_detalle_ingresos d" & vbCrLf &_
					"        where c.edin_ccod = d.edin_ccod" & vbCrLf &_
					"            and isnull(d.udoc_ccod, 1) = 1 " & vbCrLf &_
					"            and isnull(d.edin_ccod, 0) = case c.ting_ccod when 4 then 3 else 0 end) as edin_ccod," & vbCrLf &_
					"    (select d.edin_tdesc from estados_detalle_ingresos d" & vbCrLf &_
					"        where c.edin_ccod = d.edin_ccod" & vbCrLf &_
					"            and isnull(d.udoc_ccod, 1) = 1 " & vbCrLf &_
					"            and isnull(d.edin_ccod, 0) = case c.ting_ccod when 4 then 3 else 0 end) as edin_tdesc," & vbCrLf &_
					"    (select d.udoc_ccod from estados_detalle_ingresos d" & vbCrLf &_
					"        where c.edin_ccod = d.edin_ccod" & vbCrLf &_
					"            and isnull(d.udoc_ccod, 1) = 1 " & vbCrLf &_
					"            and isnull(d.edin_ccod, 0) = case c.ting_ccod when 4 then 3 else 0 end) as udoc_ccod" & vbCrLf &_
					"    from compromisos a INNER JOIN detalle_compromisos b " & vbCrLf &_
					"			ON a.tcom_ccod = b.tcom_ccod and a.inst_ccod = b.inst_ccod and a.comp_ndocto = b.comp_ndocto " & vbCrLf &_
					"            LEFT OUTER JOIN detalle_ingresos c " & vbCrLf &_
					"            ON protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod " & vbCrLf &_
					"            and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto " & vbCrLf &_
					"            and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr " & vbCrLf &_
					"            WHERE isnull(protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod'), 6) <> 3  " & vbCrLf &_
					"            and isnull(b.dcom_mcompromiso, 0) - protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0 " & vbCrLf &_
					"            and a.ecom_ccod = '1' " & vbCrLf &_
					"            and b.ecom_ccod = '1' " & vbCrLf &_
					"            and convert(datetime,b.dcom_fcompromiso,103) < convert(datetime,'31/01/2004',103)"
			 								  				  
		'sql_morosos= " select  pers_nrut|| ' ' || pers_xdv as rut, " & vbCrLf &_
		'                        " pers_tape_paterno || ' ' || pers_tape_materno || ' ' || pers_tnombre as nombre ,sum(saldo) as morosidad" & vbCrLf &_
		'					    " FROM (select a.pers_ncorr,b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, b.comp_ndocto as c_comp_ndocto, b.tcom_ccod as c_tcom_ccod, b.dcom_ncompromiso || ' / ' || a.comp_ncuotas as c_dcom_ncompromiso, a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso, " & vbCrLf &_
		'					    "		   documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod,   " & vbCrLf &_
		'						"		   documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as ding_ndocto,   " & vbCrLf &_
		'						"		   total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos, " & vbCrLf &_
		'						"		   nvl(b.dcom_mcompromiso, 0) - total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo, " & vbCrLf &_
		'						"		   d.edin_ccod, d.edin_tdesc, d.udoc_ccod   " & vbCrLf &_
		'						"	from compromisos a, detalle_compromisos b, detalle_ingresos c, estados_detalle_ingresos d  " & vbCrLf &_
		'						"	where a.tcom_ccod = b.tcom_ccod   " & vbCrLf &_
		'						"	  and a.inst_ccod = b.inst_ccod   " & vbCrLf &_
		'						"	  and a.comp_ndocto = b.comp_ndocto   " & vbCrLf &_
		'						"	  and documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod (+) " & vbCrLf &_
		'						"	  and documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto (+) " & vbCrLf &_
		'						"	  and documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr (+) " & vbCrLf &_
		'						"	  and c.edin_ccod = d.edin_ccod (+) " & vbCrLf &_
		'						"	  and nvl(documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod'), 6) <> 3  " & vbCrLf &_
		'						"	  and nvl(b.dcom_mcompromiso, 0) - total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0 " & vbCrLf &_
		'						"	  and nvl(d.udoc_ccod, 1) = 1 " & vbCrLf &_
		'						"	  and nvl(d.edin_ccod, 0) = decode(c.ting_ccod, 4, 3, 0)  " & vbCrLf &_
		'						"	  and a.ecom_ccod = '1' " & vbCrLf &_
		'						"	  and b.ecom_ccod = '1' " & vbCrLf &_
		'						"	  AND b.dcom_fcompromiso < TO_DATE('31/01/2001','dd/mm/yyyy') " & vbCrLf &_
		'						" order by dcom_fcompromiso asc, dcom_ncompromiso asc, tcom_ccod asc)  a, " & vbCrLf &_
		'						"  personas b " & vbCrLf &_
		'						" where a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
		'						" group by pers_nrut, pers_xdv, pers_tape_paterno,pers_tape_materno,pers_tnombre " 
		'		response.Write("<pre>" & sql_morosos & "</pre>")								
								
	'sql_compromisos_en_notaria = sql_compromisos_pagar
	
	sql_resumen_caja_pendiente=" select     a.pers_ncorr," & vbCrLf &_
								"          sum(b.dcom_mcompromiso) as total_compromisos," & vbCrLf &_
								"			sum(protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)) as abonos, " & vbCrLf &_
								"			sum(protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)) as documentado," & vbCrLf &_ 
								"			sum(protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)) as saldo " & vbCrLf &_
								"	 from " & vbCrLf &_
								"		compromisos a " & vbCrLf &_
								"		join detalle_compromisos b " & vbCrLf &_
								"			on a.tcom_ccod = b.tcom_ccod   " & vbCrLf &_
								"			and a.inst_ccod = b.inst_ccod    " & vbCrLf &_
								"			and a.comp_ndocto = b.comp_ndocto " & vbCrLf &_
								"		left outer join detalle_ingresos c " & vbCrLf &_
								"			on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod   " & vbCrLf &_
								"			   and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto  " & vbCrLf &_
								"			   and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr    " & vbCrLf &_
								"		left join estados_detalle_ingresos d   " & vbCrLf &_
								"			on c.edin_ccod = d.edin_ccod " & vbCrLf &_
								"	 where protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0  " & vbCrLf &_
								"	   and isnull(d.udoc_ccod, 1) = 1  " & vbCrLf &_
								"	   and ( (c.ting_ccod is null) or  " & vbCrLf &_
								"			 (c.ting_ccod = 4 and d.edin_ccod not in (6) ) or  " & vbCrLf &_
								"			 (c.ting_ccod = 5 and d.edin_ccod not in (6) ) or  "& vbCrLf &_
								"			  (c.ting_ccod in (2, 50)) or  " & vbCrLf &_
								"			  (c.ting_ccod in (3,38) and d.edin_ccod not in (6, 12, 51)) or " & vbCrLf &_
								"    		  (c.ting_ccod = 52 and d.edin_ccod not in (6) ) or "& vbCrLf &_
								"    		  (c.ting_ccod = 87 and d.edin_ccod not in (6) ) or "& vbCrLf &_
								"    		  (c.ting_ccod = 88 and d.edin_ccod not in (6) ) "& vbCrLf &_
								"			)  " & vbCrLf &_
								"	   and a.ecom_ccod = '1'  " & vbCrLf &_
								"	   and b.ecom_ccod = '1'  " & vbCrLf &_
								"  	and cast(a.pers_ncorr  as varchar)= '" & v_pers_ncorr & "' " & vbCrLf &_
								"	group by a.pers_ncorr"

'response.Write("<pre>"&sql_resumen_caja_pendiente&"</pre>")

	sql_resumen_caja_otros_pendiente =" select a.pers_ncorr, " & vbCrLf &_
										"      sum(b.dcom_mcompromiso) as total_compromisos,  " & vbCrLf &_
										"      sum(protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)) as abonos, " & vbCrLf &_
										"      sum(protic.total_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)) as documentado, " & vbCrLf &_
										"	   sum(isnull(b.dcom_mcompromiso, 0) - protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)) as saldo " & vbCrLf &_      
										"		  from  " & vbCrLf &_
										"		  compromisos a  " & vbCrLf &_
										"		  join detalle_compromisos b  " & vbCrLf &_
										"			on a.tcom_ccod = b.tcom_ccod " & vbCrLf &_    
										"				and a.inst_ccod = b.inst_ccod " & vbCrLf &_    
										"				and a.comp_ndocto = b.comp_ndocto " & vbCrLf &_
										"		  left outer join detalle_ingresos c " & vbCrLf &_
										"				on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')    = c.ting_ccod    " & vbCrLf &_
										"				and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto    " & vbCrLf &_
										"				and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')  = c.ingr_ncorr   " & vbCrLf &_
										"		 left outer join estados_detalle_ingresos d  " & vbCrLf &_
										"				on c.edin_ccod = d.edin_ccod " & vbCrLf &_
										"		  where protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0   " & vbCrLf &_
										"			and a.ecom_ccod = '1'   " & vbCrLf &_
										"			and b.ecom_ccod = '1'   " & vbCrLf &_
										"    and cast(a.pers_ncorr as varchar) = '" & v_pers_ncorr & "'" & vbCrLf &_
										"and b.tcom_ccod+ b.inst_ccod+ b.comp_ndocto+ b.dcom_ncompromiso NOT in ( " & vbCrLf &_
										" select  " & vbCrLf &_
										"			b.tcom_ccod+ b.inst_ccod+ b.comp_ndocto+ b.dcom_ncompromiso " & vbCrLf &_
										"	 from " & vbCrLf &_
										"		compromisos a " & vbCrLf &_
										"		join detalle_compromisos b " & vbCrLf &_
										"			on a.tcom_ccod = b.tcom_ccod   " & vbCrLf &_
										"			and a.inst_ccod = b.inst_ccod    " & vbCrLf &_
										"			and a.comp_ndocto = b.comp_ndocto " & vbCrLf &_
										"		left outer join detalle_ingresos c " & vbCrLf &_
										"			on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod   " & vbCrLf &_
										"			   and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto  " & vbCrLf &_
										"			   and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr " & vbCrLf &_   
										"		left join estados_detalle_ingresos d   " & vbCrLf &_
										"			on c.edin_ccod = d.edin_ccod " & vbCrLf &_
										"	 where protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0  " & vbCrLf &_
										"	   and isnull(d.udoc_ccod, 1) = 1  " & vbCrLf &_
										"	   and ( (c.ting_ccod is null) or  " & vbCrLf &_
										"			 (c.ting_ccod = 4 and d.edin_ccod not in (6) ) or  " & vbCrLf &_
										"			 (c.ting_ccod = 5 and d.edin_ccod not in (6) ) or  "& vbCrLf &_
										"			  (c.ting_ccod in (2, 50)) or  " & vbCrLf &_
										"			  (c.ting_ccod in (3,38) and d.edin_ccod not in (6, 12, 51)) or  " & vbCrLf &_
										"    		  (c.ting_ccod = 52 and d.edin_ccod not in (6) ) or "& vbCrLf &_
										"    		  (c.ting_ccod = 87 and d.edin_ccod not in (6) ) or "& vbCrLf &_
										"    		  (c.ting_ccod = 88 and d.edin_ccod not in (6) ) "& vbCrLf &_
										"			)  " & vbCrLf &_
										"	   and a.ecom_ccod = '1' " & vbCrLf &_  
										"	   and b.ecom_ccod = '1'  " & vbCrLf &_
										"  	and cast(a.pers_ncorr  as varchar)= '" & v_pers_ncorr & "') " & vbCrLf &_
										"    group by a.pers_ncorr " & vbCrLf 

				
	End Sub
	
		
	'Function ObtenerSqlDetalleCompromisos
	'	ObtenerSqlDetalleCompromisos = sql_detalle_compromisos
	'End Function
	
	'Function ObtenerSqlCreditos
	'	ObtenerSqlCreditos = sql_creditos
	'End Function
	
	'Function ObtenerSqlBecasDescuentos
	'	ObtenerSqlBecasDescuentos = sql_becas_descuentos
	'End Function
	
	Function ObtenerSql(p_tipo)
		select case p_tipo
			case "DETALLE_COMPROMISOS"
				ObtenerSql = sql_detalle_compromisos
			case "CREDITOS"
				ObtenerSql = sql_creditos
			case "BECAS_DESCUENTOS"
				ObtenerSql = sql_becas_descuentos
			case "COMPROMISOS_PENDIENTES_NO_PAGAR"
				ObtenerSql = sql_compromisos_pendientes_no_pagar
			case "COMPROMISOS_PAGAR"
				ObtenerSql = sql_compromisos_pagar
			case "MOROSOS"
				ObtenerSql = sql_morosos
			case "TODOS_COMPROMISOS_PENDIENTES"
				ObtenerSql = sql_todos_compromisos_pendientes
			case "COMPROMISOS_EN_COBRANZA"
			    ObtenerSql = sql_compromisos_en_cobranza
			case else
				ObtenerSql = ""
		end select
	End Function
	
		
		
	Sub Dibuja(p_consulta, p_formulario)
		dim salida
		
		set formulario = new CFormulario
		formulario.Carga_Parametros "class_cuenta_corriente.xml", p_formulario
		formulario.Inicializar conexion
		formulario.Consultar p_consulta
		
		nFilasDibujadas = formulario.NroFilas
				
		salida = "<table width='100%'  border='0' cellpadding='0' cellspacing='0'>" & Chr(13)
		salida = salida & "<tr><td>" & Chr(13)
		salida = salida & "<div align='right'>" & Chr(13)		
		Response.Write(salida)
		salida = ""
		formulario.AccesoPagina
		
		salida = salida & "</div>" & Chr(13)
		salida = salida & "</td></tr>" & Chr(13)
		salida = salida & "<tr><td>"		
		Response.Write(salida)
		salida = ""		
		formulario.DibujaTabla
		
		salida = salida & "</td></tr>" & Chr(13)
		salida = salida & "<tr><td><div align='center'><br>" & Chr(13)		
		Response.Write(salida)
		salida = ""
		formulario.Pagina	
		
		salida = salida & "</div></td></tr>" & Chr(13)
		salida = salida & "</table>"
		
		Response.Write(salida)
	End Sub
			
	Function NroFilasDibujadas
		NroFilasDibujadas = nFilasDibujadas
	End Function
	
	Sub DibujaCreditos
		Me.Dibuja Me.ObtenerSql("CREDITOS"), "creditos"
	End Sub
		
	Sub DibujaBecasDescuentos
		Me.Dibuja Me.ObtenerSql("BECAS_DESCUENTOS"), "becas_descuentos"
	End Sub
	
	Sub DibujaDetalleCompromisos
		Me.Dibuja Me.ObtenerSql("DETALLE_COMPROMISOS"), "detalle_compromisos"
	End Sub	
	
	Sub DibujaCompromisosPorPagar
		Me.Dibuja Me.ObtenerSql("COMPROMISOS_PAGAR"), "compromisos_por_pagar"
	End Sub
		
	Sub DibujaCompromisosPendientes
		Me.Dibuja Me.ObtenerSql("COMPROMISOS_PENDIENTES_NO_PAGAR"), "detalle_compromisos_no_edicion"
	End Sub
		
	Sub DibujaTodosCompromisosPendientesPagar
		Me.Dibuja Me.ObtenerSql("TODOS_COMPROMISOS_PENDIENTES"), "compromisos_por_pagar"
	End Sub	
	
	Sub DibujaMorosos
		Me.Dibuja Me.ObtenerSql("MOROSOS"), "morosos"
	End Sub	
		
	Sub DibujaResumenCompromisos
		set formulario = new CFormulario
		formulario.Carga_Parametros "class_cuenta_corriente.xml", "resumen_compromisos"
		formulario.Inicializar conexion
		formulario.Consultar sql_resumen_detalle_compromisos
		formulario.DibujaTabla
	End Sub
	
	Sub DibujaResumenCajaPendientes
		set formulario = new CFormulario
		formulario.Carga_Parametros "class_cuenta_corriente.xml", "resumen_caja_pendientes"
		formulario.Inicializar conexion
		formulario.Consultar sql_resumen_caja_pendiente
		formulario.DibujaTabla
	End Sub
	
	Sub DibujaResumenCajaOtrosPendientes
		set formulario = new CFormulario
		formulario.Carga_Parametros "class_cuenta_corriente.xml", "resumen_caja_otros_pendientes"
		formulario.Inicializar conexion
		formulario.Consultar sql_resumen_caja_otros_pendiente
		formulario.DibujaTabla
	End Sub

	
	Sub DibujaCompromisosEnNotaria
		Me.Dibuja Me.ObtenerSql("COMPROMISOS_EN_COBRANZA"), "compromisos_en_cobranza"		
	End Sub	
	
End Class
%>
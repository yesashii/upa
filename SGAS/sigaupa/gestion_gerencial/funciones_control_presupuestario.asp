<%

Function ReemplazaCero(numero)
	if numero=0 then
		ReemplazaCero=1
	else
		ReemplazaCero=numero
	end if	
end function

'Response.Write("Archivo funciones --> Incluido")
Function ObtenerConsultaSede(p_sede, v_anos)
v_ano_anterior=v_anos-1
v_fecha_inicio="26/11/"&v_ano_anterior
v_fecha_corte="26/11/"&v_anos

sql_bancaj_sede=	" select facu_ccod,jorn_ccod,sede_ccod, carr_ccod,facultad,cast(carrera+ case jorn_ccod when 1 then '- (D)' else '- (V)' end as varchar(150)) as carrera, "& vbCrLf &_ 
				" cast(isnull(max(total_arancel),0) as numeric) as arancel,cast(isnull(max(total_titulacion),0) as numeric) as titulacion, cast(isnull(max(total_arancel),0)+isnull(max(total_titulacion),0) as numeric) as total  "& vbCrLf &_ 
				"	From ( "& vbCrLf &_ 
					" select d.facu_ccod,d.facu_tdesc as facultad ,b.carr_tdesc as carrera, a.carr_ccod,a.tipo_ingreso,a.jorn_ccod,a.sede_ccod, "& vbCrLf &_ 
					" case tipo_ingreso when 1 then sum(monto_recaudado) end as total_arancel, "& vbCrLf &_ 
					" case tipo_ingreso when 2 then sum(monto_recaudado) end as total_titulacion "& vbCrLf &_ 
						"  from (      "& vbCrLf &_ 
						"   select  protic.obtener_carrera_ingreso(a.mcaj_ncorr,a.ting_ccod,ingr_nfolio_referencia,a.pers_ncorr)  as carr_ccod, "& vbCrLf &_ 
						"   1 as tipo_ingreso,a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,  "& vbCrLf &_ 
						"   case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6  "& vbCrLf &_ 
						" 	    else b.ting_ccod end as ting_ccod,     "& vbCrLf &_ 
						"   case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo  "& vbCrLf &_ 
						" 	   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado, "& vbCrLf &_ 
						" 		g.jorn_ccod,g.sede_ccod     "& vbCrLf &_ 
						" 	From ingresos a (nolock)       "& vbCrLf &_ 
						" 	left outer join detalle_ingresos b (nolock)      "& vbCrLf &_ 
						" 	  on a.ingr_ncorr=b.ingr_ncorr "& vbCrLf &_ 
						" 	  and b.ting_ccod in (3,4,6,13,14,51,52,59,66)     "& vbCrLf &_ 
						" 	left outer join tipos_ingresos c       "& vbCrLf &_ 
						" 	  on b.ting_ccod=c.ting_ccod      "& vbCrLf &_ 
						" 	join abonos d (nolock)  "& vbCrLf &_ 
						" 	  on a.ingr_ncorr=d.ingr_ncorr "& vbCrLf &_ 
						" 	  and d.tcom_ccod in (1,2) "& vbCrLf &_ 
						" 	join contratos e (nolock)  "& vbCrLf &_ 
						" 		on d.comp_ndocto=e.cont_ncorr  "& vbCrLf &_ 
						" 		and e.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod ='"&v_anos&"') "& vbCrLf &_ 
						" 	join alumnos f (nolock)  "& vbCrLf &_ 
						" 		on e.matr_ncorr=f.matr_ncorr "& vbCrLf &_ 
						" 	join ofertas_academicas g (nolock)  "& vbCrLf &_ 
						" 		on f.ofer_ncorr=g.ofer_ncorr "& vbCrLf &_ 
						" 	 where a.ting_ccod  in (7)      "& vbCrLf &_ 
						" 		  and a.eing_ccod not in (3,6) "& vbCrLf &_ 
						" 		  and e.econ_ccod not in (3) "& vbCrLf &_ 
						" 		  and g.sede_ccod in ('"&p_sede&"')    "& vbCrLf &_ 
						"  UNION	  "& vbCrLf &_ 
						"   -- Titulaciones pagadas directamente   "& vbCrLf &_ 
						"   select  protic.obtener_carrera_cargo(f.post_ncorr) as carr_ccod, "& vbCrLf &_ 
						"   j.tipo_ingreso,j.mcaj_ncorr,j.ingr_ncorr,j.ingr_nfolio_referencia,j.ding_mdetalle, j.ingr_mtotal, j.ingr_mefectivo,  "& vbCrLf &_ 
						"   j.ting_ccod, j.monto_recaudado, g.jorn_ccod,g.sede_ccod  "& vbCrLf &_ 
						"  from ( "& vbCrLf &_ 
						"    select a.pers_ncorr,2 as tipo_ingreso,a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,   "& vbCrLf &_ 
						"    case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6   "& vbCrLf &_ 
						" 	   else b.ting_ccod end as ting_ccod,  "& vbCrLf &_ 
						"    case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo   "& vbCrLf &_ 
						" 	   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado, "& vbCrLf &_ 
						"    protic.obtener_post_ncorr(a.pers_ncorr,d.comp_ndocto,a.ingr_ncorr) as post_ncorr  "& vbCrLf &_ 
						"    from ingresos a (nolock)    "& vbCrLf &_ 
						"    left outer join detalle_ingresos b (nolock)    "& vbCrLf &_ 
						" 	  on a.ingr_ncorr=b.ingr_ncorr    "& vbCrLf &_ 
						" 	  and  b.ting_ccod in (3,4,6,13,14,51,52,59,66)    "& vbCrLf &_ 
						"    left outer join tipos_ingresos c    "& vbCrLf &_ 
						" 	  on b.ting_ccod=c.ting_ccod   "& vbCrLf &_ 
						"    join abonos d  (nolock)  "& vbCrLf &_ 
						" 		on a.ingr_ncorr=d.ingr_ncorr   "& vbCrLf &_ 
						" 		and d.tcom_ccod=4   "& vbCrLf &_ 
						"    join detalles e (nolock)   "& vbCrLf &_ 
						" 		on d.comp_ndocto=e.comp_ndocto   "& vbCrLf &_ 
						" 		and d.tcom_ccod=e.tcom_ccod   "& vbCrLf &_ 
						" 		and e.tdet_ccod in (1230) "& vbCrLf &_ 
						"   where a.ting_ccod  in (34)  "& vbCrLf &_     
						" 	   and a.eing_ccod not in (3,6)   "& vbCrLf &_ 
						" 	  -- and datepart(year,a.ingr_fpago)='"&v_anos&"'  "& vbCrLf &_ 
						" 	  and convert(datetime,a.ingr_fpago,103) between convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_corte&"',103)  "& vbCrLf &_ 
						"    ) j "& vbCrLf &_ 
						"    join alumnos f (nolock)  "& vbCrLf &_ 
						" 		on j.pers_ncorr =f.pers_ncorr "& vbCrLf &_ 
						" 		and f.post_ncorr=j.post_ncorr "& vbCrLf &_ 
						" 		and f.emat_ccod not in (9) "& vbCrLf &_ 
						"    join ofertas_academicas g "& vbCrLf &_ 
						" 		on f.ofer_ncorr=g.ofer_ncorr  "& vbCrLf &_ 
						" 		and g.sede_ccod='"&p_sede&"'	   "& vbCrLf &_ 
						"  UNION   "& vbCrLf &_ 
						"    -- Titulaciones repactadas   "& vbCrLf &_ 
						" 	select  protic.obtener_carrera_cargo(f.post_ncorr) as carr_ccod, "& vbCrLf &_ 
						" 		  j.tipo_ingreso,j.mcaj_ncorr,j.ingr_ncorr,j.ingr_nfolio_referencia,j.ding_mdetalle, j.ingr_mtotal, j.ingr_mefectivo,  "& vbCrLf &_ 
						" 		  j.ting_ccod, j.monto_recaudado, g.jorn_ccod,g.sede_ccod "& vbCrLf &_ 
						"  from ( "& vbCrLf &_ 
						"    Select a.pers_ncorr,2 as tipo_ingreso,a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,   "& vbCrLf &_ 
						"    case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6   "& vbCrLf &_ 
						" 	   else b.ting_ccod end as ting_ccod,   "& vbCrLf &_    
						"    case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo   "& vbCrLf &_ 
						" 	   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado, "& vbCrLf &_ 
						" 	   protic.obtener_post_ncorr(a.pers_ncorr,d.comp_ndocto,a.ingr_ncorr) as post_ncorr  "& vbCrLf &_ 
						" 	  From ingresos a (nolock)   "& vbCrLf &_ 
						" 		  left outer join detalle_ingresos b   "& vbCrLf &_ 
						" 			  on a.ingr_ncorr=b.ingr_ncorr   "& vbCrLf &_   
						" 			  and  b.ting_ccod in (3,4,6,13,14,51,52,59,66) "& vbCrLf &_ 
						" 		  left outer join tipos_ingresos c   "& vbCrLf &_ 
						" 			  on b.ting_ccod=c.ting_ccod   "& vbCrLf &_ 
						" 		  join abonos d (nolock)   "& vbCrLf &_ 
						" 				on a.ingr_ncorr=d.ingr_ncorr   "& vbCrLf &_ 
						" 				and d.tcom_ccod=3   "& vbCrLf &_ 
						" 		  join compromisos e (nolock)   "& vbCrLf &_ 
						" 				on d.comp_ndocto=e.comp_ndocto   "& vbCrLf &_ 
						" 				and d.tcom_ccod=e.tcom_ccod   "& vbCrLf &_ 
						" 		  Where a.eing_ccod not in (5,3,6)  "& vbCrLf &_ 
						" 				and a.ting_ccod=15  "& vbCrLf &_ 
						" 				and a.ingr_nfolio_referencia in ( "& vbCrLf &_  
						" 							select a.ingr_nfolio_referencia   "& vbCrLf &_ 
						" 							 from ingresos a, detalle_ingresos b, abonos c  "& vbCrLf &_  
						" 							 where a.ingr_ncorr=b.ingr_ncorr   "& vbCrLf &_ 
						" 								and a.ingr_ncorr=c.ingr_ncorr   "& vbCrLf &_ 
						" 								and c.tcom_ccod=4   "& vbCrLf &_ 
						" 								and a.ting_ccod=9   "& vbCrLf &_ 
						" 								and b.ting_ccod=9  "& vbCrLf &_ 
						" 								and a.eing_ccod=5  "& vbCrLf &_ 
						" 							)  "& vbCrLf &_ 
						" 		--and datepart(year,a.ingr_fpago)='"&v_anos&"'    "& vbCrLf &_ 
						" 	    and convert(datetime,a.ingr_fpago,103) between convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_corte&"',103)  "& vbCrLf &_ 						
						"   ) j "& vbCrLf &_ 
						"    join alumnos f (nolock)  "& vbCrLf &_ 
						" 		on j.pers_ncorr =f.pers_ncorr "& vbCrLf &_ 
						" 		and f.post_ncorr=j.post_ncorr "& vbCrLf &_ 
						" 		and f.emat_ccod not in (9) "& vbCrLf &_ 
						"    join ofertas_academicas g "& vbCrLf &_ 
						" 		on f.ofer_ncorr=g.ofer_ncorr  "& vbCrLf &_ 
						" 		and g.sede_ccod='"&p_sede&"'	   "& vbCrLf &_ 
						" ) as a, carreras b, areas_academicas c,facultades d   "& vbCrLf &_ 
						" where  cast(a.carr_ccod as varchar)= cast(b.carr_ccod as varchar) "& vbCrLf &_ 
						" and b.area_ccod=c.area_ccod "& vbCrLf &_ 
						" and c.facu_ccod=d.facu_ccod "& vbCrLf &_ 
						" group by a.carr_ccod,a.tipo_ingreso,b.carr_tdesc,d.facu_tdesc,d.facu_ccod,a.jorn_ccod,a.sede_ccod  "& vbCrLf &_ 
					" ) as tabla_final "& vbCrLf &_ 
					" group by facu_ccod,facultad,carrera,carr_ccod,jorn_ccod,sede_ccod   "

if p_sede="2" then
	'response.Write("<pre>"&sql_bancaj_sede&"</pre>")
end if					      
		ObtenerConsultaSede=sql_bancaj_sede				

end function

Function ObtenerConsultaSedePareo(p_sede, v_anos)
v_ano_anterior=v_anos-1
v_fecha_inicio="26/11/"&v_ano_anterior
v_fecha_corte="26/11/"&v_anos

sql_bancaj_sede_pareo=	" select  c.facu_tdesc as facultad,b.presc_carrera_desc as carrera,b.presc_aranceles,b.presc_titulaciones,b.presc_total,"& vbCrLf &_ 
				" isnull(ff.arancel,0) arancel,isnull(ff.titulacion,0) titulacion,isnull(ff.total,0) total , b.presc_facultad"& vbCrLf &_ 
				" from  presupuestos_escuelas b "& vbCrLf &_ 
				" left outer join  "& vbCrLf &_ 
				" (select facu_ccod,jorn_ccod,sede_ccod, carr_ccod,facultad,cast(carrera+ case jorn_ccod when 1 then '- (D)' else '- (V)' end as varchar(150)) as carrera, "& vbCrLf &_ 
				" cast(isnull(max(total_arancel),0) as numeric) as arancel,cast(isnull(max(total_titulacion),0) as numeric) as titulacion, cast(isnull(max(total_arancel),0)+isnull(max(total_titulacion),0) as numeric) as total  "& vbCrLf &_ 
				"	From ( "& vbCrLf &_ 
					" select d.facu_ccod,d.facu_tdesc as facultad ,b.carr_tdesc as carrera, a.carr_ccod,a.tipo_ingreso,a.jorn_ccod,a.sede_ccod, "& vbCrLf &_ 
					" case tipo_ingreso when 1 then sum(monto_recaudado) end as total_arancel, "& vbCrLf &_ 
					" case tipo_ingreso when 2 then sum(monto_recaudado) end as total_titulacion "& vbCrLf &_ 
						"  from (      "& vbCrLf &_ 
						"   select protic.obtener_carrera_ingreso(a.mcaj_ncorr,a.ting_ccod,ingr_nfolio_referencia,a.pers_ncorr) as carr_ccod, "& vbCrLf &_ 
						"   1 as tipo_ingreso,a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,  "& vbCrLf &_ 
						"   case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6  "& vbCrLf &_ 
						" 	    else b.ting_ccod end as ting_ccod,     "& vbCrLf &_ 
						"   case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo  "& vbCrLf &_ 
						" 	   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado, "& vbCrLf &_ 
						" 		g.jorn_ccod,g.sede_ccod     "& vbCrLf &_ 
						" 	From ingresos a  (nolock)      "& vbCrLf &_ 
						" 	left outer join detalle_ingresos b     "& vbCrLf &_ 
						" 	  on a.ingr_ncorr=b.ingr_ncorr "& vbCrLf &_ 
						" 	  and b.ting_ccod in (3,4,6,13,14,51,52,59,66)     "& vbCrLf &_ 
						" 	left outer join tipos_ingresos c       "& vbCrLf &_ 
						" 	  on b.ting_ccod=c.ting_ccod      "& vbCrLf &_ 
						" 	join abonos d (nolock) "& vbCrLf &_ 
						" 	  on a.ingr_ncorr=d.ingr_ncorr "& vbCrLf &_ 
						" 	  and d.tcom_ccod in (1,2) "& vbCrLf &_ 
						" 	join contratos e (nolock) "& vbCrLf &_ 
						" 		on d.comp_ndocto=e.cont_ncorr  "& vbCrLf &_ 
						" 		and e.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod ='"&v_anos&"') "& vbCrLf &_ 
						" 	join alumnos f (nolock)  "& vbCrLf &_ 
						" 		on e.matr_ncorr=f.matr_ncorr "& vbCrLf &_ 
						" 	join ofertas_academicas g "& vbCrLf &_ 
						" 		on f.ofer_ncorr=g.ofer_ncorr "& vbCrLf &_ 
						" 	 where a.ting_ccod  in (7)      "& vbCrLf &_ 
						" 		  and a.eing_ccod not in (3,6) "& vbCrLf &_ 
						" 		  and e.econ_ccod not in (3) "& vbCrLf &_ 
						" 		  and g.sede_ccod in ('"&p_sede&"')    "& vbCrLf &_ 
						"  UNION	  "& vbCrLf &_ 
						"   -- Titulaciones pagadas directamente   "& vbCrLf &_ 
						"   select  protic.obtener_carrera_cargo(f.post_ncorr) as carr_ccod, "& vbCrLf &_ 
						"   j.tipo_ingreso,j.mcaj_ncorr,j.ingr_ncorr,j.ingr_nfolio_referencia,j.ding_mdetalle, j.ingr_mtotal, j.ingr_mefectivo,  "& vbCrLf &_ 
						"   j.ting_ccod, j.monto_recaudado, g.jorn_ccod,g.sede_ccod  "& vbCrLf &_ 
						"  from ( "& vbCrLf &_ 
						"    select a.pers_ncorr,2 as tipo_ingreso,a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,   "& vbCrLf &_ 
						"    case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6   "& vbCrLf &_ 
						" 	   else b.ting_ccod end as ting_ccod,  "& vbCrLf &_ 
						"    case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo   "& vbCrLf &_ 
						" 	   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado, "& vbCrLf &_ 
						"    protic.obtener_post_ncorr(a.pers_ncorr,d.comp_ndocto,a.ingr_ncorr) as post_ncorr  "& vbCrLf &_ 
						"    from ingresos a  (nolock)   "& vbCrLf &_ 
						"    left outer join detalle_ingresos b   "& vbCrLf &_ 
						" 	  on a.ingr_ncorr=b.ingr_ncorr    "& vbCrLf &_ 
						" 	  and  b.ting_ccod in (3,4,6,13,14,51,52,59,66)    "& vbCrLf &_ 
						"    left outer join tipos_ingresos c    "& vbCrLf &_ 
						" 	  on b.ting_ccod=c.ting_ccod   "& vbCrLf &_ 
						"    join abonos d (nolock)   "& vbCrLf &_ 
						" 		on a.ingr_ncorr=d.ingr_ncorr   "& vbCrLf &_ 
						" 		and d.tcom_ccod=4   "& vbCrLf &_ 
						"    join detalles e   "& vbCrLf &_ 
						" 		on d.comp_ndocto=e.comp_ndocto   "& vbCrLf &_ 
						" 		and d.tcom_ccod=e.tcom_ccod   "& vbCrLf &_ 
						" 		and e.tdet_ccod in (1230) "& vbCrLf &_ 
						"   where a.ting_ccod  in (34)  "& vbCrLf &_     
						" 	   and a.eing_ccod not in (3,6)   "& vbCrLf &_ 
						" 	   --and datepart(year,a.ingr_fpago)='"&v_anos&"'  "& vbCrLf &_ 
						" 	   and convert(datetime,a.ingr_fpago,103) between convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_corte&"',103)  "& vbCrLf &_ 
						"    ) j "& vbCrLf &_ 
						"    join alumnos f (nolock)  "& vbCrLf &_ 
						" 		on j.pers_ncorr =f.pers_ncorr "& vbCrLf &_ 
						" 		and f.post_ncorr=j.post_ncorr "& vbCrLf &_ 
						" 		and f.emat_ccod not in (9) "& vbCrLf &_ 
						"    join ofertas_academicas g "& vbCrLf &_ 
						" 		on f.ofer_ncorr=g.ofer_ncorr  "& vbCrLf &_ 
						" 		and g.sede_ccod='"&p_sede&"'	   "& vbCrLf &_ 
						"  UNION   "& vbCrLf &_ 
						"    -- Titulaciones repactadas   "& vbCrLf &_ 
						" 	select protic.obtener_carrera_cargo(f.post_ncorr) as carr_ccod, "& vbCrLf &_ 
						" 		  j.tipo_ingreso,j.mcaj_ncorr,j.ingr_ncorr,j.ingr_nfolio_referencia,j.ding_mdetalle, j.ingr_mtotal, j.ingr_mefectivo,  "& vbCrLf &_ 
						" 		  j.ting_ccod, j.monto_recaudado, g.jorn_ccod,g.sede_ccod "& vbCrLf &_ 
						"  from ( "& vbCrLf &_ 
						"    Select a.pers_ncorr,2 as tipo_ingreso,a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,   "& vbCrLf &_ 
						"    case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6   "& vbCrLf &_ 
						" 	   else b.ting_ccod end as ting_ccod,   "& vbCrLf &_    
						"    case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo   "& vbCrLf &_ 
						" 	   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado, "& vbCrLf &_ 
						" 	   protic.obtener_post_ncorr(a.pers_ncorr,d.comp_ndocto,a.ingr_ncorr) as post_ncorr  "& vbCrLf &_ 
						" 	  From ingresos a  (nolock)  "& vbCrLf &_ 
						" 		  left outer join detalle_ingresos b   "& vbCrLf &_ 
						" 			  on a.ingr_ncorr=b.ingr_ncorr   "& vbCrLf &_   
						" 			  and  b.ting_ccod in (3,4,6,13,14,51,52,59,66) "& vbCrLf &_ 
						" 		  left outer join tipos_ingresos c   "& vbCrLf &_ 
						" 			  on b.ting_ccod=c.ting_ccod   "& vbCrLf &_ 
						" 		  join abonos d (nolock)   "& vbCrLf &_ 
						" 				on a.ingr_ncorr=d.ingr_ncorr   "& vbCrLf &_ 
						" 				and d.tcom_ccod=3   "& vbCrLf &_ 
						" 		  join compromisos e (nolock)   "& vbCrLf &_ 
						" 				on d.comp_ndocto=e.comp_ndocto   "& vbCrLf &_ 
						" 				and d.tcom_ccod=e.tcom_ccod   "& vbCrLf &_ 
						" 		  Where a.eing_ccod not in (5,3,6)  "& vbCrLf &_ 
						" 				and a.ting_ccod=15  "& vbCrLf &_ 
						" 				and a.ingr_nfolio_referencia in ( "& vbCrLf &_  
						" 							select a.ingr_nfolio_referencia   "& vbCrLf &_ 
						" 							 from ingresos a, detalle_ingresos b, abonos c  "& vbCrLf &_  
						" 							 where a.ingr_ncorr=b.ingr_ncorr   "& vbCrLf &_ 
						" 								and a.ingr_ncorr=c.ingr_ncorr   "& vbCrLf &_ 
						" 								and c.tcom_ccod=4   "& vbCrLf &_ 
						" 								and a.ting_ccod=9   "& vbCrLf &_ 
						" 								and b.ting_ccod=9  "& vbCrLf &_ 
						" 								and a.eing_ccod=5  "& vbCrLf &_ 
						" 							)  "& vbCrLf &_ 
						" 		--and datepart(year,a.ingr_fpago)='"&v_anos&"'    "& vbCrLf &_ 
						" 	    and convert(datetime,a.ingr_fpago,103) between convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_corte&"',103)  "& vbCrLf &_ 
						"   ) j "& vbCrLf &_ 
						"    join alumnos f (nolock)  "& vbCrLf &_ 
						" 		on j.pers_ncorr =f.pers_ncorr "& vbCrLf &_ 
						" 		and f.post_ncorr=j.post_ncorr "& vbCrLf &_ 
						" 		and f.emat_ccod not in (9) "& vbCrLf &_ 
						"    join ofertas_academicas g "& vbCrLf &_ 
						" 		on f.ofer_ncorr=g.ofer_ncorr  "& vbCrLf &_ 
						" 		and g.sede_ccod='"&p_sede&"'	   "& vbCrLf &_ 
						" ) as a, carreras b, areas_academicas c,facultades d   "& vbCrLf &_ 
						" where  cast(a.carr_ccod as varchar)= cast(b.carr_ccod as varchar) "& vbCrLf &_ 
						" and b.area_ccod=c.area_ccod "& vbCrLf &_ 
						" and c.facu_ccod=d.facu_ccod "& vbCrLf &_ 
						" group by a.carr_ccod,a.tipo_ingreso,b.carr_tdesc,d.facu_tdesc,d.facu_ccod,a.jorn_ccod,a.sede_ccod      "& vbCrLf &_ 
					" ) as tabla_final "& vbCrLf &_ 
					" group by facu_ccod,facultad,carrera,carr_ccod,jorn_ccod,sede_ccod   "& vbCrLf &_
					" ) ff "& vbCrLf &_
						" on  b.presc_facultad=ff.facu_ccod "& vbCrLf &_
						" and b.presc_carrera=ff.carr_ccod "& vbCrLf &_
						" and b.presc_sede=ff.sede_ccod "& vbCrLf &_
						" and b.presc_jornada=ff.jorn_ccod "& vbCrLf &_
						" join facultades c "& vbCrLf &_
						" on b.presc_facultad=c.facu_ccod "& vbCrLf &_
						" where  b.presc_sede='"&p_sede&"' "& vbCrLf &_
						" and  b.presc_admision='"&v_anos&"' "& vbCrLf &_
						" order by c.facu_ccod desc"

'if p_sede="2" then
	'response.Write("<pre>"&sql_bancaj_sede_pareo&"</pre>")
	'response.Flush()			      
'end if

		ObtenerConsultaSedePareo=sql_bancaj_sede_pareo				
end function

Function ObtenerConsultaFacultad(p_facu, v_anos)

v_ano_anterior=v_anos-1
v_fecha_inicio="26/11/"&v_ano_anterior
v_fecha_corte="26/11/"&v_anos

	sql_facultad =	" select b.sede_tdesc,a.facu_ccod,a.sede_ccod,a.facultad , "& vbCrLf &_ 
						" cast(isnull(sum(total_arancel),0) as numeric) as arancel,cast(isnull(sum(total_titulacion),0) as numeric) as titulacion, cast(isnull(sum(total_arancel),0)+isnull(sum(total_titulacion),0) as numeric) as total  "& vbCrLf &_ 
						"	From ( "& vbCrLf &_ 
							" select d.facu_ccod,d.facu_tdesc as facultad ,b.carr_tdesc as carrera, a.carr_ccod,a.tipo_ingreso,a.jorn_ccod,a.sede_ccod, "& vbCrLf &_ 
							" case tipo_ingreso when 1 then sum(monto_recaudado) end as total_arancel, "& vbCrLf &_ 
							" case tipo_ingreso when 2 then sum(monto_recaudado) end as total_titulacion "& vbCrLf &_ 
								"  from (      "& vbCrLf &_ 
								"   select protic.obtener_carrera_ingreso(a.mcaj_ncorr,a.ting_ccod,ingr_nfolio_referencia,a.pers_ncorr) as carr_ccod, "& vbCrLf &_ 
								"   1 as tipo_ingreso,a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,  "& vbCrLf &_ 
								"   case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6  "& vbCrLf &_ 
								" 	    else b.ting_ccod end as ting_ccod,     "& vbCrLf &_ 
								"   case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo  "& vbCrLf &_ 
								" 	   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado, "& vbCrLf &_ 
								" 		g.jorn_ccod,g.sede_ccod     "& vbCrLf &_ 
								" 	From ingresos a  (nolock)     "& vbCrLf &_ 
								" 	left outer join detalle_ingresos b     "& vbCrLf &_ 
								" 	  on a.ingr_ncorr=b.ingr_ncorr "& vbCrLf &_ 
								" 	  and b.ting_ccod in (3,4,6,13,14,51,52,59,66)     "& vbCrLf &_ 
								" 	left outer join tipos_ingresos c       "& vbCrLf &_ 
								" 	  on b.ting_ccod=c.ting_ccod      "& vbCrLf &_ 
								" 	join abonos d (nolock) "& vbCrLf &_ 
								" 	  on a.ingr_ncorr=d.ingr_ncorr "& vbCrLf &_ 
								" 	  and d.tcom_ccod in (1,2) "& vbCrLf &_ 
								" 	join contratos e (nolock) "& vbCrLf &_ 
								" 		on d.comp_ndocto=e.cont_ncorr  "& vbCrLf &_ 
								" 		and e.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod ='"&v_anos&"') "& vbCrLf &_ 
								" 	join alumnos f (nolock) "& vbCrLf &_ 
								" 		on e.matr_ncorr=f.matr_ncorr "& vbCrLf &_ 
								" 	join ofertas_academicas g "& vbCrLf &_ 
								" 		on f.ofer_ncorr=g.ofer_ncorr "& vbCrLf &_ 
								" 	 where a.ting_ccod  in (7)      "& vbCrLf &_ 
								" 		  and a.eing_ccod not in (3,6) "& vbCrLf &_ 
								" 		  and e.econ_ccod not in (3) "& vbCrLf &_ 
								" 		  and g.sede_ccod in (1,2,4,7,8) "& vbCrLf &_ 
								"  UNION	  "& vbCrLf &_ 
								"   -- Titulaciones pagadas directamente   "& vbCrLf &_ 
								"   select  protic.obtener_carrera_cargo(f.post_ncorr) as carr_ccod,j.tipo_ingreso, "& vbCrLf &_ 
								"   j.mcaj_ncorr,j.ingr_ncorr,j.ingr_nfolio_referencia,j.ding_mdetalle, j.ingr_mtotal, j.ingr_mefectivo,  "& vbCrLf &_ 
								"   j.ting_ccod, j.monto_recaudado, g.jorn_ccod,g.sede_ccod  "& vbCrLf &_ 
								"  from ( "& vbCrLf &_ 
								"    select a.pers_ncorr,2 as tipo_ingreso,a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,   "& vbCrLf &_ 
								"    case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6   "& vbCrLf &_ 
								" 	   else b.ting_ccod end as ting_ccod,  "& vbCrLf &_ 
								"    case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo   "& vbCrLf &_ 
								" 	   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado, "& vbCrLf &_ 
								"    protic.obtener_post_ncorr(a.pers_ncorr,d.comp_ndocto,a.ingr_ncorr) as post_ncorr  "& vbCrLf &_ 
								"    from ingresos a (nolock)   "& vbCrLf &_ 
								"    left outer join detalle_ingresos b   "& vbCrLf &_ 
								" 	  on a.ingr_ncorr=b.ingr_ncorr    "& vbCrLf &_ 
								" 	  and  b.ting_ccod in (3,4,6,13,14,51,52,59,66)    "& vbCrLf &_ 
								"    left outer join tipos_ingresos c    "& vbCrLf &_ 
								" 	  on b.ting_ccod=c.ting_ccod   "& vbCrLf &_ 
								"    join abonos d (nolock)  "& vbCrLf &_ 
								" 		on a.ingr_ncorr=d.ingr_ncorr   "& vbCrLf &_ 
								" 		and d.tcom_ccod=4   "& vbCrLf &_ 
								"    join detalles e   "& vbCrLf &_ 
								" 		on d.comp_ndocto=e.comp_ndocto   "& vbCrLf &_ 
								" 		and d.tcom_ccod=e.tcom_ccod   "& vbCrLf &_ 
								" 		and e.tdet_ccod in (1230) "& vbCrLf &_ 
								"   where a.ting_ccod  in (34)  "& vbCrLf &_     
								" 	   and a.eing_ccod not in (3,6)   "& vbCrLf &_ 
								" 	   --and datepart(year,a.ingr_fpago)='"&v_anos&"'  "& vbCrLf &_ 
								" 	   and convert(datetime,a.ingr_fpago,103) between convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_corte&"',103)  "& vbCrLf &_ 
								"    ) j "& vbCrLf &_ 
								"    join alumnos f (nolock)  "& vbCrLf &_ 
								" 		on j.pers_ncorr =f.pers_ncorr "& vbCrLf &_ 
								" 		and f.post_ncorr=j.post_ncorr "& vbCrLf &_ 
								" 		and f.emat_ccod not in (9) "& vbCrLf &_ 
								"    join ofertas_academicas g "& vbCrLf &_ 
								" 		on f.ofer_ncorr=g.ofer_ncorr  "& vbCrLf &_ 
								" 		and g.sede_ccod in (1,2,4,7,8)	   "& vbCrLf &_ 
								"  UNION   "& vbCrLf &_ 
								"    -- Titulaciones repactadas   "& vbCrLf &_ 
								" 	select protic.obtener_carrera_cargo(j.post_ncorr) as carr_ccod,j.tipo_ingreso, "& vbCrLf &_ 
								" 		  j.mcaj_ncorr,j.ingr_ncorr,j.ingr_nfolio_referencia,j.ding_mdetalle, j.ingr_mtotal, j.ingr_mefectivo,  "& vbCrLf &_ 
								" 		  j.ting_ccod, j.monto_recaudado, g.jorn_ccod,g.sede_ccod "& vbCrLf &_ 
								"  from ( "& vbCrLf &_ 
								"    Select a.pers_ncorr,2 as tipo_ingreso,a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,   "& vbCrLf &_ 
								"    case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6   "& vbCrLf &_ 
								" 	   else b.ting_ccod end as ting_ccod,   "& vbCrLf &_    
								"    case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo   "& vbCrLf &_ 
								" 	   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado, "& vbCrLf &_ 
								" 	   protic.obtener_post_ncorr(a.pers_ncorr,d.comp_ndocto,a.ingr_ncorr) as post_ncorr  "& vbCrLf &_ 
								" 	  From ingresos a (nolock)  "& vbCrLf &_ 
								" 		  left outer join detalle_ingresos b   "& vbCrLf &_ 
								" 			  on a.ingr_ncorr=b.ingr_ncorr   "& vbCrLf &_   
								" 			  and  b.ting_ccod in (3,4,6,13,14,51,52,59,66) "& vbCrLf &_ 
								" 		  left outer join tipos_ingresos c   "& vbCrLf &_ 
								" 			  on b.ting_ccod=c.ting_ccod   "& vbCrLf &_ 
								" 		  join abonos d  (nolock) "& vbCrLf &_ 
								" 				on a.ingr_ncorr=d.ingr_ncorr   "& vbCrLf &_ 
								" 				and d.tcom_ccod=3   "& vbCrLf &_ 
								" 		  join compromisos e (nolock)  "& vbCrLf &_ 
								" 				on d.comp_ndocto=e.comp_ndocto   "& vbCrLf &_ 
								" 				and d.tcom_ccod=e.tcom_ccod   "& vbCrLf &_ 
								" 		  Where a.eing_ccod not in (5,3,6)  "& vbCrLf &_ 
								" 				and a.ting_ccod=15  "& vbCrLf &_ 
								" 				and a.ingr_nfolio_referencia in ( "& vbCrLf &_  
								" 							select a.ingr_nfolio_referencia   "& vbCrLf &_ 
								" 							 from ingresos a, detalle_ingresos b, abonos c  "& vbCrLf &_  
								" 							 where a.ingr_ncorr=b.ingr_ncorr   "& vbCrLf &_ 
								" 								and a.ingr_ncorr=c.ingr_ncorr   "& vbCrLf &_ 
								" 								and c.tcom_ccod=4   "& vbCrLf &_ 
								" 								and a.ting_ccod=9   "& vbCrLf &_ 
								" 								and b.ting_ccod=9  "& vbCrLf &_ 
								" 								and a.eing_ccod=5  "& vbCrLf &_ 
								" 							)  "& vbCrLf &_ 
								" 		--and datepart(year,a.ingr_fpago)='"&v_anos&"'    "& vbCrLf &_ 
								" 	    and convert(datetime,a.ingr_fpago,103) between convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_corte&"',103)  "& vbCrLf &_ 
								"   ) j "& vbCrLf &_ 
								"    join alumnos f (nolock) "& vbCrLf &_ 
								" 		on j.pers_ncorr =f.pers_ncorr "& vbCrLf &_ 
								" 		and f.post_ncorr=j.post_ncorr "& vbCrLf &_ 
								" 		and f.emat_ccod not in (9) "& vbCrLf &_ 
								"    join ofertas_academicas g "& vbCrLf &_ 
								" 		on f.ofer_ncorr=g.ofer_ncorr  "& vbCrLf &_ 
								" 		and g.sede_ccod in (1,2,4,7,8)	   "& vbCrLf &_ 
								" ) as a, carreras b, areas_academicas c,facultades d   "& vbCrLf &_ 
								" where  cast(a.carr_ccod as varchar)= cast(b.carr_ccod as varchar) "& vbCrLf &_ 
								" and b.area_ccod=c.area_ccod "& vbCrLf &_ 
								" and c.facu_ccod=d.facu_ccod "& vbCrLf &_ 
								" group by a.carr_ccod,a.tipo_ingreso,b.carr_tdesc,d.facu_tdesc,d.facu_ccod,a.jorn_ccod,a.sede_ccod      "& vbCrLf &_ 
							" ) as a "& vbCrLf &_ 
							" join sedes b"& vbCrLf &_ 
							"	on a.sede_ccod=b.sede_ccod "& vbCrLf &_ 
							" where a.facu_ccod='"&p_facu&"' "& vbCrLf &_ 
							" Group by b.sede_tdesc,a.facu_ccod,a.sede_ccod,a.facultad "
							
'response.Write("<pre>"&sql_facultad&"</pre>")
'response.Flush()
		ObtenerConsultaFacultad=sql_facultad				
end function

Function ObtenerConsultaFacultadPareo(p_facu, v_anos)

v_ano_anterior=v_anos-1
v_fecha_inicio="26/11/"&v_ano_anterior
v_fecha_corte="26/11/"&v_anos

	sql_facultad =	" select a.sede_tdesc,isnull(b.presc_sede,a.sede_ccod)as presc_sede, isnull(b.presc_aranceles,0) as presc_aranceles, "& vbCrLf &_
					" isnull(b.presc_titulaciones,0) as presc_titulaciones, isnull(b.presc_total,0) as presc_total, "& vbCrLf &_
					" isnull(c.arancel,0) as arancel,isnull(c.titulacion,0) as titulacion,isnull(c.total,0) as total "& vbCrLf &_
					" from ( "& vbCrLf &_
					" 		 select sede_ccod, sede_tdesc  "& vbCrLf &_
					" 		 from sedes where sede_ccod  in (1,2,4,8) "& vbCrLf &_
						" ) a "& vbCrLf &_
						" left outer join  "& vbCrLf &_
						" 	(select facu_tdesc,presc_sede,sum(presc_aranceles) as presc_aranceles,  "& vbCrLf &_
						" 	sum(presc_titulaciones) as presc_titulaciones, sum(presc_total) as presc_total "& vbCrLf &_
						" 	from presupuestos_escuelas , sedes, facultades "& vbCrLf &_
						" 	where presc_sede=sede_ccod "& vbCrLf &_
						" 	and presc_facultad=facu_ccod "& vbCrLf &_
						" 	and presc_facultad='"&p_facu&"' "& vbCrLf &_
						" 	and presc_admision='"&v_anos&"' "& vbCrLf &_
						" 	group by presc_facultad,presc_sede, sede_ccod, facu_tdesc "& vbCrLf &_
					" 	) b "& vbCrLf &_
					" 	on a.sede_ccod=b.presc_sede "& vbCrLf &_
					" left outer join "& vbCrLf &_
					"( select b.sede_tdesc,a.facu_ccod,a.sede_ccod,a.facultad , "& vbCrLf &_ 
						" cast(isnull(sum(total_arancel),0) as numeric) as arancel,cast(isnull(sum(total_titulacion),0) as numeric) as titulacion, cast(isnull(sum(total_arancel),0)+isnull(sum(total_titulacion),0) as numeric) as total  "& vbCrLf &_ 
						"	From ( "& vbCrLf &_ 
							" select d.facu_ccod,d.facu_tdesc as facultad ,b.carr_tdesc as carrera, a.carr_ccod,a.tipo_ingreso,a.jorn_ccod,a.sede_ccod, "& vbCrLf &_ 
							" case tipo_ingreso when 1 then sum(monto_recaudado) end as total_arancel, "& vbCrLf &_ 
							" case tipo_ingreso when 2 then sum(monto_recaudado) end as total_titulacion "& vbCrLf &_ 
								"  from (      "& vbCrLf &_ 
								"   select protic.obtener_carrera_ingreso(a.mcaj_ncorr,a.ting_ccod,ingr_nfolio_referencia,a.pers_ncorr) as carr_ccod, "& vbCrLf &_ 
								"   1 as tipo_ingreso,a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,  "& vbCrLf &_ 
								"   case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6  "& vbCrLf &_ 
								" 	    else b.ting_ccod end as ting_ccod,     "& vbCrLf &_ 
								"   case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo  "& vbCrLf &_ 
								" 	   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado, "& vbCrLf &_ 
								" 		g.jorn_ccod,g.sede_ccod     "& vbCrLf &_ 
								" 	From ingresos a (nolock)     "& vbCrLf &_ 
								" 	left outer join detalle_ingresos b     "& vbCrLf &_ 
								" 	  on a.ingr_ncorr=b.ingr_ncorr "& vbCrLf &_ 
								" 	  and b.ting_ccod in (3,4,6,13,14,51,52,59,66)     "& vbCrLf &_ 
								" 	left outer join tipos_ingresos c       "& vbCrLf &_ 
								" 	  on b.ting_ccod=c.ting_ccod      "& vbCrLf &_ 
								" 	join abonos d (nolock) "& vbCrLf &_ 
								" 	  on a.ingr_ncorr=d.ingr_ncorr "& vbCrLf &_ 
								" 	  and d.tcom_ccod in (1,2) "& vbCrLf &_ 
								" 	join contratos e (nolock) "& vbCrLf &_ 
								" 		on d.comp_ndocto=e.cont_ncorr  "& vbCrLf &_ 
								" 		and e.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod ='"&v_anos&"') "& vbCrLf &_ 
								" 	join alumnos f (nolock) "& vbCrLf &_ 
								" 		on e.matr_ncorr=f.matr_ncorr "& vbCrLf &_ 
								" 	join ofertas_academicas g "& vbCrLf &_ 
								" 		on f.ofer_ncorr=g.ofer_ncorr "& vbCrLf &_ 
								" 	 where a.ting_ccod  in (7)      "& vbCrLf &_ 
								" 		  and a.eing_ccod not in (3,6) "& vbCrLf &_ 
								" 		  and e.econ_ccod not in (3) "& vbCrLf &_ 
								" 		  and g.sede_ccod in (1,2,4,7,8) "& vbCrLf &_ 
								"  UNION	  "& vbCrLf &_ 
								"   -- Titulaciones pagadas directamente   "& vbCrLf &_ 
								"   select  protic.obtener_carrera_cargo(f.post_ncorr) as carr_ccod,j.tipo_ingreso, "& vbCrLf &_ 
								"   j.mcaj_ncorr,j.ingr_ncorr,j.ingr_nfolio_referencia,j.ding_mdetalle, j.ingr_mtotal, j.ingr_mefectivo,  "& vbCrLf &_ 
								"   j.ting_ccod, j.monto_recaudado, g.jorn_ccod,g.sede_ccod  "& vbCrLf &_ 
								"  from ( "& vbCrLf &_ 
								"    select a.pers_ncorr,2 as tipo_ingreso,a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,   "& vbCrLf &_ 
								"    case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6   "& vbCrLf &_ 
								" 	   else b.ting_ccod end as ting_ccod,  "& vbCrLf &_ 
								"    case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo   "& vbCrLf &_ 
								" 	   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado, "& vbCrLf &_ 
								"    protic.obtener_post_ncorr(a.pers_ncorr,d.comp_ndocto,a.ingr_ncorr) as post_ncorr  "& vbCrLf &_ 
								"    from ingresos a (nolock)   "& vbCrLf &_ 
								"    left outer join detalle_ingresos b   "& vbCrLf &_ 
								" 	  on a.ingr_ncorr=b.ingr_ncorr    "& vbCrLf &_ 
								" 	  and  b.ting_ccod in (3,4,6,13,14,51,52,59,66)    "& vbCrLf &_ 
								"    left outer join tipos_ingresos c    "& vbCrLf &_ 
								" 	  on b.ting_ccod=c.ting_ccod   "& vbCrLf &_ 
								"    join abonos d (nolock)   "& vbCrLf &_ 
								" 		on a.ingr_ncorr=d.ingr_ncorr   "& vbCrLf &_ 
								" 		and d.tcom_ccod=4   "& vbCrLf &_ 
								"    join detalles e (nolock)   "& vbCrLf &_ 
								" 		on d.comp_ndocto=e.comp_ndocto   "& vbCrLf &_ 
								" 		and d.tcom_ccod=e.tcom_ccod   "& vbCrLf &_ 
								" 		and e.tdet_ccod in (1230) "& vbCrLf &_ 
								"   where a.ting_ccod  in (34)  "& vbCrLf &_     
								" 	   and a.eing_ccod not in (3,6)   "& vbCrLf &_ 
								" 	   --and datepart(year,a.ingr_fpago)='"&v_anos&"'  "& vbCrLf &_ 
								" 	   and convert(datetime,a.ingr_fpago,103) between convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_corte&"',103)  "& vbCrLf &_ 
								"    ) j "& vbCrLf &_ 
								"    join alumnos f (nolock)  "& vbCrLf &_ 
								" 		on j.pers_ncorr =f.pers_ncorr "& vbCrLf &_ 
								" 		and f.post_ncorr=j.post_ncorr "& vbCrLf &_ 
								" 		and f.emat_ccod not in (9) "& vbCrLf &_ 
								"    join ofertas_academicas g "& vbCrLf &_ 
								" 		on f.ofer_ncorr=g.ofer_ncorr  "& vbCrLf &_ 
								" 		and g.sede_ccod in (1,2,4,7,8)	   "& vbCrLf &_ 
								"  UNION   "& vbCrLf &_ 
								"    -- Titulaciones repactadas   "& vbCrLf &_ 
								" 	select protic.obtener_carrera_cargo(j.post_ncorr) as carr_ccod,j.tipo_ingreso, "& vbCrLf &_ 
								" 		  j.mcaj_ncorr,j.ingr_ncorr,j.ingr_nfolio_referencia,j.ding_mdetalle, j.ingr_mtotal, j.ingr_mefectivo,  "& vbCrLf &_ 
								" 		  j.ting_ccod, j.monto_recaudado, g.jorn_ccod,g.sede_ccod "& vbCrLf &_ 
								"  from ( "& vbCrLf &_ 
								"    Select a.pers_ncorr,2 as tipo_ingreso,a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,   "& vbCrLf &_ 
								"    case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6   "& vbCrLf &_ 
								" 	   else b.ting_ccod end as ting_ccod,   "& vbCrLf &_    
								"    case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo   "& vbCrLf &_ 
								" 	   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado, "& vbCrLf &_ 
								" 	   protic.obtener_post_ncorr(a.pers_ncorr,d.comp_ndocto,a.ingr_ncorr) as post_ncorr  "& vbCrLf &_ 
								" 	  From ingresos a (nolock)  "& vbCrLf &_ 
								" 		  left outer join detalle_ingresos b   "& vbCrLf &_ 
								" 			  on a.ingr_ncorr=b.ingr_ncorr   "& vbCrLf &_   
								" 			  and  b.ting_ccod in (3,4,6,13,14,51,52,59,66) "& vbCrLf &_ 
								" 		  left outer join tipos_ingresos c   "& vbCrLf &_ 
								" 			  on b.ting_ccod=c.ting_ccod   "& vbCrLf &_ 
								" 		  join abonos d  (nolock) "& vbCrLf &_ 
								" 				on a.ingr_ncorr=d.ingr_ncorr   "& vbCrLf &_ 
								" 				and d.tcom_ccod=3   "& vbCrLf &_ 
								" 		  join compromisos e (nolock)  "& vbCrLf &_ 
								" 				on d.comp_ndocto=e.comp_ndocto   "& vbCrLf &_ 
								" 				and d.tcom_ccod=e.tcom_ccod   "& vbCrLf &_ 
								" 		  Where a.eing_ccod not in (5,3,6)  "& vbCrLf &_ 
								" 				and a.ting_ccod=15  "& vbCrLf &_ 
								" 				and a.ingr_nfolio_referencia in ( "& vbCrLf &_  
								" 							select a.ingr_nfolio_referencia   "& vbCrLf &_ 
								" 							 from ingresos a, detalle_ingresos b, abonos c  "& vbCrLf &_  
								" 							 where a.ingr_ncorr=b.ingr_ncorr   "& vbCrLf &_ 
								" 								and a.ingr_ncorr=c.ingr_ncorr   "& vbCrLf &_ 
								" 								and c.tcom_ccod=4   "& vbCrLf &_ 
								" 								and a.ting_ccod=9   "& vbCrLf &_ 
								" 								and b.ting_ccod=9  "& vbCrLf &_ 
								" 								and a.eing_ccod=5  "& vbCrLf &_ 
								" 							)  "& vbCrLf &_ 
								" 		--and datepart(year,a.ingr_fpago)='"&v_anos&"'    "& vbCrLf &_ 
								" 	    and convert(datetime,a.ingr_fpago,103) between convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_corte&"',103)  "& vbCrLf &_ 
								"   ) j "& vbCrLf &_ 
								"    join alumnos f (nolock) "& vbCrLf &_ 
								" 		on j.pers_ncorr =f.pers_ncorr "& vbCrLf &_ 
								" 		and f.post_ncorr=j.post_ncorr "& vbCrLf &_ 
								" 		and f.emat_ccod not in (9) "& vbCrLf &_ 
								"    join ofertas_academicas g "& vbCrLf &_ 
								" 		on f.ofer_ncorr=g.ofer_ncorr  "& vbCrLf &_ 
								" 		and g.sede_ccod in (1,2,4,7,8)	   "& vbCrLf &_ 
								" ) as a, carreras b, areas_academicas c,facultades d   "& vbCrLf &_ 
								" where  cast(a.carr_ccod as varchar)= cast(b.carr_ccod as varchar) "& vbCrLf &_ 
								" and b.area_ccod=c.area_ccod "& vbCrLf &_ 
								" and c.facu_ccod=d.facu_ccod "& vbCrLf &_ 
								" group by a.carr_ccod,a.tipo_ingreso,b.carr_tdesc,d.facu_tdesc,d.facu_ccod,a.jorn_ccod,a.sede_ccod      "& vbCrLf &_ 
							" ) as a "& vbCrLf &_ 
							" join sedes b"& vbCrLf &_ 
							"	on a.sede_ccod=b.sede_ccod "& vbCrLf &_ 
							" where a.facu_ccod='"&p_facu&"' "& vbCrLf &_ 
							" Group by b.sede_tdesc,a.facu_ccod,a.sede_ccod,a.facultad "& vbCrLf &_
							") c "& vbCrLf &_
							" on a.sede_ccod=c.sede_ccod "
if p_facu="1" then
	'response.Write("<pre>"&sql_facultad&"</pre>")
end if
		ObtenerConsultaFacultadPareo=sql_facultad				
end function



Function ObtenerConsultaConsolidado(v_anos)

v_ano_anterior=v_anos-1
v_fecha_inicio="26/11/"&v_ano_anterior
v_fecha_corte="26/11/"&v_anos

	sql_consolidado =	" select a.sede_ccod,b.sede_tdesc, "& vbCrLf &_ 
						" cast(isnull(sum(total_arancel),0) as numeric) as arancel,cast(isnull(sum(total_titulacion),0) as numeric) as titulacion, cast(isnull(sum(total_arancel),0)+isnull(sum(total_titulacion),0) as numeric) as total "& vbCrLf &_ 
						"	From ( "& vbCrLf &_ 
							" select d.facu_ccod,d.facu_tdesc as facultad ,b.carr_tdesc as carrera, a.carr_ccod,a.tipo_ingreso,a.jorn_ccod,a.sede_ccod, "& vbCrLf &_ 
							" case tipo_ingreso when 1 then sum(monto_recaudado) end as total_arancel, "& vbCrLf &_ 
							" case tipo_ingreso when 2 then sum(monto_recaudado) end as total_titulacion "& vbCrLf &_ 
								"  from (      "& vbCrLf &_ 
								"   select protic.obtener_carrera_ingreso(a.mcaj_ncorr,a.ting_ccod,ingr_nfolio_referencia,a.pers_ncorr) as carr_ccod, "& vbCrLf &_ 
								"   1 as tipo_ingreso,a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,  "& vbCrLf &_ 
								"   case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6  "& vbCrLf &_ 
								" 	    else b.ting_ccod end as ting_ccod,     "& vbCrLf &_ 
								"   case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo  "& vbCrLf &_ 
								" 	   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado, "& vbCrLf &_ 
								" 		g.jorn_ccod,g.sede_ccod     "& vbCrLf &_ 
								" 	From ingresos a (nolock)      "& vbCrLf &_ 
								" 	left outer join detalle_ingresos b     "& vbCrLf &_ 
								" 	  on a.ingr_ncorr=b.ingr_ncorr "& vbCrLf &_ 
								" 	  and b.ting_ccod in (3,4,6,13,14,51,52,59,66)     "& vbCrLf &_ 
								" 	left outer join tipos_ingresos c       "& vbCrLf &_ 
								" 	  on b.ting_ccod=c.ting_ccod      "& vbCrLf &_ 
								" 	join abonos d (nolock) "& vbCrLf &_ 
								" 	  on a.ingr_ncorr=d.ingr_ncorr "& vbCrLf &_ 
								" 	  and d.tcom_ccod in (1,2) "& vbCrLf &_ 
								" 	join contratos e (nolock) "& vbCrLf &_ 
								" 		on d.comp_ndocto=e.cont_ncorr  "& vbCrLf &_ 
								" 		and e.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod ='"&v_anos&"') "& vbCrLf &_ 
								" 	join alumnos f  (nolock) "& vbCrLf &_ 
								" 		on e.matr_ncorr=f.matr_ncorr "& vbCrLf &_ 
								" 	join ofertas_academicas g "& vbCrLf &_ 
								" 		on f.ofer_ncorr=g.ofer_ncorr "& vbCrLf &_ 
								" 	 where a.ting_ccod  in (7)      "& vbCrLf &_ 
								" 		  and a.eing_ccod not in (3,6) "& vbCrLf &_ 
								" 		  and e.econ_ccod not in (3) "& vbCrLf &_ 
								" 		  and g.sede_ccod in ('1','2','4','7','8')    "& vbCrLf &_ 
								"  UNION	  "& vbCrLf &_ 
								"   -- Titulaciones pagadas directamente   "& vbCrLf &_ 
								"   select  protic.obtener_carrera_cargo(f.post_ncorr) as carr_ccod,j.tipo_ingreso, "& vbCrLf &_ 
								"   j.mcaj_ncorr,j.ingr_ncorr,j.ingr_nfolio_referencia,j.ding_mdetalle, j.ingr_mtotal, j.ingr_mefectivo,  "& vbCrLf &_ 
								"   j.ting_ccod, j.monto_recaudado, g.jorn_ccod,g.sede_ccod  "& vbCrLf &_ 
								"  from ( "& vbCrLf &_ 
								"    select a.pers_ncorr,2 as tipo_ingreso,a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,   "& vbCrLf &_ 
								"    case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6   "& vbCrLf &_ 
								" 	   else b.ting_ccod end as ting_ccod,  "& vbCrLf &_ 
								"    case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo   "& vbCrLf &_ 
								" 	   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado, "& vbCrLf &_ 
								"    protic.obtener_post_ncorr(a.pers_ncorr,d.comp_ndocto,a.ingr_ncorr) as post_ncorr  "& vbCrLf &_ 
								"    from ingresos a (nolock)  "& vbCrLf &_ 
								"    left outer join detalle_ingresos b   "& vbCrLf &_ 
								" 	  on a.ingr_ncorr=b.ingr_ncorr    "& vbCrLf &_ 
								" 	  and  b.ting_ccod in (3,4,6,13,14,51,52,59,66)    "& vbCrLf &_ 
								"    left outer join tipos_ingresos c    "& vbCrLf &_ 
								" 	  on b.ting_ccod=c.ting_ccod   "& vbCrLf &_ 
								"    join abonos d (nolock)  "& vbCrLf &_ 
								" 		on a.ingr_ncorr=d.ingr_ncorr   "& vbCrLf &_ 
								" 		and d.tcom_ccod=4   "& vbCrLf &_ 
								"    join detalles e (nolock)  "& vbCrLf &_ 
								" 		on d.comp_ndocto=e.comp_ndocto   "& vbCrLf &_ 
								" 		and d.tcom_ccod=e.tcom_ccod   "& vbCrLf &_ 
								" 		and e.tdet_ccod in (1230) "& vbCrLf &_ 
								"   where a.ting_ccod  in (34)  "& vbCrLf &_     
								" 	   and a.eing_ccod not in (3,6)   "& vbCrLf &_ 
								" 	   --and datepart(year,a.ingr_fpago)='"&v_anos&"'  "& vbCrLf &_
								" 	   and convert(datetime,a.ingr_fpago,103) between convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_corte&"',103)  "& vbCrLf &_ 
								"    ) j "& vbCrLf &_ 
								"    join alumnos f (nolock) "& vbCrLf &_ 
								" 		on j.pers_ncorr =f.pers_ncorr "& vbCrLf &_ 
								" 		and f.post_ncorr=j.post_ncorr "& vbCrLf &_ 
								" 		and f.emat_ccod not in (9) "& vbCrLf &_ 
								"    join ofertas_academicas g "& vbCrLf &_ 
								" 		on f.ofer_ncorr=g.ofer_ncorr  "& vbCrLf &_ 
								" 		and g.sede_ccod in ('1','2','4','7','8')   "& vbCrLf &_ 
								"  UNION   "& vbCrLf &_ 
								"    -- Titulaciones repactadas   "& vbCrLf &_ 
								" 	select protic.obtener_carrera_cargo(j.post_ncorr) as carr_ccod,j.tipo_ingreso, "& vbCrLf &_ 
								" 		  j.mcaj_ncorr,j.ingr_ncorr,j.ingr_nfolio_referencia,j.ding_mdetalle, j.ingr_mtotal, j.ingr_mefectivo,  "& vbCrLf &_ 
								" 		  j.ting_ccod, j.monto_recaudado, g.jorn_ccod,g.sede_ccod "& vbCrLf &_ 
								"  from ( "& vbCrLf &_ 
								"    Select a.pers_ncorr,2 as tipo_ingreso,a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,   "& vbCrLf &_ 
								"    case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6   "& vbCrLf &_ 
								" 	   else b.ting_ccod end as ting_ccod,   "& vbCrLf &_    
								"    case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo   "& vbCrLf &_ 
								" 	   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado, "& vbCrLf &_ 
								" 	   protic.obtener_post_ncorr(a.pers_ncorr,d.comp_ndocto,a.ingr_ncorr) as post_ncorr  "& vbCrLf &_ 
								" 	  From ingresos a (nolock)  "& vbCrLf &_ 
								" 		  left outer join detalle_ingresos b   "& vbCrLf &_ 
								" 			  on a.ingr_ncorr=b.ingr_ncorr   "& vbCrLf &_   
								" 			  and  b.ting_ccod in (3,4,6,13,14,51,52,59,66) "& vbCrLf &_ 
								" 		  left outer join tipos_ingresos c   "& vbCrLf &_ 
								" 			  on b.ting_ccod=c.ting_ccod   "& vbCrLf &_ 
								" 		  join abonos d (nolock)  "& vbCrLf &_ 
								" 				on a.ingr_ncorr=d.ingr_ncorr   "& vbCrLf &_ 
								" 				and d.tcom_ccod=3   "& vbCrLf &_ 
								" 		  join compromisos e (nolock)  "& vbCrLf &_ 
								" 				on d.comp_ndocto=e.comp_ndocto   "& vbCrLf &_ 
								" 				and d.tcom_ccod=e.tcom_ccod   "& vbCrLf &_ 
								" 		  Where a.eing_ccod not in (5,3,6)  "& vbCrLf &_ 
								" 				and a.ting_ccod=15  "& vbCrLf &_ 
								" 				and a.ingr_nfolio_referencia in ( "& vbCrLf &_  
								" 							select a.ingr_nfolio_referencia   "& vbCrLf &_ 
								" 							 from ingresos a, detalle_ingresos b, abonos c  "& vbCrLf &_  
								" 							 where a.ingr_ncorr=b.ingr_ncorr   "& vbCrLf &_ 
								" 								and a.ingr_ncorr=c.ingr_ncorr   "& vbCrLf &_ 
								" 								and c.tcom_ccod=4   "& vbCrLf &_ 
								" 								and a.ting_ccod=9   "& vbCrLf &_ 
								" 								and b.ting_ccod=9  "& vbCrLf &_ 
								" 								and a.eing_ccod=5  "& vbCrLf &_ 
								" 							)  "& vbCrLf &_ 
								" 		--and datepart(year,a.ingr_fpago)='"&v_anos&"'    "& vbCrLf &_ 
								" 	    and convert(datetime,a.ingr_fpago,103) between convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_corte&"',103)  "& vbCrLf &_ 
								"   ) j "& vbCrLf &_ 
								"    join alumnos f (nolock) "& vbCrLf &_ 
								" 		on j.pers_ncorr =f.pers_ncorr "& vbCrLf &_ 
								" 		and f.post_ncorr=j.post_ncorr "& vbCrLf &_ 
								" 		and f.emat_ccod not in (9) "& vbCrLf &_ 
								"    join ofertas_academicas g "& vbCrLf &_ 
								" 		on f.ofer_ncorr=g.ofer_ncorr  "& vbCrLf &_ 
								" 		and g.sede_ccod in ('1','2','4','7','8')	   "& vbCrLf &_ 
								" ) as a, carreras b, areas_academicas c,facultades d   "& vbCrLf &_ 
								" where  cast(a.carr_ccod as varchar)= cast(b.carr_ccod as varchar) "& vbCrLf &_ 
								" and b.area_ccod=c.area_ccod "& vbCrLf &_ 
								" and c.facu_ccod=d.facu_ccod "& vbCrLf &_ 
								" group by a.carr_ccod,a.tipo_ingreso,b.carr_tdesc,d.facu_tdesc,d.facu_ccod,a.jorn_ccod,a.sede_ccod      "& vbCrLf &_ 
							" ) as a, sedes b "& vbCrLf &_ 
							" where a.sede_ccod=b.sede_ccod "& vbCrLf &_ 
							" group by a.sede_ccod, b.sede_tdesc "

'Response.Write("<pre>"&sql_consolidado&"</pre>")
'response.End()

		ObtenerConsultaConsolidado=sql_consolidado				
end function


Function ObtenerConsultaConsolidadoPareo(v_anos)

v_ano_anterior=v_anos-1
v_fecha_inicio="26/11/"&v_ano_anterior
v_fecha_corte="26/11/"&v_anos

	sql_consolidado =	" select a.presc_sede,a.sede_tdesc,a.presc_aranceles,a.presc_titulaciones,a.presc_totales, "& vbCrLf &_
						"	isnull(b.sede_ccod,a.presc_sede)as sede_ccod,isnull(b.arancel,0) as arancel,"& vbCrLf &_
						"	isnull(b.titulacion,0) as titulacion,isnull(b.total,0) as total  from "& vbCrLf &_ 
						" (select presc_sede,sede_tdesc,sum(presc_aranceles) as presc_aranceles, "& vbCrLf &_ 
						" sum(presc_titulaciones) as presc_titulaciones, sum(presc_total) as presc_totales "& vbCrLf &_ 
						" from presupuestos_escuelas, sedes "& vbCrLf &_ 
						" where presc_sede=sede_ccod "& vbCrLf &_
						" and presc_admision='"&v_anos&"' "& vbCrLf &_  
						" group by presc_sede, sede_tdesc "& vbCrLf &_ 
						" ) a "& vbCrLf &_ 
						" left outer join "& vbCrLf &_ 
						"( select a.sede_ccod,b.sede_tdesc, "& vbCrLf &_ 
						" cast(isnull(sum(total_arancel),0) as numeric) as arancel,cast(isnull(sum(total_titulacion),0) as numeric) as titulacion, cast(isnull(sum(total_arancel),0)+isnull(sum(total_titulacion),0) as numeric) as total "& vbCrLf &_ 
						"	From ( "& vbCrLf &_ 
							" select d.facu_ccod,d.facu_tdesc as facultad ,b.carr_tdesc as carrera, a.carr_ccod,a.tipo_ingreso,a.jorn_ccod,a.sede_ccod, "& vbCrLf &_ 
							" case tipo_ingreso when 1 then sum(monto_recaudado) end as total_arancel, "& vbCrLf &_ 
							" case tipo_ingreso when 2 then sum(monto_recaudado) end as total_titulacion "& vbCrLf &_ 
								"  from (      "& vbCrLf &_ 
								"   select protic.obtener_carrera_ingreso(a.mcaj_ncorr,a.ting_ccod,ingr_nfolio_referencia,a.pers_ncorr) as carr_ccod, "& vbCrLf &_ 
								"   1 as tipo_ingreso,a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,  "& vbCrLf &_ 
								"   case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6  "& vbCrLf &_ 
								" 	    else b.ting_ccod end as ting_ccod,     "& vbCrLf &_ 
								"   case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo  "& vbCrLf &_ 
								" 	   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado, "& vbCrLf &_ 
								" 		g.jorn_ccod,g.sede_ccod     "& vbCrLf &_ 
								" 	From ingresos a (nolock)   "& vbCrLf &_ 
								" 	left outer join detalle_ingresos b     "& vbCrLf &_ 
								" 	  on a.ingr_ncorr=b.ingr_ncorr "& vbCrLf &_ 
								" 	  and b.ting_ccod in (3,4,6,13,14,51,52,59,66)     "& vbCrLf &_ 
								" 	left outer join tipos_ingresos c       "& vbCrLf &_ 
								" 	  on b.ting_ccod=c.ting_ccod      "& vbCrLf &_ 
								" 	join abonos d (nolock) "& vbCrLf &_ 
								" 	  on a.ingr_ncorr=d.ingr_ncorr "& vbCrLf &_ 
								" 	  and d.tcom_ccod in (1,2) "& vbCrLf &_ 
								" 	join contratos e (nolock) "& vbCrLf &_ 
								" 		on d.comp_ndocto=e.cont_ncorr  "& vbCrLf &_ 
								" 		and e.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod ='"&v_anos&"') "& vbCrLf &_ 
								" 	join alumnos f (nolock) "& vbCrLf &_ 
								" 		on e.matr_ncorr=f.matr_ncorr "& vbCrLf &_ 
								" 	join ofertas_academicas g "& vbCrLf &_ 
								" 		on f.ofer_ncorr=g.ofer_ncorr "& vbCrLf &_ 
								" 	 where a.ting_ccod  in (7)      "& vbCrLf &_ 
								" 		  and a.eing_ccod not in (3,6) "& vbCrLf &_ 
								" 		  and e.econ_ccod not in (3) "& vbCrLf &_ 
								" 		  and g.sede_ccod in ('1','2','4','7','8')    "& vbCrLf &_ 
								"  UNION	  "& vbCrLf &_ 
								"   -- Titulaciones pagadas directamente   "& vbCrLf &_ 
								"   select protic.obtener_carrera_cargo(f.post_ncorr) as carr_ccod,j.tipo_ingreso, "& vbCrLf &_ 
								"   j.mcaj_ncorr,j.ingr_ncorr,j.ingr_nfolio_referencia,j.ding_mdetalle, j.ingr_mtotal, j.ingr_mefectivo,  "& vbCrLf &_ 
								"   j.ting_ccod, j.monto_recaudado, g.jorn_ccod,g.sede_ccod  "& vbCrLf &_ 
								"  from ( "& vbCrLf &_ 
								"    select a.pers_ncorr,2 as tipo_ingreso,a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,   "& vbCrLf &_ 
								"    case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6   "& vbCrLf &_ 
								" 	   else b.ting_ccod end as ting_ccod,  "& vbCrLf &_ 
								"    case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo   "& vbCrLf &_ 
								" 	   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado, "& vbCrLf &_ 
								"    protic.obtener_post_ncorr(a.pers_ncorr,d.comp_ndocto,a.ingr_ncorr) as post_ncorr  "& vbCrLf &_ 
								"    from ingresos a (nolock)  "& vbCrLf &_ 
								"    left outer join detalle_ingresos b   "& vbCrLf &_ 
								" 	  on a.ingr_ncorr=b.ingr_ncorr    "& vbCrLf &_ 
								" 	  and  b.ting_ccod in (3,4,6,13,14,51,52,59,66)    "& vbCrLf &_ 
								"    left outer join tipos_ingresos c    "& vbCrLf &_ 
								" 	  on b.ting_ccod=c.ting_ccod   "& vbCrLf &_ 
								"    join abonos d (nolock) "& vbCrLf &_ 
								" 		on a.ingr_ncorr=d.ingr_ncorr   "& vbCrLf &_ 
								" 		and d.tcom_ccod=4   "& vbCrLf &_ 
								"    join detalles e (nolock)  "& vbCrLf &_ 
								" 		on d.comp_ndocto=e.comp_ndocto   "& vbCrLf &_ 
								" 		and d.tcom_ccod=e.tcom_ccod   "& vbCrLf &_ 
								" 		and e.tdet_ccod in (1230) "& vbCrLf &_ 
								"   where a.ting_ccod  in (34)  "& vbCrLf &_     
								" 	   and a.eing_ccod not in (3,6)   "& vbCrLf &_ 
								" 	   --and datepart(year,a.ingr_fpago)='"&v_anos&"'  "& vbCrLf &_
								" 	   and convert(datetime,a.ingr_fpago,103) between convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_corte&"',103)  "& vbCrLf &_ 
								"    ) j "& vbCrLf &_ 
								"    join alumnos f (nolock) "& vbCrLf &_ 
								" 		on j.pers_ncorr =f.pers_ncorr "& vbCrLf &_ 
								" 		and f.post_ncorr=j.post_ncorr "& vbCrLf &_ 
								" 		and f.emat_ccod not in (9) "& vbCrLf &_ 
								"    join ofertas_academicas g "& vbCrLf &_ 
								" 		on f.ofer_ncorr=g.ofer_ncorr  "& vbCrLf &_ 
								" 		and g.sede_ccod in ('1','2','4','7','8')   "& vbCrLf &_ 
								"  UNION   "& vbCrLf &_ 
								"    -- Titulaciones repactadas   "& vbCrLf &_ 
								" 	select protic.obtener_carrera_cargo(j.post_ncorr) as carr_ccod,j.tipo_ingreso, "& vbCrLf &_ 
								" 		  j.mcaj_ncorr,j.ingr_ncorr,j.ingr_nfolio_referencia,j.ding_mdetalle, j.ingr_mtotal, j.ingr_mefectivo,  "& vbCrLf &_ 
								" 		  j.ting_ccod, j.monto_recaudado, g.jorn_ccod,g.sede_ccod "& vbCrLf &_ 
								"  from ( "& vbCrLf &_ 
								"    Select a.pers_ncorr,2 as tipo_ingreso,a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,   "& vbCrLf &_ 
								"    case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6   "& vbCrLf &_ 
								" 	   else b.ting_ccod end as ting_ccod,   "& vbCrLf &_    
								"    case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo   "& vbCrLf &_ 
								" 	   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado, "& vbCrLf &_ 
								" 	   protic.obtener_post_ncorr(a.pers_ncorr,d.comp_ndocto,a.ingr_ncorr) as post_ncorr  "& vbCrLf &_ 
								" 	  From ingresos a (nolock)   "& vbCrLf &_ 
								" 		  left outer join detalle_ingresos b   "& vbCrLf &_ 
								" 			  on a.ingr_ncorr=b.ingr_ncorr   "& vbCrLf &_   
								" 			  and  b.ting_ccod in (3,4,6,13,14,51,52,59,66) "& vbCrLf &_ 
								" 		  left outer join tipos_ingresos c   "& vbCrLf &_ 
								" 			  on b.ting_ccod=c.ting_ccod   "& vbCrLf &_ 
								" 		  join abonos d (nolock)  "& vbCrLf &_ 
								" 				on a.ingr_ncorr=d.ingr_ncorr   "& vbCrLf &_ 
								" 				and d.tcom_ccod=3   "& vbCrLf &_ 
								" 		  join compromisos e (nolock)  "& vbCrLf &_ 
								" 				on d.comp_ndocto=e.comp_ndocto   "& vbCrLf &_ 
								" 				and d.tcom_ccod=e.tcom_ccod   "& vbCrLf &_ 
								" 		  Where a.eing_ccod not in (5,3,6)  "& vbCrLf &_ 
								" 				and a.ting_ccod=15  "& vbCrLf &_ 
								" 				and a.ingr_nfolio_referencia in ( "& vbCrLf &_  
								" 							select a.ingr_nfolio_referencia   "& vbCrLf &_ 
								" 							 from ingresos a, detalle_ingresos b, abonos c  "& vbCrLf &_  
								" 							 where a.ingr_ncorr=b.ingr_ncorr   "& vbCrLf &_ 
								" 								and a.ingr_ncorr=c.ingr_ncorr   "& vbCrLf &_ 
								" 								and c.tcom_ccod=4   "& vbCrLf &_ 
								" 								and a.ting_ccod=9   "& vbCrLf &_ 
								" 								and b.ting_ccod=9  "& vbCrLf &_ 
								" 								and a.eing_ccod=5  "& vbCrLf &_ 
								" 							)  "& vbCrLf &_ 
								" 		--and datepart(year,a.ingr_fpago)='"&v_anos&"'    "& vbCrLf &_ 
								" 	    and convert(datetime,a.ingr_fpago,103) between convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_corte&"',103)  "& vbCrLf &_ 
								"   ) j "& vbCrLf &_ 
								"    join alumnos f (nolock) "& vbCrLf &_ 
								" 		on j.pers_ncorr =f.pers_ncorr "& vbCrLf &_ 
								" 		and f.post_ncorr=j.post_ncorr "& vbCrLf &_ 
								" 		and f.emat_ccod not in (9) "& vbCrLf &_ 
								"    join ofertas_academicas g "& vbCrLf &_ 
								" 		on f.ofer_ncorr=g.ofer_ncorr  "& vbCrLf &_ 
								" 		and g.sede_ccod in ('1','2','4','7','8')	   "& vbCrLf &_ 
								" ) as a, carreras b, areas_academicas c,facultades d   "& vbCrLf &_ 
								" where  cast(a.carr_ccod as varchar)= cast(b.carr_ccod as varchar) "& vbCrLf &_ 
								" and b.area_ccod=c.area_ccod "& vbCrLf &_ 
								" and c.facu_ccod=d.facu_ccod "& vbCrLf &_ 
								" group by a.carr_ccod,a.tipo_ingreso,b.carr_tdesc,d.facu_tdesc,d.facu_ccod,a.jorn_ccod,a.sede_ccod      "& vbCrLf &_ 
							" ) as a, sedes b "& vbCrLf &_ 
							" where a.sede_ccod=b.sede_ccod "& vbCrLf &_ 
							" group by a.sede_ccod, b.sede_tdesc "& vbCrLf &_
							" ) b "& vbCrLf &_
							"on a.presc_sede=b.sede_ccod "

'Response.Write("<pre>"&sql_consolidado&"</pre>")

		ObtenerConsultaConsolidadoPareo=sql_consolidado				
end function

Function ObtenerTotales()

v_ano_anterior=v_anos-1
v_fecha_inicio="26/11/"&v_ano_anterior
v_fecha_corte="26/11/"&v_anos

sql_total=	"select '<b>Totales x Documentos:</b>' as texto, sum(cheques) as cheques,sum(letras) as letras,"& vbCrLf &_  
				"sum(efectivo) as efectivo,sum(vale_vista) as vale_vista,sum(credito) as credito,sum(debito) as debito,sum(pagare) as pagare,"& vbCrLf &_  
				"(sum(cheques)+sum(letras)+sum(efectivo)+sum(vale_vista)+sum(credito)+sum(debito)+sum(pagare)) as total"& vbCrLf &_  
				" from "& vbCrLf &_  
				" (select datepart(month,b.mcaj_finicio) as mes,isnull(max(cheque),0) as cheques,isnull(max(letra),0) as letras,    "& vbCrLf &_  
				 " isnull(max(efectivo),0) as efectivo,isnull(max(credito),0) as credito,    "& vbCrLf &_ 
				 " isnull(max(vale_vista),0) as vale_vista,isnull(max(debito),0) as debito,     "& vbCrLf &_
				 " isnull(max(pagare),0) as pagare,    "& vbCrLf &_  
				 " (isnull(max(cheque),0) + isnull(max(letra),0) + isnull(max(efectivo),0) + isnull(max(credito),0) +    "& vbCrLf &_ 
				 " isnull(max(vale_vista),0) +isnull(max(debito),0) + isnull(max(pagare),0) ) as total    "& vbCrLf &_
				 " from (      "& vbCrLf &_
				 "     select mcaj_ncorr,case ting_ccod when 3 then cast(sum(monto_recaudado) as numeric) end as cheque,    "& vbCrLf &_  
				 "     case ting_ccod when 4 then cast(sum(monto_recaudado) as numeric) end as letra,     "& vbCrLf &_
				 "     case ting_ccod when 6 then cast(sum(monto_recaudado) as numeric) end as efectivo,   "& vbCrLf &_  
				 "     case ting_ccod when 13 then cast(sum(monto_recaudado) as numeric) end as credito,     "& vbCrLf &_
				 "     case ting_ccod when 14 then cast(sum(monto_recaudado) as numeric) end as vale_vista,     "& vbCrLf &_
				 "     case ting_ccod when 51 then cast(sum(monto_recaudado) as numeric) end as debito,     "& vbCrLf &_
				 "     case ting_ccod when 52 then cast(sum(monto_recaudado) as numeric) end as pagare     "& vbCrLf &_
				 "     from (     "& vbCrLf &_
				 " -- Valores por concepto Contratos "& vbCrLf &_
				        "  select a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo, "& vbCrLf &_   
                        "  case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6 "& vbCrLf &_
                        "        else b.ting_ccod end as ting_ccod,    "& vbCrLf &_
                        "  case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo "& vbCrLf &_
						"       else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado    "& vbCrLf &_  
				        "  from ingresos a  (nolock)    "& vbCrLf &_
				        "  left outer join detalle_ingresos b    "& vbCrLf &_  
				        "      on a.ingr_ncorr=b.ingr_ncorr   "& vbCrLf &_   
				        "      and  b.ting_ccod in (3,4,6,13,14,51,52,59,66)    "& vbCrLf &_   
				        "  left outer join tipos_ingresos c      "& vbCrLf &_ 
				        "      on b.ting_ccod=c.ting_ccod     "& vbCrLf &_ 
				        "  where a.mcaj_ncorr in (select  distinct d.mcaj_ncorr "& vbCrLf &_
												" from contratos a, compromisos b, abonos c, ingresos d, movimientos_cajas e	"& vbCrLf &_
												" where a.cont_ncorr=b.comp_ndocto	"& vbCrLf &_
												" and b.comp_ndocto=c.comp_ndocto	"& vbCrLf &_
												" and b.tcom_ccod=c.tcom_ccod	"& vbCrLf &_
												" and b.inst_ccod=c.inst_ccod	"& vbCrLf &_
												" and c.ingr_ncorr=d.ingr_ncorr	"& vbCrLf &_
												" and a.econ_ccod not in (2,3)	"& vbCrLf &_
												" and d.ting_ccod in (7)	"& vbCrLf &_
												" and d.eing_ccod not in (3,6)	"& vbCrLf &_
												" and d.mcaj_ncorr=e.mcaj_ncorr	"& vbCrLf &_
												" and e.sede_ccod in (1,2,4,7,8)	"& vbCrLf &_
												" and a.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod ='"&v_anos&"')  "& vbCrLf &_
												" )        "& vbCrLf &_
				        "  and a.ting_ccod  in (7)     "& vbCrLf &_
						"  and a.eing_ccod not in (3,6)     "& vbCrLf &_  
				" UNION	 "& vbCrLf &_					
								"  -- Titulaciones pagadas directamente  "& vbCrLf &_
				"   select a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,  "& vbCrLf &_
				"   case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6  "& vbCrLf &_
				" 	   else b.ting_ccod end as ting_ccod, "& vbCrLf &_    
				"   case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo  "& vbCrLf &_
				" 	   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado  "& vbCrLf &_    
				"   from ingresos a  (nolock)  "& vbCrLf &_    
				"   left outer join detalle_ingresos b  "& vbCrLf &_   
				" 	  on a.ingr_ncorr=b.ingr_ncorr   "& vbCrLf &_ 
				" 	  and  b.ting_ccod in (3,4,6,13,14,51,52,59,66)   "& vbCrLf &_  
				"   left outer join tipos_ingresos c   "& vbCrLf &_    
				" 	  on b.ting_ccod=c.ting_ccod  "& vbCrLf &_
				"   join abonos d (nolock) "& vbCrLf &_
				" 	on a.ingr_ncorr=d.ingr_ncorr  "& vbCrLf &_
				" 	and d.tcom_ccod=4  "& vbCrLf &_
				"   join detalles e  "& vbCrLf &_
				" 	on d.comp_ndocto=e.comp_ndocto  "& vbCrLf &_
				" 	and d.tcom_ccod=e.tcom_ccod  "& vbCrLf &_
				" 	and e.tdet_ccod in (1230)	  "& vbCrLf &_ 
				"   where a.mcaj_ncorr in ( "& vbCrLf &_ 
				" 						select  distinct e.mcaj_ncorr "& vbCrLf &_ 
									" 	 from compromisos b, abonos c, ingresos d, movimientos_cajas e, detalles f	 "& vbCrLf &_ 
									" 	 where b.comp_ndocto=c.comp_ndocto	 "& vbCrLf &_ 
									" 	 and b.tcom_ccod=c.tcom_ccod	 "& vbCrLf &_ 
									" 	 and b.inst_ccod=c.inst_ccod	 "& vbCrLf &_ 
									" 	 and c.ingr_ncorr=d.ingr_ncorr	 "& vbCrLf &_ 
									" 	 and d.ting_ccod in (34)	 "& vbCrLf &_ 
									" 	 and d.eing_ccod not in (3,6)	 "& vbCrLf &_ 
									" 	 and d.mcaj_ncorr=e.mcaj_ncorr "& vbCrLf &_ 
									" 	 and b.tcom_ccod=4	 "& vbCrLf &_ 
									" 	 and e.sede_ccod in (1,2,4,7,8) "& vbCrLf &_ 
									" 	 and b.tcom_ccod=f.tcom_ccod "& vbCrLf &_ 
									" 	 and b.comp_ndocto=f.comp_ndocto "& vbCrLf &_ 
									" 	 and f.tdet_ccod in (1230)	 "& vbCrLf &_ 
				"  ) "& vbCrLf &_ 
				"   and a.ting_ccod  in (34)     "& vbCrLf &_  
				"   and a.eing_ccod not in (3,6)  "& vbCrLf &_ 
				"   --and datepart(year,a.ingr_fpago)='"&v_anos&"' "& vbCrLf &_ 
				" 	and convert(datetime,a.ingr_fpago,103) between convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_corte&"',103)  "& vbCrLf &_ 
              " UNION  "& vbCrLf &_ 
				"   -- Titulaciones repactadas  "& vbCrLf &_ 
				"   Select a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo,  "& vbCrLf &_ 
				"   case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6  "& vbCrLf &_ 
				" 	   else b.ting_ccod end as ting_ccod,     "& vbCrLf &_ 
				"   case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo  "& vbCrLf &_ 
				" 	   else (b.ding_mdetalle - protic.documento_pagado_bancaj(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado  "& vbCrLf &_    
				"  From ingresos a (nolock) "& vbCrLf &_ 
				"   left outer join detalle_ingresos b  "& vbCrLf &_    
				" 	  on a.ingr_ncorr=b.ingr_ncorr    "& vbCrLf &_ 
				" 	  and  b.ting_ccod in (3,4,6,13,14,51,52,59,66) "& vbCrLf &_ 
				"  left outer join tipos_ingresos c  "& vbCrLf &_      
				" 	  on b.ting_ccod=c.ting_ccod  "& vbCrLf &_ 
				"   join abonos d (nolock) "& vbCrLf &_ 
				" 		on a.ingr_ncorr=d.ingr_ncorr  "& vbCrLf &_ 
				" 		and d.tcom_ccod=3  "& vbCrLf &_ 
				"    join compromisos e (nolock) "& vbCrLf &_ 
				" 	on d.comp_ndocto=e.comp_ndocto  "& vbCrLf &_ 
				" 	and d.tcom_ccod=e.tcom_ccod  "& vbCrLf &_ 
				" 	and e.sede_ccod in (1,2,4,7,8)    "& vbCrLf &_              
				"  Where ingr_nfolio_referencia in ( "& vbCrLf &_ 
				" 		select a.ingr_nfolio_referencia  "& vbCrLf &_ 
				 		" from ingresos a, detalle_ingresos b, abonos c  "& vbCrLf &_ 
						" where a.ingr_ncorr=b.ingr_ncorr  "& vbCrLf &_ 
						" 	and a.ingr_ncorr=c.ingr_ncorr  "& vbCrLf &_ 
						" 	and c.tcom_ccod=4  "& vbCrLf &_ 
						" 	and a.ting_ccod=9  "& vbCrLf &_ 
						" 	and b.ting_ccod=9 "& vbCrLf &_ 
						" 	and a.eing_ccod=5 "& vbCrLf &_ 
				" ) "& vbCrLf &_ 
				" and a.eing_ccod not in (5,3,6) "& vbCrLf &_ 
				" and a.ting_ccod=15 "& vbCrLf &_ 
				" --and datepart(year,a.ingr_fpago)='"&v_anos&"'   "& vbCrLf &_ 
				" and convert(datetime,a.ingr_fpago,103) between convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_corte&"',103)  "& vbCrLf &_ 
				 "     ) as tabla      "& vbCrLf &_
				 "     group by mcaj_ncorr,ting_ccod      "& vbCrLf &_
				 " ) a      "& vbCrLf &_
				 " join movimientos_cajas b (nolock)  "& vbCrLf &_   
				 "     on a.mcaj_ncorr=b.mcaj_ncorr    "& vbCrLf &_
				 " 	  and b.tcaj_ccod in (1000)   "& vbCrLf &_   
			"	 group by b.mcaj_finicio "& vbCrLf &_  
			"    ) as tabla  "
 
'response.Write("<pre>"&sql_total&"</pre>")
'response.Flush()

		Obtenertotales=sql_total				

end function

%>
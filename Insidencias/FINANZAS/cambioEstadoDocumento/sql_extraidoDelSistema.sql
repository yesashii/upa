select ingr_ncorr, 
       ingr_ncorr                                                                                                               as ingr_ncorr2,
       b.inst_ccod, 
       b.comp_ndocto, 
       b.tcom_ccod, 
       case 
         when b.tcom_ccod in ( 1, 2 ) then Cast (b.comp_ndocto as varchar) + ' (' 
                                           + protic.numero_contrato (b.comp_ndocto) + ')' 
         else Cast (b.comp_ndocto as varchar) 
       end                                                                                                                      as ncompromiso,
       case 
         when b.tcom_ccod = 25 
               or b.tcom_ccod = 4 
               or b.tcom_ccod = 5 
               or b.tcom_ccod = 8 
               or b.tcom_ccod = 10 
               or b.tcom_ccod = 26 
               or b.tcom_ccod = 34 
               or b.tcom_ccod = 35 
               or b.tcom_ccod = 15 then (select top 1 a1.tdet_tdesc 
                                         from   tipos_detalle a1, 
                                                detalles a2 
                                         where  a2.tcom_ccod = a.tcom_ccod 
                                                and a2.inst_ccod = a.inst_ccod 
                                                and a2.comp_ndocto = a.comp_ndocto 
                                                and a1.tdet_ccod = a2.tdet_ccod) 
         when b.tcom_ccod = 37 then (select a3.tcom_tdesc 
                                     from   tipos_compromisos a3 
                                     where  a3.tcom_ccod = a.tcom_ccod) 
                                    + '-' 
                                    + protic.obtener_nombre_carrera (a.ofer_ncorr, 'CJ') 
         else (select a3.tcom_tdesc 
               from   tipos_compromisos a3 
               where  a3.tcom_ccod = a.tcom_ccod) 
       end                                                                                                                      as tcom_tdesc,
       b.dcom_ncompromiso, 
       Cast ( b.dcom_ncompromiso as varchar ) + '/' 
       + Cast (a.comp_ncuotas as varchar)                                                                                       as ncuota,
       protic.trunc (a.comp_fdocto)                                                                                             as comp_fdocto,
       protic.trunc (b.dcom_fcompromiso)                                                                                        as dcom_fcompromiso,
       b.dcom_mcompromiso, 
       protic.documento_asociado_cuota (b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')               as ting_ccod,
       case 
         when a.tcom_ccod = 2 
              and protic.documento_asociado_cuota (b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = 52 then (select pag.paga_ncorr
                                                                                                                                        from   pagares pag
                                                                                                                                        where  pag.cont_ncorr = a.comp_ndocto
                                                                                                                                               and isnull(pag.opag_ccod, 1) not in (
                                                                                                                                                   2 ))
         else protic.documento_asociado_cuota (b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto')
       end                                                                                                                      as ding_ndocto,
       protic.total_abonado_cuota (b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)                                 as abonos,
       protic.total_abono_documentado_cuota (b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)                       as documentado,
       isnull(b.dcom_mcompromiso, 0) - protic.total_abonado_cuota (b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo,
       (select d.edin_ccod 
        from   estados_detalle_ingresos d 
        where  c.edin_ccod = d.edin_ccod)                                                                                       as edin_ccod,
				c.ting_ccod,
				c.ding_ndocto,
				c.ingr_ncorr,
       (select d.edin_tdesc 
               + protic.obtener_institucion (c.ingr_ncorr) 
        from   estados_detalle_ingresos d 
        where  c.edin_ccod = d.edin_ccod)                                                                                       as edin_tdesc
from   compromisos a 
       inner join detalle_compromisos b 
               on a.tcom_ccod = b.tcom_ccod 
                  and a.inst_ccod = b.inst_ccod 
                  and a.comp_ndocto = b.comp_ndocto 
       left outer join detalle_ingresos c 
                    on protic.documento_asociado_cuota (b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod
                       and protic.documento_asociado_cuota (b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto
                       and protic.documento_asociado_cuota (b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr
where  a.ecom_ccod = '1' 
       and b.ecom_ccod <> '3' 
       and Cast (a.pers_ncorr as varchar) = '195865' 
       and c.edin_ccod in ( 4, 10, 100 ) 
order  by b.dcom_fcompromiso desc 
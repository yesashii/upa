-- consulta que imprime los resultados del reporte fangorn.upacifico.cl/sigaupa/reportesnet/imprimir_repactacion.aspx?repa_ncorr=p_repa_ncorr

-- se divide en dos partes 

select 1                                                                                      as ORDEN,
       'Se cambian documentos :'                                                              as ENCABEZADO,
       a.ting_ccod, 
       a.ingr_ncorr, 
       case g.ting_ccod 
         when 52 then Cast(a.ding_ndocto as varchar) 
         else 
           case g.ting_ccod 
             when 173 then null 
             else Cast(a.ding_ndocto as varchar) 
           end 
       end                                                                                    as DING_NDOCTO,
       d.banc_tdesc, 
       a.ding_fdocto, 
       d.banc_ccod, 
       case a.ting_ccod when 52 then 'PAG. TRANS.' else g.ting_tdesc end + ' ' + h.edin_tdesc as TING_TDESC,
       a.ding_mdetalle                                                                        as MONTO1,
       0                                                                                      as MONTO2,
       e.abon_mabono                                                                          as MONTO3
from   detalle_ingresos a 
       inner join ingresos b 
               on a.ingr_ncorr = b.ingr_ncorr 
                  and ( Cast(a.repa_ncorr as varchar) = '" + p_repa_ncorr + "' ) 
                  and ( b.eing_ccod <> 3 ) 
       inner join abonos c 
               on b.ingr_ncorr = c.ingr_ncorr 
       inner join tipos_ingresos g 
               on a.ting_ccod = g.ting_ccod 
       inner join abonos e 
               on c.tcom_ccod = e.tcom_ccod 
                  and c.inst_ccod = e.inst_ccod 
                  and c.comp_ndocto = e.comp_ndocto 
                  and c.dcom_ncompromiso = e.dcom_ncompromiso 
       inner join ingresos f 
               on e.ingr_ncorr = f.ingr_ncorr 
                  and a.repa_ncorr = f.ingr_nfolio_referencia 
                  and ( f.ting_ccod = 9 ) 
                  and ( f.eing_ccod = 5 ) 
                  and ( isnull(f.ingr_mtotal, 0) > 0 ) 
       left outer join bancos d 
                    on a.banc_ccod = d.banc_ccod 
       left outer join estados_detalle_ingresos h 
                    on a.edin_ccod = h.edin_ccod 
where  case a.ting_ccod when 52 then 'PAG. TRANS.' else g.ting_tdesc end + ' ' + h.edin_tdesc is not null
union 
select 2                     as ORDEN, 
       'Nuevos documentos :' as ENCABEZADO, 
       f.ting_ccod, 
       f.ingr_ncorr, 
       case f.ting_ccod 
         when 52 then Cast(f.ding_ndocto as varchar) 
         else 
           case f.ting_ccod 
             when 173 then null 
             else Cast(f.ding_ndocto as varchar) 
           end 
       end                   as DING_NDOCTO, 
       g.banc_tdesc, 
       f.ding_fdocto, 
       g.banc_ccod, 
       case f.ting_ccod 
         when 52 then 'PAG. TRANS.' 
         else h.ting_tdesc 
       end                   as TING_TDESC, 
       c.dcom_mneto          as MONTO1, 
       c.dcom_mintereses     as MONTO2, 
       f.ding_mdetalle       as MONTO3 
from   repactaciones a 
       inner join compromisos b 
               on a.repa_ncorr = b.comp_ndocto 
                  and ( a.repa_ncorr = " + p_repa_ncorr + " ) 
                  and ( b.tcom_ccod = 3 ) 
       inner join detalle_compromisos c 
               on b.tcom_ccod = c.tcom_ccod 
                  and b.inst_ccod = c.inst_ccod 
                  and b.comp_ndocto = c.comp_ndocto 
       inner join abonos d 
               on c.tcom_ccod = d.tcom_ccod 
                  and c.inst_ccod = d.inst_ccod 
                  and c.comp_ndocto = d.comp_ndocto 
                  and c.dcom_ncompromiso = d.dcom_ncompromiso 
       inner join ingresos e 
               on d.ingr_ncorr = e.ingr_ncorr 
                  and a.repa_ncorr = e.ingr_nfolio_referencia 
                  and ( e.eing_ccod = 4 ) 
                  and ( e.ting_ccod = 15 ) 
       inner join detalle_ingresos f 
               on e.ingr_ncorr = f.ingr_ncorr 
       inner join tipos_ingresos h 
               on f.ting_ccod = h.ting_ccod 
       left outer join bancos g 
                    on f.banc_ccod = g.banc_ccod 
order  by orden asc, 
          a.ting_ccod asc, 
          a.ding_fdocto asc 
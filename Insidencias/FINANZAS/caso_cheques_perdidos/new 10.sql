
-- para ingr_ncorr 1386198

/*
Datos del ingreso:
select * from INGRESOS where INGR_NCORR = 1386198

INGR_NCORR	MCAJ_NCORR	EING_CCOD	INGR_FPAGO	INGR_MEFECTIVO	INGR_MDOCTO	INGR_MTOTAL	INGR_NESTADO	INGR_NFOLIO_REFERENCIA	TING_CCOD	AUDI_TUSUARIO	AUDI_FMODIFICACION	INST_CCOD	INGR_MINTERESES	INGR_MMULTAS	PERS_NCORR	INGR_MANTICIPADO	INEM_CCOD	TMOV_CCOD	GLOSA_FOX	INGR_NCORRELATIVO_CAJA	MCAJ_NCORR_ORIGEN
1386198	20869	4	2014-11-20 00:00:00.000	0.00	337300.00	337300.00	1	704183	34	13721634	2014-11-20 13:45:14.493	1	NULL	NULL	201964	0.00	1	1	NULL	15	NULL

select * from DETALLE_INGRESOS where INGR_NCORR = 1386198
TING_CCOD	DING_NDOCTO	INGR_NCORR	DING_NSECUENCIA	DING_NCORRELATIVO	PLAZ_CCOD	BANC_CCOD	DING_FDOCTO	DING_MDETALLE	DING_MDOCTO	DING_TCUENTA_CORRIENTE	EDIN_CCOD	ENVI_NCORR	REPA_NCORR	DING_BPACTA_CUOTA	PERS_NCORR_CODEUDOR	AUDI_TUSUARIO	AUDI_FMODIFICACION	ding_tplaza_sbif	esed_ncorr	sede_actual
3	3096970	1386198	999583511	1	1	1	2014-12-20 00:00:00.000	337300.00	337300.00	2200978306	1	63633	NULL	N	NULL	14205430	2016-01-12 16:06:46.080		NULL	NULL

select * from ABONOS where INGR_NCORR = 1386198
INGR_NCORR	TCOM_CCOD	INST_CCOD	COMP_NDOCTO	DCOM_NCOMPROMISO	DCOM_MTRASPASADO	ABON_FABONO	ABON_MABONO	AUDI_TUSUARIO	AUDI_FMODIFICACION	PERS_NCORR	PERI_CCOD	INEM_CCOD
1386198	2	1	146943	7	NULL	2014-11-20 00:00:00.000	316400.00	13721634	2014-11-20 13:45:14.600	201964	236	1
1386198	2	1	146943	8	NULL	2014-11-20 00:00:00.000	20900.00	13721634	2014-11-20 13:45:14.707	201964	236	1




*/












/* [protic].[total_abonado_cuota] */

SELECT Isnull(dcom_mcompromiso, 0) - 
                       protic.Total_abonado_cuota(tcom_ccod, inst_ccod, 
                                comp_ndocto, dcom_ncompromiso) - 
                       protic.Total_abono_documentado_cuota(tcom_ccod, inst_ccod 
                       , 
                       comp_ndocto, 
                dcom_ncompromiso 
                ) as total
FROM   detalle_compromisos 
WHERE  tcom_ccod 			= 2
       AND inst_ccod 		= 1
       AND comp_ndocto 		= 146943
       AND dcom_ncompromiso = 7 

/*
total
0.00
-- dcom_mcompromiso -- 358200.00
-- select protic.Total_abonado_cuota(2, 1, 146943, 7) -- 41800
-- select protic.Total_abono_documentado_cuota(2, 1, 146943, 7) -- 316400  


*/

SELECT Isnull(dcom_mcompromiso, 0) - 
                       protic.Total_abonado_cuota(tcom_ccod, inst_ccod, 
                                comp_ndocto, dcom_ncompromiso) - 
                       protic.Total_abono_documentado_cuota(tcom_ccod, inst_ccod 
                       , 
                       comp_ndocto, 
                dcom_ncompromiso 
                ) as total
FROM   detalle_compromisos 
WHERE  tcom_ccod 			= 2
       AND inst_ccod 		= 1
       AND comp_ndocto 		= 146943
       AND dcom_ncompromiso = 8

/*
total
0.00
*/






/* [protic].[total_abonado_cuota] */


select isnull(sum(isnull( case c.ting_brebaje 
											when 'S' then 
												a.abon_mabono*(-1)
                                            else a.abon_mabono 
                                            end , 0)), 0)
from abonos a (nolock)
	    join ingresos b (nolock)
	        on a.ingr_ncorr = b.ingr_ncorr
	    left outer join tipos_ingresos c (nolock)
	        on b.ting_ccod = c.ting_ccod 
		left outer join notascreditos_documentos d (nolock)
	        on b.ingr_ncorr = d.ingr_ncorr_notacredito
	    left outer join ingresos e (nolock)
	        on d.ingr_ncorr_documento = e.ingr_ncorr 
		where  b.eing_ccod in (1,5,6,8) -- ACTIVO, PAGADO POR REPACTACION, ANULADO, ANULACION ABONO
		  	and isnull(e.eing_ccod, 0) <> 4 --Si el ingreso original era documentado, no se le debe rebajar...
	        and a.tcom_ccod			= 2
	        and a.inst_ccod			= 1
	        and a.comp_ndocto		= 146943
	        and a.dcom_ncompromiso	= 7
			
			
-- = 41800.00


select isnull(sum(isnull( case c.ting_brebaje 
											when 'S' then 
												a.abon_mabono*(-1)
                                            else a.abon_mabono 
                                            end , 0)), 0)
from abonos a (nolock)
	    join ingresos b (nolock)
	        on a.ingr_ncorr = b.ingr_ncorr
	    left outer join tipos_ingresos c (nolock)
	        on b.ting_ccod = c.ting_ccod 
		left outer join notascreditos_documentos d (nolock)
	        on b.ingr_ncorr = d.ingr_ncorr_notacredito
	    left outer join ingresos e (nolock)
	        on d.ingr_ncorr_documento = e.ingr_ncorr 
		where  b.eing_ccod in (1,5,6,8)
		  	and isnull(e.eing_ccod, 0) <> 4 --Si el ingreso original era documentado, no se le debe rebajar...
	        and a.tcom_ccod			= 2
	        and a.inst_ccod			= 1
	        and a.comp_ndocto		= 146943
	        and a.dcom_ncompromiso	= 8

-- = 0			


/* [protic].[total_abonado_cuota] */

SELECT Isnull(Sum(Isnull(CASE c.ting_brebaje 
                           WHEN 'S' THEN a.abon_mabono * ( -1 ) 
                           ELSE a.abon_mabono 
                         END, 0)), 0) AS v_abonado 
FROM   abonos a (nolock) 
       JOIN ingresos b (nolock) 
         ON a.ingr_ncorr = b.ingr_ncorr 
            AND a.tcom_ccod = @p_tcom_ccod 
            AND a.inst_ccod = @p_inst_ccod 
            AND a.comp_ndocto = @p_comp_ndocto 
            AND a.dcom_ncompromiso = @p_dcom_ncompromiso 
            AND b.eing_ccod = 4 
       JOIN tipos_ingresos c (nolock) 
         ON b.ting_ccod = c.ting_ccod 
       JOIN detalle_ingresos d (nolock) 
         ON b.ingr_ncorr = d.ingr_ncorr 
            AND d.ting_ccod IN ( 3, 14, 13, 51 ) 
            AND d.edin_ccod NOT IN ( 6, 11, 9, 51 ) 
            AND Isnull(d.ding_bpacta_cuota, 'N') = 'N' 
            AND d.ding_ncorrelativo > 0 



-- --------------------------------------------------------------------------------------------------------------


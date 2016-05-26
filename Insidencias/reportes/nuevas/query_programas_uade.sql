select a.comp_ndocto,sum(f.abon_mabono)as monto_pago,g.ingr_nfolio_referencia as comprobante,
protic.trunc(max(g.ingr_fpago)) as fecha_inscripcion,
d.tdet_tdesc as programa, protic.obtener_nombre(b.pers_ncorr,'n') as alumno,protic.obtener_rut(b.pers_ncorr) as rut,
protic.obtener_direccion_letra(b.pers_ncorr,1,'CNPB') as direccion--, max(e.pers_tfono) as telefono
    from compromisos a 
    join detalle_compromisos b     
		on a.tcom_ccod = b.tcom_ccod        
		and a.inst_ccod = b.inst_ccod        
		and a.comp_ndocto = b.comp_ndocto 
        and a.ecom_ccod = '1'
     join detalles c
        on c.tcom_ccod = b.tcom_ccod        
		and c.inst_ccod = b.inst_ccod        
		and c.comp_ndocto = b.comp_ndocto
     join tipos_detalle d
        on c.tdet_ccod=d.tdet_ccod
     join personas e
        on b.pers_ncorr=e.pers_ncorr
     join abonos f
        on b.tcom_ccod = f.tcom_ccod        
		and b.inst_ccod = f.inst_ccod        
		and b.comp_ndocto = f.comp_ndocto 
        and b.dcom_ncompromiso = f.dcom_ncompromiso
     join ingresos g
        on f.ingr_ncorr=g.ingr_ncorr
        and g.eing_ccod not in (3,6)
        and g.ting_ccod in (16,34)
where a.tcom_ccod=25
and c.tdet_ccod in (1379,1380)
group by g.ingr_nfolio_referencia,b.pers_ncorr,c.tdet_ccod,d.tdet_tdesc ,a.comp_ndocto
order by c.tdet_ccod,rut




--select * from ingresos where ingr_nfolio_referencia=47181
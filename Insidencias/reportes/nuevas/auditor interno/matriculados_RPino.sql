--Rut
--Carrera+sede+jornada
--Promoción
--Fecha contrato
--Valor Arancel
--Valor Matricula
--Estado matrícula
--Tipo alumno(nuevo/antiguo)

 select distinct cast(a.pers_nrut as varchar)+'-'+ a.pers_xdv as rut,
   h.sede_tdesc as sede,f.carr_tdesc as carrera, g.jorn_tdesc as jornada,
   protic.ano_ingreso_carrera (a.pers_ncorr,e.carr_ccod) as promoción, 
   protic.trunc(alum_fmatricula)as fecha_matricula,
   ara.aran_mmatricula as monto_matricula,
   ara.aran_mcolegiatura as monto_arancel,
   case c.post_bnuevo when 'N' then 'ANTIGUO' else 'NUEVO' end as tipo, 
  (select emat_tdesc from estados_matriculas emat 
    where emat.emat_ccod in (select top 1 emat_ccod from alumnos a1, ofertas_academicas o1 where a1.pers_ncorr=d.pers_ncorr and a1.ofer_ncorr=o1.ofer_ncorr and o1.espe_ccod = c.espe_ccod and a1.emat_ccod <> 9 order by o1.peri_ccod desc, convert(datetime,a1.audi_fmodificacion) desc)) 
    as estado_academico
   from personas_postulante a join alumnos d 
        on a.pers_ncorr = d.pers_ncorr  
    join ofertas_academicas c 
        on c.ofer_ncorr = d.ofer_ncorr   
    join ARANCELES ARA 
        on ARA.ARAN_NCORR = C.ARAN_NCORR   
     join periodos_Academicos pea on c.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)='2009'
    left outer join tipos_ensenanza_media tip_ens 
        on a.tens_ccod = tip_ens.tens_ccod    
    join postulantes pos 
        on pos.post_ncorr = d.post_ncorr 
    join paises pai 
        on pai.pais_ccod = isnull(a.pais_ccod,0) 
    left outer join colegios k 
        on a.cole_ccod = k.cole_ccod   
    join especialidades e 
        on c.espe_ccod  = e.espe_ccod 
    left outer join planes_estudio pl 
        on d.plan_ccod = pl.plan_ccod 
    join carreras f 
        on e.carr_ccod=f.carr_ccod  and f.tcar_ccod=1--and f.carr_ccod='23'
    join jornadas g 
        on c.jorn_ccod=g.jorn_ccod 
    join sedes h 
        on c.sede_ccod=h.sede_ccod 
    left outer join direcciones i 
        on a.pers_ncorr = i.pers_ncorr  
    left outer join direcciones dire2 
        on a.pers_ncorr = dire2.pers_ncorr    and 2 = dire2.tdir_ccod 
    left outer join ciudades j 
        on i.ciud_ccod = j.ciud_ccod 
    left outer join regiones reg 
        on j.regi_ccod = reg.regi_ccod  
    left outer join ciudades ciud2 
        on dire2.ciud_ccod = ciud2.ciud_ccod    
    left outer join ciudades l 
        on k.ciud_ccod = l.ciud_ccod 
    left outer join tipos_colegios m 
        on k.tcol_ccod = m.tcol_ccod 
    join contratos cont
        on d.matr_ncorr = cont.matr_ncorr and d.post_ncorr = cont.post_ncorr 
    left outer join codeudor_postulacion copo 
        on pos.post_ncorr = copo.post_ncorr 
    left outer join personas_postulante pers2
        on copo.pers_ncorr = pers2.pers_ncorr 
 where cont.econ_ccod = 1 
 and d.emat_ccod not in (9) 
 and i.tdir_ccod = 1 --and f.carr_ccod='23'
 and exists (select 1 from contratos cont1, compromisos comp1 where d.post_ncorr=cont1.post_ncorr and d.matr_ncorr=cont1.matr_ncorr and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2) )  
 group by a.pers_ncorr, e.carr_ccod, c.peri_ccod,a.pers_nrut,a.pers_xdv, a.pers_tnombre,a.pers_tape_paterno,ara.aran_mmatricula,ara.aran_mcolegiatura, 
         a.pers_tape_materno,a.pers_fnacimiento,d.matr_ncorr,f.carr_tdesc,c.post_bnuevo,d.alum_fmatricula,g.jorn_tdesc,h.sede_tdesc, 
         i.dire_tcalle,pai.pais_tdesc,i.dire_tnro,i.dire_tpoblacion,i.dire_tblock,i.dire_tfono,j.ciud_tdesc,j.ciud_tcomuna, 
         dire2.dire_tcalle,dire2.dire_tnro,dire2.dire_tpoblacion,dire2.dire_tblock,dire2.dire_tfono,e.espe_tdesc,pl.plan_tdesc, 
         ciud2.ciud_tdesc,ciud2.ciud_tcomuna,k.cole_tdesc,l.ciud_tdesc,l.ciud_tcomuna,a.pers_nnota_ens_media, reg.regi_tdesc,
         m.tcol_tdesc,a.pers_nano_egr_media,a.sexo_ccod,pos.tpad_ccod,pos.post_npaa_verbal,pos.POST_NANO_PAA,f.area_ccod, pea.anos_ccod, 
         pos.post_npaa_matematicas,pos.post_nano_paa,pos.post_tinstitucion_anterior,a.pers_tcole_egreso,a.pers_ttipo_ensenanza,tip_ens.tens_ccod,tens_tdesc,
         cont.cont_fcontrato, d.audi_fmodificacion,c.espe_ccod,d.pers_ncorr,a.pers_fnacimiento,a.sexo_ccod,ARA.ARAN_MMATRICULA,ARA.ARAN_MCOLEGIATURA,
		 pers2.pers_ncorr,pers2.pers_nrut,pers2.pers_xdv,a.pers_temail,pers2.pers_tnombre,pers2.pers_tape_paterno,pers2.pers_tape_materno,pers2.pers_fnacimiento 
         order by sede,carrera,jornada



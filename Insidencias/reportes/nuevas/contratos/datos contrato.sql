select top 1 case when protic.es_nuevo_carrera(pp.pers_ncorr, ccc.carr_ccod, oa.peri_ccod) <> 's' then '  ' end  as text_antiguo,
			 jorn_tdesc as jornada, case when pp.pers_temail_uas is null then 
			            ', correo electrónico: ' + lower(pp.pers_temail) 
			       else 
			            ', correo electrónico: ' + lower(pp.pers_temail_uas) 
			       end email_alumno, 
			       case when estados_civiles.eciv_tdesc is not null then 
			            ', estado civil: ' + estados_civiles.eciv_tdesc 
			       end ecivil_alumno, 
			       case when paises.pais_tdesc is not null then 
			            ', nacionalidad: ' + paises.pais_tnacionalidad  
			       end nacionalidad_alumno, 
			       case when pp.pers_tprofesion is not null then 
			            ', profesión: ' + pp.pers_tprofesion 
			       end profesion_alumno, 
			       case when ppc.pers_temail_uas is null then 
			            ', correo electrónico: ' + lower(ppc.pers_temail) 
			       else 
			            ', correo electrónico: ' + lower(ppc.pers_temail_uas) 
			       end email_codeudor, 
			       case when ecivppr.eciv_tdesc is not null then 
			            ', estado civil: ' + ecivppr.eciv_tdesc 
			       end ecivil_codeudor, 
			       case when paisesppr.pais_tdesc is not null then 
			            ', nacionalidad: ' + paisesppr.pais_tnacionalidad 
			       end nacionalidad_codeudor, 
			       case when ppc.pers_tprofesion is not null then 
			            ', profesión: ' + ppc.pers_tprofesion 
			       end profesion_codeudor,'contrato' as nombre_informe, isnull(cc.contrato,cc.cont_ncorr) nro_contrato,  
				   case when ee.espe_ccod=286 then datepart(dd,cc.cont_fcontrato) else datepart(dd,getdate()) end dd_hoy,
				   (select mes_tdesc from meses where mes_ccod=case when ee.espe_ccod=286 then datepart(mm,cc.cont_fcontrato) else datepart(mm,getdate()) end ) mm_hoy, 
			       case when ee.espe_ccod=286 then datepart(yyyy,cc.cont_fcontrato) else datepart(yyyy,getdate()) end yy_hoy,  
				   iin.inst_trazon_social nombre_institucion,  
			       pac.anos_ccod periodo_academico, convert(varchar,iin.inst_nrut)+'-'+iin.inst_xdv rut_institucion,  
			       ppr.pers_tnombre +' '+ ppr.pers_tape_paterno + ' ' + ppr.pers_tape_materno nombre_representante,  
			       convert(varchar,pp.pers_nrut) +'-'+pp.pers_xdv as rut_alumno,  
			       pp.pers_tnombre +' '+ pp.pers_tape_paterno + ' ' + pp.pers_tape_materno nombre_alumno,  
			       case when ee.carr_ccod=12 then protic.obtener_nombre_carrera(p.ofer_ncorr,'ce') else ccc.carr_tdesc end as carrera,
			       convert(varchar,ppc.pers_nrut) +'-'+ppc.pers_xdv as rut_codeudor,  
			       ppc.pers_tnombre +' '+ ppc.pers_tape_paterno + ' ' + ppc.pers_tape_materno as nombre_codeudor,  
			       ddp.dire_tcalle +' ' + ddp.dire_tnro+' '+ case ddp.dire_tblock when '' then '' else 'depto '+cast(ddp.dire_tblock as varchar) end as direccion_codeudor,  
                   (select top 1 ddpa.dire_tcalle +' ' + ddpa.dire_tnro+' '+ case ddpa.dire_tblock when '' then '' else 'depto '+cast(ddpa.dire_tblock as varchar) end  from direcciones_publica ddpa where ddpa.pers_ncorr=pp.pers_ncorr and tdir_ccod=1) as direccion_alumno,  
				   c.ciud_tdesc ciudad, c.ciud_tcomuna comuna,
                   (select cia.ciud_tdesc from ciudades cia where cia.ciud_ccod = (select top 1 ddpa.ciud_ccod from direcciones_publica ddpa where ddpa.pers_ncorr=pp.pers_ncorr and ddpa.tdir_ccod=1) ) as ciudad_alumno,
                   (select cia.ciud_tcomuna from ciudades cia where cia.ciud_ccod = (select top 1 ddpa.ciud_ccod from direcciones_publica ddpa where ddpa.pers_ncorr=pp.pers_ncorr and ddpa.tdir_ccod=1) ) as comuna_alumno,
				   sd.sede_tdesc as sede,(select ciud_tdesc from ciudades where ciud_ccod=sd.ciud_ccod) as comuna_sede,
				   (select isnull(cast(comp_mdocumento as numeric),0) from compromisos where comp_ndocto=cc.cont_ncorr and tcom_ccod=1) as matricula,
                   (select isnull(cast(comp_mdocumento as numeric),0) from compromisos where comp_ndocto=cc.cont_ncorr and tcom_ccod=2) as arancel
			from postulantes p 
			     join personas_postulante pp 
                    on p.pers_ncorr=pp.pers_ncorr
			     join ofertas_academicas oa 
  					on p.ofer_ncorr=oa.ofer_ncorr 
			     join especialidades ee 
                    on oa.espe_ccod=ee.espe_ccod   
			     join carreras ccc 
                    on ee.carr_ccod=ccc.carr_ccod
                 join instituciones iin 
                    on ccc.inst_ccod=iin.inst_ccod
                 join personas ppr 
                    on iin.pers_ncorr_representante=ppr.pers_ncorr 
			     join codeudor_postulacion cp 
                    on p.post_ncorr=cp.post_ncorr  
			      join personas_postulante ppc 
                    on  cp.pers_ncorr =ppc.pers_ncorr
                 join periodos_academicos pac 
                    on  pac.peri_ccod=oa.peri_ccod 
			     join direcciones_publica ddp 
                    on ppc.pers_ncorr = ddp.pers_ncorr  
			     left outer join ciudades c 
                    on  ddp.ciud_ccod=c.ciud_ccod  
			     join paises 
                    on pp.pais_ccod = paises.pais_ccod 
                 left outer join paises paisesppr 
                    on ppr.pais_ccod = paisesppr.pais_ccod
			     join estados_civiles 
                    on pp.eciv_ccod = estados_civiles.eciv_ccod 
                 left outer join estados_civiles ecivppr 
                    on ppc.eciv_ccod = ecivppr.eciv_ccod
			     join jornadas  
                    on oa.jorn_ccod = jornadas.jorn_ccod
				 join 	sedes sd
				 	on oa.sede_ccod=sd.sede_ccod
                 join contratos cc 
                    on cc.post_ncorr=p.post_ncorr   
			where ddp.tdir_ccod=1  
			  and p.post_ncorr= isnull(172172,p.post_ncorr)
              
              
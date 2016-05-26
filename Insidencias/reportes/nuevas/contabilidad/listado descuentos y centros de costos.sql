select distinct j.jorn_tdesc,pa.peri_tdesc,g.sede_tdesc as sede,d.carr_tdesc as carrera, cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut ,  
	 f.pers_tape_paterno + ' ' + f.pers_tape_materno+' '+ f.pers_tnombre as docente,h.tpro_tdesc as tipo_profesor,protic.trunc(c.audi_fmodificacion) as fecha_ingreso,   
	 pp.pers_tnombre + ' ' + pp.pers_tape_paterno + ' ' + pp.pers_tape_materno as encargado,ltrim(rtrim(asig.asig_ccod)) + ' ' + asig_tdesc as asignatura,   
	  (select protic.trunc(min (bloq_finicio_modulo)) from secciones aa, bloques_horarios bb, bloques_profesores cc   
	  where aa.carr_ccod=a.carr_ccod and aa.sede_ccod=a.sede_ccod and aa.peri_ccod=a.peri_ccod and aa.secc_ccod=bb.secc_ccod   
	  and bb.bloq_ccod=cc.bloq_ccod and cc.pers_ncorr=c.pers_ncorr and cc.bloq_anexo is null) as finicio,   
	 (select protic.trunc(min (bloq_ftermino_modulo)) from secciones aa, bloques_horarios bb, bloques_profesores cc   
	 where aa.carr_ccod=a.carr_ccod and aa.sede_ccod=a.sede_ccod and aa.peri_ccod=a.peri_ccod and aa.secc_ccod=bb.secc_ccod   
	 and bb.bloq_ccod=cc.bloq_ccod and cc.pers_ncorr=c.pers_ncorr and cc.bloq_anexo is null) as ftermino   
	 from secciones a,bloques_horarios b, bloques_profesores c,carreras d, personas f,sedes g,   
	 tipos_profesores h,personas pp, asignaturas asig,periodos_academicos pa, jornadas j   
	 where a.secc_ccod=b.secc_ccod   
	 and a.asig_ccod=asig.asig_ccod   
	 and b.bloq_ccod=c.bloq_ccod   
	 and a.carr_ccod=d.carr_ccod   
	 and c.pers_ncorr=f.pers_ncorr	   
	 and a.sede_ccod=g.sede_ccod   
	 and c.bloq_anexo is null   
	 and c.tpro_ccod=h.tpro_ccod   
	 and a.peri_ccod=pa.peri_ccod   		   
	 and c.pers_ncorr not in (27208)   
	 and cast(pp.pers_nrut as varchar) = c.audi_tusuario    
	 and a.jorn_ccod=j.jorn_ccod   
	 order by docente asc
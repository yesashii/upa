<%
class cHistoricoNotas
	private conexion, rut, plan, especialidad, carrera
	
	sub inicializar (con, r , p, e, c)
		set conexion	= con
		rut				=	r
		plan			=	p
		especialidad	=	e
		carrera			=	c
	end sub

	function dibuja 
		dim historico
		dim cons_historico
		
		set historico		=		new cformulario
		historico.inicializar 		conexion
		historico.carga_parametros	"paulo.xml","tabla"
		
		'cons_historico="select a.nive_ccod,a.asig_ccod,asig.asig_tdesc, " & vbCrLf  & _
		'			"	 decode(to_char(b.carg_nnota_final,'9.9'),'  .0','0.0',to_char(b.carg_nnota_final,'9.9')) as carg_nnota_final,  " & vbCrLf  & _
		'			"	 b.sitf_ccod,b.peri_ccod, " & vbCrLf  & _
		'			"	 decode(('('||pa.anos_ccod||'/' ||decode(plec_ccod,1,'O',2,'I',3,'P',4,'V')||'/'||b.sitf_ccod||')'),'('||pa.anos_ccod||'/'||decode(plec_ccod,1,'O',2,'I',3,'P',4,'V')||'/)',' ','(//)',' ',('('||pa.anos_ccod||'/' ||decode(plec_ccod,1,'O',2,'I',3,'P',4,'V')||'/'||b.sitf_ccod||')')) as anos_ccod  " & vbCrLf  & _
		'			"	 from (  " & vbCrLf  & _
		'			"	 select ma.nive_ccod, asig_ccod,esp.carr_ccod  " & vbCrLf  & _
		'			"	 from especialidades esp, planes_estudio pl, malla_curricular ma  " & vbCrLf  & _
		'			"	 where esp.espe_ccod=pl.espe_ccod  " & vbCrLf  & _
		'			"	  and pl.plan_ccod=ma.plan_ccod  " & vbCrLf  & _
		'			"	  and pl.plan_ccod='" & plan & "' ) a, " & vbCrLf  & _
		'			"	  (	  " & vbCrLf  & _
		'			"	  select h.asig_ccod,a.sitf_ccod,a.carg_nnota_final,g.peri_ccod " & vbCrLf  & _
		'			"		from  " & vbCrLf  & _
		'			"			 cargas_academicas a, " & vbCrLf  & _
		'			"			 alumnos b, " & vbCrLf  & _
		'			"			 personas c, " & vbCrLf  & _
		'			"			 ofertas_academicas d " & vbCrLf  & _
		'			"			 ,planes_estudio e " & vbCrLf  & _
		'			"			 ,especialidades f " & vbCrLf  & _
		'			"			 ,secciones g " & vbCrLf  & _
		'			"			 ,asignaturas h " & vbCrLf  & _
		'			"		where  " & vbCrLf  & _
		'			"			  a.matr_ncorr=b.matr_ncorr " & vbCrLf  & _
		'			"			  and b.pers_ncorr=c.pers_ncorr " & vbCrLf  & _
		'			"			  and b.ofer_ncorr=d.ofer_ncorr " & vbCrLf  & _
		'			"			  and b.plan_ccod=e.plan_ccod " & vbCrLf  & _
		'			"			  and e.espe_ccod=f.espe_ccod " & vbCrLf  & _
		'			"			  and a.secc_ccod=g.secc_ccod " & vbCrLf  & _
		'			"			  and g.asig_ccod=h.asig_ccod " & vbCrLf  & _
		'			"			  and b.emat_ccod=1 " & vbCrLf  & _
		'			"			  and pers_nrut='" & rut & "' " & vbCrLf  & _
		'			"			  and f.carr_ccod='" & carrera & "' " & vbCrLf  & _
		'			"			  and a.sitf_ccod not in ('EE','EQ','NN') " & vbCrLf  & _		  
		'			"		union   " & vbCrLf  & _
		'			"		select  " & vbCrLf  & _
		'			"			 a.asig_ccod,sitf_ccod,decode(a.sitf_ccod,'CC',0,'AC',a.conv_nnota,0) as nota,e.peri_ccod " & vbCrLf  & _
		'			"		from  " & vbCrLf  & _
		'			"			 convalidaciones a " & vbCrLf  & _
		'			"			 , alumnos b " & vbCrLf  & _
		'			"			 ,personas c " & vbCrLf  & _
		'			"			 , actas_convalidacion d " & vbCrLf  & _
		'			"			 , ofertas_academicas e " & vbCrLf  & _
		'			"			 , planes_estudio f " & vbCrLf  & _
		'			"			 ,especialidades g " & vbCrLf  & _
		'			"		where " & vbCrLf  & _
		'			"			 a.matr_ncorr=b.matr_ncorr " & vbCrLf  & _
		'			"			 and b.pers_ncorr=c.pers_ncorr " & vbCrLf  & _
		'			"			 and a.acon_ncorr=d.acon_ncorr " & vbCrLf  & _
		'			"			 and b.ofer_ncorr=e.ofer_ncorr " & vbCrLf  & _
		'			"			 and b.plan_ccod=f.plan_ccod " & vbCrLf  & _
		'			"			 and f.espe_ccod=g.espe_ccod " & vbCrLf  & _
		'			"			 and g.carr_ccod='" & carrera & "' " & vbCrLf  & _
		'			"			 and c.pers_nrut='" & rut & "' " & vbCrLf  & _
		'			"		union " & vbCrLf  & _
		'			"		select " & vbCrLf  & _
		'			"			  a.asig_ccod,b.sitf_ccod,b.carg_nnota_final,d.peri_ccod " & vbCrLf  & _
		'			"		from " & vbCrLf  & _
		'			"			equivalencias a " & vbCrLf  & _
		'			"			, cargas_academicas b " & vbCrLf  & _
		'			"			, secciones c " & vbCrLf  & _
		'			"			, ofertas_academicas d " & vbCrLf  & _
		'			"			, planes_estudio e " & vbCrLf  & _
		'			"			, especialidades f " & vbCrLf  & _
		'			"			, alumnos g " & vbCrLf  & _
		'			"			, personas h " & vbCrLf  & _
		'			"		where " & vbCrLf  & _
		'			"			 a.matr_ncorr=b.matr_ncorr " & vbCrLf  & _
		'			"			 and a.secc_ccod=b.secc_ccod " & vbCrLf  & _
		'			"			 and b.secc_ccod=c.secc_ccod " & vbCrLf  & _
		'			"			 and b.matr_ncorr=g.matr_ncorr " & vbCrLf  & _
		'			"			 and d.ofer_ncorr=g.ofer_ncorr " & vbCrLf  & _
		'			"			 and e.plan_ccod=g.plan_ccod " & vbCrLf  & _
		'			"			 and e.espe_ccod=f.espe_ccod " & vbCrLf  & _
		'			"			 and g.pers_ncorr=h.pers_ncorr " & vbCrLf  & _
		'			"			 and f.carr_ccod='" & carrera & "' " & vbCrLf  & _
		'			"			 and h.pers_nrut='" & rut & "' " & vbCrLf  & _
		'			"		union " & vbCrLf  & _
		'			"		select distinct  " & vbCrLf  & _
		'			"		   hf.asig_ccod,sitf_ccod,carg_nnota_final,peri_ccod  " & vbCrLf  & _
		'			"		 from   " & vbCrLf  & _
		'			"				homologacion_destino hd " & vbCrLf  & _
		'			"				,homologacion_fuente hf " & vbCrLf  & _
		'			"				,homologacion h " & vbCrLf  & _
		'			"				,asignaturas asig,  " & vbCrLf  & _
		'			"				secciones secc, " & vbCrLf  & _
		'			"				(select  " & vbCrLf  & _
		'			"						b.secc_ccod, b.matr_ncorr,b.sitf_ccod,b.carg_nnota_final " & vbCrLf  & _
		'			"				from " & vbCrLf  & _
		'			"				( " & vbCrLf  & _
		'			"				select  " & vbCrLf  & _
		'			"					   c.asig_ccod,a.carr_ccod,b.plan_ccod,a.espe_ccod " & vbCrLf  & _
		'			"				from  " & vbCrLf  & _
		'			"					 especialidades a, planes_estudio b, malla_curricular c  " & vbCrLf  & _
		'			"				where  " & vbCrLf  & _
		'			"					a.espe_ccod=b.espe_ccod " & vbCrLf  & _
		'			"					and b.plan_ccod = c.plan_ccod " & vbCrLf  & _
		'			"					and  a.carr_ccod='" & carrera & "' " & vbCrLf  & _
		'			"					and b.plan_ccod <> '" & plan & "' " & vbCrLf  & _
		'			"					and a.espe_ccod <> '" & especialidad & "' " & vbCrLf  & _
		'			"				)a, " & vbCrLf  & _
		'			"				( " & vbCrLf  & _
		'			"				select " & vbCrLf  & _
		'			"					  d.asig_ccod, g.carr_ccod,f.plan_ccod, g.espe_ccod, a.carg_nnota_final , a.sitf_ccod,d.secc_ccod, a.matr_ncorr " & vbCrLf  & _
		'			"				from  " & vbCrLf  & _
		'			"					cargas_academicas a, personas b, alumnos c, secciones d " & vbCrLf  & _
		'			"					,ofertas_academicas e, planes_estudio f, especialidades g   " & vbCrLf  & _
		'			"				where b.pers_ncorr=c.pers_ncorr  " & vbCrLf  & _
		'			"					and b.pers_nrut='" & rut & "'  " & vbCrLf  & _
		'			"					and a.matr_ncorr=c.matr_ncorr  " & vbCrLf  & _
		'			"					and a.secc_ccod=d.secc_ccod " & vbCrLf  & _
		'			"					and c.ofer_ncorr=e.ofer_ncorr " & vbCrLf  & _
		'			"					and c.plan_ccod=f.plan_ccod " & vbCrLf  & _
		'			"					and f.espe_ccod=g.espe_ccod " & vbCrLf  & _
		'			"					and d.carr_ccod=g.carr_ccod " & vbCrLf  & _
		'			"					and a.sitf_ccod not in  ('EQ','EE') " & vbCrLf  & _
		'			"					and g.carr_ccod='" & carrera & "' " & vbCrLf  & _
		'			"					and f.plan_ccod <>'" & plan & "' " & vbCrLf  & _
		'			"					and g.espe_ccod <> '" & especialidad & "' " & vbCrLf  & _
		'			"				) b " & vbCrLf  & _
		'			"				where  " & vbCrLf  & _
		'			"					a.plan_ccod = b.plan_ccod and " & vbCrLf  & _
		'			"					a.espe_ccod = b.espe_ccod and " & vbCrLf  & _
		'			"					a.carr_ccod = b.carr_ccod and " & vbCrLf  & _
		'			"					a.asig_ccod = b.asig_ccod ) " & vbCrLf  & _
		'			"				carg " & vbCrLf  & _
		'			"				, alumnos al " & vbCrLf  & _
		'			"				, personas pers " & vbCrLf  & _
		'			"		where hd.homo_ccod=h.homo_ccod  " & vbCrLf  & _
		'			"				and hf.homo_ccod=h.homo_ccod  " & vbCrLf  & _
		'			"				and asig.asig_ccod=hd.asig_ccod  " & vbCrLf  & _
		'			"				and asig.asig_ccod=secc.asig_ccod  " & vbCrLf  & _
		'			"				and secc.secc_ccod=carg.secc_ccod  " & vbCrLf  & _
		'			"				and al.matr_ncorr=carg.matr_ncorr  " & vbCrLf  & _
		'			"				and pers.pers_ncorr=al.pers_ncorr  " & vbCrLf  & _
		'			"				and hd.asig_ccod <> hf.asig_ccod  " & vbCrLf  & _
		'			"				and sitf_ccod not in ('EQ','EE')  " & vbCrLf  & _
		'			"				and h.THOM_CCOD = 1  " & vbCrLf  & _
		'			"				and pers.pers_nrut='" & rut & "'  " & vbCrLf  & _
		'			"			 ) b  " & vbCrLf  & _
		'			"		,  asignaturas asig,  " & vbCrLf  & _
		'			"	 periodos_academicos pa, carreras ca  " & vbCrLf  & _
		'			"	 where a.asig_ccod = b.asig_ccod (+)  " & vbCrLf  & _
		'			"	 and a.asig_ccod=asig.asig_ccod   " & vbCrLf  & _
		'			"	 and pa.peri_ccod (+)=b.peri_ccod   " & vbCrLf  & _
		'			"	 and ca.carr_ccod=a.carr_ccod  " & vbCrLf  & _
		'			"	 order by a.nive_ccod,asig_ccod,b.peri_ccod" 
		
		
		
	cons_historico="select a.nive_ccod,a.asig_ccod,asig.asig_tdesc, " & vbCrLf  & _
                   "	 case b.sitf_ccod when 'RI' then '' else case cast(cast(b.carg_nnota_final as decimal(2,1))as varchar) when ' .0' then '0.0' else cast(cast(b.carg_nnota_final as decimal(2,1))as varchar) end end as carg_nnota_final,  " & vbCrLf  & _
				   "	 b.sitf_ccod,b.peri_ccod, " & vbCrLf  & _
				   "	 case ('('+ cast(pa.anos_ccod as varchar) + '-' + cast(b.sitf_ccod as varchar)+')') " & vbCrLf  & _
				   "     when ('('+ cast(pa.anos_ccod as varchar) + '-' + ')') then ' ' " & vbCrLf  & _
				   "     when '(-)' then ' '" & vbCrLf  & _
				   "     else ('('+ cast(pa.anos_ccod as varchar) + '-' + case cast(b.sitf_ccod as varchar) when 'A' then 'Apr' when 'R' then 'Repr' when 'C' then 'Conv' when 'SP' then 'S.P' when 'H' then 'Homologado' when 'S' then 'Suf' when 'RS' then 'RS' when 'RI' then 'RI' when 'CR' then 'ECR' end +')') end as anos_ccod  " & vbCrLf  & _
				   "	 from (  " & vbCrLf  & _
				   "	 select ma.nive_ccod, asig_ccod,esp.carr_ccod  " & vbCrLf  & _
			  	   "	 from especialidades esp, planes_estudio pl, malla_curricular ma  " & vbCrLf  & _
				   "	 where esp.espe_ccod=pl.espe_ccod  " & vbCrLf  & _
				   "	  and pl.plan_ccod=ma.plan_ccod  " & vbCrLf  & _
				   "	  and cast(pl.plan_ccod as varchar)='"&plan&"') a left outer join" & vbCrLf  & _
				   "	  (	  " & vbCrLf  & _
				   "	  select h.asig_ccod,a.sitf_ccod,a.carg_nnota_final,g.peri_ccod " & vbCrLf  & _
				   "		from  " & vbCrLf  & _
				   "			 cargas_academicas a, " & vbCrLf  & _
				   "			 alumnos b, " & vbCrLf  & _
				   "			 personas c, " & vbCrLf  & _
				   "			 ofertas_academicas d " & vbCrLf  & _
				   "			 ,planes_estudio e " & vbCrLf  & _
				   "			 ,especialidades f " & vbCrLf  & _
				   "			 ,secciones g " & vbCrLf  & _
				   "			 ,asignaturas h " & vbCrLf  & _
				   "		where  " & vbCrLf  & _
				   "			  a.matr_ncorr=b.matr_ncorr " & vbCrLf  & _
				   "			  and b.pers_ncorr=c.pers_ncorr " & vbCrLf  & _
				   "			  and b.ofer_ncorr=d.ofer_ncorr " & vbCrLf  & _
				   "			  and b.plan_ccod=e.plan_ccod " & vbCrLf  & _
				   "              and isnull(a.carg_noculto,0) <>1" & vbcrlf &_
				   "			  and e.espe_ccod=f.espe_ccod " & vbCrLf  & _
				   "			  and not exists(select 1 from equivalencias equi where equi.asig_ccod=h.asig_ccod and a.matr_ncorr=equi.matr_ncorr and a.secc_ccod = equi.secc_ccod) " & vbCrLf  & _
				   "			  --and not exists(select 1 from equivalencias equi where equi.secc_ccod=g.secc_ccod and equi.matr_ncorr=a.matr_ncorr) " & vbCrLf  & _
				   "			  and a.secc_ccod=g.secc_ccod " & vbCrLf  & _
				   "			  and g.asig_ccod=h.asig_ccod " & vbCrLf  & _
				   "			  --and b.emat_ccod=1 " & vbCrLf  & _
				   "			  and cast(pers_nrut as varchar)='"&rut&"' " & vbCrLf  & _
				   "			  --and cast(f.carr_ccod as varchar)='"&carrera&"' " & vbCrLf  & _
				   "			  and cast(a.sitf_ccod as varchar) not in ('EE','EQ','NN') " & vbCrLf  & _
				   "		union   " & vbCrLf  & _
				   "		select  " & vbCrLf  & _
				   "			 a.asig_ccod,sitf_ccod,case a.sitf_ccod when 'C' then isnull(a.conv_nnota,null) when 'AC' then a.conv_nnota else isnull(a.conv_nnota,null) end as nota,e.peri_ccod " & vbCrLf  & _
				   "		from  " & vbCrLf  & _
				   "			 convalidaciones a " & vbCrLf  & _
				   "			 , alumnos b " & vbCrLf  & _
				   "			 ,personas c " & vbCrLf  & _
				   "			 , actas_convalidacion d " & vbCrLf  & _
				   "			 , ofertas_academicas e " & vbCrLf  & _
				   "			 , planes_estudio f " & vbCrLf  & _
				   "			 ,especialidades g " & vbCrLf  & _
				   "		where " & vbCrLf  & _
				   "			 a.matr_ncorr=b.matr_ncorr " & vbCrLf  & _
				   "			 and b.pers_ncorr=c.pers_ncorr " & vbCrLf  & _
				   "			 and a.acon_ncorr=d.acon_ncorr " & vbCrLf  & _
				   "			 and b.ofer_ncorr=e.ofer_ncorr " & vbCrLf  & _
				   "			 and b.plan_ccod=f.plan_ccod " & vbCrLf  & _
				   "			 and f.espe_ccod=g.espe_ccod " & vbCrLf  & _
				   "			 and cast(g.carr_ccod as varchar)='"&carrera&"' " & vbCrLf  & _
				   "			 and cast(c.pers_nrut as varchar)='"&rut&"' " & vbCrLf  & _
				   "		union " & vbCrLf  & _
				   "		select " & vbCrLf  & _
				   "			  a.asig_ccod,b.sitf_ccod,b.carg_nnota_final,d.peri_ccod " & vbCrLf  & _
				   "		from " & vbCrLf  & _
				   "			equivalencias a " & vbCrLf  & _
				   "			, cargas_academicas b " & vbCrLf  & _
				   "			, secciones c " & vbCrLf  & _
				   "			, ofertas_academicas d " & vbCrLf  & _
				   "			, planes_estudio e " & vbCrLf  & _
				   "			, especialidades f " & vbCrLf  & _
				   "			, alumnos g " & vbCrLf  & _
				   "			, personas h " & vbCrLf  & _
				   "		where " & vbCrLf  & _
				   "			 a.matr_ncorr=b.matr_ncorr " & vbCrLf  & _
				   "			 and a.secc_ccod=b.secc_ccod " & vbCrLf  & _
				   "			 and b.secc_ccod=c.secc_ccod " & vbCrLf  & _
				   "			 and b.matr_ncorr=g.matr_ncorr " & vbCrLf  & _
				   "			 and d.ofer_ncorr=g.ofer_ncorr " & vbCrLf  & _
				   "			 and e.plan_ccod=g.plan_ccod " & vbCrLf  & _
				   "             and isnull(b.carg_noculto,0) <>1" & vbcrlf &_
				   "			 and e.espe_ccod=f.espe_ccod " & vbCrLf  & _
				   "			 and g.pers_ncorr=h.pers_ncorr " & vbCrLf  & _
				   "			 --and cast(f.carr_ccod as varchar)='"&carrera&"' " & vbCrLf  & _
				   "			 and cast(h.pers_nrut as varchar)='"&rut&"' " & vbCrLf  & _
				   "		union " & vbCrLf  & _
				   "    		 select distinct hd.asig_ccod,carg.sitf_ccod,carg.carg_nnota_final,i.peri_ccod " & vbCrLf  & _
				   "                from personas pers,alumnos al,cargas_academicas carg,situaciones_finales sf,secciones secc,asignaturas asig, homologacion_destino hd, " & vbCrLf  & _
				   "                     homologacion_fuente hf,homologacion h,ofertas_academicas i" & vbCrLf  & _
				   "                where cast(pers.pers_nrut as varchar)='"&rut&"' " & vbCrLf  & _
				   "                and pers.pers_ncorr=al.pers_ncorr" & vbCrLf  & _
				   "                and al.matr_ncorr=carg.matr_ncorr" & vbCrLf  & _
				   "                and carg.sitf_ccod=sf.sitf_ccod" & vbCrLf  & _
				   "                --and cast(sf.sitf_baprueba as varchar)='S'" & vbCrLf  & _
				   "                and cast(carg.sitf_ccod as varchar) <>'EQ'" & vbCrLf  & _
				   "                and secc.secc_ccod=carg.secc_ccod" & vbCrLf  & _
				   "                and asig.asig_ccod=secc.asig_ccod" & vbCrLf  & _
				   "                and isnull(carg.carg_noculto,0) <>1" & vbcrlf &_
				   "                and asig.asig_ccod=hf.asig_ccod" & vbCrLf  & _
				   "                and hd.homo_ccod=h.homo_ccod" & vbCrLf  & _
				   "                --and not exists (select 1 from alumnos tt0, cargas_academicas tt, secciones tt2 " & vbCrLf  & _
                   "                --                where tt0.pers_ncorr=al.pers_ncorr and tt0.matr_ncorr=tt.matr_ncorr " & vbCrLf  & _
                   "                --                and tt.secc_ccod=tt2.secc_ccod and tt2.asig_ccod=hd.asig_ccod and tt.sitf_ccod ='A')" & vbCrLf  & _
				   "                and al.ofer_ncorr=i.ofer_ncorr" & vbCrLf  & _
				   "                and hf.homo_ccod=h.homo_ccod" & vbCrLf  & _
				   "			    and cast(secc.carr_ccod as varchar)='"&carrera&"' " & vbCrLf  & _
				   "                --and exists (select 1 from alumnos tt where tt.pers_ncorr=pers.pers_ncorr and tt.plan_ccod=h.plan_ccod_destino) "  & vbCrLf  & _
				   "                and hd.asig_ccod <> hf.asig_ccod" & vbCrLf  & _
				   "                and h.THOM_CCOD = 1 " & vbCrLf  & _
				   "		) b  on  a.asig_ccod = b.asig_ccod " & vbCrLf  & _
				   "		join   asignaturas asig on a.asig_ccod=asig.asig_ccod  " & vbCrLf  & _
				   "	    left outer join periodos_academicos pa on b.peri_ccod=pa.peri_ccod" & vbCrLf  & _
				   "        join carreras ca on ca.carr_ccod=a.carr_ccod " & vbCrLf  & _
				   "        order by a.nive_ccod,a.asig_ccod,b.peri_ccod "

		'response.Write("<pre>"&cons_historico&"</pre>")
		
		oportunidades	=	3
		'nro_columnas	=	conexion.consultauno("select max(count(asig_ccod)) from ("&cons_historico&") group by asig_ccod")

		historico.consultar	cons_historico
		nro_columnas =historico.nroFilas
		'if nro_columnas > oportunidades then
		'	oportunidades	=	nro_columnas
		'end if
		
		response.Write("<table class='v1' width='98%' border='1' bordercolor='#999999' bgcolor='#adadad' cellspacing='0' cellpadding='0'>")
		response.Write("<tr borderColor=#999999 bgColor=#c4d7ff>")
		response.Write("<TH><FONT color=#333333>Nivel</FONT></TH><TH><FONT color=#333333>Código Asignatura</FONT></TH><TH><FONT color=#333333>Asignatura</FONT></TH>")
		for o_ = 1 to oportunidades
			response.Write("<TH><FONT color=#333333>"&o_&"&nbsp;Oportunidad</FONT></TH>")
		next
		'response.Write("</b>")
		response.Write("</tr>")
		historico.siguiente
		nivel		= historico.obtenervalor("nive_ccod")
		aux			= historico.obtenervalor("asig_ccod")
		asignatura	= historico.obtenervalor("asig_tdesc")
		nota		= historico.obtenervalor("carg_nnota_final")
		sit_final	= historico.obtenervalor("sitf_ccod")
		ano			= historico.obtenervalor("anos_ccod")
		cadena		= nota&"&nbsp;"&ano
		contador	=	1
		col			=	1	
		nro			=	3
					for k=0 to historico.nroFilas-1 
						if historico.obtenervalor("asig_ccod") <> "" then
							historico.siguiente
							if aux = historico.obtenervalor("asig_ccod") then
								col	=	col + 1
								cadena = cadena &"<td nowrap align='center' class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this)>"&historico.obtenervalor("carg_nnota_final")&"&nbsp;"&historico.obtenervalor("anos_ccod")&"</td>"
							else
								response.write("<tr bgColor=#ffffff><td class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this)>"&nivel&"</td><td class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this)>"&aux&"</td><td class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this)>"&asignatura&"</td><td class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this)>"&cadena&"</td>")
								for i_=1 to oportunidades-col
									response.Write("<td class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this)>&nbsp;</td>")
								next
								col	=	1
								contador = 2
								'tabla.siguiente
								nivel		= historico.obtenervalor("nive_ccod")
								aux			= historico.obtenervalor("asig_ccod")
								asignatura	= historico.obtenervalor("asig_tdesc")
								nota		= historico.obtenervalor("carg_nnota_final")
								sit_final	= historico.obtenervalor("sitf_ccod")
								ano			= historico.obtenervalor("anos_ccod")
								horas		= historico.obtenervalor("asig_nhoras")
								cadena		= historico.obtenervalor("carg_nnota_final")&"&nbsp;"&ano
								nf			= historico.obtenervalor("nf")
								sf			= historico.obtenervalor("sitf_ccod")
							end if
						end if
						if k=historico.nrofilas-1 then
								'historico.anterior
								historico.anterior
								nivel		= historico.obtenervalor("nive_ccod")
								aux			= historico.obtenervalor("asig_ccod")
								asignatura	= historico.obtenervalor("asig_tdesc")
								nota		= historico.obtenervalor("carg_nnota_final")
								sit_final	= historico.obtenervalor("sitf_ccod")
								ano			= historico.obtenervalor("anos_ccod")
								horas		= historico.obtenervalor("asig_nhoras")
								cadena		= historico.obtenervalor("carg_nnota_final")
								nf			= historico.obtenervalor("nf")
								sf			= historico.obtenervalor("sitf_ccod")
								historico.siguiente
								if aux = historico.obtenervalor("asig_ccod") then
									response.write("<tr bgColor=#FFFFFF><td class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this)>"&nivel&"</td><td class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this)>"&aux&"</td><td class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this)>"&asignatura&"</td><td class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this)>"&cadena&"&nbsp;"&ano&"</td><td class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this)>"&historico.obtenervalor("carg_nnota_final")&"&nbsp;"&historico.obtenervalor("anos_ccod")&"</td>")
									for h_=3 to oportunidades
									historico.siguiente
									response.write("<td class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this)>"&historico.obtenervalor("carg_nnota_final")&"&nbsp;"&historico.obtenervalor("anos_ccod")&"</td>")
										'response.Write("<td>&nbsp;</td>")
									next
									response.Write("</tr>")

								else
									historico.siguiente
									response.write("<tr bgColor=#FFFFFF><td class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this)>"&historico.obtenervalor("nive_ccod")&"</td><td class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this)>"&historico.obtenervalor("asig_ccod")&"</td><td class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this)>"&historico.obtenervalor("asig_tdesc")&"</td><td class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this)>"&historico.obtenervalor("carg_nnota_final")&"&nbsp;"&historico.obtenervalor("anos_ccod")&"</td>")
									for h_=2 to oportunidades
										response.Write("<td class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this)>&nbsp;</td>")
									next
									response.Write("</tr>")
								end if
						end if
					response.Write("</tr>")
				next
		response.Write("</table>")
	end function
end class
%>
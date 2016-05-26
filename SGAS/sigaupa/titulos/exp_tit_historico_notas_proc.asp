<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

rut        = request.Form("rut")
carrera    = request.Form("carrera")
plan       =  request.Form("plan")
saca_ncorr =  request.Form("saca_ncorr")
pers_ncorr =  request.Form("pers_ncorr")

set historico		=		new cformulario
historico.inicializar 		conexion
historico.carga_parametros	"tabla_vacia.xml","tabla"

cons_historico="select a.nive_ccod,ltrim(rtrim(a.asig_ccod)) as asig_ccod,asig.asig_tdesc,a.mall_ccod, " & vbCrLf  & _
                   "	 replace((case cast(cast(b.carg_nnota_final as decimal(2,1))as varchar) when ' .0' then '0.0' else cast(cast(b.carg_nnota_final as decimal(2,1))as varchar) end),',','.') as carg_nnota_final,  " & vbCrLf  & _
				   "	 b.sitf_ccod,b.peri_ccod, " & vbCrLf  & _
				   "	 isnull( case ('('+ cast(pa.anos_ccod as varchar) + '-' + cast(b.sitf_ccod as varchar)+')') " & vbCrLf  & _
				   "     when ('('+ cast(pa.anos_ccod as varchar) + '-' + ')') then ' ' " & vbCrLf  & _
				   "     when '(-)' then ' '" & vbCrLf  & _
				   "     else ('('+ cast(pa.anos_ccod as varchar) + '-' + case cast(b.sitf_ccod as varchar) when 'A' then 'Apr' when 'R' then 'Repr' when 'C' then 'Conv' when 'SP' then 'S.P' when 'H' then 'Homologado' when 'S' then 'Suf' when 'RS' then 'RS' when 'RI' then 'RI' when 'CR' then 'ECR' end +')') end ,'' ) as anos_ccod  " & vbCrLf  & _
				   "	 from (  " & vbCrLf  & _
				   "	 select ma.nive_ccod, asig_ccod,esp.carr_ccod,ma.mall_ccod  " & vbCrLf  & _
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
				   "			  and a.secc_ccod=g.secc_ccod " & vbCrLf  & _
				   "			  and g.asig_ccod=h.asig_ccod " & vbCrLf  & _
				   "			  and cast(pers_nrut as varchar)='"&rut&"' " & vbCrLf  & _
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
				   "                and al.ofer_ncorr=i.ofer_ncorr" & vbCrLf  & _
				   "                and hf.homo_ccod=h.homo_ccod" & vbCrLf  & _
				   "			    and cast(secc.carr_ccod as varchar)='"&carrera&"' " & vbCrLf  & _
				   "                and hd.asig_ccod <> hf.asig_ccod" & vbCrLf  & _
				   "                and h.THOM_CCOD = 1 " & vbCrLf  & _
				   "		) b  on  a.asig_ccod = b.asig_ccod " & vbCrLf  & _
				   "		join   asignaturas asig on a.asig_ccod=asig.asig_ccod  " & vbCrLf  & _
				   "	    left outer join periodos_academicos pa on b.peri_ccod=pa.peri_ccod" & vbCrLf  & _
				   "        join carreras ca on ca.carr_ccod=a.carr_ccod " & vbCrLf  & _
				   "        order by a.nive_ccod,a.asig_ccod,b.peri_ccod "
historico.consultar	cons_historico
while historico.siguiente
	nive_ccod = historico.obtenerValor("nive_ccod")
	asig_ccod = historico.obtenerValor("asig_ccod")
	asig_tdesc = historico.obtenerValor("asig_tdesc")
	mall_ccod = historico.obtenerValor("mall_ccod")
	carg_nnota_final = historico.obtenerValor("carg_nnota_final")
	peri_ccod = historico.obtenerValor("peri_ccod")
	sitf_ccod = historico.obtenerValor("sitf_ccod")
	anos_ccod = historico.obtenerValor("anos_ccod")
	if sitf_ccod <> "" then
		c_insert = "Insert into HIST_ASIG_EGRESO (PERS_NCORR,CARR_CCOD,PLAN_CCOD,NIVE_CCOD,ASIG_CCOD,ASIG_TDESC,MALL_CCOD,CARG_NNOTA_FINAL,SITF_CCOD,PERI_CCOD,ANOS_CCOD,AUDI_TUSUARIO,AUDI_FMODIFICACION) "&_
				   " Values ("&pers_ncorr&",'"&carrera&"',"&plan&","&nive_ccod&",'"&asig_ccod&"','"&asig_tdesc&"',"&mall_ccod&","&carg_nnota_final&",'"&sitf_ccod&"',"&peri_ccod&",'"&anos_ccod&"','"&negocio.obtenerUsuario&"',getdate())"
    else
		c_insert = "Insert into HIST_ASIG_EGRESO (PERS_NCORR,CARR_CCOD,PLAN_CCOD,NIVE_CCOD,ASIG_CCOD,ASIG_TDESC,MALL_CCOD,CARG_NNOTA_FINAL,SITF_CCOD,PERI_CCOD,ANOS_CCOD,AUDI_TUSUARIO,AUDI_FMODIFICACION) "&_
				   " Values ("&pers_ncorr&",'"&carrera&"',"&plan&","&nive_ccod&",'"&asig_ccod&"','"&asig_tdesc&"',"&mall_ccod&",NULL,NULL,NULL,NULL,'"&negocio.obtenerUsuario&"',getdate())"
	end if
	'response.write(c_insert)
	Conexion.ejecutaS c_insert
wend
'response.end()

response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

<!-- #include file = "../biblioteca/_conexion.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=corporacion_profesionales.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 350000
set conexion = new CConexion
conexion.Inicializar "upacifico"

'-----------------------------------------------------------------------
 carr_ccod  =   request.QueryString("carr_ccod")
 jorn_ccod	=	request.querystring("jorn_ccod")
 pers_nrut  =   request.QueryString("pers_nrut") 
 pers_xdv   =   request.QueryString("pers_xdv") 
 pers_tape_paterno  =   request.QueryString("pers_tape_paterno") 
 pers_tape_materno  =   request.QueryString("pers_tape_materno")
 pers_tnombre =   request.QueryString("pers_tnombre")
 mes_ccod =   request.QueryString("mes_ccod") 
 sexo_ccod =   request.QueryString("sexo_ccod") 
 pers_temail =   request.QueryString("pers_temail") 
 ano_egreso =   request.QueryString("ano_egreso")
 sin_carrera =  request.QueryString("sin_carrera")
 sin_jornada =  request.QueryString("sin_jornada")

 fecha_modificacion =  request.QueryString("fecha_modificacion")

fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------

set f_alumnos = new CFormulario
f_alumnos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_alumnos.Inicializar conexion
		   
consulta = " select cast(a.pers_nrut as varchar) +'-'+ b.pers_xdv as rut,   "& vbCrLf &_
           " b.pers_tape_paterno + ' ' + b.pers_tape_materno + ' ' + b.pers_tnombre as alumno, case emat_ccod when 4 then 'EGRESADO' when 8 then 'TITULADO' end as estado,   "& vbCrLf &_
           " año as realizado,promocion,protic.initCap(isnull(case b.pers_temail when '' then 'No Registra' else b.pers_temail end,'No registra')) as email,  "& vbCrLf &_
           " isnull(protic.trunc(b.pers_fnacimiento),'No Registra') as fecha_nacimiento,  "& vbCrLf &_  
           " b.pers_ncorr,a.sede as sede,cc.carr_tdesc as carrera, case entidad when 'I' then 'Instituto' when 'U' then 'Universidad' end as letra,jj.jorn_tdesc as jornada,ss.sexo_tdesc as sexo,   "& vbCrLf &_
           " pp.pais_tdesc as pais,dd.dire_tcalle,dd.dire_tnro,dd.dire_tblock,dd.dire_tpoblacion,dire_tdepto,dire_tlocalidad,ci1.ciud_tdesc as comuna, ci1.ciud_tcomuna as ciudad, re1.regi_tdesc,   "& vbCrLf &_
           " b.regi_particular,b.ciud_particular,b.pers_tfono as telefono_personal,b.pers_tcelular as celular, b.pers_tfax as fax,   "& vbCrLf &_
           " dae.cod_postal as cod_postal,dae.num_hijos as numero_hijos,ts.tsoc_tdesc as tipo_socio,    "& vbCrLf &_
		   " '--' as fecha_titulacion, "& vbCrLf &_
		   " protic.trunc(fecha_incorporacion) as fecha_incorporacion,protic.trunc(fecha_vencimiento) as fecha_vencimiento,dae.observaciones,  "& vbCrLf &_
		   " (select top 1 dlp.dlpr_nombre_empresa from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = b.pers_ncorr order by dlp.audi_fmodificacion desc) as empresa, "& vbCrLf &_
           " (select top 1 dlp.dlpr_rubro_empresa from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = b.pers_ncorr order by dlp.audi_fmodificacion desc) as rubro, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_cargo_empresa from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = b.pers_ncorr order by dlp.audi_fmodificacion desc) as cargo, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_depto_empresa from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = b.pers_ncorr order by dlp.audi_fmodificacion desc) as depto, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_email_empresa from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = b.pers_ncorr order by dlp.audi_fmodificacion desc) as email_laboral, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_web_empresa from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = b.pers_ncorr order by dlp.audi_fmodificacion desc) as web, "& vbCrLf &_
		   " (select top 1 pp2.pais_tdesc from alumni_direccion_laboral_profesionales dlp, paises pp2 where dlp.pers_ncorr = b.pers_ncorr and dlp.pais_ccod=pp2.pais_ccod order by dlp.audi_fmodificacion desc) as pais_laboral, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_tcalle + ' ' + isnull(dlp.dlpr_tnro,'') + '  ' + isnull((case dlp.dlpr_tblock when '' then '' else 'Depto '+dlp.dlpr_tblock  end),'')+' ' + isnull(dlp.dlpr_tpoblacion, '') from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = b.pers_ncorr order by dlp.audi_fmodificacion desc) as direccion_laboral, "& vbCrLf &_
		   " (select top 1 case dlp.pais_ccod when 1 then ciud2.ciud_tdesc + ' - ' + ciud2.ciud_tcomuna else dlp.dlpr_regi_particular + ' - ' + dlp.dlpr_ciud_particular end from alumni_direccion_laboral_profesionales dlp, paises pp2,ciudades ciud2 where dlp.pers_ncorr = b.pers_ncorr and dlp.pais_ccod=pp2.pais_ccod and dlp.ciud_ccod = ciud2.ciud_ccod  order by dlp.audi_fmodificacion desc) as ciudad_laboral, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_cpostal from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = b.pers_ncorr order by dlp.audi_fmodificacion desc) as cod_postal_laboral, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_tfono from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = b.pers_ncorr order by dlp.audi_fmodificacion desc) as fono_laboral, "& vbCrLf &_
		   " (select top 1 dlp.dire_tfax from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = b.pers_ncorr order by dlp.audi_fmodificacion desc) as fax_laboral, "& vbCrLf &_
		   " (select top 1 dlp.dlpr_tobservacion from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = b.pers_ncorr order by dlp.audi_fmodificacion desc) as observacion_laboral , "& vbCrLf &_
		   " protic.ultima_modificacion_cpp(b.pers_ncorr,2) as usuario, "& vbCrLf &_
		   " protic.ultima_modificacion_cpp(b.pers_ncorr,1) as fecha_modificacion, otro_email_personal, "& vbCrLf &_
		   " case dae.tipo_contacto when 'P' then 'Particular' when 'C' then 'Comercial' else '' end as tipo_contacto,recibir_info "& vbCrLf &_
		   " from egresados_upa2 a join alumni_personas b  "& vbCrLf &_
		   "    on  a.pers_nrut = b.pers_nrut and a.pers_xdv = b.pers_xdv "& vbCrLf &_
		   " join jornadas jj  "& vbCrLf &_
		   "    on  a.jorn_ccod=jj.jorn_ccod  "& vbCrLf &_
		   " join carreras cc  "& vbCrLf &_
		   "    on  a.carr_ccod=cc.carr_ccod  "& vbCrLf &_
		   " join sexos ss   "& vbCrLf &_
		   "    on  b.sexo_ccod=ss.sexo_ccod  "& vbCrLf &_
		   " join paises pp  "& vbCrLf &_
		   "    on isnull(b.pais_ccod,0) = pp.pais_ccod  "& vbCrLf &_
		   " left outer join alumni_datos_adicionales_egresados dae  "& vbCrLf &_
		   "    on b.pers_ncorr = dae.pers_ncorr  "& vbCrLf &_
		   " left outer join tipos_socios ts  "& vbCrLf &_
		   "    on dae.tsoc_ccod = ts.tsoc_ccod    "& vbCrLf &_
		   " left outer join alumni_direcciones dd "& vbCrLf &_
		   "    on b.pers_ncorr=dd.pers_ncorr  and 2 = dd.tdir_ccod "& vbCrLf &_
		   " left outer join ciudades ci1 "& vbCrLf &_
		   "    on dd.ciud_ccod=ci1.ciud_ccod "& vbCrLf &_
		   " left outer join regiones re1 "& vbCrLf &_
		   "    on ci1.regi_ccod=re1.regi_ccod "& vbCrLf &_
		   " where isnull(en_alumnos,'NO') = 'NO' "& vbCrLf 
			if sin_carrera = "" or sin_carrera = "0" then 
				if sin_jornada = "" or sin_jornada = "0" then 
				consulta = consulta & "  and  cc.carr_ccod='"&carr_ccod&"' and cast(jj.jorn_ccod as varchar)='"&jorn_ccod&"'"
			  	else
			  	consulta = consulta & "  and  cc.carr_ccod='"&carr_ccod&"'"
			  	end if	
			end if
            if pers_nrut <> "" and pers_xdv <> ""	then
			    consulta = consulta & " and cast(b.pers_nrut as varchar)='"&pers_nrut&"'"
			end if 
			if pers_tape_paterno <> "" then
			    consulta = consulta & " and b.pers_tape_paterno like '%"&pers_tape_paterno&"%'"
			end if 		
			if pers_tape_materno <> "" then
			    consulta = consulta & " and b.pers_tape_materno like '%"&pers_tape_materno&"%'"
			end if 
			if pers_tnombre <> "" then
			    consulta = consulta & " and b.pers_tnombre like '%"&pers_tnombre&"%'"
			end if 
			if mes_ccod <> "" then
			    consulta = consulta & " and cast(datepart(month,b.pers_fnacimiento) as varchar)='"&mes_ccod&"'"
			end if
			if sexo_ccod <> "" then
			    consulta = consulta & " and cast(b.sexo_ccod as varchar)='"&sexo_ccod&"'"
			end if 
			if pers_temail <> "" then
			    consulta = consulta & " and b.pers_temail like'%"&pers_temail&"%'"
			end if 		
			if ano_egreso <> "" then
			    consulta = consulta & " and año ='"&ano_egreso&"'"
			end if 
			if fecha_modificacion <> "" then
				consulta = consulta & " and exists (select 1 from alumni_datos_adicionales_egresados dae where dae.pers_ncorr = b.pers_ncorr and convert(varchar,dae.audi_fmodificacion,103) <= convert(datetime,'"&fecha_modificacion&"',103))"
			end if 		 
			
 consulta = consulta &	" union                 "& vbCrLf &_
						"  select cast(d.pers_nrut as varchar)+'-'+d.pers_xdv as rut,d.pers_tape_paterno + ' ' + d.pers_tape_materno + ' ' + d.pers_tnombre as alumno, "& vbCrLf &_
					    "  f.emat_tdesc as estado,e.anos_ccod as realizado,protic.ano_ingreso_carrera_egresados(d.pers_ncorr,cc.carr_ccod) as promocion,protic.initCap(isnull(case d.pers_temail when '' then 'No Registra' else d.pers_temail end,'No registra')) as email, isnull(protic.trunc(d.pers_fnacimiento),'No Registra') as fecha_nacimiento, "& vbCrLf &_
						"  a.pers_ncorr,sede_tdesc as sede,case c.espe_ccod when '224' then c.espe_tdesc else cc.carr_tdesc end as carrera, 'Universidad' as letra,jj.jorn_tdesc as jornada,ss.sexo_tdesc as sexo, "& vbCrLf &_
						"  pp.pais_tdesc as pais, dd.dire_tcalle,dd.dire_tnro,dd.dire_tblock,dd.dire_tpoblacion,dire_tdepto,dire_tlocalidad,ci1.ciud_tdesc as comuna, ci1.ciud_tcomuna as ciudad, re1.regi_tdesc, "& vbCrLf &_
					    "  d.regi_particular,d.ciud_particular,d.pers_tfono as telefono_personal,d.pers_tcelular as celular, d.pers_tfax as fax, "& vbCrLf &_
					    "  dae.cod_postal as cod_postal,dae.num_hijos as numero_hijos,ts.tsoc_tdesc as tipo_socio, "& vbCrLf &_
                        "  (select top 1 case a.emat_ccod when 4 then protic.trunc(t5.fecha_egreso) "& vbCrLf &_
                        "                                 when 8 then isnull(protic.trunc(t5.fecha_titulacion),protic.trunc(tt.asca_fsalida)) end      "& vbCrLf &_
					    "  from alumnos_salidas_carrera tt join salidas_carrera t2 "& vbCrLf &_
						"    on tt.saca_ncorr=t2.saca_ncorr "& vbCrLf &_
					    "  join planes_estudio t3 "& vbCrLf &_
						"    on t2.plan_ccod=t3.plan_ccod "& vbCrLf &_
						"  join especialidades t4   "& vbCrLf &_
						"    on t3.espe_ccod=t4.espe_ccod "& vbCrLf &_
						"  left outer join detalles_titulacion_carrera t5 "& vbCrLf &_
						"    on tt.pers_ncorr=t5.pers_ncorr and t2.plan_ccod=t5.plan_ccod and t2.carr_ccod=t5.carr_ccod "& vbCrLf &_
						"   where tt.pers_ncorr=a.pers_ncorr and t4.carr_ccod=cc.carr_ccod) as fecha_titulacion,  "& vbCrLf &_
						" protic.trunc(fecha_incorporacion) as fecha_incorporacion,protic.trunc(fecha_vencimiento) as fecha_vencimiento,dae.observaciones, "& vbCrLf &_
					    " (select top 1 dlp.dlpr_nombre_empresa from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = a.pers_ncorr order by dlp.audi_fmodificacion desc) as empresa, "& vbCrLf &_
					    " (select top 1 dlp.dlpr_rubro_empresa from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = a.pers_ncorr order by dlp.audi_fmodificacion desc) as rubro, "& vbCrLf &_
					    " (select top 1 dlp.dlpr_cargo_empresa from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = a.pers_ncorr order by dlp.audi_fmodificacion desc) as cargo, "& vbCrLf &_
					    " (select top 1 dlp.dlpr_depto_empresa from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = a.pers_ncorr order by dlp.audi_fmodificacion desc) as depto, "& vbCrLf &_
					    " (select top 1 dlp.dlpr_email_empresa from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = a.pers_ncorr order by dlp.audi_fmodificacion desc) as email_laboral, "& vbCrLf &_
					    " (select top 1 dlp.dlpr_web_empresa from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = a.pers_ncorr order by dlp.audi_fmodificacion desc) as web, "& vbCrLf &_
					    " (select top 1 pp2.pais_tdesc from alumni_direccion_laboral_profesionales dlp, paises pp2 where dlp.pers_ncorr = a.pers_ncorr and dlp.pais_ccod=pp2.pais_ccod order by dlp.audi_fmodificacion desc) as pais_laboral, "& vbCrLf &_
					    " (select top 1 dlp.dlpr_tcalle + ' ' + isnull(dlp.dlpr_tnro,'') + '  ' + isnull((case dlp.dlpr_tblock when '' then '' else 'Depto '+dlp.dlpr_tblock  end),'')+' ' + isnull(dlp.dlpr_tpoblacion, '') from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = a.pers_ncorr order by dlp.audi_fmodificacion desc) as direccion_laboral, "& vbCrLf &_
					    " (select top 1 case dlp.pais_ccod when 1 then ciud2.ciud_tdesc + ' - ' + ciud2.ciud_tcomuna else dlp.dlpr_regi_particular + ' - ' + dlp.dlpr_ciud_particular end from alumni_direccion_laboral_profesionales dlp, paises pp2,ciudades ciud2 where dlp.pers_ncorr = a.pers_ncorr and dlp.pais_ccod=pp2.pais_ccod and dlp.ciud_ccod = ciud2.ciud_ccod  order by dlp.audi_fmodificacion desc) as ciudad_laboral, "& vbCrLf &_
					    " (select top 1 dlp.dlpr_cpostal from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = a.pers_ncorr order by dlp.audi_fmodificacion desc) as cod_postal_laboral, "& vbCrLf &_
					    " (select top 1 dlp.dlpr_tfono from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = a.pers_ncorr order by dlp.audi_fmodificacion desc) as fono_laboral, "& vbCrLf &_
					    " (select top 1 dlp.dire_tfax from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = a.pers_ncorr order by dlp.audi_fmodificacion desc) as fax_laboral, "& vbCrLf &_
					    " (select top 1 dlp.dlpr_tobservacion from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = a.pers_ncorr order by dlp.audi_fmodificacion desc) as observacion_laboral , "& vbCrLf &_
					    " protic.ultima_modificacion_cpp(a.pers_ncorr,2) as usuario, "& vbCrLf &_
					    " protic.ultima_modificacion_cpp(a.pers_ncorr,1) as fecha_modificacion,otro_email_personal, "& vbCrLf &_
						" case dae.tipo_contacto when 'P' then 'Particular' when 'C' then 'Comercial' else '' end as tipo_contacto,recibir_info "& vbCrLf &_
						"  from alumnos a (nolock) join  ofertas_academicas b "& vbCrLf &_
					    "    on a.ofer_ncorr=b.ofer_ncorr "& vbCrLf &_
					    "  join especialidades c "& vbCrLf &_
					    "    on b.espe_ccod=c.espe_ccod "& vbCrLf &_
					    " join alumni_personas d (nolock) "& vbCrLf &_
					    "    on a.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					    " join periodos_Academicos e "& vbCrLf &_
					    "    on b.peri_ccod = e.peri_ccod  "& vbCrLf &_
						" join sedes see "& vbCrLf &_
    					"	 on b.sede_ccod = see.sede_ccod  "& vbCrLf &_
						" join estados_matriculas f "& vbCrLf &_
					    "    on a.emat_ccod= f.emat_ccod  "& vbCrLf &_
					    " join jornadas jj "& vbCrLf &_
					    "    on b.jorn_ccod=jj.jorn_ccod "& vbCrLf &_
						" join carreras cc "& vbCrLf &_
					    "    on c.carr_ccod=cc.carr_ccod "& vbCrLf &_
						" join sexos ss  "& vbCrLf &_
						"    on d.sexo_ccod=ss.sexo_ccod "& vbCrLf &_
						" join paises pp"& vbCrLf &_
						"    on isnull(d.pais_ccod,0) = pp.pais_ccod"& vbCrLf &_
						" left outer join alumni_datos_adicionales_egresados dae"& vbCrLf &_
						"    on d.pers_ncorr = dae.pers_ncorr"& vbCrLf &_
						" left outer join tipos_socios ts"& vbCrLf &_
						"    on dae.tsoc_ccod = ts.tsoc_ccod   "& vbCrLf &_
						" left outer join alumni_direcciones dd "& vbCrLf &_
					    "    on d.pers_ncorr=dd.pers_ncorr  and 2 = dd.tdir_ccod "& vbCrLf &_
					    " left outer join ciudades ci1 "& vbCrLf &_
					    "    on dd.ciud_ccod=ci1.ciud_ccod "& vbCrLf &_
					    " left outer join regiones re1 "& vbCrLf &_
					    "    on ci1.regi_ccod=re1.regi_ccod "& vbCrLf &_
						" where a.emat_ccod in (4,8) "& vbCrLf
						'cambiado : a.emat_ccod = (select top 1 emat_ccod from alumnos a1, ofertas_academicas o1 where a1.pers_ncorr=a.pers_ncorr and a1.ofer_ncorr=o1.ofer_ncorr and o1.espe_ccod = c.espe_ccod and emat_ccod in (4,8) order by o1.peri_ccod desc, convert(datetime,a1.audi_fmodificacion) desc)
						if sin_carrera = "" or sin_carrera = "0" then 
							if sin_jornada = "" or sin_jornada = "0" then 
								consulta = consulta & "  and  c.carr_ccod='"&carr_ccod&"' and cast(b.jorn_ccod as varchar)='"&jorn_ccod&"'"
							else
								consulta = consulta & "  and  c.carr_ccod='"&carr_ccod&"'"
							end if
						end if
                        if pers_nrut <> "" and pers_xdv <> ""	then
						    consulta = consulta & " and cast(d.pers_nrut as varchar)='"&pers_nrut&"'"
						end if 		
						if pers_tape_paterno <> "" then
			    			consulta = consulta & " and d.pers_tape_paterno like '%"&pers_tape_paterno&"%'"
						end if 		
						if pers_tape_materno <> "" then
			    			consulta = consulta & " and d.pers_tape_materno like '%"&pers_tape_materno&"%'"
						end if 		
						if pers_tnombre <> "" then
			    			consulta = consulta & " and d.pers_tnombre like '%"&pers_tnombre&"%'"
						end if 	
						if mes_ccod <> "" then
			    			consulta = consulta & " and cast(datepart(month,d.pers_fnacimiento) as varchar)='"&mes_ccod&"'"
						end if 
						if sexo_ccod <> "" then
							consulta = consulta & " and cast(d.sexo_ccod as varchar)='"&sexo_ccod&"'"
						end if 	
						if pers_temail <> "" then
							consulta = consulta & " and d.pers_temail like '%"&pers_temail&"%'"
						end if 	 
						if ano_egreso <> "" then
							consulta = consulta & " and e.anos_ccod ='"&ano_egreso&"'"
						end if 					
						if fecha_modificacion <> "" then
						    consulta = consulta & " and exists (select 1 from alumni_datos_adicionales_egresados dae where dae.pers_ncorr= d.pers_ncorr and convert(varchar,dae.audi_fmodificacion,103) <= convert(datetime,'"&fecha_modificacion&"',103))"
						end if 

 consulta = consulta &	" union                 "& vbCrLf &_
						"    select cast(b.pers_nrut as varchar) +'-'+ b.pers_xdv as rut,  "& vbCrLf &_
						"	 b.pers_tape_paterno + ' ' + b.pers_tape_materno + ' ' + b.pers_tnombre as alumno, "& vbCrLf &_
						"	 case a.emat_ccod when 4 then 'EGRESADO' when 8 then 'TITULADO' end as estado,  "& vbCrLf &_
						"	 c.anos_ccod as realizado,protic.ano_ingreso_carrera_egresa2(b.pers_ncorr,cc.carr_ccod) as promocion,protic.initCap(isnull(case b.pers_temail when '' then 'No Registra' else b.pers_temail end,'No registra')) as email, "& vbCrLf &_
						"	 isnull(protic.trunc(b.pers_fnacimiento),'No Registra') as fecha_nacimiento, "& vbCrLf &_  
						"	 b.pers_ncorr,e.sede_tdesc as sede,f.saca_tdesc + ' (Salida Intermedia)' as carrera, 'Universidad' as letra, "& vbCrLf &_
						"	 (select top 1 jorn_tdesc "& vbCrLf &_ 
						"	  from alumnos pp (nolock), ofertas_academicas p2, especialidades p3, jornadas p4 "& vbCrLf &_
						"	  where pp.ofer_ncorr=p2.ofer_ncorr and p2.espe_ccod=p3.espe_ccod and p2.jorn_ccod=p4.jorn_ccod "& vbCrLf &_
						"	  and pp.pers_ncorr=a.pers_ncorr and p3.carr_ccod=cc.carr_ccod order by p2.peri_ccod desc) as jornada, "& vbCrLf &_
						"	  ss.sexo_tdesc as sexo, "& vbCrLf &_ 
						"	  pp.pais_tdesc as pais,dd.dire_tcalle,dd.dire_tnro,dd.dire_tblock,dd.dire_tpoblacion,dire_tdepto,dire_tlocalidad,ci1.ciud_tdesc as comuna, ci1.ciud_tcomuna as ciudad, re1.regi_tdesc, "& vbCrLf &_ 
						"	  b.regi_particular,b.ciud_particular,b.pers_tfono as telefono_personal,b.pers_tcelular as celular, b.pers_tfax as fax,  "& vbCrLf &_
						"	  dae.cod_postal as cod_postal,dae.num_hijos as numero_hijos,ts.tsoc_tdesc as tipo_socio,  "& vbCrLf &_
						"	  isnull((select case a.emat_ccod when 4 then protic.trunc(ttt.fecha_egreso) "& vbCrLf &_
						"                    else isnull(protic.trunc(ttt.fecha_titulacion),protic.trunc(asca_fsalida)) end "& vbCrLf &_
						"       from detalles_titulacion_carrera ttt  "& vbCrLf &_
						"       where ttt.pers_ncorr=a.pers_ncorr and ttt.plan_ccod=a.saca_ncorr),'--') as fecha_titulacion, "& vbCrLf &_
						"	  protic.trunc(fecha_incorporacion) as fecha_incorporacion,protic.trunc(fecha_vencimiento) as fecha_vencimiento,dae.observaciones, "& vbCrLf &_ 
						"	 (select top 1 dlp.dlpr_nombre_empresa from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = b.pers_ncorr order by dlp.audi_fmodificacion desc) as empresa, "& vbCrLf &_
						"	 (select top 1 dlp.dlpr_rubro_empresa from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = b.pers_ncorr order by dlp.audi_fmodificacion desc) as rubro, "& vbCrLf &_
						"	 (select top 1 dlp.dlpr_cargo_empresa from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = b.pers_ncorr order by dlp.audi_fmodificacion desc) as cargo, "& vbCrLf &_ 
						"	 (select top 1 dlp.dlpr_depto_empresa from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = b.pers_ncorr order by dlp.audi_fmodificacion desc) as depto, "& vbCrLf &_
						"	 (select top 1 dlp.dlpr_email_empresa from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = b.pers_ncorr order by dlp.audi_fmodificacion desc) as email_laboral, "& vbCrLf &_
						"	 (select top 1 dlp.dlpr_web_empresa from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = b.pers_ncorr order by dlp.audi_fmodificacion desc) as web, "& vbCrLf &_
						"	 (select top 1 pp2.pais_tdesc from alumni_direccion_laboral_profesionales dlp, paises pp2 where dlp.pers_ncorr = b.pers_ncorr and dlp.pais_ccod=pp2.pais_ccod order by dlp.audi_fmodificacion desc) as pais_laboral, "& vbCrLf &_
						"	 (select top 1 dlp.dlpr_tcalle + ' ' + isnull(dlp.dlpr_tnro,'') + '  ' + isnull((case dlp.dlpr_tblock when '' then '' else 'Depto '+dlp.dlpr_tblock  end),'')+' ' + isnull(dlp.dlpr_tpoblacion, '') from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = b.pers_ncorr order by dlp.audi_fmodificacion desc) as direccion_laboral, "& vbCrLf &_
						"	 (select top 1 case dlp.pais_ccod when 1 then ciud2.ciud_tdesc + ' - ' + ciud2.ciud_tcomuna else dlp.dlpr_regi_particular + ' - ' + dlp.dlpr_ciud_particular end from alumni_direccion_laboral_profesionales dlp, paises pp2,ciudades ciud2 where dlp.pers_ncorr = b.pers_ncorr and dlp.pais_ccod=pp2.pais_ccod and dlp.ciud_ccod = ciud2.ciud_ccod  order by dlp.audi_fmodificacion desc) as ciudad_laboral, "& vbCrLf &_
						"	 (select top 1 dlp.dlpr_cpostal from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = b.pers_ncorr order by dlp.audi_fmodificacion desc) as cod_postal_laboral, "& vbCrLf &_
						"	 (select top 1 dlp.dlpr_tfono from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = b.pers_ncorr order by dlp.audi_fmodificacion desc) as fono_laboral, "& vbCrLf &_ 
						"	 (select top 1 dlp.dire_tfax from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = b.pers_ncorr order by dlp.audi_fmodificacion desc) as fax_laboral, "& vbCrLf &_
						"	 (select top 1 dlp.dlpr_tobservacion from alumni_direccion_laboral_profesionales dlp where dlp.pers_ncorr = b.pers_ncorr order by dlp.audi_fmodificacion desc) as observacion_laboral , "& vbCrLf &_
						"	 protic.ultima_modificacion_cpp(b.pers_ncorr,2) as usuario, "& vbCrLf &_
						"	 protic.ultima_modificacion_cpp(b.pers_ncorr,1) as fecha_modificacion, otro_email_personal, "& vbCrLf &_
						"	 case dae.tipo_contacto when 'P' then 'Particular' when 'C' then 'Comercial' else '' end as tipo_contacto,recibir_info "& vbCrLf &_
						"	 from alumnos_salidas_intermedias a join alumni_personas b (nolock) "& vbCrLf &_
						"		on  a.pers_ncorr = b.pers_ncorr and a.emat_ccod in (4,8) "& vbCrLf &_
						"	 join periodos_academicos c "& vbCrLf &_
						"		on a.peri_ccod=c.peri_ccod "& vbCrLf &_
						"	 join alumnos_salidas_carrera d "& vbCrLf &_
						"		on d.pers_ncorr=a.pers_ncorr and d.saca_ncorr=a.saca_ncorr "& vbCrLf &_
						"	 join sedes e "& vbCrLf &_
						"		on e.sede_ccod=d.sede_ccod "& vbCrLf &_
						"	 join salidas_carrera f "& vbCrLf &_
						"		on a.saca_ncorr=f.saca_ncorr "& vbCrLf &_
						"	 join carreras cc  "& vbCrLf &_
						"		on  cc.carr_ccod = f.carr_ccod   "& vbCrLf &_
						"	 join sexos ss   "& vbCrLf &_
						"		on  b.sexo_ccod=ss.sexo_ccod  "& vbCrLf &_
						"	 join paises pp  "& vbCrLf &_
						"		on isnull(b.pais_ccod,0) = pp.pais_ccod  "& vbCrLf &_
						"	 left outer join alumni_direcciones dd "& vbCrLf &_
						"		on b.pers_ncorr=dd.pers_ncorr  and 2 = dd.tdir_ccod  "& vbCrLf &_
						"	 left outer join ciudades ci1  "& vbCrLf &_
						"		on dd.ciud_ccod=ci1.ciud_ccod  "& vbCrLf &_
						"	 left outer join regiones re1  "& vbCrLf &_
						"		on ci1.regi_ccod=re1.regi_ccod     "& vbCrLf &_
						"	 left outer join alumni_datos_adicionales_egresados dae   "& vbCrLf &_
						"		on b.pers_ncorr = dae.pers_ncorr   "& vbCrLf &_
						"	 left outer join tipos_socios ts   "& vbCrLf &_
						"		on dae.tsoc_ccod = ts.tsoc_ccod "& vbCrLf

						if sin_carrera = "" or sin_carrera = "0" then 
							if sin_jornada = "" or sin_jornada = "0" then 
								consulta = consulta & " and  cc.carr_ccod='"&carr_ccod&"' "& vbCrLf &_
								                      " and cast((select top 1 jorn_ccod from alumnos tt (nolock), ofertas_academicas t2, especialidades t3  "& vbCrLf &_
													  "           where tt.pers_ncorr=a.pers_ncorr and tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  "& vbCrLf &_
													  "           and t3.carr_ccod = cc.carr_ccod order by t2.peri_ccod desc) as varchar) = '"&jorn_ccod&"'"
							else
								consulta = consulta & "  and  cc.carr_ccod='"&carr_ccod&"'"
							end if
						end if
                        if pers_nrut <> "" and pers_xdv <> ""	then
						    consulta = consulta & " and cast(b.pers_nrut as varchar)='"&pers_nrut&"'"
						end if 		
						if pers_tape_paterno <> "" then
			    			consulta = consulta & " and b.pers_tape_paterno like '%"&pers_tape_paterno&"%'"
						end if 		
						if pers_tape_materno <> "" then
			    			consulta = consulta & " and b.pers_tape_materno like '%"&pers_tape_materno&"%'"
						end if 		
						if pers_tnombre <> "" then
			    			consulta = consulta & " and b.pers_tnombre like '%"&pers_tnombre&"%'"
						end if 	
						if mes_ccod <> "" then
			    			consulta = consulta & " and cast(datepart(month,b.pers_fnacimiento) as varchar)='"&mes_ccod&"'"
						end if 
						if sexo_ccod <> "" then
							consulta = consulta & " and cast(b.sexo_ccod as varchar)='"&sexo_ccod&"'"
						end if 	
						if pers_temail <> "" then
							consulta = consulta & " and b.pers_temail like '%"&pers_temail&"%'"
						end if 	 
						if ano_egreso <> "" then
							consulta = consulta & " and c.anos_ccod ='"&ano_egreso&"'"
						end if 					
						if fecha_modificacion <> "" then
						    consulta = consulta & " and exists (select 1 from alumni_datos_adicionales_egresados dae where dae.pers_ncorr= b.pers_ncorr and convert(varchar,dae.audi_fmodificacion,103) <= convert(datetime,'"&fecha_modificacion&"',103))"
						end if 			
'response.Write("<pre>"&consulta&"</pre>")						

'cantidad_alumnos = conexion.consultaUno("select count(*) from (" &consulta & ")a")			
consulta = "select * from (" &consulta & ")a order by alumno"
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_alumnos.Consultar consulta
%>
<html>
<head>
<title>Listado alumnos pertenecientes a la corporación de profesionales</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado alumnos pertenecientes a la corporación de profesionales</font></div>
	<div align="right"><%=fecha%></div></td>
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr>
  	<td>&nbsp;</td>
	<td colspan="4" align="center"><strong>Datos Personales</strong></td>
	<td colspan="8" align="center"><strong>Datos Académicos</strong></td>
	<td colspan="18" align="center"><strong>Datos de Dirección Particular</strong></td>
	<td colspan="5" align="center"><strong>Información de Corporación de Profesionales</strong></td>
	<td colspan="6" align="center"><strong>Datos Laborales</strong></td>
	<td colspan="7" align="center"><strong>Datos de Dirección Laboral</strong></td>
	<td colspan="2" align="center"><strong>Información de Auditoría</strong></td>
    <td colspan="2" align="center" bgcolor="#FFCC66"><strong>CONTACTO</strong></td>
    
  </tr>
  <tr>
    <td><div align="center"><strong>Fila</strong></div></td> 
    <td><div align="left"><strong>Rut</strong></div></td>
    <td><div align="left"><strong>Nombre</strong></div></td>
	<td><div align="center"><strong>Sexo</strong></div></td>
	<td><div align="center"><strong>Fecha Nacimiento</strong></div></td>
	<td><div align="center"><strong>Entidad</strong></div></td>
	<td><div align="left"><strong>Sede</strong></div></td>
	<td><div align="left"><strong>Carrera</strong></div></td>
	<td><div align="left"><strong>Jornada</strong></div></td>
	<td><div align="center"><strong>Estado</strong></div></td>
	<td><div align="center"><strong>Promoción</strong></div></td>
	<td><div align="center"><strong>Realizado</strong></div></td>
	<td><div align="center"><strong>Fecha Proceso</strong></div></td>
	<td><div align="left"><strong>Email</strong></div></td>
	<td><div align="left"><strong>Otro Email</strong></div></td>
    <td><div align="left"><strong>País</strong></div></td>
	<td><div align="left"><strong>Calle</strong></div></td>
    <td><div align="left"><strong>Nro</strong></div></td>
    <td><div align="left"><strong>Depto</strong></div></td>
    <td><div align="left"><strong>Condominio</strong></div></td>
    <td><div align="left"><strong>Villa</strong></div></td>
    <td><div align="left"><strong>Localidad</strong></div></td>
    <td><div align="left"><strong>Comuna</strong></div></td>
	<td><div align="left"><strong>Ciudad</strong></div></td>
    <td><div align="left"><strong>Región</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>Región Extranjero</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>Ciudad Extranjero</strong></div></td>
	<td><div align="left"><strong>Teléfono Personal</strong></div></td>
	<td><div align="left"><strong>Celular</strong></div></td>
	<td><div align="left"><strong>Fax</strong></div></td>
	<td><div align="left"><strong>Cód. Postal</strong></div></td>
	<td><div align="center"><strong>Nro. Hijos</strong></div></td>
	<td><div align="left"><strong>Tipo Socio</strong></div></td>
	<td><div align="center"><strong>Fecha Incorporación</strong></div></td>
	<td><div align="center"><strong>Fecha Vencimiento</strong></div></td>
	<td><div align="left"><strong>Observación</strong></div></td>
	<td><div align="left"><strong>Empresa</strong></div></td>
	<td><div align="left"><strong>Rubro</strong></div></td>
	<td><div align="left"><strong>Departamento</strong></div></td>
	<td><div align="left"><strong>Cargo</strong></div></td>
	<td><div align="left"><strong>Email Empresa</strong></div></td>
	<td><div align="left"><strong>Web Empresa</strong></div></td>
	<td><div align="left"><strong>País</strong></div></td>
	<td><div align="left"><strong>Dirección</strong></div></td>
	<td><div align="left"><strong>Ciudad</strong></div></td>
	<td><div align="left"><strong>Cód. Postal</strong></div></td>
	<td><div align="left"><strong>Teléfono Comercial</strong></div></td>
	<td><div align="left"><strong>Fax Comercial</strong></div></td>
	<td><div align="left"><strong>Observación</strong></div></td>
	<td><div align="left"><strong>Usuario</strong></div></td>
	<td><div align="center"><strong>Fecha Modificación</strong></div></td>
    <td bgcolor="#FFCC66"><div align="center"><strong>Tipo de Contacto</strong></div></td>
    <td bgcolor="#FFCC66"><div align="center"><strong>Recibir Información</strong></div></td>
  </tr>
  <%fila = 1  
    while f_alumnos.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_alumnos.ObtenerValor("alumno")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("sexo")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("fecha_nacimiento")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("letra")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("sede")%></div></td>
    <td><div align="left"><%=f_alumnos.ObtenerValor("carrera")%></div></td>
    <td><div align="left"><%=f_alumnos.ObtenerValor("jornada")%></div></td>
    <td><div align="center"><%=f_alumnos.ObtenerValor("estado")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("promocion")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("realizado")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("fecha_titulacion")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("email")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("otro_email_personal")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("pais")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("dire_tcalle")%></div></td>
    <td><div align="left"><%=f_alumnos.ObtenerValor("dire_tnro")%></div></td>
    <td><div align="left"><%=f_alumnos.ObtenerValor("dire_tblock")%></div></td>
    <td><div align="left"><%=f_alumnos.ObtenerValor("dire_tpoblacion")%></div></td>
    <td><div align="left"><%=f_alumnos.ObtenerValor("dire_tdepto")%></div></td>
    <td><div align="left"><%=f_alumnos.ObtenerValor("dire_tlocalidad")%></div></td>
    <td><div align="left"><%=f_alumnos.ObtenerValor("comuna")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("ciudad")%></div></td>
    <td><div align="left"><%=f_alumnos.ObtenerValor("regi_tdesc")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("regi_particular")%></div></td>	
	<td><div align="left"><%=f_alumnos.ObtenerValor("ciud_particular")%></div></td>	
	<td><div align="left"><%=f_alumnos.ObtenerValor("telefono_personal")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("celular")%></div></td>	
	<td><div align="left"><%=f_alumnos.ObtenerValor("fax")%></div></td>	
	<td><div align="left"><%=f_alumnos.ObtenerValor("cod_postal")%></div></td>	
	<td><div align="center"><%=f_alumnos.ObtenerValor("numero_hijos")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("tipo_socio")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("fecha_incorporacion")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("fecha_vencimiento")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("observaciones")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("empresa")%></div></td>	
	<td><div align="left"><%=f_alumnos.ObtenerValor("rubro")%></div></td>	
	<td><div align="left"><%=f_alumnos.ObtenerValor("depto")%></div></td>	
	<td><div align="left"><%=f_alumnos.ObtenerValor("cargo")%></div></td>	
	<td><div align="left"><%=f_alumnos.ObtenerValor("email_laboral")%></div></td>	
	<td><div align="left"><%=f_alumnos.ObtenerValor("web")%></div></td>	
	<td><div align="left"><%=f_alumnos.ObtenerValor("pais_laboral")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("direccion_laboral")%></div></td>	
	<td><div align="left"><%=f_alumnos.ObtenerValor("ciudad_laboral")%></div></td>	
	<td><div align="left"><%=f_alumnos.ObtenerValor("cod_postal_laboral")%></div></td>	
	<td><div align="left"><%=f_alumnos.ObtenerValor("fono_laboral")%></div></td>	
	<td><div align="left"><%=f_alumnos.ObtenerValor("fax_laboral")%></div></td>	
	<td><div align="left"><%=f_alumnos.ObtenerValor("observacion_laboral")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("usuario")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("fecha_modificacion")%></div></td>
    <td bgcolor="#FFCC66"><div align="center"><%=f_alumnos.ObtenerValor("tipo_contacto")%></div></td>
    <td bgcolor="#FFCC66"><div align="center"><%=f_alumnos.ObtenerValor("recibir_info")%></div></td>
  </tr>
  <%fila = fila + 1  
    wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>
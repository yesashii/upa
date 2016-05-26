<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.end
asig_ccod=request.Form("egreso[0][asig_ccod]")
peri_ccod=request.Form("egreso[0][peri_ccod]")
sitf_ccod=request.Form("egreso[0][sitf_ccod]")
pers_ncorr=request.Form("egreso[0][pers_ncorr]")
plan_ccod=request.Form("egreso[0][plan_ccod]")
saca_ncorr=request.Form("saca_ncorr")



'-------------------------------------------------------------------------------------------------'
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

plec_ccod_egreso = request.Form("plec_ccod_egreso")
aceptar = request.Form("aceptar")
anos_ccod_egreso = request.Form("anos_ccod_egreso")
fecha_egreso = request.Form("egreso[0][fecha_egreso]")
if aceptar = "1" and not EsVacio(fecha_egreso) and not EsVacio(anos_ccod_egreso) then
	periodo_egreso = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod_egreso&"' and cast(plec_ccod as varchar)='"&plec_ccod_egreso&"'")
	if EsVacio(periodo_egreso) then
		session("msjError")="No existe periodo habilitado para la generación de matrícula de egreso para el alumno."
		response.Redirect(request.ServerVariables("HTTP_REFERER"))
	end if
end if

carr_ccod = conexion.consultaUno("select carr_ccod from planes_estudio a, especialidades b where a.espe_ccod=b.espe_ccod and cast(a.plan_ccod as varchar)='"&plan_ccod&"'")

c_practica_grabada = " Select case count(*) when 0 then 'NO' else 'SI' end from alumnos tt, cargas_academicas t2, secciones t3, asignaturas t4 "&_
					 " where tt.matr_ncorr=t2.matr_ncorr and t2.secc_ccod=t3.secc_ccod and t3.asig_ccod=t4.asig_ccod and (t4.asig_tdesc like '%pr%ctica profesional%' or t4.asig_tdesc like '%pr%ctica profesional%') "&_
					 " and cast(tt.pers_ncorr as varchar)='"&pers_ncorr&"' and t3.carr_ccod='"&carr_ccod&"'"

practica_grabada = conexion.consultaUno(c_practica_grabada)

if practica_grabada ="SI" and asig_ccod = "" and peri_ccod="" then
	c_asig_ccod    = " Select t4.asig_ccod from alumnos tt, cargas_academicas t2, secciones t3, asignaturas t4 "&_
					 " where tt.matr_ncorr=t2.matr_ncorr and t2.secc_ccod=t3.secc_ccod and t3.asig_ccod=t4.asig_ccod and (t4.asig_tdesc like '%pr%ctica profesional%' or t4.asig_tdesc like '%pr%ctica profesional%' ) "&_
					 " and cast(tt.pers_ncorr as varchar)='"&pers_ncorr&"' and t3.carr_ccod='"&carr_ccod&"'"
	asig_ccod      = conexion.consultaUno(c_asig_ccod)
	
	c_peri_ccod    = " Select t3.peri_ccod from alumnos tt, cargas_academicas t2, secciones t3, asignaturas t4 "&_
					 " where tt.matr_ncorr=t2.matr_ncorr and t2.secc_ccod=t3.secc_ccod and t3.asig_ccod=t4.asig_ccod and (t4.asig_tdesc like '%pr%ctica profesional%' or t4.asig_tdesc like '%pr%ctica profesional%') "&_
					 " and cast(tt.pers_ncorr as varchar)='"&pers_ncorr&"' and t3.carr_ccod='"&carr_ccod&"'"
	peri_ccod      = conexion.consultaUno(c_peri_ccod)

end if
'response.Write(asig_ccod)'
'response.Write(peri_ccod)'
'response.Write(sitf_ccod)'
'response.end
if practica_grabada="NO" and asig_ccod <> "" and peri_ccod <> "" and sitf_ccod <> "" then 
		es_practica = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end from asignaturas where asig_ccod='"&asig_ccod&"' and (asig_tdesc like '%pr%ctica profesional%' or asig_tdesc like '%pr%ctica profesional%')")
		if es_practica = "NO" then
		 session("msjError")="El código de asignatura ingresado no corresponde a práctica profesional."
		 response.Redirect(request.ServerVariables("HTTP_REFERER"))
		end if
		
		c_matriculado = " select case count(*) when 0 then 'NO' else 'SI' end from alumnos a, ofertas_academicas b, especialidades c "&_
						" where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'"&_
						" and cast(b.peri_ccod as varchar)='"&peri_ccod&"' and a.emat_ccod <>9 and carr_ccod='"&carr_ccod&"'"
		matriculado = conexion.consultaUno(c_matriculado)				
		if matriculado = "SI" then
			c_matr_ncorr =" select matr_ncorr from alumnos a, ofertas_academicas b, especialidades c "&_
						  " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'"&_
						  " and cast(b.peri_ccod as varchar)='"&peri_ccod&"' and a.emat_ccod <> 9 and carr_ccod='"&carr_ccod&"'"
			matr_ncorr = conexion.consultaUno(c_matr_ncorr)
		else
			session("msjError")="El alumno no presenta matrícula para el periodo consultado."
			response.Redirect(request.ServerVariables("HTTP_REFERER"))
		end if
		mall_ccod = conexion.consultaUno("select mall_ccod from malla_curricular where cast(plan_ccod as varchar)='"&plan_ccod&"' and asig_ccod='"&asig_ccod&"'")
		if EsVacio(mall_ccod) then
			c_mall_ccod = " select mall_ccod from malla_curricular a, planes_estudio b, especialidades c where asig_ccod='"&asig_ccod&"'" &_
						  " and a.plan_ccod=b.plan_ccod and b.espe_ccod=c.espe_ccod and c.carr_ccod='"&carr_ccod&"'"
			mall_ccod=conexion.consultaUno(c_mall_ccod)
		end if
		
		if EsVacio(mall_ccod) then
			session("msjError")="El código de práctica ingresado no se encuentra en ningún plan de estudio para la carrera del alumno."
			response.Redirect(request.ServerVariables("HTTP_REFERER"))
		end if
		sede_ccod_t = conexion.consultaUno("select sede_ccod from alumnos a, ofertas_academicas b where a.ofer_ncorr=b.ofer_ncorr and cast(matr_ncorr as varchar)='"&matr_ncorr&"'")
	
		c_secc_ccod = " select secc_ccod from secciones where asig_ccod='"&asig_ccod&"'" &_
					  " and cast(mall_ccod as varchar)='"&mall_ccod&"' and cast(peri_ccod as varchar)='"&peri_ccod&"' and cast(sede_ccod as varchar)='"&sede_ccod_t&"'"
		secc_ccod=conexion.consultaUno(c_secc_ccod)
		if EsVacio(secc_ccod) then
			c_secc_ccod = " select top 1 secc_ccod from secciones where asig_ccod='"&asig_ccod&"'" &_
						  " and cast(mall_ccod as varchar)='"&mall_ccod&"' and carr_ccod ='"&carr_ccod&"' and cast(sede_ccod as varchar)='"&sede_ccod_t&"' order by peri_ccod desc "
			secc_ccod=conexion.consultaUno(c_secc_ccod)
			if not EsVacio(secc_ccod) then
				secc_ccod2 = conexion.consultaUno("execute obtenerSecuencia 'secciones'")
				c_insert =  "INSERT INTO SECCIONES (SECC_CCOD,SEDE_CCOD,JORN_CCOD,CARR_CCOD,MODA_CCOD,PERI_CCOD,ASIG_CCOD,SECC_TDESC,SECC_NQUORUM,SECC_NCUPO,SECC_FINICIO_SEC, "& vbCrLf &_
							"                       SECC_FTERMINO_SEC,AUDI_TUSUARIO,AUDI_FMODIFICACION,ESTADO_CIERRE_CCOD,TASG_CCOD,MALL_CCOD) "& vbCrLf &_
							" select '"&secc_ccod2&"' as SECC_CCOD,SEDE_CCOD,JORN_CCOD,CARR_CCOD,MODA_CCOD,'"&peri_ccod&"' as PERI_CCOD,ASIG_CCOD,SECC_TDESC,SECC_NQUORUM,SECC_NCUPO, NULL as SECC_FINICIO_SEC, "& vbCrLf &_
							" NULL as SECC_FTERMINO_SEC,'Creada x TyG' as AUDI_TUSUARIO,getDate() as AUDI_FMODIFICACION,ESTADO_CIERRE_CCOD,TASG_CCOD,MALL_CCOD "& vbCrLf &_
							" from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'"
				conexion.ejecutaS c_insert
				secc_ccod = secc_ccod2
				'response.Write("<pre>"&c_insert&"</pre>")'
			end if
		end if
			
		if EsVacio(secc_ccod) then
			session("msjError")="No se han encontrado planificaciones académicas de la asignatura para el periodo consultado, solicite planificación a dirección de docencia."
			response.Redirect(request.ServerVariables("HTTP_REFERER"))
		end if
		
		calificacion = request.form("egreso[0][calificacion_practica]")
		sitf_ccod= request.Form("egreso[0][sitf_ccod]")
		
		if not EsVacio(matr_ncorr) and not EsVacio(secc_ccod) then
		  if not EsVacio(calificacion) then
			c_insert_carga = " insert into cargas_academicas "& vbCrLf &_
							 " (matr_ncorr,secc_ccod,sitf_ccod,carg_nnota_presentacion,carg_nnota_final,acse_ncorr,audi_tusuario,audi_fmodificacion)"& vbCrLf &_
							 " values ('"&matr_ncorr&"','"&secc_ccod&"','"&sitf_ccod&"',"&calificacion&","&calificacion&",NULL,'agregado "&negocio.obtenerUsuario&"',getDate()) "
		  else
			c_insert_carga = " insert into cargas_academicas "& vbCrLf &_
							 " (matr_ncorr,secc_ccod,sitf_ccod,carg_nnota_presentacion,carg_nnota_final,acse_ncorr,audi_tusuario,audi_fmodificacion) "& vbCrLf &_
							 " values ('"&matr_ncorr&"','"&secc_ccod&"','"&sitf_ccod&"',NULL,NULL,NULL,'agregado "&negocio.obtenerUsuario&"',getDate()) "
		  end if
		  conexion.ejecutaS c_insert_carga
		  'response.Write("<pre>"&c_insert_carga&"</pre>")
		end if
		'response.End()
		
elseif practica_grabada="SI" and asig_ccod <> "" and peri_ccod <> "" and sitf_ccod <> "" then ' en el caso que la práctica ya se encuentre grabada sólo hay que modificarla
		calificacion = request.form("egreso[0][calificacion_practica]")
		sitf_ccod= request.Form("egreso[0][sitf_ccod]")
		c_matr_ncorr = " Select top 1 t2.matr_ncorr from alumnos tt, cargas_academicas t2, secciones t3, asignaturas t4 "&_
					   " where tt.matr_ncorr=t2.matr_ncorr and t2.secc_ccod=t3.secc_ccod and t3.asig_ccod=t4.asig_ccod and t4.asig_tdesc like '%pr%ctica profesional%' "&_
					   " and cast(tt.pers_ncorr as varchar)='"&pers_ncorr&"' and t3.carr_ccod='"&carr_ccod&"'"
		matr_ncorr = conexion.consultaUno(c_matr_ncorr)
		c_secc_ccod = " Select top 1 t2.secc_ccod from alumnos tt, cargas_academicas t2, secciones t3, asignaturas t4 "&_
					  " where tt.matr_ncorr=t2.matr_ncorr and t2.secc_ccod=t3.secc_ccod and t3.asig_ccod=t4.asig_ccod and t4.asig_tdesc like '%pr%ctica profesional%' "&_
					  " and cast(tt.pers_ncorr as varchar)='"&pers_ncorr&"' and t3.carr_ccod='"&carr_ccod&"'"
		
		secc_ccod = conexion.consultaUno(c_secc_ccod)
		if not EsVacio(matr_ncorr) and not EsVacio(secc_ccod) then
			if not EsVacio(calificacion) then
			   c_update    = " update cargas_academicas set  sitf_ccod='"&sitf_ccod&"',carg_nnota_presentacion="&calificacion&", "& vbCrLf &_
			                 " carg_nnota_final="&calificacion&",audi_tusuario='modif "&negocio.obtenerUsuario&"', audi_fmodificacion=getDate() "& vbCrLf &_
							 " where cast(matr_ncorr as varchar)='"&matr_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"'"
		    else
			   c_update    = " update cargas_academicas set  sitf_ccod='"&sitf_ccod&"',carg_nnota_presentacion=NULL, "& vbCrLf &_
			                 " carg_nnota_final=NULL,audi_tusuario='modif "&negocio.obtenerUsuario&"', audi_fmodificacion=getDate() "& vbCrLf &_
							 " where cast(matr_ncorr as varchar)='"&matr_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"'"
		    end if
		  conexion.ejecutaS c_update
		  'response.Write(c_update)
		end if
end if
'response.End()
if aceptar = "1" and not EsVacio(fecha_egreso) and not EsVacio(anos_ccod_egreso) then
'////////////////////////////Se debe crear la matrícula para el caso en que no tenga estado de egreso y haya aceptado la creación
	c_espe_ccod = " select t2.espe_ccod  "& vbCrLf &_ 
  	  			  " from alumnos t1,ofertas_academicas t2, especialidades t3 "& vbCrLf &_ 
			      " where cast(t1.pers_ncorr as varchar)='"&pers_ncorr&"' and t1.ofer_ncorr=t2.ofer_ncorr  "& vbCrLf &_ 
				  " and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod='"&carr_ccod&"' and isnull(t1.emat_ccod,0) <> 9 order by peri_ccod desc "
	c_sede_ccod = " select t2.sede_ccod  "& vbCrLf &_ 
  	  			  " from alumnos t1,ofertas_academicas t2, especialidades t3 "& vbCrLf &_ 
			      " where cast(t1.pers_ncorr as varchar)='"&pers_ncorr&"' and t1.ofer_ncorr=t2.ofer_ncorr  "& vbCrLf &_ 
				  " and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod='"&carr_ccod&"' and isnull(t1.emat_ccod,0) <> 9 order by peri_ccod desc "
    c_jorn_ccod = " select t2.jorn_ccod  "& vbCrLf &_ 
  	  			  " from alumnos t1,ofertas_academicas t2, especialidades t3 "& vbCrLf &_ 
			      " where cast(t1.pers_ncorr as varchar)='"&pers_ncorr&"' and t1.ofer_ncorr=t2.ofer_ncorr  "& vbCrLf &_ 
				  " and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod='"&carr_ccod&"' and isnull(t1.emat_ccod,0) <> 9 order by peri_ccod desc "
	c_plan_ccod = " select t1.plan_ccod  "& vbCrLf &_ 
  	  			  " from alumnos t1,ofertas_academicas t2, especialidades t3 "& vbCrLf &_ 
			      " where cast(t1.pers_ncorr as varchar)='"&pers_ncorr&"' and t1.ofer_ncorr=t2.ofer_ncorr  "& vbCrLf &_ 
				  " and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod='"&carr_ccod&"' and isnull(t1.emat_ccod,0) <> 9 order by peri_ccod desc "
	c_post_ncorr= " select t1.post_ncorr "& vbCrLf &_ 
  	  			  " from alumnos t1,ofertas_academicas t2, especialidades t3 "& vbCrLf &_ 
			      " where cast(t1.pers_ncorr as varchar)='"&pers_ncorr&"' and t1.ofer_ncorr=t2.ofer_ncorr  "& vbCrLf &_ 
				  " and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod='"&carr_ccod&"' and isnull(t1.emat_ccod,0) <> 9 order by peri_ccod desc "			  
	ano_ingreso = conexion.consultaUno("select protic.ano_ingreso_carrera_egresados("&pers_ncorr&",'"&carr_ccod&"')")
	if not esVacio(periodo_egreso) then
    	tiene_matricula = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end  from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and c.carr_ccod='"&carr_ccod&"' and cast(b.peri_ccod as varchar)='"&periodo_egreso&"' and a.emat_ccod=1")
		if tiene_matricula = "NO" then
			espe_ccod   = conexion.consultaUno(c_espe_ccod)
			sede_ccod   = conexion.consultaUno(c_sede_ccod)
			jorn_ccod   = conexion.consultaUno(c_jorn_ccod)
			plan_ccod   = conexion.consultaUno(c_plan_ccod)
			ulti_post   = conexion.consultaUno(c_post_ncorr)
			audi_tusuario = "ajuste matricula "&negocio.obtenerUsuario
			c_ofer_ncorr = "select a.ofer_ncorr from ofertas_academicas a,aranceles b where a.ofer_ncorr=b.ofer_ncorr "& vbCrLf &_
						   " and cast(a.espe_ccod as varchar)='"&espe_ccod&"' and cast(a.peri_ccod as varchar)='"&periodo_egreso&"' "& vbCrLf &_ 
						   " and cast(a.sede_ccod as varchar)='"&sede_ccod&"' and cast(a.jorn_ccod as varchar)='"&jorn_ccod&"' "& vbCrLf &_ 
						   " and cast(b.aran_nano_ingreso as varchar)='"&ano_ingreso&"' and isnull(aran_mmatricula,0) = 0 "
			ofer_ncorr   = conexion.consultaUno(c_ofer_ncorr)
			'En el caso de no encontrar la oferta registrada se debe grabar una nueva oferta y arancel
			if EsVacio(ofer_ncorr) then
				ofer_ncorr = conexion.consultauno("execute obtenersecuencia 'ofertas_academicas'")
				aran_ncorr = conexion.consultauno("execute obtenersecuencia 'aranceles'")
				c_oferta = "insert into ofertas_academicas (OFER_NCORR,SEDE_CCOD,PERI_CCOD,ESPE_CCOD,JORN_CCOD,POST_BNUEVO,ARAN_NCORR,OFER_NVACANTES,OFER_NQUORUM,OFER_BPAGA_EXAMEN,AUDI_TUSUARIO,AUDI_FMODIFICACION,OFER_BPUBLICA,OFER_BACTIVA)"&_
				   "values ("&ofer_ncorr&","&sede_ccod&","&periodo_egreso&",'"&espe_ccod&"',"&jorn_ccod&",'N',"&aran_ncorr&",100,1,'N','"&audi_tusuario&"',getDate(),'N','N')"   
				c_aranceles = "insert into aranceles (ARAN_NCORR,MONE_CCOD,OFER_NCORR,ARAN_TDESC,ARAN_MMATRICULA,ARAN_MCOLEGIATURA,ARAN_NANO_INGRESO,AUDI_TUSUARIO,AUDI_FMODIFICACION,sede_ccod,espe_ccod,carr_ccod,peri_ccod,jorn_ccod,aran_cvigente_fup)"&_
					  "values ("&aran_ncorr&",1,"&ofer_ncorr&",'ajuste matricula histórica',0,0,"&ano_ingreso&",'"&audi_tusuario&"',getDate(),"&sede_ccod&",'"&espe_ccod&"','"&carr_ccod&"',"&periodo_egreso&","&jorn_ccod&",'N')"
				conexion.ejecutaS c_oferta 
				conexion.ejecutaS c_aranceles
			end if
			post_ncorr = conexion.consultauno("execute obtenersecuencia 'postulantes'")
			matr_ncorr = conexion.consultauno("execute obtenersecuencia 'alumnos'")
			c_postulacion = " insert into postulantes (POST_NCORR,PERS_NCORR,EPOS_CCOD,TPOS_CCOD,PERI_CCOD,POST_BNUEVO,OCUP_CCOD,OFER_NCORR,POST_FPOSTULACION,TPAD_CCOD,POST_NPAA_VERBAL,POST_NPAA_MATEMATICAS,POST_NANO_PAA,IESU_CCOD,POST_TINSTITUCION_ANTERIOR,TIES_CCOD,POST_TTIPO_INSTITUCION_ANT,POST_TCARRERA_ANTERIOR,POST_NSEM_CURSADOS,POST_NSEM_APROBADOS,POST_NANO_INICIO_EST_ANT,POST_NANO_TERMINO_EST_ANT,POST_BTITULADO,POST_TTITULO_OBTENIDO,POST_BREQUIERE_EXAMEN,POST_NNOTA_EXAMEN,POST_BPASE_ESCOLAR,POST_TOTRO_COLEGIO,POST_NCORR_CODEUDOR,TBEN_CCOD1,TBEN_CCOD2,POST_BTRABAJA,POST_NINICIO,POST_BRECONOCIMIENTO_ESTUDIOS,POST_TOTRAS_ACTIVIDADES,AUDI_TUSUARIO,AUDI_FMODIFICACION,POST_BPAGA,POST_NCORRELATIVO)"&_
							" select "&post_ncorr&" as post_ncorr,pers_ncorr,2 as epos_ccod,tpos_ccod,"&periodo_egreso&" as peri_ccod,'N' as post_bnuevo,ocup_ccod,"&ofer_ncorr&" as ofer_ncorr,post_fpostulacion,tpad_ccod,post_npaa_verbal,post_npaa_matematicas,post_nano_paa,iesu_ccod,"&_
							" post_tinstitucion_anterior,ties_ccod,post_ttipo_institucion_ant,post_tcarrera_anterior,post_nsem_cursados,post_nsem_aprobados,post_nano_inicio_est_ant,post_nano_termino_est_ant, "&_
							" post_btitulado,post_ttitulo_obtenido,post_brequiere_examen,post_nnota_examen,post_bpase_escolar,post_totro_colegio,post_ncorr_codeudor,tben_ccod1,tben_ccod2,post_btrabaja,post_ninicio,"&_
							" post_breconocimiento_estudios,post_totras_Actividades,'"&audi_tusuario&"' as audi_tusuario,getDate() as audi_fmodificacion,post_bpaga,post_ncorrelativo "&_
							" from postulantes where cast(post_ncorr as varchar)= '"&ulti_post&"'"
		
			c_detalle_postulacion = "insert into detalle_postulantes (post_ncorr,ofer_ncorr,audi_tusuario,audi_fmodificacion,dpos_tobservacion,eepo_ccod,dpos_ncalificacion,dpos_fexamen)"&_
									" values("&post_ncorr&","&ofer_ncorr&",'"&audi_tusuario&"',getDate(),'ajuste matrícula histórica',5,NULL,NULL)"
		
			c_grupo_familiar = " insert into grupo_familiar (post_ncorr,pers_ncorr,pare_ccod,audi_tusuario,audi_fmodificacion,grup_nindependiente) "&_
							   " select "&post_ncorr&" as post_ncorr,pers_ncorr,pare_ccod,'"&audi_tusuario&"' as audi_tusuario,getDate() as audi_fmodificacion,null "&_
							   " from grupo_familiar where cast(post_ncorr as varchar)= '"&ulti_post&"'"
					
			c_codeudor_postulacion = "insert into codeudor_postulacion (post_ncorr,pers_ncorr,pare_ccod,audi_tusuario,audi_fmodificacion)"&_
									 " select "&post_ncorr&" as post_ncorr,pers_ncorr,pare_ccod,'"&audi_tusuario&"' as audi_tusuario,getDate() as audi_fmodificacion"&_
									 " from codeudor_postulacion where cast(post_ncorr as varchar) = '"&ulti_post&"'"			
		
			c_alumnos = "insert into alumnos (MATR_NCORR,EMAT_CCOD,POST_NCORR,OFER_NCORR,PERS_NCORR,PLAN_CCOD,ALUM_NMATRICULA,ALUM_FMATRICULA,AUDI_TUSUARIO,AUDI_FMODIFICACION,ETCA_CCOD,TALU_CCOD,EMAT_CCOD_PEEC,ALUM_TRABAJADOR,ESTADO_CIERRE_CCOD)"&_			
						"values ("&matr_ncorr&",4,"&post_ncorr&","&ofer_ncorr&","&pers_ncorr&","&plan_ccod&",7777,getDate(),'"&audi_tusuario&"',getDate(),2,1,Null,Null,Null)"
			
			conexion.ejecutaS c_postulacion 
			conexion.ejecutaS c_detalle_postulacion
			conexion.ejecutaS c_grupo_familiar 
			conexion.ejecutaS c_codeudor_postulacion 
			conexion.ejecutaS c_alumnos
		else
			matr_ncorr = conexion.consultaUno("select matr_ncorr from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and c.carr_ccod='"&carr_ccod&"' and cast(b.peri_ccod as varchar)='"&periodo_egreso&"' and a.emat_ccod=1")
			c_update = "update alumnos set emat_ccod=4, audi_tusuario='"&audi_tusuario&"',audi_fmodificacion=getDate() where cast(matr_ncorr as varchar)='"&matr_ncorr&"' "
	        conexion.ejecutaS c_update
			'response.Write(c_update)	
		end if'fin del if por si tiene matrícula
	end if
'//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
end if

'response.Write(c_insert)
'response.End()
'conexion.estadoTransaccion false
nombre_empresa=request.Form("egreso[0][nombre_empresa]")
tsca_ccod = conexion.consultaUno("select tsca_ccod from salidas_carrera where cast(saca_ncorr as varchar)='"&saca_ncorr&"'")
if not EsVacio(nombre_empresa) or not EsVacio(fecha_egreso)  then 
	set f_practica = new CFormulario
	f_practica.Carga_Parametros "adm_salidas_alumnos.xml", "detalle_datos_practica"
	f_practica.Inicializar conexion
	f_practica.ProcesaForm
	
	f_practica.AgregaCampoFilaPost 0, "concepto_practica", f_practica.ObtenerValorPost(0, "sitf_ccod")
	f_practica.AgregaCampoFilaPost 0, "carr_ccod", carr_ccod
	if tsca_ccod = "4" then
		f_practica.AgregaCampoFilaPost 0, "plan_ccod", saca_ncorr
	end if
	
	if EsVacio(fecha_egreso) then
		f_practica.AgregaCampoFilaPost 0, "asca_nregistro", null
		f_practica.AgregaCampoFilaPost 0, "asca_nfolio", null
	end if
	
	if not EsVacio(mall_ccod) then
		f_practica.AgregaCampoFilaPost 0, "mall_ccod", mall_ccod
	end if
	
	'if EsVacio(request.Form("egreso[0][fecha_cae]")) then
	'	f_practica.AgregaCampoFilaPost 0, "fecha_cae", null
	'end if
	
	if EsVacio(request.Form("egreso[0][observaciones_cae]")) then
		f_practica.AgregaCampoFilaPost 0, "observaciones_cae", ""
	end if
	
	f_practica.MantieneTablas false				
	
end if

'tsca_ccod = conexion.consultaUno("select tsca_ccod from salidas_carrera where cast(saca_ncorr as varchar)='"&saca_ncorr&"'")
if tsca_ccod="4" then
	ya_egresado = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end from ALUMNOS_SALIDAS_INTERMEDIAS where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(saca_ncorr as varchar)='"&saca_ncorr&"' and emat_ccod = 4 ")
	if ya_egresado = "NO" then
		fecha_tt = request.Form("egreso[0][fecha_egreso]")
		mes = conexion.consultaUno("select datepart(month,convert(datetime,'"&fecha_tt&"',103))")
		if cint(mes) = 1 then
			plec_a_asignar = 1
			ano_a_asignar = conexion.consultaUno("select datepart(year,convert(datetime,'"&fecha_tt&"',103))")
		elseif cint(mes) > 1 and cint(mes) <= 7 then
			plec_a_asignar = 2
			ano_a_asignar = conexion.consultaUno("select datepart(year,convert(datetime,'"&fecha_tt&"',103))")
		elseif cint(mes) > 7 then
			plec_a_asignar = 1
			ano_a_asignar = conexion.consultaUno("select datepart(year,convert(datetime,'"&fecha_tt&"',103)) + 1 ")
		end if
        'response.Write("<hr>"&mes)
		'response.Write("<hr>"&ano_a_asignar)
		periodo_grabar = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&ano_a_asignar&"' and cast(plec_ccod as varchar)='"&plec_a_asignar&"'")
		asin_ncorr = conexion.consultaUno("select isnull(max(asin_ncorr),0) + 1 from ALUMNOS_SALIDAS_INTERMEDIAS ")
	    'response.Write("<hr>select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&ano_a_asignar&"' and cast(plec_ccod as varchar)='"&plec_a_asignar&"'")
		c_inserta = " insert into ALUMNOS_SALIDAS_INTERMEDIAS (ASIN_NCORR,PERS_NCORR,SACA_NCORR,PERI_CCOD,EMAT_CCOD,FECHA_PROCESO,AUDI_TUSUARIO,AUDI_FMODIFICACION) "&_
					" values ("&asin_ncorr&","&pers_ncorr&","&saca_ncorr&","&periodo_grabar&",4,convert(datetime,'"&fecha_tt&"',103),'"&negocio.obtenerUsuario&"',getDate() ) "
		'response.Write(c_inserta)
		conexion.ejecutaS c_inserta
	end if
	
end if


'response.End()
if conexion.obtenerEstadoTransaccion then
		session("msjOk")="Los datos han sido grabados exitosamente"
end if
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>


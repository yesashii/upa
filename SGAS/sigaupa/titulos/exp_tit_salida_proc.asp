<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

anos_ccod_titulacion = request.Form("anos_ccod_titulacion")
plec_ccod_titulacion = request.Form("plec_ccod_titulacion")
pers_ncorr = request.Form("salida[0][pers_ncorr]")
saca_ncorr = request.Form("salida[0][saca_ncorr]")
saca_ncorr2 = request.Form("salidas[0][saca_ncorr2]")

carr_ccod = conexion.consultaUno("select carr_ccod from salidas_carrera where cast(saca_ncorr as varchar)='"&saca_ncorr&"'")
tsca_ccod = conexion.consultaUno("select tsca_ccod from salidas_carrera where cast(saca_ncorr as varchar)='"&saca_ncorr&"'")
if not EsVacio(anos_ccod_titulacion) and not EsVacio(plec_ccod_titulacion) and tsca_ccod <> "4" then 
	c_peri_ccod = "select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod_titulacion&"' "& vbCrLf &_
	              "  and cast(plec_ccod as varchar)='"&plec_ccod_titulacion&"'" 
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
	peri_ccod   = conexion.consultaUno(c_peri_ccod)
	
	tiene_matricula = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end  from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and c.carr_ccod='"&carr_ccod&"' and cast(b.peri_ccod as varchar)='"&peri_ccod&"' and a.emat_ccod=1")
	
	if not esVacio(peri_ccod) then
    	tiene_matricula = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end  from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and c.carr_ccod='"&carr_ccod&"' and cast(b.peri_ccod as varchar)='"&peri_ccod&"' and a.emat_ccod=1")
		if tiene_matricula = "NO" then
			espe_ccod   = conexion.consultaUno(c_espe_ccod)
			sede_ccod   = conexion.consultaUno(c_sede_ccod)
			jorn_ccod   = conexion.consultaUno(c_jorn_ccod)
			plan_ccod   = conexion.consultaUno(c_plan_ccod)
			ulti_post   = conexion.consultaUno(c_post_ncorr)
			audi_tusuario = "ajuste matricula "&negocio.obtenerUsuario
			c_ofer_ncorr = "select a.ofer_ncorr from ofertas_academicas a,aranceles b where a.ofer_ncorr=b.ofer_ncorr "& vbCrLf &_
						   " and cast(a.espe_ccod as varchar)='"&espe_ccod&"' and cast(a.peri_ccod as varchar)='"&peri_ccod&"' "& vbCrLf &_ 
						   " and cast(a.sede_ccod as varchar)='"&sede_ccod&"' and cast(a.jorn_ccod as varchar)='"&jorn_ccod&"' "& vbCrLf &_ 
						   " and cast(b.aran_nano_ingreso as varchar)='"&ano_ingreso&"' and isnull(aran_mmatricula,0) = 0 "
			ofer_ncorr   = conexion.consultaUno(c_ofer_ncorr)
			'En el caso de no encontrar la oferta registrada se debe grabar una nueva oferta y arancel
			if EsVacio(ofer_ncorr) then
				ofer_ncorr = conexion.consultauno("execute obtenersecuencia 'ofertas_academicas'")
				aran_ncorr = conexion.consultauno("execute obtenersecuencia 'aranceles'")
				c_oferta = "insert into ofertas_academicas (OFER_NCORR,SEDE_CCOD,PERI_CCOD,ESPE_CCOD,JORN_CCOD,POST_BNUEVO,ARAN_NCORR,OFER_NVACANTES,OFER_NQUORUM,OFER_BPAGA_EXAMEN,AUDI_TUSUARIO,AUDI_FMODIFICACION,OFER_BPUBLICA,OFER_BACTIVA)"&_
				   "values ("&ofer_ncorr&","&sede_ccod&","&peri_ccod&",'"&espe_ccod&"',"&jorn_ccod&",'N',"&aran_ncorr&",100,1,'N','"&audi_tusuario&"',getDate(),'N','N')"   
				c_aranceles = "insert into aranceles (ARAN_NCORR,MONE_CCOD,OFER_NCORR,ARAN_TDESC,ARAN_MMATRICULA,ARAN_MCOLEGIATURA,ARAN_NANO_INGRESO,AUDI_TUSUARIO,AUDI_FMODIFICACION,sede_ccod,espe_ccod,carr_ccod,peri_ccod,jorn_ccod,aran_cvigente_fup)"&_
					  "values ("&aran_ncorr&",1,"&ofer_ncorr&",'ajuste matricula histórica',0,0,"&ano_ingreso&",'"&audi_tusuario&"',getDate(),"&sede_ccod&",'"&espe_ccod&"','"&carr_ccod&"',"&peri_ccod&","&jorn_ccod&",'N')"
				conexion.ejecutaS c_oferta 
				conexion.ejecutaS c_aranceles
			end if
			post_ncorr = conexion.consultauno("execute obtenersecuencia 'postulantes'")
			matr_ncorr = conexion.consultauno("execute obtenersecuencia 'alumnos'")
			c_postulacion = " insert into postulantes (POST_NCORR,PERS_NCORR,EPOS_CCOD,TPOS_CCOD,PERI_CCOD,POST_BNUEVO,OCUP_CCOD,OFER_NCORR,POST_FPOSTULACION,TPAD_CCOD,POST_NPAA_VERBAL,POST_NPAA_MATEMATICAS,POST_NANO_PAA,IESU_CCOD,POST_TINSTITUCION_ANTERIOR,TIES_CCOD,POST_TTIPO_INSTITUCION_ANT,POST_TCARRERA_ANTERIOR,POST_NSEM_CURSADOS,POST_NSEM_APROBADOS,POST_NANO_INICIO_EST_ANT,POST_NANO_TERMINO_EST_ANT,POST_BTITULADO,POST_TTITULO_OBTENIDO,POST_BREQUIERE_EXAMEN,POST_NNOTA_EXAMEN,POST_BPASE_ESCOLAR,POST_TOTRO_COLEGIO,POST_NCORR_CODEUDOR,TBEN_CCOD1,TBEN_CCOD2,POST_BTRABAJA,POST_NINICIO,POST_BRECONOCIMIENTO_ESTUDIOS,POST_TOTRAS_ACTIVIDADES,AUDI_TUSUARIO,AUDI_FMODIFICACION,POST_BPAGA,POST_NCORRELATIVO)"&_
							" select "&post_ncorr&" as post_ncorr,pers_ncorr,2 as epos_ccod,tpos_ccod,"&peri_ccod&" as peri_ccod,'N' as post_bnuevo,ocup_ccod,"&ofer_ncorr&" as ofer_ncorr,post_fpostulacion,tpad_ccod,post_npaa_verbal,post_npaa_matematicas,post_nano_paa,iesu_ccod,"&_
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
						"values ("&matr_ncorr&",8,"&post_ncorr&","&ofer_ncorr&","&pers_ncorr&","&plan_ccod&",7777,getDate(),'"&audi_tusuario&"',getDate(),2,1,Null,Null,Null)"
			
			conexion.ejecutaS c_postulacion 
			conexion.ejecutaS c_detalle_postulacion
			conexion.ejecutaS c_grupo_familiar 
			conexion.ejecutaS c_codeudor_postulacion 
			conexion.ejecutaS c_alumnos
		else
			matr_ncorr = conexion.consultaUno("select matr_ncorr from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and c.carr_ccod='"&carr_ccod&"' and cast(b.peri_ccod as varchar)='"&peri_ccod&"' and a.emat_ccod=1")
			c_update = "update alumnos set emat_ccod=8, audi_tusuario='"&audi_tusuario&"',audi_fmodificacion=getDate() where cast(matr_ncorr as varchar)='"&matr_ncorr&"' "
	        conexion.ejecutaS c_update	
		end if ' fin del if por si tiene matrícula
	end if				  			  
end if

c_titulado =  "    select case count(*) when 0 then 'N' else 'S' end  from alumnos t1, ofertas_academicas t2, especialidades t3 "& vbCrLf &_
              "    where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod "& vbCrLf &_
              "    and cast(t1.pers_ncorr as varchar)='"&pers_ncorr&"' and t3.carr_ccod='"&carr_ccod&"' and t1.emat_ccod in (8) "
titulado = conexion.consultaUno(c_titulado)

activar = true
if (tsca_ccod="1" or tsca_ccod="3" or tsca_ccod="5" or tsca_ccod="6") and titulado="N" then
	activar=false
end if

if activar then 
	asca_ncorr=request.Form("salida[0][asca_ncorr]")
	if EsVacio(asca_ncorr) then
		asca_ncorr=conexion.consultaUno("execute obtenerSecuencia 'alumnos_salidas_carrera'")
	end if
	
	set f_salida = new CFormulario
	f_salida.Carga_Parametros "expediente_titulacion.xml", "salida"
	f_salida.Inicializar conexion
	f_salida.ProcesaForm
	f_salida.agregacampopost "asca_ncorr", asca_ncorr
	f_salida.MantieneTablas false

	'------------AGREGAMOS AHORA EN CASO QUE DESEE LA LICENCIATURA
	if saca_ncorr2 <> "" then
		asca_ncorr2 = conexion.consultaUno("select asca_ncorr from alumnos_salidas_carrera where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(saca_ncorr as varchar)='"&saca_ncorr2&"'")
		if EsVacio(asca_ncorr2) then
			asca_ncorr2 = conexion.consultaUno("execute obtenerSecuencia 'alumnos_salidas_carrera'")
		end if
		
		set f_salida = new CFormulario
		f_salida.Carga_Parametros "expediente_titulacion.xml", "salida"
		f_salida.Inicializar conexion
		f_salida.ProcesaForm
		f_salida.agregacampopost "asca_ncorr", asca_ncorr2
		f_salida.agregacampopost "saca_ncorr", saca_ncorr2
		f_salida.MantieneTablas false
	end if

end if
if tsca_ccod="4" then
	ya_titulado = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end from ALUMNOS_SALIDAS_INTERMEDIAS where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(saca_ncorr as varchar)='"&saca_ncorr&"' and emat_ccod = 8 ")
	if ya_titulado = "NO" then
		fecha_tt = request.Form("salida[0][asca_fsalida]")
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

		periodo_grabar = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&ano_a_asignar&"' and cast(plec_ccod as varchar)='"&plec_a_asignar&"'")
		asin_ncorr = conexion.consultaUno("select isnull(max(asin_ncorr),0) + 1 from ALUMNOS_SALIDAS_INTERMEDIAS ")
	
		c_inserta = " insert into ALUMNOS_SALIDAS_INTERMEDIAS (ASIN_NCORR,PERS_NCORR,SACA_NCORR,PERI_CCOD,EMAT_CCOD,FECHA_PROCESO,AUDI_TUSUARIO,AUDI_FMODIFICACION) "&_
					" values ("&asin_ncorr&","&pers_ncorr&","&saca_ncorr&","&periodo_grabar&",8,convert(datetime,'"&fecha_tt&"',103),'"&negocio.obtenerUsuario&"',getDate() ) "
		
		conexion.ejecutaS c_inserta
	end if
	
end if

response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>



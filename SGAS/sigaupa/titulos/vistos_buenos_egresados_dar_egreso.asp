<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

pers_ncorr = request.form("pers_ncorr_3")
carr_ccod = request.form("carr_ccod_3")
plan_ccod = request.form("plan_ccod_3")
fecha_proceso = request.form("fecha_proceso")
fecha_egreso = request.form("fecha_egreso")
observacion = request.form("observacion")
fe = split(fecha_egreso, "/")
dia_egreso = cint(fe(0))
mes_egreso = cint(fe(1))
ano_egreso = cint(fe(2))

if  mes_egreso = 1 then
	plec_ccod_egreso = 1
	anos_ccod_egreso = ano_egreso
elseif mes_egreso > 1 and mes_egreso <=7 then
	plec_ccod_egreso = 2
	anos_ccod_egreso = ano_egreso
elseif mes_egreso > 7 then
	plec_ccod_egreso = 1
	anos_ccod_egreso = (ano_egreso*1) + 1
end if

periodo_egreso = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod_egreso&"' and cast(plec_ccod as varchar)='"&plec_ccod_egreso&"'")
'response.Write(periodo_egreso)
'response.End()
if not EsVacio(fecha_egreso) and not EsVacio(anos_ccod_egreso) then
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
					  "values ("&aran_ncorr&",1,"&ofer_ncorr&",'ajuste matricula egreso',0,0,"&ano_ingreso&",'"&audi_tusuario&"',getDate(),"&sede_ccod&",'"&espe_ccod&"','"&carr_ccod&"',"&periodo_egreso&","&jorn_ccod&",'N')"
				conexion.ejecutaS c_oferta 
				conexion.ejecutaS c_aranceles
				'response.Write("<br>"&c_oferta)
				'response.Write("<br>"&c_aranceles)
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
			'response.Write("<br>"&c_postulacion)
			'response.Write("<br>"&c_detalle_postulacion)
			'response.Write("<br>"&c_grupo_familiar)
			'response.Write("<br>"&c_codeudor_postulacion)
			'response.Write("<br>"&c_alumnos)
		else
			matr_ncorr = conexion.consultaUno("select matr_ncorr from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and c.carr_ccod='"&carr_ccod&"' and cast(b.peri_ccod as varchar)='"&periodo_egreso&"' and a.emat_ccod=1")
			c_update = "update alumnos set emat_ccod=4, audi_tusuario='"&audi_tusuario&"',audi_fmodificacion=getDate() where cast(matr_ncorr as varchar)='"&matr_ncorr&"' "
	        conexion.ejecutaS c_update
			'response.Write("<br>"&c_update)	
		end if'fin del if por si tiene matrícula
	end if
'//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
end if

cegr_ncorr = conexion.consultaUno("select cegr_ncorr from CANDIDATOS_EGRESO where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_ccod&"' and carr_ccod='"&carr_ccod&"'")

c_detalle = " select distinct a.pers_ncorr,a.carr_ccod, case c.tsca_ccod when 4 then c.saca_ncorr else a.plan_ccod end as plan_ccod, "&_
			" case c.tsca_ccod when '4' then '4' else '0' end as intermedia "&_
			" from CANDIDATOS_EGRESO a, CANDIDATOS_EGRESO_DETALLE b, salidas_carrera c "&_
			" where cast(a.cegr_ncorr as varchar) = '"&cegr_ncorr&"' "&_
			" and a.cegr_ncorr = b.cegr_ncorr and b.eceg_ccod = 2 and b.saca_ncorr = c.saca_ncorr"
'response.Write("<br>"&c_detalle)
set f_salidas = new CFormulario
f_salidas.Carga_Parametros "tabla_vacia.xml", "tabla"
f_salidas.Inicializar conexion

c_sede_ccod = " select t2.sede_ccod  "& vbCrLf &_ 
  	  			  " from alumnos t1,ofertas_academicas t2, especialidades t3 "& vbCrLf &_ 
			      " where cast(t1.pers_ncorr as varchar)='"&pers_ncorr&"' and t1.ofer_ncorr=t2.ofer_ncorr  "& vbCrLf &_ 
				  " and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod='"&carr_ccod&"' and isnull(t1.emat_ccod,0) <> 9 order by peri_ccod desc "
c_jorn_ccod = " select t2.jorn_ccod  "& vbCrLf &_ 
  	  			  " from alumnos t1,ofertas_academicas t2, especialidades t3 "& vbCrLf &_ 
			      " where cast(t1.pers_ncorr as varchar)='"&pers_ncorr&"' and t1.ofer_ncorr=t2.ofer_ncorr  "& vbCrLf &_ 
				  " and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod='"&carr_ccod&"' and isnull(t1.emat_ccod,0) <> 9 order by peri_ccod desc "
sede_ccod   = conexion.consultaUno(c_sede_ccod)
jorn_ccod   = conexion.consultaUno(c_jorn_ccod)
total_grabado = 0

f_salidas.Consultar c_detalle
while f_salidas.siguiente
     pers = f_salidas.obtenerValor("pers_ncorr")
	 carr = f_salidas.obtenerValor("carr_ccod")
	 plan = f_salidas.obtenerValor("plan_ccod")
	 inte = f_salidas.obtenerValor("intermedia")
     grabado = conexion.consultaUno("Select count(*) from detalles_titulacion_carrera where cast(pers_ncorr as varchar)='"&pers&"' and carr_ccod='"&carr&"' and cast(plan_ccod as varchar)='"&plan&"'")
     if grabado = "0" then
	   c_insert = " insert into detalles_titulacion_carrera (pers_ncorr,carr_ccod,plan_ccod,fecha_egreso,fecha_proceso,observaciones) "&_
	              " values ("&pers&",'"&carr&"',"&plan&",convert(datetime,'"&fecha_egreso&"',103),convert(datetime,'"&fecha_proceso&"',103),'"&observacion&"')"
	   conexion.ejecutaS c_insert
	   'response.Write("<br>"&c_insert)
	   total_grabado = total_grabado + 1
	 end if
	 
	 if inte="4" then
	   grabado_si = conexion.consultaUno("select count(*) from ALUMNOS_SALIDAS_INTERMEDIAS where cast(pers_ncorr as varchar)='"&pers&"' and cast(saca_ncorr as varchar)='"&plan&"' and emat_ccod=4")
	   if grabado_si = "0" then
	      asin_ncorr = conexion.consultauno("select max(asin_ncorr)+1 from ALUMNOS_SALIDAS_INTERMEDIAS")
		  c_insert = " insert into ALUMNOS_SALIDAS_INTERMEDIAS (ASIN_NCORR,PERS_NCORR,SACA_NCORR,PERI_CCOD,EMAT_CCOD,FECHA_PROCESO,AUDI_TUSUARIO,AUDI_FMODIFICACION) "&_
	              " values ("&asin_ncorr&","&pers&","&plan&","&periodo_egreso&",4,convert(datetime,'"&fecha_proceso&"',103),'"&negocio.obtenerUsuario&"', getDate())"
	      conexion.ejecutaS c_insert
		  'response.Write("<br>"&c_insert)
	   end if
	 end if
	 
wend

'Habilitar esta opción si se desea enviaf email al terminar el proceso
'if total_grabado > 0 then
'  url = "http://admision.upacifico.cl/postulacion/www/genera_egreso.php?pers_ncorr="&pers_ncorr&"&plan_ccod="&plan_ccod&"&carr_ccod="&carr_ccod&"&sede_ccod="&sede_ccod&"&jorn_ccod="&jorn_ccod
'  response.Redirect(url)
'end if			   
%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
	CerrarActualizar();
</script>

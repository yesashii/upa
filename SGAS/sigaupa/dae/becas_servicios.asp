<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut =Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
q_tdet_ccod =Request.QueryString("b[0][tdet_ccod]")
q_sede_ccod= request.QueryString("b[0][sede_ccod]")
q_anos_ccod= request.QueryString("b[0][anos_ccod]")
q_f_ini= request.QueryString("b[0][f_ini]")
q_f_fin= request.QueryString("b[0][f_fin]")
'---------------------------------------------------------------------------------------------------


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set pagina = new CPagina
pagina.Titulo = "Becas y Servicios"
'---------------------------------------------------------------------------------------------------

set botonera = new CFormulario
botonera.carga_parametros "becas_servicios.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "becas_servicios.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "becas_servicios.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

'---------------------------------------------------------------------------------------------------
set f_becas = new CFormulario
f_becas.Carga_Parametros "becas_servicios.xml", "cheques"
f_becas.Inicializar conexion
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.AgregaCampoCons "tdet_ccod",q_tdet_ccod
f_busqueda.AgregaCampoCons "sede_ccod", q_sede_ccod
f_busqueda.AgregaCampoCons "anos_ccod", q_anos_ccod
f_busqueda.AgregaCampoCons "f_ini", q_f_ini
f_busqueda.AgregaCampoCons "f_fin", q_f_fin


anio_ante=q_anos_ccod-1


if q_pers_nrut <> "" and q_pers_xdv <> "" then
	
	
  filtro1=filtro1&"and c.pers_ncorr=protic.obtener_pers_ncorr1('"&q_pers_nrut&"')"
 
                    
end if
	
 
 if q_sede_ccod <> ""  then
	

  	filtro2=filtro2&"and g.sede_ccod='"&q_sede_ccod&"'"
  					
end if

 if q_sede_ccod <> "" and q_tdet_ccod= 1237 then
	

  	filtro3=filtro3&"and d.sede_ccod='"&q_sede_ccod&"'"
  					
end if


if q_tdet_ccod <> "" and q_tdet_ccod= 1549 then
	

  	filtro2=filtro2&"and a.tdet_ccod='" &q_tdet_ccod&"'"
  					
end if
		
 
 if q_sede_ccod <> "" and q_tdet_ccod= 1549 then
	

  	filtro3=filtro3&"and d.sede_ccod='" &q_sede_ccod&"'"
  					
end if

 if q_sede_ccod <> "" and q_tdet_ccod= 1801 then
	

  	filtro3=filtro3&"and aaa.sede_ccod='" &q_sede_ccod&"'"
  					
end if

if q_pers_nrut <> "" and q_pers_xdv <> "" and q_tdet_ccod= 1801 then
	
	
  filtro8=filtro8&"and aaa.pers_ncorr=protic.obtener_pers_ncorr1('"&q_pers_nrut&"')"
 
                    
end if
 if q_f_ini <> "" and q_f_fin<> "" and q_tdet_ccod= 1224 then
	

  	filtro4=filtro4&"and convert(datetime,protic.trunc(ingr_fpago),103) between convert(datetime,'"&q_f_ini&"',103)and convert(datetime,'"&q_f_fin&"',103)"
  					
end if

 if q_f_ini <> "" and q_f_fin<> "" and q_tdet_ccod= 1801 then
	

  	filtro7=filtro7&"and convert(datetime,protic.trunc(g.ingr_fpago),103) between convert(datetime,'"&q_f_ini&"',103)and convert(datetime,'"&q_f_fin&"',103)"
  					
end if

if q_pers_nrut <> "" and q_pers_xdv <> "" and q_tdet_ccod= 1224 then
	
	
  filtro5=filtro5&"and g.pers_ncorr=protic.obtener_pers_ncorr1('"&q_pers_nrut&"')"
 
                    
end if

 if q_sede_ccod <> "" and q_tdet_ccod= 1224 then
	

  	filtro6=filtro6&"and f.sede_ccod='"&q_sede_ccod&"'"
  					
end if

if q_tdet_ccod = "" then
sql_descuentos= "select ''"

total=0			

end if
if q_tdet_ccod= 1532 then

sql_descuentos= "select  aaa.pers_ncorr,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,pers_tape_paterno,pers_tape_materno,pers_tnombre ,protic.trunc(pers_fnacimiento)as fecha_nacimiento,"& vbCrLf &_
"(cast((datepart(year,getdate()))as numeric)-cast(datepart(year,pers_fnacimiento)as numeric))as edad,"& vbCrLf &_
"(select case post_bnuevo when 'S' then 'Nuevo' else 'Antiguo' end from postulantes where post_ncorr in(select max(post_ncorr)from alumnos a,ofertas_Academicas b where a.ofer_ncorr=b.ofer_ncorr  and pers_ncorr=aaa.pers_ncorr) )as tipo,"& vbCrLf &_
"(select top 1 carr_tdesc from carreras where carr_ccod in (select carr_ccod from especialidades a,ofertas_academicas b,alumnos c where c.pers_ncorr=aaa.pers_ncorr and c.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=a.espe_ccod and b.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&q_anos_ccod&")))as carrera,"& vbCrLf &_
"(select sexo_tdesc from sexos where sexo_ccod in (select sexo_ccod from personas f where f.pers_ncorr=aaa.pers_ncorr))as sexo,"& vbCrLf &_
"(select emat_tdesc from estados_matriculas where emat_ccod in (1))as estado_academico,"& vbCrLf &_
"(select  max (protic.trunc(alum_fmatricula)) from especialidades a,ofertas_academicas b,alumnos c where c.pers_ncorr=aaa.pers_ncorr and c.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=a.espe_ccod and b.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&q_anos_ccod&"))as fecha_matricula,"& vbCrLf &_
"(select top 1 sede_tdesc from sedes where sede_ccod in (select sede_ccod from especialidades a,ofertas_academicas b,alumnos c where c.pers_ncorr=aaa.pers_ncorr and c.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=a.espe_ccod and b.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&q_anos_ccod&")))as sede,"& vbCrLf &_

"(select top 1 anos_ccod from anos where anos_ccod in(select anos_ccod from periodos_academicos where peri_ccod in (select min (b.peri_ccod) from especialidades a,ofertas_academicas b,alumnos c where c.pers_ncorr=aaa.pers_ncorr and c.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=a.espe_ccod)))as año_ingreso"& vbCrLf &_
"from(select a.pers_ncorr"& vbCrLf &_
"from alumnos a ,contratos b,ofertas_academicas c,especialidades d"& vbCrLf &_
"where a.matr_ncorr=b.matr_ncorr" & vbCrLf &_
"and b.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&q_anos_ccod&") "& vbCrLf &_
"and a.ofer_ncorr=c.ofer_ncorr"& vbCrLf &_
"and c.espe_ccod=d.espe_ccod "& vbCrLf &_
"and d.carr_ccod not in (199,224,190,192,222,229,226,191,211,223,225,198,197,212,195,228,210,227,194,196,193,40,7,820,2,5,302,303,304)"& vbCrLf &_
"and emat_ccod=1"& vbCrLf &_
"group by pers_ncorr)aaa,personas a"& vbCrLf &_
"where aaa.pers_ncorr=a.pers_ncorr"& vbCrLf &_
"order by pers_tape_paterno"

numero_total=conexion.ConsultaUno("select count(rut) from(select  aaa.pers_ncorr,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,protic.trunc(pers_fnacimiento)as fecha_nacimiento,"& vbCrLf &_
"(cast((datepart(year,getdate()))as numeric)-cast(datepart(year,pers_fnacimiento)as numeric))as edad,"& vbCrLf &_
"(select case count(matr_ncorr)when 0 then 'Nuevo' else 'Antiguo' end from alumnos a,ofertas_Academicas b where a.ofer_ncorr=b.ofer_ncorr and b.peri_ccod=208 and pers_ncorr=aaa.pers_ncorr)as tipo,"& vbCrLf &_
"(select top 1 carr_tdesc from carreras where carr_ccod in (select carr_ccod from especialidades a,ofertas_academicas b,alumnos c where c.pers_ncorr=aaa.pers_ncorr and c.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=a.espe_ccod and b.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&q_anos_ccod&")))as carrera,"& vbCrLf &_
"(select sexo_tdesc from sexos where sexo_ccod in (select sexo_ccod from personas f where f.pers_ncorr=aaa.pers_ncorr))as sexo,"& vbCrLf &_
"(select emat_tdesc from estados_matriculas where emat_ccod in (1))as estado_academico,"& vbCrLf &_
"(select  max (protic.trunc(alum_fmatricula)) from especialidades a,ofertas_academicas b,alumnos c where c.pers_ncorr=aaa.pers_ncorr and c.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=a.espe_ccod and b.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&q_anos_ccod&"))as fecha_matricula,"& vbCrLf &_
"(select top 1 sede_tdesc from sedes where sede_ccod in (select sede_ccod from especialidades a,ofertas_academicas b,alumnos c where c.pers_ncorr=aaa.pers_ncorr and c.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=a.espe_ccod and b.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&q_anos_ccod&")))as sede"& vbCrLf &_
"from(select a.pers_ncorr"& vbCrLf &_
"from alumnos a ,contratos b,ofertas_academicas c,especialidades d"& vbCrLf &_
"where a.matr_ncorr=b.matr_ncorr" & vbCrLf &_
"and b.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&q_anos_ccod&") "& vbCrLf &_
"and a.ofer_ncorr=c.ofer_ncorr"& vbCrLf &_
"and c.espe_ccod=d.espe_ccod "& vbCrLf &_
"and d.carr_ccod not in (199,224,190,192,222,229,226,191,211,223,225,198,197,212,195,228,210,227,194,196,193,40,7,820,2,5,302,303,304)"& vbCrLf &_
"and emat_ccod=1"& vbCrLf &_
"group by pers_ncorr)aaa,personas a"& vbCrLf &_
"where aaa.pers_ncorr=a.pers_ncorr)aa")

total=numero_total
end if
if q_tdet_ccod= 1224 then
  sql_descuentos="select distinct d.pers_ncorr,ltrim(rtrim(pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre)) as nombre,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,"& vbCrLf &_
"(select carr_tdesc from carreras where carr_ccod=(select carr_ccod from especialidades where espe_ccod =(select espe_ccod from ofertas_academicas where ofer_ncorr=(select max(ofer_ncorr) from alumnos where pers_ncorr=d.pers_ncorr) )))as carrera,j.JORN_TDESC as jornada,"& vbCrLf &_
"(select sede_tdesc from sedes where sede_ccod=(select sede_ccod from ofertas_academicas where ofer_ncorr=(select max(ofer_ncorr) from alumnos where pers_ncorr=d.pers_ncorr) ))as sede"& vbCrLf &_
"from detalles a,"& vbCrLf &_
"compromisos b,"& vbCrLf &_
"abonos c,"& vbCrLf &_
"ingresos d,"& vbCrLf &_
"alumnos e,"& vbCrLf &_
"ofertas_academicas f,"& vbCrLf &_
"personas g,"& vbCrLf &_
"jornadas j"& vbCrLf &_
"where tdet_ccod=1224"& vbCrLf &_
"and a.tcom_ccod=b.TCOM_CCOD"& vbCrLf &_
"and a.inst_ccod=b.inst_ccod"& vbCrLf &_
"and a.comp_ndocto=b.comp_ndocto"& vbCrLf &_
"and b.tcom_ccod=c.TCOM_CCOD"& vbCrLf &_
"and b.inst_ccod=c.inst_ccod"& vbCrLf &_
"and b.comp_ndocto=c.comp_ndocto"& vbCrLf &_
"and c.INGR_NCORR=d.INGR_NCORR"& vbCrLf &_
"and b.PERS_NCORR=e.PERS_NCORR"& vbCrLf &_
"and e.OFER_NCORR=f.OFER_NCORR"& vbCrLf &_
"and b.PERS_NCORR=g.PERS_NCORR"& vbCrLf &_
"and f.JORN_CCOD=j.JORN_CCOD"& vbCrLf &_
"and f.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&q_anos_ccod&")"& vbCrLf &_
"and protic.total_recepcionar_cuota (a.tcom_ccod,a.inst_ccod,a.comp_ndocto,1)=0 "& vbCrLf &_
 " " &filtro6&" "& vbCrLf &_
  " " &filtro5&" "& vbCrLf &_
  " " &filtro4&" "& vbCrLf &_ 
"order by nombre"

'"select distinct d.pers_ncorr,pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,"& vbCrLf &_
'"(select carr_tdesc from carreras where carr_ccod=(select carr_ccod from especialidades where espe_ccod =(select espe_ccod from ofertas_academicas where ofer_ncorr=(select max(ofer_ncorr) from alumnos where pers_ncorr=d.pers_ncorr) )))as carrera,"& vbCrLf &_
'"(select sede_tdesc from sedes where sede_ccod=(select sede_ccod from ofertas_academicas where ofer_ncorr=(select max(ofer_ncorr) from alumnos where pers_ncorr=d.pers_ncorr) ))as sede"& vbCrLf &_
'
'"from detalles a,detalle_compromisos b,compromisos c,personas d,abonos j,ingresos k,alumnos f,ofertas_academicas g"& vbCrLf &_
'"where a.tdet_ccod=1224"& vbCrLf &_
'"and a.tcom_ccod=b.tcom_ccod"& vbCrLf &_
'"and a.inst_ccod=b.inst_ccod"& vbCrLf &_
'"and a.comp_ndocto=b.comp_ndocto"& vbCrLf &_
'"and b.tcom_ccod=c.tcom_ccod"& vbCrLf &_
'"and b.inst_ccod=c.inst_ccod"& vbCrLf &_
'"and b.comp_ndocto=c.comp_ndocto"& vbCrLf &_
'"and b.tcom_ccod=j.tcom_ccod"& vbCrLf &_
'"and b.inst_ccod=j.inst_ccod"& vbCrLf &_
'"and b.comp_ndocto=j.comp_ndocto"& vbCrLf &_
'"and b.dcom_ncompromiso=j.dcom_ncompromiso"& vbCrLf &_
'"and c.ecom_ccod=1"& vbCrLf &_
'"and j.ingr_ncorr=k.ingr_ncorr"& vbCrLf &_
'"and c.pers_ncorr=d.pers_ncorr"& vbCrLf &_
'"and d.pers_ncorr=f.pers_ncorr"& vbCrLf &_
'"and g.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&q_anos_ccod&")"& vbCrLf &_
'"--and b.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&q_anos_ccod&")"& vbCrLf &_
'"and f.ofer_ncorr=g.ofer_ncorr"& vbCrLf &_
'"and emat_ccod=1"& vbCrLf &_
' " " &filtro6&" "& vbCrLf &_
'  " " &filtro1&" "& vbCrLf &_
'  " " &filtro4&" "& vbCrLf &_ 
'"and eing_ccod in (1,4)"& vbCrLf &_
'"order by nombre"





  
   numero_total=conexion.ConsultaUno("select count(*)from(select distinct d.pers_ncorr"& vbCrLf &_
									"from detalles a,"& vbCrLf &_
									"compromisos b,"& vbCrLf &_
									"abonos c,"& vbCrLf &_
									"ingresos d,"& vbCrLf &_
									"alumnos e,"& vbCrLf &_
									"ofertas_academicas f,"& vbCrLf &_
									"personas g,"& vbCrLf &_
									"jornadas j"& vbCrLf &_
									"where tdet_ccod=1224"& vbCrLf &_
									"and a.tcom_ccod=b.TCOM_CCOD"& vbCrLf &_
									"and a.inst_ccod=b.inst_ccod"& vbCrLf &_
									"and a.comp_ndocto=b.comp_ndocto"& vbCrLf &_
									"and b.tcom_ccod=c.TCOM_CCOD"& vbCrLf &_
									"and b.inst_ccod=c.inst_ccod"& vbCrLf &_
									"and b.comp_ndocto=c.comp_ndocto"& vbCrLf &_
									"and c.INGR_NCORR=d.INGR_NCORR"& vbCrLf &_
									"and b.PERS_NCORR=e.PERS_NCORR"& vbCrLf &_
									"and e.OFER_NCORR=f.OFER_NCORR"& vbCrLf &_
									"and b.PERS_NCORR=g.PERS_NCORR"& vbCrLf &_
									"and f.JORN_CCOD=j.JORN_CCOD"& vbCrLf &_
									"and f.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&q_anos_ccod&")"& vbCrLf &_
									"and protic.total_recepcionar_cuota (a.tcom_ccod,a.inst_ccod,a.comp_ndocto,1)=0 "& vbCrLf &_
									 " " &filtro6&" "& vbCrLf &_
									  " " &filtro5&" "& vbCrLf &_
									  " " &filtro4&" "& vbCrLf &_ 
									  ")aa")

total=numero_total
	end if
	if q_tdet_ccod= 1237 then
		sql_descuentos= "select  distinct cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut,"& vbCrLf &_ 
			 "c.pers_tape_paterno + ' ' + c.pers_tape_materno+ ' ' +c.pers_tnombre   as nombre , " & vbCrLf &_
			 "e.sede_tdesc as sede,h.carr_tdesc as carrera, g.jorn_tdesc as jornada ," & vbCrLf &_
			 "protic.ano_ingreso_carrera(c.pers_ncorr,f.carr_ccod) as anio_ingreso," & vbCrLf &_
			 "cast(pp.pers_nrut as varchar)+'-'+pp.pers_xdv as rut_contratante,  "& vbCrLf &_
			 "pp.pers_tnombre + ' ' + pp.pers_tape_paterno + ' ' + pp.pers_tape_materno as contratante,"& vbCrLf &_ 
			 "protic.trunc(pp.pers_fnacimiento) as fecha_nacimiento, "& vbCrLf &_
			 "protic.trunc(sses_fpostulacion) as fecha_postulacion," & vbCrLf &_
			 "protic.listado_preexistencias(a.post_ncorr,a.pers_ncorr_contratante)  as enfermedades"& vbCrLf &_
			  "from solicitud_seguro_escolaridad a, postulantes b, personas c, "& vbCrLf &_
			" ofertas_academicas d, sedes e, especialidades f, jornadas g, carreras h, "& vbCrLf &_
			 "personas pp,periodos_academicos pa" & vbCrLf &_
			 "where a.post_ncorr=b.post_ncorr and b.pers_ncorr=c.pers_ncorr and b.peri_ccod=pa.peri_ccod and cast(pa.anos_ccod as varchar)='"&q_anos_ccod&"'"& vbCrLf &_
			 "and a.ofer_ncorr=d.ofer_ncorr and d.sede_ccod=e.sede_ccod and d.espe_ccod=f.espe_ccod "& vbCrLf &_
			 "and d.jorn_ccod=g.jorn_ccod and f.carr_ccod=h.carr_ccod and a.pers_ncorr_contratante=pp.pers_ncorr and no_deseo='N'"& vbCrLf &_
			 " " &filtro1&" "& vbCrLf &_
			 " " &filtro3&" "& vbCrLf &_
			 " and b.post_ncorr in (select distinct post_ncorr from compromisos where tcom_ccod=26 and ecom_ccod=1 and pers_ncorr=b.pers_ncorr )"& vbCrLf &_
			 "order by nombre "
		
		
		numero_total=conexion.ConsultaUno("select count(rut)from(select  cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut,"& vbCrLf &_ 
			 " c.pers_tape_paterno, c.pers_tape_materno ,c.pers_tnombre , " & vbCrLf &_
			 " e.sede_tdesc as sede,h.carr_tdesc as carrera, g.jorn_tdesc as jornada ," & vbCrLf &_
			 " protic.ano_ingreso_carrera(c.pers_ncorr,f.carr_ccod) as anio_ingreso," & vbCrLf &_
			 " cast(pp.pers_nrut as varchar)+'-'+pp.pers_xdv as rut_contratante,  "& vbCrLf &_
			 " pp.pers_tnombre + ' ' + pp.pers_tape_paterno + ' ' + pp.pers_tape_materno as contratante,"& vbCrLf &_ 
			 " protic.trunc(pp.pers_fnacimiento) as fecha_nacimiento, "& vbCrLf &_
			 " protic.trunc(sses_fpostulacion) as fecha_postulacion," & vbCrLf &_
			 " protic.listado_preexistencias(a.post_ncorr,a.pers_ncorr_contratante)  as enfermedades"& vbCrLf &_
			 " from solicitud_seguro_escolaridad a, postulantes b, personas c, "& vbCrLf &_
			 " ofertas_academicas d, sedes e, especialidades f, jornadas g, carreras h, "& vbCrLf &_
			 " personas pp,periodos_academicos pa" & vbCrLf &_
			 " where a.post_ncorr=b.post_ncorr and b.pers_ncorr=c.pers_ncorr and b.peri_ccod=pa.peri_ccod and cast(pa.anos_ccod as varchar)='"&q_anos_ccod&"'"& vbCrLf &_
			 " and a.ofer_ncorr=d.ofer_ncorr and d.sede_ccod=e.sede_ccod and d.espe_ccod=f.espe_ccod "& vbCrLf &_
			 " and d.jorn_ccod=g.jorn_ccod and f.carr_ccod=h.carr_ccod and a.pers_ncorr_contratante=pp.pers_ncorr and no_deseo='N'"& vbCrLf &_
			 " and b.post_ncorr in (select distinct post_ncorr from compromisos where tcom_ccod=26 and ecom_ccod=1 and pers_ncorr=b.pers_ncorr )"& vbCrLf &_
			 " " &filtro1&" "& vbCrLf &_
			  " " &filtro3&" "& vbCrLf &_
			 " )ass")
			total=numero_total
	end if
	
	if q_tdet_ccod=1549 then

		sql_descuentos= "select a.post_ncorr, pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,carr_tdesc as carrera,(select sede_tdesc from sedes where sede_ccod=d.sede_ccod)sede"& vbCrLf &_
 				"from alumno_credito a,alumnos b,personas c,ofertas_academicas d,especialidades e,carreras f"& vbCrLf &_
				"where a.post_ncorr=b.post_ncorr"& vbCrLf &_
				"and b.pers_ncorr=c.pers_ncorr"& vbCrLf &_
				"and b.ofer_ncorr=d.ofer_ncorr"& vbCrLf &_
				"and d.espe_ccod=e.espe_ccod"& vbCrLf &_
				"and e.carr_ccod=f.carr_ccod"& vbCrLf &_
				"and d.peri_ccod in (select peri_ccod from periodos_academicos a1 where a1.anos_ccod="&q_anos_ccod&")"& vbCrLf &_
				" " &filtro2&" "& vbCrLf &_
				" " &filtro1&" "& vbCrLf &_
				" " &filtro3&" "& vbCrLf &_
				"order by carrera,nombre"
				
				'
				numero_total=conexion.ConsultaUno("select count(post_ncorr) from(select a.post_ncorr, pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,carr_tdesc as carrera,(select sede_tdesc from sedes where sede_ccod=d.sede_ccod)sede"& vbCrLf &_
 				"from alumno_credito a,alumnos b,personas c,ofertas_academicas d,especialidades e,carreras f"& vbCrLf &_
				"where a.post_ncorr=b.post_ncorr"& vbCrLf &_
				"and b.pers_ncorr=c.pers_ncorr"& vbCrLf &_
				"and b.ofer_ncorr=d.ofer_ncorr"& vbCrLf &_
				"and d.espe_ccod=e.espe_ccod"& vbCrLf &_
				"and d.peri_ccod in (select peri_ccod from periodos_academicos a1 where a1.anos_ccod="&q_anos_ccod&")"& vbCrLf &_
				" " &filtro2&" "& vbCrLf &_
				" " &filtro8&" "& vbCrLf &_
				" " &filtro3&" "& vbCrLf &_
				"and e.carr_ccod=f.carr_ccod )as bb")
				

			total=numero_total	
	end if	
if q_tdet_ccod=1801 then
	
	
 

  sql_descuentos="select pers_ncorr, pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,pers_fnacimiento,carr_tdesc as carrera,sede_tdesc as sede"& vbCrLf &_
"from (select b.pers_ncorr,pers_tape_paterno,pers_tape_materno,pers_tnombre,pers_nrut,pers_xdv,protic.trunc(pers_fnacimiento)as pers_fnacimiento,"& vbCrLf &_
"(select top 1 carr_ccod from alumnos aa, ofertas_academicas bb,especialidades cc where aa.pers_ncorr=b.pers_ncorr and aa.OFER_NCORR=bb.OFER_NCORR  and bb.ESPE_CCOD=cc.ESPE_CCOD order by matr_ncorr desc) as carr_ccod,"& vbCrLf &_
"(select top 1 sede_ccod from alumnos aa, ofertas_academicas bb where aa.pers_ncorr=b.pers_ncorr and aa.OFER_NCORR=bb.OFER_NCORR  order by matr_ncorr desc) as sede_ccod"& vbCrLf &_
"--protic.trunc(max(g.ingr_fpago)) as fecha_pago "& vbCrLf &_
" --b.pers_ncorr,protic.obtener_rut(b.pers_ncorr) as rut_alumno, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre_alumno "& vbCrLf &_
"from compromisos a"& vbCrLf &_ 
" 	join detalle_compromisos b "& vbCrLf &_    
" 		on a.tcom_ccod = b.tcom_ccod  "& vbCrLf &_ 
" 		and a.inst_ccod = b.inst_ccod  "& vbCrLf &_
" 		and a.comp_ndocto = b.comp_ndocto "& vbCrLf &_
" 	 join detalles c "& vbCrLf &_
" 		on c.tcom_ccod = b.tcom_ccod "& vbCrLf &_ 
" 		and c.inst_ccod = b.inst_ccod "& vbCrLf &_
" 		and c.comp_ndocto = b.comp_ndocto "& vbCrLf &_
" 	 join tipos_detalle d "& vbCrLf &_
" 		on c.tdet_ccod=d.tdet_ccod "& vbCrLf &_
" 	 join personas e "& vbCrLf &_
" 		on b.pers_ncorr=e.pers_ncorr "& vbCrLf &_
" 	 join abonos f "& vbCrLf &_
" 		on b.tcom_ccod = f.tcom_ccod "& vbCrLf &_
" 		and b.inst_ccod = f.inst_ccod "& vbCrLf &_
" 		and b.comp_ndocto = f.comp_ndocto "& vbCrLf &_
" 		and b.dcom_ncompromiso = f.dcom_ncompromiso"& vbCrLf &_ 
" 	 join ingresos g"& vbCrLf &_ 
" 		on f.ingr_ncorr=g.ingr_ncorr "& vbCrLf &_
" 		and g.eing_ccod not in (3,6) --no trae los nulos "& vbCrLf &_
" 		and g.ting_ccod in (16,34) -- trae solo los ingresados por caja"& vbCrLf &_
" where a.ecom_ccod = '1' "& vbCrLf &_
"	 and c.tdet_ccod =1801"& vbCrLf &_
  " " &filtro7&" "& vbCrLf &_
" group by b.pers_ncorr,d.tdet_tdesc,g.ingr_nfolio_referencia,pers_tape_paterno,pers_tape_materno,pers_tnombre,pers_nrut,pers_xdv,pers_fnacimiento)aaa,"& vbCrLf &_
" sedes c,carreras d"& vbCrLf &_
" where aaa.sede_ccod=c.SEDE_CCOD"& vbCrLf &_
" and aaa.carr_ccod=d.CARR_CCOD"& vbCrLf &_
 " " &filtro3&" "& vbCrLf &_
  " " &filtro8&" "& vbCrLf &_
  " group by pers_ncorr, pers_tape_paterno,pers_tape_materno,pers_tnombre ,pers_nrut ,pers_xdv ,pers_fnacimiento,carr_tdesc,sede_tdesc"& vbCrLf &_ 
" order by nombre"
' 
'"select distinct d.pers_ncorr,pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,"& vbCrLf &_
'"(select carr_tdesc from carreras where carr_ccod=(select carr_ccod from especialidades where espe_ccod =(select espe_ccod from ofertas_academicas where ofer_ncorr=(select max(ofer_ncorr) from alumnos where pers_ncorr=d.pers_ncorr) )))as carrera,"& vbCrLf &_
'"(select sede_tdesc from sedes where sede_ccod=(select sede_ccod from ofertas_academicas where ofer_ncorr=(select max(ofer_ncorr) from alumnos where pers_ncorr=d.pers_ncorr) ))as sede"& vbCrLf &_
'
'"from detalles a,detalle_compromisos b,compromisos c,personas d,abonos j,ingresos k,alumnos f,ofertas_academicas g"& vbCrLf &_
'"where a.tdet_ccod=1801"& vbCrLf &_
'"and a.tcom_ccod=b.tcom_ccod"& vbCrLf &_
'"and a.inst_ccod=b.inst_ccod"& vbCrLf &_
'"and a.comp_ndocto=b.comp_ndocto"& vbCrLf &_
'"and b.tcom_ccod=c.tcom_ccod"& vbCrLf &_
'"and b.inst_ccod=c.inst_ccod"& vbCrLf &_
'"and b.comp_ndocto=c.comp_ndocto"& vbCrLf &_
'"and b.tcom_ccod=j.tcom_ccod"& vbCrLf &_
'"and b.inst_ccod=j.inst_ccod"& vbCrLf &_
'"and b.comp_ndocto=j.comp_ndocto"& vbCrLf &_
'"and b.dcom_ncompromiso=j.dcom_ncompromiso"& vbCrLf &_
'"and c.ecom_ccod=1"& vbCrLf &_
'"and j.ingr_ncorr=k.ingr_ncorr"& vbCrLf &_
'"and c.pers_ncorr=d.pers_ncorr"& vbCrLf &_
'"and d.pers_ncorr=f.pers_ncorr"& vbCrLf &_
'"and g.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&q_anos_ccod&")"& vbCrLf &_
'"--and b.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&q_anos_ccod&")"& vbCrLf &_
'"and f.ofer_ncorr=g.ofer_ncorr"& vbCrLf &_
'"and emat_ccod=1"& vbCrLf &_
' " " &filtro3&" "& vbCrLf &_
'  " " &filtro1&" "& vbCrLf &_
'  " " &filtro4&" "& vbCrLf &_ 
'"and eing_ccod in (1,4)"& vbCrLf &_
'"order by nombre"


 'response.Write("<pre>"&sql_descuentos&"</pre>")
   
   numero_total=conexion.ConsultaUno("select count(distinct rut)from(select pers_ncorr, cast(pers_nrut as varchar)+'-'+pers_xdv as rut"& vbCrLf &_
"from (select b.pers_ncorr,pers_tape_paterno,pers_tape_materno,pers_tnombre,pers_nrut,pers_xdv,protic.trunc(pers_fnacimiento)as pers_fnacimiento,"& vbCrLf &_
"(select top 1 carr_ccod from alumnos aa, ofertas_academicas bb,especialidades cc where aa.pers_ncorr=b.pers_ncorr and aa.OFER_NCORR=bb.OFER_NCORR  and bb.ESPE_CCOD=cc.ESPE_CCOD order by matr_ncorr desc) as carr_ccod,"& vbCrLf &_
"(select top 1 sede_ccod from alumnos aa, ofertas_academicas bb where aa.pers_ncorr=b.pers_ncorr and aa.OFER_NCORR=bb.OFER_NCORR  order by matr_ncorr desc) as sede_ccod"& vbCrLf &_
"--protic.trunc(max(g.ingr_fpago)) as fecha_pago "& vbCrLf &_
" --b.pers_ncorr,protic.obtener_rut(b.pers_ncorr) as rut_alumno, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre_alumno "& vbCrLf &_
"from compromisos a"& vbCrLf &_ 
" 	join detalle_compromisos b "& vbCrLf &_    
" 		on a.tcom_ccod = b.tcom_ccod  "& vbCrLf &_ 
" 		and a.inst_ccod = b.inst_ccod  "& vbCrLf &_
" 		and a.comp_ndocto = b.comp_ndocto "& vbCrLf &_
" 	 join detalles c "& vbCrLf &_
" 		on c.tcom_ccod = b.tcom_ccod "& vbCrLf &_ 
" 		and c.inst_ccod = b.inst_ccod "& vbCrLf &_
" 		and c.comp_ndocto = b.comp_ndocto "& vbCrLf &_
" 	 join tipos_detalle d "& vbCrLf &_
" 		on c.tdet_ccod=d.tdet_ccod "& vbCrLf &_
" 	 join personas e "& vbCrLf &_
" 		on b.pers_ncorr=e.pers_ncorr "& vbCrLf &_
" 	 join abonos f "& vbCrLf &_
" 		on b.tcom_ccod = f.tcom_ccod "& vbCrLf &_
" 		and b.inst_ccod = f.inst_ccod "& vbCrLf &_
" 		and b.comp_ndocto = f.comp_ndocto "& vbCrLf &_
" 		and b.dcom_ncompromiso = f.dcom_ncompromiso"& vbCrLf &_ 
" 	 join ingresos g"& vbCrLf &_ 
" 		on f.ingr_ncorr=g.ingr_ncorr "& vbCrLf &_
" 		and g.eing_ccod not in (3,6) --no trae los nulos "& vbCrLf &_
" 		and g.ting_ccod in (16,34) -- trae solo los ingresados por caja"& vbCrLf &_
" where a.ecom_ccod = '1' "& vbCrLf &_
"	 and c.tdet_ccod =1801 "& vbCrLf &_
  " " &filtro7&" "& vbCrLf &_ 
" group by b.pers_ncorr,d.tdet_tdesc,g.ingr_nfolio_referencia,pers_tape_paterno,pers_tape_materno,pers_tnombre,pers_nrut,pers_xdv,pers_fnacimiento)aaa,"& vbCrLf &_
" sedes c,carreras d"& vbCrLf &_
" where aaa.sede_ccod=c.SEDE_CCOD"& vbCrLf &_
 " " &filtro3&" "& vbCrLf &_
  " " &filtro8&" "& vbCrLf &_


" and aaa.carr_ccod=d.CARR_CCOD)as bb")

total=numero_total
end if
	
'response.Write("<pre>"&sql_descuentos&"</pre>")

'response.Write("<pre>"&q_tdet_ccod&"</pre>")
'response.Write("<pre>"&q_sfun_ccod&"</pre>")
'response.End()

f_becas.Consultar sql_descuentos


%>

<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function valida_fecha(valor)
{
//alert("valor "+valor);
	if ((valor =='1224')||(valor=='1801'))
	{
		
		document.buscador.elements["b[0][f_ini]"].disabled=false;	
		document.buscador.elements["b[0][f_fin]"].disabled=false;	
	}
	else
	{
			
		document.buscador.elements["b[0][f_ini]"].disabled=true;
		document.buscador.elements["b[0][f_fin]"].disabled=true;
	}
	
	if (valor=='1801')
	{
		
		document.buscador.elements["b[0][anos_ccod]"].disabled=true;	
	}
	else
	{
			
		document.buscador.elements["b[0][anos_ccod]"].disabled=false;
	}
}

function al_cargar()
{
tdet='<%=q_tdet_ccod%>'
 
 if (tdet!='')
 {
 	valida_fecha(tdet)
 
 }

}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); al_cargar();" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="74%"  border="0" align="center">
                <tr>
					
					<td width="18%"><strong>Rut  :</strong></td>
					
					<td width="10%"><div align="center"><%f_busqueda.DibujaCampo("pers_nrut")%></div></td>
					<td width="4%">-</td>
					<td width="5%"><div align="center"><%f_busqueda.DibujaCampo("pers_xdv")%>
					</div></td>
					<td width="7%"><%pagina.DibujarBuscaPersonas "b[0][pers_nrut]", "b[0][pers_xdv]"%></td>
                  	<td width="42%"></div></td>
					<td width="14%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td
					></tr>
					</table>
					
					 <table width="74%"  border="0" align="center">
					<tr>
					
				  	<td width="11%"><p><strong>Beneficios/</strong>
				  	  <strong>Servicios:</strong></p></td>
				
				  	<td width="89%"><div align="left"><%f_busqueda.DibujaCampo("tdet_ccod")%></div>
				  	
				 
					 
					 

                </tr>
              </table>
			   <table width="74%"  border="0" align="center">
					<tr>
					
				  	<td width="15%"><strong>Sedes:</strong></td>
				  	<td width="85%"><div align="left"><%f_busqueda.DibujaCampo("sede_ccod")%></div>
					
                </tr>
              </table>
			  <table width="74%"  border="0" align="center">
					<tr>
					
				  	<td width="15%"><strong>Periodos Academico:</strong></td>
				  	<td width="85%"><div align="left"><%f_busqueda.DibujaCampo("anos_ccod")%></div>
					
                </tr>
              </table>
			  <table width="74%"  border="0" align="center">
					<tr>
					
				  	<td width="11%"><strong>Fechas:</strong></td>
				  	<td width="15%"><div align="left"><%f_busqueda.DibujaCampo("f_ini")%></div>
					<td width="6%"><strong> Al</strong></td>
					<td width="68%"><div align="left">
					  <%f_busqueda.DibujaCampo("f_fin")%> 
					  <strong>dd/mm/aaaa</strong> </td>
                </tr>
              </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
		  <tr>
		  <td><div align="center">
                    <br>
                    <table width="100%" border="0">
                     
                    </table>
					</tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Datos Beneficios y Servicios"%>
					
                      <table width="98%"  border="0" align="center">
					   <tr>
                             <td align="right">P&aacute;gina:
                                 <%f_becas.accesopagina%>
                             </td>
                            </tr>
                            <tr>						
                                <td align="center">
						       <%f_becas.DibujaTabla()%>
							   </td>
						  
                        </tr>
                      </table>
					   <table align="right">
					   <td >Numero Total de Alumnos: <strong><%=total%></strong></td>
					    </table>
                      <br>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><p><br> </p>
                            </td>
                        </tr>
                      </table></td>
                  </tr>
                </table>
                          <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				<%if 1=2 then%>
					<td><div align="center">
                    
					<%f_botonera.AgregaBotonParam "crear", "url", "agrega_servicios.asp"
				   f_botonera.DibujaBoton"crear"  %></div></td>
				   <%end if%>
                  <td><div align="center">
                    
					<%f_botonera.AgregaBotonParam "excel", "url", "becas_servicios_excel.asp?pers_nrut="&q_pers_nrut&"&pers_xdv="&q_pers_xdv&"&tdet_ccod="&q_tdet_ccod&"&sede_ccod="&q_sede_ccod&"&anos_ccod="&q_anos_ccod&"&f_fin="&q_f_fin&"&f_ini="&q_f_ini
				   f_botonera.DibujaBoton"excel"  %></div></td>
				  
							 
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="69%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
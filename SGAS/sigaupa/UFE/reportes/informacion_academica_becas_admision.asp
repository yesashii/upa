<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio_admision.asp" -->

<%
Server.ScriptTimeOut = 150000
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "INFORMACION ACADÉMICA Y BECAS ALUMNO"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "informacion_academica_becas.xml", "botonera"

'-----------------------------------------------------------------------
v_mes_actual	= 	Month(now())
v_ano_actual	= 	 Year(now())

sem1_actual = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&v_ano_actual&"' and plec_ccod=1")
sem2_actual = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&v_ano_actual&"' and plec_ccod=2")
sem1_anterior = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&v_ano_actual-1&"' and plec_ccod=1")
sem2_anterior = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&v_ano_actual-1&"' and plec_ccod=2")

pers_nrut  = ""
pers_xdv   = ""
if request.QueryString("busqueda[0][pers_nrut]") <> "" and request.QueryString("busqueda[0][pers_xdv]") <> "" then
	pers_nrut  = request.QueryString("busqueda[0][pers_nrut]")
	pers_xdv   = request.querystring("busqueda[0][pers_xdv]")
end if
'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "informacion_academica_becas.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '"&pers_nrut&"' as pers_nrut,'"&pers_xdv&"' as pers_xdv"

 f_busqueda.Siguiente

'---------------------------------------------------------------------------------------------------
pers_ncorr = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")
rut = conexion.consultaUno("select cast(pers_nrut as varchar) + '-' + pers_xdv from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")
nombre = conexion.consultaUno("select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")

c_ultima_carrera = " select top 1 carr_tdesc from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f, estados_matriculas g, periodos_academicos h "& vbCrLf &_
			       " where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod "& vbCrLf &_
			       " and cast(c.pers_ncorr as varchar)= '"&pers_ncorr&"' and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc "
ultima_carrera = conexion.consultaUno(c_ultima_carrera)

c_ultimo_carr_ccod = " select top 1 f.carr_ccod from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f, estados_matriculas g, periodos_academicos h "& vbCrLf &_
			         " where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod "& vbCrLf &_
			         " and cast(c.pers_ncorr as varchar)= '"&pers_ncorr&"' and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc "
ultima_carr_ccod = conexion.consultaUno(c_ultimo_carr_ccod)

c_ultimo_estado    = " select top 1 emat_tdesc from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f, estados_matriculas g, periodos_academicos h "& vbCrLf &_
			         " where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod "& vbCrLf &_
			         " and cast(c.pers_ncorr as varchar)= '"&pers_ncorr&"' and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc "
ultimo_estado      = conexion.consultaUno(c_ultimo_estado)

c_ultimo_periodo    = " select top 1 cast(anos_ccod as varchar)+'-'+cast(plec_ccod as varchar) from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f, estados_matriculas g, periodos_academicos h "& vbCrLf &_
			          " where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod "& vbCrLf &_
			          " and cast(c.pers_ncorr as varchar)= '"&pers_ncorr&"' and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc "
ultimo_periodo      = conexion.consultaUno(c_ultimo_periodo)

c_ultimo_plan    =   " select top 1 c.plan_ccod from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f, estados_matriculas g, periodos_academicos h "& vbCrLf &_
			         " where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod "& vbCrLf &_
			         " and cast(c.pers_ncorr as varchar)= '"&pers_ncorr&"' and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc "
ultimo_plan      = conexion.consultaUno(c_ultimo_plan)

duracion_carrera = conexion.consultaUno("select max(espe_nduracion) from especialidades where carr_ccod='"&ultima_carr_ccod&"'")
anos_adicionales = conexion.consultaUno("select anos_adicionales from ufe_alumnos_cae where cast(rut as varchar)='"&pers_nrut&"' and anos_ccod="&v_ano_actual&"")
arancel_solicitado = conexion.consultaUno("select isnull((select arancel_solicitado from ufe_alumnos_cae where cast(rut as varchar)='"&pers_nrut&"'  and anos_ccod="&v_ano_actual&"),0)")
arancel_solicitado = formatcurrency(arancel_solicitado,0)
rut_banco = conexion.consultaUno("select baca_tdesc from ufe_alumnos_cae ttt,ufe_bancos_cae fff where ttt.rut='"&pers_nrut&"' and ttt.anos_ccod="&v_ano_actual&" and ttt.rut_banco=fff.baca_nrut")

c_dato_promedio = ""
mensaje_aclaratorio = ""
if v_mes_actual >= 9 and v_mes_actual <= 12 then
	c_total_carga   = "   select count(*) " & vbCrLf & _
					  "   from alumnos a, ofertas_academicas b, especialidades c, cargas_academicas d,situaciones_finales e " & vbCrLf & _
					  "   where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.matr_ncorr=d.matr_ncorr " & vbCrLf & _
					  "	  and isnull(d.carg_nnota_final,0.0) > 0.0 and cast(a.pers_ncorr as varchar) = '"&pers_ncorr&"' and c.carr_ccod='"&ultima_carr_ccod&"' " & vbCrLf & _
					  "	  and d.sitf_ccod=e.sitf_ccod " & vbCrLf & _
					  "	  and cast(b.peri_ccod as varchar)='"&sem1_actual&"' "
					  
	c_total_aprobados="	  select count(*)  " & vbCrLf & _
					  "   from alumnos a, ofertas_academicas b, especialidades c, cargas_academicas d,situaciones_finales e " & vbCrLf & _
					  "   where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.matr_ncorr=d.matr_ncorr " & vbCrLf & _
					  "   and isnull(d.carg_nnota_final,0.0) > 0.0 and cast(a.pers_ncorr as varchar) = '"&pers_ncorr&"' and c.carr_ccod='"&ultima_carr_ccod&"' " & vbCrLf & _
					  "   and d.sitf_ccod=e.sitf_ccod and sitf_baprueba='S' " & vbCrLf & _
					  "   and cast(b.peri_ccod as varchar)='"&sem1_actual&"' "
	mensaje_aclaratorio = "(1er semestre del año actual)"
	semestre_carga = sem2_actual
else
	c_total_carga   = "   select count(*) " & vbCrLf & _
					  "   from alumnos a, ofertas_academicas b, especialidades c, cargas_academicas d,situaciones_finales e " & vbCrLf & _
					  "   where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.matr_ncorr=d.matr_ncorr " & vbCrLf & _
					  "   and isnull(d.carg_nnota_final,0.0) > 0.0 and cast(a.pers_ncorr as varchar) = '"&pers_ncorr&"' and c.carr_ccod='"&ultima_carr_ccod&"' " & vbCrLf & _
					  "   and d.sitf_ccod=e.sitf_ccod " & vbCrLf & _
					  "	  and cast(b.peri_ccod as varchar) in ('"&sem1_anterior&"','"&sem2_anterior&"')  " 
					  
	c_total_aprobados="	  select count(*)  " & vbCrLf & _
					  "   from alumnos a, ofertas_academicas b, especialidades c, cargas_academicas d,situaciones_finales e " & vbCrLf & _
					  "   where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.matr_ncorr=d.matr_ncorr " & vbCrLf & _
					  "   and isnull(d.carg_nnota_final,0.0) > 0.0 and cast(a.pers_ncorr as varchar) = '"&pers_ncorr&"' and c.carr_ccod='"&ultima_carr_ccod&"' " & vbCrLf & _
					  "   and d.sitf_ccod=e.sitf_ccod and sitf_baprueba='S' " & vbCrLf & _
					  "   and cast(b.peri_ccod as varchar) in ('"&sem1_anterior&"','"&sem2_anterior&"') " 
					  
	mensaje_aclaratorio = "(1er y 2do semestre del año anterior)"
	semestre_carga = sem2_actual
end if

if v_mes_actual >= 1 and v_mes_actual <= 4 then
	v_ano_actual	= v_ano_actual	- 1
END IF

total_carga       = conexion.consultaUno(c_total_carga)
total_aprobados   = conexion.consultaUno(c_total_aprobados)
if total_carga <> "0" then
	rendimiento = (cint(total_aprobados)*100) / total_carga
	rendimiento = formatnumber(rendimiento,1)
else
	rendimiento = "--"
end if
'response.Write("CTM")
if pers_nrut <> "" and pers_xdv <> "" and pers_ncorr <> "" then
    'response.Write("select protic.ano_ingreso_carrera_egresa2('"&pers_ncorr&"','"&ultima_carr_ccod&"')")
    ano_ingreso_carrera = conexion.consultaUno("select protic.ano_ingreso_carrera_egresa2('"&pers_ncorr&"','"&ultima_carr_ccod&"')")
	es_moroso  = conexion.consultaUno("select case protic.es_moroso('"&pers_ncorr&"',getDate()) when 'S' then 'SI' else 'NO' end ")
	c_nivel_base     = " select top 1 nive_ccod from malla_curricular tr " & vbCrLf & _
					   " where cast(tr.plan_ccod as varchar) = '"&ultimo_plan&"' " & vbCrLf & _
					   " and isnull(tr.mall_npermiso,0) = 0 " & vbCrLf & _
					   " and isnull(protic.estado_ramo_alumno('"&pers_ncorr&"',tr.asig_ccod,'"&ultima_carr_ccod&"',tr.plan_ccod,'"&semestre_carga&"'),'') = '' " & vbCrLf & _
					   " order by nive_ccod asc  "
	'response.Write("<pre>"&c_nivel_base&"</pre>")
	nivel_base       = conexion.consultaUno(c_nivel_base)
	
	c_nivel_superior = " select top 1 nive_ccod from malla_curricular tr " & vbCrLf & _
					   " where cast(tr.plan_ccod as varchar) = '"&ultimo_plan&"' " & vbCrLf & _
					   " and isnull(tr.mall_npermiso,0) = 0 " & vbCrLf & _
					   " and isnull(protic.estado_ramo_alumno('"&pers_ncorr&"',tr.asig_ccod,'"&ultima_carr_ccod&"',tr.plan_ccod,'"&semestre_carga&"'),'') <> '' " & vbCrLf & _
					   " order by nive_ccod desc  "
	
	nivel_superior   = conexion.consultaUno(c_nivel_superior)
	
	set datos_plan = new CFormulario
	datos_plan.Carga_Parametros "tabla_vacia.xml", "tabla"
	datos_plan.Inicializar conexion
	consulta_plan =  " select nive_ccod, ltrim(rtrim(b.asig_ccod))+' -- '+ b.asig_tdesc as asignatura, "& vbCrLf &_
					 " isnull(protic.estado_ramo_alumno("&pers_ncorr&",b.asig_ccod,'"&ultima_carr_ccod&"',a.plan_ccod,'"&semestre_carga&"'),'') as aprobado "& vbCrLf &_
					 " from malla_curricular a, asignaturas b "& vbCrLf &_
					 " where a.asig_ccod=b.asig_ccod "& vbCrLf &_
					 " and cast(a.plan_ccod as varchar)='"&ultimo_plan&"' and isnull(mall_npermiso,0) <> 1 "& vbCrLf &_
					 " order by nive_ccod "
	'response.Write("<pre>"&consulta_plan&"</pre>")
	datos_plan.Consultar consulta_plan
	datos_plan.siguiente
	nivel = datos_plan.obtenerValor("nive_ccod")
	datos_plan.primero
	
'	c_ano_cae = " select min(anos_ccod) from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f, estados_matriculas g, periodos_academicos h "& vbCrLf &_
'			    " where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod "& vbCrLf &_
'			    " and cast(c.pers_ncorr as varchar)= '"&pers_ncorr&"' and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod and d.peri_ccod=h.peri_ccod "& vbCrLf &_
'				"  and exists (select 1 from sdescuentos tt where tt.post_ncorr=c.post_ncorr and tt.ofer_ncorr=c.ofer_ncorr and stde_ccod=1402 and esde_ccod=1) "
    c_ano_cae="select anos_ccod from ufe_alumnos_cae where taca_ccod =1 and rut="&pers_nrut&"" 
	ano_cae   = conexion.consultaUno(c_ano_cae)
end if

set f_listado_becas = new CFormulario
f_listado_becas.Carga_Parametros "informacion_academica_becas.xml", "becas_descuentos" 
f_listado_becas.Inicializar conexion 

sql_becas_descuentos = 	" Select contrato,cont_ncorr, stde_ccod, stde_tdesc, bene_mmonto,mone_ccod,bene_nporcentaje_matricula,bene_nporcentaje_colegiatura,tben_ccod,max(bene_fbeneficio) as bene_fbeneficio "& vbCrLf &_
						" From ( "& vbCrLf &_
						" select isnull(b.contrato,b.cont_ncorr) as contrato,b.peri_ccod,b.cont_ncorr, e.stde_ccod, e.stde_tdesc," & vbCrLf &_
						"        isnull(c.bene_mmonto_matricula, 0) + isnull(c.bene_mmonto_colegiatura, 0) as bene_mmonto," & vbCrLf &_
						"        c.mone_ccod, c.bene_nporcentaje_matricula, c.bene_nporcentaje_colegiatura, e.tben_ccod, c.bene_fbeneficio " & vbCrLf &_
						"            from postulantes a, contratos b, beneficios c, stipos_descuentos e " & vbCrLf &_
						"            where a.post_ncorr = b.post_ncorr " & vbCrLf &_
						"              and b.cont_ncorr = c.cont_ncorr " & vbCrLf &_
						"              and c.stde_ccod = e.stde_ccod " & vbCrLf &_
						"              and e.tben_ccod <> 1 " & vbCrLf &_
						"              and b.econ_ccod = '1' " & vbCrLf &_
						"              and c.eben_ccod = '1' " & vbCrLf &_
						"              and b.econ_ccod <> 3 " & vbCrLf &_
						"              and cast(a.pers_ncorr as varchar) = '" & pers_ncorr & "'" & vbCrLf &_			
						"union " & vbCrLf &_
						"	select isnull(k.contrato,k.cont_ncorr) as contrato,k.peri_ccod, k.cont_ncorr, a.stde_ccod, b.tdet_tdesc as stde_tdesc, " & vbCrLf &_
						"		cast(isnull(a.sdes_mmatricula, 0) + isnull(a.sdes_mcolegiatura, 0) as int) as bene_mmonto, " & vbCrLf &_
						"			1 as mone_ccod,a.sdes_nporc_matricula as bene_nporcentaje_matricula,a.sdes_nporc_colegiatura as bene_nporcentaje_colegiatura, " & vbCrLf &_
						"		i.tben_ccod, cont_fcontrato as bene_fbeneficio " & vbCrLf &_
						"		from sdescuentos a,tipos_detalle b,sestados_descuentos c, " & vbCrLf &_
						"			  postulantes d,ofertas_academicas e,personas_postulante f, " & vbCrLf &_
						"			  especialidades g,carreras h,tipos_beneficios i,sedes j, contratos k " & vbCrLf &_
						"		where a.stde_ccod = b.tdet_ccod " & vbCrLf &_
						"			and a.esde_ccod = c.esde_ccod  " & vbCrLf &_
						"			and a.post_ncorr = d.post_ncorr  " & vbCrLf &_
						"			and a.ofer_ncorr = d.ofer_ncorr " & vbCrLf &_
						"			and d.ofer_ncorr = e.ofer_ncorr  " & vbCrLf &_
						"			and d.pers_ncorr = f.pers_ncorr " & vbCrLf &_
						"			and e.espe_ccod = g.espe_ccod  " & vbCrLf &_
						"			and g.carr_ccod = h.carr_ccod " & vbCrLf &_
						"			and e.sede_ccod = j.sede_ccod   " & vbCrLf &_
						"			and b.tben_ccod = i.tben_ccod  " & vbCrLf &_
						"			and d.post_ncorr= k.post_ncorr " & vbCrLf &_
						"			and k.econ_ccod <> 3 " & vbCrLf &_
						"			and a.esde_ccod=1 " & vbCrLf &_
						"			and cast(f.pers_ncorr as varchar) ='" & pers_ncorr & "'" & vbCrLf &_													
						" ) as tabla  "& vbCrLf &_
 						" group by contrato,cont_ncorr, stde_ccod, stde_tdesc, bene_mmonto,mone_ccod,bene_nporcentaje_matricula,bene_nporcentaje_colegiatura,tben_ccod"
'response.Write("<pre>"&sql_becas_descuentos&"</pre>")
f_listado_becas.Consultar sql_becas_descuentos

'-----------------------------buscamos la informacion de becas mineduc
set datos_becas_Mineduc = new CFormulario
datos_becas_Mineduc.Carga_Parametros "informacion_academica_becas.xml", "becas_mineduc" 
datos_becas_Mineduc.Inicializar conexion 
sql_becas_descuentos="select anos_ccod,d.TDET_TDESC,isnull(c.monto_bene,0)as monto_bene,c.ano_adjudicacion from  personas a, postulantes b, alumno_credito c, tipos_detalle d,periodos_academicos e" & vbCrLf &_ 
					"where a.PERS_NCORR=b.PERS_NCORR " & vbCrLf &_
					"and b.POST_NCORR=c.post_ncorr " & vbCrLf &_
					"and c.tdet_ccod=d.TDET_CCOD" & vbCrLf &_
					"and b.peri_ccod=e.PERI_CCOD" & vbCrLf &_
					"and d.TDET_CCOD in (910,1390,1446,1537,1538,1539,1912)" & vbCrLf &_
					"and cast(a.pers_ncorr as varchar) ='" & pers_ncorr & "'"

datos_becas_Mineduc.Consultar sql_becas_descuentos

'----------------------------buscamos la información de las matriculas del alumno
set datos_matriculas = new CFormulario
datos_matriculas.Carga_Parametros "informacion_academica_becas.xml", "matriculas"
datos_matriculas.Inicializar conexion
consulta_matriculas =  " select a.matr_ncorr as num_matricula, a.post_ncorr as num_pos,contrato as num_con,protic.initcap(f.peri_tdesc) as periodo,protic.initcap(g.sede_tdesc) as sede, protic.initcap(e.carr_tdesc) as carrera,case h.jorn_ccod when 1 then '(D)' else '(V)' end as jornada,cast(d.espe_ccod as varchar)+ '-->' + protic.initcap(d.espe_tdesc) as mension, "& vbCrLf &_
					   " protic.initcap(i.emat_tdesc) as estado_alumno, protic.trunc(isnull(j.cont_fcontrato,a.alum_fmatricula)) as fecha, isnull(k.econ_tdesc,'*') as estado_matricula "& vbCrLf &_   
					   " ,l.plan_tdesc as plan_estu, m.espe_ccod as espe_plan,f.anos_ccod,f.plec_ccod,isnull(j.cont_fcontrato,a.alum_fmatricula) as fecha2  "& vbCrLf &_
					   " from "& vbCrLf &_
					   " alumnos a join ofertas_academicas c "& vbCrLf &_
				       "    on a.ofer_ncorr = c.ofer_ncorr "& vbCrLf &_
					   " join especialidades d "& vbCrLf &_
				       "    on c.espe_ccod  = d.espe_ccod "& vbCrLf &_
					   " join carreras e "& vbCrLf &_
				       "    on d.carr_ccod  = e.carr_ccod "& vbCrLf &_
					   " join periodos_Academicos f "& vbCrLf &_
				       "    on c.peri_ccod  = f.peri_ccod  "& vbCrLf &_
				       " join sedes g "& vbCrLf &_
				       "    on c.sede_ccod  = g.sede_ccod "& vbCrLf &_
				       " join jornadas h "& vbCrLf &_
				       "    on c.jorn_ccod  = h.jorn_ccod  "& vbCrLf &_
					   " join estados_matriculas i "& vbCrLf &_
					   "    on a.emat_ccod  = i.emat_ccod "& vbCrLf &_
					   " left outer join contratos j "& vbCrLf &_
					   "    on a.matr_ncorr = j.matr_ncorr "& vbCrLf &_
				       " left outer join estados_contrato k "& vbCrLf &_
					   "    on j.econ_ccod = k.econ_ccod "& vbCrLf &_
					   "left outer join planes_estudio l "& vbCrLf &_
					   "    on a.plan_ccod = l.plan_ccod   "& vbCrLf &_
					   " left outer join especialidades m "& vbCrLf &_
					   "    on l.espe_ccod = m.espe_ccod " & vbCrLf &_
					   " where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' "& vbCrLf &_
					   " union  "& vbCrLf &_
 					   " select null as num_matricula, null as num_pos,null  as num_con,protic.initcap(d.peri_tdesc) as periodo,null as sede, protic.initCap(linea_1_certificado + ' ' + linea_2_certificado) as carrera,  "& vbCrLf &_
					   " null as jornada,protic.initCap(linea_1_certificado + ' ' + linea_2_certificado) as mension,   "& vbCrLf &_
					   " protic.initcap(c.emat_tdesc) as estado_alumno, protic.trunc(a.fecha_proceso) as fecha, '*' as estado_matricula   "& vbCrLf &_
					   " ,null as plan_estu, null as espe_plan,d.anos_ccod,d.plec_ccod,a.fecha_proceso as fecha2   "& vbCrLf &_
					   " from alumnos_salidas_intermedias a, salidas_carrera b,estados_matriculas c,periodos_academicos d, carreras e  "& vbCrLf &_
					   " where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.saca_ncorr=b.saca_ncorr    "& vbCrLf &_
					   " and a.emat_ccod=c.emat_ccod  and a.peri_ccod = d.peri_ccod and b.carr_ccod=e.carr_ccod "& vbCrLf &_
					   " order by anos_ccod asc,plec_ccod asc, fecha2 asc    "
'response.Write("<pre>"&consulta_matriculas&"</pre>")
datos_matriculas.Consultar consulta_matriculas




%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../../biblioteca/validadores.js"></script>

<script language="JavaScript">
function cargar()
{
  buscador.action="informacion_academica_becas_admision.asp?busqueda[0][ufco_ncorr]=" + document.buscador.elements["busqueda[0][ufco_ncorr]"].value;
  buscador.method="POST";
  buscador.submit();
}
function enviar(formulario){
            document.getElementById("texto_alerta").style.visibility="visible";
			formulario.action ="informacion_academica_becas_admision.asp";
			formulario.submit();
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../../imagenes/botones/buscar_f2.gif','../../images/bot_deshabilitar_f2.gif','../../images/agregar2_f2_p.gif','../im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../../imagenes/botones/cargar_f2.gif','../../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado2()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                            <table width="100%" border="0">
							  <tr> 
                                <td width="25%"><div align="left">Rut de alumno</div></td>
                                <td width="3%"><div align="center">:</div></td>
                                <td width="72%"><%f_busqueda.dibujaCampo("pers_nrut")%>
												- 
												<%f_busqueda.dibujaCampo("pers_xdv")%></td>
                              </tr>
							  <tr> 
                                <td colspan="3" align="left"><div  align="right" id="texto_alerta" style="visibility: hidden;"><font color="#0000FF" size="-1">Espere 
                                  un momento mientras se realiza la busqueda...</font></div></td>
                              </tr>
                            </table>
                          </div></td>
                  <td width="19%"><div align="center"><%botonera.DibujaBoton "buscar"%></div></td>
                </tr>
              </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
				  <tr>
                    <td><div align="center"> 
                            <%pagina.DibujarTituloPagina%>
                            <br>
							<br>
							<%if pers_nrut <> "" and pers_xdv <> "" and pers_ncorr <> "" then%>
							<table width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="#999999">
							  <tr>
	                             <td width="100%" bgcolor="#CCCCCC" align="center">
										<table width="98%" cellpadding="0" cellspacing="0">
											<tr>
											   <td colspan="3" align="center"><%pagina.DibujarSubtitulo "Datos Generales"%></td>
										    </tr>
											<tr>
												<td width="19%" align="left"><strong>Rut</strong></td>
												<td width="1%" align="center"><strong>:</strong></td>
												<td width="80%"><font color="#993300"><%=rut%></font></td>
											</tr>
											<tr>
												<td width="19%" align="left"><strong>Nombre</strong></td>
												<td width="1%" align="center"><strong>:</strong></td>
												<td width="80%"><font color="#993300"><%=nombre%></font></td>
											</tr>
											<tr>
												<td width="19%" align="left"><strong>Última carrera</strong></td>
												<td width="1%" align="center"><strong>:</strong></td>
												<td width="80%"><font color="#993300"><%=ultima_carrera%></font></td>
											</tr>
											<tr>
												<td width="19%" align="left"><strong>Último estado</strong></td>
												<td width="1%" align="center"><strong>:</strong></td>
												<td width="80%"><font color="#993300"><%=ultimo_estado%></font></td>
											</tr>
											<tr>
												<td width="19%" align="left"><strong>Último periodo</strong></td>
												<td width="1%" align="center"><strong>:</strong></td>
												<td width="80%"><font color="#993300"><%=ultimo_periodo%></font></td>
											</tr>
											<tr>
												<td width="19%" align="left"><strong>Año ingreso carrera</strong></td>
												<td width="1%" align="center"><strong>:</strong></td>
												<td width="80%"><font color="#993300"><%=ano_ingreso_carrera%></font></td>
											</tr>
											<tr>
												<td width="19%" align="left"><strong>Año obtención CAE</strong></td>
												<td width="1%" align="center"><strong>:</strong></td>
												<td width="80%"><font color="#993300"><%=ano_cae%></font></td>
											</tr>
											<tr>
												<td width="19%" align="left"><strong>Nivel estudio actual</strong></td>
												<td width="1%" align="center"><strong>:</strong></td>
												<td width="80%"><font color="#993300"><%=nivel_base%></font></td>
											</tr>
											<tr>
												<td width="19%" align="left"><strong>Nivel estudio avance</strong></td>
												<td width="1%" align="center"><strong>:</strong></td>
												<td width="80%"><font color="#993300"><%=nivel_superior%></font></td>
											</tr>
											<tr>
												<td width="19%" align="left"><strong>Total carga</strong></td>
												<td width="1%" align="center"><strong>:</strong></td>
												<td width="80%"><font color="#993300"><%=total_carga%>&nbsp;<%=mensaje_aclaratorio%></font></td>
											</tr>
											<tr>
												<td width="19%" align="left"><strong>Total aprobados</strong></td>
												<td width="1%" align="center"><strong>:</strong></td>
												<td width="80%"><font color="#993300"><%=total_aprobados%></font></td>
											</tr>
											<tr>
												<td width="19%" align="left"><strong>Rendimiento</strong></td>
												<td width="1%" align="center"><strong>:</strong></td>
												<td width="80%"><font color="#993300"><%=rendimiento%>%</font></td>
											</tr>
											<tr>
												<td width="19%" align="left"><strong>Es Moroso</strong></td>
												<td width="1%" align="center"><strong>:</strong></td>
												<td width="80%"><font color="#993300"><%=es_moroso%></font></td>
											</tr>
											<tr>
												<td width="19%" align="left"><strong>Duración Carrera</strong></td>
												<td width="1%" align="center"><strong>:</strong></td>
												<td width="80%"><font color="#993300"><%=duracion_carrera%>&nbsp;Semestres</font></td>
											</tr>
											<tr>
												<td width="19%" align="left"><strong>Años adicionales</strong></td>
												<td width="1%" align="center"><strong>:</strong></td>
												<td width="80%"><font color="#993300"><%=anos_adicionales%></font></td>
											</tr>
											<tr>
												<td width="19%" align="left"><strong>Arancel Solicitado</strong></td>
												<td width="1%" align="center"><strong>:</strong></td>
												<td width="80%"><font color="#993300"><%=arancel_solicitado%>.-</font></td>
											</tr>
											<tr>
												<td width="19%" align="left"><strong>Banco</strong></td>
												<td width="1%" align="center"><strong>:</strong></td>
												<td width="80%"><font color="#993300"><%=rut_banco%></font></td>
											</tr>
											<tr>
												<td colspan="3">&nbsp;</td>
											</tr>
										</table>
								 </td>						  
							  </tr>
							</table>
							<br>
							<table width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="#999999">
							  <tr>
	                             <td width="100%" bgcolor="#CCCCCC" align="center">
								    <table width="98%" border="0">
									  <tr>
									     <td align="center"><%pagina.DibujarSubtitulo "Becas y Descuentos"%></td>
									  </tr>
									  <tr> 
										<td align="right"><div align="right">P&aacute;ginas: &nbsp; <%f_listado_becas.AccesoPagina%></div></td>
									  </tr>
									  <tr> 
										<td align="center"><%f_listado_becas.DibujaTabla()%></td>
									  </tr>
									  <tr>
									     <td align="center">&nbsp;</td>
									  </tr>
									</table>                          
								</td>
							  </tr>
							</table>
						   <br>
							<table width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="#999999">
							  <tr>
	                             <td width="100%" bgcolor="#CCCCCC" align="center">
								    <table width="98%" border="0">
									  <tr>
									     <td align="center"><%pagina.DibujarSubtitulo "Becas Mineduc"%></td>
									  </tr>
									  <tr> 
										<td align="right"><div align="right">&nbsp;</td>
									  </tr>
									  <tr> 
										<td align="center"><%datos_becas_Mineduc.DibujaTabla()%></td>
									  </tr>
									  <tr>
									     <td align="center">&nbsp;</td>
									  </tr>
									</table>                          
								</td>
							  </tr>
							</table>
						   <br>
						    <br>
							<table width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="#999999">
							  <tr>
	                             <td width="100%" bgcolor="#CCCCCC" align="center">
								    <table width="98%" border="0">
									  <tr>
									     <td align="center"><%pagina.DibujarSubtitulo "Resumen de matrículas"%></td>
									  </tr>
									  <tr> 
										<td align="right"><div align="right">&nbsp;</td>
									  </tr>
									  <tr> 
										<td align="center"><%datos_matriculas.DibujaTabla()%></td>
									  </tr>
									  <tr>
									     <td align="center">&nbsp;</td>
									  </tr>
									</table>                          
								</td>
							  </tr>
							</table>
						   <br>
						   <table width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="#999999">
							  <tr>
	                             <td width="100%" bgcolor="#CCCCCC" align="center">
								    <table width="98%" cellpadding="0" cellspacing="0">
										<tr>
											<td width="100%"><%pagina.DibujarSubtitulo "Avance Curricular"%></td>
										</tr>
										<tr>
											<td width="100%" align="center">
											<table align="center" class=v1 width='98%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD'>
											   <tr bgcolor='#C4D7FF' bordercolor='#999999'>
													<th colspan="3"><font color='#333333'>NIVEL <%=nivel%></font></th>
											   </tr>
											   <tr bgcolor='#C4D7FF' bordercolor='#999999'>
													<th width="10%"><font color='#333333'>Nivel</font></th>
													<th width="80%"><font color='#333333'>Asignatura</font></th>
													<th width="10%"><font color='#333333'>Estado</font></th>
											   </tr>
											   <%while datos_plan.siguiente
													nivel_actual = datos_plan.obtenerValor("nive_ccod")
													asignatura = datos_plan.obtenerValor("asignatura")
													aprobado = datos_plan.obtenerValor("aprobado")
													color = "#FFFFFF"
													if aprobado = "" then
														color= "#FFFFFF"
													elseif aprobado = "CA" then
														aprobado=periodo_mostrar
														color= "#c0ffc0"
													else
														color= "#e3eefb"
													end if
												 if cint(nivel) = cint(nivel_actual) then 	
											   %>
												<tr bgcolor="#FFFFFF">
													<td width="10%" class='noclick' align="center"><%=nivel_actual%></td>
													<td width="80%" class='noclick' align="left"><%=asignatura%></td>
													<td width="10%" class='noclick' align="center" bgcolor="<%=color%>"><%=aprobado%></td>
											   </tr>
											   <%else
												   nivel = nivel_actual
												   datos_plan.anterior%>
											  </table>
											  <br>
											  <table align="center" class=v1 width='98%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD'>
														   <tr bgcolor='#C4D7FF' bordercolor='#999999'>
																<th colspan="3"><font color='#333333'>NIVEL <%=nivel%></font></th>
														   </tr>
														   <tr bgcolor='#C4D7FF' bordercolor='#999999'>
																<th width="10%"><font color='#333333'>Nivel</font></th>
																<th width="80%"><font color='#333333'>Asignatura</font></th>
																<th width="10%"><font color='#333333'>Estado</font></th>
														   </tr>
											   <%end if%>
											   <%wend%>
											</table>
											</td>
										</tr>
										<tr>
											<td width="100%">&nbsp;</td>
										</tr>
									</table>
								    
									   
								</td>
							  </tr>
							</table>
						  <%end if%>
						</div>
					</td>
                  </tr>
                </table>
                          <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"> 
                            <% botonera.AgregaBotonParam "excel", "url", "informacion_academica_becas_excel.asp?usuario="&negocio.obtenerusuario()&""
							   botonera.AgregaBotonParam "excel","texto","Resumen CAE "
							   botonera.DibujaBoton "excel"
							%>
                          </div></td>
                          <td><div align="center"> 
                            <% botonera.AgregaBotonParam "excel", "url", "informacion_academica_becas_nocae_excel.asp?usuario="&negocio.obtenerusuario()&""
							   botonera.AgregaBotonParam "excel","texto","Resumen NO CAE "
							   botonera.DibujaBoton "excel"
							%>
                          </div></td>
                  <td>&nbsp;</td>
                  <td><div align="center"><%botonera.AgregaBotonParam "lanzadera","url","../../lanzadera/lanzadera.asp"
				  botonera.DibujaBoton "lanzadera"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="62%" rowspan="2" background="../../imagenes/abajo_r1_c4.gif"><img src="../../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>

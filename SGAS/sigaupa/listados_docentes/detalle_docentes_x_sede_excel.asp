<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=listado_docentes.xls"
Response.ContentType = "application/vnd.ms-excel"

set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

sede = request.QueryString("sede_ccod")
grado = request.QueryString("grado")
tipo_jornada = request.QueryString("tipo_jornada")
sexo = request.QueryString("sexo")
peri_ccod = request.QueryString("peri_ccod")

tituloPag = "Listado docentes "




set docentes = new cformulario
docentes.carga_parametros "tabla_vacia.xml","tabla"
docentes.inicializar conectar

'-------------------------------------------------------------------------------------------------------------------------

if sede = "2" then
	filtro_sede= " and a.sede_ccod in ('1','2')"
	con_sede = " and hdc.sede_ccod= a.sede_ccod"
elseif sede <> "" then
	filtro_sede= " and a.sede_ccod = '"&sede&"'"
	con_sede = " and hdc.sede_ccod= a.sede_ccod"
else
	filtro_sede= ""	
	con_sede = " "
end if

if tipo_jornada = 1 then
    filtro_horas = " and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"  
elseif tipo_jornada = 2 then
	filtro_horas = " and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"  
elseif tipo_jornada = 3  then
    filtro_horas = " and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"  
end if

if grado = 5 then
titulo = " Listado de docentes con grado académico Doctor"

consulta_Cantidad = " select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 1 as orden,'Completa' as jornada,   " & vbCrLf &_
                    " (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e, carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					"  and d.egra_ccod in (1,3) and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  "&filtro_horas&" " &vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&peri_ccod&"' and f.tcar_ccod = 1"&vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'" 
								
'consulta_Cantidad = " select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 1 as orden,'Completa' as jornada,   " & vbCrLf &_
'                    " (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e, carreras f,asignaturas g  " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					"  and d.egra_ccod in (1,3) and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33" &vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1"&vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'" &vbCrLf &_
'			        " union all"&vbCrLf &_
'					" select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 2 as orden, 'Media' as jornada ,  " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e, carreras f,asignaturas g  " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					"  and d.egra_ccod in (1,3) and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32" &vbCrLf &_
'					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1"&vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'" &vbCrLf &_
'			        " union all"&vbCrLf &_
'					" select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 3 as orden, 'Hora' as jornada,   " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e, carreras f,asignaturas g  " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					"  and d.egra_ccod in (1,3) and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					"  and (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19" &vbCrLf &_
'					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1"&vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'" &vbCrLf &_
'					" union all"&vbCrLf &_
'					" select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 1 as orden,'Completa' as jornada,   " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e, carreras f,asignaturas g  " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					"  and d.egra_ccod in (1,3) and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33" &vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1"&vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'" &vbCrLf &_
'			        " union all"&vbCrLf &_
'					" select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 2 as orden, 'Media' as jornada,   " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e, carreras f,asignaturas g  " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					"  and d.egra_ccod in (1,3) and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32" &vbCrLf &_
'					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1"&vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'" &vbCrLf &_
'			        " union all"&vbCrLf &_
'					" select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 3 as orden, 'Hora' as jornada,  " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e, carreras f,asignaturas g  " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					"  and d.egra_ccod in (1,3) and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					"  and (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19" &vbCrLf &_
'					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1"&vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'" &vbCrLf &_
'					" union all"&vbCrLf &_
'					" select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 1 as orden,'Completa' as jornada,   " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e, carreras f,asignaturas g  " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					"  and d.egra_ccod in (1,3) and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33" &vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1"&vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'" &vbCrLf &_
'			        " union all"&vbCrLf &_
'					" select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 2 as orden, 'Media' as jornada, " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e, carreras f,asignaturas g  " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					"  and d.egra_ccod in (1,3) and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32" &vbCrLf &_
'					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1"&vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'" &vbCrLf &_
'			        " union all"&vbCrLf &_
'					" select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 3 as orden, 'Hora' as jornada,   " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e, carreras f,asignaturas g  " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					"  and d.egra_ccod in (1,3) and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					"  and (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19" &vbCrLf &_
'					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1"&vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'" 


elseif grado = 4  then
titulo = " Listado de docentes con grado académico Magister"

consulta_Cantidad = "  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 1 as orden,'Completa' as jornada,   " & vbCrLf &_
                    " (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8)  and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					"  and d.egra_ccod = 1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  "&filtro_horas&" " &vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&peri_ccod&"' and f.tcar_ccod = 1" &vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"

'consulta_Cantidad = "  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 1 as orden,'Completa' as jornada,   " & vbCrLf &_
'                    " (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8)  and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
'					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"& vbCrLf &_
'					"  union all"& vbCrLf &_
'					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 2 as orden, 'Media' as jornada,   " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_

'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8)  and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
'					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"& vbCrLf &_
'					"  union all"& vbCrLf &_
'					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 3 as orden, 'Hora' as jornada,   " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8)  and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					"  and (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
'					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"& vbCrLf &_
'					"  union all"& vbCrLf &_
'					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 1 as orden,'Completa' as jornada,   " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8)  and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
'					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"& vbCrLf &_
'					"  union all"& vbCrLf &_
'					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 2 as orden, 'Media' as jornada,   " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8)  and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
'					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"& vbCrLf &_
'					"  union all"& vbCrLf &_
'					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 3 as orden, 'Hora' as jornada,   " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8)  and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					"  and (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
'					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"& vbCrLf &_
'					"  union all"& vbCrLf &_
'					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 1 as orden,'Completa' as jornada,   " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8)  and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
'					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"& vbCrLf &_
'					"  union all"& vbCrLf &_
'					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 2 as orden, 'Media' as jornada,   " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8)  and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
'					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"& vbCrLf &_
'					"  union all"& vbCrLf &_
'					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 3 as orden, 'Hora' as jornada,   " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_

'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8)  and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					"  and (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
'					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"

elseif grado = 3  then
titulo = " Listado de docentes con grado académico Licenciado"

consulta_Cantidad = "  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 1 as orden,'Completa' as jornada,  " & vbCrLf &_
                    " (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 3 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=4 and r.egra_ccod=1)  " & vbCrLf &_
					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  "&filtro_horas&" " &vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&peri_ccod&"' and f.tcar_ccod = 1" &vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"

'consulta_Cantidad = "  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 1 as orden,'Completa' as jornada,  " & vbCrLf &_
'                    " (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 3 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=4 and r.egra_ccod=1)  " & vbCrLf &_
'					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"&vbCrLf &_
'					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"&vbCrLf &_
'					"  union all"&vbCrLf &_
'					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 2 as orden, 'Media' as jornada,      " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 3 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=4 and r.egra_ccod=1)  " & vbCrLf &_
'					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"&vbCrLf &_
'					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"&vbCrLf &_
'					"  union all"&vbCrLf &_
'					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 3 as orden, 'Hora' as jornada,      " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 3 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=4 and r.egra_ccod=1)  " & vbCrLf &_
'					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					"  and (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"&vbCrLf &_
'					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"&vbCrLf &_
'					"  union all"&vbCrLf &_
'					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 1 as orden,'Completa' as jornada,      " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 3 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=4 and r.egra_ccod=1)  " & vbCrLf &_
'					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"&vbCrLf &_
'					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"&vbCrLf &_
'					"  union all"&vbCrLf &_
'					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 2 as orden, 'Media' as jornada,      " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 3 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=4 and r.egra_ccod=1)  " & vbCrLf &_
'					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"&vbCrLf &_
'					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"&vbCrLf &_
'					"  union all"&vbCrLf &_
'					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 3 as orden, 'Hora' as jornada,      " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 3 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=4 and r.egra_ccod=1)  " & vbCrLf &_
'					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					"  and (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"&vbCrLf &_
'					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"&vbCrLf &_
'					"  union all"&vbCrLf &_
'					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 1 as orden,'Completa' as jornada,      " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 3 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=4 and r.egra_ccod=1)  " & vbCrLf &_
'					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"&vbCrLf &_
'					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"&vbCrLf &_
'					"  union all"&vbCrLf &_
'					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 2 as orden, 'Media' as jornada,      " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 3 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=4 and r.egra_ccod=1)  " & vbCrLf &_
'					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"&vbCrLf &_
'					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"&vbCrLf &_
'					"  union all"&vbCrLf &_
'					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 3 as orden, 'Hora' as jornada,      " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 3 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=4 and r.egra_ccod=1)  " & vbCrLf &_
'					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					"  and (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"&vbCrLf &_
'					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
'					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"


elseif grado = 2  then
titulo = " Listado de docentes con título Profesional"

consulta_Cantidad = " select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 1 as orden,'Completa' as jornada,        " & vbCrLf &_
					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
					"  from (  " & vbCrLf &_
					"  select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod  " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  "&filtro_horas&" " &vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&peri_ccod&"' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
					" union all  " & vbCrLf &_
					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g  " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					" and d.grac_ccod = 2  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  "&filtro_horas&" " &vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&peri_ccod&"' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"')a, personas b where a.pers_ncorr=b.pers_ncorr "

'consulta_Cantidad = " select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 1 as orden,'Completa' as jornada,        " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from (  " & vbCrLf &_
'					"  select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod  " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
'					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and d.grac_ccod = 2  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"')a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
'					" union all"& vbCrLf &_
'					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 2 as orden, 'Media' as jornada,        " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from (  " & vbCrLf &_
'					"  select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod  " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
'					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and d.grac_ccod = 2  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"')a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
'					" union all"& vbCrLf &_
'					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 3 as orden, 'Hora' as jornada,        " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from (  " & vbCrLf &_
'					"  select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod  " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
'					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and d.grac_ccod = 2  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"')a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
'					" union all"& vbCrLf &_
'					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 1 as orden,'Completa' as jornada,    " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from (  " & vbCrLf &_
'					"  select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod  " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
'					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and d.grac_ccod = 2  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"')a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
'					" union all"& vbCrLf &_
'					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 2 as orden, 'Media' as jornada, " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from (  " & vbCrLf &_
'					"  select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod  " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
'					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and d.grac_ccod = 2  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"')a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
'					" union all"& vbCrLf &_
'					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 3 as orden, 'Hora' as jornada,   " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from (  " & vbCrLf &_
'					"  select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod  " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
'					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and d.grac_ccod = 2  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"')a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
'					" union all"& vbCrLf &_
'					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 1 as orden,'Completa' as jornada,   " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from (  " & vbCrLf &_
'					"  select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod  " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
'					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and d.grac_ccod = 2  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"')a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
'					" union all"& vbCrLf &_
'					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 2 as orden, 'Media' as jornada, " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from (  " & vbCrLf &_
'					"  select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod  " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
'					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and d.grac_ccod = 2  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"')a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
'					" union all"& vbCrLf &_
'					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 3 as orden, 'Hora' as jornada,  " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					"  from (  " & vbCrLf &_
'					"  select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod  " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
'					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and d.grac_ccod = 2  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"')a, personas b where a.pers_ncorr=b.pers_ncorr "
					
					

elseif grado = 1  then
titulo = " Listado de docentes con título Técnico"

consulta_Cantidad = " select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 1 as orden,'Completa' as jornada,  " & vbCrLf &_
					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
					" from (  " & vbCrLf &_
					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  "&filtro_horas&" " &vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&peri_ccod&"' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 1 )  " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
					" union all  " & vbCrLf &_
					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras  f,asignaturas g " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					" and d.grac_ccod = 1 and tpro_ccod=1   "&filtro_sede& vbCrLf &_
					"  "&filtro_horas&" " &vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&peri_ccod&"' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr "

'consulta_Cantidad = " select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 1 as orden,'Completa' as jornada,  " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					" from (  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
'					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 1 )  " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras  f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and d.grac_ccod = 1 and tpro_ccod=1   "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
'					" union all"& vbCrLf &_
					
'					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 2 as orden, 'Media' as jornada,          " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					" from (  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
'					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 1 )  " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras  f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and d.grac_ccod = 1 and tpro_ccod=1   "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
'					" union all"& vbCrLf &_
'					
'					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 3 as orden, 'Hora' as jornada,   " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					" from (  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
'					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 1 )  " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras  f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and d.grac_ccod = 1 and tpro_ccod=1   "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
'					" union all"& vbCrLf &_
'					
'					
'					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 1 as orden,'Completa' as jornada,  " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					" from (  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
'					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 1 )  " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras  f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and d.grac_ccod = 1 and tpro_ccod=1   "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
'					" union all"& vbCrLf &_
'					
'					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 2 as orden, 'Media' as jornada,    " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_'
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					" from (  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
'					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 1 )  " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras  f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and d.grac_ccod = 1 and tpro_ccod=1   "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
'					" union all"& vbCrLf &_
'					
'					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 3 as orden, 'Hora' as jornada, " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					" from (  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
'					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 1 )  " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras  f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and d.grac_ccod = 1 and tpro_ccod=1   "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
'					" union all"& vbCrLf &_
'				
'					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 1 as orden,'Completa' as jornada,    " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					" from (  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
'					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 1 )  " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras  f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and d.grac_ccod = 1 and tpro_ccod=1   "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
'					" union all"& vbCrLf &_
'					
'					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 2 as orden, 'Media' as jornada,   " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					" from (  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
'					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 1 )  " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras  f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and d.grac_ccod = 1 and tpro_ccod=1   "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
'					" union all"& vbCrLf &_
'					
'					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 3 as orden, 'Hora' as jornada,     " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					" from (  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
'					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 1 )  " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras  f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and d.grac_ccod = 1 and tpro_ccod=1   "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr " 

elseif grado = 0  then
titulo = " Listado de docentes sin grado ni título Profesional"

consulta_Cantidad = " select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 1 as orden,'Completa' as jornada,  " & vbCrLf &_
					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
					" from ( " & vbCrLf &_
					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod  " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  "&filtro_horas&" " &vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&peri_ccod&"' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
					" union all  " & vbCrLf &_
					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  "&filtro_horas&" " &vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&peri_ccod&"' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr "

'consulta_Cantidad = " select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 1 as orden,'Completa' as jornada,  " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					" from ( " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod  " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
'					" union all"& vbCrLf &_
'					
'					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 2 as orden, 'Media' as jornada,  " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					" from ( " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod  " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
'					" union all"& vbCrLf &_
'										
'					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 3 as orden, 'Hora' as jornada,  " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					" from ( " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod  " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
'					" union all"& vbCrLf &_
'					
'					
'					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 1 as orden,'Completa' as jornada,  " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					" from ( " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod  " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
'					" union all"& vbCrLf &_
'					
'					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 2 as orden, 'Media' as jornada,  " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					" from ( " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod  " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
'					" union all"& vbCrLf &_
'									
'					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 3 as orden, 'Hora' as jornada,  " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					" from ( " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod  " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
'					" union all"& vbCrLf &_
'					
'					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 1 as orden,'Completa' as jornada,  " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					" from ( " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod  " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
'					" union all"& vbCrLf &_
'					
'					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 2 as orden, 'Media' as jornada,  " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					" from ( " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod  " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
'					" union all"& vbCrLf &_
'										
'					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 3 as orden, 'Hora' as jornada,  " & vbCrLf &_
'					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
'					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
'					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
'					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
'				    "  where hdc.pers_ncorr=a.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
'					" from ( " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod  " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
'					" union all  " & vbCrLf &_
'					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
'					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g " & vbCrLf &_
'					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
'					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
'					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
'					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
'					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
'					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
'					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr "
					
end if
'--------------------------------------------------------------------------------------------------------------------------


sede_tdesc = conectar.consultaUno("select protic.initCap(sede_tdesc) from sedes where cast(sede_ccod as varchar)='"&sede&"'")
sexo_tdesc = conectar.consultaUno("select protic.initCap(sexo_tdesc) from sexos where cast(sexo_ccod as varchar)='"&sexo&"'")

if sede = "" then
sede_tdesc = " Todas las sedes"
end if

if sexo = 1 then 
	titulo = titulo & " (Hombres)"
else
	titulo = titulo & " (Mujeres)"
end if
'response.Write("<pre>"&consulta_cantidad&" order by orden,nombre</pre>")
docentes.Consultar consulta_cantidad &" order by orden,nombre"
cantidad_lista= conectar.consultaUno("select count(distinct aa.pers_ncorr) from ("&consulta_cantidad&")aa")



%>
<html>
<head>
<title>Listado docentes</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif"><%=titulo%></font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Sede</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%= sede_tdesc%> </td>
    
  </tr>
  <tr> 
    <td height="22"><strong>Genero</strong></td>
    <td colspan="3"><strong>:</strong> <%=sexo_tdesc %> </td>
  </tr>
  <tr>
    <td><strong>Fecha</strong></td>
    <td colspan="3"> <strong>:</strong> <%=Date%></td>
 </tr>
 <tr>
     <td width="10%"><strong>Total</strong></td>
	 <td colspan="3"> <strong>:</strong> <%=cantidad_lista%> Docente(s)</td>
</tr>
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="3%" bgcolor="#FFFFCC"><div align="center"><strong>N°</strong></div></td>
    <td width="15%" bgcolor="#FFFFCC"><div align="center"><strong>Rut</strong></div></td>
    <td width="35%" bgcolor="#FFFFCC"><div align="center"><strong>Nombre Persona</strong></div></td>
    <td width="20%" bgcolor="#FFFFCC"><div align="center"><strong>Periodo</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Jornada</strong></div></td>
    <td width="15%" bgColor="#FFFFCC"><div align="center"><strong>Horas Totales</strong></div></td>
	<td width="12%" bgColor="#FFFFCC"><div align="center"><strong>Horas Semanales</strong></div></td>  
  </tr>
  <% fila = 1 
     while docentes.Siguiente %>
  <tr> 
    <td><div align="left"><%=fila%></div></td>
	<td><div align="left"><%=docentes.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=docentes.ObtenerValor("nombre")%></div></td>
    <td><div align="left"><%=docentes.ObtenerValor("periodo")%></div></td>
	<td><div align="left"><%=docentes.ObtenerValor("jornada")%></div></td>
	<td><div align="center"><%=docentes.ObtenerValor("horas")%></div></td>
	<td><div align="center"><%=docentes.ObtenerValor("horas_semanales")%></div></td>
  </tr>
  <% fila = fila + 1  
  wend %>
</table>
<div align="right">* Las horas son medidas de forma cronológica &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>
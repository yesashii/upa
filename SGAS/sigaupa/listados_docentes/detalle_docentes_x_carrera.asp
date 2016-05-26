<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'response.Flush()
'for each k in request.QueryString()
'	response.Write(k&"<br>")
'next

sede = request.QueryString("sede_ccod")
carr_ccod = request.QueryString("carr_ccod")
jorn_ccod = request.QueryString("jorn_ccod")
grado = request.QueryString("grado")
tipo_jornada = request.QueryString("tipo_jornada")
sexo = request.QueryString("sexo")

if session("pagina_anterior")= "2" then
	url_anterior = "docentes_x_sede_y_grado.asp?busqueda[0][sede_ccod]="&sede
else
    url_anterior = "docentes_x_sede.asp?busqueda[0][sede_ccod]="&sede
end if

set conectar = new cConexion
conectar.inicializar "upacifico"

set negocio = new cnegocio
negocio.inicializa conectar

nombre_sede = conectar.consultauno("SELECT sede_tdesc FROM sedes WHERE cast(sede_ccod as varchar)= '" & sede & "'")
nombre_carrera = conectar.consultauno("SELECT carr_tdesc FROM carreras WHERE cast(carr_ccod as varchar)= '" & carr_ccod & "'")
nombre_jornada = conectar.consultauno("SELECT jorn_tdesc FROM jornadas WHERE cast(jorn_ccod as varchar)= '" & jorn_ccod & "'")


set pagina = new CPagina


set botonera =  new CFormulario
botonera.carga_parametros "docentes_x_sede.xml","botonera"
tituloPag = "Listado docentes "




set docentes = new cformulario
docentes.carga_parametros "docentes_x_sede.xml","lista_docentes_horas2"
docentes.inicializar conectar




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

if carr_ccod<> "" then
	filtro_sede = filtro_sede & " and a.carr_ccod ='"&carr_ccod&"'"
	con_sede = con_sede & " and hdc.carr_ccod='"&carr_ccod&"'"
else
	filtro_sede = filtro_sede & " and 1=2"
	con_sede = con_sede & " and 1=2"
end if

if jorn_ccod<> "" then
	filtro_sede = filtro_sede & " and a.jorn_ccod ='"&jorn_ccod&"'"
	con_sede = con_sede & " and hdc.jorn_ccod='"&jorn_ccod&"'"
else
	filtro_sede = filtro_sede & " and 1=2"
	con_sede = con_sede & " and 1=2"
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33" &vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1"&vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'" &vbCrLf &_
			        " union all"&vbCrLf &_
					" select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 2 as orden, 'Media' as jornada ,  " & vbCrLf &_
					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e, carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					"  and d.egra_ccod in (1,3) and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32" &vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1"&vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'" &vbCrLf &_
			        " union all"&vbCrLf &_
					" select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 3 as orden, 'Hora' as jornada,   " & vbCrLf &_
					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e, carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					"  and d.egra_ccod in (1,3) and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  and (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19" &vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1"&vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'" &vbCrLf &_
					" union all"&vbCrLf &_
					" select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 1 as orden,'Completa' as jornada,   " & vbCrLf &_
					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e, carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					"  and d.egra_ccod in (1,3) and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33" &vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1"&vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'" &vbCrLf &_
			        " union all"&vbCrLf &_
					" select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 2 as orden, 'Media' as jornada,   " & vbCrLf &_
					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e, carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					"  and d.egra_ccod in (1,3) and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32" &vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1"&vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'" &vbCrLf &_
			        " union all"&vbCrLf &_
					" select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 3 as orden, 'Hora' as jornada,  " & vbCrLf &_
					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e, carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					"  and d.egra_ccod in (1,3) and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  and (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19" &vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1"&vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'" &vbCrLf &_
					" union all"&vbCrLf &_
					" select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 1 as orden,'Completa' as jornada,   " & vbCrLf &_
					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e, carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					"  and d.egra_ccod in (1,3) and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33" &vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1"&vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'" &vbCrLf &_
			        " union all"&vbCrLf &_
					" select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 2 as orden, 'Media' as jornada, " & vbCrLf &_
					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e, carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					"  and d.egra_ccod in (1,3) and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32" &vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1"&vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'" &vbCrLf &_
			        " union all"&vbCrLf &_
					" select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 3 as orden, 'Hora' as jornada,   " & vbCrLf &_
					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e, carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					"  and d.egra_ccod in (1,3) and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  and (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19" &vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1"&vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'" 


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
					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"& vbCrLf &_
					"  union all"& vbCrLf &_
					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 2 as orden, 'Media' as jornada,   " & vbCrLf &_
					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8)  and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"& vbCrLf &_
					"  union all"& vbCrLf &_
					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 3 as orden, 'Hora' as jornada,   " & vbCrLf &_
					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8)  and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  and (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"& vbCrLf &_
					"  union all"& vbCrLf &_
					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 1 as orden,'Completa' as jornada,   " & vbCrLf &_
					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8)  and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"& vbCrLf &_
					"  union all"& vbCrLf &_
					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 2 as orden, 'Media' as jornada,   " & vbCrLf &_
					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8)  and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"& vbCrLf &_
					"  union all"& vbCrLf &_
					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 3 as orden, 'Hora' as jornada,   " & vbCrLf &_
					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8)  and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  and (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"& vbCrLf &_
					"  union all"& vbCrLf &_
					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 1 as orden,'Completa' as jornada,   " & vbCrLf &_
					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8)  and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"& vbCrLf &_
					"  union all"& vbCrLf &_
					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 2 as orden, 'Media' as jornada,   " & vbCrLf &_
					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8)  and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"& vbCrLf &_
					"  union all"& vbCrLf &_
					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 3 as orden, 'Hora' as jornada,   " & vbCrLf &_
					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) as horas_semanales	 "& vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8)  and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  and (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"

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
					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"&vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"&vbCrLf &_
					"  union all"&vbCrLf &_
					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 2 as orden, 'Media' as jornada,      " & vbCrLf &_
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
					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"&vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"&vbCrLf &_
					"  union all"&vbCrLf &_
					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 3 as orden, 'Hora' as jornada,      " & vbCrLf &_
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
					"  and (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"&vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"&vbCrLf &_
					"  union all"&vbCrLf &_
					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 1 as orden,'Completa' as jornada,      " & vbCrLf &_
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
					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"&vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"&vbCrLf &_
					"  union all"&vbCrLf &_
					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 2 as orden, 'Media' as jornada,      " & vbCrLf &_
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
					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"&vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"&vbCrLf &_
					"  union all"&vbCrLf &_
					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 3 as orden, 'Hora' as jornada,      " & vbCrLf &_
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
					"  and (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"&vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"&vbCrLf &_
					"  union all"&vbCrLf &_
					
					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 1 as orden,'Completa' as jornada,      " & vbCrLf &_
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
					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"&vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"&vbCrLf &_
					"  union all"&vbCrLf &_
					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 2 as orden, 'Media' as jornada,      " & vbCrLf &_
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
					"  and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"&vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"&vbCrLf &_
					"  union all"&vbCrLf &_
					"  select distinct c.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 3 as orden, 'Hora' as jornada,      " & vbCrLf &_
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
					"  and (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"&vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"


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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"')a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
					" union all"& vbCrLf &_
					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 2 as orden, 'Media' as jornada,        " & vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"')a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
					" union all"& vbCrLf &_
					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 3 as orden, 'Hora' as jornada,        " & vbCrLf &_
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
					" and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
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
					" and (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"')a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
					" union all"& vbCrLf &_
					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 1 as orden,'Completa' as jornada,    " & vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"')a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
					" union all"& vbCrLf &_
					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 2 as orden, 'Media' as jornada, " & vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"')a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
					" union all"& vbCrLf &_
					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 3 as orden, 'Hora' as jornada,   " & vbCrLf &_
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
					" and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
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
					" and (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"')a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
					" union all"& vbCrLf &_
					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 1 as orden,'Completa' as jornada,   " & vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"')a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
					" union all"& vbCrLf &_
					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 2 as orden, 'Media' as jornada, " & vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"')a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
					" union all"& vbCrLf &_
					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 3 as orden, 'Hora' as jornada,  " & vbCrLf &_
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
					" and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
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
					" and (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"')a, personas b where a.pers_ncorr=b.pers_ncorr "
					
					

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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
					" union all"& vbCrLf &_
					
					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 2 as orden, 'Media' as jornada,          " & vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
					" union all"& vbCrLf &_
					
					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 3 as orden, 'Hora' as jornada,   " & vbCrLf &_
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
					" and (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
					" union all"& vbCrLf &_
					
					
					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 1 as orden,'Completa' as jornada,  " & vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
					" union all"& vbCrLf &_
					
					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 2 as orden, 'Media' as jornada,    " & vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
					" union all"& vbCrLf &_
					
					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 3 as orden, 'Hora' as jornada, " & vbCrLf &_
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
					" and (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
					" union all"& vbCrLf &_
					
					
					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 1 as orden,'Completa' as jornada,    " & vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
					" union all"& vbCrLf &_
					
					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 2 as orden, 'Media' as jornada,   " & vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
					" union all"& vbCrLf &_
					
					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 3 as orden, 'Hora' as jornada,     " & vbCrLf &_
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
					" and (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr " 



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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
					" union all  " & vbCrLf &_
					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
					" union all"& vbCrLf &_
					
					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 2 as orden, 'Media' as jornada,  " & vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
					" union all  " & vbCrLf &_
					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
					" union all"& vbCrLf &_
										
					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Primer Semestre 2005' as periodo, 3 as orden, 'Hora' as jornada,  " & vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
					" union all  " & vbCrLf &_
					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='164' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
					" union all"& vbCrLf &_
					
					
					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 1 as orden,'Completa' as jornada,  " & vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
					" union all  " & vbCrLf &_
					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
					" union all"& vbCrLf &_
					
					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 2 as orden, 'Media' as jornada,  " & vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
					" union all  " & vbCrLf &_
					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
					" union all"& vbCrLf &_
										
					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Segundo Semestre 2005' as periodo, 3 as orden, 'Hora' as jornada,  " & vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
					" union all  " & vbCrLf &_
					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='200' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
					" union all"& vbCrLf &_
					
					
					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 1 as orden,'Completa' as jornada,  " & vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
					" union all  " & vbCrLf &_
					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
					" union all"& vbCrLf &_
					
					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 2 as orden, 'Media' as jornada,  " & vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
					" union all  " & vbCrLf &_
					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
					" union all"& vbCrLf &_
										
					" select distinct a.pers_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tape_paterno + ' '+ b.pers_tape_materno + ' ' + b.pers_tnombre as nombre, 'Tercer Trimestre 2005' as periodo, 3 as orden, 'Hora' as jornada,  " & vbCrLf &_
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
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
					" union all  " & vbCrLf &_
					" select distinct c.pers_ncorr,a.sede_ccod,a.peri_ccod   " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='201' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a, personas b where a.pers_ncorr=b.pers_ncorr "
					
end if
'--------------------------------------------------------------------------------------------------------------------------
'response.Write("<pre>"&consulta&"</pre>")
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

url_excel="listado_gestion_matricula_2.asp?sede="&sede&"&espe_ccod="&espe_ccod&"&epos_ccod="&epos_ccod&"&emat_ccod="&emat_ccod&"&nuevo="&nuevo

%>
<html>
<head>
<title>Listado Docentes</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function ver_resumen()
{
//alert("muestra historico de notas");
self.open('<%=url_carga%>','notas','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../__base/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
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
                <td>
                  <%pagina.dibujarSubTitulo(titulo)%>
                </td>
          </tr>
          <tr>
            <td><div align="center">
                    <p align="left">&nbsp; </p>
                    
                    <form name="edicion">
                      <div align="left">
                        <input name="url" type="hidden" value="<%=request.ServerVariables("HTTP_REFERER")%>">
                      </div>
                      <table width="98%" align="center">
					    <tr>
                          <td width="10%"><strong>Sede</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=nombre_sede%></td>
                        </tr>
						<tr>
                          <td width="10%"><strong>Carrera</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=nombre_carrera%></td>
                        </tr>
						<tr>
                          <td width="10%"><strong>Jornada</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=nombre_jornada%></td>
                        </tr>
						<tr>
                          <td width="10%"><strong>Genero</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=sexo_tdesc%></td>
                        </tr>
						<tr>
                          <td width="10%"><strong>Total</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=cantidad_lista%> Docente(s)</td>
                        </tr>
                        <tr>
                          <td align="center" colspan="3"> <div align="right">P&aacute;ginas: 
                              <%docentes.AccesoPagina()%>
                            </div></td>
                        </tr>
                        <tr> 
                          <td align="center" colspan="3">&nbsp; <%docentes.dibujatabla()%> </td>
                        </tr>
                      </table>
                    </form>
                    <br>
                    <br>
                  </div>
                </td>
              </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28">
		 <table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="10%" height="20"><div align="center">
			 
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="11%"><div align="center"> </div></td>
				  <td width="89%"> <div align="center">  <%
					                       botonera.agregabotonparam "excel", "url", "detalle_docentes_x_carrera_excel.asp?sede_ccod="&sede&"&carr_ccod="&carr_ccod&"&jorn_ccod="&jorn_ccod&"&grado="&grado&"&tipo_jornada="&tipo_jornada&"&sexo="&sexo
  									       botonera.dibujaboton "excel"
										%>
					 </div>  
                  </td>
               </tr>
              </table>
			
            </div></td>
            <td width="90%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<div align="right">* Las horas son medidas de forma cronológica &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>

<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%Server.ScriptTimeOut = 150000
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Clasificación de docentes por carreras "
'response.End()
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
session("pagina_anterior")= "1"
'------------------------------------------función para buscar la cantidad de docentes----------------------------------
Function Cantidad_docentes(sede,grado,tipo_jornada,sexo,periodo,carrera,jornada)
'-------------------------debemos buscar solo los dcentes pertenecientes a un solo grado, vale decir un doctor que tambien tiene un magister
'-----------------------------------------solo es considerado como doctor no como magister
'dependiendo del tipo de  jornada debemos buscar a los docentes cuyas horas esten dentro del criterio asignado.


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

if carrera<> "" then
	filtro_sede = filtro_sede & " and a.carr_ccod ='"&carrera&"'"
	con_sede = con_sede & " and hdc.carr_ccod='"&carrera&"'"
else
	filtro_sede = filtro_sede & " and 1=2"
	con_sede = con_sede & " and 1=2"
end if

if jornada<> "" then
	filtro_sede = filtro_sede & " and a.jorn_ccod ='"&jornada&"'"
	con_sede = con_sede & " and hdc.jorn_ccod='"&jornada&"'"
else
	filtro_sede = filtro_sede & " and 1=2"
	con_sede = con_sede & " and 1=2"
end if

if tipo_jornada = 1 then
    filtro_horas = " and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"  
elseif tipo_jornada = 2 then
	filtro_horas = " and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"  
elseif tipo_jornada = 3  then
    filtro_horas = " and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"  
end if

if grado = 5 then

consulta_Cantidad = " select count(distinct c.pers_ncorr)   " & vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e, carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					"  and d.egra_ccod in (1,3) and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" "&filtro_horas &" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&periodo&"' and f.tcar_ccod = 1"&vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'" 
Cantidad_docentes= conexion.consultaUno(consulta_cantidad)					

elseif grado = 4  then

consulta_Cantidad = " select count(distinct c.pers_ncorr)  " & vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8)  and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" "&filtro_horas &" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&periodo&"' and f.tcar_ccod = 1" &vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"
Cantidad_docentes= conexion.consultaUno(consulta_cantidad)
elseif grado = 3  then

consulta_Cantidad = " select count(distinct c.pers_ncorr)   " & vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 3 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=4 and r.egra_ccod=1)  " & vbCrLf &_
					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" "&filtro_horas&" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&periodo&"' and f.tcar_ccod = 1" &vbCrLf &_
					"  and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"'"
Cantidad_docentes= conexion.consultaUno(consulta_cantidad)

elseif grado = 2  then
consulta_Cantidad = " select count(*)  " & vbCrLf &_
					"  from (  " & vbCrLf &_
					"  select distinct c.pers_ncorr  " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" "&filtro_horas&" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&periodo&"' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
					" union all  " & vbCrLf &_
					" select distinct c.pers_ncorr   " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g  " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					" and d.grac_ccod = 2  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" "&filtro_horas&" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&periodo&"' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"')a "
Cantidad_docentes= conexion.consultaUno(consulta_cantidad)

elseif grado = 1  then

consulta_Cantidad = " select count(*)  " & vbCrLf &_
					" from (  " & vbCrLf &_
					" select distinct c.pers_ncorr   " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g  " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" "&filtro_horas&" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&periodo&"' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 1 )  " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
					" union all  " & vbCrLf &_
					" select distinct c.pers_ncorr   " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras  f,asignaturas g " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					" and d.grac_ccod = 1 and tpro_ccod=1   "&filtro_sede& vbCrLf &_
					" "&filtro_horas&" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&periodo&"' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a"
Cantidad_docentes= conexion.consultaUno(consulta_cantidad)

elseif grado = 0  then

consulta_Cantidad = " select count(*) " & vbCrLf &_
					" from ( " & vbCrLf &_
					" select distinct c.pers_ncorr  " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,personas e,carreras f,asignaturas g " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" "&filtro_horas&" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&periodo&"' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' " & vbCrLf &_
					" union all  " & vbCrLf &_
					" select distinct c.pers_ncorr   " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,personas e,carreras f,asignaturas g " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" "&filtro_horas&" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&periodo&"' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
					" and c.pers_ncorr = e.pers_ncorr and cast(e.sexo_ccod as varchar)='"&sexo&"' )a"
Cantidad_docentes= conexion.consultaUno(consulta_cantidad)

end if
End Function

'------------------------------------------------------------------------------------------------------------------------------------
'-----------------------------------Funcion para buscar el total de horas de los docentes--------------------------------------------
'------------------------------------------función para buscar la cantidad de docentes----------------------------------
Function Cantidad_horas_docentes(sede,grado,tipo_jornada,periodo,carrera,jornada)
'-------------------------debemos buscar solo los dcentes pertenecientes a un solo grado, vale decir un doctor que tambien tiene un magister
'-----------------------------------------solo es considerado como doctor no como magister
'dependiendo del tipo de  jornada debemos buscar a los docentes cuyas horas esten dentro del criterio asignado.


if sede = "2" then
	filtro_sede= " and a.sede_ccod in ('1','2')"
	campos = " c.pers_ncorr,a.sede_ccod "
	filtro_adicional = " and hdc.sede_ccod= a.sede_ccod"
elseif sede <> "" then
	filtro_sede= " and a.sede_ccod = '"&sede&"'"
	campos = " c.pers_ncorr,a.sede_ccod "
	filtro_adicional = " and hdc.sede_ccod= a.sede_ccod"
else
	filtro_sede= ""	
	campos = " c.pers_ncorr"
	filtro_adicional = " "
end if

if carrera<> "" then
	filtro_sede = filtro_sede & " and a.carr_ccod ='"&carrera&"'"
	con_sede = con_sede & " and hdc.carr_ccod='"&carrera&"'"
else
	filtro_sede = filtro_sede & " and 1=2"
	con_sede = con_sede & " and 1=2"
end if

if jornada<> "" then
	filtro_sede = filtro_sede & " and a.jorn_ccod ='"&jornada&"'"
	con_sede = con_sede & " and hdc.jorn_ccod='"&jornada&"'"
else
	filtro_sede = filtro_sede & " and 1=2"
	con_sede = con_sede & " and 1=2"
end if

if tipo_jornada = 1 then
    filtro_horas = " and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 33"  
elseif tipo_jornada = 2 then
	filtro_horas = " and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 32"  
elseif tipo_jornada = 3  then
    filtro_horas = " and  (select sum(isnull(prof_nhoras,0)) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr "&con_sede&" and hdc.peri_ccod=a.peri_ccod) <= 19"  
end if

if grado = 5 then

consulta_Cantidad = "  select cast(isnull(sum(horas * 45 / 60),0) as numeric) from (select distinct "&campos & vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					"  and d.egra_ccod in (1,3) and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" "&filtro_horas &" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&periodo&"' and f.tcar_ccod = 1 "&vbCrLf &_
					" )a, horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" "& filtro_adicional 
Cantidad_horas_docentes= conexion.consultaUno(consulta_cantidad)					

elseif grado = 4  then

consulta_Cantidad = "  select cast(isnull(sum(horas * 45 / 60),0) as numeric) from ( select distinct "&campos & vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8) and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" "&filtro_horas &" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&periodo&"' and f.tcar_ccod = 1" &vbCrLf &_
					" )a, horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" "& filtro_adicional 
					
Cantidad_horas_docentes= conexion.consultaUno(consulta_cantidad)
elseif grado = 3  then

consulta_Cantidad = "  select cast(isnull(sum(horas * 45 / 60),0) as numeric) from ( select distinct "&campos & vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 3 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=4 and r.egra_ccod=1)  " & vbCrLf &_
					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" "&filtro_horas&" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&periodo&"' and f.tcar_ccod = 1" &vbCrLf &_
					" )a, horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" "& filtro_adicional 
Cantidad_horas_docentes= conexion.consultaUno(consulta_cantidad)

elseif grado = 2  then
consulta_Cantidad = " select cast(isnull(sum(horas * 45 / 60),0) as numeric) " & vbCrLf &_
					"  from (  " & vbCrLf &_
					"  select distinct  "&campos & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,carreras f,asignaturas g  " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" "&filtro_horas&" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&periodo&"' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
					" " & vbCrLf &_
					" union all  " & vbCrLf &_
					" select distinct "&campos & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,carreras f ,asignaturas g " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					" and d.grac_ccod = 2  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" "&filtro_horas&" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&periodo&"' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" )a, horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" "& filtro_adicional
Cantidad_horas_docentes= conexion.consultaUno(consulta_cantidad)

elseif grado = 1  then

consulta_Cantidad = " select cast(isnull(sum(horas * 45 / 60),0) as numeric)  " & vbCrLf &_
					" from (  " & vbCrLf &_
					" select distinct "&campos & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,carreras f,asignaturas g  " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)  " & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" "&filtro_horas&" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&periodo&"' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 1 )  " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
					" " & vbCrLf &_
					" union all  " & vbCrLf &_
					" select distinct "&campos & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,carreras  f,asignaturas g " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					" and d.grac_ccod = 1 and tpro_ccod=1   "&filtro_sede& vbCrLf &_
					" "&filtro_horas&" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&periodo&"' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
					" )a, horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" "& filtro_adicional
Cantidad_horas_docentes= conexion.consultaUno(consulta_cantidad)

elseif grado = 0  then

consulta_Cantidad = " select cast(isnull(sum(horas * 45 / 60),0) as numeric) " & vbCrLf &_
					" from ( " & vbCrLf &_
					" select distinct "& campos & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,carreras f,asignaturas g " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" "&filtro_horas&" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&periodo&"' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
					"  " & vbCrLf &_
					" union all  " & vbCrLf &_
					" select distinct "&campos& vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,carreras f,asignaturas g " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" "&filtro_horas&" and a.carr_ccod=f.carr_ccod and cast(a.peri_ccod as varchar)='"&periodo&"' and f.tcar_ccod = 1" &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
					" )a, horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" "& filtro_adicional
Cantidad_horas_docentes= conexion.consultaUno(consulta_cantidad)

end if
End Function

'------------------------------------------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "docentes_x_sede.xml", "botonera"
sede_ccod = request.querystring("busqueda[0][sede_ccod]")
carr_ccod = request.querystring("busqueda[0][carr_ccod]")
jorn_ccod = request.querystring("busqueda[0][jorn_ccod]")
sede_tdesc = conexion.consultaUno("select protic.initcap(sede_tdesc) from sedes where cast(sede_ccod as varchar)= '"&sede_ccod&"'")
'response.Write(carr_ccod)
sede = sede_ccod
carrera = conexion.consultauno("SELECT carr_tdesc FROM carreras WHERE carr_ccod = '" & carr_ccod & "'")
'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "grados_jornada.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "Select '"&sede_ccod&"' as sede_ccod,'"&carr_ccod&"' as carr_ccod, '"&jorn_ccod&"' as jorn_ccod"
 'f_busqueda.Consultar "select ''"
 periodo= negocio.obtenerPeriodoAcademico("Planificacion")
 anos_ccod = conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
  consulta_carreras= "select distinct rtrim(ltrim(c.carr_ccod)) as carr_ccod,c.carr_tdesc,d.jorn_ccod,d.jorn_tdesc,e.sede_ccod,e.sede_tdesc"& vbCrLf &_
					" from ofertas_Academicas a, especialidades b, carreras c, jornadas d, sedes e, periodos_academicos f "& vbCrLf &_
					" where a.espe_ccod=b.espe_ccod  and a.sede_ccod=e.sede_ccod"& vbCrLf &_
				    " and b.carr_ccod=c.carr_ccod and a.jorn_ccod=d.jorn_ccod"& vbCrLf &_
					" and a.peri_ccod = f.peri_ccod and cast(f.anos_ccod as varchar)='"&anos_ccod&"' and c.tcar_ccod=1"& vbCrLf &_
				    " order by c.carr_tdesc,d.jorn_tdesc asc"
					
 f_busqueda.inicializaListaDependiente "lBusqueda", consulta_carreras
 f_busqueda.Siguiente
 
'--------------------------------listado general de docentes (datos reales)--------------------------------
 set f_reales = new CFormulario
 f_reales.Carga_Parametros "docentes_sede.xml", "f_reales"
 f_reales.Inicializar conexion
 
 if sede_ccod = "2" then
	filtro_sede= " and a.sede_ccod in ('1','2')"
 elseif sede_ccod <> "" then
	filtro_sede= " and a.sede_ccod = '"&sede_ccod&"'"
 else
	filtro_sede= ""	
 end if
 
 if carr_ccod<> "" then
	filtro_sede = filtro_sede & " and a.carr_ccod ='"&carr_ccod&"'"
 else
	filtro_sede = filtro_sede & " and 1=2"
 end if

if jorn_ccod<> "" then
	filtro_sede = filtro_sede & " and a.jorn_ccod ='"&jorn_ccod&"'"
else
	filtro_sede = filtro_sede & " and 1=2"
end if
 
 consulta2 = " select distinct  a.*, Doctor + Magister + Licenciado + Profesional + Tecnico + sin_grado_titulo as Totales	 " & vbCrLf &_
			" from (select    " & vbCrLf &_
			" (select count(distinct c.pers_ncorr)   " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,carreras e,asignaturas f  " & vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  "&filtro_sede & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			"  and d.egra_ccod in (1,3) and a.peri_ccod in (164,200,201) and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1" & vbCrLf &_
			"  ) as Doctor,   " & vbCrLf &_
			" (select count(distinct c.pers_ncorr)  " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,carreras e,asignaturas f " & vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod "&filtro_sede & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8) and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
			"  and d.egra_ccod=1 and a.peri_ccod in (164,200,201) and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1	 " & vbCrLf &_
			"  ) as Magister, " & vbCrLf &_
			" (select count(distinct c.pers_ncorr) 	 " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, carreras e,asignaturas f " & vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 "&filtro_sede & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 3 and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3)) 	 " & vbCrLf &_	
			"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=4 and r.egra_ccod=1)  " & vbCrLf &_
			"  and d.egra_ccod=1 and a.peri_ccod in (164,200,201) and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1	 " & vbCrLf &_
			"  ) as Licenciado, 	 " & vbCrLf &_
			" (select count(*)	 " & vbCrLf &_
			"  from (	 " & vbCrLf &_
			"  select distinct c.pers_ncorr  " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, carreras e,asignaturas f " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 "&filtro_sede & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
			" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 ) 	 " & vbCrLf &_
			" and a.peri_ccod in (164,200,201)	and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1 " & vbCrLf &_
			" union all	 " & vbCrLf &_
			" select distinct c.pers_ncorr 	 " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d, carreras e,asignaturas f " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 "&filtro_sede & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 	and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and d.grac_ccod = 2 and a.peri_ccod in (164,200,201)	and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1 " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr) 	 " & vbCrLf &_
			" )a ) as Profesional,	 " & vbCrLf &_
			" (select count(*)	 " & vbCrLf &_
			" from (	 " & vbCrLf &_
			" select distinct c.pers_ncorr  " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d	,carreras e,asignaturas f " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 "&filtro_sede & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)	 " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3)) 	 " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1) 	 " & vbCrLf &_
			" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 1 ) 	 " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 ) 	 " & vbCrLf &_
			" and a.peri_ccod in (164,200,201)	and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1 " & vbCrLf &_
			" union all	 " & vbCrLf &_
			" select distinct c.pers_ncorr 	 " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,carreras e, asignaturas f " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 "&filtro_sede & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and d.grac_ccod = 1 and a.peri_ccod in (164,200,201)	and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1 " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr) 	 " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 ) 	 " & vbCrLf &_
			" )a	 " & vbCrLf &_
			" ) as tecnico,	 " & vbCrLf &_
			" ( select count(*)	 " & vbCrLf &_
			" from (	 " & vbCrLf &_
			" select distinct c.pers_ncorr 	 " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,carreras e,asignaturas f	 " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 "&filtro_sede & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 	and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3)) 	 " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1) 	 " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) ) 	 " & vbCrLf &_
			" and a.peri_ccod in (164,200,201)	and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1 " & vbCrLf &_
			" union all	 " & vbCrLf &_
			" select distinct c.pers_ncorr 	 " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d, carreras e,asignaturas f	 " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 "&filtro_sede & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 	and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr) 	 " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2)) 	 " & vbCrLf &_
			" and a.peri_ccod in (164,200,201) and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1" & vbCrLf &_
			" )a) as sin_grado_titulo	 " & vbCrLf &_
			" ) a "
'response.Write("<pre>"&consulta2&"</pre>")
f_reales.Consultar consulta2		
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
colores = Array(3);
	colores[0] = '';
	//colores[1] = '#97AAC6';
	//colores[2] = '#C0C0C0';
	colores[1] = '#FFECC6';
	colores[2] = '#FFECC6';
function cargar()
{
  buscador.action="docentes_x_carrera.asp?busqueda[0][carr_ccod]=" + document.buscador.elements["busqueda[0][carr_ccod]"].value;
  buscador.method="POST";
  buscador.submit();
}
</script>
<% f_busqueda.generaJS %>
<style type="text/css">
<!--
.Estilo2 {color: #000000}
.Estilo3 {font-weight: bold}
.Estilo4 {color: #000000; font-weight: bold; }
-->
</style>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                            <table width="100%" border="0">
                              <tr> 
                                <td width="12%"><div align="left">Sede</div></td>
                                <td width="5%"><div align="center">:</div></td>
                                <td width="83%"><%f_busqueda.dibujaCampoLista "lBusqueda", "sede_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="12%"><div align="left">Carrera</div></td>
                                <td width="5%"><div align="center">:</div></td>
                                <td width="83%"><%f_busqueda.dibujaCampoLista "lBusqueda", "carr_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="12%"><div align="left">Jornada</div></td>
                                <td width="5%"><div align="center">:</div></td>
                                <td width="83%"><%f_busqueda.dibujaCampoLista "lBusqueda", "jorn_ccod"%></td>
                              </tr>
                            </table>
                          </div></td>
                  <td width="19%"><div align="center"><%botonera.DibujaBoton "buscar"%></div></td>
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
	<%'if sede_ccod<>"" then%>
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
					<%if sede_ccod="2" then%>
					<font color="#0000FF">
					* Los Datos de Providencia se suman a la sede Central ya que por encontrarse en la misma ciudad tiene el carácter de Campus.
                    </font>
					<%end if%>
					<br>
                  
                  </div>
              <form name="edicion">
                <br>
				<!---------------------------------OTRA TABLA-------------------------------------->
				<tr><td>&nbsp;</td></tr>
				  <tr><td align="left"><%pagina.dibujarSubtitulo("Resumen de docentes reales Universidad")%></td></tr>
				   <tr>
                       <td width="100%"><div align="right">P&aacute;ginas: &nbsp; <%f_reales.AccesoPagina%> </div></td>
				  </tr>
				  <tr>
				  		<td align="center">
                           <% f_reales.DibujaTabla()%>
                        </td>
                  </tr>
				  <tr><td>&nbsp;</td></tr>
				  <tr><td>&nbsp;</td></tr>
				<tr>
                    <td align="center">
						    <table width="100%" class="v1" border="1" cellpadding="0" cellspacing="0" borderColor="#999999" bgColor="#adadad">
                              <!--DWLayoutTable-->
                              <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="70%" colspan="4" valign="bottom"><FONT color="#333333"><div align="center"><strong>Docentes Sede <%=sede_tdesc%></strong></div></font></td>
                              </tr>
							  <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="70%" colspan="4" valign="bottom"><FONT color="#333333"><div align="center">Primer Semestre año 2005</div></font></td>
                              </tr>
							  <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="60%" rowspan="1" valign="bottom"><FONT color="#333333"><div align="center">Docentes</div></font></td>
                                <td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Hombres</div></font></td>
                                <td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Mujeres</div></font></td>
                                <td width="20%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Horas Cronol&oacute;gicas</div></font></td>
                              </tr>
							  <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Doctores Jornada completa</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=5&tipo_jornada=1&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,1,1,164,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=5&tipo_jornada=1&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,1,2,164,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,1,164,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Doctores Media Jornada</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=5&tipo_jornada=2&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,2,1,164,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=5&tipo_jornada=2&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,2,2,164,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,2,164,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Doctores Jornada Hora</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=5&tipo_jornada=3&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,3,1,164,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=5&tipo_jornada=3&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,3,2,164,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,3,164,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Magíster Jornada completa</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=4&tipo_jornada=1&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,1,1,164,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=4&tipo_jornada=1&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,1,2,164,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,1,164,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Magíster Media Jornada</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=4&tipo_jornada=2&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,2,1,164,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=4&tipo_jornada=2&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,2,2,164,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,2,164,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Magíster Jornada Hora</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=4&tipo_jornada=3&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,3,1,164,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=4&tipo_jornada=3&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,3,2,164,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,3,164,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Licenciados Jornada completa</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=3&tipo_jornada=1&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,1,1,164,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=3&tipo_jornada=1&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,1,2,164,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,3,1,164,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Licenciados Media Jornada</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=3&tipo_jornada=2&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,2,1,164,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=3&tipo_jornada=2&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,2,2,164,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,3,2,164,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Liceciados Jornada Hora</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=3&tipo_jornada=3&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,3,1,164,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=3&tipo_jornada=3&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,3,2,164,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,3,3,164,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Profesionales Jornada completa</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=2&tipo_jornada=1&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,1,1,164,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=2&tipo_jornada=1&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,1,2,164,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,2,1,164,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Profesionales Media Jornada</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=2&tipo_jornada=2&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,2,1,164,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=2&tipo_jornada=2&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,2,2,164,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,2,2,164,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Profesionales Jornada Hora</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=2&tipo_jornada=3&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,3,1,164,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=2&tipo_jornada=3&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,3,2,164,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,2,3,164,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Téc. Nivel Súperior Jornada completa</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=1&tipo_jornada=1&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,1,1,164,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=1&tipo_jornada=1&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,1,2,164,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,1,1,164,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Téc. Nivel Súperior Media Jornada</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=1&tipo_jornada=2&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,2,1,164,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=1&tipo_jornada=2&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,2,2,164,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,1,2,164,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Téc. Nivel Súperior Jornada Hora</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=1&tipo_jornada=3&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,3,1,164,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=1&tipo_jornada=3&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,3,2,164,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,1,3,164,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Sin título o grado Jornada completa</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=0&tipo_jornada=1&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,1,1,164,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=0&tipo_jornada=1&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,1,2,164,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,0,1,164,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Sin título o grado Media Jornada</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=0&tipo_jornada=2&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,2,1,164,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=0&tipo_jornada=2&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,2,2,164,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,0,2,164,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Sin título o grado Jornada Hora</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=0&tipo_jornada=3&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,3,1,164,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=0&tipo_jornada=3&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,3,2,164,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,0,3,164,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
						  </table>
					</td> 
				</tr>
				  <tr><td>&nbsp;</td></tr>
				  <tr><td>&nbsp;</td></tr>
				<tr>
                    <td align="center">
						    <table width="100%" class="v1" border="1" cellpadding="0" cellspacing="0" borderColor="#999999" bgColor="#adadad">
                              <!--DWLayoutTable-->
                              <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="70%" colspan="4" valign="bottom"><FONT color="#333333"><div align="center"><strong>Docentes Sede <%=sede_tdesc%></strong></div></font></td>
                              </tr>
							  <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="70%" colspan="4" valign="bottom"><FONT color="#333333"><div align="center">Segundo Semestre Año 2005</div></font></td>
                              </tr>
							  <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="60%" rowspan="1" valign="bottom"><FONT color="#333333"><div align="center">Docentes</div></font></td>
                                <td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Hombres</div></font></td>
                                <td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Mujeres</div></font></td>
                                <td width="20%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Horas Cronol&oacute;gicas</div></font></td>
                              </tr>
							  <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Doctores Jornada completa</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=5&tipo_jornada=1&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,1,1,200,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=5&tipo_jornada=1&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,1,2,200,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,1,200,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Doctores Media Jornada</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=5&tipo_jornada=2&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,2,1,200,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=5&tipo_jornada=2&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,2,2,200,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,2,200,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Doctores Jornada Hora</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=5&tipo_jornada=3&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,3,1,200,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=5&tipo_jornada=3&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,3,2,200,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,3,200,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Magíster Jornada completa</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=4&tipo_jornada=1&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,1,1,200,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=4&tipo_jornada=1&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,1,2,200,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,1,200,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Magíster Media Jornada</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=4&tipo_jornada=2&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,2,1,200,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=4&tipo_jornada=2&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,2,2,200,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,2,200,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Magíster Jornada Hora</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=4&tipo_jornada=3&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,3,1,200,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=4&tipo_jornada=3&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,3,2,200,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,3,200,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Licenciados Jornada completa</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=3&tipo_jornada=1&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,1,1,200,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=3&tipo_jornada=1&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,1,2,200,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,3,1,200,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Licenciados Media Jornada</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=3&tipo_jornada=2&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,2,1,200,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=3&tipo_jornada=2&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,2,2,200,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,3,2,200,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Liceciados Jornada Hora</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=3&tipo_jornada=3&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,3,1,200,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=3&tipo_jornada=3&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,3,2,200,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,3,3,200,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Profesionales Jornada completa</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=2&tipo_jornada=1&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,1,1,200,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=2&tipo_jornada=1&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,1,2,200,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,2,1,200,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Profesionales Media Jornada</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=2&tipo_jornada=2&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,2,1,200,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=2&tipo_jornada=2&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,2,2,200,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,2,2,200,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Profesionales Jornada Hora</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=2&tipo_jornada=3&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,3,1,200,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=2&tipo_jornada=3&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,3,2,200,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,2,3,200,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Téc. Nivel Súperior Jornada completa</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=1&tipo_jornada=1&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,1,1,200,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=1&tipo_jornada=1&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,1,2,200,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,1,1,200,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Téc. Nivel Súperior Media Jornada</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=1&tipo_jornada=2&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,2,1,200,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=1&tipo_jornada=2&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,2,2,200,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,1,2,200,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Téc. Nivel Súperior Jornada Hora</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=1&tipo_jornada=3&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,3,1,200,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=1&tipo_jornada=3&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,3,2,200,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,1,3,200,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Sin título o grado Jornada completa</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=0&tipo_jornada=1&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,1,1,200,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=0&tipo_jornada=1&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,1,2,200,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,0,1,200,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Sin título o grado Media Jornada</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=0&tipo_jornada=2&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,2,1,200,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=0&tipo_jornada=2&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,2,2,200,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,0,2,200,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Sin título o grado Jornada Hora</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=0&tipo_jornada=3&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,3,1,200,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=0&tipo_jornada=3&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,3,2,200,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,0,3,200,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
						  </table>
					</td> 
				</tr>
				 <tr><td>&nbsp;</td></tr>
				  <tr><td>&nbsp;</td></tr>
				<tr>
                    <td align="center">
						    <table width="100%" class="v1" border="1" cellpadding="0" cellspacing="0" borderColor="#999999" bgColor="#adadad">
                              <!--DWLayoutTable-->
                              <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="70%" colspan="4" valign="bottom"><FONT color="#333333"><div align="center"><strong>Docentes Sede <%=sede_tdesc%></strong></div></font></td>
                              </tr>
							  <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="70%" colspan="4" valign="bottom"><FONT color="#333333"><div align="center">Periodo Extraordinario(Tercer Trimestre Año 2005)</div></font></td>
                              </tr>
							  <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="60%" rowspan="1" valign="bottom"><FONT color="#333333"><div align="center">Docentes</div></font></td>
                                <td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Hombres</div></font></td>
                                <td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Mujeres</div></font></td>
                                <td width="20%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Horas Cronol&oacute;gicas</div></font></td>
                              </tr>
							  <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Doctores Jornada completa</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=5&tipo_jornada=1&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,1,1,201,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=5&tipo_jornada=1&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,1,2,201,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,1,201,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Doctores Media Jornada</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=5&tipo_jornada=2&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,2,1,201,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=5&tipo_jornada=2&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,2,2,201,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,2,201,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Doctores Jornada Hora</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=5&tipo_jornada=3&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,3,1,201,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=5&tipo_jornada=3&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,3,2,201,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,3,201,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Magíster Jornada completa</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=4&tipo_jornada=1&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,1,1,201,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=4&tipo_jornada=1&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,1,2,201,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,1,201,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Magíster Media Jornada</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=4&tipo_jornada=2&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,2,1,201,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=4&tipo_jornada=2&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,2,2,201,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,2,201,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Magíster Jornada Hora</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=4&tipo_jornada=3&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,3,1,201,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=4&tipo_jornada=3&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,3,2,201,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,3,201,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Licenciados Jornada completa</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=3&tipo_jornada=1&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,1,1,201,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=3&tipo_jornada=1&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,1,2,201,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,3,1,201,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Licenciados Media Jornada</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=3&tipo_jornada=2&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,2,1,201,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=3&tipo_jornada=2&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,2,2,201,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,3,2,201,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Liceciados Jornada Hora</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=3&tipo_jornada=3&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,3,1,201,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=3&tipo_jornada=3&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,3,2,201,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,3,3,201,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Profesionales Jornada completa</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=2&tipo_jornada=1&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,1,1,201,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=2&tipo_jornada=1&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,1,2,201,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,2,1,201,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Profesionales Media Jornada</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=2&tipo_jornada=2&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,2,1,201,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=2&tipo_jornada=2&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,2,2,201,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,2,2,201,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Profesionales Jornada Hora</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=2&tipo_jornada=3&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,3,1,201,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=2&tipo_jornada=3&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,3,2,201,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,2,3,201,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Téc. Nivel Súperior Jornada completa</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=1&tipo_jornada=1&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,1,1,201,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=1&tipo_jornada=1&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,1,2,201,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,1,1,201,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Téc. Nivel Súperior Media Jornada</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=1&tipo_jornada=2&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,2,1,201,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=1&tipo_jornada=2&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,2,2,201,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,1,2,201,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Téc. Nivel Súperior Jornada Hora</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=1&tipo_jornada=3&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,3,1,201,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=1&tipo_jornada=3&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,3,2,201,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,1,3,201,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Sin título o grado Jornada completa</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=0&tipo_jornada=1&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,1,1,201,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=0&tipo_jornada=1&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,1,2,201,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,0,1,201,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Sin título o grado Media Jornada</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=0&tipo_jornada=2&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,2,1,201,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=0&tipo_jornada=2&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,2,2,201,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,0,2,201,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Sin título o grado Jornada Hora</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=0&tipo_jornada=3&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,3,1,201,carr_ccod,jorn_ccod)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_carrera.asp?sede_ccod=<%=sede_ccod%>&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&grado=0&tipo_jornada=3&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,3,2,201,carr_ccod,jorn_ccod)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,0,3,201,carr_ccod,jorn_ccod)%></div></td>
							 </tr>
						  </table>
					</td> 
				</tr>
				<!----------------------------------FIN TABLA-------------------------------------->			
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
	  <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                   <td><div align="center"><%botonera.DibujaBoton "lanzadera"%></div></td>
				   <td width="14%"> <div align="center">  <%
				                           if sede_ccod <> "" and carr_ccod <> ""  and jorn_ccod <> "" then
					                       botonera.agregabotonparam "excel", "url", "docentes_x_carrera_excel.asp?sede_ccod="&sede_ccod&"&carr_ccod="&carr_ccod&"&jorn_ccod="&jorn_ccod
										   else
										   botonera.agregabotonparam "excel", "deshabilitado", "true"
										   end if
										   botonera.dibujaboton "excel"
										%>
					 </div>
                  </td>
                </tr>
              </table>
            </div></td>
            <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<%'end if%>
	<div align="right">* Las horas son medidas de forma cronológica &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
	<br>
		
	<br>
	</td>
  </tr>  
</table>
</body>
</html>

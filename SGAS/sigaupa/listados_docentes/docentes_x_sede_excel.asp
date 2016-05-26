<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=docentes_por_sede.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 150000
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion

Function Cantidad_docentes(sede,grado,tipo_jornada,sexo,periodo)
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
Function Cantidad_horas_docentes(sede,grado,tipo_jornada,periodo)
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
					" where hdc.pers_ncorr=a.pers_ncorr and cast(hdc.peri_ccod as varchar)='"&periodo&"'"& vbCrLf &_
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
					" where hdc.pers_ncorr=a.pers_ncorr and cast(hdc.peri_ccod as varchar)='"&periodo&"'"& vbCrLf &_
					" "& filtro_adicional 
'response.Write("<pre>"&consulta_Cantidad&"</pre>")					
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
					" where hdc.pers_ncorr=a.pers_ncorr and cast(hdc.peri_ccod as varchar)='"&periodo&"'"& vbCrLf &_
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
					" )a, horas_docentes_seccion_final hdc"& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr and cast(hdc.peri_ccod as varchar)='"&periodo&"'"& vbCrLf &_
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
					" where hdc.pers_ncorr=a.pers_ncorr and cast(hdc.peri_ccod as varchar)='"&periodo&"'"& vbCrLf &_
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
					" where hdc.pers_ncorr=a.pers_ncorr and cast(hdc.peri_ccod as varchar)='"&periodo&"'"& vbCrLf &_
					" "& filtro_adicional
Cantidad_horas_docentes= conexion.consultaUno(consulta_cantidad)

end if
End Function

sede_ccod = request.QueryString("sede_ccod")  'negocio.obtenerSede
sede_tdesc = conexion.consultaUno("select protic.initcap(sede_tdesc) from sedes where cast(sede_ccod as varchar)= '"&sede_ccod&"'")
'------------------------------------------------------------------------------------

 if sede_ccod = "2" then
	filtro_sede= " and a.sede_ccod in ('1','2')"
 elseif sede <> "" then
	filtro_sede= " and a.sede_ccod = '"&sede_ccod&"'"
 else
	filtro_sede= ""	
 end if

fecha_01=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")

'--------------------------------listado general de docentes (datos reales)--------------------------------
 set f_reales = new CFormulario
 f_reales.Carga_Parametros "docentes_sede.xml", "f_reales"
 f_reales.Inicializar conexion
 
 periodo = negocio.obtenerPeriodoAcademico("Planificacion")
 anos_ccod =conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
 primer_semestre = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod = 1")
 segundo_semestre = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod = 2")
 tercer_trimestre = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod = 3")
 
 
  
 consulta2 = " select distinct  a.*, Doctor + Magister + Licenciado + Profesional + Tecnico + sin_grado_titulo as Totales	 " & vbCrLf &_
			" from (select    " & vbCrLf &_
			" (select count(distinct c.pers_ncorr)   " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,carreras e,asignaturas f,periodos_academicos pea  " & vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  "&filtro_sede & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			"  and d.egra_ccod in (1,3) and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&anos_ccod&"' and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1" & vbCrLf &_
			"  ) as Doctor,   " & vbCrLf &_
			" (select count(distinct c.pers_ncorr)  " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,carreras e,asignaturas f,periodos_academicos pea " & vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod "&filtro_sede & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8) and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
			"  and d.egra_ccod=1 and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&anos_ccod&"' and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1	 " & vbCrLf &_
			"  ) as Magister, " & vbCrLf &_
			" (select count(distinct c.pers_ncorr) 	 " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, carreras e,asignaturas f,periodos_academicos pea " & vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 "&filtro_sede & vbCrLf &_
			"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 3 and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3)) 	 " & vbCrLf &_	
			"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=4 and r.egra_ccod=1)  " & vbCrLf &_
			"  and d.egra_ccod=1 and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&anos_ccod&"' and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1	 " & vbCrLf &_
			"  ) as Licenciado, 	 " & vbCrLf &_
			" (select count(*)	 " & vbCrLf &_
			"  from (	 " & vbCrLf &_
			"  select distinct c.pers_ncorr  " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, carreras e,asignaturas f,periodos_academicos pea " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 "&filtro_sede & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
			" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 ) 	 " & vbCrLf &_
			" and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&anos_ccod&"'	and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1 " & vbCrLf &_
			" union all	 " & vbCrLf &_
			" select distinct c.pers_ncorr 	 " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d, carreras e,asignaturas f,periodos_academicos pea " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 "&filtro_sede & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 	and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and d.grac_ccod = 2 and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&anos_ccod&"' and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1 " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr) 	 " & vbCrLf &_
			" )a ) as Profesional,	 " & vbCrLf &_
			" (select count(*)	 " & vbCrLf &_
			" from (	 " & vbCrLf &_
			" select distinct c.pers_ncorr  " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d	,carreras e,asignaturas f,periodos_academicos pea " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 "&filtro_sede & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3)	 " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3)) 	 " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1) 	 " & vbCrLf &_
			" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 1 ) 	 " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 ) 	 " & vbCrLf &_
			" and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&anos_ccod&"'	and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1 " & vbCrLf &_
			" union all	 " & vbCrLf &_
			" select distinct c.pers_ncorr 	 " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,carreras e, asignaturas f,periodos_academicos pea " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 "&filtro_sede & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and d.grac_ccod = 1 and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&anos_ccod&"'	and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1 " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr) 	 " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 ) 	 " & vbCrLf &_
			" )a	 " & vbCrLf &_
			" ) as tecnico,	 " & vbCrLf &_
			" ( select count(*)	 " & vbCrLf &_
			" from (	 " & vbCrLf &_
			" select distinct c.pers_ncorr 	 " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,carreras e,asignaturas f,periodos_academicos pea	 " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 "&filtro_sede & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 	and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3)) 	 " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1) 	 " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) ) 	 " & vbCrLf &_
			" and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&anos_ccod&"'	and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1 " & vbCrLf &_
			" union all	 " & vbCrLf &_
			" select distinct c.pers_ncorr 	 " & vbCrLf &_
			" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d, carreras e,asignaturas f,periodos_academicos pea	 " & vbCrLf &_
			" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	 "&filtro_sede & vbCrLf &_
			" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1 	and a.asig_ccod=f.asig_ccod and f.duas_ccod in (1,2,3) " & vbCrLf &_
			" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr) 	 " & vbCrLf &_
			" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2)) 	 " & vbCrLf &_
			" and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&anos_ccod&"' and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1" & vbCrLf &_
			" )a) as sin_grado_titulo	 " & vbCrLf &_
			" ) a "
'response.Write("<pre>"&consulta2&"</pre>")
f_reales.Consultar consulta2		
f_reales.siguiente
%>
<html>
<head>
<title>docentes por sede</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="2">&nbsp;</td>
  </tr>
 <tr> 
    <td colspan="2"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Docentes sede <%=sede_tdesc%></font></div>
	  <div align="right"></div></td>
  </tr>
  <tr> 
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr> 
    <td width="7%"><strong>Fecha</strong></td>
    <td width="93%"><strong>:</strong> <%=fecha_01%></td>
  </tr>
  <%if sede_ccod = 2 then%>
  <tr> 
    <td colspan="2"><font color="#0000FF">
					* Los Datos de Providencia se suman a la sede Central ya que por encontrarse en la misma ciudad tiene el carácter de Campus.
                    </font></td>
  </tr>
  <%end if%>
</table>
<p>&nbsp;</p>
<table width="100%" border="1">
    <tr borderColor="#999999" bgColor="#c4d7ff">
		<td colspan="7" align="center"><FONT color="#333333"><div align="center"><strong>Resumen de docentes reales Universidad</strong></div></font></td>
	</tr>
	<tr borderColor="#999999" bgColor="#c4d7ff">
		<td width="10%"><FONT color="#333333"><div align="center"><strong>Doctores</strong></div></font></td>
		<td width="10%"><FONT color="#333333"><div align="center"><strong>Magister</strong></div></font></td>
		<td width="10%"><FONT color="#333333"><div align="center"><strong>Licenciados</strong></div></font></td>
		<td width="10%"><FONT color="#333333"><div align="center"><strong>Profesionales</strong></div></font></td>
		<td width="10%"><FONT color="#333333"><div align="center"><strong>Técnicos</strong></div></font></td>
		<td width="10%"><FONT color="#333333"><div align="center"><strong>Sin grado-título</strong></div></font></td>
		<td width="10%"><FONT color="#333333"><div align="center"><strong>Totales</strong></div></font></td>
	</tr>
	<tr bgcolor="#FFFFFF">
		<td><div align="center" class="Estilo4"><%=f_reales.ObtenerValor("Doctor")%></td>
		<td><div align="center" class="Estilo4"><%=f_reales.ObtenerValor("Magister")%></td>
		<td><div align="center" class="Estilo4"><%=f_reales.ObtenerValor("Licenciado")%></td>
		<td><div align="center" class="Estilo4"><%=f_reales.ObtenerValor("Profesional")%></td>
		<td><div align="center" class="Estilo4"><%=f_reales.ObtenerValor("Tecnico")%></td>
		<td><div align="center" class="Estilo4"><%=f_reales.ObtenerValor("sin_grado_titulo")%></td>
		<td><div align="center" class="Estilo4"><%=f_reales.ObtenerValor("Totales")%></td>
	</tr>
</table>
<p>&nbsp;</p>
<table width="100%" border="1">
                              <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="70%" colspan="4" valign="bottom"><FONT color="#333333"><div align="center"><strong>Docentes Sede <%=sede_tdesc%></strong></div></font></td>
                              </tr>
							  <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="70%" colspan="4" valign="bottom"><FONT color="#333333"><div align="center">Primer Semestre año <%=anos_ccod%></div></font></td>
                              </tr>
							  <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="60%" rowspan="1" valign="bottom"><FONT color="#333333"><div align="center">Docentes</div></font></td>
                                <td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Hombres</div></font></td>
                                <td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Mujeres</div></font></td>
                                <td width="20%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Horas cronológicas contratadas</div></font></td>
                              </tr>
							  <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Doctores Jornada completa</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,1,1,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,1,2,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,1,primer_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Doctores Media Jornada</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,2,1,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,2,2,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,2,primer_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Doctores Jornada Hora</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,3,1,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,3,2,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,3,primer_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Magíster Jornada completa</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,1,1,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,1,2,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,1,primer_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Magíster Media Jornada</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,2,1,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,2,2,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,2,primer_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Magíster Jornada Hora</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,3,1,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,3,2,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,3,primer_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Licenciados Jornada completa</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,1,1,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,1,2,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,3,1,primer_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Licenciados Media Jornada</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,2,1,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,2,2,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,3,2,primer_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Liceciados Jornada Hora</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,3,1,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,3,2,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,3,3,primer_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Profesionales Jornada completa</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,1,1,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,1,2,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,2,1,primer_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Profesionales Media Jornada</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,2,1,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,2,2,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,2,2,primer_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Profesionales Jornada Hora</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,3,1,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,3,2,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,2,3,primer_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Téc. Nivel Súperior Jornada completa</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,1,1,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,1,2,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,1,1,primer_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Téc. Nivel Súperior Media Jornada</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,2,1,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,2,2,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,1,2,primer_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Téc. Nivel Súperior Jornada Hora</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,3,1,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,3,2,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,1,3,primer_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Sin título o grado Jornada completa</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,1,1,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,1,2,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,0,1,primer_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Sin título o grado Media Jornada</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,2,1,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,2,2,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,0,2,primer_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Sin título o grado Jornada Hora</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,3,1,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,3,2,primer_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,0,3,primer_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
							 	<td colspan="4">&nbsp;</td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
							 	<td colspan="4">&nbsp;</td>
							 </tr>
							  <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="70%" colspan="4" valign="bottom"><FONT color="#333333"><div align="center"><strong>Docentes Sede <%=sede_tdesc%></strong></div></font></td>
                              </tr>
							  <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="70%" colspan="4" valign="bottom"><FONT color="#333333"><div align="center">Segundo Semestre año <%=anos_ccod%></div></font></td>
                              </tr>
							  <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="60%" rowspan="1" valign="bottom"><FONT color="#333333"><div align="center">Docentes</div></font></td>
                                <td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Hombres</div></font></td>
                                <td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Mujeres</div></font></td>
                                <td width="20%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Horas cronológicas contratadas</div></font></td>
                              </tr>
							  <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Doctores Jornada completa</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,1,1,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,1,2,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,1,segundo_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Doctores Media Jornada</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,2,1,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,2,2,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,2,segundo_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Doctores Jornada Hora</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,3,1,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,3,2,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,3,segundo_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Magíster Jornada completa</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,1,1,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,1,2,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,1,segundo_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Magíster Media Jornada</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,2,1,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,2,2,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,2,segundo_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Magíster Jornada Hora</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,3,1,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,3,2,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,3,segundo_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Licenciados Jornada completa</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,1,1,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,1,2,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,3,1,segundo_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Licenciados Media Jornada</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,2,1,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,2,2,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,3,2,segundo_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Liceciados Jornada Hora</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,3,1,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,3,2,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,3,3,segundo_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Profesionales Jornada completa</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,1,1,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,1,2,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,2,1,segundo_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Profesionales Media Jornada</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,2,1,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,2,2,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,2,2,segundo_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Profesionales Jornada Hora</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,3,1,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,3,2,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,2,3,segundo_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Téc. Nivel Súperior Jornada completa</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,1,1,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,1,2,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,1,1,segundo_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Téc. Nivel Súperior Media Jornada</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,2,1,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,2,2,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,1,2,segundo_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Téc. Nivel Súperior Jornada Hora</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,3,1,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,3,2,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,1,3,segundo_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Sin título o grado Jornada completa</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,1,1,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,1,2,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,0,1,segundo_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Sin título o grado Media Jornada</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,2,1,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,2,2,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,0,2,segundo_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Sin título o grado Jornada Hora</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,3,1,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,3,2,segundo_semestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,0,3,segundo_semestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
							 	<td colspan="4">&nbsp;</td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
							 	<td colspan="4">&nbsp;</td>
							 </tr>
							  <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="70%" colspan="4" valign="bottom"><FONT color="#333333"><div align="center"><strong>Docentes Sede <%=sede_tdesc%></strong></div></font></td>
                              </tr>
							  <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="70%" colspan="4" valign="bottom"><FONT color="#333333"><div align="center">Periodo Extraordinario(Tercer Trimestre año <%=anos_ccod%>)</div></font></td>
                              </tr>
							  <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="60%" rowspan="1" valign="bottom"><FONT color="#333333"><div align="center">Docentes</div></font></td>
                                <td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Hombres</div></font></td>
                                <td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Mujeres</div></font></td>
                                <td width="20%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Horas cronológicas contratadas</div></font></td>
                              </tr>
							  <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Doctores Jornada completa</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,1,1,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,1,2,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,1,tercer_trimestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Doctores Media Jornada</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,2,1,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,2,2,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,2,tercer_trimestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Doctores Jornada Hora</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,3,1,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,3,2,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,3,tercer_trimestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Magíster Jornada completa</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,1,1,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,1,2,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,1,tercer_trimestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Magíster Media Jornada</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,2,1,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,2,2,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,2,tercer_trimestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Magíster Jornada Hora</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,3,1,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,3,2,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,3,tercer_trimestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Licenciados Jornada completa</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,1,1,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,1,2,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,3,1,tercer_trimestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Licenciados Media Jornada</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,2,1,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,2,2,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,3,2,tercer_trimestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Liceciados Jornada Hora</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,3,1,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,3,2,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,3,3,tercer_trimestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Profesionales Jornada completa</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,1,1,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,1,2,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,2,1,tercer_trimestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Profesionales Media Jornada</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,2,1,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,2,2,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,2,2,tercer_trimestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Profesionales Jornada Hora</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,3,1,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,3,2,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,2,3,tercer_trimestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Téc. Nivel Súperior Jornada completa</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,1,1,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,1,2,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,1,1,tercer_trimestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Téc. Nivel Súperior Media Jornada</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,2,1,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,2,2,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,1,2,tercer_trimestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Téc. Nivel Súperior Jornada Hora</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,3,1,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,3,2,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,1,3,tercer_trimestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Sin título o grado Jornada completa</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,1,1,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,1,2,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,0,1,tercer_trimestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Sin título o grado Media Jornada</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,2,1,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,2,2,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,0,2,tercer_trimestre)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Sin título o grado Jornada Hora</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,3,1,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,3,2,tercer_trimestre)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,0,3,tercer_trimestre)%></div></td>
							 </tr>
</table>
<div align="right">* Las horas son medidas de forma cronológica &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>
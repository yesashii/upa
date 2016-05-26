<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION			        :
'FECHA CREACIÓN			      :
'CREADO POR				        :
'ENTRADA				          : NA
'SALIDA				            : NA
'MODULO QUE ES UTILIZADO	: SIN ACCESO DESDE EL SISTEMA
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 22/03/2013
'ACTUALIZADO POR			  : Luis Herrera G.
'MOTIVO				          : Corregir código, eliminar sentencia *=, =*
'LINEA				          : 77, 79, 245, 246
'********************************************************************
Response.AddHeader "Content-Disposition", "attachment;filename=listado_presupuestos.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

periodo = negocio.obtenerPeriodoAcademico("planificacion")

fecha_01=conexion.consultaUno("select convert(datetime,getDate(),103) as fecha")
anos_ccod = conexion.consultaUno("select anos_ccod from periodos_Academicos where cast(peri_ccod as varchar)='"&periodo&"'")

ano_actual=conexion.consultaUno("select year(getDate())-1 as anio")

if cint(anos_ccod) <= ano_actual-1  then
	ecdo_ccod=2
else
	ecdo_ccod=1	
end if

set f_listado = new CFormulario
f_listado.Carga_Parametros "parametros.xml", "tabla"
f_listado.Inicializar conexion

'consulta = " select distinct CAST(B.PERS_NRUT AS VARCHAR) as Rut "& vbCrLf &_
'		   "			, PERS_XDV as DV "& vbCrLf &_
'		   "			, ISNULL(B.PERS_TNOMBRE, '') as nombre, ISNULL(B.PERS_TAPE_PATERNO, '') as ap_paterno , ISNULL(B.PERS_TAPE_MATERNO, '') as ap_materno "& vbCrLf &_
'		   "			, (SELECT TOP 1 CUDO_TITULO FROM CURRICULUM_DOCENTE WHERE PERS_NCORR = A.PERS_NCORR AND GRAC_CCOD IN(1,2) ORDER BY GRAC_CCOD DESC) AS PROFESION "& vbCrLf &_
'		   "			,  E.BLOQ_ANEXO, H.CARR_TDESC, G.ASIG_CCOD "& vbCrLf &_
'		   "			, ISNULL(CASE G.MODA_CCOD WHEN 1 THEN HDS.HORAS ELSE G.secc_nhoras_pagar  END ,0) AS ASIG_NHORAS "& vbCrLf &_
'		   "			, I.ASIG_TDESC	, J.DUAS_TDESC, cast(E.BPRO_MVALOR as numeric) as bpro_mvalor "& vbCrLf &_
'		   "			, cast(ISNULL(CASE G.MODA_CCOD WHEN 1 THEN  (E.BPRO_MVALOR * (HDS.HORAS /2)) ELSE (E.BPRO_MVALOR * (G.secc_nhoras_pagar/2)) END ,0) as numeric) AS Valor "& vbCrLf &_
'		   "			, convert(varchar(10), A.CDOC_FCONTRATO_Ini,103) as FechaI "& vbCrLf &_
'		   "			, convert(varchar(10), A.CDOC_FCONTRATO_Fin, 103) as FechaF "& vbCrLf &_
'		   "			, isnull(E.HCOR_Valor1,0) as HOR_COORDINACION1 "& vbCrLf &_
'		   "			, isnull(E.HCOR_Valor2,0) AS HOR_COORDINACION1 "& vbCrLf &_
'		   "			, cast(P.NIVE_CCOD as varchar) + '-' + cast(G.SECC_TDESC as varchar) as SECC_TDESC "& vbCrLf &_
'		   "			, A.Porcentaje "& vbCrLf &_
'		   "			, A.MontoMC "& vbCrLf &_
'		   "			, X.SEDE_TDESC, pea.peri_tdesc as semestre,jor.jorn_tdesc as jornada "& vbCrLf &_
'		   "         ,CASE J.DUAS_CCOD WHEN 1 THEN Z.PROC_CUOTAS_TRIMESTRAL WHEN 2 THEN Z.PROC_CUOTAS_SEMESTRAL WHEN 3 THEN Z.PROC_CUOTAS_ANUAL WHEN 4 THEN Z.PROC_CUOTAS_ANUAL WHEN 5 THEN protic.OBTENER_CUOTAS_PERIODO(G.SECC_CCOD) END AS num_cuotas "& vbCrLf &_
'		   "         ,case J.DUAS_CCOD WHEN 5 then protic.trunc(G.SECC_FINICIO_SEC) else protic.trunc(Z.PROC_FINICIO) end AS FECHA_INICIO "& vbCrLf &_
'		   "         ,protic.trunc(CASE J.DUAS_CCOD WHEN 1 THEN Z.PROC_FFIN_TRIMESTRAL WHEN 2 THEN Z.PROC_FFIN_SEMESTRAL WHEN 3 THEN Z.PROC_FFIN_ANUAL WHEN 4 THEN Z.PROC_FFIN_ANUAL WHEN 5 THEN G.SECC_FTERMINO_SEC END) AS FECHA_FIN "& vbCrLf &_
'		   "         ,M.TPRO_TDESC AS TIPO_PROFESOR "& vbCrLf &_
'		   "	from    CONTRATOS_DOCENTES	A, PERSONAS B, "& vbCrLf &_
'		   "   		    BLOQUES_PROFESORES E, BLOQUES_horarios F,PERIODOS_ACADEMICOS PEA,  "& vbCrLf &_
'		   "		    SECCIONES G, CARRERAS H, ASIGNATURAS I, DURACION_ASIGNATURA J,jornadas jor, "& vbCrLf &_
'		   "		    PROFESORES L, TIPOS_PROFESORES M, PAISES N, ESTADOS_CIVILES O, MALLA_CURRICULAR P,SEDES X,PROCESOS Z,HORAS_DOCENTES_SECCION_FINAL HDS "& vbCrLf &_
'		   "	where B.PERS_NCORR = A.PERS_NCORR "& vbCrLf &_
'		   "			and E.PERS_NCORR = A.PERS_NCORR "& vbCrLf &_
'		   "			and E.CDOC_NCORR	= A.CDOC_NCORR	"& vbCrLf &_
'		   "			and F.BLOQ_CCOD = E.BLOQ_CCOD "& vbCrLf &_
'		   "			and G.SECC_CCOD = F.SECC_CCOD "& vbCrLf &_
'		   "			AND H.CARR_CCOD = G.CARR_CCOD "& vbCrLf &_
'		   "			AND I.ASIG_CCOD = G.ASIG_CCOD "& vbCrLf &_
'		   "			and J.DUAS_CCOD =* I.DUAS_CCOD "& vbCrLf &_
'		   "			and L.PERS_NCORR = A.PERS_NCORR "& vbCrLf &_
'		   "			and M.TPRO_CCOD =* L.TPRO_CCOD "& vbCrLf &_
'		   "			and N.PAIS_CCOD = B.PAIS_CCOD "& vbCrLf &_
'		   "			and O.ECIV_CCOD = B.ECIV_CCOD "& vbCrLf &_
'		   "			and P.MALL_CCOD = G.MALL_CCOD and g.jorn_ccod = jor.jorn_ccod"& vbCrLf &_
'		   "			and G.PERI_CCOD = PEA.PERI_CCOD "& vbCrLf &_
'		   "			and cast(PEA.ANOS_CCOD as varchar) = '"&anos_ccod&"'"& vbCrLf &_
'		   "            AND F.SECC_CCOD = HDS.SECC_CCOD "& vbCrLf &_
'		   "            AND E.PERS_NCORR = HDS.PERS_NCORR "& vbCrLf &_
'		   "            AND E.TPRO_CCOD = HDS.TPRO_CCOD "& vbCrLf &_
'		   "            AND E.SEDE_CCOD = X.SEDE_CCOD  "& vbCrLf &_
'		   "			AND E.PROC_CCOD = Z.PROC_CCOD "& vbCrLf &_
'		   "	order by SEDE_TDESC, ap_paterno,ap_materno,nombre"	
'--------------------------------------------------------------------------------------------------------------------------inicio consulta para SQLServqr 2008
consulta = " select distinct cast(b.pers_nrut as varchar)                    as rut, " & vbCrLf &_
"                pers_xdv                                        as dv,              " & vbCrLf &_
"                isnull(b.pers_tnombre, '')                      as nombre,          " & vbCrLf &_
"                isnull(b.pers_tape_paterno, '')                 as ap_paterno,      " & vbCrLf &_
"                isnull(b.pers_tape_materno, '')                 as ap_materno,      " & vbCrLf &_
"                (select top 1 cudo_titulo                                           " & vbCrLf &_
"                 from   curriculum_docente                                          " & vbCrLf &_
"                 where  pers_ncorr = a.pers_ncorr                                   " & vbCrLf &_
"                        and grac_ccod in( 1, 2 )                                    " & vbCrLf &_
"                 order  by grac_ccod desc)                      as profesion,       " & vbCrLf &_
"                e.bloq_anexo,                                                       " & vbCrLf &_
"                h.carr_tdesc,                                                       " & vbCrLf &_
"                g.asig_ccod,                                                        " & vbCrLf &_
"                isnull(case g.moda_ccod                                             " & vbCrLf &_
"                         when 1 then hds.horas                                      " & vbCrLf &_
"                         else g.secc_nhoras_pagar                                   " & vbCrLf &_
"                       end, 0)                                  as asig_nhoras,     " & vbCrLf &_
"                i.asig_tdesc,                                                       " & vbCrLf &_
"                j.duas_tdesc,                                                       " & vbCrLf &_
"                cast(e.bpro_mvalor as numeric)                  as bpro_mvalor,     " & vbCrLf &_
"                cast(isnull(case g.moda_ccod                                        " & vbCrLf &_
"                              when 1 then ( e.bpro_mvalor * ( hds.horas / 2 ) )     " & vbCrLf &_
"                              else ( e.bpro_mvalor *                                " & vbCrLf &_
"                                   ( g.secc_nhoras_pagar / 2 ) )                    " & vbCrLf &_
"                            end, 0) as numeric)                 as valor,           " & vbCrLf &_
"                convert(varchar(10), a.cdoc_fcontrato_ini, 103) as fechai,          " & vbCrLf &_
"                convert(varchar(10), a.cdoc_fcontrato_fin, 103) as fechaf,          " & vbCrLf &_
"                isnull(e.hcor_valor1, 0)                        as                  " & vbCrLf &_
"                hor_coordinacion1,                                                  " & vbCrLf &_
"                isnull(e.hcor_valor2, 0)                        as                  " & vbCrLf &_
"                hor_coordinacion1,                                                  " & vbCrLf &_
"                cast(p.nive_ccod as varchar) + '-'                                  " & vbCrLf &_
"                + cast(g.secc_tdesc as varchar)                 as secc_tdesc,      " & vbCrLf &_
"                a.porcentaje,                                                       " & vbCrLf &_
"                a.montomc,                                                          " & vbCrLf &_
"                x.sede_tdesc,                                                       " & vbCrLf &_
"                pea.peri_tdesc                                  as semestre,        " & vbCrLf &_
"                jor.jorn_tdesc                                  as jornada,         " & vbCrLf &_
"                case j.duas_ccod                                                    " & vbCrLf &_
"                  when 1 then z.proc_cuotas_trimestral                              " & vbCrLf &_
"                  when 2 then z.proc_cuotas_semestral                               " & vbCrLf &_
"                  when 3 then z.proc_cuotas_anual                                   " & vbCrLf &_
"                  when 4 then z.proc_cuotas_anual                                   " & vbCrLf &_
"                  when 5 then protic.obtener_cuotas_periodo(g.secc_ccod)            " & vbCrLf &_
"                end                                             as num_cuotas,      " & vbCrLf &_
"                case j.duas_ccod                                                    " & vbCrLf &_
"                  when 5 then protic.trunc(g.secc_finicio_sec)                      " & vbCrLf &_
"                  else protic.trunc(z.proc_finicio)                                 " & vbCrLf &_
"                end                                             as fecha_inicio,    " & vbCrLf &_
"                protic.trunc(case j.duas_ccod                                       " & vbCrLf &_
"                               when 1 then z.proc_ffin_trimestral                   " & vbCrLf &_
"                               when 2 then z.proc_ffin_semestral                    " & vbCrLf &_
"                               when 3 then z.proc_ffin_anual                        " & vbCrLf &_
"                               when 4 then z.proc_ffin_anual                        " & vbCrLf &_
"                               when 5 then g.secc_ftermino_sec                      " & vbCrLf &_
"                             end)                               as fecha_fin,       " & vbCrLf &_
"                m.tpro_tdesc                                    as tipo_profesor    " & vbCrLf &_
"from   contratos_docentes as a                                                      " & vbCrLf &_
"       inner join personas as b                                                     " & vbCrLf &_
"               on a.pers_ncorr = b.pers_ncorr                                       " & vbCrLf &_
"       inner join paises as n                                                       " & vbCrLf &_
"               on b.pais_ccod = n.pais_ccod                                         " & vbCrLf &_
"       inner join estados_civiles as o                                              " & vbCrLf &_
"               on b.eciv_ccod = o.eciv_ccod                                         " & vbCrLf &_
"       inner join bloques_profesores as e                                           " & vbCrLf &_
"               on a.pers_ncorr = e.pers_ncorr                                       " & vbCrLf &_
"                  and a.cdoc_ncorr = e.cdoc_ncorr                                   " & vbCrLf &_
"       inner join bloques_horarios as f                                             " & vbCrLf &_
"               on e.bloq_ccod = f.bloq_ccod                                         " & vbCrLf &_
"       inner join secciones as g                                                    " & vbCrLf &_
"               on f.secc_ccod = g.secc_ccod                                         " & vbCrLf &_
"       inner join periodos_academicos as pea                                        " & vbCrLf &_
"               on g.peri_ccod = pea.peri_ccod                                       " & vbCrLf &_
"                  and cast(pea.anos_ccod as varchar) = '"&anos_ccod&"'              " & vbCrLf &_
"       inner join carreras as h                                                     " & vbCrLf &_
"               on g.carr_ccod = h.carr_ccod                                         " & vbCrLf &_
"       inner join asignaturas as i                                                  " & vbCrLf &_
"               on g.asig_ccod = i.asig_ccod                                         " & vbCrLf &_
"       left outer join duracion_asignatura as j                                     " & vbCrLf &_
"                    on i.duas_ccod = j.duas_ccod                                    " & vbCrLf &_
"       inner join jornadas as jor                                                   " & vbCrLf &_
"               on g.jorn_ccod = jor.jorn_ccod                                       " & vbCrLf &_
"       inner join profesores as l                                                   " & vbCrLf &_
"               on a.pers_ncorr = l.pers_ncorr                                       " & vbCrLf &_
"       left outer join tipos_profesores as m                                        " & vbCrLf &_
"                    on l.tpro_ccod = m.tpro_ccod                                    " & vbCrLf &_
"       inner join malla_curricular as p                                             " & vbCrLf &_
"               on g.mall_ccod = p.mall_ccod                                         " & vbCrLf &_
"       inner join sedes as x                                                        " & vbCrLf &_
"               on e.sede_ccod = x.sede_ccod                                         " & vbCrLf &_
"       inner join procesos as z                                                     " & vbCrLf &_
"               on e.proc_ccod = z.proc_ccod                                         " & vbCrLf &_
"       inner join horas_docentes_seccion_final as hds                               " & vbCrLf &_
"               on f.secc_ccod = hds.secc_ccod                                       " & vbCrLf &_
"                  and e.pers_ncorr = hds.pers_ncorr                                 " & vbCrLf &_
"                  and e.tpro_ccod = hds.tpro_ccod                                   " & vbCrLf &_
"order  by sede_tdesc,                                                               " & vbCrLf &_
"          ap_paterno,                                                               " & vbCrLf &_
"          ap_materno,                                                               " & vbCrLf &_
"          nombre                                                                    "
'--------------------------------------------------------------------------------------------------------------------------fin consulta para SQLServqr 2008		   

'response.Write("<pre>"&consulta&"</pre>")
consulta="select '' where 1=2"
'f_listado.Consultar consulta'Fue solicitada la eliminación por parte de Gabriel Becerra en marzo de 2014
'--------------------------------------------------------------------------------------------------------------------------
'--------------------------------------------------------------------------------------------------------------------------
set f_listado_nuevos = new CFormulario
f_listado_nuevos.Carga_Parametros "parametros.xml", "tabla"
f_listado_nuevos.Inicializar conexion

'consulta_nuevos = " select distinct protic.obtiene_facultad_carrera(i.carr_ccod) as facultad,isnull(sexo_tdesc,'Sin informacion') as sexo,d.pers_nrut as RUT,d.pers_xdv as DV,d.pers_tnombre as nombre, d.pers_tape_paterno as ap_paterno,d.pers_tape_materno as ap_materno,  "& vbCrLf &_
'		   	"  (select top 1 cudo_titulo from curriculum_docente where pers_ncorr = a.pers_ncorr and grac_ccod in(1,2) order by grac_ccod desc) as profesion,  "& vbCrLf &_
'		   	"  b.anex_ncodigo as bloq_anexo,i.carr_tdesc, c.asig_ccod,(c.dane_nsesiones/2) as asig_nhoras,j.asig_tdesc, k.duas_tdesc, c.dane_msesion as bpro_mvalor,  "& vbCrLf &_
'		   	"  cast((c.dane_nsesiones/2)*c.dane_msesion as numeric) as valor,protic.trunc(a.cdoc_finicio) as fechai,protic.trunc(a.cdoc_ffin) as fechaf, "& vbCrLf &_
'		   	"  b.anex_nhoras_coordina as hor_coordinacion1,0 as hor_ccordinacion1,n.secc_tdesc,'--' as Porcentaje,0 as MontoMC, "& vbCrLf &_
'           	"  e.sede_tdesc, b.anex_ncuotas as num_cuotas, pea.peri_tdesc as semestre,jor.jorn_tdesc as jornada, "& vbCrLf &_
'		   	"  datediff(year,d.pers_fnacimiento,getDate()) as edad, " & vbCrLf &_
'		   	" protic.obtener_grado_docente(a.pers_ncorr,'G') as maximo_grado,protic.obtener_grado_docente(a.pers_ncorr,'D') as descripcion_grado,PROF_INGRESO_UAS as ano_ingreso, " & vbCrLf &_
'		    "  protic.trunc(b.anex_finicio) as fecha_inicio, protic.trunc(b.anex_ffin) as fecha_fin,o.tpro_tdesc as tipo_Profesor,  "& vbCrLf &_
'			"	cast( (c.dane_nsesiones*75)/60 as numeric) /case k.duas_tdesc when 'ANUAL'then 36 "& vbCrLf &_
'			"										  when 'SEMESTRAL' then 18 "& vbCrLf &_
'			"										  when 'TRIMESTRAL' then 12 "& vbCrLf &_
'			"										  when 'PERIODO' then 12 end  as hora_semana, "& vbCrLf &_
'           	"   (select top 1 jdoc_tdesc from profesores pro, jerarquias_docentes jd where pro.pers_ncorr=a.pers_ncorr and pro.jdoc_ccod=jd.jdoc_ccod ) as jerarquia, "& vbCrLf &_
'           	"   (select top 1 protic.trunc(per.pers_fnacimiento) from personas per where per.pers_ncorr=a.pers_ncorr ) as cumple,isnull(q.tcdo_tdesc,'Honorarios') as tipo_contrato,  "& vbCrLf &_  
'		   	" g.dire_tcalle+ ' '+g.dire_tnro as direccion, h.ciud_tdesc+' - '+h.ciud_tcomuna as c_c "& vbCrLf &_
'			"  From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  "& vbCrLf &_
'		   	"       sedes e, estados_civiles f,direcciones g, ciudades h, carreras i,jornadas jor,periodos_Academicos pea,  "& vbCrLf &_
'		   	"       asignaturas j,duracion_asignatura k,instituciones l,paises m, secciones n,tipos_profesores o,profesores p, "& vbCrLf &_
'			"       tipos_contratos_docentes q , sexos r  "& vbCrLf &_
'		   	"  Where a.cdoc_ncorr     =   b.cdoc_ncorr  "& vbCrLf &_
'		   	"     and b.anex_ncorr    =   c.anex_ncorr  "& vbCrLf &_
'		   	"     and a.pers_ncorr    =   d.pers_ncorr  "& vbCrLf &_
'		   	"	  and b.sede_ccod     =   e.sede_ccod  "& vbCrLf &_
'		   	"     and d.eciv_ccod     =   f.eciv_ccod  "& vbCrLf &_
'		   	"     and g.ciud_ccod     =   h.ciud_ccod  "& vbCrLf &_
'		   	"     and g.pers_ncorr    =   a.pers_ncorr  "& vbCrLf &_
'		   	"     and g.tdir_ccod     =   1  "& vbCrLf &_
'		   	"     and b.carr_ccod     =   i.carr_ccod  "& vbCrLf &_
'			" 	  and n.peri_ccod	  =   pea.peri_ccod "& vbCrLf &_
'			" 	  and n.jorn_ccod 	  =   jor.jorn_ccod "& vbCrLf &_
'		   	"     and c.asig_ccod     =   j.asig_ccod  "& vbCrLf &_
'		   	"     and c.duas_ccod     =   k.duas_ccod  "& vbCrLf &_
'		   	"     and l.INST_CCOD     =   1  "& vbCrLf &_
'		    "     and isnull(M.PAIS_CCOD,1)     =   isnull(d.PAIS_CCOD,1)  "& vbCrLf &_
'		   	"     and n.secc_ccod     =   c.secc_ccod  "& vbCrLf &_
'		   	"     and o.TPRO_CCOD     =   p.TPRO_CCOD  "& vbCrLf &_
'		   	"     and p.pers_ncorr    =   d.pers_ncorr  "& vbCrLf &_
'		   	"	  AND b.SEDE_CCOD     =   p.sede_ccod "& vbCrLf &_
'		   	"     and a.ecdo_ccod     =   "&ecdo_ccod&" "& vbCrLf &_
'		   	"	  and a.ano_contrato  =   "&anos_ccod&" "& vbCrLf &_
'           	"     and b.eane_ccod     <>  3 "& vbCrLf &_
'			" 	  and a.tcdo_ccod *=q.tcdo_ccod "& vbCrLf &_
'			" 	  and d.sexo_ccod *=r.sexo_ccod "	

'--------------------------------------------------------------------------------------------------------------------------inicio consulta para SQLServqr 2008	
consulta_nuevos = " select distinct protic.obtiene_facultad_carrera(i.carr_ccod)               as " & vbCrLf &_
"                facultad,                                                                        " & vbCrLf &_
"                isnull(sexo_tdesc, 'Sin informacion')                      as                    " & vbCrLf &_
"                sexo,                                                                            " & vbCrLf &_
"                d.pers_nrut                                                as                    " & vbCrLf &_
"                rut,                                                                             " & vbCrLf &_
"                d.pers_xdv                                                 as dv                 " & vbCrLf &_
"                ,                                                                                " & vbCrLf &_
"                d.pers_tnombre                                                                   " & vbCrLf &_
"                as nombre,                                                                       " & vbCrLf &_
"                d.pers_tape_paterno                                        as                    " & vbCrLf &_
"                ap_paterno,                                                                      " & vbCrLf &_
"                d.pers_tape_materno                                        as                    " & vbCrLf &_
"                ap_materno,                                                                      " & vbCrLf &_
"                (select top 1 cudo_titulo                                                        " & vbCrLf &_
"                 from   curriculum_docente                                                       " & vbCrLf &_
"                 where  pers_ncorr = a.pers_ncorr                                                " & vbCrLf &_
"                        and grac_ccod in( 1, 2 )                                                 " & vbCrLf &_
"                 order  by grac_ccod desc)                                 as                    " & vbCrLf &_
"                profesion,                                                                       " & vbCrLf &_
"                b.anex_ncodigo                                             as                    " & vbCrLf &_
"                bloq_anexo,                                                                      " & vbCrLf &_
"                i.carr_tdesc,                                                                    " & vbCrLf &_
"                c.asig_ccod,                                                                     " & vbCrLf &_
"                ( c.dane_nsesiones / 2 )                                   as                    " & vbCrLf &_
"                asig_nhoras,                                                                     " & vbCrLf &_
"                j.asig_tdesc,                                                                    " & vbCrLf &_
"                k.duas_tdesc,                                                                    " & vbCrLf &_
"                c.dane_msesion                                             as                    " & vbCrLf &_
"                bpro_mvalor,                                                                     " & vbCrLf &_
"                cast(( c.dane_nsesiones / 2 ) * c.dane_msesion as numeric) as                    " & vbCrLf &_
"                valor,                                                                           " & vbCrLf &_
"                protic.trunc(a.cdoc_finicio)                               as                    " & vbCrLf &_
"                fechai,                                                                          " & vbCrLf &_
"                protic.trunc(a.cdoc_ffin)                                  as                    " & vbCrLf &_
"                fechaf,                                                                          " & vbCrLf &_
"                b.anex_nhoras_coordina                                     as                    " & vbCrLf &_
"                hor_coordinacion1,                                                               " & vbCrLf &_
"                0                                                          as                    " & vbCrLf &_
"                hor_ccordinacion1,                                                               " & vbCrLf &_
"                n.secc_tdesc,                                                                    " & vbCrLf &_
"                '--'                                                       as                    " & vbCrLf &_
"                porcentaje,                                                                      " & vbCrLf &_
"                0                                                          as                    " & vbCrLf &_
"                montomc,                                                                         " & vbCrLf &_
"                e.sede_tdesc,                                                                    " & vbCrLf &_
"                b.anex_ncuotas                                             as                    " & vbCrLf &_
"                num_cuotas,                                                                      " & vbCrLf &_
"                pea.peri_tdesc                                             as                    " & vbCrLf &_
"                semestre,                                                                        " & vbCrLf &_
"                jor.jorn_tdesc                                             as                    " & vbCrLf &_
"                jornada,                                                                         " & vbCrLf &_
"                datediff(year, d.pers_fnacimiento, getdate())              as                    " & vbCrLf &_
"                edad,                                                                            " & vbCrLf &_
"                protic.obtener_grado_docente(a.pers_ncorr, 'G')            as                    " & vbCrLf &_
"                maximo_grado,                                                                    " & vbCrLf &_
"                protic.obtener_grado_docente(a.pers_ncorr, 'D')            as                    " & vbCrLf &_
"                descripcion_grado,                                                               " & vbCrLf &_
"                prof_ingreso_uas                                           as                    " & vbCrLf &_
"                ano_ingreso,                                                                     " & vbCrLf &_
"                protic.trunc(b.anex_finicio)                               as                    " & vbCrLf &_
"                fecha_inicio,                                                                    " & vbCrLf &_
"                protic.trunc(b.anex_ffin)                                  as                    " & vbCrLf &_
"                fecha_fin,                                                                       " & vbCrLf &_
"                o.tpro_tdesc                                               as                    " & vbCrLf &_
"                tipo_profesor,                                                                   " & vbCrLf &_
"                cast(( c.dane_nsesiones * 75 ) / 60 as numeric) /                                " & vbCrLf &_
"                case                                                                             " & vbCrLf &_
"                k.duas_tdesc                                                                     " & vbCrLf &_
"                when 'ANUAL'then 36                                                              " & vbCrLf &_
"                when 'SEMESTRAL' then 18                                                         " & vbCrLf &_
"                when 'TRIMESTRAL' then 12                                                        " & vbCrLf &_
"                when 'PERIODO' then 12                                                           " & vbCrLf &_
"                                                                  end      as                    " & vbCrLf &_
"                hora_semana,                                                                     " & vbCrLf &_
" (select count(*) from cargas_Academicas carg where carg.secc_ccod=c.secc_ccod) as num_alumnos,  " & vbCrLf &_
"                (select top 1 jdoc_tdesc                                                         " & vbCrLf &_
"                 from   profesores pro,                                                          " & vbCrLf &_
"                        jerarquias_docentes jd                                                   " & vbCrLf &_
"                 where  pro.pers_ncorr = a.pers_ncorr                                            " & vbCrLf &_
"                        and pro.jdoc_ccod = jd.jdoc_ccod)                  as                    " & vbCrLf &_
"                jerarquia,                                                                       " & vbCrLf &_
"                (select top 1 protic.trunc(per.pers_fnacimiento)                                 " & vbCrLf &_
"                 from   personas per                                                             " & vbCrLf &_
"                 where  per.pers_ncorr = a.pers_ncorr)                     as                    " & vbCrLf &_
"                cumple,                                                                          " & vbCrLf &_
"                isnull(q.tcdo_tdesc, 'Honorarios')                         as                    " & vbCrLf &_
"                tipo_contrato,                                                                   " & vbCrLf &_
"                g.dire_tcalle + ' ' + g.dire_tnro                          as                    " & vbCrLf &_
"                direccion,                                                                       " & vbCrLf &_
"                h.ciud_tdesc + ' - ' + h.ciud_tcomuna                      as                    " & vbCrLf &_
"                c_c,                                                                              " & vbCrLf &_
"	             isnull((select top 1 tjdo_tdesc from profesores tt, tipo_jornada_docente t2 where tt.tjdo_ccod=t2.tjdo_ccod and tt.pers_ncorr=a.pers_ncorr),'') as tipo_jornada, " & vbCrLf &_
"                isnull((select top 1 tido_tdesc from anos_tipo_docente tt, tipos_docente t2 where tt.tido_ccod=t2.tido_ccod and tt.pers_ncorr=a.pers_ncorr),'') as tipo_docente " & vbCrLf &_
"from   contratos_docentes_upa as a                                                               " & vbCrLf &_
"       inner join anexos as b                                                                    " & vbCrLf &_
"               on a.cdoc_ncorr = b.cdoc_ncorr                                                    " & vbCrLf &_
"                  and b.eane_ccod <> 3                                                           " & vbCrLf &_
"       inner join detalle_anexos as c                                                            " & vbCrLf &_
"               on b.anex_ncorr = c.anex_ncorr                                                    " & vbCrLf &_
"       inner join personas as d                                                                  " & vbCrLf &_
"               on a.pers_ncorr = d.pers_ncorr                                                    " & vbCrLf &_
"       inner join sedes as e                                                                     " & vbCrLf &_
"               on b.sede_ccod = e.sede_ccod                                                      " & vbCrLf &_
"       inner join estados_civiles as f                                                           " & vbCrLf &_
"               on d.eciv_ccod = f.eciv_ccod                                                      " & vbCrLf &_
"       inner join direcciones as g                                                               " & vbCrLf &_
"               on a.pers_ncorr = g.pers_ncorr                                                    " & vbCrLf &_
"                  and g.tdir_ccod = 1                                                            " & vbCrLf &_
"       inner join ciudades as h                                                                  " & vbCrLf &_
"               on g.ciud_ccod = h.ciud_ccod                                                      " & vbCrLf &_
"       inner join carreras as i                                                                  " & vbCrLf &_
"               on b.carr_ccod = i.carr_ccod                                                      " & vbCrLf &_
"       inner join secciones as n                                                                 " & vbCrLf &_
"               on c.secc_ccod = n.secc_ccod                                                      " & vbCrLf &_
"       inner join periodos_academicos as pea                                                     " & vbCrLf &_
"               on n.peri_ccod = pea.peri_ccod                                                    " & vbCrLf &_
"       inner join asignaturas as j                                                               " & vbCrLf &_
"               on c.asig_ccod = j.asig_ccod                                                      " & vbCrLf &_
"       inner join duracion_asignatura as k                                                       " & vbCrLf &_
"               on c.duas_ccod = k.duas_ccod                                                      " & vbCrLf &_
"       inner join instituciones as l                                                             " & vbCrLf &_
"               on l.inst_ccod = 1                                                                " & vbCrLf &_
"       inner join paises as m                                                                    " & vbCrLf &_
"               on isnull(m.pais_ccod, 1) = isnull(d.pais_ccod, 1)                                " & vbCrLf &_
"       inner join jornadas as jor                                                                " & vbCrLf &_
"               on n.jorn_ccod = jor.jorn_ccod                                                    " & vbCrLf &_
"       inner join profesores as p                                                                " & vbCrLf &_
"               on b.sede_ccod = p.sede_ccod                                                      " & vbCrLf &_
"                  and d.pers_ncorr = p.pers_ncorr                                                " & vbCrLf &_
"       inner join tipos_profesores as o                                                          " & vbCrLf &_
"               on p.tpro_ccod = o.tpro_ccod                                                      " & vbCrLf &_
"       left outer join tipos_contratos_docentes as q                                             " & vbCrLf &_
"                    on a.tcdo_ccod = q.tcdo_ccod                                                 " & vbCrLf &_
"       left outer join sexos as r                                                                " & vbCrLf &_
"                    on d.sexo_ccod = r.sexo_ccod                                                 " & vbCrLf &_
"where  a.ecdo_ccod = "&ecdo_ccod&"                                                               " & vbCrLf &_
"       and a.ano_contrato = "&anos_ccod&"                                                        "
'--------------------------------------------------------------------------------------------------------------------------fin consulta para SQLServqr 2008		   

'response.Write("<pre>"&consulta_nuevos&"</pre>")
f_listado_nuevos.Consultar consulta_nuevos
'response.End()

%>
<html>
<head>
<title>clasificacion por grado academico</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado 
        Presupuestos Docentes </font></div>
      <div align="right"></div></td>
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="10%"><strong>Fecha</strong></td>
    <td width="90%" colspan="3"><strong>:</strong> <%=fecha_01%></td>
  </tr>
</table>

<p>&nbsp;</p>
<table width="100%" border="1">
<!--  <tr> 
    <td width="2"><div align="left"><strong>N°</strong></div></td>
    <td width="8%"><div align="left"><strong>R.U.T.</strong></div></td>
    <td width="15%"><div align="center"><strong>NOMBRE DOCENTE</strong></div></td>
	<td width="15%"><div align="center"><strong>SEXO</strong></div></td>
    <td width="15%"><div align="center"><strong>PROFESIÓN</strong></div></td>
	<td width="5%"><div align="left"><strong>TIPO PROFESOR</strong></div></td>
	<td width="5%"><div align="center"><strong>FACULTAD</strong></div></td>
	<td width="5%"><div align="center"><strong>SEDE</strong></div></td>
	<td width="10%"><div align="center"><strong>CARRERA</strong></div></td>
	<td width="2%"><div align="left"><strong>JORNADA</strong></div></td>
    <td width="3%"><div align="center"><strong>COD ASIGNATURA</strong></div></td>
	<td width="10%"><div align="left"><strong>ASIGNATURA</strong></div></td>
	<td width="2%"><div align="left"><strong>SECCIÓN</strong></div></td>
	<td width="2%"><div align="left"><strong>SEMESTRE</strong></div></td>
    <td width="5%"><div align="center"><strong>HORAS DOCENTE</strong></div></td>
    <td width="5%"><div align="center"><strong>DURACIÓN</strong></div></td>
	<td width="5%"><div align="center"><strong>VALOR SECCION</strong></div></td>
	<td width="8%"><div align="center"><strong>TOTAL PAGAR</strong></div></td>
    <td width="3%"><div align="center"><strong>CUOTAS</strong></div></td>
	<td width="5%"><div align="left"><strong>FECHA INICIO</strong></div></td>
    <td width="5%"><div align="center"><strong>FECHA FIN</strong></div></td>
    <td width="5%"><div align="center"><strong>HORAS_COORDINACIÓN</strong></div></td>
  </tr>
  
  <%'  fila = 1
    'while f_listado.Siguiente %>
  <tr> 
    <td><div align="left"><%'=fila%></div></td>
	<td><div align="left"><%'=f_listado.ObtenerValor("rut")%>-<%'=f_listado.ObtenerValor("dv")%></div></td>
    <td><div align="center"><%'=f_listado.ObtenerValor("nombre")%>&nbsp;<%'=f_listado.ObtenerValor("ap_paterno")%>&nbsp;<%'=f_listado.ObtenerValor("ap_materno")%></div></td>
	<td><div align="center"><%'=f_listado.ObtenerValor("profesion")%></div></td>
    <td><div align="center"><%'=f_listado.ObtenerValor("tipo_profesor")%></div></td>
	<td><div align="center"><%'=f_listado.ObtenerValor("sede_tdesc")%></div></td>
	<td><div align="center"><%'=f_listado.ObtenerValor("carr_tdesc")%></div></td>
	<td><div align="center"><%'=f_listado.ObtenerValor("jornada")%></div></td>
	<td><div align="center"><%'=f_listado.ObtenerValor("asig_ccod")%></div></td>
	<td><div align="center"><%'=f_listado.ObtenerValor("asig_tdesc")%></div></td>
	<td><div align="center"><%'=f_listado.ObtenerValor("secc_tdesc")%></div></td>
	<td><div align="center"><%'=f_listado.ObtenerValor("semestre")%></div></td>
	<td><div align="center"><%'=f_listado.ObtenerValor("asig_nhoras")%></div></td>
	<td><div align="center"><%'=f_listado.ObtenerValor("duas_tdesc")%></div></td>
	<td><div align="center"><%'=f_listado.ObtenerValor("bpro_mvalor")%></div></td>
	<td><div align="center"><%'=f_listado.ObtenerValor("valor")%></div></td>
	<td><div align="center"><%'=f_listado.ObtenerValor("num_cuotas")%></div></td>
	<td><div align="center"><%'=f_listado.ObtenerValor("fecha_inicio")%></div></td>
	<td><div align="center"><%'=f_listado.ObtenerValor("fecha_fin")%></div></td>
	<td><div align="center"><%'=f_listado.ObtenerValor("hor_coordinacion1")%></div></td>
  </tr>
  <%' fila=fila + 1
  'wend %>
  <tr>
     <td colspan="18">&nbsp;</td>
  </tr>
  <tr>
     <td colspan="18" bgcolor="#FFFFCC" align="left"><strong><font size="+1">PRESUPUESTO DOCENTES CONTRATADOS CON SISTEMA NUEVO</font></strong></td>
  </tr>
  <tr>
     <td colspan="18">&nbsp;</td>
  </tr>-->
  <tr> 
    <td><div align="left"><strong>N°</strong></div></td>
    <td><div align="left"><strong>R.U.T.</strong></div></td>
    <td><div align="center"><strong>NOMBRE DOCENTE</strong></div></td>
	<td><div align="center"><strong>EDAD</strong></div></td>
	<td><div align="center"><strong>SEXO</strong></div></td>
    <td><div align="center"><strong>PROFESIÓN</strong></div></td>
	<td><div align="left"><strong>TIPO PROFESOR</strong></div></td>
	<td><div align="center"><strong>FACULTAD</strong></div></td>
	<td><div align="center"><strong>SEDE</strong></div></td>
	<td><div align="center"><strong>CARRERA</strong></div></td>
	<td><div align="center"><strong>JORNADA</strong></div></td>
    <td><div align="center"><strong>COD ASIGNATURA</strong></div></td>
	<td><div align="left"><strong>ASIGNATURA</strong></div></td>
	<td><div align="left"><strong>SECCIÓN</strong></div></td>
	<td><div align="center"><strong>SEMESTRE</strong></div></td>
    <td><div align="center"><strong>HORAS DOCENTE</strong></div></td>
    <td><div align="center"><strong>DURACIÓN</strong></div></td>
	<td><div align="center"><strong>VALOR SECCION</strong></div></td>
	<td><div align="center"><strong>TOTAL PAGAR</strong></div></td>
    <td><div align="center"><strong>CUOTAS</strong></div></td>
	<td><div align="left"><strong>FECHA INICIO</strong></div></td>
    <td><div align="center"><strong>FECHA FIN</strong></div></td>
    <td><div align="center"><strong>HORAS_COORDINACIÓN</strong></div></td>
	<td><div align="center"><strong>MÁXIMO GRADO</strong></div></td>
	<td><div align="center"><strong>DESCRIPCION GRADO</strong></div></td>
	<td><div align="center"><strong>ANO INGRESO</strong></div></td>
	<td><div align="center"><strong>HORA SEMANA</strong></div></td>
    <td><div align="center"><strong>JERARQUIA</strong></div></td>
    <td><div align="center"><strong>TIPO JORNADA</strong></div></td>
    <td><div align="center"><strong>TIPO DOCENTE</strong></div></td>
    <td><div align="center"><strong>CUMPLEAÑOS</strong></div></td>
    <td><div align="center"><strong>TIPO CONTRATO</strong></div></td>
    <td><div align="center"><strong>DIRECCION</strong></div></td>
    <td><div align="center"><strong>COMUNA-CIUDAD</strong></div></td>
    <td><div align="center"><strong>N° Alumnos</strong></div></td>
  </tr>
  <%  fila_2 = 1
    while f_listado_nuevos.Siguiente %>
  <tr> 
    <td><div align="left"><%=fila_2%></div></td>
	<td><div align="left"><%=f_listado_nuevos.ObtenerValor("rut")%>-<%=f_listado_nuevos.ObtenerValor("dv")%></div></td>
    <td><div align="center"><%=f_listado_nuevos.ObtenerValor("nombre")%>&nbsp;<%=f_listado_nuevos.ObtenerValor("ap_paterno")%>&nbsp;<%=f_listado_nuevos.ObtenerValor("ap_materno")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("edad")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("sexo")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("profesion")%></div></td>
    <td><div align="center"><%=f_listado_nuevos.ObtenerValor("tipo_profesor")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("facultad")%></div></td>	
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("sede_tdesc")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("carr_tdesc")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("jornada")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("asig_ccod")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("asig_tdesc")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("secc_tdesc")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("semestre")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("asig_nhoras")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("duas_tdesc")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("bpro_mvalor")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("valor")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("num_cuotas")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("fecha_inicio")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("fecha_fin")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("hor_coordinacion1")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("maximo_grado")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("descripcion_grado")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("ano_ingreso")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("hora_semana")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("jerarquia")%></div></td>
    <td><div align="center"><%=f_listado_nuevos.ObtenerValor("tipo_jornada")%></div></td>
    <td><div align="center"><%=f_listado_nuevos.ObtenerValor("tipo_docente")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("cumple")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("tipo_contrato")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("direccion")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("c_c")%></div></td>
    <td><div align="center"><%=f_listado_nuevos.ObtenerValor("num_alumnos")%></div></td>
  </tr>
  <% fila_2 = fila_2 + 1
  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>
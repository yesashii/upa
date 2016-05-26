select aa.sede,aa.pers_ncorr,aa.rut,aa.nombre_docente,cc.sexo_tdesc as genero,aa.tipo_profesor,
aa.grado,aa.descripcion_grado, sum(hora_semana) as horas_semanales
from  (
    select aa.carr_ccod,regimen,max(coordinacion) as horas_coordinacion,
        case sede when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,
        aa.pers_ncorr,protic.obtener_rut(aa.pers_ncorr) as rut,nombre_docente,tipo_profesor,
        protic.obtener_grado_docente(aa.pers_ncorr,'G') as grado,
        protic.obtener_grado_docente(aa.pers_ncorr,'D') as descripcion_grado,
        (((max(coordinacion)*75)+(sum(horas)*75))/60)/case regimen when 'ANUAL'then 36 
                                  when 'SEMESTRAL'then 18
                                  when 'TRIMESTRAL'then 12
                                  when 'PERIODO'then 12 end  as hora_semana 
            from (
	            select   distinct protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre_docente,A.CDOC_NCORR, CASE M.TPRO_CCOD WHEN 1 THEN isnull(E.HCOR_Valor1,0) ELSE 0 END as coordinacion 
                        , cast(ISNULL((CASE G.MODA_CCOD WHEN 1 THEN isnull(Y.hopr_nhoras ,protic.retorna_horas_seccion1(f.secc_ccod,m.TPRO_CCOD,e.pers_ncorr)) ELSE G.secc_nhoras_pagar  END)/2 ,0) as numeric) AS horas
			            , E.BLOQ_ANEXO, G.CARR_CCOD , A.PERS_NCORR, A.CDOC_FCONTRATO_Ini, A.CDOC_FCONTRATO_Fin
			            , G.ASIG_CCOD, J.DUAS_TDESC as regimen, E.BPRO_MVALOR
			            , ISNULL(CASE G.MODA_CCOD WHEN 1 THEN  (E.BPRO_MVALOR * (isnull(Y.hopr_nhoras ,protic.retorna_horas_seccion1(f.secc_ccod,m.TPRO_CCOD,e.pers_ncorr))/2)) ELSE (E.BPRO_MVALOR * (G.secc_nhoras_pagar/2)) END ,0)/*(E.BPRO_MVALOR * (I.ASIG_NHORAS/2))*/ AS Valor
                        , X.SEDE_TDESC as sede ,M.TPRO_TDESC AS TIPO_PROFESOR
			            , convert(varchar(10), A.CDOC_FCONTRATO_Ini,103) as FechaI
			            , convert(varchar(10), A.CDOC_FCONTRATO_Fin, 103) as FechaF
			            , convert(varchar(10), A.CDOC_FCONTRATO_Fin1, 103) as FechaF1
			            , cast(P.NIVE_CCOD as varchar) + '-' + cast(G.SECC_TDESC as varchar) as SECC_TDESC
                     ,CASE J.DUAS_CCOD WHEN 1 THEN Z.PROC_CUOTAS_TRIMESTRAL WHEN 2 THEN Z.PROC_CUOTAS_SEMESTRAL WHEN 3 THEN Z.PROC_CUOTAS_ANUAL WHEN 4 THEN Z.PROC_CUOTAS_ANUAL WHEN 5 THEN Z.PROC_CUOTAS_SEMESTRAL END AS num_cuotas
                     ,case J.DUAS_CCOD WHEN 5 then protic.trunc(Z.PROC_FINICIO) else protic.trunc(Z.PROC_FINICIO) end AS FECHA_INICIO
                     ,protic.trunc(CASE J.DUAS_CCOD WHEN 1 THEN Z.PROC_FFIN_TRIMESTRAL WHEN 2 THEN Z.PROC_FFIN_SEMESTRAL WHEN 3 THEN Z.PROC_FFIN_ANUAL WHEN 4 THEN Z.PROC_FFIN_ANUAL WHEN 5 THEN Z.PROC_FFIN_SEMESTRAL END) AS FECHA_FIN
	            from CONTRATOS_DOCENTES	A, PERSONAS B, 
		            BLOQUES_PROFESORES E, BLOQUES_horarios F, 
		            SECCIONES G, CARRERAS H, ASIGNATURAS I, DURACION_ASIGNATURA J, 
		            PROFESORES L, TIPOS_PROFESORES M, MALLA_CURRICULAR P,SEDES X,
		            PROCESOS Z,horas_profesores Y
	            where B.PERS_NCORR = A.PERS_NCORR
			            and E.PERS_NCORR = A.PERS_NCORR
			            and E.CDOC_NCORR	= A.CDOC_NCORR	
                        --and A.PERS_NCORR in (23804,17746,24256,24220)
			            and F.BLOQ_CCOD = E.BLOQ_CCOD
			            and G.SECC_CCOD = F.SECC_CCOD
			            AND H.CARR_CCOD = G.CARR_CCOD
			            AND I.ASIG_CCOD = G.ASIG_CCOD
			            and J.DUAS_CCOD =* I.DUAS_CCOD
			            and L.PERS_NCORR = A.PERS_NCORR
			            and M.TPRO_CCOD =* L.TPRO_CCOD
			            and P.MALL_CCOD = G.MALL_CCOD
                        AND E.SEDE_CCOD = X.SEDE_CCOD 
			            AND E.PROC_CCOD = Z.PROC_CCOD
			            AND E.SEDE_CCOD = l.sede_ccod
			            and E.PERS_NCORR*=Y.pers_ncorr
                        and F.SECC_CCOD *=Y.secc_ccod
			            and Y.hopr_nhoras > 0
                        and datepart(year,a.CDOC_FCONTRATO_Ini)=2005
                        and convert(datetime,A.CDOC_FCONTRATO_Ini,103)<=convert(datetime,'30/04/2005',103)

            ) as aa, carreras b
            where aa.carr_ccod=b.carr_ccod
            and b.tcar_ccod=1
        group by aa.pers_ncorr,aa.horas,aa.carr_ccod,aa.sede,aa.regimen,aa.nombre_docente,aa.tipo_profesor
) aa, personas bb, sexos cc
where aa.pers_ncorr=bb.pers_ncorr
and bb.sexo_ccod=cc.sexo_ccod
and aa.grado in ('TECNICO')
group by aa.sede,aa.pers_ncorr,aa.rut,aa.nombre_docente,cc.sexo_tdesc,aa.tipo_profesor,aa.grado,aa.descripcion_grado
having sum(hora_semana) >=33

UNION 

select distinct case d.sede_tdesc when 'MELIPILLA' then 'MELIPILLA' else 'SANTIAGO' end as sede,a.pers_ncorr,
    protic.obtener_rut(a.pers_ncorr) as rut,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente,
    h.sexo_tdesc as genero,f.tpro_tdesc as tipo_profesor,protic.obtener_grado_docente(a.pers_ncorr,'G') as grado,
    protic.obtener_grado_docente(a.pers_ncorr,'D') as descripcion_grado,45 as horas_semanales
    from contratos_docentes a,bloques_profesores b,administrativos_docentes c,
    sedes d,profesores e,tipos_profesores f,personas g,sexos h 
    where a.pers_ncorr      =   b.pers_ncorr
        and a.cdoc_ncorr    =   b.cdoc_ncorr
        and b.pers_ncorr    =   c.pers_ncorr
        and b.sede_ccod     =   d.sede_ccod
        and b.pers_ncorr    =   e.pers_ncorr
        and b.sede_ccod     =   e.sede_ccod
        and e.tpro_ccod     =   f.tpro_ccod
        and a.pers_ncorr    =   g.pers_ncorr
        and g.sexo_ccod     =   h.sexo_ccod
        and a.peri_ccod     =   164
        and admd_jornada    = 1
        and a.pers_ncorr not in (27208)
        and datepart(year,a.cdoc_fcontrato_ini)=2005
        and convert(datetime,a.cdoc_fcontrato_ini,103)<=convert(datetime,'30/04/2005',103)
        and protic.obtener_grado_docente(a.pers_ncorr,'G') in ('TECNICO')
        and bloq_ccod in (
            select distinct bloq_ccod from bloques_horarios a, secciones b, carreras c
            where a.secc_ccod=b.secc_ccod
            and b.carr_ccod=c.carr_ccod
            and c.tcar_ccod=1
            and b.peri_ccod=164
        )



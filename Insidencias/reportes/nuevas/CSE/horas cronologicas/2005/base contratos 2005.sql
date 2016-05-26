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
            and A.PERS_NCORR in (23804,17746,24256,24220)
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


<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=listado_presupuestos.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

periodo = negocio.obtenerPeriodoAcademico("CLASES18")

fecha_01=conexion.consultaUno("select convert(datetime,getDate(),103) as fecha")
anos_ccod = conexion.consultaUno("select anos_ccod from periodos_Academicos where cast(peri_ccod as varchar)='"&periodo&"'")
set f_listado = new CFormulario
f_listado.Carga_Parametros "parametros.xml", "tabla"
f_listado.Inicializar conexion

consulta = " select distinct CAST(B.PERS_NRUT AS VARCHAR) as Rut "& vbCrLf &_
		   "			, PERS_XDV as DV "& vbCrLf &_
		   "			, ISNULL(B.PERS_TNOMBRE, '') as nombre, ISNULL(B.PERS_TAPE_PATERNO, '') as ap_paterno , ISNULL(B.PERS_TAPE_MATERNO, '') as ap_materno "& vbCrLf &_
		   "			, (SELECT TOP 1 CUDO_TITULO FROM CURRICULUM_DOCENTE WHERE PERS_NCORR = A.PERS_NCORR AND GRAC_CCOD IN(1,2) ORDER BY GRAC_CCOD DESC) AS PROFESION "& vbCrLf &_
		   "			,  E.BLOQ_ANEXO, H.CARR_TDESC, G.ASIG_CCOD "& vbCrLf &_
		   "			, ISNULL(CASE G.MODA_CCOD WHEN 1 THEN HDS.HORAS ELSE G.secc_nhoras_pagar  END ,0) AS ASIG_NHORAS "& vbCrLf &_
		   "			, I.ASIG_TDESC	, J.DUAS_TDESC, cast(E.BPRO_MVALOR as numeric) as bpro_mvalor "& vbCrLf &_
		   "			, cast(ISNULL(CASE G.MODA_CCOD WHEN 1 THEN  (E.BPRO_MVALOR * (HDS.HORAS /2)) ELSE (E.BPRO_MVALOR * (G.secc_nhoras_pagar/2)) END ,0) as numeric) AS Valor "& vbCrLf &_
		   "			, convert(varchar(10), A.CDOC_FCONTRATO_Ini,103) as FechaI "& vbCrLf &_
		   "			, convert(varchar(10), A.CDOC_FCONTRATO_Fin, 103) as FechaF "& vbCrLf &_
		   "			, isnull(E.HCOR_Valor1,0) as HOR_COORDINACION1 "& vbCrLf &_
		   "			, isnull(E.HCOR_Valor2,0) AS HOR_COORDINACION1 "& vbCrLf &_
		   "			, cast(P.NIVE_CCOD as varchar) + '-' + cast(G.SECC_TDESC as varchar) as SECC_TDESC "& vbCrLf &_
		   "			, A.Porcentaje "& vbCrLf &_
		   "			, A.MontoMC "& vbCrLf &_
		   "			, X.SEDE_TDESC, pea.peri_tdesc as semestre,jor.jorn_tdesc as jornada "& vbCrLf &_
		   "         ,CASE J.DUAS_CCOD WHEN 1 THEN Z.PROC_CUOTAS_TRIMESTRAL WHEN 2 THEN Z.PROC_CUOTAS_SEMESTRAL WHEN 3 THEN Z.PROC_CUOTAS_ANUAL WHEN 4 THEN Z.PROC_CUOTAS_ANUAL WHEN 5 THEN protic.OBTENER_CUOTAS_PERIODO(G.SECC_CCOD) END AS num_cuotas "& vbCrLf &_
		   "         ,case J.DUAS_CCOD WHEN 5 then protic.trunc(G.SECC_FINICIO_SEC) else protic.trunc(Z.PROC_FINICIO) end AS FECHA_INICIO "& vbCrLf &_
		   "         ,protic.trunc(CASE J.DUAS_CCOD WHEN 1 THEN Z.PROC_FFIN_TRIMESTRAL WHEN 2 THEN Z.PROC_FFIN_SEMESTRAL WHEN 3 THEN Z.PROC_FFIN_ANUAL WHEN 4 THEN Z.PROC_FFIN_ANUAL WHEN 5 THEN G.SECC_FTERMINO_SEC END) AS FECHA_FIN "& vbCrLf &_
		   "         ,M.TPRO_TDESC AS TIPO_PROFESOR "& vbCrLf &_
		   "	from    CONTRATOS_DOCENTES	A, PERSONAS B, "& vbCrLf &_
		   "   		    BLOQUES_PROFESORES E, BLOQUES_horarios F,PERIODOS_ACADEMICOS PEA,  "& vbCrLf &_
		   "		    SECCIONES G, CARRERAS H, ASIGNATURAS I, DURACION_ASIGNATURA J,jornadas jor, "& vbCrLf &_
		   "		    PROFESORES L, TIPOS_PROFESORES M, PAISES N, ESTADOS_CIVILES O, MALLA_CURRICULAR P,SEDES X,PROCESOS Z,HORAS_DOCENTES_SECCION_FINAL HDS "& vbCrLf &_
		   "	where B.PERS_NCORR = A.PERS_NCORR "& vbCrLf &_
		   "			and E.PERS_NCORR = A.PERS_NCORR "& vbCrLf &_
		   "			and E.CDOC_NCORR	= A.CDOC_NCORR	"& vbCrLf &_
		   "			and F.BLOQ_CCOD = E.BLOQ_CCOD "& vbCrLf &_
		   "			and G.SECC_CCOD = F.SECC_CCOD "& vbCrLf &_
		   "			AND H.CARR_CCOD = G.CARR_CCOD "& vbCrLf &_
		   "			AND I.ASIG_CCOD = G.ASIG_CCOD "& vbCrLf &_
		   "			and J.DUAS_CCOD =* I.DUAS_CCOD "& vbCrLf &_
		   "			and L.PERS_NCORR = A.PERS_NCORR "& vbCrLf &_
		   "			and M.TPRO_CCOD =* L.TPRO_CCOD "& vbCrLf &_
		   "			and N.PAIS_CCOD = B.PAIS_CCOD "& vbCrLf &_
		   "			and O.ECIV_CCOD = B.ECIV_CCOD "& vbCrLf &_
		   "			and P.MALL_CCOD = G.MALL_CCOD and g.jorn_ccod = jor.jorn_ccod"& vbCrLf &_
		   "			and G.PERI_CCOD = PEA.PERI_CCOD "& vbCrLf &_
		   "			and cast(PEA.ANOS_CCOD as varchar) = '"&anos_ccod&"'"& vbCrLf &_
		   "            AND F.SECC_CCOD = HDS.SECC_CCOD "& vbCrLf &_
		   "            AND E.PERS_NCORR = HDS.PERS_NCORR "& vbCrLf &_
		   "            AND E.TPRO_CCOD = HDS.TPRO_CCOD "& vbCrLf &_
		   "            AND E.SEDE_CCOD = X.SEDE_CCOD  "& vbCrLf &_
		   "			AND E.PROC_CCOD = Z.PROC_CCOD "& vbCrLf &_
		   "	order by SEDE_TDESC, ap_paterno,ap_materno,nombre"		   

'response.Write("<pre>"&consulta&"</pre>")
f_listado.Consultar consulta
'--------------------------------------------------------------------------------------------------------------------------
'--------------------------------------------------------------------------------------------------------------------------
set f_listado_nuevos = new CFormulario
f_listado_nuevos.Carga_Parametros "parametros.xml", "tabla"
f_listado_nuevos.Inicializar conexion 

consulta_nuevos = " select distinct za.ccos_tcompuesto,d.pers_nrut as RUT,d.pers_xdv as dv,d.pers_tnombre as nombre, d.pers_tape_paterno as ap_paterno,d.pers_tape_materno as ap_materno,  "& vbCrLf &_
				   "  (select top 1 cudo_titulo from curriculum_docente where pers_ncorr = a.pers_ncorr and grac_ccod in(1,2) order by grac_ccod desc) as profesion,  "& vbCrLf &_
				   "  b.anex_ncodigo as bloq_anexo,i.carr_tdesc, c.asig_ccod,(c.dane_nsesiones/2) as asig_nhoras,j.asig_tdesc, k.duas_tdesc, c.dane_msesion as bpro_mvalor,  "& vbCrLf &_
				   "  cast((c.dane_nsesiones/2)*c.dane_msesion as numeric) as valor, "& vbCrLf &_
				   "  cast((b.anex_nhoras_coordina * c.dane_msesion)/(select count(*) from( select count(*) as valor from detalle_anexos where anex_ncorr=b.anex_ncorr group by asig_ccod, secc_ccod)     as tabla ) as numeric) as coordina, "& vbCrLf &_      
				   "  (b.anex_nhoras_coordina * c.dane_msesion) as total_por_anexo, "& vbCrLf &_
				   " protic.trunc(a.cdoc_finicio) as fechai,protic.trunc(a.cdoc_ffin) as fechaf, "& vbCrLf &_
				   "  b.anex_nhoras_coordina as hor_coordinacion1,0 as hor_ccordinacion1,n.secc_tdesc,'--' as Porcentaje,0 as MontoMC, "& vbCrLf &_
				   "  e.sede_tdesc, b.anex_ncuotas as num_cuotas, pea.peri_tdesc as semestre,jor.jorn_tdesc as jornada, "& vbCrLf &_
				   "  protic.trunc(b.anex_finicio) as fecha_inicio, protic.trunc(b.anex_ffin) as fecha_fin,o.tpro_tdesc as tipo_Profesor,q.moda_tdesc    "& vbCrLf &_
				   "  From contratos_docentes_upa a, detalle_anexos c, personas d,  "& vbCrLf &_
				   "       sedes e, estados_civiles f,direcciones g, ciudades h, carreras i,jornadas jor,periodos_Academicos pea,  "& vbCrLf &_
				   "       asignaturas j,duracion_asignatura k,instituciones l,paises m, secciones n,tipos_profesores o,profesores p, modalidades q, anexos b   "& vbCrLf &_
				   "    left outer join centros_costos_asignados z  "& vbCrLf &_
					"		on b.carr_ccod	 =	z.cenc_ccod_carrera    "& vbCrLf &_
					"		and b.sede_ccod  =  z.cenc_ccod_sede   "& vbCrLf &_
					"		and b.jorn_ccod	 =	z.cenc_ccod_jornada   "& vbCrLf &_
					"	join centros_costo za  "& vbCrLf &_
					"		on za.ccos_ccod	 =	z.ccos_ccod  "& vbCrLf &_
				   "  Where a.cdoc_ncorr    =   b.cdoc_ncorr  "& vbCrLf &_
				   "     and b.anex_ncorr    =   c.anex_ncorr  "& vbCrLf &_
				   "     and a.pers_ncorr    =   d.pers_ncorr  "& vbCrLf &_
				   "	 and b.sede_ccod     =   e.sede_ccod  "& vbCrLf &_
				   "     and d.eciv_ccod     =   f.eciv_ccod  "& vbCrLf &_
				   "     and g.ciud_ccod     =   h.ciud_ccod  "& vbCrLf &_
				   "     and g.pers_ncorr    =   a.pers_ncorr  "& vbCrLf &_
				   "     and g.tdir_ccod     =   1  "& vbCrLf &_
				   "     and b.carr_ccod     =   i.carr_ccod  "& vbCrLf &_
				   "	 and n.peri_ccod	 =	 pea.peri_ccod "& vbCrLf &_
				   " 	 and n.jorn_ccod 	 =   jor.jorn_ccod "& vbCrLf &_
				   "     and c.asig_ccod     =   j.asig_ccod  "& vbCrLf &_
				   "     and c.duas_ccod     =   k.duas_ccod  "& vbCrLf &_
				   "     and l.INST_CCOD     =   1  "& vbCrLf &_
				   "     and isnull(M.PAIS_CCOD,1)     =   isnull(d.PAIS_CCOD,1)  "& vbCrLf &_
				   "     and n.secc_ccod     =   c.secc_ccod  "& vbCrLf &_
				   "     and o.TPRO_CCOD     =   p.TPRO_CCOD  "& vbCrLf &_
				   "     and p.pers_ncorr    =   d.pers_ncorr  "& vbCrLf &_
				   "     AND b.SEDE_CCOD     =   p.sede_ccod "& vbCrLf &_ 
				   "     and a.ecdo_ccod     =  1 "& vbCrLf &_
				   "     and b.eane_ccod     <> 3 "& vbCrLf &_	
				   "     and n.moda_ccod     =   q.moda_ccod "    

'response.Write("<pre>"&consulta_nuevos&"</pre>")
f_listado_nuevos.Consultar consulta_nuevos

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

<p>&nbsp;</p><table width="100%" border="1">
 
  <tr>
     <td colspan="24">&nbsp;</td>
  </tr>
  <tr>
     <td colspan="24" bgcolor="#FFFFCC" align="left"><strong><font size="+1">PRESUPUESTO DOCENTES CONTRATADOS CON SISTEMA NUEVO</font></strong></td>
  </tr>
  <tr>
     <td colspan="24">&nbsp;</td>
  </tr>
  <tr> 
    <td width="2"><div align="left"><strong>N°</strong></div></td>
    <td width="8%"><div align="left"><strong>R.U.T.</strong></div></td>
    <td width="15%"><div align="center"><strong>NOMBRE DOCENTE</strong></div></td>
    <td width="15%"><div align="center"><strong>PROFESIÓN</strong></div></td>
	<td width="5%"><div align="left"><strong>TIPO PROFESOR</strong></div></td>
	<td width="5%"><div align="center"><strong>SEDE</strong></div></td>
	<td width="10%"><div align="center"><strong>CARRERA</strong></div></td>
	<td width="10%"><div align="center"><strong>JORNADA</strong></div></td>
    <td width="3%"><div align="center"><strong>COD ASIGNATURA</strong></div></td>
	<td width="10%"><div align="left"><strong>ASIGNATURA</strong></div></td>
	<td width="2%"><div align="left"><strong>SECCIÓN</strong></div></td>
	<td width="2%"><div align="left"><strong>MODALIDAD</strong></div></td>
	<td width="10%"><div align="center"><strong>SEMESTRE</strong></div></td>
    <td width="5%"><div align="center"><strong>HORAS DOCENTE</strong></div></td>
    <td width="5%"><div align="center"><strong>DURACIÓN</strong></div></td>
	<td width="5%"><div align="center"><strong>VALOR SECCION</strong></div></td>
	<td width="8%"><div align="center"><strong>TOTAL PAGAR</strong></div></td>
    <td width="3%"><div align="center"><strong>CUOTAS</strong></div></td>
	<td width="5%"><div align="left"><strong>FECHA INICIO</strong></div></td>
    <td width="5%"><div align="center"><strong>FECHA FIN</strong></div></td>
    <td width="5%"><div align="center"><strong>HORAS_COORDINACIÓN</strong></div></td>
	<td width="5%"><div align="center"><strong>monto HC dividido</strong></div></td>
	<td width="5%"><div align="center"><strong>monto HC total </strong></div></td>
	<td width="5%"><div align="center"><strong>Centro Costo</strong></div></td>	
  </tr>
  <%  fila_2 = 1
    while f_listado_nuevos.Siguiente %>
  <tr> 
    <td><div align="left"><%=fila_2%></div></td>
	<td><div align="left"><%=f_listado_nuevos.ObtenerValor("rut")%>-<%=f_listado_nuevos.ObtenerValor("dv")%></div></td>
    <td><div align="center"><%=f_listado_nuevos.ObtenerValor("nombre")%>&nbsp;<%=f_listado_nuevos.ObtenerValor("ap_paterno")%>&nbsp;<%=f_listado_nuevos.ObtenerValor("ap_materno")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("profesion")%></div></td>
    <td><div align="center"><%=f_listado_nuevos.ObtenerValor("tipo_profesor")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("sede_tdesc")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("carr_tdesc")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("jornada")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("asig_ccod")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("asig_tdesc")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("secc_tdesc")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("moda_tdesc")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("semestre")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("asig_nhoras")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("duas_tdesc")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("bpro_mvalor")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("valor")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("num_cuotas")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("fecha_inicio")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("fecha_fin")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("hor_coordinacion1")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("coordina")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("total_por_anexo")%></div></td>
	<td><div align="center"><%=f_listado_nuevos.ObtenerValor("ccos_tcompuesto")%></div></td>	
  </tr>
  <% fila_2 = fila_2 + 1
  wend %>
</table>

<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>
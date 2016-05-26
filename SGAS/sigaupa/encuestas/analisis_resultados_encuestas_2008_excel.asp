<!-- #include file = "../biblioteca/_conexion.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=encuestas_docentes_por_escuela.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 150000


set conexion = new CConexion
conexion.Inicializar "upacifico"

fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
peri_ccod = request.QueryString("peri_ccod")
carr_ccod = request.QueryString("carr_ccod")
sede_ccod = request.QueryString("sede_ccod")
jorn_ccod = request.QueryString("jorn_ccod")
anos_ccod = conexion.consultauno("SELECT ANOS_CCOD FROM PERIODOS_ACADEMICOS WHERE PERI_CCOD="&peri_ccod&";")
'---------------------------------------------------encuesta Egresados--------------------------------
set f_secciones = new CFormulario
f_secciones.Carga_Parametros "tabla_vacia.xml", "tabla"
f_secciones.Inicializar conexion
		   
consulta =  "    select sede_tdesc,i.FACU_TDESC,carr_tdesc,j.jorn_tdesc,a.secc_ccod,secc_tdesc,rtrim(b.asig_ccod)+': '+asig_tdesc as asignatura,c.pers_ncorr,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,  "& vbCrLf &_
		    "	pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,  "& vbCrLf &_
		    "	isnull((select cast(cast(sum(isnull(parte_2_1,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_2_1 >0   "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_2_1,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_2_2,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_2_2 > 0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_2_2,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_2_3,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_2_3 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_2_3,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_2_4,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_2_4 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_2_4,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_2_5,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_2_5 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_2_5,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_2_6,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_2_6 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_2_6,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_2_7,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_2_7 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_2_7,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_2_8,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_2_8 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_2_8,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_2_9,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_2_9 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_2_9,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_3_1,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_3_1 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_3_1,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_3_2,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_3_2 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_3_2,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_3_3,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_3_3 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_3_3,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_3_4,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_3_4 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_3_4,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_4_1,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_4_1 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_4_1,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_4_2,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_4_2 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_4_2,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_4_3,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_4_3 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_4_3,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_4_4,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_4_4 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_4_4,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_5_1,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_5_1 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_5_1,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_5_2,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_5_2 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_5_2,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_5_3,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_5_3 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_5_3,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_5_4,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_5_4 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_5_4,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_5_5,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_5_5 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_5_5,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_6_1,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_6_1 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_6_1,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_6_2,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_6_2 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_6_2,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_6_3,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_6_3 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_6_3,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_6_4,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_6_4 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_6_4,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_6_5,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_
			"	and parte_6_5 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_6_5,  "& vbCrLf &_
			"	isnull((select cast(cast(sum(isnull(parte_6_6,0))as numeric)/cast(count(distinct pers_ncorr)as numeric)as decimal(4,1) )  "& vbCrLf &_
			"	from cuestionario_opinion_alumnos yy  "& vbCrLf &_
			"	where yy.secc_ccod=a.secc_ccod  "& vbCrLf &_ 
			"	and parte_6_6 >0  "& vbCrLf &_
			"	and yy.pers_ncorr_profesor=c.pers_ncorr  "& vbCrLf &_
			"	group by yy.secc_ccod),0)as parte_6_6,  "& vbCrLf &_
			"	(select count(*) from cargas_academicas aa (nolock) where aa.secc_ccod = a.secc_ccod) as cantidad_alumnos,  "& vbCrLf &_
			"	(select count(distinct pers_ncorr)   "& vbCrLf &_
			"	 from cuestionario_opinion_alumnos aa   "& vbCrLf &_
			"	 where aa.secc_ccod=a.secc_ccod and aa.pers_ncorr_profesor=c.pers_ncorr   "& vbCrLf &_
			"	 and isnull(estado_cuestionario,0) = 2 ) as evaluado2,  "& vbCrLf &_
			"	cast(   "& vbCrLf &_
			"			(  (   "& vbCrLf &_
			"			   (select cast(avg(parte_2_1) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = c.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_2_1,0) > 0 )   "& vbCrLf &_
			"			  +   "& vbCrLf &_
			"			   (select cast(avg(parte_2_2) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = c.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_2_2,0) > 0 )    "& vbCrLf &_
			"			  +   "& vbCrLf &_
			"			   (select cast(avg(parte_2_3) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = c.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_2_3,0) > 0 )     "& vbCrLf &_
			"			  +   "& vbCrLf &_
			"			   (select cast(avg(parte_2_4) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = c.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_2_4,0) > 0 )     "& vbCrLf &_
			"			  +   "& vbCrLf &_
			"			   (select cast(avg(parte_2_5) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = c.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_2_5,0) > 0 )    "& vbCrLf &_
			"			  +   "& vbCrLf &_
			"			   (select cast(avg(parte_2_6) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = c.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_2_6,0) > 0 )     "& vbCrLf &_
			"			  +   "& vbCrLf &_
			"			   (select cast(avg(parte_2_7) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = c.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_2_7,0) > 0 )      "& vbCrLf &_
			"			  +   "& vbCrLf &_
			"			   (select cast(avg(parte_2_8) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = c.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_2_8,0) > 0 )      "& vbCrLf &_
			"			  +   "& vbCrLf &_
			"			   (select cast(avg(parte_2_9) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = c.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_2_9,0) > 0 )       "& vbCrLf &_
			"			  +   "& vbCrLf &_
			"			   (select cast(avg(parte_3_1) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = c.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_3_1,0) > 0 )       "& vbCrLf &_
			"			  +   "& vbCrLf &_
			"			   (select cast(avg(parte_3_2) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = c.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_3_2,0) > 0 )    "& vbCrLf &_
			"			  +   "& vbCrLf &_
			"			   (select cast(avg(parte_3_3) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = c.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_3_3,0) > 0 )     "& vbCrLf &_
			"			  +   "& vbCrLf &_
			"			   (select cast(avg(parte_3_4) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = c.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_3_4,0) > 0 )     "& vbCrLf &_
			"			  +   "& vbCrLf &_
			"			   (select cast(avg(parte_4_1) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = c.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_4_1,0) > 0 )       "& vbCrLf &_
			"			  +   "& vbCrLf &_
			"			   (select cast(avg(parte_4_2) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = c.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_4_2,0) > 0 )     "& vbCrLf &_
			"			  +   "& vbCrLf &_
			"			   (select cast(avg(parte_4_3) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = c.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_4_3,0) > 0 )       "& vbCrLf &_
			"			  +   "& vbCrLf &_
			"			   (select cast(avg(parte_4_4) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = c.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_4_4,0) > 0 )     "& vbCrLf &_
			"			  +   "& vbCrLf &_
			"			   (select cast(avg(parte_5_1) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = c.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_5_1,0) > 0 )       "& vbCrLf &_
			"			  +   "& vbCrLf &_
			"			   (select cast(avg(parte_5_2) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = c.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_5_2,0) > 0 )     "& vbCrLf &_
			"			  +   "& vbCrLf &_
			"			   (select cast(avg(parte_5_3) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = c.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_5_3,0) > 0 )     "& vbCrLf &_
			"			  +   "& vbCrLf &_
			"			   (select cast(avg(parte_5_4) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = c.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_5_4,0) > 0 )       "& vbCrLf &_
			"			  +   "& vbCrLf &_
			"			   (select cast(avg(parte_5_5) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = c.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_5_5,0) > 0 )     "& vbCrLf &_
			"			  ) / 22  "& vbCrLf &_
			"			) as decimal(2,1))  as puntaje_obtenido  "& vbCrLf &_
			"	from(select a.secc_ccod,pers_ncorr_profesor,isnull(parte_2_1,0)as parte_2_1,isnull(parte_2_2,0)as parte_2_2, "& vbCrLf &_
			"	isnull(parte_2_3,0)as parte_2_3,isnull(parte_2_4,0)as parte_2_4,isnull(parte_2_5,0)as parte_2_5, "& vbCrLf &_
			"	isnull(parte_2_6,0)as parte_2_6,isnull(parte_2_7,0)as parte_2_7,isnull(parte_2_8,0)as parte_2_8, "& vbCrLf &_
			"	isnull(parte_2_9,0)as parte_2_9,isnull(parte_3_1,0)as parte_3_1,isnull(parte_3_2,0)as parte_3_2, "& vbCrLf &_
			"	isnull(parte_3_3,0)as parte_3_3,isnull(parte_3_4,0)as parte_3_4,isnull(parte_4_1,0)as parte_4_1, "& vbCrLf &_
			"	isnull(parte_4_2,0)as parte_4_2,isnull(parte_4_3,0)as parte_4_3,isnull(parte_4_4,0)as parte_4_4, "& vbCrLf &_
			"	isnull(parte_5_1,0)as parte_5_1,isnull(parte_5_2,0)as parte_5_2,isnull(parte_5_3,0)as parte_5_3, "& vbCrLf &_
			"	isnull(parte_5_4,0)as parte_5_4,isnull(parte_5_5,0)as parte_5_5,isnull(parte_6_1,0)as parte_6_1, "& vbCrLf &_
			"	isnull(parte_6_2,0)as parte_6_2,isnull(parte_6_3,0)as parte_6_3,isnull(parte_6_4,0)as parte_6_4, "& vbCrLf &_
			"	isnull(parte_6_5,0)as parte_6_5,isnull(parte_6_6,0)as parte_6_6 "& vbCrLf &_
			"	from cuestionario_opinion_alumnos a, secciones b "& vbCrLf &_
			"	where a.secc_ccod=b.secc_ccod "& vbCrLf &_
			"	and b.peri_ccod >= 212 -- in ("&peri_ccod&")) a,"& vbCrLf &_
			"	)a, secciones b,personas c,asignaturas d,periodos_academicos e, "& vbCrLf &_
			"	sedes f,carreras g, areas_academicas h,facultades i,jornadas j "& vbCrLf &_
			"	where a.secc_ccod=b.secc_ccod "& vbCrLf &_
			"	and a.pers_ncorr_profesor=c.pers_ncorr "& vbCrLf &_
			"	and b.asig_ccod=d.asig_ccod "& vbCrLf &_
			"	and b.peri_ccod=e.peri_ccod "& vbCrLf &_
			"	and b.sede_ccod=f.sede_ccod "& vbCrLf &_
			"	and b.carr_ccod=g.carr_ccod "& vbCrLf &_
			"	and g.area_ccod=h.area_ccod "& vbCrLf &_
			"	and h.facu_ccod=i.facu_ccod "& vbCrLf &_
			"	and e.peri_ccod="&peri_ccod&""& vbCrLf &_
			"	and b.jorn_ccod=j.jorn_ccod and b.carr_ccod='"&carr_ccod&"' "& vbCrLf &_
			"	and cast(b.jorn_ccod as varchar)='"&jorn_ccod&"' and cast(b.sede_ccod as varchar) = '"&sede_ccod&"' "& vbCrLf &_
			"	group by a.secc_ccod,c.pers_ncorr,carr_tdesc,j.jorn_tdesc,i.FACU_TDESC,sede_tdesc,pers_nrut,pers_xdv,secc_tdesc,asig_tdesc,pers_tape_paterno,pers_tape_materno,pers_tnombre,b.asig_ccod "& vbCrLf &_
			"	order by sede_tdesc,facu_tdesc,carr_tdesc,jorn_tdesc,nombre "

'response.Write("<pre>"&consulta&"</pre>")
'response.End()		   
f_secciones.Consultar consulta



%>
<html>
<head>
<title>Evaluación Docente por escuela</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Evaluación docente por escuela</font></div>
	</td>
 </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Fecha</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=fecha%> </td>
  </tr>
  <tr> 
    <td width="16%">&nbsp;</td>
    <td width="84%" colspan="3">&nbsp;</td>
  </tr>
</table>
 <p>&nbsp;</p>
 <table width="100%" border="1">
  <tr><td colspan="4" bgcolor="#CCFFCC"><font size="+1"><strong>Resultados</strong></font></td>
      <td colspan="36" bgcolor="#CCFFCC">&nbsp;</td>
  </tr>
  <tr bgcolor="#CCFFCC"> 
    <td><div align="center"><strong>fila</strong></div></td>
	<td><div align="center"><strong>SEDE</strong></div></td>
    <td><div align="center"><strong>FACULTAD</strong></div></td>
    <td><div align="center"><strong>CARRERA</strong></div></td>
	<td><div align="center"><strong>JORNADA</strong></div></td>
    <td><div align="center"><strong>ASIGNATURA</strong></div></td>
	<td><div align="center"><strong>SECCIÓN</strong></div></td>
	<td><div align="center"><strong>RUT</strong></div></td>
	<td><div align="center"><strong>NOMBRE</strong></div></td>
	<td><div align="center"><strong>Pregunta 1-A</strong></div></td>
	<td><div align="center"><strong>Pregunta 1-B</strong></div></td>
	<td><div align="center"><strong>Pregunta 1-C</strong></div></td>
	<td><div align="center"><strong>Pregunta 1-D</strong></div></td>
	<td><div align="center"><strong>Pregunta 1-E</strong></div></td>
	<td><div align="center"><strong>Pregunta 1-F</strong></div></td>
	<td><div align="center"><strong>Pregunta 1-G</strong></div></td>
	<td><div align="center"><strong>Pregunta 1-H</strong></div></td>
	<td><div align="center"><strong>Pregunta 1-I</strong></div></td>
	<td><div align="center"><strong>Pregunta 2-A</strong></div></td>
	<td><div align="center"><strong>Pregunta 2-B</strong></div></td>
	<td><div align="center"><strong>Pregunta 2-C</strong></div></td>
	<td><div align="center"><strong>Pregunta 2-D</strong></div></td>
	<td><div align="center"><strong>Pregunta 3-A</strong></div></td>
	<td><div align="center"><strong>Pregunta 3-B</strong></div></td>
	<td><div align="center"><strong>Pregunta 3-C</strong></div></td>
	<td><div align="center"><strong>Pregunta 3-D</strong></div></td>
	<td><div align="center"><strong>Pregunta 4-A</strong></div></td>
	<td><div align="center"><strong>Pregunta 4-B</strong></div></td>
	<td><div align="center"><strong>Pregunta 4-C</strong></div></td>
	<td><div align="center"><strong>Pregunta 4-D</strong></div></td>
	<td><div align="center"><strong>Pregunta 4-E</strong></div></td>
	<td><div align="center"><strong>Pregunta 5-A</strong></div></td>
	<td><div align="center"><strong>Pregunta 5-B</strong></div></td>
	<td><div align="center"><strong>Pregunta 5-C</strong></div></td>
	<td><div align="center"><strong>Pregunta 5-D</strong></div></td>
	<td><div align="center"><strong>Pregunta 5-E</strong></div></td>
	<td><div align="center"><strong>Pregunta 5-F</strong></div></td>
	<td><div align="center"><strong>ALUMNOS TOTALES</strong></div></td>
	<td><div align="center"><strong>ALUMNOS QUE EVALUARON</strong></div></td>
	<td><div align="center"><strong>PUNTAJE</strong></div></td>
  </tr>
  <% fila = 1  
    while f_secciones.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
	<td><div align="left"><%=f_secciones.ObtenerValor("sede_tdesc")%></div></td>
    <td><div align="left"><%=f_secciones.ObtenerValor("facu_tdesc")%></div></td>
    <td><div align="left"><%=f_secciones.ObtenerValor("carr_tdesc")%></div></td>
    <td><div align="left"><%=f_secciones.ObtenerValor("jorn_tdesc")%></div></td>
    <td><div align="left"><%=f_secciones.ObtenerValor("asignatura")%></div></td>
	<td><div align="left"><%=f_secciones.ObtenerValor("secc_tdesc")%></div></td>
	<td><div align="left"><%=f_secciones.ObtenerValor("rut")%></div></td>
	<td><div align="left"><%=f_secciones.ObtenerValor("nombre")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_2_1")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_2_2")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_2_3")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_2_4")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_2_5")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_2_6")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_2_7")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_2_8")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_2_9")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_3_1")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_3_2")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_3_3")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_3_4")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_4_1")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_4_2")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_4_3")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_4_4")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_5_1")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_5_2")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_5_3")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_5_4")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_5_5")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_6_1")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_6_2")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_6_3")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_6_4")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_6_5")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("parte_6_6")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("cantidad_alumnos")%></div></td>
	<td><div align="center"><%=f_secciones.ObtenerValor("evaluado2")%></div></td>
   	<td><div align="center"><%=f_secciones.ObtenerValor("puntaje_obtenido")%></div></td>
  </tr>
  <% fila = fila + 1 
     wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:06/03/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:271,273,275,284,286,288,290,292,294,301,303,305,307,309,311,313,315,324,326,328,330,332,334,336,338,346,351,353,356,358,360,370,371,374,382,384,386,388,390,400,402,404,406,408,413 - 451,452
'********************************************************************
set pagina = new CPagina
set botonera = new CFormulario
set errores 	= new cErrores
botonera.carga_parametros "toma_carga.xml", "BotoneraSeccionesEQ"

'for each k in request.QueryString()
'	response.Write(k&" = "&request.QueryString(k)&"<br>")
'next


asig_ccod	=	request.querystring("asig_ccod")
peri_ccod	=	request.QueryString("peri_ccod")
plan_ccod	=	request.QueryString("plan_ccod")
sede_ccod	=	request.QueryString("sede_ccod")
pers_ncorr	=	request.QueryString("pers_ncorr")
matr_ncorr	=	request.QueryString("matr_ncorr")

set conectar		=	new cconexion
set negocio			=	new cnegocio
set seccion 		=	new cformulario
set asig_origen		=	new cformulario

conectar.inicializar "upacifico"

negocio.inicializa conectar

'periodo	=	negocio.obtenerPeriodoAcademico("OTONO")
'sede_ccod = negocio.obtenersede

seccion.carga_parametros 		"toma_carga.xml", "toma_carga"
seccion.inicializar				conectar

asig_origen.carga_parametros	"toma_carga.xml", "toma_carga"		
asig_origen.inicializar			conectar
if asig_ccod<>"" then

'asig_disponibles="select distinct c.asig_ccod,mall_ccod,c.asig_ccod ||' - '|| c.asig_tdesc as asignatura, asig_nhoras, b.secc_ccod, '" & matr_ncorr & "' as matr_ncorr " & _
'"	  , a.nive_ccod, nvl(d.reprobado,0) as reprobado from (SELECT DISTINCT b.asig_ccod,b.mall_ccod, b.nive_ccod " & vbCrlf & _
''"  FROM malla_curricular b" & vbCrlf & _
'" WHERE b.plan_ccod = '" & plan_ccod & "'" & vbCrlf & _
'" ---AND completo_requisitos_asignatura (mall_ccod, '" & pers_ncorr & "') = 0" & vbCrlf & _
'"   AND NOT (  " & vbCrlf & _
'"			EXISTS (SELECT 1 " & vbCrlf & _
'"                    FROM secciones sa," & vbCrlf & _
'"                         cargas_academicas sb," & vbCrlf & _
'"                         alumnos sc," & vbCrlf & _
'"                         situaciones_finales sd" & vbCrlf & _
'"                   WHERE sa.secc_ccod = sb.secc_ccod" & vbCrlf & _
'"                     AND sa.asig_ccod = b.asig_ccod" & vbCrlf & _
'"                     AND sb.matr_ncorr = sc.matr_ncorr" & vbCrlf & _
'"                     AND sb.sitf_ccod = sd.sitf_ccod" & vbCrlf & _
'"					  AND sc.emat_ccod = 1" & vbCrlf & _
'"                     AND sd.sitf_baprueba = 'S'" & vbCrlf & _
'"                     AND sc.pers_ncorr = '" & pers_ncorr & "')" & vbCrlf & _
'"        OR  " & vbCrlf & _
'"           EXISTS ( SELECT 1 " & vbCrlf & _
'"                    FROM convalidaciones s2a, alumnos s2b, situaciones_finales s2c " & vbCrlf & _
'"                   WHERE s2a.matr_ncorr=s2b.matr_ncorr" & vbCrlf & _
'"                     AND s2a.asig_ccod = b.asig_ccod" & vbCrlf & _
'"                     AND s2a.sitf_ccod = s2c.sitf_ccod" & vbCrlf & _
'"					  AND s2b.emat_ccod = 1" & vbCrlf & _
'"                     AND s2c.sitf_baprueba = 'S'" & vbCrlf & _
'"                     AND s2b.pers_ncorr = '" & pers_ncorr & "')" & vbCrlf & _
'"        ) " & vbCrlf & _
'"   AND b.plan_ccod = '" & plan_ccod & "'" & vbCrlf & _
'") a, " & vbCrlf & _
'"	(SELECT a.asig_ccod, a.secc_ccod, c.matr_ncorr  " & vbCrlf & _
'"	   FROM secciones a, cargas_academicas b, alumnos c " & vbCrlf & _
'"	  WHERE a.secc_ccod = b.secc_ccod " & vbCrlf & _
'"	   AND b.matr_ncorr = c.matr_ncorr " & vbCrlf & _
'"      AND c.emat_ccod = 1" & vbCrlf & _
'"      AND a.sede_ccod = '" & sede_ccod & "' " & vbCrlf & _
'"      AND a.peri_ccod = '" & peri_ccod & "' " & vbCrlf & _
'"	   AND c.pers_ncorr = '" & pers_ncorr & "') b, " & vbCrlf & _
'"	asignaturas c, " & vbCrlf & _
'"   ( select a.asig_ccod, 1 as reprobado  " & vbCrlf & _
'"       from secciones a, cargas_academicas b, situaciones_finales c, alumnos d " & vbCrlf & _
'"      where a.secc_ccod=b.secc_ccod  " & vbCrlf & _
'"        and b.sitf_ccod=c.sitf_ccod  " & vbCrlf & _
'"        and b.matr_ncorr=d.matr_ncorr " & vbCrlf & _
'"        AND d.emat_ccod = 1" & vbCrlf & _
'"        and d.pers_ncorr='" & pers_ncorr & "' " & vbCrlf & _
'"        and sitf_baprueba='N') d" & vbCrlf & _
'"  where a.asig_ccod=b.asig_ccod (+) " & vbCrlf & _
'"    and a.asig_ccod=d.asig_ccod (+) " & vbCrlf & _
'"    and a.asig_ccod=c.asig_ccod " & vbCrLf & _
'"    and b.secc_ccod is null " & vbCrLf & _
'"  order by nive_ccod, asig_ccod "


'asig_disponibles = "select distinct c.asig_ccod, mall_ccod, c.asig_ccod + ' - ' + c.asig_tdesc as asignatura, asig_nhoras, b.secc_ccod, '" & matr_ncorr & "' as matr_ncorr " & _
'"	  , a.nive_ccod, isnull(d.reprobado,0) as reprobado  from (SELECT DISTINCT b.mall_ccod, b.asig_ccod, b.nive_ccod " & vbCrlf & _
'"  FROM malla_curricular b" & vbCrlf & _
'" WHERE b.plan_ccod = '" & plan_ccod & "'" & vbCrlf & _
'" --AND completo_requisitos_asignatura (mall_ccod, '" & pers_ncorr & "') = 0" & vbCrlf & _
'"   AND NOT (  " & vbCrlf & _
'"			EXISTS (SELECT 1 " & vbCrlf & _
'"                    FROM secciones sa," & vbCrlf & _
'"                         cargas_academicas sb," & vbCrlf & _
'"                         alumnos sc," & vbCrlf & _
'"                         situaciones_finales sd" & vbCrlf & _
'"                   WHERE sa.secc_ccod = sb.secc_ccod" & vbCrlf & _
'"                     AND sa.asig_ccod = b.asig_ccod" & vbCrlf & _
'"                     AND sb.matr_ncorr = sc.matr_ncorr" & vbCrlf & _
'"                     AND sb.sitf_ccod = sd.sitf_ccod" & vbCrlf & _
'"                     AND sd.sitf_baprueba = 'S'" & vbCrlf & _
'"                     AND sc.emat_ccod = 1" & vbCrlf & _
'"                     AND sc.pers_ncorr = '" & pers_ncorr & "')" & vbCrlf & _
'"        OR  " & vbCrlf & _
'"           EXISTS (  select 1 " & vbCrlf & _
'		"			from  " & vbCrlf & _
'		"				 convalidaciones a " & vbCrlf & _
'		"				 , alumnos b1 " & vbCrlf & _
'		"				 ,personas c " & vbCrlf & _
'		"				 , actas_convalidacion d " & vbCrlf & _
'		"				 , ofertas_academicas e " & vbCrlf & _
'		"				 , planes_estudio f " & vbCrlf & _
'		"				 ,especialidades g " & vbCrlf & _
'		"				 ,situaciones_finales h " & vbCrlf & _
'		"			where " & vbCrlf & _
'		"				 a.matr_ncorr=b1.matr_ncorr " & vbCrlf & _
'		"				 and b1.pers_ncorr=c.pers_ncorr " & vbCrlf & _
'		"				 and a.acon_ncorr=d.acon_ncorr " & vbCrlf & _
'		"				 and b1.ofer_ncorr=e.ofer_ncorr " & vbCrlf & _
'		"				 and b1.plan_ccod=f.plan_ccod " & vbCrlf & _
'		"				 and f.espe_ccod=g.espe_ccod " & vbCrlf & _
'		"				 and a.asig_ccod=b.asig_ccod " & vbCrlf & _
'		"				 and a.sitf_ccod=h.sitf_ccod " & vbCrlf & _
'		"				 and h.sitf_baprueba='S' " & vbCrlf & _
'		"			     and c.pers_ncorr='"&pers_ncorr&"')" & vbCrlf & _	
'"        OR  " & vbCrlf & _
'"           EXISTS ( SELECT 1 " & vbCrlf & _
'"                		from homologacion_destino hd, homologacion_fuente hf,homologacion h,asignaturas asig, " & vbCrlf & _
'"                		secciones secc,cargas_academicas carg, alumnos al, personas pers, situaciones_finales s2c " & vbCrlf & _
'"                		where hd.homo_ccod=h.homo_ccod " & vbCrlf & _
'"                		and hf.homo_ccod=h.homo_ccod " & vbCrlf & _
'"                		and asig.asig_ccod=hd.asig_ccod " & vbCrlf & _
'"                		and asig.asig_ccod=secc.asig_ccod " & vbCrlf & _
'"                		and secc.secc_ccod=carg.secc_ccod " & vbCrlf & _
'"                     	AND hf.asig_ccod  = b.asig_ccod" & vbCrlf & _
'"                		and al.matr_ncorr=carg.matr_ncorr " & vbCrlf & _
'"                		and pers.pers_ncorr=al.pers_ncorr " & vbCrlf & _
'"        		 		and hd.asig_ccod <> hf.asig_ccod " & vbCrlf & _
'"                     	AND carg.sitf_ccod = s2c.sitf_ccod" & vbCrlf & _
'"                     	AND s2c.sitf_baprueba = 'S'" & vbCrlf & _
'"                		and carg.sitf_ccod <>'EQ' " & vbCrlf & _
'"          		 		and h.THOM_CCOD = 1 " & vbCrlf & _
'"                       AND al.emat_ccod = 1" & vbCrlf & _
'"                		and pers.pers_ncorr='" & pers_ncorr & "')" & vbCrlf & _
'"		OR EXISTS (select  1 " & vbCrlf & _
'"		   		  		   from " & vbCrlf & _
'"								equivalencias a " & vbCrlf & _
'"								, cargas_academicas b1 " & vbCrlf & _
'"								, secciones c " & vbCrlf & _
'"								, ofertas_academicas d " & vbCrlf & _
'"								, planes_estudio e " & vbCrlf & _
'"								, especialidades f " & vbCrlf & _
'"								, alumnos g " & vbCrlf & _
'"								, personas h " & vbCrlf & _
'"								, situaciones_finales sf " & vbCrlf & _
'"							where " & vbCrlf & _
'"								 a.matr_ncorr=b1.matr_ncorr " & vbCrlf & _
'"								 and a.secc_ccod=b1.secc_ccod " & vbCrlf & _
'"								 and b1.secc_ccod=c.secc_ccod " & vbCrlf & _
'"								 and b1.matr_ncorr=g.matr_ncorr " & vbCrlf & _
'"								 and d.ofer_ncorr=g.ofer_ncorr " & vbCrlf & _
'"								 and e.plan_ccod=g.plan_ccod " & vbCrlf & _
'"								 and e.espe_ccod=f.espe_ccod " & vbCrlf & _
'"								 and g.pers_ncorr=h.pers_ncorr " & vbCrlf & _
'"								 and a.asig_ccod=b.asig_ccod " & vbCrlf & _
'"								 and b1.sitf_ccod=sf.sitf_ccod " & vbCrlf & _
'"								 and sf.sitf_baprueba='S' " & vbCrlf & _
'"								 and h.pers_ncorr='" & pers_ncorr & "') " & vbCrlf & _
'"        ) " & vbCrlf & _
'"   AND b.plan_ccod = '" & plan_ccod & "'" & vbCrlf & _
'"   AND NOT EXISTS (SELECT 1 " & vbCrlf & _
'"                      FROM  " & vbCrlf & _
'"                      MALLA_CURRICULAR MC, " & vbCrlf & _
'"                      (SELECT HOMO_CCOD,ASIG_CCOD_DESTINO, COUNT(*) NREQUISITOS, count(asig_ccod)NAPROBADOS " & vbCrlf & _
'"                      FROM  " & vbCrlf & _
'"                      (SELECT HD.HOMO_CCOD,HD.ASIG_CCOD ASIG_CCOD_DESTINO,HF.ASIG_CCOD ASIG_CCOD_FUENTE  " & vbCrlf & _
'"                       FROM HOMOLOGACION_FUENTE HF,  " & vbCrlf & _
'"                       HOMOLOGACION_DESTINO HD " & vbCrlf & _
'"                       WHERE HF.HOMO_CCOD=HD.HOMO_CCOD ) HOM, " & vbCrlf & _
'"                      (SELECT S.ASIG_CCOD  " & vbCrlf & _
'"                       FROM " & vbCrlf & _
'"                       SECCIONES S, " & vbCrlf & _
'"                       CARGAS_ACADEMICAS CA, " & vbCrlf & _
'"                       ALUMNOS A, " & vbCrlf & _
'"                       SITUACIONES_FINALES SF " & vbCrlf & _
'"                       WHERE S.SECC_CCOD = CA.SECC_CCOD " & vbCrlf & _
'"                       	   AND CA.MATR_NCORR = A.MATR_NCORR  " & vbCrlf & _
'"                      	   AND SF.SITF_CCOD=CA.SITF_CCOD " & vbCrlf & _
'"                      	   AND SF.SITF_BAPRUEBA='S'   " & vbCrlf & _
'"                      	   AND A.PERS_NCORR = '" & pers_ncorr & "') APRO " & vbCrlf & _
'"                      WHERE HOM.ASIG_CCOD_FUENTE *= APRO.ASIG_CCOD " & vbCrlf & _
'"                      group by HOMO_CCOD,asig_ccod_destino)	PRUEBA " & vbCrlf & _
'"                      WHERE MC.ASIG_CCOD=ASIG_CCOD_DESTINO " & vbCrlf & _
'"                      AND MC.ASIG_CCOD=B.ASIG_CCOD " & vbCrlf & _
'"					  AND NREQUISITOS=NAPROBADOS " & vbCrlf & _
'"                      AND PLAN_CCOD='" & plan_ccod & "') " & vbCrlf & _
'") a, " & vbCrlf & _
'"	(SELECT a.asig_ccod, a.secc_ccod, c.matr_ncorr  " & vbCrlf & _
'"	   FROM secciones a, cargas_academicas b, alumnos c " & vbCrlf & _
'"	  WHERE a.secc_ccod = b.secc_ccod " & vbCrlf & _
'"	   AND b.matr_ncorr = c.matr_ncorr and b.sitf_ccod is null" & vbCrlf & _
'"      AND c.emat_ccod = 1" & vbCrlf & _
'"      AND a.sede_ccod = '" & sede_ccod & "' " & vbCrlf & _
'"      AND a.peri_ccod = '" & peri_ccod & "' " & vbCrlf & _
'"	   AND c.pers_ncorr = '" & pers_ncorr & "'"& vbCrlf & _
'" 	   AND c.emat_ccod='1') b, " & vbCrlf & _
'"	asignaturas c, " & vbCrlf & _ 
'"   ( select a.asig_ccod, 1 as reprobado  " & vbCrlf & _
'"       from secciones a, cargas_academicas b, situaciones_finales c, alumnos d " & vbCrlf & _
'"      where a.secc_ccod=b.secc_ccod  " & vbCrlf & _
'"        and b.sitf_ccod=c.sitf_ccod  " & vbCrlf & _
'"        and b.matr_ncorr=d.matr_ncorr " & vbCrlf & _
'"        AND d.emat_ccod = 1" & vbCrlf & _
'"        and d.pers_ncorr='" & pers_ncorr & "' " & vbCrlf & _
'"        and sitf_baprueba='N' " & vbCrlf & _
'"        and b.sitf_ccod not in ('EE') " & vbCrlf & _
'"	  union all" & vbCrlf & _
'"	  	select  " & vbCrlf & _
'"			a.asig_ccod,1 as reprobado  " & vbCrlf & _
'"		from  " & vbCrlf & _
'"			 equivalencias a,  " & vbCrlf & _
'"			 cargas_academicas b,  " & vbCrlf & _
'"			 secciones c,  " & vbCrlf & _
'"			 situaciones_finales d,  " & vbCrlf & _
'"			 alumnos e,  " & vbCrlf & _
'"			 personas f " & vbCrlf & _
'"	  where a.matr_ncorr=b.matr_ncorr " & vbCrlf & _
'"		  and a.secc_ccod=b.secc_ccod  " & vbCrlf & _
'"		  and b.secc_ccod=c.secc_ccod " & vbCrlf & _
'"		  and b.sitf_ccod=d.sitf_ccod " & vbCrlf & _
'"		  and b.matr_ncorr=e.matr_ncorr " & vbCrlf & _
'"		  and e.pers_ncorr=f.pers_ncorr " & vbCrlf & _
'"		  and b.sitf_ccod not in ('EE') " & vbCrlf & _
'"		  and d.sitf_baprueba='N'" & vbCrlf & _
'"		  and f.pers_ncorr='"& pers_ncorr &"') d" & vbCrlf & _
'"  where a.asig_ccod *=b.asig_ccod  " & vbCrlf & _
'"    and a.asig_ccod *=d.asig_ccod  " & vbCrlf & _
'"    and a.asig_ccod=c.asig_ccod " & vbCrLf

asig_disponibles = "select distinct c.asig_ccod, mall_ccod, c.asig_ccod + ' - ' + c.asig_tdesc as asignatura, asig_nhoras, b.secc_ccod, '" & matr_ncorr & "' as matr_ncorr " & _
"	  , a.nive_ccod, isnull(d.reprobado,0) as reprobado  from (SELECT DISTINCT b.mall_ccod, b.asig_ccod, b.nive_ccod " & vbCrlf & _
"  FROM malla_curricular b" & vbCrlf & _
" WHERE b.plan_ccod = '" & plan_ccod & "'" & vbCrlf & _
" --AND completo_requisitos_asignatura (mall_ccod, '" & pers_ncorr & "') = 0" & vbCrlf & _
"   AND NOT (  " & vbCrlf & _
"			EXISTS (SELECT 1 " & vbCrlf & _
"                    FROM secciones sa INNER JOIN cargas_academicas sb " & vbCrlf & _
"					ON sa.secc_ccod = sb.secc_ccod AND sa.asig_ccod = b.asig_ccod " & vbCrlf & _
"					INNER JOIN alumnos sc " & vbCrlf & _
"					ON sb.matr_ncorr = sc.matr_ncorr " & vbCrlf & _
"					INNER JOIN situaciones_finales sd " & vbCrlf & _
"					ON sb.sitf_ccod = sd.sitf_ccod " & vbCrlf & _
"					WHERE sd.sitf_baprueba = 'S' " & vbCrlf & _
"					AND sc.emat_ccod = 1 " & vbCrlf & _
"					AND sc.pers_ncorr = '" & pers_ncorr & "')" & vbCrlf & _
"        OR  " & vbCrlf & _
"           EXISTS (  select 1 " & vbCrlf & _
		"			from convalidaciones a INNER JOIN alumnos b1 " & vbCrlf & _
"					ON a.matr_ncorr = b1.matr_ncorr and a.asig_ccod=b.asig_ccod " & vbCrlf & _
"					INNER JOIN personas c " & vbCrlf & _
"					ON b1.pers_ncorr = c.pers_ncorr " & vbCrlf & _
"					INNER JOIN actas_convalidacion d " & vbCrlf & _
"					ON a.acon_ncorr = d.acon_ncorr " & vbCrlf & _
"					INNER JOIN ofertas_academicas e " & vbCrlf & _
"					ON b1.ofer_ncorr = e.ofer_ncorr " & vbCrlf & _
"					INNER JOIN planes_estudio f " & vbCrlf & _
"					ON b1.plan_ccod = f.plan_ccod " & vbCrlf & _
"					INNER JOIN especialidades g " & vbCrlf & _
"					ON f.espe_ccod = g.espe_ccod " & vbCrlf & _
"					INNER JOIN situaciones_finales h " & vbCrlf & _
"					ON a.sitf_ccod = h.sitf_ccod " & vbCrlf & _
"					WHERE h.sitf_baprueba = 'S' " & vbCrlf & _
"					and c.pers_ncorr = '"&pers_ncorr&"')" & vbCrlf & _	
"        OR  " & vbCrlf & _
"           EXISTS ( SELECT 1 " & vbCrlf & _
"					from homologacion_destino hd " & vbCrlf & _
"					INNER JOIN homologacion h " & vbCrlf & _
"					ON hd.homo_ccod = h.homo_ccod " & vbCrlf & _
"					INNER JOIN homologacion_fuente hf " & vbCrlf & _
"					ON hf.homo_ccod = h.homo_ccod AND hf.asig_ccod  = b.asig_ccod " & vbCrlf & _
"					INNER JOIN asignaturas asig " & vbCrlf & _
"					ON asig.asig_ccod = hd.asig_ccod " & vbCrlf & _
"					INNER JOIN secciones secc " & vbCrlf & _
"					ON asig.asig_ccod = secc.asig_ccod " & vbCrlf & _
"					INNER JOIN cargas_academicas carg " & vbCrlf & _
"					ON secc.secc_ccod = carg.secc_ccod " & vbCrlf & _
"					INNER JOIN alumnos al " & vbCrlf & _
"					ON al.matr_ncorr = carg.matr_ncorr " & vbCrlf & _
"					INNER JOIN personas pers " & vbCrlf & _
"					ON pers.pers_ncorr = al.pers_ncorr and hd.asig_ccod <> hf.asig_ccod " & vbCrlf & _
"					INNER JOIN situaciones_finales s2c " & vbCrlf & _
"					ON carg.sitf_ccod = s2c.sitf_ccod " & vbCrlf & _
"					WHERE s2c.sitf_baprueba = 'S' " & vbCrlf & _
"					and carg.sitf_ccod <>'EQ' " & vbCrlf & _
"					and h.THOM_CCOD = 1 " & vbCrlf & _
"					AND al.emat_ccod = 1 " & vbCrlf & _
"					and pers.pers_ncorr = '" & pers_ncorr & "')" & vbCrlf & _
"		OR EXISTS (select  1 " & vbCrlf & _
"		   		  		   from equivalencias a " & vbCrlf & _
"					INNER JOIN cargas_academicas b1 " & vbCrlf & _
"					ON a.matr_ncorr = b1.matr_ncorr and a.secc_ccod = b1.secc_ccod and a.asig_ccod=b.asig_ccod " & vbCrlf & _
"					INNER JOIN secciones c " & vbCrlf & _
"					ON b1.secc_ccod = c.secc_ccod " & vbCrlf & _
"					INNER JOIN alumnos g " & vbCrlf & _
"					ON b1.matr_ncorr = g.matr_ncorr " & vbCrlf & _
"					INNER JOIN ofertas_academicas d " & vbCrlf & _
"					ON d.ofer_ncorr = g.ofer_ncorr " & vbCrlf & _
"					INNER JOIN planes_estudio e " & vbCrlf & _
"					ON e.plan_ccod = g.plan_ccod " & vbCrlf & _
"					INNER JOIN especialidades f " & vbCrlf & _
"					ON e.espe_ccod = f.espe_ccod " & vbCrlf & _
"					INNER JOIN personas h " & vbCrlf & _
"					ON g.pers_ncorr = h.pers_ncorr " & vbCrlf & _
"					INNER JOIN situaciones_finales sf " & vbCrlf & _
"					ON b1.sitf_ccod = sf.sitf_ccod " & vbCrlf & _
"					WHERE sf.sitf_baprueba = 'S' " & vbCrlf & _
"					and h.pers_ncorr = '" & pers_ncorr & "') " & vbCrlf & _
"        ) " & vbCrlf & _
"   AND b.plan_ccod = '" & plan_ccod & "'" & vbCrlf & _
"   AND NOT EXISTS (SELECT 1 " & vbCrlf & _
"					FROM MALLA_CURRICULAR MC " & vbCrlf & _
"					INNER JOIN " & vbCrlf & _
"                      (SELECT HOMO_CCOD,ASIG_CCOD_DESTINO, COUNT(*) NREQUISITOS, count(asig_ccod)NAPROBADOS " & vbCrlf & _
"                      FROM  " & vbCrlf & _
"                      (SELECT HD.HOMO_CCOD,HD.ASIG_CCOD ASIG_CCOD_DESTINO,HF.ASIG_CCOD ASIG_CCOD_FUENTE " & vbCrlf & _
"							FROM HOMOLOGACION_FUENTE HF " & vbCrlf & _
"							INNER JOIN HOMOLOGACION_DESTINO HD " & vbCrlf & _
"							ON HF.HOMO_CCOD = HD.HOMO_CCOD " & vbCrlf & _
"							) HOM LEFT OUTER JOIN " & vbCrlf & _
"                      (SELECT S.ASIG_CCOD " & vbCrlf & _
"							FROM SECCIONES S " & vbCrlf & _
"							INNER JOIN CARGAS_ACADEMICAS CA " & vbCrlf & _
"							ON S.SECC_CCOD = CA.SECC_CCOD " & vbCrlf & _
"							INNER JOIN ALUMNOS A " & vbCrlf & _
"							ON CA.MATR_NCORR = A.MATR_NCORR " & vbCrlf & _
"							INNER JOIN SITUACIONES_FINALES SF " & vbCrlf & _
"							ON SF.SITF_CCOD = CA.SITF_CCOD " & vbCrlf & _
"							WHERE SF.SITF_BAPRUEBA = 'S' " & vbCrlf & _
"							AND A.PERS_NCORR ='" & pers_ncorr & "') APRO " & vbCrlf & _
"                      ON HOM.ASIG_CCOD_FUENTE = APRO.ASIG_CCOD " & vbCrlf & _
"                      group by HOMO_CCOD,asig_ccod_destino)	PRUEBA " & vbCrlf & _
"                      ON MC.ASIG_CCOD = ASIG_CCOD_DESTINO AND MC.ASIG_CCOD=B.ASIG_CCOD " & vbCrlf & _
"					AND NREQUISITOS = NAPROBADOS " & vbCrlf & _
"					WHERE PLAN_CCOD = '" & plan_ccod & "') " & vbCrlf & _
") a " & vbCrlf & _
"	LEFT OUTER JOIN ( " & vbCrlf & _
"				SELECT a.asig_ccod, a.secc_ccod, c.matr_ncorr " & vbCrlf & _
"					FROM secciones a INNER JOIN cargas_academicas b " & vbCrlf & _
"					ON a.secc_ccod = b.secc_ccod and b.sitf_ccod is null " & vbCrlf & _
"					INNER JOIN alumnos c " & vbCrlf & _
"					ON b.matr_ncorr = c.matr_ncorr " & vbCrlf & _
"					WHERE c.emat_ccod = 1 " & vbCrlf & _
"      AND a.sede_ccod = '" & sede_ccod & "' " & vbCrlf & _
"      AND a.peri_ccod = '" & peri_ccod & "' " & vbCrlf & _
"	   AND c.pers_ncorr = '" & pers_ncorr & "'"& vbCrlf & _
" 	   AND c.emat_ccod='1') b " & vbCrlf & _
"	ON a.asig_ccod = b.asig_ccod " & vbCrlf & _
"INNER JOIN asignaturas c " & vbCrlf & _
"ON a.asig_ccod = c.asig_ccod " & vbCrlf & _
"LEFT OUTER JOIN  " & vbCrlf & _ 
"   ( select a.asig_ccod, 1 as reprobado  " & vbCrlf & _
"       from secciones a INNER JOIN cargas_academicas b " & vbCrlf & _
"					ON a.secc_ccod = b.secc_ccod " & vbCrlf & _
"					INNER JOIN situaciones_finales c " & vbCrlf & _
"					ON b.sitf_ccod = c.sitf_ccod " & vbCrlf & _
"					INNER JOIN alumnos d " & vbCrlf & _
"					ON b.matr_ncorr = d.matr_ncorr " & vbCrlf & _
"					WHERE d.emat_ccod = 1 " & vbCrlf & _
"        and d.pers_ncorr='" & pers_ncorr & "' " & vbCrlf & _
"        and sitf_baprueba='N' " & vbCrlf & _
"        and b.sitf_ccod not in ('EE') " & vbCrlf & _
"	  union all" & vbCrlf & _
"	  	select  " & vbCrlf & _
"			a.asig_ccod,1 as reprobado  " & vbCrlf & _
"		from equivalencias a " & vbCrlf & _
"					INNER JOIN cargas_academicas b " & vbCrlf & _
"					ON a.matr_ncorr = b.matr_ncorr " & vbCrlf & _
"					INNER JOIN secciones c " & vbCrlf & _
"					ON a.secc_ccod = b.secc_ccod " & vbCrlf & _
"					INNER JOIN situaciones_finales d " & vbCrlf & _
"					ON b.secc_ccod = c.secc_ccod " & vbCrlf & _
"					INNER JOIN alumnos e " & vbCrlf & _
"					ON b.sitf_ccod = d.sitf_ccod and b.matr_ncorr = e.matr_ncorr " & vbCrlf & _
"					INNER JOIN personas f " & vbCrlf & _
"					ON e.pers_ncorr = f.pers_ncorr " & vbCrlf & _
"					WHERE b.sitf_ccod not in ('EE') " & vbCrlf & _
"					and d.sitf_baprueba = 'N' " & vbCrlf & _
"					and f.pers_ncorr = '"& pers_ncorr &"') d" & vbCrlf & _
"  ON a.asig_ccod = d.asig_ccod " & vbCrLf



'destino=" select asig_ccod,secc_ccod,horario " & vbCrlf & _
'		" 		  from " & vbCrlf & _
'		"              (SELECT a.asig_ccod, a.secc_tdesc, a.secc_ccod, " & vbCrlf & _
'		"                   a.asig_ccod || '-' || a.secc_tdesc || ' -> ' || horario (a.secc_ccod) " & vbCrlf & _
'		"                         AS horario, " & vbCrlf & _
'		"                   a.secc_ncupo - NVL (COUNT (distinct c.secc_ccod), 0) " & vbCrlf & _
'		"              FROM secciones a, cargas_academicas c " & vbCrlf & _
'		"             WHERE a.secc_ccod = c.secc_ccod (+) " & vbCrlf & _
'		"               AND a.sede_ccod = '"&sede_ccod&"' " & vbCrlf & _
'		"               AND a.peri_ccod = '"&peri_ccod&"' " & vbCrlf & _
'		"               and asig_ccod='"&asig_ccod&"' " & vbCrlf & _
'		"             GROUP BY a.asig_ccod,  a.secc_ccod,  a.secc_tdesc,  a.secc_ncupo " & vbCrlf & _
'		"            HAVING a.secc_ncupo - NVL (COUNT (distinct c.secc_ccod), 0) > 0) a" 
		
'destino = " select a.asig_ccod,a.secc_ccod,a.horario,a.cupos " & vbCrlf & _
'			" 		  from " & vbCrlf & _
'			"              (SELECT a.asig_ccod, a.secc_tdesc, a.secc_ccod, " & vbCrlf & _
'			"                   a.asig_ccod + '-' + a.secc_tdesc + ' -> ' + protic.horario (a.secc_ccod) " & vbCrlf & _
'			"                         AS horario, " & vbCrlf & _
'			"                   a.secc_ncupo - isnull(COUNT (distinct c.secc_ccod), 0) as cupos" & vbCrlf & _
'			"              FROM secciones a, cargas_academicas c " & vbCrlf & _
'			"             WHERE a.secc_ccod *= c.secc_ccod " & vbCrlf & _
'			"               AND a.sede_ccod = '"&sede_ccod&"' " & vbCrlf & _
'			"               AND a.peri_ccod = '"&peri_ccod&"' " & vbCrlf & _
'			"               and asig_ccod='"&asig_ccod&"' " & vbCrlf & _
'			"             GROUP BY a.asig_ccod,  a.secc_ccod,  a.secc_tdesc,  a.secc_ncupo " & vbCrlf & _
'			"            HAVING a.secc_ncupo - isnull(COUNT (distinct c.secc_ccod), 0) > 0) a"

destino = " select a.asig_ccod,a.secc_ccod,a.horario,a.cupos " & vbCrlf & _
			" 		  from " & vbCrlf & _
			"              (SELECT a.asig_ccod, a.secc_tdesc, a.secc_ccod, " & vbCrlf & _
			"                   a.asig_ccod + '-' + a.secc_tdesc + ' -> ' + protic.horario (a.secc_ccod) " & vbCrlf & _
			"                         AS horario, " & vbCrlf & _
			"                   a.secc_ncupo - isnull(COUNT (distinct c.secc_ccod), 0) as cupos" & vbCrlf & _
			"              FROM secciones a LEFT OUTER JOIN cargas_academicas c " & vbCrlf & _
			"              ON a.secc_ccod = c.secc_ccod " & vbCrlf & _
			"              WHERE a.sede_ccod = '"&sede_ccod&"' " & vbCrlf & _
			"               AND a.peri_ccod = '"&peri_ccod&"' " & vbCrlf & _
			"               and asig_ccod='"&asig_ccod&"' " & vbCrlf & _
			"             GROUP BY a.asig_ccod,  a.secc_ccod,  a.secc_tdesc,  a.secc_ncupo " & vbCrlf & _
			"            HAVING a.secc_ncupo - isnull(COUNT (distinct c.secc_ccod), 0) > 0) a"
			
'response.Write("<pre>" & destino & "</pre>")

'response.Write("<pre>"&asig_disponibles&"</pre>")
seccion.consultar 		destino 
seccion.agregacampoparam "secc_ccod","destino","("&destino&") a"

'seccion.agregacampoparam "secc_ccod","destino","(SELECT a.asig_ccod, a.secc_tdesc, a.secc_ccod, " & _
'		"                   a.asig_ccod || '-' || a.secc_tdesc || ' -> ' || horario (a.secc_ccod) " & _
'		"                         AS horario, " & _
'		"                   a.secc_ncupo - NVL (COUNT (distinct c.secc_ccod), 0) " & _
'		"              FROM secciones a, cargas_academicas c " & _
'		"             WHERE a.secc_ccod = c.secc_ccod (+) " & _
'		"               AND a.sede_ccod = '"&sede_ccod&"' " & _
'		"               AND a.peri_ccod = '"&peri_ccod&"' " & _
'		"               and asig_ccod='"&asig_ccod&"' " & _
'		"               and asig_ccod not in (select distinct c.asig_ccod from (SELECT DISTINCT b.asig_ccod,b.mall_ccod, b.nive_ccod " & vbCrlf & _
'						"  FROM malla_curricular b" & vbCrlf & _
'						" WHERE completo_requisitos_asignatura (mall_ccod, '" & pers_ncorr & "') = 0" & vbCrlf & _
'						"   AND NOT (  " & vbCrlf & _
'						"			EXISTS (SELECT 1 " & vbCrlf & _
'						"                    FROM secciones sa," & vbCrlf & _
'						"                         cargas_academicas sb," & vbCrlf & _
'						"                         alumnos sc," & vbCrlf & _
'						"                         situaciones_finales sd" & vbCrlf & _
'						"                   WHERE sa.secc_ccod = sb.secc_ccod" & vbCrlf & _
'						"                     AND sa.asig_ccod = b.asig_ccod" & vbCrlf & _
'						"                     AND sb.matr_ncorr = sc.matr_ncorr" & vbCrlf & _
'						"                     AND sb.sitf_ccod = sd.sitf_ccod" & vbCrlf & _
'						"                     AND sd.sitf_baprueba = 'S'" & vbCrlf & _
'						"                     AND sc.pers_ncorr = '" & pers_ncorr & "')" & vbCrlf & _
'						"        OR  " & vbCrlf & _
'						"           EXISTS ( SELECT 1 " & vbCrlf & _
'						"                    FROM convalidaciones s2a, alumnos s2b, situaciones_finales s2c " & vbCrlf & _
'						"                   WHERE s2a.matr_ncorr=s2b.matr_ncorr" & vbCrlf & _
'						"                     AND s2a.asig_ccod = b.asig_ccod" & vbCrlf & _
'						"                     AND s2a.sitf_ccod = s2c.sitf_ccod" & vbCrlf & _
'						"                     AND s2c.sitf_baprueba = 'S'" & vbCrlf & _
'						"                     AND s2b.pers_ncorr = '" & pers_ncorr & "')" & vbCrlf & _
'						"        ) " & vbCrlf & _
'					"   AND b.plan_ccod = '" & plan_ccod & "'" & vbCrlf & _
'						") a, " & vbCrlf & _
'						"	(SELECT a.asig_ccod, a.secc_ccod, c.matr_ncorr  " & vbCrlf & _
'						"	   FROM secciones a, cargas_academicas b, alumnos c " & vbCrlf & _
'						"	  WHERE a.secc_ccod = b.secc_ccod " & vbCrlf & _
'						"	   AND b.matr_ncorr = c.matr_ncorr " & vbCrlf & _
'						"      AND a.sede_ccod = '" & sede_ccod & "' " & vbCrlf & _
'						"      AND a.peri_ccod = '" & peri_ccod & "' " & vbCrlf & _
'						"	   AND c.pers_ncorr = '" & pers_ncorr & "') b, " & vbCrlf & _
'						"	asignaturas c, " & vbCrlf & _
'						"   ( select a.asig_ccod, 1 as reprobado  " & vbCrlf & _
'						"       from secciones a, cargas_academicas b, situaciones_finales c, alumnos d " & vbCrlf & _
'						"      where a.secc_ccod=b.secc_ccod  " & vbCrlf & _
'						"        and b.sitf_ccod=c.sitf_ccod  " & vbCrlf & _
'						"        and b.matr_ncorr=d.matr_ncorr " & vbCrlf & _
'						"        and d.pers_ncorr='" & pers_ncorr & "' " & vbCrlf & _
'						"        and sitf_baprueba='N') d" & vbCrlf & _
'						"  where a.asig_ccod=b.asig_ccod (+) " & vbCrlf & _
'						"    and a.asig_ccod=d.asig_ccod (+) " & vbCrlf & _
'						"    and a.asig_ccod=c.asig_ccod ) " & _
'		"             GROUP BY a.asig_ccod,  a.secc_ccod,  a.secc_tdesc,  a.secc_ncupo " & _
'		"            HAVING a.secc_ncupo - NVL (COUNT (distinct c.secc_ccod), 0) > 0) a"

'response.Write(destino)
seccion.siguientef


asig_origen.consultar asig_disponibles
asig_origen.agregacampoparam "asignatura","destino","("&asig_disponibles&") a"
asig_origen.siguientef
asignatura=conectar.consultauno("select asig_tdesc from asignaturas where asig_ccod='"&asig_ccod&"'")
end if
%>

<html>
<head>
<title>B&uacute;squeda de Secciones</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<!--   -->
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
<!--


function enviar(formulario){
			formulario.action ="busca_secciones.asp";//?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo+"&asig_ccod="+asignatura;
			formulario.submit();
}
function guardar(formulario){
	if (preValidaFormulario(formulario)){
			formulario.method="post";
			formulario.action="guardar_secciones.asp";
			formulario.submit();
	}
}
function cerrar(formulario){
	formulario.method="post";
	formulario.action="cerrar_homologacion.asp";
	formulario.submit();
}

function abrir(){
	self.opener.location.reload();
	window.close();
}

function salir(){
	self.opener.location.reload();
	window.close();
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_nbGroup(event, grpName) { //v6.0
  var i,img,nbArr,args=MM_nbGroup.arguments;
  if (event == "init" && args.length > 2) {
    if ((img = MM_findObj(args[2])) != null && !img.MM_init) {
      img.MM_init = true; img.MM_up = args[3]; img.MM_dn = img.src;
      if ((nbArr = document[grpName]) == null) nbArr = document[grpName] = new Array();
      nbArr[nbArr.length] = img;
      for (i=4; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
        if (!img.MM_up) img.MM_up = img.src;
        img.src = img.MM_dn = args[i+1];
        nbArr[nbArr.length] = img;
    } }
  } else if (event == "over") {
    document.MM_nbOver = nbArr = new Array();
    for (i=1; i < args.length-1; i+=3) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = (img.MM_dn && args[i+2]) ? args[i+2] : ((args[i+1])? args[i+1] : img.MM_up);
      nbArr[nbArr.length] = img;
    }
  } else if (event == "out" ) {
    for (i=0; i < document.MM_nbOver.length; i++) {
      img = document.MM_nbOver[i]; img.src = (img.MM_dn) ? img.MM_dn : img.MM_up; }
  } else if (event == "down") {
    nbArr = document[grpName];
    if (nbArr)
      for (i=0; i < nbArr.length; i++) { img=nbArr[i]; img.src = img.MM_up; img.MM_dn = 0; }
    document[grpName] = nbArr = new Array();
    for (i=2; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = img.MM_dn = (args[i+1])? args[i+1] : img.MM_up;
      nbArr[nbArr.length] = img;
  } }
}
//-->
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="701" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="397" valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td>
                  <%pagina.DibujarLenguetas Array("Buscador de Asignaturas"), 1 %>
                </td>
              <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>              
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE">
				  <div align="left">
				    <table width="100%" cellpadding="0" cellspacing="0">
				      <tr>
				        <td>&nbsp;</td>
			          </tr>
			        </table>
			      </div>				  
<form action="" method="get" name="buscador">
                    <table width="98%"  border="0">
                      <tr>
                        <td width="81%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td nowrap> <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">C&oacute;d. 
                                        de Asignatura Cursar &nbsp;<strong> 
                                        <input type="text" name="asig_ccod" size="7" maxlength="12" id="NU-N" value="<%=asig_ccod%>" 			onKeyUp="this.value=this.value.toUpperCase();"> 
                                        <input type="hidden" name="matr_ncorr" value="<%=matr_ncorr%>">
  <input type="hidden" name="plan_ccod" value="<%=plan_ccod%>">
  <input type="hidden" name="peri_ccod" value="<%=peri_ccod%>">
  <input type="hidden" name="sede_ccod" value="<%=sede_ccod%>">
  <input type="hidden" name="pers_ncorr" value="<%=pers_ncorr%>"> 
                                       </strong></font></div>
                                  <div align="center"></div></td>
                              </tr>
                            </table></td>
                        <td width="19%"><div align="center"><%botonera.dibujaboton "buscar"%></div></td>
                      </tr>
                    </table>
				  </form></td><td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
      </tr>
    </table>	
	<br>		
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td> 
                  <%pagina.DibujarLenguetas Array("Inscribir Equivalencias"), 1 %>
                </td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				    &nbsp;
				    <form name="edicion">
					<%if asig_ccod<>"" then %>
				 <table width="95%" align="center" cellpadding="0" cellspacing="0">
                        <tr> 
                          <td align="left"><table width="50%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                  <td>Resultado de la B&uacute;squeda:</td>
                                </tr>
                                <tr>
                                  <td nowrap>Asignatura:<strong><%=asignatura%>&nbsp;&nbsp;&nbsp;</strong>Secci&oacute;n<strong>:</strong> 
                                    <% if asig_ccod <> "" then%>
								    <strong>
								  <%seccion.dibujacampo("secc_ccod")%>
								  </strong>
								  <%end if %>
                                  </td>
                                </tr>
                                <tr>
                                </tr>
                              </table>
                             
                            <br>
                              <table width="100%" align="center" cellpadding="0" cellspacing="0">
                                <tr> 
                                  <td width="100%"></td>
                                </tr>
                                <tr> 
                                  <td align="center" valign="top">Equivalente a: <%asig_origen.dibujacampo("asignatura")%>
                                  </td>
                                </tr>
                              </table>
                              <div align="left"><input type="hidden" name="d[0][matr_ncorr]" value="<%=matr_ncorr%>"> <br>
                            </div></td></tr>
                      </table><%end if %>
				    </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="237" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center"></div></td>
                      <td><div align="center"><%botonera.dibujaboton "guardar"%></div></td>
                      <td><div align="center">
                        <%botonera.dibujaboton "salir"%>
                      </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="125" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
		  </td>
        </tr>
      </table>	
    <p>&nbsp;</p></td>
  </tr>  
</table>
</body>
</html>

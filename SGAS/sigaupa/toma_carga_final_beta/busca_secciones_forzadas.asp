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
'FECHA ACTUALIZACION		: 07/03/2013
'ACTUALIZADO POR			  : Luis Herrera G.
'MOTIVO				          : Corregir código, eliminar sentencia *=, =*
'LINEA				          : 191, 240, 241, 473
'********************************************************************
set pagina = new CPagina
set botonera = new CFormulario
set errores 	= new cErrores
botonera.carga_parametros "toma_carga_alfa.xml", "BotoneraSeccionesEQ"

'for each k in request.QueryString()
'	response.Write(k&" = "&request.QueryString(k)&"<br>")
'next

carr_ccod   =   request.QueryString("a[0][carr_ccod]")
asig_ccod	=	request.querystring("a[0][asig_ccod]")
peri_ccod	=	request.QueryString("peri_ccod")
plan_ccod	=	request.QueryString("plan_ccod")
sede_ccod	=	request.QueryString("sede_ccod")
pers_ncorr	=	request.QueryString("pers_ncorr")
matr_ncorr	=	request.QueryString("matr_ncorr")
'response.Write("asig_ccod "& asig_ccod)
set conectar		=	new cconexion
set negocio			=	new cnegocio
set seccion 		=	new cformulario
set asig_origen		=	new cformulario
set asignaturas		=	new cformulario

conectar.inicializar "upacifico"
negocio.inicializa conectar

'espe_ccod=conectar.consultaUno("Select espe_ccod from planes_estudio where cast(plan_ccod as varchar)='"&plan_ccod&"'")
'cadena_planes=conectar.consultaUno("select ltrim(rtrim(protic.obtener_planes('"&espe_ccod&"')))")
'response.Write("cadena planes "&cadena_planes)
'-------------------------------------------Seleccionar asignatura para equivalencia de una lista sin escribir su código-----
'-----------------------------------------------------------msandoval 19-02-2005---------------------------------------------
set fbusqueda = new cFormulario
fbusqueda.carga_parametros "toma_carga_alfa.xml", "buscador"
fbusqueda.inicializar conectar
peri = peri_ccod'negocio.obtenerPeriodoAcademico ( "planificacion" ) 
sede = sede_ccod'negocio.obtenerSede

consulta="Select '"&carr_ccod&"' as carr_ccod, '"&asig_ccod&"' as asig_ccod"

fbusqueda.consultar consulta

consulta = "select distinct a.carr_ccod, a.carr_tdesc,d.asig_ccod,d.asig_tdesc+' - '+cast(d.asig_ccod as varchar) as asig_tdesc " & vbCrLf & _
		   " from carreras a,secciones b, bloques_horarios c, asignaturas d " & vbCrLf & _
		   " where a.carr_ccod=b.carr_ccod " & vbCrLf & _
		   " and  b.secc_ccod=c.secc_ccod " & vbCrLf & _
		   " and b.asig_ccod=d.asig_ccod " & vbCrLf & _
		   " and cast(b.sede_ccod as varchar)='"&sede&"' " & vbCrLf & _
		   " and cast(b.peri_ccod as varchar)='"&peri&"' " 
	

fbusqueda.inicializaListaDependiente "lBusqueda", consulta

fbusqueda.siguiente


'---------------------------------------------------------Fin del ingreso de la consulta-------------------------------------



seccion.carga_parametros 		"toma_carga_alfa.xml", "toma_carga"
seccion.inicializar				conectar

asig_origen.carga_parametros	"toma_carga_alfa.xml", "toma_carga"		
asig_origen.inicializar			conectar
if asig_ccod<>"" then
'asig_disponibles= "select distinct c.asig_ccod, mall_ccod, cast(c.asig_ccod as  varchar)+ ' - ' + c.asig_tdesc as asignatura, asig_nhoras, b.secc_ccod, " & vbCrLf & _
'				  " '" & matr_ncorr & "' as matr_ncorr , a.nive_ccod, isnull(d.reprobado,0) as reprobado  " & vbCrLf & _
'                  " from (SELECT DISTINCT b.mall_ccod, b.asig_ccod, b.nive_ccod " & vbCrLf & _
'                  "  FROM malla_curricular b" & vbCrLf & _
'                  "  WHERE cast(b.plan_ccod as varchar) ='" & plan_ccod & "' " & vbCrLf & _
'				  " AND protic.completo_requisitos_asignatura (mall_ccod, '"&pers_ncorr&"') = 0 " & vbCrLf & _
'                  "   AND NOT (  " & vbCrLf & _
'				  "			EXISTS (SELECT 1 " & vbCrLf & _
'				  "                 FROM secciones sa, " & vbCrLf & _
'				  "                         cargas_academicas sb, " & vbCrLf & _
'				  "                         alumnos sc, " & vbCrLf & _
'				  "                         situaciones_finales sd " & vbCrLf & _
'                  "                   WHERE sa.secc_ccod = sb.secc_ccod " & vbCrLf & _
'                  "                     AND sa.asig_ccod = b.asig_ccod " & vbCrLf & _
'                  "                     AND sb.matr_ncorr = sc.matr_ncorr " & vbCrLf & _
'                  "                     AND sb.sitf_ccod = sd.sitf_ccod " & vbCrLf & _
'                  "                     AND sd.sitf_baprueba = 'S' " & vbCrLf & _
'                  "                     AND sc.emat_ccod = 1 " & vbCrLf & _
'                  "                     AND cast(sc.pers_ncorr as varchar)= '" & pers_ncorr & "') " & vbCrLf & _
'                  "        OR  " & vbCrLf & _
'				  "           EXISTS (  select 1 " & vbCrLf & _
'				  "			from  " & vbCrLf & _
'				  "				 convalidaciones a " & vbCrLf & _
'			 	  "				 , alumnos b1 " & vbCrLf & _
'				  "				 ,personas c " & vbCrLf & _
'				  "				 , actas_convalidacion d " & vbCrLf & _
'				  "				 , ofertas_academicas e " & vbCrLf & _
'				  "				 , planes_estudio f " & vbCrLf & _
'				  "				 ,especialidades g " & vbCrLf & _
'				  "				 ,situaciones_finales h " & vbCrLf & _
'				  "			where " & vbCrLf & _
'				  "				 a.matr_ncorr=b1.matr_ncorr " & vbCrLf & _
'				  "				 and b1.pers_ncorr=c.pers_ncorr " & vbCrLf & _
'				  "				 and a.acon_ncorr=d.acon_ncorr " & vbCrLf & _
'				  "				 and b1.ofer_ncorr=e.ofer_ncorr " & vbCrLf & _
'				  "				 and b1.plan_ccod=f.plan_ccod " & vbCrLf & _
'				  "				 and f.espe_ccod=g.espe_ccod " & vbCrLf & _
'				  "				 and a.asig_ccod=b.asig_ccod " & vbCrLf & _
'				  "				 and a.sitf_ccod=h.sitf_ccod " & vbCrLf & _
'				  "				 and h.sitf_baprueba='S' " & vbCrLf & _
'				  "			     and cast(c.pers_ncorr as varchar)='" & pers_ncorr & "')" & vbCrLf & _
'				  "        OR  " & vbCrLf & _
'				  "           EXISTS ( SELECT 1 " & vbCrLf & _
'				  "                		from homologacion_destino hd, homologacion_fuente hf,homologacion h,asignaturas asig, " & vbCrLf & _
'				  "                		secciones secc,cargas_academicas carg, alumnos al, personas pers, situaciones_finales s2c " & vbCrLf & _
'				  "                		where hd.homo_ccod=h.homo_ccod " & vbCrLf & _
'				  "                		and hf.homo_ccod=h.homo_ccod " & vbCrLf & _
'				  "                		and asig.asig_ccod=hd.asig_ccod " & vbCrLf & _
'				  "                		and asig.asig_ccod=secc.asig_ccod " & vbCrLf & _
'				  "                		and secc.secc_ccod=carg.secc_ccod " & vbCrLf & _
'				  "                     	AND hf.asig_ccod  = b.asig_ccod " & vbCrLf & _
'				  "                		and al.matr_ncorr=carg.matr_ncorr " & vbCrLf & _
'				  "                		and pers.pers_ncorr=al.pers_ncorr " & vbCrLf & _
'				  "        		 		and hd.asig_ccod <> hf.asig_ccod " & vbCrLf & _
'				  "                     	AND carg.sitf_ccod = s2c.sitf_ccod " & vbCrLf & _
'				  "                     	AND s2c.sitf_baprueba = 'S'" & vbCrLf & _
'				  "                		and carg.sitf_ccod <>'EQ' " & vbCrLf & _
'				  "          		 		and h.THOM_CCOD = 1 " & vbCrLf & _
'				  "                       AND al.emat_ccod = 1" & vbCrLf & _
'				  "                		and cast(pers.pers_ncorr as varchar)='" & pers_ncorr & "')" & vbCrLf & _
'				  "		OR EXISTS (select  1 " & vbCrLf & _
'				  "		   		  		   from " & vbCrLf & _
'				  "								equivalencias a " & vbCrLf & _
'				  "								, cargas_academicas b1 " & vbCrLf & _
'				  "								, secciones c " & vbCrLf & _
'			      "								, ofertas_academicas d " & vbCrLf & _
'				  "								, planes_estudio e " & vbCrLf & _
'				  "								, especialidades f " & vbCrLf & _
'				  "								, alumnos g " & vbCrLf & _
'				  "								, personas h " & vbCrLf & _
'				  "								, situaciones_finales sf " & vbCrLf & _
'				  "							where " & vbCrLf & _
'				  "								 a.matr_ncorr=b1.matr_ncorr " & vbCrLf & _
'				  "								 and a.secc_ccod=b1.secc_ccod " & vbCrLf & _
'				  "								 and b1.secc_ccod=c.secc_ccod " & vbCrLf & _
'				  "								 and b1.matr_ncorr=g.matr_ncorr " & vbCrLf & _
'				  "								 and d.ofer_ncorr=g.ofer_ncorr " & vbCrLf & _
'				  "								 and e.plan_ccod=g.plan_ccod " & vbCrLf & _
'				  "								 and e.espe_ccod=f.espe_ccod " & vbCrLf & _
'				  "								 and g.pers_ncorr=h.pers_ncorr " & vbCrLf & _
'				  "								 and a.asig_ccod=b.asig_ccod " & vbCrLf & _
'				  "								 and b1.sitf_ccod=sf.sitf_ccod " & vbCrLf & _
'				  "								 and sf.sitf_baprueba='S' " & vbCrLf & _
'				  "								 and cast(h.pers_ncorr as varchar)='" & pers_ncorr & "') " & vbCrLf & _
'				  "        ) " & vbCrLf & _
'			      "     AND cast(b.plan_ccod as varchar) ='" & plan_ccod & "'" & vbCrLf & _
'				  "   AND NOT EXISTS (SELECT 1 " & vbCrLf & _
'				  "                      FROM  " & vbCrLf & _
'				  "                      MALLA_CURRICULAR MC, " & vbCrLf & _
'				  "                      (SELECT HOMO_CCOD,ASIG_CCOD_DESTINO, COUNT(*) NREQUISITOS, count(asig_ccod)NAPROBADOS " & vbCrLf & _
'				  "                      FROM  " & vbCrLf & _
'				  "                      (SELECT HD.HOMO_CCOD,HD.ASIG_CCOD ASIG_CCOD_DESTINO,HF.ASIG_CCOD ASIG_CCOD_FUENTE  " & vbCrLf & _
'				  "                       FROM HOMOLOGACION_FUENTE HF,  " & vbCrLf & _
'				  "                       HOMOLOGACION_DESTINO HD " & vbCrLf & _
'				  "                       WHERE HF.HOMO_CCOD=HD.HOMO_CCOD ) HOM, " & vbCrLf & _
'				  "                      (SELECT S.ASIG_CCOD  " & vbCrLf & _
'			 	  "                       FROM " & vbCrLf & _
' 				  "                      SECCIONES S, " & vbCrLf & _
'				  "                       CARGAS_ACADEMICAS CA, " & vbCrLf & _
'				  "                       ALUMNOS A, " & vbCrLf & _
'				  "                       SITUACIONES_FINALES SF " & vbCrLf & _
'				  "                       WHERE S.SECC_CCOD = CA.SECC_CCOD " & vbCrLf & _
'				  "                       	   AND CA.MATR_NCORR = A.MATR_NCORR  " & vbCrLf & _
'				  "                      	   AND SF.SITF_CCOD=CA.SITF_CCOD " & vbCrLf & _
'				  "                      	   AND SF.SITF_BAPRUEBA='S'   " & vbCrLf & _
'				  "                      	   AND cast(A.PERS_NCORR as varchar)= '" & pers_ncorr & "') APRO " & vbCrLf & _
'				  "                      WHERE HOM.ASIG_CCOD_FUENTE *= APRO.ASIG_CCOD  " & vbCrLf & _
'				  "                      group by HOMO_CCOD,asig_ccod_destino)	PRUEBA " & vbCrLf & _
'				  "                      WHERE MC.ASIG_CCOD=ASIG_CCOD_DESTINO " & vbCrLf & _
'				  "                      AND MC.ASIG_CCOD=B.ASIG_CCOD " & vbCrLf & _
'				  " 					 AND NREQUISITOS=NAPROBADOS " & vbCrLf & _
'				  "                      AND cast(PLAN_CCOD as varchar) ='" & plan_ccod & "') " & vbCrLf & _
'    			  " ) a, " & vbCrLf & _
'				  "	(SELECT a.asig_ccod, a.secc_ccod, c.matr_ncorr  " & vbCrLf & _
'				  "	   FROM secciones a, cargas_academicas b, alumnos c " & vbCrLf & _
'				  "	  WHERE a.secc_ccod = b.secc_ccod " & vbCrLf & _
'				  "	   AND b.matr_ncorr = c.matr_ncorr and b.sitf_ccod is null " & vbCrLf & _
'				  "       AND c.emat_ccod = 1" & vbCrLf & _
'                  "       AND cast(a.sede_ccod as varchar)= '" & sede_ccod & "' " & vbCrLf & _
'				  "       AND cast(a.peri_ccod as varchar)= '" & peri_ccod & "' " & vbCrLf & _
'				  "	   AND cast(c.pers_ncorr as varchar)= '" & pers_ncorr & "' " & vbCrLf & _
'				  " 	   AND cast(c.emat_ccod as varchar)='1' " & vbCrLf & _
'				  "       union " & vbCrLf & _
'				  "       select null,null,null) b, " & vbCrLf & _
'				  "	asignaturas c, " & vbCrLf & _
'				  "   ( select a.asig_ccod, 1 as reprobado  " & vbCrLf & _
'				  "       from secciones a, cargas_academicas b, situaciones_finales c, alumnos d " & vbCrLf & _
'				  "      where a.secc_ccod=b.secc_ccod  " & vbCrLf  & _
'				  "        and b.sitf_ccod=c.sitf_ccod  " & vbCrLf & _
'				  "        and b.matr_ncorr=d.matr_ncorr " & vbCrLf & _
'				  "        AND d.emat_ccod = 1 " & vbCrLf & _
'				  "        and cast(d.pers_ncorr as varchar)='" & pers_ncorr & "' " & vbCrLf & _
'				  "        and sitf_baprueba='N' " & vbCrLf & _
'				  "        and b.sitf_ccod not in ('EE') " & vbCrLf & _
'				  "	  union all" & vbCrLf & _
'				  "	  	select  " & vbCrLf & _
'				  "			a.asig_ccod,1 as reprobado  " & vbCrLf & _
'				  "		from  " & vbCrLf & _
'				  "			 equivalencias a,  " & vbCrLf & _
'				  "			 cargas_academicas b,  " & vbCrLf & _
'				  "			 secciones c,  " & vbCrLf & _
'				  "			 situaciones_finales d,  " & vbCrLf & _
'				  "			 alumnos e,  " & vbCrLf & _
'				  "			 personas f " & vbCrLf & _
'				  "	  where a.matr_ncorr=b.matr_ncorr  " & vbCrLf & _
'				  "		  and a.secc_ccod=b.secc_ccod  " & vbCrLf & _
'				  "		  and b.secc_ccod=c.secc_ccod " & vbCrLf & _
'				  "		  and b.sitf_ccod=d.sitf_ccod " & vbCrLf & _
'				  "		  and b.matr_ncorr=e.matr_ncorr " & vbCrLf & _
'				  "		  and e.pers_ncorr=f.pers_ncorr " & vbCrLf & _
'				  "		  and b.sitf_ccod not in ('EE') " & vbCrLf & _
'				  "		  and d.sitf_baprueba='N' " & vbCrLf & _
'				  "		  and cast(f.pers_ncorr as varchar)='" & pers_ncorr & "'" & vbCrLf & _
'				  "          union " & vbCrLf & _
'				  "          select null,null) d " & vbCrLf & _
'				  "  where a.asig_ccod *=b.asig_ccod  " & vbCrLf & _
'				  "    and a.asig_ccod *=d.asig_ccod  " & vbCrLf & _
'				  "    and a.asig_ccod=c.asig_ccod "
'-------------------------------------------------------------------------------INICIO CONSULTA ACTUALIZADA(SQLServer 2008)
asig_disponibles = "select distinct c.asig_ccod, " & vbCrLf & _
"                mall_ccod, " & vbCrLf & _
"                cast(c.asig_ccod as varchar) + ' - ' " & vbCrLf & _
"                + c.asig_tdesc         as asignatura, " & vbCrLf & _
"                asig_nhoras, " & vbCrLf & _
"                b.secc_ccod, " & vbCrLf & _
"                '" & matr_ncorr & "'           as matr_ncorr, " & vbCrLf & _
"                a.nive_ccod, " & vbCrLf & _
"                isnull(d.reprobado, 0) as reprobado " & vbCrLf & _
"from   (select distinct b.mall_ccod, " & vbCrLf & _
"                        b.asig_ccod, " & vbCrLf & _
"                        b.nive_ccod " & vbCrLf & _
"        from   malla_curricular b " & vbCrLf & _
"        where  cast(b.plan_ccod as varchar) = '" & plan_ccod & "' " & vbCrLf & _
"               and protic.completo_requisitos_asignatura (mall_ccod, " & vbCrLf & _
"                   '"&pers_ncorr&"') = 0 " & vbCrLf & _
"               and not ( exists (select 1 " & vbCrLf & _
"                                 from   secciones as sa " & vbCrLf & _
"                                        join cargas_academicas as sb " & vbCrLf & _
"                                          on sa.secc_ccod = sb.secc_ccod " & vbCrLf & _
"                                        join alumnos as sc " & vbCrLf & _
"                                          on sb.matr_ncorr = sc.matr_ncorr " & vbCrLf & _
"                                             and cast(sc.pers_ncorr as varchar) " & vbCrLf & _
"                                                 = " & vbCrLf & _
"                                                 '" & pers_ncorr & "' " & vbCrLf & _
"                                             and sc.emat_ccod = 1 " & vbCrLf & _
"                                        join situaciones_finales as sd " & vbCrLf & _
"                                          on sb.sitf_ccod = sd.sitf_ccod " & vbCrLf & _
"                                             and sd.sitf_baprueba = 'S' " & vbCrLf & _
"                                 where  sa.asig_ccod = b.asig_ccod) " & vbCrLf & _
"                          or exists (select 1 " & vbCrLf & _
"                                     from   convalidaciones as a " & vbCrLf & _
"                                            join alumnos as b1 " & vbCrLf & _
"                                              on a.matr_ncorr = b1.matr_ncorr " & vbCrLf & _
"                                            join personas as c " & vbCrLf & _
"                                              on b1.pers_ncorr = c.pers_ncorr " & vbCrLf & _
"                                                 and cast(c.pers_ncorr as " & vbCrLf & _
"                                                          varchar) = " & vbCrLf & _
"                                                     '" & pers_ncorr & "' " & vbCrLf & _
"                                            join actas_convalidacion as d " & vbCrLf & _
"                                              on a.acon_ncorr = d.acon_ncorr " & vbCrLf & _
"                                            join ofertas_academicas as e " & vbCrLf & _
"                                              on b1.ofer_ncorr = e.ofer_ncorr " & vbCrLf & _
"                                            join planes_estudio as f " & vbCrLf & _
"                                              on b1.plan_ccod = f.plan_ccod " & vbCrLf & _
"                                            join especialidades as g " & vbCrLf & _
"                                              on f.espe_ccod = g.espe_ccod " & vbCrLf & _
"                                            join situaciones_finales as h " & vbCrLf & _
"                                              on a.sitf_ccod = h.sitf_ccod " & vbCrLf & _
"                                                 and h.sitf_baprueba = 'S' " & vbCrLf & _
"                                     where  a.asig_ccod = b.asig_ccod) " & vbCrLf & _
"                          or exists (select 1 " & vbCrLf & _
"                                     from   homologacion_destino as hd " & vbCrLf & _
"                                            join homologacion as h " & vbCrLf & _
"                                              on hd.homo_ccod = h.homo_ccod " & vbCrLf & _
"                                                 and h.thom_ccod = 1 " & vbCrLf & _
"                                            join homologacion_fuente as hf " & vbCrLf & _
"                                              on h.homo_ccod = hf.homo_ccod " & vbCrLf & _
"                                                 and " & vbCrLf & _
"                                    hd.asig_ccod <> hf.asig_ccod " & vbCrLf & _
"                                            join asignaturas as asig " & vbCrLf & _
"                                              on hd.asig_ccod = asig.asig_ccod " & vbCrLf & _
"                                            join secciones as secc " & vbCrLf & _
"                                              on asig.asig_ccod = secc.asig_ccod " & vbCrLf & _
"                                            join cargas_academicas as carg " & vbCrLf & _
"                                              on secc.secc_ccod = carg.secc_ccod " & vbCrLf & _
"                                                 and carg.sitf_ccod <> 'EQ' " & vbCrLf & _
"                                            join situaciones_finales as s2c " & vbCrLf & _
"                                              on carg.sitf_ccod = s2c.sitf_ccod " & vbCrLf & _
"                                                 and s2c.sitf_baprueba = 'S' " & vbCrLf & _
"                                            join alumnos as al " & vbCrLf & _
"                                              on carg.matr_ncorr = al.matr_ncorr " & vbCrLf & _
"                                                 and al.emat_ccod = 1 " & vbCrLf & _
"                                            join personas as pers " & vbCrLf & _
"                                              on al.pers_ncorr = pers.pers_ncorr " & vbCrLf & _
"                                                 and cast(pers.pers_ncorr as " & vbCrLf & _
"                                                          varchar) = " & vbCrLf & _
"                                                     '" & pers_ncorr & "' " & vbCrLf & _
"                                     where  hf.asig_ccod = b.asig_ccod) " & vbCrLf & _
"                          or exists (select 1 " & vbCrLf & _
"                                     from   equivalencias as a " & vbCrLf & _
"                                            join cargas_academicas as b1 " & vbCrLf & _
"                                              on a.matr_ncorr = b1.matr_ncorr " & vbCrLf & _
"                                                 and a.secc_ccod = b1.secc_ccod " & vbCrLf & _
"                                            join secciones as c " & vbCrLf & _
"                                              on b1.secc_ccod = c.secc_ccod " & vbCrLf & _
"                                            join alumnos as g " & vbCrLf & _
"                                              on b1.matr_ncorr = g.matr_ncorr " & vbCrLf & _
"                                            join situaciones_finales as sf " & vbCrLf & _
"                                              on b1.sitf_ccod = sf.sitf_ccod " & vbCrLf & _
"                                                 and sf.sitf_baprueba = 'S' " & vbCrLf & _
"                                            join personas as h " & vbCrLf & _
"                                              on g.pers_ncorr = h.pers_ncorr " & vbCrLf & _
"                                                 and cast(h.pers_ncorr as " & vbCrLf & _
"                                                          varchar) = " & vbCrLf & _
"                                                     '" & pers_ncorr & "' " & vbCrLf & _
"                                            join ofertas_academicas as d " & vbCrLf & _
"                                              on g.ofer_ncorr = d.ofer_ncorr " & vbCrLf & _
"                                            join planes_estudio as e " & vbCrLf & _
"                                              on g.plan_ccod = e.plan_ccod " & vbCrLf & _
"                                            join especialidades as f " & vbCrLf & _
"                                              on e.espe_ccod = f.espe_ccod " & vbCrLf & _
"                                     where  a.asig_ccod = b.asig_ccod) ) " & vbCrLf & _
"               and cast(b.plan_ccod as varchar) = '" & plan_ccod & "' " & vbCrLf & _
"               and not exists (select 1 " & vbCrLf & _
"                               from   malla_curricular as mc " & vbCrLf & _
"                                      join (select homo_ccod, " & vbCrLf & _
"                                                   asig_ccod_destino, " & vbCrLf & _
"                                                   count(*)        nrequisitos, " & vbCrLf & _
"                                                   count(asig_ccod)naprobados " & vbCrLf & _
"                                            from   (select " & vbCrLf & _
"                                           hd.homo_ccod, " & vbCrLf & _
"                                           hd.asig_ccod asig_ccod_destino, " & vbCrLf & _
"                                           hf.asig_ccod asig_ccod_fuente " & vbCrLf & _
"                                                    from   homologacion_fuente " & vbCrLf & _
"                                                           as hf " & vbCrLf & _
"                                                           join " & vbCrLf & _
"                                                   homologacion_destino as " & vbCrLf & _
"                                                   hd " & vbCrLf & _
"                                                             on hf.homo_ccod = " & vbCrLf & _
"                                                                hd.homo_ccod) as " & vbCrLf & _
"                                                   hom " & vbCrLf & _
"                                                   left outer join " & vbCrLf & _
"                                                   (select s.asig_ccod " & vbCrLf & _
"                                                    from   secciones as s " & vbCrLf & _
"                                                           join " & vbCrLf & _
"                                                   cargas_academicas " & vbCrLf & _
"                                                   as ca " & vbCrLf & _
"                                                             on s.secc_ccod = " & vbCrLf & _
"                                                                ca.secc_ccod " & vbCrLf & _
"                                                           join alumnos as a " & vbCrLf & _
"                                                             on ca.matr_ncorr = " & vbCrLf & _
"                                                                a.matr_ncorr " & vbCrLf & _
"                                                                and cast( " & vbCrLf & _
"                                                           a.pers_ncorr as " & vbCrLf & _
"                                                           varchar) = " & vbCrLf & _
"                                                                    '" & pers_ncorr & "' " & vbCrLf & _
"                                                   join situaciones_finales " & vbCrLf & _
"                                                        as " & vbCrLf & _
"                                                        sf " & vbCrLf & _
"                                                     on ca.sitf_ccod = " & vbCrLf & _
"                                                        sf.sitf_ccod " & vbCrLf & _
"                                                        and sf.sitf_baprueba = " & vbCrLf & _
"                                                            'S') as " & vbCrLf & _
"                                                                   apro " & vbCrLf & _
"                                                                on " & vbCrLf & _
"                                                   hom.asig_ccod_fuente " & vbCrLf & _
"                                                   = " & vbCrLf & _
"                                                   apro.asig_ccod " & vbCrLf & _
"                                            group  by homo_ccod, " & vbCrLf & _
"                                                      asig_ccod_destino) as " & vbCrLf & _
"                                           prueba " & vbCrLf & _
"                                        on mc.asig_ccod = " & vbCrLf & _
"                                           prueba.asig_ccod_destino " & vbCrLf & _
"                               --agregadoPrueba     " & vbCrLf & _
"                               where  mc.asig_ccod = b.asig_ccod " & vbCrLf & _
"                                      and nrequisitos = naprobados " & vbCrLf & _
"                                      and cast(plan_ccod as varchar) = " & vbCrLf & _
"                                          '" & plan_ccod & "')) as " & vbCrLf & _
"       a " & vbCrLf & _
"       left outer join (select a.asig_ccod, " & vbCrLf & _
"                               a.secc_ccod, " & vbCrLf & _
"                               c.matr_ncorr " & vbCrLf & _
"                        from   secciones as a " & vbCrLf & _
"                               join cargas_academicas as b " & vbCrLf & _
"                                 on a.secc_ccod = b.secc_ccod " & vbCrLf & _
"                                    and b.sitf_ccod is null " & vbCrLf & _
"                               join alumnos as c " & vbCrLf & _
"                                 on b.matr_ncorr = c.matr_ncorr " & vbCrLf & _ 
"                                    and c.emat_ccod = 1 " & vbCrLf & _
"                                    and cast(c.pers_ncorr as varchar) = " & vbCrLf & _
"                                        '" & pers_ncorr & "' " & vbCrLf & _
"                                    and cast(c.emat_ccod as varchar) = '1' " & vbCrLf & _
"                        where  cast(a.sede_ccod as varchar) = '" & sede_ccod & "' " & vbCrLf & _
"                               and cast(a.peri_ccod as varchar) = '" & peri_ccod & "' " & vbCrLf & _
"                        union " & vbCrLf & _
"                        select null, " & vbCrLf & _
"                               null, " & vbCrLf & _
"                               null) as b " & vbCrLf & _
"                    on a.asig_ccod = b.asig_ccod " & vbCrLf & _
"       join asignaturas as c " & vbCrLf & _
"         on a.asig_ccod = c.asig_ccod " & vbCrLf & _
"       left outer join (select a.asig_ccod, " & vbCrLf & _
"                               1 as reprobado " & vbCrLf & _
"                        from   secciones as a " & vbCrLf & _
"                               join cargas_academicas as b " & vbCrLf & _
"                                 on a.secc_ccod = b.secc_ccod " & vbCrLf & _
"                                    and b.sitf_ccod not in ( 'EE' ) " & vbCrLf & _
"                               join situaciones_finales as c " & vbCrLf & _
"                                 on b.sitf_ccod = c.sitf_ccod " & vbCrLf & _
"                               join alumnos as d " & vbCrLf & _
"                                 on b.matr_ncorr = d.matr_ncorr " & vbCrLf & _ 
"                                    and d.emat_ccod = 1 " & vbCrLf & _
"                                    and cast(d.pers_ncorr as varchar) = " & vbCrLf & _
"                                        '" & pers_ncorr & "' " & vbCrLf & _
"                        where  sitf_baprueba = 'N' " & vbCrLf & _
"                        union all " & vbCrLf & _
"                        select a.asig_ccod, " & vbCrLf & _
"                               1 as reprobado " & vbCrLf & _
"                        from   equivalencias as a " & vbCrLf & _
"                               join cargas_academicas as b " & vbCrLf & _
"                                 on a.matr_ncorr = b.matr_ncorr " & vbCrLf & _
"                                    and a.secc_ccod = b.secc_ccod " & vbCrLf & _
"                                    and b.sitf_ccod not in ( 'EE' ) " & vbCrLf & _
"                               join secciones as c " & vbCrLf & _
"                                 on b.secc_ccod = c.secc_ccod " & vbCrLf & _
"                               join situaciones_finales as d " & vbCrLf & _
"                                 on b.sitf_ccod = d.sitf_ccod " & vbCrLf & _
"                                    and d.sitf_baprueba = 'N' " & vbCrLf & _
"                               join alumnos as e " & vbCrLf & _
"                                 on b.matr_ncorr = e.matr_ncorr " & vbCrLf & _ 
"                               join personas as f " & vbCrLf & _
"                                 on e.pers_ncorr = f.pers_ncorr " & vbCrLf & _
"                                    and cast(f.pers_ncorr as varchar) = " & vbCrLf & _
"                                        '" & pers_ncorr & "' " & vbCrLf & _
"                        union " & vbCrLf & _
"                        select null, " & vbCrLf & _
"                               null) as d " & vbCrLf & _
"                    on a.asig_ccod = d.asig_ccod  "
'----------------------------------------------------------------------------------FIN CONSULTA ACTUALIZADA(SQLServer 2008)	
'response.Write("<pre>"&asig_disponibles&"</pre>")
asig_tdesc=conectar.consultaUno("select ltrim(rtrim(asig_tdesc)) from asignaturas where cast(asig_ccod as varchar)='"&asig_ccod&"'")

'destino=" select asig_ccod,secc_ccod,horario " & vbCrLf &_
'		" 		  from " & vbCrLf &_
'		"              (SELECT a.asig_ccod, a.secc_tdesc, a.secc_ccod, " & vbCrLf &_
'		"                   cast(a.asig_ccod as varchar)+ '-' + a.secc_tdesc + ' -> ' + protic.horario(a.secc_ccod) " & vbCrLf &_
'		"                         AS horario " & vbCrLf &_
'		"              FROM secciones a, cargas_academicas c,asignaturas d " & vbCrLf &_
'		"             WHERE a.secc_ccod *= c.secc_ccod  " & vbCrLf &_
'		"               AND cast(a.sede_ccod as varchar)= '"&sede_ccod&"' " & vbCrLf &_
'		"               AND cast(a.peri_ccod as varchar)= '"&peri_ccod&"' " & vbCrLf &_
'		"               And a.asig_ccod=d.asig_ccod "& vbCrLf &_
'		"               and d.asig_tdesc = '"& asig_tdesc &"'" & vbCrLf &_
'		"               and cast(a.carr_ccod as varchar)='"&carr_ccod&"'"&vbCrLf &_
'		"             GROUP BY a.asig_ccod,  a.secc_ccod,  a.secc_tdesc,  a.secc_ncupo " & vbCrLf &_
'		"            HAVING a.secc_ncupo - isnull(COUNT (distinct c.secc_ccod), 0) > 0) a" 
'-------------------------------------------------------------------------------INICIO CONSULTA ACTUALIZADA(SQLServer 2008)
destino="select asig_ccod, " & vbCrLf &_
"       secc_ccod, " & vbCrLf &_
"       horario " & vbCrLf &_
"from   (select a.asig_ccod, " & vbCrLf &_
"               a.secc_tdesc, " & vbCrLf &_
"               a.secc_ccod, " & vbCrLf &_
"               cast(a.asig_ccod as varchar) + '-' " & vbCrLf &_
"               + a.secc_tdesc + ' -> ' " & vbCrLf &_
"               + protic.horario(a.secc_ccod) as horario " & vbCrLf &_
"        from   secciones as a " & vbCrLf &_
"               left outer join cargas_academicas as c " & vbCrLf &_
"                            on a.secc_ccod = c.secc_ccod " & vbCrLf &_
"               join asignaturas as d " & vbCrLf &_
"                 on a.asig_ccod = d.asig_ccod " & vbCrLf &_
"                    and d.asig_tdesc = '"& asig_tdesc &"' " & vbCrLf &_
"        where  cast(a.sede_ccod as varchar) = '"&sede_ccod&"' " & vbCrLf &_
"               and cast(a.peri_ccod as varchar) = '"&peri_ccod&"' " & vbCrLf &_
"               and cast(a.carr_ccod as varchar) = '"&carr_ccod&"' " & vbCrLf &_
"        group  by a.asig_ccod, " & vbCrLf &_
"                  a.secc_ccod, " & vbCrLf &_
"                  a.secc_tdesc, " & vbCrLf &_
"                  a.secc_ncupo " & vbCrLf &_
"        having a.secc_ncupo - isnull(count (distinct c.secc_ccod), 0) > 0) a "
'----------------------------------------------------------------------------------FIN CONSULTA ACTUALIZADA(SQLServer 2008)
'response.Write("<pre>"&destino&"</pre>")
seccion.consultar 		destino 
seccion.agregacampoparam "secc_ccod","destino","("&destino&")a"
seccion.siguientef


asig_origen.consultar asig_disponibles
asig_origen.agregacampoparam "asignatura","destino","("&asig_disponibles&")j"
asig_origen.siguientef
asignatura=conectar.consultauno("select asig_tdesc from asignaturas where cast(asig_ccod as varchar)='"&asig_ccod&"'")
total_asignaturas=asig_origen.nroFilas
total_secciones=seccion.nroFilas
'response.Write("total_asignaturas "&total_asignaturas&" total_secciones "&total_secciones)

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
            document.getElementById("texto_alerta").style.visibility="visible";
			formulario.action ="busca_secciones_forzadas.asp";//?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo+"&asig_ccod="+asignatura;
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
<% fbusqueda.generaJS %>
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
                  <%pagina.DibujarLenguetas Array("Seleccione una asignatura para la equivalencia"), 1 %>
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
                                <td width="5%"> <div align="left">Carrera &nbsp; </div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% fbusqueda.dibujaCampoLista "lBusqueda", "carr_ccod"%>
                                  <input type="hidden" name="matr_ncorr" value="<%=matr_ncorr%>">
 								  <input type="hidden" name="plan_ccod" value="<%=plan_ccod%>">
								  <input type="hidden" name="peri_ccod" value="<%=peri_ccod%>">
 								  <input type="hidden" name="sede_ccod" value="<%=sede_ccod%>">
 								  <input type="hidden" name="pers_ncorr" value="<%=pers_ncorr%>"> 
                                     
                                  </td>
                              </tr>
							  <tr> 
                                <td width="5%"> <div align="left">Asignatura &nbsp; </div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% fbusqueda.dibujaCampoLista "lBusqueda", "asig_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="5%"> <div align="left"></div></td>
								<td width="1%"> <div align="center"></div> </td>
								<td><div id="texto_alerta" style="position:absolute; visibility: hidden; left: 300px; top: 130px; width:418px; height: 16px;"><font color="#0000FF" size="-1">Espere 
                                  un momento mientras se realiza la busqueda...</font></div></td>
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
                      <td><div align="center"><%if total_asignaturas > 0 and total_secciones >0 then
					                                botonera.dibujaboton "guardar"
												end if%></div></td>
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

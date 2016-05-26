 <!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
 Server.ScriptTimeOut = 150000
 Response.Buffer = True
 Response.ExpiresAbsolute = Now() - 1
 Response.Expires = 0
 Response.CacheControl = "no-cache" 
 
 'habilita_toma_carga = false
 
set pagina = new CPagina
pagina.Titulo = "Asignación de Carga Académica (Escuela)"
matr_ncorr		= 	session("matr_ncorr")
'response.Write(matr_ncorr)
'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar



set f_botonera = new CFormulario
f_botonera.Carga_Parametros "toma_carga_alfa.xml", "BotoneraTomaCarga"


set formulario 	= new cformulario
set errores 	= new cErrores
set datos		=	new cFormulario
set datos_elec  = new cFormulario


datos.inicializar	conectar
datos.carga_parametros	"paulo.xml","tabla"

formulario.carga_parametros "parametros.xml", "toma_carga"
formulario.inicializar conectar

peri_ccod = conectar.consultaUno("Select peri_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")
sede_ccod = conectar.consultaUno("Select sede_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")
talu_ccod = conectar.consultaUno("select talu_ccod from alumnos where cast(matr_ncorr as varchar)='"&matr_ncorr&"'")

peri_tdesc = conectar.consultaUno("Select protic.initcap(peri_tdesc) from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
pers_ncorr= session("pers_ncorr_alumno")
				  
 
 if matr_ncorr <>"" then 
        '----------------------------------------------En caso de alumnos nuevos se buscará el filtro para que solo muestre el primer nivel-------
	   '-------------------------------------------------------------msandoval 22-02-2005--------------------------------------------------------
	   consulta_carr=" select top 1 carr_ccod " & vbCrlf & _
				" from alumnos a, ofertas_Academicas b, especialidades c " & vbCrlf & _
				" where a.ofer_ncorr = b.ofer_ncorr " & vbCrlf & _
				" and b.espe_ccod=c.espe_ccod " & vbCrlf & _
				" and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'"
				
	   carr_temporal = conectar.consultaUno(consulta_carr)
	   
	   consulta_peri= " select top 1 min(b.peri_ccod)as periodo " & vbCrlf & _
	                  " from postulantes a, periodos_academicos b,ofertas_Academicas c, especialidades d " & vbCrlf & _
					  "	where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' " & vbCrlf & _
					  "	and a.ofer_ncorr=c.ofer_ncorr and c.espe_ccod=d.espe_ccod" & vbCrlf & _
					  "	and cast(d.carr_ccod as varchar)='"&carr_temporal&"' " & vbCrlf & _
					  "	and a.peri_ccod=b.peri_ccod order by periodo asc"
		'response.Write("<pre>"&consulta_peri&"</pre>")			  
	   primer_periodo = conectar.consultaUno(consulta_peri)
       ano_ingreso= conectar.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&primer_periodo&"'")
	   ano_proceso= conectar.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
	   'response.Write("ano_ingreso "&ano_ingreso&" ano_proceso "&ano_proceso)
	   if cint(ano_ingreso) = cint(ano_proceso) then
	   		alumno_nuevo=1
	   else
			alumno_nuevo=0	
	   end if
	   tipo_alumno = conectar.consultaUno("select post_bnuevo from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")
	
	   if tipo_alumno = "S" then
	   	   alumno_nuevo = 1
	   end if	   
		   
end if 
 'response.End()
 nombre = conectar.consultaUno ("select cast(pers_tnombre as varchar) + ' ' + cast(pers_tape_paterno as varchar) + ' ' + cast(pers_tape_materno as varchar) from personas where cast(pers_ncorr as varchar)='" & pers_ncorr & "'")
 v_carr_ccod  = conectar.consultaUno ("select ltrim(rtrim(c.carr_ccod)) from alumnos a, ofertas_academicas b, especialidades c where cast(matr_ncorr as varchar)='" & matr_ncorr & "' and a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod = c.espe_ccod")
 carrera = conectar.consultaUno ("select carr_tdesc from carreras  where carr_ccod='"&v_carr_ccod&"'")
 rut = conectar.consultaUno ("select cast(pers_nrut as varchar)+ '-'+ pers_xdv from personas where cast(pers_ncorr as varchar)='" & pers_ncorr & "'")
 v_sede  = conectar.consultaUno ("select sede_tdesc from alumnos a, ofertas_academicas b, sedes c where cast(matr_ncorr as varchar)='" & matr_ncorr & "' and a.ofer_ncorr=b.ofer_ncorr and b.sede_ccod = c.sede_ccod")
 v_jornada  = conectar.consultaUno ("select jorn_tdesc from alumnos a, ofertas_academicas b, jornadas c where cast(matr_ncorr as varchar)='" & matr_ncorr & "' and a.ofer_ncorr=b.ofer_ncorr and b.jorn_ccod = c.jorn_ccod")

'response.Write(nombre)

 if isnull(pers_ncorr) then
	pers_ncorr = "-1"
	es_nuevo = "-1"
	sede_ccod = "-1"
	plan_ccod = "-1"
	peri_ccod = "-1"
	es_nuevo = "-1"
 else
	sede_ccod = conectar.consultaUno ("select sede_ccod from ofertas_academicas a, alumnos b where a.ofer_ncorr=b.ofer_ncorr and cast(matr_ncorr as varchar)='" & matr_ncorr & "'")
	plan_ccod = conectar.consultaUno ("select plan_ccod from  alumnos where cast(matr_ncorr as varchar)='" & matr_ncorr & "'")
	es_nuevo = conectar.consultaUno ("select protic.alumno_es_nuevo('" & matr_ncorr & "')")
 end if
 jorn_ccod = conectar.consultaUno ("select jorn_ccod from alumnos a, ofertas_academicas b where a.ofer_ncorr=b.ofer_ncorr and cast(matr_ncorr as varchar)='"&matr_ncorr&"'") 
 '/************************************buscamos la cadena de planes de estudios para alumnos antiguos*************************************************
 
   asignaturas_disponibles_cons = " select distinct c.asig_ccod,c.asig_ccod asig_ccod_paso, c.asig_tdesc as asignatura, " & vbCrlf & _
                                  " case moda_ccod when 2 then secc_nhoras_pagar else asig_nhoras end as asig_nhoras, " & vbCrlf & _
								  " b.secc_ccod, '" & matr_ncorr & "' as matr_ncorr, " & vbCrlf & _
								  " a.nive_ccod, isnull(d.reprobado,0) as reprobado  from ( "

    tipo_plan = conectar.consultaUno("select isnull(plan_tcreditos,0) from alumnos a, planes_estudio b where a.plan_ccod=b.plan_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
	'-------------------debemos quitar los requisitos de la toma de carga para las personas que pertenescan a registro curricular para 
	'--------------------que puedan tomar carga a alumnos de intercambio o que presenten situación extraordinaria.
	usuario_sesion = negocio.obtenerUsuario
	sin_restriccion = conectar.consultaUno("select count(*) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and b.srol_ncorr in (2,143) and cast(a.pers_nrut as varchar)='"&usuario_sesion&"'")
	
	talu_ccod = conectar.consultaUno("select talu_ccod from alumnos where cast(matr_ncorr as varchar)='"&matr_ncorr&"'")
	if talu_ccod = "2" or talu_ccod = "3" then
		sin_restriccion = "1"
	end if
	
	'response.Write(sin_restriccion)
	if tipo_plan = "0" then
		asignaturas_disponibles_cons = asignaturas_disponibles_cons &  " SELECT DISTINCT b.asig_ccod, mc.nive_ccod,secc.moda_ccod,secc.secc_nhoras_pagar " & vbCrlf & _
										"  FROM asignaturas_comunes b,secciones secc,bloques_horarios bl,malla_curricular mc" & vbCrlf & _
										"  WHERE b.asig_ccod=secc.asig_ccod and b.mall_ccod= mc.mall_ccod and b.mall_ccod=secc.mall_ccod and secc.secc_ccod=bl.secc_ccod" & vbCrlf & _
										"  and cast(secc.peri_ccod as varchar)='"&peri_ccod&"'" 
										
										if sin_restriccion = "0" then
										asignaturas_disponibles_cons = asignaturas_disponibles_cons & "  and  protic.completo_requisitos_asignatura (b.mall_ccod, '" & pers_ncorr & "') = 0" 
										filtro_jorna = " and cast(secc.jorn_ccod as varchar)='"&jorn_ccod&"' "
										else
										filtro_jorna = " "
										end if 
										'asignaturas_disponibles_cons = asignaturas_disponibles_cons & "  and  b.carr_ccod = '"&v_carr_ccod&"' and secc.secc_ncupo > 0  " &filtro_jorna& " AND cast(secc.sede_ccod as varchar) = '" & sede_ccod & "' " 
																						
		filtro_plan = " and mc.plan_ccod in (select distinct plan_ccod from asignaturas_comunes where cast(carr_ccod as varchar)='"&v_carr_ccod&"' and cast(peri_ccod as varchar)='"&peri_ccod&"')"
		 if peri_ccod > "202" then
			filtro_plan = " and cast(b.plan_ccod as varchar)='"&plan_ccod&"'"	
 		 end if
		 asignaturas_disponibles_cons = asignaturas_disponibles_cons & "  and  b.carr_ccod = '"&v_carr_ccod&"' and secc.secc_ncupo > 0  " &filtro_jorna& " AND cast(secc.sede_ccod as varchar) = '" & sede_ccod & "' " & filtro_plan
	else
	    plan_ccod = conectar.consultaUno("select a.plan_ccod from alumnos a where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
    	asignaturas_disponibles_cons = asignaturas_disponibles_cons &  " SELECT DISTINCT b.asig_ccod, b.nive_ccod,secc.moda_ccod,secc.secc_nhoras_pagar " & vbCrlf & _
										"  FROM malla_curricular b,secciones secc,bloques_horarios bl" & vbCrlf & _
										"  WHERE cast(b.plan_ccod as varchar)='"&plan_ccod&"' and b.asig_ccod=secc.asig_ccod and b.mall_ccod=secc.mall_ccod and secc.secc_ccod=bl.secc_ccod" & vbCrlf & _
										"  and cast(secc.peri_ccod as varchar)='"&peri_ccod&"'" 
										
										if sin_restriccion = "0" then
											asignaturas_disponibles_cons = asignaturas_disponibles_cons & "  and  protic.completo_requisitos_asignatura (b.mall_ccod, '" & pers_ncorr & "') = 0" 
										filtro_jorna = " and cast(secc.jorn_ccod as varchar)='"&jorn_ccod&"' "
										filtro_jorna = "  "
										else
										filtro_jorna = " "
										end if
										asignaturas_disponibles_cons = asignaturas_disponibles_cons & "  and secc.secc_ncupo > 0  "&filtro_jorna&" AND cast(secc.sede_ccod as varchar) = '" & sede_ccod & "' " 
										if alumno_nuevo=1 then
										  'asignaturas_disponibles_cons =  asignaturas_disponibles_cons & " and b.nive_ccod=1 "
										end if
		filtro_plan = " and cast(plan_ccod as varchar)='"&plan_ccod&"'"								
	end if
	
'response.Write("<pre>"&asignaturas_disponibles_cons&"</pre>")

asignaturas_disponibles_cons = asignaturas_disponibles_cons & "   AND NOT (  " & vbCrlf & _
"			EXISTS (SELECT 1 " & vbCrlf & _
"                    FROM secciones sa," & vbCrlf & _
"                         cargas_academicas sb," & vbCrlf & _
"                         alumnos sc," & vbCrlf & _
"                         situaciones_finales sd" & vbCrlf & _
"                   WHERE sa.secc_ccod = sb.secc_ccod" & vbCrlf & _
"                     AND sa.asig_ccod = b.asig_ccod" & vbCrlf & _
"                     AND sb.matr_ncorr = sc.matr_ncorr" & vbCrlf & _
"                     AND sb.sitf_ccod = sd.sitf_ccod" & vbCrlf & _
"                     AND cast(sd.sitf_baprueba as varchar) = 'S' and isnull(carg_noculto,0) = 0 " & vbCrlf & _
"                     AND sc.emat_ccod in (1,6,11) " & vbCrlf & _
"                     AND cast(sc.pers_ncorr as varchar) = '" & pers_ncorr & "')" & vbCrlf & _
"   OR  " & vbCrlf & _
"        EXISTS (  select 1 " & vbCrlf & _
"			from  " & vbCrlf & _
"				 convalidaciones a " & vbCrlf & _
"				 , alumnos b1 " & vbCrlf & _
"				 , actas_convalidacion d " & vbCrlf & _
"				 ,situaciones_finales h " & vbCrlf & _
"			where " & vbCrlf & _
"				 a.matr_ncorr=b1.matr_ncorr " & vbCrlf & _
"				 and a.acon_ncorr=d.acon_ncorr " & vbCrlf & _
"				 and a.asig_ccod=b.asig_ccod " & vbCrlf & _
"				 and a.sitf_ccod=h.sitf_ccod " & vbCrlf & _
"				 and cast(h.sitf_baprueba as varchar)='S' " & vbCrlf & _
"			     and cast(b1.pers_ncorr as varchar)='"&pers_ncorr&"')" & vbCrlf & _	
"        OR  " & vbCrlf & _
"          EXISTS (select  1 " & vbCrlf & _
"		   		  		   from " & vbCrlf & _
"								equivalencias a " & vbCrlf & _
"								, cargas_academicas b1 " & vbCrlf & _
"								, secciones c " & vbCrlf & _
"								, alumnos g " & vbCrlf & _
"								, situaciones_finales sf " & vbCrlf & _
"							where " & vbCrlf & _
"								 a.matr_ncorr=b1.matr_ncorr " & vbCrlf & _
"								 and a.secc_ccod=b1.secc_ccod " & vbCrlf & _
"								 and b1.secc_ccod=c.secc_ccod " & vbCrlf & _
"								 and b1.matr_ncorr=g.matr_ncorr " & vbCrlf & _
"								 and a.asig_ccod=b.asig_ccod " & vbCrlf & _
"								 and b1.sitf_ccod = sf.sitf_ccod " & vbCrlf & _
"								 and cast(sf.sitf_baprueba as varchar)='S' " & vbCrlf & _
"								 and cast(g.pers_ncorr as varchar)='" & pers_ncorr & "') " & vbCrlf & _
"        ) " & vbCrlf & _
"   AND NOT EXISTS (SELECT 1 " & vbCrlf & _
"                      FROM  " & vbCrlf & _
"                      MALLA_CURRICULAR MC, " & vbCrlf & _
"                      (SELECT HOMO_CCOD,ASIG_CCOD_DESTINO, COUNT(*) NREQUISITOS, count(asig_ccod)NAPROBADOS " & vbCrlf & _
"                      FROM  " & vbCrlf & _
"                      (SELECT HD.HOMO_CCOD,HD.ASIG_CCOD ASIG_CCOD_DESTINO,HF.ASIG_CCOD ASIG_CCOD_FUENTE  " & vbCrlf & _
"                       FROM HOMOLOGACION_FUENTE HF,  " & vbCrlf & _
"                       HOMOLOGACION_DESTINO HD " & vbCrlf & _
"                       WHERE HF.HOMO_CCOD=HD.HOMO_CCOD ) HOM, " & vbCrlf & _
"                      (SELECT S.ASIG_CCOD  " & vbCrlf & _
"                       FROM " & vbCrlf & _
"                       SECCIONES S, " & vbCrlf & _
"                       CARGAS_ACADEMICAS CA, " & vbCrlf & _
"                       ALUMNOS A, " & vbCrlf & _
"                       SITUACIONES_FINALES SF " & vbCrlf & _
"                       WHERE S.SECC_CCOD = CA.SECC_CCOD " & vbCrlf & _
"                          AND CA.MATR_NCORR = A.MATR_NCORR  " & vbCrlf & _
"                      	   AND SF.SITF_CCOD=CA.SITF_CCOD  and carr_ccod ='"&v_carr_ccod&"'" & vbCrlf & _
"                      	   AND SF.SITF_BAPRUEBA='S'   " & vbCrlf & _
"                      	   AND cast(A.PERS_NCORR as varchar) = '" & pers_ncorr & "') APRO ---PONER PERS_NCORR  " & vbCrlf & _
"                      WHERE HOM.ASIG_CCOD_FUENTE *=APRO.ASIG_CCOD  " & vbCrlf & _
"                      group by HOMO_CCOD,asig_ccod_destino)	PRUEBA " & vbCrlf & _
"                      WHERE MC.ASIG_CCOD=ASIG_CCOD_DESTINO " & vbCrlf & _
"                      AND MC.ASIG_CCOD=B.ASIG_CCOD " & vbCrlf & _
"					   AND NREQUISITOS = NAPROBADOS " & vbCrlf & _
"                      and cast(plan_ccod as varchar)='"&plan_ccod&"') " & vbCrlf & _
") a, " & vbCrlf & _
"	(SELECT a.asig_ccod, a.secc_ccod, c.matr_ncorr  " & vbCrlf & _
"	   FROM secciones a, cargas_academicas b, alumnos c " & vbCrlf & _
"	  WHERE a.secc_ccod = b.secc_ccod " & vbCrlf & _
"	   AND b.matr_ncorr = c.matr_ncorr and b.sitf_ccod is null" & vbCrlf & _
"      AND c.emat_ccod in (1,6,11) " & vbCrlf & _
"      AND cast(a.sede_ccod as varchar) = '" & sede_ccod & "' " & vbCrlf & _
"      AND cast(a.peri_ccod as varchar) = '" & peri_ccod & "' " & vbCrlf & _
"	   AND cast(c.pers_ncorr as varchar) = '" & pers_ncorr & "'"& vbCrlf & _
"      union"& vbCrlf & _
"	   select null,null,null) b, " & vbCrlf & _
"	  asignaturas c, " & vbCrlf & _ 
"   ( select a.asig_ccod, 1 as reprobado  " & vbCrlf & _
"       from secciones a, cargas_academicas b, situaciones_finales c, alumnos d " & vbCrlf & _
"      where a.secc_ccod=b.secc_ccod  " & vbCrlf & _
"        and b.sitf_ccod=c.sitf_ccod  " & vbCrlf & _
"        and b.matr_ncorr=d.matr_ncorr " & vbCrlf & _
"        AND d.emat_ccod in (1,6,11) " & vbCrlf & _
"        and cast(d.pers_ncorr as varchar)='" & pers_ncorr & "' " & vbCrlf & _
"        and cast(sitf_baprueba as varchar)='N' " & vbCrlf & _
"	  union all" & vbCrlf & _
"	  	select  " & vbCrlf & _
"			a.asig_ccod,1 as reprobado  " & vbCrlf & _
"		from  " & vbCrlf & _
"			 equivalencias a,  " & vbCrlf & _
"			 cargas_academicas b,  " & vbCrlf & _
"			 secciones c,  " & vbCrlf & _
"			 situaciones_finales d,  " & vbCrlf & _
"			 alumnos e,  " & vbCrlf & _
"			 personas f " & vbCrlf & _
"	  where a.matr_ncorr=b.matr_ncorr " & vbCrlf & _
"		  and a.secc_ccod=b.secc_ccod  " & vbCrlf & _
"		  and b.secc_ccod=c.secc_ccod " & vbCrlf & _
"		  and b.sitf_ccod=d.sitf_ccod " & vbCrlf & _
"		  and b.matr_ncorr=e.matr_ncorr " & vbCrlf & _
"		  and e.pers_ncorr=f.pers_ncorr " & vbCrlf & _
"		  and d.sitf_baprueba='N'" & vbCrlf & _
"		  and cast(f.pers_ncorr as varchar)='"& pers_ncorr &"'"& vbCrlf & _
"          union "& vbCrlf & _
"		  select null,null) d" & vbCrlf & _
"  where a.asig_ccod *=b.asig_ccod  " & vbCrlf & _
"    and a.asig_ccod *=d.asig_ccod  " & vbCrlf & _
"    and a.asig_ccod=c.asig_ccod " & vbCrLf & _
"  " & vbCrLf
	
'response.Write("<pre>"&asignaturas_disponibles_cons&"</pre>")
formulario.consultar asignaturas_disponibles_cons

'response.Write("<pre>"&asignaturas_disponibles_cons&"</pre>")
'response.End()
filas_asig = formulario.nrofilas

set datos_elec		=	new cFormulario
datos_elec.inicializar	conectar
datos_elec.carga_parametros	"paulo.xml","tabla"

for i_=0 to filas_asig-1
	formulario.siguiente
	v_asig_ccod =formulario.obtenervalor("asig_ccod")
	sql_electivos = " select b.asig_ccod " & _
					" from electivos a,secciones b "& _
					" where a.secc_ccod = b.secc_ccod  " & _
					" and cast(a.asig_ccod as varchar) ='"&v_asig_ccod&"' "  & _
					" and cast(peri_ccod as varchar) ='"&peri_ccod&"'"
	datos_elec.consultar sql_electivos
	for j_=0 to datos_elec.nrofilas	-1
		datos_elec.siguiente
		asig_ccod_elec=datos_elec.obtenervalor("asig_ccod")
		if asig_ccod_elec<>"" then
			if arr_asignatura_elec <>"" then
				arr_asignatura_elec =arr_asignatura_elec &",'"&asig_ccod_elec&"'" 
			else
				arr_asignatura_elec= "'"&asig_ccod_elec&"'"
			end if	
		end if
	next			
	if arr_asignatura <>"" then
		arr_asignatura =  arr_asignatura &",'"&v_asig_ccod&"'" 
	else
		arr_asignatura ="'"&v_asig_ccod&"'" 
	end if	
next
if arr_asignatura_elec<>"" then
arr_asignatura=arr_asignatura&","&arr_asignatura_elec
end if

formulario.primero

destino =" (SELECT a.carr_ccod,a.asig_ccod, a.secc_tdesc, a.secc_ccod,  " & vbCrLf &  _
"	  case a.carr_ccod when '"&v_carr_ccod&"'  " & vbCrLf & _
"	  then '(*)' + cast(a.asig_ccod as varchar)+ '-' + cast(a.secc_tdesc as varchar)+  ' -> ' + cast(protic.horario(a.secc_ccod) as varchar)  + ' -(' + cast((a.secc_ncupo - (select count(*) from cargas_academicas ca where ca.secc_ccod = a.secc_ccod) ) as varchar) + ' Cupos)- ' " & vbCrLf & _
"	  else cast(a.asig_ccod as varchar)+ '-' + cast(a.secc_tdesc as varchar) + ' -> ' + cast(protic.horario(a.secc_ccod) as varchar) + ' -(' + cast((a.secc_ncupo - (select count(*) from cargas_academicas ca where ca.secc_ccod = a.secc_ccod) ) as varchar) + ' Cupos)- ' " & vbCrLf & _
"	  end horario--, a.secc_ncupo - isnull(COUNT (distinct c.secc_ccod), 0)  " & vbCrLf & _
"	  FROM secciones a, cargas_academicas c  " & vbCrLf & _
"	  WHERE a.secc_ccod *= c.secc_ccod   " & vbCrLf & _
"	  AND cast(a.sede_ccod as varchar)='"&sede_ccod&"'  " & vbCrLf & _
"	  and cast(a.peri_ccod as varchar)= '"&peri_ccod&"'  " & vbCrLf & _
"	  and cast(a.asig_ccod as varchar) in ("&arr_asignatura&")  " & vbCrLf & _
"	  and cast(a.carr_ccod as varchar) ='"&v_carr_ccod&"'  " & vbCrLf & _
"	  GROUP BY a.asig_ccod, a.secc_ccod, a.secc_tdesc, a.secc_ncupo,carr_ccod " & vbCrLf & _
"	  HAVING a.secc_ncupo - isnull(COUNT (distinct c.secc_ccod), 0) > 0) a  " & vbCrLf  

destino = "  (Select carr_ccod, asig_ccod,secc_tdesc,secc_ccod, " & vbCrLf & _
		  "  case carr_ccod when '"&v_carr_ccod&"' then '(*)'+asig_ccod +'-'+ secc_tdesc + ' ->' + horario2 + ' -('+cast(cupo as varchar)+' Cupos)-' " & vbCrLf & _
          "  else asig_ccod +'-'+secc_tdesc+' ->'+ horario2 + ' -('+cast(cupo as varchar)+' Cupos)-' end as horario  " & vbCrLf & _
		  "  from " & vbCrLf & _
		  "  (SELECT a.carr_ccod,a.asig_ccod, a.secc_tdesc, a.secc_ccod,protic.horario(a.secc_ccod) as horario2, " & vbCrLf & _
		  "         (a.secc_ncupo - (select count(*) from cargas_academicas ca where ca.secc_ccod = a.secc_ccod)) as cupo      " & vbCrLf & _
		  "	  FROM secciones a " & vbCrLf & _
		  "	  WHERE cast(a.sede_ccod as varchar)='"&sede_ccod&"'   " & vbCrLf & _
		  "	  and cast(a.peri_ccod as varchar)= '"&peri_ccod&"'   " & vbCrLf & _
		  "	  and cast(a.asig_ccod as varchar) in ("&arr_asignatura&")  " & vbCrLf & _
		  "	  and cast(a.carr_ccod as varchar) ='"&v_carr_ccod&"'   " & vbCrLf & _
		  "  )ata  )a"

'response.Write("<pre>"&destino&"</pre>")
'response.End()


filtro = "    asig_ccod in (select '%asig_ccod%' as asig_ccod ) " & vbCrLf  & _
"	 or	asig_ccod in ( select b.asig_ccod from electivos a,secciones b  " & vbCrLf  & _
" 	   			 	 where a.secc_ccod = b.secc_ccod  " & vbCrLf  & _
" 	   			 	 and  cast(b.carr_ccod as varchar) ='"&v_carr_ccod&"'  " & vbCrLf  & _
"				     and a.asig_ccod ='%asig_ccod%'  )" 
'response.Write("<pre>"&filtro&"</pre>")

formulario.agregaCampoParam "secc_ccod", "filtro", filtro
formulario.agregaCampoParam "secc_ccod", "destino", destino

pers_nrut = conectar.consultaUno("Select pers_nrut from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
pers_xdv = conectar.consultaUno("Select pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
url="../CERTIFICADOS/HISTORICO_NOTAS_LIBRE.ASP?busqueda[0][pers_nrut]="&pers_nrut&"&busqueda[0][pers_xdv]="&pers_xdv&"&ocultar=1"


if tipo_plan = "0" then
	lenguetas_carga = Array(Array("Toma de Carga", "toma_carga_nuevo.asp"), Array("Equivalencias", "equivalencias.asp"), Array("Form. Gral. Optativa", "ingreso_optativos.asp"), Array("Artísticos-Culturales", "ingreso_cursos_dae.asp"),Array("Carga Extraordinaria Créditos", "toma_carga_extraordinaria.asp?tipo=1"))
else
	lenguetas_carga = Array(Array("Toma de Carga", "toma_carga_nuevo.asp"), Array("Equivalencias", "equivalencias.asp"), Array("Form. Gral. Optativa", "ingreso_optativos.asp"), Array("Artísticos-Culturales", "ingreso_cursos_dae.asp"),Array("Carga Extraordinaria Sesiones", "toma_carga_extraordinaria.asp?tipo=2"))
end if	


usuario_sesion = negocio.obtenerUsuario
'------------debemos ver si la gente que inicia seción es de registro curricular o nop
'----------si lo es puede eliminar carga normal y carga sin requisitos, sino lo es slo elimina carga normal, hay que tener cuidado con optativos deportivos
'--------- y con las cargas extraordinarias qe no se eliminan por acá sino en la lengueta correspondiente.
	
	sin_restriccion = conectar.consultaUno("select count(*) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and b.srol_ncorr=2 and cast(a.pers_nrut as varchar)='"&usuario_sesion&"'")
    'response.Write(sin_restriccion)
	if sin_restriccion <> "0" or talu_ccod = "2" or talu_ccod = "3" then
		filtro_eliminacion = " and isnull(acse_ncorr,6) in (6,3,4)  " 'RC puede eliminar tanto carga normal como sin pre-requisitos 
	else
	    filtro_eliminacion = " and isnull(acse_ncorr,6) = 6 " 'solo elimina carga normal
	end if	


set f_alumno = new CFormulario
f_alumno.Carga_Parametros "inicio_toma_carga_alfa.xml", "carga_tomada_eliminar"
f_alumno.Inicializar conectar
'response.Write(matr_ncorr)
consulta = " select a.secc_ccod,a.matr_ncorr,c.asig_ccod as cod_asignatura, c.asig_tdesc as asignatura,b.secc_tdesc as seccion, " & vbCrLf &_
		   " protic.horario_con_sala(b.secc_ccod) as horario, case acse_ncorr when 3 then 'Carga Adicional' when 4 then 'Carga Sin Pre-requisitos' else case a.carg_afecta_promedio when 'N' then 'Optativo' else 'Carga Regular' end end as tipo, "& vbCrLf &_
		   " isnull((select isnull(cred_valor,0) from asignaturas aa,creditos_Asignatura bb "& vbCrLf &_
           "  where aa.cred_ccod = bb.cred_ccod and aa.asig_ccod=c.asig_ccod),0) as creditos"& vbCrLf &_
		   " from cargas_Academicas a, secciones b, asignaturas c " & vbCrLf &_
		   " where cast(matr_ncorr as varchar)='"&matr_ncorr&"' " & vbCrLf &_
		   " and a.secc_ccod=b.secc_ccod "& filtro_eliminacion & vbCrLf &_
		   " and not exists (Select 1 from equivalencias eq where eq.matr_ncorr=a.matr_ncorr and eq.secc_ccod=a.secc_ccod) " & vbCrLf &_
		   " and not exists (Select 1 from calificaciones_alumnos eq where eq.matr_ncorr=a.matr_ncorr and eq.secc_ccod=a.secc_ccod) " & vbCrLf &_
		   " and b.asig_ccod=c.asig_ccod " & vbCrLf &_
		   " union all " & vbCrLf &_
		   " select a.secc_ccod,a.matr_ncorr,c.asig_ccod as cod_asignatura, c.asig_tdesc as asignatura,b.secc_tdesc as seccion, " & vbCrLf &_
		   " protic.horario_con_sala(b.secc_ccod) as horario,case isnull(acse_ncorr,0) when 0 then 'Equivalencia' else 'Carga Extraordinaria' end as tipo, " & vbCrLf &_
		   " isnull((select isnull(cred_valor,0) from asignaturas aa,creditos_Asignatura bb "& vbCrLf &_
           "  where aa.cred_ccod = bb.cred_ccod and aa.asig_ccod=c.asig_ccod),0) as creditos"& vbCrLf &_
		   " from equivalencias a, secciones b, asignaturas c,cargas_academicas ca " & vbCrLf &_
		   " where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' " & filtro_eliminacion & vbCrLf &_
		   " and not exists (Select 1 from calificaciones_alumnos eq where eq.matr_ncorr=a.matr_ncorr and eq.secc_ccod=a.secc_ccod) " & vbCrLf &_
		   " and a.secc_ccod=b.secc_ccod  and a.matr_ncorr=ca.matr_ncorr and a.secc_ccod = ca.secc_ccod" & vbCrLf &_
		   " and b.asig_ccod=c.asig_ccod "

'response.Write("<pre>"&consulta&"</pre>")
f_alumno.Consultar consulta

'response.Write(matr_ncorr)

v_espe_ccod = conectar.consultaUno("select espe_ccod from planes_estudio where cast(plan_ccod as varchar)='"&plan_ccod&"'")
url_malla="../MANTENEDORES/malla_curricular_imprimible.ASP?a[0][CARR_CCOD]="&v_carr_ccod&"&a[0][ESPE_CCOD]="&v_espe_ccod&"&a[0][PLAN_CCOD]="&plan_ccod

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

function dibujar(formulario){
	formulario.submit();
}

function ver_notas()
{
self.open('<%=url%>','notas','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

function ver_malla()
{
self.open('<%=url_malla%>','malla','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

function horario(){
	self.open('horario.asp?matr_ncorr=<%=matr_ncorr%>','horario','width=700px, height=550px, scrollbars=yes, resizable=yes')
}


function enviar(formulario){ 

    formulario.dv.value =formulario.dv.value.toUpperCase();
  	if(preValidaFormulario(formulario)){
	   if(!(valida_rut(formulario.rut.value + '-' + formulario.dv.value))){
	      alert('El RUT que Ud. ha ingresado no es válido.Por favor, ingréselo nuevamente.');
	      formulario.rut.focus();
	      formulario.rut.select();
	   }
       else{
	  	
	      formulario.submit();
	   }
	}   
 }
 
function guardar(formulario){
formulario.method="post"
formulario.action="toma_carga_proc.asp"
formulario.submit();
}
function guardar2(formulario){
formulario.method="post"
formulario.action="toma_carga_proc2.asp"
formulario.submit();
}

function elim_asig (formulario){
	if (verifica_check(formulario)){
		formulario.method="post"
		formulario.action="eliminar_carga.asp";
		formulario.submit();
	}
	else{
		alert('No ha seleccionado ninguna asignatura a eliminar.');
	}
}

function verifica_check(formulario) {
	num=formulario.elements.length;
	c=0;
	for (i=0;i<num;i++){
		nombre = formulario.elements[i].name;
		var elem = new RegExp ("secc_ccod","gi");
		if (elem.test(nombre)){
			if((formulario.elements[i].checked==true)){
				c=c+1;
			}
		}
	}
	if (c>0) {
		return (true);
	}
	else {
		return (false);
	}
}

</script>
<STYLE type="text/css">
 <!-- 
 A {color: #000000;  text-decoration: none; font-weight: bold;}
 A:hover {COLOR: #63ABCC; }

 // -->
 </STYLE>
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.anchofijo {
	font-family: "Courier New", Courier, mono;
	font-size: 10px;
	width: 350px;
}
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
            <td><%pagina.DibujarLenguetas lenguetas_carga, 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
                    <% pagina.Titulo = pagina.Titulo & "<br>" & peri_tdesc
					  pagina.DibujarTituloPagina%>
                    <br>
                </div>
           
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
              <form name="temporal" action="toma_carga.asp"> 
			  <tr>
                <td>&nbsp; </td>
                <td colspan="2">&nbsp; </td>
              </tr>
			  <tr>
                <td width="10%"><strong>RUT</strong></td>
                <td width="2%"><strong>:</strong> </td>
				<td align="left"><font color="#CC0000"><strong><%= rut %></strong></font></td>
              </tr>
              <tr>
				<td width="10%"><strong>Nombre</strong></td>
                <td width="2%"><strong>:</strong> </td>
				<td align="left"><font color="#CC0000"><strong><%=nombre %></strong></font></td>
              </tr>
              <tr>
				<td width="10%"><strong>Sede</strong></td>
                <td width="2%"><strong>:</strong> </td>
				<td align="left"><font color="#CC0000"><strong><%=v_sede %></strong></font></td>
			  </tr>  
			  <tr>
				<td width="10%"><strong>Carrera</strong></td>
                <td width="2%"><strong>:</strong> </td>
				<td align="left"><font color="#CC0000"><strong><%=carrera %></strong></font></td>
			  </tr>
			  <tr>
				<td width="10%"><strong>Jornada</strong></td>
                <td width="2%"><strong>:</strong> </td>
				<td align="left"><font color="#CC0000"><strong><%=v_jornada %></strong></font></td>
			  </tr>
			  </form>
            </table>
			
            <form name="edicion">
			  <input type="hidden" name="matr_ncorr" value="<%=matr_ncorr%>">
					<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
					  <tr>
						<td><%pagina.DibujarSubtitulo "Seleccione las Asignaturas que desea tomar el alumno"%>
						  <br>
						  (*) Secciones Planificadas Para la Carrera :  <%= carrera %> </td>
					  </tr>
					  <%if sin_restriccion  <> "0" then%>
					  <tr> 
					       <td align="center">&nbsp;</td>
					  </tr>
					  <tr> 
					       <td align="center"><font size="2" color="#0000FF"><strong>Atención :<br></strong>Se le ha provisto de privilegios para poder tomar carga al alumno sin considerar los pre-requisitos. Dichas cargas serán identificadas dentro del sistema.</font>
					       </td>
					  </tr>
					  <%end if%>
					  </table>
				     <table width="100%" border="0">
					  <tr> 
						<td align="right"><strong><font color="000000" size="1"> 
						  <% formulario.pagina%>
						  &nbsp;&nbsp;&nbsp;&nbsp; 
						  <% formulario.accesoPagina%>
						  </font></strong></td>
					  </tr>
					  <tr> 
						 <td><strong><font color="000000" size="1"> 
						 <% formulario.dibujaTabla%>
						 </font></strong></td>
					  </tr>
					  <tr> 
						<td align="right">&nbsp;</td>
					  </tr>
					  <tr>
						<td align="right">
						<% if filas_asig = 0 then
									  f_botonera.agregabotonparam "GUARDAR", "deshabilitado" ,"TRUE"
                           end if							
								  f_botonera.DibujaBoton "GUARDAR"%><a href="javascript:guardar2(document.edicion);"><font color="#999999">.</font></a>
						</td>
					  </tr>
					  <tr>
				  	<td>&nbsp;
					</td>
				  </tr>
				  <%if matr_ncorr <> "" then %>
				  <tr>
                    <td><%pagina.DibujarSubtitulo "Eliminar carga asignada al Alumno"%>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="right">Pagina <%f_alumno.accesoPagina%></div></td>
                        </tr>
						<tr>
                          <td><div align="center"><%f_alumno.DibujaTabla%></div></td>
                        </tr>
						<tr> 
						<td align="right">&nbsp;</td>
					  </tr>
					  <tr>
						<td align="right">
						<% if f_alumno.nroFilas = 0 then
									  f_botonera.agregabotonparam "ELIMINAR", "deshabilitado" ,"TRUE"
                           end if							
								  f_botonera.DibujaBoton "ELIMINAR"%>
						</td>
					  </tr>
                      </table></td>
                  </tr>
				  <%end if%>
       			</table>
                <br>
    			</form>
            </td></tr>
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
                  <td><div align="center">
                    <% f_botonera.agregaBotonParam "anterior", "url", "inicio_toma_carga.asp?busqueda[0][pers_nrut]="&pers_nrut&"&busqueda[0][pers_xdv]="&pers_xdv&"&enca[0][pers_nrut]="&matr_ncorr&"&busqueda[0][peri_ccod]="&peri_ccod&"&busqueda[0][sede_ccod]="&sede_ccod
					  f_botonera.DibujaBoton "anterior"%>
                      </div>
				   </td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton "HORARIO"%>
                  </div></td>
                  <td><div align="center"><% f_botonera.DibujaBoton "NOTAS"%></div></td>
				  <td><div align="center"><% f_botonera.DibujaBoton "MALLA"%></div></td>
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
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>

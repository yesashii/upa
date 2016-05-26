 <!-- #include file="../biblioteca/_conexion.asp" -->
 <!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
 Response.Buffer = True
 Response.ExpiresAbsolute = Now() - 1
 Response.Expires = 0
 Response.CacheControl = "no-cache" 
 
 'habilita_toma_carga = false

set pagina = new CPagina
pagina.Titulo = "Asignaturas de la Malla Curricular"
matr_ncorr		= 	session("matr_ncorr")
'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar



set f_botonera = new CFormulario
f_botonera.Carga_Parametros "toma_carga_online.xml", "BotoneraTomaCarga"


set formulario 	= new cformulario
set errores 	= new cErrores
set datos_elec  = new cFormulario

formulario.carga_parametros "toma_carga_online.xml", "toma_carga"
formulario.inicializar conectar

peri_ccod = conectar.consultaUno("Select peri_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")
sede_ccod = conectar.consultaUno("Select sede_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")
jorn_ccod = conectar.consultaUno("Select jorn_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")

peri_tdesc = conectar.consultaUno("Select protic.initcap(peri_tdesc) from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
pers_ncorr= session("pers_ncorr_alumno")
				  
 
 if matr_ncorr <> "" then 
        '----------------------------------------------En caso de alumnos nuevos se buscará el filtro para que solo muestre el primer nivel-------
	   '-------------------------------------------------------------msandoval 22-02-2005--------------------------------------------------------
	   consulta_carr=" select carr_ccod " & vbCrlf & _
				" from alumnos a, ofertas_Academicas b, especialidades c " & vbCrlf & _
				" where a.ofer_ncorr = b.ofer_ncorr " & vbCrlf & _
				" and b.espe_ccod=c.espe_ccod " & vbCrlf & _
				" and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'"
				
	   carr_temporal = conectar.consultaUno(consulta_carr)
end if 
'response.End()
 nombre = conectar.consultaUno ("select cast(pers_tnombre as varchar) + ' ' + cast(pers_tape_paterno as varchar) + ' ' + cast(pers_tape_materno as varchar) from personas where cast(pers_ncorr as varchar)='" & pers_ncorr & "'")
 v_carr_ccod  = carr_temporal
 carrera = conectar.consultaUno ("select carr_tdesc from carreras  where carr_ccod='"&v_carr_ccod&"'")
 rut = conectar.consultaUno ("select cast(pers_nrut as varchar)+ '-'+ pers_xdv from personas where cast(pers_ncorr as varchar)='" & pers_ncorr & "'")
 v_sede  = conectar.consultaUno ("select sede_tdesc from sedes where cast(sede_ccod as varchar)='" & sede_ccod & "'")
 v_jornada  = conectar.consultaUno ("select jorn_tdesc from jornadas where cast(jorn_ccod as varchar)='" & jorn_ccod & "'")
 plan_ccod = conectar.consultaUno ("select plan_ccod from  alumnos where cast(matr_ncorr as varchar)='" & matr_ncorr & "'")
   
  activar = request.QueryString("activar")
  
  if activar = "1" then
   
	   asignaturas_disponibles_cons = " select distinct c.asig_ccod,c.asig_ccod asig_ccod_paso, ltrim(rtrim(c.asig_ccod)) + ' -> ' + c.asig_tdesc as asignatura, " & vbCrlf & _
									  " b.secc_ccod, '" & matr_ncorr & "' as matr_ncorr, " & vbCrlf & _
									  " a.nive_ccod, isnull(d.reprobado,0) as reprobado  from ( "
	
		tipo_plan = conectar.consultaUno("select isnull(plan_tcreditos,0) from planes_estudio where cast(plan_ccod as varchar)='"&plan_ccod&"'")
		
	
		if tipo_plan = "0" then
			asignaturas_disponibles_cons = asignaturas_disponibles_cons &  " SELECT DISTINCT b.asig_ccod, mc.nive_ccod,secc.moda_ccod,secc.secc_nhoras_pagar " & vbCrlf & _
											"  FROM asignaturas_comunes b,secciones secc,bloques_horarios bl,malla_curricular mc" & vbCrlf & _
											"  WHERE b.asig_ccod=secc.asig_ccod and b.mall_ccod= mc.mall_ccod and b.mall_ccod=secc.mall_ccod and secc.secc_ccod=bl.secc_ccod" & vbCrlf & _
											"  and cast(secc.peri_ccod as varchar)='"&peri_ccod&"'" & vbCrlf & _ 
											"  and  protic.completo_requisitos_asignatura (b.mall_ccod, '" & pers_ncorr & "') = 0"  & vbCrlf & _ 
											"  and  b.carr_ccod = '"&v_carr_ccod&"' and secc.secc_ncupo > 0  and cast(secc.jorn_ccod as varchar)='"&jorn_ccod&"' AND cast(secc.sede_ccod as varchar) = '" & sede_ccod & "' " & vbCrlf & _ 
											"  and cast(b.plan_ccod as varchar)='"&plan_ccod&"'"	
		else
			asignaturas_disponibles_cons = asignaturas_disponibles_cons &  " SELECT DISTINCT b.asig_ccod, b.nive_ccod,secc.moda_ccod,secc.secc_nhoras_pagar " & vbCrlf & _
											"  FROM malla_curricular b,secciones secc,bloques_horarios bl" & vbCrlf & _
											"  WHERE cast(b.plan_ccod as varchar)='"&plan_ccod&"' and b.asig_ccod=secc.asig_ccod and b.mall_ccod=secc.mall_ccod and secc.secc_ccod=bl.secc_ccod" & vbCrlf & _
											"  and cast(secc.peri_ccod as varchar)='"&peri_ccod&"'" & vbCrlf & _
											"  and  protic.completo_requisitos_asignatura (b.mall_ccod, '" & pers_ncorr & "') = 0" & vbCrlf & _
											"  and secc.secc_ncupo > 0  and cast(secc.jorn_ccod as varchar)='"&jorn_ccod&"' AND cast(secc.sede_ccod as varchar) = '" & sede_ccod & "' " & vbCrlf & _
											"  and cast(b.plan_ccod as varchar)='"&plan_ccod&"'"								
		end if
		
	
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
	"                     AND cast(sd.sitf_baprueba as varchar) = 'S'" & vbCrlf & _
	"                     AND sc.emat_ccod = 1" & vbCrlf & _
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
	"      AND c.emat_ccod = 1" & vbCrlf & _
	"      AND cast(a.sede_ccod as varchar) = '" & sede_ccod & "' " & vbCrlf & _
	"      AND cast(a.peri_ccod as varchar) = '" & peri_ccod & "' " & vbCrlf & _
	"	   AND cast(c.pers_ncorr as varchar) = '" & pers_ncorr & "'"& vbCrlf & _
	" 	   AND cast(c.emat_ccod as varchar)='1'"& vbCrlf & _
	"      union"& vbCrlf & _
	"	   select null,null,null) b, " & vbCrlf & _
	"	  asignaturas c, " & vbCrlf & _ 
	"   ( select a.asig_ccod, 1 as reprobado  " & vbCrlf & _
	"       from secciones a, cargas_academicas b, situaciones_finales c, alumnos d " & vbCrlf & _
	"      where a.secc_ccod=b.secc_ccod  " & vbCrlf & _
	"        and b.sitf_ccod=c.sitf_ccod  " & vbCrlf & _
	"        and b.matr_ncorr=d.matr_ncorr " & vbCrlf & _
	"        AND d.emat_ccod = 1" & vbCrlf & _
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
	datos_elec.carga_parametros	"tabla_vacia.xml","tabla"
	
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
	"	  then '(*)' + substring(cast(a.secc_tdesc as varchar),1,1) +  ' -> ' + cast(protic.horario(a.secc_ccod) as varchar)  +  ' -(' + cast((a.secc_ncupo - (select count(*) from cargas_academicas ca where ca.secc_ccod = a.secc_ccod) ) as varchar) + ' CUPOS)- '  " & vbCrLf & _
	"	  else substring(cast(a.secc_tdesc as varchar),1,1) + ' -> ' + cast(protic.horario(a.secc_ccod) as varchar) + ' -(' + cast((a.secc_ncupo - (select count(*) from cargas_academicas ca where ca.secc_ccod = a.secc_ccod) ) as varchar) + ' CUPOS)- '  " & vbCrLf & _
	"	  end horario--, a.secc_ncupo - isnull(COUNT (distinct c.secc_ccod), 0)  " & vbCrLf & _
	"	  FROM secciones a, cargas_academicas c  " & vbCrLf & _
	"	  WHERE a.secc_ccod *= c.secc_ccod   " & vbCrLf & _
	"	  AND cast(a.sede_ccod as varchar)='"&sede_ccod&"'  " & vbCrLf & _
	"	  and cast(a.peri_ccod as varchar)= '"&peri_ccod&"'  " & vbCrLf & _
	"	  and cast(a.asig_ccod as varchar) in ("&arr_asignatura&")  " & vbCrLf & _
	"	  and cast(a.carr_ccod as varchar) ='"&v_carr_ccod&"'  " & vbCrLf & _
	"     and (a.secc_ncupo - (select count(*) from cargas_academicas ca where ca.secc_ccod = a.secc_ccod) ) > 0 " & vbCrLf &_
	"	  GROUP BY a.asig_ccod, a.secc_ccod, a.secc_tdesc, a.secc_ncupo,carr_ccod " & vbCrLf & _
	"	  HAVING a.secc_ncupo - isnull(COUNT (distinct c.secc_ccod), 0) > 0) a  " & vbCrLf  
	
	'response.Write("<pre>"&destino&"</pre>")
	'response.End()
	
	
	filtro = "    asig_ccod in (select '%asig_ccod%' as asig_ccod ) " & vbCrLf  & _
	"	 or	asig_ccod in ( select b.asig_ccod from electivos a,secciones b  " & vbCrLf  & _
	" 	   			 	 where a.secc_ccod = b.secc_ccod  " & vbCrLf  & _
	" 	   			 	 and  cast(b.carr_ccod as varchar) ='"&v_carr_ccod&"'  " & vbCrLf  & _
	"				     and a.asig_ccod ='%asig_ccod%'  )" 
	
	formulario.agregaCampoParam "secc_ccod", "filtro", filtro
	formulario.agregaCampoParam "secc_ccod", "destino", destino
end if' fin del if que ve si presiono el botón para buscar las asignaturas (activar)

pers_nrut = conectar.consultaUno("Select pers_nrut from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
pers_xdv = conectar.consultaUno("Select pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
url="../CERTIFICADOS/HISTORICO_NOTAS_LIBRE.ASP?busqueda[0][pers_nrut]="&pers_nrut&"&busqueda[0][pers_xdv]="&pers_xdv&"&ocultar=1"


if tipo_plan = "0" then
	lenguetas_carga = Array(Array("Asignaturas Malla Curricular", "toma_carga_nuevo.asp"),Array("Formación Profesional", "toma_formacion_profesional.asp"), Array("Optativos Deportivos", "ingreso_optativos.asp"), Array("Cursos Artísticos-Culturales", "ingreso_cursos_dae.asp"))
else
	lenguetas_carga = Array(Array("Asignaturas Malla Curricular", "toma_carga_nuevo.asp"),Array("Formación Profesional", "toma_formacion_profesional.asp"), Array("Optativos Deportivos", "ingreso_optativos.asp"), Array("Cursos Artísticos-Culturales", "ingreso_cursos_dae.asp"))
end if	

if activar = "1" then 
	filtro_eliminacion = " and isnull(acse_ncorr,6) = 6 " 'solo elimina carga normal

	set f_alumno = new CFormulario
	f_alumno.Carga_Parametros "toma_carga_online.xml", "carga_tomada_eliminar"
	f_alumno.Inicializar conectar
	'response.Write(matr_ncorr)
	consulta = " select a.secc_ccod as secc_ccod2,a.secc_ccod,a.matr_ncorr,c.asig_ccod as cod_asignatura, c.asig_tdesc as asignatura,b.secc_tdesc as seccion, " & vbCrLf &_
			   " protic.horario_con_sala(b.secc_ccod) as horario, case acse_ncorr when 3 then 'Carga sin Pre-requisitos' else case a.carg_afecta_promedio when 'N' then 'Optativo' else 'Carga Regular' end end as tipo, "& vbCrLf &_
			   " isnull((select isnull(cred_valor,0) from asignaturas aa,creditos_Asignatura bb "& vbCrLf &_
			   "  where aa.cred_ccod = bb.cred_ccod and aa.asig_ccod=c.asig_ccod),0) as creditos"& vbCrLf &_
			   " from cargas_Academicas a, secciones b, asignaturas c " & vbCrLf &_
			   " where cast(matr_ncorr as varchar)='"&matr_ncorr&"' " & vbCrLf &_
			   " and a.secc_ccod=b.secc_ccod "& filtro_eliminacion & vbCrLf &_
			   " and not exists (Select 1 from equivalencias eq where eq.matr_ncorr=a.matr_ncorr and eq.secc_ccod=a.secc_ccod) " & vbCrLf &_
			   " and not exists (Select 1 from calificaciones_alumnos eq where eq.matr_ncorr=a.matr_ncorr and eq.secc_ccod=a.secc_ccod) " & vbCrLf &_
			   " and b.asig_ccod=c.asig_ccod " 
	
	'response.Write("<pre>"&consulta&"</pre>")
	f_alumno.Consultar consulta
	cantidad_tomada = f_alumno.nroFilas
	'response.Write(matr_ncorr)
end if

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
if (verifica_check_2(formulario)){
	   if (confirm("¿Está seguro(a) que desea agregar estas asignaturas a su carga académica?"))
		{ formulario.method="post"
		  formulario.action="toma_carga_proc.asp"
		  formulario.submit();
		}
		else
		{
		  document.getElementById("texto_alerta2").style.visibility="hidden";
		} 
	}
	else{
		alert('No ha seleccionado ninguna asignatura, para agregar a su carga académica.');
		document.getElementById("texto_alerta2").style.visibility="hidden";
	}  
		  
}
function verifica_check_2(formulario) {
	num=formulario.elements.length;
	c=0;
	for (i=0;i<num;i++){
		nombre = formulario.elements[i].name;
		var elem = new RegExp ("grabar","gi");
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

function elim_asig (formulario){
	if (verifica_check(formulario)){
	   if (confirm("¿Está seguro(a) que desea quitar las asignaturas seleccionadas de su carga académica?"))
		{ formulario.method="post"
		  formulario.action="eliminar_carga.asp";
		  formulario.submit();
		}
		else
		{
		  document.getElementById("texto_alerta3").style.visibility="hidden";
		} 
	}
	else{
		alert('No ha seleccionado ninguna asignatura a eliminar.');
		document.getElementById("texto_alerta3").style.visibility="hidden";
	}
}
function eliminar_carga()
{
	document.getElementById("texto_alerta3").style.visibility="visible";
	elim_asig(document.edicion);
}
function verifica_check(formulario) {
	num=formulario.elements.length;
	c=0;
	for (i=0;i<num;i++){
		nombre = formulario.elements[i].name;
		var elem = new RegExp ("eliminar","gi");
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
function MM_swapImgRestore() 
{ //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() 
{ //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) 
{ //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() 
{ //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
function guardar_carga()
{
	document.getElementById("texto_alerta2").style.visibility="visible";
	guardar(document.edicion);
}
function buscar_asignaturas()
{
	document.getElementById("texto_alerta1").style.visibility="visible";
	//document.edicion.action ="toma_formacion_profesional.asp?activar=1";//?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo+"&asig_ccod="+asignatura;
	//document.edicion.submit();
	_Navegar(this, 'toma_carga_nuevo.asp?activar=1', 'FALSE');
}
function revisar_check_grabar(campo,estado)
{   var indice;
	indice = extrae_indice(campo);
	if (estado)
	{
		document.edicion.elements["toma_carga["+indice+"][secc_ccod]"].disabled=false;
		document.edicion.elements["toma_carga["+indice+"][secc_ccod]"].id="TO-N";
	}
	else
	{
		document.edicion.elements["toma_carga["+indice+"][secc_ccod]"].disabled=true;
		document.edicion.elements["toma_carga["+indice+"][secc_ccod]"].id="TO-S";
	}
}

function  extrae_indice(cadena){
	var posicion1 = cadena.indexOf("[",0)+1;
	var posicion2 = cadena.indexOf("]",0);
	var indice=cadena.substring(posicion1, posicion2);
	return indice;
}
colores = Array(3);   colores[0] = ''; colores[1] = '#FFECC6'; colores[2] = '#FFECC6'; 
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
    <td height="80" valign="top"><img src="../imagenes/banner.jpg" width="750" height="100" border="0"></td>
  </tr>
  <%'pagina.DibujarEncabezado()%>   
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
                    <% pagina.Titulo = pagina.Titulo & "<br>" & peri_tdesc & "<br>Online"
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
							<td><font size="2" color="#4b7fc6"><strong>1.- Presione el botón para buscar asignaturas.</strong></font>
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td align="center"><a href="javascript:buscar_asignaturas();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('form_profesional','','../imagenes/boton_buscar_activo.gif',1)"><img src="../imagenes/boton_buscar_pasivo.gif" width="140" height="31" border="0" name="form_profesional"></td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td><div  align="right" id="texto_alerta1" style="visibility: hidden;">
									  <font color="#000000" size="2" face="Courier New, Courier, mono">
									  Espere mientras se realiza la búsqueda, esto puede tardar un par de segundos....</font></div></td>
						</tr>
					<%if activar = "1" then %>	
					    <tr>
							<td><font size="2" color="#4b7fc6"><strong>2.- Seleccione las Asignaturas que desea cursar este semestre.</strong></font>
							</td>
					    </tr>
					<%end if%>	
				    </table>
				     <table width="100%" border="0">
					 <%if activar = "1" then %>
					  <tr> 
						<td align="right">&nbsp;</td>
					  </tr>
					  <tr>
					  	<td align="center">
							<table class=v1 width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' id='tb_toma_carga'>
								<tr bgcolor='#C4D7FF' bordercolor='#999999'>
								    <th>&nbsp;</th>
									<th><font color='#333333'>Asignatura</font></th>
									<th><font color='#333333'>Nivel</font></th>
									<th><font color='#333333'>Sección</font></th>
								</tr>
								<%while formulario.siguiente%>
									<tr bgcolor="#FFFFFF"> 
									    <%formulario.dibujaCampo("matr_ncorr")%>
										<%formulario.dibujaCampo("asig_ccod")%>
										<td class='noclick'align='left' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%formulario.dibujaCampo("grabar")%></td>
										<td class='noclick'align='left' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%formulario.dibujaCampo("asignatura")%></td>
										<td class='noclick'align='right' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%formulario.dibujaCampo("nive_ccod")%></td>
										<td class='noclick'align='center' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%formulario.dibujaCampo("secc_ccod")%></td>
									</tr>
								<%wend%>
							</table>
						</td>
					  </tr>
					  <tr> 
						<td align="right">&nbsp;</td>
					  </tr>
					  <% if filas_asig > 0 then%>
                      <tr>
						<td align="right"><a href="javascript:guardar_carga();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('guardar_carga','','../imagenes/boton_guardar_activo.gif',1)"><img src="../imagenes/boton_guardar_pasivo.gif" width="119" height="31" border="0" name="guardar_carga"></td>
					  </tr>
					  <tr><td>&nbsp;</td></tr>
					  <tr>
						<td><div  align="right" id="texto_alerta2" style="visibility: hidden;">
						          <font color="#000000" size="2" face="Courier New, Courier, mono">
								  Espere un momento mientras guardamos su carga en el sistema....</font></div></td>
					  </tr>
					 <% end if%>
					 <%end if%>
					  <tr>
					     <td>&nbsp;</td>
				      </tr>
				  <%if matr_ncorr <> "" and activar = "1" then %>
				  <tr>
					<td><font size="2" color="#4b7fc6"><strong>3.- Acá puede eliminar las asignaturas que no desea cursar.</strong></font>
					</td>
				  </tr>
				  <tr>
                    <td>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td align="center">
						    <table class=v1 width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' id='tb_carga'>
							<tr bgcolor='#C4D7FF' bordercolor='#999999'>
								<th>&nbsp;</th>
								<th><font color='#333333'>Cod. Asignatura</font></th>
								<th><font color='#333333'>Asignatura</font></th>
								<th><font color='#333333'>Créditos</font></th>
								<th><font color='#333333'>Sección</font></th>
								<th><font color='#333333'>Horario</font></th>
								<th><font color='#333333'>Concepto</font></th>
							</tr>
							<% if cantidad_tomada > 0 then 
								  while f_alumno.siguiente%>
								<tr bgcolor="#FFFFFF"><%f_alumno.dibujaCampo("matr_ncorr")%><%f_alumno.dibujaCampo("secc_ccod")%>
									<td class='noclick'align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%f_alumno.dibujaCampo("eliminar")%></td>
									<td class='noclick'align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%f_alumno.dibujaCampo("cod_asignatura")%></td>
									<td class='noclick'align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%f_alumno.dibujaCampo("asignatura")%></td>
									<td class='noclick'align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%f_alumno.dibujaCampo("creditos")%></td>
									<td class='noclick'align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%f_alumno.dibujaCampo("seccion")%></td>
									<td class='noclick'align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%f_alumno.dibujaCampo("horario")%></td>
									<td class='noclick'align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%f_alumno.dibujaCampo("tipo")%></td>
								</tr>
								<%wend
							else%>
							   <tr bgcolor="#FFFFFF">
							       <td class='noclick'align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' colspan="7">No existen asignaturas de formación Profesional electiva dentro de su carga.</td>
							   </tr>
							 <%end if%>
							</table>
						  </td>
                        </tr>
						<tr> 
							<td align="right">&nbsp;</td>
					    </tr> 
						<% if f_alumno.nroFilas > 0 then%>
                        <tr>
							<td align="right"><a href="javascript:eliminar_carga();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('eliminar_carga','','../imagenes/boton_eliminar_activo.gif',1)"><img src="../imagenes/boton_eliminar_pasivo.gif" width="119" height="31" border="0" name="eliminar_carga"></td>
					    </tr>
					    <tr><td>&nbsp;</td></tr>
					    <tr>
						    <td>  <div  align="right" id="texto_alerta3" style="visibility: hidden;">
						          <font color="#000000" size="2" face="Courier New, Courier, mono">
								  Espere un momento mientras eliminamos su carga del sistema....</font></div></td>
					    </tr>
						<% end if%>
					 </table>
					</td>
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
            <td width="22%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    <% f_botonera.agregaBotonParam "anterior", "url", "inicio_toma_carga_2008.asp?busqueda[0][pers_nrut]="&pers_nrut&"&busqueda[0][pers_xdv]="&pers_xdv&"&enca[0][pers_nrut]="&matr_ncorr
					  f_botonera.DibujaBoton "anterior"%>
                      </div>
				   </td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton "HORARIO"%>
                  </div></td>
                  </tr>
              </table>
            </div></td>
            <td width="78%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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

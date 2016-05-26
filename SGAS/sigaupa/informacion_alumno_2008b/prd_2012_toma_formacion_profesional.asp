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
pagina.Titulo = "Asignaturas de Formación Profesional Electiva"
matr_ncorr		= 	session("matr_ncorr")
'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar



set f_botonera = new CFormulario
f_botonera.Carga_Parametros "toma_formacion_profesional.xml", "BotoneraTomaCarga"


set formulario 	= new cformulario
set errores 	= new cErrores
set datos_elec  = new cFormulario

'sacamos todos los datos en una sola consulta en vez de llenarnos de consultaUno
set f_datos = new CFormulario
f_datos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_datos.Inicializar conectar
c_datos = " select c.peri_ccod,b.sede_ccod,b.jorn_ccod,c.peri_tdesc,f.carr_ccod as carr_temporal, " & vbCrLf &_
		  " cast(i.pers_tnombre as varchar) + ' ' + cast(i.pers_tape_paterno as varchar) + ' ' + cast(i.pers_tape_materno as varchar) as nombre, " & vbCrLf &_
		  " f.carr_tdesc as carrera, cast(i.pers_nrut as varchar)+ '-'+ i.pers_xdv as rut,d.sede_tdesc as v_sede,  " & vbCrLf &_
		  " g.jorn_tdesc as v_jornada,a.plan_ccod,isnull(h.plan_tcreditos,0) as tipo_plan, i.pers_nrut,i.pers_xdv " & vbCrLf &_
		  " from alumnos a, ofertas_academicas b, periodos_academicos c,sedes d, especialidades e,  " & vbCrLf &_
		  " carreras f,jornadas g, planes_estudio h, personas i                 " & vbCrLf &_
		  " where a.ofer_ncorr = b.ofer_ncorr  " & vbCrLf &_
		  " and b.peri_ccod = c.peri_ccod " & vbCrLf &_
		  " and b.sede_ccod = d.sede_ccod " & vbCrLf &_
		  " and b.espe_ccod = e.espe_ccod " & vbCrLf &_ 
		  " and e.carr_ccod = f.carr_ccod " & vbCrLf &_
		  " and b.jorn_ccod = g.jorn_ccod " & vbCrLf &_
		  " and a.plan_ccod = h.plan_ccod " & vbCrLf &_
		  " and a.pers_ncorr = i.pers_ncorr " & vbCrLf &_
		  " and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'"
f_datos.Consultar c_datos
f_datos.siguiente		  
if f_datos.nroFilas > 0 then
	peri_ccod = f_datos.obtenerValor("peri_ccod")
	sede_ccod = f_datos.obtenerValor("sede_ccod")
	jorn_ccod = f_datos.obtenerValor("jorn_ccod")
	peri_tdesc = f_datos.obtenerValor("peri_tdesc")
	carr_temporal = f_datos.obtenerValor("carr_temporal")
	nombre = f_datos.obtenerValor("nombre")
    v_carr_ccod  = carr_temporal
    carrera = f_datos.obtenerValor("carrera")
    rut = f_datos.obtenerValor("rut")
    v_sede  = f_datos.obtenerValor("v_sede")
    v_jornada  = f_datos.obtenerValor("v_jornada")
    plan_ccod = f_datos.obtenerValor("plan_ccod")
    tipo_plan = f_datos.obtenerValor("tipo_plan")
    pers_nrut = f_datos.obtenerValor("pers_nrut")
    pers_xdv  = f_datos.obtenerValor("pers_xdv")
end if


formulario.carga_parametros "toma_formacion_profesional.xml", "toma_carga"
formulario.inicializar conectar


'peri_ccod = conectar.consultaUno("Select peri_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")
'sede_ccod = conectar.consultaUno("Select sede_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")
'jorn_ccod = conectar.consultaUno("Select jorn_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")
'peri_tdesc = conectar.consultaUno("Select protic.initcap(peri_tdesc) from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
pers_ncorr= session("pers_ncorr_alumno")
'response.End()				  
 
if matr_ncorr <> "" then 
        '----------------------------------------------En caso de alumnos nuevos se buscará el filtro para que solo muestre el primer nivel-------
	   '-------------------------------------------------------------msandoval 22-02-2005--------------------------------------------------------
	   consulta_carr=" select ltrim(rtrim(carr_ccod)) " & vbCrlf & _
				" from alumnos a, ofertas_Academicas b, especialidades c " & vbCrlf & _
				" where a.ofer_ncorr = b.ofer_ncorr " & vbCrlf & _
				" and b.espe_ccod=c.espe_ccod " & vbCrlf & _
				" and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'"
				
	    carr_temporal = conectar.consultaUno(consulta_carr)
end if 
 'response.End()

 'nombre = conectar.consultaUno ("select cast(pers_tnombre as varchar) + ' ' + cast(pers_tape_paterno as varchar) + ' ' + cast(pers_tape_materno as varchar) from personas where cast(pers_ncorr as varchar)='" & pers_ncorr & "'")
 'v_carr_ccod  = carr_temporal
 'carrera = conectar.consultaUno ("select carr_tdesc from carreras  where carr_ccod='"&v_carr_ccod&"'")
 'rut = conectar.consultaUno ("select cast(pers_nrut as varchar)+ '-'+ pers_xdv from personas where cast(pers_ncorr as varchar)='" & pers_ncorr & "'")
 'v_sede  = conectar.consultaUno ("select sede_tdesc from sedes where cast(sede_ccod as varchar)='" & sede_ccod & "'")
 'v_jornada  = conectar.consultaUno ("select jorn_tdesc from jornadas where cast(jorn_ccod as varchar)='" & jorn_ccod & "'")
 
 activar = request.QueryString("activar")
 c_tiene_formacion = " select count(*) " & vbCrlf & _
				   " from especialidades a, carreras b, planes_estudio c " & vbCrlf & _
				   " where espe_tdesc like '%formacion profesional%'      " & vbCrlf & _
				   " and a.carr_ccod=b.carr_ccod and a.espe_ccod=c.espe_ccod " & vbCrlf & _
				   " and exists (select 1 from malla_curricular cc " & vbCrlf & _
				   "             where cc.plan_ccod=c.plan_ccod) and b.carr_ccod='"&v_carr_ccod&"'"
	
 tiene_formacion = conectar.consultaUno(c_tiene_formacion)
 if tiene_formacion= "0" then 
 	activar="0"
 end if
 
 if activar = "1" then 
	    c_plan_ccod = " select c.plan_ccod " & vbCrlf & _
				   " from especialidades a, carreras b, planes_estudio c " & vbCrlf & _
				   " where espe_tdesc like '%formacion profesional%'      " & vbCrlf & _
				   " and a.carr_ccod=b.carr_ccod and a.espe_ccod=c.espe_ccod " & vbCrlf & _
				   " and exists (select 1 from malla_curricular cc " & vbCrlf & _
				   "             where cc.plan_ccod=c.plan_ccod) and b.carr_ccod='"&v_carr_ccod&"'"
	
		 plan_ccod = conectar.consultaUno(c_plan_ccod)
 
		asignaturas_disponibles_cons = " select distinct c.asig_ccod,c.asig_ccod asig_ccod_paso, ltrim(rtrim(c.asig_ccod)) + '-->' + c.asig_tdesc as asignatura, " & vbCrlf & _
		" b.secc_ccod, '"&matr_ncorr&"' as matr_ncorr, " & vbCrlf & _
		" a.nive_ccod " & vbCrlf & _
		" from ( " & vbCrlf & _
		"        select distinct b.asig_ccod, b.nive_ccod,secc.moda_ccod,secc.secc_nhoras_pagar " & vbCrlf & _
		"        from malla_curricular b, secciones secc, asignaturas c " & vbCrlf & _
		"        where cast(b.plan_ccod as varchar)= '"&plan_ccod&"' and b.mall_ccod=secc.mall_ccod " & vbCrlf & _
		"        and b.asig_ccod=secc.asig_ccod  and secc.asig_ccod=c.asig_ccod " & vbCrlf & _
		"        and cast(secc.peri_ccod as varchar)='"&peri_ccod&"' " & vbCrlf & _
		"        and cast(secc.sede_ccod as varchar)='"&sede_ccod&"' and cast(secc.jorn_ccod as varchar)='"&jorn_ccod&"'  " & vbCrlf & _
		"        and secc.secc_ncupo > 0  and exists (select 1 from bloques_horarios bh where bh.secc_ccod=secc.secc_ccod) " & vbCrlf & _
		"   AND NOT (  " & vbCrlf & _
		"			EXISTS (SELECT 1 " & vbCrlf & _
		"                    FROM secciones sa," & vbCrlf & _
		"                         cargas_academicas sb," & vbCrlf & _
		"                         alumnos sc," & vbCrlf & _
		"                         situaciones_finales sd" & vbCrlf & _
		"                   WHERE sa.secc_ccod = sb.secc_ccod" & vbCrlf & _
		"                     AND sa.asig_ccod = secc.asig_ccod" & vbCrlf & _
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
		"				 and a.asig_ccod=secc.asig_ccod " & vbCrlf & _
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
		"								 and a.asig_ccod=secc.asig_ccod " & vbCrlf & _
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
		"                      AND MC.ASIG_CCOD=secc.ASIG_CCOD " & vbCrlf & _
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
		"	  asignaturas c " & vbCrlf & _ 
		"  where a.asig_ccod *=b.asig_ccod  " & vbCrlf & _
		"  and a.asig_ccod=c.asig_ccod " 
else
	asignaturas_disponibles_cons = "select * from sexos where 1=2 "	
end if

	
formulario.consultar asignaturas_disponibles_cons
'response.Write("<pre>"&asignaturas_disponibles_cons&"</pre>")
'response.End()
filas_asig = formulario.nrofilas

set datos_elec		=	new cFormulario
datos_elec.inicializar	conectar
datos_elec.carga_parametros	"tabla_vacia.xml","tabla"
if activar = "1" then
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
	"	  then '(*)' + substring(cast(a.secc_tdesc as varchar),1,1) +  ' -> ' + cast(protic.horario(a.secc_ccod) as varchar)  +  ' -(' + cast((a.secc_ncupo - (select count(*) from cargas_academicas ca where ca.secc_ccod = a.secc_ccod) ) as varchar) + ' CUPOS) ' " & vbCrLf & _
	"	  else substring(cast(a.secc_tdesc as varchar),1,1) + ' -> ' + cast(protic.horario(a.secc_ccod) as varchar) + ' -(' + cast((a.secc_ncupo - (select count(*) from cargas_academicas ca where ca.secc_ccod = a.secc_ccod) ) as varchar) + ' CUPOS) ' " & vbCrLf & _
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
	'response.Write("<pre>"&filtro&"</pre>")
	
	formulario.agregaCampoParam "secc_ccod", "filtro", filtro
	formulario.agregaCampoParam "secc_ccod", "destino", destino
end if
'pers_nrut = conectar.consultaUno("Select pers_nrut from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
'pers_xdv = conectar.consultaUno("Select pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
url="../CERTIFICADOS/HISTORICO_NOTAS_LIBRE.ASP?busqueda[0][pers_nrut]="&pers_nrut&"&busqueda[0][pers_xdv]="&pers_xdv&"&ocultar=1"

'lenguetas_carga = Array(Array("Asignaturas Malla Curricular", "toma_carga_nuevo.asp"),Array("Formación Profesional", "toma_formacion_profesional.asp"), Array("Optativos Deportivos", "ingreso_optativos.asp"), Array("Cursos Artísticos-Culturales", "ingreso_cursos_dae.asp"))
if activar = "1" then
set f_alumno = new CFormulario
f_alumno.Carga_Parametros "toma_formacion_profesional.xml", "carga_tomada_eliminar"
f_alumno.Inicializar conectar
consulta = " select a.secc_ccod as secc_ccod2,a.secc_ccod,a.matr_ncorr,c.asig_ccod as cod_asignatura, c.asig_tdesc as asignatura,b.secc_tdesc as seccion, " & vbCrLf &_
		   " protic.horario_con_sala(b.secc_ccod) as horario, case acse_ncorr when 3 then 'Carga sin Pre-requisitos' else case a.carg_afecta_promedio when 'N' then 'Optativo' else 'Carga Regular' end end as tipo, "& vbCrLf &_
		   " isnull((select isnull(cred_valor,0) from asignaturas aa,creditos_Asignatura bb "& vbCrLf &_
           "  where aa.cred_ccod = bb.cred_ccod and aa.asig_ccod=c.asig_ccod),0) as creditos"& vbCrLf &_
		   " from cargas_Academicas a, secciones b, asignaturas c,malla_curricular d " & vbCrLf &_
		   " where cast(matr_ncorr as varchar)='"&matr_ncorr&"' " & vbCrLf &_
		   " and a.secc_ccod=b.secc_ccod and isnull(acse_ncorr,6) = 6 and b.mall_ccod=d.mall_ccod and b.asig_ccod=d.asig_ccod and cast(d.plan_ccod as varchar)='"&plan_ccod&"'" & vbCrLf &_
		   " and not exists (Select 1 from equivalencias eq where eq.matr_ncorr=a.matr_ncorr and eq.secc_ccod=a.secc_ccod) " & vbCrLf &_
		   " and not exists (Select 1 from calificaciones_alumnos eq where eq.matr_ncorr=a.matr_ncorr and eq.secc_ccod=a.secc_ccod) " & vbCrLf &_
		   " and b.asig_ccod=c.asig_ccod " 

f_alumno.Consultar consulta
cantidad_tomada = f_alumno.nroFilas
end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Toma de Carga Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumnos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function ayuda(valor)
{ var mensaje="";
    mensaje = "AYUDA\nLa toma de carga online permite al alumno adelantar este proceso ajustando su carga horaria a los días que más le acomoden. Para ello: \n\n" +
	       	  "- Hacer click en el botón para inscribir carga.\n"+
			  "- Seleccionar carga del plan de estudios,formación profecional electiva y/o carga de optativos deportivos y DAE.\n"+
			  "- Dejar una copia impresa de su horario y carga asignada para el periodo.";
		   
	alert(mensaje);
}
function dibujar(formulario){
	formulario.submit();
}

function ver_notas()
{
self.open('<%=url%>','notas','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

function horario(){
	self.open('horario_alumno.asp?matr_ncorr=<%=matr_ncorr%>','horario','width=700px, height=550px, scrollbars=yes, resizable=yes')
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
		  formulario.action="toma_formacion_profesional_proc.asp"
		  formulario.submit();
		}
		else
		{
		  document.getElementById("texto_alerta2").style.visibility="hidden";
		} 
	}
	else{
		alert('No ha seleccionado ninguna asignatura de formación profesional, para agregar a su carga académica.');
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
		  formulario.action="eliminar_carga_formacion_profesional.asp";
		  formulario.submit();
		}
		else
		{
		  document.getElementById("texto_alerta3").style.visibility="hidden";
		} 
	}
	else{
		alert('No ha seleccionado ninguna asignatura de formación profesional a eliminar.');
		document.getElementById("texto_alerta3").style.visibility="hidden";
	}
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
function buscar_asignaturas()
{
	document.getElementById("texto_alerta1").style.visibility="visible";
	//document.edicion.action ="toma_formacion_profesional.asp?activar=1";//?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo+"&asig_ccod="+asignatura;
	//document.edicion.submit();
	_Navegar(this, 'toma_formacion_profesional.asp?activar=1', 'FALSE');
}
function guardar_carga()
{
	document.getElementById("texto_alerta2").style.visibility="visible";
	guardar(document.edicion);
}
function eliminar_carga()
{
	document.getElementById("texto_alerta3").style.visibility="visible";
	elim_asig(document.edicion);
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
<style type="text/css">
#menu div.barraMenu,
#menu div.barraMenu a.botonMenu {
font-family: sans-serif, Verdana, Arial;
font-size: 8pt;
color: white;
}

#menu div.barraMenu {
text-align: left;
}

#menu div.barraMenu a.botonMenu {
background-color: #4b73a6;
border-bottom-style:double;
border-color:#FFFFFF;
color: white;
cursor: pointer;
padding: 4px 6px 2px 5px;
text-decoration: none;
}

#menu div.barraMenu a.botonMenu:hover {
background-color: #FFFFFF;
color:#4b73a6;
}

#menu div.barraMenu a.botonMenu:active {
background-color: #637D4D;
color: black;
}
</style>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" background="imagenes/fondo.jpg">
<center>
<table align="center" width="700">
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong><%pagina.DibujarTituloPagina%></strong></font></td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="left">
			<table width="700" cellpadding="0" cellspacing="0" border="0" bgcolor="#970000">
				<tr><td bgcolor="#84a6d3">
						<table width="100%" height="90" align="left" cellpadding="0" cellspacing="0" bgcolor="#84a6d3">
						<TR valign="bottom">
							<TD width="75" height="90"><a href="toma_carga_nuevo.asp"><img width="75" height="90" border="0" src="imagenes/LENGUETA1b.png" alt="IR A INGRESO DE ASIGNATURAS DEL PLAN"></a></TD>
							<TD width="75" height="90"><img width="75" height="90" border="0" src="imagenes/LENGUETA2b.png" ></TD>
							<TD width="75" height="90"><a href="ingreso_cursos_dae.asp"><img width="75" height="90" border="0" src="imagenes/LENGUETA3b.png" alt="IR A INGRESO DE ASIGNATURAS DAE"></a></TD>
							<TD width="75" height="90"><a href="ingreso_optativos.asp"><img width="75" height="90" border="0" src="imagenes/LENGUETA4b.png" alt="IR A INGRESO DE ASIGNATURAS DEPORTIVAS"></a></TD>
							<TD height="90">&nbsp;</TD>
						</TR>
						</table>
				    </td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="33%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Asignaturas Formación P.</strong></font></td>
										   <td><hr></td>
										   <TD width="10%">
										   		<%POS_IMAGEN = 4%>
										   		<a href="javascript:ayuda(1)"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda2.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda1.png';return true ">
												<img src="imagenes/ayuda1.png" border="0" width="38" height="38" alt="¿Cómo funciona?"> 
												</a>
											</TD>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<form name="temporal" action="toma_carga_nuevo.asp"> 
									  <tr> 
										<td height="20" width="20%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Rut</strong></font></td>
										<td colspan="3" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%=rut%></font></td>
									  </tr>
									  <tr> 
										<td height="20" width="20%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nombre</strong></font></td>
										<td colspan="3" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%=nombre%></font></td>
									  </tr>
									  <tr> 
										<td height="20" width="20%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Sede</strong></font></td>
										<td colspan="3" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%=v_sede%></font></td>
									  </tr>
									  <tr> 
										<td height="20" width="20%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Carrera</strong></font></td>
										<td colspan="3" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%=carrera%></font></td>
									  </tr>
									  <tr> 
										
                          <td height="19" width="20%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Jornada</strong></font></td>
										<td colspan="3" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%=v_jornada%></font></td>
									  </tr>
									  </form>
									  <tr>
									  	<td colspan="4">&nbsp;</td>
									  </tr>
									  <form name="edicion">
			  						  <input type="hidden" name="matr_ncorr" value="<%=matr_ncorr%>">
									  <%if tiene_formacion <> "0" then %>
								       <tr>
									    	<td colspan="4"><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>1.- Presione el botón para buscar asignaturas.</strong></font></td>
									   </tr>
									   <tr>
									  	<td colspan="4">&nbsp;</td>
									   </tr>
									   <tr>
									  	<td colspan="4" align="center">
														 <%POS_IMAGEN = POS_IMAGEN + 1%>
															<a href="javascript:buscar_asignaturas();"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/buscar2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/buscar1.png';return true ">
																<img src="imagenes/buscar1.png" border="0" width="70" height="70" alt="BUSCAR ASIGNATURAS DISPONIBLES DEL PLAN"> 
															</a>
										</td>
									  </tr>
									  <tr>
									  	<td colspan="4">&nbsp;</td>
									  </tr>
									  <tr>
									  	<td colspan="4"><div  align="right" id="texto_alerta1" style="visibility: hidden;">
													     <font color="#000000" size="2" face="Courier New, Courier, mono">
													        Espere mientras se realiza la búsqueda, esto puede tardar un par de segundos....
													     </font>
													    </div>
									  	</td>
									  </tr>
									  <%else%>
									  <tr>
											<td align="center" colspan="4">
											 <table width="80%" border="1" bordercolor="#4B7FC6">
												<tr>
													<td align="center"><font size="3" color="#4b7fc6"><strong>Lo Sentimos pero la carrera a la cual perteneces, no posee asignaturas de Formación Profesional Electiva.</strong></font></td>
												</tr>
											 </table>
											</td>
									  </tr>
									  <tr>
											<td colspan="4">&nbsp;</td>
									  </tr>  
									  <%end if%>
									   <%if activar = "1" then %>	
											<tr>
												<td colspan="4"><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>2.- Seleccione las Asignaturas que desea cursar este semestre.</strong></font>
												</td>
											</tr>
										<%end if%>
										<tr>
											<td colspan="4">&nbsp;</td>
										</tr> 
										<%if activar = "1" then %>
										  <tr> 
											<td align="right" colspan="4">&nbsp;</td>
										  </tr>
										  <tr>
											<td align="center" colspan="4">
												<table align="center" class=v1 width='98%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' id='tb_toma_carga'>
													<tr bgcolor='#C4D7FF' bordercolor='#999999'>
														<th>&nbsp;</th>
														<th><font color='#333333'>Asignatura</font></th>
														<th><font color='#333333'>Nivel</font></th>
														<th><font color='#333333'>Sección</font></th>
													</tr>
													<% while formulario.siguiente%>
														<tr bgcolor="#FFFFFF"> 
															<%formulario.dibujaCampo("matr_ncorr")%>
															<%formulario.dibujaCampo("asig_ccod")%>
															<td class='noclick'align='left' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%formulario.dibujaCampo("grabar")%></td>
															<td class='noclick'align='left' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%formulario.dibujaCampo("asignatura")%></td>
															<td class='noclick'align='center' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%formulario.dibujaCampo("nive_ccod")%></td>
															<td class='noclick'align='left' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%formulario.dibujaCampo("secc_ccod")%></td>
														</tr>
													<%wend%>
												</table>
											</td>
										  </tr>
										  <tr> 
											<td align="right" colspan="4">&nbsp;</td>
										  </tr>
										 <% if activar = "1" and filas_asig > 0 then%>
										  <tr>
											<td align="center" colspan="4">
													<%POS_IMAGEN = POS_IMAGEN + 1%>
															<a href="javascript:guardar_carga();"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/GUARDAR2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/GUARDAR1.png';return true ">
																<img src="imagenes/GUARDAR1.png" border="0" width="70" height="70" alt="AGREGAR ASIGNATURAS A TU CARGA ACADÉMICA"> 
															</a>
										    </tr>
										  <tr><td colspan="4">&nbsp;</td></tr>
										  <tr>
											<td colspan="4"><div  align="right" id="texto_alerta2" style="visibility: hidden;">
													  <font color="#000000" size="2" face="Courier New, Courier, mono">
													  Espere un momento mientras guardamos su carga en el sistema....</font></div></td>
										  </tr>
										 <% end if%>
										 <%end if%>
									  <tr>
									  	<td colspan="4">&nbsp;</td>
									  </tr>
									  <%if matr_ncorr <> "" and activar = "1" then %>
									  <tr>
										<td colspan="4"><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>3.- Acá puede eliminar las asignaturas que no desea cursar.</strong></font>
										</td>
									  </tr>
									  <tr>
									  	<td colspan="4">&nbsp;</td>
									  </tr>
									  <tr>
										  <td colspan="4">
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
													   <td class='noclick'align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' colspan="7">Aún no presentas carga tomada para el periodo 2008</td>
												    </tr>
												    <%end if%>
												</table>
						  						</td>
                        					</tr>
											<tr> 
												<td align="right">&nbsp;</td>
											</tr> 
											<% if activar = "1" and f_alumno.nroFilas > 0 then%>
											<tr>
												<td align="center">
															<%POS_IMAGEN = POS_IMAGEN + 1%>
															<a href="javascript:eliminar_carga();"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ELIMINAR2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ELIMINAR1.png';return true ">
																<img src="imagenes/ELIMINAR1.png" border="0" width="70" height="70" alt="QUITAR ASIGNATURAS DE LA CARGA ASIGNADA"> 
															</a>
												</td>
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
									    
									  </form>
									  <tr>
									  	<td colspan="4"><hr style="border-top: 1px solid #496da6;"/></td>
									  </tr>
									  <tr>
									  	<td>&nbsp;</td>
										<td align="right">
											               <%POS_IMAGEN = POS_IMAGEN + 1%>
															<a href="inicio_toma_carga_2008.asp"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
																<img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER A PÁGINA PRINCIPAL"> 
															</a>
										</td>
										<td align="left"><%POS_IMAGEN = POS_IMAGEN + 1%>
															<a href="javascript:horario();"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/HORARIO2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/HORARIO1.png';return true ">
																<img src="imagenes/HORARIO1.png" border="0" width="70" height="70" alt="IMPRIMIR HORARIO DE CLASES"> 
															</a></td>
										<td>&nbsp;</td>
									  </tr>  
								  </table>
                  
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>
		</td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
</table>
</center>
</body>
</html>


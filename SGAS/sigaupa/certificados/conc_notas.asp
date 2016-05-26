<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeOut = 150000
q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
q_peri_ccod = Request.QueryString("b[0][peri_ccod]")
q_solo_aprobadas = Request.QueryString("b[0][solo_aprobadas]")
carrera = Request.QueryString("enca[0][carreras_alumno]") ''PLAN DE LA CARRERA
'response.write carrera
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Certificado de Concentración de Notas"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set errores 	= new cErrores

set negocio = new CNegocio
negocio.Inicializa conexion

if q_pers_nrut <> "" then
sql_carr_consul = "SELECT max(saca_ncorr) FROM ALUMNOS_SALIDAS_CARRERA WHERE PERS_NCORR = protic.obtener_pers_ncorr("&q_pers_nrut&")"
'response.write sql_carr_consul
saca_ncorr_envio = conexion.consultaUno(sql_carr_consul)
'response.write carr_ccod_consultada
end if

'debemos buscar el plan que corresponda a la selección y con el luego consultar la tabla concentracion_notas
if carrera = "" then
	plan_consulta = "0"
else
	plan_consulta = carrera	
end if


tiene_salida_intermedia = "0"
if carrera <> "" then 
    pers_ncorr_temporal=conexion.consultaUno("select * from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
    tiene_salida_intermedia = conexion.consultaUno("select count(*) from alumnos_salidas_intermedias where cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and cast(saca_ncorr as varchar)='"&carrera&"' and emat_ccod in (4,8) " )
    tiene_minors = conexion.consultaUno("select count(*) from alumnos_salidas_carrera a, salidas_carrera b where a.saca_ncorr=b.saca_ncorr and  cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and cast(a.saca_ncorr as varchar)='"&carrera&"' and tsca_ccod in (6) " )

    if tiene_salida_intermedia = "0" and tiene_minors = "0" then
	    codigo_carrera = conexion.consultaUno("select carr_ccod from planes_estudio a, especialidades b where cast(a.plan_ccod as varchar)='"&carrera&"' and a.espe_ccod=b.espe_ccod")
    	especialidad =conexion.consultaUno("select a.espe_ccod from planes_estudio a, especialidades b where cast(a.plan_ccod as varchar)='"&carrera&"' and a.espe_ccod=b.espe_ccod")
	elseif tiene_minors = "0" then
		codigo_carrera = conexion.consultaUno("select carr_ccod from alumnos_salidas_intermedias a, salidas_carrera b where a.saca_ncorr=b.saca_ncorr and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and cast(a.saca_ncorr as varchar)='"&carrera&"' and emat_ccod in (4,8) ")
		especialidad = conexion.consultaUno("select espe_ccod from ofertas_academicas a where ofer_ncorr=protic.ultima_oferta_matriculado('"&pers_ncorr_temporal&"')")
	else
		codigo_carrera = conexion.consultaUno("select carr_ccod from alumnos_salidas_carrera a, salidas_carrera b where a.saca_ncorr=b.saca_ncorr and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and cast(a.saca_ncorr as varchar)='"&carrera&"' and tsca_ccod in (6) ")
		especialidad = conexion.consultaUno("select espe_ccod from ofertas_academicas a where ofer_ncorr=protic.ultima_oferta_matriculado('"&pers_ncorr_temporal&"')")
	end if
end if

vd_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
if q_pers_nrut = "" then
v_rut =0
else
v_rut= q_pers_nrut
end if
'response.Write(vd_peri_ccod)
con_matricula=conexion.consultaUno("select case count(*) when 0 then 'No' else 'Sí' end from alumnos aa, ofertas_academicas bb where  aa.ofer_ncorr=bb.ofer_ncorr and cast(bb.peri_ccod as varchar)= '"&vd_peri_ccod&"' and aa.emat_ccod=1 and aa.pers_ncorr=protic.obtener_pers_ncorr1('"&v_rut&"')")

'response.Write(con_matricula)
'---------------------------------------------------------------------------------------------------

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "conc_notas.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "conc_notas.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.siguiente

if not esVacio(q_pers_nrut) then
	pers_ncorr_temporal=conexion.consultaUno("select * from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
	consulta="(select c.peri_ccod, cast(c.anos_ccod as varchar)+ ' - ' + cast(c.plec_ccod as varchar) + 'º Semestre ' as desc_periodo " & vbCrLf &_
	         "from alumnos a,ofertas_Academicas b, periodos_academicos c " & vbCrLf &_
			 "where cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"'" & vbCrLf &_
			 "and a.ofer_ncorr=b.ofer_ncorr and emat_ccod not in (6,11)" & vbCrLf &_
			 "and b.peri_ccod=c.peri_ccod)t"
	f_busqueda.AgregaCampoParam "peri_ccod","destino",consulta
	'response.Write("<pre>"&consulta&"</pre>")
	
	if not esvacio(pers_ncorr_temporal) then
    es_moroso = conexion.consultaUno("select protic.es_moroso('"&pers_ncorr_temporal&"', getDate())")
	if es_moroso="N" then
		moroso = "No"
	else
	    consulta_monto = " select isnull(sum(protic.total_recepcionar_cuota(dc.tcom_ccod, dc.inst_ccod,dc.COMP_NDOCTO,dc.DCOM_NCOMPROMISO)), 0) "& vbCrLf &_
    					 " from compromisos cc,detalle_compromisos dc "& vbCrLf &_
    					 " where cc.tcom_ccod = dc.tcom_ccod "& vbCrLf &_
			             "        and cc.comp_ndocto = dc.comp_ndocto "& vbCrLf &_
				         "        and cc.inst_ccod = dc.inst_ccod      "& vbCrLf &_
						 "        --and convert(datetime,dc.DCOM_FCOMPROMISO,103) < convert(datetime,getDate(),103) "& vbCrLf &_
			             "		and dateadd(day,4,convert(datetime,dc.DCOM_FCOMPROMISO,103)) < convert(datetime,getDate(),103) "& vbCrLf &_
				         "        and dc.ecom_ccod = 1 "& vbCrLf &_
				         "        and cc.ecom_ccod = 1 "& vbCrLf &_
				         "        and cast(cc.pers_ncorr as varchar)= '"&pers_ncorr_temporal&"'" 
		
		moroso = "Sí"		
		monto_deuda = conexion.consultaUno(consulta_monto)
    end if
end if
	
end if
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.AgregaCampoCons "peri_ccod", q_peri_ccod
f_busqueda.AgregaCampoCons "solo_aprobadas", q_solo_aprobadas

'response.Write(pers_ncorr_temporal)

'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "conc_notas.xml", "encabezado"
f_encabezado.Inicializar conexion

if not esVacio(q_peri_ccod) then
	consulta = "select protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, b.plan_ccod,(select talu_tdesc from tipos_alumnos aa where aa.talu_ccod=b.talu_ccod) tipo_alumnoUpa, " & vbCrLf &_
			   "       protic.obtener_nombre_carrera(b.ofer_ncorr, 'C') as carrera, protic.ano_ingreso_plan(b.pers_ncorr, b.plan_ccod) as ano_ingreso_plan, cast(d.espe_nduracion as varchar) + ' Semestres' as duas_tdesc " & vbCrLf &_
			   "from personas a, alumnos b, ofertas_academicas c, especialidades d" & vbCrLf &_
			   "where a.pers_ncorr = b.pers_ncorr   " & vbCrLf &_
			   "  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
			   "  and c.espe_ccod = d.espe_ccod " & vbCrLf &_
			   "  and emat_ccod not in (6,9,11) " & vbCrLf &_
			   "  and cast(c.peri_ccod as varchar)= '"&q_peri_ccod&"'" & vbCrLf &_
			   "  and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "' "
			   
	f_encabezado.AgregaCampoParam "carreras_alumno","permiso","OCULTO"
	f_encabezado.AgregaCampoParam "carrera","permiso","LECTURA"
	
	consulta_carrera="(Select '' as carr_ccod,'' as carr_tdesc) s"		   
else
	consulta = "select top 1 protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, b.plan_ccod,(select talu_tdesc from tipos_alumnos aa where aa.talu_ccod=b.talu_ccod) tipo_alumnoUpa, " & vbCrLf &_
			   "       ltrim(rtrim(protic.obtener_nombre_carrera(b.ofer_ncorr, 'C'))) as carrera, protic.ano_ingreso_plan(b.pers_ncorr, b.plan_ccod) as ano_ingreso_plan, cast(d.espe_nduracion as varchar) + ' Semestres' as duas_tdesc " & vbCrLf &_
			   "from personas a, alumnos b, ofertas_academicas c, especialidades d" & vbCrLf &_
			   "where a.pers_ncorr = b.pers_ncorr   " & vbCrLf &_
			   "  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
			   "  and c.espe_ccod = d.espe_ccod " 
			   if not esVacio(carrera) then
					consulta=consulta & " and cast(d.carr_ccod as varchar)='"&codigo_carrera&"'"
			   else
					consulta=consulta & "  and b.ofer_ncorr = protic.ultima_oferta_matriculado(a.pers_ncorr) " 
			   end if
			   consulta=consulta &" and emat_ccod not in (6,9,11) " & vbCrLf &_
			   "  and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "' "
			   
	'response.Write("<pre>"&consulta&"</pre>")
	consulta_carrera="( select tra.plan_ccod as carr_ccod,  " & vbCrLf &_
					 " case (select count(*) from alumnos_salidas_carrera tt, salidas_carrera t1   " & vbCrLf &_
					 " where tt.pers_ncorr=tra.pers_ncorr and tt.saca_ncorr=t1.saca_ncorr   " & vbCrLf &_
					 " and t1.plan_ccod=tra.plan_ccod ) when 0 then '' else '* ' end +   " & vbCrLf &_
					 " ltrim(rtrim(carr_tdesc)) + ' - ' + ltrim(rtrim(trb.plan_tdesc)) as carr_tdesc  " & vbCrLf &_
					 " from  " & vbCrLf &_
					 " (  " & vbCrLf &_
					 "    select distinct a.pers_ncorr,ltrim(rtrim(d.carr_tdesc)) as carr_tdesc,  " & vbCrLf &_
					 "     (select top 1 plan_ccod from alumnos tt, ofertas_academicas t2, especialidades t3  " & vbCrLf &_
					 "      where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  " & vbCrLf &_
					 "      and tt.pers_ncorr=a.pers_ncorr and t3.carr_ccod=c.carr_ccod   " & vbCrLf &_
					 "      and emat_ccod not in (6,11) order by t2.peri_ccod desc) as plan_ccod  " & vbCrLf &_
					 "     from alumnos a, ofertas_academicas b, especialidades c, carreras d  " & vbCrLf &_
					 "     where cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"'   " & vbCrLf &_
					 "     and a.ofer_ncorr=b.ofer_ncorr   " & vbCrLf &_
					 "     and b.espe_ccod=c.espe_ccod    " & vbCrLf &_
					 "     and emat_ccod not in (6,11)  " & vbCrLf &_
					 "     and c.carr_ccod=d.carr_ccod   " & vbCrLf &_
					 " )tra, planes_estudio trb  " & vbCrLf &_
					 " where tra.plan_ccod=trb.plan_ccod " & vbCrLf &_
					 " union " & vbCrLf &_
					 " select t3.saca_ncorr as carr_ccod, 'S.I.:' + ltrim(rtrim(t4.carr_tdesc)) + ' - Salida Intermedia' as carr_tdesc " & vbCrLf &_
					 " from alumnos_salidas_intermedias t2,salidas_carrera t3,  carreras t4 " & vbCrLf &_
					 " where t2.saca_ncorr=t3.saca_ncorr and t3.carr_ccod=t4.carr_ccod and t3.tsca_ccod='4' and t2.emat_ccod in (4,8) " & vbCrLf &_
					 " and cast(t2.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' " & vbCrLf &_
					 " union " & vbCrLf &_
					 " select t3.saca_ncorr as carr_ccod, 'MINORS ' + ltrim(rtrim(t3.saca_tdesc)) as carr_tdesc " & vbCrLf &_
					 " from alumnos_salidas_carrera t2,salidas_carrera t3,  carreras t4 " & vbCrLf &_
					 " where t2.saca_ncorr=t3.saca_ncorr and t3.carr_ccod=t4.carr_ccod and t3.tsca_ccod='6' " & vbCrLf &_
					 " and cast(t2.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' ) s"
	
	
	
	'response.Write("<pre>"&consulta_carrera&"</pre>")
	'f_encabezado.AgregaCampoCons "carreras_alumno",carrera
	f_encabezado.AgregaCampoParam "carreras_alumno","permiso","LECTURAESCRITURA"
	f_encabezado.AgregaCampoParam "carrera","permiso","OCULTO"				 
end if


'response.Write("<pre>"&consulta&"</pre>")
f_encabezado.Consultar consulta
f_encabezado.Siguiente

if plan_consulta = "0" then 
	v_plan_ccod = f_encabezado.ObtenerValor("plan_ccod")
else
	v_plan_ccod = plan_consulta
end if
'response.Write(carrera)
f_encabezado.AgregaCampoCons "carreras_alumno", carrera

cantidad_planes = conexion.consultaUno("select count(distinct plan_ccod) from alumnos where cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"'")
'response.Write("select count(distinct plan_ccod) from alumnos where cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"'")

if cantidad_planes = "1" and carrera = "" then
  v_plan_ccod = conexion.consultaUno("select top 1 plan_ccod from alumnos where cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"'")
  v_carr_ccod = conexion.consultaUno("select carr_ccod from planes_estudio a, especialidades b where a.espe_ccod=b.espe_ccod and cast(a.plan_ccod as varchar)='"&v_plan_ccod&"'")
  v_conc_notas =  conexion.consultaUno("select count(*) from concentracion_notas where cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and  cast(plan_ccod as varchar)='"&v_plan_ccod&"'")
  plan_consulta = v_plan_ccod
  carrera = v_plan_ccod
  
  f_encabezado.AgregaCampoCons "carreras_alumno", v_plan_ccod
  
  set f_malla = new CFormulario
  f_malla.Carga_Parametros "tabla_vacia.xml", "tabla"  
  f_malla.Inicializar conexion
  
  c_malla = " select a.asig_ccod, b.asig_tdesc, " & vbCrLf &_
			" c.duas_tdesc as plec_ccod,b.asig_nhoras as horas, " & vbCrLf &_
			" isnull(protic.estado_ramo_concentracion('"&pers_ncorr_temporal&"',b.asig_ccod,'"&v_carr_ccod&"',a.plan_ccod,'"&vd_peri_ccod&"'),'') as cadena " & vbCrLf &_
			" from malla_curricular a, asignaturas b, duracion_asignatura c " & vbCrLf &_
			" where cast(plan_ccod as varchar)='"&v_plan_ccod&"' " & vbCrLf &_
			" and a.asig_ccod=b.asig_ccod " & vbCrLf &_
			" and b.duas_ccod=c.duas_ccod"
		
  f_malla.Consultar c_malla
 
  if v_conc_notas  = "0" and f_malla.nroFilas > 0 then
      cadena_sin_homologar = ""
	  grabados_automaticos = 0
	  while f_malla.siguiente 
		asig1 = f_malla.obtenerValor("asig_ccod")
		asig2 = f_malla.obtenerValor("asig_tdesc")
		plec1 = f_malla.obtenerValor("plec_ccod")
		horas1 = f_malla.obtenerValor("horas")
		cadena1 = f_malla.obtenerValor("cadena")
		if cadena1 <> "" then
		    'response.Write(cadena1)
			a_cadena = split(cadena1,"*")
			calificacion1 = a_cadena(0)
			estado1 = a_cadena(1)
			periodo1 = a_cadena(2)
			asig_homo1 = a_cadena(3)
			
			if estado1 = "HM" then
			  'asig1 = asig_homo1
			  'asig2 = conexion.consultaUno("select asig_tdesc from asignaturas where asig_ccod='"&asig1&"'")
			  cadena_sin_homologar = cadena_sin_homologar & "<br>- "&asig1&": "&asig2
			end if
			anos1 = conexion.consultaUno("select cast(anos_ccod as varchar)+' 0'+cast(plec_ccod as varchar) from periodos_academicos where cast(peri_ccod as varchar)='"&periodo1&"'")
			if estado1 <> "HM" then
				if calificacion1 <> "0" then
				  c_insert = " insert into concentracion_notas (pers_ncorr,asig_ccod,anos_ccod,plan_ccod,asig_tdesc,nota_final,sitf_ccod,plec_ccod,horas,cantidad, "&_
							 " audi_tusuario,audi_fmodificacion,salida_intermedia) "&_
							 " values ("&pers_ncorr_temporal&",'"&asig1&"','"&anos1&"',"&v_plan_ccod&",'"&asig2&"',"&calificacion1&",'"&estado1&"','"&plec1&"',"&horas1&",NULL,'9119940',getDate(),null)"
				  conexion.ejecutaS c_insert
				  grabados_automaticos = grabados_automaticos + 1
				else
				  c_insert = "insert into concentracion_notas (pers_ncorr,asig_ccod,anos_ccod,plan_ccod,asig_tdesc,nota_final,sitf_ccod,plec_ccod,horas,cantidad, "&_
							 " audi_tusuario,audi_fmodificacion,salida_intermedia)"&_
							 " values ("&pers_ncorr_temporal&",'"&asig1&"','"&anos1&"',"&v_plan_ccod&",'"&asig2&"',NULL,'"&estado1&"','"&plec1&"',"&horas1&",NULL,'9119940',getDate(),null)"
				  conexion.ejecutaS c_insert
				  grabados_automaticos = grabados_automaticos + 1
				end if
			end if
			'response.Write("<br><br>"&c_insert)
		end if
		
	  
	  wend  
  end if
  
  'response.Write(v_plan_ccod)
end if

f_encabezado.AgregaCampoParam "carreras_alumno","destino",consulta_carrera

'response.Write("v_plan_ccod "&v_plan_ccod)
'---------------------------------------------------------------------------------------------------
set f_notas = new CFormulario
f_notas.Carga_Parametros "conc_notas.xml", "notas_nuevo"

f_notas.Inicializar conexion

usuario_temp = negocio.obtenerUsuario
'response.Write(usuario_temp)
if usuario_temp <> "9119940" then
	sql_notas = conexion.ConsultaUno("select protic.obtener_sql_notas_nuevo('" & q_pers_nrut & "')")
else
	sql_notas = conexion.ConsultaUno("select protic.obtener_sql_notas_nuevo_2010('" & q_pers_nrut & "')")
end if
'response.Write("select protic.obtener_sql_notas('" & q_pers_nrut & "')")

consulta2 = " select tabla2.asig_ccod,tabla2.asig_tdesc,tabla3.carg_nnota_final,tabla2.peri_ccod,tabla3.anos_ccod,tabla3.plec_ccod,tabla3.sitf_ccod, " & vbCrLf &_
            " tabla3.sitf_baprueba,tabla3.nota_final,tabla3.horas, cast(tabla2.cantidad as varchar) +'ª  vez' as cantidad, " & vbCrLf &_
            " tabla2.asig_ccod as asig_ccod_guardar,tabla2.asig_tdesc as asig_tdesc_guardar,tabla3.carg_nnota_final as carg_nota_guardar,tabla2.peri_ccod as peri_guardar,tabla3.anos_ccod as anos_guardar,tabla3.plec_ccod as plec_guardar, " & vbCrLf &_
			" tabla3.sitf_ccod as sitf_guardar,tabla3.sitf_baprueba as sitf_baprueba_guardar,tabla3.nota_final as nota_final_guardar,tabla3.horas as horas_guardar, " & vbCrLf &_
			" cast(tabla2.cantidad as varchar) +'ª  vez' as cantidad_guardar," & vbCrLf &_
			" (select case count(*) when 0 then 0 else 1 end from concentracion_notas cn where ltrim(rtrim(cn.asig_ccod))=ltrim(rtrim(tabla2.asig_ccod)) and cast(cn.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and ltrim(rtrim(tabla3.anos_ccod)) = ltrim(rtrim(cn.anos_ccod)) and ltrim(rtrim(tabla3.sitf_ccod)) = ltrim(rtrim(cn.sitf_ccod)) " & vbCrLf &_
			"  and cast(cn.plan_ccod as varchar) = '"&plan_consulta&"' and isnull(cn.nota_final,0)=isnull(tabla3.nota_final,0) ) as esta_guardada " & vbCrLf &_
            " from " & vbCrLf &_
            "    ( " & vbCrLf &_
            "     select * from ( " & vbCrLf &_
            " 						select asig_ccod,asig_tdesc, " & vbCrLf &_
			"                       case sitf_baprueba when 'N' then (select top 1 rtrim(ltrim(cast(ca.carg_nnota_final as decimal(2,1)))) from alumnos alu, cargas_academicas ca, secciones se  " & vbCrLf &_
			"                                                         where alu.pers_ncorr= tabla1.pers_ncorr and alu.matr_ncorr = ca.matr_ncorr and ca.secc_ccod= se.secc_ccod " & vbCrLf &_
			"                                                         and se.asig_ccod= tabla1.asig_ccod) " & vbCrLf &_
			"             			else nota_final end as nota_final, " & vbCrLf &_
            " 			  			case sitf_baprueba when 'N' then (select top 1 se.peri_ccod from alumnos alu, cargas_academicas ca, secciones se  " & vbCrLf &_
			"                                                         where alu.pers_ncorr= tabla1.pers_ncorr and alu.matr_ncorr = ca.matr_ncorr and ca.secc_ccod= se.secc_ccod " & vbCrLf &_
            "                                                          and se.asig_ccod=tabla1.asig_ccod order by se.peri_ccod desc) " & vbCrLf &_
            "                       else peri_ccod end as peri_ccod, " & vbCrLf &_
			"                       case sitf_baprueba when 'N' then (select count(*) from alumnos alu, cargas_academicas ca, secciones se " & vbCrLf &_
			"                                                         where alu.pers_ncorr= tabla1.pers_ncorr and alu.matr_ncorr = ca.matr_ncorr and ca.secc_ccod= se.secc_ccod " & vbCrLf &_
			"                                                         and se.asig_ccod= tabla1.asig_ccod) " & vbCrLf &_
			"                       else 1 end as cantidad " & vbCrLf &_
            "						from  " & vbCrLf &_
			"                       ( " & vbCrLf &_
			"       	               select distinct a.pers_ncorr,a.asig_ccod, b.asig_tdesc, a.carg_nnota_final, c.peri_ccod, cast(c.anos_ccod as varchar) +' 0'+ cast(c.plec_ccod as varchar)  as anos_ccod,protic.initcap(g.duas_tdesc) as plec_ccod, isnull(a.sitf_ccod,'') as sitf_ccod, a.sitf_baprueba,  " & vbCrLf &_
			"                          rtrim(ltrim(cast(a.carg_nnota_final as decimal(2,1)))) as nota_final,cast(isnull(b.asig_nhoras,0) as numeric)as horas  " & vbCrLf &_
			"                          from ( " & vbCrLf &_
			"                                 " & sql_notas & vbCrLf &_
			"								) a join  asignaturas b  " & vbCrLf &_
        	" 							           on a.asig_ccod = b.asig_ccod " & vbCrLf &_
			"				                    join periodos_academicos c " & vbCrLf &_
			"				                       on a.peri_ccod = c.peri_ccod " & vbCrLf &_
			"					                join  duracion_asignatura g " & vbCrLf &_
			"				                       on b.duas_ccod = g.duas_ccod  " & vbCrLf &_
			" 						where  sitf_ccod <> '' and isnull(clas_ccod,1)= 2 " 
									if not esVacio(q_solo_aprobadas) and q_solo_aprobadas<> "N" then
										consulta2 = consulta2 & "  and isnull(cast(a.sitf_baprueba as varchar),'N') = case '" & q_solo_aprobadas & "' when 'S' then 'S' else 'N' end"
									end if
									if not esVacio(q_peri_ccod) then
										consulta2 = consulta2 & "  and cast(a.peri_ccod as varchar) = '" & q_peri_ccod & "'" 
									end if 
									'if not esVacio(carrera) then
									'	consulta2 = consulta2 & " and cast(a.plan_ccod as varchar)='"&carrera&"'"
									'end if 
consulta2 = consulta2 & ") as tabla1   ) as tabla_alfa " & vbCrLf &_
                    " UNION ALL " & vbCrLf &_  
					"  select * from ( " & vbCrLf &_ 
					"	              select asig_ccod,asig_tdesc,max(nota_final) as nota_final, " & vbCrLf &_ 
					"                 max(peri_ccod) as peri_ccod,count(*) as cantidad " & vbCrLf &_ 
					"                 from  " & vbCrLf &_ 
					"                 ( " & vbCrLf &_ 
					"  		            select distinct a.asig_ccod, b.asig_tdesc, a.carg_nnota_final, c.peri_ccod, cast(c.anos_ccod as varchar) +' 0'+ cast(c.plec_ccod as varchar)  as anos_ccod,protic.initcap(g.duas_tdesc) as plec_ccod, isnull(a.sitf_ccod,'') as sitf_ccod, a.sitf_baprueba, " & vbCrLf &_ 
					"                   rtrim(ltrim(cast(a.carg_nnota_final as decimal(2,1)))) as nota_final,cast(isnull(b.asig_nhoras,0) as numeric)as horas  " & vbCrLf &_ 
					"             		from ( " & sql_notas & vbCrLf &_ 
                    "		            ) a join  asignaturas b " & vbCrLf &_ 
					"        	                  on a.asig_ccod = b.asig_ccod " & vbCrLf &_ 
					"                       join periodos_academicos c " & vbCrLf &_ 
					"	                          on a.peri_ccod = c.peri_ccod  " & vbCrLf &_ 
				    "	                    join  duracion_asignatura g " & vbCrLf &_ 
					"      	                      on b.duas_ccod = g.duas_ccod " & vbCrLf &_ 
				    "                       where  sitf_ccod <> '' and isnull(clas_ccod,1)<> 2 "
										if not esVacio(q_solo_aprobadas) and q_solo_aprobadas<> "N" then
											consulta2 = consulta2 & "  and isnull(cast(a.sitf_baprueba as varchar),'N') = case '" & q_solo_aprobadas & "' when 'S' then 'S' else 'N' end"
										end if
										if not esVacio(q_peri_ccod) then
											consulta2 = consulta2 & "  and cast(a.peri_ccod as varchar) = '" & q_peri_ccod & "'" 
										end if 
										'if not esVacio(carrera) then
										'	consulta2 = consulta2 & " and cast(a.plan_ccod as varchar)='"&carrera&"'"
										'end if 
consulta2 = consulta2 &	") as tabla1 " & vbCrLf &_
					" group by asig_ccod,asig_tdesc ) as tabla_beta ) as tabla2 , " & vbCrLf &_
				    " (select distinct a.asig_ccod, b.asig_tdesc, a.carg_nnota_final, c.peri_ccod, cast(c.anos_ccod as varchar) +' 0'+ cast(c.plec_ccod as varchar)  as anos_ccod,protic.initcap(g.duas_tdesc) as plec_ccod, isnull(a.sitf_ccod,'') as sitf_ccod, a.sitf_baprueba, " & vbCrLf &_
					"       rtrim(ltrim(cast(a.carg_nnota_final as decimal(2,1)))) as nota_final,cast(isnull(b.asig_nhoras,0) as numeric)as horas " & vbCrLf &_
					" from ( " & vbCrLf &_
					sql_notas & vbCrLf &_
					"	) a join  asignaturas b " & vbCrLf &_
					"        	on a.asig_ccod = b.asig_ccod " & vbCrLf &_
					"       join periodos_academicos c " & vbCrLf &_
					"            on a.peri_ccod = c.peri_ccod " & vbCrLf &_
					"       join  duracion_asignatura g " & vbCrLf &_
					" 	        on b.duas_ccod = g.duas_ccod " & vbCrLf &_
					" where  sitf_ccod <> '' " 
					if not esVacio(q_solo_aprobadas) and q_solo_aprobadas<> "N" then
						consulta2 = consulta2 & "  and isnull(cast(a.sitf_baprueba as varchar),'N') = case '" & q_solo_aprobadas & "' when 'S' then 'S' else 'N' end"
					end if
					if not esVacio(q_peri_ccod) then
						consulta2 = consulta2 & "  and cast(a.peri_ccod as varchar) = '" & q_peri_ccod & "'" 
					end if 
					'if not esVacio(carrera) then
					'	consulta2 = consulta2 & " and cast(a.plan_ccod as varchar)='"&carrera&"'"
					'end if 
consulta2 = consulta2 & " ) as tabla3 " & vbCrLf &_
                        "     where tabla2.asig_ccod = tabla3.asig_ccod " & vbCrLf &_
					    "     and tabla2.asig_tdesc = tabla3.asig_tdesc " & vbCrLf &_
				        "     and tabla2.peri_ccod = tabla3.peri_ccod " & vbCrLf &_
				        "     --and isnull(tabla2.nota_final,1) = isnull(tabla3.nota_final,1) " & vbCrLf &_
                        "order by tabla2.asig_tdesc asc,tabla2.peri_ccod asc"

'response.Write("<pre>"&consulta2&"</pre>")
'response.End()
'comentario "172.16.100.111", consulta2, 1
ip_usuario = Request.ServerVariables("REMOTE_ADDR")
'response.Write("ip_usuario = "&ip_usuario&"</br>") 
ip_de_prueba = "172.16.100.128"
'----------------------------------

if ip_usuario = ip_de_prueba then
'response.Write("<pre>"&consulta2&"</pre>")
end if


if q_pers_nrut = "" then
	consulta2 = "select 0 as horas  where 1=2"
end if	
f_notas.Consultar consulta2
'----------------------------Calculamos el promedio de las notas-----------------
'-----------------------------------------14-02-2005-----------------------------------
valor_promedio=0.0
cantidad_notas=0
total_horas=0
f_notas.primero
total_registros = f_notas.nroFilas
'response.Write(total_registros)
'response.End()
while f_notas.siguiente 
	if not esVacio(f_notas.obtenerValor("nota_final") ) then
		valor_promedio= valor_promedio + conexion.consultaUno("Select replace('"&f_notas.obtenerValor("nota_final")&"','.',',')")
		cantidad_notas=cantidad_notas + 1
	end if
	total_horas = total_horas + cint(f_notas.obtenerValor("horas"))
wend 
if cantidad_notas<>0 then
    valor_promedio=valor_promedio/cantidad_notas
	valor_promedio=conexion.consultaUno("Select replace(cast(replace('"&valor_promedio&"',',','.') as decimal(3,2)),',','.')") 
end if
'
f_notas.primero
'--------------------------------------------------------------------------------------------------
'-------------------------------------------------------------------------------------------------- 
set f_param_impresion = new CFormulario
f_param_impresion.Carga_Parametros "conc_notas.xml", "param_impresion"
f_param_impresion.Inicializar conexion
f_param_impresion.Consultar "select ''"   
   
   
'response.Write("peri_ccod "&q_solo_aprobadas)
if esVacio(q_solo_aprobadas) or q_solo_aprobadas="N" then
q_solo_aprobadas=""
end if 
'------------------------------------------------------------------------------------------------ 
if esVacio(q_peri_ccod) then
	q_peri_ccod2=1
else
	q_peri_ccod = q_peri_ccod
	q_peri_ccod2 = cint(q_peri_ccod)
end if	

f_param_impresion.AgregaCampoCons "pers_nrut", q_pers_nrut
f_param_impresion.AgregaCampoCons "pers_xdv", q_pers_xdv
f_param_impresion.AgregaCampoCons "peri_ccod", q_peri_ccod2
f_param_impresion.AgregaCampoCons "solo_aprobadas", q_solo_aprobadas
f_param_impresion.AgregaCampoCons "plan_ccod", plan_consulta
f_param_impresion.AgregaCampoCons "sede_ccod", negocio.ObtenerSede
f_param_impresion.AgregaCampoCons "carrera", carrera
f_param_impresion.AgregaCampoCons "tiene_salida_intermedia" , tiene_salida_intermedia
f_param_impresion.AgregaCampoCons "tiene_minors" , tiene_minors

'response.Write(plan_consulta & "  " & tiene_salida_intermedia)

f_botonera.AgregaBotonUrlParam "excel", "pers_nrut", q_pers_nrut
f_botonera.AgregaBotonUrlParam "excel", "pers_xdv", q_pers_xdv
f_botonera.AgregaBotonUrlParam "excel", "peri_ccod", q_peri_ccod
f_botonera.AgregaBotonUrlParam "excel", "solo_aprobadas", q_solo_aprobadas
f_botonera.AgregaBotonUrlParam "excel", "carrera", carrera

cantidad_notas = f_notas.nroFilas
'response.Write(cantidad_notas)

notas_guardadas = conexion.consultaUno("select count(*) from concentracion_notas where cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and cast(plan_ccod as varchar)='"&plan_consulta&"'")
mostrar_titulados = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end  from detalles_titulacion_carrera where cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and cast(plan_ccod as varchar)='"&v_plan_ccod&"' and mostrar_concentracion='S'")
'response.Write("select case count(*) when 0 then 'N' else 'S' end  from detalles_titulacion where cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and cast(plan_ccod as varchar)='"&v_plan_ccod&"' and mostrar_concentracion='S'")

carrera_buscar = conexion.consultaUno("Select carr_ccod from planes_estudio aa, especialidades ee where aa.espe_ccod = ee.espe_ccod and cast(aa.plan_ccod as varchar)='"&v_plan_ccod&"'")
alumno_titulado = conexion.consultaUno("select count(*) from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and a.emat_ccod in (8) and c.carr_ccod ='"&carrera_buscar&"'")
alumno_egresado = conexion.consultaUno("select count(*) from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and a.emat_ccod in (4) and c.carr_ccod ='"&carrera_buscar&"'")
alumno_si       = conexion.consultaUno("select count(*) from alumnos_salidas_intermedias where cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and cast(saca_ncorr as varchar)='"&plan_consulta&"' and emat_ccod in (4,8) ")
'response.Write("select case count(*) when 0 then 'N' else 'S' end  from detalles_titulacion where cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and cast(plan_ccod as varchar)='"&v_plan_ccod&"' and mostrar_concentracion='S'")
'response.Write(alumno_egresado)
'-----------------------------hacer actualización de datos en concentración de notas para el caso que se modificaron notas históricas.
if cint(notas_guardadas) >  0 and alumno_titulado = "0" and alumno_egresado= "0" and alumno_si="0" then 'and alumno_titulado = "0" then 
	consulta_cambios = " select sum(encontrados) from ( "& vbCrLf &_
	                   " select count(*)  as encontrados "& vbCrLf &_
					   " from cargas_academicas a, secciones b, asignaturas c "& vbCrLf &_
					   " where a.secc_ccod=b.secc_ccod and b.asig_ccod=c.asig_ccod "& vbCrLf &_
					   " and a.matr_ncorr in (select matr_ncorr from alumnos where cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"') "& vbCrLf &_
					   " and isnull(a.carg_nnota_final,8.0) <> 8.0 and isnull(sitf_ccod,'N') <> 'N' "& vbCrLf &_
					   " and exists (select 1 from concentracion_notas cn where cast(cn.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and cn.audi_fmodificacion < a.audi_fmodificacion) "& vbCrLf &_
					   " union "& vbCrLf &_
					   " select count(*)  as encontrados "& vbCrLf &_
					   " from concentracion_notas a where cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"' "& vbCrLf &_
					   " and not exists (select 1 from alumnos aa, cargas_academicas bb, secciones cc, periodos_academicos dd "& vbCrLf &_
					   "				 where aa.pers_ncorr=a.pers_ncorr and aa.matr_ncorr=bb.matr_ncorr and bb.secc_ccod=cc.secc_ccod "& vbCrLf &_
					   "				 and cc.peri_ccod=dd.peri_ccod and cc.asig_ccod=a.asig_ccod  "& vbCrLf &_
					   "				 and a.anos_ccod = cast(dd.anos_ccod as varchar) + ' 0' + cast(dd.plec_ccod as varchar) ) "& vbCrLf &_
					   ")tt "
					   
cantidad_cambiados = conexion.consultaUno(consulta_cambios)
'response.Write("<pre>"&consulta_cambios&"</pre>")
'response.End()
'cantidad_cambiados = 0
	if cint(cantidad_cambiados ) > 0 then
	   '-------------------------en este caso debemos borrar todo lo existente en la concentracion_notas alumno y resubirlo con info actualizada.
     'response.Write("a grabar")     	
	 	if not esVacio(pers_ncorr_temporal) then
			consulta_delete1 = " delete from concentracion_notas where cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and cast(plan_ccod as varchar)='"&plan_consulta&"'"
			'response.Write("<br>"&consulta_delete1)
			conexion.ejecutaS consulta_delete1
		end if
		
		f_notas.primero
		while f_notas.siguiente 
		'response.Write( f_notas.obtenerValor("esta_guardada"))
			if f_notas.obtenerValor("esta_guardada")="1" then
				asig_ccod=f_notas.obtenerValor("asig_ccod_guardar")
				asig_tdesc=f_notas.obtenerValor("asig_tdesc_guardar")
				nota_final=f_notas.obtenerValor("nota_final_guardar")
				sitf_ccod=f_notas.obtenerValor("sitf_guardar")
				anos_ccod=f_notas.obtenerValor("anos_guardar")
				plec_ccod=f_notas.obtenerValor("plec_guardar")
				horas=f_notas.obtenerValor("horas_guardar")
				cantidad=f_notas.obtenerValor("cantidad_guardar")
				esta_guardada=f_notas.obtenerValor("esta_guardada")
			
			
				if not EsVacio(asig_ccod) and not EsVacio(pers_ncorr_temporal) and esta_guardada = "1" then
					esta= conexion.consultaUno("select count(*) from concentracion_notas where cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and asig_ccod='"&asig_ccod&"' and cast(anos_ccod as varchar)='"&anos_ccod&"' and cast(plan_ccod as varchar)='"&plan_consulta&"'")
					if esta = "0" then
							if not isnull(nota_final) and nota_final <> "" then
							   consulta_insert = "insert into concentracion_notas (pers_ncorr,asig_ccod,asig_tdesc,nota_final,sitf_ccod,anos_ccod,plec_ccod,horas,cantidad,audi_tusuario,audi_fmodificacion,plan_ccod) "&_
												 " values ("&pers_ncorr_temporal&",'"&asig_ccod&"','"&asig_tdesc&"',"&nota_final&",'"&sitf_ccod&"','"&anos_ccod&"','"&plec_ccod&"',"&horas&_
												 ",'"&cantidad&"','"&negocio.obtenerUsuario()&"',getDate(),"&plan_consulta&")"
							else				  
							   consulta_insert = "insert into concentracion_notas (pers_ncorr,asig_ccod,asig_tdesc,nota_final,sitf_ccod,anos_ccod,plec_ccod,horas,cantidad,audi_tusuario,audi_fmodificacion,plan_ccod) "&_
												 " values ("&pers_ncorr_temporal&",'"&asig_ccod&"','"&asig_tdesc&"',null,'"&sitf_ccod&"','"&anos_ccod&"','"&plec_ccod&"',"&horas&_
												 ",'"&cantidad&"','"&negocio.obtenerUsuario()&"',getDate(),"&plan_consulta&")"
							end if					 
							conexion.ejecutaS consulta_insert
					end if		
				end if 
		   end if '--------------fin del if para considerar solo las guardadas
	   wend'------------------fin del while que recorre el listado de notas	   
	   f_notas.primero
	   mensaje_actualizados = "<font size='2' color='#FFFFFF'>Se ha detectado que el alumno presenta notas modificadas con fecha posterior al grabado de la información de la concentración, por lo cual EL SISTEMA ha hecho un nuevo grabado de la información de forma AUTOMÁTICA.</font>" 
	end if
end if
'response.Write(mensaje_actualizados)

'--------------------------------usuario----------------------------------------------------
usuario_temp = negocio.obtenerUsuario

c_no_bloqueado = "select case count(*) when 0 then 'N' else 'S' end from personas a, sis_roles_usuarios b where cast(a.pers_nrut as varchar)='"&usuario_temp&"' and a.pers_ncorr=b.pers_ncorr and b.srol_ncorr=95"
no_bloqueado = conexion.consultaUno(c_no_bloqueado)

c_es_titulado = "select case count(*) when 0 then 'N' else 'S' end  from alumnos where cast(pers_ncorr as varchar) = '"&pers_ncorr_temporal&"' and emat_ccod=8"
es_titulado = conexion.consultaUno(c_es_titulado)
if es_titulado="S" then
	if no_bloqueado="S" then
			habilitar = "S"
	else
			habilitar ="N"
	end if 
else
	habilitar="S"
end if	
'-------------------------------------------------------------------------------------------

if q_pers_nrut = "15382657" then
	habilitar="S"
end if

'-----------------------eliminamos botón de impresión de cert. de alumno regular para titulados.-------
'-------------------------solicitud VMendoza 22-11-2007-----------------------------------------------
periodo_prueba = negocio.obtenerPeriodoAcademico("POSTULACION")
'response.Write(periodo_prueba)
'response.Write(pers_ncorr_temporal)
ano_prueba = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo_prueba&"'")
carr_ccod = conexion.consultaUno("select carr_ccod from planes_estudio a, especialidades b where cast(a.plan_ccod as varchar)='"&v_plan_ccod&"' and a.espe_ccod=b.espe_ccod")
'response.Write("select case count(*) when 0 then 'N' else 'S' end from alumnos a, ofertas_academicas b,especialidades c where a.ofer_ncorr=b.ofer_ncorr and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"'  and  b.espe_ccod=c.espe_ccod and c.carr_ccod ='"&carr_ccod&"' and a.emat_ccod in(8)")
titulado = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from alumnos a, ofertas_academicas b,especialidades c where a.ofer_ncorr=b.ofer_ncorr and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"'  and  b.espe_ccod=c.espe_ccod and c.carr_ccod ='"&carr_ccod&"' and a.emat_ccod in(8)")
'response.Write(titulado)

'response.Write("  muestra titulados      "&mostrar_titulados)
'-----------------------------------------------------------------------------------------------------
'response.Write("select case count(*) when 0 then 'N' else 'S' end from alumnos a, ofertas_academicas b,especialidades c where a.ofer_ncorr=b.ofer_ncorr and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"'  and  b.espe_ccod=c.espe_ccod and c.carr_ccod ='"&carr_ccod&"' and a.emat_ccod in(8)")
'response.Write(carrera)

if pers_ncorr_temporal <> "" then
	c_ultima_matricula = " select top 1 matr_ncorr from alumnos a, ofertas_academicas b "&_
	                     " where a.ofer_ncorr=b.ofer_ncorr and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' order by peri_ccod desc, alum_fmatricula desc "
    ultima_matricula = conexion.consultaUno(c_ultima_matricula)
	c_mensaje = " select 'El(la) alumno(a) presenta su ultima matrícula en el ' + protic.initCap(peri_tdesc) + "&_
	            " ' para el ' + protic.initCap(plan_tdesc) + ' de la especialidad ' + protic.initCap(espe_tdesc)  "&_
				" from alumnos a, ofertas_academicas b, planes_estudio c, periodos_academicos d, especialidades e "&_
				" where a.ofer_ncorr=b.ofer_ncorr and a.plan_ccod=c.plan_ccod and b.espe_ccod=e.espe_ccod "&_
				" and b.peri_ccod=d.peri_ccod and cast(a.matr_ncorr as varchar)='"&ultima_matricula&"'"
    'response.Write(c_mensaje)
	mensaje_plan = conexion.consultaUno(c_mensaje)
end if

resolucion = conexion.consultaUno("select plan_nresolucion from alumnos a,planes_estudio b where a.plan_ccod=b.plan_ccod and cast(matr_ncorr as varchar)='"&ultima_matricula&"'")

plan_seleccionado = plan_consulta
tiene_plan_titulado = conexion.consultaUno("select count(*) from alumnos_salidas_carrera a, salidas_carrera b where a.saca_ncorr=b.saca_ncorr and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"'")
plan_titulado = conexion.consultaUno("select count(*) from alumnos_salidas_carrera a, salidas_carrera b where a.saca_ncorr=b.saca_ncorr and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and cast(b.plan_ccod as varchar)='"&plan_seleccionado&"'")
mensaje_plan_titulado = ""
if cdbl(tiene_plan_titulado) > 0 and titulado="S" then
	if plan_titulado = "0" then
		mensaje_plan_titulado = "<font color='#990000' size='2'><strong>El alumno presenta registro de titulación en otro plan de estudios, seleccione el indicado</strong></font>"
	else
		mensaje_plan_titulado = "<font color='#0033FF' size='2'><strong>El alumno presenta registro de titulación en este plan</strong></font>"
	end if
end if


tiene_foto  = conexion.consultaUno("Select case count(*) when 0 then 'N' else 'S' end from rut_fotos_2010 where cast(rut as varchar)='"&q_pers_nrut&"'")
tiene_foto2 = conexion.consultaUno("Select case count(*) when 0 then 'N' else 'S' end from fotos_alumnos where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")

if tiene_foto="S" then 
 	nombre_foto = conexion.consultaUno("Select ltrim(rtrim(imagen)) from rut_fotos_2010 where cast(rut as varchar)='"&q_pers_nrut&"'")
elseif tiene_foto="N" and tiene_foto2="S" then 
  	nombre_foto = conexion.consultaUno("Select ltrim(rtrim(foto_truta)) from fotos_alumnos where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")	
else
    nombre_foto = "user.png"
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

var t_parametros;

function incluir_promedio_click(p_objeto)
{	
	t_parametros.filas[0].campos["promedio"].objeto.disabled = !p_objeto.checked;
	asignar_valor();
}
function asignar_valor()
{ var formulario=document.edicion;
  var promedio='<%=valor_promedio%>';
  //alert("promedio "+promedio);
  if (formulario.elements["p[0][incluir_promedio]"].value=='S')
	{
		formulario.elements["p[0][promedio]"].value=promedio;
	}
  else
  	{
		formulario.elements["p[0][incluir_promedio]"].value="";
	}		
}


function Inicio()
{
	t_parametros = new CTabla("p")
}

function dibujar2(formulario){
    //formulario.elements["b[0][pers_nrut]"].focus();
	alert("...");
	document.edicion.target="_self";
	document.edicion.action="conc_notas.asp";
	document.edicion.method="Get";
	//document.edicion.submit();
}
function recargar(valor,texto){
    //formulario.elements["b[0][pers_nrut]"].focus();
	var pers_nrut='<%=q_pers_nrut%>';
	var pers_xdv='<%=q_pers_xdv%>';
	var periodo='<%=q_peri_ccod%>';
	var solo_aprobadas='<%=q_solo_aprobadas%>';
	var url = "conc_notas.asp?b[0][pers_nrut]="+pers_nrut+"&b[0][pers_xdv]="+pers_xdv+"&b[0][peri_ccod]="+periodo+"&b[0][solo_aprobadas]="+solo_aprobadas+"&enca[0][carreras_alumno]="+valor;
    location.href = url;
	//alert(texto);

}

function certificado_1(){
   var formulario=document.edicion
   var valor=edicion.elements["p[0][tdes_ccod]"].value;
   var comentario=edicion.elements["comentario"].value;
   self.open('certificado_1.asp?carr_ccod=<%=codigo_carrera%>&pers_nrut=<%=q_pers_nrut%>&tdes_ccod='+ valor+'&comentario='+comentario,'certificado','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

function guarda_notas(){
    var formulario=document.edicion
   var valor=edicion.elements["p[0][tdes_ccod]"].value;
   if (valor != "")
   		{   
			window.open('guarda_certificado.asp?carr_ccod=<%=codigo_carrera%>&tipo=1&pers_nrut=<%=q_pers_nrut%>&tdes_ccod='+ valor,'guardar','width=700px, height=550px, scrollbars=yes, resizable=yes')
		}
   else
   	  { 
	      alert("Antes de guardar debe indicar el motivo por el que se extendió el certificado");
	      edicion.elements["p[0][tdes_ccod]"].focus();		
	  }	}

function guarda_alumno(){
   var formulario=document.edicion
   var valor=edicion.elements["p[0][tdes_ccod]"].value;
   var comentario=edicion.elements["comentario"].value;
   if (valor != "")
   		{   
			window.open('guarda_certificado.asp?carr_ccod=<%=codigo_carrera%>&tipo=2&pers_nrut=<%=q_pers_nrut%>&tdes_ccod='+ valor+'&comentario='+comentario,'guardar','width=700px, height=550px, scrollbars=yes, resizable=yes')
		}
   else
   	  { 
	      alert("Antes de guardar debe indicar el motivo por el que se extendió el certificado");
	      edicion.elements["p[0][tdes_ccod]"].focus();		
	  }	
}

function ValidaFormBusqueda(formulario)
{
	if (!valida_rut(formulario.elements["b[0][pers_nrut]"].value + "-" + formulario.elements["b[0][pers_xdv]"].value)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["b[0][pers_nrut]"].focus();
		formulario.elements["b[0][pers_nrut]"].select();
		return false;
	}
	
	return true;
}

function agregar_asig (formulario)
{ var carrera_javascript= document.edicion.elements["enca[0][carreras_alumno]"].options[document.edicion.elements["enca[0][carreras_alumno]"].selectedIndex].text;
	if (verifica_check(formulario))
	{   //alert(carrera_javascript);
	    if(carrera_javascript == "Todas")
		{
			if(confirm("Se grabaran las asignaturas SIN ser asociadas a un plan de estudios.\n ¿Está seguro que desea continuar?"))	
			{ formulario.method="post"
			  formulario.action="guardar_listado_concentracion.asp";
			  formulario.submit();
			}
		}
		else
		{
			if(confirm("¿Está seguro que desea agregar la asignaturas seleccionadas para la carrera "+ carrera_javascript+"?"))	
			{ formulario.method="post"
			  formulario.action="guardar_listado_concentracion.asp";
			  formulario.submit();
			}  
		}
	}
	else{
		alert('No ha seleccionado ninguna asignatura para agregar al listado de concentración de notas.');
	}
}

function verifica_check(formulario) {
	num=formulario.elements.length;
	c=0;
	for (i=0;i<num;i++){
		nombre = formulario.elements[i].name;
		var elem = new RegExp ("esta_guardada","gi");
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

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); Inicio();" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA"><br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="10%"><div align="left"><strong>RUT</strong></div></td>
				  <td width="2%"><div align="center"><strong>:</strong></div></td>
				  <td width="30%"><div align="left"><%f_busqueda.dibujaCampo("pers_nrut")%>-<%f_busqueda.dibujaCampo("pers_xdv")%> <%pagina.DibujarBuscaPersonas "b[0][pers_nrut]", "b[0][pers_xdv]"%></div></td>
				  <td width="10%"><div align="left"><strong>S&oacute;lo aprobadas</strong></div></td>
				  <td width="2%"><div align="center"><strong>:</strong></div></td>
				  <td width="30%"><div align="left"><%f_busqueda.dibujaCampo("solo_aprobadas")%></div></td>
				</tr> 
				<tr>
                  <td width="10%"><div align="left"><strong>Semestre</strong></div></td>
				  <td width="2%"><div align="center"><strong>:</strong></div></td>
				  <td width="30%"><div align="left"><%f_busqueda.dibujaCampo("peri_ccod")%></div></td>
				  <td width="10%">&nbsp;</td>
				  <td width="2%">&nbsp;</td>  
                  <td width="30%"><div align="center"><%f_botonera.DibujaBoton "buscar"%></div></td>
                </tr>
              </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
			<form name="edicion" >
			 <div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
              <br>
			   <%if not esVacio(q_pers_nrut) then%>
			   <table width="100%" cellpadding="0" cellspacing="0">
			   <tr valign="top">
				  <td width="80%" align="left">
					   <table width="98%"  border="0">
						<tr>
						  <td width="77" align="left"><strong>RUT</strong></td>
						  <td width="11"  align="center"><strong>:</strong></td>
						  <td align="left" colspan="4"><%f_encabezado.DibujaCampo("rut")%><input type="hidden" name="pers_ncorr" value="<%=pers_ncorr_temporal%>"></td>
						</tr>
						<tr>
						  <td width="77" align="left"><strong>Nombre</strong></td>
						  <td width="11"  align="center"><strong>:</strong></td>
						  <td  align="left" colspan="4"><%f_encabezado.DibujaCampo("nombre")%></td>
						</tr>
						<tr>
						  <td width="77" align="left"><strong>Carrera</strong></td>
						  <td width="11"  align="center"><strong>:</strong></td>
						  <td  align="left" colspan="4"><%f_encabezado.DibujaCampo("carrera")%><%f_encabezado.DibujaCampo("carreras_alumno")%></td>
						</tr>
						<tr>
						  <td width="77" align="left"><strong>Tipo Alumno</strong></td>
						  <td width="11"  align="center"><strong>:</strong></td>
						  <td  align="left" colspan="4"><%f_encabezado.DibujaCampo("tipo_alumnoUpa")%></td>
						</tr>
						<tr>
						  <td width="77" align="left"><strong>Duraci&oacute;n</strong></td>
						  <td width="11"  align="center"><strong>:</strong></td>
						  <td align="left" colspan="4"><%f_encabezado.DibujaCampo("duas_tdesc")%></td>
						</tr>
						<tr>
						  <td width="77" align="left"><strong>Año Ingreso al Plan de Estudios</strong></td>
						  <td width="11"  align="center"><strong>:</strong></td>
						  <td  align="left" colspan="4"><%f_encabezado.DibujaCampo("ano_ingreso_plan")%></td>
						</tr>
						<%if mensaje_plan <> "" then%>
						<tr><td colspan="6" align="center" bgcolor="#660000">
							<font color="#FFFFFF"><%=mensaje_plan%></font>
						</td></tr>
						<%end if%>
						<tr>
						  <td width="77" align="left"><strong>Resolución</strong></td>
						  <td width="11"  align="center"><strong>:</strong></td>
						  <td  align="left" colspan="4"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#990000"><%=resolucion%></font></td>
						</tr>
						<tr><td colspan="6"><hr></td></tr>
						<%if moroso = "Sí" then%>
						<tr>
						  <td width="77" align="left"> <font color="#FF0033"><strong>Está Moroso?</strong></font></td>
						  <td width="11"  align="center"><font color="#FF0033"><strong>:</strong></font></td>
						  <td align="left" colspan="4"><font color="#FF0033"><strong><%=moroso%></strong></font></td>
						</tr>
						<tr>
						  <td width="77" align="left"><strong>Monto Deuda</strong></td>
						  <td width="11"  align="center"><strong>:$</strong></td>
						  <td  align="left" colspan="4"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#FF0033"><%=monto_deuda%></font></td>
						</tr>
						<%else%>
						<tr>
						  <td width="77" align="left"><strong>Está Moroso?</strong></td>
						  <td width="11"  align="center"><strong>:</strong></td>
						  <td  align="left" colspan="4"><strong><%=moroso%></strong></td>
						</tr>
						<%end if%>
						<%if mensaje_actualizados <> "" then%>
							<tr><td colspan="6">&nbsp;</td></tr>
							<tr><td colspan="6" align="center"><table width="80%"><tr><td align="center" bgcolor="#0033FF"><%=mensaje_actualizados%></td></tr></table></td></tr>
						<%end if%>
						<tr><td colspan="6"><hr></td></tr>
						<%if cadena_sin_homologar <> "" then %>
						<tr><td colspan="6">&nbsp;</td></tr>
						<tr>
						    <td colspan="6" align="center">
						      <table width="70%" cellpadding="0" cellspacing="0" bgcolor="#669900">
							  		<tr>
										<td width="100%" align="left">
										  <font color="#FFFFFF" face="Times New Roman, Times, serif" size="2">
										        ATENCIÓN
												<BR>		
												LAS SIGUIENTES HOMOLOGACIONES NO HAN PODIDO INGRESARSE AUTOMATICAMENTE:
												<br>
												<%=cadena_sin_homologar%>
										  </font>
										</td>
									</tr>
							  </table>
						 	</td>
						</tr>
						<tr><td colspan="6">&nbsp;</td></tr>
						<%end if%>
					  </table>
					</td>
					<td width="20%" align="center">
					    <img width="90" height="98" src="../informacion_alumno_2008b/imagenes/alumnos/<%=nombre_foto%>" border="2">
					</td>
				</tr>
			  </table>
			  <%end if%>
			  </div>
              
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Notas"%>
                      <table width="98%"  border="0" align="center">
                        <tr><td colspan="2" align="center"><%=mensaje_plan_titulado%></td></tr>
						<tr>
                          <td scope="col" colspan="2"><div align="center"><%f_notas.DibujaTabla%></div></td>
                        </tr>
						<tr>
                          <td scope="col" colspan="2"><div align="left"><strong>Total horas asignaturas : </strong><%=total_horas%> hrs</div></td>
                        </tr>
						<tr>
                          <td scope="col" colspan="2">&nbsp;</td>
                        </tr>
						<tr>
                          <td scope="col" colspan="2">
							  <div align="center">
							  		<table border="1" width="80%">
										<tr>
											<td width="100%" align="center"><strong>Seleccione las asignaturas que desea mostrar en la concentración y presione el botón.</strong></td>
    									</tr>
										<tr>
											<td width="100%" align="center" bgcolor="#FFFFFF"><font color="#0033FF"><% 
											                                   if alumno_titulado = "0" and alumno_egresado = "0" or grabados_automaticos > 0 then 'and alumno_si="0" then
											                                      f_botonera.DibujaBoton "guardar_listado"
																			   else
																			   	c_mensaje=" select top 1 'Los certificados de notas de alumnos en proceso de egreso-titulación una vez generados no pueden ser modificados.<br>'"&_
																						  "			+'El certificado fue ingresado por :'+b.pers_tnombre + ' ' + b.pers_tape_paterno + ' El día '+protic.trunc(a.audi_fmodificacion)+'.' as mensaje "&_
																						  "	 from concentracion_notas a, personas b "&_
																						  "	 where cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and cast(plan_ccod as varchar)='"&plan_consulta&"'"&_
																						  "	 and a.audi_tusuario = cast(b.pers_nrut as varchar)"&_
																						  "	 order by a.audi_fmodificacion desc"
																				mensaje_titulado = conexion.consultaUno(c_mensaje)
																				response.Write(mensaje_titulado) 
																			   end if%></font></td>
										</tr>
									</table>
							  </div></td>
                        </tr>
                        <tr>
                          <td scope="col" width="80%"><br>
                            <%f_param_impresion.DibujaRegistro%></td>
							<td scope="col" width="20%">
								<table width="100%">
									<tr> <td>
									     <%  if q_pers_nrut = "" or cantidad_notas = "0" then
										      f_botonera.agregaBotonParam "guardar_notas","deshabilitado","true"
										     end if
										     f_botonera.DibujaBoton "guardar_notas"%>
										 </td>
								    </tr>
									<tr> <td>
									     <%  if q_pers_nrut = "" or habilitar="N" then
										      f_botonera.agregaBotonParam "guardar_alumno","deshabilitado","true"
										     end if
										     f_botonera.DibujaBoton "guardar_alumno"%>
										 </td>
								    </tr>
								</table>
							</td>
						</tr>
						<tr>
                          <td colspan="2" align="center">
							  <table width="98%" border="1">
							  	<tr>
							  		<td width="30%"><strong>Comentarios Certificado</strong></td>
									<td width="70%"><textarea cols="80" rows="3" name="comentario"></textarea></td>
							  	</tr>
							  </table>
						  </td>
						</tr>
						 <%  if q_pers_nrut <> "" and cantidad_notas = "0" then%>
						<tr>
                          <td scope="col" colspan="2"><div align="left">&nbsp;</div></td>
                        </tr>
						<tr>
                          <td scope="col" colspan="2"><div align="center"><font size="3"  face="Times New Roman, Times, serif"><strong>El alumno no presenta Notas para la carrera solicitada</strong></font></div></td>
                        </tr>
						<tr>
                          <td scope="col" colspan="2"><div align="left">&nbsp;</div></td>
                        </tr>
						<%end if
						if q_pers_nrut <> "" then %>
						<tr>
                          <td scope="col" colspan="2" align="center">
						  	<table width="98%" border="1">
							<tr>
								<td colspan="3" align="left"><strong>Certificados:</strong></td>
							</tr>
							<tr>
								<td width="30" align="center"><div align="center">
								                                       <%'if moroso = "Sí" or notas_guardadas = "0"   then se quita la condición de morosidad
																	     if notas_guardadas = "0"   then 
																			'response.Write("es_moroso "&moroso&" cantidad_notas "&cantidad_notas&" notas_guardadas "&notas_guardadas)
																			f_botonera.agregaBotonParam "imprimir","deshabilitado","TRUE"
																			f_botonera.DibujaBoton "imprimir"
																		else%>
																		<table width="100%" cellpadding="0" cellspacing="0">
																		 	<tr>
																				<td width="80%" align="center"><%f_botonera.DibujaBoton "imprimir"%></td>
																				<td width="20%" align="center">&nbsp;</td>
																			</tr>
																		 </table>
																		<%end if%>
																		 </div></td>
								<%if mostrar_titulados="S" then%>										 
								<td width="40" align="center">          <%'if moroso = "Sí" or cantidad_notas = "0" or notas_guardadas = "0" then se quita concepto de morosidad
								                                          if cantidad_notas = "0" or notas_guardadas = "0" then
																			'response.Write("es_moroso "&moroso&" cantidad_notas "&cantidad_notas&" notas_guardadas "&notas_guardadas)
																			f_botonera.agregaBotonParam "imprimir_titulado","deshabilitado","TRUE"
																			f_botonera.DibujaBoton "imprimir_titulado"
																		  else%>
																		 <table width="100%" cellpadding="0" cellspacing="0">
																		 	<tr>
																				<td width="80%" align="center"><%f_botonera.DibujaBoton "imprimir_titulado"%></td>
																				<td width="20%" align="center">&nbsp;</td>
																			</tr>
																		 </table>
																		 <%end if%>
																		 </td>	
								<%end if%>										 	
								<td width="30" align="center"><%         if titulado= "S" then 'moroso = "Sí" or 
																			f_botonera.agregaBotonParam "certificado_1","deshabilitado","FALSE"
																		 end if
																		 'f_botonera.agregaBotonParam "certificado_1","deshabilitado","FALSE"
																		f_botonera.DibujaBoton "certificado_1"%></td>										 								 
							</tr>
							</table>
						  </td>
                        </tr>
						<%end if%>
                      </table></td>
                  </tr>
                </table>
              <br>
			  <input type="hidden" name="tiene_salida_intermedia" value="<%=tiene_salida_intermedia%>">
			  <input type="hidden" name="b[0][pers_nrut]" value="<%=q_pers_nrut%>"> 
              <input name="b[0][pers_xdv]" type="hidden" value="<%=q_pers_xdv%>">
			  <input name="b[0][peri_ccod]" type="hidden" value="<%=q_peri_ccod%>">
			  <input name="b[0][solo_aprobadas]" type="hidden" value="<%=q_solo_aprobadas%>">
			  <input name="saca_ncorr" type="hidden" value="<%=saca_ncorr_envio%>">
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="26%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">&nbsp;</div></td>
				  <td><div align="center"><%f_botonera.DibujaBoton "excel"%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton "salir"%>
                  </div></td>
				  <td><div align="center">&nbsp;</div></td>
                </tr>
              </table>
            </div></td>
            <td width="74%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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

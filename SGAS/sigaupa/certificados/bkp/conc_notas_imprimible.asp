<%@language=vbscript%>
<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%

'for each k in request.form
'	response.Write(k&" = "&request.form(k)&"<br>")
'next

pers_nrut = request.Form("p[0][pers_nrut]")
peri_ccod = request.Form("p[0][peri_ccod]")
solo_aprobadas = request.Form("p[0][solo_aprobadas]")
plan_ccod = request.Form("p[0][plan_ccod]")
sede_ccod = request.Form("p[0][sede_ccod]")
carrera = request.Form("p[0][carrera]")
tiene_salida_intermedia = request.Form("p[0][tiene_salida_intermedia]")
tiene_minors = request.Form("p[0][tiene_minors]")
tdes_ccod = request.Form("p[0][tdes_ccod]")
agrupar_periodo = request.Form("p[0][agrupar_periodo]")
incluir_promedio = request.Form("p[0][incluir_promedio]")
promedio = request.Form("p[0][promedio]")
titulado = request.QueryString("TITULADO")
comentario = request.Form("comentario")
filtro_plan = ""
if carrera <>"" then
   filtro_plan = " and pn.plan_ccod='"&carrera&"'"
end if

if peri_ccod = "" OR peri_ccod = "1" then
	periodo_por_defecto = "226"
end if

sql = " select top 1 protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n')+ ',' as nombre, "& vbCrLf &_
      " --------------notas alumno "& vbCrLf &_
	  " (select top 1 case when isnull(porcentaje_notas,0) = 0 or isnull(calificacion_notas,0) = 0  then '' else 'Promedio Calificaciones Finales de la Carrera' end "& vbCrLf &_
	  "  from detalles_titulacion_carrera pn where pn.pers_ncorr=a.pers_ncorr "&filtro_plan&")as concepto_notas, "& vbCrLf &_
	  " (select top 1 case when isnull(porcentaje_notas,0) = 0 or isnull(calificacion_notas,0) = 0  then '' else ' : ' + cast(calificacion_notas as varchar) + '  *  ' + cast(porcentaje_notas as varchar)+ ' %' end "& vbCrLf &_
	  "  from detalles_titulacion_carrera pn where pn.pers_ncorr=a.pers_ncorr "&filtro_plan&")as calculo_notas, "& vbCrLf &_
	  " (select top 1 case when isnull(porcentaje_notas,0) = 0 or isnull(calificacion_notas,0) = 0  then '' else '=      ' + cast(cast(round(((isnull(calificacion_notas,0) *  isnull(porcentaje_notas,0))/100),2,1)as decimal(5,2)) as varchar) end "& vbCrLf &_
	  "  from detalles_titulacion_carrera pn where pn.pers_ncorr=a.pers_ncorr "&filtro_plan&")as resultado_notas, "& vbCrLf &_
	  " ---------------examen de título "& vbCrLf &_
	  " (select top 1 case when isnull(porcentaje_tesis,0) = 0 or isnull(calificacion_tesis,0) = 0  then '' else case pn.carr_ccod when '860' then 'Calificación Seminario de Título' else 'Calificación Examen de Título' end end "& vbCrLf &_
	  " from detalles_titulacion_carrera pn where pn.pers_ncorr=a.pers_ncorr "&filtro_plan&") as concepto_tesis,"& vbCrLf &_
	  " (select top 1 case when isnull(porcentaje_tesis,0) = 0 or isnull(calificacion_tesis,0) = 0  then '' else ' : ' + cast(calificacion_tesis as varchar) + '  *  ' + cast(porcentaje_tesis as varchar)+ ' %' end "& vbCrLf &_
	  " from detalles_titulacion_carrera pn where pn.pers_ncorr=a.pers_ncorr "&filtro_plan&") as calculo_tesis, "& vbCrLf &_
	  " (select top 1 case when isnull(porcentaje_tesis,0) = 0 or isnull(calificacion_tesis,0) = 0  then '' else '=      ' + cast(cast(round(((isnull(calificacion_tesis,0) *  isnull(porcentaje_tesis,0))/100),2,1)as decimal(5,2)) as varchar) end "& vbCrLf &_
	  " from detalles_titulacion_carrera pn where pn.pers_ncorr=a.pers_ncorr "&filtro_plan&") as resultado_tesis,"& vbCrLf &_
	  " ---------------Práctica Profesional "& vbCrLf &_
	  " (select top 1 case when isnull(porcentaje_practica,0) = 0 or isnull(calificacion_practica,0) = 0  then '' else 'Calificación Práctica Profesional' end "& vbCrLf &_
	  " from detalles_titulacion_carrera pn where pn.pers_ncorr=a.pers_ncorr "&filtro_plan&") as concepto_practica, "& vbCrLf &_
	  " (select top 1 case when isnull(porcentaje_practica,0) = 0 or isnull(calificacion_practica,0) = 0  then '' else ' : ' + cast(calificacion_practica as varchar) + '  *  ' + cast(porcentaje_practica as varchar)+ ' %' end "& vbCrLf &_
	  " from detalles_titulacion_carrera pn where pn.pers_ncorr=a.pers_ncorr "&filtro_plan&") as calculo_practica, "& vbCrLf &_
	  " (select top 1 case when isnull(porcentaje_practica,0) = 0 or isnull(calificacion_practica,0) = 0  then '' else '=      ' + cast(cast(round(((isnull(calificacion_practica,0) *  isnull(porcentaje_practica,0))/100),2,1)as decimal(5,2)) as varchar) end "& vbCrLf &_
	  " from detalles_titulacion_carrera pn where pn.pers_ncorr=a.pers_ncorr "&filtro_plan&") as resultado_practica, "& vbCrLf &_
	  " ---------------Nota de tesis "& vbCrLf &_
	  " (select top 1 case when isnull(porcentaje_nota_tesis,0) = 0 or isnull(nota_tesis,0) = 0  then '' else 'Calificación de Tesis' end "& vbCrLf &_
	  " from detalles_titulacion_carrera pn where pn.pers_ncorr=a.pers_ncorr "&filtro_plan&") as concepto_nota_tesis, "& vbCrLf &_
	  " (select top 1 case when isnull(porcentaje_nota_tesis,0) = 0 or isnull(nota_tesis,0) = 0  then '' else ' : ' + cast(nota_tesis as varchar) + '  *  ' + cast(porcentaje_nota_tesis as varchar)+ ' %' end "& vbCrLf &_
	  " from detalles_titulacion_carrera pn where pn.pers_ncorr=a.pers_ncorr "&filtro_plan&") as calculo_nota_tesis, "& vbCrLf &_
	  " (select top 1 case when isnull(porcentaje_nota_tesis,0) = 0 or isnull(nota_tesis,0) = 0  then '' else '=      ' + cast(cast(round(((isnull(nota_tesis,0) *  isnull(porcentaje_nota_tesis,0))/100),2,1)as decimal(5,2)) as varchar) end "& vbCrLf &_
	  " from detalles_titulacion_carrera pn where pn.pers_ncorr=a.pers_ncorr "&filtro_plan&") as resultado_nota_tesis, "& vbCrLf &_
	  " ---------------Nota final "& vbCrLf &_
	  " (select top 1 case isnull(promedio_final,0)  when  0 then '' else 'Promedio Final de Titulación' end "& vbCrLf &_
	  " from detalles_titulacion_carrera pn where pn.pers_ncorr=a.pers_ncorr "&filtro_plan&") as concepto_final, "& vbCrLf &_
	  " (select top 1 case isnull(promedio_final,0)  when  0 then '' else ' : ' + cast(promedio_final as varchar) end "& vbCrLf &_
	  " from detalles_titulacion_carrera pn where pn.pers_ncorr=a.pers_ncorr "&filtro_plan&") as nota_final, "& vbCrLf &_
	  "  "& vbCrLf &_
	  " protic.ano_ingreso_plan(b.pers_ncorr, b.plan_ccod) as ano_ingreso_plan, "& vbCrLf &_
	  " f.sede_secret, f.sede_tregistr, gg.desc_periodo, gg.peri_ccod, case gg.peri_ccod when 'N' then 'N' else 'S' end as por_periodo, 'CERTIFICADO' as titulo, protic.initcap(f.sede_tdesc) as sede,case c.jorn_ccod when 1 then 'Diurno' when '2' then 'Vespertino' end as jornada, "
 if peri_ccod <> "" and  peri_ccod <> "1" then
	if carrera <> "" then
	   sql = sql &  "     protic.es_alumno_nueva_version_prueba(" & pers_nrut & "," & peri_ccod & ",'" & carrera & "',1) as CARRERA, "& vbCrLf &_
			        "     protic.es_alumno_nueva_version_prueba(" & pers_nrut & "," & peri_ccod & ",'" & carrera & "',2) as DUAS_TDESC, "
	else
	   sql = sql &  "     protic.es_alumno_nueva_version_prueba(" & pers_nrut & "," & peri_ccod & ",'0',1) as CARRERA, "& vbCrLf &_
			        "     protic.es_alumno_nueva_version_prueba(" & pers_nrut & "," & peri_ccod & ",'0',2) as DUAS_TDESC, "
    end if 
 else
	if carrera <> "" then
	   sql = sql &  "     protic.es_alumno_nueva_version_prueba(" & pers_nrut & ","&periodo_por_defecto&",'" & carrera & "',1) as CARRERA, "& vbCrLf &_
					"     protic.es_alumno_nueva_version_prueba(" & pers_nrut & ","&periodo_por_defecto&",'" & carrera & "',2) as DUAS_TDESC, "
	else
	   sql = sql &  "     protic.es_alumno_nueva_version_prueba(" & pers_nrut & ","&periodo_por_defecto&",'0',1) as CARRERA, "& vbCrLf &_
					"     protic.es_alumno_nueva_version_prueba(" & pers_nrut & ","&periodo_por_defecto&",'0',2) as DUAS_TDESC, "
	end if
 end if
 sql = sql &  " case '" &tdes_ccod & "' when '' then ', para los fines que estime conveniente.' "& vbCrLf &_
			  " when '3' then ', para los fines que estime conveniente.' "& vbCrLf &_
			  " when '1' then ',  a petición del (la) interesado(a) para solicitar ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
			  " when '4' then ',  a petición del (la) interesado(a) para solicitar ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
			  " when '5' then ',  a petición del (la) interesado(a) para solicitar ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
			  " when '9' then ',  a petición del (la) interesado(a) para solicitar ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
			  " when '10' then ',  a petición del (la) interesado(a) para solicitar ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
			  " when '11' then ',  a petición del (la) interesado(a) para solicitar ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
			  " when '12' then ',  a petición del (la) interesado(a) para solicitar ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
			  " when '13' then ',  a petición del (la) interesado(a) para solicitar ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
			  " when '6' then ',  a petición del (la) interesado(a) para ser presentado en ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
			  " when '7' then ',  a petición del (la) interesado(a) para ser presentado en ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
			  " when '8' then ',  a petición del (la) interesado(a) para ser presentado en ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
			  " when '14' then ',  a petición del (la) interesado(a) para ser presentado en ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
			  " when '18' then ',  a petición del (la) interesado(a) para ser presentado en ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
			  " when '16' then ',  a petición del (la) interesado(a) para ser presentado en ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
			  " when '15' then ',  a petición del (la) interesado(a) para ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
			  " when '17' then ',  a petición del (la) interesado(a) para ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
			  " when '2' then ',  a petición del (la) interesado(a) para ser presentado en Cantón de Reclutamiento.' "& vbCrLf &_
			  " end as tdes_tdesc "& vbCrLf &_
			  " from personas a, alumnos b, ofertas_academicas c, especialidades d,carreras car, "& vbCrLf &_
			  "      sedes f, tipos_descripciones g,planes_estudio pl, "& vbCrLf &_
			  " 	 (select 'N' as peri_ccod, '' as desc_periodo union "
  if peri_ccod <> "" AND peri_ccod <> "1" THEN
			sql = sql &  " 	  select cast(peri_ccod as varchar) as peri_ccod, cast(anos_ccod as varchar)+ ' - ' + cast(plec_ccod as varchar) from periodos_academicos where cast(peri_ccod as varchar)= '" & peri_ccod & "') gg "
  else
			sql = sql &  " 	  select cast(peri_ccod as varchar) as peri_ccod, cast(anos_ccod as varchar)+ ' - ' + cast(plec_ccod as varchar) from periodos_academicos where cast(peri_ccod as varchar)= '"&periodo_por_defecto&"') gg "
  end if
  sql = sql & " where a.pers_ncorr = b.pers_ncorr  "& vbCrLf &_
			   "   and b.ofer_ncorr = c.ofer_ncorr  "& vbCrLf &_
			   "   and c.espe_ccod = d.espe_ccod and b.plan_ccod = pl.plan_ccod  "& vbCrLf &_
			   "   and d.carr_ccod = car.carr_ccod  "& vbCrLf &_
			   "   and b.emat_ccod <> 9 "
  if carrera <> ""  and  tiene_salida_intermedia = "0" and  tiene_minors = "0" then
		sql = sql & " and cast(pl.plan_ccod as varchar)='" & carrera & "' "
  else
		sql = sql & " and b.ofer_ncorr = protic.ultima_oferta_matriculado(a.pers_ncorr) "
  end if
  if peri_ccod <> "" and peri_ccod <> "1" then
		sql = sql &  "   and isnull('" & peri_ccod & "', 'N') = gg.peri_ccod "
  else
		sql = sql &  "   and isnull('"&periodo_por_defecto&"', 'N') = gg.peri_ccod "
  end if
  sql = sql &  "   and c.sede_ccod = f.sede_ccod "& vbCrLf &_
			   "   and cast(g.tdes_ccod as varchar)= '" & tdes_ccod & "' "& vbCrLf &_
			   "   and cast(a.pers_nrut as varchar)= '" & pers_nrut & "' "& vbCrLf &_
			   "   order by b.alum_fmatricula desc"

'response.Write("<pre>"&sql&"</pre>")
'response.End()
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "tabla_vacia.xml", "tabla"
f_encabezado.Inicializar conexion
f_encabezado.Consultar sql
f_encabezado.siguiente
'response.Write("<pre>"&sql&"</pre>")
'response.End()

rut = f_encabezado.obtenerValor("rut")	
nombre = f_encabezado.obtenerValor("nombre")
concepto_notas = f_encabezado.obtenerValor("concepto_notas")
calculo_notas = f_encabezado.obtenerValor("calculo_notas")
resultado_notas = f_encabezado.obtenerValor("resultado_notas")
concepto_tesis = f_encabezado.obtenerValor("concepto_tesis")
calculo_tesis = f_encabezado.obtenerValor("calculo_tesis")
resultado_tesis = f_encabezado.obtenerValor("resultado_tesis")
concepto_practica = f_encabezado.obtenerValor("concepto_practica")
calculo_practica = f_encabezado.obtenerValor("calculo_practica")
resultado_practica = f_encabezado.obtenerValor("resultado_practica")
concepto_nota_tesis = f_encabezado.obtenerValor("concepto_nota_tesis")
calculo_nota_tesis = f_encabezado.obtenerValor("calculo_nota_tesis")
resultado_nota_tesis = f_encabezado.obtenerValor("resultado_nota_tesis")
concepto_final = f_encabezado.obtenerValor("concepto_final")
nota_final2 = f_encabezado.obtenerValor("nota_final")
ano_ingreso_plan = f_encabezado.obtenerValor("ano_ingreso_plan")
sede_secret = f_encabezado.obtenerValor("sede_secret")
sede_tregistr = f_encabezado.obtenerValor("sede_tregistr")
desc_periodo = f_encabezado.obtenerValor("desc_periodo")
peri_ccod = f_encabezado.obtenerValor("peri_ccod")
por_periodo = f_encabezado.obtenerValor("por_periodo")
titulo = f_encabezado.obtenerValor("titulo")
sede = f_encabezado.obtenerValor("sede")
jornada = f_encabezado.obtenerValor("jornada")
carrera = f_encabezado.obtenerValor("CARRERA")
duas_tdesc = f_encabezado.obtenerValor("DUAS_TDESC")
tdes_tdesc = f_encabezado.obtenerValor("tdes_tdesc")

'Parche temporal 10/01/2013 por mriffo ( H. Vargas solicita con urgencia corregir promedio)
if pers_nrut="16607524" then
nota_final2="5.19"
end if

'-----------------------------------------------------------------------------------------------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------------------------------

sql2 = " select cast(horas as numeric(4)) as T,a.asig_ccod,b.asig_tdesc,case when c.sitf_ccod <> 'RI' then nota_final else NULL end as carg_nnota_final,anos_ccod as peri_ccod, "& vbCrLf &_
	   " anos_ccod,plec_ccod,c.sitf_ccod,c.sitf_baprueba,replace(cast(nota_final as decimal(2,1)),'.',',') as nota_final,anos_ccod as ano_cursado,plec_ccod as periodo, "& vbCrLf &_
	   " case when c.sitf_ccod <> 'RI' then case isnull(cast(nota_final as varchar),'-') when '-' then case c.sitf_ccod when 'A' then 'A' when 'C' then 'C' when 'R' then 'R' when 'SP' then 'SP' when 'H' then 'H' when 'S' then 'S' when 'RC' then 'RC' when 'RS' then 'RS' when 'RI' then 'RI' end  else '' end else 'RI' end as estado, "& vbCrLf &_
	   " SUBSTRING(LTRIM(RTRIM(cast(cast(nota_final AS decimal(2,1))AS varchar))), 1, CHARINDEX('.', LTRIM(RTRIM(cast(cast(nota_final AS decimal(2,1)) AS varchar)))) - 1) AS p1, "& vbCrLf &_
	   " SUBSTRING(LTRIM(RTRIM(cast(cast(nota_final AS decimal(2,1))AS varchar))), CHARINDEX('.', LTRIM(RTRIM(cast(cast(nota_final AS decimal(2,1))AS varchar)))) + 1, 1) AS p2, "& vbCrLf &_
	   " cantidad "& vbCrLf &_
	   " from concentracion_notas a, asignaturas b,situaciones_finales c "& vbCrLf &_
	   " where a.asig_ccod=b.asig_ccod "& vbCrLf &_
	   " and case a.sitf_ccod when 'HM' then 'H' else a.sitf_ccod end = c.sitf_ccod "& vbCrLf &_
	   " and a.pers_ncorr in (select pers_ncorr from personas where cast(pers_nrut as varchar)='" & pers_nrut & "') "& vbCrLf &_
	   " and cast(plan_ccod as varchar)='" & plan_ccod & "' "& vbCrLf &_
	   " order by peri_ccod asc,b.asig_tdesc asc "
'response.Write("<pre>"&SQL2&"</pre>")
'response.End()
set f_detalle = new CFormulario
f_detalle.Carga_Parametros "tabla_vacia.xml", "tabla"
f_detalle.Inicializar conexion
f_detalle.Consultar SQL2
'f_detalle.siguiente
cantidad_asignaturas = f_detalle.nroFilas
limite_hoja = 13
if cantidad_asignaturas <= 18 then
	limite_hoja = 18
elseif cantidad_asignaturas  > 18 then
	limite_hoja = 23
end if

 
consulta_fecha = " select case when datePart(day,getDate()) < 10 then '0' else '' end + cast(datePart(day,getDate()) as varchar)  " 				 
dia_impresion = conexion.consultaUno(consulta_fecha)

consulta_fecha = " select case datePart(month,getDate()) when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' " & vbCrLf &_
				 " when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' " & vbCrLf &_
				 " when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' end " 
mes_impresion = conexion.consultaUno(consulta_fecha)

consulta_fecha = " select cast(datePart(year,getDate()) as varchar) as fecha_01"				 
anio_impresion = conexion.consultaUno(consulta_fecha)


espacio="                                       "
espacio2="    "
Set pdf=CreateJsObject("FPDF")
pdf.CreatePDF()
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "times","",12
pdf.Open()
pdf.LoadModels("pie_concentracion") 
pdf.AddPage()
'lineas superiores
'pdf.Line 8, 18, 204, 18 
'pdf.Line 7, 17, 205, 17 
'lineas izquierdas
'pdf.Line 7, 17, 7, 285
'pdf.Line 8, 18, 8, 284
'lineas derechas
'pdf.Line 204, 18, 204, 284
'pdf.Line 205, 17, 205, 285
'lineas inferiores
'pdf.Line 8, 284, 204, 284 
'pdf.Line 7, 285, 205, 285

'pdf.Image "../certificados_dae/imagenes/logo_upa.jpg", 14, 22, 20, 20, "JPG"
	pdf.ln(30)
pdf.SetFont "times","B",14
pdf.Cell 180,1,"CERTIFICADO","","","C" 
	pdf.ln(10)
pdf.SetFont "times","",12
pdf.SetX(130)
pdf.Cell 180,0,"RUN","","","L"
pdf.SetX(150)
pdf.Cell 180,0,":","","","L"
pdf.SetX(160)
pdf.Cell 180,0,rut,"","","L"
	pdf.ln(5)
pdf.SetFont "times","",12
pdf.SetX(130)
pdf.Cell 180,0,"Sede","","","L"
pdf.SetX(150)
pdf.Cell 180,0,":","","","L"
pdf.SetX(160)
pdf.Cell 180,0,sede,"","","L"
	pdf.ln(5)
pdf.SetFont "times","",12
pdf.SetX(130)
pdf.Cell 180,0,"Jornada","","","L"
pdf.SetX(150)
pdf.Cell 180,0,":","","","L"
pdf.SetX(160)
pdf.Cell 180,0,jornada,"","","L"
	pdf.ln(10)
pdf.SetFont "times","",12
pdf.Cell 180,1,"El Jefe de Títulos y Grados que suscribe certifica que el (la) Sr.(ta).","","","L" 
	pdf.ln(3)
pdf.SetFont "times","",12
pdf.MultiCell 180,5,nombre&" "&carrera&" "&duas_tdesc&" calificaciones de acuerdo a la escala de uno a siete, siendo cuatro el mínimo de aprobación:","","","J" 
	pdf.ln(5)
pdf.SetFont "times","B",10
pdf.SetFillColor(230) 
'pdf.SetX(10)
'pdf.Cell 5,4,"","","","L",true
pdf.SetX(15)
pdf.Cell 175,4,"Código(s)","","","L",true
pdf.SetX(35)
pdf.Cell 155,4,"Asignatura(s)","","","L",true
pdf.SetX(125)
pdf.Cell 65,4,"Calificación(es)","","","L",true
pdf.SetX(155)
pdf.Cell 35,4,"Período","","","L",true
pdf.SetX(170)
pdf.Cell 20,4,"Carácter","","","L",true
	pdf.ln(4)
pdf.SetFont "times","B",10
'pdf.SetX(10)
'pdf.Cell 5,4,"","","","L",true
pdf.SetX(15)
pdf.Cell 175,3,"","","","L",true
pdf.SetX(35)
pdf.Cell 155,3,"","","","L",true
pdf.SetX(125)
pdf.Cell 65,3,"Final(es)","","","L",true
pdf.SetX(155)
pdf.Cell 35,3,"","","","L",true
pdf.SetX(170)
pdf.Cell 20,3,"","","","L",true
pdf.ln(3)
suma_notas = 0.0
total_asignaturas = 0
filas_impresas = 0
numero = 0
while f_detalle.siguiente
   asig_ccod = f_detalle.obtenerValor("asig_ccod")
   asig_tdesc = f_detalle.obtenerValor("asig_tdesc")
   nota_final = f_detalle.obtenerValor("nota_final")
   sitf_ccod  = f_detalle.obtenerValor("sitf_ccod")
   ano_cursado = f_detalle.obtenerValor("ano_cursado")
   periodo = f_detalle.obtenerValor("periodo")
   carg_nnota_final = f_detalle.obtenerValor("carg_nnota_final")
   filas_impresas = filas_impresas + 1
   numero = numero + 1

   if carg_nnota_final <> "" then
   		muestra = nota_final
		total_asignaturas = total_asignaturas + 1
		'response.Write("<br>suma_notas "&suma_notas&" carg_nnota_final "&carg_nnota_final)
		suma_notas = cdbl(suma_notas) + cdbl(carg_nnota_final)
   else
   		muestra = sitf_ccod
   end if
    
   if cantidad_asignaturas > 13 and filas_impresas > limite_hoja then
      filas_impresas = 0
	  limite_hoja = 25
	  pdf.AddPage()
	    pdf.ln(30)
		pdf.SetFont "times","B",14
		pdf.Cell 180,1,"CERTIFICADO","","","C" 
			pdf.ln(10)
		pdf.SetFont "times","",12
		pdf.SetX(130)
		pdf.Cell 180,0,"RUN","","","L"
		pdf.SetX(150)
		pdf.Cell 180,0,":","","","L"
		pdf.SetX(160)
		pdf.Cell 180,0,rut,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","",12
		pdf.SetX(130)
		pdf.Cell 180,0,"Sede","","","L"
		pdf.SetX(150)
		pdf.Cell 180,0,":","","","L"
		pdf.SetX(160)
		pdf.Cell 180,0,sede,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","",12
		pdf.SetX(130)
		pdf.Cell 180,0,"Jornada","","","L"
		pdf.SetX(150)
		pdf.Cell 180,0,":","","","L"
		pdf.SetX(160)
		pdf.Cell 180,0,jornada,"","","L"
		pdf.ln(7)
		pdf.SetFont "times","B",10
		pdf.SetFillColor(230) 
		'pdf.SetX(10)
		'pdf.Cell 5,4,"N","","","L",true
		pdf.SetX(15)
		pdf.Cell 175,4,"Código(s)","","","L",true
		pdf.SetX(35)
		pdf.Cell 155,4,"Asignatura(s)","","","L",true
		pdf.SetX(125)
		pdf.Cell 65,4,"Calificación(es)","","","L",true
		pdf.SetX(155)
		pdf.Cell 35,4,"Período","","","L",true
		pdf.SetX(170)
		pdf.Cell 20,4,"Carácter","","","L",true
		pdf.ln(4)
		pdf.SetFont "times","B",10
		'pdf.SetX(10)
		'pdf.Cell 5,4,"","","","L",true
		pdf.SetX(15)
		pdf.Cell 175,3,"","","","L",true
		pdf.SetX(35)
		pdf.Cell 155,3,"","","","L",true
		pdf.SetX(125)
		pdf.Cell 65,3,"Final(es)","","","L",true
		pdf.SetX(155)
		pdf.Cell 35,3,"","","","L",true
		pdf.SetX(170)
		pdf.Cell 20,3,"","","","L",true
		pdf.ln(3)
   end if
   
		pdf.ln(5)
	pdf.SetFont "times","",10
	pdf.SetTextColor 186,186,186
	pdf.SetX(10)
	pdf.Cell 5,0,numero,"","","L",false
	pdf.SetTextColor 0,0,0
	pdf.SetX(15)
	pdf.Cell 175,0,asig_ccod,"","","L",false
	pdf.SetX(35)
	pdf.Cell 155,0,asig_tdesc,"","","L",false
	pdf.SetX(143)
	pdf.Cell 65,0,muestra,"","","L",false
	pdf.SetX(155)
	pdf.Cell 35,0,ano_cursado,"","","L",false
	pdf.SetX(170)
	pdf.Cell 20,0,periodo,"","","L",false
wend
    'response.Write(suma_notas&" / "&total_asignaturas)
	if total_asignaturas = 0 then
		total_asignaturas = 1
	end if	
	promedio = formatnumber(cdbl(suma_notas / total_asignaturas),2,-1,0,0)
	if titulado <> "SI" then
		if promedio <> "0,00" then	
			pdf.ln(7)
			pdf.SetFont "times","",12
			pdf.Cell 180,1,"Promedio General      "&promedio,"","","C" 
		else
			pdf.ln(7)
			pdf.SetFont "times","",12
			pdf.Cell 180,1," ","","","C" 
		end if
    else
		pdf.ln(7)
		pdf.SetFont "times","B",10
		pdf.SetFillColor(230) 
		pdf.SetX(30)
		pdf.Cell 120,3,"","","","L",true
		pdf.SetX(104)
		pdf.Cell 50,3,"Nota","","","L",true
		pdf.SetX(115)
		pdf.Cell 35,3,"Pond.","","","L",true
		pdf.SetX(134)
		pdf.Cell 20,3,"Nota Pond.","","","L",true
		if concepto_notas <> "" then
			pdf.ln(4)
			pdf.SetFont "times","",10
			pdf.SetX(30)
			pdf.Cell 120,3,concepto_notas,"","","L"
			pdf.SetX(100)
			pdf.Cell 50,3,calculo_notas,"","","L"
			pdf.SetX(130)
			pdf.Cell 20,3,resultado_notas,"","","L"
		end if
		if concepto_tesis <> "" then
			pdf.ln(4)
			pdf.SetFont "times","",10
			pdf.SetX(30)
			pdf.Cell 120,3,concepto_tesis,"","","L"
			pdf.SetX(100)
			pdf.Cell 50,3,calculo_tesis,"","","L"
			pdf.SetX(130)
			pdf.Cell 20,3,resultado_tesis,"","","L"
		end if
		if concepto_practica <> "" then
			pdf.ln(4)
			pdf.SetFont "times","",10
			pdf.SetX(30)
			pdf.Cell 120,3,concepto_practica,"","","L"
			pdf.SetX(100)
			pdf.Cell 50,3,calculo_practica,"","","L"
			pdf.SetX(130)
			pdf.Cell 20,3,resultado_practica,"","","L"
		end if
		if concepto_nota_tesis <> "" then
			pdf.ln(4)
			pdf.SetFont "times","",10
			pdf.SetX(30)
			pdf.Cell 120,3,concepto_nota_tesis,"","","L"
			pdf.SetX(100)
			pdf.Cell 50,3,calculo_nota_tesis,"","","L"
			pdf.SetX(130)
			pdf.Cell 20,3,resultado_nota_tesis,"","","L"
		end if
		if concepto_final <> "" then
			pdf.ln(5)
			pdf.SetFont "times","B",10
			pdf.SetX(30)
			pdf.Cell 120,3,concepto_final,"","","L"
			pdf.SetX(100)
			pdf.Cell 50,3,nota_final2,"","","L"
			pdf.SetX(130)
			pdf.Cell 20,3,"","","","L"
		end if
	end if
   	pdf.ln(5)
pdf.SetFont "times","",12
pdf.MultiCell 180,4,"Se extiende el presente certificado"&tdes_tdesc&" "&comentario,"","","J" 
pdf.SetY(-50)
pdf.SetFont "times","B",12
pdf.SetX(130)
pdf.Cell 50,0,"VICTOR MENDOZA LOBOS","","","C"   
pdf.SetY(-46)
pdf.SetFont "times","B",12
pdf.SetX(130)
pdf.Cell 50,0,"Jefe de Títulos y Grados","","","C"   
	pdf.ln(1)
pdf.SetY(-40)
pdf.SetFont "times","",12
'pdf.Cell 180,0,"Santiago, 20 de Octubre de 2009.","","","L" 
pdf.Cell 180,0,"Santiago, "&dia_impresion&" de "&mes_impresion&" de "&anio_impresion&".","","","L" 
pdf.Close()
pdf.Output()
%> 

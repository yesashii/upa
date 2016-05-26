<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=alumnos_x_año.xls"
Response.ContentType = "application/vnd.ms-excel"

anos_ccod = Request.QueryString("anos_ccod")
carr_ccod = Request.QueryString("carr_ccod")

'------------------------------------------------------------------------------------
set pagina = new CPagina
'------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_cuentas = new CFormulario
f_cuentas.Carga_Parametros "tabla_vacia.xml", "tabla"
f_cuentas.Inicializar conexion

' consulta = " select distinct c.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbCrLf &_
	'		" c.pers_tape_paterno + ' ' + c.pers_tape_materno + ', '+ c.pers_tnombre as alumno, "& vbCrLf &_
	'		" (select max(anos_ccod) from alumnos alu, ofertas_Academicas ofe, especialidades esp, periodos_Academicos pea "& vbCrLf &_
	'		"  where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.espe_ccod=esp.espe_ccod and ofe.peri_ccod=pea.peri_ccod "& vbCrLf &_
	'		"  and esp.carr_ccod=e.carr_ccod) as ultimo_anio_estudio, "& vbCrLf &_
	'	    " (select top 1 emat_tdesc from alumnos alu1, ofertas_academicas ofe1, especialidades esp1, estados_matriculas ema1 "& vbCrLf &_
	'		"  where alu1.pers_ncorr= a.pers_ncorr and alu1.ofer_ncorr=ofe1.ofer_ncorr "& vbCrLf &_
	'		"   and ofe1.peri_ccod in (select max(peri_ccod) from alumnos alu, ofertas_Academicas ofe, especialidades esp "& vbCrLf &_
	''		"                          where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.espe_ccod=esp.espe_ccod "& vbCrLf &_
		'	"                          and esp.carr_ccod=e.carr_ccod) "& vbCrLf &_
		'	"   and ofe1.espe_ccod=esp1.espe_ccod and esp1.carr_ccod=e.carr_ccod "& vbCrLf &_
		'	"   and alu1.emat_ccod=ema1.emat_ccod order by alu1.audi_fmodificacion desc) as ultimo_estado_registrado, "& vbCrLf &_
		'	" (select count(distinct peri_ccod) from alumnos alu, ofertas_Academicas ofe, especialidades esp "& vbCrLf &_
		'	"  where alu.pers_ncorr = a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.espe_ccod=esp.espe_ccod "& vbCrLf &_
		'	"  and esp.carr_ccod = e.carr_ccod) as cantidad_semestres_registrado, "& vbCrLf &_
		'	" isnull((select top 1 cast(anos_ccod as varchar) + ' - ' + cast(plec_ccod as varchar) as ano "& vbCrLf &_
		'	"  from alumnos alu, ofertas_Academicas ofe, especialidades esp,periodos_Academicos pea "& vbCrLf &_
		'	"  where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.espe_ccod=esp.espe_ccod "& vbCrLf &_
		'	"  and esp.carr_ccod=e.carr_ccod and ofe.peri_ccod=pea.peri_ccod and alu.emat_ccod = 4 ), 'No Registra') as periodo_egreso,     "& vbCrLf &_
		'	"  isnull((select top 1 cast(anos_ccod as varchar) + ' - ' + cast(plec_ccod as varchar) as ano "& vbCrLf &_
		'	"  from alumnos alu, ofertas_Academicas ofe, especialidades esp,periodos_Academicos pea "& vbCrLf &_
		'	"  where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.espe_ccod=esp.espe_ccod "& vbCrLf &_
		'	"  and esp.carr_ccod=e.carr_ccod and ofe.peri_ccod=pea.peri_ccod and alu.emat_ccod = 8 ), 'No Registra') as periodo_titulacion, "& vbCrLf &_
		'	"  (select case count(*) when 0 then 'No' else 'Sí' end  "& vbCrLf &_
		'	"  from alumnos alu, ofertas_Academicas ofe, especialidades esp,periodos_Academicos pea "& vbCrLf &_
		'	"  where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.espe_ccod=esp.espe_ccod "& vbCrLf &_
		'	"  and esp.carr_ccod=e.carr_ccod and ofe.peri_ccod=pea.peri_ccod and pea.anos_ccod='2005') as matricula_2005 "& vbCrLf &_
		'	" from alumnos a, ofertas_academicas b, personas c, periodos_academicos d,especialidades e "& vbCrLf &_
		'	" where a.ofer_ncorr=b.ofer_ncorr and a.pers_ncorr=c.pers_ncorr "& vbCrLf &_
		'	" and exists(select 1 from cargas_Academicas carg where carg.matr_ncorr=a.matr_ncorr) "& vbCrLf &_
		'	" and b.peri_ccod = d.peri_ccod and b.espe_ccod = e.espe_ccod and a.emat_ccod <> 9"& vbCrLf &_
		'	" and cast(d.anos_ccod as varchar)='"&anos_ccod&"' and e.carr_ccod='"&carr_ccod&"' "& vbCrLf &_
		'	" and not exists (select 1 from alumnos alu, ofertas_academicas ofe, periodos_academicos pea,especialidades esp "& vbCrLf &_
			'" where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.peri_ccod=pea.peri_ccod "& vbCrLf &_
           ' " and pea.anos_ccod < d.anos_ccod  and ofe.espe_ccod=esp.espe_ccod and esp.carr_ccod=e.carr_ccod)"& vbCrLf	
			
			 consulta =" select distinct c.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbCrLf &_
					   " c.pers_tape_paterno + ' ' + c.pers_tape_materno + ', '+ c.pers_tnombre as alumno, "& vbCrLf &_
					   " "& vbCrLf &_
					   " (select max(anos_ccod) from alumnos alu, ofertas_Academicas ofe, especialidades esp, periodos_Academicos pea "& vbCrLf &_
					   "  where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.espe_ccod=esp.espe_ccod and ofe.peri_ccod=pea.peri_ccod "& vbCrLf &_
					   "  and esp.carr_ccod=e.carr_ccod) as ultimo_anio_estudio, "& vbCrLf &_
					   "  "& vbCrLf &_
					   "  (select top 1 emat_tdesc from alumnos alu1, ofertas_academicas ofe1, especialidades esp1, estados_matriculas ema1 "& vbCrLf &_
					   "  where alu1.pers_ncorr= a.pers_ncorr and alu1.ofer_ncorr=ofe1.ofer_ncorr "& vbCrLf &_
					   "  and ofe1.peri_ccod in (select max(peri_ccod) from alumnos alu, ofertas_Academicas ofe, especialidades esp "& vbCrLf &_
					   "						where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.espe_ccod=esp.espe_ccod "& vbCrLf &_
					   "						and esp.carr_ccod=e.carr_ccod) "& vbCrLf &_
					   "  and ofe1.espe_ccod=esp1.espe_ccod and esp1.carr_ccod=e.carr_ccod "& vbCrLf &_
					   "  and alu1.emat_ccod=ema1.emat_ccod order by alu1.audi_fmodificacion desc) as ultimo_estado_registrado, "& vbCrLf &_
					   "  "& vbCrLf &_
					   "  (select count(distinct peri_ccod) from alumnos alu, ofertas_Academicas ofe, especialidades esp "& vbCrLf &_
					   "  where alu.pers_ncorr = a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.espe_ccod=esp.espe_ccod "& vbCrLf &_
					   "  and esp.carr_ccod = e.carr_ccod) as cantidad_semestres_registrado, "& vbCrLf &_
					   "  "& vbCrLf &_
					   "  isnull((select top 1 cast(anos_ccod as varchar) + ' - ' + cast(plec_ccod as varchar) as ano "& vbCrLf &_
					   "  from alumnos alu, ofertas_Academicas ofe, especialidades esp,periodos_Academicos pea "& vbCrLf &_
					   "  where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.espe_ccod=esp.espe_ccod "& vbCrLf &_
					   "  and esp.carr_ccod=e.carr_ccod and ofe.peri_ccod=pea.peri_ccod and alu.emat_ccod = 4 ), 'No Registra') as periodo_egreso, "& vbCrLf &_
					   "  "& vbCrLf &_
					   "  isnull((select top 1 cast(anos_ccod as varchar) + ' - ' + cast(plec_ccod as varchar) as ano "& vbCrLf &_
					   "  from alumnos alu, ofertas_Academicas ofe, especialidades esp,periodos_Academicos pea "& vbCrLf &_
					   "  where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.espe_ccod=esp.espe_ccod "& vbCrLf &_
					   "  and esp.carr_ccod=e.carr_ccod and ofe.peri_ccod=pea.peri_ccod and alu.emat_ccod = 8 ), 'No Registra') as periodo_titulacion, "& vbCrLf &_
					   "  "& vbCrLf &_
					   "  (select case count(*) when 0 then 'No' else 'Sí' end "& vbCrLf &_
					   "  from alumnos alu, ofertas_Academicas ofe, especialidades esp,periodos_Academicos pea "& vbCrLf &_
					   "  where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.espe_ccod=esp.espe_ccod "& vbCrLf &_
					   "  and esp.carr_ccod=e.carr_ccod and ofe.peri_ccod=pea.peri_ccod and pea.anos_ccod='2007') as matricula_2005, "& vbCrLf &_
					   "  "& vbCrLf &_
					   "  protic.trunc(c.pers_fnacimiento)as fecha_nacimiento, "& vbCrLf &_
					   "  (select sexo_tdesc from sexos w where w.sexo_ccod=c.sexo_ccod)as sexo, "& vbCrLf &_
					   "  (select pais_tdesc from paises 		where pais_ccod=c.pais_ccod)as pais, "& vbCrLf &_
					   "  "& vbCrLf &_
					   "  ( select top  1 isnull(oema_tobservacion,'--') "& vbCrLf &_
					   "  from alumnos alu, ofertas_academicas ofe, periodos_academicos pea, especialidades esp,observaciones_estado_matricula om  "& vbCrLf &_
					   "  where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr "& vbCrLf &_
					   "  and ofe.peri_ccod=pea.peri_ccod and ofe.espe_ccod=esp.espe_ccod "& vbCrLf &_
					   "  and pea.anos_ccod=d.anos_ccod and esp.carr_ccod=e.carr_ccod "& vbCrLf &_
					   "  and alu.matr_ncorr = om.matr_ncorr order by oema_tobservacion desc) as observacion, "& vbCrLf &_
					   "  "& vbCrLf &_
					   "  ( select top 1 isnull(om2.eoma_tdesc,'--') "& vbCrLf &_
					   "  from alumnos alu, ofertas_academicas ofe, periodos_academicos pea, especialidades esp, "& vbCrLf &_
					   "  observaciones_estado_matricula om1,estado_observaciones_matriculas om2 "& vbCrLf &_
					   "  where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr "& vbCrLf &_
					   "  and ofe.peri_ccod=pea.peri_ccod and ofe.espe_ccod=esp.espe_ccod "& vbCrLf &_
					   "  and pea.anos_ccod=d.anos_ccod and esp.carr_ccod=e.carr_ccod "& vbCrLf &_
					   "  and alu.matr_ncorr = om1.matr_ncorr and om1.eoma_ccod = om2.eoma_ccod "& vbCrLf &_
					   "  order by oema_tobservacion desc) as condicion, "& vbCrLf &_
					   "  "& vbCrLf &_
					   "	isnull(cast(protic.PROMEDIO_MEDIA(c.pers_ncorr) as varchar),'') as promedio_media, "& vbCrLf &_
					   "  (select top 1 case f.tpad_ccod when 1 then 'P.A.A' when 2 then 'P.S.U' else '--' end  "& vbCrLf &_
					   "  from postulantes f, periodos_academicos g where f.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					   "  and f.peri_ccod=g.peri_ccod and g.anos_ccod = d.anos_ccod order by tpad_ccod desc )as tipo_prueba, "& vbCrLf &_
					   "  "& vbCrLf &_
					   "  (select top 1 case when  cast((isnull(f.post_npaa_verbal,0) + isnull(f.post_npaa_matematicas,0)) / 2 as decimal(6,3)) < 475 then 'Ingreso Especial' else cast( isnull(cast(f.post_npaa_verbal as varchar),'--')as varchar) end  "& vbCrLf &_
					   "   from postulantes f, periodos_academicos g where f.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					   "   and f.peri_ccod=g.peri_ccod and g.anos_ccod = d.anos_ccod order by post_npaa_verbal desc)as puntaje_verbal, "& vbCrLf &_
					   "   "& vbCrLf &_
					   "  (select top 1 case when  cast((isnull(f.post_npaa_verbal,0) + isnull(f.post_npaa_matematicas,0)) / 2 as decimal(6,3)) < 475 then 'Ingreso Especial' else cast( isnull(cast(f.post_npaa_matematicas as varchar),'--') as varchar) end  "& vbCrLf &_
					   "  from postulantes f, periodos_academicos g where f.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					   "  and f.peri_ccod=g.peri_ccod and g.anos_ccod = d.anos_ccod order by post_npaa_matematicas desc)as puntaje_matematicas, "& vbCrLf &_
					   "  "& vbCrLf &_
					   "  (select top 1 case when  cast((isnull(f.post_npaa_verbal,0) + isnull(f.post_npaa_matematicas,0)) / 2 as decimal(6,3)) < 475 then 'Ingreso Especial' else cast(cast((isnull(f.post_npaa_verbal,0) + isnull(f.post_npaa_matematicas,0)) / 2 as decimal(6,3)) as varchar) end  "& vbCrLf &_
					   "  from postulantes f, periodos_academicos g where f.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					   "  and f.peri_ccod=g.peri_ccod and g.anos_ccod = d.anos_ccod order by post_npaa_matematicas,post_npaa_verbal desc)as promedio_prueba, "& vbCrLf &_
					   "  "& vbCrLf &_
					   "  (select top 1 f.POST_NANO_PAA "& vbCrLf &_
					   "  from postulantes f, periodos_academicos g where f.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					   "  and f.peri_ccod=g.peri_ccod and g.anos_ccod = d.anos_ccod order by f.POST_NANO_PAA desc )as ano_paa, "& vbCrLf &_
					   "  "& vbCrLf &_
					   "  protic.ano_ingreso_carrera (a.pers_ncorr,e.carr_ccod) as ano_ingreso, "& vbCrLf &_
					   "  isnull((select case tip_ens.tens_ccod when 4 then pp.pers_ttipo_ensenanza else tip_ens.tens_tdesc end  "& vbCrLf &_
					   "		from personas_postulante pp,tipos_ensenanza_media tip_ens "& vbCrLf &_
					   " 		where pp.tens_ccod = tip_ens.tens_ccod and pp.pers_ncorr=c.pers_ncorr),'--') as tipo_ensenanza, "& vbCrLf &_
					   "  "& vbCrLf &_
					   "  (select top 1 jorn_tdesc from alumnos alu1, ofertas_academicas ofe1, especialidades esp1, jornadas ema1 "& vbCrLf &_
					   "  where alu1.pers_ncorr= a.pers_ncorr and alu1.ofer_ncorr=ofe1.ofer_ncorr "& vbCrLf &_
					   "  and ofe1.peri_ccod in (select max(peri_ccod) from alumnos alu, ofertas_Academicas ofe, especialidades esp  "& vbCrLf &_
					   "						where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.espe_ccod=esp.espe_ccod "& vbCrLf &_
					   "						and esp.carr_ccod=e.carr_ccod)  "& vbCrLf &_
					   "  and ofe1.espe_ccod=esp1.espe_ccod and esp1.carr_ccod=e.carr_ccod  "& vbCrLf &_
					   "  and ofe1.jorn_ccod=ema1.jorn_ccod order by alu1.audi_fmodificacion desc) as jornada,  "& vbCrLf &_
					   "   "& vbCrLf &_
					   "  (select top 1 esp1.espe_tdesc from alumnos alu1, ofertas_academicas ofe1, especialidades esp1 "& vbCrLf &_
					   "  where alu1.pers_ncorr= a.pers_ncorr and alu1.ofer_ncorr=ofe1.ofer_ncorr  "& vbCrLf &_
					   "  and ofe1.peri_ccod in (select max(peri_ccod) from alumnos alu, ofertas_Academicas ofe, especialidades esp  "& vbCrLf &_
					   "						where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.espe_ccod=esp.espe_ccod  "& vbCrLf &_
					   "						and esp.carr_ccod=e.carr_ccod)  "& vbCrLf &_
					   "  and ofe1.espe_ccod=esp1.espe_ccod and esp1.carr_ccod=e.carr_ccod  "& vbCrLf &_
					   "  order by alu1.audi_fmodificacion desc) as especialidad  "& vbCrLf &_
					   "  "& vbCrLf &_
					   "  from alumnos a, ofertas_academicas b, personas c, periodos_academicos d,especialidades e "& vbCrLf &_
					   "  where a.ofer_ncorr=b.ofer_ncorr and a.pers_ncorr=c.pers_ncorr "& vbCrLf &_
					   "  --and exists(select 1 from cargas_Academicas carg where carg.matr_ncorr=a.matr_ncorr) "& vbCrLf &_
					   "  and b.peri_ccod = d.peri_ccod and b.espe_ccod = e.espe_ccod and a.emat_ccod <> 9 "& vbCrLf &_
					   "  and cast(d.anos_ccod as varchar)='"&anos_ccod&"' and e.carr_ccod='"&carr_ccod&"' "& vbCrLf &_
					   "  and not exists (select 1 from alumnos alu, ofertas_academicas ofe, periodos_academicos pea,especialidades esp "& vbCrLf &_
					   "  where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.peri_ccod=pea.peri_ccod "& vbCrLf &_
					   "  and pea.anos_ccod < d.anos_ccod  and ofe.espe_ccod=esp.espe_ccod and esp.carr_ccod=e.carr_ccod) "

      'response.Write("<pre>"&consulta&"</pre>")
	  f_cuentas.consultar consulta
	  
	  
total = 0
total_titulados = 0
total_egresados = 0
total_activos = 0
total_actuales = 0
while f_cuentas.siguiente
		total = total + 1
		if f_cuentas.obtenerValor("periodo_egreso") <> "No Registra" then
			total_egresados = total_egresados + 1
		end if
		if f_cuentas.obtenerValor("periodo_titulacion") <> "No Registra" then
			total_titulados= total_titulados + 1
		end if
		if f_cuentas.obtenerValor("ultimo_estado_registrado") = "ACTIVA" then
			total_activos= total_activos + 1
		end if
		if f_cuentas.obtenerValor("matricula_2005") = "Sí" then
			total_actuales= total_actuales + 1
		end if
wend
f_cuentas.primero

carr_tdesc = conexion.consultaUno("Select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")
 

%>
<html>
<head>
<title> Listado Personas </title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
  <tr>
    <td align="center" width="100%" colspan="9"><font size="+2">Listado de Alumnos Nuevos </font> </td>
  </tr>
  <tr>
    <td align="center" width="100%" colspan="9"><font size="+2">&nbsp;</font> </td>
  </tr>
  <tr>
    <td align="left" width="100%" colspan="2"><font size="+1"><strong>Año</strong></font></td>
    <td align="left" width="100%" colspan="7"><font size="+1"><strong>: </strong><%=anos_ccod%></font></td>
  </tr>
  <tr>
    <td align="left" width="100%" colspan="2"><font size="+1"><strong>Carrera</strong></font></td>
    <td align="left" width="100%" colspan="7"><font size="+1"><strong>: </strong><%=carr_tdesc%></font></td>
  </tr>
  <tr>
    <td align="left" width="100%" colspan="2"><font size="+1"><strong>Total General</strong></font></td>
    <td align="left" width="100%" colspan="7"><font size="+1"><strong>: </strong><%=total%></font></td>
  </tr>
  <tr>
    <td align="left" width="100%" colspan="2"><font size="+1"><strong>Total Titulados</strong></font></td>
    <td align="left" width="100%" colspan="3"><font size="+1"><strong>: </strong><%=total_titulados%></font></td>
    <td align="left" width="100%" colspan="2"><font size="+1"><strong>Total Egresados</strong></font></td>
    <td align="left" width="100%" colspan="2"><font size="+1"><strong>: </strong><%=total_egresados%></font></td>
  </tr>
  <tr>
    <td align="left" width="100%" colspan="2"><font size="+1"><strong>Total Activos</strong></font></td>
    <td align="left" width="100%" colspan="3"><font size="+1"><strong>: </strong><%=total_activos%></font></td>
    <td align="left" width="100%" colspan="2"><font size="+1"><strong>Actualmente Matriculados</strong></font></td>
    <td align="left" width="100%" colspan="2"><font size="+1"><strong>: </strong><%=total_actuales%></font></td>
  </tr>
  <tr>
    <td align="center" width="100%" colspan="9"><font size="+2">&nbsp;</font> </td>
  </tr>
  <tr>
    <td  bgcolor="#FFFFCC"><div align="center"><strong>N°</strong></div></td>
    <td  bgcolor="#FFFFCC"><div align="center"><strong>RUT</strong></div></td>
    <td  bgcolor="#FFFFCC"><div align="center"><strong>ALUMNO</strong></div></td>
    <td  bgcolor="#FFFFCC"><div align="center"><strong>FECHA DE NACIMIENTO</strong></div></td>
    <td  bgcolor="#FFFFCC"><div align="center"><strong>SEXO</strong></div></td>
    <td  bgcolor="#FFFFCC"><div align="center"><strong>PAIS</strong></div></td>
    <td  bgcolor="#FFFFCC"><div align="center"><strong>ÚLTIMO AÑO</strong></div></td>
    <td  bgcolor="#FFFFCC"><div align="center"><strong>ÚLTIMO ESTADO</strong></div></td>
    <td  bgcolor="#FFFFCC"><div align="center"><strong>CONDICÍON</strong></div></td>
    <td  bgcolor="#FFFFCC"><div align="center"><strong>OBSERVACÍON</strong></div></td>
    <td  bgcolor="#FFFFCC"><div align="center"><strong>JORNADA</strong></div></td>
    <td  bgcolor="#FFFFCC"><div align="center"><strong>ESPECIALIDAD</strong></div></td>
    <td  bgcolor="#FFFFCC"><div align="center"><strong>AÑO DE INGRESO CARRERA</strong></div></td>
    <td  bgcolor="#FFFFCC"><div align="center"><strong>TIPO DE PRUEBA</strong></div></td>
    <td  bgcolor="#FFFFCC"><div align="center"><strong>AÑO PRUEBA</strong></div></td>
    <td  bgcolor="#FFFFCC"><div align="center"><strong>PRUEBA VERBAL</strong></div></td>
    <td  bgcolor="#FFFFCC"><div align="center"><strong>PRUEBA MATEMATICAS</strong></div></td>
	 <td  bgcolor="#FFFFCC"><div align="center"><strong>PROMEDIO PRUEBAS</strong></div></td>
    <td  bgcolor="#FFFFCC"><div align="center"><strong>PROMEDIO ENS.MEDIA</strong></div></td>
	  <td  bgcolor="#FFFFCC"><div align="center"><strong>TIPO ENSEÑANZA</strong></div></td>
    <td  bgcolor="#FFFFCC"><div align="center"><strong>Nº SEMESTRES CURSADOS</strong></div></td>
    <td  bgcolor="#FFFFCC"><div align="center"><strong>PERIODO EGRESO</strong></div></td>
    <td  bgcolor="#FFFFCC"><div align="center"><strong>PERIODO TITULACIÓN</strong></div></td>
    <td  bgcolor="#FFFFCC"><div align="center"><strong>CON MATRICULA 2005</strong></div></td>
  </tr>
  <% fila = 1  
  while f_cuentas.Siguiente %>
  <tr>
    <td><div align="left"><%=fila%></div></td>
    <td><div align="left"><%=f_cuentas.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_cuentas.ObtenerValor("alumno")%></div></td>
    <td><div align="left"><%=f_cuentas.ObtenerValor("fecha_nacimiento")%></div></td>
    <td><div align="left"><%=f_cuentas.ObtenerValor("sexo")%></div></td>
    <td><div align="left"><%=f_cuentas.ObtenerValor("pais")%></div></td>
    <td><div align="left"><%=f_cuentas.ObtenerValor("ultimo_anio_estudio")%></div></td>
    <td><div align="left"><%=f_cuentas.ObtenerValor("ultimo_estado_registrado")%></div></td>
    <td><div align="left"><%=f_cuentas.ObtenerValor("condicion")%></div></td>
    <td><div align="left"><%=f_cuentas.ObtenerValor("observacion")%></div></td>
    <td><div align="left"><%=f_cuentas.ObtenerValor("jornada")%></div></td>
    <td><div align="left"><%=f_cuentas.ObtenerValor("especialidad")%></div></td>
    <td><div align="left"><%=f_cuentas.ObtenerValor("ano_ingreso")%></div></td>
    <td><div align="left"><%=f_cuentas.ObtenerValor("tipo_prueba")%></div></td>
    <td><div align="left"><%=f_cuentas.ObtenerValor("ano_paa")%></div></td>
    <td><div align="left"><%=f_cuentas.ObtenerValor("puntaje_verbal")%></div></td>
    <td><div align="left"><%=f_cuentas.ObtenerValor("puntaje_matematicas")%></div></td>
    <td><div align="left"><%=f_cuentas.ObtenerValor("promedio_prueba")%></div></td>
	<td><div align="left"><%=f_cuentas.ObtenerValor("promedio_media")%></div></td>
	 <td><div align="left"><%=f_cuentas.ObtenerValor("tipo_ensenanza")%></div></td>
    <td><div align="center"><%=f_cuentas.ObtenerValor("cantidad_semestres_registrado")%></div></td>
    <td><div align="left"><%=f_cuentas.ObtenerValor("periodo_egreso")%></div></td>
    <td><div align="left"><%=f_cuentas.ObtenerValor("periodo_titulacion")%></div></td>
    <td><div align="center"><%=f_cuentas.ObtenerValor("matricula_2005")%></div></td>
  </tr>
  <% fila= fila + 1 
    wend %>
</table>
</body>
</html>
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.Form()
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

Response.AddHeader "Content-Disposition", "attachment;filename=listado_alumnos_por estado.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 150000
set pagina = new CPagina
pagina.Titulo = "Listado de Alumnos"

set conexion = new CConexion
conexion.Inicializar "upacifico"
carrera =request.Form("busqueda[0][carr_ccod]")
periodo =request.Form("busqueda[0][peri_ccod]")
emat_ccod =request.Form("busqueda[0][emat_ccod]")

emat_tdesc = conexion.consultaUno("select emat_tdesc from estados_matriculas where cast(emat_ccod as varchar)='"&emat_ccod&"'")
'response.End()
if not esVacio(carrera) then
    
	filtro= " and cast(f.carr_ccod as varchar)='"&carrera&"'"
else
	filtro=" "	
end if

set negocio = new CNegocio
negocio.Inicializa conexion

if not esvacio(periodo) then
	filtro_periodo=" and cast(c.peri_ccod as varchar)='"&periodo&"'"
else
    peri= negocio.obtenerPeriodoAcademico("POSTULACION")
	anos_ccod=conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri&"'")
	'anos_ccod="2005"
    filtro_anio= " join periodos_Academicos pea on c.peri_ccod = pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&anos_ccod&"'"	
end if
'peri_ccod = negocio.ObtenerPeriodoAcademico("Postulacion")

usuario = negocio.obtenerUsuario
pers_ncorr_administrativo = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")
autoriza_puntaje = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end  from sis_roles_usuarios where cast(pers_ncorr as varchar)='"&pers_ncorr_administrativo&"' and srol_ncorr=42")
'-----------------------------------------------------------------------------------------------
set f_listado = new CFormulario
f_listado.Carga_Parametros "consulta.xml", "consulta" 'carga el xml
f_listado.Inicializar conexion 'inicializo conexion

consulta =  " select distinct cast(a.pers_nrut as varchar)+'-'+ a.pers_xdv as rut,isnull(a.pers_temail,'No ingresado') as email, "& vbCrLf &_
		    "   a.pers_tape_paterno  as AP_Paterno, a.pers_tape_materno  as AP_Materno, a.pers_tnombre as nombre,protic.trunc(a.pers_fnacimiento) as fecha_nacimiento, "& vbCrLf &_
			"   case a.sexo_ccod when 1 then 'Masculino' when 2  then 'Femenino' else 'Sin Seleccionar' end as sexo,datediff(year,a.pers_fnacimiento,getDate()) as edad, "& vbCrLf &_
			"   case pos.tpad_ccod when 1 then 'P.A.A' when 2 then 'P.S.U' else '--' end as tipo_prueba, "& vbCrLf &_
			"   case when  cast((isnull(pos.post_npaa_verbal,0) + isnull(pos.post_npaa_matematicas,0)) / 2 as decimal(6,3)) < 475 then 'Ingreso Especial' else cast( isnull(cast(pos.post_npaa_verbal as varchar),'--')as varchar) end as puntaje_verbal, "& vbCrLf &_
			"   case when  cast((isnull(pos.post_npaa_verbal,0) + isnull(pos.post_npaa_matematicas,0)) / 2 as decimal(6,3)) < 475 then 'Ingreso Especial' else cast( isnull(cast(pos.post_npaa_matematicas as varchar),'--') as varchar) end as puntaje_matematicas, "& vbCrLf &_
			"   case when  cast((isnull(pos.post_npaa_verbal,0) + isnull(pos.post_npaa_matematicas,0)) / 2 as decimal(6,3)) < 475 then 'Ingreso Especial' else cast(cast((isnull(pos.post_npaa_verbal,0) + isnull(pos.post_npaa_matematicas,0)) / 2 as decimal(6,3)) as varchar) end as promedio_prueba,pos.POST_NANO_PAA as ano_paa,  "
consulta = consulta & "   protic.obtener_direccion_letra(a.pers_ncorr,1,'CNPB') as dire_particular, "
consulta = consulta & "   isnull(cast(pos.post_nano_paa as varchar),'--') as ano_rindio_prueba,isnull(pos.post_tinstitucion_anterior,'--') as institucion_anterior, "& vbCrLf &_
			"   pai.pais_tdesc as pais,e.carr_ccod as cod_carrera,f.carr_tdesc as Carrera,e.espe_tdesc as especialidad,pl.plan_tdesc as plan_est,case c.post_bnuevo when 'N' then 'ANTIGUO' else 'NUEVO' end as tipo, "& vbCrLf &_
			"   g.jorn_tdesc as jornada ,h.sede_tdesc as sede,protic.ano_ingreso_carrera (a.pers_ncorr,e.carr_ccod) as ano_ingreso,isnull(cast(protic.PROMEDIO_MEDIA(a.pers_ncorr) as varchar),'') as promedio_media, "& vbCrLf &_
			"   i.dire_tfono as telefono_particular,j.ciud_tdesc as comuna_particular,j.ciud_tcomuna as ciudad_particular,reg.regi_tdesc as region_particular, "& vbCrLf &_
			"   protic.obtener_direccion_letra(a.pers_ncorr,2,'CNPB')  as dire_academica, "& vbCrLf &_
			"   dire2.dire_tfono as telefono_academica,ciud2.ciud_tdesc as comuna_academica,ciud2.ciud_tcomuna as ciudad_academica, "& vbCrLf &_
			"   isnull(k.cole_tdesc,a.pers_tcole_egreso) as nombre_colegio, isnull(l.ciud_tdesc,'--') as comuna_colegio, isnull(l.ciud_tcomuna,'--') as ciudad_colegio, isnull(m.tcol_tdesc,'--') as tipo_colegio, a.pers_nano_egr_media as ano_egreso, "& vbCrLf &_
			"   isnull(case tip_ens.tens_ccod when 4 then a.pers_ttipo_ensenanza else tip_ens.tens_tdesc end,'--') as tipo_ensenanza, "& vbCrLf &_
			"   emat.emat_tdesc as estado_academico, protic.trunc(cont.cont_fcontrato) as fecha_matricula,protic.trunc(d.audi_fmodificacion) as fecha_modificacion,"& vbCrLf &_
			"   (select top 1 isnull(oema_tobservacion,'--') from observaciones_estado_matricula om where om.matr_ncorr = d.matr_ncorr) as observacion, "& vbCrLf &_
   			"	(select top 1 isnull(om2.eoma_tdesc,'--') from observaciones_estado_matricula om1,estado_observaciones_matriculas om2 where om1.matr_ncorr = d.matr_ncorr and om1.eoma_ccod = om2.eoma_ccod ) as condicion, "& vbCrLf &_
			"	cast(pers2.pers_nrut as varchar)+'-'+pers2.pers_xdv as rut_codeudor, pers2.pers_tnombre + ' ' +pers2.pers_tape_paterno + ' ' + pers2.pers_tape_materno  as codeudor, protic.trunc(pers2.pers_fnacimiento) as fecha_nacimiento_codeudor, protic.obtener_direccion_letra(pers2.pers_ncorr,1,'CNPB')  as direccion_codeudor,protic.obtener_direccion_letra(pers2.pers_ncorr,1,'C-C')  as ciudad_codeudor"
    		consulta = consulta & " from personas_postulante a join alumnos d "& vbCrLf &_
			"        on a.pers_ncorr = d.pers_ncorr  "& vbCrLf &_
			"    join ofertas_academicas c "& vbCrLf &_
			"        on c.ofer_ncorr = d.ofer_ncorr   "& vbCrLf &_
			"    "&filtro_anio& vbCrLf &_
			"    left outer join tipos_ensenanza_media tip_ens "& vbCrLf &_
			"        on a.tens_ccod = tip_ens.tens_ccod    "& vbCrLf &_
			"    join postulantes pos "& vbCrLf &_
			"        on pos.post_ncorr = d.post_ncorr "& vbCrLf &_
			"    join paises pai "& vbCrLf &_
			"        on pai.pais_ccod = isnull(a.pais_ccod,0) "& vbCrLf &_
			"    left outer join colegios k "& vbCrLf &_
			"        on a.cole_ccod = k.cole_ccod   "& vbCrLf &_
			"    join especialidades e "& vbCrLf &_
			"        on c.espe_ccod  = e.espe_ccod "& vbCrLf &_
			"    left outer join planes_estudio pl "& vbCrLf &_
			"        on d.plan_ccod = pl.plan_ccod "& vbCrLf &_
			"    join carreras f "& vbCrLf &_
			"        on e.carr_ccod=f.carr_ccod "& filtro & vbCrLf &_
			"    join jornadas g "& vbCrLf &_
			"        on c.jorn_ccod=g.jorn_ccod "& vbCrLf &_
			"    join sedes h "& vbCrLf &_
			"        on c.sede_ccod=h.sede_ccod "& vbCrLf &_
			"    left outer join direcciones i "& vbCrLf &_
			"        on a.pers_ncorr = i.pers_ncorr  "& vbCrLf &_
			"    left outer join direcciones dire2 "& vbCrLf &_
			"        on a.pers_ncorr = dire2.pers_ncorr    and 2 = dire2.tdir_ccod "& vbCrLf &_
			"    left outer join ciudades j "& vbCrLf &_
			"        on i.ciud_ccod = j.ciud_ccod "& vbCrLf &_
			"    left outer join regiones reg "& vbCrLf &_
			"        on j.regi_ccod = reg.regi_ccod  "& vbCrLf &_
			"    left outer join ciudades ciud2 "& vbCrLf &_
			"        on dire2.ciud_ccod = ciud2.ciud_ccod    "& vbCrLf &_
			"    left outer join ciudades l "& vbCrLf &_
			"        on k.ciud_ccod = l.ciud_ccod "& vbCrLf &_
			"    left outer join tipos_colegios m "& vbCrLf &_
			"        on k.tcol_ccod = m.tcol_ccod "& vbCrLf &_
			"    join contratos cont"& vbCrLf &_
			"        on d.matr_ncorr = cont.matr_ncorr and d.post_ncorr = cont.post_ncorr "& vbCrLf &_
			"    join estados_matriculas emat "& vbCrLf &_
			"        --on emat.emat_ccod = (select top 1 emat_ccod from alumnos a1, ofertas_academicas o1 where a1.pers_ncorr=d.pers_ncorr and a1.ofer_ncorr=o1.ofer_ncorr and o1.espe_ccod = c.espe_ccod order by o1.peri_ccod desc, convert(datetime,a1.audi_fmodificacion) desc) "& vbCrLf &_
			" 		on d.emat_ccod = emat.emat_ccod "& vbCrLf &_
			"	 left outer join codeudor_postulacion copo "& vbCrLf &_
			"        on pos.post_ncorr = copo.post_ncorr "& vbCrLf &_
			"    left outer join personas_postulante pers2"& vbCrLf &_
			"        on copo.pers_ncorr = pers2.pers_ncorr "& vbCrLf &_
			" where cont.econ_ccod = 1 "& vbCrLf &_
			" --and d.emat_ccod in (1,4,8) "& vbCrLf &_
			" and i.tdir_ccod = 1 "& vbCrLf &_
			" "& filtro_periodo & vbCrLf &_
			" and exists (select 1 from contratos cont1, compromisos comp1 where d.post_ncorr=cont1.post_ncorr and d.matr_ncorr=cont1.matr_ncorr and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2) ) "
			


'---------------------------------------agregamos los filtros adicionales a la consulta---------------------------------------------------------

if emat_tdesc <> "" then
	consulta = consulta & " and emat.emat_tdesc ='"&emat_tdesc&"'"
else
	consulta = consulta & " and d.emat_ccod not in(9) "
end if

if ingreso_especial = "" then
	if min_puntaje <> "" then
		consulta = consulta & " and cast((isnull(pos.post_npaa_verbal,0) + isnull(pos.post_npaa_matematicas,0)) / 2 as decimal(6,3)) >= '"&min_puntaje&"'"
	end if
	
	if max_puntaje <> "" then
		consulta = consulta & " and cast((isnull(pos.post_npaa_verbal,0) + isnull(pos.post_npaa_matematicas,0)) / 2 as decimal(6,3)) <= '"&max_puntaje&"'"
	end if
else
	consulta = consulta & " and cast((isnull(pos.post_npaa_verbal,0) + isnull(pos.post_npaa_matematicas,0)) / 2 as decimal(6,3)) < '475'"
end if
	 
consulta = consulta & " group by a.pers_ncorr, e.carr_ccod, c.peri_ccod,a.pers_nrut,a.pers_xdv, a.pers_tnombre,a.pers_tape_paterno, "& vbCrLf &_
			"         a.pers_tape_materno,a.pers_fnacimiento,d.matr_ncorr,f.carr_tdesc,c.post_bnuevo,d.alum_fmatricula,g.jorn_tdesc,h.sede_tdesc, "& vbCrLf &_
			"         i.dire_tcalle,pai.pais_tdesc,i.dire_tnro,i.dire_tpoblacion,i.dire_tblock,i.dire_tfono,j.ciud_tdesc,j.ciud_tcomuna, "& vbCrLf &_
			"         dire2.dire_tcalle,dire2.dire_tnro,dire2.dire_tpoblacion,dire2.dire_tblock,dire2.dire_tfono,e.espe_tdesc,pl.plan_tdesc, "& vbCrLf &_
			"         ciud2.ciud_tdesc,ciud2.ciud_tcomuna,k.cole_tdesc,l.ciud_tdesc,l.ciud_tcomuna,a.pers_nnota_ens_media, reg.regi_tdesc,"& vbCrLf &_
			"         m.tcol_tdesc,a.pers_nano_egr_media,a.sexo_ccod,pos.tpad_ccod,pos.post_npaa_verbal,pos.POST_NANO_PAA, "& vbCrLf &_
			"         pos.post_npaa_matematicas,pos.post_nano_paa,pos.post_tinstitucion_anterior,a.pers_tcole_egreso,a.pers_ttipo_ensenanza,tip_ens.tens_ccod,tens_tdesc,"& vbCrLf &_
			"         emat.emat_tdesc,cont.cont_fcontrato, d.audi_fmodificacion,c.espe_ccod,d.pers_ncorr,a.pers_fnacimiento,a.sexo_ccod,"& vbCrLf &_
			"		  pers2.pers_ncorr,pers2.pers_nrut,pers2.pers_xdv,a.pers_temail,pers2.pers_tnombre,pers2.pers_tape_paterno,pers2.pers_tape_materno,pers2.pers_fnacimiento"& vbCrLf &_
			" order by sede,carrera,AP_Paterno,AP_Materno,Nombre"

'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_listado.Consultar consulta 'este hace la pega
'response.write(consulta)
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<script language="JavaScript">
</script>

</head>
<body>

<br>
<%if autoriza_puntaje="S" then 
	cantidad_columnas = 13
 else
    cantidad_columnas = 10
 end if		
%>

<table width="100%" border="1" cellpadding="0" cellspacing="0">
  <tr>
  	<td colspan="17" bgcolor="#FFFFCC"><div align="center"><strong>INFORMACIÓN ALUMNO</strong></div></td>
  	<td colspan="13" bgcolor="#FFFFCC"><div align="center"><strong>INFORMACIÓN DE LA MATRICULA</strong></div></td>
  	<td colspan="<%=cantidad_columnas%>" bgcolor="#FFFFCC"><div align="center"><strong>INFORMACIÓN DE POSTULACIÓN</strong></div></td>
  	<td colspan="5" bgcolor="#FFFFCC"><div align="center"><strong>INFORMACIÓN CODEUDOR</strong></div></td>
	<%if agrega_carga <> "" then%>
		<td colspan="2" bgcolor="#FFFFCC"><div align="center"><strong>DATOS CARGA ACADÉMICA</strong></div></td>
	<%end if%>
	<%if agrega_morosidad <> "" then%>
		<td colspan="1" bgcolor="#FFFFCC"><div align="center"><strong>DATOS MOROSIDAD</strong></div></td>
	<%end if%>
	<%if agrega_documentos <> "" then%>
		<td colspan="7" bgcolor="#FFFFCC"><div align="center"><strong>DOCUMENTOS ENTREGADOS POR MATRICULA</strong></div></td>
	<%end if%>
  </tr>
  <tr>
    <td bgcolor="#FFFFCC"><div align="center"><strong>NUM</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>RUT</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>APELLIDO PATERNO</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>APELLIDO MATERNO</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>NOMBRES</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>FECHA NACIMIENTO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>EDAD</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>SEXO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>PAÍS</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>EMAIL</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>DIRECCIÓN PARTICULAR</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>TELÉFONO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>CIUDAD PARTICULAR</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>REGIÓN PARTICULAR</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>DIRECCIÓN ACADEMICA</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>TELÉFONO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>CIUDAD ACADEMICA</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>TIPO ALUMNO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>ESTADO_ACADEMICO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>CONDICIÓN</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>OBSERVACIÓN</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>FECHA MATRICULA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>FECHA MODIFICACION</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>COD. CARRERA</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>CARRERA</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="left"><strong>SEDE</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>JORNADA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>ESPECIALIDAD</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>AÑO INGRESO CARRERA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>PLAN DE ESTUDIO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>COLEGIO EGRESO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>AÑO EGRESO</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>TIPO PRUEBA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>VERBAL</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>MATEMÁTICAS</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>PROMEDIO PRUEBA</strong></div></td>
	<%if autoriza_puntaje="S" then%>
	<td bgcolor="#FFFFCC"><div align="center"><strong>VERBAL REAL</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>MATEMÁTICAS REAL </strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>PROMEDIO PRUEBA REAL</strong></div></td>
	<%end if%>
	<td bgcolor="#FFFFCC"><div align="center"><strong>AÑO PRUEBA</strong></div></td>
    <td bgcolor="#FFFFCC"><div align="center"><strong>PROMEDIO ENS. MEDIA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>PROCEDENCIA EDUCACIÓN</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>TIPO ENSEÑANZA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>RUT CODEUDOR</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>NOMBRE CODEUDOR</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>FECHA NACIMIENTO CODEUDOR</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>DIRECCIÓN CODEUDOR</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>CIUDAD CODEUDOR</strong></div></td>
	<%if agrega_carga <> "" then%>
	<td bgcolor="#FFFFCC"><div align="left"><strong>CON CARGA TOMADA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="left"><strong>CANTIDAD DE ASIGNATURAS</strong></div></td>
	<%end if%>
	<%if agrega_morosidad <> "" then%>
	<td bgcolor="#FFFFCC"><div align="left"><strong>MOROSO</strong></div></td>
	<%end if%>
	<%if agrega_documentos <> "" then%>
	<td bgcolor="#FFFFCC"><div align="center"><strong>CED. IDENTIDAD/CED. PAÍS DE ORIGEN/PASAPORTE</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>LICENCIA ENSEÑANZA MEDIA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>CONCENTRACIÓN DE NOTAS ENS. MEDIA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>PUNTAJE P.A.A. / P.S.U.</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>02 FOTOGRAFÍAS TAM. CARNET, NOMBRE/RUT</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>CERTIFICADO DE RESIDENCIA</strong></div></td>
	<td bgcolor="#FFFFCC"><div align="center"><strong>SEGURO DE SALUD (EXTRANJEROS)</strong></div></td>
	<%end if%>
  </tr>
  <%NUMERO=1%>
  <%while f_listado.Siguiente%> <!-- mientras hay registro hace-->
  <tr>
    <td><%=NUMERO%></td>
	<td><%=f_listado.ObtenerValor("rut")%></td>
    <td><%=f_listado.ObtenerValor("AP_PATERNO")%></td>
    <td><%=f_listado.ObtenerValor("AP_MATERNO")%></td>
    <td><%=f_listado.ObtenerValor("nombre")%></td>
	<td><%=f_listado.ObtenerValor("fecha_nacimiento")%></td>
	<td><%=f_listado.ObtenerValor("edad")%></td>
	<td><%=f_listado.ObtenerValor("sexo")%></td>
	<td><%=f_listado.ObtenerValor("pais")%></td>
	<td><%=f_listado.ObtenerValor("email")%></td>
	<td><%=f_listado.ObtenerValor("dire_particular")%></td>
	<td><%=f_listado.ObtenerValor("telefono_particular")%></td>
	<td><%=f_listado.ObtenerValor("comuna_particular")%> , <%=f_listado.ObtenerValor("ciudad_particular")%></td>
	<td><%=f_listado.ObtenerValor("region_particular")%></td>
	<td><%=f_listado.ObtenerValor("dire_academica")%></td>
	<td><%=f_listado.ObtenerValor("telefono_academica")%></td>
	<td><%=f_listado.ObtenerValor("comuna_academica")%> , <%=f_listado.ObtenerValor("ciudad_academica")%></td>
	<td><%=f_listado.ObtenerValor("tipo")%></td>
	<td bgcolor="#FFFFCC"><%=f_listado.ObtenerValor("estado_academico")%></td>
	<td><%=f_listado.ObtenerValor("condicion")%></td>
	<td><%=f_listado.ObtenerValor("observacion")%></td>
	<td><%=f_listado.ObtenerValor("fecha_matricula")%></td>
	<td><%=f_listado.ObtenerValor("fecha_modificacion")%></td>
	<td><%=f_listado.ObtenerValor("cod_carrera")%></td>
	<td><%=f_listado.ObtenerValor("carrera")%></td>
	<td><%=f_listado.ObtenerValor("sede")%></td>
	<td><%=f_listado.ObtenerValor("jornada")%></td>
	<td><%=f_listado.ObtenerValor("especialidad")%></td>
	<td><%=f_listado.ObtenerValor("ano_ingreso")%></td>
	<td><%=f_listado.ObtenerValor("plan_est")%></td>
	<td><%=f_listado.ObtenerValor("nombre_colegio")%> <%=f_listado.ObtenerValor("comuna_colegio")%>, <%=f_listado.ObtenerValor("ciudad_colegio")%></td>
	<td><%=f_listado.ObtenerValor("ano_egreso")%></td>
	<td><%=f_listado.ObtenerValor("tipo_prueba")%></td>
	<td><%=f_listado.ObtenerValor("puntaje_verbal")%></td>
	<td><%=f_listado.ObtenerValor("puntaje_matematicas")%></td>
	<td><%=f_listado.ObtenerValor("promedio_prueba")%></td>
	<%if autoriza_puntaje="S" then%>
	<td><%=f_listado.ObtenerValor("puntaje_verbal_real")%></td>
	<td><%=f_listado.ObtenerValor("puntaje_matematicas_real")%></td>
	<td><%=f_listado.ObtenerValor("promedio_prueba_real")%></td>
	<%end if%>
	<td><%=f_listado.ObtenerValor("ano_paa")%></td>
	<td><%=f_listado.ObtenerValor("promedio_media")%></td>
	<td><%=f_listado.ObtenerValor("tipo_colegio")%></td>
	<td><%=f_listado.ObtenerValor("tipo_ensenanza")%></td>
	<td><%=f_listado.ObtenerValor("rut_codeudor")%></td>
	<td><%=f_listado.ObtenerValor("codeudor")%></td>
	<td><%=f_listado.ObtenerValor("fecha_nacimiento_codeudor")%></td>
	<td><%=f_listado.ObtenerValor("direccion_codeudor")%></td>
	<td><%=f_listado.ObtenerValor("ciudad_codeudor")%></td>
	<%if agrega_carga <> "" then%>
	<td><%=f_listado.ObtenerValor("con_carga")%></td>
	<td><%=f_listado.ObtenerValor("cant_asignaturas")%></td>
	<%end if%>
	<%if agrega_morosidad <> "" then%>
	<td><%=f_listado.ObtenerValor("es_moroso")%></td>
	<%end if%>
	<%if agrega_documentos <> "" then%>
	<td align="center"><%=f_listado.ObtenerValor("Ced_identidad")%></td>
	<td align="center"><%=f_listado.ObtenerValor("Lic_Enseñanza_Media")%></td>
	<td align="center"><%=f_listado.ObtenerValor("Conc_de_notas_Enseñanza_Media")%></td>
	<td align="center"><%=f_listado.ObtenerValor("Puntaje_PSU")%></td>
	<td align="center"><%=f_listado.ObtenerValor("Fotografias")%></td>
	<td align="center"><%=f_listado.ObtenerValor("Certificado_Residencia")%></td>
	<td align="center"><%=f_listado.ObtenerValor("Seguro_Salud")%></td>
	<%end if%>
  </tr>
   <%NUMERO=NUMERO+1%>
  <%wend%>
</table>
</body>
</html>

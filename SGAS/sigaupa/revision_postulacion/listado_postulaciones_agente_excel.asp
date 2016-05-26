<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=listado_postulantes_agente.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

periodo=negocio.obtenerPeriodoAcademico("Postulacion")
pers_ncorr_agente = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&negocio.obtenerUsuario&"'")
rut_agente = conexion.consultaUno("select cast(pers_nrut as varchar)+ '-'+ pers_xdv from personas where cast(pers_nrut as varchar)='"&negocio.obtenerUsuario&"'")
peri_tdesc = conexion.consultaUno("select protic.initCap(peri_tdesc) from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
nombre_agente = conexion.consultaUno("select protic.initcap(Pers_tnombre + ' ' + pers_tape_paterno + ' ' +pers_tape_materno) from personas where cast(pers_nrut as varchar)='"&negocio.obtenerUsuario&"'")

set formulario = new CFormulario
formulario.Carga_Parametros "tabla_vacia.xml", "tabla"
formulario.Inicializar conexion

if rut_agente = "17176569-2" then
	filtro  = "" 'para que la Isa vea todos los alumnos
	filtro2 = "" 'no restringe por sede
	filtro2011 = ""
else
	filtro  = " and cast(a.pers_ncorr as varchar)='"&pers_ncorr_agente&"' "
	filtro2 = " and dd.sede_ccod = a.sede_ccod "
	filtro2011  = " and cast(a.pers_ncorr_agente as varchar)='"&pers_ncorr_agente&"' "
end if

consulta = " select distinct cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, pers_tfono,pers_tcelular, "& vbcrlf & _
		   " c.pers_tnombre + ' ' +c.pers_tape_paterno + ' ' + c.pers_tape_materno as alumno,fecha_ingreso, protic.trunc(fecha_ingreso) as ingresado, "& vbcrlf & _
		   " (select count(*) from postulantes_por_agente bb where bb.post_ncorr=b.post_ncorr) as total_agentes,   "& vbcrlf & _
		   " (select count(*) from detalle_postulantes bb where bb.post_ncorr=b.post_ncorr) as total_carreras, "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end from observaciones_postulacion bb,ofertas_academicas dd where bb.ofer_ncorr=dd.ofer_ncorr and bb.post_ncorr=b.post_ncorr "&filtro2&") as gestionado, "& vbcrlf & _
		   " (select max(bb.audi_fmodificacion) from observaciones_postulacion bb,ofertas_academicas dd where bb.ofer_ncorr=dd.ofer_ncorr and bb.post_ncorr=b.post_ncorr "&filtro2&" ) as ultima_modificacion, "& vbcrlf & _
		   " (select top 1 eopo_tdesc from observaciones_postulacion bb,estado_observaciones_postulacion cc, ofertas_academicas dd "& vbcrlf & _
		   "  where bb.post_ncorr=b.post_ncorr and bb.eopo_ccod=cc.eopo_ccod and bb.ofer_ncorr=dd.ofer_ncorr "&filtro2&" order by bb.audi_fmodificacion desc) as ultimo_estado, "& vbcrlf & _
		   " (select top 1 obpo_tobservacion from observaciones_postulacion bb, ofertas_academicas dd where bb.ofer_ncorr=dd.ofer_ncorr and bb.post_ncorr=b.post_ncorr "&filtro2&"  order by bb.audi_fmodificacion desc) as ultimo_comentario "& vbcrlf & _
		   " from postulantes_por_agente a, postulantes b, personas_postulante c "& vbcrlf & _
		   " where a.post_ncorr=b.post_ncorr and b.pers_ncorr=c.perS_ncorr "& vbcrlf & _
		   " " & filtro & vbcrlf & _
		   " and not exists (select 1 from alumnos cc where cc.post_ncorr=b.post_ncorr) "

consulta = " select rut,pers_tfono,pers_tcelular,alumno,fecha_ingreso,ingresado,total_agentes,total_carreras, "& vbcrlf & _
		   " gestionado,ultima_modificacion,ultima_entrevista,horario_test,ultimo_estado,ultimo_comentario,completada, "& vbcrlf & _
		   " case when total_carreras = 1 and max_estado = 2 then '<font color=''#2d5bc7''><strong>'+table2.eepo_tdesc+'</strong></font>' "& vbcrlf & _
		   "      when total_carreras = 1 and max_estado = 7 then '<font color=''#0ea02f''><strong>'+table2.eepo_tdesc+'</strong></font>' "& vbcrlf & _
		   "      when total_carreras = 1 and max_estado = 3 then '<font color=''#ffffff''><strong>'+table2.eepo_tdesc+'</strong></font>' "& vbcrlf & _
		   "      when total_carreras = 1 then '<font color=''#000000''><strong>'+table2.eepo_tdesc+'</strong></font>' "& vbcrlf & _
		   " else '' end as estado_postulacion, "& vbcrlf & _
		   " case when total_carreras = 1 and max_estado = 3 then 'bgcolor=''#f54415''' "& vbcrlf & _
		   " else 'bgcolor=''#FFFFFF''' end as color,calle,comuna, verbal, mate, cast((verbal + mate) / 2 as decimal(5,2)) as ponderado "& vbcrlf & _
		   " from "& vbcrlf & _
		   " ( "& vbcrlf & _
		   "  select distinct cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, pers_tfono,pers_tcelular, case b.epos_ccod when 1 then 'NO' else 'COMPLETADA' end as completada, "& vbcrlf & _
		   "  c.pers_tnombre + ' ' +c.pers_tape_paterno + ' ' + c.pers_tape_materno as alumno,fecha_ingreso, protic.trunc(fecha_ingreso) as ingresado,  "& vbcrlf & _
		   " (select count(*) from postulantes_por_agente bb where bb.post_ncorr=b.post_ncorr) as total_agentes,    "& vbcrlf & _
		   " (select count(*) from detalle_postulantes bb where bb.post_ncorr=b.post_ncorr) as total_carreras,  "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end from observaciones_postulacion bb,ofertas_academicas dd where bb.ofer_ncorr=dd.ofer_ncorr and bb.post_ncorr=b.post_ncorr  "&filtro2&" ) as gestionado,  "& vbcrlf & _
		   " (select max(bb.audi_fmodificacion) from observaciones_postulacion bb,ofertas_academicas dd where bb.ofer_ncorr=dd.ofer_ncorr and bb.post_ncorr=b.post_ncorr  "&filtro2&"  ) as ultima_modificacion,  "& vbcrlf & _
		   " (select top 1 protic.trunc(bb.fecha_entrevista) from observaciones_postulacion bb,ofertas_academicas dd where bb.ofer_ncorr=dd.ofer_ncorr and bb.post_ncorr=b.post_ncorr  and dd.sede_ccod = a.sede_ccod order by fecha_entrevista desc ) as ultima_entrevista,  "& vbcrlf & _
		   " (select top 1 htes_hinicio from observaciones_postulacion bb,ofertas_academicas dd, horarios_test ee where bb.ofer_ncorr=dd.ofer_ncorr and bb.post_ncorr=b.post_ncorr and bb.htes_ccod=ee.htes_ccod and dd.sede_ccod = a.sede_ccod order by fecha_entrevista desc ) as horario_test, "& vbcrlf & _
		   " (select top 1 eopo_tdesc from observaciones_postulacion bb,estado_observaciones_postulacion cc, ofertas_academicas dd  "& vbcrlf & _
		   "  where bb.post_ncorr=b.post_ncorr and bb.eopo_ccod=cc.eopo_ccod and bb.ofer_ncorr=dd.ofer_ncorr  "&filtro2&"  order by bb.audi_fmodificacion desc) as ultimo_estado,  "& vbcrlf & _
		   " (select top 1 obpo_tobservacion from observaciones_postulacion bb, ofertas_academicas dd where bb.ofer_ncorr=dd.ofer_ncorr and bb.post_ncorr=b.post_ncorr  "&filtro2&"   order by bb.audi_fmodificacion desc) as ultimo_comentario, "& vbcrlf & _
		   " (select max(eepo_ccod) from detalle_postulantes tt,ofertas_academicas dd where tt.post_ncorr=b.post_ncorr and tt.ofer_ncorr=dd.ofer_ncorr "&filtro2&") as max_estado,  "& vbcrlf & _
		   " protic.obtener_direccion_letra(c.pers_ncorr,1,'CNPB') as calle,protic.obtener_direccion_letra(c.pers_ncorr,1,'C-C') as comuna,"& vbcrlf & _
		   " (select max(post_npaa_verbal) from postulantes tt where tt.pers_ncorr=b.pers_ncorr and tt.peri_ccod=b.peri_ccod) as verbal ,"& vbcrlf & _
		   " (select max(post_npaa_matematicas) from postulantes tt where tt.pers_ncorr=b.pers_ncorr and tt.peri_ccod=b.peri_ccod) as mate "& vbcrlf & _
		   " from postulantes_por_agente a, postulantes b, personas_postulante c "& vbcrlf & _
		   " where a.post_ncorr=b.post_ncorr and b.pers_ncorr=c.pers_ncorr and cast(b.peri_ccod as varchar)='"&periodo&"'"& vbcrlf & _
		   " " & filtro & vbcrlf & _
		   "  and not exists (select 1 from alumnos cc where cc.post_ncorr=b.post_ncorr)  "& vbcrlf & _
		   " )table1, estado_examen_postulantes table2 "& vbcrlf & _
		   " where isnull(table1.max_estado,1) = table2.eepo_ccod"		   

if periodo > "222" then
consulta = " select rut,pers_tfono,pers_tcelular,alumno,fecha_ingreso,ingresado,total_agentes,total_carreras, "& vbcrlf & _
		   " gestionado,ultima_modificacion,ultima_entrevista,horario_test,ultimo_estado,ultimo_comentario,completada, "& vbcrlf & _
		   " case when total_carreras = 1 and max_estado = 2 then '<font color=''#2d5bc7''><strong>'+table2.eepo_tdesc+'</strong></font>' "& vbcrlf & _
		   "      when total_carreras = 1 and max_estado = 7 then '<font color=''#0ea02f''><strong>'+table2.eepo_tdesc+'</strong></font>' "& vbcrlf & _
		   "      when total_carreras = 1 and max_estado = 3 then '<font color=''#ffffff''><strong>'+table2.eepo_tdesc+'</strong></font>' "& vbcrlf & _
		   "      when total_carreras = 1 then '<font color=''#000000''><strong>'+table2.eepo_tdesc+'</strong></font>' "& vbcrlf & _
		   " else '' end as estado_postulacion, "& vbcrlf & _
		   " case when total_carreras = 1 and max_estado = 3 then 'bgcolor=''#f54415''' "& vbcrlf & _
		   " else 'bgcolor=''#FFFFFF''' end as color,calle,comuna, verbal, mate, cast((verbal + mate) / 2 as decimal(5,2)) as ponderado "& vbcrlf & _
		   " from "& vbcrlf & _
		   " ( "& vbcrlf & _
		   "  select distinct cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, pers_tfono,pers_tcelular, case b.epos_ccod when 1 then 'NO' else 'COMPLETADA' end as completada, "& vbcrlf & _
		   "  c.pers_tnombre + ' ' +c.pers_tape_paterno + ' ' + c.pers_tape_materno as alumno,fecha_ingreso, protic.trunc(fecha_ingreso) as ingresado,  "& vbcrlf & _
		   " (select count(*) from admi_postulantes_por_agente bb where bb.pers_ncorr=b.pers_ncorr and bb.peri_ccod=b.peri_ccod) as total_agentes,    "& vbcrlf & _
		   " (select count(*) from detalle_postulantes bb where bb.post_ncorr=b.post_ncorr) as total_carreras,  "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end from observaciones_postulacion bb,ofertas_academicas dd where bb.ofer_ncorr=dd.ofer_ncorr and bb.post_ncorr=b.post_ncorr ) as gestionado,  "& vbcrlf & _
		   " (select max(bb.audi_fmodificacion) from observaciones_postulacion bb,ofertas_academicas dd where bb.ofer_ncorr=dd.ofer_ncorr and bb.post_ncorr=b.post_ncorr ) as ultima_modificacion,  "& vbcrlf & _
		   " (select top 1 protic.trunc(bb.fecha_entrevista) from observaciones_postulacion bb,ofertas_academicas dd where bb.ofer_ncorr=dd.ofer_ncorr and bb.post_ncorr=b.post_ncorr  order by fecha_entrevista desc ) as ultima_entrevista,  "& vbcrlf & _
		   " (select top 1 htes_hinicio from observaciones_postulacion bb,ofertas_academicas dd, horarios_test ee where bb.ofer_ncorr=dd.ofer_ncorr and bb.post_ncorr=b.post_ncorr and bb.htes_ccod=ee.htes_ccod order by fecha_entrevista desc ) as horario_test, "& vbcrlf & _
		   " (select top 1 eopo_tdesc from observaciones_postulacion bb,estado_observaciones_postulacion cc, ofertas_academicas dd  "& vbcrlf & _
		   "  where bb.post_ncorr=b.post_ncorr and bb.eopo_ccod=cc.eopo_ccod and bb.ofer_ncorr=dd.ofer_ncorr order by bb.audi_fmodificacion desc) as ultimo_estado,  "& vbcrlf & _
		   " (select top 1 obpo_tobservacion from observaciones_postulacion bb, ofertas_academicas dd where bb.ofer_ncorr=dd.ofer_ncorr and bb.post_ncorr=b.post_ncorr  order by bb.audi_fmodificacion desc) as ultimo_comentario, "& vbcrlf & _
		   " (select max(eepo_ccod) from detalle_postulantes tt,ofertas_academicas dd where tt.post_ncorr=b.post_ncorr and tt.ofer_ncorr=dd.ofer_ncorr ) as max_estado,  "& vbcrlf & _
		   " protic.obtener_direccion_letra(c.pers_ncorr,1,'CNPB') as calle,protic.obtener_direccion_letra(c.pers_ncorr,1,'C-C') as comuna,"& vbcrlf & _
		   " (select max(post_npaa_verbal) from postulantes tt where tt.pers_ncorr=b.pers_ncorr and tt.peri_ccod=b.peri_ccod) as verbal ,"& vbcrlf & _
		   " (select max(post_npaa_matematicas) from postulantes tt where tt.pers_ncorr=b.pers_ncorr and tt.peri_ccod=b.peri_ccod) as mate "& vbcrlf & _
		   " from admi_postulantes_por_agente a, postulantes b, personas_postulante c "& vbcrlf & _
		   " where a.pers_ncorr=b.pers_ncorr and a.peri_ccod=b.peri_ccod and b.pers_ncorr=c.pers_ncorr and cast(b.peri_ccod as varchar)='"&periodo&"'"& vbcrlf & _
		   " "& filtro2011 & vbcrlf & _
		   " and not exists (select 1 from alumnos cc where cc.post_ncorr=b.post_ncorr)  "& vbcrlf & _
		   " )table1, estado_examen_postulantes table2 "& vbcrlf & _
		   " where isnull(table1.max_estado,1) = table2.eepo_ccod"
end if

'response.Write("<pre>"&consulta&"</pre>")
'response.End()
if rut_agente = "6289563-2" or rut_agente = "12863241-7" then ' para mostrar a Susana Arancibia los postulados a magister
consulta = " select distinct c.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbcrlf & _
		   " c.pers_tnombre + ' ' +c.pers_tape_paterno + ' ' + c.pers_tape_materno as alumno,b.post_fpostulacion as fecha_ingreso, protic.trunc(b.post_fpostulacion) as ingresado, "& vbcrlf & _
		   " '1' as total_agentes,   "& vbcrlf & _
		   " (select count(*) from detalle_postulantes bb where bb.post_ncorr=b.post_ncorr) as total_carreras, "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end from observaciones_postulacion bb,ofertas_academicas cc where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr) as gestionado, "& vbcrlf & _
		   " (select protic.trunc(max(bb.audi_fmodificacion)) from observaciones_postulacion bb,ofertas_academicas cc where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr) as ultima_modificacion "& vbcrlf & _
		   " from postulantes b, personas_postulante c, detalle_postulantes d, ofertas_academicas e "& vbcrlf & _
		   " where b.pers_ncorr=c.pers_ncorr and cast(b.peri_ccod as varchar)='"&periodo&"'"& vbcrlf & _
		   " and b.post_ncorr=d.post_ncorr and d.ofer_ncorr=e.ofer_ncorr and cast(e.espe_ccod as varchar)='349' " & vbcrlf & _
		   " and not exists (select 1 from alumnos cc where cc.post_ncorr=b.post_ncorr) "
elseif rut_agente = "6939582-1"	then ' para mostrar a Sonia Soler los postulados a magister
consulta = " select distinct c.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbcrlf & _
		   " c.pers_tnombre + ' ' +c.pers_tape_paterno + ' ' + c.pers_tape_materno as alumno,b.post_fpostulacion as fecha_ingreso, protic.trunc(b.post_fpostulacion) as ingresado, "& vbcrlf & _
		   " '1' as total_agentes,   "& vbcrlf & _
		   " (select count(*) from detalle_postulantes bb where bb.post_ncorr=b.post_ncorr) as total_carreras, "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end from observaciones_postulacion bb,ofertas_academicas cc where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr) as gestionado, "& vbcrlf & _
		   " (select protic.trunc(max(bb.audi_fmodificacion)) from observaciones_postulacion bb,ofertas_academicas cc where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr) as ultima_modificacion "& vbcrlf & _
		   " from postulantes b, personas_postulante c, detalle_postulantes d, ofertas_academicas e "& vbcrlf & _
		   " where b.pers_ncorr=c.pers_ncorr and cast(b.peri_ccod as varchar)='"&periodo&"'"& vbcrlf & _
		   " and b.post_ncorr=d.post_ncorr and d.ofer_ncorr=e.ofer_ncorr and e.espe_ccod in ('351','18') " & vbcrlf & _
		   " and not exists (select 1 from alumnos cc where cc.post_ncorr=b.post_ncorr) "
elseif rut_agente = "14461680-4"	then ' para mostrar a PATRICK LAUREAU  los postulados a magister
consulta = " select distinct c.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbcrlf & _
		   " c.pers_tnombre + ' ' +c.pers_tape_paterno + ' ' + c.pers_tape_materno as alumno,b.post_fpostulacion as fecha_ingreso, protic.trunc(b.post_fpostulacion) as ingresado, "& vbcrlf & _
		   " '1' as total_agentes,   "& vbcrlf & _
		   " (select count(*) from detalle_postulantes bb where bb.post_ncorr=b.post_ncorr) as total_carreras, "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end from observaciones_postulacion bb,ofertas_academicas cc where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr) as gestionado, "& vbcrlf & _
		   " (select protic.trunc(max(bb.audi_fmodificacion)) from observaciones_postulacion bb,ofertas_academicas cc where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr) as ultima_modificacion "& vbcrlf & _
		   " from postulantes b, personas_postulante c, detalle_postulantes d, ofertas_academicas e "& vbcrlf & _
		   " where b.pers_ncorr=c.pers_ncorr and cast(b.peri_ccod as varchar)='"&periodo&"'"& vbcrlf & _
		   " and b.post_ncorr=d.post_ncorr and d.ofer_ncorr=e.ofer_ncorr and e.espe_ccod in ('350') " & vbcrlf & _
		   " and not exists (select 1 from alumnos cc where cc.post_ncorr=b.post_ncorr) "
elseif rut_agente = "11592558-K"	then ' para mostrar a Marco Perelli  los postulados a todos los postgrados
consulta = " select distinct c.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbcrlf & _
		   " c.pers_tnombre + ' ' +c.pers_tape_paterno + ' ' + c.pers_tape_materno as alumno,b.post_fpostulacion as fecha_ingreso, protic.trunc(b.post_fpostulacion) as ingresado, "& vbcrlf & _
		   " '1' as total_agentes,   "& vbcrlf & _
		   " (select count(*) from detalle_postulantes bb where bb.post_ncorr=b.post_ncorr) as total_carreras, "& vbcrlf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end from observaciones_postulacion bb,ofertas_academicas cc where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr) as gestionado, "& vbcrlf & _
		   " (select protic.trunc(max(bb.audi_fmodificacion)) from observaciones_postulacion bb,ofertas_academicas cc where bb.ofer_ncorr=cc.ofer_ncorr and bb.post_ncorr=b.post_ncorr) as ultima_modificacion "& vbcrlf & _
		   " from postulantes b, personas_postulante c, detalle_postulantes d, ofertas_academicas e "& vbcrlf & _
		   " where b.pers_ncorr=c.pers_ncorr and cast(b.peri_ccod as varchar)='"&periodo&"'"& vbcrlf & _
		   " and b.post_ncorr=d.post_ncorr and d.ofer_ncorr=e.ofer_ncorr and e.espe_ccod in ('349','350','351','18') " & vbcrlf & _
		   " and not exists (select 1 from alumnos cc where cc.post_ncorr=b.post_ncorr) "		   
end if
		  
'response.Write("<pre>"&consulta & " order by gestionado, fecha_ingreso desc </pre>")
'response.End()
cantidad_encontrados = conexion.consultaUno("select count(*) from ("&consulta&")a")	   
formulario.Consultar consulta & " order by gestionado, fecha_ingreso desc"


fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Listado Postulantes asociados al agente</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado de Postulantes Asociados al agente</font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Rut agente</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=rut_agente%></td>
   </tr>
   <tr> 
    <td width="16%"><strong>Nombre</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=nombre_agente%></td>
   </tr>
  <tr> 
    <td width="16%"><strong>Fecha</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=fecha%></td>
   </tr>
   <tr> 
    <td width="16%"><strong>Período</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=peri_tdesc%></td>
   </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
   <tr> 
    <td bgcolor="#FFCC99"><div align="center"><strong>Nº</strong></div></td>
	<td bgcolor="#FFCC99"><div align="left"><strong>Rut</strong></div></td>
    <td bgcolor="#FFCC99"><div align="left"><strong>Nombre Alumno</strong></div></td>
	<td bgcolor="#FFCC99"><div align="left"><strong>Teléfono</strong></div></td>
	<td bgcolor="#FFCC99"><div align="left"><strong>Celular</strong></div></td>
    <td bgcolor="#FFCC99"><div align="Center"><strong>Ingresado el día</strong></div></td>
	<td bgcolor="#FFCC99"><div align="Center"><strong>Estado postulación</strong></div></td>
	<td bgcolor="#FFCC99"><div align="left"><strong>Total Agentes</strong></div></td>
    <td bgcolor="#FFCC99"><div align="left"><strong>Total Carreras</strong></div></td>
	<td bgcolor="#FFCC99"><div align="left"><strong>Gestionado</strong></div></td>
	<td bgcolor="#FFCC99"><div align="left"><strong>Última Gestión</strong></div></td>
	<td bgcolor="#FFCC99"><div align="left"><strong>Última Entrevista Agendada</strong></div></td>
	<td bgcolor="#FFCC99"><div align="left"><strong>Estado</strong></div></td>
	<td bgcolor="#FFCC99"><div align="left"><strong>Comentario</strong></div></td>
	<td bgcolor="#FFCC99"><div align="Center"><strong>Ficha completada</strong></div></td>
	<td bgcolor="#FFCC99"><div align="left"><strong>Dirección</strong></div></td>
	<td bgcolor="#FFCC99"><div align="Center"><strong>Comuna</strong></div></td>
	<td bgcolor="#FFCC99"><div align="Center"><strong>Puntaje Verbal</strong></div></td>
	<td bgcolor="#FFCC99"><div align="center"><strong>Puntaje Matemáticas</strong></div></td>
	<td bgcolor="#FFCC99"><div align="Center"><strong>Puntaje Ponderado</strong></div></td>
  </tr>
  <% fila = 1   
     while formulario.Siguiente %>

  <tr> 
    <td <%=formulario.ObtenerValor("color")%>><div align="center"><%=fila%></div></td>
    <td <%=formulario.ObtenerValor("color")%>><div align="center"><%=formulario.ObtenerValor("rut")%></div></td>
    <td <%=formulario.ObtenerValor("color")%>><div align="center"><%=formulario.ObtenerValor("alumno")%></div></td>
	<td <%=formulario.ObtenerValor("color")%>><div align="center"><%=formulario.ObtenerValor("pers_tfono")%></div></td>
	<td <%=formulario.ObtenerValor("color")%>><div align="center"><%=formulario.ObtenerValor("pers_tcelular")%></div></td>
    <td <%=formulario.ObtenerValor("color")%>><div align="center"><%=formulario.ObtenerValor("ingresado")%></div></td>
	<td <%=formulario.ObtenerValor("color")%>><div align="center"><%=formulario.ObtenerValor("estado_postulacion")%></div></td>
    <td <%=formulario.ObtenerValor("color")%>><div align="center"><%=formulario.ObtenerValor("total_agentes")%></div></td>
	<td <%=formulario.ObtenerValor("color")%>><div align="center"><%=formulario.ObtenerValor("total_carreras")%></div></td>
	<td <%=formulario.ObtenerValor("color")%>><div align="center"><%=formulario.ObtenerValor("gestionado")%></div></td>
	<td <%=formulario.ObtenerValor("color")%>><div align="center"><%=formulario.ObtenerValor("ultima_modificacion")%></div></td>
	<td <%=formulario.ObtenerValor("color")%>><div align="center"><%=formulario.ObtenerValor("ultima_entrevista")%>&nbsp;<%=formulario.ObtenerValor("horario_test")%></div></td>
	<td <%=formulario.ObtenerValor("color")%>><div align="center"><%=formulario.ObtenerValor("ultimo_estado")%></div></td>
	<td <%=formulario.ObtenerValor("color")%>><div align="center"><%=formulario.ObtenerValor("ultimo_comentario")%></div></td>
	<td <%=formulario.ObtenerValor("color")%>><div align="center"><%=formulario.ObtenerValor("completada")%></div></td>
	<td <%=formulario.ObtenerValor("color")%>><div align="center"><%=formulario.ObtenerValor("calle")%></div></td>
	<td <%=formulario.ObtenerValor("color")%>><div align="center"><%=formulario.ObtenerValor("comuna")%></div></td>
	<td <%=formulario.ObtenerValor("color")%>><div align="center"><%=formulario.ObtenerValor("verbal")%></div></td>
	<td <%=formulario.ObtenerValor("color")%>><div align="center"><%=formulario.ObtenerValor("mate")%></div></td>
	<td <%=formulario.ObtenerValor("color")%>><div align="center"><%=formulario.ObtenerValor("ponderado")%></div></td>
  </tr>
  <% fila = fila + 1  
  wend %>
</table>
</p> 

</body>
</html>
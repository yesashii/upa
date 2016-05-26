<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=listado_alumnos_extranjeros.xls"
Response.ContentType = "application/vnd.ms-excel"

'	for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next
'	response.End()

anos_ccod =Request.form("b[0][anos_ccod]")
peri_ccod =Request.form("b[0][peri_ccod]")
carr_ccod =Request.form("b[0][carr_ccod]")
univ_ccod =Request.form("b[0][univ_ccod]")
pais_ccod =Request.form("b[0][pais_ccod]")
facu_ccod =Request.form("b[0][facu_ccod]")
anos_ccod_fin =Request.form("b[0][anos_ccod_fin]")
'response.End()
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

filtro_doc=""

'**********************OK
if  peri_ccod <>""  then
filtro_doc=filtro_doc&" and (select top 1 ff.peri_ccod from ofertas_academicas cc,periodos_Academicos ff, alumnos aa where cast(aa.pers_ncorr as varchar)= a.pers_ncorr and aa.ofer_ncorr = cc.ofer_ncorr and cc.peri_ccod  = ff.peri_ccod)="&peri_ccod&""
end if

'**********************OK
if  carr_ccod <>"" then
filtro_doc=filtro_doc&" and (select top 1 ee.carr_ccod from alumnos aa (nolock), detalle_postulantes bb, ofertas_academicas cc, especialidades dd,carreras ee where cast(aa.pers_ncorr as varchar)= a.pers_ncorr and aa.post_ncorr = bb.post_ncorr and bb.ofer_ncorr = cc.ofer_ncorr and cc.espe_ccod  = dd.espe_ccod and dd.carr_ccod  = ee.carr_ccod order by cc.peri_ccod desc)="&carr_ccod&""
end if

if univ_ccod<>"" then
filtro_doc=filtro_doc&" and e.univ_ccod="&univ_ccod&""
end if
 '********************OK 
if pais_ccod<>"" then
filtro_doc=filtro_doc&" and f.pais_ccod="&pais_ccod&""
end if

'********************OK
if facu_ccod = "1" then
filtro_doc=filtro_doc&" and (select top 1 ee.carr_ccod from alumnos aa (nolock), detalle_postulantes bb, ofertas_academicas cc, especialidades dd,carreras ee where cast(aa.pers_ncorr as varchar)= a.pers_ncorr and aa.post_ncorr = bb.post_ncorr and bb.ofer_ncorr = cc.ofer_ncorr and cc.espe_ccod  = dd.espe_ccod and dd.carr_ccod  = ee.carr_ccod order by cc.peri_ccod desc) in (51)"
end if
if facu_ccod = "2" then
filtro_doc=filtro_doc&" and (select top 1 ee.carr_ccod from alumnos aa (nolock), detalle_postulantes bb, ofertas_academicas cc, especialidades dd,carreras ee where cast(aa.pers_ncorr as varchar)= a.pers_ncorr and aa.post_ncorr = bb.post_ncorr and bb.ofer_ncorr = cc.ofer_ncorr and cc.espe_ccod  = dd.espe_ccod and dd.carr_ccod  = ee.carr_ccod order by cc.peri_ccod desc) in (17,21,22)"
end if
if facu_ccod = "3" then
filtro_doc=filtro_doc&" and (select top 1 ee.carr_ccod from alumnos aa (nolock), detalle_postulantes bb, ofertas_academicas cc, especialidades dd,carreras ee where cast(aa.pers_ncorr as varchar)= a.pers_ncorr and aa.post_ncorr = bb.post_ncorr and bb.ofer_ncorr = cc.ofer_ncorr and cc.espe_ccod  = dd.espe_ccod and dd.carr_ccod  = ee.carr_ccod order by cc.peri_ccod desc) in (14,32,41,45,47,800,970)"
end if
if facu_ccod = "4" then
filtro_doc=filtro_doc&" and (select top 1 ee.carr_ccod from alumnos aa (nolock), detalle_postulantes bb, ofertas_academicas cc, especialidades dd,carreras ee where cast(aa.pers_ncorr as varchar)= a.pers_ncorr and aa.post_ncorr = bb.post_ncorr and bb.ofer_ncorr = cc.ofer_ncorr and cc.espe_ccod  = dd.espe_ccod and dd.carr_ccod  = ee.carr_ccod order by cc.peri_ccod desc) in (43,860,880,950,870,49)"
end if
if facu_ccod = "8" then
filtro_doc=filtro_doc&" and (select top 1 ee.carr_ccod from alumnos aa (nolock), detalle_postulantes bb, ofertas_academicas cc, especialidades dd,carreras ee where cast(aa.pers_ncorr as varchar)= a.pers_ncorr and aa.post_ncorr = bb.post_ncorr and bb.ofer_ncorr = cc.ofer_ncorr and cc.espe_ccod  = dd.espe_ccod and dd.carr_ccod  = ee.carr_ccod order by cc.peri_ccod desc) in (830,840,850,108)"
end if


if  anos_ccod <>""  then

set anos_periodo = new CFormulario
anos_periodo.Carga_Parametros "genera_informe.xml", "tabla" 
anos_periodo.Inicializar conexion

anos_p="select min(peri_ccod) as anos_peri from periodos_academicos where anos_ccod ="&anos_ccod&""

anos_periodo.Consultar anos_p

'******OBTENER PRIMER VALOR********
anos_periodo.siguiente
anos_perio_a = anos_periodo.obtenervalor("anos_peri")

end if

if  anos_ccod_fin <>""  then

set anos_periodo = new CFormulario
anos_periodo.Carga_Parametros "genera_informe.xml", "tabla" 
anos_periodo.Inicializar conexion

anos_p="select max(peri_ccod)-1 as anos_peri_fin from periodos_academicos where anos_ccod ="&anos_ccod_fin&""

anos_periodo.Consultar anos_p

'******OBTENER PRIMER VALOR********
anos_periodo.siguiente
anos_perio_b = anos_periodo.obtenervalor("anos_peri_fin")

end if


if  anos_ccod_fin <>"" and anos_ccod_fin <>""  then
filtro_doc=filtro_doc&" and (select top 1 anos_ccod from ofertas_academicas cc,periodos_Academicos ff, alumnos aa where cast(aa.pers_ncorr as varchar)= a.pers_ncorr and aa.ofer_ncorr = cc.ofer_ncorr and cc.peri_ccod  = ff.peri_ccod) BETWEEN "&anos_perio_a&" AND "&anos_perio_b&""
end if
'**********************************************************************************
set f_resumen_convenio = new CFormulario
f_resumen_convenio.Carga_Parametros "tabla_vacia.xml", "tabla" 
f_resumen_convenio.Inicializar conexion

sql_descuentos="select protic.obtener_rut(a.pers_ncorr) as rut,pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,a.pers_ncorr,"& vbCrLf &_
"pais_tdesc,ciex_tdesc,univ_tdesc,pa.peri_tdesc,"& vbCrLf &_
"e.univ_ccod,c.peri_ccod,f.pais_ccod,c.carr_ccod,(select top 1 carr_tdesc from alumnos aa (nolock), detalle_postulantes bb, ofertas_academicas cc, especialidades dd,carreras ee "& vbCrLf &_
"where cast(aa.pers_ncorr as varchar)= a.pers_ncorr and aa.post_ncorr = bb.post_ncorr and bb.ofer_ncorr = cc.ofer_ncorr and cc.espe_ccod  = dd.espe_ccod and dd.carr_ccod  = ee.carr_ccod"& vbCrLf &_
"order by cc.peri_ccod desc) as carrera,"& vbCrLf &_
"(select top 1 lower(email_nuevo) from cuentas_email_upa tt where tt.pers_ncorr=a.pers_ncorr) as email_upa,"& vbCrLf &_
"pers_temail as email_personal"& vbCrLf &_
"from personas a join (select pers_ncorr from alumnos where matr_ncorr in ("& vbCrLf &_
"    select matr_ncorr from alumnos  where emat_ccod=16"& vbCrLf &_
"    union"& vbCrLf &_
"    select matr_ncorr from alumnos  where talu_ccod in (2,3)"& vbCrLf &_
") and emat_ccod not in (9,6)"& vbCrLf &_
"and talu_ccod in (3)) as b"& vbCrLf &_
"    on a.pers_ncorr=b.pers_ncorr"& vbCrLf &_
"left outer join rrii_postulacion_alumnos_intercambio_extranjero c"& vbCrLf &_
"    on a.PERS_NCORR=c.PERS_NCORR"& vbCrLf &_
"left outer join universidad_ciudad d"& vbCrLf &_
"    on c.unci_ncorr=d.unci_ncorr"& vbCrLf &_
"left outer join universidades e"& vbCrLf &_
"    on d.univ_ccod=e.univ_ccod"& vbCrLf &_
"left outer join ciudades_extranjeras g"& vbCrLf &_
"    on d.ciex_ccod=g.ciex_ccod"& vbCrLf &_
"left outer join paises f"& vbCrLf &_
"    on a.pais_ccod = f.pais_ccod "& vbCrLf &_
"left outer join periodos_academicos pa"& vbCrLf &_
"    on c.peri_ccod = pa.PERI_CCOD "& vbCrLf &_
"and c.peri_ccod = pa.PERI_CCOD"& vbCrLf &_
"where 0 = 0"& vbCrLf &_
""&filtro_doc&""

'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.End()

f_resumen_convenio.Consultar sql_descuentos

%>
<html>
<head>
<title><%=pagina.Titulo%></title>  

</head>
<body bgcolor="#ffffff" leftmargin="43" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="100%" border="1">
 
  <tr>
	<td width="26%" bgcolor="#99CC33"><div align="center"><strong>Rut</strong></div></td>
	<td width="26%" bgcolor="#99CC33"><div align="center"><strong>Nombre</strong></div></td>
	<td width="26%" bgcolor="#99CC33"><div align="center"><strong>Email Upa</strong></div></td>
    <td width="26%" bgcolor="#99CC33"><div align="center"><strong>Email Personal</strong></div></td>
    <td width="23%" bgcolor="#99CC33"><div align="center"><strong>Carrera UPA</strong></div></td>
    <td width="23%" bgcolor="#99CC33"><div align="center"><strong>Universidad Procedencia</strong></div></td>
	<td width="17%" bgcolor="#99CC33"><div align="center"><strong>Ciudad Procedencia</strong></div></td>
	<td width="19%" bgcolor="#99CC33"><div align="center"><strong>Pais Procedencia</strong></div></td>			    <td width="15%" bgcolor="#99CC33"><div align="center"><strong>Periodo Academico</strong></div></td>  
  </tr>
  <%  while f_resumen_convenio.Siguiente %>
  <tr> 
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("rut")%></div></td>
    <td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("nombre")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("email_upa")%></div></td>
    <td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("email_personal")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("carr_Tdesc")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("univ_tdesc")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("ciex_tdesc")%></div></td>
    <td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("pais_tdesc")%></div></td>
    <td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("peri_tdesc")%></div></td>    
  </tr>
  <%  wend %>
</table>
</html>
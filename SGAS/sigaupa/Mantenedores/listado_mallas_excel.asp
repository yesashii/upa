<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=mallas_curriculares.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_peri_ccod=negocio.obtenerPeriodoAcademico("Postulacion")
'-----------------------------------------------------------------------
nombre_carrera=request.Form("carr")
nombre_especialidad=request.Form("espe")
nombre_plan=request.Form("planes2")

carr_ccod=request.Form("cod_carrera")
espe_ccod=request.Form("cod_especialidad")
plan_ccod=request.Form("cod_planes")
'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"adm_mallas_curriculares3.xml",	"tabla_conv"
tabla.inicializar		conexion

sede_ccod = negocio.ObtenerSede
sede = negocio.ObtenerSede
'response.End()
tablas=" select distinct " & _
		" b.nive_ccod as nivel, b.mall_ccod,b.plan_ccod as plan_ccod, c.espe_ccod as espe_ccod " & _
		" ,a.asig_ccod as asig_ccod, a.asig_tdesc as asignatura ,a.asig_nhoras as asig_nhoras,e.carr_ccod as carr_ccod,f.duas_tdesc as regimen,  " & _
		" isnull(g.cred_valor,0) as creditos "&_
        " from asignaturas a join malla_curricular b "&_
		"    on a.asig_ccod = b.asig_ccod "&_
		" join planes_estudio c "&_
		"    on b.plan_ccod=c.plan_ccod "&_
		" join  especialidades e "&_
		"    on e.ESPE_CCOD=c.ESPE_CCOD "&_
		" join  duracion_asignatura f "&_
		"    on a.duas_ccod=f.duas_ccod "&_
		" left outer join creditos_asignatura g "&_
		"    on a.cred_ccod = g.cred_ccod   "&_
		" where cast(b.plan_ccod as varchar)= '"&plan_ccod&"' " & _
		" and cast(c.espe_ccod as varchar)= '"&espe_ccod&"' " & _
		" order by b.nive_ccod,a.asig_ccod "
		

nro_niveles=conexion.consultauno("select max(nivel) from (select distinct " & _
		" b.nive_ccod as nivel, b.mall_ccod,b.plan_ccod as plan_ccod, c.espe_ccod as espe_ccod " & _
		" ,a.asig_ccod as asig_ccod, a.asig_tdesc as asignatura ,a.asig_nhoras as asig_nhoras " & _		
		" from asignaturas a " & _
		" , malla_curricular b " & _
		" , planes_estudio c " & _
		" where a.asig_ccod = b.asig_ccod " & _
		" and b.plan_ccod=c.plan_ccod " & _
		" and cast(b.plan_ccod as varchar)= '"&plan_ccod&"' " & _
		" and cast(c.espe_ccod as varchar)= '"&espe_ccod&"' " & _
		" )s")
		
		
MaxNiveles=nro_niveles
set fo 		= 		new cFormulario
fo.carga_parametros	"adm_mallas_curriculares3.xml",	"tabla_conv"
fo.inicializar		conexion
fo.consultar 		tablas

'response.End()
set asignatura = new cformulario
asignatura.carga_parametros "adm_mallas_curriculares3.xml","tabla"
asignatura.inicializar conexion		
asignatura.consultar tablas
	if asignatura.nroFilas > 0 then
		redim asig_ccod(asignatura.nroFilas)
		for k=0 to asignatura.nroFilas-1
			asignatura.siguiente
			asig_ccod(k)= asignatura.obtenerValor("asig_ccod")
		next
	end if
'response.End()
set requisito = new cformulario
requisito.carga_parametros "adm_mallas_curriculares3.xml","tabla"
requisito.inicializar conexion		
requisito.consultar tablas
'response.End()
set req = new cformulario
req.carga_parametros "adm_mallas_curriculares3.xml","tabla"
		
for j=0 to asignatura.nroFilas-1
	requisito="SELECT distinct M1.ASIG_CCOD as asig_ccod, substring(t.TREQ_TDESC,1,3) as tipo " & _
		  " FROM REQUISITOS R, MALLA_CURRICULAR M1, MALLA_CURRICULAR M2, tipos_requisito t, planes_estudio p " & _
		  " WHERE R.MALL_CREQUISITO = M1.MALL_CCOD " & _
		  " AND R.MALL_CCOD = M2.MALL_CCOD " & _
		  " and r.TREQ_CCOD = t.TREQ_CCOD " & _
		  " and cast(m2.asig_ccod as varchar)= '" & asig_ccod(j) & "' " & _
		  " and m2.plan_ccod = p.plan_ccod " & _
		  " and cast(m2.plan_ccod as varchar)= '"&plan_ccod&"' " & _
		  " and cast(p.espe_ccod as varchar)= '" & espe_ccod & "' "
	req.Inicializar conexion
	req.consultar requisito
	if req.nrofilas > 0 then
		req_tipo = ""
		for kk=0 to req.nrofilas-1
			req.siguiente
			req_tipo = req_tipo & " " & req.ObtenerValor("asig_ccod") & " - " &req.obtenervalor("tipo")&"<br>" 
		next
		fo.agregaCampoFilaCons j, "requisito", req_tipo
	else
		fo.agregaCampoFilaCons j, "requisito", "--"
	end if
next



fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
num_resolucion = conexion.consultaUno("select plan_nresolucion from planes_estudio where cast(plan_ccod as varchar)='"&plan_ccod&"'")

%>
<html>
<head>
<title>Mallas Curriculares</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Mallas Curriculares</font></div>
	<div align="right"><%=fecha%></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Carrera</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <% =nombre_carrera%> </td>
    
  </tr>
  <tr> 
    <td><strong>Especialidad</strong></td>
    <td colspan="3"><strong>:</strong> <%=nombre_especialidad %> </td>
  </tr>
  <tr>
    <td><strong>Plan</strong></td>
    <td colspan="3"> <strong>:</strong> <%=nombre_plan%></td>
 </tr>
 <tr>
    <td><strong>Resolución</strong></td>
    <td colspan="3"> <strong>:</strong> <%=num_resolucion%></td>
 </tr>
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="3%"><div align="center"><strong>Nivel</strong></div></td>
    <td width="7%"><div align="center"><strong>Código</strong></div></td>
    <td width="25%"><div align="center"><strong>Asignatura</strong></div></td>
	<td width="5%"><div align="center"><strong>Horas</strong></div></td>
	<td width="5%"><div align="center"><strong>Créditos</strong></div></td>
    <td width="25%"><div align="center"><strong>Requisitos</strong></div></td>
	 <td width="10%"><div align="center"><strong>Regimen</strong></div></td>
  </tr>
  <%  while fo.Siguiente %>
  <tr> 
    <td><div align="center"><%=fo.ObtenerValor("nivel")%></div></td>
    <td><div align="center"><%=fo.ObtenerValor("asig_ccod")%></div></td>
    <td><div align="center"><%=fo.ObtenerValor("asignatura")%></div></td>
    <td><div align="center"><%=fo.ObtenerValor("asig_nhoras")%></div></td>
    <td><div align="center"><%=fo.ObtenerValor("creditos")%></div></td>
    <td><div align="center"><%=fo.ObtenerValor("requisito")%></div></td>
	<td><div align="center"><%=fo.ObtenerValor("regimen")%></div></td>
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>
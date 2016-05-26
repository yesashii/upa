<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=listado_docentes_mensuales.xls"
Response.ContentType = "application/vnd.ms-excel"

set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

sede = request.QueryString("sede")
grado = request.QueryString("grado")
periodo = request.QueryString("periodo")


tituloPag = "Listado docentes "




set docentes = new cformulario
docentes.carga_parametros "tabla_vacia.xml","tabla"
docentes.inicializar conectar

plec_ccod = conectar.consultaUno("select plec_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")

if plec_ccod = "2" then
	anos_ccod = conectar.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
	primer_periodo = conectar.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod = 1")
	filtro_periodo = "and cast(a.peri_ccod as varchar) = case g.duas_ccod when 3 then '"&primer_periodo&"' else '"&periodo&"' end "
else 
	filtro_periodo = "and cast(a.peri_ccod as varchar) = '"&periodo&"'"	
end if

if sede <> "" then
	filtro_sede= " and cast(a.sede_ccod as varchar)= '"&sede&"'"
	con_sede = " and hdc.sede_ccod= a.sede_ccod"
	campos = " c.pers_ncorr,a.sede_ccod "
else
	filtro_sede= ""	
	con_sede = " "
	campos = " c.pers_ncorr"
end if


if grado = 5 then
titulo = " Listado de docentes con grado académico Doctor"

consulta_Cantidad = " select e.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, "&vbCrLf &_
					" sede_tdesc as sede, carr_tdesc as carrera, ltrim(rtrim(asi.asig_ccod)) + ' ' + asig_tdesc as asignatura, se.secc_tdesc as seccion, "&vbCrLf &_
					" isnull(cast((horas / case asi.duas_ccod when 1 then 3 when 2 then 5 when 3 then 10 end  * 45 / 60) as decimal(4,1)),0) as horas  "&vbCrLf &_
					" from (select distinct "&campos&vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, carreras f,asignaturas g   "&vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod   "&filtro_sede&vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) "&vbCrLf &_
					" and d.egra_ccod in (1,3) and tpro_ccod=1  "&vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and f.tcar_ccod = 1 "& filtro_periodo &vbCrLf &_
					" )a, horas_docentes_seccion_final hdc, asignaturas asi,personas e,secciones se,sedes sd, carreras car "&vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr and hdc.asig_ccod = asi.asig_ccod "&vbCrLf &_
					" and hdc.pers_ncorr=e.pers_ncorr and hdc.secc_ccod=se.secc_ccod "&vbCrLf &_
					" and se.sede_ccod=sd.sede_ccod and se.carr_ccod = car.carr_ccod "&con_sede&vbCrLf &_
					" and isnull(cast((horas / case asi.duas_ccod when 1 then 3 when 2 then 5 when 3 then 10 end  * 45 / 60) as decimal(4,1)),0) > 0 "
        

elseif grado = 4  then
titulo = " Listado de docentes con grado académico Magister"
consulta_Cantidad = "  select e.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, " &vbCrLf &_
					"  sede_tdesc as sede, carr_tdesc as carrera, ltrim(rtrim(asi.asig_ccod)) + ' ' + asig_tdesc as asignatura, se.secc_tdesc as seccion, " &vbCrLf &_
					"  isnull(cast((horas / case asi.duas_ccod when 1 then 3 when 2 then 5 when 3 then 10 end  * 45 / 60) as decimal(4,1)),0) as horas  " &vbCrLf &_
					"  from ( select distinct "&campos &vbCrLf &_
					"         from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,carreras f,asignaturas g  " &vbCrLf &_
					"         where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  "&filtro_sede &vbCrLf &_
					"         and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8) and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)  " &vbCrLf &_
					"         and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " &vbCrLf &_
					"         and d.egra_ccod=1 and tpro_ccod=1  " &vbCrLf &_
					"         and a.carr_ccod=f.carr_ccod and f.tcar_ccod = 1 "& filtro_periodo &vbCrLf &_
					" )a, horas_docentes_seccion_final hdc, asignaturas asi,personas e,secciones se,sedes sd, carreras car " &vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr and hdc.asig_ccod = asi.asig_ccod " &vbCrLf &_
					" and hdc.pers_ncorr=e.pers_ncorr and hdc.secc_ccod=se.secc_ccod "&con_sede&vbCrLf &_
					" and se.sede_ccod=sd.sede_ccod and se.carr_ccod = car.carr_ccod " &vbCrLf &_
					" and isnull(cast((horas / case asi.duas_ccod when 1 then 3 when 2 then 5 when 3 then 10 end  * 45 / 60) as decimal(4,1)),0) > 0" 

end if
'--------------------------------------------------------------------------------------------------------------------------
'response.Write("<pre>"&consulta&"</pre>")
sede_tdesc = conectar.consultaUno("select protic.initCap(sede_tdesc) from sedes where cast(sede_ccod as varchar)='"&sede&"'")
sexo_tdesc = conectar.consultaUno("select protic.initCap(sexo_tdesc) from sexos where cast(sexo_ccod as varchar)='"&sexo&"'")

if sede = "" then
sede_tdesc = " Todas las sedes"
end if


'response.Write("<pre>"&consulta_cantidad&" order by nombre</pre>")
docentes.Consultar consulta_cantidad &" order by nombre, sede,carrera"
cantidad_lista= conectar.consultaUno("select count(distinct aa.pers_ncorr) from ("&consulta_cantidad&")aa")
total_horas = conectar.consultaUno("select cast(sum(horas) as decimal(10,2)) from ("&consulta_cantidad&")aa")

%>
<html>
<head>
<title>Listado docentes</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif"><%=titulo%></font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Sede</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%= sede_tdesc%> </td>
    
  </tr>
  <tr> 
    <td height="22"><strong>Total Horas </strong></td>
    <td colspan="3"><strong>:</strong> <%=total_horas %> </td>
  </tr>
  <tr>
    <td><strong>Fecha</strong></td>
    <td colspan="3"> <strong>:</strong> <%=Date%></td>
 </tr>
 <tr>
     <td width="10%"><strong>Total</strong></td>
	 <td colspan="3"> <strong>:</strong> <%=cantidad_lista%> Docente(s)</td>
</tr>
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="3%" bgcolor="#FFFFCC"><div align="center"><strong>N°</strong></div></td>
    <td width="8%" bgcolor="#FFFFCC"><div align="center"><strong>Rut</strong></div></td>
    <td width="15%" bgcolor="#FFFFCC"><div align="center"><strong>Nombre Persona</strong></div></td>
    <td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Sede</strong></div></td>
	<td width="25%" bgcolor="#FFFFCC"><div align="center"><strong>Carrera</strong></div></td>
	<td width="25%" bgcolor="#FFFFCC"><div align="center"><strong>Asignatura</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Sección</strong></div></td>
    <td width="15%" bgColor="#FFFFCC"><div align="center"><strong>Horas Totales</strong></div></td>
  </tr>
  <% fila = 1 
     while docentes.Siguiente %>
  <tr> 
    <td><div align="left"><%=fila%></div></td>
	<td><div align="left"><%=docentes.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=docentes.ObtenerValor("nombre")%></div></td>
    <td><div align="left"><%=docentes.ObtenerValor("sede")%></div></td>
	<td><div align="left"><%=docentes.ObtenerValor("carrera")%></div></td>
	<td><div align="left"><%=docentes.ObtenerValor("asignatura")%></div></td>
	<td><div align="left"><%=docentes.ObtenerValor("seccion")%></div></td>
	<td><div align="center"><%=docentes.ObtenerValor("horas")%></div></td>
  </tr>
  <% fila = fila + 1  
  wend %>
</table>
<div align="right">* Las horas son medidas de forma cronológica &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>
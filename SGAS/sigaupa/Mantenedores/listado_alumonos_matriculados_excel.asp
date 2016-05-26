<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next
'response.End()

emat_ccod 	= 	Request.Form("buscador[0][emat_ccod]")
inicio 		= 	Request.Form("inicio")
termino 	= 	Request.Form("termino")

if inicio  <> "" and termino  <> "" then
emat_ccod = "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16"
end if


Response.AddHeader "Content-Disposition", "attachment;filename=listado_alumnos.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion

consulta="select distinct b.post_ncorr,a.pers_nrut, protic.obtener_rut(a.pers_ncorr) as rut,protic.trunc(isnull(co.cont_fcontrato,i.alum_fmatricula)) as fecha_matricula, " & vbCrLf &_
"a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre, " & vbCrLf &_
"a.pers_tfono as fono, case a.pers_temail when null then '' else ''+a.pers_temail+'' end  as email, " & vbCrLf &_
"'' + j.emat_tdesc +'' as estado, h.sede_tdesc,f.carr_tdesc, g.jorn_tdesc, p.peri_tdesc, case p.PLEC_CCOD when 1 then (case b.post_bnuevo when 'N' then 'ANTIGUO' when 'S' then 'NUEVO'end) when 2 then 'ANTIGUO' end as tipo_alumno " & vbCrLf &_
",i.audi_fmodificacion as fecha_ultimo_estado " & vbCrLf &_
",(select case count(*) when 0 then 'SIN CAE' else 'CON CAE' end from sdescuentos sd where post_ncorr in (select post_ncorr from postulantes where pers_ncorr=a.PERS_NCORR and peri_ccod < p.PERI_CCOD) and sd.STDE_CCOD='1402') as tipo_alumno_cae " & vbCrLf &_
"from   personas_postulante a, postulantes b,ofertas_academicas d,especialidades e,carreras f,jornadas g, sedes h, alumnos i, estados_matriculas j, periodos_academicos p , contratos co" & vbCrLf &_
"where a.pers_ncorr = b.pers_ncorr  " & vbCrLf &_
"and b.ofer_ncorr = d.ofer_ncorr  " & vbCrLf &_
"and d.espe_ccod = e.espe_ccod  " & vbCrLf &_
"and e.carr_ccod = f.carr_ccod  " & vbCrLf &_
"and d.jorn_ccod = g.jorn_ccod  " & vbCrLf &_
"and b.peri_ccod = p.peri_ccod  " & vbCrLf &_
"and d.sede_ccod = h.sede_ccod  " & vbCrLf &_
"and b.epos_ccod = 2            " & vbCrLf &_
"and b.post_ncorr=i.post_ncorr  " & vbCrLf &_
"and b.ofer_ncorr=i.ofer_ncorr  " & vbCrLf &_
"and b.pers_ncorr=i.pers_ncorr  " & vbCrLf &_
"and i.emat_ccod in ("&emat_ccod&")         " & vbCrLf &_
"and i.emat_ccod=j.emat_ccod    " & vbCrLf &_
"and i.MATR_NCORR = co.MATR_NCORR  " & vbCrLf &_
"and  exists (select 1 from alumnos alu where b.post_ncorr=alu.post_ncorr and alu.emat_ccod in ("&emat_ccod&") and isnull(alum_nmatricula,0) <> '7777') " & vbCrLf &_
"and protic.trunc(isnull(co.cont_fcontrato,i.alum_fmatricula)) between  convert(datetime,'"&inicio&"',103) and convert(datetime,'"&termino&"',103) " 
'response.Write("<pre>"&consulta&"</pre>")
tabla.consultar consulta 

'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Listado de Alumnos</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado de Alumnos.</font></div>
	<div align="right"></div></td>
    
  </tr>

</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="3%"><div align="center"><strong>RUT</strong></div></td>
    <td width="15%"><div align="center"><strong>Nombre Alumno</strong></div></td>
    <td width="15%"><div align="center"><strong>Telefono</strong></div></td>
    <td width="15%"><div align="center"><strong>Correo Personal</strong></div></td>
	 <td width="10%"><div align="center"><strong>Sede</strong></div></td>
	<td width="5%"><div align="center"><strong>Carrera</strong></div></td>
    <td width="5%"><div align="center"><strong>Jornada</strong></div></td>
	<td width="5%"><div align="center"><strong>Estado Matricula</strong></div></td>
	<td width="5%"><div align="center"><strong>Fecha Matricula</strong></div></td>
    <td width="5%"><div align="center"><strong>Tipo Alumno</strong></div></td>
	<td width="10%"><div align="center"><strong>Periodo Academico</strong></div></td>
	<td width="10%"><div align="center"><strong>Fecha Ultimo Estado</strong></div></td>
	<td width="10%"><div align="center"><strong>CAE</strong></div></td>
  </tr>
  <%  
  fila=1  
  while tabla.Siguiente %>
  <tr> 
    <td><div align="left"><%=tabla.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("nombre")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("fono")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("email")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("sede_tdesc")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("carr_tdesc")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("jorn_tdesc")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("estado")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("fecha_matricula")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("tipo_alumno")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("peri_tdesc")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("fecha_ultimo_estado")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("tipo_alumno_cae")%></div></td>
  </tr>
  <% fila=fila +1 
   wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>
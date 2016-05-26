<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=detalle_grados_docente.xls"
Response.ContentType = "application/vnd.ms-excel"
'------------------------------------------------------------------------------------
tipo = request.QueryString("tipo")
jornada = request.QueryString("jornada")
carr_ccod = request.QueryString("carr_ccod")
jorn_ccod = request.QueryString("jorn_ccod")
sede = request.QueryString("sede")

set pagina = new CPagina
'------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------------
periodo = negocio.obtenerPeriodoAcademico("Postulacion")

'------------------------------------------------------------------------------------
tituloPag = "Listado de Docentes "

if tipo="5" then 
	tituloPag = tituloPag + " Doctores"
	filtro1 = " and b1.grac_ccod=5 "
	filtro2 = " "
end if	
if tipo="4" then 
	tituloPag = tituloPag + " Magister"
	filtro1 = " and b1.grac_ccod=4"	
	filtro2 = " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod=5) "
end if
if tipo="3" then 
	tituloPag = tituloPag + " Licenciados"
	filtro1 = " and b1.grac_ccod=3"	
	filtro2 = " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (4,5)) "
end if
if tipo="0" then 
	tituloPag = tituloPag + " Sin Grado"
	filtro1 = " and b1.grac_ccod not in (3,4,5) "
	filtro2 = " and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,5)) "
end if	

tituloPag = tituloPag + " con jornada"

if jornada = "1" then 
	tituloPag = tituloPag + " Completa"
	filtro3= " and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') > 31"
end if	
if jornada = "2" then 
	tituloPag = tituloPag + " Media"
	filtro3= " and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') between 20 and 31"
end if	
if jornada = "3"  then 
	tituloPag = tituloPag + " por Horas"
	filtro3= " and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') between 1 and 19"
end if	

nombre_carrera = conexion.consultaUno("Select carr_tdesc from  carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")
jorn_tdesc = conexion.consultaUno("Select jorn_tdesc from jornadas where cast(jorn_ccod as varchar)='"&jorn_ccod&"'")
nombre_sede = conexion.consultaUno("Select sede_tdesc from  sedes where cast(sede_ccod as varchar)='"&sede&"'")
fecha_01 = Date & " " & Time

set f_docentes = new CFormulario
f_docentes.Carga_Parametros "titulos_jornada.xml", "f_docentes_excel"
f_docentes.Inicializar conexion


consulta = " select distinct a1.pers_ncorr, cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbCrLf &_
           " c.pers_tape_paterno as ap_paterno,c.pers_tape_materno as ap_materno,c.pers_tnombre as nombre,"&vbCrLf &_
		   " (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "  where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') as horas"& vbCrLf &_
		   " from carreras_docente a1,grados_profesor b1, personas c "& vbCrLf &_
		   " where cast(a1.carr_ccod as varchar)= '"&carr_ccod&"' and cast(a1.jorn_ccod as varchar)= '"&jorn_ccod&"'"& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr and b1.pers_ncorr=c.pers_ncorr "& vbCrLf &_
		   " " & filtro1 & " "& vbCrLf &_
		   " " & filtro2 & " "& vbCrLf &_
		   " and (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)= '"&jorn_ccod&"'"& vbCrLf &_
		   " " & filtro3 &" order by c.pers_tape_paterno"

'response.Write("<pre>"&sql_cursos&"</pre>")
'response.End()
f_docentes.Consultar consulta
%>
<html>
<head>
<title> listado de docentes </title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
  <tr> 
    <td colspan="6"><div align="center"><strong><%=tituloPag%></strong></div></td>
  </tr>
  <tr> 
    <td colspan="6"><div align="center"><strong>&nbsp;</strong></div></td>
  </tr>
  <tr> 
    <td width="11%"><div align="center"><strong>Sede</strong></div></td>
	<td colspan="5"><div align="left"><strong>:</strong> <%=nombre_sede%></div></td>
  </tr>
  <tr> 
    <td width="11%"><div align="center"><strong>Carrera</strong></div></td>
	<td colspan="5"><div align="left"><strong>:</strong> <%=nombre_carrera%></div></td>
  </tr>
  <tr> 
    <td width="11%"><div align="center"><strong>Jornada</strong></div></td>
	<td colspan="5"><div align="left"><strong>:</strong> <%=jorn_tdesc%></div></td>
  </tr>
  <tr> 
    <td width="11%"><div align="center"><strong>Fecha</strong></div></td>
	<td colspan="5"><div align="left"><strong>:</strong> <%=fecha_01%></div></td>
  </tr>
  <tr> 
    <td colspan="6"><div align="center"><strong>&nbsp;</strong></div></td>
  </tr>
  <tr> 
    <td width="3%"><div align="center"><strong>N°</strong></div></td>
    <td width="8%"><div align="center"><strong>R.U.T.</strong></div></td>
    <td width="15%"><div align="center"><strong>Ap. Paterno</strong></div></td>
    <td width="15%"><div align="center"><strong>Ap. Materno</strong></div></td>
    <td width="15%"><div align="center"><strong>Nombres</strong></div></td>
	<td width="10%"><div align="center"><strong>Horas</strong></div></td>
  </tr>
  <% cantidad = 1 
   while f_docentes.Siguiente %>
  <tr> 
   <td><div align="left"><%=cantidad%></div></td>
    <td><div align="left"><%=f_docentes.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_docentes.ObtenerValor("ap_paterno")%></div></td>
    <td><div align="left"><%=f_docentes.ObtenerValor("ap_materno")%></div></td>
    <td><div align="left"><%=f_docentes.ObtenerValor("nombre")%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("horas")%></div></td>
  </tr>
  <% cantidad= cantidad + 1 
  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>
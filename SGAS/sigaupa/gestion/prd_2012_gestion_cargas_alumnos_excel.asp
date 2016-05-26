<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=listado_alumnos_cargas.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
sede = request.QueryString("sede")
espe_ccod = request.QueryString("espe_ccod")
emat_ccod = request.QueryString("emat_ccod")
nuevo = request.QueryString("nuevo")
'------------------------------------------------------------------------------------
if sede<>"" and sede<>"-1" then
  nombre_sede=conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede&"'")
else
  nombre_sede="Todas las sedes"  
end if
if espe_ccod<>"" and espe_ccod<>"-1" then
  nombre_carrera=conexion.consultaUno("select carr_tdesc from especialidades a,carreras b where cast(a.espe_ccod as varchar)='"&espe_ccod&"' and a.carr_ccod=b.carr_ccod")
else
  nombre_carrera="Todas las carreras inpartidas en la sede"  
end if

fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
tituloPag = "Nómina de Alumnos"

if nuevo="S" then tituloPag = tituloPag + " Nuevos"
if nuevo="N" then tituloPag = tituloPag + " Antiguos"
tituloPag = tituloPag + " por Carrera"

tituloPag = tituloPag + " Matriculados a la fecha, según Nro de Asignaturas Inscritas"



set f_matriculados = new cformulario
f_matriculados.carga_parametros "gestion_matricula.xml","listado_matriculados"
f_matriculados.inicializar conexion

periodo=negocio.ObtenerPeriodoAcademico("CLASES18")
filtro_nuevo = ""
if nuevo = "S" or nuevo="N" then 
	filtro_nuevo = "  having protic.es_nuevo_carrera(a.pers_ncorr,e.carr_ccod,c.peri_ccod) = '"&nuevo&"' "
end if
consulta=""		

' asigna valores nulos
'if espe_ccod="" then espe_ccod=0 end if
'if sede="" then sede=0 end if

if emat_ccod = "1" then

	consulta = " select distinct tabla.pers_ncorr,tabla.carr_ccod,tabla.peri_ccod,tabla.rut, " & vbCrLf &_
			 " tabla.nombre,a.matr_ncorr, " & vbCrLf &_
			 " count(a.matr_ncorr) as suma_total,case count(a.matr_ncorr) when 0 then 'Sin Inscripción' else '' end as estado," & vbCrLf &_
			 " isnull(protic.ANO_INGRESO_CARRERA(tabla.pers_ncorr, (select protic.obtener_nombre_carrera((select top 1 ofer_ncorr " & vbCrLf &_
	   		 " From alumnos where matr_ncorr=a.matr_ncorr order by matr_ncorr desc),'CC'))) ,  " & vbCrLf &_
	         " protic.ANO_INGRESO_UNIVERSIDAD(tabla.pers_ncorr) )as ano_ingreso" & vbCrLf &_
			 " from cargas_academicas a, " & vbCrLf &_
			 " (select distinct a.pers_ncorr, e.carr_ccod, c.peri_ccod, " & vbCrLf &_
			 " cast(pers_nrut as varchar)+'-'+cast(pers_xdv as varchar) as rut, " & vbCrLf &_
			 " pers_tape_paterno + ' ' + pers_tape_materno + ', '+ pers_tnombre as nombre, " & vbCrLf &_
			 "   pers_fnacimiento,protic.es_nuevo_carrera(a.pers_ncorr,e.carr_ccod,c.peri_ccod) as nuevo, " & vbCrLf &_
			 "   d.matr_ncorr " & vbCrLf &_
			 " from personas a, ofertas_academicas c, alumnos d,especialidades e" & vbCrLf &_
			 " where a.pers_ncorr = d.pers_ncorr " & vbCrLf &_
			 " and c.ofer_ncorr = d.ofer_ncorr " & vbCrLf &_
			 " and c.espe_ccod  = e.espe_ccod " & vbCrLf &_
			 " and c.peri_ccod = '"&periodo&"' " & vbCrLf &_
			 " and e.espe_ccod = '"&espe_ccod&"' " & vbCrLf &_
			 " and c.sede_ccod = '"&sede&"' " & vbCrLf &_
			 " and d.emat_ccod = 1 " & vbCrLf &_
			 "   and d.audi_tusuario not in ('AgregaNota2T','AgregaNota3','AgregaNota37','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46'," & vbCrLf  & _
			 "		    'AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp'," & vbCrLf  & _
			 "          'AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80'," & vbCrLf  & _
			 "          'AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99','AgregaNota3Nuevo','AgregaNotaProtix','AgregaNotaprotix1') " & vbCrLf  & _
			 " group by a.pers_ncorr, e.carr_ccod, c.peri_ccod,pers_nrut, pers_xdv, pers_tnombre,pers_tape_paterno, " & vbCrLf &_
			 "          pers_tape_materno,pers_fnacimiento,d.matr_ncorr " & vbCrLf &_
			 " "&filtro_nuevo & " ) as tabla " & vbCrLf &_
			 " where tabla.matr_ncorr *= a.matr_ncorr " & vbCrLf &_
			 " group by tabla.pers_ncorr,tabla.carr_ccod,tabla.peri_ccod,tabla.rut,tabla.nombre,tabla.pers_fnacimiento,tabla.nuevo, " & vbCrLf &_
			 "         a.matr_ncorr " & vbCrLf &_
			 " order by tabla.nombre asc"
end if

'response.Write("<pre>"&consulta&"</pre>")
'response.Flush()
f_matriculados.Consultar consulta

%>
<html>
<head>
<title> Detalle Envio a Notaria</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif"><%=tituloPag%></font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Sede</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <% =nombre_sede%> </td>
    
  </tr>
  <tr> 
    <td height="22"><strong>Carrera</strong></td>
    <td colspan="3"><strong>:</strong> <%=nombre_carrera %> </td>
  </tr>
  <tr>
    <td><strong>Fecha</strong></td>
    <td colspan="3"> <strong>:</strong> <%=fecha%></td>
 </tr>
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="10%"><div align="center"><strong>Rut</strong></div></td>
    <td width="35%"><div align="center"><strong>Nombre Persona</strong></div></td>
    <td width="10%"><div align="center"><strong>Cant. Asignaturas</strong></div></td>
	<td width="15%"><div align="center"><strong>Observación</strong></div></td>
	<td width="10%"><div align="center"><strong>Ingreso</strong></div></td>
  </tr>
  <%  while f_matriculados.Siguiente %>
  <tr> 
    <td><div align="left"><%=f_matriculados.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_matriculados.ObtenerValor("nombre")%></div></td>
    <td><div align="center"><%=f_matriculados.ObtenerValor("suma_total")%></div></td>
	<td><div align="center"><%=f_matriculados.ObtenerValor("estado")%></div></td>
	<td><div align="center"><%=f_matriculados.ObtenerValor("ano_ingreso")%></div></td>
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>
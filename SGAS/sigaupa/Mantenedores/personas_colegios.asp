<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=asignaturas.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

cole_ccod = request.querystring("cole_ccod")
ciud_ccod = request.querystring("ciud_ccod")
Region = conexion.consultauno("SELECT regi_tdesc FROM ciudades a, Regiones b WHERE a.regi_ccod=b.regi_Ccod and cast(a.ciud_ccod as varchar)='" & ciud_ccod&"'" )
Ciudad = conexion.consultauno("SELECT ciud_tcomuna FROM Ciudades WHERE cast(ciud_ccod as varchar)='" & ciud_ccod&"'"  )
Comuna = conexion.consultauno("SELECT ciud_tdesc FROM Ciudades WHERE cast(ciud_ccod as varchar)='" & ciud_ccod&"'"  )
colegio = conexion.consultauno("SELECT cole_tdesc FROM colegios WHERE cast(cole_ccod as varchar)='" & cole_ccod&"'"  )

'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion

 consulta = " select cast(a.pers_nrut as varchar)+'-'+a.pers_xdv as rut,  "& vbCrLf &_
            " a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' +a.pers_tape_materno as persona,  "& vbCrLf &_
            " isnull((Select sede_tdesc + ' - ' + carr_tdesc + ' - ' + jorn_tdesc + ' : Ingreso ' + cast(protic.ano_ingreso_carrera(a.pers_ncorr,dd.carr_ccod) as varchar)  "& vbCrLf &_
            " 		from ofertas_academicas aa, sedes bb, especialidades cc, carreras dd, jornadas ee  "& vbCrLf &_
            " 		where aa.ofer_ncorr = protic.ultima_oferta_matriculado(a.pers_ncorr)  "& vbCrLf &_
            " 		and aa.sede_ccod=bb.sede_ccod and aa.espe_ccod=cc.espe_Ccod and cc.carr_ccod=dd.carr_ccod  "& vbCrLf &_
       		" 		and aa.jorn_ccod=ee.jorn_ccod),'--') as carrera  "& vbCrLf &_
      		" 		from personas a where cast(cole_ccod as varchar)='"&cole_ccod&"'  "& vbCrLf &_
			" union  "& vbCrLf &_ 
			" 		select cast(a.pers_nrut as varchar)+'-'+a.pers_xdv as rut,  "& vbCrLf &_
			"       a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' +a.pers_tape_materno as persona,  "& vbCrLf &_
       		"		isnull((Select sede_tdesc + ' - ' + carr_tdesc + ' - ' + jorn_tdesc + ' : Ingreso ' + cast(protic.ano_ingreso_carrera(a.pers_ncorr,dd.carr_ccod) as varchar)  "& vbCrLf &_
        	"		from ofertas_academicas aa, sedes bb, especialidades cc, carreras dd, jornadas ee  "& vbCrLf &_
        	"		where aa.ofer_ncorr = protic.ultima_oferta_matriculado(a.pers_ncorr)  "& vbCrLf &_
        	"		and aa.sede_ccod=bb.sede_ccod and aa.espe_ccod=cc.espe_Ccod and cc.carr_ccod=dd.carr_ccod  "& vbCrLf &_
        	"		and aa.jorn_ccod=ee.jorn_ccod),'--') as carrera  "& vbCrLf &_
       		"		from personas_postulante a where cast(cole_ccod as varchar)='"&cole_ccod&"'  "& vbCrLf &_
			" union  "& vbCrLf &_
			"		select cast(a.pers_nrut as varchar)+'-'+a.pers_xdv as rut,  "& vbCrLf &_
	        " 		a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' +a.pers_tape_materno as persona,  "& vbCrLf &_
			"       '--' as carrera  "& vbCrLf &_
        	"		from personas_eventos_upa a where cast(cole_ccod as varchar)='"&cole_ccod&"'  "& vbCrLf &_
        	"		and not exists (select 1 from personas bb where a.pers_nrut=bb.pers_nrut)  "& vbCrLf &_
			"       and not exists (select 1 from personas_postulante bb where a.pers_nrut=bb.pers_nrut) "
tabla.consultar consulta 


fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Listado de Asignaturas</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Colegios</font></div>
	<div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Región</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=Region%> </td>
  </tr>
  <tr> 
    <td width="16%"><strong>Ciudad</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=Ciudad%> </td>
  </tr>
  <tr> 
    <td><strong>Comuna</strong></td>
    <td colspan="3"><strong>:</strong> <%=Comuna%> </td>
  </tr>
    <tr> 
    <td><strong>Establecimiento</strong></td>
    <td colspan="3"><strong>: <%=colegio%></strong></td>
  </tr>
  <tr>
    <td><strong>Fecha</strong></td>
    <td colspan="3"> <strong>:</strong> <%=fecha%></td>
 </tr>
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td><div align="center"><strong>Fila</strong></div></td>
	<td><div align="center"><strong>Rut</strong></div></td>
	<td><div align="center"><strong>Nombre</strong></div></td>
	<td><div align="center"><strong>Carrera</strong></div></td>
  </tr>
  <%  
  fila=1  
  while tabla.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("rut")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("persona")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("carrera")%></div></td>
  </tr>
  <% fila=fila +1 
   wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>
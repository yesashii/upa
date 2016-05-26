<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=metodos_de_acceso.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

periodo=negocio.obtenerPeriodoAcademico("Postulacion")
'-----------------------------------------------------------------------
'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion

consulta_encuestas   = " select distinct f.sede_tdesc as sede, i.facu_tdesc as facultad,e.carr_tdesc as carrera, g.jorn_tdesc as jornada,  " & vbcrlf & _
					   "       cast(j.pers_nrut as varchar)+'-'+j.pers_xdv as rut, protic.initCap(j.pers_tape_paterno + ' ' + j.pers_tape_materno + ', ' + j.pers_tnombre) as nombre_postulante,  " & vbcrlf & _
					   "       case when a.IP_GENERAL like '172.%' or  " & vbcrlf & _
					   "                 a.IP_GENERAL like '10.%' or  " & vbcrlf & _
					   "                 a.IP_GENERAL like '192.168.%' or  " & vbcrlf & _
					   "                 a.IP_GENERAL = '200.27.186.129' or  " & vbcrlf & _
					   "                 a.IP_GENERAL = '200.27.186.130'  or  " & vbcrlf & _
					   "                 a.IP_GENERAL = '200.27.186.131'   or  " & vbcrlf & _
					   "                 a.IP_GENERAL = '200.27.186.132'  or  " & vbcrlf & _
					   "                 a.IP_GENERAL = '200.27.186.133'  or " & vbcrlf & _ 
					   "                 a.IP_GENERAL = '200.27.186.134' or   " & vbcrlf & _
					   "                 a.IP_GENERAL = '200.113.180.112'  or " & vbcrlf & _
					   "                 a.IP_GENERAL = '200.113.180.113'  or " & vbcrlf & _
					   "                 a.IP_GENERAL = '200.113.180.114'  or " & vbcrlf & _
					   "                 a.IP_GENERAL = '200.113.180.115'  or " & vbcrlf & _
					   "                 a.IP_GENERAL = '200.113.180.116'  or " & vbcrlf & _
					   "                 a.IP_GENERAL = '200.113.180.117'  or " & vbcrlf & _
					   "                 a.IP_GENERAL = '200.113.180.118'  or " & vbcrlf & _
					   "                 a.IP_GENERAL = '200.113.180.119' " & vbcrlf & _
					   "       then 'INTERNA' else 'EXTERNA' end as acceso, a.OPCION forma_de_postulacion,protic.trunc(a.AUDI_FMODIFICACION) as fecha_ingreso,  " & vbcrlf & _
					   "       isnull((select regi_ccod from direcciones_publica tt, ciudades t2 where tt.pers_ncorr=j.pers_ncorr and tt.tdir_ccod=1 and tt.ciud_ccod=t2.ciud_ccod),13) as regi_ccod, " & vbcrlf & _
					   "      (select case count(*) when 0 then 'NO' else 'SI' end from alumnos tt where tt.post_ncorr=b.post_ncorr and tt.ofer_ncorr=a.ofer_ncorr and emat_ccod <> 9 ) as matriculado, " & vbcrlf & _
					   "       case (select count(*) from observaciones_postulacion ttt (nolock)  " & vbcrlf & _
					   "       where ttt.post_ncorr=a.POST_NCORR and ttt.ofer_ncorr=a.OFER_NCORR and ttt.eopo_ccod=16)  " & vbcrlf & _
					   "       +  " & vbcrlf & _
					   "      (select count(*) from observaciones_postulacion_log ttt (nolock)  " & vbcrlf & _
					   "       where ttt.post_ncorr=a.POST_NCORR and ttt.ofer_ncorr=a.OFER_NCORR and ttt.eopo_ccod=16)  " & vbcrlf & _
					   "      when 0 then 'NO' else 'SI' end as gestion_entrevista,  " & vbcrlf & _
					   "      isnull((select eepo_tdesc from detalle_postulantes ttt (nolock), estado_examen_postulantes tt2 (nolock)  " & vbcrlf & _
					   "              where ttt.POST_NCORR=a.POST_NCORR and ttt.OFER_NCORR=a.OFER_NCORR and ttt.EEPO_CCOD=tt2.EEPO_CCOD),'') as   estado_entrevista,  " & vbcrlf & _
					   "      case (select count(*) from observaciones_postulacion ttt (nolock)  " & vbcrlf & _
					   "            where ttt.post_ncorr=a.POST_NCORR and ttt.ofer_ncorr=a.OFER_NCORR and ttt.eopo_ccod not in (16))  " & vbcrlf & _
					   "            +  " & vbcrlf & _
					   "           (select count(*) from observaciones_postulacion_log ttt (nolock)  " & vbcrlf & _
					   "            where ttt.post_ncorr=a.POST_NCORR and ttt.ofer_ncorr=a.OFER_NCORR and ttt.eopo_ccod not in (16))  " & vbcrlf & _
					   "            when 0 then 'NO' else 'SI' end as otra_gestion  " & vbcrlf & _
					   " from ip_postulaciones a (nolock), postulantes b (nolock),   " & vbcrlf & _
					   "      ofertas_academicas c, especialidades d, carreras e, sedes f, jornadas g, areas_academicas h, facultades i,  " & vbcrlf & _
					   "      personas_postulante j (nolock)  " & vbcrlf & _
					   " where a.post_ncorr=b.post_ncorr and a.ofer_ncorr=c.ofer_ncorr and c.espe_ccod=d.espe_ccod  " & vbcrlf & _
					   " and c.sede_ccod=f.sede_ccod and c.jorn_ccod=g.jorn_ccod   " & vbcrlf & _
					   " and e.area_ccod=h.area_ccod and h.facu_ccod=i.facu_ccod  " & vbcrlf & _
					   " and b.pers_ncorr=j.pers_ncorr  " & vbcrlf & _
			   		   " and exists (select 1 from ofertas_academicas tt (nolock), aranceles t2 (nolock) where tt.aran_ncorr=t2.aran_ncorr and tt.ofer_ncorr=a.ofer_ncorr and isnull(t2.aran_mcolegiatura,0) > 1 ) " & vbCrLf &_
					   " and d.carr_ccod=e.carr_ccod and b.post_bnuevo='S' and cast(b.peri_ccod as varchar) = '"&periodo&"'  " & vbcrlf & _
					   " order by sede,carrera,jornada asc " 					  

		
tabla.consultar consulta_encuestas

'--------------------------------------------------------------------------
fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------

%>
<html>
<head>
<title>Métodos de acceso a postulación</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Métodos de acceso a postulación</font></div>
	  <div align="right"><%=fecha%></div>
	</td>
 </tr>
</table>
<table width="100%" border="1">
   <tr>
   	<th bgcolor="#CCFFCC">&nbsp;</th>
	<th bgcolor="#CCFFCC"><strong>Sede</strong></th>
	<th bgcolor="#CCFFCC"><strong>Facultad</strong></th>
	<th bgcolor="#CCFFCC"><strong>Carrera</strong></th>
	<th bgcolor="#CCFFCC"><strong>Jornada</strong></th>
	<th bgcolor="#CCFFCC"><strong>Rut</strong></th>
	<th bgcolor="#CCFFCC"><strong>Nombre</strong></th>
	<th bgcolor="#CCFFCC"><strong>Acceso</strong></th>
	<th bgcolor="#CCFFCC"><strong>Forma de postulación</strong></th>
	<th bgcolor="#CCFFCC"><strong>Fecha</strong></th>
	<th bgcolor="#CCFFCC"><strong>Matriculado</strong></th>
	<th bgcolor="#CCFFCC"><strong>Gestión entrevista</strong></th>
	<th bgcolor="#CCFFCC"><strong>Estado entrevista</strong></th>
	<th bgcolor="#CCFFCC"><strong>Otra Gestión</strong></th>
   </tr>
 <% fila = 1  
     color_fila = "" 
     while tabla.Siguiente 
	   if tabla.ObtenerValor("matriculado") = "SI" then
	      color_fila = "bgcolor='#FF9900'"		
	   else
	      color_fila = ""
	   end if%>
  <tr <%=color_fila%>> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("sede")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("facultad")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("carrera")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("jornada")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("rut")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("nombre_postulante")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("acceso")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("forma_de_postulacion")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("fecha_ingreso")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("matriculado")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("gestion_entrevista")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("estado_entrevista")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("otra_gestion")%></div></td>	
  </tr>
  <% fila = fila + 1  
  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>
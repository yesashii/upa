<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
for each k in request.form
	response.write(k&"="&request.Form(k)&"<br>")
next
'response.End()

f_dcur_ncorr =Request.QueryString("dcur_ncorr")
f_dcur_ncorr=Request.Form("d[0]dcur_ncorr")
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion



sql_descuentos="select j.pers_ncorr,upper(pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre) as nombre,"& vbCrLf &_
"count(distinct k.pers_ncorr_alumno)as r_programa,epot_tdesc,"& vbCrLf &_
"(protic.obtener_cantidad_relatores_avaluar(j.pers_ncorr,a.dcur_ncorr)-count(l.pers_ncorr_relator))as relatores_pendientes"& vbCrLf &_
"from diplomados_cursos a"& vbCrLf &_
"join mallas_otec b"& vbCrLf &_
"on a.dcur_ncorr=b.dcur_ncorr"& vbCrLf &_
"join modulos_otec c"& vbCrLf &_
"on b.mote_ccod=c.mote_ccod"& vbCrLf &_
"join secciones_otec d"& vbCrLf &_
"on b.maot_ncorr=d.maot_ncorr"& vbCrLf &_
"join autoriza_encuesta_otec e"& vbCrLf &_
"on a.dcur_ncorr=e.dcur_ncorr"& vbCrLf &_
"and b.mote_ccod=e.mote_ccod"& vbCrLf &_
"join mallas_otec f"& vbCrLf &_
"on e.mote_ccod=f.mote_ccod"& vbCrLf &_
"join secciones_otec g"& vbCrLf &_
"on f.maot_ncorr=g.maot_ncorr"& vbCrLf &_
"and d.seot_finicio=g.seot_finicio"& vbCrLf &_
"and d.seot_ftermino=g.seot_ftermino"& vbCrLf &_
"join bloques_horarios_otec h"& vbCrLf &_
"on g.seot_ncorr=h.seot_ncorr"& vbCrLf &_
"join  postulacion_otec i"& vbCrLf &_
"on d.dgso_ncorr=i.dgso_ncorr"& vbCrLf &_
"join personas j"& vbCrLf &_
"on i.pers_ncorr=j.pers_ncorr"& vbCrLf &_
"left outer join encu_programa_otec k"& vbCrLf &_
"on j.pers_ncorr=k.pers_ncorr_alumno"& vbCrLf &_
"and a.dcur_ncorr=k.dcur_ncorr"& vbCrLf &_
"left outer join ENCU_RELATOR_OTEC l"& vbCrLf &_
"on j.pers_ncorr=l.pers_ncorr_alumno"& vbCrLf &_
"and a.dcur_ncorr=l.dcur_ncorr"& vbCrLf &_
"join estados_postulacion_otec m"& vbCrLf &_
"on i.epot_ccod=m.epot_ccod"& vbCrLf &_
"where a.dcur_ncorr="&f_dcur_ncorr&""& vbCrLf &_
"and i.epot_ccod in (3,4) "& vbCrLf &_
"group by j.pers_ncorr,pers_tape_paterno,pers_tape_materno,pers_tnombre,a.dcur_ncorr,epot_tdesc"& vbCrLf &_
"order by nombre"
				
fecha=conexion.ConsultaUno("select protic.trunc(getdate())")
hora =conexion.ConsultaUno("select cast(datepart(hour,getdate())as varchar)+':'+cast(datepart(minute,getdate())as varchar)+' hrs'")


dcur_tdesc=conexion.consultaUno("select dcur_tdesc from diplomados_cursos where dcur_ncorr="&f_dcur_ncorr&"")

	
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&q_tdet_ccod&"</pre>")
'response.Write("<pre>"&q_sede_ccod&"</pre>")
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.End()
set f_detalle  = new cformulario
f_detalle.carga_parametros "tabla_vacia.xml", "tabla" 
f_detalle.inicializar conexion							
f_detalle.consultar sql_descuentos

'-------------------------------------------------------------------------------



'response.End()		

'------------------------------------------------------------------------------
%>
 <html>
<head>
<title><%=pagina.Titulo%></title>  

</head>
<body bgcolor="#ffffff" leftmargin="43" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="100%" border="1">
  <tr align="center">
    <td><div align="center"></div></td>
	<td><div align="center"><strong>Reporte hecho el <%=fecha%></strong></div></td>
    <td><div align="left"><strong>a las <%=hora%></strong></div></td>
  </tr>
 
  <tr>
    <td width="22%" bgcolor="#339900"><div align="up"><strong>Nombre</strong></div></td>
    <td width="11%" bgcolor="#339900"><div align="center"><strong>Encuesta Relator</strong></div></td>
    <td width="38%" bgcolor="#339900"><div align="center"><strong>Encuesta Programa</strong></div></td>
	 <td width="11%" bgcolor="#339900"><div align="center"><strong>Estado Post.</strong></div></td>
  </tr>
  <%  while f_detalle.Siguiente 
   								  cantidad_programas=f_detalle.ObtenerValor("r_programa") 
								  cantidad_relatores=f_detalle.ObtenerValor("relatores_pendientes")
								  
								  if cdbl(cantidad_relatores)>0 then
									completa="Incompleta"
								  else
									 completa="Completa" 
								  end if
								  
								  if cdbl(cantidad_programas)=0 then
									completa2="Incompleta"
								  else
									completa2="Completa"
								  end if
  %>
  <tr>
    <td><div align="left"><%=f_detalle.ObtenerValor("nombre")%></div></td>
    <td><div align="left"><%=completa%></div></td>
    <td><div align="left"><%=completa2%></div></td>
	<td><div align="center"><%=f_detalle.Obtenervalor("epot_tdesc")%></div></td>
  </tr>
  <%  wend %>
</table>
</html>
<%Response.AddHeader "Content-Disposition", "attachment;filename=estado_encuesta_"&dcur_tdesc&".xls"
Response.ContentType = "application/vnd.ms-excel"%>
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each x in request.Form
'	response.Write("<br>"&x&" -> "&request.Form(x))
'next
'response.End()
f_dcur_ncorr=Request.querystring("dcur_ncorr")
f_pers_ncorr_relator=Request.querystring("pers_ncorr")
'f_dcur_ncorr=98
'--------------------------------------------------

set conectar	=	new cconexion
conectar.inicializar "upacifico"
set negocio		=	new cnegocio
negocio.inicializa conectar

set pagina = new CPagina
pagina.Titulo = "Administra Encuesta"


'--------------------------------------------------
set botonera = new CFormulario
botonera.carga_parametros "administra_encuesta.xml", "botonera"


set f_busqueda	=	new cformulario
f_busqueda.inicializar		conectar
f_busqueda.carga_parametros	"tabla_vacia.xml", "tabla" 

consulta="select mote_tdesc,rtrim(c.mote_ccod)as mote_ccod,protic.trunc(seot_finicio)as seot_finicio,protic.trunc(seot_ftermino)as seot_ftermino"& vbCrLf &_
"from diplomados_cursos a"& vbCrLf &_
"join mallas_otec b"& vbCrLf &_
"on a.dcur_ncorr=b.dcur_ncorr"& vbCrLf &_
"join modulos_otec c"& vbCrLf &_
"on b.mote_ccod=c.mote_ccod"& vbCrLf &_
"join secciones_otec d"& vbCrLf &_
"on b.maot_ncorr=d.maot_ncorr"& vbCrLf &_
"join autoriza_encuesta_otec e"& vbCrLf &_
"on b.mote_ccod=e.mote_ccod"& vbCrLf &_
"and a.dcur_ncorr=e.dcur_ncorr"& vbCrLf &_
"where a.dcur_ncorr="&f_dcur_ncorr&""& vbCrLf &_
"group by mote_tdesc,c.mote_ccod,seot_finicio,seot_ftermino"
'
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_busqueda.consultar	consulta
'f_busqueda.Siguiente

dcur_tdesc=conectar.consultaUno("select dcur_tdesc from diplomados_cursos where dcur_ncorr="&f_dcur_ncorr&"")
nombre_relator=conectar.consultaUno("select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno from personas  where pers_ncorr="&f_pers_ncorr_relator&"")
'-------------------------------------------------------------------------
fecha=conectar.ConsultaUno("select protic.trunc(getdate())")
hora =conectar.ConsultaUno("select cast(datepart(hour,getdate())as varchar)+':'+cast(datepart(minute,getdate())as varchar)+' hrs'")




%>


 <html>
<head>
<title><%=pagina.Titulo%></title>  

</head>
<body bgcolor="#ffffff" leftmargin="43" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="80%" border="1">
  <tr align="center">
    
	<td><div align="center"><strong>Reporte hecho el <%=fecha%></strong></div></td>
    <td><div align="left"><strong>a las <%=hora%></strong></div></td>
  </tr>
 
  <tr>
    <td width="22%" bgcolor="#339900"><div align="up"><strong>Modulo</strong></div></td>
    <td width="11%" bgcolor="#339900"><div align="center"><strong>Ptje Promedio</strong></div></td>
  </tr>
  <% 	 while f_busqueda.Siguiente
							mote_ccod=f_busqueda.ObtenerValor("mote_ccod")
							seot_finicio=f_busqueda.ObtenerValor("seot_finicio")
							seot_ftermino=f_busqueda.ObtenerValor("seot_ftermino")
							
							set f_relatores = new CFormulario
							f_relatores.Carga_Parametros "tabla_vacia.xml", "tabla"
							f_relatores.Inicializar conectar
									  
							 consulta_sec="select b.mote_ccod,c.seot_ncorr,f.pers_ncorr,mote_tdesc,a.dcur_ncorr,pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre"& vbCrLf &_
							"from modulos_otec b"& vbCrLf &_
							",mallas_otec a"& vbCrLf &_
							",secciones_otec c "& vbCrLf &_
							",bloques_horarios_otec d"& vbCrLf &_
							",bloques_relatores_otec e"& vbCrLf &_
							",personas f"& vbCrLf &_
							"where a.mote_ccod=b.mote_ccod"& vbCrLf &_
							"and a.maot_ncorr=c.maot_ncorr"& vbCrLf &_
							"and c.seot_ncorr=d.seot_ncorr"& vbCrLf &_
							"and d.bhot_ccod=e.bhot_ccod"& vbCrLf &_
							"and e.pers_ncorr=f.pers_ncorr"& vbCrLf &_
							"and a.mote_ccod='"&mote_ccod&"'"& vbCrLf &_
							"and f.pers_ncorr="&f_pers_ncorr_relator&""& vbCrLf &_
							"and protic.trunc(seot_finicio)='"&seot_finicio&"'"& vbCrLf &_
							"and protic.trunc(seot_ftermino)='"&seot_ftermino&"'"& vbCrLf &_
							"group by  e.pers_ncorr,b.mote_ccod,c.seot_ncorr,f.pers_ncorr,mote_tdesc,a.dcur_ncorr,pers_tape_paterno,pers_tape_materno,pers_tnombre"& vbCrLf &_
							"order by nombre"
							f_relatores.Consultar consulta_sec		
									
  
  					while f_relatores.Siguiente	
  
   								  pers_ncorr=f_relatores.Obtenervalor("pers_ncorr")
								  seot_ncorr=f_relatores.Obtenervalor("seot_ncorr")
								  
							sel_prom="select cast(((round(avg(enrp_1),2)+round(avg(enrp_2),2)+round(avg(enrp_3),2)+"& vbCrLf &_
									"round(avg(enrp_4),2)+round(avg(enrp_5),2)+round(avg(enrp_6),2)+round(avg(enrp_7),2)+"& vbCrLf &_
									"round(avg(enrp_8),2)+round(avg(enrp_9),2)+round(avg(enrp_10),2)+round(avg(enrp_11),2)+"& vbCrLf &_
									"round(avg(enrp_12),2)+round(avg(enrp_13),2))/13) as decimal(18,1))promedio_evaluacion"& vbCrLf &_
									"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
									"where vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
									"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
									"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
									"group by pers_ncorr_relator"
									
							prom=conectar.consultaUno(sel_prom)
  %>
  <tr>
    <td align="left"><%=f_relatores.ObtenerValor("mote_tdesc")%></td>
    <td><div align="left"><%=prom%></div></td>
  </tr>
   <%  wend %>
  <%  wend %>
</table>
</html>
<%Response.AddHeader "Content-Disposition", "attachment;filename=encuesta_relator_programas_"&dcur_tdesc&".xls"
Response.ContentType = "application/vnd.ms-excel"%>

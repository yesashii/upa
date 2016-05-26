<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each x in request.Form
'	response.Write("<br>"&x&" -> "&request.Form(x))
'next

f_dcur_ncorr=Request.querystring("dcur_ncorr")
f_pers_ncorr_relator=Request.querystring("pers_ncorr_relator")
seot_ncorr=Request.querystring("seot_ncorr")
mote_ccod=Request.querystring("mote_ccod")
'f_dcur_ncorr=98
'response.Write("</br>f_dcur_ncorr "&f_dcur_ncorr)
'response.Write("</br>f_pers_ncorr_relator "&f_pers_ncorr_relator)
'response.Write("</br>seot_ncorr "&seot_ncorr)
'response.Write("</br>mote_ccod "&mote_ccod)
'response.End()
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

consulta="select 1 as npre,'El profesor dio a conocer los objetivos del programa'as pregunta, cast(round(avg(enrp_1),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select  2 as npre,'El profesor prepara, organiza y estructura bien las clases'as pregunta, cast(round(avg(enrp_2),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 3 as npre,'Los contenidos fueron expresados de modo comprensible'as pregunta, cast(round(avg(enrp_3),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 4 as npre,'Los textos y material bibliográfico fueron adecuados para los aprendizajes'as pregunta, cast(round(avg(enrp_4),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select  5 as npre,'Planifica y solicita los materiales necesarios para las clases'as pregunta, cast(round(avg(enrp_5),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 6 as npre,'El profesor aplica diversas estrategias de enseñanza para facilitar el aprendizaje'as pregunta, cast(round(avg(enrp_6),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 7 as npre,'El profesor se muestra accesible y está dispuesto a atender las consultas y sugerencias de los alumnos'as pregunta, cast(round(avg(enrp_7),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 8 as npre,'El profesor cumple efectivamente con el Plan de Evaluación señalado'as pregunta, cast(round(avg(enrp_8),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 9 as npre,'El profesor cumple adecuadamente con el Programa'as pregunta, cast(round(avg(enrp_9),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 10 as npre,'El profesor entrega oportunamente (dentro de 15 días) los resultados de la evaluación'as pregunta, cast(round(avg(enrp_10),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 11 as npre,'El profesor realiza retroalimentación de los aprendizajes'as pregunta, cast(round(avg(enrp_11),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 12 as npre,'El profesor  promueve un ambiente de aprendizaje acorde a las necesidades de los estudiantes'as pregunta, cast(round(avg(enrp_12),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 13 as npre,'El profesor cumple con el horario y aspectos formales 'as pregunta, cast(round(avg(enrp_13),2)as decimal(8,2))as promedio"& vbCrLf &_
"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
"where  vv.pers_ncorr_relator="&f_pers_ncorr_relator&""& vbCrLf &_
"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"order by npre"
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_busqueda.consultar	consulta
'f_busqueda.Siguiente

dcur_tdesc=conectar.consultaUno("select dcur_tdesc from diplomados_cursos where dcur_ncorr="&f_dcur_ncorr&"")
nombre_relator=conectar.consultaUno("select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno from personas  where pers_ncorr="&f_pers_ncorr_relator&"")
modulos=conectar.consultaUno("select mote_tdesc from modulos_otec where mote_ccod='"&mote_ccod&"'")
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
  <tr align="center">
    
	<td colspan="2"><div align="left"><strong>Relator <%=nombre_relator%></strong></div></td>
  </tr>
 
  <tr>
    <td width="22%" bgcolor="#339900"><div align="up"><strong>Pregunta</strong></div></td>
    <td width="11%" bgcolor="#339900"><div align="center"><strong>Ptje Promedio</strong></div></td>
  </tr>
  <% 	 while f_busqueda.Siguiente%>
  <tr>
    <td align="left"><%=f_busqueda.ObtenerValor("pregunta")%></td>
    <td><div align="left"><%=f_busqueda.ObtenerValor("promedio")%></div></td>
  </tr>
   <%  wend %>

</table>
</html>
<%Response.AddHeader "Content-Disposition", "attachment;filename=encuesta_relator_programas_detalle_"&dcur_tdesc&".xls"
Response.ContentType = "application/vnd.ms-excel"%>

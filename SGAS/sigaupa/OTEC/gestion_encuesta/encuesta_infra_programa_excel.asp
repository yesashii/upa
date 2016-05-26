<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=encuesta_relator.xls"
Response.ContentType = "application/vnd.ms-excel"
'for each x in request.Form
'	response.Write("<br>"&x&" -> "&request.Form(x))
'next
'response.End()
f_dcr=Request.querystring("dcur_ncorr")
pers_ncorr=Request.querystring("pers_ncorr")
f_dcur_ncorr=Request.Form("b[0]dcur_ncorr")
'f_dcur_ncorr=98

if f_dcur_ncorr="" then
f_dcur_ncorr=f_dcr
end if
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

consulta="select 1 as npre,'Este curso ha aumentado mi interés por la materia.'as pregunta, cast(round(avg(enpo_I_1),2)as decimal(8,2))as promedio"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where  vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select  2 as npre,'Este curso ha sido una herramienta de gran utilidad para mi desarrollo profesional 'as pregunta, cast(round(avg(enpo_I_2),2)as decimal(8,2))as promedio"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where  vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 3 as npre,'Se cumplieron en gran medida mis expectativas respecto al programa y la universidad.'as pregunta, cast(round(avg(enpo_I_3),2)as decimal(8,2))as promedio"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where  vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 4 as npre,'El curso ha sido muy valioso para mi desempeño laboral.'as pregunta, cast(round(avg(enpo_I_4),2)as decimal(8,2))as promedio"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where  vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select  5 as npre,'Los objetivos definidos se cumplieron.'as pregunta, cast(round(avg(enpo_I_5),2)as decimal(8,2))as promedio"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where  vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 6 as npre,'Los contenidos son actuales y adecuados al programa.'as pregunta, cast(round(avg(enpo_I_6),2)as decimal(8,2))as promedio"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where  vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 7 as npre,'La Bibliografía utilizada es actualizada.'as pregunta, cast(round(avg(enpo_I_7),2)as decimal(8,2))as promedio"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where  vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"order by npre"
'
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_busqueda.consultar	consulta
'f_busqueda.Siguiente

set f_busqueda_II	=	new cformulario
f_busqueda_II.inicializar		conectar
f_busqueda_II.carga_parametros	"administra_encuesta.xml", "segunda_part" 

consul="select 1 as npre,'El curso contó con los medios audiovisuales requeridos.'as pregunta, (select count(enpo_II_1) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_1=1 )as s,"& vbCrLf &_
" (select count(enpo_II_1) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_1=2 )as av,"& vbCrLf &_
" (select count(enpo_II_1) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_1=3 )as n,"& vbCrLf &_
"  (select count(enpo_II_2) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_2=0 )as na"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select  2 as npre,'Existe una plataforma virtual de apoyo amigable.'as pregunta,  (select count(enpo_II_2) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_2=1 )as s,"& vbCrLf &_
" (select count(enpo_II_2) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_2=2 )as av,"& vbCrLf &_
" (select count(enpo_II_2) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_2=3 )as n,"& vbCrLf &_
"   (select count(enpo_II_2) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_2=0 )as na"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 3 as npre,'La Sala en que se impartió el curso era confortable.'as pregunta,  (select count(enpo_II_3) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_3=1 )as s,"& vbCrLf &_
 "(select count(enpo_II_3) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_3=2 )as av,"& vbCrLf &_
" (select count(enpo_II_3) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_3=3 )as n,"& vbCrLf &_
"   (select count(enpo_II_3) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_3=0 )as na"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 4 as npre,'El acceso a la Biblioteca fue adecuado.'as pregunta,  (select count(enpo_II_4) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_4=1 )as s,"& vbCrLf &_
 "(select count(enpo_II_4) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_4=2 )as av,"& vbCrLf &_
" (select count(enpo_II_4) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_4=3 )as n,"& vbCrLf &_
"   (select count(enpo_II_4) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_4=0 )as na"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select  5 as npre,'El número de ejemplares de libros y documentos es óptimo.'as pregunta,  (select count(enpo_II_5) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_5=1 )as s,"& vbCrLf &_
" (select count(enpo_II_5) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_5=2 )as av,"& vbCrLf &_
" (select count(enpo_II_5) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_5=3 )as n,"& vbCrLf &_
"   (select count(enpo_II_5) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_5=0 )as na"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 6 as npre,'El apoyo de la coordinación del Programa fue adecuado.'as pregunta,  (select count(enpo_II_6) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_6=1 )as s,"& vbCrLf &_
" (select count(enpo_II_6) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_6=2 )as av,"& vbCrLf &_
" (select count(enpo_II_6) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_6=3 )as n,"& vbCrLf &_
"   (select count(enpo_II_6) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_6=0 )as na"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"union"& vbCrLf &_
"select 7 as npre,'El servicio de cafetería es de buena calidad.'as pregunta,  (select count(enpo_II_7) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_7=1 )as s,"& vbCrLf &_
" (select count(enpo_II_7) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_7=2 )as av,"& vbCrLf &_
" (select count(enpo_II_7) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_7=3 )as n,"& vbCrLf &_
"   (select count(enpo_II_7) from encu_programa_otec hh where hh.DCUR_NCORR=vv.DCUR_NCORR and enpo_II_7=0 )as na"& vbCrLf &_
"from encu_programa_otec vv"& vbCrLf &_
"where vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
"order by npre"


f_busqueda_II.consultar	consul

dcur_tdesc=conectar.consultaUno("select dcur_tdesc from diplomados_cursos where dcur_ncorr="&f_dcur_ncorr&"")
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
    <td width="22%" bgcolor="#339900"><div align="up"><strong>Nombre</strong></div></td>
    <td width="11%" bgcolor="#339900"><div align="center"><strong>Ptje Promedio</strong></div></td>
  </tr>
  	<%while f_busqueda.Siguiente%>
  <tr>
    <td align="left"><%=f_busqueda.ObtenerValor("pregunta")%></td>
    <td><div align="left"><%=f_busqueda.ObtenerValor("promedio")%></div></td>
  </tr>
   <%wend %>
</table>
<table width="80%" border="1">
  <tr align="center">
    
	<td colspan="5">&nbsp;</td>
  </tr>
 
  <tr>
    <td width="22%" bgcolor="#339900"><div align="up"><strong>Nombre</strong></div></td>
    <td width="11%" bgcolor="#339900"><div align="center"><strong>Si</strong></div></td>
	<td width="11%" bgcolor="#339900"><div align="center"><strong>A veces</strong></div></td>
	<td width="11%" bgcolor="#339900"><div align="center"><strong>No</strong></div></td>
	<td width="11%" bgcolor="#339900"><div align="center"><strong>No Aplica</strong></div></td>
  </tr>
  	<%while f_busqueda_II.Siguiente%>
  <tr>
    <td align="left"><%=f_busqueda_II.ObtenerValor("pregunta")%></td>
    <td><div align="left"><%=f_busqueda_II.ObtenerValor("s")%></div></td>
	<td><div align="left"><%=f_busqueda_II.ObtenerValor("av")%></div></td>
	<td><div align="left"><%=f_busqueda_II.ObtenerValor("n")%></div></td>
	<td><div align="left"><%=f_busqueda_II.ObtenerValor("na")%></div></td>
  </tr>
   <%wend %>
</table>
</html>

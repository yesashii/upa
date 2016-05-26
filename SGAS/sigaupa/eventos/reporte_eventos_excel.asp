<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 2000
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_eventos.xls"
Response.ContentType = "application/vnd.ms-excel"

set pagina = new CPagina
pagina.Titulo = "Reporte Eventos"

v_fecha_inicio 		= request.querystring("busqueda[0][even_fevento]")
v_fecha_termino 	= request.querystring("busqueda[0][fecha_termino]")
v_teve_ccod	 		= request.querystring("busqueda[0][teve_ccod]")
v_caev_ccod 		= request.querystring("busqueda[0][caev_ccod]")
v_ciud_ccod 		= request.querystring("busqueda[0][ciud_ccod]")
v_pcol_ccod 		= request.querystring("busqueda[0][pcol_ccod]")
v_carrera 			= request.querystring("busqueda[0][carrera]")
v_carre_ccod 		= request.querystring("busqueda[0][carre_ccod]")


set negocio = new cnegocio
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"


formulario.carga_parametros "consulta.xml", "consulta"
formulario.inicializar conectar
negocio.inicializa conectar
sede=negocio.obtenerSede


if v_fecha_inicio <> "" and esvacio(v_fecha_termino) then
	sql_adicional= sql_adicional + "and  protic.trunc(c.even_fevento)='"&v_fecha_inicio&"' "& vbCrLf
end if
if EsVacio(v_fecha_inicio) and v_fecha_termino<>"" then
	sql_adicional= sql_adicional + " and convert(datetime,c.even_fevento,103) <=  convert(datetime,'"&v_fecha_termino&"',103) "& vbCrLf
end if

if v_fecha_inicio <> "" and v_fecha_termino <> "" then
	sql_adicional= sql_adicional + " and convert(datetime,c.even_fevento,103) BETWEEN  convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_termino&"',103)"& vbCrLf 
end if


if v_teve_ccod <> "" then
	sql_adicional= sql_adicional + " and c.teve_ccod ="&v_teve_ccod& vbCrLf 
end if

if v_caev_ccod <> "" then
	sql_adicional= sql_adicional + " and a.caev_ccod ="&v_caev_ccod& vbCrLf 
end if

if v_ciud_ccod <> "" then
	sql_adicional= sql_adicional + " and c.ciud_ccod_origen ="&v_ciud_ccod& vbCrLf 
end if

if v_pcol_ccod <> "" then
	sql_adicional= sql_adicional + " and c.pcol_ccod ="&v_pcol_ccod& vbCrLf 
end if

if v_carrera <> "" then
	'sql_adicional= sql_adicional + " and c.pcol_ccod ="&v_carrera& vbCrLf 
	sql_adicional= sql_adicional + " and (b.carrera_1 like '%"&v_carrera&"%' or  b.carrera_2 like '%"&v_carrera&"%' or  b.carrera_3 like '%"&v_carrera&"%')" & vbCrLf 
	sql_adicional= sql_adicional + " and PATINDEX('%@%',a.pers_temail)>0 "

	select_add= select_add + " ,carrera_1, carrera_2, carrera_3,case when carrera_1 like '%"&v_carrera&"%' then cast(1 as varchar)+'ª' "
	select_add= select_add + " when carrera_2 like '%"&v_carrera&"%' then cast(2 as varchar)+'ª' "
	select_add= select_add + " when carrera_3 like '%"&v_carrera&"%' then cast(3 as varchar)+'ª' end as opcion_carrera "

end if

if v_carre_ccod <> "" then
select_add=""

	'sql_adicional= sql_adicional + " and c.pcol_ccod ="&v_carrera& vbCrLf 
	sql_adicional= sql_adicional + " and (b.carre_ccod_1="&v_carre_ccod&" or  b.carre_ccod_2="&v_carre_ccod&" or  b.carre_ccod_3="&v_carre_ccod&")" & vbCrLf 
	sql_adicional= sql_adicional + " and PATINDEX('%@%',a.pers_temail)>0 "

	select_add= select_add + ",isnull((select carre_tdesc from carreras_eventos where carre_ccod=carre_ccod_1),'--') as carrera_1, "
	select_add= select_add + "isnull((select carre_tdesc from carreras_eventos where carre_ccod=carre_ccod_2),'--') as carrera_2, "
	select_add= select_add + "isnull((select carre_tdesc from carreras_eventos where carre_ccod=carre_ccod_3),'--') as carrera_3, "

	select_add= select_add + " case when carre_ccod_1 = "&v_carre_ccod&" then cast(1 as varchar)+'ª' "
	select_add= select_add + " when carre_ccod_2 ="&v_carre_ccod&" then cast(2 as varchar)+'ª' "
	select_add= select_add + " when carre_ccod_3 ="&v_carre_ccod&" then cast(3 as varchar)+'ª' end as opcion_carrera "
else
	select_add= select_add + ",isnull((select carre_tdesc from carreras_eventos where carre_ccod=carre_ccod_1),'--') as carrera_1, "
	select_add= select_add + "isnull((select carre_tdesc from carreras_eventos where carre_ccod=carre_ccod_2),'--') as carrera_2, "
	select_add= select_add + "isnull((select carre_tdesc from carreras_eventos where carre_ccod=carre_ccod_3),'--') as carrera_3 "
end if

'response.Write("Sql Adicional :<pre>"&sql_adicional&"</pre>")
if request.QueryString <> "" then
	sql_datos_eventos = "select cast(a.pers_nrut as varchar)+'-'+cast(a.pers_xdv as varchar) as rut, a.pers_tnombre,a.pers_tape_paterno,a.pers_tape_materno, "& vbCrLf &_
							" a.pers_tdireccion,g.ciud_tcomuna as ciudad_alumno, g.ciud_tdesc as comuna_alumno, "& vbCrLf &_
							" h.caev_tdesc as curso_alumno,a.pers_temail,a.pers_tfono,a.pers_tcelular,c.even_fevento, "& vbCrLf &_
							" e.teve_tdesc as tipo_evento,d.pest_tdesc as preferencia_estudio,pers_ttwitter,pers_tfacebook, "& vbCrLf &_
							" f.cole_tdesc as colegio_alumno,i.ciud_tdesc as comuna_colegio, i.ciud_tcomuna as ciudad_colegio, "& vbCrLf &_
							" (select cole_tdesc  from colegios where cole_ccod=c.cole_ccod) as colegio_evento "& vbCrLf &_
							"  "&select_add&" "& vbCrLf &_
							" from personas_eventos_upa a, "& vbCrLf &_
							" eventos_alumnos b,  "& vbCrLf &_
							" eventos_upa c,  "& vbCrLf &_
							" preferencia_estudio d,  "& vbCrLf &_
							" tipo_evento e,  "& vbCrLf &_
							" colegios f, "& vbCrLf &_
							" ciudades g, "& vbCrLf &_
							" cursos_alumnos_eventos h, "& vbCrLf &_
							" ciudades i "& vbCrLf &_
							" where a.pers_ncorr_alumno=b.pers_ncorr_alumno   "& vbCrLf &_
							" "&sql_adicional&" "& vbCrLf &_
							" and b.pest_ccod=d.pest_ccod "& vbCrLf &_
							" and b.even_ncorr=c.even_ncorr "& vbCrLf &_
							" and c.teve_ccod=e.teve_ccod "& vbCrLf &_
							" and a.cole_ccod=f.cole_ccod "& vbCrLf &_
							" and a.ciud_ccod=g.ciud_ccod "& vbCrLf &_
							" and a.caev_ccod=h.caev_ccod "& vbCrLf &_
							" and f.ciud_ccod=i.ciud_ccod "& vbCrLf &_
							" order by a.pers_tnombre,a.pers_tape_paterno,a.pers_tape_materno"

else
	sql_datos_eventos="select '' where 1=2 " 
end if			 

'response.Write("<pre>"&sql_datos_eventos&"</pre>")
'response.End()				 


formulario.consultar sql_datos_eventos


%>


<html>
<head>
<title>Reporte Eventos</title>
</head>
<body>
<table width="75%" border="1">
  <tr>
	<td width="11%"><div align="center"><strong>Colegio Evento</strong></div></td>
	<td width="11%"><div align="center"><strong>Fecha Evento</strong></div></td> 
    <td width="11%"><div align="center"><strong>Rut</strong></div></td>
    <td width="11%"><div align="center"><strong>Nombre</strong></div></td>
    <td width="11%"><div align="center"><strong>Paterno</strong></div></td>
    <td width="14%"><div align="center"><strong>Materno</strong></div></td>
    <td width="8%"><div align="center"><strong>Direccion</strong></div></td>
    <td width="11%"><div align="center"><strong>Ciudad Alumno</strong></div></td>
    <td width="11%"><div align="center"><strong>Comuna Alumno</strong></div></td>
	<td width="11%"><div align="center"><strong>Email</strong></div></td>
	<td width="11%"><div align="center"><strong>Fono</strong></div></td>
    <td width="11%"><div align="center"><strong>Celular</strong></div></td>
	<td width="11%"><div align="center"><strong>Twitter</strong></div></td>
	<td width="11%"><div align="center"><strong>Facebook</strong></div></td>
	<td width="11%"><div align="center"><strong>Tipo Evento</strong></div></td>
	<td width="11%"><div align="center"><strong>Preferencia Estudio</strong></div></td>
	<td width="11%"><div align="center"><strong>Colegio Alumno</strong></div></td>
	<td width="11%"><div align="center"><strong>Curso alumno</strong></div></td>
	<td width="11%"><div align="center"><strong>Comuna Colegio</strong></div></td>
    <td width="11%"><div align="center"><strong>Ciudad Colegio</strong></div></td>
	<td width="11%"><div align="center"><strong>Primera Preferencia</strong></div></td>
	<td width="11%"><div align="center"><strong>Segunda Preferencia</strong></div></td>
    <td width="11%"><div align="center"><strong>Tercera Preferencia</strong></div></td>
<%if v_carrera <> "" then %>
    <td width="11%"><div align="center"><strong>Opcion Carrera</strong></div></td>
<%end if%>
  </tr>
  <%  while formulario.Siguiente %>
  <tr>
	<td><div align="left"><%=formulario.ObtenerValor("colegio_evento")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("even_fevento")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("pers_tnombre")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("pers_tape_paterno")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("pers_tape_materno")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("pers_tdireccion")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("ciudad_alumno")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("comuna_alumno")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("pers_temail")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("pers_tfono")%></div></td>
 	<td><div align="left"><%=formulario.ObtenerValor("pers_tcelular")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("pers_ttwitter")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("pers_tfacebook")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("tipo_evento")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("preferencia_estudio")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("colegio_alumno")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("curso_alumno")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("comuna_colegio")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("ciudad_colegio")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("carrera_1")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("carrera_2")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("carrera_3")%></div></td>
<%if v_carrera <> "" then %>
    <td><div align="left"><%=formulario.ObtenerValor("opcion_carrera")%></div></td>
<%end if%>
 </tr>
  <%  wend %>
</table>
</body>
</html>

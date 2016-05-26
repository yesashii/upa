<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION			        :
'FECHA CREACIÓN			      :
'CREADO POR				        :
'ENTRADA				          : NA
'SALIDA				            : NA
'MODULO QUE ES UTILIZADO	: EVENTOS
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 07/03/2013
'ACTUALIZADO POR			  : Luis Herrera G.
'MOTIVO				          : Corregir código, eliminar sentencia *=
'LINEA				          : 74, 124, 176
'********************************************************************
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_preferencia_por_perfil.xls"
Response.ContentType = "application/vnd.ms-excel"

set pagina = new CPagina
pagina.Titulo = "Perfiles Colegios"

v_fecha_inicio 		= request.querystring("busqueda[0][even_fevento]")
v_fecha_termino 	= request.querystring("busqueda[0][fecha_termino]")
v_tiop_ccod	 		= request.querystring("busqueda[0][tiop_ccod]")
v_pcol_ccod 		= request.querystring("busqueda[0][pcol_ccod]")




set negocio = new cnegocio
set conectar = new cconexion
set formulario = new cformulario
set formulario2 = new cformulario
set formulario3 = new cformulario
conectar.inicializar "upacifico"

	formulario.carga_parametros "consulta.xml", "consulta"
	formulario.inicializar conectar

	formulario2.carga_parametros "consulta.xml", "consulta"
	formulario2.inicializar conectar

	formulario3.carga_parametros "consulta.xml", "consulta"
	formulario3.inicializar conectar


if v_fecha_inicio <> "" and esvacio(v_fecha_termino) then
	sql_adicional= sql_adicional + "and  convert(datetime,a.even_fevento,103) >= convert(datetime,'"&v_fecha_inicio&"',103)"& vbCrLf
end if
if EsVacio(v_fecha_inicio) and v_fecha_termino<>"" then
	sql_adicional= sql_adicional + " and convert(datetime,a.even_fevento,103) <=  convert(datetime,'"&v_fecha_termino&"',103) "& vbCrLf
end if

if v_fecha_inicio <> "" and v_fecha_termino <> "" then
	sql_adicional= sql_adicional + " and convert(datetime,a.even_fevento,103) BETWEEN  convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_termino&"',103)"& vbCrLf 
end if

if v_pcol_ccod <> "" then
	sql_adicional= sql_adicional + " and a.pcol_ccod ="&v_pcol_ccod& vbCrLf 
else
	sql_adicional= sql_adicional + " and a.pcol_ccod in (1,2) "& vbCrLf 
end if


'		sql_datos_eventos= "select  pcol_tdesc as perfil,teve_tdesc as tipo_evento,carre_tdesc as Preferencia, count(*) as Cantidad "& vbCrLf &_
'							" from eventos_alumnos a, eventos_upa b, perfil_colegio c, tipo_evento d , carreras_eventos e "& vbCrLf &_
'							" where a.even_ncorr in ( "& vbCrLf &_
'							" 	select even_ncorr "& vbCrLf &_
'							" 	from eventos_upa a, ciudades b, colegios c "& vbCrLf &_
'							" 	where a.ciud_ccod_origen*=b.ciud_ccod "& vbCrLf &_
'							" 	and a.cole_ccod=c.cole_ccod "& vbCrLf &_
'							" 	and datepart(year,a.even_fevento)=datepart(year,getdate()) "& vbCrLf &_
'							" "&sql_adicional&"  "& vbCrLf &_
'							" ) "& vbCrLf &_
'							" and a.even_ncorr=b.even_ncorr "& vbCrLf &_
'							" and b.pcol_ccod=c.pcol_ccod "& vbCrLf &_
'							" and b.teve_ccod=d.teve_ccod "& vbCrLf &_
'							" and b.teve_ccod not in (8)  "& vbCrLf &_									
'							"  and carre_ccod_1= e.carre_ccod"& vbCrLf &_
'							" group by carre_tdesc,pcol_tdesc,teve_tdesc  "& vbCrLf &_
'							" order by cantidad desc,carre_tdesc desc,tipo_evento desc "
'-------------------------------------------------------------------------------INICIO CONSULTA ACTUALIZADA(SQLServer 2008)
sql_datos_eventos= "select pcol_tdesc  as perfil, "& vbCrLf &_
"       teve_tdesc  as tipo_evento, "& vbCrLf &_
"       carre_tdesc as preferencia, "& vbCrLf &_
"       count(*)    as cantidad "& vbCrLf &_
"from   eventos_alumnos as a "& vbCrLf &_
"       join eventos_upa as b "& vbCrLf &_
"         on a.even_ncorr = b.even_ncorr "& vbCrLf &_
"            and b.teve_ccod not in ( 8 ) "& vbCrLf &_
"       join perfil_colegio as c "& vbCrLf &_
"         on b.pcol_ccod = c.pcol_ccod "& vbCrLf &_
"       join tipo_evento as d "& vbCrLf &_
"         on b.teve_ccod = d.teve_ccod "& vbCrLf &_
"       join carreras_eventos as e "& vbCrLf &_
"         on a.carre_ccod_1 = e.carre_ccod--se añade a. "& vbCrLf &_    
"where  a.even_ncorr in (select even_ncorr "& vbCrLf &_
"                        from   eventos_upa as a "& vbCrLf &_
"                               left outer join ciudades as b "& vbCrLf &_
"                                            on a.ciud_ccod_origen = b.ciud_ccod "& vbCrLf &_
"                               join colegios as c "& vbCrLf &_
"                                 on a.cole_ccod = c.cole_ccod "& vbCrLf &_
"                        where  1=1 --datepart(year, a.even_fevento) =  datepart(year, getdate()) "& vbCrLf &_
"                        "&sql_adicional&" "&vbCrLf &_
"                       ) "& vbCrLf &_
"group  by carre_tdesc, "& vbCrLf &_
"          pcol_tdesc, "& vbCrLf &_
"          teve_tdesc "& vbCrLf &_
"order  by cantidad desc, "& vbCrLf &_
"          carre_tdesc desc, "& vbCrLf &_
"          tipo_evento desc "		  
'-------------------------------------------------------------------------------FIN CONSULTA ACTUALIZADA(SQLServer 2008)

'		sql_datos_eventos2= "select  pcol_tdesc as perfil,teve_tdesc as tipo_evento,carre_tdesc as Preferencia, count(*) as Cantidad "& vbCrLf &_
'							" from eventos_alumnos a, eventos_upa b, perfil_colegio c, tipo_evento d , carreras_eventos e "& vbCrLf &_
'							" where a.even_ncorr in ( "& vbCrLf &_
'							" 	select even_ncorr "& vbCrLf &_
'							" 	from eventos_upa a, ciudades b, colegios c "& vbCrLf &_
'							" 	where a.ciud_ccod_origen*=b.ciud_ccod "& vbCrLf &_
'							" 	and a.cole_ccod=c.cole_ccod "& vbCrLf &_
'							" 	and datepart(year,a.even_fevento)=datepart(year,getdate()) "& vbCrLf &_
'							" "&sql_adicional&"  "& vbCrLf &_
'							" ) "& vbCrLf &_
'							" and a.even_ncorr=b.even_ncorr "& vbCrLf &_
'							" and b.pcol_ccod=c.pcol_ccod "& vbCrLf &_
'							" and b.teve_ccod=d.teve_ccod "& vbCrLf &_
'							" and b.teve_ccod not in (8)  "& vbCrLf &_											
'							" and carre_ccod_2= e.carre_ccod"& vbCrLf &_
'							" and b.teve_ccod not in (8)  "& vbCrLf &_
'							" group by carre_tdesc,pcol_tdesc,teve_tdesc "& vbCrLf &_
'							" order by cantidad desc,carre_tdesc desc,tipo_evento desc  "
'-------------------------------------------------------------------------------INICIO CONSULTA ACTUALIZADA(SQLServer 2008)
sql_datos_eventos2= "select pcol_tdesc  as perfil, "& vbCrLf &_
"       teve_tdesc  as tipo_evento, "& vbCrLf &_
"       carre_tdesc as preferencia, "& vbCrLf &_
"       count(*)    as cantidad "& vbCrLf &_
"from   eventos_alumnos as a "& vbCrLf &_
"       join eventos_upa as b "& vbCrLf &_
"         on a.even_ncorr = b.even_ncorr "& vbCrLf &_
"            and b.teve_ccod not in ( 8 ) "& vbCrLf &_
"       --(repetida)and b.teve_ccod not in ( 8 ) "& vbCrLf &_      
"       join perfil_colegio as c "& vbCrLf &_
"         on b.pcol_ccod = c.pcol_ccod "& vbCrLf &_      
"       join tipo_evento as d "& vbCrLf &_
"         on b.teve_ccod = d.teve_ccod "& vbCrLf &_     
"       join carreras_eventos as e "& vbCrLf &_
"         on a.carre_ccod_2 = e.carre_ccod--se agrega a. "& vbCrLf &_      
"where  a.even_ncorr in (select even_ncorr "& vbCrLf &_
"                        from   eventos_upa as a "& vbCrLf &_
"                               left outer join ciudades as b "& vbCrLf &_
"                                            on a.ciud_ccod_origen = b.ciud_ccod "& vbCrLf &_
"                               join colegios as c "& vbCrLf &_
"                                 on a.cole_ccod = c.cole_ccod "& vbCrLf &_
"                        where 1=1 --datepart(year, a.even_fevento) = datepart(year, getdate()) "& vbCrLf &_
"                       "&sql_adicional&" "& vbCrLf &_   
"                       ) "& vbCrLf &_
"group  by carre_tdesc, "& vbCrLf &_
"          pcol_tdesc, "& vbCrLf &_
"          teve_tdesc "& vbCrLf &_
"order  by cantidad desc, "& vbCrLf &_
"          carre_tdesc desc, "& vbCrLf &_
"          tipo_evento desc "		  
'-------------------------------------------------------------------------------FIN CONSULTA ACTUALIZADA(SQLServer 2008)							

'		sql_datos_eventos3= "select  pcol_tdesc as perfil,teve_tdesc as tipo_evento,carre_tdesc as Preferencia, count(*) as Cantidad "& vbCrLf &_
'							" from eventos_alumnos a, eventos_upa b, perfil_colegio c, tipo_evento d, carreras_eventos e  "& vbCrLf &_
'							" where a.even_ncorr in ( "& vbCrLf &_
'							" 	select even_ncorr "& vbCrLf &_
'							" 	from eventos_upa a, ciudades b, colegios c "& vbCrLf &_
'							" 	where a.ciud_ccod_origen*=b.ciud_ccod "& vbCrLf &_
'							" 	and a.cole_ccod=c.cole_ccod "& vbCrLf &_
'							" 	and datepart(year,a.even_fevento)=datepart(year,getdate()) "& vbCrLf &_
'							" "&sql_adicional&"  "& vbCrLf &_
'							" ) "& vbCrLf &_
'							" and a.even_ncorr=b.even_ncorr "& vbCrLf &_
'							" and b.pcol_ccod=c.pcol_ccod "& vbCrLf &_
'							" and b.teve_ccod=d.teve_ccod "& vbCrLf &_
'							" and b.teve_ccod not in (8)  "& vbCrLf &_											
'							" and carre_ccod_3= e.carre_ccod "& vbCrLf &_
'							" group by carre_tdesc,pcol_tdesc,teve_tdesc "& vbCrLf &_
'							" order by cantidad desc,carre_tdesc desc,tipo_evento desc  "
'-------------------------------------------------------------------------------INICIO CONSULTA ACTUALIZADA(SQLServer 2008)
sql_datos_eventos3= "select pcol_tdesc  as perfil, "& vbCrLf &_
"       teve_tdesc  as tipo_evento, "& vbCrLf &_ 
"       carre_tdesc as preferencia, "& vbCrLf &_
"       count(*)    as cantidad "& vbCrLf &_
"from   eventos_alumnos as a "& vbCrLf &_
"       join eventos_upa as b "& vbCrLf &_
"         on a.even_ncorr = b.even_ncorr "& vbCrLf &_
"            and b.teve_ccod not in ( 8 ) "& vbCrLf &_
"       join perfil_colegio as c "& vbCrLf &_
"         on b.pcol_ccod = c.pcol_ccod "& vbCrLf &_
"       join tipo_evento as d "& vbCrLf &_
"         on b.teve_ccod = d.teve_ccod "& vbCrLf &_
"       join carreras_eventos as e "& vbCrLf &_
"         on a.carre_ccod_3 = e.carre_ccod --se agrega a. "& vbCrLf &_        
"where  a.even_ncorr in (select even_ncorr "& vbCrLf &_
"                        from   eventos_upa as a "& vbCrLf &_
"                               left outer join ciudades as b "& vbCrLf &_ 
"                                            on a.ciud_ccod_origen = b.ciud_ccod "& vbCrLf &_
"                               join colegios as c "& vbCrLf &_
"                                 on a.cole_ccod = c.cole_ccod "& vbCrLf &_
"                        where  1=1 --datepart(year, a.even_fevento) =  datepart(year, getdate()) "& vbCrLf &_
"                       "&sql_adicional&" "& vbCrLf &_   
"                       ) "& vbCrLf &_
"group  by carre_tdesc, "& vbCrLf &_
"          pcol_tdesc, "& vbCrLf &_
"          teve_tdesc "& vbCrLf &_
"order  by cantidad desc, "& vbCrLf &_
"          carre_tdesc desc, "& vbCrLf &_
"          tipo_evento desc "		  
'-------------------------------------------------------------------------------FIN CONSULTA ACTUALIZADA(SQLServer 2008)		
formulario.consultar sql_datos_eventos
formulario2.consultar sql_datos_eventos2
formulario3.consultar sql_datos_eventos3

'response.Write("<pre>"&sql_datos_eventos&"</pre>")
'response.Write("<pre>"&sql_datos_eventos2&"</pre>")
'response.Write("<pre>"&sql_datos_eventos3&"</pre>")

%>


<html>
<head>
<title>Reporte Eventos</title>
</head>
<body>
<table width="100%">
<tr valign="top">
	<td>
		<table width="100%" border="1">
		  <tr>
			<td width="11%" bgcolor="#66CC00"><div align="center"><strong>Perfil</strong></div></td>
			<td width="11%" bgcolor="#66CC00"><div align="center"><strong>Tipo Evento</strong></div></td>
			<td width="11%" bgcolor="#66CC00"><div align="center"><strong>Primera Preferencia</strong></div></td>
			<td width="11%" bgcolor="#66CC00"><div align="center"><strong>Cantidad</strong></div></td>
		  </tr>
		  <%  while formulario.Siguiente %>
		  <tr>
			<td><div align="left"><%=formulario.ObtenerValor("perfil")%></div></td>
			<td><div align="left"><%=formulario.ObtenerValor("tipo_evento")%></div></td>
			<td><div align="left"><%=formulario.ObtenerValor("Preferencia")%></div></td>
			<td><div align="left"><%=formulario.ObtenerValor("Cantidad")%></div></td>
		 </tr>
		  <%  wend %>
		</table>
	</td>
<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	<td>
		<table width="100%" border="1">
		  <tr>
			<td width="11%" bgcolor="#66CC00"><div align="center"><strong>Perfil</strong></div></td>
			<td width="11%" bgcolor="#66CC00"><div align="center"><strong>Tipo Evento</strong></div></td>			
			<td width="11%" bgcolor="#66CC00"><div align="center"><strong>Segunda Preferencia</strong></div></td>
			<td width="11%" bgcolor="#66CC00"><div align="center"><strong>Cantidad</strong></div></td>  
		  </tr>
		  <%  while formulario2.Siguiente %>
		  <tr>
			<td><div align="left"><%=formulario2.ObtenerValor("perfil")%></div></td>
			<td><div align="left"><%=formulario2.ObtenerValor("tipo_evento")%></div></td>
			<td><div align="left"><%=formulario2.ObtenerValor("Preferencia")%></div></td>
			<td><div align="left"><%=formulario2.ObtenerValor("Cantidad")%></div></td>
		 </tr>
		  <%  wend %>
		</table>
	</td>
<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	<td>
		<table width="100%" border="1">
		  <tr>
			<td width="11%" bgcolor="#66CC00"><div align="center"><strong>Perfil</strong></div></td>
			<td width="11%" bgcolor="#66CC00"><div align="center"><strong>Tipo Evento</strong></div></td>
			<td width="11%" bgcolor="#66CC00"><div align="center"><strong>Tercera Preferencia</strong></div></td>
			<td width="11%" bgcolor="#66CC00"><div align="center"><strong>Cantidad</strong></div></td>
		  </tr>
		  <%  while formulario3.Siguiente %>
		  <tr>
			<td><div align="left"><%=formulario3.ObtenerValor("perfil")%></div></td>
			<td><div align="left"><%=formulario3.ObtenerValor("tipo_evento")%></div></td>
			<td><div align="left"><%=formulario3.ObtenerValor("Preferencia")%></div></td>
			<td><div align="left"><%=formulario3.ObtenerValor("Cantidad")%></div></td>
		 </tr>
		  <%  wend %>
		</table>
	</td>

</tr>
</table>
</body>
</html>

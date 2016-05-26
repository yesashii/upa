<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=alumnos_ceremonia.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
id_ceremonia=request.QueryString("id_ceremonia")
'------------------------------------------------------------------------------------
'response.End()
fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
fecha_ceremonia = conexion.consultaUno("select protic.trunc(fecha_ceremonia) from ceremonias_titulacion where cast(id_ceremonia as varchar)='"&id_ceremonia&"'")
sede = conexion.consultaUno("select protic.initCap(sede_tdesc) from ceremonias_titulacion a, sedes b where cast(id_ceremonia as varchar)='"&id_ceremonia&"' and a.sede_ccod=b.sede_ccod ")

'------------------------------------------------------------------------------------
set f_lista = new CFormulario
f_lista.Carga_Parametros "tabla_vacia.xml", "tabla"
f_lista.Inicializar conexion
 consulta = "select distinct *, case when ltrim(rtrim(carr_tdesc))=ltrim(rtrim(mencion_x_defecto)) then '' else  mencion_x_defecto end as mencion_x_defecto2 from ("& vbCrLf &_
            " select "& vbCrLf &_
            " (select top 1 sede_tdesc from alumnos tt, ofertas_academicas rr, sedes uu, especialidades zz "& vbCrLf &_
			"  where tt.pers_ncorr=e.pers_ncorr and tt.emat_ccod in (4,8) and tt.ofer_ncorr=rr.ofer_ncorr "& vbCrLf &_
			"  and rr.espe_ccod = zz.espe_ccod and zz.carr_ccod=c.carr_ccod and rr.sede_ccod=uu.sede_ccod) as sede_tdesc, "& vbCrLf &_
			"   d.carr_tdesc, "& vbCrLf &_ 
			"  (select top 1 jorn_tdesc from alumnos tt, ofertas_academicas rr, jornadas uu, especialidades zz "& vbCrLf &_
			"   where tt.pers_ncorr=e.pers_ncorr and tt.emat_ccod in (4,8) and tt.ofer_ncorr=rr.ofer_ncorr "& vbCrLf &_
			"   and rr.espe_ccod=zz.espe_ccod and zz.carr_ccod=c.carr_ccod and rr.jorn_ccod=uu.jorn_ccod) as jorn_tdesc, "& vbCrLf &_
			" case isnull(incluir_mencion,'0') when '0' then '' else nombre_mencion end as mencion, "& vbCrLf &_
			" cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, "& vbCrLf &_
			" pers_tnombre as nombres, pers_tape_paterno + ' ' + pers_tape_materno as apellidos, "& vbCrLf &_
			" replace(asca_nnota,',','.') as nota,datepart(year,fecha_titulacion) as anos_ccod, "& vbCrLf &_
			" case when datepart(year,fecha_titulacion) <= 2005 then case when asca_nnota >= 4.0 and asca_nnota <= 4.9 then 'UNANIMIDAD' "& vbCrLf &_
			"                                          when asca_nnota >= 5.0 and asca_nnota <= 5.4 then 'UN VOTO DE DISTINCION'  "& vbCrLf &_
			"                                          when asca_nnota >= 5.5 and asca_nnota <= 5.9 then 'DOS VOTOS DE DISTINCION' "& vbCrLf &_
			"                                          when asca_nnota >= 6.0 and asca_nnota <= 6.4 then 'TRES VOTOS DE DISTINCION' "& vbCrLf &_
			"                                          when asca_nnota >= 6.5 and asca_nnota <= 7.0 then 'APROBADO CON DISTINCION MAXIMA' "& vbCrLf &_
			"                                      end  "& vbCrLf &_
			"                                 else case when asca_nnota >= 4.0 and asca_nnota <= 4.9 then 'APROBADO POR UNANIMIDAD' "& vbCrLf &_
			"                                           when asca_nnota >= 5.0 and asca_nnota <= 5.9 then 'APROBADO CON DISTINCION'   "& vbCrLf &_
			"                                           when asca_nnota >= 6.0 and asca_nnota <= 7.0 then 'APROBADO CON DISTINCION MAXIMA' "& vbCrLf &_
			"                                      end "& vbCrLf &_
			" end as distincion_obtenida,g.asca_nfolio as folio, protic.trunc(g.asca_fsalida) as fecha_examen, "& vbCrLf &_
			" protic.obtener_direccion(e.pers_ncorr,1,'CNPB') as dirección, protic.obtener_direccion(e.pers_ncorr,1,'C-C') as ciudad,"& vbCrLf &_
			" e.pers_tfono as teléfono, e.pers_tcelular as celular, e.pers_temail as email,"& vbCrLf &_
			"  case when replace(replace(c.espe_tdesc,'(D)',''),'(V)','') "& vbCrLf &_
			"       like '%sin mencion%' then ''  "& vbCrLf &_
			"       when replace(replace(c.espe_tdesc,'(D)',''),'(V)','') "& vbCrLf &_
			"       like '%plan comun%' then '' "& vbCrLf &_
			"  else replace(replace(c.espe_tdesc,'(D)',''),'(V)','') end  as mencion_x_defecto "& vbCrLf &_
			" from detalles_titulacion_carrera a, planes_estudio b, especialidades c,carreras d,personas e, "& vbCrLf &_
			" salidas_carrera f, alumnos_salidas_carrera g"& vbCrLf &_
			" where a.plan_ccod=b.plan_ccod and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod "& vbCrLf &_
			" and a.pers_ncorr=e.pers_ncorr and a.carr_ccod= f.carr_ccod and f.saca_ncorr=g.saca_ncorr and g.pers_ncorr=a.pers_ncorr "& vbCrLf &_
			" and cast(a.id_ceremonia as varchar)='"&id_ceremonia&"'"


f_lista.Consultar consulta & ")table1 order by carr_tdesc, mencion, apellidos "
%>
<html>
<head>
<title>Listado alumnos ceremonia</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado Alumnos ceremonia</font></div></td>
 </tr>
 <tr> 
    <td colspan="4">&nbsp;</td>
 </tr>
 <tr> 
    <td colspan="4">Fecha Actual: <%=fecha%></div></td>
 </tr>
 <tr> 
    <td colspan="4">Fecha Ceremonia: <%=fecha_ceremonia%></div></td>
 </tr>
 <tr> 
    <td colspan="4">Sede: <%=sede%></div></td>
 </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
<tr>
	<td colspan="2" align="center">
		<table width="75%" border="1">
		  <tr> 
				<td bgcolor="#FFFFCC"><div align="center"><strong>N°</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Sede</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Carrera</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Jornada</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Mención</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Mención Por Defecto</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>RUT</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Nombres</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Apellidos</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Calificación</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Distinción Obtenida</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>N° de Folio</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Fecha Examen</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Dirección</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Ciudad</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Teléfono</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Celular</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>E-mail</strong></div></td>
			</tr>
			<% fila = 1 
			 while f_lista.Siguiente %>
			<tr> 
				<td><div align="center"><%=fila%></div></td>
				<td><div align="left"><%=f_lista.ObtenerValor("sede_tdesc")%></div></td>
				<td><div align="left"><%=f_lista.ObtenerValor("carr_tdesc")%></div></td>
				<td><div align="left"><%=f_lista.ObtenerValor("jorn_tdesc")%></div></td>
				<td><div align="left"><%=f_lista.ObtenerValor("mencion")%></div></td>
				<td><div align="left"><%=f_lista.ObtenerValor("mencion_x_defecto2")%></div></td>
				<td><div align="left"><%=f_lista.ObtenerValor("rut")%></div></td>
				<td><div align="left"><%=f_lista.ObtenerValor("nombres")%></div></td>
				<td><div align="left"><%=f_lista.ObtenerValor("apellidos")%></div></td>	
				<td><div align="center"><%=f_lista.ObtenerValor("nota")%></div></td>
				<td><div align="left"><%=f_lista.ObtenerValor("distincion_obtenida")%></div></td>
				<td><div align="center"><%=f_lista.ObtenerValor("folio")%></div></td>
				<td><div align="center"><%=f_lista.ObtenerValor("fecha_examen")%></div></td>
				<td><div align="center"><%=f_lista.ObtenerValor("dirección")%></div></td>
				<td><div align="center"><%=f_lista.ObtenerValor("ciudad")%></div></td>
				<td><div align="center"><%=f_lista.ObtenerValor("teléfono")%></div></td>
				<td><div align="center"><%=f_lista.ObtenerValor("celular")%></div></td>
				<td><div align="center"><%=f_lista.ObtenerValor("email")%></div></td>
			</tr>
			<%fila= fila + 1  
			wend %>
		</table>
	</td>
</tr>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_softland_escuelas.xls"
Response.ContentType = "application/vnd.ms-excel"
'Response.ContentType = "application/vnd.ms-excel"
'---------------------------------------------------------------------------------------------------
'carr_ccod = request.QueryString("busqueda[0][carr_ccod]")
'response.Write("carrera :" & carr_ccod)
'response.End()
set pagina = new CPagina
'pagina.Titulo = "Reporte Planificacion General" 

set conexion = new cConexion
set negocio = new cNegocio
set formu_resul= new cformulario
set resultado_busqueda = new cFormulario
conexion.inicializar "upacifico"
negocio.inicializa conexion



sql_listado_escuelas = " select za.ccos_tcompuesto,a.codigo,a.rut,a.pers_tnombre,a.pers_tape_paterno,a.pers_tape_materno,a.tipo_profesor, "& vbCrLf &_
						"	f.facu_tdesc as facultad,c.carr_tdesc as carrera,d.sede_tdesc as sede,a.anex_ncodigo,  "& vbCrLf &_
						"	protic.trunc(b.anex_finicio) as fecha_inicio,protic.trunc(b.anex_ffin) as fecha_fin, b.anex_ncuotas, "& vbCrLf &_ 
						"	sum(enero) as t_enero,sum(febrero) as t_febrero,sum(marzo) as t_marzo,sum(abril) as t_abril, "& vbCrLf &_
						"	sum(mayo) as t_mayo,sum(junio) as t_junio,sum(julio) as t_julio,sum(agosto) as t_agosto, "& vbCrLf &_
						"	sum(septiembre) as t_septiembre,sum(octubre) as t_octubre,sum(noviembre) as t_noviembre,sum(diciembre) as t_diciembre,  "& vbCrLf &_
						"	sum(monto_mensual) as total_carrera_anexo, "& vbCrLf &_
						"   protic.obtiene_categoria_carrera(a.pers_ncorr,b.sede_ccod,b.carr_ccod,b.jorn_ccod) as categoria "& vbCrLf &_
						"	 From ( "& vbCrLf &_
								"	select case mes when 1 then sum(valor_mensual) end as enero, "& vbCrLf &_
								"	case mes when 2 then sum(valor_mensual) end as febrero, "& vbCrLf &_
								"	case mes when 3 then sum(valor_mensual) end as marzo, "& vbCrLf &_
								"	case mes when 4 then sum(valor_mensual) end as abril, "& vbCrLf &_
								"	case mes when 5 then sum(valor_mensual) end as mayo, "& vbCrLf &_
								"	case mes when 6 then sum(valor_mensual) end as junio, "& vbCrLf &_
								"	case mes when 7 then sum(valor_mensual) end as julio, "& vbCrLf &_
								"	case mes when 8 then sum(valor_mensual) end as agosto, "& vbCrLf &_
								"	case mes when 9 then sum(valor_mensual) end as septiembre, "& vbCrLf &_
								"	case mes when 10 then sum(valor_mensual) end as octubre, "& vbCrLf &_
								"	case mes when 11 then sum(valor_mensual) end as noviembre, "& vbCrLf &_
								"	case mes when 12 then sum(valor_mensual) end as diciembre, "& vbCrLf &_
								"	carr_ccod,anex_ncodigo,anex_ncorr,b.pers_nrut as codigo,protic.obtener_rut(b.pers_ncorr) as rut,b.pers_tnombre, "& vbCrLf &_
								"	b.pers_tape_paterno,b.pers_tape_materno,ss.tipo_profesor, sum(valor_mensual) as monto_mensual,b.pers_ncorr     "& vbCrLf &_
								"	  from (    "& vbCrLf &_
									"	 select b.carr_ccod,mes,b.anex_ncodigo,b.anex_ncorr,pers_ncorr,cast(((sum(sesiones)+b.anex_nhoras_coordina)*monto_cuota) /b.anex_ncuotas as numeric) as valor_mensual,tipo_profesor  "& vbCrLf &_
									 "	from (     "& vbCrLf &_
										 "	select b.carr_ccod,q.mes_ccod as mes, a.pers_ncorr,(c.dane_nsesiones/2) as sesiones, b.anex_ncorr,c.dane_msesion as monto_cuota,o.tpro_tdesc as tipo_profesor  "& vbCrLf &_
											  "	From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,  "& vbCrLf &_   
											  "		asignaturas j, secciones n,tipos_profesores o,profesores p , meses q  "& vbCrLf &_    
													"	Where a.cdoc_ncorr     =   b.cdoc_ncorr   "& vbCrLf &_
														  "	and b.anex_ncorr    =   c.anex_ncorr  "& vbCrLf &_    
														  "	and a.pers_ncorr    =   d.pers_ncorr  "& vbCrLf &_    
														  "	and b.sede_ccod     =   e.sede_ccod   "& vbCrLf &_   
														  "	and c.asig_ccod     =   j.asig_ccod    "& vbCrLf &_  
														  "	and n.secc_ccod     =   c.secc_ccod  "& vbCrLf &_    
														  "	and o.TPRO_CCOD     =   p.TPRO_CCOD   "& vbCrLf &_   
														  "	and p.pers_ncorr    =   d.pers_ncorr  "& vbCrLf &_    
														  "	AND b.SEDE_CCOD     =   p.sede_ccod   "& vbCrLf &_  
														  "	and a.ecdo_ccod     <>   3    "& vbCrLf &_ 
														  "	and b.eane_ccod     <> 3   "& vbCrLf &_
														  "	and a.ano_contrato=datepart(year,getdate())   "& vbCrLf &_
														  "	and q.mes_ccod  >=  datepart(month,b.anex_finicio)  "& vbCrLf &_
														  "	and q.mes_ccod <= datepart(month,b.anex_ffin) "& vbCrLf &_
										"	 group by b.carr_ccod,q.mes_ccod,c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc   "& vbCrLf &_  
									 "	) as aa, anexos b    "& vbCrLf &_
									 "	where aa.anex_ncorr=b.anex_ncorr    "& vbCrLf &_ 
									 "	group by b.carr_ccod,aa.mes,b.anex_ncodigo,b.anex_ncorr,pers_ncorr,b.anex_nhoras_coordina,monto_cuota,b.anex_ncuotas,tipo_profesor     "& vbCrLf &_
								 "	) ss ,personas b  "& vbCrLf &_   
								 "	 where ss.pers_ncorr=cast(b.pers_ncorr as varchar)     "& vbCrLf &_
								 "	 group by  carr_ccod,mes,anex_ncodigo,anex_ncorr,b.pers_nrut,b.pers_ncorr,b.pers_tnombre,b.pers_tape_paterno,b.pers_tape_materno,ss.tipo_profesor   "& vbCrLf &_
						"	) as a ,anexos b, carreras c, sedes d, areas_academicas e, facultades f, centros_costos_asignados z, centros_costo za "& vbCrLf &_
						"	where a.anex_ncorr=b.anex_ncorr "& vbCrLf &_
						"	and b.carr_ccod=c.carr_ccod "& vbCrLf &_
						"	and b.sede_ccod=d.sede_ccod "& vbCrLf &_
						"	and c.area_ccod=e.area_ccod "& vbCrLf &_
						"	and e.facu_ccod=f.facu_ccod "& vbCrLf &_
                        "   and z.cenc_ccod_carrera=c.carr_ccod "& vbCrLf &_
						"   and z.cenc_ccod_sede=d.sede_ccod "& vbCrLf &_
						"   and z.cenc_ccod_jornada=b.jorn_ccod "& vbCrLf &_
                        "   and za.ccos_ccod=z.ccos_ccod "& vbCrLf &_						
						"	group by  b.carr_ccod,b.jorn_ccod,a.pers_ncorr,za.ccos_tcompuesto,a.carr_ccod,a.anex_ncodigo,a.anex_ncorr,a.rut,a.codigo,a.pers_tnombre,a.pers_tape_paterno,a.pers_tape_materno,a.tipo_profesor,  "& vbCrLf &_
						"	b.anex_finicio,b.anex_ffin, b.anex_ncuotas, b.sede_ccod, c.carr_tdesc,d.sede_tdesc, f.facu_tdesc   "& vbCrLf &_
						"	order by  pers_tape_paterno,pers_tape_materno,pers_tnombre,a.anex_ncodigo desc "
	
	
	
'response.Write("<pre>"&sql_detalles_mate&"</pre>")
'response.End()
set f_valor_escuelas  = new cformulario
f_valor_escuelas.carga_parametros "tabla_vacia.xml", "tabla" 
f_valor_escuelas.inicializar conexion							
f_valor_escuelas.consultar sql_listado_escuelas

'------------------------------------------------------------------------------
%>
 <html>
<head>
<title><%=pagina.Titulo%></title>  

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="75%" border="1">
  <tr>
    <td><div align="center"><strong>Centro Costo</strong></div></td>
    <td><div align="center"><strong>Categoria</strong></div></td> 	 
    <td><div align="center"><strong>Rut Sin Digito</strong></div></td>
    <td><div align="center"><strong>Rut</strong></div></td>
    <td><div align="center"><strong>Docente/Ayudante</strong></div></td>
    <td><div align="center"><strong>Apellido Paterno</strong></div></td>
	<td><div align="center"><strong>Apellido Materno</strong></div></td>
	<td><div align="center"><strong>Nombre</strong></div></td>
    <td><div align="center"><strong>Facultad</strong></div></td>	
    <td><div align="center"><strong>Sedes</strong></div></td>
    <td><div align="center"><strong>Carreras</strong></div></td>
    <td><div align="center"><strong>Anexo</strong></div></td>
	<td><div align="center"><strong>Fecha Inicio</strong></div></td>
	<td><div align="center"><strong>Fecha Termino</strong></div></td>
	<td><div align="center"><strong>N° Cuotas</strong></div></td>
	<td><div align="center"><strong>Enero</strong></div></td>
	<td><div align="center"><strong>Febrero</strong></div></td>
	<td><div align="center"><strong>Marzo</strong></div></td>
	<td><div align="center"><strong>Abril</strong></div></td>
	<td><div align="center"><strong>Mayo</strong></div></td>
	<td><div align="center"><strong>Junio</strong></div></td>
	<td><div align="center"><strong>Julio</strong></div></td>
	<td><div align="center"><strong>Agosto</strong></div></td>
	<td><div align="center"><strong>Septiembre</strong></div></td>
	<td><div align="center"><strong>Octubre</strong></div></td>
	<td><div align="center"><strong>Noviembre</strong></div></td>
	<td><div align="center"><strong>Diciembre</strong></div></td>
	<td><div align="center"><strong>Total Carrera-Anexo</strong></div></td>						
  </tr>
  <%  while f_valor_escuelas.Siguiente %>
  <tr> 
    <td><div align="left"><%=f_valor_escuelas.ObtenerValor("ccos_tcompuesto")%></div></td>
    <td><div align="left"><%=f_valor_escuelas.ObtenerValor("categoria")%></div></td>		
    <td><div align="left"><%=f_valor_escuelas.ObtenerValor("codigo")%></div></td>	
    <td><div align="left"><%=f_valor_escuelas.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_valor_escuelas.ObtenerValor("tipo_profesor")%></div></td>
    <td><div align="left"><%=f_valor_escuelas.ObtenerValor("pers_tape_paterno")%></div></td>
	<td><div align="left"><%=f_valor_escuelas.ObtenerValor("pers_tape_materno")%></div></td>
	<td><div align="left"><%=f_valor_escuelas.ObtenerValor("pers_tnombre")%></div></td>
	<td><div align="left"><%=f_valor_escuelas.ObtenerValor("facultad")%></div></td>
    <td><div align="left"><%=f_valor_escuelas.ObtenerValor("sede")%></div></td>
    <td><div align="left"><%=f_valor_escuelas.ObtenerValor("carrera")%></div></td>
    <td><div align="left"><%=f_valor_escuelas.ObtenerValor("anex_ncodigo")%></div></td>
	<td><div align="right"><%=f_valor_escuelas.ObtenerValor("fecha_inicio")%></div></td>
	<td><div align="right"><%=f_valor_escuelas.ObtenerValor("fecha_fin")%></div></td>
	<td><div align="right"><%=f_valor_escuelas.ObtenerValor("anex_ncuotas")%></div></td>
	<td><div align="right"><%=f_valor_escuelas.ObtenerValor("t_enero")%></div></td>
	<td><div align="right"><%=f_valor_escuelas.ObtenerValor("t_febrero")%></div></td>
	<td><div align="right"><%=f_valor_escuelas.ObtenerValor("t_marzo")%></div></td>
	<td><div align="right"><%=f_valor_escuelas.ObtenerValor("t_abril")%></div></td>
	<td><div align="right"><%=f_valor_escuelas.ObtenerValor("t_mayo")%></div></td>
	<td><div align="right"><%=f_valor_escuelas.ObtenerValor("t_junio")%></div></td>
	<td><div align="right"><%=f_valor_escuelas.ObtenerValor("t_julio")%></div></td>
	<td><div align="right"><%=f_valor_escuelas.ObtenerValor("t_agosto")%></div></td>							
	<td><div align="right"><%=f_valor_escuelas.ObtenerValor("t_septiembre")%></div></td>
	<td><div align="right"><%=f_valor_escuelas.ObtenerValor("t_octubre")%></div></td>
	<td><div align="right"><%=f_valor_escuelas.ObtenerValor("t_noviembre")%></div></td>
	<td><div align="right"><%=f_valor_escuelas.ObtenerValor("t_diciembre")%></div></td>
	<td><div align="right"><%=f_valor_escuelas.ObtenerValor("total_carrera_anexo")%></div></td>			
	
  </tr>
  <%  wend %>
</table>
</body>
</html>
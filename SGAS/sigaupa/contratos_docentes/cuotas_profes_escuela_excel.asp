<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_softland_escuelas.xls"
Response.ContentType = "application/vnd.ms-excel"
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio
set formu_resul= new cformulario
set resultado_busqueda = new cFormulario
conexion.inicializar "upacifico"
negocio.inicializa conexion

mes_ccod = conexion.consultaUno("select cast(datepart(month,getdate()) as varchar)")

if mes_ccod="2" then
	v_dia="28"
else
	v_dia="30"
end if

Periodo = negocio.ObtenerPeriodoAcademico("PLANIFICACION")
anos_ccod = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&Periodo&"'")

sql_listado_escuelas = " select hora_cordina,anexo,jerarquia,tipo_contrato,b.pers_nrut as codigo,protic.obtener_rut(b.pers_ncorr) as rut,b.pers_tape_paterno,b.pers_tape_materno,b.pers_tnombre,ss.tipo_profesor, sum(valor_mensual) as monto_mensual,x.sede_tdesc,y.carr_tdesc,w.jorn_tdesc,za.ccos_tcompuesto, especialidad    " & vbcrlf & _
"						  from (   " & vbcrlf & _
"						  select  anexo,jerarquia,tipo_contrato,pers_ncorr,hora_cordina,sum(valor_mensual) as valor_mensual,tipo_profesor,sede_ccod,carr_ccod,jorn_ccod, especialidad    " & vbcrlf & _
"						       from  (    					" & vbcrlf & _
"						      select aa.anex_ncorr as anexo,jerarquia,tipo_contrato,pers_ncorr,cast((b.anex_nhoras_coordina*monto_cuota)/b.anex_ncuotas as  numeric) as hora_cordina, cast(((sum(sesiones))*monto_cuota) /b.anex_ncuotas as numeric) as valor_mensual,tipo_profesor,b.sede_ccod,b.carr_ccod,b.jorn_ccod, especialidad    " & vbcrlf & _
"							      from (    " & vbcrlf & _
"							          select r.jdoc_tdesc as jerarquia,tcdo_tdesc as tipo_contrato,a.pers_ncorr,(c.dane_nsesiones/2) as sesiones, b.anex_ncorr,c.dane_msesion as monto_cuota,o.tpro_tdesc as tipo_profesor, " & vbcrlf & _
"                                       (select top 1 espe_tdesc from secciones ase, malla_curricular bm, planes_estudio cp, especialidades de " & vbcrlf & _
"                                        where ase.mall_ccod=bm.mall_ccod " & vbcrlf & _
"                                        and bm.plan_ccod=cp.plan_ccod " & vbcrlf & _
"                                        and cp.espe_ccod=de.espe_ccod " & vbcrlf & _
"                                        and ase.secc_ccod=c.secc_ccod " & vbcrlf & _
"                                        ) as especialidad " & vbcrlf & _
"												  From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,     " & vbcrlf & _
"							  			             asignaturas j, secciones n,tipos_profesores o,profesores p, tipos_contratos_docentes q,jerarquias_docentes r           " & vbcrlf & _
"							  			          Where a.cdoc_ncorr     =   b.cdoc_ncorr      	" & vbcrlf & _
"							  			             and b.anex_ncorr    =   c.anex_ncorr      	" & vbcrlf & _
"							  			             and a.pers_ncorr    =   d.pers_ncorr      	" & vbcrlf & _
"							  			             and b.sede_ccod     =   e.sede_ccod      	" & vbcrlf & _
"							  			             and c.asig_ccod     =   j.asig_ccod      	" & vbcrlf & _
"							  			             and n.secc_ccod     =   c.secc_ccod      	" & vbcrlf & _
"							  			             and o.TPRO_CCOD     =   p.TPRO_CCOD      	" & vbcrlf & _
"							  			             and p.pers_ncorr    =   d.pers_ncorr      	" & vbcrlf & _
"							  			             AND b.SEDE_CCOD     =   p.sede_ccod		" & vbcrlf & _
"                                                     and a.tcdo_ccod=q.tcdo_ccod     			" & vbcrlf & _     
"									  		         and p.jdoc_ccod=r.jdoc_ccod       			" & vbcrlf & _                                                  
"							                         and a.ecdo_ccod     <>   3  " & vbcrlf & _
"							                         and b.eane_ccod     <> 3    " & vbcrlf & _
"							  						 and c.secc_ccod  not in (select secc_ccod from seccion_carrera_plan_comun) " & vbcrlf & _   
"							                         and datepart(year,b.anex_finicio)='"&anos_ccod&"'--and a.ano_contrato=datepart(year,getdate())  " & vbcrlf & _  						
"							 						 --and datepart(month,getdate()) between  datepart(month,b.anex_finicio) and datepart(month,b.anex_ffin) " & vbcrlf & _   
"							                         and convert(datetime,'"&v_dia&"/'+cast(datepart(month,getdate()) as varchar)+'/'+cast(datepart(year,getdate()) as varchar),103) between  convert(datetime,b.anex_finicio,103) and convert(datetime,b.anex_ffin,103)    " & vbcrlf & _
"							          group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc, tcdo_tdesc,jdoc_tdesc   " & vbcrlf & _   
"							      ) as aa,    " & vbcrlf & _
"							      anexos b    " & vbcrlf & _
"							      where aa.anex_ncorr=b.anex_ncorr   " & vbcrlf & _ 
"							      group by aa.anex_ncorr,especialidad,b.anex_ncorr,pers_ncorr,b.anex_nhoras_coordina,monto_cuota,b.anex_ncuotas,tipo_profesor,b.sede_ccod,b.carr_ccod,b.jorn_ccod,jerarquia,tipo_contrato    " & vbcrlf & _
"						   )as tabla1      " & vbcrlf & _
"						  Group by hora_cordina,anexo,pers_ncorr,tipo_profesor,sede_ccod,carr_ccod,jorn_ccod,jerarquia,tipo_contrato, especialidad   " & vbcrlf & _ 
"					  Union --agrega los centros de costo del plan comun    " & vbcrlf & _
"						    Select anexo,jerarquia,tipo_contrato,pers_ncorr,hora_cordina,sum(valor_mensual) as valor_mensual,tipo_profesor,sede_ccod,carr_ccod,jorn_ccod,especialidad    " & vbcrlf & _
"						        from  (    " & vbcrlf & _
"						      select aa.anex_ncorr as anexo,jerarquia,tipo_contrato,pers_ncorr,cast((b.anex_nhoras_coordina*monto_cuota)/b.anex_ncuotas as  numeric) as hora_cordina,cast(cast(((sum(sesiones)+ case when unico=0 then 0 else 0 end)*monto_cuota) /b.anex_ncuotas as numeric)/comparte as numeric) as valor_mensual,tipo_profesor,pc.sede_ccod,pc.carr_ccod,pc.jorn_ccod, " & vbcrlf & _
"                              (select top 1 espe_tdesc from secciones a, malla_curricular b, planes_estudio c, especialidades d  " & vbcrlf & _ 
"                                    where a.mall_ccod=b.mall_ccod  " & vbcrlf & _ 
"                                    and b.plan_ccod=c.plan_ccod  " & vbcrlf & _ 
"                                   and c.espe_ccod=d.espe_ccod  " & vbcrlf & _ 
"                                    and a.secc_ccod=aa.secc_ccod  " & vbcrlf & _ 
"                              ) as especialidad    " & vbcrlf & _ 
"									from (      " & vbcrlf & _
"							            select r.jdoc_tdesc as jerarquia,tcdo_tdesc as tipo_contrato, (select count(*) from seccion_carrera_plan_comun where secc_ccod=c.secc_ccod) as comparte,    " & vbcrlf & _
"							            (select count(*) from detalle_anexos where anex_ncorr=b.anex_ncorr and secc_ccod not in (select secc_ccod from seccion_carrera_plan_comun)) as unico,    " & vbcrlf & _
"							           c.secc_ccod,a.pers_ncorr,(c.dane_nsesiones/2) as sesiones, b.anex_ncorr,c.dane_msesion as monto_cuota,o.tpro_tdesc as tipo_profesor       " & vbcrlf & _
"									        From contratos_docentes_upa a, anexos b, detalle_anexos c, personas d,  sedes e,        " & vbcrlf & _
"									  		         asignaturas j, secciones n,tipos_profesores o,profesores p , tipos_contratos_docentes q,jerarquias_docentes r         " & vbcrlf & _
"									  	          Where a.cdoc_ncorr     =   b.cdoc_ncorr         " & vbcrlf & _
"									  		         and b.anex_ncorr    =   c.anex_ncorr         " & vbcrlf & _
"									  		         and a.pers_ncorr    =   d.pers_ncorr         " & vbcrlf & _
"									  		         and b.sede_ccod     =   e.sede_ccod          " & vbcrlf & _
"									  		         and c.asig_ccod     =   j.asig_ccod          " & vbcrlf & _
"									  		         and n.secc_ccod     =   c.secc_ccod          " & vbcrlf & _
"									  		         and o.TPRO_CCOD     =   p.TPRO_CCOD          " & vbcrlf & _
"									  		         and p.pers_ncorr    =   d.pers_ncorr         " & vbcrlf & _
"									  		         AND b.SEDE_CCOD     =   p.sede_ccod          " & vbcrlf & _
"                                                    and a.tcdo_ccod=q.tcdo_ccod            " & vbcrlf & _
"									  		         and p.jdoc_ccod=r.jdoc_ccod			" & vbcrlf & _
"                                                    and a.ecdo_ccod     <>     3     		" & vbcrlf & _
"									  		         and b.eane_ccod     <>     3     		" & vbcrlf & _
"									                 and c.secc_ccod  in (select secc_ccod from seccion_carrera_plan_comun)   " & vbcrlf & _       
"									  		         and datepart(year,b.anex_finicio)=datepart(year,getdate())--and a.ano_contrato=datepart(year,getdate()) " & vbcrlf & _      						
"									                 and convert(datetime,'"&v_dia&"/'+cast(datepart(month,getdate()) as varchar)+'/'+cast(datepart(year,getdate()) as varchar),103) between  convert(datetime,b.anex_finicio,103) and convert(datetime,b.anex_ffin,103)    " & vbcrlf & _
"									  --         and datepart(month,getdate()) between  datepart(month,b.anex_finicio) and datepart(month,b.anex_ffin)       " & vbcrlf & _
"						  		          group by c.secc_ccod,a.pers_ncorr,b.anex_ncorr,a.cdoc_ncorr,c.dane_nsesiones,c.dane_msesion,tpro_tdesc, tcdo_tdesc,jdoc_tdesc    " & vbcrlf & _      
"						  	          ) as aa,       " & vbcrlf & _
"						  	          anexos b, seccion_carrera_plan_comun pc       " & vbcrlf & _
"						  	          where aa.anex_ncorr=b.anex_ncorr    " & vbcrlf & _
"						                and aa.secc_ccod =pc.secc_ccod       " & vbcrlf & _
"						  	          group by aa.anex_ncorr,unico,comparte,aa.secc_ccod,b.anex_ncorr,pers_ncorr,b.anex_nhoras_coordina,monto_cuota,b.anex_ncuotas,tipo_profesor,pc.sede_ccod,pc.carr_ccod,pc.jorn_ccod,jerarquia,tipo_contrato  " & vbcrlf & _
"						          ) as tabla   " & vbcrlf & _
"						          Group by hora_cordina,anexo,pers_ncorr,tipo_profesor,sede_ccod,carr_ccod,jorn_ccod ,jerarquia,tipo_contrato,especialidad	" & vbcrlf & _
"						 	) ss     " & vbcrlf & _
"						 	join personas b    " & vbcrlf & _
"						 		on ss.pers_ncorr=cast(b.pers_ncorr as varchar)    " & vbcrlf & _
"						 	join carreras y    								" & vbcrlf & _
"						 		on ss.carr_ccod =y.carr_ccod 				" & vbcrlf & _   
"						 	join sedes x    								" & vbcrlf & _
"						 		on ss.sede_ccod =x.sede_ccod     			" & vbcrlf & _
"						 	join jornadas w    								" & vbcrlf & _
"						 		on ss.jorn_ccod =w.jorn_ccod 				" & vbcrlf & _    
"						 	left outer join centros_costos_asignados z    	" & vbcrlf & _
"						 		on z.cenc_ccod_carrera  =ss.carr_ccod       " & vbcrlf & _
"						 		and z.cenc_ccod_sede    =ss.sede_ccod       " & vbcrlf & _
"						 		and z.cenc_ccod_jornada =ss.jorn_ccod    	" & vbcrlf & _
"						 	left outer join centros_costo za    			" & vbcrlf & _
"						 		on za.ccos_ccod=z.ccos_ccod	   	 			" & vbcrlf & _
"						  group by  hora_cordina,anexo,za.ccos_tcompuesto,b.pers_nrut,b.pers_ncorr,b.pers_tnombre,b.pers_tape_paterno,b.pers_tape_materno,ss.tipo_profesor,x.sede_tdesc,y.carr_tdesc,w.jorn_tdesc, jerarquia,tipo_contrato,especialidad "

	
	
	
'response.Write("<pre>"&sql_listado_escuelas&"</pre>")
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
   <td><div align="center"><strong>Rut Sin Digito</strong></div></td>
  <td><div align="center"><strong>Rut</strong></div></td>
  <td><div align="center"><strong>Docente/Ayudante</strong></div></td>
    <td><div align="center"><strong>Apellido Paterno</strong></div></td>
	<td><div align="center"><strong>Apellido Materno</strong></div></td>
	<td><div align="center"><strong>Nombre</strong></div></td>
    <td><div align="center"><strong>Sedes</strong></div></td>
    <td><div align="center"><strong>Carreras</strong></div></td>
    <td><div align="center"><strong>Jornadas</strong></div></td>
	<td><div align="center"><strong>Horas C.</strong></div></td>
	<td><div align="center"><strong>Valor Cuota</strong></div></td>
	<td><div align="center"><strong>Centro Costo</strong></div></td>
	<td><div align="center"><strong>Tipo Contrato</strong></div></td>
	<td><div align="center"><strong>Jerarquia</strong></div></td>
	<td><div align="center"><strong>Especialidad</strong></div></td>		
  </tr>
  <%  
  	v_anexo=0
	while f_valor_escuelas.Siguiente 
		if Cint(v_anexo) <> Cint(f_valor_escuelas.ObtenerValor("anexo")) then
			v_horas_coordina=f_valor_escuelas.ObtenerValor("hora_cordina")
		else
			v_horas_coordina="0"
		end if
		v_anexo=f_valor_escuelas.ObtenerValor("anexo")
  
  %>
  <tr> 
    <td><div align="left"><%=f_valor_escuelas.ObtenerValor("codigo")%></div></td>
    <td><div align="left"><%=f_valor_escuelas.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_valor_escuelas.ObtenerValor("tipo_profesor")%></div></td>
    <td><div align="left"><%=f_valor_escuelas.ObtenerValor("pers_tape_paterno")%></div></td>
	<td><div align="left"><%=f_valor_escuelas.ObtenerValor("pers_tape_materno")%></div></td>
	<td><div align="left"><%=f_valor_escuelas.ObtenerValor("pers_tnombre")%></div></td>
    <td><div align="left"><%=f_valor_escuelas.ObtenerValor("sede_tdesc")%></div></td>
    <td><div align="left"><%=f_valor_escuelas.ObtenerValor("carr_tdesc")%></div></td>
    <td><div align="left"><%=f_valor_escuelas.ObtenerValor("jorn_tdesc")%></div></td>
	<td><div align="right"><%=v_horas_coordina%></div></td>
	<td><div align="right"><%=f_valor_escuelas.ObtenerValor("monto_mensual")%></div></td>
	<td><div align="right"><%=f_valor_escuelas.ObtenerValor("ccos_tcompuesto")%></div></td>
	<td><div align="right"><%=f_valor_escuelas.ObtenerValor("tipo_contrato")%></div></td>
	<td><div align="right"><%=f_valor_escuelas.ObtenerValor("jerarquia")%></div></td>
	<td><div align="right"><%=f_valor_escuelas.ObtenerValor("especialidad")%></div></td>
  </tr>
  <%  wend %>
</table>
</body>
</html>
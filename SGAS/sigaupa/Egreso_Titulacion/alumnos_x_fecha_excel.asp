<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=listado_x_fecha.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 150000
'---------------------------------------------------------------------------------------------------
inicio = request.QueryString("inicio")
termino = request.QueryString("termino")
tipo = request.QueryString("tipo")
'response.Write("carrera :" & carr_ccod)
'response.End()

set pagina = new CPagina
pagina.Titulo = "Listados Alumnos egresados o Titulados" 

set conexion = new cConexion
conexion.inicializar "upacifico"

titulo_temp = "NOMINA DE ALUMNOS" 

if tipo="4" then
    titulo_temp = titulo_temp & " EGRESADOS"
	if inicio <> "" and termino <> "" then
	            titulo_temp = titulo_temp & " ENTRE EL "&inicio&" Y EL "&termino
				filtro_fecha = " AND convert(datetime,protic.trunc(fecha_egreso),103) between convert(datetime,'" & inicio & "',103) and convert(datetime,'" & termino & "',103)"& vbCrLf
	elseif inicio <> "" and termino = "" then	
	            titulo_temp = titulo_temp & " A PARTIR DEL "&inicio    
				filtro_fecha = " AND convert(datetime,protic.trunc(fecha_egreso),103) >= convert(datetime,'" & inicio & "',103) "& vbCrLf
	elseif inicio = "" and termino <> "" then	
	            titulo_temp = titulo_temp & " HASTA EL "&termino       
				filtro_fecha = " AND convert(datetime,protic.trunc(fecha_egreso),103) <= convert(datetime,'" & termino & "',103) "& vbCrLf	
	end if	
	filtro_orden =  " fecha_egreso, "		
	desc_tipo = "Egresados."
elseif tipo="8" then 
   titulo_temp = titulo_temp & " TITULADOS"
   if inicio <> "" and termino <> "" then
				titulo_temp = titulo_temp & " ENTRE EL "&inicio&" Y EL "&termino
				filtro_fecha = " AND convert(datetime,protic.trunc(fecha_titulacion),103) between convert(datetime,'" & inicio & "',103) and convert(datetime,'" & termino & "',103)"& vbCrLf
	elseif inicio <> "" and termino = "" then	
				titulo_temp = titulo_temp & " A PARTIR DEL "&inicio
				filtro_fecha = " AND convert(datetime,protic.trunc(fecha_titulacion),103) >= convert(datetime,'" & inicio & "',103) "& vbCrLf
	elseif inicio = "" and termino <> "" then
	            titulo_temp = titulo_temp & " HASTA EL "&termino    	
				filtro_fecha = " AND convert(datetime,protic.trunc(fecha_titulacion),103) <= convert(datetime,'" & termino & "',103) "& vbCrLf	
	end if		
	filtro_orden =  " fecha_titulacion, "	
	desc_tipo = "Titulados."	

end if

fecha_01 = conexion.consultaUno("select protic.trunc(getDate())")
'---------------------------------------------------------------------------------------------------
set f_lista = new CFormulario
f_lista.Carga_Parametros "tabla_vacia.xml", "tabla"
f_lista.Inicializar conexion
			
consulta = " select distinct * from  "& vbCrLf &_			
		   " (select distinct  "& vbCrLf &_			
		   " (select top 1 sede_tdesc from alumnos aa, ofertas_academicas bb, especialidades cc, sedes dd "& vbCrLf &_			
		   "                    where aa.pers_ncorr=e.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr "& vbCrLf &_			
		   "                    and bb.espe_ccod=cc.espe_ccod and bb.sede_ccod=dd.sede_ccod  "& vbCrLf &_			
		   "                    and aa.emat_ccod in (4,8) and cc.carr_ccod=d.carr_ccod) as sede,  "& vbCrLf &_			
		   " ltrim(rtrim(d.carr_tdesc)) as carr_tdesc, 	"& vbCrLf &_		
		   " (select top 1 jorn_tdesc from alumnos aa, ofertas_academicas bb, especialidades cc, jornadas dd  "& vbCrLf &_			
		   "         where aa.pers_ncorr=e.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr "& vbCrLf &_			
		   "         and bb.espe_ccod=cc.espe_ccod and bb.jorn_ccod=dd.jorn_ccod 	"& vbCrLf &_		
		   "         and aa.emat_ccod in (4,8) and cc.carr_ccod=d.carr_ccod) as jornada,    "& vbCrLf &_			
		   " protic.trunc(fecha_egreso) as m_fecha_egreso, fecha_egreso,  "& vbCrLf &_			
		   " protic.trunc(asca_fsalida) as m_fecha_titulacion, asca_fsalida as fecha_titulacion,  "& vbCrLf &_			
		   " case isnull(incluir_mencion,'0') when '0' then '' else nombre_mencion end as mencion,  "& vbCrLf &_			
		   " cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut,  "& vbCrLf &_			
		   " pers_tnombre as nombres, pers_tape_paterno + ' ' + pers_tape_materno as apellidos,  "& vbCrLf &_			
		   " replace(asca_nnota,',','.') as nota, "& vbCrLf &_
		   " (select top 1 anos_ccod from alumnos tt,ofertas_academicas t2, especialidades t3, periodos_academicos t4 "& vbCrLf &_
		   " where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and t2.peri_ccod=t4.peri_ccod "& vbCrLf &_
		   " and tt.pers_ncorr=e.pers_ncorr and t3.carr_ccod=d.carr_ccod and tt.emat_ccod=8) as anos_ccod,  "& vbCrLf &_			
		   " case when (select top 1 anos_ccod from alumnos tt,ofertas_academicas t2, especialidades t3, periodos_academicos t4 "& vbCrLf &_
		   " where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and t2.peri_ccod=t4.peri_ccod "& vbCrLf &_
		   " and tt.pers_ncorr=e.pers_ncorr and t3.carr_ccod=d.carr_ccod and tt.emat_ccod=8) <= 2005  "& vbCrLf &_
		   "                     then case when asca_nnota >= 4.0 and asca_nnota <= 4.9 then 'UNANIMIDAD' 	"& vbCrLf &_		
		   "                               when asca_nnota >= 5.0 and asca_nnota <= 5.4 then 'UN VOTO DE DISTINCION'  	"& vbCrLf &_		
		   "                               when asca_nnota >= 5.5 and asca_nnota <= 5.9 then 'DOS VOTOS DE DISTINCION' 	"& vbCrLf &_		
		   "                               when asca_nnota >= 6.0 and asca_nnota <= 6.4 then 'TRES VOTOS DE DISTINCION'  "& vbCrLf &_			
		   "                               when asca_nnota >= 6.5 and asca_nnota <= 7.0 then 'APROBADO CON DISTINCION MAXIMA' 	"& vbCrLf &_		
		   "                           end  "& vbCrLf &_			
		   "                      else case when asca_nnota >= 4.0 and asca_nnota <= 4.9 then 'APROBADO POR UNANIMIDAD' "& vbCrLf &_			
		   "                                when asca_nnota >= 5.0 and asca_nnota <= 5.9 then 'APROBADO CON DISTINCION'   "& vbCrLf &_			
           "                      when asca_nnota >= 6.0 and asca_nnota <= 7.0 then 'APROBADO CON DISTINCION MAXIMA'  	"& vbCrLf &_		
		   "                           end  	"& vbCrLf &_		
		   " end as distincion_obtenida,g.asca_nfolio as folio, protic.trunc(a.fecha_ceremonia) as fecha_ceremonia,  "& vbCrLf &_			
		   " protic.obtener_direccion(e.pers_ncorr,1,'CNPB') as dirección, protic.obtener_direccion(e.pers_ncorr,1,'C-C') as ciudad,  "& vbCrLf &_			
		   " e.pers_tfono as teléfono, e.pers_tcelular as celular, e.pers_temail as email,  "& vbCrLf &_			
		   " case when replace(replace(c.espe_tdesc,'(D)',''),'(V)','')  "& vbCrLf &_			
		   "       like '%sin mencion%' then ''   "& vbCrLf &_			
		   "       when replace(replace(c.espe_tdesc,'(D)',''),'(V)','') 			  "& vbCrLf &_
		   "       like '%plan comun%' then ''   "& vbCrLf &_			
		   " else replace(replace(c.espe_tdesc,'(D)',''),'(V)','') end  as mencion_x_defecto,  			 "& vbCrLf &_
		   " (select case count(*) when 0 then 'NO' else 'SI' end from alumnos_salidas_carrera ta, salidas_carrera tb "& vbCrLf &_ 
		   "                                                       where ta.pers_ncorr=e.pers_ncorr and ta.saca_ncorr=tb.saca_ncorr "& vbCrLf &_
		   " and tb.carr_ccod=d.carr_ccod and tb.tsca_ccod=3)  as tiene_grado,  "& vbCrLf &_
		   " isnull((select top 1 tb.saca_tdesc from alumnos_salidas_carrera ta, salidas_carrera tb where ta.pers_ncorr=e.pers_ncorr and ta.saca_ncorr=tb.saca_ncorr "& vbCrLf &_
		   "         and tb.carr_ccod=d.carr_ccod and tb.tsca_ccod=3),'') as grado_academico, isnull(f.linea_1_certificado,'') + ' ' + isnull(f.linea_2_certificado,'') as  mencion_x_defecto2,  "& vbCrLf &_
		   " protic.ANO_INGRESO_CARRERA_EGRESADOS(a.pers_ncorr,d.carr_ccod) as promocion,s.sexo_tdesc as genero,  "& vbCrLf &_
		   " protic.trunc(e.pers_fnacimiento) as fecha_nacimiento, pape.pais_tdesc as país, "& vbCrLf &_
		   " protic.ano_ingreso_carrera_egresa2(e.pers_ncorr,c.carr_ccod) as ano_ingreso_carrera,  "& vbCrLf &_
		   " (select top 1 peri_tdesc from periodos_academicos where peri_ccod in (select min(peri_ccod) from alumnos aa, ofertas_academicas oa, especialidades ea  "& vbCrLf &_
		   "     where aa.pers_ncorr=e.pers_ncorr and aa.ofer_ncorr=oa.ofer_ncorr  "& vbCrLf &_
		   "     and oa.espe_ccod=ea.espe_ccod and ea.carr_ccod=c.carr_ccod and aa.emat_ccod <> 9 )) as semestre_ingreso,  "& vbCrLf &_
		   " isnull((select  top 1 peri_tdesc from periodos_academicos  "& vbCrLf &_
		   "         where peri_ccod in (select top 1 peri_ccod from alumnos aa, ofertas_academicas oa, especialidades ea  "& vbCrLf &_
		   "                             where aa.pers_ncorr=e.pers_ncorr and aa.ofer_ncorr=oa.ofer_ncorr  "& vbCrLf &_
		   "                             and oa.espe_ccod=ea.espe_ccod and ea.carr_ccod=c.carr_ccod and aa.emat_ccod in (2,3,10,13,14) )),'') as semestre_suspención "& vbCrLf &_
		   " from detalles_titulacion_carrera a join  planes_estudio b  "& vbCrLf &_	
		   "   on a.plan_ccod=b.plan_ccod  "& vbCrLf &_	
		   " join  especialidades c  "& vbCrLf &_	
		   "   on b.espe_ccod=c.espe_ccod  "& vbCrLf &_	
		   " join carreras d  "& vbCrLf &_	
		   "   on c.carr_ccod=d.carr_ccod  "& vbCrLf &_	
		   " join personas e	 "& vbCrLf &_
		   "   on a.pers_ncorr=e.pers_ncorr  "& vbCrLf &_	
		   " join paises pape	 "& vbCrLf &_ 
		   "   on e.pais_ccod=pape.pais_ccod  "& vbCrLf &_	
		   " left outer join sexos s	 "& vbCrLf &_
		   "   on e.sexo_ccod=s.sexo_ccod  "& vbCrLf &_	
		   " left outer join salidas_carrera f  "& vbCrLf &_	
		   "   on a.carr_ccod= f.carr_ccod  "& vbCrLf &_	
		   " join alumnos_salidas_carrera g  "& vbCrLf &_	
		   "   on f.saca_ncorr=g.saca_ncorr and a.pers_ncorr = g.pers_ncorr   "& vbCrLf &_
		   " where not exists (select 1 from alumnos_salidas_carrera tt, salidas_carrera t2  "& vbCrLf &_
           "				   where tt.saca_ncorr=t2.saca_ncorr and tt.saca_ncorr=b.plan_ccod  "& vbCrLf &_
           "				   and tt.pers_ncorr=e.pers_ncorr and t2.tsca_ccod in (4,6) ) "& vbCrLf &_
		   " and exists (select 1 from alumnos_salidas_carrera tt, salidas_carrera t2 "& vbCrLf &_
           "             where tt.saca_ncorr=t2.saca_ncorr --and t2.plan_ccod = b.plan_ccod "& vbCrLf &_
           "             and tt.pers_ncorr=e.pers_ncorr ) "
		   if tipo = 4 then 		
			   consulta = consulta & " union  "& vbCrLf &_			
			   " select (select top 1 sede_tdesc from alumnos aa, ofertas_academicas bb, especialidades cc, sedes dd "& vbCrLf &_			
			   "                    where aa.pers_ncorr=e.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr "& vbCrLf &_			
			   "         and bb.espe_ccod=cc.espe_ccod and bb.sede_ccod=dd.sede_ccod "& vbCrLf &_			
			   "         and aa.emat_ccod in (4) and cc.carr_ccod=d.carr_ccod) as sede, "& vbCrLf &_			
			   "         ltrim(rtrim(carr_tdesc)) as carr_tdesc,  "& vbCrLf &_			
			   " (select top 1 jorn_tdesc from alumnos aa, ofertas_academicas bb, especialidades cc, jornadas dd "& vbCrLf &_			
			   "         where aa.pers_ncorr=e.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr "& vbCrLf &_			
			   "          and bb.espe_ccod=cc.espe_ccod and bb.jorn_ccod=dd.jorn_ccod "& vbCrLf &_			
			   "         and aa.emat_ccod in (4) and cc.carr_ccod=d.carr_ccod) as jornada, "& vbCrLf &_			
			   "         protic.trunc(fecha_egreso) as m_fecha_egreso, fecha_egreso, null as m_fecha_titulacion, null as fecha_titulacion, "& vbCrLf &_			
			   "         null as mencion,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, "& vbCrLf &_			
			   "         e.pers_tnombre as nombres, pers_tape_paterno + ' ' + pers_tape_materno as apellidos, "& vbCrLf &_			
			   "         null as nota, null as anos_ccod,  "& vbCrLf &_			
			   "         null as distincion_obtenida,null as folio, null as fecha_ceremonia, "& vbCrLf &_			
			   " protic.obtener_direccion(e.pers_ncorr,1,'CNPB') as dirección, protic.obtener_direccion(e.pers_ncorr,1,'C-C') as ciudad, "& vbCrLf &_			
			   " e.pers_tfono as teléfono, e.pers_tcelular as celular, e.pers_temail as email, "& vbCrLf &_			
			   "  case when replace(replace(c.espe_tdesc,'(D)',''),'(V)','')  "& vbCrLf &_			
			   "       like '%sin mencion%' then ''   "& vbCrLf &_			
			   "       when replace(replace(c.espe_tdesc,'(D)',''),'(V)','') "& vbCrLf &_			 
			   "       like '%plan comun%' then ''  "& vbCrLf &_			
			   "  else replace(replace(c.espe_tdesc,'(D)',''),'(V)','') end  as mencion_x_defecto, "& vbCrLf &_	
			   "  ''  as tiene_grado, "& vbCrLf &_
 			   "  '' as grado_academico,'' as  mencion_x_defecto2, protic.ANO_INGRESO_CARRERA_EGRESADOS(a.pers_ncorr,d.carr_ccod) as promocion,s.sexo_tdesc as genero, "& vbCrLf &_
			   "  protic.trunc(e.pers_fnacimiento) as fecha_nacimiento, pape.pais_tdesc as país, "& vbCrLf &_
			   "  protic.ano_ingreso_carrera_egresa2(e.pers_ncorr,c.carr_ccod) as ano_ingreso_carrera, "& vbCrLf &_
			   "  (select top 1 peri_tdesc from periodos_academicos where peri_ccod in (select min(peri_ccod) from alumnos aa, ofertas_academicas oa, especialidades ea "& vbCrLf &_
			   "   where aa.pers_ncorr=e.pers_ncorr and aa.ofer_ncorr=oa.ofer_ncorr "& vbCrLf &_
			   "   and oa.espe_ccod=ea.espe_ccod and ea.carr_ccod=c.carr_ccod and aa.emat_ccod <> 9 )) as semestre_ingreso, "& vbCrLf &_
			   "   isnull((select top 1  peri_tdesc from periodos_academicos "& vbCrLf &_
			   "   where peri_ccod in (select top 1 peri_ccod from alumnos aa, ofertas_academicas oa, especialidades ea "& vbCrLf &_
			   "   where aa.pers_ncorr=e.pers_ncorr and aa.ofer_ncorr=oa.ofer_ncorr "& vbCrLf &_
			   "   and oa.espe_ccod=ea.espe_ccod and ea.carr_ccod=c.carr_ccod and aa.emat_ccod in (2,3,10,13,14) )),'') as semestre_suspención "& vbCrLf &_
			   " from detalles_titulacion_carrera a,planes_estudio b, especialidades c,carreras d, personas e,sexos s,paises pape "& vbCrLf &_			
			   " where not exists ( select 1 from alumnos_salidas_carrera aa, salidas_carrera bb "& vbCrLf &_			
			   "       				where aa.pers_ncorr=a.pers_ncorr and aa.saca_ncorr=bb.saca_ncorr "& vbCrLf &_			
			   "       				and bb.carr_ccod=a.carr_ccod ) "& vbCrLf &_
			   " and   not exists ( select 1 from alumnos_salidas_carrera tt, salidas_carrera t2  "& vbCrLf &_
               "			        where tt.saca_ncorr = t2.saca_ncorr and tt.saca_ncorr = b.plan_ccod  "& vbCrLf &_
               "			        and tt.pers_ncorr = e.pers_ncorr and t2.tsca_ccod in (4,6) )  "& vbCrLf &_			
			   " and a.plan_ccod=b.plan_ccod and b.espe_ccod=c.espe_ccod and e.pais_ccod=pape.pais_ccod "& vbCrLf &_			
			   " and a.pers_ncorr=e.pers_ncorr and e.sexo_ccod = s.sexo_ccod and c.carr_ccod=d.carr_ccod "
		   end if
		   consulta = consulta & ") as tabla_1  "& vbCrLf &_			
		   " where 1=1  "& vbCrLf &_			
			" "& filtro_fecha

f_lista.Consultar consulta & " order by "&filtro_orden&" apellidos desc"
'response.write("<pre>"&consulta & " order by "&filtro_orden&" apellidos desc </pre>")	
'response.Write("<pre>"&sql_detalles_mate&"</pre>")
'response.End()

'------------------------------------------------------------------------------
%>
<html>
<head>
<title><%=pagina.Titulo%></title>  
<!--<meta http-equiv="Content-Type" content="text/html;">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">-->

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<tr>
	<td colspan="2" align="center"><font size="4"><strong><%=titulo_temp%></strong></font></td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<tr>
	<td colspan="2" align="left"><strong>Fecha de Proceso : </strong><%=fecha_01%></td>
</tr>
<tr>
	<td colspan="2" align="left"><strong>Hora de Proceso : </strong><%=time()%></td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<tr>
	<td colspan="2" align="center"><table width="75%" border="1">
									  <tr> 
										<td bgcolor="#FFFFCC"><div align="center"><strong>N°</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Fecha Egreso</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Fecha Título</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Sede</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Carrera</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Jornada</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Mención</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Mención Por Defecto</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Año de Ingreso</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>RUT</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Nombres</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Apellidos</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Fecha de Nacimiento</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>País</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Genero</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Con Grado</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Grado Académico</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Calificación</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Distinción Obtenida</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>N° de Folio</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Fecha Ceremonia</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Dirección</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Ciudad</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Teléfono</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Celular</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>E-mail</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Año Ingreso Carrera</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Semestre Ingreso Carrera</strong></div></td>
										<td bgcolor="#FFFFCC"><div align="center"><strong>Semestre de Suspención</strong></div></td>
									  </tr>
									  <% fila = 1 
										 while f_lista.Siguiente %>
									  <tr> 
										<td><div align="center"><%=fila%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("m_fecha_egreso")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("m_fecha_titulacion")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("sede")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("carr_tdesc")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("jornada")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("mencion")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("mencion_x_defecto2")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("promocion")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("rut")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("nombres")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("apellidos")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("fecha_nacimiento")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("país")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("genero")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("tiene_grado")%></div></td>	
										<td><div align="left"><%=f_lista.ObtenerValor("grado_academico")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("nota")%></div></td>
										<td><div align="left"><%=f_lista.ObtenerValor("distincion_obtenida")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("folio")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("fecha_ceremonia")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("dirección")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("ciudad")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("teléfono")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("celular")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("email")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("ano_ingreso_carrera")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("semestre_ingreso")%></div></td>
										<td><div align="center"><%=f_lista.ObtenerValor("semestre_suspención")%></div></td>
									  </tr>
									  <%fila= fila + 1  
										wend %>
									</table>
	</td>
</tr>
</table>

</body>
</html>
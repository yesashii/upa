<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=historicos_notas.doc"
Response.ContentType = "application/vnd.ms-word"
Server.ScriptTimeOut = 150000

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------------
fecha_01=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------

set alumnos = new CFormulario
alumnos.Carga_Parametros "tabla_vacia.xml", "tabla"
alumnos.Inicializar conexion
		   
consulta="select * "& vbCrLf &_ 
		 "	 from  "& vbCrLf &_ 
		 "	 (  "& vbCrLf &_ 
		 "	 select distinct a.pers_nrut,cast(a.pers_nrut as varchar)+'-'+ a.pers_xdv as rut, "& vbCrLf &_ 
		 "	   a.pers_tape_paterno  +' ' + a.pers_tape_materno + ', ' + a.pers_tnombre as alumno, "& vbCrLf &_ 
		 "	   case a.sexo_ccod when 1 then 'Masculino' when 2  then 'Femenino' else 'Sin Seleccionar' end as sexo, "& vbCrLf &_ 
         "     isnull(a.pers_temail,'No ingresado') as email,isnull(a.pers_tfono,'') as fono, isnull(a.pers_tcelular,'') as celular,      "& vbCrLf &_ 
		 "	   facu.facu_tdesc as facultad,h.sede_ccod,h.sede_tdesc as sede,e.carr_ccod ,f.carr_tdesc as Carrera,g.jorn_ccod, g.jorn_tdesc as jornada ,"& vbCrLf &_  
		 "	   case c.post_bnuevo when 'N' then 'ANTIGUO' else 'NUEVO' end as tipo,  "& vbCrLf &_ 
		 "	   protic.ano_ingreso_carrera (a.pers_ncorr,e.carr_ccod) as ano_ingreso, "& vbCrLf &_ 
		 "	   (select emat_tdesc from estados_matriculas emat  "& vbCrLf &_ 
		 "	   where emat.emat_ccod in (select top 1 emat_ccod from alumnos a1, ofertas_academicas o1 where a1.pers_ncorr=d.pers_ncorr and a1.ofer_ncorr=o1.ofer_ncorr and o1.espe_ccod = c.espe_ccod and a1.emat_ccod <> 9 order by o1.peri_ccod desc, convert(datetime,a1.audi_fmodificacion) desc))  "& vbCrLf &_ 
		 "	   as estado_academico,  "& vbCrLf &_ 
         "      (select top 1 plan_ccod from alumnos a1, ofertas_academicas o1 where a1.pers_ncorr=d.pers_ncorr and a1.ofer_ncorr=o1.ofer_ncorr and o1.espe_ccod = c.espe_ccod and a1.emat_ccod <> 9 order by o1.peri_ccod desc, convert(datetime,a1.audi_fmodificacion) desc)   "& vbCrLf &_ 
		 "	   as plan_ccod  "& vbCrLf &_ 
         "      from personas_postulante a join alumnos d   "& vbCrLf &_ 
		 "	        on a.pers_ncorr = d.pers_ncorr    "& vbCrLf &_ 
		 "	   join ofertas_academicas c   "& vbCrLf &_ 
		 "	        on c.ofer_ncorr = d.ofer_ncorr     "& vbCrLf &_ 
		 "	   join periodos_academicos pea   "& vbCrLf &_ 
		 "	        on c.peri_ccod = pea.peri_ccod and pea.anos_ccod= 2010 --datepart(year,getDate())  "& vbCrLf &_ 
		 "	   join postulantes pos  "& vbCrLf &_ 
		 "	        on pos.post_ncorr = d.post_ncorr  "& vbCrLf &_ 
		 "	    join paises pai  "& vbCrLf &_ 
		 "	        on pai.pais_ccod = isnull(a.pais_ccod,0)  "& vbCrLf &_ 
		 "	    join especialidades e   "& vbCrLf &_ 
		 "	        on c.espe_ccod  = e.espe_ccod "& vbCrLf &_ 
		 "	    join carreras f   "& vbCrLf &_ 
		 "	        on e.carr_ccod=f.carr_ccod "& vbCrLf &_ 
		 "	    join areas_academicas aca  "& vbCrLf &_ 
		 "	        on f.area_ccod = aca.area_ccod  "& vbCrLf &_ 
		 "	    join facultades facu  "& vbCrLf &_ 
		 "	        on aca.facu_ccod=facu.facu_ccod "& vbCrLf &_        
		 "	    join jornadas g   "& vbCrLf &_ 
		 "	        on c.jorn_ccod=g.jorn_ccod "& vbCrLf &_  
		 "	    join sedes h "& vbCrLf &_  
		 "	       on c.sede_ccod=h.sede_ccod   "& vbCrLf &_ 
		 "	    join contratos cont  "& vbCrLf &_ 
		 "	        on d.matr_ncorr = cont.matr_ncorr and d.post_ncorr = cont.post_ncorr   "& vbCrLf &_ 
		 "	 where cont.econ_ccod = 1   "& vbCrLf &_ 
		 "	 and d.emat_ccod not in (9) and f.carr_ccod='830' "& vbCrLf &_ 
		 "   and exists (select 1 from planes_estudio tt where tt.plan_ccod=d.plan_ccod and tt.plan_tdesc like '%2006%') "& vbCrLf &_ 
		 "	 and exists (select 1 from contratos cont1, compromisos comp1 where d.post_ncorr=cont1.post_ncorr and d.matr_ncorr=cont1.matr_ncorr and cont1.cont_ncorr=comp1.comp_ndocto and tcom_ccod in (1,2) )    "& vbCrLf &_ 
		 "	 group by a.pers_ncorr,a.pers_tfono,a.pers_tcelular,e.carr_ccod, c.peri_ccod,a.pers_nrut,a.pers_xdv, a.pers_tnombre,a.pers_tape_paterno,  "& vbCrLf &_ 
		 "	         a.pers_tape_materno,d.matr_ncorr,f.carr_tdesc,c.post_bnuevo,d.alum_fmatricula,g.jorn_tdesc,h.sede_tdesc,  "& vbCrLf &_ 
		 "	         pai.pais_tdesc,e.espe_tdesc,a.sexo_ccod, d.audi_fmodificacion,c.espe_ccod,d.pers_ncorr,a.pers_fnacimiento,a.sexo_ccod, "& vbCrLf &_ 
		 "			 a.pers_temail,facu.facu_ccod,facu_tdesc, h.sede_ccod, g.jorn_ccod "& vbCrLf &_ 
		 "	 )tabla_final  "& vbCrLf &_ 
		 "	 where estado_academico= 'Activa'  "& vbCrLf &_ 
		 "  order by sede,carrera,alumno "
		
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
alumnos.Consultar consulta 

set historico		=		new cformulario
historico.inicializar 		conexion
historico.carga_parametros	"tabla_vacia.xml","tabla"
%>
<html>
<head>
<title>Historicos de notas escuela</title>
<meta http-equiv="Content-Type" content="text/html;">
<STYLE>
 H1.SaltoDePagina
 {
     PAGE-BREAK-AFTER: always
 }
</STYLE>
</head>
<body >
<%  contador_alumnos = 1
    while alumnos.Siguiente 
    pers_nrut = alumnos.obtenerValor("pers_nrut")
	nombre = alumnos.obtenerValor("alumno")
	plan_ccod = alumnos.obtenerValor("plan_ccod")
	carr_ccod = alumnos.obtenerValor("carr_ccod")
	ano_ingreso = alumnos.obtenerValor("ano_ingreso")
	rut =  alumnos.obtenerValor("rut")
	email =  alumnos.obtenerValor("email")
	fono =  alumnos.obtenerValor("fono")
	celular =  alumnos.obtenerValor("celular")
	sede =  alumnos.obtenerValor("sede")
	carrera =  alumnos.obtenerValor("carrera")
	jornada =  alumnos.obtenerValor("jornada")%>
<div align="left"><font size="3" face="Arial, Helvetica, sans-serif"><strong><%=contador_alumnos%> .- <%=nombre%></strong></font></div>
<div align="left"><%=fecha_01%>
	
<table width="672" border="0">
  <tr valign="top"> 
    <td width="10%"><FONT color="#000000" face="Courier New, Courier, mono" size="1"><strong>RUT</strong></font></td>
    <td width="90%" colspan="5" align="left"><FONT color="#000000" face="Courier New, Courier, mono" size="1"><strong>:</strong> <%=rut%></font> </td>
  </tr>
  <tr> 
    <td width="10%"><FONT color="#000000" face="Courier New, Courier, mono" size="1"><strong>PROGRAMA</strong></font></td>
    <td width="90%" colspan="5" align="left"><FONT color="#000000" face="Courier New, Courier, mono" size="1"><strong>:</strong> <%=sede%> -- <%=carrera%> -- (<%=jornada%>) </font></td>
  </tr>
  <tr> 
    <td width="10%"><FONT color="#000000" face="Courier New, Courier, mono" size="1"><strong>INGRESO</strong></font></td>
    <td width="90%" colspan="5" align="left"><FONT color="#000000" face="Courier New, Courier, mono" size="1"><strong>:</strong> <%=ano_ingreso%></font></td>
  </tr>
  <tr> 
    <td width="10%"><FONT color="#000000" face="Courier New, Courier, mono" size="1"><strong>EMAIL</strong></font></td>
    <td width="90%" colspan="5" align="left"><FONT color="#000000" face="Courier New, Courier, mono" size="1"><strong>:</strong> <%=email%></font></td>
  </tr>
  <tr> 
    <td width="10%"><FONT color="#000000" face="Courier New, Courier, mono" size="1"><strong>TELÉFONOS</strong></font></td>
    <td width="90%" colspan="5" align="left"><FONT color="#000000" face="Courier New, Courier, mono" size="1"><strong>:</strong> <%=fono%>&nbsp;&nbsp; <%=celular%></font> </td>
  </tr>
  <tr>
  	<td colspan="6"><FONT color="#000000" face="Courier New, Courier, mono" size="1">&nbsp;</font></td>
  </tr>
  <%
  	'debemos generar el código para mostrar los históricos de cada alumno de la escuela
    cons_historico="select a.nive_ccod,ltrim(rtrim(a.asig_ccod)) as asig_ccod, ltrim(rtrim(a.asig_ccod)) + ' -- ' + protic.initcap(asig.asig_tdesc) as asig_tdesc,a.mall_ccod, " & vbCrLf  & _
                   "	  case cast(cast(b.carg_nnota_final as decimal(2,1))as varchar) when ' .0' then '0.0' else cast(cast(b.carg_nnota_final as decimal(2,1))as varchar) end as carg_nnota_final,  " & vbCrLf  & _
				   "	 b.sitf_ccod,b.peri_ccod, " & vbCrLf  & _
				   "	 isnull( case ('('+ cast(pa.anos_ccod as varchar) + '-' + cast(b.sitf_ccod as varchar)+')') " & vbCrLf  & _
				   "     when ('('+ cast(pa.anos_ccod as varchar) + '-' + ')') then ' ' " & vbCrLf  & _
				   "     when '(-)' then ' '" & vbCrLf  & _
				   "     else ('('+ cast(pa.anos_ccod as varchar) + '-' + case cast(b.sitf_ccod as varchar) when 'A' then 'A' when 'R' then 'R' when 'C' then 'C' when 'SP' then 'SP' when 'H' then 'HM' when 'S' then 'Su' when 'RS' then 'RS' when 'RI' then 'RI' end +')') end ,'' ) as anos_ccod  " & vbCrLf  & _
				   "	 from (  " & vbCrLf  & _
				   "	 select ma.nive_ccod, asig_ccod,esp.carr_ccod,ma.mall_ccod  " & vbCrLf  & _
			  	   "	 from especialidades esp, planes_estudio pl, malla_curricular ma  " & vbCrLf  & _
				   "	 where esp.espe_ccod=pl.espe_ccod  " & vbCrLf  & _
				   "	  and pl.plan_ccod=ma.plan_ccod  " & vbCrLf  & _
				   "	  and cast(pl.plan_ccod as varchar)='"&plan_ccod&"') a left outer join" & vbCrLf  & _
				   "	  (	  " & vbCrLf  & _
				   "	  select h.asig_ccod,a.sitf_ccod,a.carg_nnota_final,g.peri_ccod " & vbCrLf  & _
				   "		from  " & vbCrLf  & _
				   "			 cargas_academicas a, " & vbCrLf  & _
				   "			 alumnos b, " & vbCrLf  & _
				   "			 personas c, " & vbCrLf  & _
				   "			 ofertas_academicas d " & vbCrLf  & _
				   "			 ,planes_estudio e " & vbCrLf  & _
				   "			 ,especialidades f " & vbCrLf  & _
				   "			 ,secciones g " & vbCrLf  & _
				   "			 ,asignaturas h " & vbCrLf  & _
				   "		where  " & vbCrLf  & _
				   "			  a.matr_ncorr=b.matr_ncorr " & vbCrLf  & _
				   "			  and b.pers_ncorr=c.pers_ncorr " & vbCrLf  & _
				   "			  and b.ofer_ncorr=d.ofer_ncorr " & vbCrLf  & _
				   "			  and b.plan_ccod=e.plan_ccod " & vbCrLf  & _
				   "              and isnull(a.carg_noculto,0) <>1" & vbcrlf &_
				   "			  and e.espe_ccod=f.espe_ccod " & vbCrLf  & _
				   "			  and not exists(select 1 from equivalencias equi where equi.asig_ccod=h.asig_ccod and a.matr_ncorr=equi.matr_ncorr and a.secc_ccod = equi.secc_ccod) " & vbCrLf  & _
				   "			  --and not exists(select 1 from equivalencias equi where equi.secc_ccod=g.secc_ccod and equi.matr_ncorr=a.matr_ncorr) " & vbCrLf  & _
				   "			  and a.secc_ccod=g.secc_ccod " & vbCrLf  & _
				   "			  and g.asig_ccod=h.asig_ccod " & vbCrLf  & _
				   "			  --and b.emat_ccod=1 " & vbCrLf  & _
				   "			  and cast(pers_nrut as varchar)='"&pers_nrut&"' " & vbCrLf  & _
				   "			  --and cast(f.carr_ccod as varchar)='"&carr_ccod&"' " & vbCrLf  & _
				   "			  and cast(a.sitf_ccod as varchar) not in ('EE','EQ','NN') " & vbCrLf  & _
				   "		union   " & vbCrLf  & _
				   "		select  " & vbCrLf  & _
				   "			 a.asig_ccod,sitf_ccod,case a.sitf_ccod when 'C' then isnull(a.conv_nnota,null) when 'AC' then a.conv_nnota else isnull(a.conv_nnota,null) end as nota,e.peri_ccod " & vbCrLf  & _
				   "		from  " & vbCrLf  & _
				   "			 convalidaciones a " & vbCrLf  & _
				   "			 , alumnos b " & vbCrLf  & _
				   "			 ,personas c " & vbCrLf  & _
				   "			 , actas_convalidacion d " & vbCrLf  & _
				   "			 , ofertas_academicas e " & vbCrLf  & _
				   "			 , planes_estudio f " & vbCrLf  & _
				   "			 ,especialidades g " & vbCrLf  & _
				   "		where " & vbCrLf  & _
				   "			 a.matr_ncorr=b.matr_ncorr " & vbCrLf  & _
				   "			 and b.pers_ncorr=c.pers_ncorr " & vbCrLf  & _
				   "			 and a.acon_ncorr=d.acon_ncorr " & vbCrLf  & _
				   "			 and b.ofer_ncorr=e.ofer_ncorr " & vbCrLf  & _
				   "			 and b.plan_ccod=f.plan_ccod " & vbCrLf  & _
				   "			 and f.espe_ccod=g.espe_ccod " & vbCrLf  & _
				   "			 and cast(g.carr_ccod as varchar)='"&carr_ccod&"' " & vbCrLf  & _
				   "			 and cast(c.pers_nrut as varchar)='"&pers_nrut&"' " & vbCrLf  & _
				   "		union " & vbCrLf  & _
				   "		select " & vbCrLf  & _
				   "			  a.asig_ccod,b.sitf_ccod,b.carg_nnota_final,d.peri_ccod " & vbCrLf  & _
				   "		from " & vbCrLf  & _
				   "			equivalencias a " & vbCrLf  & _
				   "			, cargas_academicas b " & vbCrLf  & _
				   "			, secciones c " & vbCrLf  & _
				   "			, ofertas_academicas d " & vbCrLf  & _
				   "			, planes_estudio e " & vbCrLf  & _
				   "			, especialidades f " & vbCrLf  & _
				   "			, alumnos g " & vbCrLf  & _
				   "			, personas h " & vbCrLf  & _
				   "		where " & vbCrLf  & _
				   "			 a.matr_ncorr=b.matr_ncorr " & vbCrLf  & _
				   "			 and a.secc_ccod=b.secc_ccod " & vbCrLf  & _
				   "			 and b.secc_ccod=c.secc_ccod " & vbCrLf  & _
				   "			 and b.matr_ncorr=g.matr_ncorr " & vbCrLf  & _
				   "			 and d.ofer_ncorr=g.ofer_ncorr " & vbCrLf  & _
				   "			 and e.plan_ccod=g.plan_ccod " & vbCrLf  & _
				   "             and isnull(b.carg_noculto,0) <>1" & vbcrlf &_
				   "			 and e.espe_ccod=f.espe_ccod " & vbCrLf  & _
				   "			 and g.pers_ncorr=h.pers_ncorr " & vbCrLf  & _
				   "			 --and cast(f.carr_ccod as varchar)='"&carr_ccod&"' " & vbCrLf  & _
				   "			 and cast(h.pers_nrut as varchar)='"&pers_nrut&"' " & vbCrLf  & _
				   "		union " & vbCrLf  & _
				   "    		 select distinct hd.asig_ccod,carg.sitf_ccod,carg.carg_nnota_final,i.peri_ccod " & vbCrLf  & _
				   "                from personas pers,alumnos al,cargas_academicas carg,situaciones_finales sf,secciones secc,asignaturas asig, homologacion_destino hd, " & vbCrLf  & _
				   "                     homologacion_fuente hf,homologacion h,ofertas_academicas i" & vbCrLf  & _
				   "                where cast(pers.pers_nrut as varchar)='"&pers_nrut&"' " & vbCrLf  & _
				   "                and pers.pers_ncorr=al.pers_ncorr" & vbCrLf  & _
				   "                and al.matr_ncorr=carg.matr_ncorr" & vbCrLf  & _
				   "                and carg.sitf_ccod=sf.sitf_ccod" & vbCrLf  & _
				   "                --and cast(sf.sitf_baprueba as varchar)='S'" & vbCrLf  & _
				   "                and cast(carg.sitf_ccod as varchar) <>'EQ'" & vbCrLf  & _
				   "                and secc.secc_ccod=carg.secc_ccod" & vbCrLf  & _
				   "                and asig.asig_ccod=secc.asig_ccod" & vbCrLf  & _
				   "                and isnull(carg.carg_noculto,0) <>1" & vbcrlf &_
				   "                and asig.asig_ccod=hf.asig_ccod" & vbCrLf  & _
				   "                and hd.homo_ccod=h.homo_ccod" & vbCrLf  & _
				   "                and al.ofer_ncorr=i.ofer_ncorr" & vbCrLf  & _
				   "                and hf.homo_ccod=h.homo_ccod" & vbCrLf  & _
				   "			    and cast(secc.carr_ccod as varchar)='"&carr_ccod&"' " & vbCrLf  & _
				   "                and hd.asig_ccod <> hf.asig_ccod" & vbCrLf  & _
				   "                and h.THOM_CCOD = 1 " & vbCrLf  & _
				   "		) b  on  a.asig_ccod = b.asig_ccod " & vbCrLf  & _
				   "		join   asignaturas asig on a.asig_ccod=asig.asig_ccod  " & vbCrLf  & _
				   "	    left outer join periodos_academicos pa on b.peri_ccod=pa.peri_ccod" & vbCrLf  & _
				   "        join carreras ca on ca.carr_ccod=a.carr_ccod " & vbCrLf  & _
				   "        order by a.nive_ccod,a.asig_ccod,b.peri_ccod "


					oportunidades	=	3
					historico.consultar	cons_historico
					nro_columnas =historico.nroFilas 
					historico.primero
					filas = 1 
    %>
  
  <tr> 
    <td width="100%" colspan="6" align="left">
		<%
		if plan_ccod <> "" then
		  response.Write("<table class='v1' width='672' border='1' bordercolor='#CCCCFF' bgcolor='#CCCCFF' cellspacing='0' cellpadding='0'>")
		  response.Write("<tr borderColor=#999999 bgColor=#c4d7ff>")
		  response.Write("<TH><FONT color=#333333 face='Courier New, Courier, mono' size='1'>Nivel</FONT></TH>")
		  response.Write("<TH><FONT color=#333333 face='Courier New, Courier, mono' size='1'>Asignatura</FONT></TH>")
		  for o_ = 1 to oportunidades
			response.Write("<TH><FONT color=#333333 face='Courier New, Courier, mono' size='1'>"&o_&"a Op.</FONT></TH>")
		  next
		  response.Write("</tr>")
		  historico.siguiente
			nivel		= historico.obtenervalor("nive_ccod")
			aux			= historico.obtenervalor("asig_ccod")
			asignatura	= historico.obtenervalor("asig_tdesc")
			nota		= historico.obtenervalor("carg_nnota_final")
			sit_final	= historico.obtenervalor("sitf_ccod")
			ano			= historico.obtenervalor("anos_ccod")
			malla		= historico.obtenervalor("mall_ccod")
			cadena		= nota&"&nbsp;"&historico.obtenervalor("anos_ccod")
			contador	=	1
			col			=	1	
			nro			=	3
			for k=0 to historico.nroFilas-1 
			if historico.obtenervalor("asig_ccod") <> "" then
				historico.siguiente
				if aux = historico.obtenervalor("asig_ccod") then
					col	=	col + 1
					cadena = cadena & "<td nowrap align='center' class=click><FONT color=#333333 face='Courier New, Courier, mono' size='1'>"&historico.obtenervalor("carg_nnota_final")&"&nbsp;"&historico.obtenervalor("anos_ccod")&"</font></td>"
				else
				  	response.write("<tr bgColor=#ffffff>")
					filas = filas + 1
					response.Write("<td class=click><FONT color=#333333 face='Courier New, Courier, mono' size='1'>"&nivel&"</font></td>")
					response.Write("<td class=click><FONT color=#333333 face='Courier New, Courier, mono' size='1'>"&asignatura&"</font></td>")
					response.Write("<td class=click><FONT color=#333333 face='Courier New, Courier, mono' size='1'>"&cadena&"</font></td>")
					for i_=1 to oportunidades-col
						response.Write("<td class=click><FONT color=#333333 face='Courier New, Courier, mono' size='1'>&nbsp;</font></td>")
					next
					response.Write("</tr>")
					col	=	1
					contador = 2
					nivel		= historico.obtenervalor("nive_ccod")
					aux			= historico.obtenervalor("asig_ccod")
					asignatura	= historico.obtenervalor("asig_tdesc")
					nota		= historico.obtenervalor("carg_nnota_final")
					sit_final	= historico.obtenervalor("sitf_ccod")
					ano			= historico.obtenervalor("anos_ccod")
					malla   	= historico.obtenervalor("mall_ccod")
					horas		= historico.obtenervalor("asig_nhoras")
					cadena		= historico.obtenervalor("carg_nnota_final")&"&nbsp;"&historico.obtenervalor("anos_ccod")
					nf			= historico.obtenervalor("nf")
					sf			= historico.obtenervalor("sitf_ccod")
				end if
			end if
			if k=historico.nrofilas-1 then
				historico.anterior
				nivel		= historico.obtenervalor("nive_ccod")
				aux			= historico.obtenervalor("asig_ccod")
				asignatura	= historico.obtenervalor("asig_tdesc")
				nota		= historico.obtenervalor("carg_nnota_final")
				sit_final	= historico.obtenervalor("sitf_ccod")
				ano			= historico.obtenervalor("anos_ccod")
				horas		= historico.obtenervalor("asig_nhoras")
				malla  	    = historico.obtenervalor("mall_ccod")
				cadena		= historico.obtenervalor("carg_nnota_final")
				nf			= historico.obtenervalor("nf")
				sf			= historico.obtenervalor("sitf_ccod")
				historico.siguiente
				if aux = historico.obtenervalor("asig_ccod") then
					response.write("<tr bgColor=#FFFFFF>")
					filas = filas + 1
					response.Write("<td class=click><FONT color=#333333 face='Courier New, Courier, mono' size='1'>"&nivel&"</font></td>")
					response.Write("<td class=click><FONT color=#333333 face='Courier New, Courier, mono' size='1'>"&asignatura&"</font></td>")
					response.Write("<td class=click><FONT color=#333333 face='Courier New, Courier, mono' size='1'>"&cadena&"&nbsp;"&ano&"</font></td>")
					response.Write("<td class=click><FONT color=#333333 face='Courier New, Courier, mono' size='1'>"&historico.obtenervalor("carg_nnota_final")&"&nbsp;"&historico.obtenervalor("anos_ccod")&"</font></td>")
					for h_=3 to oportunidades
						historico.siguiente
						response.write("<td class=click><FONT color=#333333 face='Courier New, Courier, mono' size='1'>"&historico.obtenervalor("carg_nnota_final")&"&nbsp;"&historico.obtenervalor("anos_ccod")&"</font></td>")
					next
					response.Write("</tr>")
				else
					historico.siguiente
					response.write("<tr bgColor=#FFFFFF>")
					filas = filas + 1
					response.Write("<td class=click><FONT color=#333333 face='Courier New, Courier, mono' size='1'>"&historico.obtenervalor("nive_ccod")&"</font></td>")
					response.Write("<td class=click><FONT color=#333333 face='Courier New, Courier, mono' size='1'>"&historico.obtenervalor("asig_tdesc")&"</font></td>")
					response.Write("<td class=click><FONT color=#333333 face='Courier New, Courier, mono' size='1'>"&historico.obtenervalor("carg_nnota_final")&"&nbsp;"&historico.obtenervalor("anos_ccod")&"</font></td>")
					for h_=2 to oportunidades
						response.Write("<td class=click><FONT color=#333333 face='Courier New, Courier, mono' size='1'>&nbsp;</font></td>")
					next
					response.Write("</tr>")
				end if
			end if
			response.Write("</tr>")
		next
		response.Write("</table>")
		end if
		%>
	</td>
  </tr>
</table>
<%
contador_alumnos = contador_alumnos + 1
filas = filas + 9

%>
<%	'response.Write("filas"&filas&" tt "&tt)
filas = 1
wend%>

</body>
</html>
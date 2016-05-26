<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION			    : Nómina de docentes utilizados y formateado según requerimientos de RRHH para informar a SIES
'FECHA CREACIÓN			    : 05-09-2013
'CREADO POR				    : Marcelo Sandoval
'ENTRADA				    : peri_ccod
'SALIDA				        : NA
'MODULO QUE ES UTILIZADO	: LISTADOS DOCENTES
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 
'ACTUALIZADO POR			: 
'MOTIVO				        : 
'LINEA				        : 
'********************************************************************
Response.AddHeader "Content-Disposition", "attachment;filename=SIES_general.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 4500000
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
tipo=request.QueryString("tipo")
peri_ccod=request.QueryString("peri_ccod")
ano=conexion.ConsultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
fecha_actual=conexion.ConsultaUno("select getDate()")


filtro_tipo = ""
if tipo="T" then
	filtro_tipo = " where en_tecnicas ='Sí' "
end if
if tipo="P" then
	filtro_tipo = " where en_profesionales ='Sí' "
end if
if tipo="O" then
	filtro_tipo = " where en_otras ='Sí' "
end if
anos_ccod = ano
ano_actual=conexion.consultaUno("select year(getDate()) as anio")
if cint(anos_ccod) < ano_actual  then
	ecdo_ccod=2
else
	ecdo_ccod=1	
end if

set f_docentes = new CFormulario
f_docentes.Carga_Parametros "tabla_vacia.xml", "tabla" 
f_docentes.Inicializar conexion

profesores = " select distinct pers_ncorr,rut as Rut, dv as DV, ap_paterno as Apellido_paterno, ap_materno as Apellido_materno, nombre as Nombre, sexo as Sexo, " & vbCrLf &_
			 "	 cumple as Fecha_de_nacimiento, " & vbCrLf &_
			 "	 (select t2.PAIS_TNACIONALIDAD from personas tt, paises t2 where isnull(tt.pais_ccod,0)=t2.pais_ccod and tt.pers_ncorr=big_table.pers_ncorr) as Nacionalidad, " & vbCrLf &_
			 "	 ("&ano&" - ano_ingreso) + 1 as Numero_de_anos_en_la_Institucion, " & vbCrLf &_
			 "	 protic.obtener_carreras_clases_profesor_por_horas(big_table.pers_ncorr,"&peri_ccod&") as carreras_imparte_clases, " & vbCrLf &_
			 "	 protic.obtener_grado_docente_completados(big_table.pers_ncorr, 'G')  as    Nivel_de_Formacion_Academica_del_Docente,   " & vbCrLf &_                                                            
			 "	 protic.obtener_grado_docente_completados(big_table.pers_ncorr, 'D')  as    Nombre_del_Grado,   " & vbCrLf &_
			 "	 protic.obtener_grado_docente_completados(big_table.pers_ncorr, 'P')  as    Pais_donde_lo_Obtuvo,  " & vbCrLf &_
			 "	 protic.trunc(protic.obtener_grado_docente_completados(big_table.pers_ncorr, 'F'))  as    Fecha_en_que_lo_Obtuvo, " & vbCrLf &_ 
			 "	 protic.obtener_grado_docente_completados(big_table.pers_ncorr, 'E')  as    Ano_en_que_lo_Obtuvo,  " & vbCrLf &_        
			 "	 protic.obtener_grado_docente_completados(big_table.pers_ncorr, 'I')  as    Institucion_en_que_lo_Obtuvo, " & vbCrLf &_
			 "	 tipo_contrato, --protic.obtener_horas_academicas(big_table.pers_ncorr,'"&peri_ccod&"') as horas_X_75, " & vbCrLf &_
			 "	 --protic.obtener_horas_academicas_diferenciado(big_table.pers_ncorr,'"&peri_ccod&"') as horas_X_90, " & vbCrLf &_
			 "	 sum(big_table.asig_nhoras) as horas_docentes,  " & vbCrLf &_
			 "	 isnull((select top 1 tjdo_tdesc from profesores tt, tipo_jornada_docente t2 where tt.tjdo_ccod=t2.tjdo_ccod and tt.pers_ncorr=big_table.pers_ncorr),'') as tipo_jornada, " & vbCrLf &_
     		 "   isnull((select top 1 jdoc_tdesc from profesores tt, jerarquias_docentes t2 where tt.jdoc_ccod=t2.jdoc_ccod and tt.pers_ncorr=big_table.pers_ncorr),'') as tipo_jerarquia, " & vbCrLf &_
     		 "   isnull((select top 1 tido_tdesc from anos_tipo_docente tt, tipos_docente t2 where tt.tido_ccod=t2.tido_ccod and tt.pers_ncorr=big_table.pers_ncorr),'') as tipo_docente, " & vbCrLf &_
			 "   isnull((select top 1 tpro_tdesc from profesores tt, tipos_profesores t2 where tt.tpro_ccod=t2.tpro_ccod and tt.pers_ncorr=big_table.pers_ncorr),'') as tipo_profesor, " & vbCrLf &_
			 "	 (select case count(*) when 0 then 'No' else 'Sí' end    " & vbCrLf &_
			 "	  from bloques_profesores ta, bloques_horarios tb, secciones tc, carreras td    " & vbCrLf &_
			 "	  where ta.bloq_ccod=tb.bloq_ccod and tb.secc_ccod=tc.secc_ccod and tc.carr_ccod=td.carr_ccod    " & vbCrLf &_
			 "	  and ta.pers_ncorr=big_table.pers_ncorr and tc.peri_ccod='"&peri_ccod&"' and td.TGRA_CCOD in (1)) as en_tecnicas,    " & vbCrLf &_
			 "	 (select case count(*) when 0 then 'No' else 'Sí' end    " & vbCrLf &_
			 "	  from bloques_profesores ta, bloques_horarios tb, secciones tc, carreras td    " & vbCrLf &_
			 "	  where ta.bloq_ccod=tb.bloq_ccod and tb.secc_ccod=tc.secc_ccod and tc.carr_ccod=td.carr_ccod  " & vbCrLf &_  
			 "	  and ta.pers_ncorr=big_table.pers_ncorr and tc.peri_ccod='"&peri_ccod&"' and td.TGRA_CCOD in (2,7)) as en_profesionales,    " & vbCrLf &_
			 "	 (select case count(*) when 0 then 'No' else 'Sí' end    " & vbCrLf &_
			 "	  from bloques_profesores ta, bloques_horarios tb, secciones tc, carreras td    " & vbCrLf &_
			 "	  where ta.bloq_ccod=tb.bloq_ccod and tb.secc_ccod=tc.secc_ccod and tc.carr_ccod=td.carr_ccod  " & vbCrLf &_  
			 "	  and ta.pers_ncorr=big_table.pers_ncorr and tc.peri_ccod='"&peri_ccod&"' and td.TGRA_CCOD in (3,6,8)) as en_otras " & vbCrLf &_
			 "	 from " & vbCrLf &_
			 "	 ( " & vbCrLf &_
			 "		 select distinct d.pers_ncorr,protic.obtiene_facultad_carrera(i.carr_ccod) as              facultad, " & vbCrLf &_
			 "						isnull(sexo_tdesc, 'Sin informacion')                      as              sexo,  " & vbCrLf &_                                                                           
			 "						d.pers_nrut                                                as              rut,   " & vbCrLf &_                                                                           
			 "						d.pers_xdv                                                 as              dv,   " & vbCrLf &_                                                                              
			 "						d.pers_tnombre                                             as              nombre,  " & vbCrLf &_                                                                      
			 "						d.pers_tape_paterno                                        as              ap_paterno,  " & vbCrLf &_                                                                     
			 "						d.pers_tape_materno                                        as              ap_materno,  " & vbCrLf &_                                                                     
			 "						(select top 1 cudo_titulo     " & vbCrLf &_                                                    
			 "						 from   curriculum_docente     " & vbCrLf &_                                                   
			 "						 where  pers_ncorr = a.pers_ncorr   " & vbCrLf &_                                              
			 "								and grac_ccod in( 1, 2 )   " & vbCrLf &_                                               
			 "						 order  by grac_ccod desc)                                 as              profesion,  " & vbCrLf &_                                                                      
			 "						b.anex_ncodigo                                             as              bloq_anexo,  " & vbCrLf &_                                                                     
			 "						i.carr_tdesc,   " & vbCrLf &_                                                                  
			 "						c.asig_ccod,    " & vbCrLf &_                                                                  
			 "						( c.dane_nsesiones / 2 )                                   as              asig_nhoras,  " & vbCrLf &_                                                                    
			 "						j.asig_tdesc,    " & vbCrLf &_                                                                 
			 "						k.duas_tdesc,   " & vbCrLf &_                                                                  
			 "						c.dane_msesion                                             as              bpro_mvalor,  " & vbCrLf &_                                                                    
			 "						cast(( c.dane_nsesiones / 2 ) * c.dane_msesion as numeric) as              valor,  " & vbCrLf &_                                                                          
			 "						protic.trunc(a.cdoc_finicio)                               as              fechai,  " & vbCrLf &_                                                                         
			 "						protic.trunc(a.cdoc_ffin)                                  as              fechaf,  " & vbCrLf &_                                                                         
			 "						b.anex_nhoras_coordina                                     as              hor_coordinacion1,  " & vbCrLf &_                                                              
			 "						0                                                          as              hor_ccordinacion1,  " & vbCrLf &_                                                              
			 "						n.secc_tdesc,  " & vbCrLf &_                                                                   
			 "						'--'                                                       as              porcentaje,  " & vbCrLf &_                                                                     
			 "						0                                                          as              montomc,  " & vbCrLf &_                                                                        
			 "						e.sede_tdesc,  " & vbCrLf &_                                                                   
			 "						b.anex_ncuotas                                             as              num_cuotas, " & vbCrLf &_                                                                      
			 "						pea.peri_tdesc                                             as              semestre,  " & vbCrLf &_                                                                       
			 "						jor.jorn_tdesc                                             as              jornada,  " & vbCrLf &_                                                                        
			 "						datediff(year, d.pers_fnacimiento, getdate())              as              edad,  " & vbCrLf &_                                                                           
			 "						prof_ingreso_uas                                           as              ano_ingreso,  " & vbCrLf &_                                                                    
			 "						protic.trunc(b.anex_finicio)                               as              fecha_inicio,  " & vbCrLf &_                                                                   
			 "						protic.trunc(b.anex_ffin)                                  as              fecha_fin,  " & vbCrLf &_                                                                      
			 "						o.tpro_tdesc                                               as              tipo_profesor,  " & vbCrLf &_                                                                  
			 "						cast(( c.dane_nsesiones * 75 ) / 60 as numeric) /   " & vbCrLf &_                              
			 "						case   " & vbCrLf &_                                                                           
			 "						k.duas_tdesc  " & vbCrLf &_                                                                    
			 "						when 'ANUAL'then 36  " & vbCrLf &_                                                             
			 "						when 'SEMESTRAL' then 18  " & vbCrLf &_                                                        
			 "						when 'TRIMESTRAL' then 12   " & vbCrLf &_                                                      
			 "						when 'PERIODO' then 12   " & vbCrLf &_                                                         
			 "																		  end      as              hora_semana,   " & vbCrLf &_                                                                     
			 "						(select top 1 jdoc_tdesc  " & vbCrLf &_                                                        
			 "						 from   profesores pro,  " & vbCrLf &_                                                         
			 "								jerarquias_docentes jd  " & vbCrLf &_                                                  
			 "						 where  pro.pers_ncorr = a.pers_ncorr  " & vbCrLf &_                                           
			 "								and pro.jdoc_ccod = jd.jdoc_ccod)                  as              jerarquia,  " & vbCrLf &_                                                                       
			 "						(select top 1 protic.trunc(per.pers_fnacimiento)  " & vbCrLf &_                                
			 "						 from   personas per   " & vbCrLf &_                                                           
			 "						 where  per.pers_ncorr = a.pers_ncorr)                     as              cumple,  " & vbCrLf &_                                                                         
			 "						isnull(q.tcdo_tdesc, 'Honorarios')                         as              tipo_contrato,  " & vbCrLf &_                                                                   
			 "						g.dire_tcalle + ' ' + g.dire_tnro                          as              direccion,  " & vbCrLf &_                                                                       
			 "						h.ciud_tdesc + ' - ' + h.ciud_tcomuna                      as              c_c,  " & vbCrLf &_
			 "						j.duas_ccod  " & vbCrLf &_
			 "		from   contratos_docentes_upa as a  " & vbCrLf &_                                                               
			 "			   inner join anexos as b  " & vbCrLf &_                                                                   
			 "					   on a.cdoc_ncorr = b.cdoc_ncorr  " & vbCrLf &_                                                    
			 "						  and b.eane_ccod <> 3   " & vbCrLf &_                                                         
			 "			   inner join detalle_anexos as c  " & vbCrLf &_                                                           
			 "					   on b.anex_ncorr = c.anex_ncorr  " & vbCrLf &_                                                   
			 "			   inner join personas as d   " & vbCrLf &_                                                                
			 "					   on a.pers_ncorr = d.pers_ncorr  " & vbCrLf &_                                                   
			 "			   inner join sedes as e   " & vbCrLf &_                                                                   
			 "					   on b.sede_ccod = e.sede_ccod  " & vbCrLf &_                                                     
			 "			   inner join estados_civiles as f  " & vbCrLf &_                                                          
			 "					   on d.eciv_ccod = f.eciv_ccod  " & vbCrLf &_                                                     
			 "			   inner join direcciones as g   " & vbCrLf &_                                                             
			 "					   on a.pers_ncorr = g.pers_ncorr   " & vbCrLf &_                                                  
			 "						  and g.tdir_ccod = 1  " & vbCrLf &_                                                           
			 "			   inner join ciudades as h   " & vbCrLf &_                                                                
			 "					   on g.ciud_ccod = h.ciud_ccod  " & vbCrLf &_                                                     
			 "			   inner join carreras as i  " & vbCrLf &_                                                                 
			 "					   on b.carr_ccod = i.carr_ccod  " & vbCrLf &_                                                     
			 "			   inner join secciones as n   " & vbCrLf &_                                                               
			 "					   on c.secc_ccod = n.secc_ccod  " & vbCrLf &_                                                     
			 "			   inner join periodos_academicos as pea   " & vbCrLf &_                                                   
			 "					   on n.peri_ccod = pea.peri_ccod   " & vbCrLf &_                                                  
			 "			   inner join asignaturas as j   " & vbCrLf &_                                                             
			 "					   on c.asig_ccod = j.asig_ccod   " & vbCrLf &_                                                    
			 "			   inner join duracion_asignatura as k   " & vbCrLf &_                                                     
			 "					   on c.duas_ccod = k.duas_ccod   " & vbCrLf &_                                                     
			 "			   inner join instituciones as l  " & vbCrLf &_                                                            
			 "					   on l.inst_ccod = 1  " & vbCrLf &_                                                               
			 "			   inner join paises as m   " & vbCrLf &_                                                                  
			 "					   on isnull(m.pais_ccod, 1) = isnull(d.pais_ccod, 1)  " & vbCrLf &_                               
			 "			   inner join jornadas as jor  " & vbCrLf &_                                                               
			 "					   on n.jorn_ccod = jor.jorn_ccod   " & vbCrLf &_                                                  
			 "			   inner join profesores as p   " & vbCrLf &_                                                              
			 "					   on b.sede_ccod = p.sede_ccod   " & vbCrLf &_                                                    
			 "						  and d.pers_ncorr = p.pers_ncorr   " & vbCrLf &_                                              
			 "			   inner join tipos_profesores as o   " & vbCrLf &_                                                        
			 "					   on p.tpro_ccod = o.tpro_ccod  " & vbCrLf &_                                                     
			 "			   left outer join tipos_contratos_docentes as q  " & vbCrLf &_                                             
			 "							on a.tcdo_ccod = q.tcdo_ccod  " & vbCrLf &_                                                
			 "			   left outer join sexos as r  " & vbCrLf &_                                                               
			 "							on d.sexo_ccod = r.sexo_ccod  " & vbCrLf &_                                                 
			 "		where  cast(a.ecdo_ccod as varchar) = '"&ecdo_ccod&"' " & vbCrLf &_  
			 "		and o.tpro_tdesc = 'DOCENTE'  " & vbCrLf &_                                                            
			 "		and cast(a.ano_contrato as varchar) = '"&ano&"'  " & vbCrLf &_
			 "		and cast(n.peri_ccod as varchar) = '"&peri_ccod&"' " & vbCrLf &_
			 "	)big_table  "&filtro_tipo& vbCrLf &_
			 "	group by pers_ncorr,rut,dv,ap_paterno,ap_materno,nombre,sexo,cumple,ano_ingreso,tipo_contrato  " & vbCrLf &_
			 "	order by apellido_paterno, apellido_materno, nombre "
'------------------------------------------------------------------------------------------------------fin_Nueva consulta 2008

'response.Write("<pre>"&profesores&"</pre>")
'response.end()
f_docentes.Consultar profesores
f_docentes.siguiente

carreras = f_docentes.obtenerValor("carreras_imparte_clases")
a_carreras = Split(carreras,"|")
largo_maximo = ubound(a_carreras)

while f_docentes.siguiente
	carreras = f_docentes.obtenerValor("carreras_imparte_clases")
	a_carreras = Split(carreras,"|")
	if largo_maximo < ubound(a_carreras) then
		largo_maximo = ubound(a_carreras)
	end if
wend 

'response.Write(largo_maximo) 
f_docentes.primero







%>

<html>
<head>
<title>Listado de Docentes</title>
<meta http-equiv="Content-Type" content="text/html;">
<style type="text/css">
<!--
.estilo1 {
font-family: Arial, Helvetica, sans-serif;
font-size: 12px;
color: #003366;
}
.estilo2 {
color: #990000;
font-weight: bold;
}
.estilo3 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #ffffff; }

.estilo4 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #000000; }
-->
</style>

</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="2">&nbsp;</td>
  </tr>
 <tr> 
    <td colspan="2"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Docentes SIES</font></div>
	  <div align="right"></div></td>
  </tr>
  <tr> 
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="2" align="left">Fecha Actual: <%=fecha_actual%></td>
  </tr>
  <tr> 
    <td colspan="2">&nbsp;</td>
  </tr>
</table>

<table width="100%" border="1">
    <tr borderColor="#999999" bgColor="#c4d7ff">
	  <td><FONT color="#333333">
	  <div align="center"><strong>N°</strong></div></font></td>
      <td><FONT color="#333333">
	  <div align="center"><strong>Rut</strong></div></font></td>
	  <td><FONT color="#333333">
	  <div align="center"><strong>Dv</strong></div></font></td>
	  <td><FONT color="#333333">
	  <div align="center"><strong>Apellido Paterno</strong></div></font></td>
      <td><FONT color="#333333">
	  <div align="center"><strong>Apellido Materno</strong></div></font></td>
	  <td><FONT color="#333333">
	  <div align="center"><strong>Nombre</strong></div></font></td>
	  <td><FONT color="#333333">
	  <div align="center"><strong>Sexo</strong></div></font></td>
	   <td><FONT color="#333333">
	  <div align="center"><strong>Fecha de Nacimiento</strong></div></font></td>
	   <td><FONT color="#333333">
	  <div align="center"><strong>Nacionalidad</strong></div></font></td>
	   <td><FONT color="#333333">
	  <div align="center"><strong>Número de años en la Institución</strong></div></font></td>
       <%i=0
	     Palabra = "Principal"
	     while i <= largo_maximo
		  Select Case i+1
			Case 1
				Palabra = "Principal"
			Case 2
				Palabra = "Segunda"
			Case 3
				Palabra = "Tercera"
			Case 4
		 		Palabra = "Cuarta"
			Case 5
		 		Palabra = "Quinta"
			Case 6
		 		Palabra = "Sexta"	
			Case 7
		 		Palabra = "Séptima"
			Case 8
		 		Palabra = "Octava"
			Case 9
		 		Palabra = "Novena"
			Case 10
		 		Palabra = "Décima"	
		  End Select%>
         <td><FONT color="#333333">
              <div align="center"><strong><%=Palabra%> Unidad Acádemica donde se desempeña</strong></div></font></td>
         <td><FONT color="#333333">
              <div align="center"><strong>Región de la Unidad Acádemica donde se desempeña</strong></div></font></td>
		 
		 <%i = i + 1
		 wend 
	    %>
	    <td><FONT color="#333333">
	        <div align="center"><strong>Nivel de Formación Acádemica del Docente</strong></div></font></td>
	    <td><FONT color="#333333">
	    	<div align="center"><strong>Nombre del Grado</strong></div></font></td>
	    <td><FONT color="#333333">
	    	<div align="center"><strong>País donde lo Obtuvo </strong></div></font></td>
	    <td><FONT color="#333333">
	    	<div align="center"><strong>Fecha en que lo Obtuvo</strong></div></font></td>
	   <td><FONT color="#333333">
	    	<div align="center"><strong>Institución en que lo Obtuvo</strong></div></font></td>
       <td><FONT color="#333333">
	    	<div align="center"><strong>Tipo de contrato</strong></div></font></td>
	   <td><FONT color="#333333">
	    	<div align="center"><strong>N° de Horas Docente</strong></div></font></td>
       <td><FONT color="#333333">
	    	<div align="center"><strong>Horas Semanales</strong></div></font></td>
       <td><FONT color="#333333">
	    	<div align="center"><strong>Tipo Jornada</strong></div></font></td>
       <td><FONT color="#333333">
	    	<div align="center"><strong>Tipo Jerarquía</strong></div></font></td>                 
       <td><FONT color="#333333">
	    	<div align="center"><strong>Tipo Docente</strong></div></font></td>     
       <td><FONT color="#333333">
	    	<div align="center"><strong>Tipo Profesor</strong></div></font></td>     
	   <td><FONT color="#333333">
	    	<div align="center"><strong>En carreras Técnicas</strong></div></font></td>
	   <td><FONT color="#333333">
	    	<div align="center"><strong>En carreras Profesionales</strong></div></font></td>
	   <td><FONT color="#333333">
	  		<div align="center"><strong>En Otras</strong></div></font></td>
    </tr>
	
	<% fila = 1
	 while f_docentes.siguiente %>
	<tr bgcolor="#FFFFFF">
		<td align="left"><div class="Estilo4"><%=fila%></td>
        <td align="left"><div class="Estilo4"><%=f_docentes.ObtenerValor("rut")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("dv")%></td>
		<td align="left"><div  class="Estilo4"><%=f_docentes.ObtenerValor("Apellido_paterno")%></td>
		<td align="left"><div  class="Estilo4"><%=f_docentes.ObtenerValor("Apellido_materno")%></td>
		<td align="left"><div  class="Estilo4"><%=f_docentes.ObtenerValor("Nombre")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("sexo")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("Fecha_de_nacimiento")%></td>
		<td align="left"><div class="Estilo4"><%=f_docentes.ObtenerValor("Nacionalidad")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("Numero_de_anos_en_la_Institucion")%></td>
		<%i=0
		    carreras = f_docentes.obtenerValor("carreras_imparte_clases")
			a_carreras = Split(carreras,"|")
			largo = ubound(a_carreras)
			if largo = 0 then
			i = i + 1%>
			 <td><%=carreras%></td>
		     <td>15</td>
			<%end if
	      while i <= largo_maximo 
		    carrera = ""
			region = ""
			if i <= largo then
			 carrera = a_carreras(i)
			 region  = "15"
			end if%>
          <td><%=carrera%></td>
		  <td><%=region%></td>
        <%i = i + 1
		 wend 
		 color1 = "#FFFFFF"
		 color2 = "#FFFFFF"
		 color3 = "#FFFFFF"
		 if f_docentes.ObtenerValor("en_tecnicas") <> "No" then
		 	color1 = "#CC6600"
		 end if
		 if f_docentes.ObtenerValor("en_profesionales") <> "No" then
		 	color2 = "#CC6600"
		 end if
		 if f_docentes.ObtenerValor("en_otras") <> "No" then
		 	color3 = "#CC6600"
		 end if
	    %>
        <td align="left"><div class="Estilo4"><%=f_docentes.ObtenerValor("nivel_de_formacion_academica_del_docente")%></td>
		<td align="left"><div class="Estilo4"><%=f_docentes.ObtenerValor("Nombre_del_grado")%></td>
		<td align="left"><div class="Estilo4"><%=f_docentes.ObtenerValor("pais_donde_lo_obtuvo")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("fecha_en_que_lo_obtuvo")%></td>
		<td align="left"><div class="Estilo4"><%=f_docentes.ObtenerValor("institucion_en_que_lo_obtuvo")%></td>
        <td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("tipo_contrato")%></td>
		<td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("horas_docentes")%></td>
        <td><div align="center" class="Estilo4"><%=(((cdbl(f_docentes.ObtenerValor("horas_docentes")) * 90)/60)/18)%></td>
        <td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("tipo_jornada")%></td>
        <td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("tipo_jerarquia")%></td>
        <td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("tipo_docente")%></td>
        <td><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("tipo_profesor")%></td>        
		<td bgcolor="<%=color1%>"><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("en_tecnicas")%></td>
		<td bgcolor="<%=color2%>"><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("en_profesionales")%></td>
		<td bgcolor="<%=color3%>"><div align="center" class="Estilo4"><%=f_docentes.ObtenerValor("en_otras")%></td>
	</tr>
	<%fila = fila + 1
	  wend%>
</table>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>
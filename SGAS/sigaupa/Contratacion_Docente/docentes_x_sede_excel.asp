<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=docentes_por_sede.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------función para buscar la cantidad de docentes----------------------------------
Function Cantidad_docentes(sede,grado,tipo_jornada,sexo)
'-------------------------debemos buscar solo los dcentes pertenecientes a un solo grado, vale decir un doctor que tambien tiene un magister
'-----------------------------------------solo es considerado como doctor no como magister
if grado= 5 then
	filtro_estricto = " "
elseif grado=4 then 
	filtro_estricto = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5) " & vbCrLf 	
elseif grado=3 then 
	filtro_estricto = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (4,5)) " & vbCrLf 	
elseif grado=2 then 
	filtro_estricto = "  " & vbCrLf 	
elseif grado=1 then 
	filtro_estricto = "  and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (2)) " & vbCrLf 	
elseif grado =0 then
	filtro_estricto1 = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,5)) " & vbCrLf
	filtro_estricto2 = "  and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2)) " & vbCrLf 	
end if
'dependiendo del tipo de  jornada debemos buscar a los docentes cuyas horas esten dentro del criterio asignado.
if tipo_jornada = 1 then
    filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) >= 33"  
elseif tipo_jornada = 2 then
	filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) <= 32"  
elseif tipo_jornada = 3  then
    filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) <= 19"  
end if

if sede = 2 then
	filtro_sede= " in ('1','2')"
else
	filtro_sede= " = '"&sede&"'"
end if

if grado > 2 then

consulta_Cantidad = " select count(distinct c.pers_ncorr) "& vbCrLf &_ 
					" from secciones a join bloques_horarios b "& vbCrLf &_
				    " 	on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
					"   on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join grados_profesor d "& vbCrLf &_
				    "   on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" join personas e "& vbCrLf &_
				    "   on c.pers_ncorr = e.pers_ncorr    "& vbCrLf &_
					" where cast(d.grac_ccod as varchar)='"& grado&"' and c.tpro_ccod=1"& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto& vbCrLf &_
					" and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" and cast(e.sexo_ccod as varchar)='"&sexo&"'" 
Cantidad_docentes= conexion.consultaUno(consulta_cantidad)					

elseif grado > 0 and grado <= 2 then

consulta_Cantidad = " select count(distinct c.pers_ncorr) as cantidad_doctores "& vbCrLf &_
					" from secciones a join bloques_horarios b "& vbCrLf &_
					"    on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
				    "    on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join curriculum_docente d "& vbCrLf &_
				    "    on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" join personas e "& vbCrLf &_
				    "    on c.pers_ncorr = e.pers_ncorr    "& vbCrLf &_
					" where cast(d.grac_ccod as varchar)='"&grado&"' and c.tpro_ccod=1"& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto& vbCrLf &_
					" and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" and not exists (select 1 from grados_profesor gr where gr.pers_ncorr = c.pers_ncorr and gr.grac_ccod in (3,4,5)) "& vbCrLf &_
				    " and cast(e.sexo_ccod as varchar)='"&sexo&"'"
Cantidad_docentes= conexion.consultaUno(consulta_cantidad)

else
consulta_Cantidad_sin_grado = " select count(distinct c.pers_ncorr) "& vbCrLf &_ 
					" from secciones a join bloques_horarios b "& vbCrLf &_
				    " 	on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
					"   on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join grados_profesor d "& vbCrLf &_
				    "   on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" join personas e "& vbCrLf &_
				    "   on c.pers_ncorr = e.pers_ncorr    "& vbCrLf &_
					" where cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto1& vbCrLf &_
					" "&filtro_estricto2& vbCrLf &_
					" and cast(e.sexo_ccod as varchar)='"&sexo&"' and c.tpro_ccod=1"
						
consulta_Cantidad_sin_titulo = " select count(distinct c.pers_ncorr) as cantidad_doctores "& vbCrLf &_
					" from secciones a join bloques_horarios b "& vbCrLf &_
					"    on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
				    "    on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join curriculum_docente d "& vbCrLf &_
				    "    on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" join personas e "& vbCrLf &_
				    "    on c.pers_ncorr = e.pers_ncorr    "& vbCrLf &_
					" where not exists (select 1 from grados_profesor gr where gr.pers_ncorr = c.pers_ncorr) "& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto2& vbCrLf &_
					" and cast(a.sede_ccod as varchar)"&filtro_sede& vbCrLf &_
					" and cast(e.sexo_ccod as varchar)='"&sexo&"' and c.tpro_ccod=1"		

     Cantidad_docentes = cint(conexion.consultaUno(consulta_Cantidad_sin_grado))+cint(conexion.consultaUno(consulta_Cantidad_sin_titulo))
end if


End Function

'------------------------------------------------------------------------------------------------------------------------------------
'-----------------------------------Funcion para buscar el total de horas de los docentes--------------------------------------------
'------------------------------------------función para buscar la cantidad de docentes----------------------------------
Function Cantidad_horas_docentes(sede,grado,tipo_jornada)
'-------------------------debemos buscar solo los dcentes pertenecientes a un solo grado, vale decir un doctor que tambien tiene un magister
'-----------------------------------------solo es considerado como doctor no como magister
if grado= 5 then
	filtro_estricto = " "
elseif grado=4 then 
	filtro_estricto = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5) " & vbCrLf 	
elseif grado=3 then 
	filtro_estricto = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (4,5)) " & vbCrLf 	
elseif grado=2 then 
	filtro_estricto = "  " & vbCrLf 	
elseif grado=1 then 
	filtro_estricto = "  and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (2)) " & vbCrLf 	
elseif grado =0 then
	filtro_estricto1 = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,5)) " & vbCrLf
	filtro_estricto2 = "  and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2)) " & vbCrLf 	
end if
'dependiendo del tipo de  jornada debemos buscar a los docentes cuyas horas esten dentro del criterio asignado.
if tipo_jornada = 1 then
    filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) >= 33"  
elseif tipo_jornada = 2 then
	filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) <= 32"  
elseif tipo_jornada = 3  then
    filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) <= 19"  
end if

if sede = 2 then
	filtro_sede= " in ('1','2')"
else
	filtro_sede= " = '"&sede&"'"
end if

if grado > 2 then

consulta_Cantidad = " select cast(isnull(sum(horas * 45 / 60),0) as numeric) from (select distinct c.pers_ncorr,a.sede_ccod "& vbCrLf &_ 
					" from secciones a join bloques_horarios b "& vbCrLf &_
				    " 	on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
					"   on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join grados_profesor d "& vbCrLf &_
				    "   on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" join personas e "& vbCrLf &_
				    "   on c.pers_ncorr = e.pers_ncorr    "& vbCrLf &_
					" where cast(d.grac_ccod as varchar)='"& grado&"' and c.tpro_ccod=1"& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto& vbCrLf &_
					" and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" )a, horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod" 
Cantidad_horas_docentes= conexion.consultaUno(consulta_cantidad)					

elseif grado > 0 and grado <= 2 then

consulta_Cantidad = " select cast(isnull(sum(horas * 45 / 60 ),0) as numeric) from (select distinct c.pers_ncorr,a.sede_ccod "& vbCrLf &_
					" from secciones a join bloques_horarios b "& vbCrLf &_
					"    on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
				    "    on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join curriculum_docente d "& vbCrLf &_
				    "    on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" join personas e "& vbCrLf &_
				    "    on c.pers_ncorr = e.pers_ncorr    "& vbCrLf &_
					" where cast(d.grac_ccod as varchar)='"&grado&"' and c.tpro_ccod=1"& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto& vbCrLf &_
					" and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" and not exists (select 1 from grados_profesor gr where gr.pers_ncorr = c.pers_ncorr and gr.grac_ccod in (3,4,5)) "& vbCrLf &_
				    " )a,horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod" 
Cantidad_horas_docentes= conexion.consultaUno(consulta_cantidad)

else
consulta_Cantidad_sin_grado = " select cast(isnull(sum(horas * 45 / 60),0) as numeric) from (select distinct c.pers_ncorr,a.sede_ccod "& vbCrLf &_ 
					" from secciones a join bloques_horarios b "& vbCrLf &_
				    " 	on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
					"   on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join grados_profesor d "& vbCrLf &_
				    "   on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" join personas e "& vbCrLf &_
				    "   on c.pers_ncorr = e.pers_ncorr    "& vbCrLf &_
					" where cast(a.sede_ccod as varchar) "&filtro_sede& " and c.tpro_ccod=1"&vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto1& vbCrLf &_
					" "&filtro_estricto2& vbCrLf &_
					" )a,horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod" 
						
consulta_Cantidad_sin_titulo = " select cast(isnull(sum(horas * 45 / 60),0) as numeric) from (select distinct c.pers_ncorr,a.sede_ccod "& vbCrLf &_
					" from secciones a join bloques_horarios b "& vbCrLf &_
					"    on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
				    "    on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join curriculum_docente d "& vbCrLf &_
				    "    on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" join personas e "& vbCrLf &_
				    "    on c.pers_ncorr = e.pers_ncorr    "& vbCrLf &_
					" where not exists (select 1 from grados_profesor gr where gr.pers_ncorr = c.pers_ncorr) and c.tpro_ccod=1"& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto2& vbCrLf &_
					" and cast(a.sede_ccod as varchar)"&filtro_sede& vbCrLf &_
					" )a,horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod" 		

     Cantidad_horas_docentes = cint(conexion.consultaUno(consulta_Cantidad_sin_grado))+cint(conexion.consultaUno(consulta_Cantidad_sin_titulo))
end if
End Function
'-----------------------------------------------------------------------
sede_ccod = request.QueryString("sede_ccod")  'negocio.obtenerSede
sede_tdesc = conexion.consultaUno("select protic.initcap(sede_tdesc) from sedes where cast(sede_ccod as varchar)= '"&sede_ccod&"'")
'------------------------------------------------------------------------------------
fecha_01=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
%>
<html>
<head>
<title>docentes por sede</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="2">&nbsp;</td>
  </tr>
 <tr> 
    <td colspan="2"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Docentes sede <%=sede_tdesc%></font></div>
	  <div align="right"></div></td>
  </tr>
  <tr> 
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr> 
    <td width="7%"><strong>Fecha</strong></td>
    <td width="93%"><strong>:</strong> <%=fecha_01%></td>
  </tr>
  <%if sede_ccod = 2 then%>
  <tr> 
    <td colspan="2"><font color="#0000FF">
					* Los Datos de Providencia se suman a la sede Central ya que por encontrarse en la misma ciudad tiene el carácter de Campus.
                    </font></td>
  </tr>
  <%end if%>
</table>

<p>&nbsp;</p>
<table width="100%" border="1">
<tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="70%" colspan="4" valign="bottom"><FONT color="#333333"><div align="center"><strong>Docentes Sede <%=sede_tdesc%></strong></div></font></td>
                              </tr>
							  <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="70%" colspan="4" valign="bottom"><FONT color="#333333"><div align="center">AÑO 2005</div></font></td>
                              </tr>
							  <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="60%" rowspan="1" valign="bottom"><FONT color="#333333"><div align="center">Docentes</div></font></td>
                                <td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Hombres</div></font></td>
                                <td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Mujeres</div></font></td>
                                <td width="20%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Horas cronológicas contratadas</div></font></td>
                              </tr>
							  <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Doctores Jornada completa</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,1,1)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,1,2)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,1)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Doctores Media Jornada</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,2,1)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,2,2)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,2)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Doctores Jornada Hora</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,3,1)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,3,2)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,3)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Magíster Jornada completa</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,1,1)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,1,2)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,1)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Magíster Media Jornada</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,2,1)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,2,2)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,2)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Magíster Jornada Hora</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,3,1)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,3,2)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,3)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Licenciados Jornada completa</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,1,1)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,1,2)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,3,1)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Licenciados Media Jornada</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,2,1)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,2,2)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,3,2)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Liceciados Jornada Hora</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,3,1)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,3,2)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,3,3)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Profesionales Jornada completa</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,1,1)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,1,2)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,2,1)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Profesionales Media Jornada</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,2,1)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,2,2)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,2,2)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Profesionales Jornada Hora</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,3,1)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,3,2)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,2,3)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Téc. Nivel Súperior Jornada completa</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,1,1)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,1,2)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,1,1)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Téc. Nivel Súperior Media Jornada</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,2,1)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,2,2)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,1,2)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Téc. Nivel Súperior Jornada Hora</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,3,1)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,3,2)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,1,3)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Sin título o grado Jornada completa</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,1,1)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,1,2)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,0,1)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Sin título o grado Media Jornada</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,2,1)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,2,2)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,0,2)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Sin título o grado Jornada Hora</div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,3,1)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,3,2)%></div></td>
										<td><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,0,3)%></div></td>
							 </tr>
</table>
<div align="right">* Las horas son medidas de forma cronológica &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>
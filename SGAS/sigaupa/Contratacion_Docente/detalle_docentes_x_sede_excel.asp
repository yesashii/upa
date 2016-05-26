<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=listado_docentes.xls"
Response.ContentType = "application/vnd.ms-excel"

set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

sede = request.QueryString("sede_ccod")
grado = request.QueryString("grado")
tipo_jornada = request.QueryString("tipo_jornada")
sexo = request.QueryString("sexo")

tituloPag = "Listado docentes "




set docentes = new cformulario
docentes.carga_parametros "tabla_vacia.xml","tabla"
docentes.inicializar conectar

'-------------------------------------------------------------------------------------------------------------------------
if grado= 5 then
	filtro_estricto = " "
	tituloPag = tituloPag + " con grado académico de Doctor"
elseif grado=4 then 
	filtro_estricto = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5) " & vbCrLf 	
		tituloPag = tituloPag + " con grado académico de Magíster"
elseif grado=3 then 
	filtro_estricto = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (4,5)) " & vbCrLf 	
	tituloPag = tituloPag + " con grado académico de Licenciado"    
elseif grado=2 then 
	filtro_estricto = "  " & vbCrLf 
		tituloPag = tituloPag + " con Título Profesional "	
elseif grado=1 then 
	filtro_estricto = "  and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (2)) " & vbCrLf 	
	tituloPag = tituloPag + " Técnicos de nivel súperior"
elseif grado =0 then
	filtro_estricto1 = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,5)) " & vbCrLf
	filtro_estricto2 = "  and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2)) " & vbCrLf 	
	tituloPag = tituloPag + " sin título ni grado académico"
end if
'dependiendo del tipo de  jornada debemos buscar a los docentes cuyas horas esten dentro del criterio asignado.
if tipo_jornada = 1 then
    filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) >= 33"  
	tituloPag = tituloPag + " y en Jornada Completa"
elseif tipo_jornada = 2 then
	filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) <= 32"  
	tituloPag = tituloPag + " y en Media Jornada"
elseif tipo_jornada = 3  then
    filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) <= 19"  
	tituloPag = tituloPag + " y en Jornada Hora"
end if

if sede = 2 then
	filtro_sede= " in ('1','2')"
else
	filtro_sede= " = '"&sede&"'"
end if

if grado > 2 then
titulo_celda="Grado Académico"
consulta = " select distinct c.pers_ncorr, cast(e.pers_nrut as varchar)+'-'+ e.pers_xdv as rut, e.pers_tape_paterno + ' '+ pers_tape_materno + ' ' + pers_tnombre as nombre, gpro_tdescripcion as grado, "& vbCrLf &_ 
                    " (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod ) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod ) as horas_semanales	 "& vbCrLf &_
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

elseif grado > 0 and grado <= 2 then
titulo_celda="Título"
consulta = " select distinct c.pers_ncorr, cast(e.pers_nrut as varchar)+'-'+ e.pers_xdv as rut, e.pers_tape_paterno + ' '+ pers_tape_materno + ' ' + pers_tnombre as nombre, d.cudo_titulo as grado,  "& vbCrLf &_
                    " (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod ) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod ) as horas_semanales	 "& vbCrLf &_
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

else
titulo_celda="Información"
consulta = " select distinct c.pers_ncorr, cast(e.pers_nrut as varchar)+'-'+ e.pers_xdv as rut, e.pers_tape_paterno + ' '+ pers_tape_materno + ' ' + pers_tnombre as nombre, ' Sin título ni grado académico' as grado,  "& vbCrLf &_ 
                    " (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod ) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod ) as horas_semanales	 "& vbCrLf &_
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
					" and cast(e.sexo_ccod as varchar)='"&sexo&"' and c.tpro_ccod=1"& vbCrLf &_
					" union " & vbCrLf &_
				    " select distinct c.pers_ncorr, cast(e.pers_nrut as varchar)+'-'+ e.pers_xdv as rut, e.pers_tape_paterno + ' '+ pers_tape_materno + ' ' + pers_tnombre as nombre, ' Sin título ni grado académico' as grado, "& vbCrLf &_
					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod ) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) as horas_semanales	 "& vbCrLf &_
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

end if

'--------------------------------------------------------------------------------------------------------------------------
'response.Write("<pre>"&consulta&"</pre>")
sede_tdesc = conectar.consultaUno("select protic.initCap(sede_tdesc) from sedes where cast(sede_ccod as varchar)='"&sede&"'")
sexo_tdesc = conectar.consultaUno("select protic.initCap(sexo_tdesc) from sexos where cast(sexo_ccod as varchar)='"&sexo&"'")

docentes.Consultar consulta & " order by nombre"
cantidad_lista= conectar.consultaUno("select count(distinct a.pers_ncorr) from ("&consulta&")a")


%>
<html>
<head>
<title> Detalle Envio a Notaria</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif"><%=tituloPag%></font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Sede</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%= sede_tdesc%> </td>
    
  </tr>
  <tr> 
    <td height="22"><strong>Genero</strong></td>
    <td colspan="3"><strong>:</strong> <%=sexo_tdesc %> </td>
  </tr>
  <tr>
    <td><strong>Fecha</strong></td>
    <td colspan="3"> <strong>:</strong> <%=Date%></td>
 </tr>
 <tr>
     <td width="10%"><strong>Total</strong></td>
	 <td colspan="3"> <strong>:</strong> <%=cantidad_lista%> Docente(s)</td>
</tr>
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="3%" bgcolor="#FFFFCC"><div align="center"><strong>N°</strong></div></td>
    <td width="15%" bgcolor="#FFFFCC"><div align="center"><strong>Rut</strong></div></td>
    <td width="35%" bgcolor="#FFFFCC"><div align="center"><strong>Nombre Persona</strong></div></td>
    <td width="20%" bgcolor="#FFFFCC"><div align="center"><strong><%=titulo_celda%></strong></div></td>
    <td width="15%" bgColor="#FFFFCC"><div align="center"><strong>Horas Totales</strong></div></td>
	<td width="12%" bgColor="#FFFFCC"><div align="center"><strong>Horas Semanales</strong></div></td>  
  </tr>
  <% fila = 1 
     while docentes.Siguiente %>
  <tr> 
    <td><div align="left"><%=fila%></div></td>
	<td><div align="left"><%=docentes.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=docentes.ObtenerValor("nombre")%></div></td>
    <td><div align="left"><%=docentes.ObtenerValor("grado")%></div></td>
	<td><div align="center"><%=docentes.ObtenerValor("horas")%></div></td>
	<td><div align="center"><%=docentes.ObtenerValor("horas_semanales")%></div></td>
  </tr>
  <% fila = fila + 1  
  wend %>
</table>
<div align="right">* Las horas son medidas de forma cronológica &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>
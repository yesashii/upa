<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
pers_nrut = request.QueryString("pers_nrut")
carr_ccod = request.QueryString("carr_ccod")
tdes_ccod = request.QueryString("tdes_ccod")
peri_ccod = request.QueryString("peri_ccod")
comentario = request.QueryString("comentario")
tdes_ccod = 8
set conexion = new cConexion
conexion.inicializar "upacifico"

consulta_encabezado = "select top 1 protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n')+ ',' as nombre, "& vbCrLf &_
					  " --------------notas alumno"& vbCrLf &_
					  " (select top 1 case when isnull(porcentaje_notas,0) = 0 or isnull(calificacion_notas,0) = 0  then '' else 'Promedio Calificaciones Finales de la Carrera' end "& vbCrLf &_
					  " from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr)as concepto_notas, "& vbCrLf &_
					  " (select top 1 case when isnull(porcentaje_notas,0) = 0 or isnull(calificacion_notas,0) = 0  then '' else ' :    ' + cast(calificacion_notas as varchar) + '    *    ' + cast(porcentaje_notas as varchar)+ ' %' end  "& vbCrLf &_
					  " from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr)as calculo_notas,"& vbCrLf &_
				      " (select top 1 case when isnull(porcentaje_notas,0) = 0 or isnull(calificacion_notas,0) = 0  then '' else '=      ' + cast(cast(((isnull(calificacion_notas,0) *  isnull(porcentaje_notas,0))/100) as decimal (5,2)) as varchar) end "& vbCrLf &_
					  " from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr)as resultado_notas,                          "& vbCrLf &_  
					  " ---------------examen de título "& vbCrLf &_
					  " (select top 1 case when isnull(porcentaje_tesis,0) = 0 or isnull(calificacion_tesis,0) = 0  then '' else 'Calificación Examen de Título' end  "& vbCrLf &_
					  " from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr) as concepto_tesis, "& vbCrLf &_
					  " (select top 1 case when isnull(porcentaje_tesis,0) = 0 or isnull(calificacion_tesis,0) = 0  then '' else ' :    ' + cast(calificacion_tesis as varchar) + '    *    ' + cast(porcentaje_tesis as varchar)+ ' %' end  "& vbCrLf &_
					  " from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr) as calculo_tesis, "& vbCrLf &_
					  " (select top 1 case when isnull(porcentaje_tesis,0) = 0 or isnull(calificacion_tesis,0) = 0  then '' else '=      ' + cast(cast(((isnull(calificacion_tesis,0) *  isnull(porcentaje_tesis,0))/100) as decimal (5,2)) as varchar) end  "& vbCrLf &_
					  " from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr) as resultado_tesis, "& vbCrLf &_
					  " ---------------Práctica Profesional"& vbCrLf &_
					  " (select top 1 case when isnull(porcentaje_practica,0) = 0 or isnull(calificacion_practica,0) = 0  then '' else 'Calificación Práctica Profesional' end "& vbCrLf &_
					  " from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr) as concepto_practica, "& vbCrLf &_
					  " (select top 1 case when isnull(porcentaje_practica,0) = 0 or isnull(calificacion_practica,0) = 0  then '' else ' :    ' + cast(calificacion_practica as varchar) + '    *    ' + cast(porcentaje_practica as varchar)+ ' %' end  "& vbCrLf &_
					  " from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr) as calculo_practica,  "& vbCrLf &_                                                  
					  " (select top 1 case when isnull(porcentaje_practica,0) = 0 or isnull(calificacion_practica,0) = 0  then '' else '=      ' + cast(cast(((isnull(calificacion_practica,0) *  isnull(porcentaje_practica,0))/100) as decimal (5,2))as varchar) end "& vbCrLf &_
					  " from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr) as resultado_practica, "& vbCrLf &_                                                          
					  " ---------------Nota de tesis "& vbCrLf &_
					  " (select top 1 case when isnull(porcentaje_nota_tesis,0) = 0 or isnull(nota_tesis,0) = 0  then '' else 'Calificación de Tesis' end"& vbCrLf &_
					  " from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr) as concepto_nota_tesis, "& vbCrLf &_
					  " (select top 1 case when isnull(porcentaje_nota_tesis,0) = 0 or isnull(nota_tesis,0) = 0  then '' else ' :    ' + cast(nota_tesis as varchar) + '    *    ' + cast(porcentaje_nota_tesis as varchar)+ ' %' end  "& vbCrLf &_
					  " from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr) as calculo_nota_tesis, "& vbCrLf &_                                                         
					  " (select top 1 case when isnull(porcentaje_nota_tesis,0) = 0 or isnull(nota_tesis,0) = 0  then '' else '=      ' + cast(cast(((isnull(nota_tesis,0) *  isnull(porcentaje_nota_tesis,0))/100) as decimal (5,2))as varchar) end "& vbCrLf &_
					  " from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr) as resultado_nota_tesis,  "& vbCrLf &_                                                           
					  " ---------------Nota final "& vbCrLf &_
					  " (select top 1 case isnull(promedio_final,0)  when  0 then '' else 'Promedio Final de Titulación' end  "& vbCrLf &_
					  " from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr) as concepto_final, "& vbCrLf &_
					  " (select top 1 case isnull(promedio_final,0)  when  0 then '' else ' :    ' + cast(promedio_final as varchar) end  "& vbCrLf &_
					  " from detalles_titulacion pn where pn.pers_ncorr=a.pers_ncorr) as nota_final, "& vbCrLf &_
					  " protic.ano_ingreso_plan(b.pers_ncorr, b.plan_ccod) as ano_ingreso_plan, "& vbCrLf &_
					  " f.sede_secret, f.sede_tregistr, gg.desc_periodo, gg.peri_ccod, case gg.peri_ccod when 'N' then 'N' else 'S' end as por_periodo, 'CERTIFICADO' as titulo, protic.initcap(f.sede_tdesc) as sede,case c.jorn_ccod when 1 then 'DIURNO' when '2' then 'VESPERTINO' end as jornada, "

if peri_ccod <> "" and peri_ccod <> "1" then 
	if carrera <> "" then
		consulta_encabezado = consulta_encabezado &  "     protic.es_alumno_nueva_version(" & pers_nrut & "," & peri_ccod & ",'" & carrera & "',1) as CARRERA, "& vbCrLf &_
		                      "     protic.es_alumno_nueva_version(" & pers_nrut & "," & peri_ccod & ",'" & carrera & "',2) as DUAS_TDESC, "
	else
		consulta_encabezado = consulta_encabezado &  "     protic.es_alumno_nueva_version(" & pers_nrut & "," & peri_ccod & ",'0',1) as CARRERA, "& vbCrLf &_
		                      "     protic.es_alumno_nueva_version(" & pers_nrut & "," & peri_ccod & ",'0',2) as DUAS_TDESC, "
	end if
else
	if carrera <> "" then
		consulta_encabezado = consulta_encabezado &  "     protic.es_alumno_nueva_version(" & pers_nrut & ",206,'" & carrera & "',1) as CARRERA, "& vbCrLf &_
		                      "     protic.es_alumno_nueva_version(" & pers_nrut & ",206,'" & carrera & "',2) as DUAS_TDESC, "
	else
	   
		consulta_encabezado = consulta_encabezado &  "     protic.es_alumno_nueva_version(" & pers_nrut & ",206,'0',1) as CARRERA, "& vbCrLf &_
		                      "     protic.es_alumno_nueva_version(" & pers_nrut & ",206,'0',2) as DUAS_TDESC, "
	end if
end if 

consulta_encabezado =  consulta_encabezado &  " case '" & tdes_ccod & "' when '' then ', para los fines que estime conveniente.' "& vbCrLf &_
					   " when '3' then ', para los fines que estime conveniente.' "& vbCrLf &_
					   " when '1' then ',  a petición del (la) interesado(a) para solicitar ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
					   " when '4' then ',  a petición del (la) interesado(a) para solicitar ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
					   " when '5' then ',  a petición del (la) interesado(a) para solicitar ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
					   " when '9' then ',  a petición del (la) interesado(a) para solicitar ' + protic.initcap(g.tdes_tdesc) + '.'  "& vbCrLf &_
					   " when '10' then ',  a petición del (la) interesado(a) para solicitar ' + protic.initcap(g.tdes_tdesc) + '.'  "& vbCrLf &_
					   " when '11' then ',  a petición del (la) interesado(a) para solicitar ' + protic.initcap(g.tdes_tdesc) + '.'  "& vbCrLf &_
					   " when '12' then ',  a petición del (la) interesado(a) para solicitar ' + protic.initcap(g.tdes_tdesc) + '.'  "& vbCrLf &_
					   " when '13' then ',  a petición del (la) interesado(a) para solicitar ' + protic.initcap(g.tdes_tdesc) + '.'  "& vbCrLf &_
					   " when '6' then ',  a petición del (la) interesado(a) para ser presentado en ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
					   " when '7' then ',  a petición del (la) interesado(a) para ser presentado en ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
					   " when '8' then ',  a petición del (la) interesado(a) para ser presentado en ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
					   " when '14' then ',  a petición del (la) interesado(a) para ser presentado en ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
					   " when '18' then ',  a petición del (la) interesado(a) para ser presentado en ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
					   " when '16' then ',  a petición del (la) interesado(a) para ser presentado en ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
					   " when '15' then ',  a petición del (la) interesado(a) para ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
					   " when '17' then ',  a petición del (la) interesado(a) para ' + protic.initcap(g.tdes_tdesc) + '.' "& vbCrLf &_
					   " when '2' then ',  a petición del (la) interesado(a) para ser presentado en Cantón de Reclutamiento.' "& vbCrLf &_
					   " end as tdes_tdesc "& vbCrLf &_
					   " from personas a, alumnos b, ofertas_academicas c, especialidades d,carreras car, "& vbCrLf &_
					   " sedes f, tipos_descripciones g,planes_estudio pl,  "& vbCrLf &_
					   " (select 'N' as peri_ccod, '' as desc_periodo  "& vbCrLf &_
					   " union  "
					    if ((peri_ccod <> "" ) and  (peri_ccod <> "1")) then
							consulta_encabezado = consulta_encabezado &  " 	  select cast(peri_ccod as varchar) as peri_ccod, cast(anos_ccod as varchar)+ ' - ' + cast(plec_ccod as varchar) from periodos_academicos where cast(peri_ccod as varchar)= '" & peri_ccod & "') gg "
						else
							consulta_encabezado = consulta_encabezado &  " 	  select cast(peri_ccod as varchar) as peri_ccod, cast(anos_ccod as varchar)+ ' - ' + cast(plec_ccod as varchar) from periodos_academicos where cast(peri_ccod as varchar)= '206') gg "
						end if
						consulta_encabezado = consulta_encabezado &  " where a.pers_ncorr = b.pers_ncorr "& vbCrLf &_
											  "   and b.ofer_ncorr = c.ofer_ncorr "& vbCrLf &_
											  "   and c.espe_ccod = d.espe_ccod and b.plan_ccod = pl.plan_ccod "& vbCrLf &_
											  "   and d.carr_ccod = car.carr_ccod "& vbCrLf &_
											  "   and b.emat_ccod <> 9 "
						if (carrera <> "") then
							consulta_encabezado = consulta_encabezado & " and cast(pl.plan_ccod as varchar)='" & carrera & "'"
						else
							consulta_encabezado = consulta_encabezado & " and b.ofer_ncorr = protic.ultima_oferta_matriculado(a.pers_ncorr)"
						end if
						if ((peri_ccod <> "" ) and (peri_ccod <> "1")) then
							consulta_encabezado = consulta_encabezado &  "   and isnull('" & peri_ccod & "', 'N') = gg.peri_ccod "
						else
							consulta_encabezado = consulta_encabezado &  "   and isnull('206', 'N') = gg.peri_ccod "
						end if
			consulta_encabezado = consulta_encabezado &  "   and c.sede_ccod = f.sede_ccod "& vbCrLf &_
								  " and cast(g.tdes_ccod as varchar)= '" & tdes_ccod & "' "& vbCrLf &_
								  " and cast(a.pers_nrut as varchar)= '" & pers_nrut & "' "& vbCrLf &_
								  " order by b.alum_fmatricula desc "

set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "tabla_vacia.xml", "tabla"
f_encabezado.Inicializar conexion


f_encabezado.Consultar consulta_encabezado
f_encabezado.Siguiente
'response.Write("<pre>"&consulta_encabezado&"</pre>")		


consulta_detalle = " select cast(horas as numeric(4)) as T,a.asig_ccod,b.asig_tdesc,nota_final as carg_nnota_final,anos_ccod as peri_ccod,"& vbCrLf &_
				   " anos_ccod,plec_ccod,c.sitf_ccod,c.sitf_baprueba,nota_final,anos_ccod as ano_cursado,plec_ccod as periodo, "& vbCrLf &_
                   " case isnull(cast(nota_final as varchar),'-') when '-' then case c.sitf_ccod when 'A' then 'A' when 'C' then 'C' when 'R' then 'R' when 'SP' then 'SP' when 'H' then 'H' when 'S' then 'S' when 'RC' then 'RC' when 'RS' then 'RS' end  else '' end as estado, "& vbCrLf &_
				   " SUBSTRING(LTRIM(RTRIM(cast(cast(nota_final AS decimal(2,1))AS varchar))), 1, CHARINDEX('.', LTRIM(RTRIM(cast(cast(nota_final AS decimal(2,1)) AS varchar)))) - 1) AS p1, "& vbCrLf &_
			       " SUBSTRING(LTRIM(RTRIM(cast(cast(nota_final AS decimal(2,1))AS varchar))), CHARINDEX('.', LTRIM(RTRIM(cast(cast(nota_final AS decimal(2,1))AS varchar)))) + 1, 1) AS p2, "& vbCrLf &_
			       " cantidad "& vbCrLf &_
			       " from concentracion_notas a, asignaturas b,situaciones_finales c "& vbCrLf &_
			       " where a.asig_ccod=b.asig_ccod "& vbCrLf &_
			       " and case a.sitf_ccod when 'HM' then 'H' else a.sitf_ccod end = c.sitf_ccod "& vbCrLf &_
			       " and a.pers_ncorr in (select pers_ncorr from personas where cast(pers_nrut as varchar)='" + pers_nrut + "') "& vbCrLf &_
			       " order by peri_ccod asc,b.asig_tdesc asc  "

set f_detalle = new CFormulario
f_detalle.Carga_Parametros "tabla_vacia.xml", "tabla"
f_detalle.Inicializar conexion			


f_detalle.Consultar consulta_detalle
'response.Write("<pre>"&consulta_detalle&"</pre>")
cantidad_notas = f_detalle.nroFilas
'response.Write(cantidad_notas)
consulta_fecha = " select 'Santiago, '+cast(datepart(day,getdate()) as varchar)+ ' de ' + protic.initcap(mes_tdesc) "&_
				 " + ' de ' + cast(datepart(year,getdate()) as varchar) as fecha"&_
				 " from meses "&_
				 " where mes_ccod = datepart(month,getdate()) "

fecha_impresion = conexion.consultaUno(consulta_fecha)
					 
%>
<html>
<head>
<title>Concentración Web</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_inicio.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript1.2" src="tabla.js"></script>
<style>
@media print{ .noprint {visibility:hidden; }}
</style>
<style type="text/css">
<!--
td {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 8px;
}
h1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 16px;
}
-->
</style>
</head>
<body bgcolor="#ffffff">
<table width="672" border="0" cellspacing="0" cellpadding="0">
  <TR>
	  <TD align="left">
	  		<table width="672">
				<tr valign="middle">
					<td width="54" height="56" align="right"><div align="right"><img src="imagenes_certificado/logo_upa.jpg" width="52" height="56"></div></td>
					<td width="214" height="56"><div align="left"><img src="imagenes_certificado/membrete_upa.jpg" width="162" height="56"></div></td>
					<td width="404" align="center">
					    <div align="center" class="noprint">
						<button name="Button" value="Imprimir Horario" onClick="print()" >
										Imprimir Certificado
						</button>
						</div>
					</td>
				</tr>
			</table>
	  </TD>
  </TR>
  <tr><td align="left" width="672">
  			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="33" height="33" align="right"><img src="imagenes_certificado/izquierda_sup.jpg" width="33" height="33"></td>
					<td width="550"><img src="imagenes_certificado/superior.jpg" width="600" height="33"></td>
					<td width="39" height="33" align="left"><img src="imagenes_certificado/derecha_sup.jpg" width="35" height="33"></td>
				</tr>
				<tr valign="top">
					<td width="33" align="right"><img src="imagenes_certificado/izquierda_lado.jpg" width="33" height="735"></td>
				  <td bgcolor="#FFFFFF" width="600">
						<table width="100%" cellpadding="0" cellspacing="0">
						  <tr><td width="100%" align="center"><font size="4" face="Times New Roman, Times, serif"><strong>CERTIFICADO</strong></font></td></tr>
						  <tr><td width="100%"><font size="2" face="Times New Roman, Times, serif">2</font></td></tr>
						  <tr><td width="100%">
						  		  <table width="100%" cellpadding="0" cellspacing="0">
								  	<tr>
										<td width="80%" align="right"><font size="2" face="Times New Roman, Times, serif">R.u.t.</font></td>
										<td width="1%" align="center"><font size="2" face="Times New Roman, Times, serif">:</font></td>
										<td width="19%" align="left"><font size="2" face="Times New Roman, Times, serif"><%=f_encabezado.obtenerValor("rut")%></font></td>
									</tr>
									<tr>
										<td width="80%" align="right"><font size="2" face="Times New Roman, Times, serif">Horario</font></td>
										<td width="1%" align="center"><font size="2" face="Times New Roman, Times, serif">:</font></td>
										<td width="19%" align="left"><font size="2" face="Times New Roman, Times, serif"><%=f_encabezado.obtenerValor("sede")%></font></td>
									</tr>
									<tr>
										<td width="80%" align="right"><font size="2" face="Times New Roman, Times, serif">Sede</font></td>
										<td width="1%" align="center"><font size="2" face="Times New Roman, Times, serif">:</font></td>
										<td width="19%" align="left"><font size="2" face="Times New Roman, Times, serif"><%=f_encabezado.obtenerValor("jornada")%></font></td>
									</tr>
								  </table>
						      </td>
						  </tr>
						  <tr><td width="100%"><font size="2" face="Times New Roman, Times, serif">6</font></td></tr>
						  <tr><td width="100%"><font size="2" face="Times New Roman, Times, serif">El jefe de Títulos y Grados que suscribe certifica que el (la) Sr.(ta).</font></td></tr>
						  <tr><td width="100%"><font size="2" face="Times New Roman, Times, serif"><%=f_encabezado.obtenerValor("nombre")%></font></td></tr>
						  <tr><td width="100%"><font size="2" face="Times New Roman, Times, serif"><%=f_encabezado.obtenerValor("carrera")%></font></td></tr>
						  <tr><td width="100%"><font size="2" face="Times New Roman, Times, serif"><%=f_encabezado.obtenerValor("duas_tdesc")%> calificaciones de acuerdo a la escala de uno a siete, siendo cuatro el m&iacute;nimo de aprobación:</font></td></tr>
						  <tr><td width="100%"><font size="2" face="Times New Roman, Times, serif">13</font></td></tr>
						  <tr valign="top">
						      <td width="100%">
						      	  <table width="100%" border="1" cellpadding="0" cellspacing="0">
								  	<tr valign="top">
										<td width="15%" align="center"><font size="2" face="Times New Roman, Times, serif">Código(s)</font></td>
										<td width="40%" align="center"><font size="2" face="Times New Roman, Times, serif">Asignatura(s)</font></td>
										<td width="15%" align="center"><font size="2" face="Times New Roman, Times, serif">Calificacion(es)<br>Final(es)</font></td>
										<td width="10%" align="center"><font size="2" face="Times New Roman, Times, serif">Periodo</font></td>
										<td width="10%" align="center"><font size="2" face="Times New Roman, Times, serif">Carácter</font></td>
										<td width="10%" align="center"><font size="2" face="Times New Roman, Times, serif">N°Horas</font></td>
									</tr>
								  </table>
							  </td>
						  </tr>
						  <%if cantidad_notas + 4 <= 22 then
						    contador = 0
						    while f_detalle.siguiente
								contador = contador + 1
							    asig_ccod = f_detalle.obtenerValor("asig_ccod")
								asig_tdesc = f_detalle.obtenerValor("asig_tdesc")
								nota_final = f_detalle.obtenerValor("carg_nnota_final")
								sitf_ccod = f_detalle.obtenerValor("sitf_ccod")
								periodo = f_detalle.obtenerValor("anos_ccod")
								caracter = f_detalle.obtenerValor("plec_ccod")
								horas = f_detalle.obtenerValor("T") %>
								<tr valign="top">
								  <td width="100%">
									  <table width="100%" cellpadding="0" cellspacing="0">
										<tr valign="top">
											<td width="15%" align="left"><font size="2" face="Times New Roman, Times, serif"><%=asig_ccod%></font></td>
											<td width="40%" align="left"><font size="2" face="Times New Roman, Times, serif"><%=asig_tdesc%></font></td>
											<%if nota_final <> "" then %>
												<td width="15%" align="center"><font size="2" face="Times New Roman, Times, serif"><%=nota_final%></font></td>
											<%else%>
												<td width="15%" align="center"><font size="2" face="Times New Roman, Times, serif"><%=sitf_ccod%></font></td>
											<%end if%>
											<td width="10%" align="center"><font size="2" face="Times New Roman, Times, serif"><%=periodo%></font></td>
											<td width="10%" align="center"><font size="2" face="Times New Roman, Times, serif"><%=caracter%></font></td>
											<td width="10%" align="center"><font size="2" face="Times New Roman, Times, serif"><%=horas%></font></td>
										</tr>
									  </table>
								  </td>
							  </tr>
							<%wend%>
							<tr><td width="100%"><font size="2" face="Times New Roman, Times, serif"><hr></font></td></tr>
							<tr><td width="100%"><font size="2" face="Times New Roman, Times, serif">Promedio General</font></td></tr>
							<tr><td width="100%"><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></td></tr>
							<tr><td width="100%" align="left"><font size="2" face="Times New Roman, Times, serif">Se extiende el presente certificado<%=f_encabezado.obtenerValor("tdes_tdesc")%></font></td></tr>
							
						  <%contador = contador + 4
						  end if %>
						  <%while contador <= 24%>
						  	<tr><td width="100%"><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></td></tr>
						   <%
						    contador = contador + 1
						    wend%>	
						  <tr valign="top"><td width="100%" align="center">
						  	  <table width="90%" cellpadding="0" cellspacing="0">
							  	<tr>
									<td width="33%">&nbsp;</td>
									<td width="33%">&nbsp;</td>
									<td width="33%" align="center"><font size="2" face="Times New Roman, Times, serif">VICTOR MENDOZA LOBOS</font></td>
								</tr>
								<tr>
									<td width="33%">&nbsp;</td>
									<td width="33%">&nbsp;</td>
									<td width="33%" align="center"><font size="2" face="Times New Roman, Times, serif">Jefe de Títulos y Grados</font></td>
								</tr>
							  </table>
						  </td></tr>
						  <tr><td width="100%"><font size="2" face="Times New Roman, Times, serif">53</font></td></tr>
						  <tr><td width="100%" align="center">
						  		<table width="80%" border="0">
									<tr>
										<td width="2%"><font size="1" face="Times New Roman, Times, serif" color="#666666">A</font></td>
										<td width="1%"><font size="1" face="Times New Roman, Times, serif" color="#666666">:</font></td>
										<td width="47%"><font size="1" face="Times New Roman, Times, serif" color="#666666">Asignatura Aprobada</font></td>
										<td width="2%"><font size="1" face="Times New Roman, Times, serif" color="#666666">H</font></td>
										<td width="1%"><font size="1" face="Times New Roman, Times, serif" color="#666666">:</font></td>
										<td width="47%"><font size="1" face="Times New Roman, Times, serif" color="#666666">Asignatura Aprobada por Homologación</font></td>
									</tr>
									<tr>
										<td width="2%"><font size="1" face="Times New Roman, Times, serif" color="#666666">C</font></td>
										<td width="1%"><font size="1" face="Times New Roman, Times, serif" color="#666666">:</font></td>
										<td width="47%"><font size="1" face="Times New Roman, Times, serif" color="#666666">Asignatura Aprobada por Convalidación</font></td>
										<td width="2%"><font size="1" face="Times New Roman, Times, serif" color="#666666">RC</font></td>
										<td width="1%"><font size="1" face="Times New Roman, Times, serif" color="#666666">:</font></td>
										<td width="47%"><font size="1" face="Times New Roman, Times, serif" color="#666666">Asignatura Reprobada por conocimientos relevantes</font></td>
									</tr>
									<tr>
										<td width="2%"><font size="1" face="Times New Roman, Times, serif" color="#666666">S</font></td>
										<td width="1%"><font size="1" face="Times New Roman, Times, serif" color="#666666">:</font></td>
										<td width="47%"><font size="1" face="Times New Roman, Times, serif" color="#666666">Asignatura Aprobada por Suficiencia</font></td>
										<td width="2%"><font size="1" face="Times New Roman, Times, serif" color="#666666">RS</font></td>
										<td width="1%"><font size="1" face="Times New Roman, Times, serif" color="#666666">:</font></td>
										<td width="47%"><font size="1" face="Times New Roman, Times, serif" color="#666666">Asignatura Reprobada por Suficiencia</font></td>
									</tr>
									<tr>
										<td width="2%"><font size="1" face="Times New Roman, Times, serif" color="#666666">R</font></td>
										<td width="1%"><font size="1" face="Times New Roman, Times, serif" color="#666666">:</font></td>
										<td width="47%"><font size="1" face="Times New Roman, Times, serif" color="#666666">Asignatura Reprobada</font></td>
										<td width="2%"><font size="1" face="Times New Roman, Times, serif">&nbsp;</font></td>
										<td width="1%"><font size="1" face="Times New Roman, Times, serif">&nbsp;</font></td>
										<td width="47%"><font size="1" face="Times New Roman, Times, serif">&nbsp;</font></td>
									</tr>
								</table>
						  </td></tr>
						  <tr><td width="100%"><font size="1" face="Times New Roman, Times, serif"><%=fecha_impresion%></font></td></tr>
						</table>
					</td>
					<td width="39" align="left"><img src="imagenes_certificado/derecha_lado.jpg" width="35" height="735"></td>
				</tr>
				<tr valign="top">
					<td width="33" height="36" align="right"><img src="imagenes_certificado/izquierda_inf.jpg" width="33" height="36"></td>
					<td width="550" background="imagenes_certificado/inferior.jpg" height="36"><font size="1" face="Times New Roman, Times, serif">Si detecta algún antecedente que no corresponda, comuniquese con la oficina de títulos y grados.</font></td>
					<td width="39" height="36" align="left"><img src="imagenes_certificado/derecha_inf.jpg" width="35" height="36"></td>
				</tr>
				<TR>
					<TD colspan="3" align="center"><font size="2" face="Times New Roman, Times, serif">Página 1 de 1</font></TD>
				</TR>
				<TR>
					<TD colspan="3"><hr></TD>
				</TR>
				<TR>
					<TD colspan="3" align="center"><font size="1">Casa Central: Av. Las Condes 11.121 Fono:366 5300 - Sede Providencia: Av. Ricardo Lyon 227 Fono 378 9259</font></TD>
				</TR>
				<TR>
					<TD colspan="3" align="center"><font size="1">Sede Baquedano Av. Ramón Carnicer 65 Fono 634 3393 - Sede Melipilla Andres Bello 0383-A Fono 831 7991</font></TD>
				</TR>
			</table>
      </td>
  </tr>
  
</body>
</html>

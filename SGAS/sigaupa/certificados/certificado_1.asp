<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
pers_nrut = request.QueryString("pers_nrut")
carr_ccod = request.QueryString("carr_ccod")
tdes_ccod = request.QueryString("tdes_ccod")
comentario = request.QueryString("comentario")
'response.Write(comentario)
set conexion = new cConexion
set negocio = new cnegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

peri_ccod = negocio.obtenerPeriodoAcademico("Postulacion")
'Se agregará el año 2013 fijo para certificación asi se compara si es o fue alumno
anio_activo = "2013"

if esVacio(tdes_ccod) or tdes_ccod = "3" then
	resto_mensaje= ", para los fines que estime conveniente."
elseif not esVacio(tdes_ccod) and (tdes_ccod = "5" or tdes_ccod = "1" or tdes_ccod = "4" or tdes_ccod = "9" or tdes_ccod = "10" or tdes_ccod = "11" or tdes_ccod = "12" or tdes_ccod = "13" or tdes_ccod = "19") then
	motivo = conexion.consultaUno("select tdes_tdesc from tipos_descripciones where cast(tdes_ccod as varchar)='"&tdes_ccod&"'")
	resto_mensaje= " a petici&oacute;n del (la) interesado(a) para solicitar "&motivo&"."
elseif not esVacio(tdes_ccod) and (tdes_ccod = "6" or tdes_ccod = "7" or tdes_ccod = "8" or tdes_ccod = "14" or tdes_ccod = "16" or tdes_ccod = "18") then
	motivo = conexion.consultaUno("select tdes_tdesc from tipos_descripciones where cast(tdes_ccod as varchar)='"&tdes_ccod&"'")
	resto_mensaje= " a petici&oacute;n del (la) interesado(a) para ser presentado en "&motivo&"."
elseif not esVacio(tdes_ccod) and tdes_ccod = "2" then
	resto_mensaje= " a petici&oacute;n del (la) interesado(a) para ser presentado en Cant&oacute;n de Reclutamiento."
elseif not esVacio(tdes_ccod) and (tdes_ccod = "15" or tdes_ccod = "17")then
	motivo = conexion.consultaUno("select tdes_tdesc from tipos_descripciones where cast(tdes_ccod as varchar)='"&tdes_ccod&"'")
	resto_mensaje= " a petici&oacute;n del (la) interesado(a) para "&motivo&"."	
end if

if esVacio(carr_ccod) then
consulta_carrera= " select top 1 d.carr_ccod from personas a, alumnos b, ofertas_academicas c, especialidades d " & vbCrLf &_
		  " where cast(a.pers_nrut as varchar)='"&pers_nrut&"' " & vbCrLf &_
		  " and a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
		  " and b.ofer_ncorr=c.ofer_ncorr " & vbCrLf &_
		  " and c.espe_ccod=d.espe_ccod  and emat_ccod not in (6,9,11)" & vbCrLf &_
		  " order by peri_ccod desc"
carr_ccod = conexion.consultaUno(consulta_carrera)
end if

'response.Write(carr_ccod)
consulta= " select top 1 e.jorn_tdesc from personas a, alumnos b, ofertas_academicas c, especialidades d,jornadas e " & vbCrLf &_
		  " where cast(a.pers_nrut as varchar)='"&pers_nrut&"' " & vbCrLf &_
		  " and a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
		  " and b.ofer_ncorr=c.ofer_ncorr " & vbCrLf &_
		  " and c.espe_ccod=d.espe_ccod " & vbCrLf &_
		  " and c.jorn_ccod=e.jorn_ccod " & vbCrLf &_
		  " and cast(d.carr_ccod as varchar)='"&carr_ccod&"'  and emat_ccod not in (6,9,11) " & vbCrLf &_
		  " order by peri_ccod desc"


consulta_sede= " select top 1 e.sede_tdesc from personas a, alumnos b, ofertas_academicas c, especialidades d,sedes e " & vbCrLf &_
		  " where cast(a.pers_nrut as varchar)='"&pers_nrut&"' " & vbCrLf &_
		  " and a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
		  " and b.ofer_ncorr=c.ofer_ncorr " & vbCrLf &_
		  " and c.espe_ccod=d.espe_ccod " & vbCrLf &_
		  " and c.sede_ccod=e.sede_ccod " & vbCrLf &_
		  " and cast(d.carr_ccod as varchar)='"&carr_ccod&"'   and emat_ccod not in (6,9,11) " & vbCrLf &_
		  " order by peri_ccod desc"

nombre = conexion.consultaUno("select cast(pers_tnombre as varchar) + ' ' + cast(pers_tape_paterno as varchar) + ' ' + cast(pers_tape_materno as varchar) from personas where cast(pers_nrut as varchar)='" & pers_nrut & "' ")
rut = conexion.consultaUno("select protic.format_rut('"&pers_nrut&"')")
carrera = conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar)='" & carr_ccod & "' ")
jornada = conexion.consultaUno(consulta)
nombre_sede = conexion.consultaUno(consulta_sede)
tcar_ccod = conexion.consultaUno("select tcar_ccod from carreras where cast(carr_ccod as varchar)='" & carr_ccod & "' ")

consulta_fecha = " select cast(datePart(day,getDate()) as varchar)+ ' de ' + " & vbCrLf &_
				 " case datePart(month,getDate()) when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' " & vbCrLf &_
				 " when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' " & vbCrLf &_
				 " when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' end + ' de ' +  " & vbCrLf &_
				 " cast(datePart(year,getDate()) as varchar) as fecha_01"
fecha_01 = conexion.consultaUno(consulta_fecha)
fecha_01 = "Santiago, "&fecha_01
'------------------------------------ configuramos mensaje de salida para el alumno de acuerdo a su estado---------------
pers_ncorr= conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")
'response.Write("pers_ncorr "&pers_ncorr&" carr_ccod "&carr_ccod)
consulta_ultimo_estado= " select top 1 emat_ccod from alumnos a, ofertas_academicas b, especialidades c " & vbCrLf &_
						" where a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
					    " and b.espe_ccod=c.espe_ccod " & vbCrLf &_
						" and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'  and emat_ccod not in (6,9,11) " & vbCrLf &_
						" and c.carr_ccod='"&carr_ccod&"' " & vbCrLf &_  
						" order by peri_ccod desc,a.audi_fmodificacion desc"
estado=	conexion.consultaUno(consulta_ultimo_estado)
'response.Write("<pre>"&consulta_ultimo_estado&"</pre>")
consulta_ultimo_periodo= " select top 1 peri_ccod from alumnos a, ofertas_academicas b, especialidades c " & vbCrLf &_
						 " where a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
					     " and b.espe_ccod=c.espe_ccod " & vbCrLf &_
						 " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'  and emat_ccod not in (6,9,11) " & vbCrLf &_
						 " and c.carr_ccod='"&carr_ccod&"' and isnull(a.alum_nmatricula,0) <> 7777" & vbCrLf &_  
						 " order by peri_ccod desc,a.audi_fmodificacion desc"
periodo_ultimo = conexion.consultaUno(consulta_ultimo_periodo)
anio_ultimo = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo_ultimo&"'")					
'response.Write(consulta_ultimo_periodo)
'-------------------------Debemos ver si el alumno tiene matricula para el periodo solicitado
consulta_matricula = "select count(*) from alumnos a, ofertas_Academicas b, especialidades c where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod = c.espe_ccod and cast(b.peri_ccod as varchar)='"&peri_ccod&"' and c.carr_ccod='"&carr_ccod&"' and a.emat_ccod = 1 "

tiene_matricula = conexion.consultaUno(consulta_matricula)
if cint(anio_ultimo) < cint(anio_activo) then
	tiene_matricula = "0"
end if

anos_ccod = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
'response.Write(consulta_matricula)
if tcar_ccod <> "2" then
	
	if estado = "8" then
		mensaje = "Es alumno(a) Titulado(a)"	
	else
		if estado= "2" or estado="3" or estado="5" or estado="6" or estado="9" or estado= "10" or tiene_matricula="0" then
			mensaje = "Fue Alumno(a)"
		else
			mensaje = "Es Alumno(a)"
		end if
	end if	
else
	if estado = "8" then
		mensaje = "Se encuetra Graduado(a) "	
    elseif estado = "4" then
		mensaje = "Es alumno(a) egresado(a) "	
	else
		if estado= "2" or estado="3" or estado="5" or estado="6" or estado="9" or estado= "10" or tiene_matricula="0" then
			mensaje = "Fue Alumno(a)"
		else
			mensaje = "Es Alumno(a)"
		end if
	end if	

end if
'response.Write(mensaje)

detalle_estado= conexion.consultaUno("Select protic.initcap(emat_tdesc) from estados_matriculas where cast(emat_ccod as varchar)='"&estado&"'")
if estado = "1" or estado = "13" then
	mensaje = mensaje & " regular "
'else
'	mensaje = mensaje & detalle_estado & "(a)"
end if	

if tcar_ccod = "2" and estado = "8" then
	mensaje = mensaje & " de "
else
	mensaje = mensaje & " de la carrera "
end if	
'response.Write(mensaje)						 
%>
<html>
<head>
<title>Certificado alumno</title>
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
	  <TD colspan="3" align="left">
	  		<table width="100%">
				<tr valign="top">
					<td width="230 "align="center"><img src="imagenes_certificado/logo_upa_rojo_2011.png" width="150" height="50"></td>
					<td>&nbsp;</td>
				</tr>
				<tr valign="top">
					<td width="230" align="center"><font size="2">VICERRECTORÍA ACADÉMICA</font><br><font size="1">REGISTRO CURRICULAR</font></td>
					<td align="center"><div align="center" class="noprint">
										<button name="Button" value="Imprimir Horario" onClick="print()" >
										Imprimir Certificado
										</button>
										</div></td>
				</tr>
			</table>
	  </TD>
  </TR>
  <tr><td colspan="3" align="center">
  			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="33" height="33" align="right"><img src="imagenes_certificado/izquierda_sup.jpg" width="33" height="33"></td>
					<td width="550"><img src="imagenes_certificado/superior.jpg" width="600" height="33"></td>
					<td width="39" height="33" align="left"><img src="imagenes_certificado/derecha_sup.jpg" width="35" height="33"></td>
				</tr>
				<tr>
					<td width="33" align="right"><img src="imagenes_certificado/izquierda_lado.jpg" width="33" height="600"></td>
					<td bgcolor="#FFFFFF" width="550">
						<table width="90%" cellpadding="0" cellspacing="0">
						  <tr><td colspan="3">&nbsp;</td></tr>
						  <tr> 
							<td colspan="3"><div align="center"><font size="4"><strong>CERTIFICADO DE ALUMNO</strong></font></div></td>
						  </tr>
						  <tr><td colspan="3">&nbsp;</td></tr>
						  <tr><td colspan="3">&nbsp;</td></tr>
						  <tr><td colspan="3">&nbsp;</td></tr>
						  <tr><td colspan="3">&nbsp;</td></tr>
						  <tr><td colspan="3"><div align="left"><font size="2"><strong>La Universidad del Pac&iacute;fico :</strong></font></div></td></tr>
						  <tr><td colspan="3">&nbsp;</td></tr>
						  <tr><td colspan="3">&nbsp;</td></tr>
						  <tr><td colspan="3">&nbsp;</td></tr>
						  <tr>
							  <td width="50%"><div align="left"><font size="2">Certifica que el(la) Sr.(ita).</font></div></td>
							  <td width="1%"><div align="center"><font size="2">:</font></div></td>
							  <td width="49%"><div align="left"><font size="2"><%=nombre%></font></div></td>	
						  </tr>
						  <tr><td colspan="3">&nbsp;</td></tr>
						  <tr><td colspan="3">&nbsp;</td></tr>
						  <tr>
							  <td width="50%"><div align="left"><font size="2">R.u.t.</font></div></td>
							  <td width="1%"><div align="center"><font size="2">:</font></div></td>
							  <td width="49%"><div align="left"><font size="2"><%=rut%></font></div></td>	
						  </tr>
						  <tr><td colspan="3">&nbsp;</td></tr>
						  <tr><td colspan="3">&nbsp;</td></tr>
						  <tr>
							  <td width="50%"><div align="left"><font size="2"><%=mensaje%></font></div></td>
							  <td width="1%"><div align="center"><font size="2">:</font></div></td>
							  <td width="49%"><div align="left"><font size="2"><%=carrera%></font></div></td>	
						  </tr>
						  <tr><td colspan="3">&nbsp;</td></tr>
						  <tr><td colspan="3">&nbsp;</td></tr>
						  <tr>
							  <td width="50%"><div align="left"><font size="2">Período Académico</font></div></td>
							  <td width="1%"><div align="center"><font size="2">:</font></div></td>
							  <td width="49%"><div align="left"><font size="2"><%=anio_ultimo%></font></div></td>	
						  </tr>
						  <tr><td colspan="3">&nbsp;</td></tr>
						  <tr><td colspan="3">&nbsp;</td></tr>
						  <tr>
							  <td width="50%"><div align="left"><font size="2">Jornada</font></div></td>
							  <td width="1%"><div align="center"><font size="2">:</font></div></td>
							  <td width="49%"><div align="left"><font size="2"><%=jornada%></font></div></td>	
						  </tr>
						  <tr><td colspan="3">&nbsp;</td></tr>
						  <tr><td colspan="3">&nbsp;</td></tr>
						   <tr>
							  <td width="50%"><div align="left"><font size="2">Sede</font></div></td>
							  <td width="1%"><div align="center"><font size="2">:</font></div></td>
							  <td width="49%"><div align="left"><font size="2"><%=nombre_sede%></font></div></td>	
						  </tr>
						  <tr><td colspan="3">&nbsp;</td></tr>
						  <tr><td colspan="3">&nbsp;</td></tr>
						  <tr><td colspan="3"><div align="left"><font size="2">Se extiende el presente certificado<%=resto_mensaje%></font></div></td></tr>
						  <tr><td colspan="3">&nbsp;</td></tr>
						  <%if comentario <> "" then %>
						  <tr><td colspan="3"><div align="left"><font size="2"><strong>Observaciones: </strong><%=comentario%></font></div></td></tr>
						  <%end if%>
						</table>
						<br>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
						  <tr> 
							<td width="34%" align="center">&nbsp;</td>
							<td width="16%" align="center">&nbsp;</td>
							<td width="50%" align="center">&nbsp;</td>
						  </tr>
						   <tr> 
							<td width="34%" align="center">&nbsp;</td>
							<td width="16%" align="center">&nbsp;</td>
							<td width="50%" align="center">&nbsp;</td>
						  </tr>
						  <tr> 
							<td width="34%" align="center">&nbsp;</td>
							<td width="16%" align="center">&nbsp;</td>
							<td width="50%" align="center">&nbsp;</td>
						  </tr>
						  <tr> 
							<td width="34%" align="center">&nbsp;</td>
							<td width="16%" align="center">&nbsp;</td>
							<td width="50%" align="center">&nbsp;</td>
						  </tr>
						  <tr> 
							<td width="34%" align="center">&nbsp;</td>
							<td width="16%" align="center">&nbsp;</td>
							<td width="50%" align="center">&nbsp;</td>
						  </tr>
						  <tr> 
							<td width="34%" align="center">&nbsp;</td>
							<td width="16%" align="center">&nbsp;</td>
							<td width="50%" align="center">&nbsp;</td>
						  </tr>
						   <tr> 
							<td width="34%" align="center">&nbsp;</td>
							<td width="16%" align="center">&nbsp;</td>
							<td width="50%" align="center">&nbsp;</td>
						  </tr>
						  <tr> 
							<td width="34%" align="center">&nbsp;</td>
							<td width="16%" align="center">&nbsp;</td>
							<td width="50%" align="center">&nbsp;</td>
						  </tr>
						  <tr> 
							<td width="34%" align="center">&nbsp;</td>
							<td width="16%" align="center">&nbsp;</td>
							<td width="50%" align="center">&nbsp;</td>
						  </tr>
						  <tr> 
							<td width="34%" align="center">&nbsp;</td>
							<td width="16%" align="center">&nbsp;</td>
							<td width="50%" align="center">&nbsp;</td>
						  </tr>
						  <tr> 
							<td width="34%" align="center">&nbsp;</td>
							<td width="16%" align="center">&nbsp;</td>
							<td width="50%" align="center">&nbsp;</td>
						  </tr>
							<tr> 
							<td width="34%" align="center">&nbsp;</td>
							<td width="16%" align="center">&nbsp;</td>
							<!--<td width="50%" align="center"><font size="2"><strong>ELENA ORTUZAR MU&Ntilde;OZ</strong></font></td>-->
							<td width="50%" align="center"><font size="2"><strong>MARÍA TERESA MERINO GAMÉ</strong></font></td>
						  </tr>
							<tr> 
							<td width="34%" align="center">&nbsp;</td>
							<td width="16%" align="center">&nbsp;</td>
							<!--<td width="50%" align="center"><font size="2"><strong>Secretaria General</strong></font></td>-->
							<td width="50%" align="center"><font size="2"><strong>JEFE REGISTRO CURRICULAR</strong></font></td>
						  </tr>
							<tr> 
							<td width="34%" align="center">&nbsp;</td>
							<td width="16%" align="center">&nbsp;</td>
							<td width="50%" align="center">&nbsp;</td>
						  </tr>
						  <tr> 
							<td width="34%" align="left"><font color="#000000" face="Arial, Helvetica, sans-serif" size="2"><%=fecha_01%></font></td>
							<td width="16%" align="center">&nbsp;</td>
							<td width="50%" align="center"><font color="#000000" face="Arial, Helvetica, sans-serif" size="2">&nbsp;</font></td>
						  </tr>
						</table>
					</td>
					<td width="39" align="left"><img src="imagenes_certificado/derecha_lado.jpg" width="35" height="600"></td>
				</tr>
				<tr valign="top">
					<td width="33" height="36" align="right"><img src="imagenes_certificado/izquierda_inf.jpg" width="33" height="36"></td>
					<td width="550"><img src="imagenes_certificado/inferior.jpg" width="600" height="36"></td>
					<td width="39" height="36" align="left"><img src="imagenes_certificado/derecha_inf.jpg" width="35" height="36"></td>
				</tr>
				<TR>
					<TD colspan="3">&nbsp;</TD>
				</TR>
				<TR>
					<TD colspan="3"><hr></TD>
				</TR>
				<TR>
					
        <TD colspan="3" align="center"><font size="1">Sede Las Condes: Av. Las 
          Condes 11.121 Fono:2862 5315 - Sede Melipilla:  Av. José Massoud 533 Fono 2352 4900</font></TD>
				</TR>
				<!--<TR>
					<TD colspan="3" align="center"><font size="1">Campus Baquedano: Av. Ramón Carnicer 65 Fonos 352 6900--352 6901 </font></TD>
				</TR>-->
			</table>
      </td>
  </tr>
 </table> 
</body>
</html>

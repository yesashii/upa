<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
acon_ncorr = request.QueryString("acon_ncorr")

set conexion = new cConexion
set negocio = new cnegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

c_fecha = " select 'Santiago,&nbsp;' + case datepart(month,getDate() ) when 1 then 'enero' when 2 then 'febrero' when 3 then 'marzo' "&_
          " when 4 then 'abril' when 5 then 'mayo' when 6 then 'junio' when 7 then 'julio' when 8 then 'agosto' when 9 then 'septiembre' "&_
		  " when 10 then 'octubre' when 11 then 'noviembre' when 12 then 'diciembre' end + case when datepart(day,getDate() ) < 10 then '&nbsp;0' else '&nbsp;' end + cast( datepart(day,getdate() ) as varchar) "&_
		  " + '&nbsp;de&nbsp;' + cast( datepart(year,getDate() ) as varchar) "
fecha_muestra = conexion.consultaUno(c_fecha)
c_anio = "select 'DRC. CA/'+cast( datepart(year,getDate() ) as varchar) "
anio_muestra = conexion.consultaUno(c_anio)

c_nombre = " select top 1 protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) from convalidaciones a, alumnos b, personas c "&_
           " where cast(a.acon_ncorr as varchar)='"&acon_ncorr&"' and a.matr_ncorr=b.matr_ncorr and b.pers_ncorr=c.pers_ncorr "
nombre_muestra = conexion.consultaUno(c_nombre)

c_direccion = " select top 1 protic.initCap( protic.obtener_direccion_letra(b.pers_ncorr,1,'CNPB') )  from convalidaciones a, alumnos b "&_
              " where cast(a.acon_ncorr as varchar)='"&acon_ncorr&"' and a.matr_ncorr=b.matr_ncorr"
direccion_muestra = conexion.consultaUno(c_direccion)

c_ciudad = " select top 1 protic.initCap( protic.obtener_direccion_letra(b.pers_ncorr,1,'C-C') )  from convalidaciones a, alumnos b "&_
           " where cast(a.acon_ncorr as varchar)='"&acon_ncorr&"' and a.matr_ncorr=b.matr_ncorr"
ciudad_muestra = conexion.consultaUno(c_ciudad)

c_carrera = " select top 1 protic.initCap( carr_tdesc )  from convalidaciones a, alumnos b, ofertas_academicas c, especialidades d, carreras e "&_
           " where cast(a.acon_ncorr as varchar)='"&acon_ncorr&"' and a.matr_ncorr=b.matr_ncorr and b.ofer_ncorr=c.ofer_ncorr and c.espe_ccod=d.espe_ccod and d.carr_ccod=e.carr_ccod "
carrera_muestra = conexion.consultaUno(c_carrera)


set f_convalidaciones = new CFormulario
f_convalidaciones.Carga_Parametros "tabla_vacia.xml", "tabla"
f_convalidaciones.Inicializar conexion
	
consulta = "SELECT b.asig_ccod, b.asig_tdesc, cast(anos_ccod as varchar)+'-'+cast(plec_ccod as varchar) as periodo, isnull(replace(cast(cast(a.conv_nnota as decimal(2,1)) as varchar),',','.'),'') as nota " &_
           " FROM convalidaciones a, asignaturas b, alumnos c, ofertas_academicas d, periodos_academicos e " &_
		   " WHERE a.asig_ccod = b.asig_ccod and a.matr_ncorr=c.matr_ncorr and c.ofer_ncorr=d.ofer_ncorr and d.peri_ccod=e.peri_ccod " &_
		   " AND cast(acon_ncorr as varchar)= '" & acon_ncorr & "' " &_
		   " ORDER BY b.asig_tdesc"
'response.Write("<pre>"&consulta&"</pre>")			   
f_convalidaciones.Consultar consulta

reso_ncorr  = conexion.consultaUno("Select reso_ncorr from actas_convalidacion where cast(acon_ncorr as varchar)='"&acon_ncorr&"'")
tres_ccod   = conexion.consultaUno("Select tres_ccod from resoluciones where cast(reso_ncorr as varchar)='"&reso_ncorr&"'")
c_carr_ccod = " select top 1 e.carr_ccod  from convalidaciones a, alumnos b, ofertas_academicas c, especialidades d, carreras e "&_
              " where cast(a.acon_ncorr as varchar)='"&acon_ncorr&"' and a.matr_ncorr=b.matr_ncorr and b.ofer_ncorr=c.ofer_ncorr and c.espe_ccod=d.espe_ccod and d.carr_ccod=e.carr_ccod "
carr_ccod   = conexion.consultaUno(c_carr_ccod)
tgra_ccod   = conexion.consultaUno("select tgra_ccod from carreras where carr_ccod='"&carr_ccod&"'")

%>
<html>
<head>
<title>Certificado Convalidación</title>
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
  <TR valign="top">
	  <TD colspan="3" align="left">
	  		<table width="100%">
				<tr valign="top">
					<td width="230" height="77" align="center"><img src="imagenes_certificado/logo_upa_rojo_2011.png" width="230" height="77"></td>
					<td width="442">&nbsp;</td>
				</tr>
				<tr valign="top">
					<td width="230" align="center"><font size="1">VICERRECTORÍA ACADÉMICA</font><br><font size="1">REGISTRO CURRICULAR</font></td>
					<td align="center"><div align="center" class="noprint">
										<button name="Button" value="Imprimir Horario" onClick="print()" >
										Imprimir Certificado
										</button>
										</div></td>
				</tr>
				<tr>
					<td colspan="2" align="right"><font size="1"><%=fecha_muestra%></font></td>
				</tr>
				<tr>
					<td colspan="2" align="right"><font size="1"><%=anio_muestra%></font></td>
				</tr>
				<tr>
					<td colspan="2" align="left"><font size="2">Señor(ita)</font></td>
				</tr>
				<tr>
					<td colspan="2" align="left"><font size="2"><%=nombre_muestra%></font></td>
				</tr>
				<tr>
					<td colspan="2" align="left"><font size="2"><%=direccion_muestra%></font></td>
				</tr>
				<tr>
					<td colspan="2" align="left"><font size="2"><%=ciudad_muestra%></font></td>
				</tr>
				<tr>
					<td colspan="2" align="right"><font size="1">&nbsp;</font></td>
				</tr>
				<tr>
					<td colspan="2" align="right"><font size="1">&nbsp;</font></td>
				</tr>
				<tr>
					<td colspan="2" align="right"><font size="1">&nbsp;</font></td>
				</tr>
				<tr>
					<td colspan="2" align="left"><font size="2">Estimado(a) Alumno(a):</font></td>
				</tr>
				<tr>
					<td colspan="2" align="left">
                       <font size="2">
                       <%if tres_ccod <> "3" and tgra_ccod <> "1" then%>
                       Por intermedio de la presente informo a Ud. que, la Dirección de Escuela de <%=carrera_muestra%>, ha aprobado la convalidación de las asignaturas que a continuación se detallan, las cuales se encuentran debidamente registradas.
                       <%elseif tres_ccod <> "3" and tgra_ccod = "1" then%>
                       Por intermedio de la presente informo a Ud. que, la Dirección de Formación Técnica, ha aprobado la convalidación de las asignaturas de la Carrera de <%=carrera_muestra%> que a continuación se detallan, las cuales se encuentran debidamente registradas.
                       <%elseif tres_ccod = "3" and tgra_ccod <> "1" then%>
                       Por intermedio de la presente informo a Ud. que, la Dirección de Escuela de <%=carrera_muestra%>, ha procedido a validar mediante la aprobación de exámenes de conocimientos relevantes las siguientes asignaturas, las cuales se encuentran debidamente registradas.
                       <%elseif tres_ccod = "3" and tgra_ccod = "1" then%>
                       Por intermedio de la presente informo a Ud. que, la Dirección de Formación Técnica, ha procedido a validar mediante la aprobación de exámenes de conocimientos relevantes las siguientes asignaturas de la Carrera de <%=carrera_muestra%>, las cuales se encuentran debidamente registradas.
                       <%end if%>
                       </font></td>
				</tr>
				<tr>
					<td colspan="2" align="left"><font size="1">&nbsp;</font></td>
				</tr>
				<tr>
					<td colspan="2" align="left">
						<table width="98%" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td align="left"><font size="1"><strong>COD. ASIGNATURA</strong></font></td>
								<td align="left"><font size="1"><strong>ASIGNATURA</strong></font></td>
								<td align="left"><font size="1"><strong>PERIODO</strong></font></td>
                                <%if tres_ccod = "3" then%>
                                <td align="left"><font size="1"><strong>NOTA</strong></font></td>
                                <%end if%>
							</tr>
							<%while f_convalidaciones.siguiente%>
							<tr>
								<td align="left"><font size="1"><%=f_convalidaciones.obtenerValor("asig_ccod")%></font></td>
								<td align="left"><font size="1"><%=f_convalidaciones.obtenerValor("asig_tdesc")%></font></td>
								<td align="left"><font size="1"><%=f_convalidaciones.obtenerValor("periodo")%></font></td>
                                <%if tres_ccod = "3" then%>
                                <td align="left"><font size="1"><%=f_convalidaciones.obtenerValor("nota")%></font></td>
                                <%end if%>
							</tr>
							<%wend%>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="right"><font size="1">&nbsp;</font></td>
				</tr>
				<tr>
					<td colspan="2" align="left"><font size="2">Sin otro particular le saluda atentamente,</font></td>
				</tr>
				<tr>
					<td colspan="2" align="right"><font size="1">&nbsp;</font></td>
				</tr>
				<tr>
					<td colspan="2" align="right">
						<table width="300" align="right" cellpadding="0" cellspacing="0">
							<tr>
								<td width="100%" height="132" align="center"><img width="261" height="132" src="imagenes_certificado/firma.bmp"></td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<font size="2">María Teresa Merino G.<br>Jefe Departamento de Registro Curricular<br>Universidad del Pacífico
</font>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
	  </TD>
  </TR>
 </table> 
</body>
</html>

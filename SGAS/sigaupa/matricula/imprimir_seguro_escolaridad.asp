<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
pers_ncorr = request.QueryString("pers_ncorr")
post_ncorr = request.QueryString("post_ncorr")

set conexion = new cConexion
set negocio = new cnegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

periodo = negocio.obtenerPeriodoAcademico("POSTULACION")
anio = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")

paterno_codeudor = conexion.consultaUno("select pers_tape_paterno from personas where cast(pers_ncorr as varchar)='" & pers_ncorr & "' ")
materno_codeudor = conexion.consultaUno("select pers_tape_materno from personas where cast(pers_ncorr as varchar)='" & pers_ncorr & "' ")
nombre_codeudor = conexion.consultaUno("select pers_tnombre from personas where cast(pers_ncorr as varchar)='" & pers_ncorr & "' ")
rut_codeudor = conexion.consultaUno("select cast(pers_nrut as varchar)+'-'+pers_xdv from personas where cast(pers_ncorr as varchar)='" & pers_ncorr & "' ")
nacimiento_codeudor = conexion.consultaUno("select protic.trunc(pers_fnacimiento) from personas where cast(pers_ncorr as varchar)='" & pers_ncorr & "' ")
fono_codeudor = conexion.consultaUno("select 'Fono: ' + ltrim(rtrim(isnull(pers_tfono,'--'))) + 'Celular: ' + ltrim(rtrim(isnull(pers_tcelular,'--'))) from personas where cast(pers_ncorr as varchar)='" & pers_ncorr & "' ")

if post_ncorr <> "" then
    codigo = conexion.consultaUno("select pers_ncorr from postulantes where cast(post_ncorr as varchar)='"&post_ncorr&"'")
	nombre_alumno = conexion.consultaUno("select pers_tape_paterno + ' ' + pers_tape_materno + ', ' + pers_tnombre from personas where cast(pers_ncorr as varchar)='"&codigo&"'")
	rut_alumno = conexion.consultaUno("select cast(pers_nrut as varchar) + '-' + pers_xdv from personas where cast(pers_ncorr as varchar)='"&codigo&"'")
	nacimiento_alumno = conexion.consultaUno("select isnull(protic.trunc(pers_fnacimiento),'--') from personas where cast(pers_ncorr as varchar)='"&codigo&"'")
	carrera_alumno = conexion.consultaUno("select c.sede_tdesc + ' - ' + protic.obtener_nombre_carrera(b.ofer_ncorr,'CJ') from postulantes a, ofertas_academicas  b, sedes c where cast(a.post_ncorr as varchar)='"&post_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr and  b.sede_ccod = c.sede_ccod")
end if

set lista_preexistencias = new CFormulario
lista_preexistencias.Carga_Parametros "tabla_vacia.xml", "tabla"
lista_preexistencias.Inicializar conexion
consulta_acceso =  " select b.pers_tnombre + ' ' + b.pers_tape_paterno + ' ' + b.pers_tape_materno as nombre,"& vbCrLf	&_
				   " c.enfe_tdesc + ' ' + isnull(a.esse_tdescripcion,'') as enfermedad, protic.trunc(a.esse_tfecha) as fecha "& vbCrLf	&_
				   " from enfermedades_solicitud_seguro a, personas b,enfermedades c "& vbCrLf	&_
				   " where a.pers_ncorr=b.pers_ncorr and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' "& vbCrLf	&_
			       " and cast(a.post_ncorr as varchar)='"&post_ncorr&"' "& vbCrLf	&_
				   " and a.enfe_ccod = c.enfe_ccod"

lista_preexistencias.Consultar consulta_acceso

dia_actual = conexion.consultaUno("select datepart(day,getDate())")
mes_actual = conexion.consultaUno("select datepart(month,getDate())")
anio_actual = conexion.consultaUno("select datepart(year,getDate())")				

grabado = conexion.consultaUno("select count(*) from solicitud_seguro_escolaridad a, postulantes b, periodos_academicos c where a.post_ncorr=b.post_ncorr and cast(b.pers_ncorr as varchar)='"&codigo&"' and b.peri_ccod=c.peri_ccod and cast(c.anos_ccod as varchar)='"&anio&"'")
grabado_con_cargo = conexion.consultaUno("select count(*) from solicitud_seguro_escolaridad a, postulantes b, periodos_academicos c where a.post_ncorr=b.post_ncorr and cast(b.pers_ncorr as varchar)='"&codigo&"' and b.peri_ccod=c.peri_ccod and cast(c.anos_ccod as varchar)='"&anio&"' and exists(Select 1 from compromisos cc where cc.post_ncorr=a.post_ncorr and cc.ofer_ncorr=a.ofer_ncorr and cc.ecom_ccod<> 3 and cc.tcom_ccod=26)")

if cint(grabado_con_cargo) > 0 then 
    'response.Write(grabado_con_cargo)
	valor_check= "N"
else
	if cint(grabado) > 0 then 
		valor_check = conexion.consultaUno("select no_deseo from solicitud_seguro_escolaridad a, postulantes b, periodos_academicos c where a.post_ncorr=b.post_ncorr and cast(b.pers_ncorr as varchar)='"&codigo&"' and b.peri_ccod=c.peri_ccod and cast(c.anos_ccod as varchar)='"&anio&"'")
	else
		valor_check = "N"	
	end if
end if
'valor_check = conexion.consultaUno("select no_deseo from solicitud_seguro_escolaridad a where cast(a.pers_ncorr_contratante as varchar)='"&pers_ncorr&"' and cast(a.post_ncorr as varchar)='"&post_ncorr&"'")

'response.Write(valor_check) 
%>
<html>
<head>
<title>SOLICITUD DE SEGURO DE ESCOLARIDAD</title>
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
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="100%">&nbsp;<div align="right" class="noprint">
<button name="Button" value="Imprimir Horario" onClick="print()" >
Imprimir
</button>
</div></td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr> 
    <td align="center">
		<table width="90%" cellpadding="0" cellspacing="0" border="1">
			<TR>
				<TD align="center"><div align="center"><font size="4"><strong>SOLICITUD DE SEGURO DE ESCOLARIDAD</strong></font></div></TD>
			</TR>
		</table></td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr> 
    <td align="center">
		<table width="90%" cellpadding="0" cellspacing="0">
			<TR>
				<TD align="left"><div align="left"><font size="1"><strong>Contratante Contrato de Servicios Educacionales - Año <%=anio%></strong></font></div></TD>
			</TR>
		</table></td>
  </tr>
  <tr> 
    <td align="center">
		<table width="90%" cellpadding="0" cellspacing="0" border="1">
			<TR>
				<TD align="center" width="33%"><div align="center"><font size="1">Apellido Paterno</font></div></TD>
				<TD align="center" width="33%"><div align="center"><font size="1">Apellido Materno</font></div></TD>
				<TD align="center" width="33%"><div align="center"><font size="1">Nombres</font></div></TD>
			</TR>
			<TR>
				<TD align="center" width="33%"><div align="center"><font size="1"><%=paterno_codeudor%></font></div></TD>
				<TD align="center" width="33%"><div align="center"><font size="1"><%=materno_codeudor%></font></div></TD>
				<TD align="center" width="33%"><div align="center"><font size="1"><%=nombre_codeudor%></font></div></TD>
			</TR>
		</table></td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr> 
    <td align="center">
		<table width="90%" cellpadding="0" cellspacing="0">
		    <%if valor_check = "S" then %>
			<TR>
				<TD align="center"><div align="center"><input type="checkbox" name="desea_seguro" value="0" disabled  checked>&nbsp;&nbsp;<strong><font size="3" style="text-decoration:underline">NO</font>&nbsp;&nbsp;<font size="2">DESEO EL SEGURO DE ESCOLARIDAD</strong></font></div></TD>
			</TR>
			<%else%>
			<TR>
				<TD align="center"><div align="center">&nbsp;</div></TD>
			</TR>
			<%end if%>
		</table></td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr> 
    <td align="center">
		<table width="90%" cellpadding="0" cellspacing="0">
		<%if valor_check = "S" then %> 
		   <tr><td>&nbsp;</td></tr>
           <tr><td>&nbsp;</td></tr>
           <tr><td>&nbsp;</td></tr>
			<TR>
				<TD align="center"><div align="center"><font size="1">Firma Contratante ..................................................</font></div></TD>
			</TR>
		<%end if%>	
		</table></td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr> 
    <td align="center">
		<table width="90%" cellpadding="0" cellspacing="0">
			<TR>
				<TD align="Left" width="20%"><div align="left"><font size="1"><strong>1er Sostenedor</strong></font></div></TD>
				<TD align="center" width="10%"><div align="center"><font size="1">&nbsp;</font></div></TD>
				<TD align="left"><div align="left"><font size="1">(Edad m&aacute;xima asegurable 68 años, 364 d&iacute;as)</font></div></TD>
			</TR>
		</table></td>
  </tr>
  <tr> 
    <td align="center">
		<table width="90%" cellpadding="0" cellspacing="0" border="1">
			<TR>
				<TD align="center" width="33%"><div align="center"><font size="1">Apellido Paterno</font></div></TD>
				<TD align="center" width="33%"><div align="center"><font size="1">Apellido Materno</font></div></TD>
				<TD align="center" width="33%"><div align="center"><font size="1">Nombres</font></div></TD>
			</TR>
			<TR>
				<TD align="center" width="33%"><div align="center"><font size="1"><%=paterno_codeudor%></font></div></TD>
				<TD align="center" width="33%"><div align="center"><font size="1"><%=materno_codeudor%></font></div></TD>
				<TD align="center" width="33%"><div align="center"><font size="1"><%=nombre_codeudor%></font></div></TD>
			</TR>
			<TR>
				<TD align="center" width="33%"><div align="center"><font size="1">F. Nacimiento</font></div></TD>
				<TD align="center" width="33%"><div align="center"><font size="1">R.U.T.</font></div></TD>
				<TD align="center" width="33%"><div align="center"><font size="1">Fonos</font></div></TD>
			</TR>
			<TR>
				<TD align="center" width="33%"><div align="center"><font size="1"><%=nacimiento_codeudor%></font></div></TD>
				<TD align="center" width="33%"><div align="center"><font size="1"><%=rut_codeudor%></font></div></TD>
				<TD align="center" width="33%"><div align="center"><font size="1"><%=fono_codeudor%></font></div></TD>
			</TR>
		</table></td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <tr> 
    <td align="center">
		<table width="90%" cellpadding="0" cellspacing="0">
			<TR>
				<TD align="left"><div align="left"><font size="1"><strong>Datos Alumnos (s)</strong></font></div></TD>
			</TR>
		</table></td>
  </tr>
  <tr> 
    <td align="center">
		<table width="90%" cellpadding="0" cellspacing="0" border="1">
			<TR>
				<TD align="center" width="30%"><div align="center"><font size="1">Nombre completo</font></div></TD>
				<TD align="center" width="15%"><div align="center"><font size="1">RUT</font></div></TD>
				<TD align="center" width="15%"><div align="center"><font size="1">F. Nacimiento</font></div></TD>
				<TD align="center" width="40%"><div align="center"><font size="1">Carrera</font></div></TD>
			</TR>
			<TR>
				<TD align="center" width="30%"><div align="center"><font size="1"><%=nombre_alumno%></font></div></TD>
				<TD align="center" width="15%"><div align="center"><font size="1"><%=rut_alumno%></font></div></TD>
				<TD align="center" width="15%"><div align="center"><font size="1"><%=nacimiento_alumno%></font></div></TD>
				<TD align="center" width="40%"><div align="center"><font size="1"><%=carrera_alumno%></font></div></TD>
			</TR>
		</table></td>
  </tr>
   <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
  <%if valor_check = "N" then %>
  <tr> 
    <td align="center">
		<table width="90%" cellpadding="0" cellspacing="0">
			<TR>
				<TD align="left"><div align="left"><font size="1"><strong>Declaración simple</strong></font></div></TD>
			</TR>
		</table></td>
  </tr>
  <tr> 
    <td align="center">
		<table width="90%" cellpadding="0" cellspacing="0" border="1">
			<TR>
				<TD align="center" width="100%">
				    <div align="justify">
					   <font size="1">Declaro estar en buenas condiciones de salud y que no padezco ni he padecido ninguna de las siguientes enfermedades:
					                  Diabetes, cáncer o tumores de cualquier naturaleza, trastornos mentales o del sistema nervioso, enfermedades cardiovasculares
									  y/o hipertensión, broncopulmonares, genitourinarias, renales y de transmisión sexual (venereas o sida). En caso contrario detallar
									  en "Declaración de Preexistencias".<br><br>Preexistencia: Se entiende por preexistencia cualquier enfermedad o accidente conocida y/o 
									  diagnosticada  con anterioridad a la fecha de llenado de este formulario.                
					   </font>
					 </div>
			      </TD>
    		</TR>
			<tr><td>&nbsp;</td></tr>
			<tr>
			    <td align="center">
				           <table width="100%" border="1">
						   <tr>
						   	   <td width="40%" align="left"><font size="1">Nombre del asegurable</font></td>
							   <td width="40%" align="left"><font size="1">Descripción de la enfermedad/accidente</font></td>
							   <td width="20%" align="left"><font size="1">Fecha diagnóstico</font></td>
						   </tr>
						   <%while lista_preexistencias.siguiente %>
						   <tr>
						   	   <td width="40%" align="left"><font size="1"><%=lista_preexistencias.obtenerValor("nombre")%>&nbsp;</font></td>
							   <td width="40%" align="left"><font size="1"><%=lista_preexistencias.obtenerValor("enfermedad")%>&nbsp;</font></td>
							   <td width="20%" align="left"><font size="1"><%=lista_preexistencias.obtenerValor("fecha")%>&nbsp;</font></td>
						   </tr>
						   <%wend%>
						   <tr>
						   	   <td width="40%" align="left"><font size="1">&nbsp;</font></td>
							   <td width="40%" align="left"><font size="1">&nbsp;</font></td>
							   <td width="20%" align="left"><font size="1">&nbsp;</font></td>
						   </tr>
						   </table>
				</td>
		     </tr>
		</table></td>
  </tr>
  <%end if%>
  <%if valor_check <> "S" then %>
  <tr><td>&nbsp;</td></tr>
  <tr><td align="center"><table width="90%"><tr><td><div align="justify"><font size="1">Confirmo la exactitud y veracidad de las declaraciones arriba expresadas y que nada he omitido y/o disimulado
		                             y autorizo a la Compañía a recabar todos aquellos antecedentes que de una u otra forma le permitan realizar una 
									 mejor evaluación de esta Solicitud de Seguro.</div></font></td></tr>
           </table>
	  </td>
   </tr>
   <%else%>
   <tr><td>&nbsp;</td></tr>
  <tr><td align="center">&nbsp;</td></tr>
   <%end if%>
   <tr><td>&nbsp;</td></tr>
   <tr><td>&nbsp;</td></tr>
   <tr><td>&nbsp;</td></tr>
   <tr><td>&nbsp;</td></tr>
   <tr><td align="center">
		   <table width="90%">
			  <tr>
			  	<td width="10%"><font size="2">Fecha&nbsp;&nbsp;</font></td>
				<td width="30%" align="left"><table width="100%" border="1">
				                <tr>
									<td width="25%"><font size="1"><%=dia_actual%></font></td>
									<td width="25%"><font size="1"><%=mes_actual%></font></td>
									<td width="50%"><font size="1"><%=anio_actual%></font></td>
								</tr>
								</table>
				</td>
				<%if valor_check <> "S" then %>
					<td width="60%"><font size="1">&nbsp;&nbsp;Firma Sostenedor responsable...............................</font></td>
				<%else%>	
				    <td width="60%">&nbsp;</td>
				<%end if%>
			  </tr>			   
		   </table>
	   </td>
   </tr>
  <tr><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td></tr>
   <tr><td align="center">
		   <table width="90%" border="1">
		   <%if valor_check <> "S" then %>
			  <tr>
			  	<td align="center"><font size="1">Esta declaración no otorga cobertura sino hasta haber sido evaluada y aceptada por parte de la Compañía.</font></td>
    		  </tr>			   
			<%end if%>  
		   </table>
	   </td>
   </tr>
</table>
<br>
</body>
</html>

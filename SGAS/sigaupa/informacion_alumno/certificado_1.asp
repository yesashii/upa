<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
pers_nrut = request.QueryString("pers_nrut")
carr_ccod = request.QueryString("carr_ccod")
tdes_ccod = request.QueryString("tdes_ccod")
'response.Write(tdes_ccod)
set conexion = new cConexion
set negocio = new cnegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

peri_ccod = "210"
pers_ncorr = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='" & pers_nrut & "' ")

c_consulta = " select case count(*) when 0 then 'N' else 'S' end " & vbCrLf &_
			 " from certificados_online " & vbCrLf &_
			 " where cast(pers_ncorr as varchar)='"&pers_ncorr&"'  " & vbCrLf &_
		     " and carr_ccod ='"&carr_ccod&"' " & vbCrLf &_
			 " and cast(tdes_ccod as varchar)='"&tdes_ccod&"' " & vbCrLf &_
			 " and convert(datetime,protic.trunc(getDate()),103) <= convert(datetime,protic.trunc(fecha_vencimiento),103)"

tiene_grabado = conexion.consultaUno(c_consulta)
'---------------------revisamos si tiene grabado este certificado y ya esta vencido o no l tiene se debe grabar un certificado nuevo.
if tiene_grabado = "N" then 
 ceon_ncorr = conexion.consultaUno("exec obtenerSecuencia 'certificados_online'")
 matr_ncorr_temporal = conexion.consultaUno ("select max(matr_ncorr) from alumnos where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and emat_ccod = 1 ") 
 post_ncorr_temporal = conexion.consultaUno ("select max(post_ncorr) from alumnos where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and emat_ccod = 1 ") 
 letra_nombre_temporal = conexion.consultaUno ("select substring(pers_tnombre,2,1)  from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'") 
 letra_apellido_temporal = conexion.consultaUno ("select substring(pers_tape_paterno,2,1)  from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'") 
 new_matr = clng(matr_ncorr_temporal) + ceon_ncorr
 new_post = clng(post_ncorr_temporal) - ceon_ncorr
 codigo = new_post & letra_apellido_temporal & new_matr & letra_nombre_temporal &ceon_ncorr
 vencimiento = conexion.consultaUno("select protic.trunc(getDate()+30)")
 
 c_insert = "insert into certificados_online (ceon_ncorr, pers_ncorr, carr_ccod, tdes_ccod, fecha_emision, fecha_vencimiento, audi_tusuario, audi_fmodificacion,cod_activacion)"&_
            "values ("&ceon_ncorr&","&pers_ncorr&",'"&carr_ccod&"',"&tdes_ccod&",getDate(), (getDate() + 30), '"&negocio.obtenerUsuario&"', getdate(),'"&codigo&"')"
			
 conexion.ejecutaS c_insert
else
c_codigo = " select ltrim(rtrim(cod_activacion)) " & vbCrLf &_
			 " from certificados_online " & vbCrLf &_
			 " where cast(pers_ncorr as varchar)='"&pers_ncorr&"'  " & vbCrLf &_
		     " and carr_ccod ='"&carr_ccod&"' " & vbCrLf &_
			 " and cast(tdes_ccod as varchar)='"&tdes_ccod&"' " & vbCrLf &_
			 " and convert(datetime,protic.trunc(getDate()),103) <= convert(datetime,protic.trunc(fecha_vencimiento),103)"
codigo = conexion.consultaUno(c_codigo)
c_vencimiento = " select protic.trunc(fecha_vencimiento) " & vbCrLf &_
			 " from certificados_online " & vbCrLf &_
			 " where cast(pers_ncorr as varchar)='"&pers_ncorr&"'  " & vbCrLf &_
		     " and carr_ccod ='"&carr_ccod&"' " & vbCrLf &_
			 " and cast(tdes_ccod as varchar)='"&tdes_ccod&"' " & vbCrLf &_
			 " and convert(datetime,protic.trunc(getDate()),103) <= convert(datetime,protic.trunc(fecha_vencimiento),103)"
vencimiento = conexion.consultaUno(c_vencimiento) 
end if 

if esVacio(tdes_ccod) or tdes_ccod = "3" then
	resto_mensaje= ", para los fines que estime conveniente."
elseif not esVacio(tdes_ccod) and (tdes_ccod = "5" or tdes_ccod = "1" or tdes_ccod = "4" or tdes_ccod = "9" or tdes_ccod = "10" or tdes_ccod = "11" or tdes_ccod = "12" or tdes_ccod = "13") then
	motivo = conexion.consultaUno("select protic.initcap(tdes_tdesc) from tipos_descripciones where cast(tdes_ccod as varchar)='"&tdes_ccod&"'")
	resto_mensaje= " a petici&oacute;n del (la) interesado(a) para solicitar "&motivo&"."
elseif not esVacio(tdes_ccod) and (tdes_ccod = "6" or tdes_ccod = "7" or tdes_ccod = "8" or tdes_ccod = "14" or tdes_ccod = "16" or tdes_ccod = "18") then
	motivo = conexion.consultaUno("select protic.initcap(tdes_tdesc) from tipos_descripciones where cast(tdes_ccod as varchar)='"&tdes_ccod&"'")
	resto_mensaje= " a petici&oacute;n del (la) interesado(a) para ser presentado en "&motivo&"."
elseif not esVacio(tdes_ccod) and tdes_ccod = "2" then
	resto_mensaje= " a petici&oacute;n del (la) interesado(a) para ser presentado en Cant&oacute;n de Reclutamiento."
elseif not esVacio(tdes_ccod) and (tdes_ccod = "15" or tdes_ccod = "17")then
	motivo = conexion.consultaUno("select protic.initcap(tdes_tdesc) from tipos_descripciones where cast(tdes_ccod as varchar)='"&tdes_ccod&"'")
	resto_mensaje= " a petici&oacute;n del (la) interesado(a) para "&motivo&"."	
end if

'response.Write(carr_ccod)
consulta= " select top 1 e.jorn_tdesc from personas a, alumnos b, ofertas_academicas c, especialidades d,jornadas e " & vbCrLf &_
		  " where cast(a.pers_nrut as varchar)='"&pers_nrut&"' " & vbCrLf &_
		  " and a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
		  " and b.ofer_ncorr=c.ofer_ncorr " & vbCrLf &_
		  " and c.espe_ccod=d.espe_ccod " & vbCrLf &_
		  " and c.jorn_ccod=e.jorn_ccod " & vbCrLf &_
		  " and cast(d.carr_ccod as varchar)='"&carr_ccod&"'  and emat_ccod = 1 " & vbCrLf &_
		  " order by peri_ccod desc"


consulta_sede= " select top 1 e.sede_tdesc from personas a, alumnos b, ofertas_academicas c, especialidades d,sedes e " & vbCrLf &_
		  " where cast(a.pers_nrut as varchar)='"&pers_nrut&"' " & vbCrLf &_
		  " and a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
		  " and b.ofer_ncorr=c.ofer_ncorr " & vbCrLf &_
		  " and c.espe_ccod=d.espe_ccod " & vbCrLf &_
		  " and c.sede_ccod=e.sede_ccod " & vbCrLf &_
		  " and cast(d.carr_ccod as varchar)='"&carr_ccod&"'   and emat_ccod = 1 " & vbCrLf &_
		  " order by peri_ccod desc"

nombre = conexion.consultaUno("select cast(pers_tnombre as varchar) + ' ' + cast(pers_tape_paterno as varchar) + ' ' + cast(pers_tape_materno as varchar) from personas where cast(pers_nrut as varchar)='" & pers_nrut & "' ")
rut = conexion.consultaUno("select protic.format_rut('"&pers_nrut&"')")
carrera = conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar)='" & carr_ccod & "' ")
jornada = conexion.consultaUno(consulta)
nombre_sede = conexion.consultaUno(consulta_sede)
tcar_ccod = conexion.consultaUno("select tcar_ccod from carreras where cast(carr_ccod as varchar)='" & carr_ccod & "' ")

'consulta_fecha = " select cast(datePart(day,getDate()) as varchar)+ ' de ' + " & vbCrLf &_
'				 " case datePart(month,getDate()) when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' " & vbCrLf &_
'				 " when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' " & vbCrLf &_
'				 " when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' end + ' de ' +  " & vbCrLf &_
'				 " cast(datePart(year,getDate()) as varchar) as fecha_01"

consulta_fecha = "  select cast(datePart(day,fecha_emision) as varchar)+ ' de ' + " & vbCrLf &_
				     "  case datePart(month,fecha_emision) when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' " & vbCrLf &_
					 "  when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' " & vbCrLf &_
					 "  when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' end " & vbCrLf &_
					 "  + ' de ' + cast(datePart(year,fecha_emision) as varchar) as fecha_01 " & vbCrLf &_
					 "  from certificados_online " & vbCrLf &_
					 "  where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cod_activacion='"&codigo&"'"				 
				
fecha_01 = conexion.consultaUno(consulta_fecha)
fecha_01 = "Santiago, "&fecha_01
'------------------------------------ configuramos mensaje de salida para el alumno de acuerdo a su estado---------------
pers_ncorr= conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")
'response.Write("pers_ncorr "&pers_ncorr&" carr_ccod "&carr_ccod)
consulta_ultimo_estado= " select top 1 emat_ccod from alumnos a, ofertas_academicas b, especialidades c " & vbCrLf &_
						" where a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
					    " and b.espe_ccod=c.espe_ccod " & vbCrLf &_
						" and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'  and emat_ccod= 1  " & vbCrLf &_
						" and c.carr_ccod='"&carr_ccod&"' " & vbCrLf &_  
						" order by peri_ccod desc,a.audi_fmodificacion desc"
estado=	conexion.consultaUno(consulta_ultimo_estado)					
'response.Write(estado)
'-------------------------Debemos ver si el alumno tiene matricula para el periodo solicitado
consulta_matricula = "select count(*) from alumnos a, ofertas_Academicas b, especialidades c where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr and cast(b.peri_ccod as varchar)='"&peri_ccod&"' and a.emat_ccod = 1 and b.espe_ccod=c.espe_ccod and c.carr_ccod='"&carr_ccod&"' "

tiene_matricula = conexion.consultaUno(consulta_matricula)

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
	else
		if estado= "2" or estado="3" or estado="5" or estado="6" or estado="9" or estado= "10" or tiene_matricula="0" then
			mensaje = "Fue Alumno(a)"
		else
			mensaje = "Es Alumno(a)"
		end if
	end if	

end if


detalle_estado= conexion.consultaUno("Select protic.initcap(emat_tdesc) from estados_matriculas where cast(emat_ccod as varchar)='"&estado&"'")
if estado = "1" or estado = "13" then
	mensaje = mensaje & " regular "
'else
'	mensaje = mensaje & detalle_estado & "(a)"
end if	

if tcar_ccod <> "2" then
	mensaje = mensaje & " de la Carrera de "
else
	mensaje = mensaje & " de "
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
<table width="100%" border="1" bordercolor="#666666">
<tr valign="top">
<td width="100%" align="center">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr><td colspan="3">&nbsp;</td></tr>
 <tr><td colspan="3" align="left"><table width="10%">
                                  	<tr valign="top">
										<td width="5%">&nbsp;</td>
										<td width="65" height="50" align="center"><img align="middle" width="65" height="50" src="../imagenes/logo_upa.jpg"></td>
									</tr>
									<tr valign="top">
										<td width="5%">&nbsp;</td>
										<td align="center">Universidad Del Pacífico</td>
									</tr>
								  </table></td></tr> 
  <tr> 
    <td colspan="3">&nbsp;<div align="right" class="noprint">
<button name="Button" value="Imprimir Horario" onClick="print()" >
Imprimir
</button>
</div></td>
  </tr>
  
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr> 
    <td colspan="3"><div align="center"><font size="4"><strong>CERTIFICADO DE ALUMNO</strong></font></div></td>
  </tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3"><div align="left"><font size="2"><strong>&nbsp;La Universidad del Pac&iacute;fico :</strong></font></div></td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr>
  	  <td width="50%"><div align="left"><font size="2">&nbsp;Certifica que el(la) Sr.(ita).</font></div></td>
	  <td width="1%"><div align="center"><font size="2">:</font></div></td>
	  <td width="49%"><div align="left"><font size="2"><%=nombre%></font></div></td>	
  </tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr>
  	  <td width="50%"><div align="left"><font size="2">&nbsp;R.u.t.</font></div></td>
	  <td width="1%"><div align="center"><font size="2">:</font></div></td>
	  <td width="49%"><div align="left"><font size="2"><%=rut%></font></div></td>	
  </tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr>
  	  <td width="50%"><div align="left"><font size="2">&nbsp;<%=mensaje%></font></div></td>
	  <td width="1%"><div align="center"><font size="2">:</font></div></td>
	  <td width="49%"><div align="left"><font size="2"><%=carrera%></font></div></td>	
  </tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr>
  	  <td width="50%"><div align="left"><font size="2">&nbsp;Jornada</font></div></td>
	  <td width="1%"><div align="center"><font size="2">:</font></div></td>
	  <td width="49%"><div align="left"><font size="2"><%=jornada%></font></div></td>	
  </tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
   <tr>
  	  <td width="50%"><div align="left"><font size="2">&nbsp;Sede</font></div></td>
	  <td width="1%"><div align="center"><font size="2">:</font></div></td>
	  <td width="49%"><div align="left"><font size="2"><%=nombre_sede%></font></div></td>	
  </tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3"><div align="left"><font size="2">Se extiende el presente certificado<%=resto_mensaje%></font></div></td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
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
	<td width="50%" align="center"><img width="280" height="134" src="../imagenes/firma2.jpg"></td>
  </tr>
    <tr> 
    <td width="34%" align="center">&nbsp;</td>
	<td width="16%" align="center">&nbsp;</td>
	<!--<td width="50%" align="center"><font size="2"><strong>ELENA ORTUZAR MU&Ntilde;OZ</strong></font></td>-->
	<td width="50%" align="center"><font size="2"><strong>MARIA TERESA MERINO GAME</strong></font></td>
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
    <td colspan="3" align="center">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="3" align="center"><font size="1"><strong>C&oacute;digo de Validaci&oacute;n: <%=codigo%></strong></font></td>
  </tr>
  <tr> 
    <td colspan="3" align="center">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="3" align="center"><font size="-2">Para validar este certificado dir&iacute;jase a la p&aacute;gina de la Universidad:<br><a href="http://www.upacifico.cl/validacion_certificados/valida.htm" target="_blank">http://www.upacifico.cl/validacion_certificados/valida.htm</a><br>Ingrese Rut del alumno y código de validaci&oacute;n <br>(el certificado es V&aacute;lido sólo si el mostrado en pantalla de validaci&oacute;n es id&eacute;ntico al que se encuentra en su poder). <br>Este certificado es v&aacute;lido hasta el <%=vencimiento%>.</font></td>
  </tr>
  <tr> 
    <td colspan="3" align="center">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="3" align="center"><font size="-2"><strong>Santiago: </strong>Sede Las Condes: Av.Las Condes 11.121 - Campus Lyon: Av. R. Lyon 227 - Campus Baquedano: Av. Ramón Carnicer 65. <br> <strong>Melipilla : </strong>Sede Melipilla : Andrés Bello 0383 - Mall Leyán, Av. Serrano 395, Local 13, Planta Baja. <br> <strong>Concepción: </strong>Oficina Concepción: Víctor Lamas 917, Edificio Horizonte.</font></td>
  </tr>
  <tr> 
    <td colspan="3" align="center">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="3" align="center">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="3" align="center"><font size="1"><%=fecha_01%></font></td>
  </tr>
</table>
</td>
</tr>
</table>
</body>
</html>

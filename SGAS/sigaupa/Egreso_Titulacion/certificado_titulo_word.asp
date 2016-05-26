<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
Response.AddHeader "Content-Disposition", "attachment;filename=encuestas_acreditacion.doc"
Response.ContentType = "application/vnd.ms-word"
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
pers_nrut = request.QueryString("pers_nrut")
sede_ccod = request.QueryString("sede_ccod")
plan_ccod = request.QueryString("plan_ccod")
peri_ccod = request.QueryString("peri_ccod")
'response.Write(tdes_ccod)
set conexion = new cConexion
set negocio = new cnegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

set f_titulados = new CFormulario
f_titulados.Carga_Parametros "adm_titulados.xml", "titulados"
f_titulados.Inicializar conexion

SQL = "  select top 1 a.salu_ncorr, a.pers_ncorr, protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr, 'N') as nombre,"& vbCrLf &_
      "         a.salu_nregistro, a.salu_nfolio, SUBSTRING(LTRIM(RTRIM(cast(cast(a.salu_nnota AS decimal(2,1))AS varchar))), 1, CHARINDEX('.', LTRIM(RTRIM(cast(cast(a.salu_nnota AS decimal(2,1)) AS varchar)))) - 1) + '.' + "& vbCrLf &_
      "         isnull(SUBSTRING(LTRIM(RTRIM(cast(cast(a.salu_nnota AS decimal(2,1))AS varchar))), CHARINDEX('.', LTRIM(RTRIM(cast(cast(a.salu_nnota AS decimal(2,1))AS varchar)))) + 1, 1),0) as salu_nnota, a.salu_fsalida,"& vbCrLf &_
      " 		b.peri_ccod, b.plan_ccod, b.sede_ccod, c.pers_nrut, c.pers_xdv, cast(a.salu_nnota AS decimal(2,1)) as nota_prueba,      "& vbCrLf &_
      "         cast(a.salu_nfolio as varchar) as folio_reg, b.sapl_tdesc as titulo_grado, "& vbCrLf &_
	  " '( ' + "& vbCrLf &_
      "  case  SUBSTRING(LTRIM(RTRIM(cast(cast(a.salu_nnota AS decimal(2,1))AS varchar))), 1, CHARINDEX('.', LTRIM(RTRIM(cast(cast(a.salu_nnota AS decimal(2,1)) AS varchar)))) - 1) "& vbCrLf &_
      "  when 1 then 'Uno' when 2 then 'Dos' when 3 then 'Tres' when 4 then 'Cuatro' when 5 then 'Cinco' when 6 then 'Seis' "& vbCrLf &_
      "  when 7 then 'Siete' end + ' , ' + "& vbCrLf &_
	  "  case isnull(SUBSTRING(LTRIM(RTRIM(cast(cast(a.salu_nnota AS decimal(2,1))AS varchar))), CHARINDEX('.', LTRIM(RTRIM(cast(cast(a.salu_nnota AS decimal(2,1))AS varchar)))) + 1, 1),0) "& vbCrLf &_
      "  when 1 then 'Uno' when 2 then 'Dos' when 3 then 'Tres' when 4 then 'Cuatro' when 5 then 'Cinco' when 6 then 'Seis' "& vbCrLf &_
      "  when 7 then 'Siete' when 8 then 'Ocho' when 9 then 'Nueve' when 0 then 'Cero' end + ' )'as en_palabras, "& vbCrLf &_
	  "  case when replace(replace((select espe_tdesc from planes_estudio aa,especialidades ee where aa.espe_ccod=ee.espe_ccod and cast(plan_ccod as varchar) = '"&plan_ccod&"'),'(D)',''),'(V)','') "& vbCrLf &_
	  "       like '%sin mencion%' then ''  "& vbCrLf &_
	  "       when replace(replace((select espe_tdesc from planes_estudio aa,especialidades ee where aa.espe_ccod=ee.espe_ccod and cast(plan_ccod as varchar) = '"&plan_ccod&"'),'(D)',''),'(V)','') "& vbCrLf &_
	  "       like '%plan comun%' then '' "& vbCrLf &_
	  "  else replace(replace((select espe_tdesc from planes_estudio aa,especialidades ee where aa.espe_ccod=ee.espe_ccod and cast(plan_ccod as varchar) = '"&plan_ccod&"'),'(D)',''),'(V)','') end  as mencion "& vbCrLf &_
      " from salidas_alumnos a, salidas_plan b, personas c,"& vbCrLf &_
      "       tipos_salidas_plan d"& vbCrLf &_
      "  where a.sapl_ncorr = b.sapl_ncorr "& vbCrLf &_
      "    and a.pers_ncorr = c.pers_ncorr "& vbCrLf &_
      "    and b.tspl_ccod = d.tspl_ccod "& vbCrLf &_
      "    and b.tspl_ccod in (2, 3, 4) "& vbCrLf &_
      "    and cast(b.peri_ccod as varchar)= '" & peri_ccod & "' "& vbCrLf &_
      "    and cast(b.plan_ccod as varchar)= '" & plan_ccod & "' "& vbCrLf &_
      "    and cast(b.sede_ccod as varchar)= '" & sede_ccod & "' "& vbCrLf &_
	  "    and cast(c.pers_nrut as varchar)= '" & pers_nrut & "' "& vbCrLf &_
      " order by nombre asc, b.tspl_ccod asc"
'response.Write("<pre>"&SQL&"</pre>")

f_titulados.Consultar SQL
f_titulados.siguiente



nombre = f_titulados.obtenerValor("nombre")
rut = f_titulados.obtenerValor("rut")
titulo = f_titulados.obtenerValor("titulo_grado")
folio = f_titulados.obtenerValor("folio_reg")
nota = f_titulados.obtenerValor("salu_nnota")
fecha_origen = f_titulados.obtenerValor("salu_fsalida")
en_palabras = f_titulados.obtenerValor("en_palabras")
nota_prueba = f_titulados.obtenerValor("nota_prueba")
mencion = f_titulados.obtenerValor("mencion")

consulta_fecha = " select cast(datePart(day,getDate()) as varchar)+ ' de ' + " & vbCrLf &_
				 " case datePart(month,getDate()) when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' " & vbCrLf &_
				 " when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' " & vbCrLf &_
				 " when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' end + ' de ' +  " & vbCrLf &_
				 " cast(datePart(year,getDate()) as varchar) as fecha_01"
fecha_impresion = conexion.consultaUno(consulta_fecha)

consulta_fecha = " select cast(datePart(day,'"&fecha_origen&"') as varchar)+ ' de ' + " & vbCrLf &_
				 " case datePart(month,'"&fecha_origen&"') when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' " & vbCrLf &_
				 " when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' " & vbCrLf &_
				 " when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' end + ' de ' +  " & vbCrLf &_
				 " cast(datePart(year,'"&fecha_origen&"') as varchar) as fecha_01"
fecha_titulacion = conexion.consultaUno(consulta_fecha)

'-------------------debemos sacar el a�o en que se titulo para ver a que distinci�n corresponde su nota.
anio_titulacion = conexion.consultaUno("select datePart(year,'"&fecha_origen&"')")

if anio_titulacion <= "2005" then
   if cdbl(nota_prueba) >= cdbl(4.0) and cdbl(nota_prueba) <= cdbl(4.9) then
   		equivale = "UNANIMIDAD"
    elseif cdbl(nota_prueba) >= cdbl(5.0) and cdbl(nota_prueba) <= cdbl(5.4) then
   		equivale = "UN VOTO DE DISTINCION"
	elseif cdbl(nota_prueba) >= cdbl(5.5) and cdbl(nota_prueba) <= cdbl(5.9) then
   		equivale = "DOS VOTOS DE DISTINCION"	
	elseif cdbl(nota_prueba) >= cdbl(6.0) and cdbl(nota_prueba) <= cdbl(6.4) then
   		equivale = "TRES VOTOS DE DISTINCION"	 
    elseif cdbl(nota_prueba) >= cdbl(6.5) and cdbl(nota_prueba) <= cdbl(7.0) then
   		equivale = "APROBADO CON DISTINCION MAXIMA" 
   end if 
else
    'response.Write(cdbl(nota_prueba))
    if cdbl(nota_prueba) >= cdbl(4.0) and cdbl(nota_prueba) <= cdbl(4.9) then
   		equivale = "APROBADO POR UNANIMIDAD"
    elseif cdbl(nota_prueba) >= cdbl(5.0) and cdbl(nota_prueba) <= cdbl(5.9) then
   		equivale = "APROBADO CON DISTINCION" 
    elseif cdbl(nota_prueba) >= cdbl(6.0) and cdbl(nota_prueba) <= cdbl(7.0) then
   		equivale = "APROBADO CON DISTINCION MAXIMA" 
   end if 
end if

%>
<html>
<head>
<title>Certificado de Titulaci�n</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
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
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
   <tr> 
    <td colspan="3"><div align="right">&nbsp;</div></td>
  </tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3"><div align="left">&nbsp;</div></td></tr>
  <tr> 
    <td colspan="3"><div align="right"><font size="2"><strong>R.u.t. :&nbsp;&nbsp;<%=rut%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong></font></div></td>
  </tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr> 
    <td colspan="3"><div align="left" class="noprint"><font size="2" color="#FFFFFF">Certifico que, conforme a la Reglamentaci&oacute;n de la Universidad, y seg&uacute;n consta en el expediente</font></div></td>
  </tr> 
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr> 
    <td colspan="3"><div align="left" class="noprint"><font size="2" color="#FFFFFF">de titulaci&oacute;n correspondiente,</font></div></td>
  </tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr> 
    <td colspan="3" align="left"><font size="2" color="#FFFFFF"><span class="noprint">con fecha </span></font><font size="2"><strong>&nbsp;&nbsp;&nbsp;<%=fecha_titulacion%></strong></font></td>
  </tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr> 
    <td colspan="3" align="left"><font size="2" color="#FFFFFF"><span class="noprint">se otorg&oacute; el T&Iacute;tulo </span></font><font size="2"><strong>&nbsp;&nbsp;&nbsp;<%=titulo%></strong></font></td>
  </tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <%if mencion <> "" then %>
  <tr> 
    <td colspan="3" align="left"><font size="2"><strong>CON MENCION EN &nbsp;<%=mencion%></strong></font></td>
  </tr>
  <%else%>
  <tr> 
    <td colspan="3" align="left"><font size="2"><strong>&nbsp;</strong></font></td>
  </tr>
  <%end if%>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr> 
    <td colspan="3" align="left"><font size="2" color="#FFFFFF"><span class="noprint">la calificaci&oacute;n final obtenida es </span></font><font size="2"><strong>&nbsp;&nbsp;&nbsp;<%=nota%>&nbsp;&nbsp;<%=en_palabras%></strong></font></td>
  </tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr> 
    <td colspan="3" align="left"><font size="2" color="#FFFFFF"><span class="noprint">equivalente a </span></font><font size="2"><strong>&nbsp;&nbsp;&nbsp;<%=equivale%></strong></font></td>
  </tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr> 
    <td colspan="3"align="left"><font size="2" color="#FFFFFF"><span class="noprint">a don (�a) </span></font><font size="2"><strong>&nbsp;&nbsp;&nbsp;<%=nombre%></strong></font></td>
  </tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr> 
    <td width="34%" align="center">&nbsp;</td>
	<td width="16%" align="center">&nbsp;</td>
	<td width="50%" align="center"><div align="center" class="noprint"><font size="2" color="#FFFFFF"><strong>ELENA ORTUZAR MU&Ntilde;OZ</strong></font></div></td>
  </tr>
  <tr> 
    <td width="34%" align="center">&nbsp;</td>
	<td width="16%" align="center">&nbsp;</td>
	<td width="50%" align="center"><div align="center" class="noprint"><font size="2" color="#FFFFFF"><strong>Secretaria General</strong></font></div></td>
  </tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3" height="15">&nbsp;</td></tr>
  <tr> 
    <td colspan="3" align="left"><font size="2" color="#FFFFFF"><span class="noprint">Santiago,</span></font><font size="2"><strong>&nbsp;&nbsp;<%=fecha_impresion%></strong></font></td>
  </tr>
  <tr> 
    <td colspan="3" align="left"><font size="2" color="#FFFFFF"><span class="noprint">Folio N�</span></font><font size="2"><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=folio%></strong></font></td>
  </tr>
 </table>
<br>
</body>
</html>

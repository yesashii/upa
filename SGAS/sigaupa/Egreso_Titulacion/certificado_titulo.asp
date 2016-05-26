<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
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
      "         cast(a.salu_nfolio as varchar) as folio_reg, linea_1_certificado as titulo_grado, "& vbCrLf &_
	  " '( ' + "& vbCrLf &_
      "  case  SUBSTRING(LTRIM(RTRIM(cast(cast(a.salu_nnota AS decimal(2,1))AS varchar))), 1, CHARINDEX('.', LTRIM(RTRIM(cast(cast(a.salu_nnota AS decimal(2,1)) AS varchar)))) - 1) "& vbCrLf &_
      "  when 1 then 'Uno' when 2 then 'Dos' when 3 then 'Tres' when 4 then 'Cuatro' when 5 then 'Cinco' when 6 then 'Seis' "& vbCrLf &_
      "  when 7 then 'Siete' end + ' , ' + "& vbCrLf &_
	  "  case isnull(SUBSTRING(LTRIM(RTRIM(cast(cast(a.salu_nnota AS decimal(2,1))AS varchar))), CHARINDEX('.', LTRIM(RTRIM(cast(cast(a.salu_nnota AS decimal(2,1))AS varchar)))) + 1, 1),0) "& vbCrLf &_
      "  when 1 then 'Uno' when 2 then 'Dos' when 3 then 'Tres' when 4 then 'Cuatro' when 5 then 'Cinco' when 6 then 'Seis' "& vbCrLf &_
      "  when 7 then 'Siete' when 8 then 'Ocho' when 9 then 'Nueve' when 0 then 'Cero' end + ' )'as en_palabras, "& vbCrLf &_
	  "  --case when replace(replace((select isnull(espe_certificado,espe_tdesc) from planes_estudio aa,especialidades ee where aa.espe_ccod=ee.espe_ccod and cast(plan_ccod as varchar) = '"&plan_ccod&"'),'(D)',''),'(V)','') "& vbCrLf &_
	  "  --     like '%sin mencion%' then ''  "& vbCrLf &_
	  "  --     when replace(replace((select isnull(espe_certificado,espe_tdesc) from planes_estudio aa,especialidades ee where aa.espe_ccod=ee.espe_ccod and cast(plan_ccod as varchar) = '"&plan_ccod&"'),'(D)',''),'(V)','') "& vbCrLf &_
	  "  --     like '%plan comun%' then '' "& vbCrLf &_
	  "  --else replace(replace((select isnull(espe_certificado,espe_tdesc) from planes_estudio aa,especialidades ee where aa.espe_ccod=ee.espe_ccod and cast(plan_ccod as varchar) = '"&plan_ccod&"'),'(D)',''),'(V)','') end  as mencion "& vbCrLf &_
      "  linea_2_certificado as mencion"& vbCrLf &_
	  " from salidas_alumnos a, salidas_plan b, personas c,"& vbCrLf &_
      "       tipos_salidas_plan d,planes_estudio e"& vbCrLf &_
      "  where a.sapl_ncorr = b.sapl_ncorr "& vbCrLf &_
      "    and a.pers_ncorr = c.pers_ncorr "& vbCrLf &_
      "    and b.tspl_ccod = d.tspl_ccod and b.plan_ccod = e.plan_ccod "& vbCrLf &_
      "    and b.tspl_ccod in (2, 3, 4) "& vbCrLf &_
      "    and cast(b.peri_ccod as varchar)= '" & peri_ccod & "' "& vbCrLf &_
      "    and cast(b.plan_ccod as varchar)= '" & plan_ccod & "' "& vbCrLf &_
      "    --and cast(b.sede_ccod as varchar)= '" & sede_ccod & "' "& vbCrLf &_
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
mencion1 = f_titulados.obtenerValor("mencion")
'mencion = mencion1
'response.Write(mencion1)
'response.End()
'------------------------------------------------------------------------------------
'tiene = conexion.consultaUno("select charindex(' ','"&titulo&"',21)")
'mencion=""
'if tiene <> "0" then 
'	titulo1 = conexion.consultaUno("select substring('"&titulo&"',0,(select charindex(' ','"&titulo&"',21)))")
'	resto_titulo1 = conexion.consultaUno("select substring('"&titulo&"',(select charindex(' ','"&titulo&"',21)),1 + len('"&titulo&"'))")
'    if mencion1 <> "" then
'		mencion = resto_titulo1 &" CON MENCION EN "&mencion1
'	else
'	    mencion = resto_titulo1
'		mencion1 = resto_titulo1
'	end if		
'else
'    if mencion1 <> "" then
'		mencion = " CON MENCION EN "&mencion1
'    end if
'	titulo1 = titulo 
'end if

'largo = conexion.consultaUno("select len('"&mencion&"')")
'response.Write(largo)

'------------------------------------------------------------------------------------


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

'-------------------debemos sacar el año en que se titulo para ver a que distinción corresponde su nota.
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

tcar_ccod = conexion.consultaUno("select c.tcar_ccod from planes_estudio a, especialidades b, carreras c where a.espe_ccod=b.espe_ccod and b.carr_ccod=c.carr_ccod and cast(a.plan_ccod as varchar)='"&plan_ccod&"'")
if tcar_ccod = "2" then 
	texto_oculto = "se otorgó el Grado Académico de"
else 
	texto_oculto = "se otorgó el Título de"
end if

%>
<html>
<head>
<title>Certificado de Titulación</title>
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
    <td width="19%">&nbsp;</td>
	<td width="81%" align="left">
		<table width="100%">
			  <tr>
					<td colspan="3">&nbsp;<div align="right" class="noprint">
				<button name="Button" value="Imprimir Horario" onClick="print()" >
				Imprimir
				</button>
				</div></td>
  			  </tr>
			  <tr><td colspan="3"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">A</span></font></td></tr>
			  <tr><td colspan="3"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">B</span></font></td></tr>
			  <tr><td colspan="3"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">C</span></font></td></tr>
			  <tr><td colspan="3" align="right"><font size="4" face="Times New Roman, Times, serif"><span class="noprint">Folio N°:</span>&nbsp;&nbsp;<%=folio%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td></tr>
			  <tr><td colspan="3" align="right"><font size="2" face="Times New Roman, Times, serif">N° Céd. de Identidad: <%=rut%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td></tr>
			  <tr><td colspan="3"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">F</span></font></td></tr>
			  <tr><td colspan="3"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">G</span></font></td></tr>
			  <tr><td colspan="3"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">I</span></font></td></tr>
			  <tr valign="bottom"><td colspan="3" align="left" height="58"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">&nbsp;</span></font><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><span class="noprint">&nbsp;&nbsp;con fecha </span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=fecha_titulacion%></font></td></tr> 
			  <tr><td colspan="3"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">K</span></font></td></tr>
			  <tr><td colspan="3"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">L</span></font></td></tr>
			  <tr><td colspan="3" align="left"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">&nbsp;</span></font><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><span class="noprint">&nbsp;&nbsp;<%=texto_oculto%> </span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=titulo%></font></td></tr>
			  <tr><td colspan="3"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">N</span></font></td></tr>
			  <tr><td colspan="3"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">Ñ</span></font></td></tr>
			  <%if mencion1 <> "" then %>
			  <tr>
			    <td colspan="3" align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;&nbsp;<%=mencion1%></font></td>
			  </tr>
			  <%else%>
			  <tr>
			    <td colspan="3" align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;&nbsp;</font></td>
			  </tr>
			  <%end if%>
			  <tr><td colspan="3"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">P</span></font></td></tr>
			  <tr valign="bottom"><td colspan="3" align="left" height="40"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">&nbsp;</span></font><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><span class="noprint">Con calificaci&oacute;n final </span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=nota%>&nbsp;&nbsp;<%=en_palabras%></font></td></tr>
			  <tr><td colspan="3"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">S</span></font></td></tr>
			  <tr><td colspan="3"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">T</span></font></td></tr>
			  <tr valign="top"><td colspan="3" align="left"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">&nbsp;</span></font><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><span class="noprint">equivalente a </span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=equivale%></font></td></tr>
			  <tr><td colspan="3"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">V</span></font></td></tr>
			  <tr valign="bottom"><td colspan="3" height="39"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">&nbsp;</span></font><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><span class="noprint">a Don (ña) </span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=nombre%></font></td></tr>
			  <tr><td colspan="3"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">X</span></font></td></tr>
    		  <tr><td colspan="3"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">Y</span></font></td></tr>
			  <tr><td colspan="3"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">Z</span></font></td></tr>
			  <tr><td colspan="3"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">A</span></font></td></tr>
			  <tr><td colspan="3"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">B</span></font></td></tr>
			  <tr><td colspan="3"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">C</span></font></td></tr>
			  <tr><td colspan="3"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">D</span></font></td></tr>
			  <tr><td colspan="3"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">E</span></font></td></tr>
			  <tr valign="bottom"><td colspan="3" align="left" height="37"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">&nbsp;</span></font><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><span class="noprint">Santiago,</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=fecha_impresion%></font></td></tr>
			  <tr><td colspan="3"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">G</span></font></td></tr>
			  <tr><td colspan="3"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">Z</span></font></td></tr>
    	</table>
	</td>
</tr>
</table>
<br>
</body>
</html>

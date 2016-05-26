<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
saca_ncorr = request.QueryString("saca_ncorr")
pers_ncorr = request.QueryString("pers_ncorr")
tsca_ccod  = request.QueryString("tsca_ccod")

set conexion = new cConexion
set negocio = new cnegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

set errores = new cErrores

set f_titulados = new CFormulario
f_titulados.Carga_Parametros "adm_titulados.xml", "titulados"
f_titulados.Inicializar conexion

SQL = "  select top 1 a.asca_ncorr, a.pers_ncorr, protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr, 'N') as nombre, "& vbCrLf &_
      "  a.asca_nregistro, a.asca_nfolio, SUBSTRING(LTRIM(RTRIM(cast(cast(a.asca_nnota AS decimal(2,1))AS varchar))), 1, CHARINDEX('.', LTRIM(RTRIM(cast(cast(a.asca_nnota AS decimal(2,1)) AS varchar)))) - 1) + '.' +  "& vbCrLf &_
      "  isnull(SUBSTRING(LTRIM(RTRIM(cast(cast(a.asca_nnota AS decimal(2,1))AS varchar))), CHARINDEX('.', LTRIM(RTRIM(cast(cast(a.asca_nnota AS decimal(2,1))AS varchar)))) + 1, 1),0) as asca_nnota, a.asca_fsalida, "& vbCrLf &_
 	  "	 a.peri_ccod, b.plan_ccod, a.sede_ccod, c.pers_nrut, c.pers_xdv, cast(a.asca_nnota AS decimal(2,1)) as nota_prueba,b.carr_ccod,  "& vbCrLf &_     
      "  cast(a.asca_nfolio as varchar) as folio_reg, linea_1_certificado as titulo_grado,linea_2_certificado as mencion,linea_3_certificado as mencion2,  "& vbCrLf &_
      "  '( ' + "& vbCrLf &_
      "   case  SUBSTRING(LTRIM(RTRIM(cast(cast(a.asca_nnota AS decimal(2,1))AS varchar))), 1, CHARINDEX('.', LTRIM(RTRIM(cast(cast(a.asca_nnota AS decimal(2,1)) AS varchar)))) - 1) "& vbCrLf &_
      "   when 1 then 'Uno' when 2 then 'Dos' when 3 then 'Tres' when 4 then 'Cuatro' when 5 then 'Cinco' when 6 then 'Seis' "& vbCrLf &_
      "   when 7 then 'Siete' end + ' , ' +  "& vbCrLf &_
      "   case isnull(SUBSTRING(LTRIM(RTRIM(cast(cast(a.asca_nnota AS decimal(2,1))AS varchar))), CHARINDEX('.', LTRIM(RTRIM(cast(cast(a.asca_nnota AS decimal(2,1))AS varchar)))) + 1, 1),0)  "& vbCrLf &_
      "   when 1 then 'Uno' when 2 then 'Dos' when 3 then 'Tres' when 4 then 'Cuatro' when 5 then 'Cinco' when 6 then 'Seis'  "& vbCrLf &_
      "   when 7 then 'Siete' when 8 then 'Ocho' when 9 then 'Nueve' when 0 then 'Cero' end + ' )'as en_palabras, "& vbCrLf &_
	  " case isnull(a.sede_ccod,1) when 1 then 'Santiago' when 2 then 'Santiago' when 8 then 'Santiago' "& vbCrLf &_
	  " when 4 then 'Melipilla' when 7 then 'Concepción' end as sede "& vbCrLf &_
	  " from alumnos_salidas_carrera a, salidas_carrera b, personas c "& vbCrLf &_
	  " where a.saca_ncorr = b.saca_ncorr  "& vbCrLf &_
   	  " and a.pers_ncorr = c.pers_ncorr  "& vbCrLf &_
      " and cast(a.saca_ncorr as varchar)='"&saca_ncorr&"' and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' "& vbCrLf &_
	  " order by nombre asc "
      
f_titulados.Consultar SQL
f_titulados.siguiente



nombre = f_titulados.obtenerValor("nombre")
rut = f_titulados.obtenerValor("rut")
titulo = f_titulados.obtenerValor("titulo_grado")
folio = f_titulados.obtenerValor("folio_reg")
nota = f_titulados.obtenerValor("asca_nnota")
fecha_origen = f_titulados.obtenerValor("asca_fsalida")
en_palabras = f_titulados.obtenerValor("en_palabras")
nota_prueba = f_titulados.obtenerValor("nota_prueba")
mencion1 = f_titulados.obtenerValor("mencion")
mencion2 = f_titulados.obtenerValor("mencion2")
carr_ccod = f_titulados.obtenerValor("carr_ccod")
pers_nrut = f_titulados.obtenerValor("pers_nrut")
texto_sede = f_titulados.obtenerValor("sede")

'consulta_fecha = " select cast(datePart(day,getDate()) as varchar)+ ' de ' + " & vbCrLf &_
'				 " case datePart(month,getDate()) when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' " & vbCrLf &_
'				 " when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' " & vbCrLf &_
'				 " when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' end + ' de ' +  " & vbCrLf &_
'				 " cast(datePart(year,getDate()) as varchar) as fecha_01"
consulta_fecha = " select cast(datePart(day,getDate()) as varchar)+ '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + " & vbCrLf &_
				 " case datePart(month,getDate()) when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' " & vbCrLf &_
				 " when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' " & vbCrLf &_
				 " when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' end + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +  " & vbCrLf &_
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
   		equivale = "UN VOTO DE DISTINCIÓN"
	elseif cdbl(nota_prueba) >= cdbl(5.5) and cdbl(nota_prueba) <= cdbl(5.9) then
   		equivale = "DOS VOTOS DE DISTINCIÓN"	
	elseif cdbl(nota_prueba) >= cdbl(6.0) and cdbl(nota_prueba) <= cdbl(6.4) then
   		equivale = "TRES VOTOS DE DISTINCIÓN"	 
    elseif cdbl(nota_prueba) >= cdbl(6.5) and cdbl(nota_prueba) <= cdbl(7.0) then
   		equivale = "APROBADO CON DISTINCIÓN MÁXIMA" 
   end if 
else
    'response.Write(cdbl(nota_prueba))
    if cdbl(nota_prueba) >= cdbl(4.0) and cdbl(nota_prueba) <= cdbl(4.9) then
   		equivale = "APROBADO POR UNANIMIDAD"
    elseif cdbl(nota_prueba) >= cdbl(5.0) and cdbl(nota_prueba) <= cdbl(5.9) then
   		equivale = "APROBADO CON DISTINCIÓN" 
    elseif cdbl(nota_prueba) >= cdbl(6.0) and cdbl(nota_prueba) <= cdbl(7.0) then
   		equivale = "APROBADO CON DISTINCIÓN MÁXIMA" 
   end if 
end if

tcar_ccod = conexion.consultaUno("select tcar_ccod from carreras where carr_ccod='"&carr_ccod&"'")
if tcar_ccod = "2" then 
	texto_oculto = "se otorgó el Grado Académico de"
else 
	texto_oculto = "se otorgó el Título de"
end if

'Cambiamos el tsca_ccod para titulos profesionales o grados académicos según los registros históricos
tipo = tsca_ccod
if tsca_ccod = "1" then
	tipo = "3"
elseif tsca_ccod = "2" then
	tipo = "5"
elseif tsca_ccod = "3" then
	tipo = "4"
elseif tsca_ccod = "4" then
	tipo = "6"
elseif tsca_ccod = "5" then
	tipo = "7"
elseif tsca_ccod = "6" then
	tipo = "8"			
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
<script type="text/javascript">
function guarda_titulo()
{
  //location.href='guarda_certificado.asp?carr_ccod='+<%=carr_ccod%>+'&tipo='+<%=tipo%>+'&pers_nrut='+<%=pers_nrut%>;
	  window.open('guarda_certificado.asp?carr_ccod='+<%=carr_ccod%>+'&tipo='+<%=tipo%>+'&pers_nrut='+<%=pers_nrut%>,'guardar','width=50px, height=50px, scrollbars=yes, resizable=yes')
}
function guarda_grado()
{
//location.href='guarda_certificado.asp?carr_ccod='+<%=carr_ccod%>+'&tipo='+<%=tipo%>+'&pers_nrut='+<%=pers_nrut%>;	
	window.open('guarda_certificado.asp?carr_ccod='+<%=carr_ccod%>+'&tipo='+<%=tipo%>+'&pers_nrut='+<%=pers_nrut%>,'guardar','width=50px, height=50px, scrollbars=yes, resizable=yes')
}
</script>
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
  <tr valign="top"> 
    <td width="19%">&nbsp;</td>
	<td width="81%" align="left">
		<table width="100%" cellpadding="0" cellspacing="0">
			  <tr>
					<td colspan="3" height="18">&nbsp;
					    <div align="right" class="noprint">
							<button name="Button" value="Imprimir Horario" onClick="print()" >
							Imprimir
							</button>
							<button name="Guardar" value="Guardar Solicitud" onClick="guarda_titulo()">Guardar Solicitud
							</button>
						</div>
					</td>
  			  </tr>
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18" align="right"><font size="4" face="Times New Roman, Times, serif"><span class="noprint">Folio N°:</span>&nbsp;&nbsp;<%=folio%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18" align="right"><font size="2" face="Times New Roman, Times, serif">N° Céd. de Identidad: <%=rut%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" align="left" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">&nbsp;</span></font><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><span class="noprint">&nbsp;&nbsp;con fecha </span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=fecha_titulacion%></font></td></tr> 
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18" align="left"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">&nbsp;</span></font><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><span class="noprint">&nbsp;&nbsp;<%=texto_oculto%> </span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=titulo%></font></td></tr>
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <%if mencion1 <> "" then %>
			  <tr>
			    <td colspan="3" height="18" align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;&nbsp;<%=mencion1%></font></td>
			  </tr>
			  <%else%>
			  <tr>
			    <td colspan="3" height="18" align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;&nbsp;</font></td>
			  </tr>
			  <%end if%>
			  <%if mencion2 <> "" then %>
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr>
			    <td colspan="3" height="18" align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;&nbsp;<%=mencion2%></font></td>
			  </tr>
			  <%end if%>
			  <tr><td colspan="3" height="18" ><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18" ><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" align="left" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">&nbsp;</span></font><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><span class="noprint">Con calificaci&oacute;n final </span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=nota%>&nbsp;&nbsp;<%=en_palabras%></font></td></tr>
			  <tr><td colspan="3"  height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3"  height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3"  height="18" align="left"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">&nbsp;</span></font><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><span class="noprint">equivalente a </span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=equivale%></font></td></tr>
			  <tr><td colspan="3"  height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18" ><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">&nbsp;</span></font><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><span class="noprint">a Don (ña) </span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=nombre%></font></td></tr>
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</td></tr>
    		  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18" align="left"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF"><span class="noprint">&nbsp;</span></font><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;&nbsp;<%=texto_sede%><span class="noprint">&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=fecha_impresion%></font></td></tr>
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
			  <tr><td colspan="3" height="18"><font size="4" face="Times New Roman, Times, serif" color="#FFFFFF">&nbsp;</font></td></tr>
    	</table>
	</td>
</tr>
</table>
<br>
</body>
</html>

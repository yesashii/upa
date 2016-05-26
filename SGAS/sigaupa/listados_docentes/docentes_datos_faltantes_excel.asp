<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION			    : Nómina de docentes con datos de sexo, país o estado civil sin llenar
'FECHA CREACIÓN			    : 06-09-2013
'CREADO POR				    : Marcelo Sandoval
'ENTRADA				    : peri_ccod
'SALIDA				        : NA
'MODULO QUE ES UTILIZADO	: LISTADOS DOCENTES
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 
'ACTUALIZADO POR			: 
'MOTIVO				        : 
'LINEA				        : 
'********************************************************************
Response.AddHeader "Content-Disposition", "attachment;filename=SIES_general.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 4500000
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
peri_ccod=request.QueryString("peri_ccod")
fecha_actual=conexion.ConsultaUno("select getDate()")


set f_docentes = new CFormulario
f_docentes.Carga_Parametros "tabla_vacia.xml", "tabla" 
f_docentes.Inicializar conexion

profesores = " select distinct cast(d.pers_nrut as varchar)+'-'+d.pers_xdv as Rut, d.pers_tape_paterno + ' ' + d.pers_tape_materno +', ' + d.pers_tnombre as Nombres,  " & vbCrLf &_
			 "	isnull(e.sexo_tdesc,'') as Sexo, isnull(f.eciv_tdesc,'') as Estado_civil, isnull(g.pais_tdesc,'') as Pais   " & vbCrLf &_
			 "	from secciones a join bloques_horarios b   " & vbCrLf &_
			 "		on a.secc_ccod=b.secc_ccod  " & vbCrLf &_
			 "	join bloques_profesores c   " & vbCrLf &_
			 "		on b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
			 "	join personas d  " & vbCrLf &_
			 "		on c.pers_ncorr=d.pers_ncorr  " & vbCrLf &_ 
			 "	left outer join sexos e  " & vbCrLf &_
			 "		on d.sexo_ccod = e.sexo_ccod  " & vbCrLf &_
			 "	left outer join estados_civiles f  " & vbCrLf &_
			 "		on d.eciv_ccod = f.eciv_ccod  " & vbCrLf &_
			 "	left outer join paises g  " & vbCrLf &_
			 "		on d.pais_ccod=g.pais_ccod  " & vbCrLf &_
			 "	where (isnull(d.sexo_ccod,-1)=-1 or isnull(d.eciv_ccod,-1)=-1 or isnull(d.pais_ccod,-1)=-1)  " & vbCrLf &_
			 "	and cast(a.peri_ccod as varchar)='"&peri_ccod&"'  " & vbCrLf &_
			 "	order by Nombres "
'------------------------------------------------------------------------------------------------------fin_Nueva consulta 2008

'response.Write("<pre>"&profesores&"</pre>")
'response.end()
f_docentes.Consultar profesores


%>

<html>
<head>
<title>Listado de Docentes con datos faltantes</title>
<meta http-equiv="Content-Type" content="text/html;">
<style type="text/css">
<!--
.estilo1 {
font-family: Arial, Helvetica, sans-serif;
font-size: 12px;
color: #003366;
}
.estilo2 {
color: #990000;
font-weight: bold;
}
.estilo3 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #ffffff; }

.estilo4 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #000000; }
-->
</style>

</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="2">&nbsp;</td>
  </tr>
 <tr> 
    <td colspan="2"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Docentes con datos faltantes</font></div>
	  <div align="right"></div></td>
  </tr>
  <tr> 
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="2" align="left">Fecha Actual: <%=fecha_actual%></td>
  </tr>
  <tr> 
    <td colspan="2">&nbsp;</td>
  </tr>
</table>

<table width="100%" border="1">
    <tr borderColor="#999999" bgColor="#c4d7ff">
	  <td><FONT color="#333333">
	  <div align="center"><strong>N°</strong></div></font></td>
      <td><FONT color="#333333">
	  <div align="center"><strong>Rut</strong></div></font></td>
	  <td><FONT color="#333333">
	  <div align="center"><strong>Nombre docente</strong></div></font></td>
	  <td><FONT color="#333333">
	  <div align="center"><strong>Sexo</strong></div></font></td>
      <td><FONT color="#333333">
	  <div align="center"><strong>Estado civil</strong></div></font></td>
	  <td><FONT color="#333333">
	  <div align="center"><strong>País</strong></div></font></td>
    </tr>
	
	<% fila = 1
	 while f_docentes.siguiente %>
	<tr bgcolor="#FFFFFF">
		<td align="left"><div class="Estilo4"><%=fila%></td>
        <td align="left"><div class="Estilo4"><%=f_docentes.ObtenerValor("Rut")%></td>
		<td align="left"><div class="Estilo4"><%=f_docentes.ObtenerValor("Nombres")%></td>
		<td align="left"><div class="Estilo4"><%=f_docentes.ObtenerValor("Sexo")%></td>
		<td align="left"><div class="Estilo4"><%=f_docentes.ObtenerValor("Estado_civil")%></td>
		<td align="left"><div class="Estilo4"><%=f_docentes.ObtenerValor("Pais")%></td>
	</tr>
	<%fila = fila + 1
	  wend%>
</table>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>
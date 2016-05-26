<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
'pers_ncorr = request.querystring("pers_ncorr")
set conexion = new cConexion
set z = new cHorario

set negocio = new cnegocio

conexion.inicializar "upacifico"

negocio.inicializa conexion

set dsede		= new cformulario
dsede.inicializar		conexion
dsede.carga_parametros	"paulo.xml","tabla"

peri	= 	negocio.obtenerPeriodoAcademico("PLANIFICACION")
Sql="select pers_ncorr from personas where cast(pers_nrut as varchar)='"&negocio.obtenerUsuario&"'"
pers_ncorr=conexion.consultaUno(Sql)

sql_sede_ccod	=	"	select distinct   " & vbCrLf & _
					"		sede_ccod   " & vbCrLf & _
					"	from   " & vbCrLf & _
					"		bloques_profesores  " & vbCrLf & _
					"	where cast(pers_ncorr as varchar)='"& pers_ncorr &"' "
					
'response.Write("<pre>--------"&sql_sede_ccod&"</pre>")


session("sede") = conexion.consultauno(sql_sede_ccod)

'response.Write("sede " & negocio.ObtenerSede & "<br>")
'pers_ncorr="16128"
'response.Write(pers_ncorr&"<----<br>")
'response.Write(peri&"<----<br>")

docente			=	conexion.consultauno("select pers_tape_paterno+' '+pers_tape_materno+', '+ pers_tnombre as docente from personas where cast(pers_ncorr as varchar)='"& pers_ncorr &"'")

rut				=	conexion.consultauno("select cast(pers_nrut as varchar)+'-'+ pers_xdv  as rut from personas where cast(pers_ncorr as varchar)='"& pers_ncorr &"'")

sede			=	"	select distinct   " & vbCrLf & _
					"		b.sede_tdesc   " & vbCrLf & _
					"	from   " & vbCrLf & _
					"		bloques_profesores a, sedes b  " & vbCrLf & _
					"	where  " & vbCrLf & _
					"		a.sede_ccod=b.sede_ccod  " & vbCrLf & _
					"		and cast(a.pers_ncorr as varchar)='"& pers_ncorr &"'"
					

dsede.consultar	sede
'response.Write("<pre>"&sede&"</pre>")				

fecha			=	conexion.consultauno("select convert(datetime,getDate(),103) as fecha")
peri_tdesc			=	conexion.consultauno("select protic.initcap(peri_tdesc) from periodos_Academicos where cast(peri_ccod as varchar)='"&peri&"'")
sql_finicio ="	select convert(datetime,min(bloq_finicio_modulo),103) as finicio" & vbCrLf & _
				"	from  " & vbCrLf & _
				"		bloques_horarios a, " & vbCrLf & _
				"		secciones b,bloques_profesores c  " & vbCrLf & _
				"	where a.secc_ccod=b.secc_ccod " & vbCrLf & _
				" 		and a.bloq_ccod = c.bloq_ccod " & vbCrLf & _
				"		and cast(peri_ccod as varchar)='"& peri &"'" & vbCrLf & _
				"		and cast(c.pers_ncorr as varchar)='"&pers_ncorr&"' "
									
finicio			=	conexion.consultauno(sql_finicio)

sql_ftermino = "	select convert(datetime,max(bloq_ftermino_modulo),103) as ftermino" & vbCrLf & _
				"	from  " & vbCrLf & _
				"		bloques_horarios a, " & vbCrLf & _
				"		secciones b,bloques_profesores c  " & vbCrLf & _
				"	where a.secc_ccod=b.secc_ccod " & vbCrLf & _
				" 		and a.bloq_ccod = c.bloq_ccod " & vbCrLf & _
				"		and cast(peri_ccod as varchar)='"& peri &"'" & vbCrLf & _
				"		and cast(c.pers_ncorr as varchar)='"&pers_ncorr&"' "
									
ftermino		=	conexion.consultauno(sql_ftermino)


'response.Write("<pre>"&sql_finicio&"</pre>")
'response.Write("<pre>"&sql_ftermino&"</pre>")

z.inicializa 		conexion
z.generaHorario		pers_ncorr,finicio,ftermino,"docente"
%>
<script language="javascript" >
function salir(){
window.navigate("../lanzadera/lanzadera.asp")
}
</script> 
<html>
<head>
<title>Carga Horaria</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_inicio.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

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
.Estilo1 {font-size: large}
-->
</style>
</head>
<body>
<h1 align="right"><font size="4">UPACÍFICO</font></h1>
<table width="50%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="21%" nowrap> 
      <h1>Carga Horaria</h1></td>
    <td width="79%">&nbsp;</td>
  </tr>
</table>

<br>
<font size="1" face="Verdana, Arial, Helvetica, sans-serif"> </font> 
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="6%" valign="top" widt="10"><font size="2">Docente</font></td>
    <td width="31%" valign="top"><font size="2">: <strong><%=ucase(docente)%></strong></font></td>
    <td width="16%" valign="top" widt="10"><font size="2">Fecha</font></td>
    <td width="1%" valign="top"><font size="2">: </font></td>
    <td width="46%"><font size="2"><strong><%=ucase(fecha)%></strong></font></td>
  </tr>
  <tr> 
    <td valign="top" widt="10"><font size="2">Rut</font></td>
    <td valign="top"><font size="2">: <strong><%=rut%></strong></font></td>
    <td valign="top"> <%if dsede.nrofilas > 1 then%> <font size="2"> Sedes</font> <%else%> <font size="2">Sede</font> <%end if%> </td>
    <td valign="top"><font size="2">:</font> </td>
    <td> <%if dsede.nrofilas > 0 then	%> <font size="2"><strong> 
      <%
	for i=0 to dsede.nrofilas-1
		dsede.siguiente
		cadena = dsede.obtenervalor("sede_tdesc")&"<br>"
		response.write(cadena)
	next
		%>
      </strong></font> <%end if%> </td>
  </tr>
  <tr> 
    <td width="6%" valign="top" widt="10"><font size="2">Periodo</font></td>
    <td width="31%" valign="top"><font size="2">: <strong><%=ucase(peri_tdesc)%></strong></font></td>
    <td width="16%" valign="top" widt="10"><font size="2">&nbsp;</font></td>
    <td width="1%" valign="top"><font size="2">&nbsp; </font></td>
    <td width="46%"><font size="2"><strong>&nbsp;</strong></font></td>
  </tr>
</table><p>&nbsp;</p>
<div align="right" class="noprint">
  <button name="Button" value="Imprimir Horario" onClick="print()" > Imprimir 
  </button>&nbsp;&nbsp;&nbsp;
<button name="Button" value="Salir" onClick="javascript:salir()" >
&nbsp;&nbsp;Salir&nbsp;&nbsp;
</button>
</div>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
  </tr>
</table>
<%  
z.dibuja
%>
</body>
</html>
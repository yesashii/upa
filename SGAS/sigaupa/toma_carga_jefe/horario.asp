<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
matr_ncorr = request.QueryString("matr_ncorr")
if matr_ncorr = "" then
	matr_ncorr="0"
end if

set conexion = new cConexion
set z = new cHorario
set negocio = new cnegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

session("sede") = negocio.obtenerSede


alumno = conexion.consultaUno("select pers_tape_paterno + ' ' + pers_tape_materno + ', ' + pers_tnombre from alumnos a, personas b where a.pers_ncorr=b.pers_ncorr and cast(a.matr_ncorr as varchar)='" & matr_ncorr & "' ")
fecha = conexion.consultaUno("select convert(varchar,getdate(),103)")
semestre = conexion.consultaUno("select peri_tdesc from alumnos a, ofertas_academicas b, periodos_academicos c where a.ofer_ncorr=b.ofer_ncorr and b.peri_ccod=c.peri_ccod and cast(a.matr_ncorr as varchar)='" & matr_ncorr & "' ")
sede = conexion.consultaUno("select sede_tdesc from alumnos a, ofertas_academicas b, sedes c where a.ofer_ncorr=b.ofer_ncorr and b.sede_ccod=c.sede_ccod and cast(a.matr_ncorr as varchar) ='" & matr_ncorr & "' ")
carrera = conexion.consultaUno("select carr_tdesc from alumnos a, planes_estudio b, especialidades c, carreras d where a.plan_ccod=b.plan_ccod and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod and cast(a.matr_ncorr as varchar) ='" & matr_ncorr & "' ")
z.inicializa conexion
z.generaHorario matr_ncorr,"","","alumno"
%>
<html>
<head>
<title>Carga Académica</title>
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
.Estilo1 {font-size: large}
-->
</style>
</head>
<body bgcolor="#FFFFFF">
<h1 align="right"><font size="4">UPA</font></h1>
<h2 class="Estilo1">Carga Acad&eacute;mica</h2>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="10%" widt="10"><font size="2"><strong>Alumnos</strong></font></td>
    <td width="47%"><font size="2">: <%=ucase(alumno)%></font></td>
    <td width="6%" widt="10"><font size="2"><strong>Fecha</strong></font></td>
    <td width="37%"><font size="2">: <%=ucase(fecha)%></font></td>
  </tr>
  <tr> 
    <td><font size="2"><strong>Semestre</strong></font></td>
    <td><font size="2">: <%=ucase(semestre)%></font></td>
    <td><font size="2"><strong>Sede</strong></font></td>
    <td><font size="2">: <%=ucase(sede)%></font></td>
  </tr>
  <tr>
    <td><font size="2"><strong>Carrera</strong></font></td>
    <td><font size="2">: <%=ucase(carrera)%></font></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
<div align="right" class="noprint">
<button name="Button" value="Imprimir Horario" onClick="print()" >
Imprimir
</button>
</div>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td><font color="000000" size="1">&quot;Te informamos que esta carga acad&eacute;mica 
      est&aacute; sujeta a eventuales modificaciones.&quot;</font></td>
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

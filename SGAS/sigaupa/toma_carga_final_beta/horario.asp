<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
matr_ncorr = request.QueryString("matr_ncorr")
sede_seleccionada = request.querystring("sede[0][sede_ccod]")
'response.Write(matr_ncorr)
if matr_ncorr = "" then
	matr_ncorr="0"
end if

set conexion = new cConexion
set z = new cHorario
set negocio = new cnegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

'session("sede") = negocio.obtenerSede


set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "toma_carga_alfa.xml", "combo_sedes"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 
 sedes_matricula="select distinct c.sede_ccod,c.sede_tdesc from cargas_academicas a,secciones b, sedes c where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.secc_ccod=b.secc_ccod and b.sede_ccod=c.sede_ccod"
 'if  EsVacio(carr_ccod) then
 ' 		f_busqueda.Agregacampoparam "carr_ccod", "filtro" , "1=2"
 'end if
 f_busqueda.agregaCampoParam "sede_ccod","destino","("&sedes_matricula&")a"
 f_busqueda.AgregaCampoCons "sede_ccod", sede_seleccionada 
 f_busqueda.Siguiente
'peri_actual = negocio.obtenerPeriodoAcademico("TOMACARGA")

 cantidad_sedes = conexion.consultaUno("select count(*) from ("&sedes_matricula&")a")
 
 
 
 if cantidad_sedes > "0" and sede_seleccionada="" then
 	sede_ccod = conexion.consultaUno("select sede_ccod from ("&sedes_matricula&")a")
	session("nueva_sede") = sede_ccod
 elseif cantidad_sedes = "0" and sede_seleccionada= "" then
	session("nueva_sede") = negocio.obtenerSede
 	sede = conexion.consultaUno("select sede_tdesc from alumnos a, ofertas_academicas b, sedes c where a.ofer_ncorr=b.ofer_ncorr and b.sede_ccod=c.sede_ccod and cast(a.matr_ncorr as varchar)='" & matr_ncorr & "' ")
 elseif sede_seleccionada <> "" then
 	session("nueva_sede") = sede_seleccionada
 end if 
 

alumno = conexion.consultaUno("select cast(pers_tape_paterno as varchar) + ' ' + cast(pers_tape_materno as varchar) + ', ' + cast(pers_tnombre as varchar) from alumnos a, personas b where a.pers_ncorr=b.pers_ncorr and cast(a.matr_ncorr as varchar)='" & matr_ncorr & "' ")
rut_alumno = conexion.consultaUno("select cast(b.pers_nrut as varchar)+ '-' + b.pers_xdv as rut from alumnos a, personas b where a.pers_ncorr=b.pers_ncorr and cast(a.matr_ncorr as varchar)='" & matr_ncorr & "' ")
fecha_actual = conexion.consultauno("select convert(smalldatetime,getDate(),103) as fecha")
'fecha = conexion.consultaUno("select convert(datetime,getDate(),103)")
semestre = conexion.consultaUno("select cast(peri_tdesc as varchar)+ ', ' + cast(anos_ccod as varchar) from alumnos a, ofertas_academicas b, periodos_academicos c where a.ofer_ncorr=b.ofer_ncorr and b.peri_ccod=c.peri_ccod and cast(a.matr_ncorr as varchar)='" & matr_ncorr & "' ")
carrera = conexion.consultaUno("select carr_tdesc from alumnos a, planes_estudio b, especialidades c, carreras d where a.plan_ccod=b.plan_ccod and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod and cast(a.matr_ncorr as varchar)='" & matr_ncorr & "' ")

'********************************************************************
'------PERIODO ACTUAL A PARTIR DE MATR_CORR-------------
peri_actual = conexion.consultaUno("select b.peri_ccod as periodo" & vbCrLf & _
		"	from alumnos a, postulantes b" & vbCrLf & _
		"	where 	a.matr_ncorr='" & matr_ncorr & "' " & vbCrLf & _
		"			and a.post_ncorr=b.post_ncorr" & vbCrLf & _
		"			and a.pers_ncorr=b.pers_ncorr")

'response.Write("periodo lectivo :" & peri_actual)		
'response.End()
'-----------------------------------------------------------
'-------------PERS_NCORR A PARTIR DEL MATR_NCORR--------------
'pers_ncorr = conexion.consultaUno("select b.pers_ncorr as pers_ncorr " & vbCrLf & _
'		"	from alumnos a, postulantes b " & vbCrLf & _
'   	"	where 	a.matr_ncorr='" & matr_ncorr & "' " & vbCrLf & _
'	  	"			and a.post_ncorr=b.post_ncorr" & vbCrLf & _
'	    "			and a.pers_ncorr=b.pers_ncorr")
		
'response.Write("pers_ncorr :" & pers_ncorr)
'RESPONSE.End()
'------------------------------------------------------------------------	
'-----------------MATR_CCOD DEL PERODO ANTERIOR A PARTIR DE PERS_NCORR-------------
'matr_ant = conexion.consultaUno("select a.matr_ncorr as perido " & vbCrLf & _
' 		"	from alumnos a, postulantes b" & vbCrLf & _
'		"	where 	b.peri_ccod=164 " & vbCrLf & _
'		"   		and a.post_ncorr=b.post_ncorr" & vbCrLf & _
'		"   		and a.pers_ncorr=b.pers_ncorr" & vbCrLf & _
'		"   		and a.pers_ncorr='" & pers_ncorr & "' ")
		
'response.Write("periodo anterior :" & matr_ant)
'response.End()

'------------------------------------------------------------------------
'**********************************************************************

set f_consulta = new CFormulario
f_consulta.Carga_Parametros "consulta.xml", "consulta"
f_consulta.Inicializar conexion

consulta = 	"select convert(datetime,min(a.bloq_finicio_modulo), 103) as finicio, convert(datetime,max(a.bloq_ftermino_modulo),103) as ftermino " & vbCrLf &_
		  	"	from bloques_horarios a, secciones b, periodos_academicos c , cargas_Academicas d " & vbCrLf &_
			"	where a.secc_ccod = b.secc_ccod  and  b.peri_ccod = c.peri_ccod" & vbCrLf &_
			"	and d.secc_ccod=b.secc_ccod and cast(d.matr_ncorr as varchar)='" & matr_ncorr & "'" & vbCrLf &_
			"	and cast(c.peri_ccod as varchar) = '"& peri_actual &"' "
'response.Write("<pre>"&consulta&"</pre>")	       
f_consulta.Consultar consulta
f_consulta.Siguiente

finicio = f_consulta.ObtenerValor("finicio")
ftermino = f_consulta.ObtenerValor("ftermino")

'response.Write("periodo lectivo <pre>:" & peri_actual& "</pre>")
'response.Write("fecha inicio periodo:<pre>"&finicio&"</pre>")
'response.Write("fecha termino periodo:<pre>"&ftermino&"</pre>")
'response.Write("N Matricula:<pre>"&matr_ncorr&"</pre>")

z.inicializa conexion
z.generaHorario matr_ncorr,finicio,ftermino,"alumno"

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
<script language="JavaScript">
function re_envia(){
           var formulario = document.edicion;
		   //var sede = formulario.elements["[]"]
		   	formulario.action ="horario.asp";
			formulario.submit();
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
<h1 align="right"><font size="4">UPACIFICO</font></h1>
<h1>Carga Acad&eacute;mica</h1>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="10%" widt="10"><font size="2"><strong>Alumno</strong></font></td>
    <td width="47%"><font size="2">: <%=ucase(alumno)%></font></td>
    <td width="6%" widt="10"><font size="2"><strong>RUT</strong></font></td>
    <td width="37%"><font size="2">: <%=rut_alumno%></font></td>
  </tr>
  <form name="edicion" method="get">
  <tr> 
    <td><font size="2"><strong>Semestre</strong></font><input type="hidden" name="matr_ncorr" value="<%=matr_ncorr%>"></td>
    <td><font size="2">: <%=ucase(semestre)%></font></td>
    <td><font size="2"><strong>Sede</strong></font></td>
    <td><font size="2">: <% if cantidad_sedes > "0" then
								f_busqueda.dibujaCampo ("sede_ccod")
							else
	                        	response.Write(ucase(sede))
							end if%></font></td>
  </tr>
  </form>
  <tr>
    <td><font size="2"><strong>Carrera</strong></font></td>
    <td><font size="2">: <%=ucase(carrera)%></font></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><font size="2"><strong>Fecha</strong></font></td>
    <td><font size="2">: <%=ucase(fecha_actual)%></font></td>
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
<br>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="20%" align="center">&nbsp;</td>
	<td width="60%" align="center">&nbsp;</td>
	<td width="20%" align="center">&nbsp;</td>
  </tr>
   <tr> 
    <td width="20%" align="center">&nbsp;</td>
	<td width="60%" align="center">&nbsp;</td>
	<td width="20%" align="center">&nbsp;</td>
  </tr>
  <tr> 
    <td width="20%" align="center">&nbsp;</td>
	<td width="60%" align="center">&nbsp;</td>
	<td width="20%" align="center">&nbsp;</td>
  </tr>
    <tr> 
    <td width="20%" align="center">&nbsp;</td>
	<td width="60%" align="center">&nbsp;</td>
	<td width="20%" align="center">&nbsp;</td>
  </tr>
    <tr> 
    <td width="20%" align="center">&nbsp;</td>
	<td width="60%" align="center">&nbsp;</td>
	<td width="20%" align="center">&nbsp;</td>
  </tr>
    <tr> 
    <td width="20%" align="center">&nbsp;</td>
	<td width="60%" align="center">&nbsp;</td>
	<td width="20%" align="center">&nbsp;</td>
  </tr>
    <tr> 
    <td width="20%" align="center">&nbsp;</td>
	<td width="60%" align="center">&nbsp;</td>
	<td width="20%" align="center">&nbsp;</td>
  </tr>
  
  <tr> 
    <td width="20%" align="center"><font color="#000000" face="Arial, Helvetica, sans-serif"><strong>____________________________________</strong></font></td>
	<td width="60%" align="center">&nbsp;</td>
	<td width="20%" align="center"><font color="#000000" face="Arial, Helvetica, sans-serif"><strong>____________________________________</strong></font></td>
  </tr>
  <tr> 
    <td width="20%" align="center"><font color="#000000" face="Arial, Helvetica, sans-serif" size="2"><strong>Encargado Escuela</strong></font></td>
	<td width="60%" align="center">&nbsp;</td>
	<td width="20%" align="center"><font color="#000000" face="Arial, Helvetica, sans-serif" size="2"><strong>Alumno</strong></font></td>
  </tr>
</table>
</body>
</html>

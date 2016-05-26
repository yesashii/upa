<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%

'for each k in request.QueryString
'	response.Write(k&" = "&request.QueryString(k)&"<br>")
'next
'response.End()
carr_ccod = request.QueryString("carr_ccod")
plan_ccod = request.QueryString("plan_ccod")
espe_ccod = request.QueryString("espe_ccod")
nive_ccod = request.QueryString("nive_ccod")
seccion_tdesc = request.QueryString("secc_tdesc")
if not esVacio(seccion_tdesc) then
	mensaje_seccion = seccion_tdesc
else
    mensaje_seccion = "Todas"
end if		

'response.Write("<br>carr_ccod "&carr_ccod&" plan_ccod "&plan_ccod&" espe_ccod "&espe_ccod&" nive_ccod "&nive_ccod)
set conexion = new cConexion
set z = new cHorario
set negocio = new cnegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

session("sede") = negocio.obtenerSede


carrera = conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")
vfecha = conexion.consultaUno("select convert(datetime,getDate(),103)")
plan = conexion.consultaUno("select plan_tdesc from planes_estudio where cast(plan_ccod as varchar)='"&plan_ccod&"'")
especialidad = conexion.consultaUno("select espe_tdesc from especialidades where cast(espe_ccod as varchar)='"&espe_ccod&"'")
nivel = conexion.consultaUno("select nive_tdesc from niveles where cast(nive_ccod as varchar)='"&nive_ccod&"'")

'buscamos el periodo para hacer la planificación en caso de que de esta se trate la actividad
usuario_paso=negocio.obtenerUsuario
autorizada = conexion.consultaUno("select isnull(count(*),0) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and b.srol_ncorr=72 and cast(a.pers_nrut as varchar)='"&usuario_paso&"'")
actividad = session("_actividad")
'response.Write("actividad "&actividad&" autorizada "&autorizada)
'if ((actividad = "6") and (autorizada > "0")) then
'	periodo = session("_periodo")
'else
periodo =  negocio.obtenerPeriodoAcademico("PLANIFICACION")
'end if
peri =  negocio.obtenerPeriodoAcademico("CLASES18")

peri_tdesc  = conexion.consultaUno("select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")


sede = negocio.obtenerSede


if nive_ccod <> "" and carr_ccod <> "" and espe_ccod <> "" and plan_ccod <> "" then
	filtro= "cast(c.carr_ccod as varchar)='" & carr_ccod & "' and cast(a.nive_ccod as varchar)='" & nive_ccod & "' and cast(c.espe_ccod as varchar)='" & espe_ccod & "' and cast(b.plan_ccod as varchar)= '"& plan_ccod & "'"
else
	filtro = " 1=2 "
end if


'**********************************************Agregar la cadena de secciones pal horario*****************************
'********************************************************MSANDOVAL 25/01/2005*****************************************
consulta_secc_ccod="select a.secc_ccod " & vbCrLf & _
               " from ( " & vbCrLf & _   
               " select secc_ccod, secc_tdesc, c.asig_ccod, asig_tdesc, asig_nhoras, sede_ccod, peri_ccod " & vbCrLf & _
               " from ( " & vbCrLf & _
                  " select asig_ccod  " & vbCrLf & _
                  " from  " & vbCrLf & _
                  " malla_curricular a " & vbCrLf & _
                  " , planes_estudio b " & vbCrLf & _
                  " , especialidades c " & vbCrLf & _
                  " where " & vbCrLf & _
                  " a.plan_ccod=b.plan_ccod " & vbCrLf & _
                  " and b.espe_ccod=c.espe_ccod " & vbCrLf & _
                  " and "& filtro & vbCrLf & _
                  " ) a " & vbCrLf & _
                  " , secciones b " & vbCrLf & _
                  " , asignaturas c " & vbCrLf & _
                  " where " & vbCrLf & _
                  " a.asig_ccod=b.asig_ccod " & vbCrLf & _
                  " and a.asig_ccod=c.asig_ccod and secc_finicio_sec is not null and secc_ftermino_sec is not null" & vbCrLf & _
                  " and cast(sede_ccod as varchar)= '"& sede & "'" &  vbCrLf & _
                  " and cast(peri_ccod as varchar)= case duas_ccod when 3 then '"&peri&"' else '"& periodo &"' end" &  vbCrLf & _
				  " and cast(b.carr_ccod as varchar)='" & carr_ccod & "' " & vbCrLf &_
                " ) a, bloques_horarios b " & vbCrLf & _
                " WHERE a.secc_ccod = b.secc_ccod  " 
				if not esVacio(seccion_tdesc) then
					 consulta_secc_ccod = consulta_secc_ccod & " and a.secc_tdesc='"&seccion_tdesc&"' "
				end if				
                consulta_secc_ccod = consulta_secc_ccod &" GROUP BY a.secc_ccod,a.asig_ccod,a.secc_tdesc,asig_tdesc,a.sede_ccod,peri_ccod,asig_nhoras,protic.horario (b.secc_ccod)" 

set f_secc_ccod= new cformulario
f_secc_ccod.carga_parametros "paulo.xml", "pl_academica2"
f_secc_ccod.agregaCampoParam "Asignatura_Seccion","consulta", filtro
f_secc_ccod.inicializar conexion
f_secc_ccod.consultar consulta_secc_ccod

'response.Write("<pre>"&consulta_secc_ccod&"</pre>")
contador_secc=0
cadena_secc_ccod = "("
while f_secc_ccod.siguiente
	if contador_secc=0 then
	   cadena_secc_ccod=cadena_secc_ccod & "'"&f_secc_ccod.obtenerValor("secc_ccod")&"'"
    else
	   cadena_secc_ccod=cadena_secc_ccod &",'"&f_secc_ccod.obtenerValor("secc_ccod") & "'"
	end if
	contador_secc=contador_secc + 1
wend
cadena_secc_ccod=cadena_secc_ccod & ")"

if cadena_secc_ccod= "()" then
	cadena_Secc_ccod = "('')"
end if
	
z.inicializa conexion
z.generaHorario cadena_secc_ccod,"","","carrera"
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
-->
</style>
</head>
<body bgcolor="#ffffff">
<h1 align="right"><font size="4">UPACIFICO</font></h1>
<h1>Carga Acad&eacute;mica</h1>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
   <tr>
    <td><font size="2"><strong>Fecha</strong></font></td>
    <td><font size="2">: <%=vfecha%></font></td>
    <td><font size="2"><strong>Periodo</strong></font></td>
    <td><font size="2">: <%=peri_tdesc%></font></td>
  </tr>
  <tr> 
    <td width="17%" widt="10"><font size="2"><strong>Carrera</strong></font></td>
    <td width="38%"><font size="2">: <%=ucase(carrera)%></font></td>
    <td width="10%" widt="10"><font size="2"><strong>Especialidad</strong></font></td>
    <td width="35%"><font size="2">: <%=ucase(especialidad)%></font></td>
  </tr>
  <tr> 
    <td><font size="2"><strong>Plan de Estudios</strong></font></td>
    <td><font size="2">: <%=ucase(plan)%></font></td>
    <td><font size="2"><strong>Nivel</strong></font></td>
    <td><font size="2">: <%=ucase(nivel)%></font></td>
  </tr>
  <tr> 
    <td><font size="2"><strong>Secci&oacute;n</strong></font></td>
    <td colspan="3"><font size="2">: <%=mensaje_seccion%></font></td>
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


<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
'-------------------------------------------------------debug<<
ip_usuario = Request.ServerVariables("REMOTE_ADDR")
'response.Write("ip_usuario = "&ip_usuario&"</br>")
'ip_de_prueba = "172.16.100.91"
ip_de_prueba = "172.16.100.127" 'luis herrera

'--------------------------------------------------------------
'    if ip_usuario = ip_de_prueba then
'    for each k in request.Form()
'	    response.Write(k&" = "&request.Form(k)&"<br>")
'    next
'    response.End()
'    end if
'-------------------------------------------------------debug<<
'---------------------debug>>
'    if ip_usuario = ip_de_prueba then
'    response.Write(" Entró:  "& v_secc_tdesc)
'    response.end()
'    end if
'---------------------debug<<



sala_ccod = request.querystring("test[0][sala_ccod]")

set conexion 	= new cConexion
set z 				= new cHorario
set negocio 	= new cnegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

set dsede = new cformulario
dsede.inicializar conexion
dsede.carga_parametros "paulo.xml","tabla"

'buscamos el periodo para hacer la planificación en caso de que de esta se trate la actividad
usuario_paso=negocio.obtenerUsuario


autorizada = conexion.consultaUno("select isnull(count(*),0) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and b.srol_ncorr=72 and cast(a.pers_nrut as varchar)='"&usuario_paso&"'")
actividad = session("_actividad")

peri = negocio.obtenerPeriodoAcademico("PLANIFICACION")

sql_sede_ccod	=	"select sede_ccod from salas where cast(sala_ccod as varchar) = '"&sala_ccod&"'"


session("sede") = conexion.consultauno(sql_sede_ccod)

'consultas_1 >>
c_sede_tdesc 	= ""& vbCrLf & _
"SELECT sede_tdesc                       										"& vbCrLf & _
"FROM   sedes                            										"& vbCrLf & _
"WHERE  Cast(sede_ccod AS VARCHAR) = '"&session("sede")&"' 	"

c_sala_tdesc 	= ""& vbCrLf & _
"SELECT Cast(sala_ciso AS VARCHAR) + ' '             				"& vbCrLf & _
"       + Cast(sala_tdesc AS VARCHAR)                				"& vbCrLf & _
"FROM   salas                                        				"& vbCrLf & _
"WHERE  Cast(sala_ccod AS VARCHAR) = '"&sala_ccod&"' 				"

c_semestre		= ""& vbCrLf & _
"SELECT peri_tdesc                              						"& vbCrLf & _
"FROM   periodos_academicos                     						"& vbCrLf & _
"WHERE  Cast(peri_ccod AS VARCHAR) = '"&peri&"'							"

c_sala_ncupo	= ""& vbCrLf & _
"SELECT sala_ncupo                                          "& vbCrLf & _
"FROM   salas                                               "& vbCrLf & _
"WHERE  Cast(sala_ccod AS VARCHAR) = '"&sala_ccod&"'        "

c_fecha2 = "SELECT CONVERT(SMALLDATETIME, Getdate(), 103) AS fecha "




if ip_usuario = ip_de_prueba then response.Write("<pre>"&c_sala_ncupo&"</pre>") ' DEBUG

sede_tdesc 	= conexion.consultauno(c_sede_tdesc)    'variable
sala_tdesc 	= conexion.consultauno(c_sala_tdesc)    'variable
semestre 		= conexion.consultaUno(c_semestre)      'variable
sala_ncupo 	= conexion.consultauno(c_sala_ncupo)    'variable
fecha2			=	conexion.consultauno(c_fecha2)        'ej: 30-11-2015 16:53:00
'consultas_1 <<
if ip_usuario = ip_de_prueba then response.Write("<pre>fecha2: "&fecha2&"</pre>") ' DEBUG

set f_consulta = new CFormulario
f_consulta.Carga_Parametros "consulta.xml", "consulta"
f_consulta.Inicializar conexion

consulta = "" & vbCrLf &_
"SELECT CONVERT(DATETIME, Min(a.bloq_finicio_modulo), 103)  AS finicio, "& vbCrLf & _
"       CONVERT(DATETIME, Max(a.bloq_ftermino_modulo), 103) AS ftermino "& vbCrLf & _
"FROM   bloques_horarios a,                                             "& vbCrLf & _
"       secciones b                                                     "& vbCrLf & _
"WHERE  a.secc_ccod = b.secc_ccod                                       "& vbCrLf & _
"       AND Cast(b.peri_ccod AS VARCHAR) = '"&peri&"'                   "& vbCrLf & _
"       AND Cast(a.sala_ccod AS VARCHAR) = '"&sala_ccod&"'              "

if ip_usuario = ip_de_prueba then response.Write("<pre>consulta: "&consulta&"</pre>") ' DEBUG

f_consulta.Consultar consulta
f_consulta.Siguiente

finicio   = f_consulta.ObtenerValor("finicio")
ftermino  = f_consulta.ObtenerValor("ftermino")

if ip_usuario = ip_de_prueba then response.Write("<pre>finicio: "&finicio&"</pre>") ' DEBUG
if ip_usuario = ip_de_prueba then response.Write("<pre>ftermino: "&ftermino&"</pre>") ' DEBUG


z.inicializa 		conexion
z.generaHorario		sala_ccod,finicio,ftermino,"SALA"


%><html>
<head>
<title>Carga Académica</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_inicio.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript1.2" src="tabla.js"></script>

<script language="JavaScript" >

function volver()
{
  var sala = '<%=sala_ccod%>';
  location.href="horarios_salas_sedes.asp?sala_ccod="+sala;
}

function generar()
{
  var sala = '<%=sala_ccod%>';
  location.href="horario_sala_excel.asp?sala_ccod="+sala;
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
.Estilo1 {font-size: large}
-->
</style>
</head>
<body bgcolor="#FFFFFF">
<h1 align="right"><font size="4">UPACIFICO</font></h1>
<h2 class="Estilo1">Horario Sala</h2>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="15%" widt="10"><font size="2"><strong>Sala</strong></font></td>
    <td width="42%"><font size="2">: <%=sala_tdesc%></font></td>
    <td width="6%" widt="10"><font size="2"><strong>Fecha</strong></font></td>
    <td width="37%"><font size="2">: <%=fecha2%> </font></td>
  </tr>
  <tr>
    <td><font size="2"><strong>Periodo</strong></font></td>
    <td><font size="2">: <%=semestre%> </font></td>
    <td><font size="2"><strong>Sede</strong></font></td>
    <td><font size="2">: <%=sede_tdesc%></font></td>
  </tr>
  <tr>
    <td><font size="2"><strong>Ocupada entre</strong></font></td>
    <td><font size="2">: <%=finicio%> y <%=ftermino%> </font></td>
    <td><font size="2"><strong>Cupos</strong></font></td>
    <td><font size="2">: <%=sala_ncupo%></font></td>
  </tr>
</table>
<div align="center" class="noprint">
<button name="Button" value="Imprimir Horario" onClick="print()" >Imprimir</button>&nbsp;&nbsp;
<button name="Button" value="Volver" onClick="volver()" >Volver</button>&nbsp;&nbsp;
<button name="Button" value="Generar_Excel" onClick="generar()" >Generar Excel</button>
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

<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
sala_ccod = request.querystring("test[0][sala_ccod]")

set conexion = new cConexion
set z = new cHorario
set negocio = new cnegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

set dsede		= new cformulario
dsede.inicializar		conexion
dsede.carga_parametros	"paulo.xml","tabla"

'buscamos el periodo para hacer la planificación en caso de que de esta se trate la actividad
usuario_paso=negocio.obtenerUsuario
autorizada = conexion.consultaUno("select isnull(count(*),0) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and b.srol_ncorr=72 and cast(a.pers_nrut as varchar)='"&usuario_paso&"'")
actividad = session("_actividad")
'response.Write("actividad "&actividad&" autorizada "&autorizada)
if ((actividad = "6") and (autorizada > "0")) then
	peri = session("_periodo")
else
	peri = negocio.obtenerPeriodoAcademico("PLANIFICACION")
end if

ano = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri&"'")

sql_sede_ccod	=	"select sede_ccod from salas where cast(sala_ccod as varchar) = '"&sala_ccod&"'"					

session("sede") = conexion.consultauno(sql_sede_ccod)
sede_tdesc = conexion.consultauno("select sede_tdesc from sedes where cast(sede_ccod as varchar)= '"&session("sede")&"'")
sala_tdesc = conexion.consultauno("select cast(sala_ciso as varchar)+' '+cast(sala_tdesc as varchar) from salas where cast(sala_ccod as varchar) ='"&sala_ccod&"'")
semestre = conexion.consultaUno("select peri_tdesc from periodos_academicos  where cast(peri_ccod as varchar)='" & peri & "' ")
fecha2 = conexion.consultauno("select convert(smalldatetime,getDate(),103) as fecha")
sala_ncupo = conexion.consultauno("select sala_ncupo from salas where cast(sala_ccod as varchar) ='"&sala_ccod&"'")



set f_consulta = new CFormulario
f_consulta.Carga_Parametros "consulta.xml", "consulta"
f_consulta.Inicializar conexion

consulta = 	"select convert(datetime,min(c.peri_finicio_periodo), 103) as finicio, convert(datetime,max(a.bloq_ftermino_modulo),103) as ftermino " & vbCrLf &_
		  	"	from bloques_horarios a, secciones b, periodos_academicos c " & vbCrLf &_
			"	where a.secc_ccod = b.secc_ccod  " & vbCrLf &_
			"	and b.peri_ccod = c.peri_ccod  " & vbCrLf &_
			"	and cast(c.peri_ccod as varchar) = '"& peri &"' and cast(c.anos_ccod as varchar)='"&ano&"'" & vbCrLf &_
	       	"	and cast(a.sala_ccod as varchar) = '"& sala_ccod &"' "

'response.Write("<pre>"&consulta&"</pre>")
'response.Write("<pre>"&sql_finicio&"</pre>")
'response.Write("<pre>"&sql_ftermino&"</pre>")

f_consulta.Consultar consulta
f_consulta.Siguiente

finicio = f_consulta.ObtenerValor("finicio")
ftermino = f_consulta.ObtenerValor("ftermino")

'response.Write("PERIODO :"&peri&"</pre>")
'response.Write("FECHA INICIO :"&finicio&"</pre>")
'response.Write("FECHA TERMINO :"&ftermino&"</pre>")
		
z.inicializa conexion
z.generaHorario	sala_ccod,finicio,ftermino,"SALA_PERIODO"

%><html>
<head>
<title>Horario de la sala para el periodo</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_inicio.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript1.2" src="tabla.js"></script>
<script language="JavaScript" >
function volver(){
var sala = '<%=sala_ccod%>';
location.href="horarios_salas_sedes.asp?sala_ccod="+sala;
}
function generar(){
var sala = '<%=sala_ccod%>';
location.href="horario_sala_periodo_excel.asp?sala_ccod="+sala;
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
<h2 class="Estilo1">Horario Sala para el Periodo </h2>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="10%" widt="10"><font size="2"><strong>Sala</strong></font></td>
    <td width="47%"><font size="2">: <%=sala_tdesc%></font></td>
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
    <td><font size="2"><strong>Cupos</strong></font></td>
    <td><font size="2">: <%=sala_ncupo%> </font></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
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

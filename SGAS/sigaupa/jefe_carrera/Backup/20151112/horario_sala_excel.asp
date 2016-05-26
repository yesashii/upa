<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
Response.AddHeader "Content-Disposition", "attachment;filename=horario_sala.xls"
Response.ContentType = "application/vnd.ms-excel"

sala_ccod = request.querystring("sala_ccod")

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
'if ((actividad = "6") and (autorizada > "0")) then
'	peri = session("_periodo")
'else
peri = negocio.obtenerPeriodoAcademico("PLANIFICACION")
'end if
'peri =  negocio.obtenerPeriodoAcademico("PLANIFICACION")
'peri			= 	negocio.obtenerPeriodoAcademico("PLANIFICACION")

'response.Write(peri)
if request.Form("de_soporte") = "si" then
	sala_ccod = request.Form("salas[0][sala_ccod]")
	peri	  = request.Form("peri")
end if

sql_sede_ccod	=	"select sede_ccod from salas where cast(sala_ccod as varchar) = '"&sala_ccod&"'"					

session("sede") = conexion.consultauno(sql_sede_ccod)
sede_tdesc = conexion.consultauno("select sede_tdesc from sedes where cast(sede_ccod as varchar)= '"&session("sede")&"'")
sala_tdesc = conexion.consultauno("select cast(sala_ciso as varchar)+' '+cast(sala_tdesc as varchar) from salas where cast(sala_ccod as varchar) ='"&sala_ccod&"'")
semestre = conexion.consultaUno("select peri_tdesc from periodos_academicos  where cast(peri_ccod as varchar)='" & peri & "' ")
sala_ncupo = conexion.consultauno("select sala_ncupo from salas where cast(sala_ccod as varchar) ='"&sala_ccod&"'")

fecha2			=	conexion.consultauno("select convert(smalldatetime,getDate(),103) as fecha")

set f_consulta = new CFormulario
f_consulta.Carga_Parametros "consulta.xml", "consulta"
f_consulta.Inicializar conexion

consulta = "select convert(datetime,min(a.bloq_finicio_modulo), 103) as finicio, convert(datetime,max(a.bloq_ftermino_modulo),103) as ftermino " & vbCrLf &_
           "from bloques_horarios a, secciones b--, periodos_academicos c, periodos_academicos d " & vbCrLf &_
		   "where a.secc_ccod = b.secc_ccod  " & vbCrLf &_
		   "  --and b.peri_ccod = c.peri_ccod  " & vbCrLf &_
		   "  --and c.anos_ccod = d.anos_ccod " & vbCrLf &_
		   "  and cast(b.peri_ccod as varchar) = '" & peri & "' " & vbCrLf &_
		   "  and cast(a.sala_ccod as varchar) = '" & sala_ccod & "' "

'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_consulta.Consultar consulta
f_consulta.Siguiente

finicio = f_consulta.ObtenerValor("finicio")
ftermino = f_consulta.ObtenerValor("ftermino")

				
z.inicializa 		conexion
z.generaHorario		sala_ccod,finicio,ftermino,"SALA"
%><html>
<head>
<title>Carga Académica</title>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript1.2" src="tabla.js"></script>
<script language="JavaScript" >
function volver(){
var sala = '<%=sala_ccod%>';
location.href="horarios_salas_sedes.asp?sala_ccod="+sala;
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
  </tr>
  <tr> 
    <td width="15%" widt="10"><font size="2"><strong>Fecha</strong></font></td>
    <td width="42%"><font size="2">: <%=fecha2%></font></td>
  </tr>
  <tr> 
    <td><font size="2"><strong>Periodo</strong></font></td>
    <td><font size="2">: <%=semestre%> </font></td>
  </tr>
  <tr> 
    <td><font size="2"><strong>Sede</strong></font></td>
    <td><font size="2">: <%=sede_tdesc%></font></td>
  </tr>
  <tr> 
    <td><font size="2"><strong>Ocupada entre</strong></font></td>
    <td><font size="2">: <%=finicio%> y <%=ftermino%> </font></td>
  </tr>
  <tr> 
    <td><font size="2"><strong>Cupos</strong></font></td>
    <td><font size="2">: <%=sala_ncupo%></font></td>
  </tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <br>
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

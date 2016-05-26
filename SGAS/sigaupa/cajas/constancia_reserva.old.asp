<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_contrato = Request.QueryString("cont_ncorr")

set pagina = new CPagina
pagina.Titulo = "Constancia"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set errores = new CErrores

set negocio = new CNegocio
negocio.Inicializa conexion
	'v_periodo = negocio.ObtenerPeriodoAcademico("postulacion")
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "rendicion_cajas.xml", "botonera"

v_sede=session("sede")

if v_sede=4 then
	txt_sede="Melipilla"
else
	txt_sede="Santiago"
end if




'---------------------------------------------------------------------------------------------------
if q_contrato <> "" then
sql_anio_admision= "select anos_ccod "&_
					"from contratos a,periodos_academicos b "&_
					"where cast(a.cont_ncorr as varchar)='"&q_contrato&"' "&_
					"and a.peri_ccod=b.peri_ccod "

v_anio_admision=conexion.consultaUno(sql_anio_admision)

else

	sql_periodo="select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&v_periodo&"'"
	v_anio_admision=conexion.consultaUno(sql_periodo)
end if
'--------------------------------------------------------------------------------------------------

'response.Write(Day(date())& "-" &Month(date())& "-" & Year(date()))
v_anio=Year(date())
if Day(date())<9 then
	v_dia="0"&Day(date())
else
	v_dia=Day(date())
end if

if Month(date())<9 then
	v_mes="0"&Month(date())
else
	v_mes=Month(date())
end if

'response.Write("<br>"&v_dia)
'response.Write("<br>"&v_mes)
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_inicial.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">


<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script>
function imprimir()
{
  window.print();  
}
</script>
</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<style>
@media print{ .noprint {visibility:hidden; }}
</style>
<table width="600" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" >
	<br/>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" >
      <tr>
        <td>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              	<td valign="top">
					<table width="100%">
						<tr>
							<td width="15%"><img src="../imagenes/logo_upa_rojo_2011.png" /></td>
							<td width="75%"> <div align="center"></div></td>
							<td width="10%"></td>
						</tr>
					</table>  
				</td>
            </tr>
            <tr>
              <td>
				<BR/>
				<BR/>
				<BR/>
				<BR/>
				<DIV align="center"><font face="Verdana, Arial, Helvetica, sans-serif"><span style="color:#42424A; font-weight: bold; font-size: 17px">CONSTANCIA DE ENTREGA DOCUMENTACI&Oacute;N PROCESO MATRÍCULA <span style="line-height:18pt;font-size: 16px"><%=v_anio_admision%></span></span></font></DIV>
				<div align="left">
 				<br/>
                  <br/>
                  <br/>
                  	
                  <p align="justify" style="line-height:18pt;font-size: 16px">
					Yo, ....................................................... Rut ......................
					declara que en este acto procede a realizar una reserva de vacante para el año <b><%=v_anio_admision%></b>, para el (la) señor (ita) 
					........................................................,Rut ...................... 
					la que se formalizar&aacute; como matr&iacute;cula oficial una vez que se entregue la  totalidad de la documentaci&oacute;n que acredita el cumplimiento de los requisitos  legales y de admisi&oacute;n vigentes de la Universidad del Pac&iacute;fico para el a&ntilde;o <%=v_anio_admision%>, para acceder a la  carrera .................................................................. <br>Jornada ......................, Sede ............................. </p>
                </div>
                  <br>
              </td>
            </tr>
        </table></td>
      </tr>
      <tr>
        <td style="font-size: 13px ">
          <br/>
          <br/>          
          <p align="Left" style="line-height:18pt;font-size: 16px">Nombre  de quien firma la Constancia:………………………………………………</p>
          <br/>
          <br/>
          <br/>
          <center>___________________________________<br/> 
        FIRMA y RUT APODERADO y/o ALUMNO (a) 
          </center><br/>
        <p> Consultas: <strong>admision@upacifico.cl</strong> o <strong>ufe.cae@upacifico.cl</strong> </p>
          <p style="font-size: 12px "><%=txt_sede%><!--,<b><%=v_dia%></b> de <b><%=v_mes%></b> del <b><%=v_anio%></b> --></p></td>
      </tr>
      <tr>
        <td align="center" class="noprint" ><%f_botonera.DibujaBoton("imprimir")%></td>
      </tr>
    </table>
	</td>
  </tr>  
</table>
</body>
</html>

<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
pers_ncorr = request.querystring("pers_ncorr")
carr_ccod  = request.querystring("carr_ccod")

set pagina = new CPagina

pagina.Titulo = "Asignaturas Seleccionadas" 

'---------------------------------------------------------------------------------------------------
set conexion = new cconexion
conexion.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

rut = conexion.consultaUno("select cast(pers_nrut as varchar)+'-'+pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
nombre = conexion.consultaUno("select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
carrera = conexion.consultaUno("select protic.initcap(carr_tdesc) from carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")
plan_ccod = conexion.consultaUno("select top 1 plan_ccod from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and c.carr_ccod='"&carr_ccod&"' and a.emat_ccod in (4,8) order by b.peri_ccod desc")
plan = conexion.consultaUno("select protic.initcap(plan_tdesc) from planes_estudio where cast(plan_ccod as varchar)='"&plan_ccod&"'")
'-------------------------------------------------------------------------------
'------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "m_encuestas2.xml", "botonera"
'-------------------------------------------------------------------------------
set f_alumno = new CFormulario
f_alumno.Carga_Parametros "gestion_solicitudes_certificados.xml", "asignaturas_cert"
f_alumno.Inicializar conexion
'response.End()
c_asignaturas = " select b.nive_ccod, c.asig_ccod, c.asig_tdesc  "& vbCrLf &_
				" from asignaturas_certificado a, malla_curricular b, asignaturas c  "& vbCrLf &_
				" where a.mall_ccod=b.mall_ccod and b.asig_ccod=c.asig_ccod and acer_enviada='SI'  "& vbCrLf &_ 
				" and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.carr_ccod='"&carr_ccod&"' "& vbCrLf &_ 
				" order by b.nive_ccod "
'response.Write("<pre>"&consulta&"</pre>")			
f_alumno.Consultar c_asignaturas

%>
<html>
<head>
<title><%=Pagina.titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function Salir()
{ 
  window.close();
}
</script>

</head>
<body bgcolor="#EBEBEB" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="600" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
    <td valign="top" bgcolor="#EAEAEA"> <br> <br> <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
        <tr> 
          <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
          <td height="8" background="../imagenes/top_r1_c2.gif"></td>
          <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
        </tr>
        <tr> 
          <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
          <td>
		    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="2" background="../imagenes/top_r3_c2.gif"></td>
              </tr>
              <tr> 
                <td align="center"><br>
                  <%pagina.DibujarTituloPagina%><br>
                </td>
			  </tr>
			  <tr><td>&nbsp;</td></tr>
			  <tr>
			  	  <td>
				  	 <table width="100%" cellpadding="0" cellspacing="0">
					 	<tr>
							<td width="15%"><strong>Rut</strong></td>
							<td width="5%" align="center"><strong>:</strong></td>
							<td width="80%"><%=rut%></td>
						</tr>
						<tr>
							<td width="15%"><strong>Nombre</strong></td>
							<td width="5%" align="center"><strong>:</strong></td>
							<td width="80%"><%=nombre%></td>
						</tr>
						<tr>
							<td width="15%"><strong>Carrera</strong></td>
							<td width="5%" align="center"><strong>:</strong></td>
							<td width="80%"><%=carrera%></td>
						</tr>
						<tr>
							<td width="15%"><strong>Plan</strong></td>
							<td width="5%" align="center"><strong>:</strong></td>
							<td width="80%"><%=plan%></td>
						</tr>
					 </table>
				  </td>
			  </tr>
			  <tr><td>&nbsp;</td></tr>
			  <tr><td align="center"><div align="center"><%f_alumno.DibujaTabla%></div></td></tr>
			  <tr><td>&nbsp;</td></tr>
            </table>
			
			</td>
          <td width="7" background="../imagenes/der.gif">&nbsp;</td>
        </tr>
        <tr> 
          <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
          <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="19%" height="20"><div align="center"> 
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="47%">&nbsp;</td>
                        <td width="53%"><div align="center">
                            <%botonera.DibujaBoton "cerrar_actualizar"%>
                          </div></td>
                      </tr>
                    </table>
                  </div></td>
                <td width="81%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
              </tr>
              <tr> 
                <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
              </tr>
            </table></td>
          <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
        </tr>
      </table>
      <br> </td>
  </tr>
</table>
</body>
</html>

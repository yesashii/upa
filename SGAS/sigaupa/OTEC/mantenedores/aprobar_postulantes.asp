<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
dgso_ncorr = request.QueryString("dgso_ncorr")

set pagina = new CPagina
pagina.Titulo = "Configurar Orden de Compra"

set botonera =  new CFormulario
botonera.carga_parametros "postulacion_otec.xml", "botonera_aprobar"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

programa = conexion.consultaUno("select dcur_tdesc from datos_generales_secciones_otec a, diplomados_cursos b where a.dcur_ncorr=b.dcur_ncorr and cast(a.dgso_ncorr as varchar)='"&dgso_ncorr&"'")
sede = conexion.consultaUno("select sede_tdesc from datos_generales_secciones_otec a, sedes b where a.sede_ccod=b.sede_ccod and cast(a.dgso_ncorr as varchar)='"&dgso_ncorr&"'")
sence = conexion.consultaUno("select dcur_nsence from datos_generales_secciones_otec a, diplomados_cursos b where a.dcur_ncorr=b.dcur_ncorr and cast(a.dgso_ncorr as varchar)='"&dgso_ncorr&"'")


			 
set listado_postulaciones = new cformulario
listado_postulaciones.carga_parametros "postulacion_otec.xml", "f_listado_cerradas"
listado_postulaciones.inicializar conexion


c_consulta = " select a.pote_ncorr, b.pers_ncorr, cast(b.pers_nrut as varchar)+'-' + pers_xdv as rut,  " & vbCrlf & _
			 " protic.initcap(b.pers_tnombre + ' ' + b.pers_tape_paterno + ' ' + b.pers_tape_materno) as alumno, " & vbCrlf & _
		     " a.epot_ccod " & vbCrlf & _
			 " from postulacion_otec a, personas b " & vbCrlf & _
			 " where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' " & vbCrlf & _
		     " and epot_ccod in (2,3) " & vbCrlf & _
			 " and a.pers_ncorr=b.pers_ncorr order by a.epot_ccod asc"

'response.write("<pre>"&consulta&"</pre>")
listado_postulaciones.consultar c_consulta 




lenguetas_masignaturas = Array(Array("Aprobar Postulantes Otec", "aprobar_postulantes.asp?dgso_ncorr="&dgso_ncorr))
'response.Write("doras "&horas_Asignatura&" duracion "&duracion_asignatura)
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function guardar(formulario){

if(preValidaFormulario(formulario))
    {	
    	formulario.action ='actualizar_modulos.asp';
		formulario.submit();
	}
	
}
function volver(){
	CerrarActualizar();
}


</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="450" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas lenguetas_masignaturas, 1%> </td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
              <form name="edicion" method="post">
			  <table width="100%"  border="0">
				  <tr>
					<td><strong>Programa :</strong><%=programa%></td>
				  </tr>
				  <tr>
					<td><strong>Sede :</strong><%=sede%></td>
				  </tr>
				  <tr>
					<td><strong>Sence :</strong><%=sence%></td>
				  </tr>
				  <tr>
					<td align="center">&nbsp;</td>
				  </tr>
				  <tr>
				  	<td>&nbsp;</td>
				  </tr>
				  <tr>
					  <td><div align="right"><strong>P&aacute;ginas :</strong>                          
						  <%listado_postulaciones.accesopagina%></div>
					   </td>
				  </tr>
				  <tr>
					  <td>&nbsp;</td>
				  </tr>
				  <tr>
					  <td colspan="2"><div align="center">
									  <%listado_postulaciones.dibujatabla()%>
					  </div></td>
				  </tr>
				</table>
           </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%botonera.dibujaboton "aprobar_postulantes"%></div></td>
                  <td><div align="center"><%botonera.dibujaboton "salir"%></div></td>
                  <td><div align="center"></div></td>
                </tr>
              </table>
            </div></td>
            <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	</td>
  </tr>  
</table>
</body>
</html>

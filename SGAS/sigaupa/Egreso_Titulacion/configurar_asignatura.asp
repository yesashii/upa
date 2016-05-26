<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
codigo= request.QueryString("asig_ccod")
asig_ccod = request.QueryString("asig_ccod")
mall_ccod = request.QueryString("mall_ccod")
espe_ccod = request.QueryString("espe_ccod")
carr_ccod = request.QueryString("carr_ccod")
plan_ccod = request.QueryString("plan_ccod")


set pagina = new CPagina
pagina.Titulo = "Mantenedor De Asignaturas"

set botonera =  new CFormulario
botonera.carga_parametros "configurar_plan.xml", "btn_busca_malla"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
periodo = negocio.obtenerPeriodoAcademico("Postulacion")

asig_tdesc = conexion.consultaUno("Select asig_tdesc from asignaturas where cast(asig_ccod as varchar)='"&asig_ccod&"'")
carr_tdesc = conexion.consultaUno("Select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")
espe_tdesc = conexion.consultaUno("Select espe_tdesc from especialidades where cast(espe_ccod as varchar)='"&espe_ccod&"'")
plan_tdesc = conexion.consultaUno("Select plan_tdesc from planes_estudio where cast(plan_ccod as varchar)='"&plan_ccod&"'")

'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "configurar_plan.xml", "edicion_asig"
formulario.inicializar conexion

consulta= " select mall_ccod,asig_ccod,plan_ccod,tasg_ccod,cpla_nporcentaje," & vbCrlf & _
		  " cpla_pertenece_certificado,cpla_con_nota,cpla_con_concepto " & vbCrlf & _
		  " from configuracion_planes " & vbCrlf & _
		  " where cast(mall_ccod as varchar)='"&mall_ccod&"' and asig_ccod = '"&asig_ccod&"' " 
if conexion.consultaUno("select count(*) from ("&consulta&")aa") <> "1" then
	consulta = "Select "&mall_ccod&" as mall_ccod,'"&asig_ccod&"' as asig_ccod,"&plan_ccod&" as plan_ccod "
end if 

formulario.consultar consulta 
formulario.siguiente

lenguetas_masignaturas = Array(Array("Configurar Asignatura", ""))

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
	if(preValidaFormulario(formulario)){	
    	formulario.action ='configurar_asignatura_proc.asp';
		formulario.submit();
    }	
}
function volver(){
	window.navigate("busca_asignaturas.asp?asig_ccod="+"<%=codigo%>")
}

function validaCambios(){
	alert("..");
	return false;
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="500" border="0" align="center" cellpadding="0" cellspacing="0">
 <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
					<td>&nbsp;</td>
				  </tr>
				  <tr>
					<td><%pagina.DibujarSubtitulo "Datos De La Asignatura"%></td>
				  </tr>
				  <tr>
					<td>&nbsp;</td>
				  </tr>
				</table>

                    <table width="90%" align="center">
                      <tr> 
                        <td width="29%"><strong>Carrera</strong></td>
                        <td width="61%">:<%=carr_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="29%"><strong>Especialidad</strong></td>
                        <td width="61%">:<%=espe_tdesc%><%=formulario.dibujaCampo("mall_ccod")%></td>
                      </tr>
					  <tr> 
                        <td width="29%"><strong>Plan</strong></td>
                        <td width="61%">:<%=plan_tdesc%><%=formulario.dibujaCampo("plan_ccod")%></td>
                      </tr>
					  <tr> 
                        <td width="29%"><strong>Asignatura</strong></td>
                        <td width="61%">:<%=asig_ccod%> -- <%=asig_tdesc%><%=formulario.dibujaCampo("asig_ccod")%></td>
                      </tr>
                      <tr> 
                        <td nowrap><strong>Tipo Asignatura</strong></td>
                        <td >:<%=formulario.dibujaCampo("tasg_ccod")%></td>
                      </tr>
                      <tr> 
                        <td nowrap><strong>Ponderación</strong></td>
                        <td >:<%=formulario.dibujaCampo("cpla_nporcentaje")%> %</td>
                      </tr>
					  <tr> 
                        <td nowrap><strong>NO incluir en Concentración</strong></td>
                        <td >:<%=formulario.dibujaCampo("cpla_pertenece_certificado")%></td>
                      </tr>
					  <tr> 
                        <td nowrap><strong>NO mostrar Nota</strong></td>
                        <td >:<%=formulario.dibujaCampo("cpla_con_nota")%></td>
                      </tr>
					  <tr> 
                        <td nowrap><strong>NO mostrar Concepto</strong></td>
                        <td >:<%=formulario.dibujaCampo("cpla_con_concepto")%></td>
                      </tr>
					   <tr> 
                        <td  colspan="2"><strong><font color="#0000FF">Atención los datos de selección son en NEGACIÓN, ya que toma por defecto que todo lo del plan debe salir en el certificado.</font></strong></td>
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
                  <td><div align="center"><%botonera.dibujaboton "guardar"%></div></td>
                  <td><div align="center"><%botonera.dibujaboton "cerrar"%></div></td>
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
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>

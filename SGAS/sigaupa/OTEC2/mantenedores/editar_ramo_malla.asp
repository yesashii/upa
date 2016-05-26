<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
maot_ncorr  = request.QueryString("maot_ncorr")


'session("url_actual")="../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Editar programa <br> de la malla"

set botonera =  new CFormulario
botonera.carga_parametros "m_diplomados_curso.xml", "botonera_modulos"
'response.End()
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores

'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "m_diplomados_curso.xml", "f_editar_programa"
formulario.inicializar conexion

consulta =" select * " & vbCrlf & _
" from  mallas_otec " & vbCrlf & _
" Where cast(maot_ncorr as varchar)='"&maot_ncorr&"'"

formulario.consultar consulta 
formulario.siguiente
dcur_tdesc = conexion.consultaUno("select dcur_tdesc from mallas_otec a, diplomados_cursos b where a.dcur_ncorr=b.dcur_ncorr and cast(a.maot_ncorr as varchar)='"&maot_ncorr&"'")
mote_tdesc = conexion.consultaUno("select mote_tdesc from mallas_otec a, modulos_otec b where a.mote_ccod=b.mote_ccod and cast(a.maot_ncorr as varchar)='"&maot_ncorr&"'")

c_tiene_contrato = " select count(*) from secciones_otec a, detalle_anexo_otec b, anexos_otec c "&_
				   " where cast(maot_ncorr as varchar)='"&maot_ncorr&"' and a.seot_ncorr=b.seot_ncorr "&_
				   " and b.anot_ncorr=c.anot_ncorr and b.cdot_ncorr=c.cdot_ncorr and eane_ccod <> 3 "
tiene_contrato = conexion.consultaUno(c_tiene_contrato)
mensaje = ""
if tiene_contrato > "0" then
	mensaje = "Imposible modificar este registro, el programa ya se encuentra asociado a un contrato docente"
end if
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
function enviar(formulario){
    var dcur_ncorr = '<%=dcur_ncorr%>';
	formulario.action = 'editar_programas_dcurso.asp';
  	if(preValidaFormulario(formulario)){	
		formulario.submit();
		
	}
}
function abrir() {
	
	direccion = "editar_modulos.asp?codigo=<%=mote_ccod%>";
	resultado=window.open(direccion, "ventana1","width=400,height=200,scrollbars=no, left=380, top=350");
	
 // window.close();
}
function salir(){
window.close()
}

</script>

</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="550" height="100%">
<tr>
	<td bgcolor="#EAEAEA">
<table width="550" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA" align="center">
	</td></tr>
	
	
   <td valign="top" bgcolor="#EAEAEA" align="left">
	<table width="93%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Edición de malla otec"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
                <table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <tr>
                    <td><div align="center"><%pagina.DibujarTituloPagina%> <br></div></td>
                  </tr>
				  <tr>
                    <td align="center">
                                       <form name="edicion">
										  <br>
										  <table width="98%"  border="0" align="center">
											 <tr>
												<td width="20%"><div align="center"><strong>Programa</strong></td>
												<td width="3%"><div align="center"><strong>:</strong></td>
												<td colspan="2"><strong><%=dcur_tdesc%><%formulario.dibujaCampo("maot_ncorr")%></strong></td>
											 </tr>
                                             <tr>
												<td width="20%"><div align="center"><strong>Módulo</strong></td>
												<td width="3%"><div align="center"><strong>:</strong></td>
												<td colspan="2"><strong><%=mote_tdesc%></td>
											 </tr>
                                             <tr>
												<td width="20%"><div align="center"><strong>Horas Programa</strong></td>
												<td width="3%"><div align="center"><strong>:</strong></td>
												<td colspan="2"><%formulario.dibujaCampo("maot_nhoras_programa")%></td>
											 </tr>
                                             <tr>
												<td width="20%"><div align="center"><strong>Presupuesto relator</strong></td>
												<td width="3%"><div align="center"><strong>:</strong></td>
												<td colspan="2"><%formulario.dibujaCampo("maot_npresupuesto_relator")%></td>
											 </tr>
                                             <tr>
												<td width="20%"><div align="center"><strong>Orden en malla</strong></td>
												<td width="3%"><div align="center"><strong>:</strong></td>
												<td colspan="2"><%formulario.dibujaCampo("maot_norden")%></td>
											 </tr>
                                             <%if tiene_contrato > "0" then%>
                                             <tr>
												<td colspan="5"><font color="#0000FF" size="2"><%=mensaje%></font></td>
											 </tr>
                                             <%end if%>
										  </table>
									   </form>
			        </td>
                  </tr> 
				  
				  <tr>
                    <td><hr></td>
                  </tr>
				  
                </table>
                          <br>
            </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="28%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><% if tiene_contrato > "0" then  
				                                botonera.agregaBotonParam "guardar_edicion_programa","deshabilitado","true"
											 end if  
				                               botonera.dibujaboton "guardar_edicion_programa"%></div></td>
                  <td><div align="center"><%botonera.dibujaboton "salir22"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="72%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
</td>
</tr>
</table>
</body>
</html>

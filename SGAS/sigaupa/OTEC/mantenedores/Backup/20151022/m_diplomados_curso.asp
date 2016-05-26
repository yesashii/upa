<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
detalle = request.querystring("detalle")
DCUR_NCORR = request.querystring("b[0][DCUR_NCORR]")
referencia = request.QueryString("referencia")
'response.Write("detalle "&detalle)
session("url_actual")="../mantenedores/m_diplomados_curso.asp?dcur_ncorr="&dcur_ncorr
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Mantenedor de Diplomados y Cursos"

set botonera =  new CFormulario
botonera.carga_parametros "m_diplomados_curso.xml", "btn_busca_asignaturas"
'response.End()
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores



'response.Write(carr_ccod)
dcur_tdesc = conexion.consultauno("SELECT dcur_tdesc FROM diplomados_cursos WHERE cast(dcur_ncorr as varchar)= '" & DCUR_NCORR & "'")
'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "m_diplomados_curso.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"

 f_busqueda.AgregaCampoCons "DCUR_NCORR", DCUR_NCORR
 f_busqueda.Siguiente

'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "m_diplomados_curso.xml", "f_programas"
formulario.inicializar conexion

consulta =" select a.dcur_ncorr as codigo,a.dcur_ncorr,a.dcur_tdesc, b.tdcu_tdesc " & vbCrlf & _
		  " from diplomados_cursos a, tipos_diplomados_cursos b " & vbCrlf & _
		  " where a.tdcu_ccod=b.tdcu_ccod " 
		  
if referencia <> "" then
	consulta = consulta & " and a.dcur_tdesc like '%"&referencia&"%' "
end if
'" nvl(to_char(a.ASIG_FINI_VIGENCIA, 'dd/mm/yyyy'),'- -') AS ASIG_FINI_VIGENCIA,   " & vbCrlf & _
'" nvl(to_char(a.ASIG_FFIN_VIGENCIA, 'dd/mm/yyyy'),'- -') AS ASIG_FFIN_VIGENCIA,  " & vbCrlf & _

'response.write("<pre>"&consulta&"</pre>")
formulario.consultar consulta & " order by dcur_tdesc " 
'response.Write("<pre>"&consulta&" order by asig_tdesc</pre>")

'-----------------------------------------programas del diplomado o curso----------------------------------------------------------
set formulario_malla = new cformulario
formulario_malla.carga_parametros "m_diplomados_curso.xml", "f_malla"
formulario_malla.inicializar conexion

consulta =" select maot_ncorr,b.mote_ccod as codigo,b.mote_ccod, b.mote_tdesc, a.maot_norden,maot_nhoras_programa,maot_npresupuesto_relator " & vbCrlf & _
		  " from mallas_otec a, modulos_otec b " & vbCrlf & _
		  " where a.mote_ccod=b.mote_ccod " & vbCrlf & _
		  " and cast(a.dcur_ncorr as varchar ) ='"&DCUR_NCORR&"' " & vbCrlf & _
		  " order by maot_norden asc " 

'response.write("<pre>"&consulta&"</pre>")
formulario_malla.consultar consulta 

dcur_tdesc = conexion.consultaUno("select dcur_tdesc from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")


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
	formulario.elements["detalle"].value="2";
  	if(preValidaFormulario(formulario)){	
		formulario.submit();
		
	}
}
function abrir() {
	
	direccion = "editar_diplomados_curso.asp";
	resultado=window.open(direccion, "ventana1","width=650,height=450,scrollbars=yes, left=380, top=150");
	
 // window.close();
}
function abrir_programa() {
	var DCUR_NCORR = '<%=DCUR_NCORR%>';
	direccion = "editar_programas_dcurso.asp?dcur_ncorr=" + DCUR_NCORR;
	resultado=window.open(direccion, "ventana2","width=780,height=450,scrollbars=yes, left=380, top=100");
	
 // window.close();
}
function enviar2(formulario) {
	//direccion = "m_diplomados_curso.asp?detalle=1";
	//alert("direccion "+direccion);
	formulario.elements["detalle"].value="1";
	//formulario.action = direccion;
	formulario.submit();
}
function salir(){
window.close()
}

function enviar3(formulario)
{
	formulario.elements["detalle"].value="1";
  	if(preValidaFormulario(formulario))
	{	
		formulario.submit();
	}
}

</script>

</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="580" height="100%">
<tr valign="top" height="30">
	<td bgcolor="#EAEAEA">
</td>
</tr>
<tr valign="top">
	<td bgcolor="#EAEAEA">
<table width="652" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA" align="center">
	<table width="95%">
	<tr>
		<td align="center">
	
	<table width="50%"  border="0" align="left" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td align="left"><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                    <td width="20%"><div align="center"><strong>Módulo</strong></td>
					<td width="3%"><div align="center"><strong>:</strong></td>
                    <td><% f_busqueda.dibujaCampo ("dcur_ncorr") %></td>
                 </tr>
				 <tr> 
				  <td colspan="3"><input type="hidden" name="detalle" value=""></td>
                </tr>
				 <tr> 
				  <td colspan="3"><table width="100%">
				                      <tr>
									  	<td width="50%" align="center"><%botonera.dibujaboton "crear_dcurso"%></td>
										<td width="50%" align="center"><%botonera.dibujaboton "buscar"%></td>
									  </tr>
				                  </table>
			       </td>
                </tr>
              </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	</td>
	</tr>
	</table>
	</td></tr>
	
	
	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">&nbsp;</td></tr>
	<tr>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="edicion">
                <table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>                        <div align="center"><%pagina.DibujarTituloPagina%> <br>
                    </div></td>
                    </tr>
                  
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <tr>
                    <td><%if detalle="2" then
					        response.Write("<strong>PROGRAMA: "&dcur_tdesc&"</strong>")
						  end if%></td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <%if detalle = "1"  then %>
                  <tr>
                    <td><input type="hidden" name="detalle" value="<%=detalle%>">
                        <input type="hidden" name="b[0][DCUR_NCORR]"  value="<%=DCUR_NCORR%>">
                    	<table width="95%" cellpadding="0" cellspacing="0">
                        	<tr bgcolor="#999999" valign="middle" height="25">
                            	<td width="20%"><strong>Acotar listado por:</strong></td>
                                <td width="50%"><input type="text" name="referencia" size="45" maxlength="60" value="<%=referencia%>"></td>
                                <td width="30%" align="left"><%botonera.dibujaboton "busqueda_interna"%></td>
                            </tr>
                        </table>
                    </td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td><div align="right"><strong>P&aacute;ginas :</strong>                          
                      <%formulario.accesopagina%>
                    </div></td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td><div align="center">
                          <%formulario.dibujatabla()%>
                    </div></td>
                  </tr>
				  <%end if%>
				  <%if (dcur_ncorr <> "" ) and detalle = "2"  then %>
                  <tr>
                    <td><div align="right"><strong>P&aacute;ginas :</strong>                          
                      <%formulario_malla.accesopagina%>
                    </div></td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td><div align="center">
                          <%formulario_malla.dibujatabla()%>
                    </div></td>
                  </tr>
                  <tr>
                    <td align="right"><font color="#0000CC">* Haga clic sobre el programa que desee modificar.</font></td>
                  </tr>
				  <%end if%>
                </table>
                          <br>
            </form></td></tr>
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
                  <td><div align="center"><% if detalle="1" then
				                             	botonera.dibujaboton "agregar_nuevo_dcurso"
											 end if
											 if detalle="2" then
				                             	botonera.dibujaboton "agregar_programa_dcurso"
											 end if
										  %></div></td>
                  <td><div align="center"><%if detalle="1" then
				                             	botonera.dibujaboton "eliminar"
											 end if
											 if detalle="2" then
				                             	botonera.dibujaboton "eliminar_malla"
											 end if%></div></td>
				  <td width="14%"> <div align="center">  <%
				                           'botonera.agregabotonparam "excel", "url", "busca_asignaturas_excel.asp?mote_ccod="&mote_ccod&"&asig_tdesc="&mote_tdesc
										   'botonera.dibujaboton "excel"
										%>
					 </div>
                  </td>
                  <td><div align="center"><%'botonera.dibujaboton "salir"%></div></td>
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

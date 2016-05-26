<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
detalle = request.querystring("detalle")
DCUR_NCORR = request.querystring("b[0][DCUR_NCORR]")
'response.Write("detalle "&detalle)
session("url_actual")="../mantenedores/asociar_programas.asp?dcur_ncorr="&dcur_ncorr
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Relacionar Programas"

set botonera =  new CFormulario
botonera.carga_parametros "asociar_programas.xml", "btn_busca_asignaturas"
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
 f_busqueda.Carga_Parametros "asociar_programas.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"

 f_busqueda.AgregaCampoCons "DCUR_NCORR", DCUR_NCORR
 f_busqueda.Siguiente

'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "asociar_programas.xml", "seleccionar_programa"
formulario.inicializar conexion

consulta = "select '' as dcur_ncorr"

formulario.consultar consulta 
formulario.siguiente

c_diplomados = "(select distinct dcur_ncorr as dcur_ncorr_a_emular,dcur_tdesc "&_
			   " from diplomados_cursos a "&_
			   " where (select count(*) from mallas_otec tt where tt.dcur_ncorr = a.dcur_ncorr) > 1 "&_
			   " and not exists (select 1 from programas_asociados tt where tt.dcur_ncorr_origen = a.dcur_ncorr) "&_
			   " and cast(a.dcur_ncorr as varchar) <> '"&DCUR_NCORR&"') ta "
			   
formulario.agregaCampoParam "dcur_ncorr_a_emular","destino",c_diplomados

'-----------------------------------------Relación de programas----------------------------------------------------------
set formulario_relaciones = new cformulario
formulario_relaciones.carga_parametros "asociar_programas.xml", "f_relaciones"
formulario_relaciones.inicializar conexion

consulta =" select a.dcur_ncorr, a.dcur_tdesc,b.dcur_ncorr_origen,c.dcur_tdesc as dcur_tdesc_origen, b.dcur_norden,b.dcur_norden as orden_relacion " & vbCrlf & _
		  " from diplomados_cursos a, programas_asociados b, diplomados_cursos c " & vbCrlf & _
		  " where cast(a.dcur_ncorr as varchar)='"&DCUR_NCORR&"' " & vbCrlf & _
		  " and a.dcur_ncorr=b.dcur_ncorr " & vbCrlf & _
		  " and b.dcur_ncorr_origen=c.dcur_ncorr " & vbCrlf & _
		  " order by b.dcur_norden asc " 

'response.write("<pre>"&consulta&"</pre>")
formulario_relaciones.consultar consulta 


'-----------------------------------------programas del diplomado o curso----------------------------------------------------------
set formulario_malla = new cformulario
formulario_malla.carga_parametros "asociar_programas.xml", "f_malla"
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
	resultado=window.open(direccion, "ventana2","width=650,height=450,scrollbars=yes, left=380, top=100");
	
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
                    <td width="20%"><div align="center"><strong>Programa Contenedor</strong></td>
					<td width="3%"><div align="center"><strong>:</strong></td>
                    <td><% f_busqueda.dibujaCampo ("dcur_ncorr") %></td>
                 </tr>
				 <tr> 
				  <td colspan="3"><input type="hidden" name="detalle" value=""></td>
                </tr>
				 <tr> 
				  <td colspan="3"><table width="100%">
				                      <tr>
									  	<td width="50%" align="center">&nbsp;</td>
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
    <%if DCUR_NCORR <> "" then %>
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
            <td>
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
                    <form name="edicion">
                    <input type="hidden" name="dcur_ncorr" value="<%=dcur_ncorr%>">
                    <tr>
                      <td>
                      	<table width="95%" cellpadding="0" cellspacing="0">
                        	<tr>
                            	<td colspan="2">SELECCIONE PROGRAMA PARA ASOCIAR MALLA CURRICULAR</td>
                            </tr>
                            <tr>
                                <td colspan="2"><%=formulario.dibujaCampo("dcur_ncorr_a_emular")%></td> 	
                            </tr>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td align="right"><%botonera.dibujaboton "guardar"%></td>
                    </tr>
                    </form>
                    <tr>
                      <td>&nbsp;</td>
                    </tr>
				  <%if (dcur_ncorr <> "" ) and detalle = "2"  then %>
                  <form name="edicion_relacion">
                  <tr>
                    <td align="left"><strong>PROGRAMAS ASOCIADOS</strong></td>
                  </tr>
                  <tr>
                    <td><div align="right"><strong>P&aacute;ginas :</strong>                          
                      <%formulario_relaciones.accesopagina%>
                    </div></td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td><div align="center">
                          <%formulario_relaciones.dibujatabla()%>
                    </div></td>
                  </tr>
                  <tr>
                      <td align="right"><%botonera.dibujaboton "eliminar_relacion"%></td>
                  </tr>
                  </form>
                  <tr>
                    <td align="right">&nbsp;</td>
                  </tr>
                  <form name="edicion_malla">
                  <tr>
                    <td align="left"><strong>MALLA CURRICULAR COMPLETA</strong></td>
                  </tr>
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
                  </form>
                  <tr>
                    <td align="right"><font color="#0000CC">* Haga clic sobre el programa que desee modificar.</font></td>
                  </tr>
				  <%end if%>
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
                  <td><div align="center"><%botonera.dibujaboton "eliminar_malla"%></div></td>
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
    <%end if%>
    
	</td>
  </tr>  
</table>
</td>
</tr>
</table>
</body>
</html>

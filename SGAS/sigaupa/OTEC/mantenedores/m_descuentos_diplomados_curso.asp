<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
anio_admision = request.querystring("b[0][anio_admision]")
DCUR_NCORR = request.querystring("b[0][DCUR_NCORR]")
sede_ccod = request.querystring("b[0][sede_ccod]")
'response.Write("detalle "&detalle)
session("url_actual")="../mantenedores/m_descuentos_diplomados_curso.asp?dcur_ncorr="&dcur_ncorr
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Asignación de Descuentos a Diplomados y Cursos"

set botonera =  new CFormulario
botonera.carga_parametros "m_descuentos_diplomados_curso.xml", "btn_busca_asignaturas"
'response.End()
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores

dcur_tdesc = conexion.consultauno("SELECT dcur_tdesc FROM diplomados_cursos WHERE cast(dcur_ncorr as varchar)= '" & DCUR_NCORR & "'")
'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "m_descuentos_diplomados_curso.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 'f_busqueda.Consultar "select ''"
 
  consulta = "Select '"&anio_admision&"' as anio_admision,'"&dcur_ncorr&"' as dcur_ncorr, '"&sede_ccod&"' as sede_ccod"
 f_busqueda.consultar consulta

 consulta = " select anio_admision,c.sede_ccod,c.sede_tdesc, b.dcur_ncorr,b.dcur_tdesc " & vbCrlf & _
			" from datos_generales_secciones_otec a, diplomados_cursos b,sedes c,ofertas_otec d " & vbCrlf & _
			" where a.dcur_ncorr=b.dcur_ncorr " & vbCrlf & _
			" and a.sede_ccod=c.sede_ccod  " & vbCrlf & _
			" and a.dgso_ncorr=d.dgso_ncorr " & vbCrlf & _
			" and a.esot_ccod not in (3) and a.dcur_ncorr not in (5,35) " & vbCrlf & _
			" order by anio_admision desc,c.sede_tdesc asc, b.dcur_tdesc asc " 
 'response.Write("detalle "&consulta)		
 f_busqueda.inicializaListaDependiente "lBusqueda", consulta
 f_busqueda.Siguiente
 
 'f_busqueda.AgregaCampoCons "DCUR_NCORR", DCUR_NCORR
 'f_busqueda.Siguiente

 dcur_tdesc = conexion.consultaUno("select dcur_tdesc from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")


set f_descuentos = new cformulario
f_descuentos.carga_parametros "m_descuentos_diplomados_curso.xml", "f_descuentos"
f_descuentos.inicializar conexion

'if dcur_ncorr <> "" then 
'consulta= " select a.tdet_ccod,tdet_tdesc,replace(cast(ddcu_mdescuento as decimal(6,3)),',','.') as ddcu_mdescuento " & vbCrlf & _
'		  " from tipos_detalle a left outer join descuentos_diplomados_curso b " & vbCrlf & _
'		  "  on a.tdet_ccod=b.tdet_ccod and '"&dcur_ncorr&"' = cast(b.dcur_ncorr as varchar) " & vbCrlf & _
'		  "  where a.tdet_ccod in (1371,1332,1393,1394,1276,1385,1523,1508,1509,1534,1536,1570,1573,1588,1595,1598,1601,1613,1620,1621,1622,1623,1625,1630,1631,1632,1633,1634)"

'####### Cambio query segun uso descuento (1: pregrado, 2: Otec , 3: Mixto) #########
consulta= " select a.tdet_ccod,tdet_tdesc,replace(cast(isnull(ddcu_mdescuento,0) as decimal(6,3)),',','.') as ddcu_mdescuento " & vbCrlf & _
		  " from tipos_detalle a left outer join descuentos_diplomados_curso b " & vbCrlf & _
		  "  on a.tdet_ccod=b.tdet_ccod and '"&dcur_ncorr&"' = cast(b.dcur_ncorr as varchar) " & vbCrlf & _
		  "  where a.udes_ccod in (2,3) "

'end if

'response.write("<pre>"&consulta&"</pre>")
f_descuentos.consultar consulta 

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
function guardar(formulario){
if(preValidaFormulario(formulario))
    {	
    	formulario.action ='m_descuentos_diplomados_curso_proc.asp';
		formulario.submit();
	}
	
}</script>
<% f_busqueda.generaJS %>
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
                    <td width="20%"><div align="center"><strong>Año</strong></td>
					<td width="3%"><div align="center"><strong>:</strong></td>
                    <td><%f_busqueda.dibujaCampoLista "lBusqueda", "anio_admision" %></td>
                 </tr>
				 <tr>
                    <td width="20%"><div align="center"><strong>Sede</strong></td>
					<td width="3%"><div align="center"><strong>:</strong></td>
                    <td><%f_busqueda.dibujaCampoLista "lBusqueda", "sede_ccod" %></td>
                 </tr>
                 <tr>
                    <td width="20%"><div align="center"><strong>Módulo</strong></td>
					<td width="3%"><div align="center"><strong>:</strong></td>
                    <td><%f_busqueda.dibujaCampoLista "lBusqueda", "dcur_ncorr"%></td>
                 </tr>
				 <tr> 
				  <td colspan="3"><input type="hidden" name="detalle" value=""></td>
                </tr>
				 <tr> 
				  <td colspan="3"><table width="100%">
				                      <tr>
									  	<td width="50%" align="center">&nbsp;</td>
										<td width="50%" align="center"><% botonera.agregaCampoParam "buscar","texto","Buscar"
										                                  botonera.dibujaboton "buscar"%></td>
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
            <td><form name="edicion" method="post">
			    <input type="hidden" name="dcur_ncorr" value="<%=dcur_ncorr%>">
                <table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>                        <div align="center"><%pagina.DibujarTituloPagina%> <br>
                    </div></td>
                    </tr>
                  
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <tr>
                    <td><%if dcur_tdesc<>"" then
					        response.Write("<strong>PROGRAMA: "&dcur_tdesc&"</strong>")
						  end if%></td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <%if (dcur_ncorr <> "" ) then %>
                   <tr>
                       <td>&nbsp;</td>
                   </tr>
                   <tr> 
                       <td align="center"><strong>Indique El porcentaje de descuento que afectará al programa si cumple cualquiera de estas condiciones.(0 si no considera.)</strong></td>
                   </tr>
				   <tr> 
                       <td align="center"><strong><%f_descuentos.dibujaTabla%></strong></td>
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
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><% botonera.dibujaboton "guardar"%></div></td>
                  <td><div align="center">&nbsp;</div></td>
				  <td width="14%">&nbsp; </td>
                  <td><div align="center"><%'botonera.dibujaboton "salir"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="84%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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

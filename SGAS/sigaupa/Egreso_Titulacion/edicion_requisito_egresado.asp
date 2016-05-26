<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
q_repl_ncorr = Request.QueryString("repl_ncorr")
q_egre_ncorr = Request.QueryString("egre_ncorr")


'------------------------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new Cnegocio
negocio.Inicializa conexion


'--------------------------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "requisitos_titulacion.xml", "botonera"

set f_requisito = new CFormulario
f_requisito.Carga_Parametros "requisitos_titulacion.xml", "edicion_requisitos"
f_requisito.Inicializar conexion

consulta = "select a.*, " & vbCrLf & _
           "       b.treq_ccod " & vbCrLf & _
		   "from requisitos_titulacion a, requisitos_plan b  " & vbCrLf & _
		   "where a.repl_ncorr = b.repl_ncorr " & vbCrLf & _
		   "  and a.repl_ncorr = '" & q_repl_ncorr & "' " & vbCrLf & _
		   "  and a.egre_ncorr = '" & q_egre_ncorr & "'"
		   
consulta = "select a.treq_ccod, a.repl_ncorr, " & vbCrLf & _
           "       '" & q_egre_ncorr & "' as egre_ncorr, " & vbCrLf & _
		   "       b.reti_ncorr, b.ereq_ccod, b.reti_nnota, nvl(b.reti_ftermino, sysdate) as reti_ftermino, c.teva_ccod " & vbCrLf & _
		   "from requisitos_plan a, requisitos_titulacion b, tipos_requisitos_titulo c " & vbCrLf & _
		   "where a.repl_ncorr = b.repl_ncorr (+) " & vbCrLf & _
		   "  and a.treq_ccod = c.treq_ccod " & vbCrLf &_
		   "  and a.repl_ncorr = '" & q_repl_ncorr & "' " & vbCrLf & _
		   "  and b.egre_ncorr (+) = '" & q_egre_ncorr & "'"
		   
'response.Write("<pre>"&consulta&"</pre>")
f_requisito.Consultar consulta
f_requisito.SiguienteF

v_treq_ccod = f_requisito.ObtenerValor("treq_ccod")
v_teva_ccod = f_requisito.ObtenerValor("teva_ccod")
b_puede_editar = true

if v_treq_ccod = "1" then
	b_puede_editar = false	
end if


'--------------------------------------------------------------------------------------------------------------------
consulta = "select count(distinct a.acti_ncorr) " & vbCrLf &_
           "from detalle_actas_titulacion a, requisitos_titulacion b " & vbCrLf &_
		   "where a.reti_ncorr = b.reti_ncorr " & vbCrLf &_
		   "  and b.egre_ncorr = '" & q_egre_ncorr & "'"
		   
v_cuenta = CInt(conexion.ConsultaUno(consulta))
'response.Write(v_cuenta)
if v_cuenta > 0 then
	b_puede_editar = false
end if

'response.Write(b_puede_editar)
'--------------------------------------------------------------------------------------------------------------------
if not b_puede_editar then
	f_requisito.AgregaCampoParam "reti_nnota", "permiso", "LECTURA"
	f_requisito.AgregaCampoParam "ereq_ccod", "permiso", "LECTURA"
	f_requisito.AgregaCampoParam "reti_ftermino", "permiso", "LECTURA"
end if

'--------------------------------------------------------------------------------------------------------------------
set fc_datos = new CFormulario
fc_datos.Carga_Parametros "consulta.xml", "consulta"
fc_datos.Inicializar conexion

consulta = "select b.pers_nrut || '-' || b.pers_xdv as rut, b.pers_tape_paterno || ' '  || b.pers_tape_materno || ' ' || b.pers_tnombre as nombre " & vbCrLf & _
           "from egresados a, personas b  " & vbCrLf & _
		   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf & _
		   "  and a.egre_ncorr = '" & q_egre_ncorr & "'"
		   
fc_datos.Consultar consulta
fc_datos.Siguiente

'--------------------------------------------------------------------------------------------------------------------

%>
<html>
<head>
<title>Evaluaci&oacute;n de Actividades de Titulaci&oacute;n</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function Cancelar()
{
	window.close();
}

function ActualizarEstado(formulario)
{
	v_teva_ccod = '<%=v_teva_ccod%>';
	
	if (v_teva_ccod != '2') {	
		if (isNumber(formulario.elements["requisitos_titulacion[0][reti_nnota]"].value)) {
			if (formulario.elements["requisitos_titulacion[0][reti_nnota]"].value >= 4)
				formulario.elements["requisitos_titulacion[0][ereq_ccod]"].value = 1;
			else
				formulario.elements["requisitos_titulacion[0][ereq_ccod]"].value = 2;		
		}
	}
}


function ValidaFormEdicion(formulario)
{
	v_teva_ccod = '<%=v_teva_ccod%>';
	
	if (v_teva_ccod != '2') {
		if ((formulario.elements["requisitos_titulacion[0][reti_nnota]"].value < 1) || (formulario.elements["requisitos_titulacion[0][reti_nnota]"].value > 7)) {
			alert('Nota debe ser entre 1 y 7.');
			formulario.elements["requisitos_titulacion[0][reti_nnota]"].focus();
			formulario.elements["requisitos_titulacion[0][reti_nnota]"].select();
			return false;
		}
	}
	
	return true;
}

function Guardar(formulario)
{
	if (preValidaFormulario(formulario)) {
		if (ValidaFormEdicion(formulario)) {
			formulario.action = "proc_edicion_requisito_egresado.asp";
			formulario.method = "post";
			formulario.submit();
		}
	}
}

</script>

<style type="text/css">
<!--
.Estilo2 {color: #FFFFFF}
-->
</style>
</head>
<body  onBlur="revisaVentana()" bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="552" height="268" border="0" align="center" cellpadding="0" cellspacing="0">
  <%'pagina.DibujarEncabezado()%>  
  <tr>
    <td height="268" valign="top" bgcolor="#EAEAEA">
	<BR>
	<BR>			
	
	<table width="400" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="400" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="400" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="9" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="266" valign="middle" background="../imagenes/fondo1.gif">
					    <span class="Estilo2">Evaluaci&oacute;n de Actividades de Titulaci&oacute;n </span>
					  <div align="left"></div></td>
                      <td width="125" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="400" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
                    <form name="edicion" id="edicion">
					<div align="center">
                      <%f_requisito.DibujaCampo("reti_ncorr")%>
                      <%f_requisito.DibujaCampo("egre_ncorr")%>
                      <%f_requisito.DibujaCampo("repl_ncorr")%>				    
                    </div>
					<table width="100%" border="0">
					  <tr>
					    <td nowrap><strong>Alumno</strong></td>
					    <td nowrap><strong>:</strong></td>
					    <td nowrap><strong><%=fc_datos.ObtenerValor("nombre")%>
					    </strong> </td>
				      </tr>
					  <tr>
					    <td nowrap><strong>Tipo de Requisito</strong></td>
					    <td nowrap><strong>:</strong></td>
					    <td nowrap><strong>
					      <%f_requisito.DibujaCampo("treq_ccod")%>&nbsp;(<%f_requisito.DibujaCampo("teva_ccod")%>) </strong> </td>
				      </tr>
					  <% if v_teva_ccod = "1" then %>
					  <tr>					    
					    <td nowrap><strong>Nota <font color="#CC3300">(*)</font></strong></td>												
					    <td nowrap><strong>:</strong></td>
					    <td nowrap><%f_requisito.DibujaCampo("reti_nnota")%></td>
				      </tr>
					  <% end if %>
					  <tr>
					    <td nowrap><strong>Estado <font color="#CC3300">(*)</font></strong></td>
					    <td nowrap><strong>:</strong></td>
					    <td nowrap><%f_requisito.DibujaCampo("ereq_ccod")%></td>
				      </tr>
					  <tr>
					    <td width="28%" nowrap><strong>Fecha de T&eacute;rmino&nbsp;<font color="#CC3300">(*)</font></strong></td>
					    <td width="2%" nowrap><strong>:</strong></td>
					    <td width="70%" nowrap><%f_requisito.DibujaCampo("reti_ftermino")%></td>
				      </tr>
					  </table>					
				    <div align="right">                      <br>				  
                    </div>
				  </form>			</td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="225" bgcolor="#D8D8DE"> <div align="left"></div> 
		            <div align="left">                       <table width="100%" border="0" cellpadding="0" cellspacing="0">
                         <tr>
                           <td><div align="center">
                             <% botonera.dibujaboton "guardar_egre"%>
                           </div></td>
                           <td><div align="center">
                             <% botonera.dibujaboton "cancelar"%>
                           </div></td>
                         </tr>
                       </table>
</div></td>
                  <td width="37" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="145" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
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
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
q_egre_ncorr = Request.QueryString("egre_ncorr")

set pagina = new CPagina
pagina.Titulo = "Requisitos de Titulación"

set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores			= new cErrores

set botonera = new CFormulario
botonera.Carga_Parametros "requisitos_titulacion.xml", "botonera"

set f_requisito = new CFormulario
f_requisito.Carga_Parametros "requisitos_titulacion.xml", "agregar_requisitos"
f_requisito.Inicializar conexion

consulta = "select a.egre_ncorr, b.pers_tape_paterno || ' ' || b.pers_tape_materno || ' ' || b.pers_tnombre as nombre " & vbCrLf &_
           "from egresados a, personas b " & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
		   "  and a.egre_ncorr = '" & q_egre_ncorr & "'"

f_requisito.Consultar consulta
f_requisito.Siguiente

'----------------------------------------------------------------------------------------------------------------------
consulta = "select c.* " & vbCrLf &_
           "from egresados a, requisitos_plan b, tipos_requisitos_titulo c " & vbCrLf &_
		   "where a.plan_ccod = b.plan_ccod " & vbCrLf &_
		   "  and a.sede_ccod = b.sede_ccod " & vbCrLf &_
		   "  and a.peri_ccod = b.peri_ccod " & vbCrLf &_
		   "  and b.treq_ccod = c.treq_ccod " & vbCrLf &_
		   "  and a.egre_ncorr = '" & q_egre_ncorr & "' " & vbCrLf &_
		   "  and not exists (select 1 " & vbCrLf &_
		   "                  from requisitos_titulacion a2 " & vbCrLf &_
		   "				  where a2.egre_ncorr = a.egre_ncorr " & vbCrLf &_
		   "				    and a2.repl_ncorr = b.repl_ncorr) " & vbCrLf &_
		   "order by c.treq_ccod asc"

f_requisito.AgregaCampoParam "treq_ccod", "destino", "(" & consulta & ")"

%>
<html>
<head>
<title>Mantenedor de Funciones</title>
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


function ValidaFormEdicion(formulario)
{
	if (!isEmpty(formulario.elements["requisitos_titulacion[0][reti_nnota]"].value)) {	
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
			formulario.action = "proc_requisito_titulacion_agregar.asp";
			formulario.method = "post";
			formulario.submit();
		}
	}
}
</script>

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
                      <td width="221" valign="middle" background="../imagenes/fondo1.gif">
					  <font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">
					  Mantenedor de Requisitos de Titulaci&oacute;n</font>
	                  <div align="left"></div></td>
                      <td width="170" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
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
				    &nbsp;
				    <form name="edicion" id="edicion">			    
					<table width="100%" border="0">
					  <tr>
					    <td nowrap><strong>Alumno</strong></td>
					    <td nowrap><strong>:</strong></td>
					    <td nowrap><strong><%=f_requisito.ObtenerValor("nombre")%>
                            <%f_requisito.DibujaCampo("egre_ncorr")%>
					    </strong> </td>
				      </tr>
					  <tr>
					    <td nowrap><strong>Tipo de Requisito</strong></td>
					    <td nowrap><strong>:</strong></td>
					    <td nowrap><strong>
					      <%f_requisito.DibujaCampo("treq_ccod")%>
					    </strong> </td>
				      </tr>
					  <tr>
					    <td nowrap><strong>Nota</strong></td>
					    <td nowrap><strong>:</strong></td>
					    <td nowrap><%f_requisito.DibujaCampo("reti_nnota")%></td>
				      </tr>
					  <tr>
					    <td nowrap><strong>Estado</strong></td>
					    <td nowrap><strong>:</strong></td>
					    <td nowrap><%f_requisito.DibujaCampo("ereq_ccod")%></td>
				      </tr>
					  <tr>
					    <td width="28%" nowrap><strong>Fecha de T&eacute;rmino</strong></td>
					    <td width="2%" nowrap><strong>:</strong></td>
					    <td width="70%" nowrap><%f_requisito.DibujaCampo("reti_ftermino")%> 
				        (dd/mm/yyyy)</td>
				      </tr>
					  </table>					
				    <div align="right">                      <br>				  
                    </div>
					</form>
			</td>
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
                             <% botonera.dibujaboton "guardar"%>
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
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina

set f_busqueda = new CFormulario
set conexion = new CConexion
set botonera = new CFormulario
set negocio = new CNegocio

conexion.Inicializar "upacifico"
negocio.Inicializa conexion
'-----------------------------------------------------------------------
pagina.Titulo = "Envíos a Cobranza"

'-----------------------------------------------------------------------
botonera.Carga_Parametros "envios_cobranza.xml", "btn_envios_cobranza"
f_busqueda.Carga_Parametros "envios_cobranza.xml", "fbusqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")

 sede = request.querystring("busqueda[0][sede_ccod]")
 empresa = request.querystring("busqueda[0][inen_ccod]")
 folio = request.querystring("busqueda[0][envi_ncorr]")
 inicio = request.querystring("busqueda[0][envi_fenvio]")
 termino = request.querystring("busqueda[0][envio_termino]") 
 tipo_envio = request.querystring("busqueda[0][tenv_ccod]") 
 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado = request.querystring("busqueda[0][code_nrut]")
 rut_apoderado_digito = request.querystring("busqueda[0][code_xdv]")

f_busqueda.AgregaCampoCons "sede_ccod", sede
f_busqueda.AgregaCampoCons "inen_ccod", empresa
f_busqueda.AgregaCampoCons "envi_ncorr", folio
f_busqueda.AgregaCampoCons "envi_fenvio", inicio
f_busqueda.AgregaCampoCons "envio_termino", termino
f_busqueda.AgregaCampoCons "tenv_ccod", tipo_envio
f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
f_busqueda.AgregaCampoCons "code_nrut", rut_apoderado
f_busqueda.AgregaCampoCons "code_xdv", rut_apoderado_digito

'---------------------------------------------------------------------------------------------------
set f_listado = new CFormulario
f_listado.Carga_Parametros "envios_cobranza.xml", "f_listado"
f_listado.Inicializar conexion

sql_listado = "select distinct envi_ncorr as folio, envi_ncorr as num_folio, envi_ncorr,  inen_tdesc as empresa_envio,TINE_CCOD as tipo_empresa,"&_
			"envi_fenvio as fecha, eenv_tdesc as estado_envio, 0 as retenidos, 0 as saldo, tenv_tdesc as tipo_envio, SUM(cant_doc) as cant_doc  "&_
"from (select *   "&_
      "from (select distinct isnull(a.envi_ncorr,0) as envi_ncorr, a.envi_fenvio, "&_
	             " isnull(a.inen_ccod,0) as inen_ccod, "&_
				 " isnull(e.pers_nrut, 0) as pers_nrut, e.pers_xdv, "&_ 
				 " isnull(g1.pers_nrut, 0) as code_nrut, g1.pers_xdv as code_xdv, "&_
				 "count(b.envi_ncorr) as cant_doc,h.inen_tdesc, h.TINE_CCOD,i.eenv_tdesc,   isnull(l.sede_ccod,0) as sede_ccod, te.tenv_tdesc  "&_
            "from envios a, detalle_envios b, detalle_ingresos c, ingresos d, personas e, postulantes f, codeudor_postulacion g, "&_
                 "instituciones_envio h, estados_envio i, alumnos k, ofertas_academicas l, sedes m, personas g1, tipos_envios te "&_
            "where a.envi_ncorr *= b.envi_ncorr  "&_
              "and b.ting_ccod *= c.ting_ccod  "&_
              "and b.ding_ndocto *= c.ding_ndocto "&_
              "and b.ingr_ncorr *= c.ingr_ncorr  "&_
              "and c.ingr_ncorr *= d.ingr_ncorr  "&_
              "and d.pers_ncorr *= e.pers_ncorr  "&_
              "and e.pers_ncorr *= f.pers_ncorr  "&_
              "and f.post_ncorr *= g.post_ncorr  "&_
              "and cast(f.peri_ccod as varchar) ='" & Periodo & "' "&_
              "and a.inen_ccod = h.inen_ccod "&_
			  "and (h.TINE_CCOD = 3 or h.TINE_CCOD = 4) "&_
              "and a.eenv_ccod = i.eenv_ccod "&_
              
			  "and f.post_ncorr *= k.post_ncorr  "&_
			  "and k.emat_ccod  = 1 "&_
           	  "and k.ofer_ncorr  *= l.ofer_ncorr  "&_
	          "and l.sede_ccod *= m.sede_ccod "&_
			  "and g1.pers_ncorr =* g.pers_ncorr "&_
			  "and a.tenv_ccod = te.tenv_ccod "&_
			  "group by a.inen_ccod,a.envi_ncorr,a.envi_fenvio,"&_
		      "e.pers_nrut,e.pers_xdv,g1.pers_nrut,g1.pers_xdv, h.inen_tdesc,"&_ 
		      "h.TINE_CCOD, i.eenv_tdesc, l.sede_ccod,te.tenv_tdesc"&_
		  ") a "&_
            "where a.pers_nrut = isnull('" & rut_alumno & "', a.pers_nrut) "&_
              "and a.code_nrut = isnull('" & rut_apoderado & "', a.code_nrut) "&_
              "and a.envi_ncorr = isnull('" & folio &  "', a.envi_ncorr) "&_
			  "and protic.trunc(a.envi_fenvio)  BETWEEN isnull('" & inicio & "', a.envi_fenvio) AND  isnull('" & termino & "', a.envi_fenvio) "&_
 		      "and a.inen_ccod = isnull('" & empresa &  "', a.inen_ccod) "&_ 
			  "and a.sede_ccod = isnull('" & sede &  "', a.sede_ccod) "&_ 
      ") group by envi_ncorr, inen_tdesc, envi_fenvio, eenv_tdesc,TINE_CCOD,tenv_tdesc	ORDER BY envi_ncorr DESC"	   
'response.Write(sql_listado)
'response.End()
f_listado.Consultar sql_listado

'---------------------------------------------------------------------------------------------------
'set botonera = new CFormulario
'botonera.Carga_Parametros "Envios_Notaria.xml", "botonera"
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
function Validar()
{
	formulario = document.buscador;
	
	rut_alumno = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }
	
	rut_apoderado = formulario.elements["busqueda[0][code_nrut]"].value + "-" + formulario.elements["busqueda[0][code_xdv]"].value;	
    if (formulario.elements["busqueda[0][code_nrut]"].value  != '')
	  if (!valida_rut(rut_apoderado)) 
  	   {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][code_xdv]"].focus();
		formulario.elements["busqueda[0][code_xdv]"].select();
		return false;
	   }
	return true;
}

</script>

<script language="JavaScript">
function abrir()
 { 
  location.reload("Envios_Cobranza_Agregar1.asp") 
 }
</script>

<script language='javaScript1.2'> 
  colores = Array(3);
  colores[0] = ''; 
  colores[1] = '#97AAC6'; 
  colores[2] = '#C0C0C0'; 
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="238" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador
                      de Env&iacute;os a Cobranza</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="395" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                  </tr>
              </table></td>
              <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>              
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
				<form name="buscador" >
                  <table width="98%"  border="0">
                    <tr>
                      <td width="86%"><table width="555" border="0">
                              <tr> 
                                <td width="137"> <div align="left">Sede</div></td>
                                <td width="11">:</td>
                                <td width="147"> <%f_busqueda.dibujacampo("sede_ccod")%> </td>
                                <td width="81">&nbsp;</td>
                                <td width="10">&nbsp;</td>
                                <td width="143">&nbsp;</td>
                              </tr>
                              <tr> 
                                <td>Periodo Inicio</td>
                                <td>:</td>
                                <td><div align="left"></div>
                                  <%f_busqueda.dibujacampo("envi_fenvio")%> </td>
                                <td>T&eacute;rmino</td>
                                <td>:</td>
                                <td><div align="left"> 
                                    <%f_busqueda.dibujacampo("envio_termino")%>
                                  </div></td>
                              </tr>
                              <tr> 
                                <td>Empresa de Cobranza</td>
                                <td>:</td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                  <%f_busqueda.dibujacampo("inen_ccod")%>
                                  </font></td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
                              <tr> 
                                <td height="20">N&ordm; Folio</td>
                                <td>:</td>
                                <td> <%f_busqueda.dibujacampo("envi_ncorr")%> </td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
                              <tr> 
                                <td>Rut Alumno</td>
                                <td>:</td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                  <%f_busqueda.dibujacampo("pers_nrut")%>
                                  - 
                                  <%f_busqueda.dibujacampo("pers_xdv")%>
                                  </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut 
                                  Apoderado</font></td>
                                <td>:</td>
                                <td><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                    <%f_busqueda.dibujacampo("code_nrut")%>
                                    - 
                                    <%f_busqueda.dibujacampo("code_xdv")%>
                                    </font><a href="javascript:buscar_persona('busqueda[0][code_nrut]', 'busqueda[0][code_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></div></td>
                              </tr>
                            </table></td>
                      <td width="14%"><div align="center"><%botonera.DibujaBoton "buscar" %></div></td>
                    </tr>
                  </table>
				</form>
                </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
      </tr>
    </table>	
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Listado
                          de Env&iacute;os
                          a Cobranza</font></div>
                    </td>
                    <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                  </tr>
                </table>
              </td>
              <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
            </tr>
          </table>
		  
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"> <div align="center">&nbsp; <br>
                    <%pagina.DibujarTituloPagina%>
                    <br>
                  </div>
                  <table width="665" border="0">
                    <tr> 
                      <td width="116">&nbsp;</td>
                      <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                          <%f_listado.AccesoPagina%>
                        </div></td>
                      <td width="24"> <div align="right"> </div></td>
                    </tr>
                  </table> 
                  <form name="edicion">
				  <table width="100%" cellspacing="0" cellpadding="0">
                    <tr>
                      <td><div align="center">
                          <% f_listado.DibujaTabla %>
                        </div></td>
                    </tr>
                  </table> 
                  </form>
                    <br>
                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="335" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td><div align="center"> 
                          <%botonera.DibujaBoton "agregar" %>
                        </div></td>
                      <td><div align="center">
                          <%
						   botonera.agregabotonparam "enviar_folio", "url", "Proc_Envios_Emp_Cobra.asp"
						   botonera.dibujaboton "enviar_folio" %>
                        </div></td>
                      <td align="center" valign="middle"> 
					    <% botonera.agregabotonparam "eliminar", "url", "Proc_Empresa_Eliminar.asp"
						     botonera.dibujaboton "eliminar"%>
                        
                      </td>
                      <td><div align="center"> 
                          <%botonera.DibujaBoton "salir" %>
                        </div></td>
                    </tr>
                  </table>
                  
                </td>
                <td width="27" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
              </tr>
              <tr>
                <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
              </tr>
            </table>
        </td>
      </tr>
    </table>
	<p>&nbsp;</p></td>
  </tr>  
</table>
</body>
</html>
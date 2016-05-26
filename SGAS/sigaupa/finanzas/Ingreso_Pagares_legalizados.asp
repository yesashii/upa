<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Ingreso de Pagares Legalizados"
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-------------------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Ingreso_Pagares_Legalizados.xml", "botonera"
'-------------------------------------------------------------------------------

 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado = request.querystring("busqueda[0][code_nrut]")
 rut_apoderado_digito = request.querystring("busqueda[0][code_xdv]")
 num_pagare = request.querystring("busqueda[0][paga_ncorr]")

 'notaria  = request.querystring("busqueda[0][inen_ccod]")
 folio  = request.querystring("busqueda[0][enpa_ncorr]")
 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "Ingreso_Pagares_Legalizados.xml", "busqueda_letras"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 

 f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
 f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
 f_busqueda.AgregaCampoCons "code_nrut", rut_apoderado
 f_busqueda.AgregaCampoCons "code_xdv", rut_apoderado_digito
 f_busqueda.AgregaCampoCons "paga_ncorr", num_pagare

 'f_busqueda.AgregaCampoCons "inen_ccod", notaria
 f_busqueda.AgregaCampoCons "enpa_ncorr", folio

'----------------------------------------------------------------------------
 set f_letras = new CFormulario
 f_letras.Carga_Parametros "Ingreso_Pagares_Legalizados.xml", "f_letras"
 f_letras.Inicializar conexion


			  
'consulta = "select pag.enpa_ncorr,pag.enpa_ncorr enpa_ncorr_c, pag.paga_fpagare,pag.paga_finicio_pago,pag.PAGA_NCORR, pag.epag_ccod,pag.PAGA_NCORR nro_pagare, "& vbCrLf &_
'"	   	   	(nvl(bba.BENE_MMONTO_ACUM_MATRICULA,0) + nvl(bba.BENE_MMONTO_ACUM_COLEGIATURA,0)) as valor_pagar, "& vbCrLf &_
'"			 pp.PERS_NRUT ||'-'||pp.PERS_XDV as rut_post,  epag.EPAG_TDESC, "& vbCrLf &_
'"			 ppc.PERS_NRUT ||'-'||ppc.PERS_XDV as rut_codeudor "& vbCrLf &_
'"			 from postulantes p,personas pp, "& vbCrLf &_
'"			 personas ppc, "& vbCrLf &_
'"			 codeudor_postulacion cp,  "& vbCrLf &_
'"			 beneficios bba,  "& vbCrLf &_
'"			 contratos con, pagares pag,estados_pagares epag "& vbCrLf &_
'"			 where p.pers_ncorr=pp.pers_ncorr  "& vbCrLf &_
'"			 and con.post_ncorr=p.post_ncorr   "& vbCrLf &_
'"			 and con.CONT_NCORR=pag.CONT_NCORR   "& vbCrLf &_
'"			 and pag.PAGA_NCORR=bba.PAGA_NCORR   "& vbCrLf &_
'"			 and pag.EPAG_CCOD=2 "& vbCrLf &_
'"			and pag.EPAG_CCOD=epag.EPAG_CCOD  "& vbCrLf &_
'" 			 and bba.EBEN_CCOD =1   "& vbCrLf &_
'"			 and con.econ_ccod=1  "& vbCrLf &_
'"			 and p.post_ncorr=cp.post_ncorr (+) "& vbCrLf &_
'"			 and cp.pers_ncorr =ppc.pers_ncorr (+)   "'

consulta = "select pag.enpa_ncorr,pag.enpa_ncorr enpa_ncorr_c, pag.paga_fpagare,pag.paga_finicio_pago,pag.PAGA_NCORR,"& vbCrLf &_
		"             pag.epag_ccod,pag.PAGA_NCORR nro_pagare, "& vbCrLf &_
		"	   	   	(isnull(bba.BENE_MMONTO_ACUM_MATRICULA,0) + isnull(bba.BENE_MMONTO_ACUM_COLEGIATURA,0)) as valor_pagar, "& vbCrLf &_
		"			 cast(pp.PERS_NRUT as varchar) + '-' + pp.PERS_XDV as rut_post,  epag.EPAG_TDESC, "& vbCrLf &_
		"			 cast(ppc.PERS_NRUT as varchar) + '-' + ppc.PERS_XDV as rut_codeudor "& vbCrLf &_
		"			 from postulantes p,personas pp, "& vbCrLf &_
		"			 personas ppc, "& vbCrLf &_
		"			 codeudor_postulacion cp,  "& vbCrLf &_
		"			 beneficios bba,  "& vbCrLf &_
		"			 contratos con, pagares pag,estados_pagares epag "& vbCrLf &_
		"			 where p.pers_ncorr=pp.pers_ncorr  "& vbCrLf &_
		"			 and con.post_ncorr=p.post_ncorr   "& vbCrLf &_
		"			 and con.CONT_NCORR=pag.CONT_NCORR   "& vbCrLf &_
		"			 and pag.PAGA_NCORR=bba.PAGA_NCORR   "& vbCrLf &_
		"			 and pag.EPAG_CCOD=2 "& vbCrLf &_
		"			and pag.EPAG_CCOD=epag.EPAG_CCOD  "& vbCrLf &_
		" 			 and bba.EBEN_CCOD =1   "& vbCrLf &_
		"			 and con.econ_ccod=1  "& vbCrLf &_
		"			 and p.post_ncorr =cp.post_ncorr  "& vbCrLf &_
		"			 and cp.pers_ncorr = ppc.pers_ncorr "& vbCrLf 

	if rut_alumno <> "" then
				consulta = consulta &  "			and  pp.pers_nrut = '"&rut_alumno&"'   "
			end if
			if rut_apoderado <> "" then
				consulta = consulta &  "			and  ppc.pers_nrut  = '"&rut_apoderado&"'   "
			end if
			if num_pagare <> "" then
				consulta = consulta &  "			and  pag.PAGA_NCORR  = '"&num_pagare&"'   "
			end if
			
			if folio <> "" then
				consulta = consulta &  "			and  pag.enpa_ncorr  = '"&folio&"'   "
			end if	
	   
			 





if Request.QueryString <> "" then
	  f_letras.consultar consulta
  else
	f_letras.consultar "select '' where 1 = 2"
	f_letras.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
  end if	
'response.Write("<pre>"&consulta&"</pre>")
'response.End()	
	
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

var tabla; 
function inicio() {
tabla = new CTabla("letras");
	
}		

</script>



</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<BR>
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
                    <td width="14" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="159" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador 
                          de Pagares</font></div></td>
                      <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="487" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
				<form name="buscador"><BR>
                  <table width="98%"  border="0">
                    <tr>
                      <td width="81%"><table width="524" border="0">
                              <tr> 
                                <td width="86">Rut Alumno</td>
                                <td width="17">:</td>
                                <td width="151"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                  <%f_busqueda.DibujaCampo("pers_nrut") %>
                                  - 
                                  <%f_busqueda.DibujaCampo("pers_xdv")%>
                                  </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                                <td width="93">Rut Apoderado</td>
                                <td width="12">:</td>
                                <td width="139"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                  <%f_busqueda.DibujaCampo("code_nrut")%>
                                  - 
                                  <%f_busqueda.DibujaCampo("code_xdv")%>
                                  </font><a href="javascript:buscar_persona('busqueda[0][code_nrut]', 'busqueda[0][code_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                              </tr>
                              <tr> 
                                <td>N&ordm; Pagare</td>
                                <td>:</td>
                                <td><% f_busqueda.DibujaCampo ("paga_ncorr")%></td>
                                <td>N&ordm; Folio</td>
                                <td>:</td>
                                <td> <% f_busqueda.dibujaCampo ("enpa_ncorr") %> </td>
                              </tr>
                            </table></td>
                      <td width="19%"><div align="center"><% botonera.DibujaBoton ("buscar") %></div></td>
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
                    <td width="156" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Resultado
                        de la B&uacute;squeda</font></div>
                    </td>
                    <td width="501" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
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
                <td bgcolor="#D8D8DE"> <div align="center"><BR> 
                    <%pagina.DibujarTituloPagina%>
                  </div>
                  <table width="665" border="0">
                    <tr> 
                      <td width="116">&nbsp;</td>
                      <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                          <%f_letras.AccesoPagina%>
                        </div></td>
                      <td width="24"> <div align="right"> </div></td>
                    </tr>
                  </table> 
                  <form name="edicion">
                    <div align="center">
                      <% f_letras.DibujaTabla() %>
                    </div>
                    </form>
                    <br>
                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="72" bgcolor="#D8D8DE"><table width="100%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="19%">
                        <div align="left">
						<% if (f_letras.nrofilas >0) then 
						      botonera.AgregaBotonParam "legalizar_pagares","deshabilitado","FALSE"
						  else 
						      botonera.AgregaBotonParam "legalizar_pagares","deshabilitado","TRUE"
						  end if 
						  %>
                          <% botonera.DibujaBoton ("legalizar_pagares") %>
						  
                          </div></td>
                      <td width="81%">
                        <div align="left">
                          <% botonera.DibujaBoton ("cancelar") %>
                          </div></td>
                    </tr>
                  </table>
                </td>
                <td width="290" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
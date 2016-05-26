<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Protestar Pagares"
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-------------------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Ingreso_Pagares_Protestados.xml", "botonera"
'-------------------------------------------------------------------------------

 rut_alumno 			= request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito 		= request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado 			= request.querystring("busqueda[0][code_nrut]")
 rut_apoderado_digito 	= request.querystring("busqueda[0][code_xdv]")
 num_pagare 			= request.querystring("busqueda[0][paga_ncorr]")

 'notaria  = request.querystring("busqueda[0][inen_ccod]")
 folio  = request.querystring("busqueda[0][enpa_ncorr]")
 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "Ingreso_Pagares_Protestados.xml", "busqueda_letras"
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
 f_letras.Carga_Parametros "Ingreso_Pagares_Protestados.xml", "f_letras"
 f_letras.Inicializar conexion


			  
consulta = "select j.enpa_ncorr,protic.trunc(j.paga_fpagare) as paga_fpagare,protic.trunc(j.paga_finicio_pago) as paga_finicio_pago,  e.bene_ncorr, "& vbCrLf &_
			"	j.enpa_ncorr enpa_ncorr_c,j.PAGA_NCORR, j.epag_ccod,j.PAGA_NCORR nro_pagare, "& vbCrLf &_
			"	(isnull(e.BENE_MMONTO_ACUM_MATRICULA,0) + isnull(e.BENE_MMONTO_ACUM_COLEGIATURA,0)) as valor_pagar, "& vbCrLf &_
			"	(isnull(e.BENE_MMONTO_ACUM_MATRICULA,0) + isnull(e.BENE_MMONTO_ACUM_COLEGIATURA,0)) as valor_pagar_c, "& vbCrLf &_
			"	cast(b.PERS_NRUT as varchar) +'-'+cast(b.PERS_XDV as varchar) as rut_post,  "& vbCrLf &_
			"	k.EPAG_TDESC,h.INST_CCOD, cast(c.PERS_NRUT as varchar) +'-'+cast(c.PERS_XDV as varchar) as rut_codeudor, b.PERS_NCORR ,"& vbCrLf &_
			"	c.pers_ncorr as pers_ncorr_codeudor"& vbCrLf &_
			" from "& vbCrLf &_
			" postulantes a "& vbCrLf &_
			" join personas b "& vbCrLf &_
			"    on a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
			" left outer join codeudor_postulacion d "& vbCrLf &_
			"    on a.post_ncorr  = d.post_ncorr "& vbCrLf &_
			" left outer join personas c "& vbCrLf &_
			"    on d.pers_ncorr = c.pers_ncorr "& vbCrLf &_
			" join ofertas_academicas f "& vbCrLf &_
			"    on  a.ofer_ncorr=f.ofer_ncorr "& vbCrLf &_
			" join especialidades g "& vbCrLf &_
			"    on f.espe_ccod=g.espe_ccod  "& vbCrLf &_
			" join carreras h "& vbCrLf &_
			"    on g.carr_ccod=h.carr_ccod "& vbCrLf &_
			" join contratos i "& vbCrLf &_
			"    on a.post_ncorr=i.post_ncorr "& vbCrLf &_
			" join pagares j "& vbCrLf &_
			"    on i.CONT_NCORR=j.CONT_NCORR "& vbCrLf &_
			" join estados_pagares k "& vbCrLf &_
			"    on j.EPAG_CCOD=k.EPAG_CCOD "& vbCrLf &_
			" left outer join beneficios e "& vbCrLf &_
			"    on j.PAGA_NCORR=e.PAGA_NCORR "& vbCrLf &_
			"    and e.EBEN_CCOD=1 "& vbCrLf &_  
			" where j.EPAG_CCOD in (1,3) "& vbCrLf &_
			"    and i.econ_ccod=1  "

	if rut_alumno <> "" then
				consulta = consulta &  "	and  b.pers_nrut = '"&rut_alumno&"'   "
			end if
			if rut_apoderado <> "" then
				consulta = consulta &  "	and  c.pers_nrut  = '"&rut_apoderado&"'   "
			end if
			if num_pagare <> "" then
				consulta = consulta &  "	and  j.PAGA_NCORR  = '"&num_pagare&"'   "
			end if
			
			if folio <> "" then
				consulta = consulta &  "	and  j.enpa_ncorr  = '"&folio&"'   "
			end if	
	   

'response.Write("<pre>" & consulta & "</pre>")
'response.End()
 'f_letras.consultar consulta

 
 if Request.QueryString <> "" then
	  f_letras.consultar consulta
  else
	f_letras.consultar "select '' where 1 = 2"
	f_letras.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
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



</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
						<% if ( f_letras.nrofilas >0) then 
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
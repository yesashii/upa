<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

set pagina = new CPagina
pagina.Titulo = "Ingresos matricula"
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'-----------------------------------------------------------------------
 sede_ccod = request.querystring("busqueda[0][sede_ccod]")
 inicio = request.querystring("busqueda[0][inicio]")
 termino = request.querystring("busqueda[0][termino]")
  
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "ingresos_matricula.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' from dual"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "sede_ccod", sede_ccod
 f_busqueda.AgregaCampoCons "inicio", inicio
  f_busqueda.AgregaCampoCons "termino", termino
'-----------------------------------------------------------------------
 set botonera = new CFormulario
 botonera.Carga_Parametros "ingresos_matricula.xml", "botonera"
'-----------------------------------------------------------------------
 set f_consulta = new CFormulario
 f_consulta.Carga_Parametros "ingresos_matricula.xml", "f_contratos"
 f_consulta.Inicializar conexion 

 set f_contratos = new CFormulario
 f_contratos.Carga_Parametros "ingresos_matricula.xml", "f_contratos"
 f_contratos.Inicializar conexion 
 
 sql = "SELECT a.cont_ncorr, trunc(a.cont_fcontrato) as cont_fcontrato, "& vbCrLf &_
			   "c.pers_nrut || '-' || c.pers_xdv as rut_alumno,  "& vbCrLf &_
			   "c.pers_tape_paterno || ' ' || c.pers_tape_materno || ' ' || c.pers_tnombre as nombre_alumno, "& vbCrLf &_
			   "g.INGR_NFOLIO_REFERENCIA, trunc(g.INGR_FPAGO) AS ingr_fpago "& vbCrLf &_
		"FROM contratos a, postulantes b, personas_postulante c, compromisos d, "& vbCrLf &_
			 "detalle_compromisos e, abonos f,ingresos g, ofertas_academicas h "& vbCrLf &_
		"WHERE a.post_ncorr = b.post_ncorr "& vbCrLf &_
		  "and a.econ_ccod = 1 "& vbCrLf &_ 
		  "and b.pers_ncorr = c.pers_ncorr "& vbCrLf &_
		  "and d.tcom_ccod in (1,2) "& vbCrLf &_
		  "and a.cont_ncorr = d.comp_ndocto "& vbCrLf &_
		  "and d.tcom_ccod = e.tcom_ccod "& vbCrLf &_
		  "and d.inst_ccod = e.inst_ccod "& vbCrLf &_
		  "and d.comp_ndocto = e.comp_ndocto "& vbCrLf &_
		  "and e.tcom_ccod = f.tcom_ccod "& vbCrLf &_
		  "and e.inst_ccod = f.inst_ccod "& vbCrLf &_
		  "and e.comp_ndocto = f.comp_ndocto "&_
		  "and e.dcom_ncompromiso = f.dcom_ncompromiso "& vbCrLf &_
		  "and f.ingr_ncorr = g.ingr_ncorr "& vbCrLf &_
		  "and b.ofer_ncorr = h.ofer_ncorr "& vbCrLf &_ 
		  "and g.EING_CCOD = 4  "& vbCrLf &_
		  "and a.peri_ccod ='" & Periodo & "' "& vbCrLf &_ 
		  "and h.sede_ccod = nvl('" & sede_ccod & "',h.sede_ccod) "& vbCrLf &_ 
		  "and trunc(a.cont_fcontrato) BETWEEN  nvl('" & inicio & "',a.cont_fcontrato) and nvl('" & termino & "',a.cont_fcontrato) "& vbCrLf &_
		"GROUP BY a.cont_ncorr, cont_fcontrato, c.pers_nrut , c.pers_xdv , "& vbCrLf &_
		   "c.pers_tape_paterno , c.pers_tape_materno , c.pers_tnombre, "& vbCrLf &_
		   "g.INGR_NFOLIO_REFERENCIA, ingr_fpago "& vbCrLf &_ 
		"ORDER BY cont_fcontrato DESC, a.cont_ncorr"& vbCrLf 
 
  
  if Request.QueryString <> "" then
	'response.Write("<PRE>" & sql & "</PRE>")
	f_contratos.Consultar sql
	f_consulta.Consultar sql
  else
	f_consulta.consultar "select '' from dual where 1 = 2"
	f_consulta.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
	f_contratos.consultar "select '' from dual where 1 = 2"
	f_contratos.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
	
  end if
 
 'f_contratos.Consultar sql
 
' f_consulta.Consultar sql
 fila = 0
 while f_consulta.Siguiente
    total = 0
	contrato = f_consulta.ObtenerValor ("cont_ncorr")
	sql = genera_sql_compromisos (contrato, 1)
	monto_matricula = conexion.ConsultaUno(sql)
	f_contratos.AgregaCampoFilaCons fila, "monto_matricula" , monto_matricula

	sql = genera_sql_compromisos (contrato, 2)
	monto_colegiatura = conexion.ConsultaUno(sql)
	f_contratos.AgregaCampoFilaCons fila, "monto_colegiatura" , monto_colegiatura
		
	sql = genera_sql_beneficios (contrato, 1)
	monto_credito = conexion.ConsultaUno(sql)
	f_contratos.AgregaCampoFilaCons fila, "monto_credito" , monto_credito
	if trim(monto_credito) <> "" then
	else  
	  monto_credito = "0"
    end if
	
	sql = genera_sql_beneficios (contrato, 2)
	monto_beca = conexion.ConsultaUno(sql)
	f_contratos.AgregaCampoFilaCons fila, "monto_beca" , monto_beca
	if trim(monto_beca) <> "" then
	else  
	  monto_beca = "0"
    end if
	
	sql = genera_sql_beneficios (contrato, 3)
	monto_descuento = conexion.ConsultaUno(sql)
	f_contratos.AgregaCampoFilaCons fila, "monto_descuento" , monto_descuento
	if trim(monto_descuento) <> "" then
	else  
	  monto_descuento = "0"
    end if
	
	total = clng(monto_matricula) + clng(monto_colegiatura) - clng(monto_credito) - clng(monto_beca) - clng(monto_descuento)
	f_contratos.AgregaCampoFilaCons fila, "total" , total
	fila = fila + 1    
  wend
%>

<%
 function genera_sql_compromisos(contrato,tipo_compromiso)
      sql =  "SELECT nvl(a.comp_mneto,0) + nvl(a.comp_mintereses,0) as monto_matricula  "&_
			"FROM contratos z, compromisos a, tipos_compromisos b  "&_
			"WHERE z.cont_ncorr = a.comp_ndocto " &_
			  "and a.tcom_ccod = b.tcom_ccod  "&_
			  "and a.comp_ndocto =" & contrato& "  "&_ 
			  "and a.tcom_ccod =" & tipo_compromiso 
	 genera_sql_compromisos = sql
 end function

function genera_sql_beneficios (contrato, tipo_beneficio)
  sql = "select  sum(nvl(-b.DETA_MVALOR_DETALLE,0)) as total  "&_ 
		"from compromisos a, detalles b, stipos_descuentos c , beneficios d "&_
		"where a.comp_ndocto = b.COMP_NDOCTO "&_
		  "and a.tcom_ccod = b.tcom_ccod "&_
		  "and a.inst_ccod = b.inst_ccod "&_
		  "and a.tcom_ccod in (1,2) "&_
		  "and b.tdet_ccod  = c.STDE_CCOD "&_
		  "and c.stde_ccod = c.stde_ccod "&_
		  "and a.COMP_NDOCTO = d.CONT_NCORR "&_
		  "and c.STDE_CCOD = d.stde_ccod "&_
		  "and c.tben_ccod =" & tipo_beneficio & " "&_
		  "and a.comp_ndocto =" & contrato		  
  genera_sql_beneficios = sql
end function

%>
<html>
<head>
<title>Buscar Documento</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>



</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="800" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="100%" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
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
                <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr> 
                <th nowrap><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></th>
                <th nowrap> <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="183" valign="bottom" background="../imagenes/fondo1.gif"> 
                        <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador 
                          de Documentos</font></div></td>
                      <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                      <td width="458" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                    </tr>
                  </table></th>
                <th nowrap><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></th>
              </tr>
              <tr> 
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
				<form name="buscador">
                  <table width="98%"  border="0">
                    <tr>
                      <td width="81%" height=""><table width="514" border="0">
                              <tr> 
                                <td width="105"> <div align="left">Periodo Inicio</div></td>
                                <td width="17">:</td>
                                <td width="108"> <% f_busqueda.dibujaCampo ("inicio")%> </td>
                                <td width="60">Termino</td>
                                <td width="22">:</td>
                                <td width="176">
                                  <% f_busqueda.dibujaCampo ("termino")%>
                                </td>
                              </tr>
                              <tr> 
                                <td>Sede</td>
                                <td>:</td>
                                <td><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                    <% f_busqueda.dibujaCampo ("sede_ccod")%>
                                    </font></div></td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
                              <!-- 
					    <tr>
                          <td>Rut Alumno</td>
                          <td>:</td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                  <%'f_busqueda.DibujaCampo("pers_nrut") %>
                                  - 
                                  <%'f_busqueda.DibujaCampo("pers_xdv") %>
                                  </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                        </tr>
                        <tr>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut
                              Apoderado</font></td>
                          <td>:</td>
                          <td><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                    <%'f_busqueda.DibujaCampo("code_nrut")%>
                                    -
                                    <%'f_busqueda.DibujaCampo("code_xdv")%>
                                    </font><a href="javascript:buscar_persona('busqueda[0][code_nrut]', 'busqueda[0][code_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></div>
                          </td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                        </tr>
						-->
                            </table></td>
                      <td width="19%"><div align="center"><% botonera.DibujaBoton ("buscar")%></div></td>
                    </tr>
                  </table>
				</form>
                </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="100%" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
      </tr>
    </table>	
	  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="100%" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="100%" height="8" border="0"></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Documentos
                          Encontrados</font></div>
                    </td>
                    <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                  </tr>
                </table>
              </td>
              <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
            </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"> <div align="center">&nbsp; 
                    <BR><%pagina.DibujarTituloPagina%>
                    <table width="100%" border="0">
                      <tr> 
                        <td width="150">&nbsp;</td>
                        <td width="616"><div align="right">P&aacute;ginas: &nbsp; 
                            <% f_contratos.AccesoPagina%>
                          </div></td>
                        <td width="10"> 
                          <div align="right"> </div></td>
                      </tr>
                    </table>
                  </div>
                  <form name="edicion">
                    <div align="center">
                      <%  f_contratos.DibujaTabla() %>
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
                <td width="135" bgcolor="#D8D8DE"><table width="84%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="left"></div>                        
                        <div align="left">
                          <% botonera.dibujaBoton "lanzadera" %>
                          </div></td>
                    </tr>
                  </table>
                </td>
                <td width="100%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                <td width="100%" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
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
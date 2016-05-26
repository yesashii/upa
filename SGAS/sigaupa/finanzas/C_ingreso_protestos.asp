<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'<!-- #include file = "../biblioteca/_conexion_prod.asp" -->
set pagina = new CPagina
pagina.Titulo = "ingreso de protestos"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Ingreso_Protestos.xml", "botonera"
'-----------------------------------------------------------------------
 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado = request.querystring("busqueda[0][code_nrut]")
 rut_apoderado_digito = request.querystring("busqueda[0][code_xdv]")
 num_doc = request.querystring("busqueda[0][ding_ndocto]")
 estado_doc = request.querystring("busqueda[0][edin_ccod]")
 vencimiento = request.querystring("busqueda[0][ding_fdocto]")
 tipo_doc = request.querystring("busqueda[0][ting_ccod]")
 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "Ingreso_Protestos.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' from dual"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
 f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
 f_busqueda.AgregaCampoCons "code_nrut", rut_apoderado
 f_busqueda.AgregaCampoCons "code_xdv", rut_apoderado_digito
 f_busqueda.AgregaCampoCons "ding_ndocto", num_doc
 f_busqueda.AgregaCampoCons "edin_ccod", estado_doc
 f_busqueda.AgregaCampoCons "ding_fdocto", vencimiento
 f_busqueda.AgregaCampoCons "ting_ccod", tipo_doc
'-----------------------------------------------------------------------
 set f_datos = new CFormulario
 f_datos.Carga_Parametros "Ingreso_Protestos.xml", "f_documentos"
 f_datos.Inicializar conexion

 set f_documentos = new CFormulario
 f_documentos.Carga_Parametros "Ingreso_Protestos.xml", "f_documentos"
 f_documentos.Inicializar conexion

sql = "select a.ding_ndocto, a.ding_ndocto as c_ding_ndocto, a.ting_ccod, a.edin_ccod, a.ingr_ncorr, "& vbCrLf &_
	         "a.ding_mdocto, a.ding_nsecuencia,   "& vbCrLf &_
	         "c.pers_ncorr, obtener_rut(c.pers_ncorr) as rut_alumno, obtener_rut(f.pers_ncorr) as rut_apoderado,   "& vbCrLf &_
	         "trunc(b.ingr_fpago) as ingr_fpago, trunc(a.ding_fdocto) as ding_fdocto,   "& vbCrLf &_
	         "i.ting_tdesc, j.edin_tdesc,   "& vbCrLf &_
	         "'' as multa,   "& vbCrLf &_
	         "h.tcom_ccod, h.inst_ccod, h.comp_ndocto, h.tcom_ccod as c_tcom_ccod, "& vbCrLf &_
	         "w.total	as reca_mmonto  "& vbCrLf &_
"from detalle_ingresos a,   "& vbCrLf &_
	 "ingresos b, tipos_ingresos i, estados_detalle_ingresos j, personas c,   "& vbCrLf &_
	 "postulantes d, codeudor_postulacion e, personas f, abonos g, detalle_compromisos h, compromisos k, "& vbCrLf &_
	    "(select x.ting_ccod, x.ding_ndocto, x.ingr_ncorr, sum (x.reca_mmonto) as total  "& vbCrLf &_
        " from referencias_cargos x "& vbCrLf &_
        "group by  x.ting_ccod, x.ding_ndocto, x.ingr_ncorr "& vbCrLf &_
        ")w	  	    "& vbCrLf &_
"where a.ding_ncorrelativo = 1   "& vbCrLf &_
  "and a.ingr_ncorr = b.ingr_ncorr   "& vbCrLf &_
  "and a.ting_ccod = i.ting_ccod   "& vbCrLf &_
  "and a.edin_ccod = j.edin_ccod   "& vbCrLf &_
  "and b.pers_ncorr = c.pers_ncorr   "& vbCrLf &_
  "and b.pers_ncorr = d.pers_ncorr   "& vbCrLf &_
  "and d.post_ncorr = e.post_ncorr   "& vbCrLf &_
  "and e.pers_ncorr = f.pers_ncorr   "& vbCrLf &_
  "and b.ingr_ncorr = g.ingr_ncorr  "& vbCrLf &_
  "and g.tcom_ccod = h.tcom_ccod  "& vbCrLf &_
  "and g.inst_ccod = h.inst_ccod  "& vbCrLf &_
  "and g.comp_ndocto = h.comp_ndocto  "& vbCrLf &_
  "and g.dcom_ncompromiso = h.dcom_ncompromiso  "& vbCrLf &_
  "and h.tcom_ccod = k.tcom_ccod  "& vbCrLf &_
  "and h.inst_ccod = k.inst_ccod  "& vbCrLf &_
  "and h.comp_ndocto = k.comp_ndocto "& vbCrLf &_
  "and a.ting_ccod = w.ting_ccod (+) "& vbCrLf &_
  "and a.ding_ndocto = w.ding_ndocto (+) "& vbCrLf &_
  "and a.ingr_ncorr = w.ingr_ncorr (+) "& vbCrLf &_
  "and a.ding_ndocto = nvl('" & num_doc & "',a.ding_ndocto) "& vbCrLf &_
  "and c.pers_nrut = nvl('" & rut_alumno & "', c.pers_nrut) "& vbCrLf &_
  "and a.ting_ccod = nvl('" & tipo_doc & "', a.ting_ccod) "& vbCrLf &_
  "and a.edin_ccod = nvl('" & estado_doc & "', a.edin_ccod) "& vbCrLf &_
  "and a.ding_fdocto = nvl('" & vencimiento & "',a.ding_fdocto) "& vbCrLf &_
  "and f.pers_nrut = nvl('" & rut_apoderado & "', f.pers_nrut) "

	   
   response.Write("<pre>" & sql & "</pre>")
  fila = 0
  if Request.QueryString <> "" then
    f_documentos.Consultar sql
	f_datos.Consultar sql
	
	'while f_datos.Siguiente
     ' estado = f_datos.ObtenerValor("edin_ccod")
	  
	 ' if estado = "9" or estado = "18" or estado = "17" or estado = "6" then
	 '   f_documentos.AgregaCampoFilaParam fila, "multa" , "permiso", "LECTURA"
	'	f_documentos.AgregaCampoFilaParam fila, "multa" , "formato", "MONEDA"
	'  end if
	'fila = fila + 1
	'wend
 
  else
	f_documentos.consultar "select '' from dual where 1 = 2"
	f_documentos.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
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
    <td valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
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
              <td width="9"><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="100%" height="1" border="0" alt=""></td>
              <td width="7"><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
            <tr>
              <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td width="9"><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><%pagina.DibujarLenguetas Array("Búsqueda de documentos"), 1%></td>
              <td width="7"><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>              
            </tr>
            <tr>
              <td width="9"><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
              <td width="7"><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
				<form name="buscador">
                      <table width="98%"  border="0">
                        <tr> 
                          <td width="100%"><table width="660" border="0" align="left">
                              <tr> 
                                <td width="93"><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">N&ordm; 
                                    Documento</font></div></td>
                                <td width="10">:</td>
                                <td width="134"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                  <% f_busqueda.DibujaCampo ("ding_ndocto") %>
                                  </font></td>
                                <td width="20"><div align="center"></div></td>
                                <td width="86">tipo</td>
                                <td width="13">:</td>
                                <td width="166"><% f_busqueda.DibujaCampo ("ting_ccod")%></td>
                                <td width="104" rowspan="6"><div align="center"></div>
                                  <div align="center"> 
                                    <%botonera.DibujaBoton "buscar" %>
                                  </div></td>
                              </tr>
                              <tr> 
                                <td><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut 
                                    Alumno </font></div></td>
                                <td>:</td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                  <% f_busqueda.DibujaCampo ("pers_nrut") %>
                                  - 
                                  <% f_busqueda.DibujaCampo ("pers_xdv") %>
                                  </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a><font face="Verdana, Arial, Helvetica, sans-serif" size="1">&nbsp; 
                                  </font></td>
                                <td>&nbsp;</td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut 
                                  Apoderado</font></td>
                                <td>:</td>
                                <td><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                    <% f_busqueda.DibujaCampo ("code_nrut") %>
                                    - 
                                    <% f_busqueda.DibujaCampo ("code_xdv") %>
                                    </font><a href="javascript:buscar_persona('busqueda[0][code_nrut]', 'busqueda[0][code_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></div></td>
                              </tr>
                              <tr> 
                                <td>F. Vencimiento</td>
                                <td>:</td>
                                <td><% f_busqueda.DibujaCampo ("ding_fdocto")%></td>
                                <td>&nbsp;</td>
                                <td>Estado</td>
                                <td>:</td>
                                <td> <% f_busqueda.DibujaCampo ("edin_ccod") %> </td>
                              </tr>
                          
                            </table></td>
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
	<br>		
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->              
              <tr>
                <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1%></td>
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
                  
                <td bgcolor="#D8D8DE"> <div align="center"><BR>
                    <%pagina.DibujarTituloPagina%>
                    <table width="100%" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                            <% f_documentos.AccesoPagina %>
                          </div></td>
                        <td width="24"> <div align="right"> </div></td>
                      </tr>
                    </table>
                    <br>
                  </div>
                  <form name="edicion">
                    <div align="center"><% f_documentos.DibujaTabla()%><br>
                    </div>
                    </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="206" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center">
                        <% botonera.DibujaBoton ("protestar") %>
                      </div></td>
                      <td><div align="center">
                        <% botonera.DibujaBoton ("lanzadera")%>
                      </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="150" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="310" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
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

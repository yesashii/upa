<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Pactación de Pagares"
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion
'----------------------------------------------------------------------
'set cajero = new CCajero
'cajero.inicializar conexion, negocio.obtenerUsuario, negocio.obtenerSede

'if not cajero.TieneCajaAbierta then
 ' session("mensajeerror")= "No puede ingresar cedentes sin tener una caja abierta"
 ' response.Redirect("../lanzadera/lanzadera.asp") 
' end if
 
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Ingreso_Cedentes.xml", "botonera"
'-----------------------------------------------------------------------
 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado = request.querystring("busqueda[0][code_nrut]")
 rut_apoderado_digito = request.querystring("busqueda[0][code_xdv]")
 num_doc = request.querystring("busqueda[0][ding_ndocto]")
  
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
' -----------------------------------------------------------------------
 set f_letras = new CFormulario
 f_letras.Carga_Parametros "Ingreso_Cedentes.xml", "f_letras"
 f_letras.Inicializar conexion
 
 sql = "SELECT a.ding_ndocto, a.ding_ndocto as c_ding_ndocto, a.ding_nsecuencia, a.ting_ccod, a.ingr_ncorr, d.ting_tdesc, "&_
		   "c.edin_ccod, c.edin_tdesc, trunc(b.ingr_fpago) as ingr_fpago, trunc(a.ding_fdocto) as ding_fdocto,  "&_
		   "obtener_rut(f.pers_ncorr) as rut_alumno, obtener_rut(h.pers_ncorr) as rut_apoderado,  "&_
		   "a.ding_mdetalle  "&_
	 "FROM detalle_ingresos a, ingresos b, estados_detalle_ingresos c,  "&_
		 "tipos_ingresos d,  postulantes e,  personas f,  "&_
		 "codeudor_postulacion g,  personas h  "&_
	 "WHERE a.ting_ccod = 4	 "&_ 
	   "and a.edin_ccod = 4 "&_ 
	   "and a.ingr_ncorr = b.ingr_ncorr "&_ 
	   "and a.edin_ccod = c.edin_ccod "&_ 
	   "and a.ting_ccod = d.ting_ccod  "&_
	   "and b.pers_ncorr = e.pers_ncorr "&_ 
	   "and e.peri_ccod = '" & Periodo & "'  "&_ 
	   "and e.pers_ncorr = f.pers_ncorr "&_ 
	   "and e.POST_NCORR = g.post_ncorr "&_ 
	   "and g.pers_ncorr = h.pers_ncorr "&_  
	   "and a.ding_ndocto = nvl('" & num_doc & "', a.ding_ndocto)  "&_
	   "and f.pers_nrut = nvl('" & rut_alumno & "', f.pers_nrut) "&_
	   "and h.pers_nrut = nvl('" & rut_apoderado & "', h.pers_nrut) "&_ 
	   "ORDER BY a.ding_ndocto"
	   
sql ="select pag.PAGA_NCORR, pag.epag_ccod,pag.PAGA_NCORR nro_pagare, epag.EPAG_TDESC,"&_
"	   	   	(nvl(bba.BENE_MMONTO_ACUM_MATRICULA,0) + nvl(bba.BENE_MMONTO_ACUM_COLEGIATURA,0)) as valor_pagar,"&_
"			 pp.PERS_NRUT ||'-'||pp.PERS_XDV as rut_post, "&_
"			 ppc.PERS_NRUT ||'-'||ppc.PERS_XDV as rut_codeudor "&_
"			 from postulantes p,personas_postulante pp,  "&_
"			 personas_postulante ppc, "&_
"			 codeudor_postulacion cp,  "&_
"			 beneficios bba, "&_
"			 contratos con, pagares pag,estados_pagares epag "&_
"			 where p.pers_ncorr=pp.pers_ncorr   "&_
"			 and con.post_ncorr=p.post_ncorr "&_
"			 and pag.EPAG_CCOD in (1,3) "&_
"			  and pag.EPAG_CCOD=epag.EPAG_CCOD   "&_
"			 and con.CONT_NCORR=pag.CONT_NCORR  "&_
"			 and pag.PAGA_NCORR=bba.PAGA_NCORR  "&_
"			 and bba.EBEN_CCOD <>3  "&_
"			 and con.econ_ccod<>3   "&_
"			 and p.post_ncorr=cp.post_ncorr  "&_
"			 and cp.pers_ncorr =ppc.pers_ncorr  "&_
"			 and not exists (select 1 from detalle_envios_pagares x, envios_pagares y   "&_
"									   where x.enpa_ncorr = y.enpa_ncorr  "&_
"									   and x.paga_ncorr = pag.paga_ncorr "&_
"									   and x.epag_ccod = pag.epag_ccod  "&_
"									   and x.epag_ccod =1 "&_
"									   and y.eenv_ccod = 1) "&_
"			and  pp.pers_nrut = nvl('',pp.pers_nrut)   "&_
"			and  ppc.pers_nrut = nvl('',ppc.pers_nrut) "&_
"			and  pag.PAGA_NCORR = nvl('',pag.PAGA_NCORR )"	   

 f_letras.consultar sql
 

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

<script language='JavaScript'> 
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

function procesar_tabla()
  {
    var tabla = new CTabla("letras");
    var loco,valor;	
	for (i = 0; i < tabla.filas.length; i++) 
     {  	    
	    valor = document.edicion.elements["letras[" + i + "][ding_ndocto]"].checked;	     
		 if (valor == true)
		  {
		      estado = tabla.ObtenerValor(i, "edin_ccod");
			  if (estado == 18)
			     document.edicion.elements["_letras[" + i + "][multa]"].setAttribute("disabled", false);			      
			  else
			    if (estado == 19)
				  document.edicion.elements["_letras[" + i + "][multa]"].setAttribute("disabled", false);
				else
			   	  if (estado == 20)
			       {
			          document.edicion.elements["_letras[" + i + "][multa]"].setAttribute("disabled", false);
			          document.edicion.elements["letras[" + i + "][nueva_fecha]"].setAttribute("disabled", false)
			       }
				  else
				    {
					  document.edicion.elements["_letras[" + i + "][multa]"].setAttribute("disabled", true);
			          document.edicion.elements["letras[" + i + "][nueva_fecha]"].setAttribute("disabled", true)
			        } 
		   }
	  }	 
  
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
                      <td width="84%"><div align="center">
                        <table width="524" border="0">
                          <tr>
                            <td>N&ordm; Letra</td>
                            <td>:</td>
                                  <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                                    <% f_busqueda.DibujaCampo ("ding_ndocto") %>
                                    </font></td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr>
                            <td>Rut Alumno</td>
                            <td>:</td>
                                  <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                    <% f_busqueda.DibujaCampo ("pers_nrut") %>
                                    - 
                                    <% f_busqueda.DibujaCampo ("pers_xdv") %>
                                    </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a><font face="Verdana, Arial, Helvetica, sans-serif" size="1">&nbsp; 
                                    </font></td>
                            <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut
                                Apoderado</font></td>
                            <td>:</td>
                            <td><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                      <% f_busqueda.DibujaCampo ("code_nrut") %>
                                      - 
                                      <% f_busqueda.DibujaCampo ("code_xdv") %>
                                      </font><a href="javascript:buscar_persona('busqueda[0][code_nrut]', 'busqueda[0][code_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></div>
                            </td>
                          </tr>
                        </table>
                      </div></td>
                      <td width="16%"><div align="center"><% botonera.DibujaBoton ("buscar")%></div></td>
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
      <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
        <tr> 
          <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
          <td height="8" background="../imagenes/top_r1_c2.gif"></td>
          <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
        </tr>
        <tr> 
          <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
          <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td> 
                  <%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1%>
                </td>
              </tr>
              <tr> 
                <td height="2" background="../imagenes/top_r3_c2.gif"></td>
              </tr>
              <tr> 
                <td><div align="center"><br>
                    <%pagina.DibujarTituloPagina%>
                    <table width="100%" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                            <% f_letras.AccesoPagina %>
                          </div></td>
                        <td width="3%"> 
                          <div align="right"> </div></td>
                      </tr>
                    </table>
                    <br>
                  </div>
                  <form name="edicion">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td> <div align="center">
                            <% f_letras.DibujaTabla()%>
                            <br>
                          </div></td>
                      </tr>
                    </table>
                    <br>
                  </form></td>
              </tr>
            </table></td>
          <td width="7" background="../imagenes/der.gif">&nbsp;</td>
        </tr>
        <tr> 
          <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
          <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="30%" height="20"><div align="center"> 
                    <table width="65%"  border="0" align="left" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td width="32%"><div align="center">
                            <% botonera.DibujaBoton ("ingresar") %>
                          </div></td>
                        <td width="56%"><div align="center">
                            <% boton
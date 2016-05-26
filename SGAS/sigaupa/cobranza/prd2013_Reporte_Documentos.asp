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

botonera.Carga_Parametros "reporte_cobranza.xml", "btn_reporte_cobranza"
f_busqueda.Carga_Parametros "reporte_cobranza.xml", "fbusqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'-----------------------------------------------------------------------
pagina.Titulo = "Reporte Detalles de Envíos a Cobranza"

'-----------------------------------------------------------------------
 sede = request.querystring("busqueda[0][sede_ccod]")
 empresa = request.querystring("busqueda[0][inen_ccod]")
 folio = request.querystring("busqueda[0][envi_ncorr]")
 inicio = request.querystring("busqueda[0][ingr_fpago]")
 termino = request.querystring("busqueda[0][envio_termino]") 
 tipo_docto = request.querystring("busqueda[0][ting_ccod]") 
 nro_docto = request.querystring("busqueda[0][ding_ndocto]") 
 estado_docto = request.querystring("busqueda[0][edin_ccod]") 
 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado = request.querystring("busqueda[0][code_nrut]")
 rut_apoderado_digito = request.querystring("busqueda[0][code_xdv]")
  nro_cuenta_corriente= request.querystring("busqueda[0][ding_tcuenta_corriente]")

f_busqueda.AgregaCampoCons "sede_ccod", sede
f_busqueda.AgregaCampoCons "inen_ccod", empresa
f_busqueda.AgregaCampoCons "envi_ncorr", folio
f_busqueda.AgregaCampoCons "ingr_fpago", inicio
f_busqueda.AgregaCampoCons "envio_termino", termino
f_busqueda.AgregaCampoCons "ting_ccod", tipo_docto
f_busqueda.AgregaCampoCons "ding_ndocto", nro_docto
f_busqueda.AgregaCampoCons "edin_ccod", estado_docto
f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
f_busqueda.AgregaCampoCons "code_nrut", rut_apoderado
f_busqueda.AgregaCampoCons "code_xdv", rut_apoderado_digito
 f_busqueda.AgregaCampoCons "ding_tcuenta_corriente", nro_cuenta_corriente
'---------------------------------------------------------------------------------------------------


set f_listado = new CFormulario
f_listado.Carga_Parametros "reporte_cobranza.xml", "f_listado"
f_listado.Inicializar conexion

sql_reporte =   "SELECT f.peri_ccod, d1.ting_tdesc, b.ding_ndocto as c_ding_ndocto,c.ding_tcuenta_corriente,convert(datetime,d.ingr_fpago,103) fecha_envio,  "&_
				" b.ding_ndocto, c.ding_mdocto, c.ding_fdocto,  "&_ 
				" c1.edin_tdesc, a.envi_fenvio, "&_
				" protic.format_rut(e.pers_nrut) as rut_alumno,   "&_
				" protic.format_rut(g1.pers_nrut) as rut_apoderado,   "&_
				" isnull(e.pers_nrut, 0) as pers_nrut, e.pers_xdv,   "&_
				" isnull(g1.pers_nrut, 0) as code_nrut, g1.pers_xdv as code_xdv   "&_
				" FROM envios a, detalle_envios b, detalle_ingresos c,   "&_
				" estados_detalle_ingresos c1, ingresos d, tipos_ingresos d1,   "&_
				" personas e, postulantes f, codeudor_postulacion g, "&_ 
				" personas g1,instituciones_envio h,  "&_
				" alumnos k,ofertas_academicas l, sedes m   "&_
				" WHERE a.envi_ncorr = b.envi_ncorr and   "&_
				" b.ting_ccod = c.ting_ccod and   "&_
				" c.ting_ccod = d1.ting_ccod and   "&_
				" b.ding_ndocto = c.ding_ndocto and   "&_
				" b.ingr_ncorr = c.ingr_ncorr and   "&_
				" c.ingr_ncorr = d.ingr_ncorr and   "&_
				" c.edin_ccod = c1.edin_ccod and   "&_
				" d.pers_ncorr = e.pers_ncorr and   "&_
				" e.pers_ncorr = f.pers_ncorr and   "&_
				" f.post_ncorr = g.post_ncorr and   "&_
				" g.pers_ncorr = g1.pers_ncorr and   "&_
				" cast(f.peri_ccod as varchar)='" & Periodo & "'  AND   "&_
				" f.post_ncorr *= k.post_ncorr   and k.emat_ccod=1 and   "&_
				" k.ofer_ncorr *= l.ofer_ncorr and   "&_
				" l.sede_ccod *= m.sede_ccod  and  "&_
				" a.inen_ccod = h.inen_ccod and   "&_
				" (h.TINE_CCOD = 3 or h.TINE_CCOD = 4) and  "&_
				" e.pers_nrut = isnull('" & rut_alumno & "', e.pers_nrut) and   "&_
				" g1.pers_nrut = isnull('" & rut_apoderado & "', g1.pers_nrut) and   "&_
				" protic.trunc(d.ingr_fpago) BETWEEN isnull('" & inicio & "', d.ingr_fpago) AND   "&_
				" isnull('" & termino & "', d.ingr_fpago) and   "&_
				" m.sede_ccod = isnull('" & sede &  "', m.sede_ccod) and   "&_
				" b.ting_ccod = isnull('" &   tipo_docto & "', b.ting_ccod) and   "&_
				" b.ding_ndocto = isnull('" & nro_docto & "', b.ding_ndocto) and   "&_
				" c.edin_ccod  = isnull('" & estado_docto & "', c.edin_ccod )  "&_
				" and isnull(c.ding_tcuenta_corriente , ' ') = isnull(isnull('" & nro_cuenta_corriente & "',c.ding_tcuenta_corriente), ' ') "&_
				" and c.repa_ncorr is null "&_ 
		        " and c.ding_ncorrelativo = 1 "&_ 
				" ORDER BY a.envi_ncorr  "	
				
consulta = "select a.edin_ccod, a.ting_ccod ,i.ting_tdesc, a.ding_ndocto as c_ding_ndocto,ee.envi_ncorr,  "& vbCrLf &_
"protic.trunc(b.ingr_fpago) as fecha_envio,a.ding_tcuenta_corriente, a.ding_ndocto, a.ding_mdetalle, "& vbCrLf &_
"protic.trunc(a.ding_fdocto) as ding_fdocto,h.edin_tdesc,b.ingr_ncorr,a.ding_mdocto,  "& vbCrLf &_
"protic.obtener_rut(b.pers_ncorr) as rut_alumno, protic.obtener_rut(a.pers_ncorr_codeudor) as rut_apoderado  "& vbCrLf &_
"	 from envios ee,  "& vbCrLf &_
"	 detalle_envios de,  "& vbCrLf &_
"	 detalle_ingresos a,   "& vbCrLf &_
"	 estados_detalle_ingresos a1,   "& vbCrLf &_
"	 ingresos b,   "& vbCrLf &_
"	 estados_detalle_ingresos h,   "& vbCrLf &_
"	 tipos_ingresos i,    "& vbCrLf &_
"		  personas j,  "& vbCrLf &_
"		  personas k,   "& vbCrLf &_
"		  abonos l,   "& vbCrLf &_
"		  detalle_compromisos m,   "& vbCrLf &_
"		  postulantes n,  "& vbCrLf &_
"		  ofertas_academicas o ,instituciones_envio hh,familias_estados_detalle_ingr fe  "& vbCrLf &_
"	 where   "& vbCrLf &_
"	   ee.envi_ncorr = de.envi_ncorr "& vbCrLf &_
"	   and de.ting_ccod = a.ting_ccod  "& vbCrLf &_
"	   and de.ding_ndocto = a.ding_ndocto   "& vbCrLf &_
"	 and de.ingr_ncorr = a.ingr_ncorr   "& vbCrLf &_
"	   and a.ingr_ncorr = b.ingr_ncorr     "& vbCrLf &_
"      and a.edin_ccod = a1.edin_ccod   "& vbCrLf &_
"		and a1.fedi_ccod = fe.fedi_ccod  "& vbCrLf &_
"      and a.ding_ncorrelativo = 1    "& vbCrLf &_
"	   and a.edin_ccod = h.edin_ccod    "& vbCrLf &_
"	   and a.ting_ccod = i.ting_ccod   "& vbCrLf &_
"	   and b.pers_ncorr = j.pers_ncorr   "& vbCrLf &_
"	   and a.pers_ncorr_codeudor  *= k.pers_ncorr    "& vbCrLf &_
"	   and b.ingr_ncorr = l.ingr_ncorr   "& vbCrLf &_
"	   and l.tcom_ccod = m.tcom_ccod   "& vbCrLf &_
"	   and l.inst_ccod = m.inst_ccod   "& vbCrLf &_
"	   and l.comp_ndocto = m.comp_ndocto  "& vbCrLf &_
"	   and l.dcom_ncompromiso = m.dcom_ncompromiso   "& vbCrLf &_
"	   and b.pers_ncorr = n.pers_ncorr   "& vbCrLf &_
"	   and n.peri_ccod  = isnull(m.peri_ccod,n.peri_ccod) "& vbCrLf &_
"	   and n.ofer_ncorr = o.ofer_ncorr  "& vbCrLf &_
"	   and ee.inen_ccod = hh.inen_ccod    "& vbCrLf &_
"	   and hh.TINE_CCOD in (3,4) "& vbCrLf 

					if rut_alumno <> "" then
					   consulta = consulta & "	   and cast(j.pers_nrut as varchar)= '" & rut_alumno & "' "& vbCrLf
					end if
					
					if sede <> "" then
					   consulta = consulta & "	  and cast(o.sede_ccod as varchar)='" & sede & "' "& vbCrLf
					end if
					
					
					if rut_apoderado <> "" then
					   consulta = consulta & "	   and cast(k.pers_nrut as varchar)= '" & rut_apoderado & "' "& vbCrLf
					end if
					
					if nro_docto <> "" then					
					  consulta = consulta & "	   and cast(a.ding_ndocto as varchar)= '" & nro_docto & "' "& vbCrLf
					end if
					
					if nro_cuenta_corriente <> "" then					
					  consulta = consulta &" and isnull(a.ding_tcuenta_corriente , ' ') = isnull(isnull('" & nro_cuenta_corriente & "',a.ding_tcuenta_corriente), ' ') "& vbCrLf
					 end if 
					 
					 
					 if tipo_docto <> "" then					
					  consulta = consulta &"		and cast(de.ting_ccod as varchar)= '" & tipo_docto & "'"& vbCrLf
					 end if 
					 
					 if estado_docto <> "" then
					  consulta = consulta & "and cast(fe.fedi_ccod as varchar)= '" & estado_docto & "' "& vbCrLf
					end if
					 			  
	  	   
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_listado.Consultar consulta

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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>
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
  //location.reload("Envios_Banco_Agregar1.asp") 
 }
</script>

<script language='javaScript1.2'> 
  colores = Array(3);
  colores[0] = ''; 
  colores[1] = '#97AAC6'; 
  colores[2] = '#C0C0C0'; 
</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "busqueda[0][ingr_fpago]","1","buscador","fecha_oculta_fpago"
	calendario.MuestraFecha "busqueda[0][envio_termino]","2","buscador","fecha_oculta_ftermino"
	calendario.FinFuncion
%>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="750"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
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
                    <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="192" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador
                      de Documentos</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="459" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
				<form name="buscador">
                      <table width="100%"  border="0">
                        <tr>
                      <td width="83%" height=""><table width="542" border="0">
                              <tr> 
                                <td width="103">Sede</td>
                                <td width="12">:</td>
                                <td width="139"> <%f_busqueda.dibujacampo("sede_ccod")%> <input type="hidden" name="periodo" value=<%=Periodo%>> 
                                  <font face="Verdana, Arial, Helvetica, sans-serif" size="1">&nbsp; 
                                  </font> </td>
                                <td width="82">&nbsp;</td>
                                <td width="9">&nbsp;</td>
                                <td width="171">&nbsp;</td>
                              </tr>
                              <tr> 
                                <td> <div align="left">N&ordm; Documento</div></td>
                                <td>:</td>
                                <td> <%f_busqueda.dibujacampo("ding_ndocto")%> </td>
                                <td>Estado</td>
                                <td>:</td>
                                <td> <%f_busqueda.dibujacampo("edin_ccod")%> </td>
                              </tr>
                              <tr>
                                <td>N&ordm; Cuenta Corriente</td>
                                <td>:</td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                                  <% f_busqueda.DibujaCampo ("ding_tcuenta_corriente") %>
                                  </font></td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
                              <tr> 
                                <td>Tipo Documento</td>
                                <td>:</td>
                                <td> <%f_busqueda.dibujacampo("ting_ccod")%> </td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
                              <tr> 
                                <td>Periodo Inicio</td>
                                <td>:</td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                  <%f_busqueda.dibujacampo("ingr_fpago")%>
                                  <a style='cursor:hand;' onClick='PopCalendar.show(document.buscador.fecha_oculta, "dd/mm/yyyy", null, null, "obtener_fecha(1)", "11");'> 
                                  </a> 
                                  <%calendario.DibujaImagen "fecha_oculta_fpago","1","buscador" %></font></td>
                                <td>T&eacute;rmino</td>
                                <td>:</td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                  <%f_busqueda.dibujacampo("envio_termino")%>
                                  <a style='cursor:hand;' onClick='PopCalendar.show(document.buscador.fecha_oculta, "dd/mm/yyyy", null, null, "obtener_fecha(2)", "11");'> 
                                  </a> 
                                  <%calendario.DibujaImagen "fecha_oculta_ftermino","2","buscador" %>
								  </font></td>
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
                      <td width="17%"><div align="center"> 
                              <%botonera.DibujaBoton "buscar" %>
                            </div></td>
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
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
            </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE">
				     <div align="center">&nbsp; <br>
                    <%pagina.DibujarTituloPagina%>
                    <br>
                    <br>
                  </div><table width="665" border="0">
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
                  <br> </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="194" bgcolor="#D8D8DE"><table width="94%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="51%" align="center" valign="middle"> <% 
                         botonera.DibujaBoton "excel"
		                %> </td>
                      <td width="51%" align="center" valign="middle">
                        <% botonera.AgregaBotonParam "pdf","url","/REPORTESNET/rep_cobranza.aspx?periodo="&Periodo
                         botonera.DibujaBoton "pdf"
		                %>
                      </td>
                    </tr>
                  </table>
                </td>
                <td width="168" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
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
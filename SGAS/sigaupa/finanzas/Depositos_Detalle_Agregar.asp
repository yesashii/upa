<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
folio_envio = request.querystring("folio_envio")
banc_ccod = request.querystring("banc_ccod")

set pagina = new CPagina
pagina.Titulo = "agregar documentos al deposito"
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_sede = negocio.ObtenerSede()
v_usuario=negocio.ObtenerUsuario()
'-----------------------------------------------------------------------
 set botonera = new CFormulario
 botonera.Carga_Parametros "Depositos.xml", "botonera"
 '----------------------------------------------------------------------
 sede 			= 	request.querystring("busqueda[0][sede_ccod]")
 num_doc 		= 	request.querystring("busqueda[0][ding_ndocto]")
 vencimientoI 	= 	request.querystring("busqueda[0][inicio]")
 vencimientoF 	= 	request.querystring("busqueda[0][termino]")
 buscando 		= 	request.querystring("buscando")
 mcaj_ncorr		=	request.querystring("busqueda[0][mcaj_ncorr]")
 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "Depositos.xml", "busqueda_cheques"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
'response.write("sede . "&v_sede)
v_pers_ncorr=conexion.ConsultaUno("select top 1 pers_ncorr from personas where pers_nrut="&v_usuario)

Select Case v_pers_ncorr
	case "97598"  'ichamblas
		v_sede=2
	case "124445"  'BENAVIDES
		v_sede=4
	case "127963" 'itobar
		v_sede=8		
	case "103170" 'gjara
		v_sede=1
End Select

if cint(v_sede)=1 then
 f_busqueda.AgregaCampoParam "sede_ccod", "filtro", "sede_ccod in (1,8,7)"
else
 f_busqueda.AgregaCampoParam "sede_ccod","anulable", "false"
 f_busqueda.AgregaCampoParam "sede_ccod", "filtro", "sede_ccod in ("&v_sede&")"
end if

 f_busqueda.AgregaCampoCons "sede_ccod", sede
 f_busqueda.AgregaCampoCons "ding_ndocto", num_doc
 f_busqueda.AgregaCampoCons "inicio", vencimientoI
 f_busqueda.AgregaCampoCons "termino", vencimientoF
 f_busqueda.AgregaCampoCons "mcaj_ncorr", mcaj_ncorr

'-----------------------------------------------------------------------
 set f_letras = new CFormulario
 f_letras.Carga_Parametros "Depositos.xml", "f_cheques"
 f_letras.Inicializar conexion

 'CHEQUES que no estan en algun envio pendiente y que estan en Cartera

consulta = "select distinct " & folio_envio & " as envi_ncorr, b.mcaj_ncorr, i.banc_tdesc, a.ding_ndocto as c_ding_ndocto, a.ding_ndocto, h.edin_tdesc, "& vbCrLf &_
			" a.ding_fdocto, a.ding_tcuenta_corriente,  protic.obtener_rut(b.pers_ncorr) as rut_alumno, "& vbCrLf &_
			" a.ding_mdocto, a.ting_ccod as c_ting_ccod, a.ting_ccod, b.ingr_ncorr, 0 as enviar, a.edin_ccod ,i.banc_ccod,j.sede_ccod, "& vbCrLf &_
			" isnull(a.sede_actual,case when b.ingr_fpago < '03/12/2006' then 1 else j.sede_ccod end) as sede_actual "& vbCrLf &_
			" From detalle_ingresos a "& vbCrLf &_
			" join ingresos b "& vbCrLf &_
			"    on a.ingr_ncorr = b.ingr_ncorr "& vbCrLf &_
			" join movimientos_cajas j "& vbCrLf &_
			" 	on b.mcaj_ncorr=j.mcaj_ncorr "& vbCrLf &_
			" join abonos c "& vbCrLf &_
			"    on b.ingr_ncorr = c.ingr_ncorr "& vbCrLf &_
			" join detalle_compromisos d "& vbCrLf &_
			"    on c.tcom_ccod = d.tcom_ccod  "& vbCrLf &_
			"    and c.inst_ccod = d.inst_ccod  "& vbCrLf &_
			"    and c.comp_ndocto = d.comp_ndocto "& vbCrLf &_
			"    and c.dcom_ncompromiso = d.dcom_ncompromiso "& vbCrLf &_
			" join compromisos e "& vbCrLf &_
			"    on d.tcom_ccod = e.tcom_ccod  "& vbCrLf &_
			"    and d.inst_ccod = e.inst_ccod  "& vbCrLf &_
			"    and d.comp_ndocto = e.comp_ndocto "& vbCrLf &_
			" left outer join postulantes f "& vbCrLf &_
			"    on b.pers_ncorr = f.pers_ncorr "& vbCrLf &_
			" left outer join ofertas_academicas g "& vbCrLf &_
			"    on f.ofer_ncorr = g.ofer_ncorr "& vbCrLf &_
			" join estados_detalle_ingresos h "& vbCrLf &_
			"    on a.edin_ccod = h.edin_ccod "& vbCrLf &_
			" left outer join bancos i "& vbCrLf &_
			"    on a.banc_ccod = i.banc_ccod "& vbCrLf &_
			" Where e.ecom_ccod = 1  "& vbCrLf &_
			" and isnull(a.ding_ncorrelativo,1) = 1  "& vbCrLf &_
			" and protic.documento_pagado_x_otro(a.ingr_ncorr,a.ding_bpacta_cuota,'A')=0 "& vbCrLf &_
			" and (a.ting_ccod in (3,14,38,88) and h.fedi_ccod in (1, 8, 9,24))  "& vbCrLf &_
			" and a.edin_ccod not in (SELECT distinct a.edin_ccod  "& vbCrLf &_
			"                        FROM detalle_ingresos a,  "& vbCrLf &_
			"                        estados_detalle_ingresos b  "& vbCrLf &_
			"                       WHERE a.edin_ccod = b.edin_ccod  "& vbCrLf &_
			"                        AND b.udoc_ccod = 2 and a.edin_ccod <> 100)  "& vbCrLf &_
			" and not exists (select 1  "& vbCrLf &_
			"                from detalle_envios x, envios y  "& vbCrLf &_
			"                where x.envi_ncorr = y.envi_ncorr  "& vbCrLf &_
			"                and x.ding_ndocto = a.ding_ndocto  "& vbCrLf &_
			"                and x.ting_ccod = a.ting_ccod  "& vbCrLf &_
			"                and x.ingr_ncorr = a.ingr_ncorr  "& vbCrLf &_
			"                and y.eenv_ccod = 1)  "


			 'if sede <> "" then
 			 '    consulta = consulta &  " and isnull(e.sede_ccod,g.sede_ccod ) = '" & sede & "' "& vbCrLf
			 'end if
			 if sede <> "" then
 			     'consulta = consulta &  " and isnull(a.sede_actual,j.sede_ccod) = '" & sede & "' "& vbCrLf
 				 consulta = consulta &  " and isnull(a.sede_actual,case when b.ingr_fpago < '03/12/2006' then 1 else j.sede_ccod end) in (" & sede & ") "& vbCrLf
			else
  				 consulta = consulta &  " and isnull(a.sede_actual,case when b.ingr_fpago < '03/12/2006' then 1 else j.sede_ccod end) in (1,7) "& vbCrLf
			end if
 
			  if num_doc <> "" then
			    consulta = consulta &  " and a.ding_ndocto = '" & num_doc & "' "& vbCrLf
			  end if
			  
			  if vencimientoI <> "" or vencimientoF <> "" then
			     consulta = consulta &  "and convert(datetime,a.ding_fdocto,103)  BETWEEN isnull(convert(datetime,'" & vencimientoI & "',103), convert(datetime,a.ding_fdocto,103)) AND  isnull(convert(datetime,'" & vencimientoF & "',103), convert(datetime,a.ding_fdocto,103)) "
			  end if
			 
			if banc_ccod <> "" then
				consulta = consulta &  " and a.banc_ccod="&banc_ccod
			end if
			
			if mcaj_ncorr <> "" then
				consulta = consulta &  "and b.mcaj_ncorr="&mcaj_ncorr
			end if

orden=" order by i.banc_ccod, a.ding_ndocto asc"
consulta= consulta + orden
'	response.Write("<PRE>" & consulta & "</pre>")
  if buscando = 1 then
	'response.Write("<PRE>" & consulta & "</pre>")
	f_letras.consultar consulta	
  else
	f_letras.consultar "select '' where 1 = 2"
	f_letras.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
  end if
  cantidad= f_letras.nrofilas
'response.Write("<PRE>" & consulta & "</pre>")
'-----------------------------------------------------------------------
set f_envio = new CFormulario
f_envio.Carga_Parametros "Depositos.xml", "f_depositos"
f_envio.Inicializar conexion

consulta = "SELECT  a.envi_ncorr, a.eenv_ccod, b.eenv_tdesc, a.envi_fenvio, a.tdep_ccod, d.tdep_tdesc , a.inen_ccod, c.inen_tdesc  "& vbCrLf &_
           "FROM envios a, "& vbCrLf &_
			   "estados_envio b, "& vbCrLf &_
			   "instituciones_envio c, "& vbCrLf &_
			   "tipos_depositos d "& vbCrLf &_
			"WHERE a.eenv_ccod = b.eenv_ccod "& vbCrLf &_
			  "and a.inen_ccod = c.inen_ccod "& vbCrLf &_
			  "and a.tdep_ccod = d.tdep_ccod "& vbCrLf &_
			  "and a.envi_ncorr =" & folio_envio 

			'response.Write("<pre>"&consulta&"</pre>")
			'response.End()
 f_envio.Consultar consulta
 f_envio.siguiente

 estado_envio =  f_envio.obtenervalor("eenv_ccod")

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
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "busqueda[0][inicio]","1","buscador","fecha_oculta_inicio"
	calendario.MuestraFecha "busqueda[0][termino]","2","buscador","fecha_oculta_termino"
	calendario.FinFuncion
%>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
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
                <td> 
                  <%  pagina.dibujarLenguetas array (array("Detalle Depósito","Depositos_Detalle.asp?folio_envio=" & folio_envio),array("Búsqueda de Documentos","Depositos_Detalle_Agregar.asp?folio_envio="& folio_envio)),2 %>
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
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
				<form name="buscador">
                      <BR>
					  <table width="98%"  border="0">
                        <tr> 
                          <td width="84%"><table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                              <tr> 
                                <td width="28%">N&ordm; Cheque </td>
                                <td width="21%">: 
                                  <% f_busqueda.DibujaCampo ("ding_ndocto") %></td>
                                <td width="1%">&nbsp;</td>
                                <td width="10%">Sede</td>
                                <td width="40%">: 
                                  <% f_busqueda.DibujaCampo ("sede_ccod") %></td>
                              </tr>
                              <tr> 
                                <td>Fecha Vencimiento Inicio</td>
                                <td>: 
                                  <% f_busqueda.DibujaCampo ("inicio") %> <%calendario.DibujaImagen "fecha_oculta_inicio","1","buscador" %>
                                  (dd/mm/aaaa)</td>
                                <td>&nbsp;</td>
                                <td>T&eacute;rmino</td>
                                <td> : 
                                  <% f_busqueda.DibujaCampo ("termino") %> <%calendario.DibujaImagen "fecha_oculta_termino","2","buscador" %>
                                  (dd/mm/aaaa) 
                                  <input name="folio_envio" type="hidden" value="<%=folio_envio%>"> 
                                  <input name="buscando" type="hidden" value="1"> 
                                </td>
                              </tr>
                              <tr>
                                <td>N&ordm; de Caja</td>
                                <td>: 
                                  <% f_busqueda.DibujaCampo ("mcaj_ncorr") %></td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
                            </table>
                            <br> </td>
                          <td width="16%"><div align="center"> 
                              <% botonera.DibujaBoton ("buscar") %>
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
                <td>
                  <%pagina.DibujarLenguetas Array("Resultado de le búsqueda"), 1%>
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
                  
                <td bgcolor="#D8D8DE"> <div align="center">
                    <BR>
				    <%pagina.DibujarTituloPagina%>
                   
                    <BR>
                  </div>
                  <table width="665" border="0">
                    <tr> 
                      <td width="116">&nbsp;</td>
                      <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                          <% f_letras.AccesoPagina %>
                        </div></td>
                      <td width="24"> <div align="right"> </div></td>
                    </tr>
                  </table>
                  <BR>
				   <form name="edicion">
				   <div align="center">
			          <% f_letras.DibujaTabla() %>
			         </div>
				   </form>
				  <BR>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="89" bgcolor="#D8D8DE"><table width="53%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="11%"><div align="center"></div></td>
                      <td width="18%"> 
                        <% 
						  botonera.agregabotonparam "anterior", "url","Depositos_Detalle.asp?folio_envio=" & folio_envio
						  botonera.DibujaBoton "anterior" %>
                      </td>
                      <td width="71%"> <div align="left">
                          <% 
						 if estado_envio = "2" or cint(cantidad)=0 then
						    botonera.agregabotonparam "guardar_cheques", "deshabilitado" ,"TRUE"
						 end if
						    botonera.DibujaBoton "guardar_cheques"
						%>
                        </div></td>
                    </tr>
                  </table>                    
                  
                </td>
                  <td width="273" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<BR>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>

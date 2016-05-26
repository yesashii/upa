<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

 folio_envio = request.querystring("folio_envio")
 tipo_empresa = request.querystring("tipo_empresa")
set pagina = new CPagina
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")

cc_empresa_envio="select tine_tdesc from tipos_instituciones_envio where tine_ccod = " & tipo_empresa
tipo_empresa_envio=conexion.consultaUno(cc_empresa_envio)
'-----------------------------------------------------------------------
 set botonera = new CFormulario
 botonera.Carga_Parametros "envios_cobranza_buscar.xml", "btn_envios_cobranza_buscar"
 '-----------------------------------------------------------------------------------------
 '-----------------------------------------------------------------------
   pagina.Titulo = "Agregar Documentos a Envio"

'-----------------------------------------------------------------------

 sede = request.querystring("busqueda[0][sede_ccod]")
 inicio = request.querystring("busqueda[0][inicio]")
 termino = request.querystring("busqueda[0][termino]")
 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado = request.querystring("busqueda[0][code_nrut]")
 rut_apoderado_digito = request.querystring("busqueda[0][code_xdv]")
 num_doc = request.querystring("busqueda[0][ding_ndocto]")
 estado_letra = request.querystring("busqueda[0][edin_ccod]")
 tipo_documento = request.querystring("busqueda[0][TING_CCOD]")
 vencimiento = request.querystring("busqueda[0][vencimiento]")
 nro_cuenta_corriente= request.querystring("busqueda[0][ding_tcuenta_corriente]")

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "envios_cobranza_buscar.xml", "busqueda_letras"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "sede_ccod", sede
 f_busqueda.AgregaCampoCons "inicio", inicio
 f_busqueda.AgregaCampoCons "termino", termino
 f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
 f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
 f_busqueda.AgregaCampoCons "code_nrut", rut_apoderado
 f_busqueda.AgregaCampoCons "code_xdv", rut_apoderado_digito
 f_busqueda.AgregaCampoCons "ding_ndocto", num_doc
 f_busqueda.AgregaCampoCons "edin_ccod", estado_letra
 f_busqueda.AgregaCampoCons "TING_CCOD", tipo_documento
 f_busqueda.AgregaCampoCons "vencimiento", vencimiento
 f_busqueda.AgregaCampoCons "ding_tcuenta_corriente", nro_cuenta_corriente

'---------------------------------
 set f_letras = new CFormulario
 f_letras.Carga_Parametros "envios_cobranza_buscar.xml", "listado_letras"
 f_letras.Inicializar conexion

			
			
		
consulta = "select distinct z.envi_ncorr, z.ting_ccod, z.ting_tdesc, z.ding_ndocto," & vbcrlf & _ 
		   " z.ding_ndocto as c_ding_ndocto,z.ding_tcuenta_corriente, " & vbcrlf & _
		   " z.edin_tdesc,z.edin_ccod,z.ingr_ncorr," & vbcrlf & _
		   " z.fecha_envio, z.ding_fdocto, z.ding_mdocto, z.enviar,  z.sede_ccod, z.rut_alumno,z.rut_apoderado   " & vbcrlf & _
		   " from ( " & vbcrlf & _
		   " select distinct "&folio_envio&" as envi_ncorr,   a.ding_ndocto, h.edin_tdesc,a.edin_ccod ," & vbcrlf & _
		   " a.ding_tcuenta_corriente, " & vbcrlf & _
		   " a.ding_mdocto, a.ting_ccod, b.ingr_ncorr, 0 as enviar,   protic.trunc(b.ingr_fpago) as fecha_envio," & vbcrlf & _
		   " protic.trunc(a.ding_fdocto) as ding_fdocto, i.ting_tdesc,  o.sede_ccod," & vbcrlf & _
		   " protic.obtener_rut(b.pers_ncorr) as rut_alumno, protic.obtener_rut(a.pers_ncorr_codeudor) as rut_apoderado" & vbcrlf & _
		   " from " & vbcrlf & _
		   " detalle_ingresos a " & vbcrlf & _
		   " join estados_detalle_ingresos a1" & vbcrlf & _
		   "    on a.edin_ccod = a1.edin_ccod" & vbcrlf & _
		   " join ingresos b" & vbcrlf & _
		   "    on a.ingr_ncorr = b.ingr_ncorr" & vbcrlf & _
           " join estados_detalle_ingresos h" & vbcrlf & _
		   "    on a.edin_ccod = h.edin_ccod " & vbcrlf & _
		   " join tipos_ingresos i" & vbcrlf & _
		   "    on a.ting_ccod = i.ting_ccod  " & vbcrlf & _
		   " join personas j" & vbcrlf & _
		   "    on b.pers_ncorr = j.pers_ncorr  " & vbcrlf & _
		   " left outer join personas k" & vbcrlf & _
		   "    on  a.pers_ncorr_codeudor  = k.pers_ncorr  " & vbcrlf & _
		   " join abonos l" & vbcrlf & _
		   "    on  b.ingr_ncorr = l.ingr_ncorr  " & vbcrlf & _
		   " join detalle_compromisos m" & vbcrlf & _
		   "    on l.tcom_ccod = m.tcom_ccod and l.inst_ccod = m.inst_ccod and l.comp_ndocto = m.comp_ndocto and l.dcom_ncompromiso = m.dcom_ncompromiso " & vbcrlf & _
		   " left outer join postulantes n" & vbcrlf & _
		   "    on b.pers_ncorr = n.pers_ncorr" & vbcrlf & _
		   " left outer join ofertas_academicas o" & vbcrlf & _
		   "    on n.ofer_ncorr = o.ofer_ncorr" & vbcrlf & _
		   " left outer join familias_estados_detalle_ingr fe   " & vbcrlf & _
		   "   on a1.fedi_ccod = fe.fedi_ccod" & vbcrlf & _
		   " where a.ting_ccod in (3,4,38,52,66)  " & vbcrlf & _
		   " and a.edin_ccod  not in (6,10,11)    " & vbcrlf & _
		   " and a.ding_ncorrelativo = 1 "& vbCrLf 
					 
					'"	   and a.ding_fdocto <= to_char(sysdate -1, 'DD/MM/YYYY') "&vbCrLf
					
					if rut_alumno <> "" then
					   consulta = consulta & "	   and cast(j.pers_nrut as varchar)= '" & rut_alumno & "' "& vbCrLf
					end if
					
					if sede <> "" then
					   consulta = consulta & "	   and cast(o.sede_ccod as varchar)='" & sede & "' "& vbCrLf
					end if
					
					
					if rut_apoderado <> "" then
					   consulta = consulta & "	   and cast(k.pers_nrut as varchar)= '" & rut_apoderado & "' "& vbCrLf
					end if
					
					if num_doc <> "" then					
					  consulta = consulta & "	   and cast(a.ding_ndocto as varchar)= '" & num_doc & "' "& vbCrLf
					end if
					
					if nro_cuenta_corriente <> "" then					
					  consulta = consulta &"				and isnull(a.ding_tcuenta_corriente , ' ') = isnull(isnull('" & nro_cuenta_corriente & "',a.ding_tcuenta_corriente), ' ') "& vbCrLf
					 end if 
					if inicio <> "" or termino <> "" then
					  consulta = consulta & "			   and protic.trunc(b.ingr_fpago) BETWEEN isnull('" & inicio & "',b.ingr_fpago)  "&_
			        	"	   and isnull('" & termino & "',b.ingr_fpago)  "& vbCrLf
					end if
					
					if vencimiento <> ""  then
					consulta = consulta & "			   and a.ding_fdocto <= isnull('" & vencimiento & "',a.ding_fdocto)  "& vbCrLf
					end if
					
					if estado_letra <> "" then
					  consulta = consulta & "and cast(fe.fedi_ccod as varchar) = '" & estado_letra & "' "& vbCrLf
					end if
					
					if tipo_documento <> "" then
					  consulta = consulta & "and cast(i.TING_CCOD as varchar) = '" & tipo_documento & "' "& vbCrLf
					end if
					
					consulta = consulta  & " ) z "& vbCrLf &_
					"where not exists (select 1  "& vbCrLf &_
					"				   from detalle_envios x, envios y   "& vbCrLf &_
					"				   where y.tenv_ccod = 1  "& vbCrLf &_
					"					 and x.envi_ncorr = y.envi_ncorr   "& vbCrLf &_
					"					 and x.ding_ndocto = z.ding_ndocto   "& vbCrLf &_
					"					 and x.ting_ccod = z.ting_ccod   "& vbCrLf &_
					"					 and x.ingr_ncorr = z.ingr_ncorr   "& vbCrLf &_
					"					 and y.envi_ncorr = z.envi_ncorr   "& vbCrLf &_
					"					 and y.eenv_ccod = 1)  "& vbCrLf 
					
		
		
		
if len(Request.QueryString) >40  then	
	'response.Write("<PRE>" & consulta & "</PRE>") 
	'response.End()
	
	f_letras.consultar   consulta
	'response.Write("cantidad "&conexion.consultaUno("Select count(*) from ("&consulta&")xx"))
	
else
	f_letras.consultar "select '' from personas where 1 = 2"
	f_letras.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
  end if

cantidad=f_letras.nroFilas
'-------------------------------------------------------------------------------------
'response.Write("<PRE>" & consulta & "</PRE>") 
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
	calendario.MuestraFecha "busqueda[0][inicio]","1","buscador","fecha_oculta_finicio"
	calendario.MuestraFecha "busqueda[0][termino]","2","buscador","fecha_oculta_ftermino"
	calendario.FinFuncion
%>


</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <%'pagina.DibujarEncabezado()
  %>  
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
                    <td width="14" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="203" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador
                      de Documentos</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="445" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
                      <table width="660" border="0" align="left">
                        <tr> 
                          <td width="113" height="21"> 
                            <div align="left">Sede</div></td>
                          <td width="9">:</td>
                          <td width="133"> <% f_busqueda.DibujaCampo ("sede_ccod") %></td>
                          <td width="10"><div align="center"></div></td>
                          <td width="103">&nbsp;</td>
                          <td width="9">&nbsp;</td>
                          <td width="134">&nbsp;</td>
                          <td width="121" rowspan="7"><div align="center"></div>
                            <div align="center"> 
                              <%botonera.DibujaBoton "buscar" %>
                            </div></td>
                        </tr>
                        <tr> 
                          <td height="20">Periodo Inicio</td>
                          <td>:</td>
                          <td><div align="left"></div>
                            <% f_busqueda.DibujaCampo ("inicio") %>
							<a style='cursor:hand;' onClick='PopCalendar.show(document.buscador.fecha_oculta, "dd/mm/yyyy", null, null, "obtener_fecha(1)", "11");'> 
                            </a> 
                            <%calendario.DibujaImagen "fecha_oculta_finicio","1","buscador" %> </td>
                          <td>&nbsp;</td>
                          <td>T&eacute;rmino</td>
                          <td>:</td>
                          <td><div align="left"> 
                              <% f_busqueda.DibujaCampo ("termino") %>
                            
							<a style='cursor:hand;' onClick='PopCalendar.show(document.buscador.fecha_oculta, "dd/mm/yyyy", null, null, "obtener_fecha(2)", "11");'> 
                            </a> 
                            <%calendario.DibujaImagen "fecha_oculta_ftermino","2","buscador" %>
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
                            </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
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
                          <td><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">N&ordm; 
                              Documento</font></div></td>
                          <td>:</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                            <% f_busqueda.DibujaCampo ("ding_ndocto") %>
                            </font></td>
                          <td>&nbsp;</td>
                          <td>Estado Documento</td>
                          <td>:</td>
                          <td> <% f_busqueda.DibujaCampo ("edin_ccod") %> </td>
                        </tr>
                        <tr>
                          <td>N&ordm; Cuenta Corriente</td>
                          <td>:</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                            <% f_busqueda.DibujaCampo ("ding_tcuenta_corriente") %>
                            </font></td>
                          <td>&nbsp;</td>
                          <td>Tipo Documento</td>
                          <td>:</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                            <% f_busqueda.DibujaCampo ("TING_CCOD") %>
                            </font></td>
                        </tr>
                        <tr> 
                          <td> Fecha Corte:</td>
                          <td>:</td>
                          <td> <% f_busqueda.DibujaCampo ("vencimiento")%> </td>
                          <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                              </font></div></td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><input type="hidden" name="folio_envio" value="<%=folio_envio%>"> 
                            <input name="tipo_empresa" type="hidden" id="tipo_empresa" value="<%=tipo_empresa%>"></td>
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Detalle
                          Documentos Encontrados</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
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
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE"><form name="edicion"><br>
                  <div align="center">
                    <%pagina.DibujarTituloPagina%>
                    <br>
                    <BR>
                  </div>
                  <table width="100%" border="0">
                      <tr>
                        <td width="12%">N&ordm; Folio</td>
                        <td width="3%">:</td>
                        <td width="21%"><%=folio_envio%></td>
                        <td width="6%">Tipo</td>
                        <td width="3%">:</td>
                        
                      <td><%=tipo_empresa_envio%></td>
                      </tr>
                    </table>
					
                  <table width="665" border="0">
                    <tr> 
                      <td width="116">&nbsp;</td>
                      <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                          <%f_letras.AccesoPagina%>
                        </div></td>
                      <td width="24"> <div align="right"> </div></td>
                    </tr>
                  </table>
                  <br>
                  <form name="edicion">
				    <table width="100%" cellspacing="0" cellpadding="0">
                      <tr>
                        <td>
				   <div align="center">
			          <% f_letras.DibujaTabla() %>
			         </div>
				   </td>
                      </tr>
                    </table></form><br><br>
                    				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="237" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td><div align="center"> 
                          <% if cint(cantidad)=0 then
						        botonera.agregabotonparam "guardar_letras", "deshabilitado" ,"TRUE"
						     end if
						     	botonera.DibujaBoton "guardar_letras"%>
                        </div></td>
                      <td><div align="center"> 
                          <% botonera.DibujaBoton "cancelar" %>
                        </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="125" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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

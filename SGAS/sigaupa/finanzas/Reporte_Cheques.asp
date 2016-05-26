<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 2000 
set pagina = new CPagina
pagina.Titulo = "Reporte de Cheques"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
Usuario = negocio.ObtenerUsuario()
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Reporte_Cheques.xml", "botonera"
'-----------------------------------------------------------------------
 
 sede 					= request.querystring("busqueda[0][sede_ccod]")
 inicio 				= request.querystring("busqueda[0][inicio]")
 termino 				= request.querystring("busqueda[0][termino]")
 rut_alumno 			= request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito 		= request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado 			= request.querystring("busqueda[0][code_nrut]")
 rut_apoderado_digito 	= request.querystring("busqueda[0][code_xdv]")
 num_doc 				= request.querystring("busqueda[0][ding_ndocto]")
 estado_cheque 			= request.querystring("busqueda[0][edin_ccod]")
 num_cuenta 			= request.querystring("busqueda[0][ding_tcuenta_corriente]")
 v_tipo_doc 			= request.querystring("busqueda[0][ting_ccod]")
 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "Reporte_Cheques.xml", "busqueda_cheques"
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
 f_busqueda.AgregaCampoCons "edin_ccod", estado_cheque
 f_busqueda.AgregaCampoCons "ding_tcuenta_corriente",  num_cuenta
 f_busqueda.AgregaCampoCons "ting_ccod",  v_tipo_doc
'----------------------------------------------------------------------------

consulta = "SELECT pers_ncorr FROM personas WHERE pers_nrut='" & Usuario & "'"
pers_ncorr = conexion.ConsultaUno(consulta)
f_busqueda.AgregaCampoParam "a.sede_ccod","destino", "(select a.sede_ccod, d.sede_tdesc from sis_sedes_usuarios a, sis_usuarios b, personas c, sedes d where a.pers_ncorr = b.pers_ncorr and b.pers_ncorr = c.pers_ncorr and a.sede_ccod = d.sede_ccod and a.pers_ncorr =" & pers_ncorr & ") a"
'----------------------------------------------------------------------------

if v_tipo_doc <> "" then
	filtro_docto = " and a.ting_ccod in ("&v_tipo_doc&") "& vbCrLf
else
	filtro_docto = " and a.ting_ccod in (3,38,14) "
end if


 set f_cheques = new CFormulario
 f_cheques.Carga_Parametros "Reporte_Cheques.xml", "f_cheques"
 f_cheques.Inicializar conexion
		
					
consulta = "select a.ting_ccod,f.envi_ncorr, e.banc_tdesc, a.ding_ndocto, convert(varchar,b.ingr_fpago,103) as ingr_fpago,isnull(a.sede_actual,case when b.ingr_fpago < '03/12/2006' then 1 else m.sede_ccod end) as sede_actual,"& vbCrLf &_
		" case  when protic.documento_pagado_x_regularizacion(a.ingr_ncorr,a.ding_bpacta_cuota,'P' )=1 " & vbCrLf &_
		" and protic.documento_pagado_x_regularizacion(a.ingr_ncorr,a.ding_bpacta_cuota,'A' )=a.ding_mdocto " & vbCrLf &_
		" and g.edin_tdesc='PAGADO' then (select ereg_tdesc from estados_regularizados where ereg_ccod=protic.documento_pagado_x_regularizacion(a.ingr_ncorr,a.ding_bpacta_cuota,'T')) else g.edin_tdesc end as edin_tdesc, " & vbCrLf &_
		"            convert(varchar,a.ding_fdocto,103) as ding_fdocto, c.abon_mabono,"& vbCrLf &_
		"            a.ding_mdocto, protic.obtener_rut(b.pers_ncorr) as rut_alumno,"& vbCrLf &_
		"            protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre_alumno,"& vbCrLf &_
		"            protic.obtener_nombre_completo(a.pers_ncorr_codeudor,'n') as nombre_apoderado,"& vbCrLf &_
		"            protic.obtener_rut(a.pers_ncorr_codeudor) as rut_apoderado, a.ding_tcuenta_corriente, protic.obtener_envio(a.ingr_ncorr) as deposito, "& vbCrLf &_
		" protic.documento_pagado_x_otro(a.ingr_ncorr,a.ding_bpacta_cuota,'A') as abonado "& vbCrLf &_
		"   from detalle_ingresos a (nolock)  "& vbCrLf &_
        " join ingresos b (nolock)"& vbCrLf &_
        "    on a.ingr_ncorr = b.ingr_ncorr "& vbCrLf &_
		" join movimientos_cajas m (nolock)"& vbCrLf &_
		"    on b.mcaj_ncorr = m.mcaj_ncorr "& vbCrLf &_
        " join abonos c (nolock) "& vbCrLf &_
        "    on b.ingr_ncorr = c.ingr_ncorr "& vbCrLf &_
        " join compromisos d (nolock)"& vbCrLf &_
        "    on c.tcom_ccod = d.tcom_ccod  "& vbCrLf &_
		"    and c.inst_ccod = d.inst_ccod  "& vbCrLf &_
		"    and c.comp_ndocto = d.comp_ndocto "& vbCrLf &_
        "    and c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
        " left outer join bancos e "& vbCrLf &_
        "    on a.banc_ccod = e.banc_ccod "& vbCrLf &_
        " left outer join envios f  "& vbCrLf &_
        "    on a.envi_ncorr = f.envi_ncorr "& vbCrLf &_
        " join estados_detalle_ingresos g"& vbCrLf &_
        "    on a.edin_ccod = g.edin_ccod"& vbCrLf &_
        " join personas h (nolock)"& vbCrLf &_
        "    on b.pers_ncorr = h.pers_ncorr"& vbCrLf &_
        " left outer join personas i (nolock)"& vbCrLf &_
        "    on a.pers_ncorr_codeudor = i.pers_ncorr"& vbCrLf &_
		" where d.ecom_ccod <> 3 "& vbCrLf &_
		" "&filtro_docto&" "& vbCrLf &_
		"  and a.ding_ncorrelativo >= 1 "& vbCrLf &_
		"  and b.eing_ccod <> 3  "
					

					if sede <> "" then
					  consulta = consulta &  "And isnull(a.sede_actual,case when b.ingr_fpago < '03/12/2006' then 1 else m.sede_ccod end) = '" & sede & "' "& vbCrLf
					end if
				  
					if inicio <> "" or termino <> "" then
					  consulta = consulta &  "AND convert(datetime,a.ding_fdocto,103) BETWEEN  isnull(convert(datetime,'" & inicio & "',103),convert(datetime,a.ding_fdocto,103)) and isnull(convert(datetime,'" & termino & "',103),convert(datetime,a.ding_fdocto,103))"& vbCrLf
					end if 

					if rut_alumno <> "" then
					  consulta = consulta &  "AND h.pers_nrut = '" & rut_alumno & "' "& vbCrLf
					end if
					
					if rut_apoderado <> "" then
					  consulta = consulta &  "AND i.pers_nrut = '" & rut_apoderado & "' "& vbCrLf
					end if
					
					if num_doc <> "" then                   
				      consulta = consulta &  "AND a.ding_ndocto = '" & num_doc & "' "& vbCrLf
					end if
					
					if estado_cheque <> "" then
					   if 	estado_cheque = 100 then
							consulta = consulta & " AND g.fedi_ccod = '24' "& vbCrLf
					   else
							consulta = consulta & " AND g.fedi_ccod = '" & estado_cheque & "' "& vbCrLf
					   end if
					 end if
					
					if num_cuenta <> "" then
					   consulta = consulta & " AND a.ding_tcuenta_corriente = '" & num_cuenta & "' "
					end if
					
					consulta = consulta & "order by a.ding_fdocto asc, a.ding_ndocto asc, a.ding_ncorrelativo"
										
'response.Write("<pre>"&consulta&"</pre>")			
'response.End()			    
   if Request.QueryString <> "" then
      'response.Write("<PRE>" & consulta & "</PRE>")
	  f_cheques.consultar consulta
   else
	 f_cheques.consultar "select '' where 1 = 2"
	 f_cheques.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
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
			<BR>
				<form name="buscador">                
                      <table width="100%" border="0" align="left">
                        <tr> 
                          <td>Sede ingreso </td>
                          <td>:</td>
                          <td> <% f_busqueda.DibujaCampo ("sede_ccod") %> </td>
                          <td width="112">Tipo Cheque </td>
                          <td width="17">:</td>
                          <td width="132"><% f_busqueda.DibujaCampo ("ting_ccod") %></td>
                          <td width="90" rowspan="8"><div align="center"></div>
                            <div align="center"> 
                              <%botonera.DibujaBoton "buscar" %>
                            </div></td>
                        </tr>
						<tr> 
                          <td colspan="6">Periodo seg&uacute;n fecha de vencimiento</td>
                        </tr>
						<tr> 
                          <td>Inicio</td>
                          <td>:</td>
                          <td><div align="left"></div>
                            <% f_busqueda.DibujaCampo ("inicio")%>
							<%calendario.DibujaImagen "fecha_oculta_inicio","1","buscador" %>(dd/mm/aaaa) </td>
                          <td>T&eacute;rmino</td>
                          <td>:</td>
                          <td><div align="left"> 
                              <% f_busqueda.DibujaCampo ("termino") %>
							  <%calendario.DibujaImagen "fecha_oculta_termino","2","buscador" %>(dd/mm/aaaa)
                            </div></td>
                        </tr>
                        <tr> 
                          <td width="124"><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">N&ordm; 
                              Cheque</font></div></td>
                          <td width="17">:</td>
                          <td width="148"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                            <% f_busqueda.DibujaCampo ("ding_ndocto") %>
                            </font></td>
                          <td>Cuenta Corriente</td>
                          <td>:</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                            <% f_busqueda.DibujaCampo ("ding_tcuenta_corriente") %>
                            </font></td>
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
                          <td>Estado Cheque</td>
                          <td>:</td>
                          <td colspan="4"> <% f_busqueda.DibujaCampo ("edin_ccod") %> </td>
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
                    <td width="172" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Documentos
                          Encontrados</font></div>
                    </td>
                    <td width="485" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
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
                  <table width="100%" border="0">
                    <tr> 
                      <td width="116">&nbsp;</td>
                      <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                          <% f_cheques.AccesoPagina %>
                        </div></td>
                      <td width="24"> <div align="right"> </div></td>
                    </tr>
                  </table> 
                  <form name="edicion">
                    <div align="center">
                      <% f_cheques.DibujaTabla() %>
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
                <td width="100" bgcolor="#D8D8DE"><table width="100%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td ><% botonera.DibujaBoton ("lanzadera") %> </td>
                      <td >
					  				<% if Request.QueryString = "" then 
					                     botonera.agregabotonparam "excel", "deshabilitado" ,"TRUE"
  									  end if
									     botonera.DibujaBoton ("excel")  %>
					  </td>
					  <td>
					  				<% if Request.QueryString = "" then 
					                     botonera.agregabotonparam "excel_avanzado", "deshabilitado" ,"TRUE"
  									  end if
									     botonera.DibujaBoton ("excel_avanzado")  %>
					  </td>
					  <td>
								<% if Request.QueryString = "" then 
					                     botonera.agregabotonparam "excel_aviso", "deshabilitado" ,"TRUE"
  								   end if
								   botonera.DibujaBoton ("excel_aviso")  %>
					 </td>
                    </tr>
                  </table>
                </td>
                <td width="262" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
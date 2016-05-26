<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:GESTIÓN DE DOCUMENTOS
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:12/03/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:125
'********************************************************************
folio_envio = request.querystring("folio_envio")
set pagina = new CPagina
pagina.Titulo = "Agregar Letras al Envio a Banco"
'---------------------------------------------------------------------------------------------------
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
 botonera.Carga_Parametros "Envios_Banco.xml", "botonera"
 '-----------------------------------------------------------------------------------------
 sede = request.querystring("busqueda[0][sede_ccod]")
 inicio = request.querystring("busqueda[0][inicio]")
 termino = request.querystring("busqueda[0][termino]")
 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado = request.querystring("busqueda[0][code_nrut]")
 rut_apoderado_digito = request.querystring("busqueda[0][code_xdv]")
 num_doc = request.querystring("busqueda[0][ding_ndocto]")
 estado_letra = request.querystring("busqueda[0][edin_ccod]")
 vencimiento = request.querystring("busqueda[0][vencimiento]")
 
 set f_busqueda = new CFormulario
 'f_busqueda.Carga_Parametros "Ficha_Alumno.xml", "busqueda_alumno"
 f_busqueda.Carga_Parametros "envios_banco.xml", "busqueda_letras"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente


v_pers_ncorr=conexion.ConsultaUno("select top 1 pers_ncorr from personas where pers_nrut="&v_usuario)
Select Case v_pers_ncorr
	case "97598" 'jhernandez
		v_sede=4
	case "12008" 'ichamblas
		v_sede=2
	case "127963" 'itobar
		v_sede=8
	case "103170" 'gjara
		v_sede ="1"
End Select

if cint(v_sede)=1 then
	f_busqueda.AgregaCampoParam "sede_ccod", "filtro", "sede_ccod in (1,8,7)"
else
	f_busqueda.AgregaCampoParam "sede_ccod","anulable", "false"
	f_busqueda.AgregaCampoParam "sede_ccod", "filtro", "sede_ccod in ("&v_sede&")"
end if
 
 f_busqueda.AgregaCampoCons "sede_ccod", sede
 f_busqueda.AgregaCampoCons "inicio", inicio
 f_busqueda.AgregaCampoCons "termino", termino
 f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
 f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
 f_busqueda.AgregaCampoCons "code_nrut", rut_apoderado
 f_busqueda.AgregaCampoCons "code_xdv", rut_apoderado_digito
 f_busqueda.AgregaCampoCons "ding_ndocto", num_doc
 f_busqueda.AgregaCampoCons "edin_ccod", estado_letra
 f_busqueda.AgregaCampoCons "vencimiento", vencimiento

'---------------------------------
 set f_letras = new CFormulario
 f_letras.Carga_Parametros "Envios_Banco.xml", "f_letras"
 f_letras.Inicializar conexion
 'letras que no estan en algun folio pendiente y que ademas estan en cartera	
				
'     	consulta = "select z.*  "& vbCrLf &_
'					"from ( "& vbCrLf &_
'					"select " & folio_envio & " as envi_ncorr, a.ding_ndocto as c_ding_ndocto, a.ding_ndocto, h.edin_tdesc, a.ding_tcuenta_corriente, " & vbCrLf &_
'					"       protic.obtener_nombre_completo(a.pers_ncorr_codeudor,'n') as nombre_apoderado, a.ding_mdocto, a.ting_ccod, " & vbCrLf &_
'					"	   a.ingr_ncorr, 0 as enviar, a.edin_ccod, convert(varchar,b.ingr_fpago,103) as ingr_fpago, convert(varchar,a.ding_fdocto,103) as ding_fdocto, d.ting_tdesc, " & vbCrLf &_
'					"	   protic.obtener_rut(b.pers_ncorr) as rut_alumno, protic.obtener_rut(a.pers_ncorr_codeudor) as rut_apoderado,g.sede_ccod  " & vbCrLf &_
'					"from detalle_ingresos a, ingresos b, estados_detalle_ingresos h, tipos_ingresos d, " & vbCrLf &_
'					"     personas k, personas j , movimientos_cajas g  " & vbCrLf &_
'					"where a.ingr_ncorr = b.ingr_ncorr " & vbCrLf &_
'					"  and a.edin_ccod = h.edin_ccod " & vbCrLf &_
'					"  and a.ting_ccod = d.ting_ccod " & vbCrLf &_
'					"  and a.pers_ncorr_codeudor *= k.pers_ncorr " & vbCrLf &_
'					"  and b.pers_ncorr = j.pers_ncorr " & vbCrLf &_
'					"  and b.mcaj_ncorr = g.mcaj_ncorr " & vbCrLf &_
'					"  and a.ting_ccod = 4   " & vbCrLf &_
'					"  and b.eing_ccod not in (1,3,6) " & vbCrLf &_
'					"  and protic.documento_pagado_x_otro(a.ingr_ncorr,a.ding_bpacta_cuota,'A')=0 "& vbCrLf &_
'					"  and h.edin_ccod in (1,3) "

     	consulta = "select z.*  "& vbCrLf &_
					"from ( "& vbCrLf &_
					"select " & folio_envio & " as envi_ncorr, a.ding_ndocto as c_ding_ndocto, a.ding_ndocto, h.edin_tdesc, a.ding_tcuenta_corriente, " & vbCrLf &_
					"       protic.obtener_nombre_completo(a.pers_ncorr_codeudor,'n') as nombre_apoderado, a.ding_mdocto, a.ting_ccod, " & vbCrLf &_
					"	   a.ingr_ncorr, 0 as enviar, a.edin_ccod, convert(varchar,b.ingr_fpago,103) as ingr_fpago, convert(varchar,a.ding_fdocto,103) as ding_fdocto, d.ting_tdesc, " & vbCrLf &_
					"	   protic.obtener_rut(b.pers_ncorr) as rut_alumno, protic.obtener_rut(a.pers_ncorr_codeudor) as rut_apoderado,g.sede_ccod  " & vbCrLf &_
					"from detalle_ingresos a " & vbCrLf &_
					"INNER JOIN ingresos b " & vbCrLf &_
					"ON a.ingr_ncorr = b.ingr_ncorr " & vbCrLf &_
					"INNER JOIN estados_detalle_ingresos h " & vbCrLf &_
					"ON a.edin_ccod = h.edin_ccod " & vbCrLf &_
					"INNER JOIN tipos_ingresos d " & vbCrLf &_
					"ON a.ting_ccod = d.ting_ccod " & vbCrLf &_
					"LEFT OUTER JOIN personas k " & vbCrLf &_
					"ON a.pers_ncorr_codeudor = k.pers_ncorr " & vbCrLf &_
					"INNER JOIN personas j " & vbCrLf &_
					"ON b.pers_ncorr = j.pers_ncorr " & vbCrLf &_
					"INNER JOIN movimientos_cajas g " & vbCrLf &_
					"ON b.mcaj_ncorr = g.mcaj_ncorr " & vbCrLf &_
					"WHERE a.ting_ccod = 4 " & vbCrLf &_
					"  and b.eing_ccod not in (1,3,6) " & vbCrLf &_
					"  and protic.documento_pagado_x_otro(a.ingr_ncorr,a.ding_bpacta_cuota,'A')=0 "& vbCrLf &_
					"  and h.edin_ccod in (1,3) "
				
'"  and g.sede_ccod = '"&negocio.ObtenerSede&"' " & vbCrLf &_	

					 if sede <> "" then
						 'consulta = consulta &  " and isnull(g.sede_ccod,1) = '" & sede & "' "& vbCrLf
 				 		 consulta = consulta &  " and isnull(a.sede_actual,case when b.ingr_fpago < '03/12/2006' then 1 else g.sede_ccod end) = '" & sede & "' "& vbCrLf
					 end if					

					if rut_alumno <> "" then
					   consulta = consulta & "	   and j.pers_nrut = '" & rut_alumno & "' "& vbCrLf
					end if
					
					if rut_apoderado <> "" then
					   consulta = consulta & "	   and k.pers_nrut = '" & rut_apoderado & "' "& vbCrLf
					end if
					
					if num_doc <> "" then					
					  consulta = consulta & "	   and a.ding_ndocto = '" & num_doc & "' "& vbCrLf
					end if
					
					if inicio <> "" or termino <> "" then
					  consulta = consulta & "and convert(datetime,a.ding_fdocto,103) BETWEEN  isnull(convert(datetime,'" & inicio & "',103),convert(datetime,a.ding_fdocto,103)) and isnull(convert(datetime,'" & termino & "',103),convert(datetime,a.ding_fdocto,103))  "& vbCrLf
					end if
					
					if estado_letra <> "" then
					  'consulta = consulta & "and a.edin_ccod = '" & estado_letra & "' "& vbCrLf
					  consulta = consulta & "and h.fedi_ccod = '" & estado_letra & "' "& vbCrLf
					end if
					
'					consulta = consulta  & "	 ) z "& vbCrLf &_
'					"where not exists (select 1  "& vbCrLf &_
'					"				   from detalle_envios x, envios y   "& vbCrLf &_
'					"				   where y.tenv_ccod = 1  "& vbCrLf &_
'					"					 and x.envi_ncorr = y.envi_ncorr   "& vbCrLf &_
'					"					 and x.ding_ndocto = z.ding_ndocto   "& vbCrLf &_
'					"					 and x.ting_ccod = z.ting_ccod   "& vbCrLf &_
'					"					 and x.ingr_ncorr = z.ingr_ncorr   "& vbCrLf &_
'					"					 and y.eenv_ccod = 1)  "& vbCrLf &_ 
'					"and z.edin_ccod not in (SELECT distinct a.edin_ccod "& vbCrLf &_
'										   "FROM detalle_ingresos a, "& vbCrLf &_
'												  "estados_detalle_ingresos b "& vbCrLf &_
'										   "WHERE a.edin_ccod = b.edin_ccod "& vbCrLf &_
'											 "AND b.udoc_ccod = 2) "& vbCrLf 

					consulta = consulta  & "	 ) z "& vbCrLf &_
					"where not exists "& vbCrLf &_
					"				( "& vbCrLf &_
					"				select 1 "& vbCrLf &_
					"				from detalle_envios x "& vbCrLf &_
					"				INNER JOIN envios y "& vbCrLf &_
					"				ON x.envi_ncorr = y.envi_ncorr "& vbCrLf &_
					"				and x.ding_ndocto = z.ding_ndocto "& vbCrLf &_
					"				and x.ting_ccod = z.ting_ccod "& vbCrLf &_
					"				and x.ingr_ncorr = z.ingr_ncorr "& vbCrLf &_
					"				and y.eenv_ccod = 1 "& vbCrLf &_
					"				AND y.tenv_ccod = 1 "& vbCrLf &_
					"				)  "& vbCrLf &_ 
					"and z.edin_ccod not in "& vbCrLf &_
					"				( "& vbCrLf &_
					"				SELECT distinct a.edin_ccod "& vbCrLf &_
					"				FROM detalle_ingresos a "& vbCrLf &_
					"				INNER JOIN estados_detalle_ingresos b "& vbCrLf &_
					"				ON a.edin_ccod = b.edin_ccod "& vbCrLf &_
					"				WHERE b.udoc_ccod = 2 "& vbCrLf &_
					"				) "& vbCrLf  								   							   

	
  if len(Request.QueryString) > 25 then
	  'response.Write("<PRE>" & consulta & "</PRE>")
  	  'response.Flush()
	  f_letras.consultar consulta
  else
	f_letras.consultar "select '' where 1 = 2"
	f_letras.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
  end if
'response.Write("<pre>"&consulta&"</pre>")				
'response.End()	
cantidad=f_letras.nroFilas
'-------------------------------------------------------------------------------------
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
	
	function salir()
	{
	  CerrarActualizar();
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
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <%'pagina.DibujarEncabezado()%>  
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
                    <td width="143" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador
                      de Letras</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="507" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
                          <td colspan="3">Periodo fecha de Vencimiento</td>
                          <td width="10"><div align="center"></div></td>
                          <td width="92">&nbsp;</td>
                          <td width="16">&nbsp;</td>
                          <td width="152">&nbsp;</td>
                          <td width="102" rowspan="6"><div align="center"></div>
                            <div align="center"> 
                              <%botonera.DibujaBoton "buscar" %>
                            </div></td>
                        </tr>
                        <tr> 
                          <td width="101">Inicio</td>
                          <td width="12">:</td>
                          <td width="141"><div align="left"></div>
                            <% f_busqueda.DibujaCampo ("inicio") %>
							<%calendario.DibujaImagen "fecha_oculta_inicio","1","buscador" %>(dd/mm/aaaa)
                          <td>&nbsp;</td>
                          <td>T&eacute;rmino</td>
                          <td>:</td>
                          <td><div align="left"> 
                              <% f_busqueda.DibujaCampo ("termino") %>
							  <%calendario.DibujaImagen "fecha_oculta_termino","2","buscador" %>(dd/mm/aaaa)
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
                          <td>Estado Letra</td>
                          <td>:</td>
                          <td><% f_busqueda.DibujaCampo ("edin_ccod") %> </td>
                        </tr>
                        <tr> 
                          <td>Sede</td>
                          <td>:</td>
                          <td><% f_busqueda.DibujaCampo ("sede_ccod") %></td>
                          <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                              </font></div></td>
                          <td>&nbsp; </td>
                          <td>&nbsp;</td>
                          <td><div align="center"> 
                              <input type="hidden" name="folio_envio" value="<%=folio_envio%>">
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
                 <td bgcolor="#D8D8DE"> <div align="center">
                    <BR>   <%pagina.DibujarTituloPagina%>    <BR>
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
                  <div align="center"> <BR>
                  </div>
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
                  <td width="57" bgcolor="#D8D8DE"><table width="100%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="19%"><div align="left">
                          <% 
						  botonera.AgregaBotonParam "guardar_letras","url","Proc_Envios_Banco_Buscar.asp?folio_envio=" & folio_envio
						  if cint(cantidad)=0 then
						       botonera.agregabotonparam "guardar_letras", "deshabilitado" ,"TRUE"
						  end if
						  botonera.DibujaBoton "guardar_letras"%>
                        </div></td>
                      <td width="81%"> <div align="left">
                          <% botonera.DibujaBoton "cerrar_actualizar" %>
                        </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="305" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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

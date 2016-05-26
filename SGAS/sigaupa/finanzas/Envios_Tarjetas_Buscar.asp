<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
folio_envio = request.querystring("folio_envio")
set pagina = new CPagina
pagina.Titulo = "Agregar Cuotas al Envio de Tarjetas"
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Envios_Tarjetas.xml", "botonera"
'-----------------------------------------------------------------------
 sede 				= request.querystring("busqueda[0][sede_ccod]")
 inicio 			= request.querystring("busqueda[0][inicio]")
 termino 			= request.querystring("busqueda[0][termino]")
 rut_alumno 		= request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito 	= request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado 		= request.querystring("busqueda[0][code_nrut]")
 num_doc 			= request.querystring("busqueda[0][ding_ndocto]")
 estado_tarjeta 	= request.querystring("busqueda[0][edin_ccod]")
 tipo_tarjeta 		= request.querystring("busqueda[0][ting_ccod]")
 rut_apoderado_digito = request.querystring("busqueda[0][code_xdv]")

 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "Envios_Tarjetas.xml", "busqueda_letras"
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
 f_busqueda.AgregaCampoCons "edin_ccod", estado_tarjeta
 f_busqueda.AgregaCampoCons "ting_ccod", tipo_tarjeta

'---------------------------------
 set f_letras = new CFormulario
 f_letras.Carga_Parametros "Envios_Tarjetas.xml", "f_letras"
 f_letras.Inicializar conexion
 'letras que no estan en algun folio pendiente y que estan en UAS	
		   
			   
	consulta = "select z.*  "& vbCrLf &_
					"from ( "& vbCrLf &_
					"	 select " & folio_envio & " as envi_ncorr,  a.ding_ndocto as c_ding_ndocto, a.ding_ndocto, case when len(isnull(a.ding_ndocto,0))<=3 then Right(substring(a.ding_tcuenta_corriente,1,12),4) else cast(a.ding_ndocto as varchar) end as num_tarjeta,  "& vbCrLf &_
					"		    h.edin_tdesc, a.ding_tcuenta_corriente,  protic.obtener_nombre_completo(a.pers_ncorr_codeudor,'n') as nombre_apoderado,  "& vbCrLf &_
					"		   a.ding_mdetalle, a.ting_ccod, b.ingr_ncorr, 0 as enviar, a.edin_ccod,  convert(varchar,b.ingr_fpago,103) as ingr_fpago,   "& vbCrLf &_
					"		   convert(varchar,a.ding_fdocto,103) as ding_fdocto, substring(i.ting_tdesc,12,7) as ting_tdesc,  "& vbCrLf &_
					"		   protic.obtener_rut(b.pers_ncorr) as rut_alumno, protic.obtener_rut(a.pers_ncorr_codeudor) as rut_apoderado  "& vbCrLf &_
					" from detalle_ingresos a "& vbCrLf &_
					" join ingresos b "& vbCrLf &_
					"    on a.ingr_ncorr = b.ingr_ncorr "& vbCrLf &_
					" left outer join estados_detalle_ingresos h "& vbCrLf &_
					"    on a.edin_ccod = h.edin_ccod "& vbCrLf &_
					" join tipos_ingresos i "& vbCrLf &_
					"    on a.ting_ccod = i.ting_ccod "& vbCrLf &_
					" join personas j "& vbCrLf &_
					"    on b.pers_ncorr = j.pers_ncorr "& vbCrLf &_
					" left outer join personas k "& vbCrLf &_
					"    on a.pers_ncorr_codeudor = k.pers_ncorr "& vbCrLf &_  
					"	 where a.ting_ccod  in(51,13)  "& vbCrLf &_
					"    and a.edin_ccod not in (6,15) "& vbCrLf &_
					"    and a.DING_NCORRELATIVO > 0 "
					

'"      and h.fedi_ccod in (1,15) "& vbCrLf &_and a.ding_bpacta_cuota='N'

					if rut_alumno <> "" then
					   consulta = consulta & "	   and j.pers_nrut = '" & rut_alumno & "' "& vbCrLf
					end if
					
					if rut_apoderado <> "" then
					   consulta = consulta & "	   and k.pers_nrut = '" & rut_apoderado & "' "& vbCrLf
					end if
					
					if num_doc <> "" then					
					  'consulta = consulta & "	   and case when len(isnull(a.ding_ndocto,0))<=3 then Right(substring(a.ding_tcuenta_corriente,1,12),4) else cast(a.ding_ndocto as varchar) end = '" & num_doc & "' "& vbCrLf
					  consulta = consulta & "	   and case when len(isnull(a.ding_ndocto,0))<=2 then Right(substring(a.ding_tcuenta_corriente,1,12),3) else cast(a.ding_ndocto as varchar) end = '" & num_doc & "' "& vbCrLf
					end if
					
					if inicio <> "" or termino <> "" then
					  consulta = consulta & "and convert(datetime,a.ding_fdocto,103) BETWEEN  isnull(convert(datetime,'" & inicio & "',103),convert(datetime,a.ding_fdocto,103)) and isnull(convert(datetime,'" & termino & "',103),convert(datetime,a.ding_fdocto,103))  "& vbCrLf
					end if
					
					if estado_tarjeta <> "" then
					  
					   consulta = consulta & "and h.fedi_ccod = '" & estado_tarjeta & "' "& vbCrLf
					end if
					
					
					if tipo_tarjeta <> "" then
					  
					   consulta = consulta & "and a.ting_ccod = '" & tipo_tarjeta & "' "& vbCrLf
					end if
					
					consulta = consulta  & "	 ) z "& vbCrLf &_
					"where not exists (select 1  "& vbCrLf &_
					"				   from detalle_envios x, envios y   "& vbCrLf &_
					"				   where y.tenv_ccod = 5  "& vbCrLf &_
					"					 and x.envi_ncorr = y.envi_ncorr   "& vbCrLf &_
					"					 and x.ding_ndocto = z.ding_ndocto   "& vbCrLf &_
					"					 and x.ting_ccod = z.ting_ccod   "& vbCrLf &_
					"					 and x.ingr_ncorr = z.ingr_ncorr   "& vbCrLf &_
					"					 and y.eenv_ccod = 1)  "& vbCrLf &_ 
					"and z.edin_ccod not in (SELECT distinct a.edin_ccod "& vbCrLf &_
										   "FROM detalle_ingresos a, "& vbCrLf &_
												  "estados_detalle_ingresos b "& vbCrLf &_
										   "WHERE a.edin_ccod = b.edin_ccod "& vbCrLf &_
											 "AND b.udoc_ccod = 2) "& vbCrLf &_ 
					" order by num_tarjeta desc,ding_ndocto asc "
	 	 
		   	
	if len(Request.QueryString) > 25 then
	 ' response.Write("<PRE>" & consulta & "</PRE>") 
	  'response.End() 				
	  f_letras.consultar consulta
   else
	 f_letras.consultar "select '' where 1 = 2"
	 f_letras.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
  end if
'response.Write("<pre>"&consulta&"</pre>")	
'response.End()
cantidad=f_letras.nroFilas
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif"> Buscador 
                          de Tarjetas</font></div></td>
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
                                     
                  <BR>
                      <table width="660" border="0" align="left">
                        <tr> 
                          <td colspan="3">Periodo Fecha de Vencimiento</td>
                          <td width="3">&nbsp;</td>
                          <td width="96">&nbsp;</td>
                          <td width="11">&nbsp;</td>
                          <td width="142">&nbsp;</td>
                          <td width="102" rowspan="7"><div align="center"></div>
                            <div align="center"> 
                              <%botonera.DibujaBoton "buscar" %>
                            </div></td>
                        </tr>
                        <tr> 
                          <td width="95">Inicio</td>
                          <td width="16">:</td>
                          <td width="161"><div align="left"></div>
                            <% f_busqueda.DibujaCampo ("inicio") %>
							<%calendario.DibujaImagen "fecha_oculta_inicio","1","buscador" %>(dd/mm/aaaa)</td>
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
                          <td>Estado Tarjeta</td>
                          <td>:</td>
                          <td> <% f_busqueda.DibujaCampo ("edin_ccod") %> </td>
                          <td>&nbsp;</td>
                          <td><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">N&ordm; 
                              Tarjeta</font></div></td>
                          <td>:</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                            <% f_busqueda.DibujaCampo ("ding_ndocto") %>
                            </font></td>
                        </tr>
                        <tr> 
                          <td>Tipo Tarjeta</td>
                          <td>:</td>
                          <td><% f_busqueda.DibujaCampo ("ting_ccod") %></td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                            <input type="hidden" name="folio_envio" value="<%=folio_envio%>">
                            </font></td>
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
                  
                <td bgcolor="#D8D8DE"> <div align="center"><BR>
                    <%pagina.DibujarTituloPagina%>
                    <BR>
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
                  <td width="79" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="17%"><div align="center">
                          <% 
						  botonera.AgregaBotonParam "guardar_letras","url","Proc_Envios_Tarjetas_Buscar.asp?folio_envio=" & folio_envio
						  if cint(cantidad)=0 then
						     botonera.agregabotonparam "guardar_letras", "deshabilitado" ,"TRUE"
						  end if
						  botonera.DibujaBoton "guardar_letras"%>
                        </div></td>
                      <td width="83%"> <div align="left">
                          <% botonera.DibujaBoton "cerrar_actualizar" %>
                        </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="283" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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

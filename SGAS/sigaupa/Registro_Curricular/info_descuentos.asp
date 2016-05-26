<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

post_ncorr = Request.QueryString("post_ncorr")
ofer_ncorr = Request.QueryString("ofer_ncorr")
stde_ccod = Request.QueryString("stde_ccod")

'-----------------------------------DATOS PERIODO -----------------------------------------------


cc_peri_ccod= " select peri_ccod from postulantes where cast(post_ncorr as varchar)=" & post_ncorr
peri_ccod = conexion.consultaUno(cc_peri_ccod)

cc_sede_ccod = " select oo.sede_ccod from postulantes pp, ofertas_academicas oo  where cast(post_ncorr as varchar)=" &post_ncorr &" and pp.ofer_ncorr=oo.ofer_ncorr" 
sede_ccod = conexion.consultaUno(cc_sede_ccod)

'----------------------------------DATOS TIPO DESCUENTO -------------------------------------
		consulta_nombre ="select stde_tdesc  from stipos_descuentos where stde_ccod= "& stde_ccod
		nombreBeneficio = conexion.consultaUno(consulta_nombre)

'-----------------------------------MONTO GENERAL ---------------------------------------------
		 consulta_monto_total = " select mb.MBEN_MMONTO as monto_total  from montos_beneficios mb  where mb.STDE_CCOD = " & stde_ccod & " and mb.sede_ccod=" & sede_ccod & " and mb.peri_ccod=" & peri_ccod 
		'response.Write(consulta_monto_total)
		monto = conexion.consultaUno(consulta_monto_total)
		
'---------------------------------MONTO AUTORIZADO ------------------------------------------------------
 		consulta_monto_autorizado = " select (sum (sd.sdes_mmatricula)+ sum(sd.SDES_MCOLEGIATURA)) as monto_actual_autorizado from sdescuentos sd, postulantes pp, ofertas_academicas oo where sd.stde_ccod=" & stde_ccod & " and sd.post_ncorr= pp.post_ncorr and pp.OFER_NCORR= oo.OFER_NCORR and oo.SEDE_CCOD=" & sede_ccod & "  and oo.peri_ccod="& peri_ccod & "and sd.esde_ccod = 1 group by sd.stde_ccod"		
		montoAutorizado = conexion.consultaUno(consulta_monto_autorizado)
		'response.Write(consulta_monto_autorizado)
		
'-------------------------------- MONTO MATRICULADOS -----------------------------------------------------

		consulta_monto_matriculado = "select  sum(dda.deta_mvalor_unitario) monto_matriculados from contratos cc, beneficios bba, detalles dda , postulantes pp , ofertas_academicas oo where bba.stde_ccod=" & stde_ccod & " and cc.CONT_NCORR=bba.CONT_NCORR and bba.CONT_NCORR=dda.COMP_NDOCTO  and dda.tdet_ccod=bba.stde_ccod and dda.TCOM_CCOD in (1,2)  and cc.econ_ccod=1 and cc.peri_ccod="& peri_ccod & " and cc.POST_NCORR=pp.POST_NCORR and pp.OFER_NCORR= oo.OFER_NCORR and oo.SEDE_CCOD=" & sede_ccod & " and bba.EBEN_CCOD =1 group by bba.stde_ccod"
		'response.Write(consulta_monto_matriculado)
		montoMatriculado = conexion.consultaUno(consulta_monto_matriculado)
		
'--------------------------------------- MONTO DISPONIBLE -----------------------------------------------------------		
		if EsVacio(monto) then
			if EsVacio(montoAutorizado) then 
				consulta_monto_disponible = "select  ( isnull(null,0) - isnull(null,0) ) as monto_disponible"	
			else
				consulta_monto_disponible = "select  ( isnull(null,0) - isnull("& montoAutorizado & ",0) ) as monto_disponible"		
			end if
		else
		consulta_monto_disponible = "select  ( isnull("& monto & ",0) - isnull("& montoAutorizado & ",0) ) as monto_disponible"
		end if
		'response.Write(consulta_monto_disponible)
		montoDisponible = conexion.consultaUno(consulta_monto_disponible)

'--------------------------------------- MONTO ALUMNO -----------------------------------------------------------
		
		consulta_monto_alumno = " select (isnull(sd.SDES_MMATRICULA,0) + isnull(sd.SDES_MCOLEGIATURA,0)) as monto_alumno from sdescuentos sd where  sd.post_ncorr=" &post_ncorr &" and sd.ofer_ncorr = " &ofer_ncorr &" and sd.STDE_CCOD=" & stde_ccod 
		montoAlumno = conexion.consultaUno(consulta_monto_alumno)
		
		
		consulta_ya_autorizado = " select sd.esde_ccod as autorizado from sdescuentos sd where  sd.post_ncorr=" &post_ncorr &" and sd.ofer_ncorr = " &ofer_ncorr &" and sd.STDE_CCOD=" & stde_ccod 
		'response.Write(consulta_ya_autorizado)
		autorizado= conexion.consultaUno(consulta_ya_autorizado)
		'response.Write(autorizado)
'--------------------------------------- MONTO APLICADO DESCUENTO -----------------------------------------------------------		
		consulta_monto_despues = "select  ( isnull(abs("& montoDisponible &"),0) - isnull("& montoAlumno & ",0) ) as monto_despues"		
		'response.Write(consulta_monto_disponible)
		montoDespues = conexion.consultaUno(consulta_monto_despues)
		
		
%>


<html>
<head>
<title>Informaci&oacute;n de descuentos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
</script>

</head>
<body bgcolor="#555564" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	 		
	<table width="416" border="0" align="center" cellpadding="0" cellspacing="0">
        <%'pagina.DibujarEncabezado()%>
        <tr> 
          <td width="482" valign="top" bgcolor="#EAEAEA"> <table width="47%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
                 
                    <tr> 
                      <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="400" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                      <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="400" height="8" border="0"></td>
                      <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                      <td>
                        <%pagina.DibujarLenguetas Array("Información"), 1 %>
                      </td>
                      <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="400" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
                    </tr>
                  </table>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                      <td bgcolor="#D8D8DE"> <BR> <form name="edicion">
                          <table  border="0" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td width="250">Tipo de Descuento </td>
                              <td width="14"><div align="center">: </div></td>
                              <td width="10"><div align="center"></div></td>
                              <td width="132"><strong><%=nombreBeneficio%> </strong></td>
                            </tr>
                            <tr> 
                              <td width="250">Monto Total</td>
                              <td width="14"><div align="center">:</div></td>
                              <td width="10"><div align="center">$</div></td>
                              <td align="left"><strong> 
                                <%if (monto) then %>
                                </strong><strong><%=formatnumber(monto,0,-1,0,-1)%> 
                                <%else %>
                                0 
                                <% end if%>
                                </strong></td>
                            </tr>
                            <tr> 
                              <td width="250">Monto Total Autorizado</td>
                              <td width="14"><div align="center">:</div></td>
                              <td width="10"><div align="center">$</div></td>
                              <td><strong> 
                                <%if (montoAutorizado) then %>
                                <%=formatnumber(montoAutorizado,0,-1,0,-1)%> 
                                <%else %>
                                0 
                                <% end if%>
                                </strong></td>
                            </tr>
                            <tr> 
                              <td width="250">Monto Total Matriculado</td>
                              <td width="14"><div align="center">:</div></td>
                              <td width="10"><div align="center">$</div></td>
                              <td><p><strong> 
                                  <label> </label>
                                  <%if (montoMatriculado) then %>
                                  <%=formatnumber(montoMatriculado,0,-1,0,-1)%> 
                                  <%else %>
                                  0 
                                  <% end if%>
                                  <br>
                                  </strong></p></td>
                            </tr>
                            <tr> 
                              <td>Monto Total Disponible</td>
                              <td align="center">:</td>
                              <td align="center">$</td>
                              <td> <strong> 
                                <%if (montoDisponible) then %>
                                <%=formatnumber(montoDisponible,0,-1,0,-1)%> 
                                <%else %>
                                0 
                                <% end if%>
                                </strong> </td>
                            </tr>
                            <tr> 
                              <td>Monto Asignado Alumno</td>
                              <td align="center">:</td>
                              <td align="center">$</td>
                              <td><strong> 
                                <%if (montoAlumno) then %>
                                <%=formatnumber(montoAlumno,0,-1,0,-1)%> 
                                <%else %>
                                0 
                                <% end if%>
                                </strong></td>
                            </tr>
                            <%if autorizado="2" then %>
                            <tr> 
                              <td>Monto disponible aplicado este descuento</td>
                              <td align="center">:</td>
                              <td align="center">$</td>
                              <td><strong> 
                                <%if (montoDespues) then %>
                                <%=formatnumber(montoDespues,0,-1,0,-1)%> 
                                <%else %>
                                0 
                                <% end if%>
                                </strong></td>
                            </tr>
                            <% else %>
                            <tr> 
                              <td height="10" colspan="4">Monto descuento de este 
                                alumno ya ha sido asignado</td>
                            </tr>
                            <% end if%>
                          </table>
                        </form>
                        <br> </td>
                      <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                    </tr>
                  </table>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                      <td width="287" bgcolor="#D8D8DE"> <table width="100%" border="0" cellpadding="0" cellspacing="0">
                          <tr> 
                            <td width="46%" align="center">
                              <%pagina.DibujarBoton "Cerrar", "CERRAR", ""%>
                            </td>
                            <td width="54%" align="center">&nbsp; </td>
                          </tr>
                        </table></td>
                      <td width="75" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                      <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                    </tr>
                    <tr> 
                      <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
        </tr>
      </table>
      <br>
      <br>
      
     
    </td>
  </tr>  
</table>
</body>
</html>

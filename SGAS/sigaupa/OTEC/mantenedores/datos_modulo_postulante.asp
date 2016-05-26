<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.QueryString
'	response.Write(k&" = "&request.QueryString(k)&"<br>")
'	next
v_pers_nrut  =Request.QueryString("pers_nrut")
v_dcur_ncorr =Request.QueryString("dcur_ncorr")
v_dgso_ncorr =Request.QueryString("dgso_ncorr")
'response.Write(v_fact_ncorr)
'---------------------------------------------------------------------------------------------------
set errores = new CErrores

set pagina = new CPagina
pagina.Titulo = "Datos Empresas"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set pagina = new cPagina

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "modulo_postulantes.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set datos_empresa = new CFormulario
datos_empresa.Carga_Parametros "modulo_postulantes.xml", "datos_empresa"
datos_empresa.Inicializar conexion


sql_descuentos=" Select e.PERS_NCORR,d.dcur_tdesc, "& vbCrLf &_
" isnull(c.ofot_nmatricula,0) as monto_matricula,isnull(c.ofot_narancel,0) as monto_arancel,a.fpot_ccod,isnull(case a.fpot_ccod when 4 then norc_otic else norc_empresa end,0) as num_oc,isnull(case a.fpot_ccod when 4 then norc_otic else norc_empresa end,0) as n_docto, "& vbCrLf &_
" isnull(c.ofot_nmatricula,0)+isnull(c.ofot_narancel,0) as monto_total,isnull(case a.fpot_ccod when 4 then norc_otic else norc_empresa end,0) as num_oc_2,"& vbCrLf &_
" isnull(ocot_monto_empresa,0) as financia_empresa,isnull(ocot_monto_otic,0) as financia_otic,isnull(ocot_monto_persona,0) as financia_persona "& vbCrLf &_
" from postulacion_otec a "& vbCrLf &_
" INNER JOIN personas e "& vbCrLf &_
" ON a.pers_ncorr = e.pers_ncorr AND cast(e.pers_nrut as varchar) = '"&v_pers_nrut&"' "& vbCrLf &_
" INNER JOIN datos_generales_secciones_otec b "& vbCrLf &_
" ON a.dgso_ncorr = b.dgso_ncorr "& vbCrLf &_
" INNER JOIN ofertas_otec c "& vbCrLf &_
" ON b.dgso_ncorr = c.dgso_ncorr "& vbCrLf &_
" INNER JOIN diplomados_cursos d "& vbCrLf &_
" ON c.dcur_ncorr = d.dcur_ncorr and d.DCUR_NCORR = "&v_dcur_ncorr&""& vbCrLf &_
" LEFT OUTER JOIN ordenes_compras_otec f "& vbCrLf &_
" ON a.dgso_ncorr = f.dgso_ncorr "& vbCrLf &_
" and a.fpot_ccod = f.fpot_ccod "& vbCrLf &_
" and case a.fpot_ccod when 4 then norc_otic else norc_empresa end = f.nord_compra "

'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.End()
datos_empresa.Consultar sql_descuentos

'---------------------------------------------------------------------------------------------------
v_pers_ncorr = conexion.ConsultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar) = '" & v_pers_nrut & "'")
'---------------------------------------------------------------------------------------------------

set empresa = new CFormulario
empresa.Carga_Parametros "modulo_postulantes.xml", "empresa"
empresa.Inicializar conexion

sql_empresa="select protic.obtener_rut(empr_ncorr_empresa) as rut,protic.obtener_nombre_completo(empr_ncorr_empresa, 'n') as nombre,"& vbCrLf &_
"protic.obtener_rut(empr_ncorr_otic) as rut_otic,protic.obtener_nombre_completo(empr_ncorr_otic, 'n') as nombre_otic "& vbCrLf &_
"from postulacion_otec "& vbCrLf &_
"where pers_ncorr="&v_pers_ncorr&""& vbCrLf &_
"and  dgso_ncorr ="&v_dgso_ncorr

empresa.Consultar sql_empresa
empresa.Siguiente

rut = empresa.ObtenerValor("rut")
rut_otic = empresa.ObtenerValor("rut_otic")
datos_empresa.Siguiente
financia_persona= datos_empresa.ObtenerValor("financia_persona")
v_n_docto = datos_empresa.ObtenerValor("n_docto")
financia_otic = datos_empresa.ObtenerValor("financia_otic")
financia_empresa = datos_empresa.ObtenerValor("financia_empresa")

'---------------------------------------------------------------------------------------------------

if financia_persona > "0" then
set persona_narutal = new CFormulario
persona_narutal.Carga_Parametros "modulo_postulantes.xml", "persona_narutal"
persona_narutal.Inicializar conexion


sql_persona="select protic.obtener_rut(pers_ncorr) as rut_persona,protic.obtener_nombre_completo(pers_ncorr, 'n') as nombre_persona from personas where cast(pers_nrut as varchar) = '" & v_pers_nrut & "'"

persona_narutal.Consultar sql_persona
persona_narutal.Siguiente

rut_persona= persona_narutal.ObtenerValor("rut_persona")
end if

'---------------------------------------------------------------------------------------------------

set f_abonos_documentados = new CFormulario
f_abonos_documentados.Carga_Parametros "modulo_postulantes.xml", "abonos"
f_abonos_documentados.Inicializar conexion

sql_documentados="select a.comp_ndocto,cast(case d.ting_brebaje when 'S' then -a.abon_mabono else  a.abon_mabono end as numeric) as abon_mabono"& vbCrLf &_
", a.abon_fabono, b.eing_ccod, b.ingr_fpago, b.ingr_mefectivo, b.ingr_mdocto, b.ting_ccod"& vbCrLf &_
", b.ingr_nfolio_referencia, c.ting_ccod as ting_ccod_documento, c.ding_ndocto, c.ding_mdocto"& vbCrLf &_
", c.ding_fdocto, c.edin_ccod, c.ting_ccod ,c.banc_ccod "& vbCrLf &_
"from abonos a INNER JOIN ingresos b "& vbCrLf &_
"ON a.ingr_ncorr = b.ingr_ncorr "& vbCrLf &_
"LEFT OUTER JOIN detalle_ingresos c "& vbCrLf &_
"ON b.ingr_ncorr = c.ingr_ncorr "& vbCrLf &_
"INNER JOIN tipos_ingresos d "& vbCrLf &_
"ON b.ting_ccod = d.ting_ccod "& vbCrLf &_
"WHERE protic.estado_origen_ingreso(a.ingr_ncorr) = 4 "& vbCrLf &_
"and a.tcom_ccod = '7' "& vbCrLf &_
"and a.inst_ccod = '1' "& vbCrLf &_
"and c.ding_ndocto = "&v_n_docto&""& vbCrLf &_
"and (c.ding_mdocto = "&financia_otic&" or c.ding_mdocto ="&financia_empresa&")"& vbCrLf &_
"and a.dcom_ncompromiso = '1'"

f_abonos_documentados.Consultar sql_documentados
'response.Write("<pre>"&sql_documentados&"</pre>")
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

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%pagina.DibujarTituloPagina%>
<table width="750"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<%if request.QueryString.count > 0 and buscar<>"N" then%> 
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>		  
            <td><br>  
             <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Datos Empresas"%>
                    
                    <!-- TABLA EMPRESA--> 
				 <table width="35%" style="float:left" border="0">                 
                 <%if rut <> "" then %>
					   <tr>   
                       		<td width="57%"><strong><em><u>EMPRESA</u></em></strong></td>     
                            <td>&nbsp;</td>
                            <td width="38%">&nbsp;</td>              	 
                       </tr>                       
                         <tr>						
                            <td><strong>Rut Empresa</strong></td>   
                            <td width="5%"><strong>:</strong></td>
                            <td><%empresa.DibujaCampo("rut")%></td>
                        </tr>
                        <tr>						
                            <td><strong>Nombre Empresa</strong></td>   
                            <td width="5%"><strong>:</strong></td>
                            <td><%empresa.DibujaCampo("nombre")%></td>  
                        </tr>
                        <%end if%>  
                      </table>      
                      
                       <!-- TABLA OTIC--> 
                      <table width="30%" style="float:left" border="0">
                      	<%if rut_otic <> "" then %>
					   <tr>   
                       		<td width="40%"><strong><em><u>OTIC</u></em></strong></td>     
                            <td>&nbsp;</td>
                            <td width="54%">&nbsp;</td>              	 
                       </tr>                       
                         <tr>						
                            <td><strong>Rut Otic</strong></td>   
                            <td width="6%"><strong>:</strong></td>
                            <td><%empresa.DibujaCampo("rut_otic")%></td>
                        </tr>
                        <tr>						
                            <td><strong>Nombre Otic</strong></td>   
                            <td width="6%"><strong>:</strong></td>
                            <td><%empresa.DibujaCampo("nombre_otic")%></td>   
                        </tr>
                        <%end if%>  
                      	
                      </table>                      
                      
                      <!-- TABLA PERSONA NATURAL-->          
                      <table width="38%" style="float:left" border="0">
                      	<%if rut_persona <> "" then %>
					   <tr>   
                       		<td width="48%" nowrap="3"><strong><em><u>PERSONA NATURAL</u></em></strong></td>     
                            <td>&nbsp;</td>
                            <td width="48%">&nbsp;</td>              	 
                       </tr>                       
                         <tr>						
                            <td><strong>Rut Persona</strong></td>   
                            <td width="4%"><strong>:</strong></td>
                            <td><%persona_narutal.DibujaCampo("rut_persona")%></td>
                        </tr>
                        <tr>						
                            <td><strong>Nombre Persona</strong></td>   
                            <td width="4%"><strong>:</strong></td>
                            <td><%persona_narutal.DibujaCampo("nombre_persona")%></td>  
                        </tr>
                        <%end if%>  
                      	
                      </table> 
                  </tr>
                </table>
                <br>
                <table width="98%"  border="0" align="center">
					   <tr>                       	 
                            </tr>
                            <tr>						
                                <td align="center">
									<%datos_empresa.Dibujatabla()%>
							   </td>
                        </tr>
                      </table>                      
                          <br>
                           <table width="98%"  border="0" align="center">
					   <tr>                       	 
                            </tr>
                            <tr>						
                                <td align="center"><%pagina.DibujarSubtitulo "Abonos documentados"%>
									<%f_abonos_documentados.Dibujatabla()%>
							   </td>
                        </tr>
                      </table>
                      <br>
            </form>
        </table>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="20%" height="20"><div align="center">
              <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("cerrar")%></div></td>
				</tr>
              </table>
            </div></td>
            <td width="80%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	 <%end if%><br>
	 <%buscar=""%>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
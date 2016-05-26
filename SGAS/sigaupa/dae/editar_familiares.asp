<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

pers_ncorr_pariente=request.QueryString("pers_ncorr")
v_parentesco=request.QueryString("pare_ccod")

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------

rut_temporal = request.Form("padre[0][pers_nrut]")
xdv_temporal = request.Form("padre[0][pers_xdv]")



'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Postulación - Antecedentes Familiares"


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "editar_familia.xml", "botonera"



'---------------------------------------------------------------------------------------------------
set f_padre = new CFormulario
f_padre.Carga_Parametros "editar_familia.xml", "grupo_familiar"
f_padre.Inicializar conexion

consulta = "select pers_tnombre,pers_tape_paterno,pers_tape_materno,pers_nrut,pers_xdv,dire_tcalle,dire_tnro,dire_tpoblacion,ciud_ccod,"& vbCrLf &_
"dire_tblock,dire_tdepto,dire_tfono,pers_tcelular,pers_temail,nedu_ccod "& vbCrLf &_
"from personas a,direcciones b "& vbCrLf &_
"where a.pers_ncorr=1135854 and a.pers_ncorr=b.pers_ncorr and tdir_ccod=1"



response.Write("<pre>" & consulta & "</pre>")
 'response.end() 
f_padre.Consultar consulta
f_padre.Siguientef


'---------------------------------------------------------------------------------------------------

  
 
'-------------------------------------------------------------------------------------


'v_epos_ccod = conexion.ConsultaUno("select epos_ccod from postulantes where post_ncorr = '" & v_post_ncorr & "'")
'response.Write(v_post_ncorr)

	
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
<script language="JavaScript" src="../biblioteca/dicc_ciudades.js"></script>
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">


</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "padre[0][pers_fnacimiento]","1","edicion","fecha_oculta_fnacimiento_papa"
	calendario.MuestraFecha "padre[0][pers_fdefuncion]","2","edicion","fecha_oculta_fdefuncion_papa"
	calendario.FinFuncion
%>

<style type="text/css">
<!--
.style1 {color: #FF0000}
.Estilo2 {color: #FF0000; font-weight: bold; }
-->
</style>
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');">

<table width="750"  border="0" align="center" cellpadding="0" cellspacing="0">
  <!--<tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>-->

  <tr>
    <td valign="top" bgcolor="#EAEAEA">
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
           
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTitulo "Ingreso Datos FAMILIARES" %>
              <br>
              <br>
              <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td><div align="justify"><%=msjRecordatorio%></div></td>
                </tr>
              </table>
			</div>
              <form name="edicion" method="post">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Familiar"%>                      
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" >
                            <tr> 
                              <td width="20%"><span class="Estilo2">(*)</span><strong> R.U.T.</strong><br> <%f_padre.DibujaCampo("pers_nrut")%>
                                - 
                                <%f_padre.DibujaCampo("pers_xdv")%></td>
                              <td width="30%"><strong>FECHA DE NACIMIENTO </strong><br> 
                                <%f_padre.DibujaCampo("pers_fnacimiento")%>  </td>
                              <td width="30%"><strong>FECHA DE DEFUNCION </strong><br> 
                                <%f_padre.DibujaCampo("pers_fdefuncion")%></td>
							  <td width="20%"><span class="Estilo2">(*)</span><strong>PARENTESCO</strong><BR><%f_padre.DibujaCampo("pare_ccod")%></td>
                            </tr>
                          </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><span class="Estilo2">(*)</span><strong> APELLIDO PATERNO </strong><br>
                              <%f_padre.DibujaCampo("pers_tape_paterno")%></td>
                          <td><span class="Estilo2">(*)</span><strong> APELLIDO MATERNO </strong><br>
                              <%f_padre.DibujaCampo("pers_tape_materno")%></td>
                          <td><span class="Estilo2">(*)</span><strong> NOMBRES</strong><br>
                              <%f_padre.DibujaCampo("pers_tnombre")%></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="40%"><strong>REGI&Oacute;N</strong><br>
                              <%f_padre.DibujaCampo("regi_ccod")%>                          </td>
                              <td width="40%"><strong>CIUDAD DE PROCEDENCIA</strong><br>
                              <%f_padre.DibujaCampo("ciud_ccod")%></td>
							  <td width="20%"><span class="Estilo2">(*)</span><strong>EST. CIVIL</strong><br>
                              <%f_padre.DibujaCampo("eciv_ccod")%></td>
                        </tr>
                      </table>
                      <br>
						<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
						<tr> 
                              <td><strong>CALLE</strong><br> <%f_padre.DibujaCampo("dire_tcalle")%></td>
                              <td><strong>N&Uacute;MERO</strong><br> <%f_padre.DibujaCampo("dire_tnro")%></td>
                              <td> <strong>DEPTO</strong><br>  <%f_padre.DibujaCampo("dire_tblock")%> </td>
							  <td><strong>CONDOMINIO/CONJUNTO</strong><br> <%f_padre.DibujaCampo("dire_tpoblacion")%></td>
                              <td><strong>TEL&Eacute;FONO</strong><br> <%f_padre.DibujaCampo("dire_tfono")%></td>
                            </tr>
					</table>
					<br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                            
							<tr> 
                              <td><strong>CELULAR</strong><br> <%f_padre.DibujaCampo("pers_tcelular")%></td>
                              <td colspan="2"><strong>EMAIL</strong><br> <%f_padre.DibujaCampo("pers_temail")%></td>
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                            </tr>
                             <tr>
								<td colspan="4" align="right"> <%f_botonera.DibujaBoton("copiar_direccion")%></td>
						     </tr>
                          </table>
					  <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><strong>ESCOLARIDAD (&Uacute;LTIMO A&Ntilde;O CURSADO) </strong><br>
                            <%f_padre.DibujaCampo("nedu_ccod")%></td>
                        </tr>
                      </table>
                      <br>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><strong>PROFESI&Oacute;N U OFICIO </strong><br>
                              <%f_padre.DibujaCampo("pers_tprofesion")%></td>
                          <td><strong>EMPRESA</strong><br>
                              <%f_padre.DibujaCampo("pers_tempresa")%></td>
                          <td><strong>CARGO O ACTIVIDAD </strong><br>
                              <%f_padre.DibujaCampo("pers_tcargo")%></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="50%"><strong>REGI&Oacute;N</strong><br>
                              <%f_padre.DibujaCampo("regi_ccod_empresa")%>                          </td>
                          <td width="50%"><strong>CIUDAD O LOCALIDAD</strong><br>
                              <%f_padre.DibujaCampo("ciud_ccod_empresa")%></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td><strong>CALLE</strong><br> 
                                <%f_padre.DibujaCampo("dire_tcalle_empresa")%>
                              </td>
                              <td><strong>N&Uacute;MERO</strong><br> 
                                <%f_padre.DibujaCampo("dire_tnro_empresa")%>
                              </td>
							  <td> <b>CONJUNTO/CONDOMINIO</b><br> 
                                <%f_padre.DibujaCampo("dire_tpoblacion_empresa")%>
                              </td>
                              <td><strong>TEL&Eacute;FONO</strong><br> 
                                <%f_padre.DibujaCampo("dire_tfono_empresa")%>
                              </td>
                            </tr>
                          </table>
                      <%f_padre.DibujaCampo("post_ncorr")%><br>                      
                  
                        </td>
                  </tr>
                </table>
			  
			  	  
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("agregar")%>
                  </div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("cerrar")%>
                  </div></td>
                </tr>
              </table>
            </div></td>
            <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>

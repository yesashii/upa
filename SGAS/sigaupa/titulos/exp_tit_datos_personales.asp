<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.queryString
'	response.Write(k&" = "&request.querystring(k)&"<br>")
'next
saca_ncorr = Request.QueryString("saca_ncorr")
pers_ncorr = Request.QueryString("pers_ncorr")

'response.Write("q_plan_ccod "&q_plan_ccod&" q_peri_ccod "&q_peri_ccod&" rut "&q_pers_nrut&"-"&q_pers_xdv)

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Datos personales"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

q_plan_ccod = Request.QueryString("dp[0][plan_ccod]")
q_peri_ccod = Request.QueryString("dp[0][peri_ccod]")
q_pers_nrut = conexion.consultaUno("Select pers_nrut from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
q_pers_xdv  = conexion.consultaUno("Select pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "expediente_titulacion.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_titulado = new CFormulario
f_titulado.Carga_Parametros "expediente_titulacion.xml", "editar_dpersonales"
f_titulado.Inicializar conexion

SQL = " select a.pers_ncorr, a.pers_nrut, a.pers_xdv, a.pers_tape_paterno, a.pers_tape_materno, a.pers_tnombre, " & vbCrLf & _
	  " b.dire_tcalle, b.dire_tnro, b.dire_tpoblacion, b.ciud_ccod,rtrim(ltrim(cast(a.pers_nnota_ens_media as decimal(2,1)))) pers_nnota_ens_media," & vbCrLf & _
	  " a.pers_nano_egr_media, a.sexo_ccod, a.cole_ccod, " & vbCrLf & _
	  " c.ciud_ccod as ciud_ccod_colegio " & vbCrLf & _
	  " from " & vbCrLf & _
	  " personas a " & vbCrLf & _
	  " left outer join direcciones b " & vbCrLf & _
	  "    on a.pers_ncorr = b.pers_ncorr   and 1 = b.tdir_ccod  " & vbCrLf & _
	  " left outer join colegios c " & vbCrLf & _
	  "    on a.cole_ccod = c.cole_ccod " & vbCrLf & _
	  " where cast(a.pers_nrut as varchar)= '"&q_pers_nrut&"' "

f_titulado.Consultar SQL
f_titulado.SiguienteF
'response.Write("entre")

f_titulado.AgregaCampoCons "pers_nrut", q_pers_nrut
f_titulado.AgregaCampoCons "pers_xdv", q_pers_xdv

'---------------------------------------------------------------------------------------------------
set f_colegio_egreso = new CFormulario
f_colegio_egreso.Carga_Parametros "expediente_titulacion.xml", "colegio_egreso"
f_colegio_egreso.Inicializar conexion
f_colegio_egreso.Consultar SQL
f_colegio_egreso.Siguiente
f_colegio_egreso.AgregaCampoCons "x", "x"

'---------------------------------------------------------------------------------------------------
f_botonera.AgregaBotonUrlParam "siguiente", "pers_nrut", q_pers_nrut
f_botonera.AgregaBotonUrlParam "siguiente", "pers_xdv", q_pers_xdv
'---------------------------------------------------------------------------------------------------
'for each k in request.Form
'	response.Write("<br>" & k & " : " & request.Form(k))
'next

if not EsVacio(Request.Form) then
	f_titulado.AgregaCampoCons "pers_tape_paterno", Request.Form("dp[0][pers_tape_paterno]")	
	f_titulado.AgregaCampoCons "pers_tape_materno", Request.Form("dp[0][pers_tape_materno]")	
	f_titulado.AgregaCampoCons "pers_tnombre", Request.Form("dp[0][pers_tnombre]")
	f_titulado.AgregaCampoCons "sexo_ccod", Request.Form("dp[0][sexo_ccod]")
	f_titulado.AgregaCampoCons "dire_tcalle", Request.Form("dp[0][dire_tcalle]")
	f_titulado.AgregaCampoCons "dire_tnro", Request.Form("dp[0][dire_tnro]")
	f_titulado.AgregaCampoCons "dire_tpoblacion", Request.Form("dp[0][dire_tpoblacion]")
	f_titulado.AgregaCampoCons "ciud_ccod", Request.Form("dp[0][ciud_ccod]")
	f_titulado.AgregaCampoCons "pers_nnota_ens_media", Request.Form("dp[0][pers_nnota_ens_media]")
	f_titulado.AgregaCampoCons "pers_nano_egr_media", Request.Form("dp[0][pers_nano_egr_media]")	
	
	f_colegio_egreso.AgregaCampoCons "ciud_ccod_colegio", Request.Form("dp[0][ciud_ccod_colegio]")
	
	v_ciud_ccod_colegio = Request.Form("dp[0][ciud_ccod_colegio]")	
end if


f_colegio_egreso.AgregaCampoParam "cole_ccod", "filtro", " cast(ciud_ccod as varchar)='" & f_colegio_egreso.ObtenerValor("ciud_ccod_colegio") & "'"


'---------------------------------------------------------------------------------------------------
url_leng_0 = "exp_tit_mensajes.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_1 = "exp_tit_datos_personales.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_2 = "exp_tit_doctos_entregados.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_3 = "exp_tit_historico_notas.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_4 = "exp_tit_practica.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_5 = "exp_tit_egreso.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_6 = "exp_tit_salida.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_7 = "exp_tit_titulo.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_8 = "exp_tit_concentracion.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr

'---------------------------------------------------------------------------------------------------

carr_param = conexion.consultaUno("select carr_ccod from salidas_carrera where cast(saca_ncorr as varchar)='"&saca_ncorr&"'")
permiso_escuela = conexion.consultaUno("select isnull((select isnull(peca_dat_personal,'0') from permisos_evt_carrera where carr_ccod='"&carr_param&"'),'0')")

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

<script language="JavaScript">


var t_datos;
var o_pers_nrut;
var flag;





function ciud_ccod_colegio_change(p_objeto)
{
	var formulario = document.forms["edicion"];
	
	formulario.method = "post";
	formulario.submit();
}



function dBlur()
{
	flag = 1;
}


function InicioPagina()
{
	t_datos = new CTabla("dp");
	
	flag = 0;
}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="right" valign="top" bgcolor="#EAEAEA">	  <br>
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
            <td><%pagina.DibujarLenguetasFClaro Array(Array("Mensajes", url_leng_0), Array("Datos Pers.", url_leng_1), Array("Docs Alumno", url_leng_2),Array("Hist. Notas", url_leng_3), Array("Práctica prof.", url_leng_4), Array("Datos Egreso", url_leng_5),Array("Reg. Salida", url_leng_6), Array("Tesis y comisión", url_leng_7), Array("Conc. Notas", url_leng_8)), 2%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Datos personales"%>
                      <br>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td width="15%"><strong><font color="#FF0000">(*)</font>RUT</strong></td>
						  <td width="1%"><strong>:</strong></td>
						  <td width="35%" colspan="4"><%f_titulado.dibujaCampo("pers_nrut")%> - <%f_titulado.dibujaCampo("pers_xdv")%><%f_titulado.dibujaCampo("pers_ncorr")%>  </td>
						</tr>
						<tr>
                          <td width="15%"><strong><font color="#FF0000">(*)</font>Ap. Paterno</strong></td>
						  <td width="1%"><strong>:</strong></td>
						  <td width="35%"><%f_titulado.dibujaCampo("pers_tape_paterno")%></td>
						  <td width="15%"><strong><font color="#FF0000">(*)</font>Ap. Materno</strong></td>
						  <td width="1%"><strong>:</strong></td>
						  <td width="35%"><%f_titulado.dibujaCampo("pers_tape_materno")%></td>
						</tr>
						<tr>
                          <td width="15%"><strong><font color="#FF0000">(*)</font>Nombres</strong></td>
						  <td width="1%"><strong>:</strong></td>
						  <td width="35%"><%f_titulado.dibujaCampo("pers_tnombre")%></td>
						  <td width="15%"><strong>Sexo</strong></td>
						  <td width="1%"><strong>:</strong></td>
						  <td width="35%"><%f_titulado.dibujaCampo("sexo_ccod")%></td>
						</tr>
						<tr>
                          <td width="15%"><strong>Calle</strong></td>
						  <td width="1%"><strong>:</strong></td>
						  <td width="35%"><%f_titulado.dibujaCampo("dire_tcalle")%></td>
						  <td width="15%"><strong>N°</strong></td>
						  <td width="1%"><strong>:</strong></td>
						  <td width="35%"><%f_titulado.dibujaCampo("dire_tnro")%></td>
						</tr>
						<tr>
                          <td width="15%"><strong>Poblaci&oacute;n-Villa</strong></td>
						  <td width="1%"><strong>:</strong></td>
						  <td width="35%"><%f_titulado.dibujaCampo("dire_tpoblacion")%></td>
						  <td width="15%"><strong>Ciudad</strong></td>
						  <td width="1%"><strong>:</strong></td>
						  <td width="35%"><%f_titulado.dibujaCampo("ciud_ccod")%></td>
						</tr>
						<tr>
                          <td width="15%"><strong>Nota E.M.</strong></td>
						  <td width="1%"><strong>:</strong></td>
						  <td width="35%"><%f_titulado.dibujaCampo("pers_nnota_ens_media")%></td>
						      <td width="15%"><strong>A&ntilde;o Egreso E.M.</strong></td>
						  <td width="1%"><strong>:</strong></td>
						  <td width="35%"><%f_titulado.dibujaCampo("pers_nano_egr_media")%></td>
						</tr>
						<tr>
                          <td width="15%">&nbsp;</td>
						  <td width="1%">&nbsp;</td>
						  <td width="35%">&nbsp;</td>
						  <td width="15%" colspan="3"><strong><font color="#FF0000">(*)</font></strong>Campos Obligatorios</td>
						</tr>
                     </table></td>
                  </tr>
				  <tr>
                    <td>
                      <br>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><div align="center">
                                <%f_colegio_egreso.DibujaRegistro%>
                          </div></td>
                        </tr>
                      </table></td>
                  </tr>
				  <% if permiso_escuela = "0" then%>
				  <tr>
                    <td align="center"><font color="#8A0808">LA  ESCUELA NO POSEE PERMISOS DE INGRESO O EDICIÓN DE DATOS</font></td>
                  </tr>
				  <%end if%>
				  <tr>
                    <td>&nbsp;</td>
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
            <td width="23%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><% if permiso_escuela = "0" then
				                                f_botonera.AgregaBotonParam "guardar_dp" , "deshabilitado" , "true"
											 end if
				                             f_botonera.DibujaBoton "guardar_dp"%></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton "cerrar"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="77%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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


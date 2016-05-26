<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pare_ccod = Request("pare_ccod")

v_post_ncorr = Session("post_ncorr")
if EsVacio(v_post_ncorr) then
	Response.Redirect("inicio.asp")
end if

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Postulación - Apoderado Sostenedor"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "postulacion_5.xml", "botonera"


'---------------------------------------------------------------------------------------------------
set f_codeudor = new CFormulario
f_codeudor.Carga_Parametros "postulacion_5.xml", "codeudor"
f_codeudor.Inicializar conexion

if EsVacio(q_pare_ccod) then
	v_pare_ccod = conexion.ConsultaUno("select pare_ccod from codeudor_postulacion where post_ncorr = '" & v_post_ncorr & "'")
else
	v_pare_ccod = q_pare_ccod
end if

if EsVacio(v_pare_ccod) then
	v_pare_ccod="null"
	filtro ="1=2"
else
	filtro = "1=1"
end if


consulta =" select a.post_ncorr, '" & v_pare_ccod & "' as pare_ccod, b.pers_ncorr, " & vbCrLf &_
" (select c.pers_nrut from personas_postulante c where c.pers_ncorr= b.pers_ncorr ) as pers_nrut, " & vbCrLf &_
" (select c.pers_xdv from personas_postulante c where c.pers_ncorr= b.pers_ncorr ) as pers_xdv, " & vbCrLf &_
" (select c.pers_tnombre from personas_postulante c where c.pers_ncorr= b.pers_ncorr ) as pers_tnombre, " & vbCrLf &_
" (select c.pers_tape_paterno from personas_postulante c where c.pers_ncorr= b.pers_ncorr ) as pers_tape_paterno, " & vbCrLf &_
" (select c.pers_tape_materno from personas_postulante c where c.pers_ncorr= b.pers_ncorr ) as pers_tape_materno, " & vbCrLf &_
" (select c.pers_fnacimiento from personas_postulante c where c.pers_ncorr= b.pers_ncorr ) as pers_fnacimiento, " & vbCrLf &_
" (select c.ifam_ccod from personas_postulante c where c.pers_ncorr= b.pers_ncorr ) as ifam_ccod, " & vbCrLf &_
" (select c.alab_ccod from personas_postulante c where c.pers_ncorr= b.pers_ncorr ) as alab_ccod, " & vbCrLf &_
" (select c.nedu_ccod from personas_postulante c where c.pers_ncorr= b.pers_ncorr ) as nedu_ccod, " & vbCrLf &_
" (select c.pers_tprofesion from personas_postulante c where c.pers_ncorr= b.pers_ncorr ) as pers_tprofesion, " & vbCrLf &_
" (select c.pers_tempresa from personas_postulante c where c.pers_ncorr= b.pers_ncorr ) as pers_tempresa, " & vbCrLf &_
" (select c.pers_tcargo from personas_postulante c where c.pers_ncorr= b.pers_ncorr ) as pers_tcargo, " & vbCrLf &_
" (select d.dire_tcalle from direcciones_publica d where d.pers_ncorr = b.pers_ncorr and d.tdir_ccod = 1) as dire_tcalle, " & vbCrLf &_
" (select d.dire_tnro from direcciones_publica d where d.pers_ncorr = b.pers_ncorr and d.tdir_ccod = 1) as dire_tnro, " & vbCrLf &_
" (select d.dire_tpoblacion from direcciones_publica d where d.pers_ncorr = b.pers_ncorr and d.tdir_ccod = 1) as dire_tpoblacion, " & vbCrLf &_
" (select d.dire_tfono from direcciones_publica d where d.pers_ncorr = b.pers_ncorr and d.tdir_ccod = 1) as dire_tfono, " & vbCrLf &_
" (select d.ciud_ccod from direcciones_publica d where d.pers_ncorr = b.pers_ncorr and d.tdir_ccod = 1) as ciud_ccod, " & vbCrLf &_
" (select e.regi_ccod from direcciones_publica d, ciudades e where d.ciud_ccod = e.ciud_ccod and d.pers_ncorr = b.pers_ncorr and d.tdir_ccod = 1 ) as regi_ccod, " & vbCrLf &_
" (select f.dire_tcalle from direcciones_publica f where f.pers_ncorr = b.pers_ncorr and f.tdir_ccod = 3) as dire_tcalle_empresa, " & vbCrLf &_
" (select f.dire_tnro from direcciones_publica f where f.pers_ncorr = b.pers_ncorr and f.tdir_ccod = 3) as dire_tnro_empresa, " & vbCrLf &_
" (select f.dire_tpoblacion from direcciones_publica f where f.pers_ncorr = b.pers_ncorr and f.tdir_ccod = 3) as dire_tpoblacion_empresa, " & vbCrLf &_
" (select f.dire_tfono from direcciones_publica f where f.pers_ncorr = b.pers_ncorr and f.tdir_ccod = 3) as dire_tfono_empresa, " & vbCrLf &_
" (select f.ciud_ccod from direcciones_publica f where f.pers_ncorr = b.pers_ncorr and f.tdir_ccod = 3) as ciud_ccod_empresa, " & vbCrLf &_
" (select g.regi_ccod from direcciones_publica f, ciudades g where f.ciud_ccod = g.ciud_ccod and f.pers_ncorr = b.pers_ncorr and f.tdir_ccod = 3 ) as regi_ccod_empresa " & vbCrLf &_
" from postulantes a,  " & vbCrLf &_
"  ( select aa.post_ncorr, " & vbCrLf &_
"     case '" & v_pare_ccod & "' " & vbCrLf &_
"       when '4' then bb.pers_ncorr " & vbCrLf &_
"       when '0' then aa.pers_ncorr " & vbCrLf &_
"       else cc.pers_ncorr " & vbCrLf &_
"     end as pers_ncorr      " & vbCrLf &_
"   from " & vbCrLf &_
"   postulantes aa, codeudor_postulacion bb,grupo_familiar cc " & vbCrLf &_
"   where aa.post_ncorr *= bb.post_ncorr    " & vbCrLf &_
"   and aa.post_ncorr *= cc.post_ncorr        " & vbCrLf &_
"   and cc.pare_ccod = isnull(" & v_pare_ccod & ",cc.pare_ccod) " & vbCrLf &_
"   and aa.post_ncorr ='" & v_post_ncorr & "') b " & vbCrLf &_
" where a.post_ncorr = b.post_ncorr " & vbCrLf &_
" and a.post_ncorr =  '" & v_post_ncorr & "' and "&filtro&""

' "select a.post_ncorr, '" & v_pare_ccod & "' as pare_ccod, b.pers_ncorr, c.pers_nrut, c.pers_xdv, c.pers_tnombre, c.pers_tape_paterno, c.pers_tape_materno, c.pers_fnacimiento, c.ifam_ccod, c.alab_ccod, " & vbCrLf &_
'          "       d.dire_tcalle, d.dire_tnro, d.dire_tpoblacion, d.dire_tfono, d.ciud_ccod, e.regi_ccod, " & vbCrLf &_
'		   "	   c.nedu_ccod, c.pers_tprofesion, c.pers_tempresa, c.pers_tcargo, " & vbCrLf &_
'		   "	   f.dire_tcalle as dire_tcalle_empresa, f.dire_tnro as dire_tnro_empresa, f.dire_tpoblacion as dire_tpoblacion_empresa, f.dire_tfono as dire_tfono_empresa, f.ciud_ccod as ciud_ccod_empresa, g.regi_ccod as regi_ccod_empresa	" & vbCrLf &_
'		   "from postulantes a, " & vbCrLf &_
'		   "     (select a.post_ncorr, decode('" & v_pare_ccod & "', '4', b.pers_ncorr, '0', a.pers_ncorr, c.pers_ncorr) as pers_ncorr " & vbCrLf &_
'		   "	  from postulantes a, codeudor_postulacion b, grupo_familiar c " & vbCrLf &_
'		   "	  where a.post_ncorr = b.post_ncorr (+) " & vbCrLf &_
'		   "	    and a.post_ncorr = c.post_ncorr (+) " & vbCrLf &_
'		   "		and c.pare_ccod (+) = '" & v_pare_ccod & "' " & vbCrLf &_
'		   "		and a.post_ncorr = '" & v_post_ncorr & "') b, " & vbCrLf &_
'		   "	 personas_postulante c, " & vbCrLf &_
'		   "	 direcciones_publica d, ciudades e, " & vbCrLf &_
'		   "	 direcciones_publica f, ciudades g " & vbCrLf &_
'		   "where a.post_ncorr = b.post_ncorr (+) " & vbCrLf &_
'		   "  and b.pers_ncorr = c.pers_ncorr (+) " & vbCrLf &_
'		   "  and c.pers_ncorr = d.pers_ncorr (+) " & vbCrLf &_
'		   "  and d.ciud_ccod = e.ciud_ccod (+) " & vbCrLf &_
'		   "  and c.pers_ncorr = f.pers_ncorr (+) " & vbCrLf &_
'		   "  and f.ciud_ccod = g.ciud_ccod (+) " & vbCrLf &_
'		   "  and d.tdir_ccod (+) = 1 " & vbCrLf &_
'		   "  and f.tdir_ccod (+) = 3 " & vbCrLf &_
'		   "  and a.post_ncorr = '" & v_post_ncorr & "'"
  
' response.Write("<pre>"&consulta&"</pre>") 
  
  
f_codeudor.Consultar consulta
f_codeudor.Siguientef


'---------------------------------------------------------------------------------------------------
consulta_ciudades = "select regi_ccod, ciud_ccod, ciud_tdesc, ciud_tcomuna from ciudades order by ciud_tdesc asc"

'-------------------------------------------------------------------------------------
v_epos_ccod = conexion.ConsultaUno("select epos_ccod from postulantes where post_ncorr = '" & v_post_ncorr & "'")

if v_epos_ccod = "2" then
	lenguetas_postulacion = Array(Array("Información general", "postulacion_1.asp"), Array("Datos Personales", "postulacion_2.asp"), Array("Ant. Académicos", "postulacion_3.asp"), Array("Ant. Familiares", "postulacion_4.asp"), Array("Apoderado Sostenedor", "postulacion_5.asp"))
	msjRecordatorio = "Se ha detectado que esta postulación ya ha sido enviada.  Si va a realizar cambios en la información de esta página, presione el botón ""Siguiente"" para guardarlos."
else
	lenguetas_postulacion = Array("Información general", "Datos Personales", "Ant. Académicos", "Ant. Familiares", "Apoderado Sostenedor", "Envío de Postulación")
	msjRecordatorio = ""
end if

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
function Validar()
{
	formulario = document.edicion;
	
	rut_codeudor = formulario.elements["codeudor[0][pers_nrut]"].value + "-" + formulario.elements["codeudor[0][pers_xdv]"].value;	
	if (!valida_rut(rut_codeudor)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["codeudor[0][pers_xdv]"].focus();
		formulario.elements["codeudor[0][pers_xdv]"].select();
		return false;
	}
	

	return true;
}

function InicioPagina()
{
	_FiltrarCombobox(document.edicion.elements["codeudor[0][ciud_ccod]"], 
	                 document.edicion.elements["codeudor[0][regi_ccod]"].value,
					 d_ciudades,
					 'regi_ccod',
					 'ciud_ccod',
					 'ciud_tdesc',
					 '<%=f_codeudor.ObtenerValor("ciud_ccod")%>');
					 
					 
	_FiltrarCombobox(document.edicion.elements["codeudor[0][ciud_ccod_empresa]"], 
	                 document.edicion.elements["codeudor[0][regi_ccod_empresa]"].value,
					 d_ciudades,
					 'regi_ccod',
					 'ciud_ccod',
					 'ciud_tdesc',
					 '<%=f_codeudor.ObtenerValor("ciud_ccod_empresa")%>');			 
					
}
</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "codeudor[0][pers_fnacimiento]","1","edicion","fecha_oculta_codeudor"
	calendario.FinFuncion
%>

<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
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
            <td><%				
				pagina.DibujarLenguetas lenguetas_postulacion, 5
				%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTitulo "FICHA DE POSTULACION APODERADO SOSTENEDOR ECONOMICO"%>
              <br>
              <br>
              <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td><div align="justify"><%=msjRecordatorio%></div></td>
                </tr>
              </table>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Apoderado Sostenedor"%>                    
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr>
                        <td><%f_codeudor.DibujaCampo("pare_ccod")%></td>
                      </tr>
                    </table>
                    <br>
                    <br>                     
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="33%"><span class="style1">(*)</span> R.U.T.<br>
						  <%f_codeudor.DibujaCampo("pers_nrut")%>
      -
      <%f_codeudor.DibujaCampo("pers_xdv")%></td>
                          <td width="67%">FECHA DE NACIMIENTO <br>
                              <%f_codeudor.DibujaCampo("pers_fnacimiento")%>  <%calendario.DibujaImagen "fecha_oculta_codeudor","1","edicion" %></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><span class="style1">(*)</span> APELLIDO PATERNO <br>
                              <%f_codeudor.DibujaCampo("pers_tape_paterno")%></td>
                          <td><span class="style1">(*)</span> APELLIDO MATERNO <br>
                              <%f_codeudor.DibujaCampo("pers_tape_materno")%></td>
                          <td><span class="style1">(*)</span> NOMBRES<br>
                              <%f_codeudor.DibujaCampo("pers_tnombre")%></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="33%"><span class="style1">(*)</span> REGI&Oacute;N<br>
                              <%f_codeudor.DibujaCampo("regi_ccod")%>                          </td>
                          <td width="67%"><span class="style1">(*)</span> CIUDAD O LOCALIDAD DE PROCEDENCIA<br>
                              <%f_codeudor.DibujaCampo("ciud_ccod")%></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><span class="style1">(*)</span> CALLE<br>
                              <%f_codeudor.DibujaCampo("dire_tcalle")%></td>
                          <td><span class="style1">(*)</span> N&Uacute;MERO<br>
                              <%f_codeudor.DibujaCampo("dire_tnro")%></td>
                          <td>CONJUNTO/CONDOMINIO<br>
                              <%f_codeudor.DibujaCampo("dire_tpoblacion")%></td>
                          <td>TEL&Eacute;FONO<br>
                              <%f_codeudor.DibujaCampo("dire_tfono")%></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td>ESCOLARIDAD (&Uacute;LTIMO A&Ntilde;O CURSADO) <br>
                            <%f_codeudor.DibujaCampo("nedu_ccod")%></td>
                        </tr>
                      </table>
                      <br>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td>PROFESI&Oacute;N U OFICIO <br>
                              <%f_codeudor.DibujaCampo("pers_tprofesion")%></td>
                          <td>EMPRESA<br>
                              <%f_codeudor.DibujaCampo("pers_tempresa")%></td>
                          <td>CARGO O ACTIVIDAD <br>
                              <%f_codeudor.DibujaCampo("pers_tcargo")%></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="50%">REGI&Oacute;N<br>
                              <%f_codeudor.DibujaCampo("regi_ccod_empresa")%>
                          </td>
                          <td width="50%">CIUDAD O LOCALIDAD<br>
                              <%f_codeudor.DibujaCampo("ciud_ccod_empresa")%></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td>CALLE<br>
                              <%f_codeudor.DibujaCampo("dire_tcalle_empresa")%></td>
                          <td>N&Uacute;MERO<br>
                              <%f_codeudor.DibujaCampo("dire_tnro_empresa")%></td>
                          <td>CONJUNTO/CONDOMINIO<br>
                              <%f_codeudor.DibujaCampo("dire_tpoblacion_empresa")%></td>
                          <td>TEL&Eacute;FONO<br>
                              <%f_codeudor.DibujaCampo("dire_tfono_empresa")%></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td>ANTIGUEDAD LABORAL<br>
                            <%f_codeudor.DibujaCampo("alab_ccod")%> </td>
                          <td>RENTA PERCIBIDA<br>
                            <%f_codeudor.DibujaCampo("ifam_ccod")%> </td>
                        </tr>
                      </table>
                      <br>
                      <%f_codeudor.DibujaCampo("post_ncorr")%>                      <br>                      
                      <br>
                      </td>
                  </tr>
                </table>
                          <br>
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
                  <td><div align="center"><%f_botonera.DibujaBoton("anterior")%></div></td>				 
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("siguiente")%>
                  </div></td>				  
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir")%>
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

<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Cierre de Cajas"


set botonera = new CFormulario
botonera.carga_parametros "parametros.xml", "btn_cierre_cajas"


set negocio = new cnegocio
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"
formulario.carga_parametros "parametros.xml", "cierre_de_cajas"
formulario.inicializar conectar
negocio.inicializa conectar
sede=negocio.obtenerSede

v_usuario=negocio.ObtenerUsuario()
'response.Write("Usuario"&v_usuario)

sql_rol_mini_tesorero="select count(*) from personas a,sis_roles_usuarios c, sis_roles b "& vbcrlf &_
						"where a.pers_ncorr=c.pers_ncorr"& vbcrlf &_
						"and c.srol_ncorr=b.srol_ncorr"& vbcrlf &_
						"and c.srol_ncorr=87"& vbcrlf &_
						"and a.pers_nrut='"&v_usuario&"' "

v_pers_ncorr=conectar.ConsultaUno("select top 1 pers_ncorr from personas where pers_nrut="&v_usuario)

'response.Write("<br>Pers_ncorr : "&v_pers_ncorr)			 


Select Case v_pers_ncorr
	case "124445" 'BENAVIDES
		sede=4
	case "12008" 'ichamblas
		sede=1
	'case "103170" 'gjara
	'	sede=8
	'case "101130" ' folave abre en 2 cajas
	'	sede=sede
	'	v_pers_ncorr_filtro=" and c.pers_ncorr=101130 "
End Select

cajas_abiertas_cons = "select a.* from ( " & vbCrLf &_
						"select mcaj_ncorr,mcaj_ncorr as mcaj_ncorr_paso,mcaj_finicio,mcaj_ftermino,mcaj_mrendicion " & vbCrLf &_
						"        , pers_tnombre + ' ' + pers_tape_paterno as nombre " & vbCrLf &_
						"        , a.ecua_ccod, a.eren_ccod, d.tcaj_tdesc " & vbCrLf &_
						" from movimientos_cajas a,cajeros b,personas c,tipos_caja d" & vbCrLf &_
						" where a.caje_ccod = b.caje_ccod" & vbCrLf &_
						"    and a.sede_ccod = b.sede_ccod" & vbCrLf &_
						"    and b.pers_ncorr = c.pers_ncorr" & vbCrLf &_
						"    and a.tcaj_ccod = d.tcaj_ccod" & vbCrLf &_
						"    and a.eren_ccod not in (3,4,5,6)" & vbCrLf &_
						"    and a.tcaj_ccod not in (1002,1005) "&v_pers_ncorr_filtro&" " & vbCrLf &_
						"    and a.sede_ccod = '" & sede & "'" & vbCrLf &_
						"    ) a "& vbCrLf &_
						"  order by a.mcaj_ncorr desc "
'response.Write("<pre>"&cajas_abiertas_cons&"</pre>")
'response.End()				 

formulario.consultar cajas_abiertas_cons

%>


<html>
<head>
<title>Cierre de Cajas</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
<!--

function verificar_pendiente(objeto){
	formulario = objeto.form;
	ind = objeto.name.substr(6,1);
	pendiente = "cajas[" + ind + "][ecua_ccod]";
	tesorero = "cajas[" + ind + "][eren_ccod]";
	if ( (objeto.value == 3) && ((formulario.elements[pendiente].value == '') || (formulario.elements[pendiente].value == null)) ){
		alert('No puede tener estado de cuadre \"Pendiente\".');			
		formulario.elements[pendiente].focus();
		return(false);
	}
	else {
		return(true);
	}
}

function verificar_tesorero(objeto){
	formulario = objeto.form;
	ind = objeto.name.substr(6,1);
	tesorero = "cajas[" + ind + "][eren_ccod]";
	if ( (formulario.elements[tesorero].value == 3) && ((objeto.value == '') || (objeto.value == null)) ){
		alert('No puede tener estado de rendición \"OK Tesorero\".');		
		formulario.elements[tesorero].focus();
		return(false);
	}
	else {
		return(true);
	}
}

function guardar(formulario){
	valido = true;
	for (i = 0; i < <%=formulario.NroFilas%>; i++) {
		str_cuadre = "cajas[" + i + "][ecua_ccod]";
		str_rendicion = "cajas[" + i + "][eren_ccod]";		
		if ( (formulario.elements[str_cuadre].value == '') && (formulario.elements[str_rendicion].value==3) ) {			
			formulario.elements[str_cuadre].focus();			
			valido = false;
			break;
		}		
	}
	
	if (valido) {
			formulario.action="cierre_cajas_proc.asp"
			formulario.submit();
	} else {
		alert ('No puede tener estado de cuadre \"Pendiente\" y estado de rendición \"Ok Tesorero\".');
	}
}


function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

//-->

//-->//-->
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
        <form action="" method="post" name="editar">
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Cierre
                          de Cajas</font></div></td>
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
                  <td bgcolor="#D8D8DE">
				  <br>
                    <div align="center"><font size="+1">
                      <%pagina.DibujarTituloPagina()%> 
                      </font>
                    </div>
                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                    <td><strong><font color="000000" size="1"> </font></strong>
                      <table width="100%" border="0">
                        <tr> 
                          <td>&nbsp;</td>
                        </tr>
                        <tr> 
                          <td align="right"><strong><font color="000000" size="1"> 
                            <% formulario.pagina%></font></strong>
                            &nbsp;&nbsp;&nbsp;&nbsp; 
                            <% formulario.accesoPagina%>
                            </td>
                        </tr>
                        <tr> 
                          <td><strong><font color="000000" size="1"> 
                            <% formulario.dibujaTabla%>
                            </font></strong></td>
                        </tr>
                        <tr>
                          <td align="right"><%botonera.dibujaboton "guardar"%>
                          </td>
                        </tr>
                      </table>
                      <strong><font color="000000" size="1"> </font></strong></td>
                  </tr>
                </table>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="103" bgcolor="#D8D8DE"><table width="91%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="30%"><div align="center">
                        <%botonera.dibujaboton "salir"%>
                      </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="259" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td height="8" valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
			<p><br>
			<p><br>
		  </td>
        </tr>
      </table>	
   </form>
   </td>
  </tr>  
</table>
</body>
</html>

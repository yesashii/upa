<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set botonera = new CFormulario
botonera.carga_parametros "andres.xml", "btn_det_abono"

q_pers_nrut = Request.QueryString("pers_nrut")
q_pers_xdv = Request.QueryString("pers_xdv")


'------------------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new Cnegocio
negocio.Inicializa conexion


'-------------------------------------------------------------------------------------------------------------
set fc_persona = new CFormulario
fc_persona.Carga_Parametros "andres.xml", "consulta"
consulta = "SELECT pers_nrut || ' - ' || pers_xdv AS rut, pers_tape_paterno || ' ' || pers_tape_materno || ' ' || pers_tnombre AS nombre_completo " &_
           "FROM personas WHERE pers_nrut = '" & q_pers_nrut & "' AND pers_xdv = '" & q_pers_xdv & "'"
		   
fc_persona.Inicializar conexion
fc_persona.Consultar consulta
fc_persona.Siguiente



'------------------------------------------------------------------------------------------------------------
set f_notas_abono = new CFormulario
f_notas_abono.Carga_Parametros "det_nabono.xml", "f_notas_abono"
f_notas_abono.Inicializar conexion

consulta = "SELECT a.ingr_ncorr, a.ingr_fpago, a.ingr_nfolio_referencia, a.ting_ccod, a.ingr_mtotal, d.ting_tdesc" & vbCrLf &_
           "FROM ingresos a, notascreditos_documentos b, personas c, tipos_ingresos d " & vbCrLf &_
		   "WHERE a.ingr_ncorr = b.ingr_ncorr_notacredito AND " & vbCrLf &_
		   "	        a.pers_ncorr = c.pers_ncorr AND " & vbCrLf &_
		   "	        a.ting_ccod = d.ting_ccod AND " & vbCrLf &_
		   "			a.eing_ccod = 1 AND " & vbCrLf &_
		   "	        d.ting_brebaje = 'S' AND " & vbCrLf &_
		   "			a.ting_ccod not in (4,15) AND " & vbCrLf &_
		   "			c.pers_nrut = '" & q_pers_nrut & "' " & vbCrLf &_
		   "ORDER BY a.ingr_fpago"


consulta = "SELECT a.*, a.ingr_mtotal AS monto_nota,  nvl(b.ding_mdetalle,0) AS monto_utilizado, a.ingr_mtotal - nvl(b.ding_mdetalle,0) AS saldo_nota " & vbCrLf &_
           "FROM ( SELECT a.ingr_ncorr, a.ingr_fpago, a.ingr_nfolio_referencia, a.ting_ccod, a.inst_ccod, a.ingr_mtotal, d.ting_tdesc " & vbCrLf &_
		   "       FROM ingresos a, notascreditos_documentos b, personas c, tipos_ingresos d " & vbCrLf &_
		   "	   WHERE a.ingr_ncorr = b.ingr_ncorr_notacredito AND " & vbCrLf &_
		   "	         a.pers_ncorr = c.pers_ncorr AND " & vbCrLf &_
		   "			 a.ting_ccod = d.ting_ccod AND " & vbCrLf &_
		   "			 a.eing_ccod = 1 AND " & vbCrLf &_
		   "			 d.ting_brebaje = 'S' AND " & vbCrLf &_
		   "			 a.ting_ccod not in (4,15) AND " & vbCrLf &_
		   "			 c.pers_nrut = '" & q_pers_nrut & "' " & vbCrLf &_
		   "	   ORDER BY a.ingr_fpago ) a, " & vbCrLf &_
		   "	  (SELECT b.ding_ndocto, sum(b.ding_mdetalle) AS ding_mdetalle " & vbCrLf &_
		   "	   FROM ingresos a, detalle_ingresos b, personas c " & vbCrLf &_
		   "	   WHERE a.ingr_ncorr = b.ingr_ncorr AND " & vbCrLf &_
		   "	         a.pers_ncorr = c.pers_ncorr AND " & vbCrLf &_
		   "			 a.eing_ccod = 1 AND " & vbCrLf &_
		   "			 b.ting_ccod = 52 AND " & vbCrLf &_
		   "			 c.pers_nrut = '" & q_pers_nrut & "' " & vbCrLf &_
		   "	   GROUP BY b.ding_ndocto) b " & vbCrLf &_
		   "WHERE a.ingr_nfolio_referencia = b.ding_ndocto (+) " & vbCrLf &_
		   "ORDER BY a.ingr_fpago ASC, a.ingr_nfolio_referencia ASC"

'response.Write("<pre>"&consulta&"</pre>")
f_notas_abono.Consultar consulta


'----------------------------------------------------------------------------------------------------
set fc_resumen = new CFormulario
fc_resumen.Carga_Parametros "andres.xml", "consulta"
fc_resumen.Inicializar conexion

consulta = "SELECT sum(a.ingr_mtotal) AS m_total, sum(nvl(b.ding_mdetalle,0)) AS m_utilizado, sum(a.ingr_mtotal - nvl(b.ding_mdetalle,0)) AS m_saldo " & vbCrLf &_
           "FROM ( SELECT a.ingr_ncorr, a.ingr_fpago, a.ingr_nfolio_referencia, a.ting_ccod, a.inst_ccod, a.ingr_mtotal, d.ting_tdesc " & vbCrLf &_
		   "       FROM ingresos a, notascreditos_documentos b, personas c, tipos_ingresos d " & vbCrLf &_
		   "	   WHERE a.ingr_ncorr = b.ingr_ncorr_notacredito AND " & vbCrLf &_
		   "	         a.pers_ncorr = c.pers_ncorr AND " & vbCrLf &_
		   "			 a.ting_ccod = d.ting_ccod AND " & vbCrLf &_
		   "			 a.eing_ccod = 1 AND " & vbCrLf &_
		   "			 d.ting_brebaje = 'S' AND " & vbCrLf &_
		   "			 a.ting_ccod not in (4,15) AND " & vbCrLf &_
		   "			 c.pers_nrut = '" & q_pers_nrut & "' " & vbCrLf &_
		   "	   ORDER BY a.ingr_fpago ) a, " & vbCrLf &_
		   "	  (SELECT b.ding_ndocto, sum(b.ding_mdetalle) AS ding_mdetalle " & vbCrLf &_
		   "	   FROM ingresos a, detalle_ingresos b, personas c " & vbCrLf &_
		   "	   WHERE a.ingr_ncorr = b.ingr_ncorr AND " & vbCrLf &_
		   "	         a.pers_ncorr = c.pers_ncorr AND " & vbCrLf &_
		   "			 a.eing_ccod = 1 AND " & vbCrLf &_
		   "			 b.ting_ccod = 52 AND " & vbCrLf &_
		   "			 c.pers_nrut = '" & q_pers_nrut & "' " & vbCrLf &_
		   "	   GROUP BY b.ding_ndocto) b " & vbCrLf &_
		   "WHERE a.ingr_nfolio_referencia = b.ding_ndocto (+)"

'response.Write(consulta)
fc_resumen.Consultar consulta
fc_resumen.Siguiente

v_mtotal = fc_resumen.ObtenerValor("m_total")
v_mutilizado = fc_resumen.ObtenerValor("m_utilizado")
v_msaldo = fc_resumen.ObtenerValor("m_saldo")


%>


<html>
<head>
<title>Detalle de Notas de Abono</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
<!--



function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_nbGroup(event, grpName) { //v6.0
  var i,img,nbArr,args=MM_nbGroup.arguments;
  if (event == "init" && args.length > 2) {
    if ((img = MM_findObj(args[2])) != null && !img.MM_init) {
      img.MM_init = true; img.MM_up = args[3]; img.MM_dn = img.src;
      if ((nbArr = document[grpName]) == null) nbArr = document[grpName] = new Array();
      nbArr[nbArr.length] = img;
      for (i=4; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
        if (!img.MM_up) img.MM_up = img.src;
        img.src = img.MM_dn = args[i+1];
        nbArr[nbArr.length] = img;
    } }
  } else if (event == "over") {
    document.MM_nbOver = nbArr = new Array();
    for (i=1; i < args.length-1; i+=3) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = (img.MM_dn && args[i+2]) ? args[i+2] : ((args[i+1])? args[i+1] : img.MM_up);
      nbArr[nbArr.length] = img;
    }
  } else if (event == "out" ) {
    for (i=0; i < document.MM_nbOver.length; i++) {
      img = document.MM_nbOver[i]; img.src = (img.MM_dn) ? img.MM_dn : img.MM_up; }
  } else if (event == "down") {
    nbArr = document[grpName];
    if (nbArr)
      for (i=0; i < nbArr.length; i++) { img=nbArr[i]; img.src = img.MM_up; img.MM_dn = 0; }
    document[grpName] = nbArr = new Array();
    for (i=2; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = img.MM_dn = (args[i+1])? args[i+1] : img.MM_up;
      nbArr[nbArr.length] = img;
  } }
}
//-->
</script>

</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="705" border="0" cellpadding="0" cellspacing="0">
  <tr>
  </tr>
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
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                        <div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif"><font color="#FFFFFF" size="2">Recepci&oacute;n
                        de Ingresos</font><b></b></font></div></td>
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
				    &nbsp;
				  <table width="95%" align="center" cellpadding="0" cellspacing="0">
                      <tr> 
                        <form name="edicion" method="post">
                          <td align="left"> <table width="50%" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td nowrap><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Rut: 
                                  <strong>
                                  <%fc_persona.DibujaCampo("rut")%>
                                  </strong> </font></td>
                              </tr>
                              <tr> 
                                <td> <font size="1" face="Verdana, Arial, Helvetica, sans-serif">Nombre:</font><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif"><strong> 
                                  <%fc_persona.DibujaCampo("nombre_completo")%>
                                  </strong></font> </strong> </td>
                            </table>
                            <br> <br> <table width="97%" align="center" cellpadding="0" cellspacing="0">
                              <tr> 
                                <td></td>
                              </tr>
                              <tr> 
                                <td height="13" align="center"><strong>NOTAS DE 
                                  CREDITO CON ABONO</strong></td>
                              </tr>
                              <tr> 
                                <td align="center"><%f_notas_abono.DibujaTabla()%> <table width="100%" align="center" cellpadding="0" cellspacing="0">
                                    <tr> 
                                      <td><div align="center"><strong>TOTAL :</strong></div></td>
                                      <td width="15%"> <div align="right"><b>$ 
                                          <%=v_mtotal%></b></div></td>
                                      <td width="15%"><div align="right"><b>$ 
                                          <%=v_mutilizado%></b></div></td>
                                      <td width="15%"><div align="right"><b>$ 
                                          <%=v_msaldo%></b></div></td>
                                    </tr>
                                  </table></td>
                              </tr>
                              <tr> 
                                <td align="center">&nbsp; </td>
                              </tr>
                            </table>
                          </td>
                        </form>
                      </tr>
                    </table>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="105" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center">
                        <%botonera.dibujaboton "salir"%>
                      </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="257" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
			<p><br>
			<p><br>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>

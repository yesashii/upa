<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set botonera = new CFormulario
botonera.carga_parametros "paulo.xml", "btn_rev_ctacte"

rut=request.querystring("rut")
dv=request.querystring("dv")
inst=request.QueryString("ins[0][insti]")
set conectar = new cconexion
set formulario = new cformulario
set negocio= new cnegocio
set persona = new cformulario
set formu = new cformulario
set insti	=	new cFormulario

conectar.inicializar "desauas"
 
'sede = 1

'usuario = 14492361
negocio.inicializa conectar
sede       = negocio.obtenersede

formulario.carga_parametros "paulo.xml", "cuenta_corriente"
insti.carga_parametros "paulo.xml", "institucion"
persona.carga_parametros "paulo.xml","persona"

persona.inicializar conectar
formulario.inicializar conectar
insti.inicializar conectar

institucion="select '' as institucion from dual"
	
if (trim(inst)) <> "" then
	inst_razon_cons="select inst_trazon_social from instituciones where inst_ccod=" & inst
	inst_razon = conectar.consultaUno(inst_razon_cons)
end if 


personas = "select " & _
        "pers_ncorr as c, pers_nrut || '-' || pers_xdv  as rut " & _
		" , pers_tape_paterno || ' ' ||   PERS_TAPE_MATERNO || ' ' || pers_tnombre as nombre  " & _
	   " from personas" & _
	   " where pers_nrut='" & rut & "' " & _
       " and pers_xdv='" & dv & "'  "


tabla="SELECT a.tcom_ccod, a.inst_ccod, a.comp_ndocto,b.dcom_ncompromiso as ncompromiso, b.dcom_ncompromiso, a.ecom_ccod as ecom_ccod, " & _
"      (b.dcom_mcompromiso - NVL(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0)) AS dcom_mcompromiso_oculto, " & _
"       nvl(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0) AS abono, b.dcom_fcompromiso , " & _
"       b.dcom_mcompromiso, a.comp_ndocto AS nro, " & _
"       d.tcom_tdesc AS concepto, d.tcom_tdesc,a.inst_ccod as institucion, " & _
"       (b.dcom_mcompromiso - NVL(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0)) AS saldo " & _
"  FROM compromisos a, " & _
"       detalle_compromisos b, " & _
"       (select b.tcom_ccod,b.inst_ccod,b.comp_ndocto,b.dcom_ncompromiso,b.abon_mabono,a.ting_ccod, d.ting_brebaje  " & _
"        from ingresos a, abonos b, personas p, tipos_ingresos d  " & _       
"        where a.ingr_ncorr = b.ingr_ncorr and a.ting_ccod = d.ting_ccod  " & _
"          AND a.eing_ccod = 1 " & _
"          AND b.pers_ncorr = p.pers_ncorr " & _
"          AND p.pers_nrut = '"& rut &"' " & _
"          and b.inst_ccod = '"& inst & "') c, " & _ 
"       tipos_compromisos d, " & _
"      personas e " & _
" WHERE a.tcom_ccod = b.tcom_ccod " & _
"   AND a.inst_ccod = b.inst_ccod " & _
"   AND a.comp_ndocto = b.comp_ndocto " & _
"   AND b.tcom_ccod = c.tcom_ccod (+) " & _
"   AND b.inst_ccod = c.inst_ccod (+) " & _
"   AND b.comp_ndocto = c.comp_ndocto (+) " & _
"   AND b.dcom_ncompromiso = c.dcom_ncompromiso (+) " & _
"   AND b.tcom_ccod = d.tcom_ccod  " & _
"	and B.ecom_ccod not in (2,3) " & _ 
"	and a.ecom_ccod not in (2,3) " & _ 
"   AND a.pers_ncorr = e.pers_ncorr " & _
"   AND e.pers_nrut = '"& rut &"' " & _
"   AND a.inst_ccod = '"& inst &"' " & _
 " GROUP BY a.tcom_ccod, " & _
 "         a.inst_ccod, " & _
 "         a.comp_ndocto, " & _
 "         b.dcom_ncompromiso, " & _
 "         b.dcom_fcompromiso, " & _
 "         b.dcom_mcompromiso, " & _
 "         d.tcom_tdesc, a.ecom_ccod " & _
 " ORDER BY a.comp_ndocto, b.dcom_fcompromiso,nro"
 

totales="select * from ( " & _
"    sum(c.abon_mabono) as abono, " & _
"    sum(b.dcom_mcompromiso - c.abon_mabono) as saldo_total, " & _
"    sum(b.dcom_mcompromiso) as deuda " & _
"from " & _
"    compromisos a,detalle_compromisos b,abonos c, tipos_compromisos d,personas e " & _
"where " & _
"    a.tcom_ccod         =   b.tcom_ccod " & _
"    and a.inst_ccod     =   b.inst_ccod " & _
"    and a.comp_ndocto   =   b.comp_ndocto " & _
"    and b.tcom_ccod     =   c.tcom_ccod(+) " & _
"    and b.inst_ccod     =   c.inst_ccod(+) " & _
"    and b.comp_ndocto   =   c.comp_ndocto(+) " & _
"    and b.dcom_ncompromiso = c.dcom_ncompromiso (+) " & _
"    and c.tcom_ccod         = d.tcom_ccod " & _
"    and a.pers_ncorr        = e.pers_ncorr  " & _
"    and e.pers_nrut        = '"& rut &"'  " & _
"    ) a "

persona.consultar personas	 
formulario.consultar tabla

insti.consultar institucion

resumenes= "SELECT SUM (ABONO) AS TOTAL_ABONOS, SUM(SALDO) AS TOTAL_SALDO, SUM(COMPROMISO) AS TOTAL_COMPROMISOS FROM   " & _
"( " & _
"SELECT a.tcom_ccod, a.inst_ccod, a.comp_ndocto,b.dcom_ncompromiso as ncompromiso, b.dcom_ncompromiso, a.ecom_ccod as ecom_ccod, " & _
"      (b.dcom_mcompromiso - NVL(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0)) AS dcom_mcompromiso_oculto, " & _
"       nvl(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0) AS abono, b.dcom_fcompromiso , b.dcom_mcompromiso as compromiso, " & _
"       b.dcom_mcompromiso, a.comp_ndocto AS nro, " & _
"       d.tcom_tdesc AS concepto, d.tcom_tdesc,a.inst_ccod as institucion, " & _
"       (b.dcom_mcompromiso - NVL(SUM (decode(c.ting_brebaje, 'S',-c.abon_mabono,c.abon_mabono)),0)) AS saldo " & _
"  FROM compromisos a, " & _
"       detalle_compromisos b, " & _
"       (select b.tcom_ccod,b.inst_ccod,b.comp_ndocto,b.dcom_ncompromiso,b.abon_mabono,a.ting_ccod, d.ting_brebaje  " & _
"        from ingresos a, abonos b, personas p, tipos_ingresos d  " & _       
"        where a.ingr_ncorr = b.ingr_ncorr and a.ting_ccod = d.ting_ccod  " & _
"          AND a.eing_ccod = 1 " & _
"          AND b.pers_ncorr = p.pers_ncorr " & _
"          AND p.pers_nrut = '"& rut &"' " & _
"          and b.inst_ccod = '"& inst & "') c, " & _ 
"       tipos_compromisos d, " & _
"      personas e " & _
" WHERE a.tcom_ccod = b.tcom_ccod " & _
"   AND a.inst_ccod = b.inst_ccod " & _
"   AND a.comp_ndocto = b.comp_ndocto " & _
"   AND b.tcom_ccod = c.tcom_ccod (+) " & _
"   AND b.inst_ccod = c.inst_ccod (+) " & _
"   AND b.comp_ndocto = c.comp_ndocto (+) " & _
"   AND b.dcom_ncompromiso = c.dcom_ncompromiso (+) " & _
"   AND b.tcom_ccod = d.tcom_ccod  " & _
"	and B.ecom_ccod not in (2,3) " & _ 
"	and a.ecom_ccod not in (2,3) " & _ 
"   AND a.pers_ncorr = e.pers_ncorr " & _
"   AND e.pers_nrut = '"& rut &"' " & _
"   AND a.inst_ccod = '"& inst &"' " & _
 " GROUP BY a.tcom_ccod, " & _
 "         a.inst_ccod, " & _
 "         a.comp_ndocto, " & _
 "         b.dcom_ncompromiso, " & _
 "         b.dcom_fcompromiso, " & _
 "         b.dcom_mcompromiso, " & _
 "         d.tcom_tdesc, a.ecom_ccod " & _
 " ORDER BY b.dcom_fcompromiso,nro" & _
"  )"

set finales = new cformulario
finales.carga_parametros "paulo.xml", "totales"
finales.inicializar conectar 
finales.consultar resumenes



persona.siguiente
insti.siguiente

%>


<html>
<head>
<title>T&iacute;tulo</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
<!--

function verifica_check(formulario) {
	num=formulario.elements.length;
	c=0;
	for (i=0;i<num;i++){
		nombre = formulario.elements[i].name;
		var elem = new RegExp ("dcom_ncompromiso","gi");
		if (elem.test(nombre)){
			if((formulario.elements[i].checked==true)){
				return (true);
			}
			else {
				return (false);
			}
		}

			
	}
	}
	/*if (c>0) {
		return (true);
	}
	else {
		return (false);
	}*/


function enviar(formulario){
		if(!(valida_rut(formulario.rut.value + '-' + formulario.dv.value))){
		    alert('ERROR.\nEl RUT que Ud. ha ingresado no es válido.Por favor, ingréselo nuevamente.');
			formulario.rut.focus();
			formulario.rut.select();
		 }
		else{
			formulario.action = 'rev_ctacte.asp';
			formulario.submit();
		}
}


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
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
                    <td width="5"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="226" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="center"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador
                          de Alumnos</font></div></td>
                    <td width="10" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="433" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
				<form name="buscador" method="get" action="">
                  <table width="98%"  border="0">
                    <tr>
                      <td width="81%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr> 
                                  <td width="63%" align="center" nowrap> 
                                    <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut&nbsp; 
                                      <input type="text" name="rut" size="10" maxlength="8" id="NU-N" value="<%=rut%>">
                                      - 
                                      <input type="text" name="dv" size="2" maxlength="1" id="LE-N" 			onKeyUp="this.value=this.value.toUpperCase();" value="<%=dv%>">
                                      <a href="javascript:buscar_persona();"><img src="../imagenes/lupa_f2.gif" width="15" height="15" border="0"></a> 
                                      </font></div>
                                    <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                      </font></div></td>
                                  <td width="37%" align="center" nowrap><%=insti.dibujaCampo("insti")%></td>
                                </tr>
                              </table></td>
                      <td width="19%"><div align="center">
                        <%botonera.dibujaboton "buscar"%>
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Analizar
                          Cuenta Corriente</font></div></td>
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
				     <form name="edicion" method="post">
		            <table width="95%" align="center" cellpadding="0" cellspacing="0">
                        <tr> 
                          <td align="left"> <%if rut <>"" and dv <> "" then %> 
                            <table width="50%" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td>Resultado de la B&uacute;squeda</td>
                              </tr>
                              <tr> 
                                <td nowrap><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Rut: 
                                  <strong><%=persona.dibujaCampo("rut")%></strong> Nombre:<strong> <%=persona.dibujaCampo("nombre")%></strong></font></td>
                              </tr>
                              <tr>
                                <td nowrap>Instituci&oacute;n <font size="1" face="Verdana, Arial, Helvetica, sans-serif"><strong><%=inst_razon%></strong></font></td>
                              </tr>
                            </table>
                            <%else
					  response.Write(texto)
					  end if%> <br>
<br><TABLE width="96%" align="center" cellpadding="0"cellspacing="0">
                              <TR>
                                <TD colspan="3" align="center" nowrap  ><strong>RESUMEN
                                CUENTA CORRIENTE</strong></TD>
                              </TR>
                              <TR>
                                  <TD colspan="3" align="center" nowrap  >&nbsp;</TD>
                            </TR>
							  <TR>
                                  <TD align="center">
<%finales.dibujatabla()%>
                                  </TD>
                            </TR>
							  </TABLE>
<br> 
                            <table width="10%" align="right" cellpadding="0" cellspacing="0">

                            </table>
                            <input type="hidden" name="nombre" value="<%=persona.dibujaCampo("nombre")%>"> 
                            <input type="hidden" name="rut" value="<%=persona.dibujaCampo("rut")%>"> 
                            <br> <br> <table width="97%" align="center" cellpadding="0" cellspacing="0">
                              <tr> 
                                <td></td>
                              </tr>
                              <tr> 
                                <td height="13" align="center"><strong>CUENTA 
                                  CORRIENTE </strong></td>
                              </tr>
                              <tr> 
                                <td align="right"><strong>P&aacute;ginas&nbsp;:&nbsp;</strong>&nbsp; 
                                  <%formulario.accesoPagina%>
                                </td>
                              </tr>
                              <tr> 
                                <td align="center"> <% if rut<>"" and dv <> "" then
										formulario.dibujaTabla()
									%> </td>
                              </tr>
                              <tr> 
                                <td align="center"> 
                                  <%else%>
								  <table width="100%" border="1" align="center" cellpadding=0 cellspacing=0 bordercolor="#FFFFFF" bgcolor="#6581AB">
                                    <tr align="center"> 
                                      <td><font color="#FFFFFF">&nbsp;</font></td>
                                      <td><font color="#FFFFFF"><strong>Nro. Cuota</strong></font></td>
                                      <td><font color="#FFFFFF"><strong>Concepto</strong></font></td>
                                      <td><font color="#FFFFFF"><strong> Vencimiento</strong></font></td>
                                      <td><font color="#FFFFFF"><strong>Monto</strong></font></td>
                                      <td><font color="#FFFFFF"><strong>Pago</strong></font></td>
                                      <td><font color="#FFFFFF"><strong>Saldo</strong></font></td>
                                    </tr>
                                    <tr align="center" bgcolor="#AEC7E3"> 
                                      <td colspan="7" bordercolor="#FFFFFF">Debe 
                                        ingresar el rut de la persona que desea 
                                        consultar</td>
                                    </tr>
                                  </table>
                                  <%end if%> </td>
                              </tr>
                            </table>
                            <br></td>
                        </tr>
                      </table>
					</form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="99" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="45%"><div align="center">
                        <%botonera.dibujaboton "salir"%>
                      </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="263" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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

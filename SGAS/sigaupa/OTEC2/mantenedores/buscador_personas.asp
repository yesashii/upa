<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set botonera = new CFormulario
botonera.carga_parametros "buscador_personas.xml", "btn_buscador_personas"

 paterno= request.QueryString("ap_pat")
 materno= request.QueryString("ap_mat")
 nombre= request.QueryString("nombre")
 
 campo_rut = Request.QueryString("campo_rut")
 campo_dv = Request.QueryString("campo_dv") 

 set conectar = new cConexion
 set formulario = new cFormulario
 set negocio= new cnegocio
 
 conectar.inicializar "upacifico"
 
 negocio.inicializa conectar
 sede_ccod = negocio.obtenersede
 
 formulario.carga_parametros "buscador_personas.xml", "list_alumnos"
 formulario.inicializar conectar

 
 consulta = "select distinct a.pers_ncorr, cast(a.pers_nrut as varchar) as pers_nrut,''''+a.pers_xdv+'''' as pers_xdv, cast(a.pers_nrut as varchar)+'-'+a.pers_xdv as rut,  " &_
            "a.PERS_TAPE_PATERNO+' '+a.PERS_TAPE_MATERNO+' '+a.PERS_TNOMBRE as nombre  " &_ 
            "from personas a  "
			if paterno <> "" or materno <> "" or nombre <> "" then
              consulta=consulta & " where 1=1"
			else
			  consulta=consulta & " where 1=2"
			end if  
			
 if paterno <>"" then
 	consulta=consulta& " and protic.extrae_acentos(rtrim(ltrim(pers_tape_paterno))) like protic.extrae_acentos('%"&paterno&"%')"
 end if
  if materno <>"" then
 	consulta=consulta& " and protic.extrae_acentos(rtrim(ltrim(pers_tape_materno)))like protic.extrae_acentos('%"&materno&"%')"
 end if
  if nombre <>"" then
 	consulta=consulta& " and protic.extrae_acentos(rtrim(ltrim(pers_tnombre))) like protic.extrae_acentos('%"&nombre&"%')"
 end if
consulta=consulta &	" order by nombre "
'response.Write("<pre>"&consulta&"</pre>")
formulario.consultar consulta	

if formulario.nroFilas() = 0 then
consulta = "select distinct a.pers_ncorr, cast(a.pers_nrut as varchar) as pers_nrut,''''+a.pers_xdv+'''' as pers_xdv, cast(a.pers_nrut as varchar)+'-'+a.pers_xdv as rut,  " &_
            "a.PERS_TAPE_PATERNO+' '+a.PERS_TAPE_MATERNO+' '+a.PERS_TNOMBRE as nombre  " &_ 
            "from personas_postulante a  "
			if paterno <> "" or materno <> "" or nombre <> "" then
              consulta=consulta & " where 1=1"
			else
			  consulta=consulta & " where 1=2"
			end if  
			
 if paterno <>"" then
 	consulta=consulta& " and protic.extrae_acentos(rtrim(ltrim(pers_tape_paterno))) like protic.extrae_acentos('%"&paterno&"%')"
 end if
  if materno <>"" then
 	consulta=consulta& " and protic.extrae_acentos( rtrim(ltrim(pers_tape_materno))) like protic.extrae_acentos('%"&materno&"%')"
 end if
  if nombre <>"" then
 	consulta=consulta& " and protic.extrae_acentos(rtrim(ltrim(pers_tnombre))) like protic.extrae_acentos('%"&nombre&"%')"
 end if
consulta=consulta &	" order by nombre "

'response.Write("<pre>"&consulta&"</pre>")
formulario.consultar consulta
end if	 
formulario.agregacampocons "v_rut","<a href=""javascript:cerrar(%pers_nrut%,%pers_xdv%)"">%rut%</a>"
formulario.agregacampocons "v_nombre","<a href=""javascript:cerrar(%pers_nrut%,%pers_xdv%)"">%nombre%</a>"
%>


<html>
<head>
<title>Busca Personas</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript" type="text/JavaScript">
<!--
function enviar(formulario){
	formulario.action = 'buscador_personas.asp';
	formulario.submit();
 }

function cerrar(nrut,ndv)
{

if ('<%=campo_rut%>' == 'undefined') {

	num=opener.document.forms[0].elements.length;
	c=0;
	for (i=0;i<num;i++){
		nombre = opener.document.forms[0].elements[i].name;
		var elem = new RegExp("rut","gi");
		if (elem.test(nombre)){
			opener.document.forms[0].elements[i].value=nrut;		
			}
	   var elem2 = new RegExp("dv","gi");
		if (elem2.test(nombre)){
		   opener.document.forms[0].elements[i].value=ndv;		
		   opener.document.forms[0].elements[i].focus();		
			}
		}
	}
else {
	opener.document.forms[0].elements["<%=campo_rut%>"].value = nrut;
	opener.document.forms[0].elements["<%=campo_dv%>"].value = ndv;
}

window.close();
}

function mensaje(form){
<%if session("ses_error_busca") <> "" then %>
alert('<%=session("ses_error_busca")%>');
<%session("ses_error_busca") = ""
end if %>
form.ap_pat.focus();
}
//-->

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
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../jefe_carrera/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<div align="left"></div>
<table width="750" border="0" cellpadding="0" cellspacing="0">
  <tr>
  </tr>
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<table width="75%" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="99%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="541" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="12" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="208" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font size="1" face="Verdana, Arial, Helvetica, sans-serif"><font color="#FFFFFF">Buscador
                        De Personas</font></font></div></td>
                      <td width="326" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="540" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="99%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				    &nbsp;
				    <table width="100%" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
                      <tr bordercolor="FFFFFF" bgcolor="#F1F1E4">
                        <TD bordercolor="FFFFFF" bgcolor="#D8D8DE"><form name="buscador" method="get" action="">
                            <table width="70%" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
                              <tr>
                                <td width="28%" height="20">
                                  <div align="left"><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Apellido
                                        Paterno</font></strong></div>
                                </td>
                                <td colspan="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif">
                                  <input name="ap_pat" type="text" id="ap_pat6" size="30" maxlength="30" value="<%=paterno%>" onKeyUp="this.value=this.value.toUpperCase();">
                                </font></td>
                              </tr>
                              <tr>
                                <td align="right"><div align="left"><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Apellido
                                        Materno</font></strong> </div>
                                </td>
                                <td colspan="2" align="right"><div align="left"><font size="1" face="Verdana, Arial, Helvetica, sans-serif">
                                    <input name="ap_mat" type="text" id="ap_mat6" size="30" maxlength="30" value="<%=materno%>" onKeyUp="this.value=this.value.toUpperCase();">
                                  </font></div>
                                </td>
                              </tr>
                              <tr>
                                <td align="center">
                                  <div align="left"><strong><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Nombres</font></strong></div>
                                </td>
                                <td colspan="2" align="center"><div align="left"><font size="1" face="Verdana, Arial, Helvetica, sans-serif">
                                    <input name="nombre" type="text" id="nombre" size="30" maxlength="30" value="<%=nombre%>" onKeyUp="this.value=this.value.toUpperCase();">
                                  </font></div>
                                </td>
                              </tr>
                              <tr>
                                <td align="center">&nbsp;</td>
                                <td width="50%" align="center">&nbsp;</td>
                                <td width="22%" align="center"><%botonera.dibujaboton "aceptar"%></td>
                              </tr>
                            </table>
							<input type="hidden" name="campo_rut" value="<%=campo_rut%>">
							<input type="hidden" name="campo_dv" value="<%=campo_dv%>">
                          </form>
                            <form name="editar" method="post" action="">
                              <table width="95%" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
                                <tr>
                                  <td height="20">
                                    <div align="center"><strong><font face="Verdana, Arial, Helvetica, sans-serif">RESULTADO
                                          DE LA B&Uacute;SQUEDA</font></strong></div>
                                  </td>
                                </tr>
                                <tr>
                                  <td align="right">P&aacute;gina:
                                      <%formulario.accesopagina%>
                                  </td>
                                </tr>
                                <tr>
                                  <td align="center">
                                    <%formulario.dibujaTabla()%>
                                  </td>
                                </tr>
                                <tr>
                                  <td align="center">&nbsp;</td>
                                </tr>
                              </table>
                            </form>
                        </TD>
                      </tr>
                    </table>
			      <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="99%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="237" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center"></div></td>
                      <td><div align="center"></div></td>
                      <td><div align="center">
                        <%botonera.dibujaboton "salir"%>
                      </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="33" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="407" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
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

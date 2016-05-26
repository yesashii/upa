<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

'---------------------------------------------------------------------------------------------------
correlativo    = session("ses_corr_persona")
 rut_persona    = session("ses_rut_post") 
 dv_persona     = session("ses_dv_post")  
'response.Write("Correlativo: "&correlativo&" ->rut persona:"&rut_persona&" ->dv_persona:"&dv_persona&"<br>")
 if correlativo = "" then
   response.Redirect("denegado.asp")
 end if
 
 set conectar = new cconexion
 conectar.inicializar "upacifico"
 
 ' Consulta para verificar si el alumno existe y es extranjero
 cons = conectar.consultaUno("select pais_ccod from personas_postulante where pers_ncorr=" & correlativo )
 if isNull(cons) then ' no existe el alumno
    hab = "F"
 else
    if trim(cons) = "1" then ' Es chileno
	   hab = "F"
	else
	   hab = "T"   
	end if
 end if

 cons1 = " select  a.pers_ncorr,a.pers_nrut, a.pers_xdv, a.pers_tape_paterno, " _
	   & " a.pers_tape_materno, a.pers_tnombre,a.pers_temail, " _
	   & " a.pers_tfono,a.pais_ccod,a.pers_tpasaporte, pers_femision_pas, " _
	   & " a.pers_fvencimiento_pas,tvis_ccod, a.pers_ftermino_visa,b.usua_tpregunta, " _
	   & " b.usua_trespuesta, b.usua_tusuario, b.usua_tclave " _
	   & " from personas_postulante a, usuarios b " _
	   & " where a.pers_ncorr = "& correlativo &" " _
	   & " and a.pers_ncorr *= b.pers_ncorr "
 ' response.Write("<br>"&cons1&"<br>")
 '--------------------------------------------------------------------------------
 v_pers_ncorr = conectar.ConsultaUno(cons1)
 if EsVacio(v_pers_ncorr) then
 	cons1 = " select  a.pers_ncorr,a.pers_nrut, a.pers_xdv, a.pers_tape_paterno, " _
	   & " a.pers_tape_materno, a.pers_tnombre,a.pers_temail, " _
	   & " a.pers_tfono,a.pais_ccod,a.pers_tpasaporte, pers_femision_pas, " _
	   & " a.pers_fvencimiento_pas,tvis_ccod, a.pers_ftermino_visa,b.usua_tpregunta, " _
	   & " b.usua_trespuesta, b.usua_tusuario, b.usua_tclave " _
	   & " from personas a, usuarios b " _
	   & " where a.pers_ncorr = "& correlativo &" " _
	   & " and a.pers_ncorr *= b.pers_ncorr "
 end if
 'response.Write("<br>"&cons1&"<br>")
 '---------------------------------------------------------------------------------
 
 set formulario  = new cformulario
 
 formulario.carga_parametros "registrarse.xml", "edicion_ficha_postulante" 
 formulario.inicializar conectar
 
 formulario.consultar cons1 
 formulario.agregaCampoFilaCons 0 ,"pers_ncorr", correlativo
 formulario.agregaCampoFilaCons 0 ,"pers_nrut", rut_persona
 formulario.agregaCampoFilaCons 0 ,"pers_xdv", dv_persona
 if hab = "F" then
   formulario.agregaCampoParam "pers_tpasaporte", "script", " disabled "
   formulario.agregaCampoParam "pers_femision_pas", "script", " disabled "
   formulario.agregaCampoParam "pers_fvencimiento_pas", "script", " disabled "
   formulario.agregaCampoParam "tvis_ccod", "script", " disabled " 
   formulario.agregaCampoParam "pers_ftermino_visa", "script", " disabled "
 else
   formulario.agregaCampoParam "pais_ccod", "destino", "(select * from paises where pais_ccod <> 1)a"  
 end if

 '==========================================================
 ' Textos para los alumos extranjeros
 if session("ses_extranjero") = "V" then
    formulario.agregaCampoParam "pais_ccod", "destino", "(select * from paises where pais_ccod <> 1)a"  
    titulo_ext = "PARA ALUMNOS EXTRANJEROS"
	rut_ext    = "Este <b>RUT</b> ha sido creado por el sistema; por lo tanto, recuérdelo para seguir con su proceso de postulación."
    apellido_1 = "Primer Apellido"
	apellido_2 = "Segundo Apellido"
 else
    apellido_1 = "Apellido Paterno"
	apellido_2 = "Apellido Materno"
 end if
 
  formulario.siguienteF

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "registrarse.xml", "botonera"

%>


<html>
<head>
<title>Ficha de creaci&oacute;n de claves</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>
<script language="JavaScript">
function enviar(form){
  if( preValidaFormulario(form)){
		var pais = MM_findObj('a[0][PAIS_CCOD]', document);
		
		var pasaporte         = MM_findObj('a[0][pers_tpasaporte]', document);
		var fecha_emision     = MM_findObj('a[0][pers_femision_pas]', document);
		var fecha_vencimiento = MM_findObj('a[0][pers_fvencimiento_pas]', document);
		var tipo_visa         = MM_findObj('a[0][tvis_ccod]', document ) ;
		//var fecha_termino_visa= MM_findObj('a[0][pers_ftermino_visa]', document ) ;
		
		if(pais.value == '1'){ // Formateando fecha de emision y fecha de vencimiento (1= CHILE).
		  pasaporte.value         = '' ;
		  fecha_emision.value     = '' ;
		  fecha_vencimiento.value = '' ;
		  tipo_visa.value         = '' ;
		 // fecha_termino_visa.value= '' ;
		} 
		else{ // Cualquier otro pais.
			if (pasaporte.value == '' ){
				alert('Si Ud. es extranjero, debe ingresar su número de pasaporte.');
				pasaporte.focus();
				return;
			}
			if (fecha_emision.value == '' ){
				alert('Si Ud. es extranjero, debe ingresar la fecha de emisión del pasaporte.');
				fecha_emision.focus();
				return;
			}
			if (fecha_vencimiento.value == '' ){
				alert('Si Ud. es extranjero, debe ingresar la fecha de vencimiento del pasaporte.');
				fecha_vencimiento.focus();
				return;
			}
		//	if (fecha_termino_visa.value == '' ){
		//		alert('Si Ud. es extranjero, debe ingresar la fecha de vencimiento de la Visa.');
		//		fecha_termino_visa.focus();
		//		return;
		//	}
		}
        var password = MM_findObj('a[0][usua_tclave]',document);
	    if(password.value != form.confirma_password.value){
		    alert('La clave y la confirmación ingresada no son iguales.');
		    password.focus();
		    password.select();
	    }
	    else{
		   if((password.value.length < 4) || (password.value.length > 6)){
		       alert('La clave debe tener entre 4 y 6 caracteres.');
		       password.focus();
		       password.select();
		   }
		   else {
			   var usuario_ = MM_findObj('a[0][usua_tusuario]',document);		      
			   var rut_     = MM_findObj('a[0][pers_nrut]',document);		      
			   var dv_      = MM_findObj('a[0][pers_xdv]',document);		      
			   usuario_.value = rut_.value + '-' + dv_.value ;
			   form.submit();  
		   }
	    }
   } 
}
function habilita(valor, form)
{
    var pasaporte = MM_findObj('a[0][pers_tpasaporte]', document);
	var tvisa = MM_findObj('a[0][tvis_ccod]', document);
	var fecha_emision     = MM_findObj('a[0][pers_femision_pas]', document);
	var fecha_vencimiento = MM_findObj('a[0][pers_fvencimiento_pas]', document);
	//var fecha_termino_visa= MM_findObj('a[0][pers_ftermino_visa]', document ) ; 
	
 	if ((valor != '1') && (valor != '')){
	 	alert("Si es extranjero debe ingresar la información correspondiente al Pasaporte y Visa")
		
        pasaporte.disabled = false; 
		tvisa.disabled     = false;
		//fecha_termino_visa.disabled = false ;
		fecha_emision.disabled      = false ;
		fecha_vencimiento.disabled  = false ;
	 }
	 else {
	 	pasaporte.disabled = true; 
		pasaporte.value = '';
		tvisa.disabled = true;
		//fecha_termino_visa.disabled = true ;
		tvisa.value = '1';
		fecha_emision.disabled = true ;
		fecha_vencimiento.disabled = true;
	 }
}
</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "a[0][pers_femision_pas]","1","formulario1","fecha_oculta_femision"
	calendario.MuestraFecha "a[0][pers_fvencimiento_pas]","2","formulario1","fecha_oculta_fvencimiento"
	calendario.FinFuncion
%>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<br>		
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="100%" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><strong><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">FICHA DE CREACI&Oacute;N DE CLAVES </font></strong></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				    &nbsp;
				    <div align="right"><font color="#FF0000"><b>*</b></font><b> Campos Obligatorios</b></div>
				    <form action="man_formulario.asp" method="post" name="formulario1">
				      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="3%">&nbsp;</td>
                          <td height="40"><div align="center"><b><font size="2" color="#000066">FICHA DE CREACI&Oacute;N DE CLAVES <%=titulo_ext%></font></b></div></td>
                          <td width="3%">&nbsp;</td>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                          <td><table width="99%" cellpadding="0" cellspacing="0" border="0">
                              <tr>
                                <td>&nbsp;</td>
                                <td height="30" colspan="3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">&nbsp;&nbsp;&nbsp;Para crear su CLAVE, primero debe llenar los siguientes datos. Recuerde que esta informaci&oacute;n es personal e intransferible.</font></td>
                              </tr>
                              <tr>
                                <td width="4%">&nbsp;</td>
                                <td width="20%">&nbsp;</td>
                                <td width="2%">&nbsp;</td>
                                <td width="77%"><%=formulario.dibujaCampo("pers_ncorr")%>&nbsp;<%=formulario.dibujaCampo("usua_tusuario")%></td>
                              </tr>
                              <tr>
                                <td width="4%" height="22">&nbsp;</td>
                                <td width="20%" height="22"><font color="#FF0000">*</font> RUT del postulante<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;( Usuario)</td>
                                <td width="2%" height="22">:</td>
                                <td height="22" width="77%">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td width="24%"><%=formulario.dibujaCampo("pers_nrut")%> - <%=formulario.dibujaCampo("pers_xdv")%>&nbsp;</td>
                                      <td width="76%">&nbsp;<font color="#E62E00"><%=rut_ext%></font></td>
                                    </tr>
                                </table></td>
                              </tr>
                              <tr>
                                <td height="10">&nbsp;</td>
                                <td height="25" valign="top">&nbsp;</td>
                                <td height="10">&nbsp;</td>
                                <td height="10" valign="bottom">&nbsp;</td>
                              </tr>
                              <tr>
                                <td height="10">&nbsp;</td>
                                <td width="20%" height="25" valign="top">
                                  <div align="center">&nbsp;&nbsp;</div></td>
                                <td height="10">&nbsp;</td>
                                <td height="10" valign="bottom">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td width="33%"><%=apellido_1%> </td>
                                      <td width="33%"><%=apellido_2%> </td>
                                      <td width="34%">Nombres </td>
                                    </tr>
                                </table></td>
                              </tr>
                              <tr>
                                <td height="22">&nbsp;</td>
                                <td width="20%" height="22"><font color="#FF0000">*</font>Nombre Completo </td>
                                <td height="22">:</td>
                                <td height="22">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td width="33%"><%=formulario.dibujaCampo("pers_tape_paterno")%> </td>
                                      <td width="33%"><%=formulario.dibujaCampo("pers_tape_materno")%> </td>
                                      <td width="34%"> <%=formulario.dibujaCampo("pers_tnombre")%></td>
                                    </tr>
                                </table></td>
                              </tr>
                              <tr>
                                <td height="10">&nbsp;</td>
                                <td width="20%" height="10">&nbsp;</td>
                                <td height="10">&nbsp;</td>
                                <td height="10">&nbsp;</td>
                              </tr>
                              <tr>
                                <td height="22">&nbsp;</td>
                                <td height="22" colspan="3"><table width="99%" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                      <td width="21%"> <font color="#FF0000">*</font> Clave</td>
                                      <td width="2%"> :</td>
                                      <td width="23%"><%=formulario.dibujaCampo("usua_tclave")%> </td>
                                      <td width="25%">
                                        <div align="center"><font color="#FF0000">*</font> Vuelva a escribir la Clave </div></td>
                                      <td> :
                                          <input type="password" name="confirma_password" id="TO-N" size="23" maxlength="6">
                                      </td>
                                    </tr>
                                    <tr>
                                      <td width="20%" height="22">&nbsp;</td>
                                      <td width="2%" height="22">&nbsp;</td>
                                      <td colspan="3" height="22">(M&iacute;nimo 4 y M&aacute;ximo 6 caracteres alfanum&eacute;ricos; sin espacios) </td>
                                    </tr>
                                </table></td>
                              </tr>
                              <tr>
                                <td height="10">&nbsp;</td>
                                <td width="20%" height="10">&nbsp;</td>
                                <td height="10">&nbsp;</td>
                                <td height="10">&nbsp;</td>
                              </tr>
                              <tr>
                                <td height="30">&nbsp;</td>
                                <td height="40" colspan="3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font size="2"> En caso que olvides tu clave, escribe una pregunta a la cual solo t&uacute; conozcas la respuesta, la que ser&aacute; preguntada para verificar tus datos y as&iacute; entregarte tu clave. </font></td>
                              </tr>
                              <tr>
                                <td height="22">&nbsp;</td>
                                <td width="20%" height="22"><font color="#FF0000">*</font><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> Pregunta</font></td>
                                <td height="22">:</td>
                                <td height="22"><%=formulario.dibujaCampo("usua_tpregunta")%></td>
                              </tr>
                              <tr>
                                <td height="10">&nbsp;</td>
                                <td width="20%" height="10">&nbsp;</td>
                                <td height="10">&nbsp;</td>
                                <td height="10">&nbsp;</td>
                              </tr>
                              <tr>
                                <td height="21">&nbsp;</td>
                                <td width="20%" height="21"><font color="#FF0000">*</font><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> Respuesta</font></td>
                                <td height="21">:</td>
                                <td height="21"><%=formulario.dibujaCampo("usua_trespuesta")%> </td>
                              </tr>
                              <tr>
                                <td height="10">&nbsp;</td>
                                <td width="20%" height="10">&nbsp;</td>
                                <td height="10">&nbsp;</td>
                                <td height="10">&nbsp;</td>
                              </tr>
                              <tr>
                                <td height="22">&nbsp;</td>
                                <td width="20%" height="22">Correo Electr&oacute;nico</td>
                                <td height="22">:</td>
                                <td height="22"> <%=formulario.dibujaCampo("pers_temail")%>&nbsp;&nbsp;Ej: juanperez@hotmail.com</td>
                              </tr>
                              <tr>
                                <td height="10">&nbsp;</td>
                                <td width="20%" height="10">&nbsp;</td>
                                <td height="10">&nbsp;</td>
                                <td height="10">&nbsp;</td>
                              </tr>
                              <tr>
                                <td height="22">&nbsp;</td>
                                <td width="20%" height="22"><font color="#FF0000">*</font> Tel&eacute;fono de Contacto</td>
                                <td height="22">:</td>
                                <td height="22"><%=formulario.dibujaCampo("pers_tfono")%>&nbsp;(Formato: Cod. &Aacute;rea - N&uacute;mero)</td>
                              </tr>
                              <tr>
                                <td height="10">&nbsp;</td>
                                <td width="20%" height="10">&nbsp;</td>
                                <td height="10">&nbsp;</td>
                                <td height="10">&nbsp;</td>
                              </tr>
                              <tr>
                                <td height="22">&nbsp;</td>
                                <td width="20%" height="22"><font color="#FF0000">*</font> Nacionalidad</td>
                                <td height="22">:</td>
                                <td height="22"> <%=formulario.dibujaCampo("pais_ccod")%></td>
                              </tr>
                              <tr>
                                <td height="10">&nbsp;</td>
                                <td width="20%" height="10">&nbsp;</td>
                                <td height="10">&nbsp;</td>
                                <td height="10">&nbsp;</td>
                              </tr>
                              <tr>
                                <td height="22">&nbsp;</td>
                                <td height="22" colspan="3"><font size="2">Si es <b>EXTRANJERO</b> debe completar los siguientes datos :</font></td>
                              </tr>
                              <tr>
                                <td height="10">&nbsp;</td>
                                <td width="20%" height="10">&nbsp;</td>
                                <td height="10">&nbsp;</td>
                                <td height="10">&nbsp;</td>
                              </tr>
                              <tr>
                                <td height="22">&nbsp;</td>
                                <td height="22" colspan="3"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td width="26%" height="22">N&ordm; de Pasaporte o documento identificatorio </td>
                                      <td width="2%">:</td>
                                      <td><%=formulario.dibujaCampo("pers_tpasaporte")%></td>
                                    </tr>
                                    <tr>
                                      <td width="26%" height="10">&nbsp;</td>
                                      <td>&nbsp;</td>
                                      <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                      <td width="26%" height="22">Fecha Emisi&oacute;n del Pasaporte</td>
                                      <td>:</td>
                                      <td><%=formulario.dibujaCampo("pers_femision_pas")%> &nbsp;
									   <a style='cursor:hand;' onClick='PopCalendar.show(document.formulario1.fecha_oculta, "dd/mm/yyyy", null, null, "obtener_fecha(1)", "11");'> 
                                       </a> 
                                       <%calendario.DibujaImagen "fecha_oculta_femision","1","formulario1" %></td>
                                    </tr>
                                    <tr>
                                      <td width="26%" height="10">&nbsp;</td>
                                      <td>&nbsp;</td>
                                      <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                      <td width="26%" height="22">Fecha Vencimiento Pasaporte</td>
                                      <td>:</td>
                                      <td><%=formulario.dibujaCampo("pers_fvencimiento_pas")%>&nbsp;
									  <a style='cursor:hand;' onClick='PopCalendar.show(document.formulario1.fecha_oculta, "dd/mm/yyyy", null, null, "obtener_fecha(2)", "11");'> 
                                      </a> 
                                      <%calendario.DibujaImagen "fecha_oculta_fvencimiento","2","formulario1" %></td>
                                    </tr>
                                    <tr>
                                      <td width="26%" height="10">&nbsp;</td>
                                      <td>&nbsp;</td>
                                      <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                      <td width="26%" height="22">Tipo de Visa</td>
                                      <td>:</td>
                                      <td><%=formulario.dibujaCampo("tvis_ccod")%></td>
                                    </tr>
                                    <tr>
                                      <td height="10">&nbsp;</td>
                                      <td>&nbsp;</td>
                                      <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                      <td height="22"><!--Fecha T&eacute;rmino Visa --></td>
                                      <td></td>
                                      <td><%'=formulario.dibujaCampo("PERS_FTERMINO_VISA")%></td>
                                    </tr>
                                </table></td>
                              </tr>
                          </table></td>
                          <td>&nbsp;</td>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
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
                  <td width="184" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center"><%f_botonera.DibujaBoton("siguiente")%></div></td>
                      <td><div align="center">
                        <%f_botonera.DibujaBoton("salir")%>
                      </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="172" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="310" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
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

<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
 q_pers_nrut 	= Request.QueryString("busqueda[0][pers_nrut]")
 q_pers_xdv 	= Request.QueryString("busqueda[0][pers_xdv]")

'-----------------------------
 set conexion = new CConexion
 conexion.Inicializar "upacifico"

 set negocio = new CNegocio
 negocio.Inicializa conexion
'-----------------------------

 periodo_actual = negocio.ObtenerPeriodoAcademico("POSTULACION")
 
 set pagina = new CPagina
 pagina.Titulo = "Ficha de antecedentes personales"
 
'-- Botones de la pagina -----------
 set f_botonera = new CFormulario
 f_botonera.Carga_Parametros "ficha_antec_personales.xml", "botonera"

'---------------------------------------------------------------------------------------------------
 
 if q_pers_nrut = "" or isnull(q_pers_nrut) then
 	rut_env = "-1"
 else
 	rut_env = q_pers_nrut
	
	'-- Formulario con los datos del alumno (Parte 1) -----------
	set fDatosPer = new CFormulario
	fDatosPer.Carga_Parametros "ficha_antec_personales.xml", "f_datos_antecedentes"
	fDatosPer.Inicializar conexion
	cons_Datos = "exec LIST_FICHA_ANTECEDENTES_PERS " & rut_env
	fDatosPer.Consultar cons_Datos 
	fDatosPer.Siguiente
	
		
	'-- Formulario con los datos del alumno (Parte 2) -----------
	set fDatosPer2 = new CFormulario
	fDatosPer2.Carga_Parametros "ficha_antec_personales.xml", "f_datos_antecedentes2"
	fDatosPer2.Inicializar conexion
	cons_Datos = "exec LIST_FICHA_ANTECEDENTES_PERS2 " & rut_env
	fDatosPer2.Consultar cons_Datos 
	fDatosPer2.Siguiente

 end if 
 
'-- Fin (datos alumno ) -------------------------------------------

%>
<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_inicial.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<style>
@media print{ .noprint {visibility:hidden;display: none; }}
</style>

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function imprimir() 
   {window.print()}
   
   
</script>
</head>
<body bgcolor="#FFFFFF">
<table width="714" height="" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
    <td width="714"  valign="top" bgcolor="#FFFFFF"> 
	<table width="100%">
	<tr>
	<td width="14%" align="center"><img src="../imagenes/logo_upa.jpg"><br clear=all> UNIVERSIDAD DEL PACIFICO</td>
	<td width="76%"> <p align="center"><%pagina.DibujarTituloPagina%> </p>
	  <div align="center" class="noprint"><%f_botonera.DibujaBoton ("imprimir")%></div>
	  </td>
	<td width="10%"></td>
	</tr>
	</table>
     <br> 
      <table width="680"   border="1" align="center" cellpadding="0" cellspacing="0">
        <tr> 
          <td valign="top"> <form name="edicion">
              <p align="left"> 
                <%pagina.DibujarSubtitulo "Identificaci&oacute;n del Alumno"%>
              </p>
              <table width="676" height="596" border="0" cellpadding="1" cellspacing="3" bordercolor="#CCCCCC" bgcolor="#FFFFFF">
                <tr> 
                  <td width="196" height="19"><strong>Nombres :</strong></td>
                  <td width="129"><strong>RUT :</strong></td>
                  <td width="163"><strong>Pasaporte :</strong></td>
                  <td width="165"><strong>Fecha Nacimiento :</strong></td>
                </tr>
                <tr> 
                  <td height="22"> 
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("nombre")%></td>
                      </tr>
                    </table></td>
                  <td><table width="80%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("rut")%></td>
                      </tr>
                    </table></td>
                  <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("pasaporte")%></td>
                      </tr>
                    </table></td>
                  <td><table width="50%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("fecha_nac")%></td>
                      </tr>
                    </table></td>
                </tr>
				<tr><td colspan="4" height="20"><strong>E-mail Alumno</strong></td></tr>
					  <tr><td colspan="4" height="20"><table width="80%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
														<tr> 
														  <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("email_alumno")%></td>
														</tr>
													  </table>
						 </td>
					  </tr>
                <tr> 
                  <td height="20"><strong>Direcci&oacute;n :</strong></td>
                  <td><strong>Ciudad : </strong></td>
                  <td><strong>Comuna :</strong></td>
                  <td><strong>Regi&oacute;n :</strong></td>
                </tr>
                <tr> 
                  <td height="22"> 
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("Direccion")%></td>
                      </tr>
                    </table></td>
                  <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("comuna")%></td>
                      </tr>
                    </table></td>
                  <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("ciudad")%></td>
                      </tr>
                    </table></td>
                  <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("region")%></td>
                      </tr>
                    </table></td>
                </tr>
                <tr> 
                  <td height="23"><strong>Fonos : </strong></td>
                  <td><strong>Nacionalidad :</strong></td>
                  <td><strong>Carrera :</strong></td>
                  <td><strong>A&ntilde;o Ingreso :</strong></td>
                </tr>
                <tr> 
                  <td height="24"> 
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("fono")%></td>
                      </tr>
                    </table></td>
                  <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("nacionalidad")%></td>
                      </tr>
                    </table></td>
                  <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("Carrera")%></td>
                      </tr>
                    </table></td>
                  <td> <table width="40%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("ano_ingr")%></td>
                      </tr>
                    </table></td>
                </tr>
                <tr> 
                  <td height="22"><strong>Estado Civil :</strong></td>
                  <td colspan="2"><p><strong>Qui&eacute;n financia sus estudios 
                      :</strong></p></td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td height="22"> 
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("Estado_civil")%></td>
                      </tr>
                    </table></td>
                  <td colspan="2"><table width="55%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("FinanciaEst")%></td>
                      </tr>
                    </table></td>
                  <td>&nbsp; </td>
                </tr>
                <tr> 
                  <td height="20">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td height="20" colspan="4"><font size="2"><strong> 
                    <%pagina.DibujarSubtitulo "Antecedentes Educacionales"%>
                    </strong></font></td>
                </tr>
                <tr> 
                  <td height="21">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td height="20"><strong>Colegio de Egreso</strong></td>
                  <td><strong>A&ntilde;o de Egreso</strong></td>
                  <td><strong>Proc. de Educaci&oacute;n</strong></td>
                  <td><strong>Tipo de Establecimiento</strong></td>
                </tr>
                <tr> 
                  <td height="25"> 
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("colegio_egreso")%></td>
                      </tr>
                    </table></td>
                  <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("ano_egreso")%></td>
                      </tr>
                    </table></td>
                  <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("proced_educ")%></td>
                      </tr>
                    </table></td>
                  <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"> 
                          <%'=fDatosPer.dibujaCampo("Estado_civil")%> </td>
                      </tr>
                    </table></td>
                </tr>
                <tr> 
                  <td height="20" colspan="2"><strong>Universidad (Si estuvo en 
                    otra anteriormente)</strong></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td height="22" colspan="2"> 
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("inst_educ_sup")%></td>
                      </tr>
                    </table></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td height="21">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td height="20" colspan="4"><font size="2"><strong> 
                    <%pagina.DibujarSubtitulo "Identificaci&oacute;n del sostenedor acad&eacute;mico "%>
                    </strong></font></td>
                </tr>
                <tr> 
                  <td height="22"><strong>Nombre :</strong></td>
                  <td><strong>RUT :</strong></td>
                  <td><strong>Fecha Nacimiento :</strong></td>
                  <td><strong> Edad :</strong></td>
                </tr>
                <tr> 
                  <td height="22"> 
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("nombre_sost_ec")%></td>
                      </tr>
                    </table></td>
                  <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("RUT_sost_ec")%></td>
                      </tr>
                    </table></td>
                  <td><table width="50%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("fnac_sost_ec")%></td>
                      </tr>
                    </table></td>
                  <td><table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" align="right" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("edad_sost")%></td>
                      </tr>
                    </table></td>
                </tr>
				<tr><td colspan="4" height="20"><strong>E-mail sostenedor</strong></td></tr>
					  <tr><td colspan="4" height="20"><table width="80%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
														<tr> 
														  <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("email_sost")%></td>
														</tr>
													  </table>
						 </td>
					  </tr>
                <tr> 
                  <td height="20"><strong>Direcci&oacute;n :</strong></td>
                  <td><strong>Ciudad:</strong></td>
                  <td><strong>Comuna : </strong></td>
                  <td><strong>Regi&oacute;n :</strong></td>
                </tr>
                <tr> 
                  <td height="31"> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("dire_tdesc_sost_ec")%></td>
                      </tr>
                    </table></td>
                  <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("comu_sost_ec")%></td>
                      </tr>
                    </table></td>
                  <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("ciud_sost_ec")%></td>
                      </tr>
                    </table></td>
                  <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("regi_sost_ec")%></td>
                      </tr>
                    </table></td>
                </tr>
                <tr> 
                  <td height="20"><strong>Fono :</strong></td>
                  <td><strong>Parentesco</strong></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td height="23"> 
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("fono_sost_ec")%></td>
                      </tr>
                    </table></td>
                  <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer.dibujaCampo("pare_sost_ec")%></td>
                      </tr>
                    </table></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td height="20">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
              </table>
              <table width="100%" border="0" cellpadding="1" cellspacing="3" bordercolor="#CCCCCC" bgcolor="#FFFFFF">
                <tr> 
                  <td height="10" colspan="4"><font size="2"><strong> 
                    <%pagina.DibujarSubtitulo "Antecedentes del Padre"%>
                    </strong></font></td>
                </tr>
                <tr> 
                  <td width="30%" height="10"><strong>RUT :</strong></td>
                  <td width="20%" height="10"><strong>Nombres :</strong></td>
                  <td width="25%" height="10">&nbsp;</td>
                  <td height="10"><strong>Fono :</strong></td>
                </tr>
                <tr> 
                  <td height="10"><font size="2"><strong> </strong></font> <table width="50%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer2.dibujaCampo("RUT_p")%></td>
                      </tr>
                    </table>
                    <font size="2"><strong> </strong></font></td>
                  <td height="10" colspan="2"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer2.dibujaCampo("Nombre_p")%></td>
                      </tr>
                    </table></td>
                  <td height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer2.dibujaCampo("fono_p")%></td>
                      </tr>
                    </table></td>
                </tr>
                <tr> 
                  <td height="10"><strong>Direcci&oacute;n :</strong></td>
                  <td height="10">&nbsp;</td>
                  <td height="10"><strong>Ciudad :</strong></td>
                  <td height="10"><strong>Comuna :</strong></td>
                </tr>
                <tr> 
                  <td height="10" colspan="2"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer2.dibujaCampo("Direccion_p")%></td>
                      </tr>
                    </table></td>
                  <td height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer2.dibujaCampo("comuna_p")%></td>
                      </tr>
                    </table></td>
                  <td height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer2.dibujaCampo("ciudad_p")%></td>
                      </tr>
                    </table></td>
                </tr>
                <tr> 
                  <td height="10">&nbsp;</td>
                  <td height="10">&nbsp;</td>
                  <td height="10">&nbsp;</td>
                  <td height="10">&nbsp;</td>
                </tr>
                <tr> 
                  <td height="10" colspan="4"><font size="2"><strong> 
                    <%pagina.DibujarSubtitulo "Antecedentes de la madre"%>
                    </strong></font></td>
                </tr>
                <tr> 
                  <td height="10"><strong>RUT :</strong></td>
                  <td height="10"><strong>Nombres :</strong></td>
                  <td height="10">&nbsp;</td>
                  <td height="10"><strong>Fono :</strong></td>
                </tr>
                <tr> 
                  <td height="10"><table width="55%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer2.dibujaCampo("RUT_m")%></td>
                      </tr>
                    </table></td>
                  <td height="10" colspan="2"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer2.dibujaCampo("Nombre_m")%></td>
                      </tr>
                    </table></td>
                  <td height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer2.dibujaCampo("fono_m")%></td>
                      </tr>
                    </table></td>
                </tr>
                <tr> 
                  <td height="10">&nbsp;</td>
                  <td height="10">&nbsp;</td>
                  <td height="10">&nbsp;</td>
                  <td height="10">&nbsp;</td>
                </tr>
                <tr> 
                  <td height="10"><strong>Direcci&oacute;n :</strong></td>
                  <td height="10">&nbsp;</td>
                  <td height="10"><strong>Ciudad :</strong></td>
                  <td height="10"><strong>Comuna :</strong></td>
                </tr>
                <tr> 
                  <td height="10" colspan="2"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer2.dibujaCampo("Direccion_m")%></td>
                      </tr>
                    </table></td>
                  <td height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer2.dibujaCampo("comuna_m")%></td>
                      </tr>
                    </table></td>
                  <td height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer2.dibujaCampo("ciudad_m")%></td>
                      </tr>
                    </table></td>
                </tr>
                <tr> 
                  <td height="10">&nbsp;</td>
                  <td height="10">&nbsp;</td>
                  <td height="10">&nbsp;</td>
                  <td height="10">&nbsp;</td>
                </tr>
                <tr> 
                  <td height="10" colspan="4"><font size="2"><strong> 
                    <%pagina.DibujarSubtitulo "Datos entregados para admisión"%>
                    </strong></font></td>
                </tr>
                <tr> 
                  <td height="10" colspan="2"><em><font color="#000066">ACAD&Eacute;MICOS</font></em></td>
                  <td height="10" colspan="2"><em><font color="#000066">FORMA 
                    DE ADMISI&Oacute;N</font></em></td>
                </tr>
                <tr> 
                  <td height="26"><strong>Prom. Notas Ens. Media </strong></td>
                  <td height="26"> <table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" align="right" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><div align="center"><%=fDatosPer2.dibujaCampo("promNotas_em")%></div></td>
                      </tr>
                    </table>
                    <div align="left"></div></td>
                  <td height="26"><strong>Admisi&oacute;n Regular</strong></td>
                  <td height="26"> <table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer2.dibujaCampo("adm_regular")%></td>
                      </tr>
                    </table></td>
                </tr>
                <tr> 
                  <td height="10"><strong>A&ntilde;o que rinde la PAA /PSU</strong></td>
                  <td height="10"><table width="29%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" align="right" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><div align="center"><%=fDatosPer2.dibujaCampo("ano_PAA")%></div></td>
                      </tr>
                    </table></td>
                  <td height="10"><strong>Admisi&oacute;n por Convalidaci&oacute;n</strong></td>
                  <td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer2.dibujaCampo("adm_por_conv")%></td>
                      </tr>
                    </table></td>
                </tr>
                <tr> 
                  <td height="10"><strong>Ptje. promedio PAA/PSU</strong></td>
                  <td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" align="right" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><div align="center"><%=fDatosPer2.dibujaCampo("pje_prom_PAA")%></div></td>
                      </tr>
                    </table></td>
                  <td height="10">&nbsp;</td>
                  <td height="10">&nbsp;</td>
                </tr>
                <tr> 
                  <td height="10" valign="top">(Verbal - Matem&aacute;ticas)</td>
                  <td height="10">&nbsp;</td>
                  <td height="10">&nbsp;</td>
                  <td height="10">&nbsp;</td>
                </tr>
                <tr> 
                  <td height="10">&nbsp;</td>
                  <td height="10">&nbsp;</td>
                  <td height="10">&nbsp;</td>
                  <td height="10">&nbsp;</td>
                </tr>
                <tr> 
                  <td height="10"><em><font color="#000066">ANTECEDENTES ENTREGADOS</font></em></td>
                  <td height="10">&nbsp;</td>
                  <td height="10">&nbsp;</td>
                  <td height="10">&nbsp;</td>
                </tr>
                <tr> 
                  <td height="10"><strong>C&eacute;dula de Identidad o Pasaporte</strong></td>
                  <td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer2.dibujaCampo("CI_pas")%></td>
                      </tr>
                    </table></td>
                  <td height="10">&nbsp;</td>
                  <td height="10">&nbsp;</td>
                </tr>
                <tr> 
                  <td height="10"><strong>Licencia de Ense&ntilde;anza Media</strong></td>
                  <td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer2.dibujaCampo("lic_EM")%></td>
                      </tr>
                    </table></td>
                  <td height="10">&nbsp;</td>
                  <td height="10">&nbsp;</td>
                </tr>
                <tr> 
                  <td height="10"><strong>Concentraci&oacute;n de Notas E.M. </strong></td>
                  <td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer2.dibujaCampo("concen_notas")%></td>
                      </tr>
                    </table></td>
                  <td height="10">&nbsp;</td>
                  <td height="10">&nbsp;</td>
                </tr>
                <tr> 
                  <td height="10"><strong>Puntaje PAA / PSU</strong></td>
                  <td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer2.dibujaCampo("ptje_paa_psu")%></td>
                      </tr>
                    </table></td>
                  <td height="10">&nbsp;</td>
                  <td height="10">&nbsp;</td>
                </tr>
                <tr> 
                  <td height="10"><strong>2 Fotos tama&ntilde;o Carnet</strong></td>
                  <td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer2.dibujaCampo("fotos_carnet")%></td>
                      </tr>
                    </table></td>
                  <td height="10">&nbsp;</td>
                  <td height="10">&nbsp;</td>
                </tr>
                <tr> 
                  <td height="10"><strong>Certificado de Residencia</strong></td>
                  <td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer2.dibujaCampo("certif_residencia")%></td>
                      </tr>
                    </table></td>
                  <td height="10">&nbsp;</td>
                  <td height="10">&nbsp;</td>
                </tr>
                <tr> 
                  <td height="10"><strong>Seguro de Salud (Extranjeros)</strong></td>
                  <td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                      <tr> 
                        <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#FFFFFF"><%=fDatosPer2.dibujaCampo("seguro_salud")%></td>
                      </tr>
                    </table></td>
                  <td height="10">&nbsp;</td>
                  <td height="10">&nbsp;</td>
                </tr>
              </table>
          
              <br>
            </form>
            <table width="100%" border="0">
              <tr> 
                <td width="90%"> <div align="right"></div></td>
                <td width="10%">
                 
                  </td>
              </tr>
              <tr> 
                <td colspan="2"></td>
              </tr>
              <tr> 
                <td colspan="2" align="center"></td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
	  <br/>
	  <div  align="center" class="noprint"><%f_botonera.DibujaBoton ("imprimir")%></div>
     </td>
  </tr>
</table>
</body>
</html>

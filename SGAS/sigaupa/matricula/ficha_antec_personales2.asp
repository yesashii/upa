<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
 q_pers_nrut 	= Request.QueryString("busqueda[0][pers_nrut]")
 q_pers_xdv 	= Request.QueryString("busqueda[0][pers_xdv]")
 q_npag			= Request.QueryString("npag")

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
'-----------------------------------

'---------------------------------------------------------------------------------------------------
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "ficha_antec_personales.xml", "busqueda"
 f_busqueda.Inicializar conexion

 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
 f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
'---------------------------------------------------------------------------------------------------
 
 if q_pers_nrut = "" or isnull(q_pers_nrut) then
 	rut_env = "-1"
	es_alumno = -1
 else
 	rut_env = q_pers_nrut
	es_alumno = cint(conexion.consultaUno("select protic.ES_ALUMNO("& rut_env &", "& periodo_actual &")"))

	'-- Formulario con los datos del alumno (Parte 1) -----------
	set fDatosPer = new CFormulario
	fDatosPer.Carga_Parametros "ficha_antec_personales.xml", "f_datos_antecedentes"
	fDatosPer.Inicializar conexion
	cons_Datos = "exec LIST_FICHA_ANTECEDENTES_PERS " & rut_env
	fDatosPer.Consultar cons_Datos 
	fDatosPer.Siguiente
	
	if q_npag = "" or isnull(q_npag) then
		q_npag = 1
	elseif q_npag = 2 then
		'-- Formulario con los datos del alumno (Parte 2) -----------
		set fDatosPer2 = new CFormulario
		fDatosPer2.Carga_Parametros "ficha_antec_personales.xml", "f_datos_antecedentes2"
		fDatosPer2.Inicializar conexion
		cons_Datos = "exec LIST_FICHA_ANTECEDENTES_PERS2 " & rut_env
		fDatosPer2.Consultar cons_Datos 
		fDatosPer2.Siguiente
	end if
 end if 
 
'-- Fin (Parte 1) -------------------------------------------

 
'--------------------------------------------------------------------------------------------------
 set fc_datos = new CFormulario
 fc_datos.Carga_Parametros "consulta.xml", "consulta"
 fc_datos.Inicializar conexion
		   
 consulta = "select cast(a.pers_nrut as varchar) + ' - ' + a.pers_xdv as rut," & vbCrLf &_
			"         a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre_completo " & vbCrLf &_
			"from personas_postulante a " & vbCrLf &_
			"where cast(a.pers_nrut as varchar) = '" & q_pers_nrut & "'"
 fc_datos.Consultar consulta
 fc_datos.Siguiente
 
'-------------------------------------------------------------------------
 dir_a = "ficha_antec_personales.asp?busqueda[0][pers_nrut]="&q_pers_nrut&"&busqueda[0][pers_xdv]="&q_pers_xdv&"&npag=1"
 dir_b = "ficha_antec_personales.asp?busqueda[0][pers_nrut]="&q_pers_nrut&"&busqueda[0][pers_xdv]="&q_pers_xdv&"&npag=2" 
 
 if q_npag = 1 then
 	f_botonera.AgregaBotonParam "pagina2", "texto", "Ir a página 2"
 	dir_JS = "ficha_antec_personales.asp?busqueda[0][pers_nrut]="&q_pers_nrut&"&busqueda[0][pers_xdv]="&q_pers_xdv&"&npag=2"
 else
 	dir_JS = "ficha_antec_personales.asp?busqueda[0][pers_nrut]="&q_pers_nrut&"&busqueda[0][pers_xdv]="&q_pers_xdv&"&npag=1"
	f_botonera.AgregaBotonParam "pagina2", "texto", "Ir a página 1"
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

<script language="JavaScript">
function ValidaFormBusqueda()
{
	var formulario = document.buscador;
	var	rut = formulario.elements["busqueda[0][pers_nrut]"].value + '-' + formulario.elements["busqueda[0][pers_xdv]"].value;
	
	if (!valida_rut(rut)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	}
	
	return true;
	
}

function imprimir() {
  //window.open(direccion ,"ventana1","width=520,height=540,scrollbars=yes, left=313, top=200");
}
function mensaje(){
	<%if es_alumno = 0 then%>
	alert('La persona ingresada no se ha matriculado en el período académico actual.')
	<%end if%>
}

function irPagina2(){
	window.location = '<%=dir_JS%>';
}
</script>
</head>

<body onLoad="javascript:mensaje();">
<table width="750" height="50%" border="0" align="center" cellpadding="0" cellspacing="0">
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
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td><div align="right">R.U.T. Alumno </div></td>
                        <td width="7%"><div align="center">:</div></td>
                        <td><%f_busqueda.DibujaCampo("pers_nrut")%> 
                        - 
                          <%f_busqueda.DibujaCampo("pers_xdv")%><%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td>
                      </tr>
                    </table>
                  </div></td>
                  <td width="19%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
                </tr>
              </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	  <% if q_pers_nrut <>"" and fc_datos.nrofilas > 0 and es_alumno = 1 then %>
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
            <td><%pagina.DibujarLenguetas Array(Array("Página 1", dir_a), Array("Página 2", dir_b)), q_npag %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%>
                    <br>
                  </div>
				<form name="edicion">
				<% if q_npag = 1 then %>
                    <table width="100%" border="0" cellpadding="1" cellspacing="3" bgcolor="#D8D8DE">
                      <tr> 
                        <td width="30%">&nbsp;</td>
                        <td width="20%">&nbsp;</td>
                        <td width="25%">&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="20" colspan="4"> <%pagina.DibujarSubtitulo "Identificaci&oacute;n del Alumno"%> </td>
                      </tr>
                      <tr> 
                        <td height="20">&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="20"><strong>Nombres :</strong></td>
                        <td><strong>RUT :</strong></td>
                        <td><strong>Pasaporte :</strong></td>
                        <td><strong>Fecha Nacimiento :</strong></td>
                      </tr>
                      <tr> 
                        <td height="20"> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("nombre")%></td>
                            </tr>
                          </table></td>
                        <td><table width="80%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><strong><%=fDatosPer.dibujaCampo("rut")%></strong></td>
                            </tr>
                          </table></td>
                        <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><strong><%=fDatosPer.dibujaCampo("pasaporte")%></strong></td>
                            </tr>
                          </table></td>
                        <td><table width="50%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><strong><%=fDatosPer.dibujaCampo("fecha_nac")%></strong></td>
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
                        <td height="20"><strong>Direcci&oacute;n :</strong></td>
                        <td><strong>Comuna : </strong></td>
                        <td><strong>Ciudad :</strong></td>
                        <td><strong>Regi&oacute;n :</strong></td>
                      </tr>
                      <tr> 
                        <td height="20"> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("Direccion")%></td>
                            </tr>
                          </table></td>
                        <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("comuna")%></td>
                            </tr>
                          </table></td>
                        <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("ciudad")%></td>
                            </tr>
                          </table></td>
                        <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("region")%></td>
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
                        <td height="20"><strong>Fonos : </strong></td>
                        <td><strong>Nacionalidad :</strong></td>
                        <td><strong>Carrera :</strong></td>
                        <td><strong>A&ntilde;o Ingreso :</strong></td>
                      </tr>
                      <tr> 
                        <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("fono")%></td>
                            </tr>
                          </table></td>
                        <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("nacionalidad")%></td>
                            </tr>
                          </table></td>
                        <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("Carrera")%></td>
                            </tr>
                          </table></td>
                        <td> <table width="40%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("ano_ingr")%></td>
                            </tr>
                          </table></td>
                      </tr>
                      <tr> 
                        <td height="10">&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="20"><strong>Estado Civil :</strong></td>
                        <td colspan="2"><p><strong>Qui&eacute;n financia sus estudios 
                            :</strong></p></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="20"> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("Estado_civil")%></td>
                            </tr>
                          </table></td>
                        <td colspan="2"><table width="55%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("FinanciaEst")%></td>
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
                        <td height="20">&nbsp;</td>
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
                        <td height="20"> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("colegio_egreso")%></td>
                            </tr>
                          </table></td>
                        <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("ano_egreso")%></td>
                            </tr>
                          </table></td>
                        <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("proced_educ")%></td>
                            </tr>
                          </table></td>
                        <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"> 
                                <%'=fDatosPer.dibujaCampo("Estado_civil")%> </td>
                            </tr>
                          </table></td>
                      </tr>
                      <tr> 
                        <td height="5">&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="20" colspan="2"><strong>Universidad (Si estuvo 
                          en otra anteriormente)</strong></td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="20" colspan="2"> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("inst_educ_sup")%></td>
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
                      <tr> 
                        <td height="20" colspan="4"><font size="2"><strong> 
                          <%pagina.DibujarSubtitulo "Identificaci&oacute;n del sostenedor acad&eacute;mico "%>
                          </strong></font></td>
                      </tr>
                      <tr> 
                        <td height="20"><strong>Nombre :</strong></td>
                        <td><strong>RUT :</strong></td>
                        <td><strong>Fecha Nacimiento :</strong></td>
                        <td><strong> Edad :</strong></td>
                      </tr>
                      <tr> 
                        <td height="20"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("nombre_sost_ec")%></td>
                            </tr>
                          </table></td>
                        <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("RUT_sost_ec")%></td>
                            </tr>
                          </table></td>
                        <td><table width="50%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("fnac_sost_ec")%></td>
                            </tr>
                          </table></td>
                        <td><table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" align="right" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("edad_sost")%></td>
                            </tr>
                          </table></td>
                      </tr>
                      <tr> 
                        <td height="5">&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="20"><strong>Direcci&oacute;n :</strong></td>
                        <td><strong>Comuna:</strong></td>
                        <td><strong>Ciudad : </strong></td>
                        <td><strong>Regi&oacute;n :</strong></td>
                      </tr>
                      <tr> 
                        <td height="20"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("dire_tdesc_sost_ec")%></td>
                            </tr>
                          </table></td>
                        <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("comu_sost_ec")%></td>
                            </tr>
                          </table></td>
                        <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("ciud_sost_ec")%></td>
                            </tr>
                          </table></td>
                        <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("regi_sost_ec")%></td>
                            </tr>
                          </table></td>
                      </tr>
                      <tr> 
                        <td height="5">&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="20"><strong>Fono :</strong></td>
                        <td><strong>Parentesco</strong></td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("fono_sost_ec")%></td>
                            </tr>
                          </table></td>
                        <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("pare_sost_ec")%></td>
                            </tr>
                          </table></td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                    </table>
					<%else%>
                    <table width="100%" border="0" cellpadding="1" cellspacing="3" bgcolor="#D8D8DE">
                      <tr> 
                        <td width="30%">&nbsp;</td>
                        <td width="20%">&nbsp;</td>
                        <td width="25%">&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="20" colspan="4"> <%pagina.DibujarSubtitulo "Identificaci&oacute;n del Alumno"%> </td>
                      </tr>
                      <tr> 
                        <td height="20">&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="20"><strong>Nombres :</strong></td>
                        <td><strong>RUT :</strong></td>
                        <td><strong>Fonos :</strong></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="20"> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("nombre")%></td>
                            </tr>
                          </table></td>
                        <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><strong><%=fDatosPer.dibujaCampo("rut")%></strong></td>
                            </tr>
                          </table></td>
                        <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><strong><%=fDatosPer.dibujaCampo("fono")%></strong></td>
                            </tr>
                          </table></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="10">&nbsp;</td>
                        <td height="10">&nbsp;</td>
                        <td height="10">&nbsp;</td>
                        <td height="10">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="20" colspan="2"><strong>Carrera (s) :</strong></td>
                        <td><strong>A&ntilde;o ingreso: </strong></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="20" colspan="2"> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("Carrera")%></td>
                            </tr>
                          </table></td>
                        <td><table width="40%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer.dibujaCampo("ano_ingr")%></td>
                            </tr>
                          </table></td>
                        <td>&nbsp; </td>
                      </tr>
                      <tr> 
                        <td height="10">&nbsp;</td>
                        <td height="10">&nbsp;</td>
                        <td height="10">&nbsp;</td>
                        <td height="10">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="10" colspan="4"><font size="2"><strong> 
                          <%pagina.DibujarSubtitulo "Antecedentes del Padre"%>
                          </strong></font></td>
                      </tr>
                      <tr> 
                        <td height="10"><strong>RUT :</strong></td>
                        <td height="10"><strong>Nombres :</strong></td>
                        <td height="10">&nbsp;</td>
                        <td height="10"><strong>Fono :</strong></td>
                      </tr>
                      <tr> 
                        <td height="10"><font size="2"><strong> </strong></font> 
                          <table width="50%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer2.dibujaCampo("RUT_p")%></td>
                            </tr>
                          </table>
                          <font size="2"><strong> </strong></font></td>
                        <td height="10" colspan="2"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer2.dibujaCampo("Nombre_p")%></td>
                            </tr>
                          </table></td>
                        <td height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer2.dibujaCampo("fono_p")%></td>
                            </tr>
                          </table></td>
                      </tr>
                      <tr> 
                        <td height="10"><strong>Direcci&oacute;n :</strong></td>
                        <td height="10">&nbsp;</td>
                        <td height="10"><strong>Comuna :</strong></td>
                        <td height="10"><strong>Ciudad :</strong></td>
                      </tr>
                      <tr> 
                        <td height="10" colspan="2"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer2.dibujaCampo("Direccion_p")%></td>
                            </tr>
                          </table></td>
                        <td height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer2.dibujaCampo("comuna_p")%></td>
                            </tr>
                          </table></td>
                        <td height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer2.dibujaCampo("ciudad_p")%></td>
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
                        <td height="10"><table width="50%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer2.dibujaCampo("RUT_m")%></td>
                            </tr>
                          </table></td>
                        <td height="10" colspan="2"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer2.dibujaCampo("Nombre_m")%></td>
                            </tr>
                          </table></td>
                        <td height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer2.dibujaCampo("fono_m")%></td>
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
                        <td height="10"><strong>Comuna :</strong></td>
                        <td height="10"><strong>Ciudad :</strong></td>
                      </tr>
                      <tr> 
                        <td height="10" colspan="2"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer2.dibujaCampo("Direccion_m")%></td>
                            </tr>
                          </table></td>
                        <td height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer2.dibujaCampo("comuna_m")%></td>
                            </tr>
                          </table></td>
                        <td height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer2.dibujaCampo("ciudad_m")%></td>
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
                        <td height="10"><strong>Prom. Notas Ens. Media </strong></td>
                        <td height="10"> <table width="50%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" align="right" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer2.dibujaCampo("promNotas_em")%></td>
                            </tr>
                          </table></td>
                        <td height="10"><strong>Admisi&oacute;n Regular</strong></td>
                        <td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer2.dibujaCampo("adm_regular")%></td>
                            </tr>
                          </table></td>
                      </tr>
                      <tr> 
                        <td height="10"><strong>A&ntilde;o que rinde la PAA </strong></td>
                        <td height="10"><table width="50%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" align="right" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer2.dibujaCampo("ano_PAA")%></td>
                            </tr>
                          </table></td>
                        <td height="10"><strong>Admisi&oacute;n por Convalidaci&oacute;n</strong></td>
                        <td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer2.dibujaCampo("adm_por_conv")%></td>
                            </tr>
                          </table></td>
                      </tr>
                      <tr> 
                        <td height="10"><strong>Ptje. promedio PAA </strong></td>
                        <td height="10"><table width="50%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" align="right" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer2.dibujaCampo("pje_prom_PAA")%></td>
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
                        <td height="10"><em><font color="#000066">ANTECEDENTES 
                          ENTREGADOS</font></em></td>
                        <td height="10">&nbsp;</td>
                        <td height="10">&nbsp;</td>
                        <td height="10">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="10"><strong>C&eacute;dula de Identidad o Pasaporte</strong></td>
                        <td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer2.dibujaCampo("CI_pas")%></td>
                            </tr>
                          </table></td>
                        <td height="10">&nbsp;</td>
                        <td height="10">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="10"><strong>Licencia de Ense&ntilde;anza Media</strong></td>
                        <td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer2.dibujaCampo("lic_EM")%></td>
                            </tr>
                          </table></td>
                        <td height="10">&nbsp;</td>
                        <td height="10">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="10"><strong>Concentraci&oacute;n de Notas 
                          E.M. </strong></td>
                        <td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer2.dibujaCampo("concen_notas")%></td>
                            </tr>
                          </table></td>
                        <td height="10">&nbsp;</td>
                        <td height="10">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="10"><strong>Puntaje PAA / PSU</strong></td>
                        <td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer2.dibujaCampo("ptje_paa_psu")%></td>
                            </tr>
                          </table></td>
                        <td height="10">&nbsp;</td>
                        <td height="10">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="10"><strong>2 Fotos tama&ntilde;o Carnet</strong></td>
                        <td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer2.dibujaCampo("fotos_carnet")%></td>
                            </tr>
                          </table></td>
                        <td height="10">&nbsp;</td>
                        <td height="10">&nbsp;</td>
                      </tr>
                      <tr>
                        <td height="10"><strong>Certificado de Residencia</strong></td>
                        <td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer2.dibujaCampo("certif_residencia")%></td>
                            </tr>
                          </table></td>
                        <td height="10">&nbsp;</td>
                        <td height="10">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="10"><strong>Seguro de Salud (Extranjeros)</strong></td>
                        <td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                            <tr> 
                              <td height="20" align="center" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%=fDatosPer2.dibujaCampo("seguro_salud")%></td>
                            </tr>
                          </table></td>
                        <td height="10">&nbsp;</td>
                        <td height="10">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="10">&nbsp;</td>
                        <td height="10">&nbsp;</td>
                        <td height="10">&nbsp;</td>
                        <td height="10">&nbsp;</td>
                      </tr>
                    </table>
                    <%end if %>
					
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
                  <td><div align="center">
                            <%f_botonera.DibujaBoton ("pagina2")%>
                          </div></td>
				  <td><div align="center"><%'f_botonera.DibujaBoton ("imprimir")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir")%>
                  </div></td>
                  </tr>
              </table>
            </div></td>
            <td width="72%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
	<% end if%>
	</td>
  </tr>  
</table>
</body>
</html>

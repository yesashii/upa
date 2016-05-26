<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

'---------------------------------------------------------------------------------------------------
cpro_ncorr=request.QueryString("cpro_ncorr")
pers_ncorr=request.QueryString("pers_ncorr")
set conectar = new CConexion
conectar.Inicializar "upacifico"


SqlExperiencia= " select PERS_NCORR,CPRO_NCORR,CPRO_CAPACITACION_INTERNA,EMPR_RAZON_SOCIAL,EMPR_NRUT,EMPR_XDV,EMPR_TDIRECCION,EMPR_CIUD_CCOD,EMPR_TFONO,EMPR_TCOORDINADOR,EMPR_TEMAIL,GRAC_CCOD, "&_
                " CPRO_NOMBRE_CURSO,CPRO_COD_SENCE,CPRO_NUM_HORAS,protic.trunc(CPRO_FECHA_INICIO) as CPRO_FECHA_INICIO, "&_ 
				" protic.trunc(CPRO_FECHA_TERMINO) as CPRO_FECHA_TERMINO,CPRO_LUGAR,CPRO_COSTO_PERSONA,CPRO_COSTO_OTIC,CPRO_VIATICOS,CPRO_TRASLADOS,EGRA_CCOD  " & _
				" from capacitacion_profesor " & _
				" where cast(cpro_ncorr as varchar) = '"&cpro_ncorr&"'"

set F_ExLaboral = new cformulario			   
F_ExLaboral.carga_parametros "capacitacion_docente.xml", "agregar_capacitacion"
F_ExLaboral.inicializar conectar

F_ExLaboral.consultar SqlExperiencia
F_ExLaboral.siguientef

terminado = F_ExLaboral.obtenervalor("egra_ccod")

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "capacitacion_docente.xml", "botonera"

%>


<html>
<head>
<title>Agregar experiencia docente</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function compfecha(formulario){
	StrDesde=formulario.elements["m[0][cudo_finicio]"].value;
	arrfechaDesde=StrDesde.split('/');
	StrHasta=formulario.elements["m[0][cudo_ftermino]"].value;
	arrFechaHasta=StrHasta.split('/');
	var FechaDesde = new Date(arrfechaDesde[2],arrfechaDesde[1],arrfechaDesde[0])	
	var FechaHasta = new Date(arrFechaHasta[2],arrFechaHasta[1],arrFechaHasta[0])
	if (FechaDesde<FechaHasta) {
		return true;
	}
	else {return false;}
	}
	
function ValidaForm(formulario)
{
	if (!compfecha(formulario)) {
		alert("La fecha desde debe ser menor a la fecha hasta.")
		return false;
	}
	
	return true;
}
function asigna_upa(valor)
{
	if(valor)
	{
		document.edicion.elements["m[0][EMPR_RAZON_SOCIAL]"].value="Universidad del Pacífico";
		document.edicion.elements["m[0][EMPR_NRUT]"].value="71704700";
		document.edicion.elements["m[0][EMPR_XDV]"].value="1";
		document.edicion.elements["m[0][EMPR_TDIRECCION]"].value="Avda. Las Condes 11121";
	}
	else
	{
		document.edicion.elements["m[0][EMPR_RAZON_SOCIAL]"].value="";
		document.edicion.elements["m[0][EMPR_NRUT]"].value="";
		document.edicion.elements["m[0][EMPR_XDV]"].value="";
		document.edicion.elements["m[0][EMPR_TDIRECCION]"].value="";
	}
}
function iniciopagina(formulario){
terminado = '<%=terminado%>'
	if (terminado==1){
		formulario.elements["m[0][GPRO_ANO_EGRESO]"].readOnly=false;
	}	
	else{
		formulario.elements["m[0][GPRO_ANO_EGRESO]"].readOnly=true;
	}

}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="iniciopagina(document.edicion);MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="700" border="0" align="center" cellpadding="0" cellspacing="0">  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td height="8" background="../imagenes/top_r1_c2.gif"></td>
                <td height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Agregar Grado Acad&eacute;mico </font></div></td>
                      <td bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td background="../imagenes/top_r3_c2.gif"></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				    &nbsp;
				    <form name="edicion">
					<input name="m[0][pers_ncorr]" type="hidden" value="<%=pers_ncorr%>">
			        <input type="hidden" name="cpro_ncorr" value="<%=cpro_ncorr%>">
              <table width="100%" border="0">
                <tr> 
                  <td align="center"><div align="right"><font color="#CC3300">*</font> 
                      Campos Obligatorios</div></td>
                </tr>
              </table>
        
               <table width="100%" border="0">
                <tr>
                  <td colspan="6">&nbsp;</td>
                </tr>
                <tr>
                  <td colspan="6" align="left"><strong>Organismo que entrega la capacitación:</strong></td>
                </tr>
                <tr>
                  <td width="3%" align="center"><font color="#CC3300">&nbsp;</font> </td>
                  <td width="15%" align="right"><div align="left"><strong>Capacitación UPA</strong></div></td>
                  <td width="32%" align="left" colspan="4">: <%F_ExLaboral.dibujacampo("CPRO_CAPACITACION_INTERNA")%></td>
                </tr>
                <tr>
                  <td width="3%" align="center"><font color="#CC3300">*</font> </td>
                  <td width="15%" align="right"><div align="left"><strong>Razón Social</strong></div></td>
                  <td width="32%" align="left">: <%F_ExLaboral.dibujacampo("EMPR_RAZON_SOCIAL")%></td>
                  <td width="3%" align="center"><font color="#CC3300">*</font> </td>
                  <td width="15%" align="right"><div align="left"><strong>Rut empresa</strong></div></td>
                  <td width="32%" align="left">: <%F_ExLaboral.dibujacampo("EMPR_NRUT")%>-<%F_ExLaboral.dibujacampo("EMPR_XDV")%></td>
                </tr>
                <tr>
                  <td width="3%" align="center"><font color="#CC3300">&nbsp;</font> </td>
                  <td width="15%" align="right"><div align="left"><strong>Dirección</strong></div></td>
                  <td width="32%" align="left" colspan="4">: <%F_ExLaboral.dibujacampo("EMPR_TDIRECCION")%></td>
                </tr>
                <tr>
                  <td width="3%" align="center"><font color="#CC3300">*</font> </td>
                  <td width="15%" align="right"><div align="left"><strong>Comuna</strong></div></td>
                  <td width="32%" align="left">: <%F_ExLaboral.dibujacampo("EMPR_CIUD_CCOD")%></td>
                  <td width="3%" align="center"><font color="#CC3300">&nbsp;</font> </td>
                  <td width="15%" align="right"><div align="left"><strong>Fono</strong></div></td>
                  <td width="32%" align="left">: <%F_ExLaboral.dibujacampo("EMPR_TFONO")%></td>
                </tr>
                <tr>
                  <td width="3%" align="center"><font color="#CC3300">&nbsp;</font> </td>
                  <td width="15%" align="right"><div align="left"><strong>Coordinador curso</strong></div></td>
                  <td width="32%" align="left">: <%F_ExLaboral.dibujacampo("EMPR_TCOORDINADOR")%></td>
                  <td width="3%" align="center"><font color="#CC3300">&nbsp;</font> </td>
                  <td width="15%" align="right"><div align="left"><strong>Email</strong></div></td>
                  <td width="32%" align="left">: <%F_ExLaboral.dibujacampo("EMPR_TEMAIL")%></td>
                </tr>
                <tr>
                  <td colspan="6">&nbsp;</td>
                </tr>
                <tr>
                  <td colspan="6" align="left"><strong>Datos de la capacitación:</strong></td>
                </tr>
                <tr>
                  <td width="3%" align="center"><font color="#CC3300">*</font> </td>
                  <td width="15%" align="right"><div align="left"><strong>Grado Acad&eacute;mico  </strong></div></td>
                  <td width="32%" align="left">: <%F_ExLaboral.dibujacampo("GRAC_CCOD")%></td>
                  <td width="3%" align="center"><font color="#CC3300">*</font></td>
                  <td width="15%" align="right"><div align="left"><strong>Estado Del Grado </strong></div></td>
                  <td width="32%" align="left">: <%F_ExLaboral.dibujacampo("EGRA_CCOD")%> </td>
                </tr>
                <tr>
                  <td width="3%" align="center"><font color="#CC3300">*</font> </td>
                  <td width="15%" align="right"><div align="left"><strong>Nombre curso/Seminario</strong></div></td>
                  <td width="32%" align="left" colspan="4">: <%F_ExLaboral.dibujacampo("CPRO_NOMBRE_CURSO")%></td>
                </tr>
                <tr>
                  <td width="3%" align="center"><font color="#CC3300">&nbsp;</font> </td>
                  <td width="15%" align="right"><div align="left"><strong>Código SENCE</strong></div></td>
                  <td width="32%" align="left">: <%F_ExLaboral.dibujacampo("CPRO_COD_SENCE")%></td>
                  <td width="3%" align="center"><font color="#CC3300">*</font> </td>
                  <td width="15%" align="right"><div align="left"><strong>N° Horas</strong></div></td>
                  <td width="32%" align="left">: <%F_ExLaboral.dibujacampo("CPRO_NUM_HORAS")%></td>
                </tr>
                <tr>
                  <td width="3%" align="center"><font color="#CC3300">*</font> </td>
                  <td width="15%" align="right"><div align="left"><strong>Fecha inicio</strong></div></td>
                  <td width="32%" align="left">: <%F_ExLaboral.dibujacampo("CPRO_FECHA_INICIO")%></td>
                  <td width="3%" align="center"><font color="#CC3300">*</font> </td>
                  <td width="15%" align="right"><div align="left"><strong>Fecha término</strong></div></td>
                  <td width="32%" align="left">: <%F_ExLaboral.dibujacampo("CPRO_FECHA_TERMINO")%></td>
                </tr>
                <tr>
                  <td width="3%" align="center"><font color="#CC3300">*</font> </td>
                  <td width="15%" align="right"><div align="left"><strong>Lugar de realización</strong></div></td>
                  <td width="32%" align="left" colspan="4">: <%F_ExLaboral.dibujacampo("CPRO_LUGAR")%></td>
                </tr>
                <tr>
                  <td width="3%" align="center"><font color="#CC3300">&nbsp;</font> </td>
                  <td width="15%" align="right"><div align="left"><strong>Valor por persona</strong></div></td>
                  <td width="32%" align="left">: <%F_ExLaboral.dibujacampo("CPRO_COSTO_PERSONA")%></td>
                  <td width="3%" align="center"><font color="#CC3300">&nbsp;</font> </td>
                  <td width="15%" align="right"><div align="left"><strong>Valor a pagar por OTIC</strong></div></td>
                  <td width="32%" align="left">: <%F_ExLaboral.dibujacampo("CPRO_COSTO_OTIC")%></td>
                </tr>
                <tr>
                  <td width="3%" align="center"><font color="#CC3300">&nbsp;</font> </td>
                  <td width="15%" align="right"><div align="left"><strong>Viáticos</strong></div></td>
                  <td width="32%" align="left">: <%F_ExLaboral.dibujacampo("CPRO_VIATICOS")%></td>
                  <td width="3%" align="center"><font color="#CC3300">&nbsp;</font> </td>
                  <td width="15%" align="right"><div align="left"><strong>Traslados</strong></div></td>
                  <td width="32%" align="left">: <%F_ExLaboral.dibujacampo("CPRO_TRASLADOS")%></td>
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
                  <td width="237" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center"><%f_botonera.DibujaBoton "guardar" %></div></td>
                      <td><div align="center"><%f_botonera.DibujaBoton "cerrar" %></div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="125" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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

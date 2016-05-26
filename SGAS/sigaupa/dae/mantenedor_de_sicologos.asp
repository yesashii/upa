<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut =Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
q_tdet_ccod =Request.QueryString("b[0][tdet_ccod]")
q_sede_ccod= request.QueryString("b[0][sede_ccod]")
q_anos_ccod= request.QueryString("b[0][anos_ccod]")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Becas"

Set errores= New CErrores
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "mantenedor_sicologos.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "mantenedor_sicologos.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "mantenedor_sicologos.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.AgregaCampoCons "sede_ccod", q_sede_ccod

'---------------------------------------------------------------------------------------------------
set f_cheques = new CFormulario
f_cheques.Carga_Parametros "mantenedor_sicologos.xml", "sicologos"
f_cheques.Inicializar conexion

sql_descuentos="select a.pers_ncorr,pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,lower(email_upa)as email,protic.obtener_sedes_sicologos(a.pers_ncorr)as sede "& vbCrLf &_
"from personas a,"& vbCrLf &_
"sicologos b"& vbCrLf &_
"where a.PERS_NCORR=b.pers_ncorr"

'response.End()

f_cheques.Consultar sql_descuentos



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
function Validar(form){
mensaje="Borrar";
//alert(dcur_ncorrM);


 nro = document.buscador.elements.length;
   num =0;
   for( i = 0; i < nro; i++ ) {
	  comp = document.buscador.elements[i];
	  str  = document.buscador.elements[i].name;
	  	//alert("comp"+comp);
		//alert("str="+str);
	  if((comp.type == 'checkbox') && (comp.checked == true)){
	  //alert(comp.name);	
		indice=extrae_indice(comp.name);
		//alert(indice);
		//alert(num);
	     num += 1;
		return true;
	  }
   }
   if( num == 0 ) {

      alert('Debes seleccionar al menos una Sede');
	return false;
   }	


}

function Validar_rut()
{
	formulario = document.buscador;
	rut_alumno = formulario.elements["b[0][pers_nrut]"].value + "-" + formulario.elements["b[0][pers_xdv]"].value;	
	if (formulario.elements["b[0][pers_nrut]"].value  != ''){
	  	  if (!valida_rut(rut_alumno)) {
		  alert("Ingrese un RUT válido");
		formulario.elements["b[0][pers_nrut]"].focus();
		formulario.elements["b[0][pers_nrut]"].select();
		return false;
	  }
	}
	return true;
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
				  <table width="74%"  border="0" align="center">
					<tr>
						<td width="7%"><strong>Rut  :</strong></td>
						<td width="10%"><div align="center"><%f_busqueda.DibujaCampo("pers_nrut")%></div></td>
						<td width="2%">-</td>
						<td width="4%"><div align="center"><%f_busqueda.DibujaCampo("pers_xdv")%></div></td>
						<td width="77%" colspan="3"><%pagina.DibujarBuscaPersonas "b[0][pers_nrut]", "b[0][pers_xdv]"%></td>
					</tr>
					</table>
					
					 <table width="74%"  border="0" align="center">
						<tr>
						  <td width="15%"><p><strong>Correo Upa</strong></p></td>
							<td width="85%"><div align="left"><%f_busqueda.DibujaCampo("email")%></div></td>
						</tr>
             		</table>
					<table width="74%" border="0" align="center">
						<tr>
						  <td width="14%"><p><strong>Las Condes</strong></p></td>
						  <td width="86%"><div align="left"><%f_busqueda.DibujaCampo("lascondes")%></div></td>
						</tr>
						<tr>
						  <td><p><strong>Baquedano</strong></p></td>
						  <td width="86%"><div align="left"><%f_busqueda.DibujaCampo("baquedano")%></div></td>
						</tr>
						<tr>
						  <td><p><strong>Lyon</strong></p></td>
						  <td width="86%"><div align="left"><%f_busqueda.DibujaCampo("lyon")%></div></td>
						</tr>
						<tr>
						  <td><p><strong>Melipilla</strong></p></td>
						  <td width="86%"><div align="left"><%f_busqueda.DibujaCampo("melipilla")%></div></td>
						</tr>
					</table>
					<table width="74%"  border="0" align="center">
						<tr>
							<td width="11%"><div align="center"><%f_botonera.DibujaBoton("guardar")%></div></td>
							<td width="89%">&nbsp;</td>
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
            <td><%pagina.DibujarLenguetas Array("Sicologos"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
		  <tr>
		  <td><div align="center">
                    <br>
                    <table width="100%" border="0">
                     
                    </table>
					</tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Sicólogos Ingresados"%>
					
                      <table width="98%"  border="0" align="center">
					        <tr>
                             <td align="right">P&aacute;gina:
                                 <%f_cheques.accesopagina%>
                             </td>
                            </tr>
                            <tr>						
                                <td align="center">
						       <%f_cheques.DibujaTabla()%>
							   </td>
						  
                        </tr>
                      </table>
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
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    
					<%'f_botonera.AgregaBotonParam "excel", "url", "becas_excel.asp?pers_nrut="&q_pers_nrut&"&pers_xdv="&q_pers_xdv&"&tdet_ccod="&q_tdet_ccod&"&sede_ccod="&q_sede_ccod&"&anos_ccod="&q_anos_ccod
				   'f_botonera.DibujaBoton"excel"  %></div></td>
				  
							 
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="69%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
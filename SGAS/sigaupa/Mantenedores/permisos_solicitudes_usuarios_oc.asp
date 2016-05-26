<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%


set errores= new CErrores

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set pagina = new cPagina
pagina.Titulo = "Permisos por tipo de solicitud"

set botonera = new CFormulario
botonera.carga_parametros "roles_compra.xml", "botonera"

rut = request.querystring("busqueda[0][pers_nrut]")
digito = request.querystring("busqueda[0][pers_xdv]")
 set f_cc = new CFormulario
f_cc.Carga_Parametros "roles_compra.xml", "roles_usuarios"
f_cc.Inicializar conexion


sql_roles= "select b.rusu_tdesc,a.rusu_ccod,pers_nrut from ocag_permisos_roles_usuarios a,ocag_roles_usuarios b where a.rusu_ccod=b.rusu_ccod and cast(pers_nrut as varchar)='"&rut&"'"

f_cc.Consultar sql_roles
'f_cc.siguiente'


 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "centro_costo_compra.xml", "busqueda_persona"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' "
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut
 f_busqueda.AgregaCampoCons "pers_xdv", digito

if  not EsVacio(rut)  then
	nombre_persona = conexion.ConsultaUno("select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_nrut as varchar)='" & rut & "'")
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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>
<script language="JavaScript">
function ingresa_cc()
{
window.open("agregar_roles_usuarios_compras.ASP?r=<%=rut%>","","left=90,top=100,width=755,height=300");
}
function Validar()
{
	formulario = document.buscador;
	
	rut_alumno = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }
	
	
	return true;
}

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');">

<table width="750" height="300" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	 
	<br>
	<form name="buscador"> 
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td>
			<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
				  <tr> 
					<td>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
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
								<td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
								<td width="210" valign="bottom" background="../imagenes/fondo1.gif"> 
								  <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador 
									</font></div></td>
								<td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
								<td width="423" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
                      <td bgcolor="#D8D8DE">
					  	<table width="100%"  border="0">
                              <tr> 
                                <td width="81%">
									<table width="100%" border="0">
										<tr> 
										  <td width="89">Rut Usuario</td>
										  <td width="10">:</td>
										  <td width="429"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
											<%f_busqueda.DibujaCampo("pers_nrut") %>
											- 
											<%f_busqueda.DibujaCampo("pers_xdv")%>
										  </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
										</tr>
									  </table>
								  </td>
                                <td width="19%"><div align="center"> 
                                    <%botonera.DibujaBoton "buscar" %>
                                  </div></td>
                              </tr>
							  <tr>
							  		<td width="81%" colspan="3">
										<table width="100%" border="0">
											<tr> 
											  <td width="43" height="23">Nombre</td>
											  <td width="11">:</td>
											  <td width="1135"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%=nombre_persona %>
											  </font></td>
										  </tr>
										 </table>
								    </td>
							  </tr>
                            </table>
					  
					   
					  </td>
                      <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                      <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                      <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
      </tr>
</table>
	 </form> 			  
	<br>
	<form name="edicion">
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
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
				<table align="center">
					<tr>
						<td>
							<%pagina.DibujarTituloPagina%>
						</td>
					</tr>
				</table>
				<br>
				<table align="center">
					<tr>
						<td width="511"><div align="right">P&aacute;ginas: 
                                    &nbsp; 
                                    <%f_cc.AccesoPagina%>
                                  </div>
						</td>
					</tr>
					<tr>
						<td>
							<%f_cc.DibujaTabla()%>
						</td>
					</tr>
				</table>
				&nbsp;
				</td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
    <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="13%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    
					<%if	EsVacio(rut) then
								botonera.agregabotonparam "agregar_cc" , "deshabilitado" , "TRUE"
							end if
						botonera.DibujaBoton"agregar_cc" %></div></td>
						<td><div align="center">
                    
					<%if	EsVacio(rut) then
								botonera.agregabotonparam "eliminar" , "deshabilitado" , "TRUE"
							end if
						botonera.DibujaBoton"eliminar" %></div></td>
					<td><div align="center">
                    
					<%botonera.DibujaBoton"salir" %></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="87%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	</form>
	<br>
	<br>
	
	<br>
	<br>
	</td>
  </tr>  
</table> 
</body>
</html>
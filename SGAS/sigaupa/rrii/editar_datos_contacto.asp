<!-- #include file = "../biblioteca/_conexion.asp" -->

<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
euco_ncorr =Request.QueryString("euco_ncorr")
daco_ncorr =Request.QueryString("daco_ncorr")


set errores = new CErrores
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Convenios Internacionales"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "convenios_rrii.xml", "botonera"


set f_ingreso = new CFormulario
f_ingreso.Carga_Parametros "convenios_rrii.xml", "agrega_contacto"
f_ingreso.Inicializar conexion

sql_descuentos="select euco_ncorr,euco_tnombre as nombre,euco_tcargo as cargo,euco_direccion as dire,euco_temail as email,euco_tfono as fono,euco_tfax as fax from encargado_universidad_convenio where cast(euco_ncorr as varchar)='"&euco_ncorr&"'"				

'response.Write(sql_descuentos)
f_ingreso.Consultar sql_descuentos
f_ingreso.siguiente


cuenta_contacto=conexion.ConsultaUno("select case count(*) when 0 then 'N' else 'S' end from encargado_universidad_convenio where cast(daco_ncorr as varchar)='"&daco_ncorr&"'")

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
function Validar()
{
	cuenta_contacto='<%=cuenta_contacto%>';
	if (cuenta_contacto=='N')
	{
		alert("Debes ingresar al menos un contacto")
		return false;
	}
	else
	{
		return true;
	}

}

function Validar_borrado(form){
mensaje="Borrar";
//alert(dcur_ncorrM);


 nro = document.ingresados.elements.length;
   num =0;
   for( i = 0; i < nro; i++ ) {
	  comp = document.ingresados.elements[i];
	  str  = document.ingresados.elements[i].name;
	  	//alert("comp"+comp);
		//alert("str="+str);
	  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo')&&(comp.value != 1)){
	  //alert(comp.name);	
		indice=extrae_indice(comp.name);
		//alert(indice);
		//alert(num);
	     num += 1;
		return true;
	  }
   }
   if( num == 0 ) {

      alert('Ud. no ha seleccionado ningún registro para Eliminar');
	return false;
   }	


}


</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');" onBlur="revisaVentana();">
<table width="750"  border="0" align="center" cellpadding="0" cellspacing="0">
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
            <td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
				    <td width="6" ><img src="../imagenes/izq2.gif" width="6" height="17"></td>
					<td valign="middle" nowrap background="../imagenes/fondo2.gif" >
					   <div align="center"><font color="#333333" face="Verdana, Arial, Helvetica, sans-serif">1)  Ubicación</font></div></td>
					<td width="6"><img src="../imagenes/der2.gif" width="6" height="17" ></td>
				  
				  
					<td width="6" ><img src="../imagenes/izq2.gif" width="6" height="17"></td>
					<td valign="middle" nowrap background="../imagenes/fondo2.gif" >
					   <div align="center"><font color="#333333" face="Verdana, Arial, Helvetica, sans-serif">2)  Datos del Convenio</font></div></td>
					<td width="6"><img src="../imagenes/der2.gif" width="6" height="17" ></td>
					
					<td width="6"><img src="../imagenes/izq_1.gif" width="6" height="17"></td>
					<td valign="middle" nowrap background="../imagenes/fondo1.gif">
					   <div align="center"><font color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif">3)  Datos Contacto </font></div></td>
					<td width="6"><img src="../imagenes/derech1.gif" width="6" height="17" ></td>
					
					<td width="6" ><img src="../imagenes/izq2.gif" width="6" height="17"></td>
					<td valign="middle" nowrap background="../imagenes/fondo2.gif">
					   <div align="center"><font color="#333333" face="Verdana, Arial, Helvetica, sans-serif">4)  Carreras en Convenio</font></div></td>
					<td width="6"><img src="../imagenes/der2.gif" width="6" height="17" ></td>
					<td width="100%" bgcolor="#D8D8DE">
				  </tr>
				</table>
			</td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
				 <form name="contacto">
				 <input type="hidden" name="b[0][daco_ncorr]" value="<%=daco_ncorr%>">
				 <input type="hidden" name="b[0][euco_ncorr]" value="<%=euco_ncorr%>">
				 	<table align="center" width="100%">
						<tr>
							<td width="4%"><strong>&nbsp;</strong></td>
					  </tr>
					</table>
					<table width="100%">
						<tr>
							<td width="12%"><strong>Nombre:</strong></td>
							<td width="88%"><%f_ingreso.DibujaCampo("nombre")%></td>
						</tr>
					</table>
					<table width="100%">
						<tr>
							<td width="12%"><strong>Cargo:</strong></td>
							<td width="88%"><%f_ingreso.DibujaCampo("cargo")%></td>
						</tr>
					</table>
					<table width="100%">
						<tr>
							<td width="12%"><strong>Dirección:</strong></td>
							<td width="88%"><%f_ingreso.DibujaCampo("dire")%></td>
						</tr>
					</table>
					<table width="100%">
						<tr>
							<td width="12%"><strong>Email:</strong></td>
							<td width="88%"><%f_ingreso.DibujaCampo("email")%></td>
						</tr>
					</table>
					<table width="100%">
						<tr>
							<td width="12%"><strong>Telefono:</strong></td>
							<td width="88%"><%f_ingreso.DibujaCampo("fono")%></td>
						</tr>
					</table>
					<table width="100%">
						<tr>
							<td width="12%"><strong>Fax:</strong></td>
							<td width="88%"><%f_ingreso.DibujaCampo("fax")%></td>
						</tr>
					</table>
					</form>
					<br>
					 
			</td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				 <td><div align="center"><% f_botonera.AgregaBotonParam "volver3", "url", "agrega_datos_contacto.asp?b%5B0%5D%5Bdaco_ncorr%5D="&daco_ncorr&""
				 							f_botonera.DibujaBoton("volver3")%></div></td>	
                  <td><div align="center"><%f_botonera.DibujaBoton"guardar_contactos2"%></div></td>
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
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
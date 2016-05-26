<!-- #include file = "../biblioteca/_conexion.asp" -->

<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'---------------------------------------------------------------------------------------------------
set errores = new CErrores

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
f_botonera.Carga_Parametros "genera_informe.xml", "botonera"



set datos = new CFormulario
datos.Carga_Parametros "genera_informe.xml", "busqueda"
datos.Inicializar conexion
sql_descuentos="select ''"	

sql_vista= "(select carr_tdesc, a.carr_ccod from carreras a,rrii_carreras_ingles b "&_
		   " where a.carr_ccod=b.carr_ccod and a.tcar_ccod=1) a "
			
datos.Consultar sql_descuentos

datos.AgregaCampoParam "carr_ccod", "destino",  sql_vista

datos.siguiente


%>

<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />

<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" src="jquery-1.6.2.min.js"></script>

<script language="JavaScript">
function verifica_periodos(valor,nombre)
{
	//alert(valor+" nombre "+ nombre )
	anos_1=document.excel.elements['b[0][anos_ccod]'].value
	anos_2=document.excel.elements['b[0][anos_ccod_fin]'].value
	
	if (anos_1 != "" && anos_2 != ""){
		if (anos_1 >anos_2 ){
			alert("No Puedes ser menor el año de inicio al de fin")			
		}
	}	
	
	if (anos_1 != "" || anos_2 != ""){
		document.excel.elements['b[0][peri_ccod]'].disabled = true
	}else{
		document.excel.elements['b[0][peri_ccod]'].disabled = false			
	}
}
function bloquearcampo(valor,nombre){
	//alert(valor+" nombre "+ nombre )
	carr=document.excel.elements['b[0][carr_ccod]'].value
	facu=document.excel.elements['b[0][facu_ccod]'].value
	
	if (carr != ""){
		document.excel.elements['b[0][facu_ccod]'].disabled = true
	}else{
		document.excel.elements['b[0][facu_ccod]'].disabled = false			
	}
	
	if (facu != ""){
		document.excel.elements['b[0][carr_ccod]'].disabled = true
	}else{
		document.excel.elements['b[0][carr_ccod]'].disabled = false			
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
        <td>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td><%pagina.DibujarLenguetas Array("Estadisticas Postulantes Extranjero"), 1 %></td>
				  </tr>
				  <tr>
					<td height="2" background="../imagenes/top_r3_c2.gif"></td>
				  </tr>
				  <tr>
					<td>
						 
						<form name="excel">
							<br>
							
							<table align="center" width="100%">
								<tr>
								  <td><strong>A&ntilde;o Intercambio:</strong></td>
								  <td><p><strong>Desde</strong>
								    <%datos.DibujaCampo("anos_ccod")%>
								    <strong>Hasta</strong>
							        <%datos.DibujaCampo("anos_ccod_fin")%>
						          </p></td>
							  </tr>
								<tr>
								  <td><strong>Periodo Acad&eacute;mico Intercambio:</strong></td>
								  
								      <td><%datos.DibujaCampo("peri_ccod")%></td>
							        
							    </tr>
								<tr>
								  <td><strong>Universidad de Procedencia:</strong></td>
								  <td><%datos.DibujaCampo("univ_ccod")%></td>
							  </tr>
								<tr>
								  <td><strong>Pais de Origen:</strong></td>
								  <td><%datos.DibujaCampo("pais_ccod")%></td>
							  </tr>
								<tr>
								  <td><strong>Facultad:</strong></td>
								  <td><%datos.DibujaCampo("facu_ccod")%></td>
							  </tr>
								<tr>
								  <td width="13%"><strong>Carrera :</strong></td>
								  <td width="23%"><%datos.DibujaCampo("carr_ccod")%></td>
							    </tr>
								
							</table>
						 </form>
					</td>
				  </tr>
        	</table>
		</td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
     <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				 <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>	
                  <td><div align="center">
					<%f_botonera.DibujaBoton"imprimir"%></div></td>
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
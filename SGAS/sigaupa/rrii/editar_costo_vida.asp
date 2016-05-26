<!-- #include file = "../biblioteca/_conexion.asp" -->


<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
pais_ccod =Request.QueryString("b[0][pais_ccod]")
ciex_ccod = Request.QueryString("b[0][ciex_ccod]")
univ_ccod =Request.QueryString("b[0][univ_ccod]")
covi_ncorr= request.QueryString("b[0][covi_ncorr]")
anos_ccod= request.QueryString("b[0][anos_ccod]")
covi_ncorr=request.QueryString("covi_ncorr")'38
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



'------------------------------------PAISES---------------------------------------------------------------
set f_pais = new CFormulario
f_pais.Carga_Parametros "convenios_rrii.xml", "editar_costo_vida"
f_pais.Inicializar conexion
sql_descuentos="select covi_ncorr,tcvi_tdesc,c.ciex_ccod,d.PAIS_CCOD,a.tcvi_ccod,"& vbCrLf &_
"anos_ccod , "& vbCrLf &_
"ciex_tdesc,"& vbCrLf &_
"pais_tdesc,"& vbCrLf &_
"covi_monto as monto,"& vbCrLf &_
"covi_comentario as comentario "& vbCrLf &_
"from costo_vida a, "& vbCrLf &_
"tipo_costo_vida b,"& vbCrLf &_
"ciudades_extranjeras c,"& vbCrLf &_
"paises d"& vbCrLf &_
"where a.tcvi_ccod=b.tcvi_ccod "& vbCrLf &_
"and a.ciex_ccod=c.ciex_ccod"& vbCrLf &_
"and c.pais_ccod=d.PAIS_CCOD"& vbCrLf &_	
"and covi_ncorr="&covi_ncorr&""	
f_pais.Consultar sql_descuentos
f_pais.Siguiente

'response.Write(sql_descuentos)




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
function cambiar_pais()
{
		document.costo_vida.elements["b[0][ciex_ccod]"].value=''
		document.costo_vida.elements["b[0][anos_ccod]"].value=''
		document.costo_vida.action ='agrega_costo_vida.asp';
		document.costo_vida.method = "get";
		document.costo_vida.submit();
	

}
function cambiar_anos()
{
		valor=document.costo_vida.elements["b[0][ciex_ccod]"].value
		
		if (valor!="")
		{
			document.costo_vida.action ='agrega_costo_vida.asp';
			document.costo_vida.method = "get";
			document.costo_vida.submit();
		}
		else
		{
			document.costo_vida.elements["b[0][anos_ccod]"].value=''
			alert('Debe Selecionar una ciudad ')

		}

}
function alcargar()
{
ciex_ccod='<%=ciex_ccod%>'
univ_ccod='<%=univ_ccod%>'
	if (ciex_ccod!="")
	{
		document.costo_vida.elements["b[0][ciex_ccod]"].value=ciex_ccod
	}
		
	//if (univ_ccod!="")
	//{
	//	document.buscador.elements["b[0][univ_ccod]"].value=univ_ccod
	//}	

}

function Validar_check(){
//mensaje="Imprimir";
//alert(dcur_ncorrM);


 nro = document.ingresados.elements.length;
 //alert(nro);
   num =0;
   for( i = 0; i < nro; i++ ) 
   {
	  comp = document.ingresados.elements[i];
	  //str  = document.mensajes.elements[i].name;
	  	//alert("comp"+comp);
		//alert("str="+str);
	  if((comp.type == 'checkbox') && (comp.checked == true))
	    {
		 // alert(comp.name);	
			 num += 1;
	    }
    }
	//alert(num)
	   if( num == 0 ) {
	
		  
		  alert('Ud. no ha seleccionado ningún Costo para Eliminar');
			return false;
	   }	
	   else if( num > 0)
	   {
			
			return true;
	   }

}
</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); alcargar();" onBlur="revisaVentana();">
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
					<td width="6" ><img src="../imagenes/izq_1.gif" width="6" height="17"></td>
					<td valign="middle" nowrap background="../imagenes/fondo1.gif" >
					   <div align="center"><font color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif">Editar Costo Vida</font></div></td>
					<td width="6"><img src="../imagenes/derech1.gif" width="6" height="17" ></td>
				  </tr>
				</table>
			</td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
				 <form name="costo_vida">
				 <input type="hidden" name="b[0][covi_ncorr]" value="<%=covi_ncorr%>">
				 <input type="hidden" name="b[0][ciex_ccod]" value="<%=f_pais.ObtenerValor("ciex_ccod")%>">
				 <input type="hidden" name="b[0][tcvi_ccod]" value="<%=f_pais.ObtenerValor("tcvi_ccod")%>">
				 <input type="hidden" name="b[0][anos_ccod]" value="<%=f_pais.ObtenerValor("anos_ccod")%>">
				 <input type="hidden" name="b[0][pais_ccod]" value="<%=f_pais.ObtenerValor("pais_ccod")%>">
				 	<table align="center" width="100%">
						<tr>
							<td width="4%"><strong>Pais:</strong></td>
						  <td width="13%"><%=f_pais.ObtenerValor("pais_tdesc")%> </td>
							<td width="7%" align="right"><strong>Ciudad:</strong></td>
							<td width="19%"><%=f_pais.ObtenerValor("ciex_tdesc")%></td>
						  <td width="22%"><strong>Periodo Acad&eacute;mico:</strong></td>
						  <td width="35%"><%=f_pais.ObtenerValor("anos_ccod")%></td>
							
					  </tr>
					</table>
					<table width="100%">
						<tr>
							<td width="5%"><strong>Tipo:</strong></td>
							<td width="95%"><%=f_pais.ObtenerValor("tcvi_tdesc")%></td>
						</tr>
					</table>
					<table width="100%">
						<tr>
							<td width="7%"><strong>Monto:</strong></td>
							<td width="93%"><%f_pais.DibujaCampo("monto")%></td>
						</tr>
					</table>
					
					<table width="100%">
						<tr>
							<td width="11%" valign="top"><strong>Comentario:</strong></td>
					      <td width="89%" valign="top"><textarea name="b[0][comentario]" id="TO-S" rows="5" cols="80"><%=f_pais.ObtenerValor("comentario")%></textarea></td>
						</tr>
					</table>
					
				  </form>

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
				 <td><div align="center"><%pais_ccod=f_pais.ObtenerValor("pais_ccod")
				 						   ciex_ccod=f_pais.ObtenerValor("ciex_ccod")
										   anos_ccod=f_pais.ObtenerValor("anos_ccod")
											 f_botonera.AgregaBotonParam "volver", "url", "agrega_costo_vida.asp?b%5B0%5D%5Bcovi_ncorr%5D=&b%5B0%5D%5Bpais_ccod%5D="&pais_ccod&"&b%5B0%5D%5Bciex_ccod%5D="&ciex_ccod&"&b%5B0%5D%5Banos_ccod%5D="&anos_ccod&"&b%5B0%5D%5Btcvi_ccod%5D=&b%5B0%5D%5Bmonto%5D=&b%5B0%5D%5Bcomentario%5D="
											 f_botonera.DibujaBoton("volver")%></div></td>	
                  <td><div align="center">
					<%f_botonera.DibujaBoton"agregar_costo_vida"%></div></td>
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
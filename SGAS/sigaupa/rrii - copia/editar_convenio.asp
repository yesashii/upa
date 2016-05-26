<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
pais_ccod=Request.QueryString("b[0][pais_ccod]")
anos_ccod=Request.QueryString("b[0][anos_ccod]")
ciex_ccod=Request.QueryString("b[0][ciex_ccod]")

'response.Write("<br>ciex_ccod="&ciex_ccod&"</br>")
buscar=Request.QueryString("buscar")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Convenios Internacionales"

set errores= new CErrores
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "convenios_rrii.xml", "botonera"
'---------------------------------------------------------------------------------------------------



'------------------------------------PAISES---------------------------------------------------------------
set f_pais = new CFormulario
f_pais.Carga_Parametros "convenios_rrii.xml", "edita_convenio"
f_pais.Inicializar conexion
f_pais.Consultar "select ''"
f_pais.Siguiente
f_pais.AgregaCampoCons "pais_ccod", pais_ccod
f_pais.AgregaCampoCons "anos_ccod", anos_ccod

'response.End()



set f_ciudades_extranjeras = new CFormulario
f_ciudades_extranjeras.Carga_Parametros "convenios_rrii.xml", "muestra_ciudad"
f_ciudades_extranjeras.Inicializar conexion

if pais_ccod<>"" then
sql_descuentos="select ciex_ccod ,ciex_tdesc , pais_ccod from ciudades_extranjeras where pais_ccod="&pais_ccod&" order by ciex_tdesc"
else
sql_descuentos="select ciex_ccod , ciex_tdesc , pais_ccod from ciudades_extranjeras where 1=2"
end if				
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&numero_total&"</pre>")
'response.Write("<pre>"&q_sfun_ccod&"</pre>")
'response.End()

f_ciudades_extranjeras.Consultar sql_descuentos



set f_universidad = new CFormulario
f_universidad.Carga_Parametros "convenios_rrii.xml", "muestra_universidad_ciudad"
f_universidad.Inicializar conexion


if ciex_ccod<>"" and pais_ccod<>"" then
sql_descuentos="select univ_tdesc,d.anos_ccod,c.ciex_ccod,d.unci_ncorr,pais_ccod,a.univ_ccod,daco_ncorr "& vbCrLf &_
"from universidades a,"& vbCrLf &_
"universidad_ciudad b,"& vbCrLf &_
"ciudades_extranjeras c, "& vbCrLf &_
"datos_convenio d "& vbCrLf &_
"where a.univ_ccod=b.univ_ccod"& vbCrLf &_
"and b.ciex_ccod=c.ciex_ccod"& vbCrLf &_
"and b.unci_ncorr=d.unci_ncorr"& vbCrLf &_
"and b.ciex_ccod="&ciex_ccod&""& vbCrLf &_
"and d.anos_ccod="&anos_ccod&""
else

sql_descuentos="select * from universidad_ciudad where 1=3"
end if

'response.Write(sql_descuentos)
f_universidad.Consultar sql_descuentos

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
function envia()
{
		document.ciudad.elements["b[0][ciex_ccod]"].value=""
		document.ciudad.action ='editar_convenio.asp';
		document.ciudad.method = "get";
		document.ciudad.submit();
}

function envia_ciudad()
{
		
		document.ciudad.action ='editar_convenio.asp';
		document.ciudad.method = "get";
		document.ciudad.submit();
}

function envia_ano()
{
pais_ccod='<%=pais_ccod%>'
ciex_ccod=document.ciudad.elements["b[0][ciex_ccod]"].value

if ((pais_ccod!='')&&(ciex_ccod!=''))
	
	{
		document.ciudad.elements["buscar"].value='S'
		document.ciudad.action ='editar_convenio.asp';
		document.ciudad.method = "get";
		document.ciudad.submit();
	}
	else
	{
		document.ciudad.elements["b[0][anos_ccod]"].value=''
		alert('Debe tener seleccionado el pais y ciudad')
	}
}

function alcargar()
{
pais_ccod='<%=pais_ccod%>'
ciex_ccod='<%=ciex_ccod%>'
	if (pais_ccod!="")
	{
		document.ciudad.elements["b[0][pais_ccod]"].value=pais_ccod
		
	}
	if (ciex_ccod!="")
	{
		document.ciudad.elements["b[0][ciex_ccod]"].value=ciex_ccod
	
	}

}

function Validar_marcaje(){
//alert(dcur_ncorrM);


 nro = document.resultado.elements.length;
   num =0;
   for( i = 0; i < nro; i++ ) {
	  comp = document.resultado.elements[i];
	  str  = document.resultado.elements[i].name;
	  	//alert("comp"+comp);
		//alert("str="+str);
	  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo')&&(comp.value != 1)){
	  //alert(comp.name);	
		indice=extrae_indice(comp.name);
		//alert(indice);
		//alert(num);
	     num += 1;
		 //alert(num);
	  }
   }
   if( num == 0 ) {

      alert('Ud. no ha seleccionado ningún Convenio');
	  return false;

   }
   else
   {
   	return true;
   }	


}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); alcargar();">
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
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
				 <form name="ciudad">
				 <input type="hidden" name="buscar" />
				 	<table align="center" width="100%">
						<tr>
							<td width="4%">Pais</td>
						  <td width="23%"><%f_pais.DibujaCampo("pais_ccod")%> </td>
							<td width="7%" align="right">Ciudad</td>
						  <td width="31%">
						  <select name="b[0][ciex_ccod]" id="TO-N" >
								<option value="">Seleccione</option>
							    <% if pais_ccod<>"" then
								   while f_ciudades_extranjeras.siguiente%>
								   
								<option value="<%=f_ciudades_extranjeras.ObtenerValor("ciex_ccod")%>"><%=f_ciudades_extranjeras.ObtenerValor("ciex_tdesc")%></option>
								 <%wend
								   end if%>
							</select> 
						  </td>
						  <td width="5%">A&ntilde;o</td>
						  <td width="30%"><%f_pais.DibujaCampo("anos_ccod")%> </td>
					  </tr>
					</table>
					 </form>
					<br>
					<br>
					<form name="resultado">
					<input type="hidden" name="b[0][pais_ccod]" value="<%=pais_ccod%>">
					<input type="hidden" name="b[0][ciex_ccod]" value="<%=ciex_ccod%>">
					<input type="hidden" name="b[0][anos_ccod]" value="<%=anos_ccod%>">
					<table align="center" width="100%">
						   <tr>
                             <td align="center"width="25%">&nbsp;</td>
							<td align="right"width="50%">P&aacute;gina:
                                 <%f_universidad.accesopagina%></td>
							<td align="center"width="25%">&nbsp;</td>
                            </tr>
						<tr>
							<td align="center"width="25%">&nbsp;</td>
							<td align="center"width="50%"><%f_universidad.Dibujatabla()%></td>
							<td align="center"width="25%">&nbsp;</td>
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
				 <td><div align="center"><%botonera.DibujaBoton("salir")%></div></td>	
                  <td><div align="center">
					<%botonera.DibujaBoton("crear_ano_siguiente")%></div></td>
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
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
pais_ccod =Request.QueryString("b[0][pais_ccod]")
ciex_ccod = Request.QueryString("b[0][ciex_ccod]")
univ_ccod =Request.QueryString("b[0][univ_ccod]")
covi_ncorr= request.QueryString("b[0][covi_ncorr]")
anos_ccod= request.QueryString("b[0][anos_ccod]")

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
f_pais.Carga_Parametros "convenios_rrii.xml", "costo_vida"
f_pais.Inicializar conexion
f_pais.Consultar "select ''"
f_pais.Siguiente
f_pais.AgregaCampoCons "pais_ccod", pais_ccod
f_pais.AgregaCampoCons "anos_ccod", anos_ccod


'------------------------------------CIUDADES EXTRANJERAS---------------------------------------------------------------
set f_ciudades_extranjeras = new CFormulario
f_ciudades_extranjeras.Carga_Parametros "convenios_rrii.xml", "ciudad_extranjera"
f_ciudades_extranjeras.Inicializar conexion

if pais_ccod<>"" then
 consulta_ciu="select ciex_ccod,ciex_tdesc from ciudades_extranjeras where pais_ccod="&pais_ccod&""
else
 consulta_ciu="select ''"
end if
f_ciudades_extranjeras.Consultar consulta_ciu


'------------------------------------UNIVERSIDADES EXTRANJERAS---------------------------------------------------------------
set f_universidades_extranjeras = new CFormulario
f_universidades_extranjeras.Carga_Parametros "convenios_rrii.xml", "universidades_extranjeras"
f_universidades_extranjeras.Inicializar conexion

if pais_ccod<>"" and ciex_ccod<>"" then
 consulta_uni="select b.univ_ccod,univ_tdesc from universidad_ciudad a, universidades b where a.univ_ccod=b.univ_ccod and ciex_ccod="&ciex_ccod&""
else
 consulta_uni="select ''"
end if
f_universidades_extranjeras.Consultar consulta_uni



'------------------------------------Tipos de Costos EXTRANJERAS---------------------------------------------------------------
set f_tipos_costos = new CFormulario
f_tipos_costos.Carga_Parametros "convenios_rrii.xml", "tipos_costos"
f_tipos_costos.Inicializar conexion

 consulta_costos="select tcvi_ccod,tcvi_tdesc from tipo_costo_vida where tcvi_ccod not in ( select tcvi_ccod from costo_vida where cast(anos_ccod as varchar)='"&anos_ccod&"' and  cast(ciex_ccod as varchar)='"&ciex_ccod&"')"
f_tipos_costos.Consultar consulta_costos

if anos_ccod<>""  and pais_ccod<>"" and  ciex_ccod<>"" then

set f_costos = new CFormulario
f_costos.Carga_Parametros "convenios_rrii.xml", "muestra_costo_vida"
f_costos.Inicializar conexion

sql_descuentos="select covi_ncorr,tcvi_tdesc,anos_ccod , covi_monto as monto,covi_comentario as comentario from costo_vida a, "& vbCrLf &_
"tipo_costo_vida b"& vbCrLf &_
"where a.tcvi_ccod=b.tcvi_ccod "& vbCrLf &_
"and ciex_ccod="&ciex_ccod&""& vbCrLf &_
"and anos_ccod="&anos_ccod&""				
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&numero_total&"</pre>")
'response.Write("<pre>"&q_sfun_ccod&"</pre>")
'response.End()

f_costos.Consultar sql_descuentos
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
					   <div align="center"><font color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif">Agregar Costo Vida</font></div></td>
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
				 	<table align="center" width="100%">
						<tr>
							<td width="4%"><strong>Pais:</strong></td>
						  <td width="13%"><%f_pais.DibujaCampo("pais_ccod")%> </td>
							<td width="7%" align="right"><strong>Ciudad:</strong></td>
							<td width="19%">
								<select name="b[0][ciex_ccod]" id="TO-N">
								<option value="">Todas</option>
						   <% if pais_ccod<>"" then
						  	while f_ciudades_extranjeras.siguiente%>
						  	<option value="<%=f_ciudades_extranjeras.ObtenerValor("ciex_ccod")%>"><%=f_ciudades_extranjeras.ObtenerValor("ciex_tdesc")%></option>
						  	<%wend
						     end if%>
								</select>
						  </td>
						  <td width="22%"><strong>Periodo Acad&eacute;mico:</strong></td>
						  <td width="35%"><%f_pais.DibujaCampo("anos_ccod")%></td>
							
					  </tr>
					</table>
					<table width="100%">
						<tr>
							<td width="5%"><strong>Tipo:</strong></td>
							<td width="95%"><select name="b[0][tcvi_ccod]" id="TO-N">
								<option value="">Selecione</option>
						   <% while f_tipos_costos.siguiente%>
						  	<option value="<%=f_tipos_costos.ObtenerValor("tcvi_ccod")%>"><%=f_tipos_costos.ObtenerValor("tcvi_tdesc")%></option>
						  	<%wend%>
								</select></td>
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
					      <td width="89%" valign="top"><textarea name="b[0][comentario]" id="TO-S" rows="5" cols="80"></textarea></td>
						</tr>
					</table>
					
				  </form>
				  
				  <% if anos_ccod<>""  and pais_ccod<>"" and  ciex_ccod<>"" then%>
				  <form name="ingresados">
				  <input type="hidden" name="b[0][pais_ccod]" value="<%=pais_ccod%>">
				  <input type="hidden" name="b[0][ciex_ccod]" value="<%=ciex_ccod%>">
				  <input type="hidden" name="b[0][anos_ccod]" value="<%=anos_ccod%>">
				  <table width="100%">
						<tr>
							<td width="16%" align="center"></td>
							<td width="60%" align="center"><strong>Costos Ingresados </strong></td>
							<td width="24%" align="center"></td>
							
						</tr>
						<tr>
                             <td align="center"width="16%">&nbsp;</td>
							<td align="right"width="60%">P&aacute;gina:
                                 <%f_costos.accesopagina%></td>
							<td align="center"width="24%">&nbsp;</td>
                    </tr>
						<tr>
							<td width="16%" align="center"></td>
							<td width="60%" align="center"><%f_costos.DibujaTabla()%></td>
							<td width="24%" align="center"></td>
						</tr>
						<tr>
							<td width="16%" align="center"></td>
							<td width="60%" align="left"><%f_botonera.DibujaBoton"elimina_costo"  %></td>
							<td width="24%" align="center"></td>
						</tr>
					</table>
					</form>
					<%end if%>
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
				 <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>	
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
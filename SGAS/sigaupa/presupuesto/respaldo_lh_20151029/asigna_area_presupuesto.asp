<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
v_area_ccod = 	Request.QueryString("busca[0][area_ccod]")
q_pers_xdv 	= 	Request.QueryString("busca[0][pers_xdv]")
q_pers_nrut	= 	Request.QueryString("busca[0][pers_nrut]")

set pagina = new CPagina
pagina.Titulo = "Asignar Area Presupuestal"

set errores = new CErrores

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "asigna_area_presupuesto.xml", "botonera"


'--------------------------------------------fin seleccion combos carreras--------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "asigna_area_presupuesto.xml", "busqueda"
f_busqueda.Inicializar conexion2
f_busqueda.Consultar "Select ''"
f_busqueda.siguienteF

 f_busqueda.AgregaCampoCons "area_ccod", v_area_ccod 
 f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut 
 f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv

if v_area_ccod<>"" then
	sql_area="and a.area_ccod="&v_area_ccod
end if

if q_pers_nrut<>"" then
	sql_rut="and a.rut_usuario="&q_pers_nrut
end if

set f_areas = new CFormulario
f_areas.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_areas.Inicializar conexion2

if Request.QueryString <> "" then				
sql_areas	=	"select * from presupuesto_upa.protic.area_presupuesto_usuario a ,presupuesto_upa.protic.area_presupuestal b  " & vbCrLf &_
				" where a.area_ccod=b.area_ccod   " & vbCrLf &_
				" "&sql_rut&"  " & vbCrLf &_
				" "&sql_area&" "
else
	sql_areas="select '' "
end if

f_areas.consultar sql_areas

'f_busqueda.Siguiente
'response.End()

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

function enviar(formulario)
{
	
	formulario = document.buscador;

	rut_alumno = formulario.elements["busca[0][pers_nrut]"].value + "-" + formulario.elements["busca[0][pers_xdv]"].value;	
	if (formulario.elements["busca[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busca[0][pers_xdv]"].focus();
		formulario.elements["busca[0][pers_xdv]"].select();
		return false;
	  }

	document.buscador.method="get";
	document.buscador.action="asigna_area_presupuesto.asp";
	document.buscador.submit();
}


function nuevo_centro_costo(){
	v_url="asigna_area_presupuesto_agregar.asp";	
	window.open(v_url,"asigna_nueva_area","resizable,width=600,height=300");
	//return false;
}


function editar(rut,area){
	v_url="asigna_area_presupuesto_agregar.asp?opcion=2&cod_area="+area+"&rut="+rut;	
	window.open(v_url,"asigna_nueva_area","resizable,width=600,height=300");
	//return false;
}

function eliminar(rut,area){
	if(confirm("¿Esta realmente seguro de quitar estos permisos?")){
		v_url="proc_asignar_area_presupuesto.asp?opcion=3&area_origen="+area+"&rut_origen="+rut;	
		window.open(v_url,"asigna_nueva_area","resizable,width=600,height=300");
	}
}

function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="97%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
			  
			  <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
				  <tr>
                    <td>
                          <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0" bordercolor='#999999' >
                            	<tr bgcolor='#C4D7FF' bordercolor='#999999'> 
                              		<td width="51%"><div align="center"><strong>Por Rut</strong></div></td>
                              		<td width="49%"><div align="center"><strong>Por Area Presupuestaria</strong></div></td>
								  	<td></td>
                            	</tr>
                            <tr > 
                              <td > 
                                	<table width="99%"   cellspacing="0" cellpadding="0"  >
                               		  <tr> 
										<td width="75"><div align="left"><strong>Rut Usuario </strong></div></td>
									    <td width="10"><div align="center">:</div></td>
										<td width="261"><%f_busqueda.DibujaCampo("pers_nrut")%>-<%f_busqueda.DibujaCampo("pers_xdv")%></td>
                               		  </tr>
                                	</table>                              
								</td>
                              <td > 
								  <table width="98%" height="98%" >
								  <tr>
									<td><%f_busqueda.DibujaCampo("area_ccod")%></td>
								  </tr>
								  </table>                              
							  </td>
							  <td><%f_botonera.DibujaBoton("buscar2")%></td>
                            </tr>
                          </table>
					</td>
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
	<table width="97%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
			  <table width="99%"  border="0" cellspacing="0" cellpadding="0" >
                  <tr>
				  		<td><%pagina.DibujarSubtitulo "Areas asociadas"%></td>
				  </tr>
				  <tr>
				  		<td><br/><br/>
							<table width="95%" border="1" align="center" >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'>
 										<th width="9%">ACCION</th> 
									  	<th width="16%">RUT</th>
								  	  <th width="33%">ENCARGADO</th>
								  	  <th width="6%">COD </th>
								  	  <th width="36%">AREA</th>
									</tr>
									<%
									if Request.QueryString <> "" then	
									while f_areas.Siguiente
									v_rut		=	f_areas.ObtenerValor("rut_usuario")
									cod_area	=	f_areas.ObtenerValor("area_ccod")
									
									sql_encargado	=	"select protic.obtener_nombre_completo(pers_ncorr,'n') as encargado from personas where pers_nrut="&v_rut
									encargado		= 	conexion.consultaUno(sql_encargado)
									
									sql_rut_encargado	=	"select protic.obtener_rut(pers_ncorr) as rut from personas where pers_nrut="&v_rut
									rut_encargado		= 	conexion.consultaUno(sql_rut_encargado)
									
									%>
									<tr bordercolor='#999999'>	
										<td><a href="javascript:eliminar(<%=v_rut%>,<%=cod_area%>);"><font style="font-size:9px">[borrar]</font></a><br><a href="javascript:editar(<%=v_rut%>,<%=cod_area%>);"><font style="font-size:9px">[editar]</font></a></td>
									  	<td><%=rut_encargado%></td>
									  	<td><%=encargado%></td>
									  	<td><%=f_areas.ObtenerValor("area_ccod")%></td>
									  	<td><%=f_areas.ObtenerValor("area_tdesc")%></td>
									</tr>
									 <%wend 
									 else%>
									 <td colspan="5"><center>No se registras parametros para busqueda</center></td>
									 <%end if
									 %>
								 </table>
						
						</td>
				  </tr>
				  <tr>
				  <td><p><br></p></td>
				  </tr>
				 </table> 
            </form></td></tr>
        </table>
		</td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="9%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
					<td><div align="left"><%f_botonera.DibujaBoton("nuevo")%></div></td>
                  	<td><div align="left"><%f_botonera.DibujaBoton("salir")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="71%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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

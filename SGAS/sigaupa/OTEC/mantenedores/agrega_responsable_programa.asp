<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
UDPO_ccod= request.QueryString("a[0][UDPO_ccod]")
anos_ccod= request.QueryString("a[0][anos_ccod]")
dgso_ncorr=request.QueryString("a[0][dgso_ncorr]")

set pagina = new CPagina
pagina.Titulo = "Agregar Responsable Programa"

set botonera =  new CFormulario
botonera.carga_parametros "responsable_programa.xml", "btn_edita_modulos"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
periodo = negocio.obtenerPeriodoAcademico("Postulacion")
'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros  "responsable_programa.xml", "listado_responsable"
formulario.inicializar conexion


if  UDPO_ccod<>"" and anos_ccod<>"" then

consulta="select a.dcur_tdesc,b.dgso_ncorr" & vbCrlf & _
"from diplomados_cursos a," & vbCrlf & _
"datos_generales_secciones_otec b," & vbCrlf & _
"ofertas_otec c" & vbCrlf & _
"where a.dcur_ncorr=b.dcur_ncorr" & vbCrlf & _
"and b.dgso_ncorr=c.dgso_ncorr" & vbCrlf & _
"and c.udpo_ccod="&udpo_ccod&"" & vbCrlf & _
"and c.anio_admision="&anos_ccod&"" & vbCrlf & _
"group by a.dcur_tdesc,b.dgso_ncorr"
 
else
 consulta="select ''"
end if
formulario.consultar consulta  


set formulario2 = new cformulario
formulario2.carga_parametros   "tabla_vacia.xml", "tabla"
formulario2.inicializar conexion


if  UDPO_ccod<>"" and anos_ccod<>"" and dgso_ncorr<>"" then

consulta="select bb.reun_ncorr, pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre from  responsable_unidad bb, personas cc" & vbCrlf & _
"where bb.pers_ncorr=cc.PERS_NCORR" & vbCrlf & _
"and bb.udpo_ccod="&UDPO_ccod&"" & vbCrlf & _
"and esre_ccod=1" & vbCrlf & _
"order by nombre"
 
else
 consulta="select ''"
end if
'response.Write(consulta)
formulario2.consultar consulta  



set f_busqueda = new cformulario
f_busqueda.carga_parametros "responsable_programa.xml", "agrega"
f_busqueda.inicializar conexion

consulta= "SELECT '' " 

'response.write("<pre>"&consulta&"</pre>")
f_busqueda.consultar consulta 

f_busqueda.siguiente
f_busqueda.AgregaCampoCons "udpo_ccod", udpo_ccod
f_busqueda.AgregaCampoCons "anos_ccod", anos_ccod
'response.Write("doras "&horas_Asignatura&" duracion "&duracion_asignatura)
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
function guardar(formulario){

if(preValidaFormulario(formulario))
    {	
    	formulario.action ='actualizar_modulos.asp';
		formulario.submit();
	}
	
}
function volver(){
	CerrarActualizar();
}

function validaCambios(){
	alert("..");
	return false;
}
function cambiar()
{
unidad=document.buscador.elements["a[0][UDPO_ccod]"].value


	if (unidad!='')
	{
		document.buscador.action ='agrega_responsable_programa.asp';
		document.buscador.method = "get";
		document.buscador.submit();
	
	}
	else
	{
		//document.buscador.elements["a[0][anos_ccod]"].value=''
		alert('Debes Seleccionar una Unidad primero')
	}

}
function cambiar2()
{

		document.buscador.action ='agrega_responsable_programa.asp';
		document.buscador.method = "get";
		document.buscador.submit();
	

}
function marca_programa()
{
udpo='<%=udpo_ccod%>'
anos='<%=anos_ccod%>'
dgso_ncorr='<%=dgso_ncorr%>'
	if ((udpo!='')&&(anos!=''))
	{
	//alert('jajaja')
	//document.buscador.elements["a[0][dgso_ncorr]"].selectedIndex=2
	document.buscador.elements["a[0][dgso_ncorr]"].value=dgso_ncorr
	}
}
</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); marca_programa();" onBlur="revisaVentana();">
<table width="380" border="0" align="center" cellpadding="0" cellspacing="0" >
  <tr valign="middle">
    <td valign="top" bgcolor="#EAEAEA">
		<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
		  <tr>
			<td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
			<td height="8" background="../imagenes/top_r1_c2.gif"></td>
			<td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
		  </tr>
		  <tr>
			<td width="9" background="../imagenes/izq.gif">&nbsp;</td>
			<td>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td height="2" background="../imagenes/top_r3_c2.gif"></td>
					  </tr>
					  <tr>
						<td>
				<table width="100%"  border="0">
					  <tr>
						<td>&nbsp;</td>
					  </tr>
					  <tr>
						<td><%pagina.DibujarSubtitulo "Ingresar Unidad"%></td>
					  </tr>
					  <tr>
						<td>&nbsp;</td>
					  </tr>
				 </table>
	
				 <form name="buscador" >
				 <table width="100%">
				 
				 	<tr>
						<td align="right" width="16%">Unidad</td>
						<td width="84%"><%f_busqueda.DibujaCampo("UDPO_ccod")%></td>
					</tr>
					<tr>
						<td align="right" width="16%">Año</td>
						<td width="84%"><%f_busqueda.DibujaCampo("anos_ccod")%></td>
					</tr>
					
					<tr>
						<td width="16%" align="right">Programas</td>
						<td width="84%"><select name="a[0][dgso_ncorr]" id="TO-N" onChange="cambiar2()">
						  <option value="">Seleccione</option>
						  <% if udpo_ccod<>"" and anos_ccod<>"" then%>
						  	<%while formulario.siguiente%>
						  	<option value="<%=formulario.ObtenerValor("dgso_ncorr")%>"><%=formulario.ObtenerValor("dcur_tdesc")%></option>
						  	<%wend%>
						  <%end if%>
					      </select>
					    </td>
					</tr>
					<tr>
						<td width="16%" align="right">Responsables</td>
						<td width="84%"><select name="a[0][reun_ncorr]" id="TO-N">
						  <option value="">Seleccione</option>
						  <% if udpo_ccod<>"" and anos_ccod<>"" then%>
						  	<%while formulario2.siguiente%>
						  	<option value="<%=formulario2.ObtenerValor("reun_ncorr")%>"><%=formulario2.ObtenerValor("nombre")%></option>
						  	<%wend%>
						  <%end if%>
					      </select>
					    </td>
					</tr>
					<tr>
						<td colspan="2" align="right">
							<table width="100%">
								<tr>
									<td width="74%">&nbsp;</td>
									<td width="26%">&nbsp;</td>
								</tr>
							</table>
						</td>
					</tr>
				 </table>
				 </form>
							  
				
				</td>
			</tr>
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
					  <td><div align="center"><%botonera.dibujaboton "volver1"%></div></td>
					  <td><div align="center"><%botonera.dibujaboton "guardar1"%></div></td>
					  <td><div align="center"></div></td>
					</tr>
				  </table>
				</div></td>
				<td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
				</tr>
			  <tr>
				<td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
			  </tr>
			</table></td>
			<td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
		  </tr>
		</table>
	</td>
  </tr>  
</table>
</body>
</html>

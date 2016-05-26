<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Activación de contratos"
'-----------------------------------------------------------------------

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set cajero = new CCajero
cajero.inicializar conexion, negocio.obtenerUsuario, negocio.obtenerSede

if not cajero.tienecajaabierta then
  conexion.MensajeError "No puede activar un contrato sin tener una caja abierta"
  response.Redirect("../lanzadera/lanzadera.asp") 
end if

set errores = new CErrores
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Activar_Contrato.xml", "botonera"
'-----------------------------------------------------------------------
 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 accion = request.querystring("accion")
 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "Activar_Contrato.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
 f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
'--------------------------------------------------------------------
set f_contrato2 = new CFormulario
f_contrato2.Carga_Parametros "Activar_Contrato.xml", "f_contratos"
f_contrato2.Inicializar conexion
'--------------------------------------------------------------------
set f_contrato = new CFormulario
f_contrato.Carga_Parametros "Activar_Contrato.xml", "f_contratos"
f_contrato.Inicializar conexion


consulta = "select a.cont_ncorr, a.cont_ncorr as c_cont_ncorr,protic.obtener_nombre_carrera(b.ofer_ncorr,'CJ') as carrera," & vbCrLf &_
			"    convert(varchar,a.cont_fcontrato,103) as cont_fcontrato, a.post_ncorr," & vbCrLf &_
			"    b.pers_ncorr, c.pers_nrut, c.pers_xdv, " & vbCrLf &_
			"    cast(c.pers_nrut as varchar) + '-' +  c.pers_xdv as rut_alumno," & vbCrLf &_
			"    c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO  + ' ' + c.pers_tnombre as nombre_alumno, " & vbCrLf &_
			"    a.peri_ccod, a.econ_ccod, d.econ_tdesc " & vbCrLf &_
			" from contratos a,postulantes b,personas_postulante c,estados_contrato d" & vbCrLf &_
			" where a.post_ncorr = b.post_ncorr" & vbCrLf &_
			"    and b.pers_ncorr = c.pers_ncorr" & vbCrLf &_
			"    and a.econ_ccod = d.econ_ccod" & vbCrLf &_
			"    and a.peri_ccod = '" & Periodo & "'" & vbCrLf &_
			"    and a.econ_ccod <> 3" & vbCrLf &_
			"    and cast(c.pers_nrut as varchar) = isnull('" & rut_alumno & "', '0')"& vbCrLf &_
			" order by a.cont_ncorr desc "
			
'response.Write("<pre>"&consulta&"</pre>")		

if not Esvacio(Request.QueryString) then
		'response.Write("entre")
 	  f_contrato.Consultar consulta
	  f_contrato2.Consultar consulta
	  f_contrato2.siguiente
	  estado =  f_contrato2.obtenervalor("econ_ccod")
	  contrato =  f_contrato2.obtenervalor("cont_ncorr")	  
 else
 	'response.Write("entre2")
	 f_contrato.Consultar "select '' where 1=2"
	 'f_contrato2.Consultar "select '' "
	 f_contrato.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
	 estado = ""	 
 end if

'set persona = new CPersona
'persona.inicializar conexion, rut_alumno

'post_ncorr = persona.ObtenerPostncorr (Periodo)

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
function inicio()
{
formulario = document.edicion;
cantidad_contratos = <%=f_contrato.NroFilas()%>;
for	(i=0; i< cantidad_contratos; i++)
	{
	if 	(formulario.elements["contratos["+i+"][econ_ccod]"].value == '1')
		{
		formulario.elements["contratos["+i+"][cont_ncorr]"].visibled = false;
		}
	}
//contratos[1][cont_ncorr]
}
function Activar()
{
form = document.edicion;
nro = form.elements.length;
centinela = false;
valor = uno_seleccionado(form);
if	(valor == 1)// se selecciono uno
	{
	for	( i = 0; i < nro; i++ ) 
		{
		comp = form.elements[i];
		str  = form.elements[i].name;
		if	((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo'))
			{
		  	//	alert(str);
			indice=extrae_indice(str);
			 //alert("Indice:"+indice);
			v_estado=form.elements["contratos["+indice+"][econ_ccod]"].value;
			if	((v_estado==2)) // estado del contrato debe ser pendiente
				{ 
				centinela = true;
				}	
		  	}
		}
	if	(centinela== false)
		{
		alert("Debe seleccionar un contrato con estado pendiente.");
		return false;	
		}
	else
		if 	(confirm('¿Está seguro que desea activar este contrato?')) 
			 return true;
		else 
		   	 return false;	
	}
else	
	{
	alert('Ud. no ha seleccionado registro o selecciono más de uno, debe seleccionar sólo un registro.');
	return false;
	}
}
function ValidarVerFP()
{
//alert("aca voy")
form = document.edicion;
nro = form.elements.length;
valor = uno_seleccionado(form);
if	(valor == 1)// se selecciono uno
	{
	for	( i = 0; i < nro; i++ ) 
		{
		comp = form.elements[i];
		str  = form.elements[i].name;
		if	((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo'))
			{
		  	//	alert(str);
			indice=extrae_indice(str);
			 //alert("Indice:"+indice);
			v_estado=form.elements["contratos["+indice+"][econ_ccod]"].value;
			//if	((v_estado==1)) // estado del contrato debe ser activo
				//{ 
				cont_ncorr = form.elements["contratos["+indice+"][cont_ncorr]"].value;
				//return true;
				pagina = "ver_forma_pago.asp?cont_ncorr=" +cont_ncorr;
				resultado = open(pagina,'wAgregar','width=800px, height=500px, scrollbars=yes, resizable=yes');
				resultado.focus();
				return false;
				//}	
		  	}
		}
	//alert("Opción de impresión sólo para contratos activos.");	
	//return false;	
	}
else	
	{
	alert('Ud. no ha seleccionado registro o selecciono más de uno, debe seleccionar sólo un registro.');
	return false;
	}
//alert("Opción de impresión sólo para contratos activos.");	
return false;	
}
function ValidarImpresion()
{
form = document.edicion;
nro = form.elements.length;
valor = uno_seleccionado(form);
if	(valor == 1)// se selecciono uno
	{
	for	( i = 0; i < nro; i++ ) 
		{
		comp = form.elements[i];
		str  = form.elements[i].name;
		if	((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo'))
			{
		  	//	alert(str);
			indice=extrae_indice(str);
			 //alert("Indice:"+indice);
			v_estado=form.elements["contratos["+indice+"][econ_ccod]"].value;
			if	((v_estado==1)) // estado del contrato debe ser activo
				{ 
				cont_ncorr = form.elements["contratos["+indice+"][cont_ncorr]"].value;
				//return true;
				pagina = "../REPORTESNET/Comprobante.aspx?contrato=" +cont_ncorr+"&periodo="+<%=Periodo%>;
				resultado = open(pagina,'wAgregar','width=800px, height=600px, scrollbars=yes, resizable=yes');
				resultado.focus();
				return false;
				}	
		  	}
		}
	alert("Opción de impresión sólo para contratos activos.");	
	return false;	
	}
else	
	{
	alert('Ud. no ha seleccionado registro o selecciono más de uno, debe seleccionar sólo un registro.');
	return false;
	}
//alert("Opción de impresión sólo para contratos activos.");	
return false;	
}
function uno_seleccionado(form){
	  	nro = form.elements.length;
   		num =0;
	   for( i = 0; i < nro; i++ ) {
		  comp = form.elements[i];
		  str  = form.elements[i].name;
		  
		  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo')){
	 		num += 1;
		  }
	   }
	   return num;
 }

</script>

<script language="JavaScript">
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



<style type="text/css">
<!--
.style4 {
	color: #42424A;
	font-weight: bold;
}
.style8 {font-size: 18px}
-->
</style>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
            <tr>
              <td width="9"><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="100%" height="1" border="0" alt=""></td>
              <td width="7"><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
            <tr>
              <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td width="9"><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><%pagina.DibujarLenguetas Array("Búsqueda de contratos para activar"), 1 %></td>
              <td width="7"><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>              
            </tr>
            <tr>
              <td width="9"><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
              <td width="7"><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
				<form name="buscador">
                  <table width="98%"  border="0">
                    <tr>
                      <td width="81%"><div align="center">
                        <table width="50%"  border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td width="37%">R.U.T. Alumno : </td>
                                  <td width="57%"> 
                                    <% f_busqueda.DibujaCampo ("pers_nrut") %>
                                    - <% f_busqueda.DibujaCampo ("pers_xdv") %>
									<a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a>
									</td>
                          </tr>
                        </table>
                      </div></td>
                      <td width="19%"><div align="center"><% botonera.DibujaBoton ("buscar") %></div></td>
                    </tr>
                  </table>
				</form>
                </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="100%" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
      </tr>
    </table>	
	<br>		
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="100%" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>			  
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td bgcolor="#D8D8DE">
				<%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %>				
				</td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>			 
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
&nbsp;<div align="center"><%pagina.DibujarTituloPagina%></div>
<form name="edicion">
					<%pagina.DibujarSubtitulo "Contratos"%><br>
					<% f_contrato.DibujaTabla() %>
                  </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="198" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="20%">
                        <%
					   'if estado = "" then
					   if	f_contrato.NroFilas = 0 then
							botonera.agregabotonparam "pagos", "deshabilitado" ,"TRUE"							   
					   end if
					    'botonera.AgregaBotonUrlParam "pagos", "cont_ncorr", contrato			   
						botonera.DibujaBoton ("pagos")
					   %>
                      </td>
                      <td width="20%"> <div align="left"> 
                          <%
					   'if estado = "1" or estado = "" then
					   if	f_contrato.NroFilas = 0 then
							   botonera.agregabotonparam "activar", "deshabilitado" ,"TRUE"			   
					   end if
					    botonera.DibujaBoton ("activar")
					   %>
                        </div></td>
                      <td width="31%"> <div align="left"> 
                          <%
					   'if estado = "2" or estado = "" then
					   if	f_contrato.NroFilas = 0 then
							botonera.agregabotonparam "imprimir", "deshabilitado" ,"TRUE"						   
					   end if
					   'botonera.agregabotonparam "imprimir", "url" ,"../REPORTESNET/Comprobante.aspx?contrato=" & contrato & "&periodo=" & Periodo
					   botonera.DibujaBoton ("imprimir") 
					   %>
                        </div></td>
                      <td width="49%"> <div align="left"> 
                          <%botonera.DibujaBoton ("salir")%>
                        </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="157" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="311" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>			
		  </td>
        </tr>
      </table>	
   <p>&nbsp;</p></td>
  </tr>  
</table>
</body>
</html>

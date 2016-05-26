<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
folio_envio = Request.QueryString("folio_envio")
set pagina = new CPagina

q_regi_ccod_colegio = Request.QueryString("envio[0][regi_ccod_colegio]")
q_ciud_ccod_colegio = Request.QueryString("envio[0][ciud_ccod_colegio]")


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'---------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "eventos_upa.xml", "botonera"
'---------------------------------------------------------------------------------------------------

set formulario = new CFormulario
formulario.Carga_Parametros "eventos_upa.xml", "f_nuevo"
formulario.Inicializar conexion
if folio_envio = "NUEVO" then
  consulta = "select '' "
end if

formulario.Consultar consulta
formulario.Siguiente

if not EsVacio(q_regi_ccod_colegio) then
	formulario.AgregaCampoCons "regi_ccod_colegio", q_regi_ccod_colegio
	formulario.AgregaCampoCons "ciud_ccod_colegio", q_ciud_ccod_colegio
	formulario.AgregaCampoParam "cole_ccod", "filtro", "ciud_ccod = '" & q_ciud_ccod_colegio & "'"
else
'response.Write(f_antecedentes.ObtenerValor("ciud_ccod_colegio"))
	formulario.AgregaCampoParam "cole_ccod", "filtro", "ciud_ccod = '1'"
end if



'formulario.AgregaCampoCons "envi_fenvio", v_fecha





%>


<html>
<head>
<title>Nuevo Evento Upa</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">


<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" src="../biblioteca/dicc_ciudades.js"></script>



<script language="JavaScript" type="text/JavaScript">


function LimpiarComboColegios()
{
	o_cole_ccod = document.edicion.elements["envio[0][cole_ccod]"];
	
	o_cole_ccod.length = 0;
	o_cole_ccod.add (new Option("Seleccionar colegio", ""));
}

function RecargarColegios()
{	
	
	navigate("ingreso_evento_nuevo.asp?folio_envio=NUEVO&envio[0][regi_ccod_colegio]=" +document.edicion.elements["envio[0][regi_ccod_colegio]"].value + "&envio[0][ciud_ccod_colegio]=" + document.edicion.elements["envio[0][ciud_ccod_colegio]"].value);
	
}

function InicioPagina()
{
	_FiltrarCombobox(document.edicion.elements["envio[0][ciud_ccod_colegio]"], 
	                 document.edicion.elements["envio[0][regi_ccod_colegio]"].value,
					 d_ciudades,
					 'regi_ccod',
					 'ciud_ccod',
					 'ciud_tdesc',
					 '<%=formulario.ObtenerValor("ciud_ccod_colegio")%>',
					 'Seleccionar ciudad');					 
}

function habilita_otro_colegio(objeto){
	//alert(objeto.checked);
	if(objeto.checked){
		document.edicion.elements["envio[0][otro_tdesc]"].disabled=false;
		document.edicion.elements["envio[0][cole_ccod]"].disabled=true;

	}else{
		document.edicion.elements["envio[0][otro_tdesc]"].disabled=true;
		document.edicion.elements["envio[0][cole_ccod]"].disabled=false;

	}
	
}


function valida_tipo_evento(tipo_evento){
//alert("Valor"+tipo_evento);
	if(tipo_evento=="8"){
		document.edicion.elements["envio[0][regi_ccod_colegio]"].disabled=true;
		document.edicion.elements["envio[0][ciud_ccod_colegio]"].disabled=true;
		document.edicion.elements["envio[0][cole_ccod]"].disabled=true;
		document.edicion.perfil[0].disabled = true;
		document.edicion.perfil[1].disabled = true;
		document.edicion.elements["habilita_cole"].disabled=true;
		
	}else{
		document.edicion.elements["envio[0][regi_ccod_colegio]"].disabled=false;
		document.edicion.elements["envio[0][ciud_ccod_colegio]"].disabled=false;
		document.edicion.elements["envio[0][cole_ccod]"].disabled=false;
		document.edicion.perfil[0].disabled = false;
		document.edicion.perfil[1].disabled = false;
		document.edicion.elements["habilita_cole"].disabled=false;
	}
	
}

function ValidaPerfil(){
	v_tipo_evento=document.edicion.elements["envio[0][teve_ccod]"].value;

	/*alert("Perfil 0 : "+document.edicion.perfil[1].checked);
	alert("Perfil 1 : "+document.edicion.perfil[0].checked);
	alert("Tipo Evento "+v_tipo_evento);*/

	if(v_tipo_evento!=8){
		if((!document.edicion.perfil[0].checked)&&(!document.edicion.perfil[1].checked)){
			alert("Debe seleccionar un perfil para el evento seleccionado");
			return false;
		}
	}
return true;
}

</script>


</head>
<body  bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="InicioPagina();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="100%" valign="top" bgcolor="#EAEAEA">
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="400" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td background="../imagenes/top_r1_c2.gif"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Nuevo
                          Evento</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td ><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td background="../imagenes/top_r3_c2.gif"></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bordercolor="#FFFFFF" bgcolor="#D8D8DE">
				    
				    <BR>
		            <form name="edicion">
					<center><strong>Perfil del Colegio</strong>
					<div align="center"  class="tabactivo" style=" width:400px; border:1px solid blue; color: #0000FF; margin:'margin-right:-20px;'">
					
					<input type="radio" name="perfil" value="1">Santiago&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="radio" name="perfil" value="2">Melipilla					</div>
					(marcar solo para las fichas, <b>NO</b> para Atención Oficina Upa)
					</center>
				    <br>
					<br>
					<table width="100%" border="0" >
						<tr>
							<td colspan="3">
								<table  style="border:1px solid gray; background-color:#C5C5C5">
								<tr>
								<th colspan="3" >Informacion del Colegio</th>
								</tr>
									<tr> 
										<td width="216" valign="top" ><strong><font color="#FF0000">*</font>Region Colegio</strong></td>
										<td width="10"><div align="left"><strong>:</strong></div></td>
										<td><%formulario.DibujaCampo("regi_ccod_colegio")%></td>
									</tr>
									<tr>
										<td width="216" valign="top" ><strong><font color="#FF0000">*</font>Comuna Colegio</strong></td>
										<td width="10"><div align="left"><strong>:</strong></div></td>	
										<td width="555"> <%formulario.DibujaCampo("ciud_ccod_colegio")%></td>
									</tr>
									<tr> 
										<td width="216" valign="top" ><strong><font color="#FF0000">*</font>Nombre Colegio</strong></td>
										<td width="10"><div align="left"><strong>:</strong></div></td>
										<td><%formulario.DibujaCampo("cole_ccod")%></td>
									</tr>
									<tr> 
										<td><strong>Otro Colegio </strong></td>
										<td><div align="left"><strong>:</strong></div></td>
										<td><input type="checkbox" name="habilita_cole" onClick="habilita_otro_colegio(this);"> <% formulario.DibujaCampo ("otro_tdesc")%> </td>
									</tr>
							  </table>
							</td>
						</tr>
					 <tr>
							<td><strong><font color="#FF0000">*</font>Tipo evento </strong></td>
							<td><div align="left"><strong>:</strong></div></td>
							<td><% formulario.DibujaCampo("teve_ccod")%></td>
                      	</tr>
<!--
					 	<tr>
							<td><strong><font color="#FF0000">*</font>Nombre Evento </strong></td>
							<td><div align="left"><strong>:</strong></div></td>
							<td><% formulario.DibujaCampo("even_tnombre")%></td>
                      	</tr>
-->
					  	<tr>
                          <td width="216"><strong><font color="#FF0000">*</font>Comuna Evento </strong></td>
                          <td width="10"><strong>:</strong></td>
                          <td width="555"><% formulario.DibujaCampo("ciud_ccod_origen")%></td>
                        </tr>
					  <tr> 
                        <td><strong>Rango de cursos</strong></td>
                        <td><div align="left"><strong>:</strong></div></td>
                        <td><% formulario.DibujaCampo("even_trango_cursos")%></td>
                      </tr>
                      <tr> 
                        <td><strong><font color="#FF0000">*</font>Fecha del evento </strong></td>
                        <td><div align="left"><strong>:</strong></div></td>
                        <td> 
                          <% formulario.DibujaCampo("even_fevento")%>  (dd/mm/aaaa) </td>
                      </tr>
    
                      <tr>
                        <td><strong><font color="#FF0000">*</font>Cantidad Fichas </strong></td>
                        <td><div align="left"><strong>:</strong></div></td>
                        <td><% formulario.DibujaCampo("even_ncantidad_fichas")%></td>
                      </tr>
                      <tr>
                        <td><strong>Recibido por</strong></td>
                        <td><div align="left"><strong>:</strong></div></td>
                        <td><% formulario.DibujaCampo("even_trecibido")%></td>
                      </tr>
                    </table>
			        </form>
				  <p><font color="#FF0000">*</font> Campos obligatorios</p>
				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="234" bgcolor="#D8D8DE"> 
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        
                      <td width="46%">
                        <% botonera.dibujaboton "guardar_nuevo_evento"%>
                      </td>
                        
                      <td width="54%">
                        <%botonera.dibujaboton "cancelar" %>
                      </td>
                      </tr>
                    </table>
				  </td>
                  <td  rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td  rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" align="right" width="7" height="28"></td>
                  
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>

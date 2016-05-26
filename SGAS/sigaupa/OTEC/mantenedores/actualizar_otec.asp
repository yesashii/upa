<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
tipo = Request.QueryString("tipo")
q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
'for each k in request.querystring
'	response.write(k&"="&request.querystring(k)&"<br>")
'next
'response.End()

'response.Write("e_empr_nrut "&e_empr_nrut)
session("url_actual")="../mantenedores/actualizar_otec.asp?b[0][pers_nrut]="&q_pers_nrut&"&b[0][pers_xdv]="&q_pers_xdv&"&tipo="&tipo
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Actualización de Antecedentes"

set botonera =  new CFormulario
botonera.carga_parametros "actualizar_otec.xml", "botonera"
'response.End()
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores



'response.Write(carr_ccod)
'----------------------------------------------------------------------- 
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "actualizar_otec.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select '' "
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv

if tipo="p" then 
	'---------------------------------------------------------------------------------------------------
	set datos_postulante = new cformulario
	datos_postulante.carga_parametros "actualizar_otec.xml", "datos_postulante"
	datos_postulante.inicializar conexion
	
	consulta= "  select a.pers_ncorr,cast(a.pers_nrut as varchar) + '-' + a.pers_xdv as codigo_rut,a.pers_nrut,a.pers_xdv,a.pers_tnombre,a.pers_tape_paterno,a.pers_tape_materno, " & vbCrlf & _
			  "  protic.trunc(pers_fnacimiento) as pers_fnacimiento, " & vbCrlf & _
			  "  pers_tprofesion, b.dire_tcalle,b.dire_tnro,b.dire_tpoblacion,b.dire_tblock,b.ciud_ccod, " & vbCrlf & _
			  "  a.pers_tfono,a.pers_tcelular,a.pers_temail,pers_tempresa,pers_tcargo  " & vbCrlf & _
			  "  from personas a join  direcciones b " & vbCrlf & _
			  "     on  a.pers_ncorr=b.pers_ncorr " & vbCrlf & _
			  "  where cast(pers_nrut as varchar)='"&q_pers_nrut&"' " & vbCrlf & _
			  "  and  b.tdir_ccod=1 "
		
	esta_en_personas = conexion.consultaUno("select count(*) from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")		  
	
	if esta_en_personas ="0" and q_pers_nrut <> "" then
		'response.Write("entre acá")
		consulta = "select '"&q_pers_nrut&"' as pers_nrut,'"&q_pers_xdv&"' as pers_xdv, '"&q_pers_nrut&"' + '-' + '"&q_pers_xdv&"' as codigo_rut"
		mensaje = "No existe un registro en nuestras bases para la persona consultada."
	end if
	'response.write("<pre>"&consulta&"</pre>")
	datos_postulante.consultar consulta 
	datos_postulante.siguiente
end if

if tipo = "e" then 
	'---------------------------------------------------------------------------------------------------
	set datos_empresa = new cformulario
	datos_empresa.carga_parametros "actualizar_otec.xml", "datos_empresa"
	datos_empresa.inicializar conexion
	
	
	consulta= "   select cast(empr_nrut as varchar)+'-'+ empr_xdv as codigo_empresa, empr_ncorr,empr_trazon_social,empr_nrut,empr_xdv,empr_tdireccion,ciud_ccod,empr_tfono,empr_tfax,empr_tgiro, " & vbCrlf & _
			  "   empr_tejecutivo,empr_temail_ejecutivo  " & vbCrlf & _
			  "   from empresas  " & vbCrlf & _
			  "   where cast(empr_nrut as varchar)='"&q_pers_nrut&"' " 
			  
	esta_en_empresa = conexion.consultaUno("select count(*) from empresas where cast(empr_nrut as varchar)='"&q_pers_nrut&"'")		  
		  
	'response.write("<pre>"&consulta&"</pre>")
	if esta_en_empresa = "0" and q_pers_nrut <> "" then
		consulta = "select '' as empr_ncorr"
		mensaje = "No existe un registro en nuestras bases para la empresa u otic consultada."
	end if
	'response.write("<pre>"&consulta&"</pre>")
	datos_empresa.consultar consulta 
	datos_empresa.siguiente
	if q_pers_nrut <> "" and q_pers_xdv <> "" and esta_en_empresa <> "0"  then
		datos_empresa.AgregaCampoCons "empr_nrut", q_pers_nrut
		datos_empresa.AgregaCampoCons "empr_xdv", q_pers_xdv
	end if

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
function enviar(formulario){
	formulario.elements["detalle"].value="2";
  	if(preValidaFormulario(formulario)){	
		formulario.submit();
		
	}
}

var t_busqueda;
var t_busqueda2;
function ValidaBusqueda()
{
	rut=document.buscador.elements['b[0][pers_nrut]'].value+'-'+document.buscador.elements['b[0][pers_xdv]'].value
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido');		
		document.buscador.elements['b[0][pers_nrut]'].focus()
		document.buscador.elements['b[0][pers_nrut]'].select()
		return false;
	}
	
	return true;	
}
function InicioPagina()
{
	t_busqueda = new CTabla("b");
	t_busqueda2 = new CTabla("e");
	t_busqueda3 = new CTabla("o");
}

function forma_pago(valor)
{
	forma_pago_registrada = '<%=forma_pago%>';
	//alert("forma_pago "+forma_pago_registrada+ " valor "+valor);
	if (forma_pago_registrada != valor)
	{
		alert("Se debe volver a guardar los datos para que los cambios se  vean reflejados.");
		if ((forma_pago_registrada=="2") || (forma_pago_registrada=="3"))
			{document.getElementById("bt_empresa").style.visibility = "hidden" ;
		}
		if ((forma_pago_registrada=="4"))
		{document.getElementById("bt_otic").style.visibility = "hidden" ;}

	}
	else
	{
		if ((forma_pago_registrada=="2") || (forma_pago_registrada=="3"))
			{document.getElementById("bt_empresa").style.visibility = "visible" ;
		}
		if ((forma_pago_registrada=="4"))
		{document.getElementById("bt_otic").style.visibility = "visible" ;}
	}
	if (valor=='1')
	{
		 document.getElementById("sence").style.visibility = "hidden" ;
		 document.edicion_persona.elements["m[0][utiliza_sence]"].checked = false;
		 document.edicion_persona.elements["_m[0][utiliza_sence]"].checked = false;
		 document.edicion_persona.elements["m[0][utiliza_sence]"].value = 0;
		 document.edicion_persona.elements["_m[0][utiliza_sence]"].value = 0;
	}
	if (valor=='2')//en caso de ser forma de pago empresa sin sence se debe descheckear esa opción
	{
	 document.getElementById("sence").style.visibility = "hidden" ;
	 document.edicion_persona.elements["m[0][utiliza_sence]"].checked = false;
	 document.edicion_persona.elements["_m[0][utiliza_sence]"].checked = false;
	 document.edicion_persona.elements["m[0][utiliza_sence]"].value = 0;
	 document.edicion_persona.elements["_m[0][utiliza_sence]"].value = 0;
	}
	if (valor=='3')//en caso de ser forma de pago empresa sin sence se debe descheckear esa opción
	{
		 document.getElementById("sence").style.visibility = "visible" ;
		 document.edicion_persona.elements["m[0][utiliza_sence]"].checked = true;
		 document.edicion_persona.elements["_m[0][utiliza_sence]"].checked = true;
		 document.edicion_persona.elements["m[0][utiliza_sence]"].value = 1;
		 document.edicion_persona.elements["_m[0][utiliza_sence]"].value = 1;
	}
	if (valor=='4')
	{
		document.getElementById("sence").style.visibility = "visible" ;
	}
}
function ValidaRut22()
{
	rut = t_busqueda2.ObtenerValor(0, "empr_nrut") + '-' + t_busqueda2.ObtenerValor(0, "empr_xdv")

	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido.');		
		t_busqueda2.filas[0].campos["empr_xdv"].objeto.select();
		return false;
	}
	
	return true;	
}
function ValidaRut33()
{
	rut = t_busqueda3.ObtenerValor(0, "empr_nrut") + '-' + t_busqueda3.ObtenerValor(0, "empr_xdv")

	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido.');		
		t_busqueda3.filas[0].campos["empr_xdv"].objeto.select();
		return false;
	}
	
	return true;	
}

function genera_digito (rut){
 var IgStringVerificador, IgN, IgSuma, IgDigito, IgDigitoVerificador, rut;
 var texto_rut = new String(rut);
 var posicion_guion = 0;
 
 posicion_guion = texto_rut.indexOf("-");
 if (posicion_guion != -1)
 {
    texto_rut = texto_rut.substring(0,posicion_guion);
    document.edicion2.elements["e[0][empr_nrut]"].value= texto_rut;
	rut = texto_rut;
 }
// texto_rut.
 //alert(texto_rut);
   if (rut.length==7) rut = '0' + rut; 

   
   IgStringVerificador = '32765432';
   IgSuma = 0;
   for( IgN = 0; IgN < 8 && IgN < rut.length; IgN++)
      IgSuma = eval(IgSuma + '+' + rut.substr(IgN, 1) + '*' + IgStringVerificador.substr(IgN, 1) + ';');
   IgDigito = 11 - IgSuma % 11;
   IgDigitoVerificador = IgDigito==10?'K':IgDigito==11?'0':IgDigito;
   //alert(IgDigitoVerificador);
   document.edicion2.elements["e[0][empr_xdv]"].value=IgDigitoVerificador;
//alert(rut+IgDigitoVerificador);
_Buscar(this, document.forms['edicion2'],'', 'ValidaRut22();', 'FALSE');
}

function genera_digito2 (rut){
 var IgStringVerificador, IgN, IgSuma, IgDigito, IgDigitoVerificador, rut;
 var texto_rut = new String(rut);
 var posicion_guion = 0;
 
 posicion_guion = texto_rut.indexOf("-");
 if (posicion_guion != -1)
 {
    texto_rut = texto_rut.substring(0,posicion_guion);
    document.edicion2.elements["o[0][empr_nrut]"].value= texto_rut;
	rut = texto_rut;
 }
// texto_rut.
 //alert(texto_rut);
   if (rut.length==7) rut = '0' + rut; 

   
   IgStringVerificador = '32765432';
   IgSuma = 0;
   for( IgN = 0; IgN < 8 && IgN < rut.length; IgN++)
      IgSuma = eval(IgSuma + '+' + rut.substr(IgN, 1) + '*' + IgStringVerificador.substr(IgN, 1) + ';');
   IgDigito = 11 - IgSuma % 11;
   IgDigitoVerificador = IgDigito==10?'K':IgDigito==11?'0':IgDigito;
   //alert(IgDigitoVerificador);
   document.edicion2.elements["o[0][empr_xdv]"].value=IgDigitoVerificador;
//alert(rut+IgDigitoVerificador);
_Buscar(this, document.forms['edicion2'],'', 'ValidaRut33();', 'FALSE');
}

function configurar_orden_compra() {
	
	direccion = '<%=url_orden%>';
	resultado=window.open(direccion, "ventana1","width=400,height=250,scrollbars=no, left=380, top=150");
	
 // window.close();
}

function valida_cierre(formulario)
{forma_pago = '<%=forma_pago%>';
 valor = 1;
  //alert(formulario.elements["_m[0][datos_persona_correctos]"].checked);
	if ((forma_pago=='1')&&(document.edicion_fin.elements["_m[0][datos_persona_correctos]"].checked==false))
		{ valor = 0;
		  alert("Debe Seleccionar la conformidad de los datos entregados por el alumno para cerrar la postulación");
		 }
	if (((forma_pago=='2')||(forma_pago=='3'))&&((document.edicion_fin.elements["_m[0][datos_persona_correctos]"].checked==false)||(document.edicion_fin.elements["_m[0][datos_empresa_correctos]"].checked==false)))
		{ valor = 0;
		  alert("Debe Seleccionar la conformidad de los datos personales y de la empresa, entregados por el alumno, para cerrar la postulación");
		 }
	if ((forma_pago=='4')&&((document.edicion_fin.elements["_m[0][datos_persona_correctos]"].checked==false)||(document.edicion_fin.elements["_m[0][datos_empresa_correctos]"].checked==false)||(document.edicion_fin.elements["_m[0][datos_otic_correctos]"].checked==false)))
		{ valor = 0;
		  alert("Debe Seleccionar la conformidad de los datos personales, de la empresa y la otic, entregados por el alumno, para cerrar la postulación");
		 }	
		 
/*alert(document.edicion_fin.elements["m[0][tdet_ccod]"].value);		
if (document.edicion_fin.elements["m[0][tdet_ccod]"].value=="")
 {
 	document.edicion_fin.elements["temporal"].value=0;
 }
else
 {
 	document.edicion_fin.elements["temporal"].value = document.edicion_fin.elements["m[0][tdet_ccod]"].value;
 } */
 
if (valor == 0)		  
	{return false;	}
else
	{return true;}
			
}
</script>

</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
<table width="580" height="100%">
<tr valign="top" height="30">
	<td bgcolor="#EAEAEA">
</td>
</tr>
<tr valign="top">
	<td bgcolor="#EAEAEA">
<table width="652" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA" align="center">
	<table width="90%">
	<tr>
		<td align="center">
	
	<table width="68%"  border="0" align="left" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
            <td align="left"><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                    <td width="20%"><div align="center"><strong>Rut</strong></td>
					<td width="3%"><div align="center"><strong>:</strong></td>
                    <td width="50%"><%f_busqueda.DibujaCampo("pers_nrut")%> 
                          - 
                            <%f_busqueda.DibujaCampo("pers_xdv")%></td>
					<td align="right"><%botonera.dibujaboton "buscar"%></td>
                 </tr>
				 <tr>
                    <td width="20%"><div align="center"><strong>De</strong></td>
					<td width="3%"><div align="center"><strong>:</strong></td>
                    <td colspan="2">Persona : 
					<%if tipo="p" or tipo="" or EsVacio(tipo) then%>
					<input type="radio" name="tipo" value="p" checked>
					<%else%>
					<input type="radio" name="tipo" value="p">
					<%end if%>
					&nbsp;&nbsp;&nbsp;&nbsp;Empresa : 
					<%if tipo="e" then%>
					<input type="radio" name="tipo" value="e" checked>
					<%else%>
					<input type="radio" name="tipo" value="e">
					<%end if%></td>
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
	</td>
	</tr>
	</table>
	</td></tr>
	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">&nbsp;</td></tr>
	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">
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
            <td><%pagina.DibujarLenguetas Array("Ingreso de Postulación"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
                <table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><div align="center"><%pagina.DibujarTituloPagina%> <br>
                    </div></td>
                    </tr>
                  
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <%if q_pers_nrut <> "" and q_pers_xdv <> "" then %>
				  
				  <tr>
				  	<td align="center">
						<table width="98%">
						<form name="edicion_persona">
						<%if tipo="p" and esta_en_personas <> "0" then %>
						<tr>
							<td width="10%"><strong>Rut</strong></td>
							<td width="1%"><strong>:</strong></td>
							<td width="39%"><%datos_postulante.dibujaCampo("codigo_rut")%><%datos_postulante.dibujaCampo("pers_nrut")%><%datos_postulante.dibujaCampo("pers_xdv")%></td>
							<td width="10%" align="right"><strong>Nombre</strong></td>
							<td width="1%"><strong>:</strong></td>
							<td width="39%"><%datos_postulante.dibujaCampo("pers_tnombre")%><input type="hidden" name="tipo" value="<%=tipo%>"></td>
						</tr>
						<tr>
							<td width="10%"><strong>A.Paterno</strong></td>
							<td width="1%"><strong>:</strong></td>
							<td width="39%"><%datos_postulante.dibujaCampo("pers_tape_paterno")%></td>
							<td width="10%" align="right"><strong>A.Materno</strong></td>
							<td width="1%"><strong>:</strong></td>
							<td width="39%"><%datos_postulante.dibujaCampo("pers_tape_materno")%></td>
						</tr>
						<tr>
							<td width="10%"><strong>F.Nacimiento</strong></td>
							<td width="1%"><strong>:</strong></td>
							<td width="39%"><%datos_postulante.dibujaCampo("pers_fnacimiento")%></td>
							<td width="10%" align="right"><strong>Profesión</strong></td>
							<td width="1%"><strong>:</strong></td>
							<td width="39%"><%datos_postulante.dibujaCampo("pers_tprofesion")%></td>
							
						</tr>
						<tr>
							<td width="10%"><strong>Dirección</strong></td>
							<td width="1%"><strong>:</strong></td>
							<td width="39%"><%datos_postulante.dibujaCampo("dire_tcalle")%></td>
							<td width="10%" align="right"><strong>Número</strong></td>
							<td width="1%"><strong>:</strong></td>
							<td width="39%"><%datos_postulante.dibujaCampo("dire_tnro")%></td>
						</tr>
						<tr>
							<td width="10%"><strong>Población</strong></td>
							<td width="1%"><strong>:</strong></td>
							<td width="39%"><%datos_postulante.dibujaCampo("dire_tpoblacion")%></td>
							<td width="10%" align="right"><strong>Depto</strong></td>
							<td width="1%"><strong>:</strong></td>
							<td width="39%"><%datos_postulante.dibujaCampo("dire_tblock")%></td>
						</tr>
						<tr>
							<td width="10%"><strong>Comuna</strong></td>
							<td width="1%"><strong>:</strong></td>
							<td width="39%"><%datos_postulante.dibujaCampo("ciud_ccod")%></td>
							<td width="10%" align="right"><strong>E-mail</strong></td>
							<td width="1%"><strong>:</strong></td>
							<td width="39%"><%datos_postulante.dibujaCampo("pers_temail")%></td>
						</tr>
						<tr>
							<td width="10%"><strong>Fono</strong></td>
							<td width="1%"><strong>:</strong></td>
							<td width="39%"><%datos_postulante.dibujaCampo("pers_tfono")%></td>
							<td width="10%" align="right"><strong>Celular</strong></td>
							<td width="1%"><strong>:</strong></td>
							<td width="39%"><%datos_postulante.dibujaCampo("pers_tcelular")%></td>
						</tr>
						<tr>
							<td width="10%"><strong>Empresa</strong></td>
							<td width="1%"><strong>:</strong></td>
							<td width="39%"><%datos_postulante.dibujaCampo("pers_tempresa")%></td>
							<td width="10%" align="right"><strong>Cargo</strong></td>
							<td width="1%"><strong>:</strong></td>
							<td width="39%"><%datos_postulante.dibujaCampo("pers_tcargo")%></td>
						</tr>
						<tr><td colspan="6" align="right"><%botonera.dibujaBoton "guardar_persona"%></td></tr>
						<%elseif tipo="p" and esta_en_personas = "0" then %>
							<tr><td colspan="6" align="right">&nbsp;</td></tr>
							<tr><td colspan="6" align="center"><font size="2" face="Courier New, Courier, mono"><strong><%=mensaje%></strong></font></td></tr>
							<tr><td colspan="6" align="right">&nbsp;</td></tr>
						<%end if%>
						</form>
						
						<form name="edicion2">
						<%if tipo="e" and esta_en_empresa <> "0" then %>
						    <tr><td colspan="6">&nbsp;<input type="hidden" name="tipo" value="<%=tipo%>"></td></tr>
							<tr><td colspan="6" align="left"><strong>------DATOS EMPRESA------</strong></td></tr>
								<tr>
									<td width="10%"><strong>Rut</strong></td>
									<td width="1%"><strong>:</strong></td>
									<td width="39%"><%datos_empresa.dibujaCampo("codigo_empresa")%><%datos_empresa.dibujaCampo("empr_nrut")%><%datos_empresa.dibujaCampo("empr_xdv")%></td>
									<td width="10%" align="right"><strong>Razón Social</strong></td>
									<td width="1%"><strong>:</strong></td>
									<td width="39%"><%datos_empresa.dibujaCampo("empr_trazon_social")%><%datos_empresa.dibujaCampo("pote_ncorr")%></td>
								</tr>
								<tr>
									<td width="10%"><strong>Dirección</strong></td>
									<td width="1%"><strong>:</strong></td>
									<td width="39%"><%datos_empresa.dibujaCampo("empr_tdireccion")%></td>
									<td width="10%" align="right"><strong>Comuna</strong></td>
									<td width="1%"><strong>:</strong></td>
									<td width="39%"><%datos_empresa.dibujaCampo("ciud_ccod")%></td>
								</tr>
								<tr>
									<td width="10%"><strong>Teléfono</strong></td>
									<td width="1%"><strong>:</strong></td>
									<td width="39%"><%datos_empresa.dibujaCampo("empr_tfono")%></td>
									<td width="10%" align="right"><strong>Fax</strong></td>
									<td width="1%"><strong>:</strong></td>
									<td width="39%"><%datos_empresa.dibujaCampo("empr_tfax")%></td>
								</tr>
								<tr>
									<td width="10%"><strong>Giro</strong></td>
									<td width="1%"><strong>:</strong></td>
									<td width="39%"><%datos_empresa.dibujaCampo("empr_tgiro")%></td>
									<td width="10%" align="right"><strong>Nombre Ejecutivo</strong></td>
									<td width="1%"><strong>:</strong></td>
									<td width="39%"><%datos_empresa.dibujaCampo("empr_tejecutivo")%></td>
								</tr>
								<tr>
									<td width="10%"><strong>E-mail Ejecutivo</strong></td>
									<td width="1%"><strong>:</strong></td>
									<td colspan="4"><%datos_empresa.dibujaCampo("empr_temail_ejecutivo")%></td>
								</tr>
								<tr><td colspan="6" align="left">
										<table width="100%" cellpadding="0" cellspacing="0" id="bt_empresa" style="visibility:visible">
											<tr><td align="right"><%botonera.dibujaBoton "guardar_empresas"%></td></tr>
										</table>
								    </td>
								</tr>	
							  <%elseif tipo="e" and esta_en_empresa="0" then %>
								<tr><td colspan="6" align="right">&nbsp;</td></tr>
								<tr><td colspan="6" align="center"><font size="2" face="Courier New, Courier, mono"><strong><%=mensaje%></strong></font></td></tr>
								<tr><td colspan="6" align="right">&nbsp;</td></tr>
							 <%end if%>
     					</form>
					</table>
					</td>
				  </tr>
				  
				  <%end if%>
				  <tr>
                    <td>&nbsp;</td>
                  </tr>
                </table>
              <br>
            </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
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

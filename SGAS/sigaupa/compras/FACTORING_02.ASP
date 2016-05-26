<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->

<%
'*******************************************************************
'DESCRIPCION		: FACTORIZACIÓN DE DOCUMENTOS
'FECHA CREACIÓN		:10/09/2014
'CREADO POR 		:	JAIME PAINEMAL ALCAMAN
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:COMPRAS Y AUT. DE GIRO
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:
'ACTUALIZADO POR	:
'MOTIVO			:
'LINEA			:
'*******************************************************************
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

'v_rut			= request.querystring("rut")
'v_dv			= request.querystring("dv")

set pagina = new CPagina
pagina.Titulo = "FACTORIZACIÓN DE DOCUMENTOS"

set botonera = new CFormulario
'botonera.carga_parametros "fondo_fijo.xml", "botonera"
botonera.carga_parametros "factorizar_documentos.xml", "botonera"

set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new cnegocio
negocio.Inicializa conectar

set conexion = new Cconexion2
conexion.Inicializar "upacifico"

v_usuario	=	negocio.ObtenerUsuario()
v_anos_ccod	= 	conectar.consultaUno("select year(getdate())")

'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "factorizar_documentos.xml", "buscador"
'f_busqueda.Carga_Parametros "factorizar_documentos.xml", "factorizar"
f_busqueda.Inicializar conectar
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

f_busqueda.AgregaCampoCons "sogi_ncorr", v_sogi_ncorr
f_busqueda.AgregaCampoCons "dsgi_ndocto", v_dsgi_ndocto
f_busqueda.AgregaCampoCons "pers_nrut", v_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", v_pers_xdv

'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888


set f_solicitud = new cFormulario
'f_solicitud.carga_parametros "vb_vicerector.xml", "autoriza_solicitud_giro"
f_solicitud.Carga_Parametros "factorizar_documentos.xml", "cheques"
f_solicitud.inicializar conectar
f_solicitud.procesaForm


for fila = 0 to f_solicitud.CuentaPost - 1

	v_RUT	= f_solicitud.ObtenerValorPost (fila, "PERS_NRUT")
	v_dsgi_ndocto		= f_solicitud.ObtenerValorPost (fila, "dsgi_ndocto")
	v_sogi_ncorr		= f_solicitud.ObtenerValorPost (fila, "sogi_ncorr")
	
'8888888888888888888888
'RESPONSE.WRITE("v_RUT: "&v_RUT&"<BR>")
'RESPONSE.WRITE("v_dsgi_ndocto: "&v_dsgi_ndocto&"<BR>")
'RESPONSE.WRITE("v_sogi_ncorr: "&v_sogi_ncorr&"<BR>")
'8888888888888888888888

IF v_sogi_ncorr<>"" THEN

			sql_cheques	=	" select "& vbCrLf &_
										" B.PERS_NRUT, (CAST(B.PERS_NRUT AS VARCHAR)+ '-' + CAST(B.PERS_XDV AS VARCHAR)) AS RUT  "& vbCrLf &_
										" , (B.PERS_TNOMBRE + ' ' + B.PERS_TAPE_PATERNO + ' ' +B.PERS_TAPE_MATERNO) AS NOMBRE  "& vbCrLf &_
										" , c.sogi_ncorr, c.sogi_ncorr as solicitud, c.tmon_ccod, f.tdoc_tdesc, c.dsgi_ndocto, c.dsgi_mdocto, c.dsgi_mexento, c.dsgi_mafecto, c.dsgi_miva, c.dogi_fecha_documento  "& vbCrLf &_
										" , (isnull(c.dsgi_mafecto,0) + isnull(c.dsgi_miva ,0)) AS TOTAL  "& vbCrLf &_
										" , E.DPVA_FPAGO  "& vbCrLf &_
 										" from ocag_solicitud_giro a   "& vbCrLf &_
										"  INNER JOIN personas b   "& vbCrLf &_
										"  ON a.pers_ncorr_proveedor = b.pers_ncorr and a.vibo_ccod=7 and a.sogi_ncorr = "&v_sogi_ncorr&" and B.PERS_NRUT="&v_RUT&" "& vbCrLf &_
										"  INNER JOIN ocag_detalle_solicitud_giro c   "& vbCrLf &_
										"  ON a.sogi_ncorr = c.sogi_ncorr AND c.tdoc_ccod IN (2,3,9,10) and c.dsgi_ndocto="&v_dsgi_ndocto&" "& vbCrLf &_
										"  INNER JOIN ocag_validacion_contable D  "& vbCrLf &_
										"  ON a.sogi_ncorr=D.cod_solicitud and D.tsol_ccod = 1  "& vbCrLf &_
										"  INNER JOIN ocag_detalle_pago_validacion E  "& vbCrLf &_
										"  ON D.vcon_ncorr=E.vcon_ncorr  "& vbCrLf &_
										"  INNER JOIN ocag_tipo_documento f  "& vbCrLf &_
										"  ON c.tdoc_ccod=f.tdoc_ccod  "& vbCrLf &_
										"  ORDER BY C.dogi_fecha_documento "

END IF

next

'RESPONSE.WRITE("sql_cheques: "&sql_cheques&"<BR>")

' 88888888888888888888888888888888888888888888888888888888888888888888888888888

set f_cheques = new CFormulario
f_cheques.Carga_Parametros "factorizar_documentos.xml", "cheques"
'f_cheques.Carga_Parametros "factorizar_documentos.xml", "factorizar"
f_cheques.Inicializar conectar
f_cheques.Consultar sql_cheques
f_cheques.siguiente
'response.End()

' 88888888888888888888888888888888888888888888888888888888888888888888888888888

v_nombre=f_cheques.obtenerValor("nombre")
v_PERS_NRUT=f_cheques.obtenerValor("PERS_NRUT")

'RESPONSE.WRITE("v_nombre: "&v_nombre&"<BR>")

' 88888888888888888888888888888888888888888888888888888888888888888888888888888
	'88 INICIO
	
	if TRIM(v_nombre)="" then
	
	set f_personas2 = new CFormulario
	f_personas2.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_personas2.inicializar conexion

	sql_datos_persona= " select CODAUX AS pers_nrut, RIGHT(RUTAUX,1) AS pers_xdv, NOMAUX AS pers_tnombre, NOMAUX AS v_nombre "&_
										" from softland.cwtauxi where cast(CodAux as varchar)='"&v_PERS_NRUT&"'"

	f_personas2.consultar sql_datos_persona
	f_personas2.Siguiente
						
	v_nombre = f_personas2.obtenerValor("v_nombre")
	
	'RESPONSE.WRITE("v_nombre: "&v_nombre&"<BR>")
						
	f_cheques.AgregaCampoCons "nombre", f_personas2.obtenerValor("v_nombre")
	
	end if
	'88 FIN
' 88888888888888888888888888888888888888888888888888888888888888888888888888888



%>
<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<style>
.Mimetismo { background-color:#ADADAD;border: 1px #ADADAD solid; font-size:10px; font-style:oblique; font:bold;}
</style>
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>
}

function CopiaNombre(){
	var formulario = document.forms["datos"];
	formulario.pers_nrut.value=formulario.elements["datos[0][pers_nrut]"].value;
	formulario.pers_xdv.value=formulario.elements["datos[0][pers_xdv]"].value;
	formulario.funcionario.value=formulario.elements["datos[0][pers_tnombre]"].value;
}

function ImprimirFondoFijo(){
	url="imprimir_ff.asp?ffij_ncorr=<%=v_ffij_ncorr%>";
	window.open(url,'ImpresionFF', 'scrollbars=yes, menubar=no, resizable=yes, width=700,height=700');	
}

function Enviar(){

	var formulario = document.forms["factorizar"];
	var rut=formulario.elements["datos_1[0][pers_nrut]"].value.length;
	var nombre_02=formulario.elements["datos_1[0][nombre_02]"].value.length;	

	if(rut == "0")
	{	
		alert("Ingrese Rut Proveedor");
		return false;
	}else{
		return true;
	}
	
	if(nombre_02 == "0")
	{	
		alert("Ingrese Nombre Proveedor");
		return false;
	}else{
		return true;
	}

}

//888888888888888888888888888888888888888888888888888888888888888888888888888888888

function crearAjax()
{
    var xmlhttp=false;
    try
    { // para navegadores que no sean Micro$oft
        xmlhttp=new ActiveXObject("Msxml2.XMLHTTP");
    }
    catch(e)
    {
        try
        { // para iexplore.exe XD
            xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
        }
        catch(E) { xmlhttp=false; }
    }
    if (!xmlhttp && typeof XMLHttpRequest!='undefined') { xmlhttp=new XMLHttpRequest(); }
    return xmlhttp;
}

//888888888888888888888888888888888888888888888888888888888888888888888888888888888

function llenaDatos_softland()
{
	//var formulario = document.forms["datos_1"];
	var formulario = document.forms["factorizar"];
	var rut=formulario.elements["datos_1[0][pers_nrut]"].value;
	var nombre;
	var ajax=crearAjax();

    ajax.open("POST", "datos_proveedor.asp", true);
    ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    ajax.send("rut="+rut);
	
    ajax.onreadystatechange=function()
    {
        if (ajax.readyState==4)
        {
            var respuesta=ajax.responseXML;
            nombre=respuesta.getElementsByTagName("nombre")[0].childNodes[0].data;
			formulario.elements["datos_1[0][nombre_02]"].value=nombre;

			//if(!nombre.value){
			if(nombre==""){
				alert("No existen datos asociados al rut ingresado");
				formulario.elements["datos_1[0][pers_nrut]"].value="";
				formulario.elements["datos_1[0][pers_xdv]"].value="";
				formulario.elements["datos_1[0][nombre_02]"].value="";
			}
	   }
    }
}

//888888888888888888888888888888888888888888888888888888888888888888888888888888888

function genera_digito (rut){

 var IgStringVerificador, IgN, IgSuma, IgDigito, IgDigitoVerificador, rut;
 var texto_rut = new String(rut);
 var posicion_guion = 0;
 //var formulario = document.forms["datos_1"];
 var formulario = document.forms["factorizar"];
 
 posicion_guion = texto_rut.indexOf("-");
 
 if (posicion_guion != -1)
 {
    texto_rut = texto_rut.substring(0,posicion_guion);
    formulario.elements["datos_1[0][pers_nrut]"].value=texto_rut;
    //formulario.elements["factorizar[0][pers_nrut]"].value=texto_rut;
	rut = texto_rut;
 }
 
   if (rut.length==7) rut = '0' + rut; 

   IgStringVerificador = '32765432';
   IgSuma = 0;

   for( IgN = 0; IgN < 8 && IgN < rut.length; IgN++)
      	IgSuma = eval(IgSuma + '+' + rut.substr(IgN, 1) + '*' + IgStringVerificador.substr(IgN, 1) + ';');
	   	IgDigito = 11 - IgSuma % 11;
	   	IgDigitoVerificador = IgDigito==10?'K':IgDigito==11?'0':IgDigito;

		formulario.elements["datos_1[0][pers_xdv]"].value=IgDigitoVerificador;
		//formulario.elements["factorizar[0][pers_xdv]"].value=IgDigitoVerificador;
		llenaDatos_softland();
}

//888888888888888888888888888888888888888888888888888888888888888888888888888888888

function email(){
	//alert(document.datos.elements["email"].value);
	var f = new Date(); 
	miFecha =(f.getDate() + "/" + (f.getMonth() +1) + "/" + f.getFullYear());	
	//email=prompt('Ingrese Correo electronico Jefe Directo:  (Ejemplo: jefe@upacifico.cl)','');
	
	//-----------Carga email de Responsable desde BD, condiciona si el correo es el correcto, si no da opción de ingreso. Rpavez 06/05/2014	
	if (document.datos.elements["email"].value.length<5) {
		email=prompt('Ingrese Correo electronico Jefe Directo:  (Ejemplo: jefe@upacifico.cl)','');
	}
	else{
		if (confirm("Se enviara un correo a: " + document.datos.elements["email"].value)){
			email=document.datos.elements["email"].value;
		}
		else{
			email=prompt('Ingrese Correo electronico Jefe Directo:  (Ejemplo: jefe@upacifico.cl)','');
		}
	}
//-------------------------------------	
	var re  = /^([a-zA-Z0-9_.-])+@((upacifico)+.)+(cl)+$/; 
	if (!re.test(email)) { 
		alert ("Dirección de email inválida"); 
		return false; 
	} 
	
	
	if((email != "")&&(email != null)){

	window.open("http://admision.upacifico.cl/postulacion/www/proc_envio_solicitud_giro.php?nombre=<%=nombre_solicitante%>&solicitud=<%=tipo_soli%>&n_soli=<%=n_soli%>&fecha="+miFecha+"&correo="+email)
	//return false;
	return true;
	}else{
		alert("Debe Ingresar un Correo Electronico.")
		return false;	
	}
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
          <td>
		  <table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">FACTORIZACIÓN DE DOCUMENTOS</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td background="../imagenes/top_r3_c2.gif"></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
			
			<!--88888888888888888888888888888888888888888888888888888888888888888888888888888888-->

              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				  <BR>
                    <div align="center"><font size="+1"> <%pagina.DibujarTituloPagina()%></font></div>
					
					<!--88888888888888888888888888888888888888888888888888888888888888888888888888888888-->

					<!--<form name="datos" method="post">-->
					<form name="factorizar" method="post">
					
						<input type="hidden" name="datos[0][pers_nrut]" value="<%=f_cheques.obtenerValor("pers_nrut")%>">
						<input type="hidden" name="datos[0][rut]" value="<%=f_cheques.obtenerValor("rut")%>" />
                        <input type="hidden" name="datos[0][nombre]" value="<%=f_cheques.obtenerValor("nombre")%>"/>

						<input type="hidden" name="datos[0][sogi_ncorr]" value="<%=f_cheques.obtenerValor("sogi_ncorr")%>">
						<input type="hidden" name="datos[0][solicitud]" value="<%=f_cheques.obtenerValor("solicitud")%>" />
                        <input type="hidden" name="datos[0][tmon_ccod]" value="<%=f_cheques.obtenerValor("tmon_ccod")%>"/>

						<input type="hidden" name="datos[0][tdoc_tdesc]" value="<%=f_cheques.obtenerValor("tdoc_tdesc")%>">
						<input type="hidden" name="datos[0][dsgi_ndocto]" value="<%=f_cheques.obtenerValor("dsgi_ndocto")%>" />
                        <input type="hidden" name="datos[0][dsgi_mdocto]" value="<%=f_cheques.obtenerValor("dsgi_mdocto")%>"/>

						<input type="hidden" name="datos[0][dsgi_mexento]" value="<%=f_cheques.obtenerValor("dsgi_mexento")%>">
						<input type="hidden" name="datos[0][dsgi_mafecto]" value="<%=f_cheques.obtenerValor("dsgi_mafecto")%>" />
                        <input type="hidden" name="datos[0][dsgi_miva]" value="<%=f_cheques.obtenerValor("dsgi_miva")%>"/>

						<input type="hidden" name="datos[0][dogi_fecha_documento]" value="<%=f_cheques.obtenerValor("dogi_fecha_documento")%>">
						<input type="hidden" name="datos[0][total]" value="<%=f_cheques.obtenerValor("total")%>" />
                        <input type="hidden" name="datos[0][dpva_fpago]" value="<%=f_cheques.obtenerValor("dpva_fpago")%>"/>
	
						<table width="100%" border="1">
						
  					     <tr>
						 
							   <td colspan="4">
										<h5><BR>Antiguo Proveedor</h5>					
								</td>
						  </tr>	

						  <tr> 
							<td width="20%">Rut Proveedor :</td>
							<td width="30%"><%f_cheques.dibujaCampo("rut")%></td>
							<td width="20%">Tipo de Factura :</td>
							<td width="30%"><%f_cheques.dibujaCampo("tdoc_tdesc")%></td>
						  </tr>
						  <tr> 
							<td>Nombre Proveedor :</td>
							<td><%f_cheques.dibujaCampo("nombre")%>&nbsp;</td>
							<td>Numero de Solicitud :</td>
							<td><%f_cheques.dibujaCampo("SOLICITUD")%></td>
						  </tr>
						 <tr> 
							<td>Monto Factura :</td>
						   <td><%f_cheques.dibujaCampo("TOTAL")%></td>
							<td>Numero Factura :</td>
							<td><%f_cheques.dibujaCampo("dsgi_ndocto")%></td>
						 </tr>
					<!--
					</form>
						 <form name="datos_1">
						 -->

  					     <tr>
							   <td colspan="4">
							   <br>
										<h5><font color="RED">Ingrese Rut Nuevo Proveedor</font></h5>					
								</td>
						  </tr>	

						  <tr> 
							<td>Rut Proveedor :</td>
							<td colspan="3"><%f_busqueda.dibujaCampo("pers_nrut")%>-<%f_busqueda.dibujaCampo("pers_xdv")%></td>
						  </tr>
						  <tr> 
							<td>Nombre Proveedor :</td>
							<td colspan="3"><%f_busqueda.dibujaCampo("nombre_02")%></td>
						  </tr>

						</table>

						</form>
				  
				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
			
			<!--88888888888888888888888888888888888888888888888888888888888888888888888888888888-->
			
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="240" bgcolor="#D8D8DE">
				  <table width="49%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
					<tr>
					  <td width="30%"><%botonera.dibujaboton "factorizar"%> </td>
                      <td></td>
					  <td><%botonera.dibujaboton "salir_02"%></td>
					  <td></td>
					</tr>
				  </table>                </td>
                  <td width="429" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="10" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td height="8" valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
		  </td>
        </tr>
      </table>	
	  <BR>
   </td>
  </tr>  
</table>
</body>
</html>

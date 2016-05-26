<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- '#include file = "../biblioteca/_negocio.asp" -->

<%
anio_admision   = request.querystring("b[0][anio_admision]")
sede_ccod   = request.querystring("b[0][sede_ccod]")
DCUR_NCORR  = request.querystring("b[0][dcur_ncorr]")
fpot_ccod   = request.querystring("b[0][fpot_ccod]")
nord_compra = request.querystring("b[0][nord_compra]")

if dcur_ncorr = "" or sede_ccod = "" then
	anio_admision   = request.form("b[0][anio_admision]")
	sede_ccod   = request.form("b[0][sede_ccod]")
	DCUR_NCORR  = request.form("b[0][dcur_ncorr]")
	fpot_ccod   = request.form("b[0][fpot_ccod]")
    nord_compra = request.form("b[0][nord_compra]")
end if

'rut recargado de la empresa
e_empr_nrut = request.querystring("e[0][empr_nrut]")
e_empr_xdv  = request.querystring("e[0][empr_xdv]")

'rut recargado de la otic
o_empr_nrut = request.querystring("o[0][empr_nrut]")
o_empr_xdv  = request.querystring("o[0][empr_xdv]")

'response.Write("detalle "&detalle)
session("url_actual")="../mantenedores/postulacion_masiva_otec.asp?b[0][dcur_ncorr]="&dcur_ncorr&"&b[0][sede_ccod]="&sede_ccod&"&b[0][anio_admision]="&anio_admision&"&b[0][fpot_ccod]="&fpot_ccod&"&b[0][nord_compra]="&nord_compra
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Postulacion a Seminarios, Cursos y Diplomados"

set botonera =  new CFormulario
botonera.carga_parametros "postulacion_masiva_otec.xml", "botonera"

set f_botonera =  new CFormulario
f_botonera.carga_parametros "postulacion_masiva_otec.xml", "botonera2"

'response.End()
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

'set negocio = new CNegocio
'negocio.Inicializa conexion

'set errores 	= new cErrores

if fpot_ccod = "" then
	fpot_ccod="2"
end if


dcur_tdesc = conexion.consultauno("SELECT dcur_tdesc FROM diplomados_cursos WHERE cast(dcur_ncorr as varchar)= '" & DCUR_NCORR & "'")
'response.Write(dcur_tdesc)

'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "postulacion_masiva_otec.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 
 consulta = "Select '"&anio_admision&"' as anio_admision,'"&sede_ccod&"' as sede_ccod,'"&dcur_ncorr&"' as dcur_ncorr,  '"&nord_compra&"' as nord_compra"
 f_busqueda.consultar consulta

 'consulta = " select b.dcur_ncorr,b.dcur_tdesc,c.sede_ccod,c.sede_tdesc " & vbCrLf & _
'			" from datos_generales_secciones_otec a, diplomados_cursos b,sedes c " & vbCrLf & _
'			" where a.dcur_ncorr=b.dcur_ncorr " & vbCrLf & _
'		    " and a.sede_ccod=c.sede_ccod " & vbCrLf & _
'			" and a.esot_ccod not in (3) and a.dcur_ncorr not in (5,35) " & vbCrLf & _
'			" and exists (select 1 from ofertas_otec cc where cc.dgso_ncorr=a.dgso_ncorr) "& vbCrLf & _
'			" order by b.dcur_tdesc desc " 

 consulta = " select anio_admision,c.sede_ccod,c.sede_tdesc, b.dcur_ncorr,b.dcur_tdesc " & vbCrlf & _
			" from datos_generales_secciones_otec a, diplomados_cursos b,sedes c,ofertas_otec d " & vbCrlf & _
			" where a.dcur_ncorr=b.dcur_ncorr " & vbCrlf & _
			" and a.sede_ccod=c.sede_ccod  " & vbCrlf & _
			" and a.dgso_ncorr=d.dgso_ncorr " & vbCrlf & _
			" and a.esot_ccod not in (3) and a.dcur_ncorr not in (5,35) " & vbCrlf & _
			" order by anio_admision desc,c.sede_tdesc asc, b.dcur_tdesc asc " 
			
						
 f_busqueda.inicializaListaDependiente "lBusqueda", consulta
 f_busqueda.Siguiente

tiene_datos_generales = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&DCUR_NCORR&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2)")

sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")
dcur_tdesc = conexion.consultaUno("select dcur_tdesc from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
dcur_nsence = conexion.consultaUno("select dcur_nsence from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
dgso_ncorr = conexion.consultaUno("select dgso_ncorr from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&DCUR_NCORR&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2)")
periodo_programa = conexion.consultaUno("select 'FECHA INICIO : <strong>'+ protic.trunc(dgso_finicio) + '</strong>    FECHA TERMINO : <strong>' + protic.trunc(dgso_ftermino) + '</strong>' from datos_generales_secciones_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")

'response.Write("select empr_nrut from ordenes_compras_otec a,empresas b where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"' and a.empr_ncorr=b.empr_ncorr")

if dgso_ncorr <> "" and e_empr_nrut="" then
	e_empr_nrut = conexion.consultaUno("select empr_nrut from ordenes_compras_otec a,empresas b where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"' and a.empr_ncorr_2=b.empr_ncorr")
	e_empr_xdv = conexion.consultaUno("select empr_xdv from ordenes_compras_otec a,empresas b where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"' and a.empr_ncorr_2=b.empr_ncorr")
end if
if dgso_ncorr <> "" and o_empr_nrut="" then
	o_empr_nrut = conexion.consultaUno("select empr_nrut from ordenes_compras_otec a,empresas b where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"' and a.empr_ncorr = b.empr_ncorr")
	o_empr_xdv = conexion.consultaUno("select empr_xdv from ordenes_compras_otec a,empresas b where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"' and a.empr_ncorr = b.empr_ncorr")
end if

if e_empr_nrut <>"" then 
e_empr_ncorr=conexion.consultaUno("select empr_ncorr from empresas where cast(empr_nrut as varchar)='"&e_empr_nrut&"'")
end if


'---------------------------------------------------------------------------------------------------
set datos_generales = new cformulario
datos_generales.carga_parametros "postulacion_masiva_otec.xml", "datos_generales"
datos_generales.inicializar conexion


consulta= " select a.dgso_ncorr,a.dcur_ncorr,a.sede_ccod,protic.trunc(dgso_finicio) as dgso_finicio,protic.trunc(dgso_ftermino) as dgso_ftermino,dgso_ncupo,dgso_nquorum,ofot_nmatricula,ofot_narancel " & vbCrlf & _
		  " from datos_generales_secciones_otec a left outer join ofertas_otec  b" & vbCrlf & _
		  "  on a.dgso_ncorr = b.dgso_ncorr " & vbCrlf &_
		  " where cast(a.dcur_ncorr as varchar)='"&DCUR_NCORR&"'  " & vbCrlf & _
		  " and cast(a.sede_ccod as varchar)='"&sede_ccod&"' " 

if tiene_datos_generales = "N" then
	consulta = "select '' as dgso_ncorr"
end if

datos_generales.consultar consulta 
if codigo <> "" then
	datos_generales.agregacampocons "sede_ccod", sede_ccod
	datos_generales.agregacampocons "dcur_ncorr", dcur_ncorr
end if
datos_generales.siguiente

'--------------iniciamos variables de sessión con valor de sede y programa para la postulación------------
if sede_ccod <> "" and dcur_ncorr <> "" then
	session("sede_ccod_postulacion") = sede_ccod
	session("dcur_ncorr_postulacion") = dcur_ncorr
end if

'---------------------------------------------------------------------------------------------------
set datos_empresa = new cformulario
datos_empresa.carga_parametros "postulacion_masiva_otec.xml", "datos_empresa"
datos_empresa.inicializar conexion


consulta= " select empr_ncorr,empr_trazon_social, empr_nrut,empr_xdv, empr_tdireccion, " & vbCrlf & _
		  " ciud_ccod,empr_tfono,empr_tfax,empr_tgiro,empr_tejecutivo,empr_temail_ejecutivo " & vbCrlf & _
		  " from empresas  " & vbCrlf & _
		  " where cast(empr_nrut as varchar)='"&e_empr_nrut&"' and empr_xdv='"&e_empr_xdv&"'" 
		  
existe_empresa = conexion.consultaUno("select count(*) from empresas where cast(empr_nrut as varchar)='"&e_empr_nrut&"' and empr_xdv='"&e_empr_xdv&"'")		  
'response.write("<pre>"&consulta&"</pre>")
if existe_empresa="0" then
	consulta = "select '' as pers_ncorr"
end if
'response.write("<pre>"&consulta&"</pre>")
datos_empresa.consultar consulta 
datos_empresa.siguiente
if e_empr_nrut <> "" and e_empr_xdv <> "" then
	datos_empresa.AgregaCampoCons "empr_nrut", e_empr_nrut
	datos_empresa.AgregaCampoCons "empr_xdv", e_empr_xdv
end if

tiene_empresa_1 = conexion.consultaUno("select isnull(empr_ncorr_2,0) from ordenes_compras_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'")

tiene_otic_1 = conexion.consultaUno("select isnull(empr_ncorr,0) from ordenes_compras_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'")
	
'---------------------------------------------------------------------------------------------------
habilita_orden = "NO"
habilita_otic = "NO"
if fpot_ccod = "2" and tiene_empresa_1 > "0" then
	habilita_orden = "SI"
end if
if fpot_ccod = "3" and tiene_empresa_1 > "0" then
	habilita_orden = "SI"
end if
if fpot_ccod = "4" and tiene_empresa_1 > "0" and tiene_otic_1 > "0" then
	habilita_orden = "SI"
end if
if fpot_ccod = "4" and tiene_empresa_1 > "0" then
	habilita_otic = "SI"
end if

if habilita_otic = "SI" then'--------si financia Otic y ya ingreso empresa buscamos datos otic
	set datos_otic = new cformulario
	datos_otic.carga_parametros "postulacion_masiva_otec.xml", "datos_otic"
	datos_otic.inicializar conexion
	
	
consulta= " select empr_ncorr,empr_trazon_social, empr_nrut,empr_xdv, empr_tdireccion, " & vbCrlf & _
		  " ciud_ccod,empr_tfono,empr_tfax,empr_tgiro,empr_tejecutivo,empr_temail_ejecutivo " & vbCrlf & _
		  " from empresas  " & vbCrlf & _
		  " where cast(empr_nrut as varchar)='"&o_empr_nrut&"' and empr_xdv='"&o_empr_xdv&"'" 

existe_otic = conexion.consultaUno("select count(*) from empresas where cast(empr_nrut as varchar)='"&o_empr_nrut&"' and empr_xdv='"&o_empr_xdv&"'")			  
	if existe_otic = "0" then
		consulta = "select '' as pers_ncorr"
	end if
	datos_otic.consultar consulta 
	datos_otic.siguiente
	if o_empr_nrut <> "" and o_empr_xdv <> "" then
		datos_otic.AgregaCampoCons "empr_nrut", o_empr_nrut
		datos_otic.AgregaCampoCons "empr_xdv", o_empr_xdv
	end if
end if

'------------------------------búsqueda de datos orden de compra---------------------------------------------------
matricula = conexion.consultaUno("select ofot_nmatricula from ofertas_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
arancel = conexion.consultaUno("select ofot_narancel from ofertas_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
ocot_nalumnos = conexion.consultaUno("select isnull((select top 1 ocot_nalumnos from ordenes_compras_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'),0)")
ocot_monto_empresa = conexion.consultaUno("select isnull((select top 1 ocot_monto_empresa from ordenes_compras_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'),0)")
ocot_monto_otic = conexion.consultaUno("select isnull((select top 1 ocot_monto_otic from ordenes_compras_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'),0)")
valor_descuento = conexion.consultaUno("select isnull((select top 1 cast(tdet_ccod as varchar)+'*'+cast(ddcu_mdescuento as varchar) from ordenes_compras_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'),'0*0')")
'------------------------------------------------------------------------------------------------------------------

set datos_finales = new cformulario
datos_finales.carga_parametros "postulacion_masiva_otec.xml", "datos_finales"
datos_finales.inicializar conexion

consulta= " select '' as pers_ncorr" 

c_datos = " select '0*0' as tdet_ccod, 'SIN DESCUENTO (0%)' as tdet_tdesc "&_
          " union "&_
          " select cast(a.tdet_ccod as varchar)+'*'+cast(ddcu_mdescuento as varchar) as tdet_ccod,b.tdet_tdesc + ' ('+cast(ddcu_mdescuento as varchar)+'%)' as tdet_tdesc "&_
		  " from descuentos_diplomados_curso a, tipos_detalle b "&_
		  " where a.tdet_ccod=b.tdet_ccod and isnull(ddcu_mdescuento,0) > 0 "&_
		  " and cast(dcur_ncorr as varchar)='"&DCUR_NCORR&"'"
		  
datos_finales.consultar consulta
datos_finales.agregaCampoParam "tdet_ccod","destino","("&c_datos&")a"
datos_finales.siguiente
datos_finales.agregaCampoCons "tdet_ccod",valor_descuento
'valor_descuento = "0*0"
habilitado_ingreso_alumnos = false
if ocot_monto_empresa <> "0" or acot_monto_otic <> "0" then
	habilitado_ingreso_alumnos = true
end if

'conexion.consultaUno()
if dgso_ncorr<>"" and nord_compra<>"" and e_empr_ncorr<>"" then

existe_postulante= conexion.consultaUno("select isnull((select count(*) from postulacion_otec where  dgso_ncorr="&dgso_ncorr&" and norc_empresa="&nord_compra&"and empr_ncorr_empresa="&e_empr_ncorr&"),0)")
'response.write("<br>dgso_ncorr="&dgso_ncorr)
'response.write("<br>dgso_ncorr="&nord_compra)
'response.write("<br>"&existe_postulante)
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
var t_busqueda2;
t_busqueda2 = new CTabla("e");

function enviar(formulario){
	formulario.elements["detalle"].value="2";
  	if(preValidaFormulario(formulario)){	
		formulario.submit();
		
	}
}
function abrir() {
	
	direccion = "editar_diplomados_curso.asp";
	resultado=window.open(direccion, "ventana1","width=550,height=250,scrollbars=no, left=380, top=150");
	
 // window.close();
}
function abrir_programa() {
	var DCUR_NCORR = '<%=DCUR_NCORR%>';
	direccion = "editar_programas_dcurso.asp?dcur_ncorr=" + DCUR_NCORR;
	resultado=window.open(direccion, "ventana2","width=550,height=400,scrollbars=yes, left=380, top=100");
	
 // window.close();
}

function agregar_nuevo(formulario){
  	if(preValidaFormulario(formulario)){	
		formulario.action = "agrega_postulantes.asp";
		formulario.submit();
		
	}
}

function forma_pago(valor)
{
	forma_pago_registrada = '<%=forma_pago%>';
	//alert("forma_pago "+forma_pago_registrada+ " valor "+valor);
	if (forma_pago_registrada != valor)
	{
		alert("Se debe volver a buscar los datos para que los cambios se  vean reflejados.");
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
	if (valor=='2')//en caso de ser forma de pago empresa sin sence se debe descheckear esa opción
	{
	 document.getElementById("sence").style.visibility = "hidden" ;
	 document.edicion_persona.elements["m[0][utiliza_sence]"].checked = false;
	 document.edicion_persona.elements["_m[0][utiliza_sence]"].checked = false;
	 document.edicion_persona.elements["m[0][utiliza_sence]"].value = 0;
	 document.edicion_persona.elements["_m[0][utiliza_sence]"].value = 0;
	}
	if (valor=='3')//en caso de ser forma de pago empresa con sence se debe descheckear esa opción
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
	rut = document.edicion2.elements["e[0][empr_nrut]"].value + '-' + document.edicion2.elements["e[0][empr_xdv]"].value;

	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido.');		
		document.edicion2.elements["e[0][empr_xdv"].objeto.select();
		return false;
	}
	
	return true;	
}
function ValidaRut33()
{
	rut = document.edicion2.elements["o[0][empr_nrut]"].value + '-' + document.edicion2.elements["o[0][empr_xdv]"].value;

	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido.');		
		document.edicion2.elements["o[0][empr_xdv]"].objeto.select();
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
 var texto_rut = new String(rut);//rut de la otic
 var posicion_guion = 0;
 var otro_rut  = document.edicion2.elements["e[0][empr_nrut]"].value; //rut de la empresa
 if (otro_rut == rut)
	 {
	   alert("Imposible asignar un rut de Otic igual al de la empresa registrada para el postulante");
	   document.edicion2.elements["o[0][empr_nrut]"].value="";
	   document.edicion2.elements["o[0][empr_xdv]"].value="";
	 }
 else
	 {
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
}
function calcula_total(valor)
{
	var matricula = document.edicion2.elements["matricula"].value;
	var arancel = document.edicion2.elements["arancel"].value;
	var total = (matricula + arancel) * valor;
	var codigo    = document.edicion2.elements["seleccionado"].value;
	arreglo = codigo.split("*");
	tdet_ccod = arreglo[0];
	descuento = arreglo[1] / 100;
	if (descuento == 0)
	{
		descuento=1;
	}
	else
	{
		total = total - (total * descuento);
	}
	document.edicion2.elements["monto_calculado"].value=total;
}
function evaluar_reparticion()
{
	matricula = document.edicion2.elements["matricula"].value;
	arancel = document.edicion2.elements["arancel"].value;
	valor = document.edicion2.elements["o[0][ocot_nalumnos]"].value;
	total = ((matricula*1) + (arancel*1)) * (valor*1);
	tipo_pago = '<%=fpot_ccod%>';
	var codigo    = document.edicion2.elements["seleccionado"].value;
	arreglo = codigo.split("*");
	tdet_ccod = arreglo[0];
	descuento = arreglo[1] / 100;
	if (descuento == 0)
	{
		descuento=1;
	}
	else
	{
		total = total - (total * descuento);
	}
	document.edicion2.elements["monto_calculado"].value=total;
	
	empresa = document.edicion2.elements["o[0][ocot_monto_empresa]"].value;
	if (tipo_pago=='4')
		{otic = document.edicion2.elements["o[0][ocot_monto_otic]"].value;}
	else
		{otic = 0;}
	
	total2 = (empresa * 1) + (otic * 1);
	if (total2 == total)
	  {
	    document.edicion2.elements["resultado"].value= "OK";
	  }
	else
	  {
	    document.edicion2.elements["resultado"].value= "OK"; //Distribución no válida
	  }	
	
}

function configurar_orden_compra()
{

	matricula = document.edicion2.elements["matricula"].value;
	arancel = document.edicion2.elements["arancel"].value;
	valor = document.edicion2.elements["o[0][ocot_nalumnos]"].value;
	tipo_pago = '<%=fpot_ccod%>';
	var codigo  = document.edicion2.elements["seleccionado"].value;
	arreglo = codigo.split("*");
	tdet_ccod = arreglo[0];
	descuento = arreglo[1] / 100;
	total = ((matricula*1) + (arancel*1)) * (valor*1);
	if (descuento == 0)
	{
		descuento=1;
	}
	else
	{
		total = total - (total * descuento);
	}
	resultado = "";
	
	
	
	document.edicion2.elements["monto_calculado"].value=total;
	
	empresa = document.edicion2.elements["o[0][ocot_monto_empresa]"].value;
	if (tipo_pago=='4')
		{otic = document.edicion2.elements["o[0][ocot_monto_otic]"].value;}
	else
		{otic = 0;}
	
	total2 = (empresa * 1) + (otic * 1);
	if (total2 == total)
	  {
	    document.edicion2.elements["resultado"].value= "OK";
		resultado = "OK";
	  }
	else
	  {
	    document.edicion2.elements["resultado"].value= "OK"; //Distribución no válida
	    resultado = "ERROR";
	  }	
	 // document.edicion2.elements["o[0][tdet_ccod]"].value=tdet_ccod;
	  
	  if (resultado=="OK")
	  {
	    //alert("llegue acá");
	    _Guardar(this, document.forms['edicion2'], 'guardar_orden_masiva.asp','','', '', 'FALSE');
	  }

}

function configurar_orden_compra2(valor_lista)
{
	document.edicion2.elements["seleccionado"].value = valor_lista;
	matricula = document.edicion2.elements["matricula"].value;
	arancel = document.edicion2.elements["arancel"].value;
	valor = document.edicion2.elements["o[0][ocot_nalumnos]"].value;
	tipo_pago = '<%=fpot_ccod%>';
	total = ((matricula*1) + (arancel*1)) * (valor*1);
	//alert(valor_lista);
	codigo = valor_lista;
	arreglo = codigo.split("*");
	tdet_ccod = arreglo[0];
	descuento = arreglo[1] / 100;
	if (descuento == 0)
	{
		descuento=1;
	}
	else
	{
		total = total - (total * descuento);
	}
	
	document.edicion2.elements["monto_calculado"].value=total;
	
	empresa = document.edicion2.elements["o[0][ocot_monto_empresa]"].value;
	if (tipo_pago=='4')
		{otic = document.edicion2.elements["o[0][ocot_monto_otic]"].value;}
	else
		{otic = 0;}
	
	total2 = (empresa * 1) + (otic * 1);
	if (total2 == total)
	  {
	    document.edicion2.elements["resultado"].value= "OK";
	  }
	else
	  {
	    document.edicion2.elements["resultado"].value= "OK"; //Distribución no válida
	  }	
	
}

function agregar_postulantes() 
{
	var dgso_ncorr = '<%=dgso_ncorr%>';
	var fpot_ccod = '<%=fpot_ccod%>';
	var rut_empresa = '<%=e_empr_nrut%>';
	var rut_otic = '<%=o_empr_nrut%>';
	var nord_compra = '<%=nord_compra%>';
	direccion = "agrega_postulantes_masivos.asp?dgso_ncorr="+dgso_ncorr+"&fpot_ccod="+fpot_ccod+"&nord_compra="+nord_compra+"&rut_empresa="+rut_empresa+"&rut_otic="+rut_otic;
	resultado = window.open(direccion, "ventana2","width=600, height=550, scrollbars=yes, left=380, top=100");
}

function verifica_fpote()
{

}
</script>
<% f_busqueda.generaJS %>
</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="580" height="100%">
<tr valign="top" height="30">
	<td bgcolor="#EAEAEA">
</td>
</tr>
<tr valign="top">
	<td bgcolor="#EAEAEA">
<table width="652" border="0" align="left" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA" align="center">
	<table width="90%">
	<tr>
		<td align="center">
	
	<table width="50%"  border="0" align="left" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
                    <td width="20%"><strong>Año</strong></td>
					<td width="3%"><strong>:</strong></td>
                    <td><%f_busqueda.dibujaCampoLista "lBusqueda", "anio_admision" %></td>
                 </tr>
				  <tr>
                    <td width="20%"><strong>Sede</strong></td>
					<td width="3%"><strong>:</strong></td>
                    <td><%f_busqueda.dibujaCampoLista "lBusqueda", "sede_ccod" %></td>
                 </tr>
				 <tr>
                    <td width="20%"><strong>Módulo</strong></td>
					<td width="3%"><strong>:</strong></td>
                    <td><%f_busqueda.dibujaCampoLista "lBusqueda", "dcur_ncorr"%></td>
                 </tr>
				 <tr>
                          <td colspan="3" align="left">
                            <table width="90%" border="0">
                              <tr>
                                <td width="100%">
                                  <table width="100%" border="0">
								  <%if cdbl(existe_postulante)=0 then%>
                                    <tr>
                                      <td colspan="4" align="left"><strong>Método de pago la postulanción:</strong></td>
                                    </tr>
									
                                    <tr>
                                      <td width="33%" align="center">Empresa sin SENCE</td>
                                      <td width="34%" align="center">Empresa con SENCE</td>
                                      <td width="33%" align="center">Empresa con OTIC</td>
                                    </tr>
								
                                    <tr>
                                      <td width="33%" align="center">
                                        <%if fpot_ccod = "2" then %>
                                        <input type="radio" name="b[0][fpot_ccod]" value="2" checked >
                                        <%else%>
                                        <input type="radio" name="b[0][fpot_ccod]" value="2" >
                                        <%end if%>                                      </td>
                                      <td width="25%" align="center">
                                        <%if fpot_ccod = "3" then %>
                                        <input type="radio" name="b[0][fpot_ccod]" value="3" checked >
                                        <%else%>
                                        <input type="radio" name="b[0][fpot_ccod]" value="3" >
                                        <%end if%>                                      </td>
                                      <td width="25%" align="center">
                                        <%if fpot_ccod = "4" then %>
                                        <input type="radio" name="b[0][fpot_ccod]" value="4" checked >
                                        <%else%>
                                        <input type="radio" name="b[0][fpot_ccod]" value="4" >
                                        <%end if%>                                      </td>
                                    </tr>
									<%end if%>
                                </table></td>
                              </tr>
                          </table></td>
                 </tr>
                 <tr>
                 	<td colspan="3" align="left">
                      <table width="100%" cellpadding="0" cellspacing="0">
                      	<tr>
                        	<td width="20%" align="left"><strong>N° Orden de Compra</strong></td>
                            <td width="3%" align="center"><strong>:</strong></td>
                            <td width="50%" align="left"><%f_busqueda.dibujaCampo "nord_compra" %></td>
                            <td width="27%" align="left"><%botonera.dibujaboton "buscar"%></td>
                        </tr>
                      </table>
                    </td>
                 </tr>
                  
				 <tr> 
				  <td colspan="3"><input type="hidden" name="detalle" value=""></td>
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
	
	<%if nord_compra <> "" then %>
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
            <td><%pagina.DibujarLenguetas Array("Ingreso información orden de compra"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
                <table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>                        <div align="center"><%pagina.DibujarTituloPagina%> <br>
                    </div></td>
                    </tr>
                  
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <%if dcur_tdesc <> "" and nord_compra <> "" then %>
				  <tr>
                    <td><%response.Write("AÑO: <strong>"&anio_admision&"</strong>")%></td>
                  </tr>
				  <tr>
                    <td><%response.Write("SEDE: <strong>"&sede_tdesc&"</strong>")%></td>
                  </tr>
				  <tr>
                    <td><%response.Write("PROGRAMA: <strong>"&dcur_tdesc&"</strong>")%></td>
                  </tr>
				  <tr>
                    <td><%response.Write("CÓDIGO SENCE: <strong>"&dcur_nsence&"</strong>")%></td>
                  </tr>
				  <tr>
				  	<td><%=periodo_programa%>
					</td>
				  </tr>
                  <tr>
                    <td><%if fpot_ccod = "2" then
					         tpot_tdesc = "Empresa sin Sence"
						  elseif fpot_ccod = "3" then
					         tpot_tdesc = "Empresa con Sence"
						  elseif fpot_ccod = "4" then
					         tpot_tdesc = "Empresa con Otic"
						  end if
					      response.Write("FORMA DE PAGO: <font color='#990000'><strong>"&tpot_tdesc&"</strong></font>")%></td>
                  </tr>
                  <tr>
                    <td><%response.Write("ORDEN DE COMPRA: <font color='#990000'><strong>"&nord_compra&"</strong></font>")%></td>
                  </tr>
				  <tr>
					  <td>&nbsp;</td>
				  </tr>
				  <%end if%>
				  <tr>
                    <td>
                    	<table width="100%" cellpadding="0" cellspacing="0" align="left">
                    		<form name="edicion2">
                                <input type="hidden" name="b[0][anio_admision]" value="<%=anio_admision%>">
								<input type="hidden" name="b[0][sede_ccod]" value="<%=sede_ccod%>">
								<input type="hidden" name="b[0][dcur_ncorr]" value="<%=dcur_ncorr%>">
                                <input type="hidden" name="b[0][nord_compra]" value="<%=nord_compra%>">
                                <tr>
                                  <td colspan="6">&nbsp;</td>
                                </tr>
                                <tr>
                                  <td colspan="6" align="center" bgcolor="#999999"><font size="+2" face="Times New Roman, Times, serif" color="#FFFFFF"><strong>PASO 1</strong></font></td>
                                </tr>
                                <%if (fpot_ccod="2" or fpot_ccod="3" or fpot_ccod="4") and nord_compra <> "" then%>
                                <tr>
                                  <td colspan="6" align="left"><strong>------DATOS EMPRESA------</strong></td>
                                </tr>
                                <tr>
                                  <input type="hidden" name="b[0][fpot_ccod]" value="<%=fpot_ccod%>">
                                  <td width="10%"><strong>Rut</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_empresa.dibujaCampo("empr_nrut")%>
                                    -
                                      <%datos_empresa.dibujaCampo("empr_xdv")%></td>
                                  <td width="10%" align="right"><strong>Razón Social</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_empresa.dibujaCampo("empr_trazon_social")%>
                                      <%datos_empresa.dibujaCampo("pote_ncorr")%></td>
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
                                <tr>
                                  <td colspan="6" align="left">
                                    <table width="100%" cellpadding="0" cellspacing="0" id="bt_empresa" style="visibility:visible">
                                      <tr>
                                        <td align="right"><%f_botonera.dibujaBoton "guardar_empresas"%></td>
                                      </tr>
                                  </table></td>
                                </tr>
                                <%end if%>
                                <%'response.Write("--------**********--------- "&tiene_empresa)
                                  if habilita_otic = "SI" then%>
                                <tr>
                                  <td colspan="6" align="left"><strong>------DATOS OTIC------</strong></td>
                                </tr>
                                <tr>
                                  <td width="10%"><strong>Rut</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_otic.dibujaCampo("empr_nrut")%>
                                    -
                                      <%datos_otic.dibujaCampo("empr_xdv")%></td>
                                  <td width="10%" align="right"><strong>Razón Social</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_otic.dibujaCampo("empr_trazon_social")%></td>
                                </tr>
                                <tr>
                                  <td width="10%"><strong>Dirección</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_otic.dibujaCampo("empr_tdireccion")%></td>
                                  <td width="10%" align="right"><strong>Comuna</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_otic.dibujaCampo("ciud_ccod")%></td>
                                </tr>
                                <tr>
                                  <td width="10%"><strong>Teléfono</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_otic.dibujaCampo("empr_tfono")%></td>
                                  <td width="10%" align="right"><strong>Fax</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_otic.dibujaCampo("empr_tfax")%></td>
                                </tr>
                                <tr>
                                  <td width="10%"><strong>Giro</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_otic.dibujaCampo("empr_tgiro")%></td>
                                  <td width="10%" align="right"><strong>Nombre Ejecutivo</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_otic.dibujaCampo("empr_tejecutivo")%></td>
                                </tr>
                                <tr>
                                  <td width="10%"><strong>E-mail Ejecutivo</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td colspan="4"><%datos_otic.dibujaCampo("empr_temail_ejecutivo")%></td>
                                </tr>
                                <tr>
                                  <td colspan="6" align="left">
                                    <table width="100%" cellpadding="0" cellspacing="0" id="bt_otic" style="visibility:visible">
                                      <tr>
                                        <td align="right"><%f_botonera.dibujaBoton "guardar_otic"%></td>
                                      </tr>
                                  </table></td>
                                </tr>
                                <%end if%>
                                <%if habilita_orden = "SI" then%>
                                <tr>
                                  <td colspan="6">&nbsp;</td>
                                </tr>
                                <tr>
                                  <td colspan="6" align="center"><table width="98%" border="1">
                                      <tr>
                                        <td align="center"> 
                                                <table width="100%" cellpadding="0" cellspacing="0">
                                                  <tr>
                                                    <td align="left" colspan="6"><strong>-----Datos Orden de Compra------</strong></td>
                                                  </tr>
                                                  <tr>
                                                    <td width="7%" align="left"><strong>Programa</strong></td>
                                                    <td width="1%" align="left"><strong>:</strong></td>
                                                    <td align="left" colspan="4"><%=dcur_tdesc%></td>
                                                  </tr>
                                                  <tr>
                                                    <td width="7%" align="left"><strong>Matrícula</strong></td>
                                                    <td width="1%" align="left"><strong>:</strong></td>
                                                    <td width="42%" align="left">$<%=matricula%><input type="hidden" name="matricula" value="<%=matricula%>"></td>
                                                    <td width="7%" align="left"><strong>Arancel</strong></td>
                                                    <td width="1%" align="left"><strong>:</strong></td>
                                                    <td width="42%" align="left">$<%=arancel%><input type="hidden" name="arancel" value="<%=arancel%>"></td>
                                                  </tr>
                                                  <tr>
                                                    <td width="7%" align="left"><strong>Orden de Compra</strong></td>
                                                    <td width="1%" align="left"><strong>:</strong></td>
                                                    <td width="42%" align="left"><%=nord_compra%></td>
                                                    <td width="7%" align="left"><strong>Total Alumnos</strong></td>
                                                    <td width="1%" align="left"><strong>:</strong></td>
                                                    <td width="42%" align="left"><input type="text" name="o[0][ocot_nalumnos]" value="<%=ocot_nalumnos%>" size="10" maxlength="3" onChange="calcula_total(this.value);"></td>
                                                  </tr>
                                                  <%if fpot_ccod = "4" then%>
                                                  <tr>
                                                    <td width="7%" align="left"><strong>Monto Empresa</strong></td>
                                                    <td width="1%" align="left"><strong>:</strong></td>
                                                    <td width="42%" align="left"><input type="text" name="o[0][ocot_monto_empresa]" value="<%=ocot_monto_empresa%>" size="10" maxlength="8" onChange="evaluar_reparticion();">$</td>
                                                    <td width="7%" align="left"><strong>Monto Otic</strong></td>
                                                    <td width="1%" align="left"><strong>:</strong></td>
                                                    <td width="42%" align="left"><input type="text" name="o[0][ocot_monto_otic]" value="<%=ocot_monto_otic%>" size="10" maxlength="8" onChange="evaluar_reparticion();">$</td>
                                                  </tr>
                                                  <%else%>
                                                  <tr>
                                                    <td width="7%" align="left"><strong>Monto Empresa</strong></td>
                                                    <td width="1%" align="left"><strong>:</strong></td>
                                                    <td width="42%" align="left" colspan="4"><input type="text" name="o[0][ocot_monto_empresa]" value="<%=ocot_monto_empresa%>" size="10" maxlength="8" onChange="evaluar_reparticion();">$</td>
                                                  </tr>
                                                  <%end if%>
                                                  <tr>
                                                    <td width="7%" align="left"><strong>Monto calculado</strong></td>
                                                    <td width="1%" align="left"><strong>:</strong></td>
                                                    <td width="42%" align="left"><input type="text" name="monto_calculado" value="" size="8" style="background:#d8d8de; border:none; color:#0000CC;"></td>
                                                    <td width="7%" align="left"><strong>&nbsp;</strong></td>
                                                    <td width="1%" align="left"><strong>&nbsp;</strong></td>
                                                    <td width="42%" align="left"><input type="text" name="resultado" value="" size="30" style="background:#d8d8de; border:none; color:#990000">
                                                    <input type="hidden" name="o[0][tdet_ccod]" value=""></td>
                                                  </tr>
                                                  <tr>
                                                    <td width="7%" align="left"><strong>Descuento</strong></td>
                                                    <td width="1%" align="left"><strong>:</strong></td>
                                                    <td align="left" colspan="4"><%datos_finales.dibujaCampo("tdet_ccod")%><input type="hidden" name="seleccionado" value="<%=valor_descuento%>"></td>
                                                  </tr>
                                                  <tr>
                                                    <td colspan="6" align="right">&nbsp;</td>
                                                  </tr>
                                                  <tr>
                                                    <td colspan="6" align="right"><%f_botonera.dibujaBoton "configurar_orden_compra"%></td>
                                                  </tr>
                                                </table>
                                        </td>
                                      </tr>
                                  </table></td>
                                </tr>
									<%if habilitado_ingreso_alumnos then%>
                                        <tr>
                                          <td colspan="6">&nbsp;</td>
                                        </tr>
                                        <tr>
                                          <td colspan="6" align="center" bgcolor="#999999"><font size="+2" face="Times New Roman, Times, serif" color="#FFFFFF"><strong>PASO 2</strong></font></td>
                                       </tr>
                                       <tr>
                                          <td colspan="6" bgcolor="#999999" align="center"><%f_botonera.dibujaBoton "agregar_alumnos"%></td>
                                        </tr>
                                        <tr>
                                          <td colspan="6" bgcolor="#999999" align="center">&nbsp;</td>
                                        </tr>
                                    <%end if%>
                                <%end if%>
                              </form>    
                        </table>
                    </td>
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
  <%end if 'de nord_compra %> 
</table>
</td>
</tr>
</table>
</body>
</html>

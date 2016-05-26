<!-- #include file = "../biblioteca/_conexion.asp" -->

<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
pers_nrut=Request.QueryString("a[0][pers_nrut]")
pers_xdv=Request.QueryString("a[0][pers_xdv]")
peri_ccod=Request.QueryString("a[0][peri_ccod_busqueda]")
tici_ccod=Request.QueryString("a[0][tici_ccod]")
'---------------------------------------------------------------------------------------------------
set errores = new CErrores

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
f_botonera.Carga_Parametros "alumnos_intercambio_extranjero.xml", "botonera"


set f_univ_convenios = new CFormulario
f_univ_convenios.Carga_Parametros "alumnos_intercambio_extranjero.xml", "universidades_convenio"
f_univ_convenios.Inicializar conexion
sql_descuentos="select a.pais_ccod,pais_tdesc,b.ciex_ccod,ciex_tdesc,c.univ_ccod,univ_tdesc"& vbcrlf & _
				"from paises a,"& vbcrlf & _
				"ciudades_extranjeras b,"& vbcrlf & _
				"universidad_ciudad c,"& vbcrlf & _
				"universidades d"& vbcrlf & _
				"where a.pais_ccod=b.pais_ccod"& vbcrlf & _
				"and b.ciex_ccod=c.ciex_ccod"& vbcrlf & _
				"and c.univ_ccod=d.univ_ccod"& vbcrlf & _
				"order by pais_tdesc,ciex_tdesc,univ_tdesc"				
f_univ_convenios.Consultar sql_descuentos
f_univ_convenios.inicializaListaDependiente "lBusqueda", sql_descuentos
f_univ_convenios.siguiente


f_univ_convenios.AgregaCampoCons "pais_ccod",pais_ccod
f_univ_convenios.AgregaCampoCons "ciex_ccod",ciex_ccod
f_univ_convenios.AgregaCampoCons "univ_ccod",univ_ccod






%>

<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<% 
f_univ_convenios.generaJS 
%>

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" src="jquery-1.6.2.min.js"></script>

<script language="JavaScript">
var errores=''
function generar()
{
	result=validador()
	//alert(result)
	if(result=="0")
	{
					$("#foto").css("display","inline");
					datos_envi= $("form").serialize();
					//alert(datos_envi)
					//location.href="genera_link.asp?"+datos_envi
			
				$.ajax({
						url: "genera_link.asp",
						beforeSend: function(objeto){
							$("#foto").css("display","inline");  
						},
						complete: function(objeto, exito){
							$("#foto").css("display","none");
							if(exito=="success"){
								$("#link").css("display","inline");
								$("#fex").css("display","inline");
							}
						},
						data: datos_envi, 
						dataType: "json",
						error: function(objeto, quepaso, otroobj){
							//alert("Error: "+quepaso+" "+otroobj);
						},
						success: function(datos){
							$("#txt_link").val("http://admision.upacifico.cl/postulacion_intercambio/www/home.php?id="+datos.link)
							$("#txt_fexpiracion").val(datos.fecha)
							alert("El link se ha generado")
						},
						type: "POST"
				});
		
		}
		else
		{
			//alert(errores)
			errores=''
		}
	
}

function editar()
{
$("#txt_fexpiracion").css("border-width","1");
$("#txt_fexpiracion").css("background","ffffff");
$("#txt_fexpiracion").css("padding","1");
//$("#txt_fexpiracion").attr("readOnly ","false")

document.getElementById('txt_fexpiracion').readOnly=false;

//border-style: solid; border-width: 0; padding: 0; background-color:#D8D8DE
}

var patron = new Array(2,2,4)
function mascara(d,sep,pat,nums){
if(d.valant != d.value){
	val = d.value
	largo = val.length
	val = val.split(sep)
	val2 = ''
	for(r=0;r<val.length;r++){
		val2 += val[r]	
	}
	if(nums){
		for(z=0;z<val2.length;z++){
			if(isNaN(val2.charAt(z))){
				letra = new RegExp(val2.charAt(z),"g")
				val2 = val2.replace(letra,"")
			}
		}
	}
	val = ''
	val3 = new Array()
	for(s=0; s<pat.length; s++){
		val3[s] = val2.substring(0,pat[s])
		val2 = val2.substr(pat[s])
	}
	for(q=0;q<val3.length; q++){
		if(q ==0){
			val = val3[q]
		}
		else{
			if(val3[q] != ""){
				val += sep + val3[q]
				}
		}
	}
	d.value = val
	d.valant = val
	}
}

function validar(fecha)
{
es_f=isFecha(fecha)
	if (es_f!=true)
	{
		alert("Debes ingresar un fecha válida")
		//document.postulacion.elements['a[0][lipe_fexpiracion]'].focus()
		//document.postulacion.elements['a[0][lipe_fexpiracion]'].select()
		document.getElementById('txt_fexpiracion').focus();
		document.getElementById('txt_fexpiracion').select()
		
	
	}

}

 $(document).ready(function() {

		if('<%=tici_ccod%>'=='1')
		{
			document.getElementById('uno').checked=true;
			document.getElementById('dos').checked=false;
		}
		else if('<%=tici_ccod%>'=='2')
		{
			document.getElementById('uno').checked=false;
			document.getElementById('dos').checked=true;
		}

    });

function llenarSelectPais(valor)
{
	$.post("obtener_pais_select.asp", { tici: valor }, function(data){
			$("#pais_ccod").html(data);
			
			});
	data=''
	$("#ciex_ccod").html(data);	
	$("#univ_ccod_s").html(data);			
}


function PaisesXTipoIntercambio(opcion)
{
//alert(opcion)
	if (opcion=="1")
	{
		//llenamos select de paises
		llenarSelectPais(opcion)
				
		$("#univ_ccod_s").removeAttr('disabled');
		//$("#univ_ccod_s").attr('disabled','');
		$("#univ_ccod_txt").attr('disabled','disabled');
		
		$("#univ_ccod_s").css({display:"inline"});
		$("#univ_ccod_txt").css({display:"none"});
	
	}
	else if (opcion=="2") 
	{
		llenarSelectPais(opcion)
		
			
		$("#univ_ccod_s").attr("disabled","disabled");
		//$("#univ_ccod_txt").attr('disabled','');
		$("#univ_ccod_txt").removeAttr('disabled');
		
		
		$("#univ_ccod_s").css({display:"none"});
		$("#univ_ccod_txt").css({display:"inline"});
	}

}

$(document).ready(function() {
$("#pais_ccod").change(function () {
   		$("#pais_ccod option:selected").each(function () {
			//alert($(this).val());
			pais_selec=$(this).val();
			tici_v=$('[name="a[0][tici_ccod]"]:checked').val();
			//alert(tici_v)
				$.post("obtener_ciudad_select.asp", { pais: pais_selec,tici:tici_v}, function(data){
					$("#ciex_ccod").html(data);
						if (pais_selec=='')
					   {
						 data=''
						 $("#ciex_ccod").html(data);
						}
					
							$("#univ_ccod_s").html('');	
				});	
				
						
			});
	   })
	   
	   
$("#ciex_ccod").change(function () {
tici_v=$('[name="a[0][tici_ccod]"]:checked').val();
	   if (tici_v='1')
		{ 		
			$("#ciex_ccod option:selected").each(function () {
				//alert($(this).val());
				ciex_selec=$(this).val();
				
				//alert(tici_v)
					$.post("obtener_universidad_select.asp", { ciex: ciex_selec}, function(data){
						$("#univ_ccod_s").html(data);
							if (ciex_selec=='')
						   {
							 data=''
							 $("#univ_ccod_s").html(data);
							}
					});	
					
							
				});
		  }
	   })
	   
llenarSelectPais("1")	   
});



function validador()
{
peri=$('[name="a[0][peri_ccod]"] option:selected').val();
idio=$('[name="a[0][idio_ccod]"] option:selected').val();
tici=$('[name="a[0][tici_ccod]"]:checked').val();
pais=$('[name="a[0][pais_ccod]"] option:selected').val();
ciex=$('[name="a[0][ciex_ccod]"] option:selected').val();
univ_ccod_s=$("#univ_ccod_s").val();
univ_ccod_txt=$("#univ_ccod_txt").val();


//alert('p='+peri+' id='+idio+' ti='+tici+' pa='+pais+' ci='+ciex+' uns='+univ_ccod_s+' unt='+univ_ccod_txt)

	error=0
	if (peri!='')
	{
	 error=error+0
	}
	else
	{
	 error=error+1
	 errores=errores+'\n debes Seleccionar un Periodo Academico '
	}
	
	if (idio!='')
	{
	error=error+0
	}
	else
	{
	 error=error+1
	 errores=errores+'\n debes Seleccionar un Idioma '
	}
	
	if (tici!='')
	{
	error=error+0
	}
	else
	{
	 error=error+1
	 errores=errores+'\n debes Seleccionar que tipo de intercambio'
	}
	
	if (pais!='')
	{
	 error=error+0
	}
	else
	{
	 error=error+1
	 errores=errores+'\n debes Seleccionar un Pais'
	}
	
	if (ciex!='')
	{
	 error=error+0
	}
	else
	{
	 error=error+1
	 errores=errores+'\n debes Seleccionar una Ciudad'
	}
	
	if ((univ_ccod_s!='')&&(tici=='1'))
	{
	 error=error+0
	}
	else if ((univ_ccod_s=='')&&(tici=='1'))
	{
	 error=error+1
	 errores=errores+'\n debes Seleccionar una Universidad'
	}
	
	if ((univ_ccod_txt!='')&&(tici=='2'))
	{
	 error=error+0
	}
	else if ((univ_ccod_txt=='')&&(tici=='2'))
	{
	 error=error+1
	 errores=errores+'\n debes Ingresar una Universidad'
	}

return error

}





</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');" onBlur="revisaVentana();">
<table width="750"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td><%pagina.DibujarLenguetas Array("Crear Link para Postulacion Extranjera"), 1 %></td>
				  </tr>
				  <tr>
					<td height="2" background="../imagenes/top_r3_c2.gif"></td>
				  </tr>
				  <tr>
					<td>
						 
						<form name="postulacion" id="form">
							<br>
							
							<table align="center" width="100%">
								<tr>
								  <td width="29%"><strong>Periodo Acad&eacute;mico Intercambio </strong></td>
								  <td width="71%"><%f_univ_convenios.DibujaCampo("peri_ccod")%></td>
								</tr>
								<tr>
								  <td width="29%"><strong>Idioma en que se mostrara</strong></td>
								  <td width="71%"><%f_univ_convenios.DibujaCampo("idio_ccod")%></td>
								</tr>
								<tr>
								   <td width="29%"><strong>Intercambio Estudiantil (Convenios Intercambio)</strong></td>
							      <td width="71%"><input type="radio" name="a[0][tici_ccod]" id="uno" value="1" onClick="PaisesXTipoIntercambio(this.value)" checked="checked"/></td>
								</tr>
								<tr>
								   <td><strong>Programa Study Abroad</strong></td>
								   <td valign="top"><input type="radio" name="a[0][tici_ccod]" id "dos" value="2" onClick="PaisesXTipoIntercambio(this.value)"/></td>
								</tr>
							</table>
							
							<br>
							<label><strong><font size="2">Lugar de Intercambio</font></strong></label>
							<table width="100%">
								<tr>
									<td width="10%"><strong>Pais</strong></td>
								    <td width="25%"><select name="a[0][pais_ccod]" id="pais_ccod"></select></td>
									<td width="6%" align="right"><strong>Ciudad</strong></td>
						          <td width="59%"><select name="a[0][ciex_ccod]" id="ciex_ccod"></select></td>
								</tr>
								<tr>
									<td width="10%"><strong>Universidad</strong></td>
									<td colspan="3"><select name="a[0][univ_ccod]" id="univ_ccod_s" ></select> <input type="text" name="a[0][univ_ccod2]" id="univ_ccod_txt"  style="display:none" value"" onKeyUp='this.value=this.value.toUpperCase();'></td>
								</tr>
							</table>
						 
						 
						 <div align="center">
						 		<div id="foto" align="center" style="display:none"><img src="imagenes/ajax-loader.gif"/></div>
								<div id="link"  align="center" style="display:none">Link Postulaci&oacute;n Extranjera &nbsp;&nbsp;<input type="text" name="link" id="txt_link" size="100" readonly="true"/></div>
								</br>
								<div id="fex"  align="center" style="display:none">Fecha Expiraci&oacute;n&nbsp;&nbsp;<input type="text"  name="a[0][lipe_fexpiracion]" id="txt_fexpiracion" size="11" maxlength="10" onKeyUp="mascara(this,'/',patron,true)" onBlur="validar(this.value)" readonly style="border-style: solid; border-width: 0; padding: 0; background-color:#D8D8DE" /></div>
						 </div>
						 </form>
					</td>
				  </tr>
        	</table>
		</td>
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
					<%f_botonera.DibujaBoton"generar"%></div></td>
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
	</td>
  </tr>  
</table>
</body>
</html>
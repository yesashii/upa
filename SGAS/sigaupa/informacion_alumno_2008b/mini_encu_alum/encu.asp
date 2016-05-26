<!-- #include file = "../../biblioteca/_conexion.asp" -->
<!-- #include file = "../../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../../biblioteca/_negocio.asp" -->
<% 
'------------------------------------------------------
set errores= new CErrores
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
 


 
 

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Bienvenido a Universidad del Pac&iacute;fico Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<script language="JavaScript" src="../../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../../biblioteca/validadores.js"></script>

<link href="jquery/style.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="jquery/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="jquery/jquery.jcarousel.min.js"></script>


<script type="text/javascript">
/*jQuery(document).ready(function() {
    jQuery('#mycarousel').jcarousel();
});*/

function mycarousel_initCallback(carousel) {
    jQuery('.jcarousel-control a').bind('click', function() {
        carousel.scroll(jQuery.jcarousel.intval(jQuery(this).text()));
        return false;
    });
 
    jQuery('.jcarousel-scroll select').bind('change', function() {
        carousel.options.scroll = jQuery.jcarousel.intval(this.options[this.selectedIndex].value);
        return false;
    });
 
    jQuery('#mycarousel-next').bind('click', function() {
        carousel.next();
        return false;
    });
 
    jQuery('#mycarousel-prev').bind('click', function() {
        carousel.prev();
        return false;
    });
};
 
// Ride the carousel...
jQuery(document).ready(function() {
    jQuery("#mycarousel").jcarousel({
        scroll: 1,
		wrap: 'circular',
        initCallback: mycarousel_initCallback,
        // This tells jCarousel NOT to autobuild prev/next buttons
        buttonNextHTML: null,
        buttonPrevHTML: null
    });
});
	
	
function salir(){
window.close();
}
function verifica()
{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=4;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.alumno.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.alumno.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="alumn"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 return true
  }
  else
  {
   return false
   
  }
}
function envia()
{//alert('hola')
valor=verifica();

	if (valor)
	{
		//alert(document.getElementById('b_votar').onClick)
		//document.getElementById('b_votar').onClick='';
		document.alumno.action="guardar_encu.asp"
		//alert(document.getElementById('b_votar').onClick)
		document.alumno.submit();
	}
	else
	{
		alert("Debes Elegir un alumno")
	}

}

</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"  background="images/fondo.jpg">
<br>
<br>
<table align="center" width="600" cellpadding="0" cellspacing="0" border="0">
	
	<tr>
		<td><img src="images/acreditada.png" width="260" height="126"/></td>
		<td></td>
	</tr>
	<tr>
		<td align="center" width="100%"><img src="images/alumnos.png" width="1040"/></td>
	</tr>
	<tr>
		<td width="100%" align="left">
			<table width="600" cellpadding="0" cellspacing="0" border="0">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" >
						<div>

						<div id="mycarousel" class="jcarousel-skin-tango">
						    <ul>
						        <li><img src="images/15842305_C.png"/></li>     
						        <li><img src="images/15934379_C.png"/></li>     
						        <li><img src="images/16426889_C.png"/></li>     
						        <li><img src="images/17082787_C.png"/></li>     
						    </ul>
						</div>
							<div  align="center">
							  <form action="">
								<a  id="mycarousel-prev" style="border:none; cursor:pointer"><img src="images/antes.png"/></a>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<a  id="mycarousel-next" style="border:none; cursor:pointer"><img src="images/siguiente.png"/></a>
							  </form>
							</div>
							<div align="left" style="float:left">
							
							<form name="alumno" method="post">
							<p><input type="radio" name="alumn" value="113334"/><img src="images/mariquez.png"/></p>
							<p><input type="radio" name="alumn" value="116422"/><img src="images/navarrete.png"/></p>
							<p><input type="radio" name="alumn" value="118251"/><img src="images/meneses.png"/></p>
							<p><input type="radio" name="alumn" value="116125"/><img src="images/RABB.png"/></p>
							</form>
							</div>
							<div class="botones" align="right" style="float:rigth; padding:40px,170px,0px,0px">
							
							<p><img src="images/b_votar.png" id="b_votar" onClick="envia();" alt="Votar" style="cursor:pointer" />&nbsp;&nbsp;<img src="images/b_salir.png" onClick="salir()" alt="Salir" style="cursor:pointer"/></p>
							</div>
						</div>
						</table>					
						</td>
				</tr>
			</table>		</td>
	</tr>
</table>
</body>
</html>


var x = $(document);
x.ready(inicio);
function inicio()
{
	verVersion();
}
function verVersion()
{
	checkVersion();
}

/**
 * Returns the version of Internet Explorer or a -1
 * (indicating the use of another browser).
 */
function getInternetExplorerVersion()
{
    var rv = -1; // Return value assumes failure.

    if (navigator.appName == 'Microsoft Internet Explorer')
    {
        var ua = navigator.userAgent;
        var re  = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
        if (re.exec(ua) != null)
            rv = parseFloat( RegExp.$1 );
    }

    return rv;
}

function checkVersion()
{
    var ver = getInternetExplorerVersion();

   if (ver <= -1)
   {
		$("#controlversion").append("<h2><P style='BACKGROUND-COLOR: orange'align=center><FONT color=# ff0000>&iexcl;ATENCI&Oacute;N!<br/><br/>El sistema SGA, est&aacute; desarrollado para funcionar con Internet Explorer 10 o inferior con vista de compatibilidad.<br/>Por favor, utilice el navegador mencionado.<br/><br/></FONT></P></h2>");
		$('#evaluacion').attr("disabled", true);
		$('#bt_aceptar7055f21').attr("disabled", true);
   }
   if (ver == 10)
   {   
   
		$("#controlversion").append("<h3><P style='BACKGROUND-COLOR: orange'align=center><FONT color=# ff0000>Con la configuraci&oacute;n actual de su navegador, el sistema no funcionar&aacute; en condiciones &oacute;ptimas.</FONT></P></h3>");
		$("#controlversion").append("<img WIDTH=100% HEIGHT=200 src='portada/img/compati.jpg'/><br /><br />");
		//$('#controlversion').prepend($('<img>',{id:'theImg',src:'portada/img/ima_1.png'}))
   }
      if (ver > 10)
   {
		$("#controlversion").append("<h3><P style='BACKGROUND-COLOR: orange'align=center><FONT color=# ff0000>La configuraci&oacute;n de su navegador, no corresponde a la utilizada por el sistema.<br/>Para solucionar este problema comun&iacute;quese a:<br/>Anexo: 5292.<br/>o al correo electr&oacute;nico:<br/>hcastillo@upacifico.cl<br/>H&eacute;ctor Castillo.</FONT></P></h3>");
   }
   
}













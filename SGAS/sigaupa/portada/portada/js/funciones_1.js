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

   if ( !esExplorer() )
   {
		$("#controlversion").append("<h2><P class ='resaltar' style='BACKGROUND-COLOR: orange'align=center><FONT>&iexcl;ATENCI&Oacute;N!<br/><br/>El sistema SGA, est&aacute; desarrollado para funcionar con Internet Explorer 10.<br/>Por favor, utilice el navegador mencionado.<br/><br/></FONT></P></h2>");
	 //	esconderAceptar();
   }
   if (explorer10())
   {
		$("#controlversion").append("<h3><P class ='resaltar' style='BACKGROUND-COLOR: orange'align=center><FONT>Con la configuraci&oacute;n actual de su navegador, el sistema no funcionar&aacute; en condiciones &oacute;ptimas.</FONT></P></h3>");
		$("#controlversion").append("<img WIDTH=100% HEIGHT=200 src='portada/img/compati.jpg'/>");
		//$('#controlversion').prepend($('<img>',{id:'theImg',src:'portada/img/ima_1.png'}))

	//	esconderAceptar();
	 }
      if (explorerMayor10())
   {
		$("#controlversion").append("<h3><P class ='resaltar' style='BACKGROUND-COLOR: orange'align=center><FONT color=# ff0000>La configuraci&oacute;n de su navegador, no corresponde a la utilizada por el sistema.<br/>Para solucionar este problema comun&iacute;quese a:<br/>Anexo: 5292.<br/>o al correo electr&oacute;nico:<br/>hcastillo@upacifico.cl<br/>H&eacute;ctor Castillo.</FONT></P></h3>");
	//	esconderAceptar();
	 }

}

// true si es explorer, false si no es explorer
function esExplorer()
{
	var ver = getInternetExplorerVersion();
	if (ver <= -1)
	{
		return false;
	}else{
		return true;
	}

}

// true si es explorer10, false si no es explorer10
function explorer10()
{
	var ver = getInternetExplorerVersion();
	if (ver == 10)
	{
		return true;
	}else{
		return false;
	}
}
// true si es explorer>10, false si no es explorer>10
function explorerMayor10()
{
	var ver = getInternetExplorerVersion();
	if(ver > 10)
	{
		return true;
	}else{
		return false;
	}
}

function esconderAceptar()
{
	$("#text_clave").html("<p class='resaltar'>Navegador, no compatible</p>");
	$("#bt_aceptar7055").attr('disabled', true);
}

// true si el usuario está en la lista de debug : lista de debug es para poder probar errores ya que no los muestra en explorer
function usuarioDebug( boolValor )
{
	if( boolValor == 1 )
	{
		return true;
	}else{
		return false;
	}
}

function esUsuario(valor_s)
{
	var valor = valor_s.toUpperCase();
	urlAux="portada/trozosHtml/compruebaUsuario.asp?usuario="+valor;
	$.ajax({
		async:true,
		type: "GET",
		url: urlAux,
		//beforeSend:inicioEnvioCombo_2,
		success:llegadaUsuario,
		error:problemasUsuario
	});
	return false;
}

function llegadaUsuario(datos)
{
	if(! usuarioDebug(datos) )
	{
		if(!esExplorer())
		{
			esconderAceptar();
		}

	}else{
		$("#btn_aceptar").attr('disabled', false);
		$("#text_clave").html('<input name="datos[0][clave]" id="TO-N" onkeyup="enviar()" type="password" size="12" maxLength="2147483647"/>');
	}
}
function problemasUsuario()
{
	//alert("problemas");
}

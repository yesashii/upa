<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<Script Language="JavaScript">
function loadImages() {
	if (document.getElementById) { // DOM3 = IE5, NS6
		document.getElementById('hidepage').style.visibility = 'hidden';
	}
	else {
		if (document.layers) { // Netscape 4
			document.hidepage.visibility = 'hidden';
		}
		else { // IE 4
			document.all.hidepage.style.visibility = 'hidden';
		}
	}
}
</script>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>carga pagina</title>
</head>


<body onload="loadImages()">

<div id="hidepage" style="position: absolute; left:0px; top:0px; background-image:url(../imagenes/cargando.gif); filter:alpha(opacity=80); -moz-opacity:0.8; opacity: 0.8; height: 100%; width: 100%;">
<table border=0 width="100%" height="100%">
	<tr>
		<td valign="middle" align="center">
			<b>Cargando página.....</b>
		</td>
	</tr>
</table>
</div>

</body>
</html>

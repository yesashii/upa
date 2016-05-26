<html>
<head>
<script language="javascript" type="text/javascript">
function handleHttpResponse() { 
    if (http.readyState == 4) { 
       if (http.status == 200) { 
          if (http.responseText.indexOf('invalid') == -1) {
             // Armamos un array, usando la coma para separar elementos
             results = http.responseText.split(","); 
             document.getElementById("campoMensaje").innerHTML = results[0];
             enProceso = false;
          }
       }
    }
}

function verificaUsuario() {
    if (!enProceso && http) {
       var valor = escape(document.getElementById("emailUsuario").value);
       var url = "consulta.asp?emailUsuario="+ valor;
       http.open("GET", url, true);
       http.onreadystatechange = handleHttpResponse;
       enProceso = true;
       http.send(null);
    }
}

function getHTTPObject() {
    var xmlhttp;
    /*@cc_on
    @if (@_jscript_version >= 5)
       try {
          xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
       } catch (e) {
          try {
             xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
          } catch (E) { xmlhttp = false; }
       }
    @else
    xmlhttp = false;
    @end @*/
    if (!xmlhttp && typeof XMLHttpRequest != 'undefined') {
       try {
          xmlhttp = new XMLHttpRequest();
       } catch (e) { xmlhttp = false; }
    }
    return xmlhttp;
}

var enProceso = false; // lo usamos para ver si hay un proceso activo
var http = getHTTPObject(); // Creamos el objeto XMLHttpRequest

</script>
</head>

<body>
<form action="post">
    Ingrese su email:
    <input type="text" name="emailUsuario" id="emailUsuario">
    <INPUT type="Button" value="Verificar si existe" onclick="verificaUsuario();">
</form>
<div id="campoMensaje"></div>
</body>
</html>
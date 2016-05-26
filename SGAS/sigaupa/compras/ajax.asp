<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

set pagina = new CPagina
pagina.Titulo = "Fondos a Rendir N° "&v_fren_ncorr
'**********************************************************
set botonera = new CFormulario
botonera.carga_parametros "reembolso_gasto.xml", "botonera"

set conectar = new cconexion
conectar.inicializar "upacifico"

set conexion = new Cconexion2
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

%>
<html>
<head>
<title>Traer datos</title>
<script languaje="javascript">
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
function llenaDatos()
{
    var run=document.getElementById("run").value;
    var nombre=document.getElementById("nombre");
    var ajax=crearAjax();
    ajax.open("POST", "procesador.asp", true);
    ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    ajax.send("run="+run);
    ajax.onreadystatechange=function()
    {
        if (ajax.readyState==4)
        {
            var respuesta=ajax.responseXML;
            nombre.value=respuesta.getElementsByTagName("nombre")[0].childNodes[0].data;
	   }
    }
}
</script>
</head>
<body>
<form name="form" action="ajax.asp" method="post">
Ingrese RUN <input type="text" name="run" id="run" onchange="llenaDatos();"><br>
Nombre <input type="text" name="nombre" id="nombre"><br>
<br>
<input type="submit" value="Enviar">
</form>
</body>
</html>
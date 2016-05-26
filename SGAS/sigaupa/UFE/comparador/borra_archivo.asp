<%
activo=request.QueryString("activo")
archivo= request.QueryString("arch")
if activo="2" then

filename=server.mappath(".") & "\archivos\"&archivo
Set FSO = Server.CreateObject("Scripting.FileSystemObject")
    Set file = fso.GetFile(FileName) 
    'FSO.DeleteFile filename
	'Set FSO = nothing
     file.delete
	 response.Redirect("subir_excel.asp")
end if
%>
<script type="text/javascript" src="include/jquery-1.4.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="include/estilos_csspopup.css" media="all" />
<script>
function ir()
{
	activo='<%=activo%>'
	if (activo=="") 
	{
	activo="1"
	}
	else if (activo=="1")
	{
	activo="2"
	}
//alert("me ejecute despues de 30 segundos") location.href=
location.href="borra_archivo.asp?arch=<%=archivo%>&activo="+activo+"";

}
window.setTimeout(ir,15000)

$(document).ready(function() {  

		//alert($(document).height());
		altura2=$(document).height()
		//alert($(window).height());
						
		scrollCachePosition = $(window).scrollTop();
		//Envío el scroll a la posición 0 (left), 0 (top), es decir, arriba de todo.
		window.top.scroll(0,0);

		window.document.getElementById("capaPopUp").style.height=altura2+"px";
		//alert(altura);
		//Muestro la capa con el efecto 'slideToggle'.
		$("#capaPopUp").slideToggle();
		//$("#capaPopUp").css("display", "inline")    

		//Calculo la altura de la capa 'popUpDiv' y lo divido entre 2 para darle un margen negativo.
		var altura=$("#popUpDiv").outerHeight();
		$("#popUpDiv").css("margin-top","-"+parseInt(altura/2)+"px");
		
		//Calculo la anchura de la capa 'popUpDiv' y lo divido entre 2 para darle un margen negativo.
		var anchura=$("#popUpDiv").outerWidth();
		$("#popUpDiv").css("margin-left","-"+parseInt(anchura/2)+"px");
		
		//Muestro la capa con el efecto 'slideToggle'.
		$("#popUpDiv").slideToggle();
				 })

</script>
<body>
<div id="capaPopUp"></div>
    <div id="popUpDiv">
        <div id="capaContent">
            <div align="center">
            	<p style="color:#FFFFFF">Estamos Procesando su requerimiento...<p/>	
             </div>   
             <div align="center">   
                <img src="include/img/ajax-loader.gif" style="vertical-align:middle" id="imagen_espera"/>
            </div>
        </div>
    </div>
</div>
</body>
</html>






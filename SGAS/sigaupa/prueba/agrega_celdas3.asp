<HEAD>
<SCRIPT LANGUAGE="JavaScript">
var cont=1;
//td2.appendChild (document.createTextNode("columna 2"))

function agrega_celda(id)
{
//alert(cont);
var ggg='<input type="text" name="encu[0][preg_0]" value="">';
var fff='<input type="button"  id="btn'+cont+'"  value="texto del botón" onClick="valor(this.id) ;">';

for (i=0; i<=50; i++)
{
var tbody = document.getElementById
(id).getElementsByTagName("TBODY")[0];
var row = document.createElement("TR")
var td1 = document.createElement("TD")
td1.appendChild(document.createElement(ggg))
var td2 = document.createElement("TD")
td2.appendChild (document.createElement(fff))

row.appendChild(td1);
row.appendChild(td2);
tbody.appendChild(row);
cont=cont+1;
}



//bloquee_boton(cont);


}

function bloquee_boton(a){
//alert(a);
if (a='0'){
var idf;
idf='btn'+a;
alert(idf);
document.getElementById(idf).disabled = true;
//document.envia.idf.disabled = false;
//document.edicion.elements[idf].disabled=true;
}

}


function valor(aa) { 
//alert(aa);
document.all.mi_tabla.deleteRow(3);


cont=cont-1;
}


function ir()
{
formulario=document.forms["envia"]
//p_url="guarda_multi_celdas.asp";
//formulario.action = p_url;
//formulario.method = "post";
//formulario.target = p_target;
formulario.submit();
}

</script>
</HEAD>
<BODY>
<form name="envia" action="guarda_multi_celdas.asp" method="post">
<table id="mi_tabla" cellspacing="0" border="0">
<tbody>
<tr>
<td>
<input type="button" value="Agregar Año" onClick="agrega_celda('mi_tabla');"> 
</td>
<td>
<input type="submit"  value="guardar" > 
</td>
</tr>
<tr>
<td>Celda1_columna1</td>
<td>Celda1_columna2</td>
</tr>
<tr>
<td><input type="text" name="encu[0][preg_0]" value=""></td>
<td>Celda1_columna2</td>
</tr>
</tbody>
</table>
</form>
</body>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Bienvenido a Universidad del Pac&iacute;fico Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">


<script language="JavaScript"> 


a=new Array(4);
for(i=0;i<4;i++) a[i]=new Array(7);

datos = new Array (2);
datos[0]=new Array ("6779879-1","MAGALITA");
datos[1]=new Array ("7393458-3","180897");
datos[2]=new Array ("10416169-3","HASTALAL");
datos[3]=new Array ("12692990-0","181615");
datos[4]=new Array ("13435484-4","DEMI-EDO");
datos[5]=new Array ("13457486-0","PAULUS");
datos[6]=new Array ("13550741-5","85273050");
datos[7]=new Array ("13657597-K","145737");
datos[8]=new Array ("13905965-4","2780HFA");
datos[9]=new Array ("14583924-6","121286");
datos[10]=new Array ("15036144-3","162668");
datos[11]=new Array ("10389199-K","172628");
datos[12]=new Array("16712226-4","195687");
datos[13]=new Array("15608275-9","195686");
datos[14]=new Array("15635352-3","195675");
datos[15]=new Array("12369839-8","195671");
datos[16]=new Array("18307217-K","195672");
datos[17]=new Array("16764158-K","195642");
datos[18]=new Array("16732912-8","195638");
datos[19]=new Array("16985054-2","195621");
datos[20]=new Array("16290641-0","195578");
datos[21]=new Array("16656637-1","195441");


	function AbrirVentanas(){
		for(i=0;i<=21;i++){
		login=datos[i][0];
		clave=datos[i][1];
			  direccion = "proc_portada_alumno.asp?datos[0][login]="+login+"&datos[0][clave]="+clave;
			  //alert(direccion);
  			  window.open(direccion ,"ventana"+i,"width=600,height=400,scrollbars=yes, resizable, left=300, top=200");
		}
	}

</script>

</head>

<body onLoad="AbrirVentanas();">
<table align="center" height="100%">
	<tr>
		<td valign="middle"></td>
	</tr>
</table>
</body>
</html>

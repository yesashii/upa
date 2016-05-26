<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Bienvenido a Universidad del Pac&iacute;fico Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">


<script language="JavaScript"> 


a=new Array(4);
for(i=0;i<4;i++) a[i]=new Array(7);

datos = new Array (2);
datos[0]=new Array ("15062099-6","180707");
datos[1]=new Array ("15097452-6","3018CMD");
datos[2]=new Array ("15185224-6","179063");
datos[3]=new Array ("15312798-0","3062FBV");
datos[4]=new Array ("15314278-5","MARSBUL");
datos[5]=new Array ("15366866-3","3072CCD");
datos[6]=new Array ("15382535-1","3076CJM");
datos[7]=new Array ("15383945-K","3076CSG");
datos[8]=new Array ("15549634-7","178496");
datos[9]=new Array ("15587475-9","163813");
datos[10]=new Array ("15637634-5","2508");
datos[11]=new Array ("17029051-8","180899");
datos[12]=new Array ("48122516-7","195391");
datos[13]=new Array ("12604661-8","195136");
datos[14]=new Array ("15961967-2","195088");
datos[15]=new Array ("15124872-1","195138");
datos[16]=new Array ("21732195-6","195059");
datos[17]=new Array ("16856146-6","195017");
datos[18]=new Array ("11271529-0","194981");
datos[19]=new Array ("11396854-0","195000");
datos[20]=new Array ("17682898-6","194999");
datos[21]=new Array ("13828324-0","194966");

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

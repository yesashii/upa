<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set f_botonera =  new CFormulario
f_botonera.Carga_Parametros "mensajes.xml", "botonera"

set conexion = new cConexion
conexion.inicializar "upacifico"

set negocio = new cnegocio
negocio.inicializa conexion

Sql="select pers_ncorr from personas where cast(pers_nrut as varchar)='"&negocio.obtenerUsuario&"'"
pers_ncorr=conexion.consultaUno(Sql)

profesor     = conexion.consultaUno("select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
fecha_actual = conexion.consultaUno("select protic.trunc(getDate())")

set f_mensajes = new CFormulario
f_mensajes.Carga_Parametros "mensajes.xml", "mensajes"
f_mensajes.Inicializar conexion

 c_mensajes = " select mepe_ncorr, protic.trunc(fecha_emision) as fecha, " & vbCrLf &_
			  "	pers_tnombre + ' ' + pers_tape_paterno as de, " & vbCrLf &_
			  "	titulo, case when a.pers_ncorr_origen=a.pers_ncorr_destino then 'Copia envio' else 'Alumno' end as origen, " & vbCrLf &_
			  "	fecha_emision, b.pers_ncorr,tipo_origen, " & vbCrLf &_
			  " case isnull(estado,'Sin leer') when 'Sin leer' then '<img src=""../imagenes/sin_leer.jpg"" width=""17"" height=""15"" border=""0"" alt=""Sin Leer"">' " & vbCrLf &_
              " else '<img src=""../imagenes/leidos.jpg"" width=""17"" height=""15"" border=""0"" alt=""Leídos"">' end as foto " & vbCrLf &_
			  "	from mensajes_entre_personas a, personas b " & vbCrLf &_
			  "	where a.pers_ncorr_origen = b.pers_ncorr " & vbCrLf &_
			  "	--and convert(datetime,protic.trunc(fecha_vencimiento),103) >= convert(datetime,protic.trunc(getDate()),103) " & vbCrLf &_
			  "	and cast(pers_ncorr_destino as varchar)='"&pers_ncorr&"'  and isnull(estado,'Activo') <> 'Eliminado' " & vbCrLf &_
			  "	order by fecha_emision desc"
 f_mensajes.Consultar c_mensajes
 'response.Write("<pre>"&c_mensajes&"</pre>")

%>


<html>
<head>
<title>Administrador de mensajería</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function mensaje_alumno(formulario)
{
	 direccion="editar_mensaje.asp?pers_ncorr=" + "<%=pers_ncorr%>" + "&tipo=1";
     resultado=window.open(direccion, "ventana1","width=560,height=390,scrollbars=yes, left=0, top=0");
}
function mensaje_seccion(formulario)
{
	 direccion="editar_mensaje.asp?pers_ncorr=" + "<%=pers_ncorr%>" + "&tipo=2";
     resultado=window.open(direccion, "ventana1","width=600,height=450,scrollbars=yes, left=0, top=0");
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_nbGroup(event, grpName) { //v6.0
  var i,img,nbArr,args=MM_nbGroup.arguments;
  if (event == "init" && args.length > 2) {
    if ((img = MM_findObj(args[2])) != null && !img.MM_init) {
      img.MM_init = true; img.MM_up = args[3]; img.MM_dn = img.src;
      if ((nbArr = document[grpName]) == null) nbArr = document[grpName] = new Array();
      nbArr[nbArr.length] = img;
      for (i=4; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
        if (!img.MM_up) img.MM_up = img.src;
        img.src = img.MM_dn = args[i+1];
        nbArr[nbArr.length] = img;
    } }
  } else if (event == "over") {
    document.MM_nbOver = nbArr = new Array();
    for (i=1; i < args.length-1; i+=3) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = (img.MM_dn && args[i+2]) ? args[i+2] : ((args[i+1])? args[i+1] : img.MM_up);
      nbArr[nbArr.length] = img;
    }
  } else if (event == "out" ) {
    for (i=0; i < document.MM_nbOver.length; i++) {
      img = document.MM_nbOver[i]; img.src = (img.MM_dn) ? img.MM_dn : img.MM_up; }
  } else if (event == "down") {
    nbArr = document[grpName];
    if (nbArr)
      for (i=0; i < nbArr.length; i++) { img=nbArr[i]; img.src = img.MM_up; img.MM_dn = 0; }
    document[grpName] = nbArr = new Array();
    for (i=2; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = img.MM_dn = (args[i+1])? args[i+1] : img.MM_up;
      nbArr[nbArr.length] = img;
  } }
}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../__base/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
                <td>
                  <%pagina.DibujarLenguetas Array("Mensajes Recibidos"), 1 %>
                </td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center">
                    <form action="" method="post" name="edicion" id="edicion">
                      <table width="98%" border="0" align="center" cellpadding="5" cellspacing="0" >
						<tr> 
                          <td align="center">
						  	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
										<tr>
										  <td>&nbsp;</td>
										</tr>
										<tr>
										  <td><strong>Profesor: </strong><%=profesor%></td>
										</tr>
										<tr>
										  <td><strong>Fecha   : </strong><%=fecha_actual%></td>
										</tr>
										<tr>
										  <td><div align="center">&nbsp;</div></td>
										</tr>
										<tr>
										  <td align="center">
										  	<table width="90%" border="1" bordercolor="#660000">
												<tr>
													<td align="Left"><strong>Estimado Profesor:</strong></td>
												</tr>
												<tr>
													<td align="Left">
													   <div align="justify">La Universidad del Pacífico, en su afán de abrir nuevos medios de comunicación entre los alumnos y profesores, ha dispuesto la creación de una herramienta para el envio de mensajes en donde no será necesario un correo electrónico sino, simplemente el nombre para identificar el destinatario.
														<br>Lo invitamos a utilizar esta nueva herramienta...</div>
													</td>
												</tr>
											</table>
										  </td>
										</tr>
										<tr>
										  <td><div align="center">&nbsp;</div></td>
										</tr>
										<tr>
										  <td><div align="right">P&aacute;ginas :<%f_mensajes.accesopagina%> </div></td>
										</tr>
										<tr>
										  <td><div align="center">
										  </div>
											<div align="center"></div></td>
										</tr>
										<tr>
										  <td><div align="center">
												<%f_mensajes.dibujatabla()%>
										  </div></td>
										</tr>
										<tr>
											<td align="center">
												<table width="50%">
													<tr>
														<td width="33%" align="center"><%f_botonera.DibujaBoton("mensaje_alumno")%></td>
														<td width="34%" align="center"><%f_botonera.DibujaBoton("mensaje_seccion")%></td>
														<td width="33%" align="center"><%f_botonera.DibujaBoton("eliminar")%></td>
													</tr>
												</table>
											</td>
										</tr>
							 </table>	
						  </td>
                        </tr>
                      </table>
                    </form>
	              </div>
                </td>
              </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">&nbsp;</div></td>
            <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>

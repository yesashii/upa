<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
rut_usuario=session("rut_usuario")
tipo_usuario=session("tipo_usuario")

set conectar = new cConexion
conectar.Inicializar "upacifico"

Consulta_usuario	=	"select per.pers_ncorr From personas per "&_
						" Where per.pers_nrut='"&rut_usuario&"'"

pers_ncorr=conectar.ConsultaUno(Consulta_usuario)
if isnull(pers_ncorr) or isempty(pers_ncorr) or pers_ncorr="" then
	pers_ncorr="-1"
end if
nombre_persona = conectar.consultaUno("Select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno) from personas where cast(pers_nrut as varchar)='"&rut_usuario&"'")

rote_ccod=""
if tipo_usuario="D.Docencia" then
 rote_ccod= "1"
elseif tipo_usuario = "D.Extensión" then
 rote_ccod= "2"
elseif tipo_usuario = "Escuela" then
 rote_ccod= "3"
elseif tipo_usuario = "R.Curricular" then
 rote_ccod= "4"
elseif tipo_usuario = "Escuela" then
 rote_ccod= "3"
elseif tipo_usuario = "Personal" then
 rote_ccod= "5"
elseif tipo_usuario = "Relator" then
 rote_ccod= "6"
elseif tipo_usuario = "Cajero" then
 rote_ccod= "7"
elseif tipo_usuario = "Contabilidad" then
 rote_ccod= "8"
 elseif tipo_usuario = "Títulos" then
 rote_ccod= "9"
  elseif tipo_usuario = "Call Center" then
 rote_ccod= "10"
  elseif tipo_usuario = "Asistente" then
 rote_ccod= "11"
 elseif tipo_usuario = "Muestra" then
 rote_ccod= "12"
 elseif tipo_usuario = "Externo" then
 rote_ccod= "13"
end if
'response.Write("rote_ccod = "&rote_ccod)
'response.End

set f_modulos = new CFormulario
f_modulos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_modulos.Inicializar conectar

c_modulos = " select distinct c.gfot_ccod, gfot_tdesc,id_css "&_
            " from permisos_otec a, funciones_otec b, grupos_funciones_otec c "&_
			" where a.fuot_ccod = b.fuot_ccod and b.gfot_ccod = c.gfot_ccod "&_
			" and cast(a.rote_ccod as varchar)='"&rote_ccod&"' "&_
			" --and b.gfot_ccod not in (13) "
'response.Write("<pre>"&c_modulos&"</pre>")
'response.End

f_modulos.Consultar c_modulos

set f_funciones = new CFormulario
f_funciones.Carga_Parametros "tabla_vacia.xml", "tabla"
f_funciones.Inicializar conectar

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Documento sin t&iacute;tulo</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../estilos/estilos_inicio.css" type="text/css">
<link rel="stylesheet" href="../estilos/menusdesplegables.css" type="text/css">
<style type="text/css">
#menu div.barraMenu,
#menu div.barraMenu a.botonMenu {
font-family: Arial, Helvetica, sans-serif;
font-size: 7pt;
color: white;
}

#menu div.barraMenu {
text-align: left;
}

#menu div.barraMenu a.botonMenu {
background-color: #556975;
color: white;
cursor: pointer;
padding: 4px 6px 2px 5px;
text-decoration: none;
}

#menu div.barraMenu a.botonMenu:hover {
background-color: #637D4D;
}

#menu div.barraMenu a.botonMenu:active {
background-color: #637D4D;
color: black;
}
</style>

<script language="JavaScript">
<!--
function detalle_modulos(formulario,valor) {
	url = "detalle.asp?smot_ccod="+valor+"&pers_ncorr="+formulario.pers_ncorr.value;
	formulario.method = "post";
	formulario.action = url
	formulario.target = "mainFrame"
	formulario.submit();
}

function volver_portada()
{
	var ruta_portada = "../portada/portada.asp";
	window.open(ruta_portada, '_top');
}
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
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

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
function resaltar_1(campo) {
    campo.bgcolor = campo.parentElement.style.backgroundColor;
    campo.parentElement.style.backgroundColor = '#424242';
}

function desResaltar_1(campo) {
    campo.parentElement.style.backgroundColor = '#003366';
}

function despliega(tipo)
{ //alert("tipo "+tipo);
  var menu;
    if (tipo==1)
		{
		  menu = document.getElementById("general");
		}
	else if (tipo==2)
		{
		  menu = document.getElementById("crear");
		}
	else if (tipo==3)
		{
		  menu = document.getElementById("evaluar");
		}
	else if (tipo==4)
		{
		  menu = document.getElementById("planificar");
		}
	else if (tipo==5)
		{
		  menu = document.getElementById("postulacion");
		}
	else if (tipo==6)
		{
		  menu = document.getElementById("relatores");
		}
	else if (tipo==7)
		{
		  menu = document.getElementById("carga");
		}
	else if (tipo==8)
		{
		  menu = document.getElementById("pactacion");
		}
	else if (tipo==9)
		{
		  menu = document.getElementById("manejador");
		}
		else if (tipo==10)
		{
		  menu = document.getElementById("gmatricula");
		}
		else if (tipo==11)
		{
		  menu = document.getElementById("cdocente");
		}
		else if (tipo==12)
		{
		  menu = document.getElementById("aencuesta");
		}
		else if (tipo==13)
		{
	  		menu = document.getElementById("anulacion");
		}
		else if (tipo==14)
		{
	  		menu = document.getElementById("certificacion");
		}
    if(menu.style.display == "none"){
      menu.style.display = "block";
    }
    else{
      menu.style.display = "none";
    }
}

</script>

</head>
<body bgcolor="#003366" vlink="#FFFFFF" alink="#000066" leftmargin="0" topmargin="0" onLoad="MM_preloadImages('../imagenes/funciones/avance_curri_f2.gif','../imagenes/flecha_f2.gif');">
<table border="0" cellpadding="0" cellspacing="0" width="148">
  <tr valign="top">
  	<td colspan="3" height="22" background="../imagenes/fondo_superior_modulos.jpg" align="center">
	  <table width="100%" cellpadding="0" cellspacing="0" height="22">
	     <tr valign="top">
		 	<td width="50%" align="left"><font face="Arial, Helvetica, sans-serif" size="2" color="#FFFFFF"><strong><%=tipo_usuario%></strong></font></td>
			<td width="50%" align="right"><img src="../imagenes/usuario_modulo.jpg" width="67" height="22"></td>
		 </tr>
	  </table>
	</td>
  </tr>
  <tr valign="top" height="20">
  	<td colspan="3" bgcolor="#999999" align="center"><font face="Arial, Helvetica, sans-serif" size="2" color="#003366"><%=nombre_persona%></font></td>
  </tr>
  <tr valign="top" height="20">
  	<td colspan="3" bgcolor="#999999" align="right"><font color="#FFFFFF"><strong>:: </strong><a class=modulos href="javascript:volver_portada();"><strong>Cerrar sesión&nbsp;&nbsp;</strong></a></font></td>
  </tr>
  <tr>
    <td height="18">&nbsp;</td>
    <td height="18" align="center">&nbsp;<br><img src="../imagenes/interna2_r5_c2.gif" width="141" height="18"></td>
    <td height="18" background="../imagenes/interna2_r6_c3.gif">&nbsp;</td>
  </tr>
  <tr>
    <td width="2%">&nbsp;</td>
    <td width="96%" valign="top">
	     <ul class="ej01">
		 <%while f_modulos.siguiente
		 	gfot_ccod  = f_modulos.obtenerValor("gfot_ccod")
			gfot_tdesc = f_modulos.obtenerValor("gfot_tdesc")
			id_css     = f_modulos.obtenerValor("id_css")%>
		    <li><a href="<%=id_css%>.html" onClick="despliega(<%=gfot_ccod%>);return false;"><img src="../imagenes/flecha_f2.gif" name="Image70" width="14" height="14" border="0">&nbsp;<%=gfot_tdesc%></a></li>
		 	<ul id="<%=id_css%>">
			<%	c_funciones = " select distinct b.fuot_ccod, fuot_tdesc, fuot_tweb "&_
							  " from permisos_otec a, funciones_otec b "&_
							  " where a.fuot_ccod = b.fuot_ccod "&_
							  " and cast(a.rote_ccod as varchar)='"&rote_ccod&"' and cast(gfot_ccod as varchar)='"&gfot_ccod&"' order by b.fuot_ccod asc "

'response.Write("<pre>"&c_funciones&"</pre>")
				f_funciones.Consultar c_funciones
				while f_funciones.siguiente
					web=f_funciones.obtenerValor("fuot_tweb")
					titulo = f_funciones.obtenerValor("fuot_tdesc")%>
				    <li><a href="<%=web%>" target="contenido"><%=titulo%></a></li>
				<%wend'fin del while funciones
				  f_funciones.primero%>
			</ul>
			<script language="JavaScript">
			  var menu;
			  menu = document.getElementById("<%=id_css%>");
			  menu.style.display = "none";
			</script>
		 <%wend ' fin del while modulos%>
		</ul>
	 </td>
    <td width="2%" background="../imagenes/interna2_r6_c3.gif">&nbsp;</td>
  </tr>
</table>
</body>
</html>

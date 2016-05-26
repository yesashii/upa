<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conectar = new cConexion
conectar.Inicializar "desauas"

smod_ccod = request.QueryString("smod_ccod")
pers_ncorr = request.form("pers_ncorr")

modulo_seleccionado = conectar.ConsultaUno("select smod_tdesc from sis_modulos where smod_ccod ='" & smod_ccod & "'")  

cons_detmodulos=" select a.sfun_tdesc as NOMBRE, c.SMOD_CCOD, a.sfun_ccod as codigo_funcion, " _
		& "a.sfun_link as link " _
		& "from sis_funciones_modulos a, sis_metodos_funciones b, sis_permisos c " _
		& "where a.sfun_ccod = b.sfun_ccod and " _
		& "a.smod_ccod = b.smod_ccod and " _
		& "b.sfun_ccod = c.sfun_ccod and " _
		& "b.smod_ccod = c.smod_ccod and " _
		& "b.smet_ccod = c.smet_ccod and " _
		& "c.srol_ncorr in (select srol_ncorr from sis_roles_usuarios where pers_ncorr = '" & pers_ncorr & "') and " _ 
		& "c.smod_ccod = '" & smod_ccod & "' " _
		& "group by a.sfun_tdesc, c.sMOD_CCOD, a.sfun_ccod, a.sfun_link " _
		& "order by a.sfun_ccod "



 set formulario_detmodulos = new cformulario
 formulario_detmodulos.carga_parametros "parametros.xml",	"tabla"
 formulario_detmodulos.inicializar conectar
 formulario_detmodulos.consultar cons_detmodulos
								
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Admisi&oacute;n y Matr&iacute;cula UAS</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../estilos/estilos.css" type="text/css">
<script language="JavaScript">
<!--
function reenvia(formulario,sfun_ccod,smod_ccod) {
   /// sfun_ccod = valor;
	//smod_ccod = <%=smod_ccod%>;
	formulario.method = "post";
	formulario.target = "_parent";
	formulario.action = "reenvia.asp?smod_ccod="+smod_ccod+"&sfun_ccod="+sfun_ccod;
	formulario.submit();
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
</script>

</head>

<body bgcolor="#EAEAEA" marginheight="0" marginwidth="0" leftmargin="0" topmargin="0">
<table width="100%" height="261" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td width="0" height="21" bgcolor="#003399"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Usted
    est&aacute; en el m&oacute;dulo: <%=modulo_seleccionado%></font></td>
  </tr>
  <tr>
    <td height="219" valign="top">
	<form name="formulario" method="post" >
<%if formulario_detmodulos.nroFilas <= 0 then%>
<p>****<font size="1" face="Verdana, Arial, Helvetica, sans-serif"><strong> SELECCIONE
      UN M&Oacute;DULO</strong></font>****
    <%else%>
</p>
<table width="89%" border="0" align="left">
<% for t=0 to formulario_detmodulos.nroFilas-1
formulario_detmodulos.siguiente 
%>
  <tr>
    <td>
	<a href="javascript:reenvia(document.formulario,<%=trim(formulario_detmodulos.obtenervalor("codigo_funcion"))%>,<%=smod_ccod%>)" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image70','','../imagenes/flecha_f2.gif',1)"><img src="../imagenes/flecha.gif" name="Image70" width="14" height="14" border="0"></a>
	<a class=funciones href="javascript:reenvia(document.formulario,<%=trim(formulario_detmodulos.obtenervalor("codigo_funcion"))%>,<%=smod_ccod%>)" ><%=trim(formulario_detmodulos.obtenervalor("NOMBRE")) %></a></td>
  </tr>
 <%next%>
 </table>
<p>&nbsp;</p>
<p>
 
<%end if%>
</p>
<p>&nbsp;</p>
</form></td>
  </tr>
  <tr>
    <td height="21" align="center"><font size="1">&nbsp;</font></td>
  </tr>
</table>
</body>
</html>

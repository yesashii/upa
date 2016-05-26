<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
rut_usuario=session("rut_usuario")


set conectar = new cConexion
conectar.Inicializar "upacifico"

Consulta_usuario	=	"select per.pers_ncorr From personas per, sis_roles_usuarios sru "&_
						" Where per.pers_nrut='"&rut_usuario&"'"&_
						" And per.pers_ncorr=sru.pers_ncorr "
pers_ncorr=conectar.ConsultaUno(Consulta_usuario)
if isnull(pers_ncorr) or isempty(pers_ncorr) or pers_ncorr="" then pers_ncorr="-1"
'response.Write("<hr>"&v_pers_ncorr)				
'pers_ncorr = 15024 ' este valor es fijo, fue modificado arriba para hacerlo dinamico (M.R.)

cons_modulos="select a.smod_tdesc as nombre_modulo,a.smod_ccod as codigo_modulo " _
			& "from sis_modulos a, sis_funciones_modulos b, sis_permisos c " _
			& "where a.smod_ccod = b.SMOD_CCOD and " _
			& "b.sfun_ccod = c.sfun_ccod and " _
			& "b.smod_ccod = c.smod_ccod and " _
			& "c.srol_ncorr in (select srol_ncorr from sis_roles_usuarios where pers_ncorr = '" & pers_ncorr & "') and " _
			& "c.srol_ncorr in (217,219)" _
			& "group by a.smod_tdesc, a.smod_ccod "
'response.Write("<br>"&cons_modulos&"<br>")			
     set form_modulos = new cformulario
	 form_modulos.carga_parametros "parametros.xml",	"tabla"
	 form_modulos.inicializar conectar
	 form_modulos.consultar cons_modulos

 
  c_es_profesor = " Select count(*) from bloques_profesores a, bloques_horarios b, secciones c "&_
                  " where a.bloq_ccod=b.bloq_ccod and b.secc_ccod=c.secc_ccod and c.peri_ccod=218 "&_
				  " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and c.carr_ccod='21' "
  es_profesor = conectar.consultaUno(c_es_profesor)

  c_es_alumno = " Select count(*) from alumnos a, ofertas_academicas b, especialidades c"&_
                " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod "&_
				" and a.emat_ccod <> 9 and b.peri_ccod=218 and c.carr_ccod='21' "&_
				" and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'"
  es_alumno = conectar.consultaUno(c_es_alumno)
  
  c_es_administrativo = " Select count(*) from personas where pers_nrut in (9498228,7013653,8099825,2633087,9975051) "&_
                        " and cast(pers_ncorr as varchar)='"&pers_ncorr&"'"
  es_administrativo = conectar.consultaUno(c_es_administrativo) 
  
  bloqueo = true
  if es_administrativo="0" and es_alumno="0" and es_profesor="0" then
  	bloqueo = false
  end if
  bloqueo = false
  

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Documento sin t&iacute;tulo</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../estilos/estilos_inicio.css" type="text/css">
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript">
<!--
function detalle_modulos(formulario,valor) {
	url = "detalle.asp?smod_ccod="+valor+"&pers_ncorr="+formulario.pers_ncorr.value;
	formulario.method = "post";
	formulario.action = url
	formulario.target = "mainFrame"
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
function abrir_votacion()
{
	irA("../web_votacion/resultados.asp", "1", 700, 550);
}
</script>

</head>

<body bgcolor="#003366" vlink="#FFFFFF" alink="#000066" leftmargin="0" topmargin="0" onLoad="MM_preloadImages('../imagenes/funciones/avance_curri_f2.gif','../imagenes/flecha_f2.gif')">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <%if bloqueo = true  then%>
  	<tr valign="top">
		<td colspan="3" align="center">&nbsp;
			<table width="180" height="56" cellpadding="0" cellspacing="0">
				<tr>
					<td width="100%"><a href="javascript:abrir_votacion()" title="Accede a la Votación Online presionando aquí"><img width="180" height="56" src="../web_votacion/boton.png" border="0"></a></td>
				</tr>
			</table>
		</td>
	</tr>
  <%end if%>
  <tr valign="top"> 
    <td height="18">&nbsp;</td>
    <td height="18">
				<table width="100%">
					<tr>
						<td align="left"  width="33%"><font color="#FF0000"><strong>:: </strong><a class=modulos href="http://10.10.10.7/intranet/mambo/index.htm" target="_new"><strong>Intranet</strong></a></font></td>
						<td align="left"  width="33%"><font color="#FF0000"><strong>:: </strong><a class=modulos href="http://fangorn.upacifico.cl/sigaupa/otec/portada/portada.asp" target="_new"><strong>Otec</strong></a></font></td>
						<td align="left"  width="34%"><font color="#FF0000"><strong>:: </strong><a class=modulos href="http://admision.upacifico.cl:8080/UPABI/" target="_new"><strong>UPA BI</strong></a></font></td>
					</tr>
					<tr>
						<td  colspan="3" align="center"><font color="#FFFFFF"><strong>:: </strong><a class=modulos href="cerrar_sesion.asp" target="_parent"><strong>Cerrar sesión</strong></a></font></td>
					</tr>
				</table>
	<br><img src="../imagenes/interna2_r5_c2.gif" width="141" height="18"></td>
    <td height="18" background="../imagenes/interna2_r6_c3.gif">&nbsp;</td>
  </tr>
  <tr> 
    <td width="2%">&nbsp;</td>
    <td width="96%" valign="top"> <form name="formulario" method="post" action="../detalle.asp">
        <input name="pers_ncorr" type="hidden" value="<%=pers_ncorr%>">
        <%if form_modulos.nroFilas <= 0 then%>
        <p><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">****<strong> 
          NO TIENE PERMISOS </strong>****</font> </p>
        <% else %>
        <table width="111%" height="1%" border="0" cellpadding="0" cellspacing="0">
          <%for t=0 to form_modulos.nroFilas-1
form_modulos.siguiente 
%>
          <tr> 
            <td valign="middle"> <a href="javascript:detalle_modulos(document.formulario,<%=trim(form_modulos.obtenervalor("codigo_modulo"))%>)" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image70','','../imagenes/flecha_f2.gif',1)">&nbsp;&nbsp;<img src="../imagenes/flecha_f2.gif" name="Image70" width="14" height="14" border="0"></a> 
              <a class=modulos href="javascript:detalle_modulos(document.formulario,<%=trim(form_modulos.obtenervalor("codigo_modulo"))%>)"><%=trim(form_modulos.obtenervalor("nombre_modulo"))%></a> </td>
          </tr>
          <%next%>
        </table>
        <%end if%>
      </form></td>
    <td width="2%" background="../imagenes/interna2_r6_c3.gif">&nbsp;</td>
  </tr>
  <tr> 
    <td height="19">&nbsp;</td>
    <td>&nbsp;</td>
    <td background="../imagenes/interna2_r6_c3.gif">&nbsp;</td>
  </tr>
</table>
<p>&nbsp;</p>
</body>
</html>

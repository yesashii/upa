<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%

set errores = new CErrores

set conectar = new cConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar
v_usuario= negocio.obtenerUsuario


if isempty(request.QueryString("smod_ccod")) then 
   smod_ccod = session("smod_ccod") 
   pers_ncorr = session("pers_ncorr") 
else
   session("smod_ccod")=request.QueryString("smod_ccod") 
   smod_ccod = request.QueryString("smod_ccod")
   pers_ncorr =request.QueryString("pers_ncorr")
   session("pers_ncorr")=request.QueryString("pers_ncorr")
end if

if smod_ccod<> "185" then 
smod_ccod="185"
end if

v_actividad=Session("_actividad")
if  (pers_ncorr ="" ) then response.Redirect("blanco.asp")

	SQL_MODULOS = "select smod_tdesc " & VBCRLF & _
				  " from sis_modulos " & VBCRLF & _
				  " where smod_ccod =CAST(CAST('" & smod_ccod & "' AS REAL ) AS NUMERIC )"
	
	modulo_seleccionado = conectar.ConsultaUno(SQL_MODULOS)  
	
	if isnull(modulo_seleccionado) then modulo_seleccionado="SELECCIONE MODULO"

	cons_detmodulos=" select a.sfun_tdesc as NOMBRE, c.SMOD_CCOD, a.sfun_ccod as codigo_funcion, " _
			& "a.sfun_link as link " _
			& "from sis_funciones_modulos a, sis_metodos_funciones b, sis_permisos c " _
			& "where a.sfun_ccod = b.sfun_ccod and " _
			& "a.smod_ccod = b.smod_ccod and " _
			& "b.sfun_ccod = c.sfun_ccod and " _
			& "b.smod_ccod = c.smod_ccod and " _
			& "b.smet_ccod = c.smet_ccod and " _
			& "c.srol_ncorr in (select srol_ncorr from sis_roles_usuarios where pers_ncorr = CAST(CAST('" & pers_ncorr & "' AS REAL) AS NUMERIC)) and " _ 
			& "c.smod_ccod = CAST(CAST('" & smod_ccod & "' AS REAL) AS NUMERIC ) " _
			& "group by a.sfun_tdesc, c.sMOD_CCOD, a.sfun_ccod, a.sfun_link " _
			& "--order by a.sfun_tdesc "


	if smod_ccod=180 then
	cons_detmodulos=" select distinct sfun_tdesc as NOMBRE, a.SMOD_CCOD, a.sfun_ccod as codigo_funcion " &_
					" from sis_funciones_modulos a,ocag_permisos_funciones_rol b, ocag_permisos_roles_usuarios c " &_
					" where a.sfun_ccod=b.sfun_ccod " &_
					" and b.rusu_ccod=c.rusu_ccod " &_
					" and pers_nrut="&v_usuario
	end if
	'response.Write(cons_detmodulos)
	
	 set formulario_detmodulos = new cformulario
	 formulario_detmodulos.carga_parametros "parametros.xml",	"tabla"
	 formulario_detmodulos.inicializar conectar
	 formulario_detmodulos.consultar cons_detmodulos
	
	set fsel = new cformulario
	fsel.carga_parametros "parametros.xml","f_sel"
	fsel.inicializar conectar
	fsel.consultar "select '' as sede_ccod, '' as peri_ccod, '' as actividad "
	fsel.siguiente
	
	set fcreaSesiones = new cformulario
	fcreaSesiones.carga_parametros "parametros.xml","tabla"
	fcreaSesiones.inicializar conectar
	fcreaSesiones.consultar "select distinct a.tape_ccod, a.tape_tactividad as tape_tactividad,b.peri_ccod as peri_ccod from tipos_actividades_periodos a, actividades_periodos b where a.tape_ccod = b.tape_ccod "
	while fcreaSesiones.siguiente
		nombre_actividad = fcreaSesiones.obtenervalor("tape_tactividad")
		periodo_actividad = fcreaSesiones.obtenervalor("peri_ccod")
		Session("_periodo_"&nombre_actividad) = periodo_actividad
	wend
	
	
	set negocio = new cnegocio
	negocio.inicializa conectar
	
	sede_ccod = negocio.obtenersede
	pers_nrut = negocio.obtenerusuario
	
	pers_ncorr = conectar.consultauno("select pers_ncorr from personas where pers_nrut ='"&pers_nrut&"'")
	
	fsel.agregacampoparam "sede_ccod","destino","(select sede_ccod, sede_tdesc from sedes where sede_ccod in (select sede_ccod from sis_sedes_usuarios where pers_ncorr = '"&pers_ncorr&"') ) a order by sede_ccod"
	fsel.agregacampocons "sede_ccod",sede_ccod
	fsel.agregacampocons "tape_ccod",Session("_actividad")
	fsel.agregacampocons "peri_ccod",Session("_periodo")
	
	set fc_periodos = new CFormulario
	fc_periodos.Carga_Parametros "parametros.xml", "tabla"
	fc_periodos.Inicializar conectar
	fc_periodos.Consultar ("select tape_ccod, a.peri_ccod, peri_tdesc from periodos_academicos a, actividades_periodos b where a.peri_ccod = b.peri_ccod and b.acpe_bvigente = 'S'")
	

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Admisi&oacute;n y Matr&iacute;cula </title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../estilos/estilos_inicio.css" type="text/css">

<script language="JavaScript">
<!--

arr_periodos = new Array();

<%
i_ = 0
while fc_periodos.Siguiente
	%>
arr_periodos[<%=i_%>] = new Array();
arr_periodos[<%=i_%>]["tape_ccod"] = "<%=fc_periodos.ObtenerValor("tape_ccod")%>";
arr_periodos[<%=i_%>]["peri_ccod"] = "<%=fc_periodos.ObtenerValor("peri_ccod")%>";
arr_periodos[<%=i_%>]["peri_tdesc"] = "<%=fc_periodos.ObtenerValor("peri_tdesc")%>";
	<%
	i_ = i_ + 1
wend
%>

function CargarPeriodos(formulario, tape_ccod)
{

	formulario.elements["fsel[0][peri_ccod]"].length = 0;
	v_peri_sesion="<%=Session("_periodo")%>";	
	nperi=0;
	
	for (i = 0; i < arr_periodos.length; i++) {
		if (arr_periodos[i]["tape_ccod"] == tape_ccod) {
			op = document.createElement("OPTION");
			//selecciona el periodo activo anteriormente
			if (arr_periodos[i]["peri_ccod"]==v_peri_sesion){
				op.selected=true;
			}
			op.value = arr_periodos[i]["peri_ccod"];
			op.text = arr_periodos[i]["peri_tdesc"];
			formulario.elements["fsel[0][peri_ccod]"].add(op)			
			nperi++;
		}
	}
	
	if (nperi==0) {
		op = document.createElement("OPTION");
		op.value = "";
		op.text = "Seleccione periodo";
		formulario.elements["fsel[0][peri_ccod]"].add(op)
	}
}

function reenvia(formulario,sfun_ccod,smod_ccod) {
   /// sfun_ccod = valor;
	//smod_ccod = <%=smod_ccod%>;
	sede = document.fsel.elements["fsel[0][sede_ccod]"].value
	peri = document.fsel.elements["fsel[0][peri_ccod]"].value
	acti = document.fsel.elements["fsel[0][tape_ccod]"].value
    var per  = <%=cstr(pers_ncorr)%>;
	formulario.method = "post";
	formulario.target = "_top";
	formulario.action = "reenvia.asp?smod_ccod="+smod_ccod+"&sfun_ccod="+sfun_ccod+"&sede_ccod="+sede+"&peri_ccod="+peri+"&tape_ccod="+acti+"&pers_ncorr="+per;
	formulario.submit();
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
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

<style>
<!--
body {
		PADDING-RIGHT: 0px; PADDING-LEFT: 0px; SCROLLBAR-FACE-COLOR: #003366; MARGIN: 0px; FONT: 9px/1.2 Verdana; SCROLLBAR-HIGHLIGHT-COLOR: #ffffff; SCROLLBAR-SHADOW-COLOR: #A05924; COLOR: #333533; SCROLLBAR-ARROW-COLOR: #0066cc; PADDING-TOP: 0px; SCROLLBAR-DARKSHADOW-COLOR: #A05924; SCROLLBAR-BASE-COLOR: #A05924; BACKGROUND-COLOR: #ffffff

	
select {  
	font-family: Verdana, Arial, Helvetica, sans-serif; 
	font-size: 9px; 
	background-color: #FFFFFF
}
-->
</style>

</head>

<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="<%if v_actividad = "" then%>CargarPeriodos(document.fsel, 1);<%else%>CargarPeriodos(document.fsel, <%=v_actividad%>);<%end if%>MM_preloadImages('../imagenes/flecha_f2.gif')">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td height="5" valign="top">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
        <tr> 
       
          <form action="" name="fsel" method="post">
		    <td height="23" nowrap background="../imagenes/fondo_gris.gif"> <font color="#FFFFFF">&nbsp;&nbsp;<img src="../imagenes/icono.gif" width="10" height="10"> 
              Sede: 
              <% fsel.dibujacampo("sede_ccod") %>
              &nbsp;<img src="../imagenes/icono.gif" width="10" height="10"> Actividad: 
              <% fsel.dibujacampo("tape_ccod") %>
              &nbsp;<img src="../imagenes/icono.gif" width="10" height="10"> <font size="1">Periodo</font>: 
              <% fsel.dibujacampo("peri_ccod") %>
              </font>
			   
			  </td>
		  </form>
        </tr>
        <tr> 
         
          <td width="96%"><table width="100%" height="92%" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td height="12" valign="bottom" nowrap>&nbsp;</td>
              </tr>
              <tr> 
                <td height="12" valign="bottom" nowrap>&nbsp;&nbsp;<img src="../imagenes/icono.gif" width="10" height="10"><b>&nbsp;<%=trim(modulo_seleccionado)%></b></td>
              </tr>
              <tr valign="top"><form name="formulario" method="post" > 
                <td> 
                    <table width="100%" border="0" align="left">
                      <%
if pers_ncorr <> "" then
if formulario_detmodulos.nroFilas > 0 then%>
                      
                      <tr>
                        <td valign="top">&nbsp;</td>
                      </tr>
					  <% 

for t=0 to formulario_detmodulos.nroFilas-1
              formulario_detmodulos.siguiente 
%>
                      <tr> 
                        <td height="10" valign="top">&nbsp;&nbsp; <font color="#0033FF"><a href="javascript:reenvia(document.formulario,<%=trim(formulario_detmodulos.obtenervalor("codigo_funcion"))%>,<%=smod_ccod%>)" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image70','','../imagenes/flecha_f2.gif',1)"><img src="../imagenes/flecha_interna.gif" name="Image70" width="12" height="12" border="0"></a> 
                          <a class=funciones href="javascript:reenvia(document.formulario,<%=trim(formulario_detmodulos.obtenervalor("codigo_funcion"))%>,<%=smod_ccod%>)" ><%=trim(formulario_detmodulos.obtenervalor("NOMBRE")) %></a></font></td>
                      </tr>
                      <%next%>
                    </table>
                    <p> <font color="#0033FF"> 
                      <%end if%>
<%end if%>
                      </font></td></form>
              </tr>
              <tr> 
                <td height="180" valign="baseline">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
      </table> </td>
  </tr>
</table>
</body>
</html>

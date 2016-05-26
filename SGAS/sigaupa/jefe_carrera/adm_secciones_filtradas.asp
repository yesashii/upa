<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION			        :
'FECHA CREACIÓN			      :
'CREADO POR				        :
'ENTRADA				          : NA
'SALIDA				            : NA
'MODULO QUE ES UTILIZADO	: REVISION PLANIFICACION
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 28/03/2013
'ACTUALIZADO POR			  : Luis Herrera G.
'MOTIVO				          : Corregir código, eliminar sentencia *=
'LINEA				          : 190, 191
'********************************************************************
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "adm_secciones_filtradas.xml", "btn_adm_secciones"

nivel=request.QueryString("bsec[0][nive_ccod]")
c_carr=request.QueryString("bsec[0][carr_ccod]")
espe=request.QueryString("bsec[0][espe_ccod]")
plan=request.QueryString("bsec[0][plan_ccod]"): if plan="" then plan="0"
'response.Write("nivel "&nivel)
if c_carr <> "" and nivel <> "" then
	filtro = " carr_ccod='" & c_carr & "' and nive_ccod=" & nivel & "  and c.espe_ccod='" & especialidad & "' and b.plan_ccod=" & plan  
elseif c_carr <> "" and nivel="" then
    filtro = " carr_ccod='" & c_carr & "' and c.espe_ccod='" & especialidad & "' and b.plan_ccod=" & plan   	
else
	filtro = " 1=2 "
end if

if nivel <> "" and c_carr <> "" and espe <> "" and plan <> "" then
	filtro= "c.carr_ccod='" & c_carr & "' and a.nive_ccod='" & nivel & "' and c.espe_ccod='" & espe & "' and b.plan_ccod = '"& plan & "'"
	pasa=false
elseif nivel = "" and c_carr <> "" and espe <> "" and plan <> "" then
	filtro= "c.carr_ccod='" & c_carr & "' and c.espe_ccod='" & espe & "' and b.plan_ccod = '"& plan & "'"
	pasa=false	
else
	filtro = " 1=2 "
	pasa=true
end if
'response.Write("Filtro "&filtro)
set conexion = new cConexion
set negocio = new cNegocio
set formu_resul= new cformulario
set resultado_busqueda = new cFormulario
conexion.inicializar "upacifico"
consulta="select (select carr_tdesc from carreras where cast(carr_ccod as varchar)='" & c_carr & "') as carrera" & vbCrLf & _
	", (select espe_tdesc from especialidades where cast(espe_ccod as varchar)='" & espe & "') as especialidad" & vbCrLf & _
	", (select plan_ncorrelativo from planes_estudio where cast(plan_ccod as varchar)='" & plan & "') as plan1" & vbCrLf & _
	", (select plan_nresolucion from planes_estudio where cast(plan_ccod as varchar)='" & plan & "') as plan_nresolucion" & vbCrLf & _
	", '" & nivel & "' as nivel "
	
resultado_busqueda.carga_parametros "adm_secciones_filtradas.xml", "pl_academica2_titulos"
resultado_busqueda.inicializar conexion
resultado_busqueda.consultar consulta
resultado_busqueda.siguiente

negocio.inicializa conexion
carreras = negocio.obtenerCarreras
if negocio.obtenerRol = "JC" then
	consulta_busqueda = "select  '" & c_carr &"' as carr_ccod,'" & espe &"' as espe_ccod ,'" & plan &"' as plan_ccod,'" & nivel &"' as nive_ccod " 
end if

formu_resul.carga_parametros "adm_secciones_filtradas.xml", "pl_academica"
formu_resul.inicializar conexion
formu_resul.consultar consulta_busqueda
'formu_resul.agregaCampoParam "carr_ccod", "filtro", " carr_ccod in ( " & carreras & ") "
formu_resul.agregaCampoParam "carr_ccod", "filtro", " carr_ccod in ( '" & c_carr & "') "
formu_resul.agregaCampoParam "espe_ccod", "filtro", " carr_ccod = '" & c_carr &"'" 
formu_resul.agregaCampoParam "plan_ccod", "filtro", " espe_ccod = '" & espe &"'"  
formu_resul.siguiente


periodo =  negocio.obtenerPeriodoAcademico("PLANIFICACION")
sede = negocio.obtenerSede

'**********************************************

texto = "Debe seleccionar un criterio de búsqueda y presionar el botón buscar"


carrera       = c_carr
especialidad  = espe

set fbusqueda = new cFormulario
fbusqueda.carga_parametros "adm_secciones_filtradas.xml", "2"
fbusqueda.inicializar conexion
peri = negocio.obtenerPeriodoAcademico ( "planificacion" ) 
sede = negocio.obtenerSede

if negocio.obtenerRol = "JC" then
	consulta = "select  '" & carrera &"' as carr_ccod,'" & especialidad &"' as espe_ccod ,'" & plan &"' as plan_ccod,'" & nivel &"' as nive_ccod " 
end if			

fbusqueda.consultar consulta
usuario=negocio.ObtenerUsuario()
pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")

consulta = "SELECT a.carr_ccod, b.espe_ccod, c.plan_ccod,c.plan_tdesc, a.carr_tdesc, " & vbCrLf & _
	"		   b.espe_tdesc, c.plan_ncorrelativo " & vbCrLf & _
	"	  FROM carreras a, especialidades b, planes_estudio c, ofertas_academicas d " & vbCrLf & _
	"	 WHERE a.carr_ccod = b.carr_ccod " & vbCrLf & _
	"	   AND b.espe_ccod = c.espe_ccod " & vbCrLf & _
	"	   and b.espe_ccod = d.espe_ccod " & vbCrLf & _
	"      and b.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
	"	   and cast(d.sede_ccod as varchar)= '" & sede &"'" & vbCrLf & _
 	"	   and cast(d.peri_ccod as varchar)= '" & peri &"'" & vbCrLf & _
	"	 order by a.carr_ccod, b.espe_ccod, c.plan_ccod "

fbusqueda.inicializaListaDependiente "lBusqueda", consulta

fbusqueda.siguiente

'*********************************
set fAsignaturas = new cFormulario
fAsignaturas.carga_parametros "adm_secciones_filtradas.xml", "3"
fAsignaturas.inicializar conexion
if carrera <> "" and nivel <> "" then
	filtro = " nive_ccod=" & nivel & " and b.plan_ccod=isnull(" & plan & ",0)"  
elseif carrera <> "" then
	filtro = " b.plan_ccod=isnull(" & plan & ",0)"  	
else
	filtro = " 1=2 "
end if
'consulta = " select " & sede & vbCrLf & _
'" as sede_ccod, b.asig_ccod, asig_tdesc " & vbCrLf & _
'"  , a.carr_ccod, " & peri & " as periodo ,a.nive_ccod ,a.plan_ccod,a.espe_ccod " & vbCrLf & _
'"   , sum(decode(secc_finicio_sec,null,0,1)) as nro_secciones " & vbCrLf & _
'"  , nvl(sum(secc_nquorum),0) as minimo " & vbCrLf & _
'"  , nvl(sum(secc_ncupo),0) as cupo  " & vbCrLf & _
'" from " & vbCrLf & _
'"  (  " & vbCrLf & _
'"    select distinct a.asig_ccod, c.carr_ccod,a.nive_ccod,b.plan_ccod,c.espe_ccod  " & vbCrLf & _
'"      from  " & vbCrLf & _
'"          malla_curricular a " & vbCrLf & _
'"         , planes_estudio b " & vbCrLf & _
'"         , especialidades c " & vbCrLf & _
'"      where " & vbCrLf & _
'"        a.plan_ccod=b.plan_ccod " & vbCrLf & _
'"          and b.espe_ccod=c.espe_ccod " & vbCrLf & _
'"          and  " & filtro & vbCrLf & _
'"   ) a, " & vbCrLf & _
'"	(   " & vbCrLf & _
'"		select asig_ccod, carr_ccod ,secc_nquorum,secc_ncupo,secc_finicio_sec,sede_ccod,peri_ccod " & vbCrLf & _
'"		  from   " & vbCrLf & _
'"			  secciones  " & vbCrLf & _
'"		  where carr_ccod (+)= '" & carrera & "' " & vbCrLf & _
'"			and peri_ccod (+)= " & peri &" " & vbCrLf & _
'"			and sede_ccod (+)= " & sede &" " & vbCrLf & _
'"			and secc_finicio_sec is not null  " & vbCrLf & _
'"			and secc_ftermino_sec is not null  " & vbCrLf & _
'"	   ) c " & vbCrLf & _
'"   , asignaturas b " & vbCrLf & _
'"  where " & vbCrLf & _
'"    a.asig_ccod=b.asig_ccod " & vbCrLf & _
'"    and a.asig_ccod = c.asig_ccod(+) " & vbCrLf & _
'"   group by sede_ccod, b.asig_ccod, asig_tdesc,a.carr_ccod,a.nive_ccod,a.plan_ccod,a.espe_ccod, a.carr_ccod  " & vbCrLf


'consulta="select " & sede &" as sede_ccod, bb.asig_ccod, asig_tdesc, aa.carr_ccod, " & peri & " as periodo ,aa.nive_ccod ,aa.plan_ccod,aa.espe_ccod," & vbCrLf & _ 
'         " sum(case secc_finicio_sec when null then 0 else 1 end ) as nro_secciones," & vbCrLf & _
'         " isnull(sum(secc_nquorum),0) as minimo, " & vbCrLf & _
'         " isnull(sum(secc_ncupo),0) as cupo  " & vbCrLf & _
' 		 " from" & vbCrLf & _ 
'         " 		(select distinct a.asig_ccod, c.carr_ccod,a.nive_ccod,b.plan_ccod,c.espe_ccod, mall_ccod  " & vbCrLf & _
'         " 		from malla_curricular a, planes_estudio b, especialidades c " & vbCrLf & _
'         " 		where " & vbCrLf & _
'         " 		a.plan_ccod=b.plan_ccod " & vbCrLf & _
'         " 		and b.espe_ccod=c.espe_ccod " & vbCrLf & _
'         " 		and  " & filtro & " "& vbCrLf & _
'         "      ) aa, " & vbCrLf & _
'         "      (select asig_ccod, carr_ccod ,secc_nquorum,secc_ncupo,secc_finicio_sec,sede_ccod,peri_ccod,mall_ccod " & vbCrLf & _
'		 "      from   " & vbCrLf & _
'		 "	    secciones  " & vbCrLf & _
'		 "      where cast(carr_ccod as varchar) = '" & carrera & "' " & vbCrLf & _
'		 "	    and cast(peri_ccod as varchar)= '" & peri &"' " & vbCrLf & _
'		 " 	    and cast(sede_ccod as varchar)='" & sede &"' " & vbCrLf & _
'		 "	    and secc_finicio_sec is not null  " & vbCrLf & _
'		 "	    and secc_ftermino_sec is not null  " & vbCrLf & _
'	     "      ) cc" & vbCrLf & _ 
'         "      , asignaturas bb " & vbCrLf & _
'         "		where" & vbCrLf & _ 
'         "		aa.asig_ccod=bb.asig_ccod " & vbCrLf & _
'    	 "		and aa.asig_ccod *= cc.asig_ccod " & vbCrLf & _
'		 "		and aa.mall_ccod *= cc.mall_ccod " & vbCrLf & _
'   		 "		group by sede_ccod, bb.asig_ccod, asig_tdesc,aa.carr_ccod,aa.nive_ccod,aa.plan_ccod,aa.espe_ccod, aa.carr_ccod"
   		 
'----------------------------------------------------------------------------------------------------------Nueva consulta 2008
consulta = "select "& sede &"                   as sede_ccod,                  " & vbCrLf &_
"       bb.asig_ccod,                                                          " & vbCrLf &_
"       asig_tdesc,                                                            " & vbCrLf &_
"       aa.carr_ccod,                                                          " & vbCrLf &_
"       " & peri & "                 as periodo,                               " & vbCrLf &_
"       aa.nive_ccod,                                                          " & vbCrLf &_
"       aa.plan_ccod,                                                          " & vbCrLf &_
"       aa.espe_ccod,                                                          " & vbCrLf &_
"       sum(case secc_finicio_sec                                              " & vbCrLf &_
"             when null then 0                                                 " & vbCrLf &_
"             else 1                                                           " & vbCrLf &_
"           end)                     as nro_secciones,                         " & vbCrLf &_
"       isnull(sum(secc_nquorum), 0) as minimo,                                " & vbCrLf &_
"       isnull(sum(secc_ncupo), 0)   as cupo                                   " & vbCrLf &_
"from   (select distinct a.asig_ccod,                                          " & vbCrLf &_
"                        c.carr_ccod,                                          " & vbCrLf &_
"                        a.nive_ccod,                                          " & vbCrLf &_
"                        b.plan_ccod,                                          " & vbCrLf &_
"                        c.espe_ccod,                                          " & vbCrLf &_
"                        mall_ccod                                             " & vbCrLf &_
"        from   malla_curricular as a                                          " & vbCrLf &_
"               inner join planes_estudio as b                                 " & vbCrLf &_
"                       on a.plan_ccod = b.plan_ccod                           " & vbCrLf &_
"                          and " & filtro & "--es un b.                        " & vbCrLf &_
"               inner join especialidades as c                                 " & vbCrLf &_
"                       on b.espe_ccod = c.espe_ccod) as aa                    " & vbCrLf &_
"       left outer join (select asig_ccod,                                     " & vbCrLf &_
"                               carr_ccod,                                     " & vbCrLf &_
"                               secc_nquorum,                                  " & vbCrLf &_
"                               secc_ncupo,                                    " & vbCrLf &_
"                               secc_finicio_sec,                              " & vbCrLf &_
"                               sede_ccod,                                     " & vbCrLf &_
"                               peri_ccod,                                     " & vbCrLf &_
"                               mall_ccod                                      " & vbCrLf &_
"                        from   secciones                                      " & vbCrLf &_
"                        where  cast(carr_ccod as varchar) = '" & carrera & "' " & vbCrLf &_
"                               and cast(peri_ccod as varchar) = '" & peri &"' " & vbCrLf &_
"                               and cast(sede_ccod as varchar) = '" & sede &"' " & vbCrLf &_
"                               and secc_finicio_sec is not null               " & vbCrLf &_
"                               and secc_ftermino_sec is not null) as cc       " & vbCrLf &_
"                    on aa.asig_ccod = cc.asig_ccod                            " & vbCrLf &_
"                       and aa.mall_ccod = cc.mall_ccod                        " & vbCrLf &_
"       inner join asignaturas as bb                                           " & vbCrLf &_
"               on aa.asig_ccod = bb.asig_ccod                                 " & vbCrLf &_
"group  by sede_ccod,                                                          " & vbCrLf &_
"          bb.asig_ccod,                                                       " & vbCrLf &_
"          asig_tdesc,                                                         " & vbCrLf &_
"          aa.carr_ccod,                                                       " & vbCrLf &_
"          aa.nive_ccod,                                                       " & vbCrLf &_
"          aa.plan_ccod,                                                       " & vbCrLf &_
"          aa.espe_ccod,                                                       " & vbCrLf &_
"          aa.carr_ccod                                                        " 
'------------------------------------------------------------------------------------------------------fin_Nueva consulta 2008   		 
   
'response.Write("<pre>"&consulta&"</pre>")   
fAsignaturas.consultar consulta

'********************corrección de filtros****************************************************************************
if esVacio(nivel) then
	nive_tdesc_1="Todos"
else
	nive_tdesc_1=conexion.consultaUno("Select nive_tdesc from niveles where cast(nive_ccod as varchar)='"&nivel&"'")
end if
	plan_tdesc_1=conexion.consultaUno("Select plan_tdesc from planes_estudio where cast(plan_ccod as varchar)='"&plan&"'")


%>


<html>
<head>
<title>Administrador de Secciones</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript" type="text/JavaScript">
<!--
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
//-->
</script>

<% fbusqueda.generaJS %>

</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif','../imagenes/botones/salir_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr> 
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr> 
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr> 
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td> 
                  <%pagina.DibujarLenguetas Array("Buscador"), 1%>
                </td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr> 
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
				<table width="100%" cellpadding="0" cellspacing="0">
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif"> <b></b></font></td>
  </tr>
</table>

				<form name="buscador" method="get">
                  <table width="98%"  border="0">
                    <tr>
                      <td width="81%"><table cellspacing=0 cellpadding=0 width="100%" 
border=0>
                        <tbody>
                          <tr>
                                  <td valign=top align=middle height=40> <div align="left">
                                      <% fbusqueda.dibujaCampoLista "lBusqueda", "carr_ccod"%>
                                      <br>
                                      Programa de Estudio</div></td>
                            <td align=middle>&nbsp;</td>
                                  <td valign=top align=middle> <div align="left">
                                      <% fbusqueda.dibujaCampoLista "lBusqueda", "plan_ccod"%>
                                      <br>
                                      Plan </div></td>
                            <td align=middle>&nbsp;</td>
                            <td>
                              <div align=center><font 
                              face="Verdana, Arial, Helvetica, sans-serif" 
                              size=1></font></div>
                            </td>
                          </tr>
                          <tr>
                            <td valign=top align=middle>
                              <div align="left">
                                  <% fbusqueda.dibujaCampoLista "lBusqueda", "espe_ccod"%>
                                  <br>
          Especialidad </div></td>
                            <td align=middle>&nbsp;</td>
                                  <td valign=top align=middle> <div align="left"><%=fbusqueda.dibujaCampo("nive_ccod")%><br>
                                      Nivel</div></td>
                            <td align=middle>&nbsp;</td>
                            <td>&nbsp;</td>
                          </tr>
                        </tbody>
                      </table></td>
                      <td width="19%"><div align="center"><%botonera.dibujaboton "buscar"%></div></td>
                    </tr>
                  </table>
				</form>
                </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
      </tr>
    </table>	
	<br>		
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr> 
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr> 
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr> 
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td> 
                  <%pagina.DibujarLenguetas Array("Administrar Secciones"), 1%>
                </td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr> 
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				  <br>
				  <%if fAsignaturas.nroFilas > 0 then%>
				  <table width="50%" cellspacing="0" cellpadding="0">
                      <tr align="left">
                        <td colspan="5" nowrap><%pagina.DibujarSubtitulo "Resultado de la Busqueda"%></td>
                      </tr>
                      <tr>
                        <td align="right" nowrap>Programa de Estudio :</td>
                        <td nowrap> <strong>
                          <%resultado_busqueda.dibujaCampo("carrera")%>
                        </strong> </td>
                        <td align="right" nowrap>&nbsp;</td>
                        <td align="right" nowrap>Plan :</td>
                        <td nowrap> <strong>
                          <%=plan_tdesc_1%>
                        </strong></td>
                      </tr>
                      <tr>
                        <td align="right" nowrap>Especialidad :</td>
                        <td nowrap> <strong>
                          <%resultado_busqueda.dibujaCampo("especialidad")%>
                        </strong> </td>
                        <td align="right" nowrap>&nbsp;</td>
                        <td align="right" nowrap>Nivel :</td>
                        <td nowrap> <strong>
                          <%=nive_tdesc_1%>
                        </strong> </td>
                      </tr>
					  <tr>
                        <td align="right" nowrap>Nro. Resoluci&oacute;n :</td>
                        <td nowrap> <strong>
                          <%resultado_busqueda.dibujaCampo("plan_nresolucion")%>
                        </strong> </td>
                        <td align="right" nowrap>&nbsp;</td>
                        <td align="right" nowrap>&nbsp;</td>
                        <td nowrap>&nbsp;</td>
                      </tr>
                    </table>
					<%end if%>
			        <br>
                    <div align="center">
                      <table width="98%" cellspacing="0" cellpadding="0">
                        <tr>
                          <td align="right">
                            <form name="hola" method="post" action="">
                            <div align="center">
                              <% fAsignaturas.dibujaTabla %>
                              <br>
                              Para agregar secciones a una asignatura debe seleccionar 
                              una fila desde la lista presentada. </div>
                          </form>
                          </td>
                        </tr>
                      </table>
                    </div>
                  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="89" bgcolor="#D8D8DE"> <div align="right"><%botonera.dibujaboton "salir"%></div></td>
                  <td width="273" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
			<p><br>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>

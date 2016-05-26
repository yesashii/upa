<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "parametros.xml", "btn_adm_secciones"

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
	
resultado_busqueda.carga_parametros "paulo.xml", "pl_academica2_titulos"
resultado_busqueda.inicializar conexion
resultado_busqueda.consultar consulta
resultado_busqueda.siguiente

negocio.inicializa conexion
carreras = negocio.obtenerCarreras
if negocio.obtenerRol = "JC" then
	consulta_busqueda = "select  '" & c_carr &"' as carr_ccod,'" & espe &"' as espe_ccod ,'" & plan &"' as plan_ccod,'" & nivel &"' as nive_ccod " 
end if

formu_resul.carga_parametros "paulo.xml", "pl_academica"
formu_resul.inicializar conexion
formu_resul.consultar consulta_busqueda
'formu_resul.agregaCampoParam "carr_ccod", "filtro", " carr_ccod in ( " & carreras & ") "
formu_resul.agregaCampoParam "carr_ccod", "filtro", " carr_ccod in ( '" & c_carr & "') "
formu_resul.agregaCampoParam "espe_ccod", "filtro", " carr_ccod = '" & c_carr &"'" 
formu_resul.agregaCampoParam "plan_ccod", "filtro", " espe_ccod = '" & espe &"'"  
formu_resul.siguiente


'buscamos el periodo para hacer la planificación en caso de que de esta se trate la actividad
usuario_paso=negocio.obtenerUsuario
autorizada = conexion.consultaUno("select isnull(count(*),0) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and b.srol_ncorr=72 and cast(a.pers_nrut as varchar)='"&usuario_paso&"'")
actividad = session("_actividad")
'response.Write("actividad "&actividad&" autorizada "&autorizada)
'if ((actividad = "6") and (autorizada > "0")) then
'	periodo = session("_periodo")
'else
periodo =  negocio.obtenerPeriodoAcademico("PLANIFICACION")
anos_ccod2 = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar )='"&periodo&"'")
'response.Write(periodo)
plec_ccod = conexion.consultaUno("select plec_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
if plec_ccod <> "1" then
	peri = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod2&"' and plec_ccod=1 ")
else
	peri = periodo
end if
'response.Write(peri)
 
'end if
'peri =  negocio.obtenerPeriodoAcademico("CLASES18")
peri_tdesc  = conexion.consultaUno("select protic.initcap(peri_tdesc) from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")


'if anos_ccod2 < "2006" then
	periodo_mostrar = " case bb.duas_ccod when 3 then '" & peri &"'  else '"&periodo&"' end "
	condicion_periodo = " and cast(a.peri_ccod as varchar)= case b.duas_ccod when 3 then '" & peri &"'  else '"&periodo&"' end "
'else
	'periodo_mostrar = "'"&periodo&"' "
	'condicion_periodo = " and cast(a.peri_ccod as varchar)='"&periodo&"'"
'end if
'response.Write(condicion_periodo)
sede = negocio.obtenerSede

'**********************************************

texto = "Debe seleccionar un criterio de búsqueda y presionar el botón buscar"


carrera       = c_carr
especialidad  = espe

set fbusqueda = new cFormulario
fbusqueda.carga_parametros "parametros.xml", "2"
fbusqueda.inicializar conexion
'peri = negocio.obtenerPeriodoAcademico ( "planificacion" ) 
sede = negocio.obtenerSede

if negocio.obtenerRol = "JC" then
	consulta = "select  '" & carrera &"' as carr_ccod,'" & especialidad &"' as espe_ccod ,'" & plan &"' as plan_ccod,'" & nivel &"' as nive_ccod " 
end if			

fbusqueda.consultar consulta

consulta = "SELECT distinct ltrim(rtrim(cast(a.carr_ccod as varchar))) as carr_ccod, a.carr_tdesc, b.espe_ccod,b.espe_tdesc, c.plan_ccod,c.plan_tdesc, " & vbCrLf & _
	"		c.plan_ncorrelativo " & vbCrLf & _
	"	  FROM carreras a, especialidades b, planes_estudio c, ofertas_academicas d " & vbCrLf & _
	"	 WHERE a.carr_ccod = b.carr_ccod " & vbCrLf & _
	"	   AND b.espe_ccod = c.espe_ccod " & vbCrLf & _
	"	   and b.espe_ccod = d.espe_ccod " & vbCrLf & _
	"	   and cast(d.sede_ccod as varchar)= '" & sede &"'" & vbCrLf & _
 	"	   and cast(d.peri_ccod as varchar) in ('" & peri &"','"&periodo&"')" & vbCrLf & _
    " union " & vbCrLf & _
	" select  distinct ltrim(rtrim(cast(a.carr_ccod as varchar))) as carr_ccod,a.carr_tdesc,b.espe_ccod,b.espe_tdesc,c.plan_ccod,c.plan_tdesc,c.plan_ncorrelativo " & vbCrLf & _
	" from carreras a, especialidades b, planes_estudio c " & vbCrLf & _
	" where a.carr_ccod=b.carr_ccod " & vbCrLf & _
	" and b.espe_ccod=c.espe_ccod" & vbCrLf & _
	" --and cast(b.carr_ccod as varchar)='"&carrera&"'" & vbCrLf & _
	" and b.espe_nplanificable='2' " & vbCrLf & _
	" order by a.carr_tdesc,b.espe_tdesc,c.plan_tdesc asc" 

fbusqueda.inicializaListaDependiente "lBusqueda", consulta
'response.Write("<pre>"&consulta&"</pre>")
fbusqueda.siguiente

'*********************************
set fAsignaturas = new cFormulario
fAsignaturas.carga_parametros "parametros.xml", "3"
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


if espe <> "" then
	jorn_ccod = conexion.consultaUno("select jorn_ccod from ofertas_Academicas where cast(espe_ccod as varchar)='"&espe&"' and cast(peri_ccod as varchar)='"&peri&"' and cast(sede_ccod as varchar)='"&sede&"'")
	filtro_jornada = " and cast(jorn_ccod as varchar)='"&jorn_ccod&"'"
	if jorn_ccod = "" or EsVAcio(jorn_ccod) then
		jorn_ccod = 1
		filtro_jornada = " and cast(jorn_ccod as varchar) in ('1','2')"
	end if 
	
else
	filtro_jornada = ""
end if

consulta="select " & sede &" as sede_ccod, bb.asig_ccod, asig_tdesc, aa.carr_ccod,"&periodo_mostrar&" as periodo ,aa.nive_ccod ,aa.plan_ccod,aa.espe_ccod," & vbCrLf & _ 
         " sum(case secc_finicio_sec when null then 0 else 1 end ) as nro_secciones," & vbCrLf & _
         " isnull(sum(secc_nquorum),0) as minimo, " & vbCrLf & _
         " isnull(sum(secc_ncupo),0) as cupo,bb.EASI_CCOD as estado  " & vbCrLf & _
 		 " from" & vbCrLf & _ 
         " 		(select distinct a.asig_ccod, c.carr_ccod,a.nive_ccod,b.plan_ccod,c.espe_ccod,a.mall_ccod  " & vbCrLf & _
         " 		from malla_curricular a, planes_estudio b, especialidades c " & vbCrLf & _
         " 		where " & vbCrLf & _
         " 		a.plan_ccod=b.plan_ccod " & vbCrLf & _
         " 		and b.espe_ccod=c.espe_ccod " & vbCrLf & _
         " 		and  " & filtro & " "& vbCrLf & _
         "      ) aa " & vbCrLf & _
		 "      join asignaturas bb " & vbCrLf & _
		 "      	on aa.asig_ccod=bb.asig_ccod and bb.EASI_CCOD=1 " & vbCrLf & _
		 "      left outer join  " & vbCrLf & _
         "      (select a.asig_ccod, a.carr_ccod ,a.secc_nquorum,a.secc_ncupo,a.secc_finicio_sec,a.sede_ccod,a.peri_ccod,a.mall_ccod " & vbCrLf & _
		 "      from   " & vbCrLf & _
		 "	    secciones a, asignaturas b,periodos_academicos c " & vbCrLf & _
		 "      where a.asig_ccod=b.asig_ccod " &vbCrLf &_ 
		 "		and cast(carr_ccod as varchar) = '" & carrera & "' " & vbCrLf & _
		 "	    "& condicion_periodo & vbCrLf & _
		 " 	    and a.peri_ccod=c.peri_ccod and cast(c.anos_ccod as varchar)='" & anos_ccod2 &"' " & vbCrLf & _
		 " 	    and cast(sede_ccod as varchar)='" & sede &"' "& filtro_jornada & vbCrLf & _
		 "	    and secc_finicio_sec is not null  " & vbCrLf & _
		 "	    and secc_ftermino_sec is not null  " & vbCrLf & _
	     "      ) cc" & vbCrLf & _ 
         "       on aa.asig_ccod = cc.asig_ccod and aa.mall_ccod = cc.mall_ccod  " & vbCrLf & _
     	 "		group by sede_ccod, bb.asig_ccod, asig_tdesc,aa.carr_ccod,aa.nive_ccod,aa.plan_ccod,aa.espe_ccod, aa.carr_ccod, bb.duas_ccod, bb.EASI_CCOD"
  'response.Write(anos_ccod2)
'RESPONSE.Write("<PRE>"&CONSULTA&"</PRE>")   
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
				  <table width="98%" cellspacing="0" cellpadding="0">
                      <tr align="left">
                        <td colspan="2" nowrap><%pagina.DibujarSubtitulo "Resultado de la Busqueda para "&peri_tdesc%></td>
                      </tr>
					  <tr align="left">
                        <td colspan="2" nowrap>&nbsp;</td>
                      </tr>
                      <tr>
                        <td width="27%" align="left" nowrap>Programa de Estudio </td>
                        <td width="73%" nowrap> :<strong>
                          <%resultado_busqueda.dibujaCampo("carrera")%>
                        </strong> </td>
                      </tr>
                      <tr>
                        <td align="left" nowrap>Especialidad </td>
                        <td nowrap> :<strong>
                          <%resultado_busqueda.dibujaCampo("especialidad")%>
                        </strong> </td>
                      </tr>
					  <tr>
                        <td align="left" nowrap>Nro. Resoluci&oacute;n </td>
                        <td nowrap> :<strong>
                          <%resultado_busqueda.dibujaCampo("plan_nresolucion")%>
                        </strong> </td>
                      </tr>
					  <tr>
                        <td align="left" nowrap>Plan </td>
                        <td nowrap> :<strong>
                          <%=plan_tdesc_1%>
                        </strong></td>
                      </tr>
					  <tr>
                        <td align="left" nowrap>Nivel </td>
                        <td nowrap> :<strong>
                          <%=nive_tdesc_1%>
                        </strong> </td>
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

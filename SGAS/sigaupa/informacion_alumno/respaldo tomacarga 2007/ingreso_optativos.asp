<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
 
set pagina = new CPagina
pagina.Titulo = "Optativos Deportivos"
matr_ncorr		= 	session("matr_ncorr")
asig_ccod	=	request.querystring("a[0][asig_ccod]")
secc_ccod	=	request.querystring("a[0][secc_ccod]")
'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set f_botonera = new CFormulario

f_botonera.Carga_Parametros "toma_carga_alfa.xml", "BotoneraTomaCarga"

set botonera = new CFormulario
botonera.carga_parametros "toma_carga_alfa.xml", "BotoneraOptativosDeportivos"

set f_botonera_optativo = new CFormulario
f_botonera_optativo.Carga_Parametros "toma_carga_alfa.xml", "BotoneraOptativos"

set errores 	= new cErrores
set optativos_deportivos = new cformulario

optativos_deportivos.carga_parametros "toma_carga_alfa.xml" , "tabla_Op_deportivos"
optativos_deportivos.inicializar	conectar

peri_ccod = conectar.consultaUno("Select peri_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")
sede_ccod = conectar.consultaUno("Select sede_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")
pers_ncorr = conectar.consultaUno("Select pers_ncorr from alumnos  where cast(matr_ncorr as varchar)='"&matr_ncorr&"'")
carr_prueba = conectar.consultaUno("Select carr_ccod from alumnos a, ofertas_academicas b,especialidades c where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr and b.espe_ccod = c.espe_ccod")
v_sede  = conectar.consultaUno ("select sede_tdesc from alumnos a, ofertas_academicas b, sedes c where cast(matr_ncorr as varchar)='" & matr_ncorr & "' and a.ofer_ncorr=b.ofer_ncorr and b.sede_ccod = c.sede_ccod")
v_jornada  = conectar.consultaUno ("select jorn_tdesc from alumnos a, ofertas_academicas b, jornadas c where cast(matr_ncorr as varchar)='" & matr_ncorr & "' and a.ofer_ncorr=b.ofer_ncorr and b.jorn_ccod = c.jorn_ccod")


'-------------------------------------------Seleccionar asignatura para equivalencia de una lista sin escribir su código-----
'-----------------------------------------------------------msandoval 19-02-2005---------------------------------------------
set fbusqueda = new cFormulario
fbusqueda.carga_parametros "toma_carga_alfa.xml", "buscador_optativos"
fbusqueda.inicializar conectar
peri = peri_ccod 'negocio.obtenerPeriodoAcademico ( "planificacion" ) 
sede = sede_ccod 'negocio.obtenerSede

if sede = "1" or sede="2" then
	filtro_sede = " and sede_ccod in (1,2)"
else
	filtro_sede = " and cast(sede_ccod as varchar)='"&sede&"'"
end if

'-----------------------------------------Debemos revisar si el alumno reprobo alguna asignatura deportiva, de ser así-------
'-------------------------------------------- Esta será la única que se le mostrará en el listado-------------------------
consulta_reprobados = " select distinct bb.asig_ccod from cargas_academicas aa, secciones bb,alumnos cc " & vbCrLf & _
		   " where bb.secc_ccod in (select secc_ccod from secciones a, malla_curricular b,periodos_academicos c " & vbCrLf & _
		   "                       where carr_ccod='820' and a.peri_ccod=c.peri_ccod and c.anos_ccod >= 2005 " & vbCrLf & _
		   "                       and a.mall_ccod = b.mall_ccod and a.asig_ccod=b.asig_ccod " & vbCrLf & _
		   "                       and b.plan_ccod=378 "&filtro_sede&") " & vbCrLf & _
		   " and aa.secc_ccod = bb.secc_ccod  " & vbCrLf & _                     
		   " and aa.matr_ncorr = cc.matr_ncorr " & vbCrLf & _
		   " and sitf_ccod = 'R'  and cast(carr_ccod as varchar)='"&carr_prueba&"'" & vbCrLf & _
		   " and aa.estado_cierre_ccod = 2 " & vbCrLf & _
		   " and cast(cc.pers_ncorr as varchar)='"&pers_ncorr&"'" & vbCrLf & _
		   " and not exists (select 1 from alumnos a, cargas_academicas b, secciones c, situaciones_finales d " & vbCrLf & _
		   "                         where a.pers_ncorr= cc.pers_ncorr and a.matr_ncorr = b.matr_ncorr " & vbCrLf & _
		   "                         and b.secc_ccod = c.secc_ccod and c.asig_ccod = bb.asig_ccod " & vbCrLf & _
		   "                         and b.sitf_ccod= d.sitf_ccod " & vbCrLf & _
		   "                         and d.sitf_baprueba='S')" 

cantidad_reprobados = conectar.consultaUno("select count(*) from ("&consulta_reprobados&")aaaa")

'response.Write(cantidad_reprobados)

'-----------------------------------------------------------------------------------------------------------------------------
consulta="Select '"&asig_ccod&"' as asig_ccod, '"&secc_ccod&"' as secc_ccod"

fbusqueda.consultar consulta

consulta = "  select a.secc_ccod, subString(a.secc_tdesc,1,1) +'--> '+ protic.horario(a.secc_ccod)  + ' (' + cast((a.secc_ncupo - (select count(*) from cargas_academicas ca where a.secc_ccod=ca.secc_ccod))as varchar) + ') ' " & vbCrLf & _
		   " + ' - ' + (select top 1 'Horario Clase: ('+ cast( datepart(hour,hora_hinicio)as varchar)+ ':' + cast( datepart(minute,hora_hinicio)as varchar)+ " & vbCrLf & _
           " ' -- ' + cast( datepart(hour,hora_htermino)as varchar)+ ':' + cast( datepart(minute,hora_htermino)as varchar)+ ')'  " & vbCrLf & _
 		   "            from bloques_horarios ccc, horario_asignado_real aaa,horarios_optativos bbb  " & vbCrLf & _
		   " where ccc.secc_ccod= a.secc_ccod and aaa.bloq_ccod=ccc.bloq_ccod " & vbCrLf & _
		   " and aaa.hora_ccod_optativos=bbb.hora_ccod_optativos) + ' / ' + cast( (a.secc_ncupo - (select count(*) from cargas_academicas ca where ca.secc_ccod = a.secc_ccod) ) as varchar) + ' Cupos Disp.' as secc_tdesc, " & vbCrLf & _
		   " b.asig_ccod, b.asig_tdesc + ' ('+ltrim(rtrim(b.asig_ccod))+')'  as asig_tdesc " & vbCrLf & _
		   " from secciones a, asignaturas b,malla_curricular c " & vbCrLf & _
		   " where a.asig_ccod = b.asig_ccod " & vbCrLf & _
		   " and a.asig_ccod = c.asig_ccod and a.mall_ccod=c.mall_ccod " & vbCrLf & _
		   " and c.plan_ccod = '378' " & vbCrLf & _
		   " and a.carr_ccod = '820' "& filtro_sede & vbCrLf & _
		   " and a.secc_ncupo > 0  and asig_tdesc not like '%seleccion%' " & vbCrLf & _
		   " and exists (select 1 from bloques_horarios bb where bb.secc_ccod=a.secc_ccod) " & vbCrLf & _
	   	   " and (a.secc_ncupo - (select count(*) from cargas_academicas ca where ca.secc_ccod = a.secc_ccod) ) > 0 " & vbCrLf &_
		   " and cast(a.peri_ccod as varchar)= '"&peri&"'" 

if (cantidad_reprobados <> "0" and cantidad_reprobados <> "") then
	consulta = consulta & " and b.asig_ccod in ("&consulta_reprobados&")"
end if		   

fbusqueda.inicializaListaDependiente "lBusqueda", consulta & " order by asig_tdesc "
fbusqueda.siguiente
afecta_promedio=false
activo="0"
'response.Write("<pre>"&consulta&"</pre>")

'------------------------consulta para mostrar los optativos deportivos que tiene en la carga el alumno-----------------------------------
'--------------------------------------agregada el 14 de julio de 2005 por Marcelo Sandoval-----------------------------------------------
cons_optativo=" select '"&matr_ncorr&"' as matr_ncorr,a.secc_ccod, c.asig_ccod + ' --> ' + c.asig_tdesc as asignatura, "& vbCrLf & _
			  " 'Secc. ' + cast(b.secc_tdesc as varchar)+' -> '+ cast(protic.horario(b.secc_ccod) as varchar)+ "& vbCrLf & _
			  " ' - ' + (select 'Horario Clase: ('+ cast( datepart(hour,hora_hinicio)as varchar)+ ':' + cast( datepart(minute,hora_hinicio)as varchar)+  "& vbCrLf & _
			  " ' -- ' + cast( datepart(hour,hora_htermino)as varchar)+ ':' + cast( datepart(minute,hora_htermino)as varchar)+ ')'  "& vbCrLf & _
			  " from bloques_horarios ccc, horario_asignado_real aaa,horarios_optativos bbb  "& vbCrLf & _
			  "	where ccc.secc_ccod= a.secc_ccod and aaa.bloq_ccod=ccc.bloq_ccod "& vbCrLf & _
			  "            and aaa.hora_ccod_optativos=bbb.hora_ccod_optativos) as horario, "& vbCrLf & _
			  " carg_afecta_promedio as afecta "& vbCrLf & _
			  " from cargas_academicas a, secciones b, asignaturas c,malla_curricular d "& vbCrLf & _
		      " where a.secc_ccod = b.secc_ccod "& vbCrLf & _
		      " and b.asig_ccod = c.asig_ccod "& vbCrLf & _
			  " and b.mall_ccod = d.mall_ccod  and d.plan_ccod = 378"& vbCrLf & _
			  " and cast(a.matr_ncorr as varchar)= '"&matr_ncorr&"' "& vbCrLf & _
			  " and cast(b.peri_ccod as varchar)= '"&peri_ccod&"' "& vbCrLf & _
			  " and b.carr_ccod='820' "
			
'response.Write("<pre>"&cons_optativo&"</pre>")
optativos_deportivos.consultar cons_optativo


peri_tdesc = conectar.consultaUno("Select protic.initcap(peri_tdesc) from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
pers_ncorr= session("pers_ncorr_alumno")
				  
 nombre = conectar.consultaUno ("select cast(pers_tnombre as varchar) + ' ' + cast(pers_tape_paterno as varchar) + ' ' + cast(pers_tape_materno as varchar) from personas where cast(pers_ncorr as varchar)='" & pers_ncorr & "'")
 v_carr_ccod  = conectar.consultaUno ("select ltrim(rtrim(c.carr_ccod)) from alumnos a, ofertas_academicas b, especialidades c where cast(matr_ncorr as varchar)='" & matr_ncorr & "' and a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod = c.espe_ccod")
 carrera = conectar.consultaUno ("select carr_tdesc from carreras  where carr_ccod='"&v_carr_ccod&"'")
 rut = conectar.consultaUno ("select cast(pers_nrut as varchar)+ '-'+ pers_xdv from personas where cast(pers_ncorr as varchar)='" & pers_ncorr & "'")

pers_nrut = conectar.consultaUno("Select pers_nrut from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
pers_xdv = conectar.consultaUno("Select pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
url="../CERTIFICADOS/HISTORICO_NOTAS_LIBRE.ASP?busqueda[0][pers_nrut]="&pers_nrut&"&busqueda[0][pers_xdv]="&pers_xdv&"&ocultar=1"

tipo_plan = conectar.consultaUno("select isnull(plan_tcreditos,0) from alumnos a, planes_estudio b where a.plan_ccod=b.plan_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")

if tipo_plan = "0" then
	lenguetas_carga = Array(Array("Asignaturas Malla Curricular", "toma_carga_nuevo.asp"),Array("Formación Profesional", "toma_formacion_profesional.asp"), Array("Optativos Deportivos", "ingreso_optativos.asp"), Array("Cursos Artísticos-Culturales", "ingreso_cursos_dae.asp"))
else
	lenguetas_carga = Array(Array("Asignaturas Malla Curricular", "toma_carga_nuevo.asp"),Array("Formación Profesional", "toma_formacion_profesional.asp"), Array("Optativos Deportivos", "ingreso_optativos.asp"), Array("Cursos Artísticos-Culturales", "ingreso_cursos_dae.asp"))
end if	

if tipo_plan <> "0" then
	suma_creditos = conectar.consultaUno("select protic.obtener_creditos_asignados("&matr_ncorr&")")
end if

%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>



<script language="JavaScript">

function abrir_optativo(){
		var matricula 	= '<%=matr_ncorr%>';
		var pers 		= '<%=pers_ncorr%>';
		var sede		= '<%=sede_ccod%>';
		var plan		= '<%=plan_ccod%>';
		var periodo     = '<%=peri_ccod%>';
		
		direccion = "busca_optativo_deportivo.asp?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo;
		resultado=window.open(direccion, "ventana1","scrollbars=yes,resizable,width=710,height=280");
}
function eliminar_optativo (formulario){
   		if (verifica_check(document.edicion2))
			{
				if (confirm("¿Está seguro que desea eliminar el optativo deportivo de la carga del alumno?"))
				{
					document.edicion2.method="post"
					document.edicion2.action="eliminar_optativo.asp";
					document.edicion2.submit();
				}
			}
			else{
				alert('No ha seleccionado ninguna asignatura optativa a eliminar.');
			}
}

function verifica_check(formulario) {
	num=formulario.elements.length;
	c=0;
	for (i=0;i<num;i++){
		nombre = formulario.elements[i].name;
		var elem = new RegExp ("secc_ccod","gi");
		if (elem.test(nombre)){
			if((formulario.elements[i].checked==true)){
				c=c+1;
			}
		}
	}
	if (c>0) {
		return (true);
	}
	else {
		return (false);
	}
}
function guardar(formulario){
			formulario.method="post";
			formulario.action="guardar_optativo.asp";
			formulario.submit();
}
function validar()
{ var formulario=document.edicion;
      activo = '<%=activo%>';
      asignatura = formulario.elements["a[0][ASIG_CCOD]"].value;
	  seccion = formulario.elements["a[0][SECC_CCOD]"].value;
  	  valor_retorno=false;
	  if (asignatura!="" && seccion!="")
	    valor_retorno=true;
	  else
	  {
	   alert("Debe seleccionar la asignatura y la sección que desea asignar al alumno");
	   valor_retorno=false;
	  }	
	
  return valor_retorno;
}
function MM_swapImgRestore() 
{ //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() 
{ //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) 
{ //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() 
{ //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
</script>
<% fbusqueda.generaJS %>
<STYLE type="text/css">
 <!-- 
 A {color: #000000;  text-decoration: none; font-weight: bold;}
 A:hover {COLOR: #63ABCC; }

 // -->
 </STYLE>
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.anchofijo {
	font-family: "Courier New", Courier, mono;
	font-size: 10px;
	width: 350px;
}
-->
</style>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="80" valign="top"><img src="../imagenes/banner.jpg" width="750" height="100" border="0"></td>
  </tr>
  <%'pagina.DibujarEncabezado()%>    
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
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
            <td><%pagina.DibujarLenguetas lenguetas_carga, 3 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
                    <% pagina.Titulo = pagina.Titulo & "<br>" & peri_tdesc & "<br>Online"
					  pagina.DibujarTituloPagina%>
                    <br>
                </div>
           
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
              <form name="edicion" > 
			  <tr>
                <td>&nbsp; </td>
                <td colspan="2">&nbsp; </td>
              </tr>
			  <tr>
                <td width="10%"><strong>RUT</strong></td>
                <td width="2%"><strong>:</strong> </td>
				<td align="left"><font color="#CC0000"><strong><%= rut %></strong></font></td>
              </tr>
              <tr>
				<td width="10%"><strong>Nombre</strong></td>
                <td width="2%"><strong>:</strong> </td>
				<td align="left"><font color="#CC0000"><strong><%=nombre %></strong></font></td>
              </tr>
              <tr>
				<td width="10%"><strong>Sede</strong></td>
                <td width="2%"><strong>:</strong> </td>
				<td align="left"><font color="#CC0000"><strong><%=v_sede %></strong></font></td>
			  </tr>  
			  <tr>
				<td width="10%"><strong>Carrera</strong></td>
                <td width="2%"><strong>:</strong> </td>
				<td align="left"><font color="#CC0000"><strong><%=carrera %></strong></font></td>
			  </tr>
			  <tr>
				<td width="10%"><strong>Jornada</strong></td>
                <td width="2%"><strong>:</strong> </td>
				<td align="left"><font color="#CC0000"><strong><%=v_jornada %></strong></font></td>
			  </tr>
			  <tr><td colspan="3">&nbsp;</td></tr>
			  <tr><td colspan="3">
			  		<table width="100%"  border="0">
					    <tr>
							<td><font size="2" color="#4b7fc6"><strong>1.- Seleccione los optativos deportivos que desee cursar en el semestre.</strong></font>
							</td>
						</tr>
						 <tr>
							<td>&nbsp;</td>
						</tr>
                      <tr>
                        <td width="81%">
						      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="10%"> <div align="left"><strong>Optativo</strong> 
                                </div></td>
								<td width="5%"> <div align="center">:</div> </td>
								<td width="85%" align="left"><% fbusqueda.dibujaCampoLista "lBusqueda", "asig_ccod"%></td>
                              </tr>
							  <tr><td colspan="3"><hr></td></tr>
							  <tr> 
                                <td width="10%"> <div align="left"><strong>Horario</strong></div></td>
								<td width="5%"> <div align="center">:</div> </td>
								<td width="85%" align="left"-><% fbusqueda.dibujaCampoLista "lBusqueda", "secc_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="10%"> <div align="left">&nbsp;</div></td>
								<td width="5%"> <div align="center"><input type="hidden" name="matr_ncorr" value="<%=matr_ncorr%>">&nbsp;</div> </td>
                              	<td width="85%" align="right">
								                <% if cint(suma_creditos) < 27 then%>
													<a href="javascript:_Guardar(this, document.forms['edicion'], 'guardar_optativo.asp','', 'validar()', '', 'TRUE');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('guardar_carga','','../imagenes/boton_guardar_activo.gif',1)"><img src="../imagenes/boton_guardar_pasivo.gif" width="119" height="31" border="0" name="guardar_carga">
												<%end if%>
								</td>
							  </tr>
							  <tr>
							     <td colspan="3" align="center">&nbsp;</font></td>	
							  </tr>
							  <%if tipo_plan <> "0" and cint(suma_creditos) >= 27 then%>
								<tr>
								   <td colspan="3" align="center"><font  size="2" color="#0000FF"><strong>Atención el total de Cr&eacute;ditos Asignados (<%=suma_creditos%>) esta fuera del rango permitido (9-27).<br> Elimine parte de la carga para tomar el optativo.</strong></font>
								   </td>
								</tr>
							  <%end if%>
                            </table></td>
						</tr>
                    </table>
			      </td>
			  </tr>
			  </form>
            </table>
			
            <form name="edicion2">
			  <input type="hidden" name="matr_ncorr" value="<%=matr_ncorr%>">
					 <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
					  <tr>
							<td><font size="2" color="#4b7fc6"><strong>2.- Listado de Optativos Deportivos que ya pertenecen a su carga académica.</strong></font>
							</td>
					  </tr>
					 </table>
				     <table width="100%" border="0">
					  <tr> 
						<td align="right">&nbsp;</td>
					  </tr>
					  <tr> 
						 <td><strong><font color="000000" size="1"> 
						 <% optativos_deportivos.dibujaTabla%>
						 </font></strong></td>
					  </tr>
					  <tr> 
						<td align="right">&nbsp;</td>
					  </tr>
					  <tr>
						<td align="right">
						<% if optativos_deportivos.NroFilas > 0 then %>
							<a href="javascript:eliminar_optativo(document.edicion_optativo);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('eliminar_carga','','../imagenes/boton_eliminar_activo.gif',1)"><img src="../imagenes/boton_eliminar_pasivo.gif" width="119" height="31" border="0" name="eliminar_carga">
						<%end if%>
						</td>
					  </tr>
       			</table>
                <br>
    			</form>
            </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="13%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    <% f_botonera.agregaBotonParam "anterior", "url", "toma_formacion_profesional.asp"
					  f_botonera.DibujaBoton "anterior"%>
                      </div>
				   </td>
                </tr>
              </table>
            </div></td>
            <td width="87%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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

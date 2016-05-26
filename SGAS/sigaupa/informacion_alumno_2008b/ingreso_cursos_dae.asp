 <!-- #include file="../biblioteca/_conexion.asp" -->
 <!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
 
set pagina = new CPagina
pagina.Titulo = "Cursos Artístico - Culturales"
matr_ncorr  	= 	session("matr_ncorr")
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
botonera.carga_parametros "toma_carga_alfa.xml", "BotoneraCursosArtisticos"

set f_botonera_optativo = new CFormulario
f_botonera_optativo.Carga_Parametros "toma_carga_alfa.xml", "BotoneraOptativos"

set errores 	= new cErrores
set optativos_deportivos = new cformulario

optativos_deportivos.carga_parametros "toma_carga_alfa.xml" , "tabla_Op_deportivos"
optativos_deportivos.inicializar	conectar

'sacamos todos los datos en una sola consulta en vez de llenarnos de consultaUno
set f_datos = new CFormulario
f_datos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_datos.Inicializar conectar
c_datos = " select a.pers_ncorr,c.peri_ccod,b.sede_ccod,b.jorn_ccod,c.peri_tdesc,f.carr_ccod as carr_temporal, " & vbCrLf &_
		  " cast(i.pers_tnombre as varchar) + ' ' + cast(i.pers_tape_paterno as varchar) + ' ' + cast(i.pers_tape_materno as varchar) as nombre, " & vbCrLf &_
		  " f.carr_tdesc as carrera, cast(i.pers_nrut as varchar)+ '-'+ i.pers_xdv as rut,d.sede_tdesc as v_sede,  " & vbCrLf &_
		  " g.jorn_tdesc as v_jornada,a.plan_ccod,isnull(h.plan_tcreditos,0) as tipo_plan, i.pers_nrut,i.pers_xdv " & vbCrLf &_
		  " from alumnos a, ofertas_academicas b, periodos_academicos c,sedes d, especialidades e,  " & vbCrLf &_
		  " carreras f,jornadas g, planes_estudio h, personas i                 " & vbCrLf &_
		  " where a.ofer_ncorr = b.ofer_ncorr  " & vbCrLf &_
		  " and b.peri_ccod = c.peri_ccod " & vbCrLf &_
		  " and b.sede_ccod = d.sede_ccod " & vbCrLf &_
		  " and b.espe_ccod = e.espe_ccod " & vbCrLf &_ 
		  " and e.carr_ccod = f.carr_ccod " & vbCrLf &_
		  " and b.jorn_ccod = g.jorn_ccod " & vbCrLf &_
		  " and a.plan_ccod = h.plan_ccod " & vbCrLf &_
		  " and a.pers_ncorr = i.pers_ncorr " & vbCrLf &_
		  " and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'"
f_datos.Consultar c_datos
f_datos.siguiente		  
if f_datos.nroFilas > 0 then
	peri_ccod = f_datos.obtenerValor("peri_ccod")
	sede_ccod = f_datos.obtenerValor("sede_ccod")
	jorn_ccod = f_datos.obtenerValor("jorn_ccod")
	peri_tdesc = f_datos.obtenerValor("peri_tdesc")
	carr_temporal = f_datos.obtenerValor("carr_temporal")
	nombre = f_datos.obtenerValor("nombre")
    v_carr_ccod  = carr_temporal
	carr_prueba  = carr_temporal
    carrera = f_datos.obtenerValor("carrera")
    rut = f_datos.obtenerValor("rut")
    v_sede  = f_datos.obtenerValor("v_sede")
    v_jornada  = f_datos.obtenerValor("v_jornada")
    plan_ccod = f_datos.obtenerValor("plan_ccod")
    tipo_plan = f_datos.obtenerValor("tipo_plan")
    pers_nrut = f_datos.obtenerValor("pers_nrut")
    pers_xdv  = f_datos.obtenerValor("pers_xdv")
	pers_ncorr  = f_datos.obtenerValor("pers_ncorr")
end if
'peri_ccod = conectar.consultaUno("Select peri_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")
'sede_ccod = conectar.consultaUno("Select sede_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")
'pers_ncorr = conectar.consultaUno("Select pers_ncorr from alumnos  where cast(matr_ncorr as varchar)='"&matr_ncorr&"'")
'carr_prueba = conectar.consultaUno("Select carr_ccod from alumnos a, ofertas_academicas b,especialidades c where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr and b.espe_ccod = c.espe_ccod")
'v_sede  = conectar.consultaUno ("select sede_tdesc from alumnos a, ofertas_academicas b, sedes c where cast(matr_ncorr as varchar)='" & matr_ncorr & "' and a.ofer_ncorr=b.ofer_ncorr and b.sede_ccod = c.sede_ccod")
'v_jornada  = conectar.consultaUno ("select jorn_tdesc from alumnos a, ofertas_academicas b, jornadas c where cast(matr_ncorr as varchar)='" & matr_ncorr & "' and a.ofer_ncorr=b.ofer_ncorr and b.jorn_ccod = c.jorn_ccod")

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
		   "                       and b.plan_ccod=479 "&filtro_sede&") " & vbCrLf & _
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
		   " and c.plan_ccod = '479' " & vbCrLf & _
		   " and a.carr_ccod = '820' "& filtro_sede & vbCrLf & _
		   " and a.secc_ncupo > 0 " & vbCrLf & _
		   " and exists (select 1 from bloques_horarios bb where bb.secc_ccod=a.secc_ccod) " & vbCrLf & _
		   " and (a.secc_ncupo - (select count(*) from cargas_academicas ca where ca.secc_ccod = a.secc_ccod) ) > 0 " & vbCrLf &_
		   " and cast(a.peri_ccod as varchar)= '"&peri&"'" 

if (cantidad_reprobados <> "0" and cantidad_reprobados <> "") then
	consulta = consulta & " and b.asig_ccod in ("&consulta_reprobados&")"
end if		   

cantidad_planificada = conectar.consultaUno("select count(*) from ("&consulta&")a")
'response.Write("<pre>"&cantidad_planificada&"</pre>")	

fbusqueda.inicializaListaDependiente "lBusqueda", consulta & " order by asig_tdesc "
fbusqueda.siguiente

'afecta_promedio=true	
'f_afecta.agregaCampoParam "carg_afecta_promedio","deshabilitado","FALSE"
'f_afecta.agregaCampoParam "carg_afecta_promedio","id","TO-N"
'f_afecta.agregaCampoCons "carg_afecta_promedio","N"
activo="1"

'------------------------consulta para mostrar los cursos artístico-culturales que tiene en la carga el alumno-----------------------------------
'--------------------------------------agregada el 19 de julio de 2006 por Marcelo Sandoval-----------------------------------------------
cons_optativo=" select '"&matr_ncorr&"' as matr_ncorr,a.secc_ccod, c.asig_ccod + ' --> ' + c.asig_tdesc as asignatura, "& vbCrLf & _
			  " 'Secc. ' + cast(b.secc_tdesc as varchar)+' -> '+ cast(protic.horario(b.secc_ccod) as varchar)+ "& vbCrLf & _
			  " ' - ' + (select 'Horario Clase: ('+ cast( datepart(hour,hora_hinicio)as varchar)+ ':' + cast( datepart(minute,hora_hinicio)as varchar)+  "& vbCrLf & _
			  " ' -- ' + cast( datepart(hour,hora_htermino)as varchar)+ ':' + cast( datepart(minute,hora_htermino)as varchar)+ ')'  "& vbCrLf & _
			  " from bloques_horarios ccc, horario_asignado_real aaa,horarios_optativos bbb  "& vbCrLf & _
			  "	where ccc.secc_ccod= a.secc_ccod and aaa.bloq_ccod=ccc.bloq_ccod "& vbCrLf & _
			  "            and aaa.hora_ccod_optativos=bbb.hora_ccod_optativos) as horario, "& vbCrLf & _
			  " 'S' as afecta "& vbCrLf & _
			  " from cargas_academicas a, secciones b, asignaturas c,malla_curricular d "& vbCrLf & _
		      " where a.secc_ccod = b.secc_ccod "& vbCrLf & _
		      " and b.asig_ccod = c.asig_ccod "& vbCrLf & _
			  " and b.mall_ccod = d.mall_ccod  and d.plan_ccod = 479"& vbCrLf & _
			  " and cast(a.matr_ncorr as varchar)= '"&matr_ncorr&"' "& vbCrLf & _
			  " and cast(b.peri_ccod as varchar)= '"&peri_ccod&"' "& vbCrLf & _
			  " and b.carr_ccod='820' "
			

optativos_deportivos.consultar cons_optativo


'peri_tdesc = conectar.consultaUno("Select protic.initcap(peri_tdesc) from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
pers_ncorr= session("pers_ncorr_alumno")
				  
' nombre = conectar.consultaUno ("select cast(pers_tnombre as varchar) + ' ' + cast(pers_tape_paterno as varchar) + ' ' + cast(pers_tape_materno as varchar) from personas where cast(pers_ncorr as varchar)='" & pers_ncorr & "'")
' v_carr_ccod  = conectar.consultaUno ("select ltrim(rtrim(c.carr_ccod)) from alumnos a, ofertas_academicas b, especialidades c where cast(matr_ncorr as varchar)='" & matr_ncorr & "' and a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod = c.espe_ccod")
' carrera = conectar.consultaUno ("select carr_tdesc from carreras  where carr_ccod='"&v_carr_ccod&"'")
' rut = conectar.consultaUno ("select cast(pers_nrut as varchar)+ '-'+ pers_xdv from personas where cast(pers_ncorr as varchar)='" & pers_ncorr & "'")

'pers_nrut = conectar.consultaUno("Select pers_nrut from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
'pers_xdv = conectar.consultaUno("Select pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
url="../CERTIFICADOS/HISTORICO_NOTAS_LIBRE.ASP?busqueda[0][pers_nrut]="&pers_nrut&"&busqueda[0][pers_xdv]="&pers_xdv&"&ocultar=1"

'tipo_plan = conectar.consultaUno("select isnull(plan_tcreditos,0) from alumnos a, planes_estudio b where a.plan_ccod=b.plan_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")

if tipo_plan = "0" then
	lenguetas_carga = Array(Array("Asignaturas Malla Curricular", "toma_carga_nuevo.asp"),Array("Formación Profesional", "toma_formacion_profesional.asp"), Array("Optativos Deportivos", "ingreso_optativos.asp"), Array("Cursos Artísticos-Culturales", "ingreso_cursos_dae.asp"))
else
	lenguetas_carga = Array(Array("Asignaturas Malla Curricular", "toma_carga_nuevo.asp"),Array("Formación Profesional", "toma_formacion_profesional.asp"), Array("Optativos Deportivos", "ingreso_optativos.asp"), Array("Cursos Artísticos-Culturales", "ingreso_cursos_dae.asp"))
end if	

if tipo_plan <> "0" then
	suma_creditos = conectar.consultaUno("select protic.obtener_creditos_asignados("&matr_ncorr&")")
end if

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Toma de Carga Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumnos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function ayuda(valor)
{ var mensaje="";
    mensaje = "AYUDA\nLa toma de carga online permite al alumno adelantar este proceso ajustando su carga horaria a los días que más le acomoden. Para ello: \n\n" +
	       	  "- Hacer click en el botón para inscribir carga.\n"+
			  "- Seleccionar carga del plan de estudios,formación profecional electiva y/o carga de optativos deportivos y DAE.\n"+
			  "- Dejar una copia impresa de su horario y carga asignada para el periodo.";
		   
	alert(mensaje);
}
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
				if (confirm("¿Está seguro(a) que desea eliminar la asignatura Artístico-cultural de su carga académica?"))
				{
					document.edicion2.method="post"
					document.edicion2.action="eliminar_optativo.asp";
					document.edicion2.submit();
				}
			}
			else{
				alert('No ha seleccionado ninguna asignatura artístico-cultural a eliminar.');
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
			formulario.action="guardar_curso_dae.asp";
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
function horario(){
	self.open('horario_alumno.asp?matr_ncorr=<%=matr_ncorr%>','horario','width=700px, height=550px, scrollbars=yes, resizable=yes')
}
</script>
<% fbusqueda.generaJS %>
<style type="text/css">
#menu div.barraMenu,
#menu div.barraMenu a.botonMenu {
font-family: sans-serif, Verdana, Arial;
font-size: 8pt;
color: white;
}

#menu div.barraMenu {
text-align: left;
}

#menu div.barraMenu a.botonMenu {
background-color: #4b73a6;
border-bottom-style:double;
border-color:#FFFFFF;
color: white;
cursor: pointer;
padding: 4px 6px 2px 5px;
text-decoration: none;
}

#menu div.barraMenu a.botonMenu:hover {
background-color: #FFFFFF;
color:#4b73a6;
}

#menu div.barraMenu a.botonMenu:active {
background-color: #637D4D;
color: black;
}
 A {color: #000000;  text-decoration: none; font-weight: bold;}
 A:hover {COLOR: #63ABCC; }
</style>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" background="imagenes/fondo.jpg">
<center>
<table align="center" width="700">
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong><%pagina.DibujarTituloPagina%></strong></font></td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="left">
			<table width="700" cellpadding="0" cellspacing="0" border="0" bgcolor="#2b5d02">
				<tr><td bgcolor="#84a6d3">
						<table width="100%" height="90" align="left" cellpadding="0" cellspacing="0" bgcolor="#84a6d3">
						<TR valign="bottom">
							<TD width="75" height="90"><a href="toma_carga_nuevo.asp"><img width="75" height="90" border="0" src="imagenes/LENGUETA1b.png" alt="IR A INGRESO DE ASIGNATURAS DEL PLAN"></a></TD>
							<TD width="75" height="90"><a href="toma_formacion_profesional.asp"><img width="75" height="90" border="0" src="imagenes/LENGUETA2b.png" alt="IR A INGRESO DE FORMACIÓN PROFESIONAL"></a></TD>
							<TD width="75" height="90"><img width="75" height="90" border="0" src="imagenes/LENGUETA3b.png" ></TD>
							<TD width="75" height="90"><a href="ingreso_optativos.asp"><img width="75" height="90" border="0" src="imagenes/LENGUETA4b.png" alt="IR A INGRESO DE ASIGNATURAS DEPORTIVAS"></a></TD>
							<TD height="90">&nbsp;</TD>
						</TR>
						</table>
				    </td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="22%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Asignaturas DAE</strong></font></td>
										   <td width="68%"><hr></td>
										   <TD width="10%">
										   		<%POS_IMAGEN = 4%>
										   		<a href="javascript:ayuda(1)"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda2.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda1.png';return true ">
												<img src="imagenes/ayuda1.png" border="0" width="38" height="38" alt="¿Cómo funciona?"> 
												</a>
											</TD>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<form name="edicion" action="toma_carga_nuevo.asp"> 
									  <tr> 
										<td height="20" width="20%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Rut</strong></font></td>
										<td colspan="3" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%=rut%></font></td>
									  </tr>
									  <tr> 
										<td height="20" width="20%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nombre</strong></font></td>
										<td colspan="3" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%=nombre%></font></td>
									  </tr>
									  <tr> 
										<td height="20" width="20%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Sede</strong></font></td>
										<td colspan="3" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%=v_sede%></font></td>
									  </tr>
									  <tr> 
										<td height="20" width="20%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Carrera</strong></font></td>
										<td colspan="3" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%=carrera%></font></td>
									  </tr>
									  <tr> 
							            <td height="19" width="20%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Jornada</strong></font></td>
										<td colspan="3" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%=v_jornada%></font></td>
									  </tr>
									  <tr>
									  	<td colspan="4">&nbsp;</td>
									  </tr>
									   <tr>
									  	<td colspan="4">&nbsp;</td>
									   </tr>
									   <tr><td colspan="4">
										   <%if sin_definir = false and cantidad_planificada <> "0" then%>
											<table width="100%"  border="0">
											 <tr>
													<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>1.- Seleccione los cursos artístico-culturales que desee cursar en el semestre.</strong></font></td>
											 </tr>
											 <tr>
													<td><input type="hidden" name="matr_ncorr" value="<%=matr_ncorr%>">&nbsp;</td>
											 </tr>
											  <tr>
												<td width="81%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
													  <tr> 
														<td width="9%"> <div align="left"><strong>Curso</strong> 
														</div></td>
														<td width="4%"> <div align="center">:</div> </td>
														<td width="87%"><% response.Write(fbusqueda.nroFilas)
														                   fbusqueda.dibujaCampoLista "lBusqueda", "asig_ccod"%></td>
													  </tr>
													  <tr>
														 <td colspan="3" align="center"><hr></font></td>	
													  </tr>
													  <tr> 
														<td width="9%"> <div align="left"><strong>Horario</strong></div></td>
														<td width="4%"> <div align="center">:</div> </td>
														<td width="87%"><% fbusqueda.dibujaCampoLista "lBusqueda", "secc_ccod"%></td>
													  </tr>
													  <tr>
													  	<td colspan="3">&nbsp;</td>
													  </tr>
													  <%if cint(suma_creditos) < 27 then %>
													  <tr> 
														<td colspan="3" align="center">
															    <%POS_IMAGEN = POS_IMAGEN + 1%>
																<a href="javascript:_Guardar(this, document.forms['edicion'], 'guardar_curso_dae.asp','', 'validar()', '', 'TRUE');"
																	onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/GUARDAR2.png';return true "
																	onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/GUARDAR1.png';return true ">
																	<img src="imagenes/GUARDAR1.png" border="0" width="70" height="70" alt="AGREGAR OPTATIVO ARTÍSTICO/CULTURAL"> 
																</a>
														</td>
													  </tr>
													  <%end if%>
													  <tr>
														 <td colspan="3" align="center">&nbsp;</font></td>	
													  </tr>
													  <%if tipo_plan <> "0" and cint(suma_creditos) >= 27 then%>
														<tr>
														   <td colspan="4" align="center"><font  size="2" color="#496da6"><strong>Atención el total de Cr&eacute;ditos Asignados (<%=suma_creditos%>) esta fuera del rango permitido (9-27).<br> Elimine parte de la carga para tomar el curso Artistico-Cultural.</strong></font>
														   </td>
														</tr>
													  <%end if%>
													</table></td>
												</tr>
											</table>
											<%end if%>
										  </td>
									  </tr>
									  </form>
									  <tr>
									  	<td colspan="4">&nbsp;</td>
									  </tr>
									  <tr>
									  	<td colspan="4" align="center">
											<%if sin_definir = false then%>
											<form name="edicion2">
											  <input type="hidden" name="matr_ncorr" value="<%=matr_ncorr%>">
													<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
													  <tr>
															<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>2.- Listado de cursos Artístico-Culturales, que ya pertenecen a su carga académica.</strong></font>
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
													  <% if optativos_deportivos.NroFilas > 0 then%>
													  <tr>
														<td align="center">
														    <%POS_IMAGEN = POS_IMAGEN + 1%>
															<a href="javascript:eliminar_optativo(document.edicion_optativo);"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ELIMINAR2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ELIMINAR1.png';return true ">
																<img src="imagenes/ELIMINAR1.png" border="0" width="70" height="70" alt="QUITAR ASIGNATURAS DE LA CARGA ASIGNADA"> 
															</a>
														</td>
													  </tr>
													  <%end if%>
												</table>
												<br>
												</form>
												<%end if%>
												<%if sin_definir = true then%>
												<table width="98%"  border="1" align="center" cellpadding="0" cellspacing="0">
													  <tr>
														<td align="center"><font size="+1" color="#0033CC"><strong>Aún no se ha definido por completo esta función.</strong></font></td>
													  </tr>
													  </table>
													  <br>
													  <br>
												<%end if%>
										</td>
									  </tr>
									  <tr>
									  	<td colspan="4"><hr style="border-top: 1px solid #496da6;"/></td>
									  </tr>
									  <tr>
									  	<td>&nbsp;</td>
										<td align="right">
											               <%POS_IMAGEN = POS_IMAGEN + 1%>
															<a href="inicio_toma_carga_2008.asp"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
																<img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER A PÁGINA PRINCIPAL"> 
															</a>
										</td>
										<td align="left"><%POS_IMAGEN = POS_IMAGEN + 1%>
															<a href="javascript:horario();"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/HORARIO2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/HORARIO1.png';return true ">
																<img src="imagenes/HORARIO1.png" border="0" width="70" height="70" alt="IMPRIMIR HORARIO DE CLASES"> 
															</a></td>
										<td>&nbsp;</td>
									  </tr>  
								  </table>
                  
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>
		</td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
</table>
</center>
</body>
</html>


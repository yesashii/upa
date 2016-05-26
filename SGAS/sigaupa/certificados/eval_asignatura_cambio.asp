<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set botonera =  new CFormulario
botonera.carga_parametros "eval_asignaturas.xml", "btn_eval_asignaturas"


secc_ccod= request.QueryString("secc_ccod")

if secc_ccod <> "" then
	session("secc_ccod_trabajo")= secc_ccod
else
	secc_ccod = session("secc_ccod_trabajo")
end if

asig_tdesc=request.QueryString("m[0][secc_ccod]")

set conectar = new cConexion
set negocio = new cnegocio
set formevalasignatura = new cformulario
set formevalasignaturaN = new cformulario

conectar.inicializar "upacifico"
negocio.inicializa conectar
sede = negocio.obtenerSede
carrera= conectar.consultaUno("Select carr_tdesc from secciones a, carreras b where a.carr_ccod=b.carr_ccod and cast(a.secc_ccod as varchar)='"&secc_ccod&"'")

formevalasignatura.carga_parametros "eval_asignaturas.xml","tabla"
formevalasignaturaN.carga_parametros "eval_asignaturas.xml","tablaN"

formevalasignatura.inicializar conectar
formevalasignaturaN.inicializar conectar
periodo= conectar.consultaUno("Select peri_ccod from secciones  where cast(secc_ccod as varchar)='"&secc_ccod&"'")
'primer_periodo= negocio.ObtenerPeriodoAcademico("CLASES18")

PerSel= conectar.consultaUno("Select peri_tdesc from secciones a, periodos_academicos b where a.peri_ccod=b.peri_ccod and cast(a.secc_ccod as varchar)='"&secc_ccod&"'")

Sql="select c.pers_ncorr from secciones a, bloques_horarios b, bloques_profesores c where a.secc_ccod=b.secc_ccod and b.bloq_ccod=c.bloq_ccod and c.tpro_ccod=1  and cast(a.secc_ccod as varchar)='"&secc_ccod&"'"
pers_ncorr=conectar.consultaUno(Sql)


asignaturas=" select distinct a.sede_ccod,e.asig_ccod,e.asig_tdesc, a.pers_ncorr from  " & _
			" profesores a, bloques_profesores b, " & _
			" bloques_horarios c,secciones d, asignaturas e " & _
			" where a.pers_ncorr =  b.pers_ncorr  " & _
			" and a.sede_ccod = b.sede_ccod " & _
			" and b.bloq_ccod = c.bloq_ccod  " & _
			" and c.secc_ccod = d.secc_ccod " & _
			" and d.asig_ccod = e.asig_ccod  " & _
			" and cast(d.peri_ccod as varchar)= '"&periodo&"'" & _
			" and cast(a.pers_ncorr as varchar)= '"&pers_ncorr&"' " 
			


conectar.Ejecuta asignaturas

set rec_asignaturas = conectar.ObtenerRS

Secciones =" select distinct a.pers_ncorr,d.sede_ccod, " & _
			" d.secc_ccod,d.secc_tdesc, " & _
			" e.asig_ccod,e.asig_tdesc, d.secc_tdesc+ ' - ' + isnull(f.carr_tsigla,'-')+ ' '+ case d.jorn_ccod when 1 then '(D)' when 2 then '(V)' else '' end as descripcion " & _
			" from " & _
			" profesores a, bloques_profesores b, " & _
			" bloques_horarios c,secciones d,asignaturas e, carreras f " & _
			" where a.pers_ncorr = b.pers_ncorr " & _
			" and a.sede_ccod = b.sede_ccod " & _
			" and b.bloq_ccod = c.bloq_ccod " & _
			" and c.secc_ccod = d.secc_ccod " & _
			" and d.asig_ccod = e.asig_ccod " & _
			" and d.carr_ccod = f.carr_ccod " & _
			" and cast(d.peri_ccod as varchar)= '"&periodo&"' " & _
			" and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' " 



conectar.Ejecuta Secciones
set rec_secciones = conectar.ObtenerRS
	pruebas="select a.cali_ncorr, a.secc_ccod, a.teva_ccod, a.cali_nevaluacion, a.cali_nevaluacion as c_cali_nevaluacion, replace(cali_nponderacion,',','.') as cali_nponderacion, " & vbCrLf &_
      		" convert(varchar,cali_fevaluacion,103) as cali_fevaluacion, b.teva_tdesc, " & vbCrLf &_
			" count(d.cali_ncorr) as nnotas_ant, sum(case when e.emat_ccod = 1 then 1 else 0 end) as nnotas " & vbCrLf &_
			" from 	" & vbCrLf &_
			" calificaciones_seccion a join tipos_evaluacion b" & vbCrLf &_
			"    on a.teva_ccod = b.teva_ccod " & vbCrLf &_
			" join secciones c" & vbCrLf &_
			"    on a.secc_ccod = c.secc_ccod " & vbCrLf &_
			" left outer join calificaciones_alumnos d" & vbCrLf &_
			"    on a.cali_ncorr = d.cali_ncorr" & vbCrLf &_
			" left outer join  alumnos e  " & vbCrLf &_
			"    on  d.matr_ncorr = e.matr_ncorr  and  e.emat_ccod  = 1" & vbCrLf &_
			" where  cast(c.peri_ccod as varchar)= '" & periodo & "'" & vbCrLf &_
			" and cast(a.secc_ccod as varchar)= '" & secc_ccod & "' " & vbCrLf &_
			" group by a.cali_ncorr, a.secc_ccod, a.teva_ccod, a.cali_nevaluacion, cali_nponderacion, " & vbCrLf &_
			" convert(varchar,cali_fevaluacion, 103), b.teva_tdesc "

registros = conectar.consultauno("select count(*) from ("&pruebas&")s")
		
formevalasignatura.consultar pruebas
pruebaN=" select a.cali_ncorr,a.secc_ccod,a.teva_ccod, a.cali_nevaluacion,cali_nponderacion,convert(datetime,cali_fevaluacion,103) as cali_fevaluacion, " & _
	   	" b.teva_tdesc " & _
 		" from calificaciones_seccion a, tipos_evaluacion b " & _
		" where a.teva_ccod=b.teva_ccod " & _
		" and cast(a.secc_ccod as varchar)='"&secc_ccod&"' "   & _
		" and a.teva_ccod='N'" & _
		" order by a.cali_nevaluacion"
formevalasignaturaN.consultar pruebaN
RegistrosN=formevalasignaturaN.NroFilas
set f_asignatura = new CFormulario
f_asignatura.Carga_Parametros "agregar_evaluacion.xml", "f_datos_asignaturas"
f_asignatura.Inicializar conectar
dotos_asignatura=   " select a.asig_ccod,a.secc_tdesc + ' - ' + isnull(e.carr_tsigla,'-') + ' ' + case a.jorn_ccod when 1 then '(DIURNA)' when 2 then '(VESPERTINA)' else '' end as secc_tdesc,d.tasg_tdesc," & _
	                " b.asig_tdesc,b.asig_nhoras,c.sede_tdesc " & _
					" from secciones a,asignaturas b, sedes c,tipos_asignatura d, carreras e" & _
					" where  a.asig_ccod=b.asig_ccod and" & _
					"	     a.sede_ccod=c.sede_ccod and " & _
					"        a.carr_ccod = e.carr_ccod and " &_
					"	     isnull(a.tasg_ccod,b.tasg_ccod)=d.tasg_ccod and    " & _					
					"	     cast(a.secc_ccod as varchar)='"&secc_ccod&"' " & _
					" and cast(a.peri_ccod as varchar)='"&periodo&"'"
		
f_asignatura.Consultar dotos_asignatura
f_asignatura.Siguiente
'response.Write(dotos_asignatura)
nombre=conectar.consultauno("select pers_tnombre +' '+ pers_tape_paterno +' '+ pers_tape_materno from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")

'asignatura cerrada-----------------
asig_cerrada = conectar.consultaUno("select isnull(estado_cierre_ccod,1) from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")

if secc_ccod <> "" then
	jorn_ccod = conectar.consultaUno("select jorn_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
end if
'response.Write(sys_cierra_notas)

lenguetas_evaluacion = Array(Array("Cambio de Evaluaciones", "eval_asignatura_cambio.asp"), Array("Cambio Notas Parciales", "notas_parciales.asp"), Array("Cambio Nota Final", "notas_finales.asp"))

'response.Write(secc_ccod)
if pers_ncorr <> "" then
	total_alumnos = conectar.consultaUno("select count(*) from cargas_Academicas where cast(secc_ccod as varchar)='"&secc_ccod&"'")
	consulta_terminados = conectar.consultaUno("select count(*) from cargas_Academicas where isnull(sitf_ccod,'1')<> '1' and isnull(cast(carg_nnota_final as varchar),'N') <> 'N' and cast(secc_ccod as varchar)='"&secc_ccod&"'")
else
    total_alumnos = "1"
	consulta_terminados = "2"
end if
'response.Write("total "&total_alumnos &" terminados "&consulta_terminados)
'Para corrección por parte de Viviana Sandoval y en respuesta a solicitud de MTMerino el día 08-01-2013
	total_alumnos = "1"
	consulta_terminados = "2"
'--------Fin-------------------------------------------------------------------------------------------
%>


<html>
<head>
<title>Evaluación De Asignaturas</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
rec_asignaturas = new Array();

<%
if (rec_asignaturas.BOF <> rec_asignaturas.EOF) then

rec_asignaturas.MoveFirst
i = 0
while not rec_asignaturas.Eof
%>
rec_asignaturas[<%=i%>] = new Array();
rec_asignaturas[<%=i%>]["pers_ncorr"] = '<%=rec_asignaturas("pers_ncorr")%>';
rec_asignaturas[<%=i%>]["asig_ccod"] = '<%=rec_asignaturas("asig_ccod")%>';
rec_asignaturas[<%=i%>]["asig_tdesc"] = '<%=rec_asignaturas("asig_tdesc")%>';
rec_asignaturas[<%=i%>]["sede_ccod"] = '<%=rec_asignaturas("sede_ccod")%>';

<%	
	rec_asignaturas.MoveNext
	i = i + 1
wend
end if
%>


rec_secciones = new Array();
<%

if (rec_secciones.BOF <> rec_secciones.EOF) then
rec_secciones.MoveFirst
j = 0
while not rec_secciones.Eof
%>
rec_secciones[<%=j%>] = new Array();
rec_secciones[<%=j%>]["pers_ncorr"] = '<%=rec_secciones("pers_ncorr")%>';
rec_secciones[<%=j%>]["asig_ccod"] = '<%=rec_secciones("asig_ccod")%>';
rec_secciones[<%=j%>]["asig_tdesc"] = '<%=rec_secciones("asig_tdesc")%>';
rec_secciones[<%=j%>]["sede_ccod"] = '<%=rec_secciones("sede_ccod")%>';
rec_secciones[<%=j%>]["secc_tdesc"] = '<%=rec_secciones("secc_tdesc")%>';
rec_secciones[<%=j%>]["secc_ccod"] = '<%=rec_secciones("secc_ccod")%>';
rec_secciones[<%=j%>]["descripcion"] = '<%=rec_secciones("descripcion")%>';
<%	
	rec_secciones.MoveNext
	j = j + 1
wend
end if
%>

function CargarAsignaturas(formulario, profesor_sede)
{
 var cadena, pers_ncorr, sede_ccod
 cadena=profesor_sede.split(" ");
 pers_ncorr=cadena[0];
 sede_ccod=cadena[1];

	formulario.elements["m[0][secc_ccod]"].length = 0;
	
	op = document.createElement("OPTION");
	op.value = "-1";
	op.text = "-- Seleccione Una Asignaturas --";
	formulario.elements["m[0][secc_ccod]"].add(op)
	
	for (i = 0; i < rec_asignaturas.length; i++) {
		if ((rec_asignaturas[i]["pers_ncorr"] == pers_ncorr) && (rec_asignaturas[i]["sede_ccod"] == sede_ccod)) {
			op = document.createElement("OPTION");
			op.value = rec_asignaturas[i]["asig_ccod"];
			op.text = rec_asignaturas[i]["asig_ccod"]+"-"+rec_asignaturas[i]["asig_tdesc"];
			formulario.elements["m[0][secc_ccod]"].add(op)
			
		}
	}	
}

var t_evaluaciones;

function InicioPagina(formulario)
{
	t_evaluaciones = new CTabla("em");
/*formulario = document.busqueda;*/
a="<%=asig_tdesc%>"
if (a !="")
{
CargarAsignaturas(formulario, formulario.elements["m[0][sede_ccod]"].value)
formulario.elements["m[0][secc_ccod]"].value = "<%=asig_tdesc%>";

CargarSecciones(formulario,formulario.elements["m[0][secc_ccod]"].value)
formulario.elements["m[0][secc_tdesc]"].value = "<%=secc_ccod%>";
sec=formulario.elements["m[0][secc_tdesc]"].value;
}
	
}

function CargarSecciones(formulario,asig_ccod){
var cadena,cadena2, pers_ncorr, sede_ccod
 cadena= formulario.elements["m[0][sede_ccod]"].value.split(" ");
 cadena2=asig_ccod.split(" ");
 pers_ncorr=cadena[0];
 sede_ccod=cadena[1];
asig=cadena2[0];
asig_ccod=formulario.elements["m[0][secc_ccod]"].value

	formulario.elements["m[0][secc_tdesc]"].length = 0;
	
	op2 = document.createElement("OPTION");
	op2.value = "-1";
	op2.text = "-- Secciones --";
	formulario.elements["m[0][secc_tdesc]"].add(op2)
	
	
	for (i = 0; i < rec_secciones.length; i++) {
		if ((rec_secciones[i]["pers_ncorr"] == pers_ncorr) && (rec_secciones[i]["sede_ccod"] == sede_ccod) && (rec_secciones[i]["asig_ccod"]== asig_ccod)) {
			op2 = document.createElement("OPTION");
			op2.value = rec_secciones[i]["secc_ccod"];
			op2.text = rec_secciones[i]["descripcion"];
			formulario.elements["m[0][secc_tdesc]"].add(op2)
			
		}
	}
}

function ValidarBusqueda(formulario){
	if (formulario.elements["m[0][sede_ccod]"].value == "") {
		alert('Seleccione una Sede.');
		formulario.elements["m[0][sede_ccod]"].focus();
		return false ;
	}
	if (formulario.elements["m[0][secc_ccod]"].value == "-1") {
		alert('Seleccione una Asignatura.');
		formulario.elements["m[0][secc_ccod]"].focus();
		return false;
	}
	
	if (formulario.elements["m[0][secc_tdesc]"].value == "-1") {
		alert('Seleccione una Sección.');
		formulario.elements["m[0][secc_tdesc]"].focus();
		return false ;
	}
	return true;
 }

function enviar(formulario){
	/*var pers_ncorr,sede_ccod,asig_ccod,secc_ccod,cadena*/
  	if(ValidarBusqueda(formulario)){
	  formulario.action = 'eval_asignatura.asp'
   	  formulario.submit();}
 }

function cambiarperiodo(formulario){
	  
	   formulario.action = 'matar_sesion.asp'
   	   formulario.submit();
}

function ProcEliminar(formulario)
{
	
	formulario.method="post";
	formulario.target="_self";
	formulario.action = 'eliminar_eval.asp';
	formulario.submit();
	
}


function eliminar(formulario)
{
	var nseleccionados = t_evaluaciones.CuentaSeleccionados("cali_ncorr");
	var str_alerta = "";
	var bnotas = false;
	var str_mensaje;
	
	if (nseleccionados > 0) {
		//if (nseleccionados == 1) {			
			
			for (var i = 0; i < t_evaluaciones.filas.length; i++) {
				
				if ( (t_evaluaciones.filas[i].campos["cali_ncorr"].objeto.checked) && (parseInt(t_evaluaciones.ObtenerValor(i, "nnotas")) > 0) ) {
					str_alerta = str_alerta + "Evaluación Nº " + t_evaluaciones.ObtenerValor(i, "c_cali_nevaluacion") + " : " + t_evaluaciones.ObtenerValor(i, "nnotas") + " alumnos con nota.\n";
					bnotas = true;						
				}				
			}
			
			if (bnotas)
				str_mensaje = "Las siguientes evaluaciones tienen notas puestas. Si las elimina, también eliminará las notas asociadas a ellas.\n\n" + str_alerta + "\n¿Desea continuar?";
			else 
				str_mensaje = "¿Está seguro que desea eliminar las evaluaciones seleccionadas?";
			
			if (confirm(str_mensaje))
				ProcEliminar(formulario);
			
		/*}
		else {
			alert('No puede seleccionar más de una evaluación para eliminar.');
		}*/
	}
	else {
		alert('No ha seleccionado una evaluación para eliminar.');
	}	

}

function eliminar_(formulario){
	if (vcheck_eliminar(formulario)==1){
		formulario.method="post";
		formulario.target="_self"
		formulario.action = 'eliminar_eval.asp'
		formulario.submit();
	}
	else {
		if (vcheck_eliminar(formulario)==0){
			alert('No ha seleccionado una evaluación para eliminar');
		}
		else {
			alert('No puede seleccionar más de una evaluación para eliminar');
		}
	}
}

function vcheck_eliminar(formulario) {
	num=formulario.elements.length;
	c=0;
	for (i=0;i<num;i++){
		//alert(formulario.elements[i].name);
		nombre = formulario.elements[i].name;
		var elem = new RegExp ("cali_ncorr","gi");
		if (elem.test(nombre)){
			if((formulario.elements[i].checked==true)){
				c=c+1;
			}
		}
	}
	if (c==1){
		valor=1;
	}
	else {
		if (c==0){
			valor=0;
		}
		else{
			valor=2;
		}
	}
return(valor);	
}

function agregar(formulario){
//if(ValidarBusqueda(formulario)){
	 direccion="agregar_evaluacion.asp?secc_ccod="+"<%=secc_ccod%>";
     resultado=window.open(direccion, "ventana1","width=600,height=400,scrollbars=yes, left=0, top=0");
//	}
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
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="InicioPagina(document.busqueda);MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../__base/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
                  <%				
				pagina.DibujarLenguetas lenguetas_evaluacion, 1
				%>
                </td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center">
                    <p align="left"> 
                      <% if secc_ccod <>"" then %>
					  <table width="60%" border="0">
						  <tr>
							  <td colspan="3">&nbsp;</td>
						  </tr>
						  <tr>
							  <td width="25%" align="left"><strong>Sede</strong></td>
							  <td width="1%" align="left"><strong>:</strong></td>
							  <td align="left"><%=f_asignatura.obtenervalor("sede_tdesc")%></td>
						  </tr>
						  <tr>
							  <td width="25%" align="left"><strong>Carrera</strong></td>
							  <td width="1%" align="left"><strong>:</strong></td>
							  <td align="left"><%=carrera%></td>
						  </tr>
						  <tr>
							  <td width="25%" align="left"><strong>Asignatura</strong></td>
							  <td width="1%" align="left"><strong>:</strong></td>
							  <td align="left"><%=f_asignatura.obtenervalor("asig_ccod")%> &nbsp; <%=f_asignatura.obtenervalor("asig_tdesc")%></td>
						  </tr>
						  <tr>
							  <td width="25%" align="left"><strong>Tipo Asignatura</strong></td>
							  <td width="1%" align="left"><strong>:</strong></td>
							  <td align="left"><%=f_asignatura.obtenervalor("tasg_tdesc")%></td>
						  </tr>
						  <tr>
							  <td width="25%" align="left"><strong>Asignatura</strong></td>
							  <td width="1%" align="left"><strong>:</strong></td>
							  <td align="left"><%=f_asignatura.obtenervalor("secc_tdesc")%></td>
						  </tr>
					  </table>
                    <%end if %>
                    </p>
                    <form action="" method="post" name="edicion" target="_blank" id="edicion">
                      <div align="left">
                        <input name="url" type="hidden" value="<%=request.ServerVariables("HTTP_REFERER")%>">
                      </div>
                      <table width="98%" border="0" align="center" cellpadding="5" cellspacing="0" >
				    <tr> 
                          <td align="center">&nbsp; 
                            <%formevalasignatura.dibujatabla()%>
                            <input type="hidden" name="registros" value="<%=registros%>"> 
                          </td>
                        </tr>
                      </table>
                    </form>
                    <br>Para editar una evaluación debe hacer click sobre el registro a editar
                    <p><br>
                    </p>
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
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                            <% if cint(total_alumnos) = cint(consulta_terminados) and secc_ccod <> "40847" then
							     botonera.agregaBotonParam "agregar","deshabilitado","TRUE"
							   end if
							   botonera.dibujaboton "agregar"%>
                          </div></td>
                  <td><div align="center">
                            <% if cint(total_alumnos) = cint(consulta_terminados)  and secc_ccod <> "40847" then
							   	 botonera.agregaBotonParam "eliminar","deshabilitado","TRUE"
							   end if
							   botonera.dibujaboton "eliminar"%>
                          </div></td>
                  <td><div align="center">
                            <%botonera.dibujaboton "salir"%>
                          </div></td>
                </tr>
              </table>
            </div></td>
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

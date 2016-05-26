<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set botonera =  new CFormulario
botonera.carga_parametros "fotos_alumnos_seccion.xml", "btn_eval_asignaturas"


secc_ccod= request.QueryString("m[0][secc_tdesc]")
asig_tdesc=request.QueryString("m[0][secc_ccod]")


set conectar = new cConexion
set negocio = new cnegocio

conectar.inicializar "upacifico"
negocio.inicializa conectar


set formbusqueda = new cformulario
set formsecciones = new cformulario
set formprofesores = new cformulario



sede = negocio.obtenerSede
carrera= conectar.consultaUno("Select carr_tdesc from secciones a, carreras b where a.carr_ccod=b.carr_ccod and cast(a.secc_ccod as varchar)='"&secc_ccod&"'")
set errores = new CErrores

formbusqueda.carga_parametros "fotos_alumnos_seccion.xml", "busqueda"
formsecciones.carga_parametros "fotos_alumnos_seccion.xml", "secciones"
formprofesores.carga_parametros "fotos_alumnos_seccion.xml", "profesores"


formbusqueda.inicializar conectar
formsecciones.inicializar conectar 
formprofesores.inicializar conectar
periodo= negocio.ObtenerPeriodoAcademico("PLANIFICACION")
'primer_periodo= negocio.ObtenerPeriodoAcademico("CLASES18")
		
PerSel=conectar.consultauno("select peri_tdesc  from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")


Sql="select pers_ncorr from personas where cast(pers_nrut as varchar)='"&negocio.obtenerUsuario&"'"
pers_ncorr=conectar.consultaUno(Sql)

sedeprofesor=   " select distinct  cast(a.pers_ncorr as varchar)+' '+cast(a.sede_ccod as varchar)+' '+ e.sede_tdesc as profesor_sede, "& _
				" e.sede_tdesc as sede,d.peri_ccod  "& _
				" from profesores a,bloques_profesores b, "& _
				" bloques_horarios c,secciones d, sedes e "& _
				" where a.pers_ncorr = b.pers_ncorr "& _
				" and a.sede_ccod = b.sede_ccod " & _
				" and b.bloq_ccod = c.bloq_ccod "& _
				" and c.secc_ccod = d.secc_ccod "& _
				" and a.sede_ccod = e.sede_ccod "& _
				" and cast(d.peri_ccod as varchar)='"&periodo&"' "& _
				" and   cast(b.pers_ncorr as varchar)= '"&pers_ncorr&"' " 


consprofesor = "select '"&request.QueryString("m[0][sede_ccod]")&"' as sede_ccod"

formprofesores.consultar consprofesor
formprofesores.agregacampoparam "sede_ccod","destino","("& sedeprofesor &") aa"   
formprofesores.siguiente

consulta="select '"&request.QueryString("m[0][secc_ccod]")&"' as secc_ccod"
formbusqueda.consultar consulta
formbusqueda.agregacampocons	"secc_ccod", asig_tdesc
formbusqueda.siguiente

consulta2="select '"&request.QueryString("m[0][secc_tdesc]")&"' as secc_tdesc"
formsecciones.consultar consulta2
formsecciones.siguiente

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


sede = conectar.consultaUno("select sede_tdesc from secciones a, sedes b where a.sede_ccod=b.sede_ccod and cast(secc_Ccod as varchar)='"&secc_ccod&"'")
carrera = conectar.consultaUno("select carr_tdesc from secciones a, carreras b where a.carr_ccod=b.carr_ccod and cast(secc_Ccod as varchar)='"&secc_ccod&"'")
jornada = conectar.consultaUno("select jorn_tdesc from secciones a, jornadas b where a.jorn_ccod=b.jorn_ccod and cast(secc_Ccod as varchar)='"&secc_ccod&"'")
asignatura = conectar.consultaUno("select ltrim(rtrim(b.asig_ccod))+' -- ' + asig_tdesc from secciones a, asignaturas b where a.asig_ccod=b.asig_ccod and cast(secc_ccod as varchar)='"&secc_ccod&"'")
seccion = conectar.consultaUno("select secc_tdesc from secciones  where cast(secc_Ccod as varchar)='"&secc_ccod&"'")
periodo_asignatura = conectar.consultaUno("select peri_tdesc from secciones a,periodos_academicos b where cast(secc_Ccod as varchar)='"&secc_ccod&"' and a.peri_ccod=b.peri_ccod")


set tabla_personas = new CFormulario
tabla_personas.Carga_Parametros "tabla_vacia.xml", "tabla"
tabla_personas.Inicializar conectar
nomina_seccion = " select a.matr_ncorr,a.secc_ccod,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbCrLf &_
				 " protic.initCap(protic.initcap(substring(pers_tnombre,0, case charindex(' ' ,pers_tnombre) when 0 then 20 else charindex(' ' ,pers_tnombre) end  )) ) as nombre,protic.initCap(c.pers_tape_paterno) as apellido, "& vbCrLf &_
				 " a.sitf_ccod as estado_final, a.carg_nnota_final as promedio_final, "& vbCrLf &_
				 " isnull(isnull((Select top 1 ltrim(rtrim(imagen)) from rut_fotos_2010 tt where tt.rut = c.pers_nrut), "& vbCrLf &_
				 "       (Select top 1 ltrim(rtrim(foto_truta)) from fotos_alumnos tr where tr.pers_nrut= c.pers_nrut)), "& vbCrLf &_
				 "       case c.sexo_ccod when 2 then 'mujer.png' else 'hombre.png' end ) as foto, "& vbCrLf &_
				 " pers_tape_paterno + ' ' + pers_tape_materno + ' ' + pers_tnombre as nombres_alfabeticos         "& vbCrLf &_
				 " from cargas_academicas a (nolock), alumnos b (nolock), personas c (nolock) "& vbCrLf &_
				 " where cast(a.secc_ccod as varchar)='"&secc_ccod&"' "& vbCrLf &_
				 " and a.matr_ncorr=b.matr_ncorr  "& vbCrLf &_
				 " and b.pers_ncorr=c.pers_ncorr "& vbCrLf &_
				 " order by nombres_alfabeticos "
				 
'response.Write("<pre>"&consulta_postulacion&"</pre>")
tabla_personas.Consultar nomina_seccion

%>


<html>
<head>
<title>Galería de alumnos</title>
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
	  formulario.action = 'fotos_alumnos_seccion.asp'
   	  formulario.submit();}
 }

function cambiarperiodo(formulario){
	  
	   formulario.action = 'matar_sesion.asp'
   	   formulario.submit();
}

function ProcEliminar(formulario)
{
	//alert('ok');
	
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


function grabar_pocentaje(formulario)
{
	var porcentaje = formulario.elements["secc_porce_asiste"].value;
	if (!isNaN(porcentaje) )
	{
		if ((porcentaje >= 0 )&&(porcentaje <= 100))
		{
			formulario.method="post";
			formulario.target="_self";
			formulario.action = 'grabar_porcentaje_proc.asp';
			formulario.submit();
		}
		else
		{
			alert("El valor ingresado no corresponde a un número de porcentaje válido (0-100), el simbolo (%) debe omitirlo");
			formulario.elements["secc_porce_asiste"].value="";
			formulario.elements["secc_porce_asiste"].focus();
		}	
	}
	else
	{
		alert("El valor ingresado no corresponde a un número de porcentaje válido (0-100), el simbolo (%) debe omitirlo");
		formulario.elements["secc_porce_asiste"].value="";
		formulario.elements["secc_porce_asiste"].focus();
	}	
}

function aviso_email()
{
	 var seccion = '<%=secc_ccod%>';
	 if (seccion == '')
	 {
	   direccion="aviso_nuevo_email.asp";
       resultado=window.open(direccion, "ventana_aviso","width=380,height=559,scrollbars=no, left=0, top=0");
	 }  
}

function abrir_datos(matricula,seccion)
{
    direccion = "fotos_alumnos_seccion_detalle.asp?matr_ncorr="+matricula+"&secc_ccod="+seccion;
    resultado = window.open(direccion, "ventana_aviso","width=440,height=360,scrollbars=no, left=0, top=0");
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
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Búsqueda de Asignaturas"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
			<form action="" method="get" name="busqueda" id="busqueda">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center"> 
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="24%" align="left"> <font face="Verdana, Arial, Helvetica, sans-serif" size="1">Sede 
                                  <br>
                                  <%formprofesores.dibujacampo("sede_ccod")%>
                                  </font></td>
                                <td width="57%" align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">&nbsp; 
                                  </font> <font face="Verdana, Arial, Helvetica, sans-serif" size="1">&nbsp; 
                                  </font><font face="Verdana, Arial, Helvetica, sans-serif" size="1">&nbsp; 
                                  Asignaturas<br>
                                  <%formbusqueda.dibujacampo("secc_ccod")%>
                                  </font></td>
                                <td width="19%" align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Secci&oacute;n<br>
                                  <%formsecciones.dibujacampo("secc_tdesc")%>
                                  </font></td>
                              </tr>
                            </table>
                          </div></td>
                  
                </tr><input name="sesi_ccod" type="hidden" value="<%=id_sesion%>">
              </table>
             <table width="98%" border="0">
                            <tr> 
                              <td>*PARA VER UN CURSO SELECCIONE LOS PARAMETROS 
                                DE B&Uacute;SQUEDA Y PRESIONE EL BOTON <em><strong>&quot;BUSCAR&quot;</strong></em></td>
                            </tr>
							<tr> 
                            <td align="right"><%botonera.dibujaboton "buscar"%></td>
                            </tr>
                  </table>
        
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	<br>
	<%if secc_ccod <> "" then%>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
                <td>
                  <%pagina.DibujarLenguetas Array("Alumnos"), 1 %>
                </td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
		  <tr>
            <td align="left">
				<table width="100%" align="left" cellpadding="0" cellspacing="0">
					<tr><td colspan="3">&nbsp;</td></tr>
					<tr>
						<td width="19%" align="left"><strong>Sede</strong></td>
						<td width="1%" align="left"><strong>:</strong></td>
						<td width="80%" align="left"><%=sede%></td>
					</tr>
					<tr>
						<td width="19%" align="left"><strong>Carrera</strong></td>
						<td width="1%" align="left"><strong>:</strong></td>
						<td width="80%" align="left"><%=carrera%></td>
					</tr>
					<tr>
						<td width="19%" align="left"><strong>Jornada</strong></td>
						<td width="1%" align="left"><strong>:</strong></td>
						<td width="80%" align="left"><%=jornada%></td>
					</tr>
					<tr>
						<td width="19%" align="left"><strong>Asignatura</strong></td>
						<td width="1%" align="left"><strong>:</strong></td>
						<td width="80%" align="left"><%=asignatura%></td>
					</tr>
					<tr>
						<td width="19%" align="left"><strong>Sección</strong></td>
						<td width="1%" align="left"><strong>:</strong></td>
						<td width="80%" align="left"><%=seccion%></td>
					</tr>
					<tr>
						<td width="19%" align="left"><strong>Período</strong></td>
						<td width="1%" align="left"><strong>:</strong></td>
						<td width="80%" align="left"><%=periodo_asignatura%></td>
					</tr>
					<tr><td colspan="3">&nbsp;</td></tr>
					<tr>
					  <td colspan="3">
						 <table width="651" align="center" cellpadding="0" cellspacing="0">
						  <tr valign="top">
						    <%columna = 1
							  while tabla_personas.siguiente 
							    rut = tabla_personas.obtenerValor("rut")
								nombre = tabla_personas.obtenerValor("nombre")
								apellido = tabla_personas.obtenerValor("apellido")
								estado_final = tabla_personas.obtenerValor("estado_final")
								promedio_final = tabla_personas.obtenerValor("promedio_final")
								foto = tabla_personas.obtenerValor("foto")
								generico = rut&": "&nombre&" "&apellido&" ("&promedio_final&" - "&estado_final&")"
								matr = tabla_personas.obtenerValor("matr_ncorr")
								secc = tabla_personas.obtenerValor("secc_ccod")
								
								if columna > 7 then
								   columna = 1
								   %>
								 </tr>
								 <tr valign="top">
								<%end if%> 
								<td width="93" align="center">
								   <table width="100%" cellpadding="0" cellspacing="0" align="center">
										<tr>
											<td width="100%" height="98" align="center"><a href="javascript:abrir_datos(<%=matr%>,<%=secc%>)"><img width="90" height="98" src="../informacion_alumno_2008b/imagenes/alumnos/<%=foto%>" border="0" title="<%=generico%>"></a></td>
										</tr>
										<tr>
											<td width="100%" align="center"><font size="-1"><%=nombre&"<br>"&apellido%></font></td>
										</tr>
								   </table>
								</td>
								<%columna = columna + 1%>
						    <%wend%>
							 <%if columna - 1 < 7 then %>
							 	<td colspan="<%=7 - (columna-1)%>">&nbsp;</td>
							 <%end if%>
						  </tr>
						 </table>
					  </td>
					</tr>
					<tr><td colspan="3">&nbsp;</td></tr>
				</table>
			</td>
          </tr>
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
                            <%botonera.dibujaboton "salir"%>
                          </div></td>
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
	<%end if%>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>

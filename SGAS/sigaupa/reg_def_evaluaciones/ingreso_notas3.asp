<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Ingreso Notas"
set botonera =  new CFormulario
botonera.carga_parametros "notas.xml", "btn_ingreso_notas"
'for each k in request.querystring
'	response.Write(k&" = "&request.querystring(k)&"<br>")
'next

'sesi_ccod =	request.QueryString("sesi_ccod")
cali_ncorr = request.QueryString("not[0][cali_ncorr]")
secc_ccod = request.QueryString("not[0][secc_tdesc]")
asig_tdesc = request.QueryString("not[0][secc_ccod]")

'response.Write("sesi_ccod"&sesi_ccod&"<br>")
'response.Write("cali_ncorr"&cali_ncorr&"<br>")
'response.Write("secc_ccod"&secc_ccod&"<br>")
'response.Write("asig_tdesc"&asig_tdesc&"<br>")

set conectar				=	new cconexion
set negocio					=	new cnegocio
set alumnos					=	new cformulario
set docente					=	new cformulario
set secciones				=	new cformulario
set nota					=	new cformulario
set datos_selecionados		=	new cformulario
set datos_no_selec			=	new cformulario
'-----------------------------------------------------------
set formbusqueda = new cformulario
set formsecciones = new cformulario
set formprofesores = new cformulario


formbusqueda.inicializar conectar
formsecciones.inicializar conectar 
formprofesores.inicializar conectar
'-----------------------------------------------------------
conectar.inicializar	"desauas"
negocio.inicializa	conectar
sede=negocio.obtenersede

usuario=negocio.obtenerUsuario
periodo=negocio.obtenerperiodoacademico("CLASES")

alumnos.inicializar					conectar
docente.inicializar					conectar
secciones.inicializar				conectar
nota.inicializar					conectar
datos_selecionados.inicializar		conectar
datos_no_selec.inicializar			conectar

alumnos.carga_parametros			"notas.xml","alumnos"
docente.carga_parametros			"notas.xml","docente"
secciones.carga_parametros			"notas.xml","secciones"
nota.carga_parametros				"notas.xml","notas"
datos_selecionados.carga_parametros	"paulo.xml","tabla"	
datos_no_selec.carga_parametros		"paulo.xml","tabla"

'_______________________________________________________________________________________________________________________________________________
formbusqueda.carga_parametros "notas.xml", "busqueda"
formsecciones.carga_parametros "notas.xml", "secciones_J"
formprofesores.carga_parametros "notas.xml", "profesores"

PerSel=conectar.consultauno("select peri_tdesc ||'  '||anos_ccod  from periodos_academicos where peri_ccod='"&periodo&"'")

Sql="select pers_ncorr from personas where pers_nrut='"&negocio.obtenerUsuario&"'"
pers_ncorr=conectar.consultaUno(Sql)

sedeprofesor=   " select distinct a.pers_ncorr ||' '||a.sede_ccod ||' '|| d.sede_tdesc as profesor_sede,d.sede_tdesc as sede,c.peri_ccod " & _
				" from profesores a, bloques_horarios b, secciones c, sedes d " & _
				" where a.pers_ncorr='"&pers_ncorr&"'" & _
				" and a.pers_ncorr=b.pers_ncorr(+)" & _
				" and b.secc_ccod=c.secc_ccod(+)" & _
				" and a.sede_ccod=d.sede_ccod " & _
				" and     c.peri_ccod='"&periodo&"' order by sede "

consprofesor = "select '"&request.QueryString("not[0][sede_ccod]")&"' as sede_ccod from dual"

formprofesores.consultar consprofesor
formprofesores.agregacampoparam "sede_ccod","destino","("& sedeprofesor &") aa"   
formprofesores.siguiente

consulta="select '"&request.QueryString("not[0][secc_ccod]")&"' as secc_ccod from dual"
formbusqueda.consultar consulta
formbusqueda.agregacampocons "secc_ccod", asig_tdesc
formbusqueda.siguiente

consulta2="select '"&request.QueryString("not[0][secc_tdesc]")&"' as secc_tdesc from dual"
formsecciones.consultar consulta2
formsecciones.siguiente

asignaturas=" select distinct b.sede_ccod,c.asig_ccod,c.asig_tdesc, aa.pers_ncorr " & _
			" from profesores aa ,bloques_horarios a, secciones b, asignaturas c " & _
			" where a.secc_ccod=b.secc_ccod " & _
			" and   b.asig_ccod=c.asig_ccod " & _
			" and   a.pers_ncorr='"&pers_ncorr&"' " & _
			" and   b.peri_ccod='"&periodo&"'  " & _
			" and aa.pers_ncorr=a.pers_ncorr " & _
			" order by ltrim(asig_tdesc,' ')  " 


conectar.Ejecuta asignaturas
set rec_asignaturas = conectar.ObtenerRS

Secciones_J = "select distinct a.pers_ncorr,d.sede_ccod,d.sede_tdesc,c.secc_ccod,c.secc_tdesc, e.asig_ccod,e.asig_tdesc " & _
" from profesores a, bloques_horarios b, secciones c,sedes d, asignaturas e " & _
" where a.pers_ncorr='"&pers_ncorr&"' and " & _
" a.pers_ncorr=b.pers_ncorr and " & _
" b.secc_ccod=c.secc_ccod and " & _
" c.sede_ccod=d.sede_ccod and " & _
" c.asig_ccod=e.asig_ccod  and " & _
" c.peri_ccod='"&periodo&"' " 

conectar.Ejecuta Secciones_J
set rec_secciones = conectar.ObtenerRS

set f_asignatura = new CFormulario
f_asignatura.Carga_Parametros "agregar_evaluacion.xml", "f_datos_asignaturas"
f_asignatura.Inicializar conectar
dotos_asignatura=   " select a.asig_ccod,a.secc_tdesc,d.tasg_tdesc," & _
	                " b.asig_tdesc,b.asig_nhoras,c.sede_tdesc " & _
					" from secciones a,asignaturas b, sedes c,tipos_asignatura d" & _
					" where  a.asig_ccod=b.asig_ccod and" & _
					"	     a.sede_ccod=c.sede_ccod and " & _
					"	   	 nvl(a.tasg_ccod,b.tasg_ccod)=d.tasg_ccod and    " & _					
					"	     a.secc_ccod='"&secc_ccod&"' " & _
					" and a.peri_ccod='"&periodo&"'"


		
f_asignatura.Consultar dotos_asignatura
f_asignatura.Siguiente
asig_ccod=f_asignatura.obtenervalor("asig_ccod")

'_______________________________________________________________________________________________________________________________________________

consulta_secciones=" select distinct b.secc_ccod,b.asig_ccod||' '||c.asig_tdesc||' Sección '|| b.secc_tdesc as curso " & vbCrlf & _
				"	 from  " & vbCrlf & _
				"		bloques_horarios a,secciones b,asignaturas c " & vbCrlf & _
				"	 where a.secc_ccod=b.secc_ccod " & vbCrlf & _
				"		 and b.asig_ccod=c.asig_ccod " & vbCrlf & _
				"		 and peri_ccod= '"& periodo &"'  " & vbCrlf & _
				"		 and pers_ncorr=   '"& pers_ncorr &"' " 
		'		"		 and b.sede_ccod='"& sede &"' "' sacar variable en duro

'---------------------------------------------------------------------------------------------------
seccion	=	"select '' as curso, '' as secc_ccod from dual"

secciones.consultar		seccion
	secciones.agregacampoparam	"secc_ccod","destino", "("& consulta_secciones &") a"
if usuario <> "" or not isnull(usuario) then 
	secciones.agregacampocons	"secc_ccod", secc_ccod
else
	secciones.agregacampocons	"secc_ccod", " "
end if
secciones.siguiente
'---------------------------------------------------------------------------------------------------
if (secc_ccod <> "" or not isnull(secc_ccod))then
	ponderacion	=	conectar.consultauno("select sum(cali_nponderacion) as ponderacion from calificaciones_seccion where secc_ccod='"& secc_ccod &"'")
	asig_ccod=conectar.consultauno("select asig_ccod from secciones where secc_ccod='"&secc_ccod&"'")
end if

consulta_alumnos="select  " & vbCrlf & _
					" c.matr_ncorr,nvl(c.estado_cierre_ccod,1)as estado_cierre_ccod, " & vbCrlf & _
				    " decode(d.cali_njustificacion,1,'<font color=red>' || a.pers_nrut||' - '||a.pers_xdv || '</font>',  " & vbCrlf & _
					" a.pers_nrut||' - '||a.pers_xdv) as rut," & vbCrlf & _
					" decode(d.cali_njustificacion,1,'<font color=red>' || pers_tape_paterno||' '||pers_tape_materno||', '|| pers_tnombre || '</font>',  " & vbCrlf & _
					" pers_tape_paterno||' '||pers_tape_materno||', '|| pers_tnombre) as alumno," & vbCrlf & _
  					"		decode(cala_nnota,null,'1.0','1','1.0','2','2.0','3','3.0','4','4.0','5','5.0','6','6.0','7','7.0',cala_nnota) as cala_nnota,  " & vbCrlf & _
					"		d.cali_njustificacion" & vbCrlf & _
					"	from  " & vbCrlf & _
					"		personas a,alumnos b,cargas_academicas c, calificaciones_alumnos d,calificaciones_seccion e " & vbCrlf & _
					"	where a.pers_ncorr=b.pers_ncorr   " & vbCrlf & _
					"		and b.matr_ncorr=c.matr_ncorr  " & vbCrlf & _
					"		and b.emat_ccod=1  " & vbCrlf & _
					"		and c.secc_ccod=d.secc_ccod(+) " & vbCrlf & _
					"		and c.matr_ncorr=d.matr_ncorr(+) " & vbCrlf & _
					"		and c.carg_nsence is null  " & vbCrlf & _
					"		and c.secc_ccod		=	'"& secc_ccod &"' " & vbCrlf & _
					"	    and d.cali_ncorr = e.cali_ncorr (+) " & vbCrlf & _
					"		and d.cali_ncorr(+)  =	'"& cali_ncorr &"' " & vbCrlf & _
					"		and c.matr_ncorr    not in (select matr_ncorr_destino from resoluciones_homologaciones  where secc_ccod_destino='"&secc_ccod&"') " & vbCrlf & _				
					"		and c.matr_ncorr    not in (select matr_ncorr from convalidaciones where matr_ncorr=c.matr_ncorr and asig_ccod='"&asig_ccod&"') " & vbCrlf & _
					"		and (c.sitf_ccod<>'EE' or sitf_ccod is null)" & _
					"	order by pers_tape_paterno, pers_tape_materno, pers_tnombre"

'response.write(consulta_alumnos)
'response.Flush()
if ((secc_ccod <> "" or not isempty(secc_ccod)) or (cali_ncorr <> "" or not isempty(cali_ncorr))) then
cons_datos_sel="select cali_ncorr, to_char(cali_fevaluacion,'dd/mm/yyyy') as fecha from calificaciones_seccion where cali_ncorr='"&cali_ncorr&"'"
cons_datos_nsel="select cali_ncorr, to_char(cali_fevaluacion,'dd/mm/yyyy') as fecha from calificaciones_seccion where secc_ccod='"&secc_ccod&"' and cali_ncorr not in ('"& cali_ncorr &"') and cali_fevaluacion < to_date('"&conectar.consultauno("select to_char(cali_fevaluacion,'dd/mm/yyyy') as fecha from calificaciones_seccion where secc_ccod='"&secc_ccod&"' and cali_ncorr ='"& cali_ncorr &"'")&"','dd/mm/yyyy') order by fecha"

datos_selecionados.consultar		cons_datos_sel
datos_no_selec.consultar			cons_datos_nsel

 dim existe()
	if (datos_selecionados.nrofilas > 0) then
		for i=0 to datos_selecionados.nrofilas - 1
			datos_selecionados.siguiente
			for k=0 to datos_no_selec.nrofilas - 1
				redim preserve existe(k)
				datos_no_selec.siguiente
				existe(k)=conectar.consultauno("select count(*) from calificaciones_alumnos where cali_ncorr in ('"&datos_no_selec.obtenervalor("cali_ncorr")&"') and audi_tusuario not like '%MIGRACION%'")
			next
		next
	end if

	if  datos_no_selec.nrofilas > 0 and not (isnull(datos_no_selec.nrofilas)) then
		no_permite=1
		for k_=0 to datos_no_selec.nrofilas - 1
			if existe(k_) <= 0 then
				no_permite=0
			else
				no_permite=no_permite + 1
			end if
		next
	else
		no_permite=1
	end if

if (no_permite=0 and no_permite<>"") then 
%>
<script language="JavaScript">
	alert('No puede ingresar nota.\nPorque alguna de las evaluaciones anteriores no presenta notas ingresadas.');
</script>	
<%
end if

consulta_nota	="  select cali_ncorr, " & vbCrlf & _
				"	decode(cali_nevaluacion,null,'PN',cali_nevaluacion)||' - '|| to_char(cali_fevaluacion,'dd/mm/yyyy')||' - '|| teva_tdesc  as cali_nevaluacion  " & vbCrlf & _
				"	from calificaciones_seccion a, tipos_evaluacion b , secciones c" & vbCrlf & _
				"	where  " & vbCrlf & _
				"	a.teva_ccod=b.teva_ccod " & vbCrlf & _
				" 	and a.secc_ccod=c.secc_ccod"  & _
				"	and a.secc_ccod='"& secc_ccod &"'  " & vbCrlf & _
				"  	and c.peri_ccod='"&periodo&"'"& _
				"	order by cali_fevaluacion  "

nro_evaluaciones	=	conectar.consultauno("Select count(*) from ("&consulta_nota&")")

if (cali_ncorr <> "" )then
nro_nota	=	conectar.consultauno("select cali_nevaluacion from calificaciones_seccion where cali_ncorr='"& cali_ncorr &"'")

alumnos.consultar	consulta_alumnos
alumnos.agregacampoparam	"cala_nnota","descripcion","Nota "&nro_nota
end if

registros	=	conectar.consultauno("select count(*) from ("& consulta_alumnos &")")

notas	=	"select '' as cali_ncorr from dual "
nota.consultar	notas
nota.agregacampoparam	"cali_ncorr",	"destino", "("& consulta_nota &") a"
nota.agregacampocons	"cali_ncorr",	cali_ncorr
if  nota.nrofilas > 0 then
nota.siguiente
end if

	if (ponderacion < 100 )  then 
	%>
		<script language="JavaScript">
			alert('No puede ingresar notas.\nNo está completo el 100% de las calificaciones');
		</script>
	<%
	end if



correspondencia	=	conectar.consultauno("select count(*) from ("& consulta_nota &")")

	if correspondencia = 0 then
		cali_ncorr=""
	end if
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
<!--
<!--  ----------------------------------------------------------------------------------------
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
	
	formulario.elements["not[0][secc_ccod]"].length = 0;
	
	op = document.createElement("OPTION");
	op.value = "-1";
	op.text = "-- Seleccione Una Asignaturas --";
	formulario.elements["not[0][secc_ccod]"].add(op)
	
	for (i = 0; i < rec_asignaturas.length; i++) {
		if ((rec_asignaturas[i]["pers_ncorr"] == pers_ncorr) && (rec_asignaturas[i]["sede_ccod"] == sede_ccod)) {
			op = document.createElement("OPTION");
			op.value =  rec_asignaturas[i]["asig_ccod"];
			op.text = rec_asignaturas[i]["asig_ccod"]+"-"+rec_asignaturas[i]["asig_tdesc"];
			formulario.elements["not[0][secc_ccod]"].add(op)
		}
	}	
}
function InicioPagina(formulario)
{
/*formulario = document.busqueda;*/
a="<%=asig_tdesc%>"
if (a !="")
{
CargarAsignaturas(formulario, formulario.elements["not[0][sede_ccod]"].value)
formulario.elements["not[0][secc_ccod]"].value = "<%=asig_tdesc%>";

CargarSecciones(formulario,formulario.elements["not[0][secc_ccod]"].value)

if ('<%=secc_ccod%>' != '') {
	formulario.elements["not[0][secc_tdesc]"].value = "<%=secc_ccod%>";
}

sec=formulario.elements["not[0][secc_tdesc]"].value;
}
	
}

function cambiarperiodo(formulario){
	   formulario.action = 'matar_sesion.asp'
   	   formulario.submit();
}

  
function CargarSecciones(formulario,asig_ccod){
var cadena,cadena2, pers_ncorr, sede_ccod
 cadena= formulario.elements["not[0][sede_ccod]"].value.split(" ");
 cadena2=asig_ccod.split(" ");
 pers_ncorr=cadena[0];
 sede_ccod=cadena[1];
 asig=cadena2[0];
 formulario.elements["not[0][secc_tdesc]"].length = 0;
//asig_ccod=formulario.elements["m[0][secc_ccod]"].value

	op2 = document.createElement("OPTION");
	op2.value = "-1";
	op2.text = "-- Secciones --";
	formulario.elements["not[0][secc_tdesc]"].add(op2)
	
	
	for (i = 0; i < rec_secciones.length; i++) {
		if ((rec_secciones[i]["pers_ncorr"] == pers_ncorr) && (rec_secciones[i]["sede_ccod"] == sede_ccod) && (rec_secciones[i]["asig_ccod"]== asig_ccod)) {
			op2 = document.createElement("OPTION");
			op2.value = rec_secciones[i]["secc_ccod"];
			op2.text = rec_secciones[i]["secc_tdesc"];
			formulario.elements["not[0][secc_tdesc]"].add(op2)
			
		}
	}

 
}

function ValidarBusqueda(formulario){
	if (formulario.elements["not[0][sede_ccod]"].value == "") {
		alert('Seleccione una Sede.');
		formulario.elements["not[0][sede_ccod]"].focus();
		return false ;
	}
	if (formulario.elements["not[0][secc_ccod]"].value == "-1") {
		alert('Seleccione una Asignatura.');
		formulario.elements["not[0][secc_ccod]"].focus();
		return false;
	}
	
	if (formulario.elements["not[0][secc_tdesc]"].value == "-1") {
		alert('Seleccione una Sección.');
		formulario.elements["not[0][secc_tdesc]"].focus();
		return false ;
	}

	
	return true;
 }

<!--  ----------------------------------------------------------------------------------------

function verifica_nota(formulario){
n_mala=0;
var num=formulario.elements.length;
	for (i=0;i<num;i++){
		nombre = formulario.elements[i].name;
		var ingresada = new RegExp ("cala_nnota","gi");
		if (ingresada.test(nombre)){
			nota = eval(formulario.elements[i].value);
			if (nota < 1 || nota > 7) {
				n_mala	=	n_mala+1;
				mal		=	formulario.elements[i].focus();
			}
		}
	}
	if (n_mala > 0){
		return(false);
	}
	else {
		return(true);
	}
}

function dibujar(formulario){
	formulario.action='ingreso_notas.asp';
	formulario.submit();
}


function guardar(formulario){
nro_evaluaciones='<%=nro_evaluaciones%>'
pon	=parseInt(<%=ponderacion%>);

if (parseInt(nro_evaluaciones)>0){
	if (pon > 0 || pon <=100){
		ponderacion=pon
		if (parseInt(ponderacion) == 100){
			if(preValidaFormulario(formulario)){
				formulario.method='post';
				if (verifica_nota(formulario)){
					formulario.action ='guardar_nota.asp';
					formulario.submit();
				}
				else {
					alert('Las notas deben estar entre 1.0 y 7.0.');
				}
			}
		}
	}
}
else {alert("No Existen Alumnos ")	}
}
//-->

//-->

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

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="InicioPagina(document.busca_alumnos);MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../__base/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
      <br>
	<table width="88%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
        <tr>
        <td width="10" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td width="658" height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="10" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Ingreso Notas"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
                <td> <p><br>
                  <form name="busca_alumnos" method="get">
                    <table width="98%"  border="0" align="center">
                      <tr> 
                        <td width="81%"><div align="center"> 
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="32%" align="left"> <font face="Verdana, Arial, Helvetica, sans-serif" size="1">Sede 
                                  <br>
                                  <%formprofesores.dibujacampo("sede_ccod")%>
                                  </font></td>
                                <td width="44%" align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">&nbsp; 
                                  </font> <font face="Verdana, Arial, Helvetica, sans-serif" size="1">&nbsp; 
                                  </font><font face="Verdana, Arial, Helvetica, sans-serif" size="1">&nbsp; 
                                  Asignaturas<br>
                                  <%formbusqueda.dibujacampo("secc_ccod")%>
                                  </font></td>
                                <td width="24%" align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Secci&oacute;n<br>
                                  <%formsecciones.dibujacampo("secc_tdesc")%>
                                  </font></td>
                              </tr>
                            </table>
                          </div></td>
                        <td width="19%"><div align="center">
                            <%botonera.dibujaboton "buscar"%>
                          </div></td>
                      </tr>
                    </table>
                    <table width="95%" border="0" align="center">
                      <tr> 
                        <td align="left">*PARA VER UN CURSO SELECCIONES LOS PARAMETROS 
                          DE BUSQUEDA Y PRESIONE EL BOTON <em><strong>&quot;BUSCAR&quot;</strong></em></td>
                      </tr>
                      <tr> 
                        <td align="left">Nota : Ud. esta Ingresando Notas para 
                          el periodo academico de :<strong> 
                          <%response.Write(PerSel)%>
                          </strong> &nbsp;(<a href="javascript:cambiarperiodo(document.busca_alumnos)">Selecionar 
                          Nuevo Periodo</a>)</td>
                      </tr>
                    </table>
                    <br>
                    <% if (not isnull(secc_ccod)) and (secc_ccod <> "") and (secc_ccod <> "-1" ) then %></p> 
                    <table width="100%" border="0">
                    <tr> 
                      <td colspan="2" nowrap>Resultado de La b&uacute;squeda </td>
                    </tr>
                    <tr> 
                      <td width="21%">Sede </td>
                      <td width="79%">:<strong>&nbsp;<%=f_asignatura.obtenervalor("sede_tdesc")%></strong></td>
                    </tr>
                    <tr> 
                      <td nowrap>Asignatura </td>
                      <td nowrap>:<strong> <%=f_asignatura.obtenervalor("asig_ccod")%> 
                        &nbsp; <%=f_asignatura.obtenervalor("asig_tdesc")%></strong> 
                      </td>
                    </tr>
                    <tr> 
                      <td>Secci&oacute;n</td>
                      <td>:<strong> <%=f_asignatura.obtenervalor("secc_tdesc")%></strong> 
                      </td>
                    </tr>
                    <tr> 
                      <td>Tipo Asignatura</td>
                      <td><strong>: <%=f_asignatura.obtenervalor("tasg_tdesc")%></strong></td>
                    </tr>
                  </table>
                  <p></p>
                  <table width="100%" border="0">
                    <tr> 
                      <td align="left"> 
                        <%if ponderacion=100 then%>
                        <strong>CALIFICACIONES :</strong> <%=nota.dibujacampo("cali_ncorr")%> 
                        <%end if%>
                      </td>
                    </tr>
                    <tr> 
                      <td align="left">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td align="left"><p> 
                          <%if cali_ncorr <> "" then%>
                        </p>
                        <p>Calificacion Seleccionada:<strong> 
                          <%
					  response.Write(conectar.consultauno("select 'Nº '|| cali_nevaluacion||' - '||to_char(a.cali_fevaluacion,'dd/mm/yyyy')||' - '||teva_tdesc as evaluacion from calificaciones_seccion a, tipos_evaluacion b where a.teva_ccod=b.teva_ccod and cali_ncorr='"&cali_ncorr&"' "))
					  %>
                          </strong> 
                          <%end if%>
                        </p>
                        <table width="100%" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td>* Alumnos de Color Rojo , tienen la nota justificada 
                              y su nota ser&aacute; remplazada por la nota del 
                              examen</td>
                          </tr>
                        </table></td>
                    </tr>
                  </table>
                  <p> 
                    <%end if %>
                  </form></p>
                  <form name="lista" method="post">
                    <div align="left"> 
                      <p>
                        <% if secc_ccod <> "" and cali_ncorr <> "" then %>
                      </p>
                      <table width="100%" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td align="center">
                            <%pagina.DibujarSubtitulo "Lista de Alumnos"%>
                          </td>
                        </tr>
                        <tr> 
                          <td align="right">&nbsp; </td>
                        </tr>
                        <tr> 
                          <td align="center"> <% 
					if cali_ncorr<>"" then
					alumnos.dibujatabla()
					end if
					%> <input type="hidden" name="registros" value="<%=registros%>"> 
                            <input type="hidden" name="not[0][cali_ncorr]" value="<%=cali_ncorr%>"> 
                            <input type="hidden" name="not[0][secc_ccod]" value="<%=secc_ccod%>">	
                          </td>
                        </tr>
                        <tr> 
                          <td align="center">&nbsp;</td>
                        </tr>
                      </table>
                      <%end if%>
                      <p>&nbsp; </p>
                    </div>
                   
                    <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="10" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"></div></td>
                  <td><div align="center"><%if no_permite > 0 and ponderacion=100 then%>
				                          <%botonera.dibujaboton "guardar"%>
										  <%end if%></div></td>
                  <td><div align="center"><%botonera.dibujaboton "salir"%></div></td>
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

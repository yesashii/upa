<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Ingreso Examenes De Repetición"
set botonera =  new CFormulario
botonera.carga_parametros "notas.xml", "btn_ingreso_notas_finales"

Response.Buffer = True
Response.ExpiresAbsolute = Now() - 1
Response.Expires = 0
Response.CacheControl = "no-cache"

secc_ccod = request.QueryString("secc_ccod")

set conectar		=	new cconexion
set negocio			=	new cnegocio
set alumnos			=	new cformulario
set docente			=	new cformulario
set secciones		=	new cformulario
set n_cali_alum		=	new cformulario
set notas_asig		=	new cformulario
set errores         =   new cerrores	

conectar.inicializar	"upacifico"
negocio.inicializa	conectar

Sql="select pers_ncorr from personas where cast(pers_nrut as varchar)='"&negocio.obtenerUsuario&"'"
pers_ncorr=conectar.consultaUno(Sql)
 
fecha	=	conectar.consultauno("select convert(datetime,getDate(),103) as fecha")
usuario = negocio.obtenerUsuario

sede = negocio.obtenersede
periodo	= negocio.obtenerperiodoacademico("CLASES18")
PerSel=conectar.consultauno("select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")

NombreUsuario	=	conectar.consultauno("select pers_tnombre+' '+ pers_tape_paterno + ' '+ pers_tape_materno as nombre_usuario from personas where cast(pers_ncorr as varchar)='"& pers_ncorr &"'")	

alumnos.inicializar			conectar
docente.inicializar			conectar
secciones.inicializar		conectar
notas_asig.inicializar		conectar		


alumnos.carga_parametros		"notas.xml","alumnos_f_rep"
docente.carga_parametros		"notas.xml","docente"
secciones.carga_parametros		"notas.xml","secciones"
notas_asig.carga_parametros		"paulo.xml","tabla"

seccion	=	"select '' as curso, '' as secc_ccod"
'_______________________________________________________________________________________________________________________________________________

set f_asignatura = new CFormulario
f_asignatura.Carga_Parametros "agregar_evaluacion.xml", "f_datos_asignaturas"
f_asignatura.Inicializar conectar

if (secc_ccod <> "" or isempty(secc_ccod)) then
datos_asignatura=   " select a.asig_ccod,a.secc_tdesc,d.tasg_tdesc," & _
	                " b.asig_tdesc,b.asig_nhoras,c.sede_tdesc " & _
					" from secciones a,asignaturas b, sedes c,tipos_asignatura d" & _
					" where  a.asig_ccod=b.asig_ccod and" & _
					"	     a.sede_ccod=c.sede_ccod and " & _
					"	     b.tasg_ccod=d.tasg_ccod and  " & _					
					"	     cast(a.secc_ccod as varchar)='"&secc_ccod&"' " & _
					" and cast(a.peri_ccod as varchar)='"&periodo&"' "
		
f_asignatura.Consultar datos_asignatura
f_asignatura.Siguiente
asig_ccod=f_asignatura.obtenervalor("asig_ccod")
'--------------------------------------------------------

SQL =" select count(*) from ( select distinct b.cali_ncorr " & _
				" from calificaciones_seccion a,calificaciones_alumnos b " & _
				" where a.cali_ncorr = b.cali_ncorr  and " &_
				"	  a.secc_ccod  = b.secc_ccod   and " & _
				"	 cast(b.secc_ccod as varchar) = '"&secc_ccod&"')r " 
	 
'------------------------------	 
	 
SQL2 =" select count(*) from calificaciones_seccion where cast(secc_ccod as varchar)='"&secc_ccod&"'" 
NumCaliAlumno=conectar.consultauno(sql)
NumCaliAsignatura=conectar.consultauno(SQL2)
end if

'_______________________________________________________________________________________________________________________________________________
consulta_secciones=" select distinct b.secc_ccod,cast(b.asig_ccod as varchar)+' '+c.asig_tdesc +' Sección '+ b.secc_tdesc as curso " & _
				"	 from  " & _
				"		bloques_horarios a,secciones b,asignaturas c " & _
				"	 where a.secc_ccod=b.secc_ccod " & _
				"		 and b.asig_ccod=c.asig_ccod " & _
				"		 and cast(peri_ccod as varchar)= '"& periodo &"'  " & _
				"		 and cast(pers_ncorr as varchar)= '"& pers_ncorr &"' " 

secciones.consultar		seccion
	secciones.agregacampoparam	"secc_ccod","destino", "("& consulta_secciones &")a"
if usuario <> "" or not isnull(usuario) then 
	secciones.agregacampocons	"secc_ccod", secc_ccod
else
	secciones.agregacampocons	"secc_ccod", " "
end if

secciones.siguiente
'------------DATOS EVALUACION------------------------------------------------
mall_ccod = conectar.consultauno("select mall_ccod from secciones where cast(secc_ccod as varchar)= '"&secc_ccod&"'")


set f_consulta = new CFormulario
f_consulta.Carga_Parametros "consulta.xml", "consulta"
f_consulta.Inicializar conectar

consulta = "select a.secc_ccod, " & vbCrLf &_
           "       cast(isnull(a.secc_nota_presentacion, 3) as decimal(2,1)) as secc_nota_presentacion, " & vbCrLf &_
		   "	   isnull(a.secc_porcentaje_presentacion, 60) as secc_porcentaje_presentacion, " & vbCrLf &_
		   "	   replace(cast(isnull(a.secc_porcentaje_presentacion, 60) / 100 as decimal(2,1)),',','.') as porcentaje_presentacion, " & vbCrLf &_
		   "	   isnull(a.secc_eval_mini, 2) as secc_eval_mini, " & vbCrLf &_
		   "	   isnull(a.secc_porce_asiste, 50) as secc_porce_asiste, " & vbCrLf &_
		   "	   cast(isnull(a.secc_nota_ex, 5.5) as decimal(2,1)) as secc_nota_ex, " & vbCrLf &_
		   "	   cast(isnull(a.secc_min_examen, 3) as decimal(2,1)) as secc_min_examen, " & vbCrLf &_
		   "	   isnull(a.secc_eximision, 'S') as secc_eximision, " & vbCrLf &_
		   "       replace(cast(1 - (isnull(secc_porcentaje_presentacion, 60) / 100) as decimal(2,1)),',','.') as porc_examen " & vbCrLf &_
		   "from secciones a " & vbCrLf &_
		   "where cast(a.secc_ccod as decimal)= '" & secc_ccod & "'"

f_consulta.Consultar consulta
f_consulta.Siguiente

porcentaje_asistencia = f_consulta.ObtenerValor("secc_porce_asiste")
NOTA_PRESENTACION = f_consulta.ObtenerValor("secc_nota_presentacion")
NOTA_EXIMICION = f_consulta.ObtenerValor("secc_nota_ex")
NOTA_MIN_EXAMEN = f_consulta.ObtenerValor("secc_min_examen")
PORCENTAJE_PRESENTACION = f_consulta.ObtenerValor("porcentaje_presentacion")
v_porcentaje_presentacion = f_consulta.ObtenerValor("secc_porcentaje_presentacion")
PORCENTAJE_EXAMEN = f_consulta.ObtenerValor("porc_examen")
SECC_EXIMISION = f_consulta.ObtenerValor("secc_eximision")

if f_consulta.NroFilas = 0 then	
	PORCENTAJE_PRESENTACION = "0"
	PORCENTAJE_EXAMEN = "0"
end if

set f_consulta = Nothing


'porcentaje_asistencia =conectar.consultauno("select nvl(MALL_PORCENTAJE_ASISTENCIA,60) from malla_curricular where mall_ccod = '"&mall_ccod&"'")
'NOTA_PRESENTACION = conectar.consultauno("select replace(decode(nvl(MALL_NOTA_PRESENTACION,3),'1','1.0','2','2.0','3','3.0','4','4.0','5','5.0','6','6.0','7','7.0',MALL_NOTA_PRESENTACION),',','.') from malla_curricular where mall_ccod = '"&mall_ccod&"'")
'NOTA_EXIMICION = conectar.consultauno("select replace(decode(nvl(MALL_NOTA_EXIMICION,5.5),'1','1.0','2','2.0','3','3.0','4','4.0','5','5.0','6','6.0','7','7.0',MALL_NOTA_EXIMICION),',','.') from malla_curricular where mall_ccod = '"&mall_ccod&"'")
'PORCENTAJE_PRESENTACION = conectar.consultauno("select nvl(MALL_PORCENTAJE_PRESENTACION,60) from malla_curricular where mall_ccod = '"&mall_ccod&"'")/100
'PORCENTAJE_EXAMEN =(1 -PORCENTAJE_PRESENTACION)
'PORCENTAJE_PRESENTACION = conectar.consultauno("select replace('"&PORCENTAJE_PRESENTACION&"',',','.') from dual")
'PORCENTAJE_EXAMEN = conectar.consultauno("select replace('"&PORCENTAJE_EXAMEN&"',',','.') from dual")

'if PORCENTAJE_PRESENTACION ="" or isnull(PORCENTAJE_PRESENTACION) or isempty(PORCENTAJE_PRESENTACION) then
'		PORCENTAJE_PRESENTACION =0
'		PORCENTAJE_EXAMEN =0
'end if
'----------------------------------------------------------------------------
consulta_alumnos="select distinct " & vbCrlf & _
				" isnull(c.carg_justi,0) as carg_justi," & vbCrlf & _
				" isnull(c.estado_cierre_ccod,1)as estado_cierre_ccod,c.matr_ncorr,c.matr_ncorr as v_matr_ncorr,  pers_tape_paterno,pers_tape_materno,pers_tnombre, " & vbCrlf & _
			    " case b.alum_trabajador when 0 then '<font color=blue>' + cast(a.pers_nrut as varchar)+' - '+ a.pers_xdv + '</font>' else" & vbCrlf & _
				"      cast(a.pers_nrut as varchar)+' - '+ a.pers_xdv end as rut, " & vbCrlf & _
				" case b.alum_trabajador when 0 then '<font color=blue>' + pers_tape_paterno+' '+ pers_tape_materno + ',<br> '+ pers_tnombre  + '</font>' else" & vbCrlf & _
                "      pers_tape_paterno + ' '+ pers_tape_materno +',<br> '+ pers_tnombre end as alumno,"& vbCrlf & _
				" replace(case protic.NOTA_PRESENTACION(c.matr_ncorr,'"&secc_ccod&"') when '1' then '1.0' when '2' then '2.0' when '3' then '3.0' when '4' then '4.0' when '5' then '5.0' when '6' then '6.0' when '7' then '7.0' else protic.NOTA_PRESENTACION(c.matr_ncorr,'"&secc_ccod&"') end,',','.') as carg_nnota_presentacion, " & vbCrlf & _
				" replace(case c.carg_nnota_examen when '1' then '1.0' when '2' then '2.0' when '3' then '3.0' when '4' then '4.0' when '5' then '5.0' when '6' then '6.0' when '7' then '7.0' else c.carg_nnota_examen end,',','.') as carg_nnota_examen," & vbCrlf & _
				" replace(case c.carg_nnota_repeticion when '1' then '1.0' when '2' then '2.0' when '3' then '3.0' when '4' then '4.0' when '5' then '5.0' when '6' then '6.0' when '7' then '7.0' else c.carg_nnota_repeticion end,',','.') as carg_nnota_repeticion, "&vbcrlf&_
				" case isnull(carg_nnota_final,0) when 0 then" & vbCrlf & _
				" 	 replace(case protic.ALUMNOS_EXIMIDOS(c.matr_ncorr,'"&secc_ccod&"') when '1' then '1.0' when '2' then '2.0' when '3' then '3.0' when '4' then '4.0' when '5' then '5.0' when '6' then '6.0' when '7' then '7.0'else protic.ALUMNOS_EXIMIDOS(c.matr_ncorr,'"&secc_ccod&"') end,',','.') else "&vbcrlf&_
				"    replace(isnull(case carg_nnota_final when '1' then '1.0' when '2' then '2.0' when '3' then '3.0' when '4' then '4.0' when '5' then '5.0' when '6' then '6.0' when '7' then '7.0' else carg_nnota_final end,'1,0'),',','.')end as carg_nnota_final, " & vbCrlf & _
				" case isnull(carg_nnota_final,0) when 0 then" & vbCrlf & _
				" 	 replace(case protic.ALUMNOS_EXIMIDOS(c.matr_ncorr,'"&secc_ccod&"') when '1' then '1.0' when '2' then '2.0' when '3' then '3.0' when '4' then '4.0' when '5' then '5.0' when '6' then '6.0' when '7' then '7.0' else protic.ALUMNOS_EXIMIDOS(c.matr_ncorr,'"&secc_ccod&"')end,',','.') else "&vbcrlf&_
				"    replace(case carg_nnota_final when '1' then '1.0' when '2' then '2.0' when '3' then '3.0' when '4' then '4.0' when '5' then '5.0' when '6' then '6.0' when '7' then '7.0' else carg_nnota_final end,',','.')end as carg_nnota_final_paso, " & vbCrlf & _
				" c.sitf_ccod,c.carg_nasistencia,isnull(b.talu_ccod,1) as talu_ccod ,isnull(b.alum_trabajador,1) as alum_trabajador, isnull(eexa_ccod_rep,'NP') as EEXA_CCOD_REP, eexa_ccod as EEXA_CCOD" & vbCrlf & _
				"	from  " & vbCrlf & _
				"		personas a, " & vbCrlf & _
				"		alumnos b, " & vbCrlf & _
				"		cargas_academicas c, " & vbCrlf & _
				"		secciones f " & vbCrlf & _
				"	where  " & vbCrlf & _
				"		a.pers_ncorr        =   b.pers_ncorr  " & vbCrlf & _
				"		and b.matr_ncorr    =   c.matr_ncorr  " & vbCrlf & _
				"		and b.emat_ccod     =   1  " & vbCrlf & _
				"		and c.carg_nsence is null  " & vbCrlf & _
				"		and c.secc_ccod     =   f.secc_ccod " & vbCrlf & _
				"		and c.matr_ncorr    not in (select matr_ncorr_destino from resoluciones_homologaciones  where cast(secc_ccod_destino as varchar)='"&secc_ccod&"') " & vbCrlf & _
				"		and c.matr_ncorr    not in (select matr_ncorr from convalidaciones where matr_ncorr=c.matr_ncorr and cast(asig_ccod as varchar)='"&asig_ccod&"') " & vbCrlf & _
				" 		and (c.sitf_ccod<>'EE' or c.sitf_ccod is null) " & vbCrlf & _
				"		and cast(c.secc_ccod as varchar) = '"& secc_ccod &"' " & vbCrlf & _
				" AND cast(f.peri_ccod as varchar)='"&periodo&"' and (sitf_ccod='RR' or carg_nnota_repeticion is not null)" & _
				"	group by c.carg_justi,c.estado_cierre_ccod,c.matr_ncorr,a.pers_nrut,a.pers_xdv,pers_tape_paterno,pers_tape_materno,pers_tnombre,c.carg_nnota_presentacion, c.carg_nnota_examen,c.carg_nnota_repeticion, c.carg_nnota_final,c.sitf_ccod,c.carg_nasistencia,b.talu_ccod,b.alum_trabajador,eexa_ccod_rep,EEXA_CCOD  "
			
			
'response.Write("<pre>"&consulta_alumnos&"</pre>")
'response.End()
alumnos.consultar	consulta_alumnos
i_ = 0
while alumnos.Siguiente	
	
		if alumnos.ObtenerValor("EEXA_CCOD_REP") ="NP" then
			alumnos.agregacampofilacons	i_,	"carg_nnota_final",	"1.0"
		end if
	i_ = i_ + 1
wend

alumnos.primero

alumnos.agregacampoparam	"cala_nnota","descripcion","Nota "&nro_nota
alumnos.agregacampoparam	"carg_nnota_presentacion","script","readOnly"


registros	=	conectar.consultauno("select count(*) from ("& consulta_alumnos &")j")
reg=alumnos.nrofilas
'response.Write(consulta_nota)

if secc_ccod <> ""  then
	tipo_asignatura	= conectar.consultauno("	select isnull(b.tasg_ccod,a.tasg_ccod) "  & vbcrlf & _
											"	from  " & vbcrlf & _
											"		asignaturas a, secciones b " & vbcrlf & _
											"	where " & vbcrlf & _
											"		a.asig_ccod=b.asig_ccod " & vbcrlf & _
											"		and cast(b.secc_ccod as varchar)='"&secc_ccod&"'")
end if

if cint(tipo_asignatura) <> 1 then
	notas_asig.consultar			consulta_alumnos
	for i_=0 to notas_asig.nrofilas-1
		notas_asig.siguiente
		alumnos.agregacampofilacons	i_,	"carg_nnota_final",		notas_asig.obtenervalor("carg_nnota_presentacion")
	next
	alumnos.agregacampoparam		"carg_nnota_examen",		"tipo",		"hidden"
	alumnos.agregacampoparam		"carg_nnota_examen",		"permiso",	"oculto"
	alumnos.agregacampoparam		"carg_nnota_repeticion",	"tipo",		"hidden"
	alumnos.agregacampoparam		"carg_nnota_repeticion",	"permiso",	"oculto"
	
end if
alumnos.agregacampoparam		"erep",		"tipo",	"hidden"
alumnos.agregacampoparam		"erep",	"permiso",	"oculto"

tasg_tdesc=conectar.consultauno("select tasg_tdesc from tipos_asignatura where cast(tasg_ccod as varchar)='"&tipo_asignatura&"'")
v_tipo_asignatura=conectar.consultauno("select tasg_ccod from tipos_asignatura where cast(tasg_ccod as varchar)<>'"&tipo_asignatura&"'")
v_tasg_tdesc=conectar.consultauno("select tasg_tdesc from tipos_asignatura where cast(tasg_ccod as varchar)<>'"&tipo_asignatura&"'")


'alumnos.AgregaCampoParam "carg_nnota_repeticion", "script", "onBlur='ValidaNota(this)'"
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
			op.value = rec_asignaturas[i]["asig_ccod"];
			op.text = rec_asignaturas[i]["asig_ccod"]+"-"+rec_asignaturas[i]["asig_tdesc"];
			formulario.elements["not[0][secc_ccod]"].add(op)
		}
	}	
}

function CargarSecciones(formulario,asig_ccod){
var cadena,cadena2, pers_ncorr, sede_ccod
 cadena= formulario.elements["not[0][sede_ccod]"].value.split(" ");
 cadena2=asig_ccod.split(" ");
 pers_ncorr=cadena[0];
 sede_ccod=cadena[1];
asig=cadena2[0];
	formulario.elements["not[0][secc_tdesc]"].length = 0;
	
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

 function enviar(formulario){
	/*var pers_ncorr,sede_ccod,asig_ccod,secc_ccod,cadena*/	
   	if(ValidarBusqueda(formulario)){
	  formulario.action = 'ingreso_notas_finales.asp'
   	  <%v_enviado_=0%>
	  formulario.submit();}	
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

 function volver_examen (formulario){
    secc_ccod = '<%=request.QueryString("secc_ccod")%>';
	asig_tdesc = '<%=request.QueryString("asig_tdesc")%>'
	sede_ccod='<%=request.QueryString("sede_ccod")%>'
	secc_tdesc ='<%=request.QueryString("secc_tdesc")%>'
	url = 'ingreso_notas_finales.asp?not[0][secc_tdesc]='+secc_ccod+'&not[0][secc_ccod]='+asig_tdesc+'&not[0][sede_ccod]='+sede_ccod+'&secc_tdesc='+secc_tdesc
	formulario.action=url;
	formulario.submit();
 }

function guardar(formulario){
registros	= '<%=registros%>'
if (parseInt(registros) ){
	if(preValidaFormulario(formulario)){
		formulario.method='post';
		if (verifica_nota(formulario)){
			if(valporcentaje(formulario)){
			formulario.action ='guardar_notas_finales.asp';
			formulario.submit();
			}
			else{alert("Los Porcentaje Deben Estar Entre 0% y 100%")}
		}
		else {
			alert('Las notas deben estar entre 1.0 y 7.0.');
		}
	}
}
else {alert("No Existen Alumnos ")}	
}

function cambiarAsig(formulario){
	registros	= '<%=registros%>'
//	resgistros_peec = '<%=resgistros_peec%>'
	if (parseInt(registros)>0 ){
		formulario.method='post';
		formulario.action ='cambiar_asignatura.asp';
		formulario.submit();
	}
}

function cerrar_asignatura(formulario){
	if(preValidaFormulario(formulario)){
		formulario.method='post';
		formulario.action ='cerrar_seccion.asp';
		formulario.submit();
			
	}
}

function cerrar_alumno(formulario){
resgistros='<%=reg%>'
paso=true;
for(i=0;i<resgistros;i++){
	if (formulario.elements["not["+i+"][v_matr_ncorr]"].checked==true){
		if (formulario.elements["not["+i+"][sitf_ccod]"].value=="" || formulario.elements["not["+i+"][carg_nasistencia]"].value=="" ) {
			paso=false ;
		}
	}
}

	
if (paso==true) {
	if (verifica_nota(formulario)){
		if(valporcentaje(formulario)){
					formulario.method='post';
					formulario.action ='cerrar_alumno.asp';
					formulario.submit();
		}
		else{alert("Los Porcentaje Deben Estar Entre 0% y 100%")}	
	}
	else{alert('Las notas deben estar entre 1.0 y 7.0.');}
}
else{alert("Existen Campos Vacios")}
}

function verifica_nota(formulario){
n_mala=0;
var num=formulario.elements.length;
	for (i=0;i<num;i++){
		nombre = formulario.elements[i].name;
		var ingresada = new RegExp (/(carg_nnota_presentacion|carg_nnota_examen|carg_nnota_repeticion)/gi);
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

function valporcentaje(formulario){
p_mala=0;
var num=formulario.elements.length;
	for (i=0;i<num;i++){
		nombre = formulario.elements[i].name;
		var ingresada = new RegExp (/(carg_nasistencia)/gi);
		if (ingresada.test(nombre)){
			porcentaje = eval(formulario.elements[i].value);
			if (porcentaje < 0 || porcentaje > 100) {
				p_mala	=	p_mala+1;
				p_mal		=	formulario.elements[i].focus();
			}
		}
	}
	if (p_mala > 0){
		return(false);
	}
	else {
		return(true);
	}

}

function evalua_nota(objeto){
	arr_indice=objeto.name.split(/[\[\]]/);
	ver_ne = MM_findObj('not['+arr_indice[1]+'][carg_nnota_examen]')
	
	var nf		= MM_findObj('not['+arr_indice[1]+'][carg_nnota_final]')
	var nf2		= MM_findObj('not['+arr_indice[1]+'][carg_nnota_final_paso]')
	var np		= MM_findObj('not['+arr_indice[1]+'][carg_nnota_presentacion]')
	var ne		= MM_findObj('not['+arr_indice[1]+'][carg_nnota_examen]')
	var nr		= MM_findObj('not['+arr_indice[1]+'][carg_nnota_repeticion]')
	var asist	= MM_findObj('not['+arr_indice[1]+'][carg_nasistencia]')
	var sf		= MM_findObj('not['+arr_indice[1]+'][sitf_ccod]')
	var at      = MM_findObj('not['+arr_indice[1]+'][alum_trabajador]')
	var ta		= MM_findObj('not['+arr_indice[1]+'][talu_ccod]')
	var cer		= MM_findObj('not['+arr_indice[1]+'][eexa_ccod_rep]')	
	var ce		= MM_findObj('not['+arr_indice[1]+'][eexa_ccod]')		
	var carg_justi		= MM_findObj('not['+arr_indice[1]+'][carg_justi]')
	var	t_asig	= '<%=tipo_asignatura%>';
	var porcentaje_presentacion01='<%=PORCENTAJE_PRESENTACION%>';
	var porcentaje_examen01='<%=PORCENTAJE_EXAMEN%>';
	var notafinal=0;
porcentaje = "<%=porcentaje_asistencia%>";
if (ver_ne.disabled){
valor_examen = np.value
}
else{
valor_examen = ne.value
}

if (valor_examen!="" ){
ce.value="RE"
}
else {
	if (ce.value!="EX") {
			if(ce.value!="SD"){
				ce.value="NP"
				}	
		}
}
if(ce.value=="NP"){
	valor_examen=1
}
notafinal=roundFun((eval_nota(np.value) * porcentaje_presentacion01 ) + (eval_nota(valor_examen) * porcentaje_examen01),1);
	if (t_asig==1){
		notafinal=roundFun((eval_nota(np.value)* porcentaje_presentacion01 ) + (eval_nota(valor_examen) * porcentaje_examen01),1);
		if (eval_nota(np.value)<3.95 && notafinal<3.95 && eval_nota(nr.value)!=0){
			notafinal=roundFun((eval_nota(np.value) * porcentaje_presentacion01 ) + (eval_nota(nr.value) * porcentaje_examen01),1);
			
			/*if (notafinal>=3.95){
				nf.value=4.0;
			}
			else {
				nf.value=notafinal;
			}*/
			nf.value=notafinal;
		}
		else{
			
			if (eval_nota(nr.value)!=0){
				notafinal=roundFun((eval_nota(np.value) * porcentaje_presentacion01) + (eval_nota(nr.value) * porcentaje_examen01),1);
					nf.value=notafinal;

			}
			else{
				nf.value=notafinal;
			}
		}
		if(nr.value!="") {
			cer.value="RE"
		}
		else{
			cer.value="NP"
			if(ce.value=="SD"){
				nf.value=np.value
			}
			else{
				nf.value=notafinal;	
				}
		}
		if ((nr.value<3) && (cer.value!="NP") ){
			nf.value = nr.value
		}
		if (cer.value=="NP"){
			nf.value="1.0"
		}
		if (nf.value>=eval(3.95)){
		
			if (parseInt(asist.value)>=porcentaje){  
				if (validar_porc(asist)){
					sf.value="AA";
				}
				else{
				sf.value="RI";
				}
			}
			else{
				sf.value="RI";
			}
		}
		else{
			sf.value="RR";
		}
	}
	else{ 
		nf.value=roundFun(eval_nota(np.value),1);
		if (eval_nota(nf.value)>=eval(3.95)){
		//alert(asist.value)
			if (parseInt(asist.value)>=porcentaje){  
				sf.value="AA";
			}
			else{
				sf.value="RI";
			}
		}
		else{
			sf.value="RR";
		}
	}
}

function eval_nota(n){
if (n=="" || n==null || isDigit(n)==false)
   {
   return eval(0);}
else
   {return eval(roundFun(n,1));}
}

function validar_porc(n){
		if (isNumber(n.value)==true){ 
			if (eval(n.value)<eval(0) || eval(n.value)>eval(100)){
				alert ('Debe ingresar valores númericos entre 0 y 100')
				n.focus();
				return false;
			}
		}
		else{
			alert ('Asegurese de ingresar valores númericos validos.')
			n.focus();
			return false;
		 }
	return true;
}

function dibujar(formulario){
	formulario.action='ingreso_notas_finales.asp';
	formulario.submit();
}


function EsNota(p_nota)
{
	if (isEmpty(p_nota))
		return true;
		
	if (!isNumber(p_nota))
		return false;
		
	if ((parseFloat(p_nota) < 1) || (parseFloat(p_nota) > 7))
		return false;
		
	return true;
}


function ValidaNota(p_objeto)
{
	v_nota = p_objeto.value;
	
	if (!EsNota(v_nota)) {
		alert('Ingrese una nota entre 1.0 y 7.0 utilizando un (.) como separador decimal, \no deje en blanco si el alumno no se presentó al examen.');
		p_objeto.select();
		p_objeto.focus();		
	}
}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../__base/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
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
                <td>
                  <%pagina.DibujarLenguetas Array("Ingresar Notas Finales"), 1 %>
                </td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <form name="lista" method="post">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td><p> 
                            <% if secc_ccod <>"" then %>
                            
                          <table width="99%"  border="0">
                            <tr>
                              <td colspan="4">&nbsp;Resultado De La busqueda </td>
                            </tr>
                            <tr>
                              <td width="26%">Sede</td>
                              <td width="47%"><strong>: <%=f_asignatura.obtenervalor("sede_tdesc")%></strong></td>
                              <td width="4%">RE</td>
                              <td width="23%"> : RINDIO EXAMEN </td>
                            </tr>
                            <tr>
                              <td>Asignatura</td>
                              <td><strong>: <%=f_asignatura.obtenervalor("asig_ccod")%> &nbsp; <%=f_asignatura.obtenervalor("asig_tdesc")%></strong> </td>
                              <td>NP</td>
                              <td> : NO SE PRESENTO </td>
                            </tr>
                            <tr>
                              <td>Tipo Asignatura</td>
                              <td> : <strong>
                                <%response.Write(tasg_tdesc)%>
                              </strong></td>
                              <td>SD</td>
                              <td>: SIN DERECHO A EXAMEN</td>
                            </tr>
                            <tr>
                              <td>Seccion</td>
                              <td> : <strong><%=f_asignatura.obtenervalor("secc_tdesc")%></strong></td>
                              <td>EX</td>
                              <td> : EXIMIDO </td>
                            </tr>
                          </table>
                          <p> 
                            <%end if %>
                          </p>
                          <input name="regAlumnos" type="hidden" value="<%=RegAlumnos%>"> 
                          <%

			   if secc_ccod<>""  then
			   	
					if NumCaliAsignatura=NumCaliAlumno and NumCaliAsignatura<>0 and NumCaliAlumno<>0 then
					
					
			   %>
                         
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
                              <td align="center"> 
                                <%alumnos.dibujatabla()%>
                                <input type="hidden" name="registros" value="<%=registros%>"> 
                                <input type="hidden" name="not[0][secc_ccod]" value="<%=secc_ccod%>"> 
                                <input name="sesi_ccod2" type="hidden" value="<%=sesi_ccod%>"> 
                                <input name="cali_ncorr2" type="hidden" value="<%=cali_ncorr%>"> 
                              </td>
                            </tr>
                          </table>
                          <p> 
                            <%else
				 	response.Write("<font face='Verdana, Arial, Helvetica, sans-serif' color='#CC3300' size='1'><center><b>NO PUEDE INGRESAR NOTAS FINALES, YA QUE EXISTEN NOTAS  PARCIALES NO INGRESADAS</b></center></font>")
					
				 end if%>
                            <%end if%>
                          </p>
                          <p> 
                            <%if cint(tipo_asignatura)=1   THEN%>
                            <%if cint(NumCaliAsignatura)<>0 or cint(NumCaliAsignatura)<>0  or NumCaliAsignatura<> NumCaliAsignatura then  %>
</p>
                          <p>                         
                          <table width="75%" align="right">
                            <tr> 
                              <td> <div align="right"><%botonera.dibujaboton "examen"%>                                </div></td>
                            </tr>
                          </table>
                          <p> 
                            <%end if%>
                            <%end if%>
                          
                           
                        </td>
                      </tr>
                    </table>
                    <br>
            </form></td></tr>
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
                        <td><div align="center"></div></td>
                        <td><div align="center">
                            <%botonera.dibujaboton "guardar"%>
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

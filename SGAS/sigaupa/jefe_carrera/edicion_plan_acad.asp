<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set botonera = new CFormulario
botonera.carga_parametros "edicion_plan_acad.xml", "btn_edicion_plan_acad"




Session("ses_accion") = Request.QueryString("accion")

set errores = new CErrores

a = request("bloq_ccod")
b = request("ssec_ncorr")
c = request("pers_ncorr")
'response.Write("c "& c)
bloque_prueba =request("bloq_ccod")
'response.Write("a "&a&" b "&b&" c "&c)
if EsVacio(a) then
	b_bloque_creado = false
else
	b_bloque_creado = true
end if


set negocio = new cnegocio
set conec_resul = new cconexion
set formu_resul= new cformulario
conec_resul.inicializar "upacifico"

negocio.inicializa conec_resul
'--------------------------------------agregar filtros para ver si se dividen en escuela las funcionalidades o no--------------------------
'------------------------------------------------------------------------21/01/2005--------------------------------------------------------
usuario_iniciado = negocio.obtenerUsuario
pers_ncorr_temporal=conec_resul.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario_iniciado&"'")

sql = "select isnull(b.srol_npermiso,2) from sis_roles_usuarios a, sis_roles b where cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and a.srol_ncorr=b.srol_ncorr "
'response.write sql
tipo_permiso=conec_resul.consultaUno(sql)
'
'tipo_permiso
'
'1.- Bloques Horarios
'2.- Asignación Docentes
'
if usuario_iniciado="8474919"  or usuario_iniciado="7139878" or usuario_iniciado="8001318" or usuario_iniciado="13721634" or usuario_iniciado="12412430" then
tipo_permiso="1"
end if
'habilitar permisos a Luz Sepulveda, Pablo Balzo y Paulina Romero y viviana cornejo, claudia brito, cecilia Duran 
if usuario_iniciado="13670470" or usuario_iniciado="9498228" or usuario_iniciado="8685700" or usuario_iniciado="14255933" or usuario_iniciado="12799369" or usuario_iniciado="14255933" or usuario_iniciado="16232812" then
	tipo_permiso="1"  
end if

if usuario_iniciado="12136197" then
    tipo_permiso="1"
end if

if (usuario_iniciado="12884063" or usuario_iniciado="16232812") and b <> "" then
    tipo_permiso="1"
end if

if (usuario_iniciado="12884063" or usuario_iniciado="16232812") and b = "" then
	tipo_permiso="2"
end if
'------------------------------------------------------------------------------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------------------------------
if tipo_permiso="1" then
	pagina.Titulo = "Bloques Horarios"
else
	pagina.Titulo = "Asignación de Docentes"	
end if

mensaje_cambio = ""
if b_bloque_creado then
  tiene_asignado_laboratorio =  conec_resul.consultaUno("select count(*) from bloques_horarios where cast(bloq_ccod as varchar)='"&a&"' and sala_ccod in (30,32,31,29,43,274,65,25,175,176,102,161,85,133,167,266)")
  if tiene_asignado_laboratorio <> "0" then
  		mensaje_cambio = "Bloque asignado a laboratorio o auditorium!"
  end if
  if usuario_iniciado = "8516097" or usuario_iniciado = "12884063" then'Habilitación de permisos para Regina
  	tiene_asignado_laboratorio = "0"
	mensaje_cambio			   = ""
  end if
end if

if b<>"" then
	secc_ccod_cons = "select secc_ccod from sub_secciones where cast(ssec_ncorr as varchar)='" & b &"'"
'	response.Write("1")
	secc_ccod = conec_resul.consultaUno(secc_ccod_cons)
end if

sede = negocio.obtenerSede
carreras = negocio.obtenerCarreras


if c = "" then
	'c = "NULL"
	if a <> "" then 
		pn = conec_resul.consultaUno("Select pers_ncorr from bloques_profesores where cast(bloq_ccod as varchar)='"&a&"' and tpro_ccod=1")
	end if
	
	if pn <> "" then
		c = pn
	else	
		c = conec_resul.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&negocio.ObtenerUsuario&"'")
	end if	
end if
'response.Write("c "&c)

fInicio = negocio.obtenerFechaInicio("CLASES","I")
fTermino1 = negocio.obtenerFechaTermino("CLASES18","I")
fTermino2 = negocio.obtenerFechaTermino("CLASES19","I")
fTermino3 = negocio.obtenerFechaTermino("CLASES20","I")

formu_resul.carga_parametros "paulo.xml", "edicion_bloque"


'formu_resul.agregaCampoParam "sala_ccod", "filtro", "cast(sede_ccod as varchar) = '" & sede &"'"
formu_resul.AgregaCampoParam "sala_ccod", "script", "onChange = 'MostrarCupos(this.value)';"

formu_resul.agregaCampoParam "pers_ncorr", "filtro", "cast(sede_ccod as varchar) = '" & sede &"'"
formu_resul.agregaCampoParam "hora_ccod", "filtro", "cast(sede_ccod as varchar) = '" & sede &"'"


formu_resul.inicializar conec_resul

if b="" then
	consulta = "select ssec_ncorr from bloques_horarios where cast(bloq_ccod as varchar)= '" & a & "'" 
'	consulta = "select 10 from dual"
    'response.Write("<br>consulta "&consulta)
	subseccion = conec_resul.consultaUno(consulta)
	
else
	subseccion = b
end if
'response.Write("subseccion "&subseccion)
'response.End()
consulta = "select convert(varchar,ssec_finicio_sec,103) from sub_secciones where cast(ssec_ncorr as varchar)='" & subseccion &"'"
'response.Write(consulta)
fI = conec_resul.consultaUno(consulta)
'response.Write("3")
consulta = "select convert(varchar,ssec_ftermino_sec,103) from sub_secciones where cast(ssec_ncorr as varchar)='" & subseccion &"'"
fT = conec_resul.consultaUno(consulta)
'response.Write("4")
if fI <> "" and fT <> "" then
	if  false then
		fAs = split(fI,"/")
		fInicio = fAs(1) & "/" & fAs(0)& "/" & fAs(2)
		fAi = split(fT,"/")
		fTermino = fAi(1) & "/" & fAi(0)& "/" & fAi(2)
	else 
	'response.write fI
	'response.Flush
		fAs = split(fI,"/")
		fInicio = fAs(0) & "/" & fAs(1)& "/" & fAs(2)
		fAi = split(fT,"/")
		fTermino = fAi(0) & "/" & fAi(1)& "/" & fAi(2)
	'response.write fT
	end if
end if

if a <> "" then
'response.Write("5")
	consulta = "select cast(a.asig_ccod as varchar)+ '-' + cast(secc_tdesc as varchar)+ ' ' + cast(asig_tdesc as varchar) from asignaturas a, secciones b, bloques_horarios c where a.asig_ccod=b.asig_ccod and b.secc_ccod = c.secc_ccod and cast(c.bloq_ccod as varchar)='" &a&"'"
	asignatura = conec_resul.consultaUno(consulta)
'	response.Write("6")
	consulta = "select a.*,  '" & asignatura & "' as secc_ccod_pres from bloques_horarios a where cast(bloq_ccod as varchar)='"& a &"'"
else
    horas_seguidas = "Horas seguidas: <input type='text' name='horas' value='1' maxlength='1' size='2'>"
'	response.Write("7")
	consulta = "select cast(a.asig_ccod as varchar)+ '-' + cast(secc_tdesc as varchar)+ ' ' + cast(asig_tdesc as varchar) from asignaturas a, secciones b, sub_secciones c where a.asig_ccod=b.asig_ccod and b.secc_ccod=c.secc_ccod and cast(c.ssec_ncorr as varchar)= '"&b&"'"
	asignatura = conec_resul.consultaUno(consulta)
'response.Write("8")
	consulta = "select cast(isnull(asig_nhoras,0) as int) from asignaturas a, secciones b, sub_secciones c where a.asig_ccod=b.asig_ccod and b.secc_ccod=c.secc_ccod and cast(c.ssec_ncorr as varchar)= '"&b&"'"
	'RESPONSE.Write(CONSULTA)
	horas = cint(conec_resul.consultaUno(consulta))
	'response.Write("c "&c)
	consulta = "select " & b & " as ssec_ncorr,  '" & asignatura & "' as secc_ccod_pres,  " & _
				 c & " as pers_ncorr,  " & sede & " as sede_ccod_pres, " &_ 
				 "'" & fInicio & "' as bloq_finicio_modulo,  '" & fTermino & "' as bloq_ftermino_modulo"  
				 
end if
'response.Write("<br>"&consulta)
formu_resul.consultar consulta 

if b<>"" then
	formu_resul.agregaCampoCons "secc_ccod", secc_ccod
end if
    ' formu_resul.agregaCampoCons "pers_ncorr", c
formu_resul.siguiente



set fc_salas = new CFormulario
fc_salas.Carga_Parametros "andres.xml", "consulta"
fc_salas.Inicializar conec_resul

consulta = "select a.sala_ccod, a.sala_ncupo " &_
           "from salas a, tipos_sala b " &_
		   "where a.tsal_ccod=b.tsal_ccod " &_
		   "  and cast(a.sede_ccod as varchar) = '" & sede & "' and a.sala_ccod in (30,32,31,29,43,274,65,25,175,176,102,161,85,133,167,266,336) "

if usuario_iniciado = "8516097" or usuario_iniciado = "12884063" or usuario_iniciado = "16232812" then'Habilitación de permisos para Regina
consulta = " select a.sala_ccod, a.sala_ncupo " &_
           " from salas a, tipos_sala b " &_
		   " where a.tsal_ccod=b.tsal_ccod " &_
		   " and cast(a.sede_ccod as varchar) = '" & sede & "' "
end if

fc_salas.Consultar consulta

set formu_prof= new cformulario
formu_prof.carga_parametros "paulo.xml", "profesores"
formu_prof.Inicializar conec_resul

consulta = "select  a.pers_ncorr, " &_
           " cast(a.pers_tape_paterno as varchar)+ ' ' +cast(a.PERS_TAPE_MATERNO as varchar)+' '+cast(a.pers_tnombre as varchar) as nombre , b.sede_ccod " &_
		   "from personas a, profesores b where a.pers_ncorr=b.pers_ncorr and 1=2 order by nombre "

formu_prof.Consultar consulta


'---------------------------------------------------------------------------------------------
set f_profesores = new CFormulario
f_profesores.Carga_Parametros "edicion_plan_acad.xml", "profesores"
f_profesores.Inicializar conec_resul

'if not EsVacio(a) then
consulta = "select pers_ncorr, bloq_ccod, protic.obtener_nombre_completo(pers_ncorr, 'PM,N') as nombre_profesor, sede_ccod, a.tpro_ccod,bloq_anexo," & vbCrLf &_
		   "isnull(cast(blpr_nhoras_ayudante as varchar),'--') as horas, isnull(cast(niay_ccod as varchar),'--') as nivel," & vbCrLf &_
		   " b.tpro_tdesc + case a.tpro_ccod when 1 then case a.ebpr_ccod when 2 then ' (R)' else '' end  end  as tipo " & vbCrLf &_
		   "from bloques_profesores a,tipos_profesores  b" & vbCrLf &_
		   "where cast(bloq_ccod as varchar) = '" & a & "' and a.tpro_ccod=b.tpro_ccod"
'response.Write("<pre>"&consulta&"</pre>")
'else
'	consulta = "select distinct d.bloq_ccod, obtener_nombre_completo(d.pers_ncorr) as nombre_profesor, d.sede_ccod, d.tpro_ccod " & vbCrLf &_
'	           "from sub_secciones a, secciones b, bloques_horarios c, bloques_profesores d " & vbCrLf &_
'			   "where a.secc_ccod = b.secc_ccod " & vbCrLf &_
'			   "  and b.secc_ccod = c.secc_ccod " & vbCrLf &_
'			   "  and c.bloq_ccod = d.bloq_ccod " & vbCrLf &_
'			   "  and a.ssec_ncorr = '" & a & "'"
'end if
'response.Write("<pre>"&consulta&"</pre>")		   
f_profesores.Consultar consulta

'---------------------------------------------------------------------
set f_botonera_profesor = new CFormulario
f_botonera_profesor.Carga_Parametros "edicion_plan_acad.xml", "botonera"

f_botonera_profesor.AgregaBotonUrlParam "agregar_profesor", "bloq_ccod", a


if not b_bloque_creado then
	f_botonera_profesor.AgregaBotonParam "agregar_profesor", "deshabilitado", "TRUE"
	f_botonera_profesor.AgregaBotonParam "eliminar_profesor", "deshabilitado", "TRUE"
else
	f_botonera_profesor.AgregaBotonParam "crear_bloque", "deshabilitado", "TRUE"
end if



'------------------------------------------------------------------------------------
if Request.QueryString("accion") = "A" then
	str_boton_guardar = "nuevo"
	botonera.AgregaBotonUrlParam "nuevo", "ssec_ncorr", formu_resul.ObtenerValor("ssec_ncorr")
	botonera.AgregaBotonUrlParam "nuevo", "sede_ccod", negocio.ObtenerSede
	botonera.AgregaBotonUrlParam "nuevo", "accion", "A"
	
	if b_bloque_creado then
		formu_resul.AgregaCampoParam "dias_ccod", "permiso", "LECTURA"
		formu_resul.AgregaCampoParam "hora_ccod", "permiso", "LECTURA"
		formu_resul.AgregaCampoParam "bloq_finicio_modulo", "permiso", "LECTURA"
		formu_resul.AgregaCampoParam "bloq_ftermino_modulo", "permiso", "LECTURA"
		formu_resul.AgregaCampoParam "sala_ccod", "permiso", "LECTURA"	
	end if
else
	str_boton_guardar = "guardar"
end if


tiene_eliminados = conec_resul.consultaUno("Select count(*) from bloques_profesores where tpro_ccod=1 and isnull(ebpr_ccod,1)<> 1 and cast(bloq_ccod as varchar)='"&a&"'")

'--------------------------debemos ver si el usuario es del departamento de docencia o nop------------------------
usuario_secion = negocio.obtenerUsuario
'response.Write("select count(*) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and cast(a.pers_nrut as varchar)='"&usuario_secion&"' and srol_ncorr = 27")
de_docencia = conec_resul.consultaUno("select count(*) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and cast(a.pers_nrut as varchar)='"&usuario_secion&"' and srol_ncorr = 27")

anos_ccod = conec_resul.consultaUno("select anos_ccod from sub_secciones a, periodos_academicos b where cast(ssec_ncorr as varchar)='"&subseccion&"' and a.peri_ccod=b.peri_ccod")
'response.Write("select anos_ccod from sub_secciones a, periodos_academicos b where cast(ssec_ncorr as varchar)='"&subseccion&"' and a.peri_ccod=b.peri_ccod")
sys_cierra_planificacion = false

if de_docencia > "0"  then
	sys_cierra_planificacion = false
end if

if usuario_secion <> "8516097" and usuario_secion <> "10070749" and usuario_secion <> "8474919" and usuario_secion = "12884063" and anos_ccod <= "2008" then
	sys_cierra_planificacion = true
end if

v_dia_actual 	= 	Day(now())
v_mes_actual	= 	Month(now())
'if de_docencia = "0" and v_dia_actual <> 4 then
'	sys_cierra_planificacion = true
'end if

v_peri_ccod= Cstr(negocio.obtenerPeriodoAcademico("PLANIFICACION"))
v_peri_tdesc=conec_resul.ConsultaUno("Select peri_tdesc from periodos_academicos where peri_ccod="&v_peri_ccod)
%>


<html>
<head>
<title>Creaci&oacute;n de Planificaci&oacute;n</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript" type="text/JavaScript">
arr_salas = new Array();
<%
i_ = 0
while fc_salas.Siguiente
	%>
arr_salas[<%=i_%>] = new Array();
arr_salas[<%=i_%>]["sala_ccod"] = '<%=fc_salas.ObtenerValor("sala_ccod")%>';
arr_salas[<%=i_%>]["sala_ncupo"] = '<%=fc_salas.ObtenerValor("sala_ncupo")%>';
	<%
	i_ = i_ + 1
wend
%>


function MostrarCupos(p_sala_ccod)
{
	
	v_sala_ncupo = '';
	
	for (i = 0; i < arr_salas.length; i++) {
		if (arr_salas[i]["sala_ccod"] == p_sala_ccod) {			
			v_sala_ncupo = arr_salas[i]["sala_ncupo"];
			break;
		}
	}
	
	desc_cupos.innerText = "Esta sala tiene " + v_sala_ncupo + " cupos.";
}

function CrearBloque(formulario)
{
	formulario.action = 'actualizar_bloque.asp?accion=A';
	formulario.submit();
}

function enviar(formulario){
	formulario.action ='actualizar_bloque.asp';
	//if(preValidaFormulario(formulario)){
	  formulario.submit();
	  
	//}
	
}
function cerrar() {
	// Editado por M.R.:
	// En algunos navegadores se cerraba la sesion con estas instrucciones
	/*
	self.opener.location.reload()
	self.close();
	*/
opener.location.reload();
close();	
}


function valida(formulario) {
	formulario = document.buscador;
	nroElementos = formulario.elements.length;
	j=1;
	flag = true;
	for(i=0; i < nroElementos ; i++ ) {
		var expresion = new RegExp('(bloq_finicio_modulo|bloq_ftermino_modulo)','gi');
		if (expresion.test(formulario.elements[i].name) ) {
			switch(j%2) {
				case 1 :
					fechaInicio = formulario.elements[i].value;
					break;
				case 0 :
					fechaTermino = formulario.elements[i].value;
					if(!comparaFechas(fechaTermino,fechaInicio)) {
						flag=false;
					}
					break;
			}
			j++;
		}
	}
	if(!flag) {
		alert('Complete correctamente las fechas del formulario');
	}
	return(flag);
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
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="510" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
<form action="actualizar_bloque.asp" method="post" name="buscador">
   <input name= "pl[0][pers_ncorr]" type="hidden" value="<%=c%>" >
   <input type="hidden" name="Carrera_ocul"  value="<%=request.QueryString("Carrera_ocul")%>">
	<table width="70%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="83%">
              <tr>
              </tr>
              <tr>
                <td height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="450" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td height="17"><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="8" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="229" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Resultados de la b&uacute;squeda</font></div></td>
                      <td width="213" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td height="2"><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="450" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				   <%
				      if sys_cierra_planificacion=true then 
					   	if esvacio(bloque_prueba) then
				       		response.Write("<br/><font color='blue'>"&sys_info_cierre_planificacion&"</font><br/>") 
						end if	
					  end if
					  'response.Write(sys_cierra_semestre&"  =  "&v_peri_ccod)
					 if sys_cierra_semestre=v_peri_ccod then 
				       		response.Write("<br/><font color='blue'>"&sys_info_cierre_semestre&": "&v_peri_tdesc&"</font><br/>") 
					  end if 
					  %>

<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                      <%if tipo_permiso="1" then%>
					  <tr> 
                        <td width="3%" align="right">&nbsp;</td>
                        <td height="15" colspan="4" align="right"><font color="#FF0000">*</font> 
                          Campos obligatorios</td>
                        <td width="1%">&nbsp;</td>
                        <td width="1%">&nbsp;</td>
                      </tr>
					  <%end if%>
                      <tr> 
					     <br>
                          <center><%pagina.DibujarTituloPagina%></center>
						 <br>
                        <td align="right">&nbsp;</td>
                        <td width="31%" height="15" align="right"><font size="1"><strong>Asignatura 
                          - Secci&oacute;n</strong></font></td>
                        <td width="3%"><div align="center">:</div></td>
                        <td colspan="2"><%=formu_resul.dibujaCampo("ssec_ncorr")%><%=formu_resul.dibujaCampo("secc_ccod")%><%=formu_resul.dibujaCampo("secc_ccod_pres")%></td>
                        <td><strong> </strong></td>
                        <td>&nbsp;</td>
                      </tr>
					  <%if tipo_permiso="1" then%>
					  <%if mensaje_cambio = "" then %>
                      <tr> 
                        <td align="right"><font color="#FF0000">*</font></td>
                        <td height="25" align="right"><font size="1"><strong>D&iacute;a</strong></font></td>
                        <td nowrap><div align="center">:</div></td>
                        <td colspan="2" nowrap><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%=formu_resul.dibujaCampo("dias_ccod")%></font></td>
                        <td nowrap>&nbsp; </td>
                        <td nowrap>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td align="right"><font color="#FF0000">*</font></td>
                        <td align="right"><strong>Bloque Horario Inicio</strong></td>
                        <td><div align="center">:</div></td>
                        <td colspan="2"><%=formu_resul.dibujacampo("hora_ccod")%> <%=horas_seguidas%></td>
                        <td nowrap>&nbsp;</td>
                        <td></td>
                      </tr>
                      <tr> 
                        <td align="right"><font color="#FF0000">*</font></td>
                        <td height="25" align="right"><strong>Fecha Inicio</strong></td>
                        <td><div align="center">:</div></td>
                        <td colspan="2"><%=formu_resul.dibujacampo("bloq_finicio_modulo")%> (dd/mm/aaaa)</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td align="right"><font color="#FF0000">*</font></td>
                        <td height="25" align="right"><strong>Fecha T&eacute;rmino</strong></td>
                        <td nowrap><div align="center">:</div></td>
                        <td colspan="2" nowrap><%=formu_resul.dibujacampo("bloq_ftermino_modulo")%> (dd/mm/aaaa)</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td align="right"><font color="#FF0000">*</font></td>
                        <td height="25" align="right"><font size="1"><strong>Aula/Laboratorio/Taller</strong></font></td>
                        <td><div align="center">:</div></td>
                        <td width="34%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%=formu_resul.dibujaCampo("sala_ccod")%></font> </td>
                        <td width="27%"><font color="#FF0000"> 
                          <div id="desc_cupos">&nbsp;</div>
                          </font></td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
					  <tr> 
                        <td align="right">&nbsp;</td>
                        <td height="25" align="right"><font size="1"><strong>Destinado a</strong></font></td>
                        <td><div align="center">:</div></td>
                        <td width="34%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%=formu_resul.dibujaCampo("bloq_ayudantia")%></font> </td>
                        <td width="27%"><font color="#FF0000"> 
                          <div id="desc_cupos">&nbsp;</div>
                          </font></td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
					  <%else%>
					  <tr>
					   	  <td colspan="7" align="center">
						  	 <font face="Georgia, Times New Roman, Times, serif" size="+1" color="#0033FF"><br>El bloque horario que desea modificar, se encuentra asignado a un laboratorio o auditorium, es necesario que sea liberado por el departamento de desarrollo y tecnología para poder asignar la sala o taller correspondiente.<br></font>
						  </td>
					   </tr>
					  <%end if%>
					  <%end if%>
                      <tr> 
                        <td height="25" colspan="7" align="right">
						<%if sys_cierra_planificacion=false and mensaje_cambio="" then%>
						<div align="left">  </div>
                          <div align="right"><% if tipo_permiso="1" then 
						  							f_botonera_profesor.DibujaBoton("crear_bloque") 
						  						end if%><br>
                          </div>						  
						<%end if%>
                         <%if tipo_permiso="2" then%>
						  <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td>&nbsp;</td>
                            </tr>
                            <tr>
                              <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%=f_profesores.dibujatabla()%></font></div></td>
                            </tr>
                            <tr>
                              <td><br> 
							   <!-- cierre de planificacion de forma Global -->
							  <%if sys_cierra_planificacion=false then%>
							  <!-- cierre de planificacion para un periodo especifico -->
							  <%'response.Write(sys_cierra_semestre)
							    if sys_cierra_semestre <> v_peri_ccod then%>
								  	<table width="20%"  border="0" align="right" cellpadding="0" cellspacing="0">
									  <tr>
										<td><div align="center">
										
											<%f_botonera_profesor.DibujaBoton("agregar_profesor")%>
										</div></td>
										<td><div align="center">
											<%f_botonera_profesor.DibujaBoton("eliminar_profesor")%>
										</div></td>
									  </tr>
									</table>
								 <%end if%>
								 <%end if%>
                                <div align="right">                                </div></td></tr>
								 <%if tiene_eliminados <> "0" then %>		
								  <tr>
									<td align="left"> (R): Indica que el docente ha sido eliminado 
									</td>
								  </tr>
								  <%end if%>
                          </table>
						  <%end if%>	
							
                          <font face="Verdana, Arial, Helvetica, sans-serif" size="1"><br>
                          </font></td>
                      </tr>
                    </table>
                      <br>
                      <%formu_resul.dibujaCampo("bloq_ccod")%>
					  <input type="hidden" name="pl[0][sede_ccod]" value="<%=sede%>">
					  </div> 				  
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="202" bgcolor="#D8D8DE"><table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
					<%if sys_cierra_planificacion=false  then%>
					   <% 'response.Write(tipo_permiso)
					      if tipo_permiso="1" and mensaje_cambio="" then%>
							   <td>
							      <div align="center">
								  <%botonera.dibujaboton(str_boton_guardar)%>
							      </div>
							   </td>
						  <%end if%>
					  <%end if%>
                      <td><div align="center">
                        <%botonera.dibujaboton "salir"%>
                      </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="14" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="350" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
			</td>
        </tr>
      </table>	
     </form>
	</td>
  </tr>  
</table>
</body>
</html>

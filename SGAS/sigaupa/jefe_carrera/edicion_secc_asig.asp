<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

set conexion = new cConexion
set ftitulo = new cFormulario
set fsecc_asig = new cFormulario
set fsecc_asig_electivo = new cFormulario
set errores 	= new cErrores

set botonera = new CFormulario
botonera.carga_parametros "parametros.xml", "btn_edicion_secc_asig"
set botonera_electivo = new CFormulario
botonera_electivo.carga_parametros "electivos.xml", "botonera"


conexion.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


ftitulo.carga_parametros "parametros.xml", "4tt"
ftitulo.inicializar conexion
fsecc_asig.carga_parametros "parametros.xml", "4"
fsecc_asig.inicializar conexion

fsecc_asig_electivo.carga_parametros "buscar_asignaturas_elec.xml", "planificacion_elec"
fsecc_asig_electivo.inicializar conexion


sede_ccod = request.QueryString("sede_ccod")
peri_ccod = request.QueryString("periodo")
asig_ccod = request.QueryString("asig_ccod")
carr_ccod = request.QueryString("carr_ccod")
nive_ccod = request.QueryString("nive_ccod")
espe_ccod = request.QueryString("espe_ccod")
plan_ccod = request.QueryString("plan_ccod")
crea_seccion = TRUE
insertar_electivo = request.QueryString("insertar_electivo")
periodo_temporal = negocio.obtenerPeriodoAcademico("CLASES18")
if espe_ccod <> "" then
'response.Write("select jorn_ccod from ofertas_Academicas where cast(espe_ccod as varchar)='"&espe_ccod&"' and cast(peri_ccod as varchar)='"&periodo_temporal&"' and cast(sede_ccod as varchar)='"&sede_ccod&"'")
	jorn_ccod = conexion.consultaUno("select jorn_ccod from ofertas_Academicas where cast(espe_ccod as varchar)='"&espe_ccod&"' and cast(peri_ccod as varchar)='"&periodo_temporal&"' and cast(sede_ccod as varchar)='"&sede_ccod&"'")
	'response.write(jorn_ccod)
	if jorn_ccod= "" or EsVAcio(jorn_ccod) then
		periodo_temporal = negocio.obtenerPeriodoAcademico("PLANIFICACION")
        jorn_ccod = conexion.consultaUno("select jorn_ccod from ofertas_Academicas where cast(espe_ccod as varchar)='"&espe_ccod&"' and cast(peri_ccod as varchar)='"&periodo_temporal&"' and cast(sede_ccod as varchar)='"&sede_ccod&"'")
	end if
	filtro_jornada = " and cast(b.jorn_ccod as varchar) in ('"&jorn_ccod&"')"
	if jorn_ccod = "" or EsVAcio(jorn_ccod) then
		jorn_ccod = 1
		filtro_jornada = " and cast(b.jorn_ccod as varchar) in ('1','2')"
	end if

	if espe_ccod = "332" then
		jorn_ccod = 1
		filtro_jornada = " and cast(b.jorn_ccod as varchar) in ('1','2')"
	end if

else
	filtro_jornada = ""
end if

sql_electiva ="select cast(isnull(ASIG_ELECTIVA,0) as int) from asignaturas where cast(asig_ccod as varchar) = '"&asig_ccod&"'"
'response.Write("jorn_ccod "&jorn_ccod)

electiva = conexion.consultauno(sql_electiva)

	sql_malla = "select mall_ccod " & _
			" from malla_curricular " & _
			" where cast(asig_ccod as varchar)  = '"&asig_ccod&"'  " & _
			" and cast(plan_ccod as varchar) ='"&plan_ccod&"' " & _
			" and cast(nive_ccod as varchar) ='"&nive_ccod&"' "

	mall_ccod = conexion.consultauno(sql_malla)
	'response.Write(sql_malla)
'if 	EsVacio(session("mall_ccod")) then
'	session("mall_ccod")=mall_ccod
'end if

if electiva = 1 then
	crea_seccion = TRUE'forzado por el momento
	session("electivo_malla") =asig_ccod
	session("mall_ccod")=mall_ccod
end if
accion = "subsecciones.asp?sede_ccod=" & sede_ccod & "&peri_ccod=" & peri_ccod & "&asig_ccod=" & asig_ccod & "&carr_ccod=" & carr_ccod & "&nive_ccod=" & nive_ccod & "&espe_ccod=" & espe_ccod & "&plan_ccod=" & plan_ccod
if crea_seccion = TRUE then
			consulta = ""& vbCrLf & _
						 "select case b.jorn_ccod when 2 then 																"& vbCrLf & _
						 "cast(REPLACE(secc_tdesc, ' - - (V)', '') as int) 										"& vbCrLf & _
						 "else 																																"& vbCrLf & _
						 "cast(REPLACE(secc_tdesc, ' - - (D)', '') as int) 										"& vbCrLf & _
						 "end																																	"& vbCrLf & _
						 "as orden,																														"& vbCrLf & _
						 "		 		 Isnull(b.secc_ccod,0) AS secc_ccod_paso,                   "& vbCrLf & _
						 "         a.asig_ccod,                                               "& vbCrLf & _
						 "         a.asig_tdesc,                                              "& vbCrLf & _
						 "         c.ssec_ncorr,                                              "& vbCrLf & _
						 "         'Editar' AS subsecciones ,                                 "& vbCrLf & _
						 "         b.*                                                        "& vbCrLf & _
						 "FROM     asignaturas a,                                             "& vbCrLf & _
						 "         secciones b,                                               "& vbCrLf & _
						 "         sub_secciones c                                            "& vbCrLf & _
						 "WHERE    a.asig_ccod=b.asig_ccod                                    "& vbCrLf & _
						 "AND      b.secc_ccod=c.secc_ccod "&filtro_jornada&"                 "& vbCrLf & _
						 "AND      b.sede_ccod=" & sede_ccod &"                               "& vbCrLf & _
						 "AND      cast(b.asig_ccod AS varchar)='"& asig_ccod &"'             "& vbCrLf & _
						 "AND      b.peri_ccod=" & peri_ccod  & "                             "& vbCrLf & _
						 "AND      c.tsse_ccod=1                                              "& vbCrLf & _
						 "AND      cast(b.carr_ccod AS varchar)='"& carr_ccod &"'             "& vbCrLf & _
						 "AND      secc_finicio_sec IS NOT NULL                               "& vbCrLf & _
						 "AND      secc_ftermino_sec IS NOT NULL                              "& vbCrLf & _
						 "ORDER BY orden ASC                                                  "

			'response.Write("<pre>"&consulta&"</pre>")
			fsecc_asig.consultar consulta

else
			consulta = "select  case  when a.carr_ccod = '"&carr_ccod&"' " & vbCrLf & _
					   " then "  & vbCrLf & _
						"   'Asignatura Libre' "  & vbCrLf & _
						" else "  & vbCrLf & _
						"   ' Asignatura Otro Plan' "  & vbCrLf & _
						" end as asig_elctiva, "  & vbCrLf & _
						" a.secc_ccod,cast(c.asig_ccod as varchar)+'<br>'+cast(c.asig_tdesc as varchar)+' Sec '+ cast(secc_tdesc as varchar) as asignatura,secc_ncupo,secc_nquorum,  "  & vbCrLf & _
						" SECC_FINICIO_SEC, SECC_FTERMINO_SEC,jorn_tdesc  "  & vbCrLf & _
						" from secciones a, jornadas b,asignaturas c  "  & vbCrLf & _
						" where a.jorn_ccod = b.jorn_ccod   "  & vbCrLf & _
						" and a.asig_ccod = c.asig_ccod  "  & vbCrLf & _
						" and cast(a.sede_ccod as varchar) = '"&sede_ccod&"'"  & vbCrLf & _
						" and secc_ccod in (select secc_ccod  "  & vbCrLf & _
						" 	  			   from electivos "  & vbCrLf & _
						"				   where cast(asig_ccod as varchar) ='"&session("electivo_malla")&"' "  & vbCrLf & _
						"				   and cast(mall_ccod as varchar) ='"&session("mall_ccod")&"') "

			fsecc_asig_electivo.consultar consulta


end if
'	response.Write("<pre>"&consulta&"</pre>")
			consulta_titulo = "Select (select carr_tdesc from carreras where cast(carr_ccod as varchar)='" & carr_ccod & "') as carr_tdesc," & _
							  "       (select asig_ccod  from asignaturas where cast(asig_ccod as varchar)='" & asig_ccod & "') as asig_ccod, " & _
							  "		  (select asig_tdesc from asignaturas where cast(asig_ccod as varchar)='" & asig_ccod & "') as asig_tdesc "


			ftitulo.consultar consulta_titulo

			ftitulo.siguiente


'-------------------------------------------------------------------------------------------------------
sql_jornadas = "select jorn_ccod, jorn_tdesc_corta from jornadas"

fsecc_asig.primero
fila=0
while fsecc_asig.siguiente
	if fsecc_asig.obtenerValor("moda_ccod") = "1" then
		fsecc_asig.AgregaCampoFilaParam fila,"secc_nhoras_pagar", "deshabilitado","TRUE"
	end if
	fila=fila+1
wend
fsecc_asig.primero
cantidad_filas = fila
'--------------------------debemos ver si el usuario es del departamento de docencia o nop------------------------
usuario_secion = negocio.obtenerUsuario
'response.Write("select count(*) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and cast(a.pers_nrut as varchar)='"&usuario_secion&"' and srol_ncorr = 27")
de_docencia = conexion.consultaUno("select count(*) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and cast(a.pers_nrut as varchar)='"&usuario_secion&"' and srol_ncorr = 27")

if de_docencia > "0" then
	sys_cierra_planificacion = false
end if
sys_cierra_planificacion = true
if usuario_secion = "8516097" or usuario_secion = "10070749" or usuario_secion = "16371641" or usuario_secion = "8409343" or usuario_secion = "14022852" OR usuario_secion = "9242221" or usuario_secion ="8685670" or usuario_secion = "15740666" then
	'response.write "okokok"
	sys_cierra_planificacion = false
end if



'--------------------------validar si es una carrera de musica------------------------
asig_musica = conexion.consultaUno("select count(*) from asignaturas where ASIG_TDESC like '%INSTRUMENTO%MUSICAL%' and cast(asig_ccod as varchar)='" & asig_ccod & "'")
'response.write(asig_musica)
%>


<html>
<head>
<title>Detalle Secciones Asignatura</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<%pagina.GeneraDiccionarioJSClave sql_jornadas, "jorn_ccod", conexion, "d_jornadas"%>

<script language="JavaScript" type="text/JavaScript">
function corregir(nombre,valor)
{var indice;
     indice= extrae_indice(nombre)
	if (valor!=1){
		document.buscador.elements["esec["+indice+"][secc_nhoras_pagar]"].disabled=false;
	}
	else {
		document.buscador.elements["esec["+indice+"][secc_nhoras_pagar]"].disabled=true;
	}

}

function eliminar(formulario){
//alert("sdfsdf")
}
function crearelectivo(){
url = "busca_asignaturas_elec.asp?sede_ccod="+'<%=sede_ccod%>'+"&asig_ccod="+'<%=asig_ccod%>'+"&carr_ccod="+'<%=carr_ccod%>'+"&periodo="+'<%=peri_ccod%>'+"&nive_ccod="+'<%=nive_ccod%>'+"&plan_ccod="+'<%=plan_ccod%>'+"&espe_ccod="+'<%=espe_ccod%>'
//alert(url)
window.navigate(url)
}
function crearelectivo_2(){
url = "busca_asignaturas_elec_2.asp?sede_ccod="+'<%=sede_ccod%>'+"&asig_ccod="+'<%=asig_ccod%>'+"&carr_ccod="+'<%=carr_ccod%>'+"&periodo="+'<%=peri_ccod%>'+"&nive_ccod="+'<%=nive_ccod%>'+"&plan_ccod="+'<%=plan_ccod%>'+"&espe_ccod="+'<%=espe_ccod%>'
//alert(url)
window.navigate(url)
}


function validarJornada(){
	formulario = document.buscador;
	var num_elementos=formulario.length;
	var contador_d = 0
	var contador_v = 0
	var modifica_d = 0
	var modifica_v = 0
	contar_asig_musica = "<%=asig_musica%>"
	peri_correcion = "<%=peri_ccod%>"
	espec_ccod = "<%=espe_ccod%>"

if (peri_correcion >="240"){
if (contar_asig_musica == "0" ){
if (espec_ccod != "230"){

	for (i=0;i < num_elementos;i++){
		var numeroE= new RegExp("([0-9]+)","gi");
		var campoJornadaE = new RegExp("(jorn_ccod)","gi");
		var campoSeccT = new RegExp("(secc_tdesc)","gi");
		nombre = formulario.elements[i].name;

		if ((numeroA=numeroE.exec(nombre))!=null){
					nro = numeroA[1];
			}

		if (campoSeccT.test(nombre)){
			conta_sec = formulario.elements[i].value;
			var contador_seccion = conta_sec.slice(0, 1);
		}
		if (campoJornadaE.test(nombre)){
			//alert (formulario.elements["esec[2][jorn_ccod]"].value)
			if(formulario.elements[i].checked) {
				jorn_ccod_value = 	formulario.elements[i].value
				if 	(jorn_ccod_value == 1){
					contador_d = contador_d + 1;
					//alert ("Diurno  "+formulario.elements[i].value)
					//alert ("Diurno Contador "+contador_d+"  contador_seccion : "+contador_seccion)
					if (contador_d != contador_seccion){
						//alert("modifica")
						modifica_d = contador_d+ " - - (D)"
						//alert ("modifica_d"+ modifica_d +"      nro     "+  nro)
						document.buscador.elements["esec["+nro+"][secc_tdesc]"].value=modifica_d;
					}
				} else if 	(jorn_ccod_value == 2){
					contador_v = contador_v + 1;
					//alert ("Vespe  "+formulario.elements[i].value)
					//alert ("Vespe Contador "+contador_v+"  contador_seccion : "+contador_seccion)
					if (contador_v != contador_seccion){
						modifica_v = contador_v+ " - - (V)"
						document.buscador.elements["esec["+nro+"][secc_tdesc]"].value=modifica_v;
					}
				}
			}
		}
	}
}
}
}
}


function subsecciones(seccion) {
	formulario = document.forms[0];

	formulario.action = "<%= accion %>&secc_ccod=" + seccion;
	formulario.submit();
}

function compara(formulario)
{
	var num_elementos=formulario.length;
	nro=null;
	filaAnterior=null;
	flag=true;
	for (i=0;i < num_elementos;i++){
		var numeroE= new RegExp("([0-9]+)","gi");
		var campoCupoE= new RegExp("secc_ncupo","gi");
		var campoQuorumE= new RegExp("(secc_nquorum)","gi");
		var campoJornadaE = new RegExp("(jorn_ccod)","gi");
		nombre = formulario.elements[i].name;
		if ((numeroA=numeroE.exec(nombre))!=null){
				nro = numeroA[1];
		}
		if (campoCupoE.test(nombre)){
				cupo = formulario.elements[i].value;
			}
		 if (campoQuorumE.test(nombre)){
			quorum = formulario.elements[i].value;
			if (quorum >= 0) {
				if(cupo<quorum){
					alert("Existe un cupo menor que la cantidad mínima de alumnos")
					return (false);
				}
			}
			else{
				alert('Ingrese un número mayor o igual a 0');
				return (false);
			}
		}
			filaActual = nro;
			if ( filaActual != filaAnterior ){
				if (filaAnterior != null  && !flag ) {
					return (flag);
				}
				flag=false;
				filaAnterior = filaActual;
			}
			if (campoJornadaE.test(nombre)){
				if(formulario.elements[i].checked) {
					flag = true;
				}
			}
		}
		if (num_elementos>4){
			if (!flag){
				alert('Complete la jornada');
			}
	   }
	return (flag);
}
function salir(){
				self.opener.location.reload()
				self.close();

}
function cerrarVentana() {

	if (preValidaFormulario(document.buscador)){
		if(valida(document.buscador)){
			if(compara(document.buscador)){
				self.opener.location.reload()
				self.close();
				return (true);
			}
		}
	}
	return (false);
}

function modificar(formulario){
	if(preValidaFormulario(document.buscador)){
		   if(compara(formulario)){
				return(valida(document.buscador));
			}
	}
	return (false);
}

function proc_btn_clickeado(formulario,boton){
	//alert(formulario.name);
	formulario.btn_clickeado.value = boton;
	if (boton != '3'){
	  if(modificar(formulario)){
	  formulario.submit();
	  }
	 }
	else{
	 formulario.submit();
	}
}



function valida(formulario) {
	nroElementos = formulario.elements.length;
	j=1;
	flag = true;
		for(i=0; i < nroElementos ; i++ ) {
			var expresion = new RegExp('(secc_finicio|secc_ftermino)','gi');
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


function CompletarJornTDesc(p_fila)
{
	var formulario = document.forms["buscador"];
	var o_secc_tdesc = formulario.elements["esec[" + p_fila + "][secc_tdesc]"];
	var v_secc_tdesc = o_secc_tdesc.value;
	var v_jorn_ccod = getRadioValue(formulario.elements["esec[" + p_fila + "][jorn_ccod]"]);
	var v_jorn_tdesc_aux;


	if (v_secc_tdesc.search(/\(.\)$/) < 0) {
		o_secc_tdesc.value = v_secc_tdesc + " (" + d_jornadas.Item(v_jorn_ccod).Item("jorn_tdesc_corta") + ")";
	}
	else {
		o_secc_tdesc.value = v_secc_tdesc.replace(/\(.+\)$/, "(" + d_jornadas.Item(v_jorn_ccod).Item("jorn_tdesc_corta") + ")");
	}
}


function jorn_ccod_click(objeto)
{
	var fila = _FilaCampo(objeto);
	CompletarJornTDesc(fila);
}

</script>

</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="validarJornada();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();validarJornada();" onclick="validarJornada()">
<table width="628" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
			<form action="proc_secc.asp" method="post" name="buscador" >
				<table width="82%" border="0" align="center" cellpadding="0" cellspacing="0">
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
									<%if sys_cierra_planificacion=false then response.Write(sys_info_cierre_planificacion) end if%>

									<input type="hidden" name="sede_ccod" value="<%= sede_ccod%>">
									<input type="hidden" name="peri_ccod" value="<%= peri_ccod%>">
									<input type="hidden" name="asig_ccod" value="<%= asig_ccod%>">
									<input type="hidden" name="carr_ccod" value="<%= carr_ccod%>">
									<input type="hidden" name="asig_ccod_electiva" value="<%= session("electivo_malla")%>">
									<input type="hidden" name="mall_ccod_electiva" value="<%= session("mall_ccod")%>">
									<input type="hidden" name="mall_ccod_asignatura" value="<%= mall_ccod%>">
									<input type="hidden" name="insertar_electivo" value="<%= insertar_electivo%>">
									<input type="hidden" name="jornada_fija" value="<%=jorn_ccod%>">
									<input type="hidden" name="btn_clickeado" value="">
									<br>
									<%if sys_cierra_planificacion=true then response.Write("<br/><font color='blue'>"&sys_info_cierre_planificacion&"</font><br/>") end if%>

									<table border="0" align="center" cellpadding="0" cellspacing="0">
										<tr>
											<td align="right" >
												<% ftitulo.dibujaEtiqueta("carr_tdesc") %>
												: </td>
												<td > <strong>
													<% ftitulo.dibujaCampo("carr_tdesc") %>
												</strong> </td>
											</tr>
											<tr>
												<td align="right"><% ftitulo.dibujaEtiqueta("asig_ccod") %> : </td>
												<td> <strong> <% ftitulo.dibujaCampo("asig_ccod") %>  -  <% ftitulo.dibujaCampo("asig_tdesc") %> </strong> </td>
												<td align="right">&nbsp;</td>
											</tr>
											<tr>
												<td colspan="2">&nbsp;</td>
												<td align="right"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong>
													Pagina <%fsecc_asig.accesoPagina %></strong></font></td>
												</tr>
											</table>
											<font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><strong><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><br>
											</b></font></strong></font></strong><b> </b></font></strong></font></strong></font></strong></font></strong></font>
											<table width="98%" height="200" border="0" align="center" cellpadding="0" cellspacing="0">
												<tr>
													<td align="center" valign="top">
													<%
														if crea_seccion = true then
															fsecc_asig.dibujaTabla ' esta es la que dibuja la tabla
														else
															fsecc_asig_electivo.dibujatabla()
														end if
													%>
														<br><br>
														<%if crea_seccion = FALSE then%>
														<table width="90%"  border="0">
															<tr>
																<td colspan="4">La asignatura <strong>
																	<% ftitulo.dibujaCampo("asig_ccod") %>
																	-
																	<% ftitulo.dibujaCampo("asig_tdesc") %>
																</strong>es una asignatura electiva del programa de estudio <strong>
																<% ftitulo.dibujaCampo("carr_tdesc") %>
																.
															</strong></td>
														</tr>
														<tr>
															<td colspan="4">Para poder asociar una <em><strong>&quot;Asignatura que ya pertenece a un plan de estudio &quot;</strong></em> a este Electivo hacer click en el bot&oacute;n <em><strong>&quot;Asociar Asignatura Otro Plan&quot; </strong></em></td>
														</tr>
														<tr>
															<td height="28" colspan="4">Para poder asociar una <em><strong>&quot;Asignatura que no pertenece a ningun plan de estudio &quot;</strong></em> a este Electivo hacer click en el bot&oacute;n <em><strong>&quot;Asociar Asignatura Libre&quot; </strong></em></td>
														</tr>
														<tr>
															<td width="34%"><div align="right">
																<%botonera_electivo.dibujaboton "Asociar"%>
															</div></td>
															<td width="24%"><div align="right">
																<%botonera_electivo.dibujaboton "planificar"%>
															</div></td>
															<td width="22%"><div align="right">
																<%botonera_electivo.dibujaboton "eliminar"%>
															</div></td>
															<td width="20%"><%botonera_electivo.dibujaboton "salir"%></td>
														</tr>
													</table>
													<%end if%>
												</td>
											</tr>
										</table><%if crea_seccion = true then%>
										<table width="96%" border="0" align="center" cellpadding="0" cellspacing="0">
											<tr>
												<td align="left"><p>Para agregar una secci&oacute;n a la
													asignatura pre-seleccionada haga clic en el bot&oacute;n &quot;Agregar&quot;.<br>
													Si ha realizado cambios en la definici&oacute;n de
													las secciones haga clic en el bot&oacute;n &quot;Guardar&quot;
													para actualizar los datos.<br>
													Para eliminar una secci&oacute;n, seleccionela en
													la caja de chequeo y haga clic en el bot&oacute;n
													&quot;Eliminar&quot;.<br>
													<br>
												</p>
											</td>
										</tr>
										<tr>
											<td align="right"><table width="100%" cellspacing="0" cellpadding="0">
												<tr>
													<td align="right">&nbsp; </td>
												</tr>
											</table>
										</td>
									</tr>
								</table><%end if%>
								<br>				  </td>
								<td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
							</tr>
						</table>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
								<td width="237" bgcolor="#D8D8DE"><%if crea_seccion = TRUE then %><table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
									<tr>
										<%if sys_cierra_planificacion=false then%>
										<td><div align="center">
											<%botonera.dibujaboton "eliminar"%>
										</div>
									</td>
									<td><div align="center">
										<% if cantidad_filas = 0 then
										botonera.agregaBotonParam "guardar", "deshabilitado","true"
										end if
										botonera.dibujaboton "guardar"%>
									</div>
								</td>
								<td><div align="center">
									<%botonera.dibujaboton "agregar"%>
								</div>
							</td>
							<%end if%>
							<td><div align="center">
								<%botonera.dibujaboton "salir"%>
							</div>
						</td>
					</tr>
				</table><%end if%>
			</td>
			<td width="125" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
			<td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
		</tr>
		<tr>
			<td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
		</tr>
	</table>

</td>
</tr>
</table>
</form>
  </td>
 </tr>
</table>
</body>
</html>

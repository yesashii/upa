<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_encuesta_dir_docente_rr_hh.asp"-->

<%

'---------------------------------------------------------------------------------------------------
'set pagina = new CPagina
'pagina.Titulo = "Encuesta Así soy yo"
'---------------------------------------------------------------------------------------------------
secc_ccod=request.QueryString("secc")
pers_ncorr=request.QueryString("pers_ncorr")
carr_ccod=request.QueryString("carr_ccod")
'secc_ccod=request.Form("secc")
set conexion = new CConexion
conexion.Inicializar "upacifico"
'
set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "encuesta_docente_rr_hh.xml", "botonera"

set f_docentes = new CFormulario
f_docentes.Carga_Parametros "tabla_vacia.xml", "tabla"
f_docentes.Inicializar conexion
'/*****************************************************************************************************************************
q_pers_nrut=negocio.obtenerUsuario
'para la variable peri_ccod si es el 1 semestre se escribe el codigo correspondiente , si el el 2° sem debe colocarse el codigo del 2° sem y el 3 trimestre separado por una 
'coma  ej. 220,221 
'peri_ccod= conexion.consultaUno("select peri_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
peri_ccod = "238"


pers_ncorr=conexion.ConsultaUno("select protic.obtener_pers_ncorr("&q_pers_nrut&")")
nombre=conexion.ConsultaUno("select pers_tnombre+' '+pers_tape_paterno from personas where pers_nrut="&q_pers_nrut&"")
peri=conexion.ConsultaUno("select peri_tdesc from periodos_academicos where peri_ccod="&peri_ccod&"") 
if pers_ncorr_q <>"" then
pers_ncorr=pers_ncorr_q
end if
'consulta = " select ''" 
		   
'response.Write("peri "&peri&"<br>")		   

'response.Write("<pre>"&consulta&"</pre>")
'response.End()
'f_encabezado.Consultar consulta
'f_encabezado.Siguiente

'peri_ccod = 1
'pers_ncorr=23921
consulta ="select protic.obtener_codigo_carreras_con_clases("&pers_ncorr&","&peri_ccod&")" 
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
carr_ccod=conexion.ConsultaUno(consulta)
'response.Write(carr_ccod)

if carr_ccod = "" then
	carr_ccod = 0
end if

sedes_filtro = "1,4,9"
'/*****************************************************************************************************************************

consulta_sec ="select d.pers_ncorr,pers_tape_paterno+' '+pers_tnombre as nombre from asignaturas a, secciones b, bloques_horarios c, bloques_profesores d,carreras e,personas f"& vbCrLf &_
"where a.asig_ccod=b.asig_ccod"& vbCrLf &_
"and b.secc_ccod=c.secc_ccod"& vbCrLf &_
"and b.peri_ccod in ("&peri_ccod&")"& vbCrLf &_
"and c.bloq_ccod=d.bloq_ccod"& vbCrLf &_
"and b.carr_ccod in ("&carr_ccod&")"& vbCrLf &_
"and b.carr_ccod=e.carr_ccod"& vbCrLf &_
"and d.pers_ncorr=f.pers_ncorr"& vbCrLf &_
"and b.sede_ccod in ("&sedes_filtro&") "& vbCrLf &_
"and tpro_ccod=1"& vbCrLf &_
"group by d.pers_ncorr,pers_tnombre,pers_tape_paterno order by nombre"

'response.Write("1: "&consulta_sec)
'response.End()
f_docentes.Consultar consulta_sec

nro_profes = f_docentes.nroFilas

Dim arr_pers_ncorr_prof()
Dim arr_nombre_prof()
Dim arr_pers_ncorr_prof_rezagado()
Dim arr_nombre_prof_rezagado()

f_docentes.primero

Redim arr_pers_ncorr_prof(nro_profes)
Redim arr_nombre_prof(nro_profes)
'response.Write(nro_profes)
se_va = 0
se_queda = 0
j = 0

'Antes de llenar arreglos pregunto si existen profesores a evaluar
if nro_profes = 0 then
	Response.Redirect("encuesta_2015_fin.asp?origen=1")
end if
'----------------------------

for i=1 to nro_profes
	f_docentes.siguiente
	arr_pers_ncorr_prof(i-1)	=	f_docentes.Obtenervalor("pers_ncorr")
	arr_nombre_prof(i-1)		=	f_docentes.Obtenervalor("nombre")
	
	'response.Write(arr_nombre_prof(i)&"<br>")
	
	realizo_encuesta = conexion.consultaUno("select distinct peri_ccod from evaluacion_docente_directores_2015 where peri_ccod="&peri_ccod&" and pers_ncorr_prof="&arr_pers_ncorr_prof(i-1)&" and pers_ncorr_dir="&pers_ncorr&"")
	
	if realizo_encuesta <> "" then
		'response.Write("<pre>"&realizo_encuesta&"<pre>")
		se_va = se_va+1

	else
	
	Redim preserve arr_pers_ncorr_prof_rezagado(j)
	Redim preserve arr_nombre_prof_rezagado(j)	
		se_queda = se_queda+1
		
		arr_pers_ncorr_prof_rezagado(j)	=	arr_pers_ncorr_prof(i-1)
		arr_nombre_prof_rezagado(j)		=	arr_nombre_prof(i-1)
		j=j+1
	end if
next

if se_va > 0 and se_queda = 0 then
	Response.Redirect("encuesta_2015_fin.asp?origen=1")
end if


%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>- Encuesta Universidad del Pac&iacute;fico</title>
<style type="text/css">
<!--
.Estilo25 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
}
body {
	background-color: #dae4fa;
}
.Estilo26 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10pt;
}
.Estilo27 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10pt;
	font-weight: bold;
	color: #FF7F00;
}
.Estilo31 {
	font-size: 10pt;
	font-family: Arial, Helvetica, sans-serif;
}
.Estilo34 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bold; }
.Estilo35 {
	font-weight: bold;
	font-size: 12px;
	font-style: italic;
	color: #000000;
}
.Estilo36 {font-family: Arial, Helvetica, sans-serif; font-size: 10pt; font-style: italic; }
.Estilo37 {font-family: Arial, Helvetica, sans-serif; font-size: 10pt; font-style: italic; font-weight: bold; }
.Estilo42 {font-size: 10pt; color: #000000; font-family: Arial, Helvetica, sans-serif;}
.Estilo43 {font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #333333; }
.Estilo45 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; }
.Estilo46 {
	color: #FF6600;
	font-weight: bold;
}
-->
</style>

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function cambio(elemento){
	//var arSelected = new Array();
	
	document.getElementById(elemento.id).style.color="black";

}
function volver()
{
	confirma = confirm("Desea salir sin guardar la encuesta?");
	
	if (confirma == true){
	   location.href = "portada_encuesta.asp";
	}
}

function validar_ingreso(){
	
	/*if (valida_caracter(document.edicion.observaciones)){
		envio=true;	
	}
	else{
		envio=false;
		msj	= "No puedes ingresar el caracter Comilla Simple en tu respuesta.";	
	}
	*/
	envio = true;
	var rezagados = <%=se_queda%>;
	var profesor = <%=nro_profes%>;
	//var envio = true;
	//alert(profesor);
	if(rezagados>0){
		profesor = rezagados;
	}
	
	for(var i=1;i<=profesor;i++)
	{
		for(var j=1;j<12;j++)
		{
			//alert(document.getElementById("nota["+j+"]["+i+"]").value);
			if(document.getElementById("nota["+j+"]["+i+"]").value)
			{}
			else
			{
				document.getElementById("nota["+j+"]["+i+"]").style.color="red";
				envio = false;
				msj	= "Debe responder todas las preguntas antes de grabar,\n aún faltan preguntas por contestar.";
			}
		}
	}
	//alert(j);
	if (envio == false) {
		alert(msj);
	}
	else
	{
		document.edicion.submit();	
	}
}

</script>
</head>

<body>
<!--<p align="center" class="Estilo35">&quot;Encuesta Egresados de RR PP&quot;</p>-->
<table width="100%" border="0">
  <tr valign="top">
<td width="100%" align="center">
<form name="edicion" action="responder_encuesta_2015.asp" method="post">
<input type="hidden" name="pers_ncorr" value="<%=pers_ncorr%>">
<input type="hidden" name="peri_ccod" value="<%=peri_ccod%>">
<input type="hidden" name="carr_ccod" value="<%=carr_ccod%>">
<table width="700" border="0" cellpadding="0" cellspacing="0">

<tr>
	<td width="25" height="24" background="images/lado_izquierda.jpg" align="right"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>
	<td width="646" height="24" background="images/borde_superior.jpg">&nbsp;</td>
	<td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>
</tr>
<tr>
    <td width="25" background="images/lado_izquierda.jpg" align="right">&nbsp;</td>
	<td bgcolor="#FFFFFF" aling="left" width="646">
		<table width="763" border="0" align="left" cellpadding="10" cellspacing="10" bgcolor="#FFFFFF">
		  <tr>
		  
			<td width="723" align="left">
				<table width="298">
					<tr>
						<td align="center">
							<p class="Estilo35">VICERRECTORÍA ACADÉMCIA DIRECCIÓN DE DOCENCIA</p>
						</td>
					</tr>
				</table>
				<table width="654">
					<tr>
						<td align="center">
							<p class="Estilo35">CUESTIONARIO DE AUTO EVALUACIÓN DOCENTE</p>
						</td>
					</tr>
				</table>
					<br />
					<table width="90%" border="0" bgcolor="#FFFFFF">
					  <tr>
                    <td class="Estilo31">Estimado(a)  director(a):</td>
                   </tr>
                  <tr>
                    <td class="Estilo31"><p>El  siguiente instrumento tiene como prop&oacute;sito recoger informaci&oacute;n sobre la  percepci&oacute;n que usted tiene sobre el&nbsp;  desempe&ntilde;o de cada uno de los docentes que desarrollan docencia en la  carrera.&nbsp; Esta informaci&oacute;n es muy  relevante y servir&aacute; para retroalimentar la labor docente. </p>
La  pauta de evaluaci&oacute;n, consta de cuatro dimensiones, que se desprenden de la  evaluaci&oacute;n institucional: Preparaci&oacute;n de la ense&ntilde;anza, responsabilidad y  compromiso con la carrera, relaci&oacute;n entre profesores y estudiantes; y proceso  de evaluaci&oacute;n. </td>
                   </tr>
				  <tr>
                    <td class="Estilo31"><p>Al t&eacute;rmino de la pauta encontrar&aacute; un  apartado para consignar diferencias entre asignaturas de un mismo docente (si  fuese necesario). </p>
                      <table border="1" cellspacing="0" cellpadding="0">
                        <tr>
                          <td class="Estilo31" valign="top"><br />
                            <strong>Puntajes &nbsp;</strong></td>
                          <td class="Estilo31" valign="top"><p><strong>Niveles de desempe&ntilde;o </strong></p></td>
                        </tr>
                        <tr>
                          <td class="Estilo31" valign="top"><p><strong>4</strong></p></td>
                          <td class="Estilo31" valign="top"><p><strong>Destacado: </strong>Alcanza el    criterio con un excelente nivel de calidad. </p></td>
                        </tr>
                        <tr>
                          <td class="Estilo31" valign="top"><p><strong>3</strong></p></td>
                          <td class="Estilo31" valign="top"><p><strong>Logrado:</strong> Alcanza el    criterio con un buen nivel de calidad. </p></td>
                        </tr>
                        <tr>
                          <td class="Estilo31" valign="top"><p><strong>2</strong></p></td>
                          <td class="Estilo31" valign="top"><p><strong>Medianamente logrado:</strong> Tiene aspectos    por mejorar de su desempe&ntilde;o. </p></td>
                        </tr>
                        <tr>
                          <td class="Estilo31" valign="top"><p>1</p></td>
                          <td class="Estilo31" valign="top"><p><strong>No logrado:</strong> No alcanza el    criterio. </p></td>
                        </tr>
                        <tr>
                          <td class="Estilo31" valign="top"><p><strong>N/O</strong></p></td>
                          <td class="Estilo31" valign="top"><p>No    observado </p></td>
                        </tr>
                      </table></td>
                   </tr>
			      </table>
				  <br />
					<hr align="left" width="100%" size="1" noshade="noshade" />
			<br />
			 
				<table width="100%" border="1" cellpadding="0" cellspacing="0">
				  <tr align="center">
				  		<td width="264"><strong>Dimensi&oacute;n:  Preparaci&oacute;n de la ense&ntilde;anza </strong></td>
                        <% for i=0 to ubound(arr_pers_ncorr_prof_rezagado) %>
                 <input type="hidden" name="arr_pers_ncorr_prof" value="<%=arr_pers_ncorr_prof_rezagado(i)%>">
                 
				  		<td width="102"><div class="Estilo25">
                           	<%=arr_nombre_prof_rezagado(i)%>
						</div>
                        </td>
                        <%next%>
					  </tr>
				  <tr align="justify">
				  		<td width="264" align="justify">1.  El programa de la asignatura  se evidencian en el cronograma.  </td>
                        <% for i=0 to ubound(arr_pers_ncorr_prof_rezagado) %>
				  		<td width="102" align="center">
                        <select id="nota[1][<%=i+1%>]" name="nota[1][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                          </select>
                        </td>
                        <%next%>
					  </tr>
				  <tr align="justify">
				  		<td width="264" align="justify">2.  Para la elaboraci&oacute;n del cronograma son  considerados los descriptores del perfil de egreso presentes en el programa de  asignatura. </td>
				  		 <% for i=0 to ubound(arr_pers_ncorr_prof_rezagado) %>
				  		<td width="102" align="center">
                        <select id="nota[2][<%=i+1%>]" name="nota[2][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                          </select>
                        </td>
                        <%next%>
					  </tr>
				  <tr align="justify">
				  		<td width="264" align="justify">3. El cronograma de asignatura se basa en el  enfoque del Modelo educativo&nbsp; para  establecer las metodolog&iacute;as del curso y la evaluaci&oacute;n. </td>
				  		 <% for i=0 to ubound(arr_pers_ncorr_prof_rezagado) %>
				  		<td width="102" align="center">
                        <select id="nota[3][<%=i+1%>]" name="nota[3][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                          </select>
                        </td>
                        <%next%>
					  </tr>
			  
				  <tr align="center">
				  		<td width="267"><strong>Dimensi&oacute;n:  Responsabilidad y compromiso con la carrera. </strong></td>
				  		<td width="102"></td>
					  </tr>
				  <tr align="justify">
				  		<td width="267" align="justify">4.  Participa activamente en consejo de escuela, en  comit&eacute;s o en comisiones de trabajo.</td>
				  		<% for i=0 to ubound(arr_pers_ncorr_prof_rezagado) %>
				  		<td width="102" align="center">
                        <select id="nota[4][<%=i+1%>]" name="nota[4][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                          </select>
                        </td>
                        <%next%>
					  </tr>
				  <tr align="justify">
				  		<td width="267" align="justify">5. Asiste a las reuniones docentes citadas por el  director y/o jefe de carrera. </td>
				  		<% for i=0 to ubound(arr_pers_ncorr_prof_rezagado) %>
				  		<td width="102" align="center">
                        <select id="nota[5][<%=i+1%>]" name="nota[5][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                          </select>
                        </td>
                        <%next%>
					  </tr>
				  <tr align="justify">
				  		<td width="267" align="justify">6.  Participa de cursos o talleres de  perfeccionamiento disciplinar o pedag&oacute;gico. </td>
				  		<% for i=0 to ubound(arr_pers_ncorr_prof_rezagado) %>
				  		<td width="102" align="center">
                        <select id="nota[6][<%=i+1%>]" name="nota[6][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                          </select>
                        </td>
                        <%next%>
					  </tr>
			 
				  <tr align="center">
				    <td width="267"><strong>Dimensi&oacute;n:  Relaci&oacute;n entre profesores y estudiantes.</strong></td>
				    <td width="102"></td>
				    </tr>
				  <tr align="justify">
				    <td width="267" align="justify">7.  El docente mantiene relaciones de confianza y  respeto con los estudiantes.</td>
				    <% for i=0 to ubound(arr_pers_ncorr_prof_rezagado) %>
				  		<td width="102" align="center">
                        <select id="nota[7][<%=i+1%>]" name="nota[7][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                          </select>
                        </td>
                        <%next%>
				    </tr>
				  <tr align="justify">
				    <td width="267" align="justify">8. El docente demuestra disposici&oacute;n para responder  inquietudes de los estudiantes. </td>
				    <% for i=0 to ubound(arr_pers_ncorr_prof_rezagado) %>
				  		<td width="102" align="center">
                        <select id="nota[8][<%=i+1%>]" name="nota[8][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                          </select>
                        </td>
                        <%next%>
				    </tr>
				 
			 	  <tr align="center">
			 	    <td width="267"><strong>Dimensi&oacute;n:  Proceso de Evaluaci&oacute;n. </strong></td>
			 	    <td width="102"></td>
			 	    </tr>
			 	  <tr align="justify">
			 	    <td width="267" align="justify">9.  El docente utiliza diferentes procedimientos de  evaluaci&oacute;n (proyectos, problemas, exposiciones, etc.) para evaluar el desempe&ntilde;o  de los estudiantes.</td>
			 	    <% for i=0 to ubound(arr_pers_ncorr_prof_rezagado) %>
				  		<td width="102" align="center">
                        <select id="nota[9][<%=i+1%>]" name="nota[9][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                          </select>
                        </td>
                        <%next%>
			 	    </tr>
			 	  <tr align="justify">
			 	    <td width="267" align="justify">10. El docente utiliza pautas de evaluaci&oacute;n,  r&uacute;bricas o pautas de correcci&oacute;n para establecer calificaciones. </td>
			 	    <% for i=0 to ubound(arr_pers_ncorr_prof_rezagado) %>
				  		<td width="102" align="center">
                        <select id="nota[10][<%=i+1%>]" name="nota[10][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                          </select>
                        </td>
                        <%next%>
			 	    </tr>
			 	  <tr align="justify">
			 	    <td width="267" align="justify">11.  Ingresa&nbsp;  calificaciones en&nbsp; los tiempos  estipulados en &nbsp;la calendarizaci&oacute;n y por  la carrera. </td>
			 	    <% for i=0 to ubound(arr_pers_ncorr_prof_rezagado) %>
				  		<td width="102" align="center">
                        <select id="nota[11][<%=i+1%>]" name="nota[11][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                          </select>
                        </td>
                        <%next%>
			 	    </tr>
			 	  </table>
			 	<br />
			 <br />
			  <table width="100%">
			   <tr>
			   <td width="36%" align="rigth" valign="top" class="Estilo31"></td>
					
				
					<td width="10%" align="center" valign="top" class="Estilo31">
					 
						<a href="javascript:volver();">
												
						<img src="Images/salir.png" border="0" width="55" height="55">	</a>				
					</td>
					
					<td width="11%" align="center" valign="top" class="Estilo31">
					 
						<a href="javascript:validar_ingreso();">
												
						<img src="Images/guardar1.png" border="0" width="55" height="55" alt="¿Cómo funciona?"></a>
					 </td>
						<td width="43%" align="left" valign="top" class="Estilo31">&nbsp;</td>
				  </tr>
			  </table>
				
				<br />
				<br />
				<br />
				<hr size="1" noshade="noshade" />
				<br /></td>
		  </tr>
		</table>
</td>
	<td width="29" background="images/lado_derecha.gif"></td>
</tr>
<tr>
	<td width="25" height="27" background="images/borde_inferior.jpg"><img width="25" height="27" src="images/inferior_izquierda.jpg"></td>
	<td width="646" height="27" background="images/borde_inferior.jpg">&nbsp;</td>
	<td width="29" height="27"><img width="29" height="27" src="images/inferior_derecha.jpg"></td>
</tr>
</table>

</form>
<p align="center"><strong>&nbsp;<span class="Estilo45">&iexcl;Muchas gracias por  tu colaboraci&oacute;n! </span></strong><span class="Estilo45"><br />
  
<p>&nbsp;</p>
<p>&nbsp;</p>
</td>
</tr>
</table>
</body>

</html>

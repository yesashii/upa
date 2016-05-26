<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_encuesta_2015.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 

'------------------------------------------------------
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

rut						=	Request.Form("b[0][pers_nrut]")
pers_ncorr_temporal		=	Request.Form("b[0][pers_ncorr_temp]")
q_peri_ccod				=	Request.Form("b[0][peri_ccod]")

set conectar = new CConexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

anos_ccod = conectar.consultaUno("select anos_ccod from periodos_Academicos where  cast(peri_ccod as varchar)='"&q_peri_ccod&"'")

'response.Write(anos_ccod)
'response.End()
set f_ramos = new CFormulario
f_ramos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_ramos.Inicializar conectar
'response.Write(carrera)			
consulta2 = "  select distinct e.asig_ccod,f.asig_tdesc,protic.initcap(i.pers_tnombre + ' ' + i.pers_tape_paterno) as docente,e.secc_ccod,i.pers_ncorr, " & vbCrLf &_
			"  case c.plec_ccod when 1 then '1er Sem' when 2 then '2do Sem' when 3 then '3er Tri' end as semestre " & vbCrLf &_
			"  from alumnos a, ofertas_academicas b,periodos_academicos c,cargas_academicas d, " & vbCrLf &_
			"       secciones e,asignaturas f,bloques_horarios g, bloques_profesores h,personas i " & vbCrLf &_
			"  where cast(a.pers_ncorr as varchar)= '"&pers_ncorr_temporal&"' " & vbCrLf &_
			"  and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
			"  and b.peri_ccod = c.peri_ccod and c.PERI_CCOD="&q_peri_ccod&" and cast(c.anos_ccod as varchar)='"&anos_ccod&"' and c.plec_ccod in (1,2,3) " & vbCrLf &_
			"  and a.matr_ncorr=d.matr_ncorr and d.secc_ccod=e.secc_ccod " & vbCrLf &_
			"  and e.asig_ccod=f.asig_ccod and e.secc_ccod=g.secc_ccod  " & vbCrLf &_
			"  and g.bloq_ccod=h.bloq_ccod and h.tpro_ccod=1 " & vbCrLf &_
			"  and h.pers_ncorr=i.pers_ncorr " & vbCrLf &_
			"  and not exists (select 1 from convalidaciones conv where conv.matr_ncorr=a.matr_ncorr and conv.asig_ccod=e.asig_ccod) " & vbCrLf &_
			"and e.ASIG_CCOD not in (select ASIG_CCOD from asignaturas_no_encuestadas_2015)" & vbCrLf &_
			"  order by semestre"
			
'response.Write("<pre>"&consulta2&"</pre>")
'response.End()		
f_ramos.Consultar consulta2
nro_profes = f_ramos.nroFilas
'response.Write("nro_filas: "&nro_profes)

'f_ramos.siguiente

Dim arr_secc_ccod()
Dim arr_secc_ccod_rezagado()
Dim arr_pers_ncorr_prof()
Dim arr_pers_ncorr_prof_rezagado()
Dim arr_asig_tdesc_rezagado()
Dim arr_docente_rezagado()

f_ramos.primero

Redim arr_secc_ccod(nro_profes)
Redim arr_pers_ncorr_prof(nro_profes)
Redim arr_secc_ccod_rezagado(nro_profes)
se_va = 0
se_queda = 0
j = 0
'response.Write(nro_profes)
for i=1 to nro_profes
	f_ramos.siguiente
	arr_secc_ccod(i)	=	f_ramos.Obtenervalor("secc_ccod")
	arr_pers_ncorr_prof(i)	=	f_ramos.Obtenervalor("pers_ncorr")
	'response.Write(arr_secc_ccod(i)&",")
	realizo_encuesta = conectar.consultaUno("select distinct secc_ccod from evaluacion_docente_alumnos_2015 where secc_ccod="&arr_secc_ccod(i)&" and pers_ncorr="&pers_ncorr_temporal&" and pers_ncorr_profesor="&arr_pers_ncorr_prof(i)&"")

'response.Write("select distinct secc_ccod from evaluacion_docente_alumnos_2015 where secc_ccod="&arr_secc_ccod(i)&" and pers_ncorr="&pers_ncorr_temporal&" and pers_ncorr_profesor="&arr_pers_ncorr_prof(i)&"")
'response.Write(	"select distinct secc_ccod from evaluacion_docente_alumnos_2015 where secc_ccod="&arr_secc_ccod(i)&" and pers_ncorr="&pers_ncorr_temporal&" and pers_ncorr_profesor="&arr_pers_ncorr_prof(i)&"")
	if realizo_encuesta <> "" then
		'response.Write("<pre>"&realizo_encuesta&"<pre>")
		se_va = se_va+1

	else
		Redim preserve arr_secc_ccod_rezagado(j)
		Redim preserve arr_pers_ncorr_prof_rezagado(j)
		Redim preserve arr_asig_tdesc_rezagado(j)
		Redim preserve arr_docente_rezagado(j)
		
		se_queda = se_queda+1
		
		arr_secc_ccod_rezagado(j)		=	arr_secc_ccod(i)
		arr_pers_ncorr_prof_rezagado(j)	=	arr_pers_ncorr_prof(i)
		arr_asig_tdesc_rezagado(j)		=	f_ramos.Obtenervalor("asig_tdesc")
		arr_docente_rezagado(j)			=	f_ramos.Obtenervalor("docente")
	'response.Write("sec_reza "&arr_secc_ccod_rezagado(j)&" prof_reza "&arr_pers_ncorr_prof_rezagado(j))
		'response.End()
		'response.Write(arr_asig_tdesc_rezagado(j)&"-")
		j = j+1

	end if
'response.Write("<pre>"&arr_secc_ccod(i)&"<pre>")
next
if (nro_profes = 0) then
	Response.Redirect("encuesta_2015_fin.asp?origen=2")
end if
'response.End()
'response.Write("se_queda="&se_queda)
'response.Write("se_va="&se_va)
'response.End()
if se_va > 0 and se_queda = 0 then
	Response.Redirect("encuesta_2015_fin.asp?origen=1")
else
	'response.write("se queda")
end if
'response.Write("hola")
'response.End()
'response.Write("rezagados: "&Ubound(arr_secc_ccod_rezagado))
'sql_realizo_encuesta = "select * from evaluacion_docente_alumnos_2015 where secc_ccod="&&" and pers_ncorr="&&" and pers_ncorr_profesor="&""
'------------------------------------------------------------

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><%=nombre_encuesta%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumnos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function volver()
{
   location.href ="seleccionar_docente.asp";
}
function direccionar(valor)
{var cadena;
 var secc_ccod='<%=secc_ccod%>';
 var pers_ncorr_profesor='<%=pers_ncorr_profesor%>';
 location.href="contestar_encuesta2.asp?encu_ncorr="+valor+"&secc_ccod="+secc_ccod+"&pers_ncorr_docente="+pers_ncorr_profesor;
}
function cambio(elemento){
	//var arSelected = new Array();
	
	document.getElementById(elemento.id).style.color="black";
	//alert(elemento);
	
	/* while (elemento.selectedIndex != -1)
    {
       if (elemento.selectedIndex != 0) arSelected.push(elemento.options[elemento.selectedIndex].value);
       // alert(elemento.options[elemento.selectedIndex].selected);
		elemento.options[elemento.selectedIndex].selected = false;
    }
	*/
}
function valida_caracter(elemento){
//  var charRegExp = /'[a-zA-Z0-9¡!"#$%&()¿?+$*¨][.-]/ 
  var charRegExp = /'/; 
  
  var firstName = elemento.value; 
//  alert(firstName.search(charRegExp))
  if (firstName.search(charRegExp)!=-1 ){ 
	return false;
	} 
	else{
	return true;
	}
}
function validar_ingreso(){
	
	if (valida_caracter(document.edicion.observaciones)){
		envio=true;	
	}
	else{
		envio=false;
		msj	= "No puedes ingresar el caracter Comilla Simple en tu respuesta.";	
	}
	var rezagados = <%=se_queda%>;
	var profesor = <%=nro_profes%>;
	//var envio = true;
	
	if(rezagados>0){
		profesor = rezagados;
	}
	
	for(var i=1;i<=profesor;i++)
	{
		for(var j=1;j<21;j++)
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
	if (envio == false) {
		alert(msj);
	}
	else
	{
		document.edicion.submit();	
	}
}


</script>
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
</style>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" background="imagenes/fondo.jpg">
<center>
<table align="center" width="700">
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>Cuestionario de Opinión de alumnos</strong></font></td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<!--Antecedentes educacionales-->
	<tr>
		<td width="100%" align="left">
			<table width="700" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
						<form name="edicion" action="responder_encuesta_2015_proc.asp" method="post">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="95%">&nbsp;</td>
										   <td width="5%" align="center"><div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#990000"><strong></strong></font></div></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="98%" cellpadding="0" cellspacing="0">
									<tr>
									  <td align="center">
                                      <table  cellpadding="1" cellspacing="0" border="1" bordercolor="#496da6">
									    <tr>
									      <td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6">4</font></td>
									      <td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6">TOTALMENTE DE ACUERDO</font></td>
								        </tr>
									    <tr>
									      <td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6">3</font></td>
									      <td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6">DE ACUERDO</font></td>
								        </tr>
									    <tr>
									      <td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6">2</font></td>
									      <td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6">EN DESACUERDO</font></td>
								        </tr>
									    <tr>
									      <td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6">1</font></td>
									      <td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6">TOTALMENTE EN DESACUERDO</font></td>
								        </tr>
									    <tr>
									      <td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6">0</font></td>
									      <td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6">NO OBSERVADO</font></td>
								        </tr>
								      </table></td>
									  </tr>
									<tr>
                                    <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                     <td width="100%" align="center">
											<table width="100%" align="center" cellpadding="0" cellspacing="0" border="1" bordercolor="#4b73a6">
											<tr>
											  <td><div align="right"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">NOMBRE DE LA ASIGNATURA:</font></div></td>
											  <input type="hidden" name="pers_ncorr_temporal" value="<%=pers_ncorr_temporal%>">
											  <% for i=0 to Ubound(arr_secc_ccod_rezagado)%>
											 <td align="center">
											<input type="hidden" name="arr_secc_ccod" value="<%=arr_secc_ccod_rezagado(i)%>">
                                            <input type="hidden" name="arr_pers_ncorr_prof" value="<%=arr_pers_ncorr_prof_rezagado(i)%>">
											 
											   <%=arr_asig_tdesc_rezagado(i)%></td>
											  <%Next%>
											  </tr>
											<tr>
											  <td><div align="right"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">NOMBRE DEL DOCENTE:</font></div></td>
											   <% 'f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado) %>
                                              <td align="center">
											  <% 'f_ramos.siguiente
											  response.write(arr_docente_rezagado(i))%></td>
											 <%Next%>
											  </tr>
											<tr>
											  <td><div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6"><strong>DIMENSIÓN: ASPECTOS FORMALES DE LA DOCENCIA</strong></font></div></td>
											   <% 'f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado)
											   		'f_ramos.siguiente%>
                                                    <td align='center'><div></div></td>
											   <%Next
											   'response.End()
											   %>
											  </tr>
											<tr>
												<td width="50%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="left">
																		1. El docente cumple con el horario de clases establecido.</div></font>
												</td>
												<% 'f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado)
											   		'f_ramos.siguiente%>
                                                    <td align='center'>
                                                    <select id="nota[1][<%=i+1%>]" name="nota[1][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                                                    </select>
                                                    </td>
											   <%Next%>
												
											</tr>
											<tr>
												<td width="50%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="left">
																		2. El docente prepara y planifica las actividades desarrolladas en clases.</div>
																</font>
												</td>
												<% 'f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado)
											   		'f_ramos.siguiente%>
                                                    <td align='center'>
                                                    <select id="nota[2][<%=i+1%>]" name="nota[2][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                                                    </select>
                                                    </td>
											   <%Next%>
											</tr>
											<tr>
											  <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6"><div align="left">
																		3. Las clases del docente son coherentes con el programa de la asignatura.</div></font></td>
											 <% 'f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado)
											   		'f_ramos.siguiente%>
                                                    <td align='center'>
                                                    <select id="nota[3][<%=i+1%>]" name="nota[3][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                                                    </select>
                                                    </td>
											   <%Next%>
											  </tr>
											<tr>
											  <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="left">
																		4. El docente comunica los resultados de las evaluaciones dentro de los 15 d&iacute;as establecidos en el reglamento.</div>
																</font></td>
											 <% 'f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado)
											   		'f_ramos.siguiente%>
                                                    <td align='center'>
                                                    <select id="nota[4][<%=i+1%>]" name="nota[4][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                                                    </select>
                                                    </td>
											   <%Next%>
											  </tr>
											<tr>
											  <td><div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6"><strong>DIMENSI&Oacute;N: PROCESO DE ENSE&Ntilde;ANZA Y APRENDIZAJE</strong></font></div></td>
											   <% 'f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado)
											   		'f_ramos.siguiente%>
                                                    <td align='center'><div></div></td>
											   <%Next%>
											<tr>
											  <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="left">
																		5. El docente domina los temas tratados, de acuerdo al programa de la asignatura.</div>
																</font></td>
											  <%' f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado)
											   		'f_ramos.siguiente%>
                                                    <td align='center'>
                                                    <select id="nota[5][<%=i+1%>]" name="nota[5][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                                                    </select>
                                                    </td>
											   <%Next%>
											  </tr>
											<tr>
											  <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="left">
																		6. El docente utiliza diferentes recursos y estrategias de apoyo al proceso de aprendizaje (materiales audio visuales, uso de aulas virtuales, salidas a terreno, entre otros).</div>
																</font></td>
											 <% 'f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado)
											   		'f_ramos.siguiente%>
                                                    <td align='center'>
                                                    <select id="nota[6][<%=i+1%>]" name="nota[6][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                                                    </select>
                                                    </td>
											   <%Next%>
											  </tr>
											<tr>
											  <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="left">
																		7. Las actividades desarrolladas en clases me permiten aplicar el conocimiento adquirido en diferentes contextos.</div>
																</font></td>
											  <% 'f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado)
											   		'f_ramos.siguiente%>
                                                    <td align='center'>
                                                    <select id="nota[7][<%=i+1%>]" name="nota[7][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                                                    </select>
                                                    </td>
											   <%Next%>
											<tr>
											  <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="left">
																		8. El docente promueve la participaci&oacute;n, a partir de preguntas e instancias de discusi&oacute;n sobre los temas tratados en clases.</div>
																</font></td>
											  <% 'f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado)
											   		'f_ramos.siguiente%>
                                                    <td align='center'>
                                                    <select id="nota[8][<%=i+1%>]" name="nota[8][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                                                    </select>
                                                    </td>
											   <%Next%>
											<tr>
											  <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="left">
																		9. El docente relaciona los temas tratados con los conocimientos y procedimientos que utilizar&eacute; en mi futuro desempe&ntilde;o profesional.</div>
																</font></td>
											  <% 'f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado)
											   		'f_ramos.siguiente%>
                                                    <td align='center'>
                                                    <select id="nota[9][<%=i+1%>]" name="nota[9][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                                                    </select>
                                                    </td>
											   <%Next%>
											<tr>
											  <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="left">
																		10. El docente estimula la creatividad durante las clases.</div>
																</font></td>
											 <% 'f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado)
											   		'f_ramos.siguiente%>
                                                    <td align='center'>
                                                    <select id="nota[10][<%=i+1%>]" name="nota[10][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                                                    </select>
                                                    </td>
											   <%Next%>
											<tr>
											  <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="left">
																		11. Durante las clases se llevan a cabo ejercicios y/o actividades que relacionan la teor&iacute;a con la pr&aacute;ctica.</div>
																</font></td>
											  <% 'f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado)
											   		'f_ramos.siguiente%>
                                                    <td align='center'>
                                                    <select id="nota[11][<%=i+1%>]" name="nota[11][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                                                    </select>
                                                    </td>
											   <%Next%>
											<tr>
											  <td><div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6"><strong>DIMENSI&Oacute;N: AMBIENTE DE CLASES</strong></font></div></td>
											   <% 'f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado)
											   		'f_ramos.siguiente%>
                                                    <td align='center'><div></div></td>
											   <%Next%>
											<tr>
											  <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="left">
																		12. El docente promueve un ambiente de confianza y respeto.</div>
																</font></td>
											 <% 'f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado)
											   		'f_ramos.siguiente%>
                                                    <td align='center'>
                                                    <select id="nota[12][<%=i+1%>]" name="nota[12][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                                                    </select>
                                                    </td>
											   <%Next%>
											<tr>
											  <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="left">
																		13. El docente tienen buena disposici&oacute;n para responder a las inquietudes de los estudiantes.</div>
																</font></td>
											  <% 'f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado)
											   		'f_ramos.siguiente%>
                                                    <td align='center'>
                                                    <select id="nota[13][<%=i+1%>]" name="nota[13][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                                                    </select>
                                                    </td>
											   <%Next%>
											<tr>
											  <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="left">
																		14. El docente vincula algunos temas trabajados en la asignatura con los valores de la universidad (respeto, honestidad y responsabilidad).</div>
																</font></td>
											  <% 'f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado)
											   		'f_ramos.siguiente%>
                                                    <td align='center'>
                                                    <select id="nota[14][<%=i+1%>]" name="nota[14][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                                                    </select>
                                                    </td>
											   <%Next%>
											<tr>
											  <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="left">
																		15. En la asignatura se trabajan los aspectos &eacute;ticos de la profesi&oacute;n.</div>
																</font></td>
											  <% 'f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado)
											   		'f_ramos.siguiente%>
                                                    <td align='center'>
                                                    <select id="nota[15][<%=i+1%>]" name="nota[15][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                                                    </select>
                                                    </td>
											   <%Next%>
											<tr>
											  <td><div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6"><strong>DIMENSI&Oacute;N: PROCESO DE EVALUACI&Oacute;N</strong></font></div></td>
											  <% 'f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado)
											   		'f_ramos.siguiente%>
                                                    <td align='center'><div></div></td>
											   <%Next%>
											<tr>
											  <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="left">
																		16. Los instrumentos de evaluaci&oacute;n, son coherentes con los contenidos y la metodolog&iacute;a utilizada en clases.</div>
																</font></td>
											  <% 'f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado)
											   		'f_ramos.siguiente%>
                                                    <td align='center'>
                                                    <select id="nota[16][<%=i+1%>]" name="nota[16][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                                                    </select>
                                                    </td>
											   <%Next%>
											<tr>
											  <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="left">
																		17. El docente aplica diferentes formas de evaluar el aprendizaje (proyectos, problemas, exposiciones, ejecuciones, etc.).</div>
																</font></td>
											  <% 'f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado)
											   		'f_ramos.siguiente%>
                                                    <td align='center'>
                                                    <select id="nota[17][<%=i+1%>]" name="nota[17][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                                                    </select>
                                                    </td>
											   <%Next%>
											<tr>
											  <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="left">
																		18. El docente comunica con anticipaci&oacute;n los aspectos a evaluar.</div>
																</font></td>
											  <% 'f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado)
											   		'f_ramos.siguiente%>
                                                    <td align='center'>
                                                    <select id="nota[18][<%=i+1%>]" name="nota[18][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                                                    </select>
                                                    </td>
											   <%Next%>
											<tr>
											  <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="left">
																		19. El docente da a conocer la pauta de evaluaci&oacute;n o correcci&oacute;n con la asignaci&oacute;n de puntaje y nota.</div>
																</font></td>
											  <% 'f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado)
											   		'f_ramos.siguiente%>
                                                    <td align='center'>
                                                    <select id="nota[19][<%=i+1%>]" name="nota[19][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                                                    </select>
                                                    </td>
											   <%Next%>
											<tr>
											  <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												                    <div align="left">
																		20. El docente comunica el resultado de las evaluaciones, realizando comentarios sobre los aspectos m&aacute;s d&eacute;biles de forma constructiva, ayud&aacute;ndome a mejorar mi desempe&ntilde;o.</div>
																</font></td>
											  <% 'f_ramos.primero
											   for i=0 to Ubound(arr_secc_ccod_rezagado)
											   		'f_ramos.siguiente%>
                                                    <td align='center'>
                                                    <select id="nota[20][<%=i+1%>]" name="nota[20][<%=i+1%>]" multiple size="5" onChange="cambio(this);">
                                                    <option value="0">0</option>
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                                                    </select>
                                                    </td>
											   <%Next%>
											</table>
											
										</td>
									</tr>
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<tr>
										<td width="100%" align="left">
											<div align="justify">
												<font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#4b73a6">
												PREGUNTA: Describe los aspectos que pueden contribuir a mejorar la docencia de uno o tres profesores que te hicieron clases. 
											</font>
											</div>
										</td>
									</tr>
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<tr>
										<td width="100%" align="center"><textarea name="observaciones" cols="100" rows="6" id="TO-S" onChange="javascript:valida_caracter(this);"></textarea></td>
									</tr>
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<tr>
										<td width="100%" align="left">&nbsp;</td>
									</tr>
									<tr>
										<td width="100%" align="center">
											<table width="40%" cellpadding="0" cellspacing="0">
												<tr>
												<td width="34%" align="center">
														<%POS_IMAGEN = 0%>
														<a href="javascript:_Navegar(this, 'encuesta_2015.asp', 'FALSE');"
															onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ANTERIOR2.png';return true "
															onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ANTERIOR1.png';return true ">
															<img src="imagenes/ANTERIOR1.png" border="0" width="70" height="70" alt="VOLVER A PAGINA ANTERIOR"> 
														</a>
													</td>
												    
													<td width="34%" align="center">
														<%POS_IMAGEN = POS_IMAGEN + 1%>
														<a href="javascript:validar_ingreso();"
															onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/CERRAR2.png';return true "
															onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/CERRAR1.png';return true ">
															<img src="imagenes/CERRAR1.png" border="0" width="70" height="70" alt="CERRAR ENCUESTA">
														</a>
													</td>
												</tr>
											</table>
										</td>
									</tr>
									</table>
								</td>
							</tr>
						 </form>
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


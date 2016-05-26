 <!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
 
set pagina = new CPagina
pagina.Titulo = "Asignación de Optativos Deportivos"
matr_ncorr		= 	session("matr_ncorr")
asig_ccod	=	request.querystring("a[0][asig_ccod]")
secc_ccod	=	request.querystring("a[0][secc_ccod]")
'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set f_botonera = new CFormulario

f_botonera.Carga_Parametros "toma_carga.xml", "BotoneraTomaCarga"

set botonera = new CFormulario
botonera.carga_parametros "toma_carga.xml", "BotoneraOptativosDeportivos"

set f_botonera_optativo = new CFormulario
f_botonera_optativo.Carga_Parametros "toma_carga.xml", "BotoneraOptativos"

set errores 	= new cErrores
set optativos_deportivos = new cformulario

optativos_deportivos.carga_parametros "toma_carga.xml" , "tabla_Op_deportivos"
optativos_deportivos.inicializar	conectar

peri_ccod = conectar.consultaUno("Select peri_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")
sede_ccod = conectar.consultaUno("Select sede_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")
pers_ncorr = conectar.consultaUno("Select pers_ncorr from alumnos  where cast(matr_ncorr as varchar)='"&matr_ncorr&"'")
carr_prueba = conectar.consultaUno("Select carr_ccod from alumnos a, ofertas_academicas b,especialidades c where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr and b.espe_ccod = c.espe_ccod")


'-------------------------------------------Seleccionar asignatura para equivalencia de una lista sin escribir su código-----
'-----------------------------------------------------------msandoval 19-02-2005---------------------------------------------
set fbusqueda = new cFormulario
fbusqueda.carga_parametros "toma_carga.xml", "buscador_optativos"
fbusqueda.inicializar conectar
peri = peri_ccod 'negocio.obtenerPeriodoAcademico ( "planificacion" ) 
sede = sede_ccod 'negocio.obtenerSede

'-----------------------------------------Debemos revisar si el alumno reprobo alguna asignatura deportiva, de ser así-------
'-------------------------------------------- Esta será la única que se le mostrará en el listado-------------------------
consulta_reprobados = " select distinct bb.asig_ccod from cargas_academicas aa, secciones bb,alumnos cc " & vbCrLf & _
		   " where bb.secc_ccod in (select secc_ccod from secciones a, malla_curricular b,periodos_academicos c " & vbCrLf & _
		   "                       where carr_ccod='820' and a.peri_ccod=c.peri_ccod and c.anos_ccod >= 2005 " & vbCrLf & _
		   "                       and a.mall_ccod = b.mall_ccod and a.asig_ccod=b.asig_ccod " & vbCrLf & _
		   "                       and b.plan_ccod=378) " & vbCrLf & _
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

consulta = " select a.secc_ccod, a.secc_tdesc +'--> '+ protic.horario(a.secc_ccod) as secc_tdesc, b.asig_ccod, b.asig_tdesc + ' ('+ltrim(rtrim(b.asig_ccod))+')'  as asig_tdesc " & vbCrLf & _
		   " from secciones a, asignaturas b,malla_curricular c " & vbCrLf & _
		   " where a.asig_ccod = b.asig_ccod " & vbCrLf & _
		   " and a.asig_ccod = c.asig_ccod and a.mall_ccod=c.mall_ccod " & vbCrLf & _
		   " and c.plan_ccod = '378' " & vbCrLf & _
		   " and a.carr_ccod = '820' " & vbCrLf & _
		   " and a.secc_ncupo > 0 " & vbCrLf & _
		   " and cast(a.peri_ccod as varchar)= '"&peri&"'" 

if (cantidad_reprobados <> "0" and cantidad_reprobados <> "") then
	consulta = consulta & " and b.asig_ccod in ("&consulta_reprobados&")"
end if		   

'response.Write("<pre>"&consulta&"</pre>")	

fbusqueda.inicializaListaDependiente "lBusqueda", consulta
fbusqueda.siguiente


'---------------------------buscamos ahora si al alumno le quedan optativos de plan por realizar-----------------------------
plan_alumno =conectar.consultaUno("select plan_ccod from alumnos where cast(matr_ncorr as varchar)='"&matr_ncorr&"'")
'response.Write(plan_alumno)
cantidad_optativos_plan = conectar.consultaUno("select isnull(count(*),0) from malla_curricular a, asignaturas b where a.asig_ccod = b.asig_ccod and b.clas_ccod=2 and asig_tdesc not like '%especialidad%' and cast(plan_ccod as varchar)='"&plan_alumno&"'")
'response.Write("num_optativos_malla "&cantidad_optativos_plan)
carrera = conectar.consultaUno("select c.carr_ccod from alumnos a, ofertas_Academicas b,especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
'response.Write(carrera)
cantidad_optativos_alumno = " select isnull(count(*),0) from ( " & vbCrLf & _
							" select d.asig_ccod " & vbCrLf & _
							" from alumnos a, cargas_Academicas b, secciones c, asignaturas d " & vbCrLf & _
						    " where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' " & vbCrLf & _
						    " and a.matr_ncorr=b.matr_ncorr and asig_tdesc not like '%especialidad%'" & vbCrLf & _
							" and b.secc_ccod=c.secc_ccod " & vbCrLf & _
							" and c.asig_ccod=d.asig_ccod " & vbCrLf & _
							" and d.clas_ccod=2  --2 significa que busca optativos " & vbCrLf &_ 
							" and c.carr_ccod='"&carrera&"' " & vbCrLf & _
							" union " & vbCrLf & _
						    " select b.asig_ccod --para ver si se le ingresaron optativos por equivalencias" & vbCrLf & _ 
							" from alumnos a, equivalencias b,asignaturas c,secciones d " & vbCrLf & _
							" where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'" & vbCrLf & _
							" and a.matr_ncorr=b.matr_ncorr  and asig_tdesc not like '%especialidad%'" & vbCrLf & _
							" and b.asig_ccod=c.asig_ccod " & vbCrLf & _
							" and b.secc_ccod=d.secc_ccod " & vbCrLf & _
							" and d.carr_ccod='"&carrera&"'" & vbCrLf & _
							"and c.clas_ccod=2) a"

cantidad_optativos_alumno = conectar.consultaUno(cantidad_optativos_alumno)
'response.Write(" num_optativos_alumno "&cantidad_optativos_alumno)
set f_afecta = new cFormulario
f_afecta.carga_parametros "toma_carga.xml", "afecta_promedio"
f_afecta.inicializar conectar
f_afecta.consultar "select ''"
f_afecta.siguiente

if cint(cantidad_optativos_alumno) >= cint(cantidad_optativos_plan) then
	afecta_promedio=false
	f_afecta.agregaCampoParam "carg_afecta_promedio","deshabilitado","TRUE"
	f_afecta.agregaCampoParam "carg_afecta_promedio","id","TO-S"
	activo="0"
else
	afecta_promedio=true	
    f_afecta.agregaCampoParam "carg_afecta_promedio","deshabilitado","FALSE"
	f_afecta.agregaCampoParam "carg_afecta_promedio","id","TO-N"
	f_afecta.agregaCampoCons "carg_afecta_promedio","N"
	activo="1"
end if









'------------------------consulta para mostrar los optativos deportivos que tiene en la carga el alumno-----------------------------------
'--------------------------------------agregada el 14 de julio de 2005 por Marcelo Sandoval-----------------------------------------------
cons_optativo=" select '"&matr_ncorr&"' as matr_ncorr,a.secc_ccod, c.asig_ccod + ' --> ' + c.asig_tdesc as asignatura, "& vbCrLf & _
			 " 'Secc. ' + cast(b.secc_tdesc as varchar)+' -> '+ cast(protic.horario(b.secc_ccod) as varchar) as horario, carg_afecta_promedio as afecta "& vbCrLf & _
			 " from cargas_academicas a, secciones b, asignaturas c "& vbCrLf & _
		     " where a.secc_ccod = b.secc_ccod "& vbCrLf & _
		     " and b.asig_ccod = c.asig_ccod "& vbCrLf & _
			 " and cast(a.matr_ncorr as varchar)= '"&matr_ncorr&"' "& vbCrLf & _
			 " and cast(b.peri_ccod as varchar)= '"&peri_ccod&"' "& vbCrLf & _
			 " and b.carr_ccod='820' "
			

optativos_deportivos.consultar cons_optativo


peri_tdesc = conectar.consultaUno("Select protic.initcap(peri_tdesc) from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
pers_ncorr= session("pers_ncorr_alumno")
				  
 nombre = conectar.consultaUno ("select cast(pers_tape_paterno as varchar) + ' ' + cast(pers_tape_materno as varchar) + ', ' + cast(pers_tnombre as varchar) from personas where cast(pers_ncorr as varchar)='" & pers_ncorr & "'")
 v_carr_ccod  = conectar.consultaUno ("select ltrim(rtrim(c.carr_ccod)) from alumnos a, ofertas_academicas b, especialidades c where cast(matr_ncorr as varchar)='" & matr_ncorr & "' and a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod = c.espe_ccod")
 carrera = conectar.consultaUno ("select carr_tdesc from carreras  where carr_ccod='"&v_carr_ccod&"'")
 rut = conectar.consultaUno ("select cast(pers_nrut as varchar)+ '-'+ pers_xdv from personas where cast(pers_ncorr as varchar)='" & pers_ncorr & "'")

pers_nrut = conectar.consultaUno("Select pers_nrut from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
pers_xdv = conectar.consultaUno("Select pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
url="../CERTIFICADOS/HISTORICO_NOTAS_LIBRE.ASP?busqueda[0][pers_nrut]="&pers_nrut&"&busqueda[0][pers_xdv]="&pers_xdv&"&ocultar=1"

tipo_plan = conectar.consultaUno("select isnull(plan_tcreditos,0) from alumnos a, planes_estudio b where a.plan_ccod=b.plan_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")

if tipo_plan = "0" then
	lenguetas_carga = Array(Array("Toma de Carga", "toma_carga_nuevo.asp"), Array("Ingreso Equivalencias", "equivalencias.asp"), Array("Optativos Deportivos", "ingreso_optativos.asp"),Array("Carga Extraordinaria Créditos", "toma_carga_extraordinaria.asp?tipo=1"))
else
	lenguetas_carga = Array(Array("Toma de Carga", "toma_carga_nuevo.asp"), Array("Ingreso Equivalencias", "equivalencias.asp"), Array("Optativos Deportivos", "ingreso_optativos.asp"),Array("Carga Extraordinaria Secciones", "toma_carga_extraordinaria.asp?tipo=2"))
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
            <td><%pagina.DibujarLenguetas lenguetas_carga, 3 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
                    <% pagina.Titulo = pagina.Titulo & "<br>" & peri_tdesc
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
                <td width="80">RUT</td>
                <td width="443">: <%= rut %></td>
				<td width="136" align="center">&nbsp;</td>
              </tr>
              <tr>
                <td>Nombre</td>
                <td colspan="2">: <%= nombre %></td>
              </tr>
              <tr>
                <td>Carrera</td>
                <td colspan="2">: <%=carrera%>
			    </td>
              </tr>
			  <tr><td colspan="3">&nbsp;</td></tr>
			  <tr><td colspan="3">&nbsp;</td></tr>
			  <tr><td colspan="3">
			  		<table width="100%"  border="1">
                      <tr>
                        <td width="81%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="26%"> <div align="left"><strong>Asignatura&nbsp;</strong> 
                                </div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td colspan="2"><% fbusqueda.dibujaCampoLista "lBusqueda", "asig_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="26%"> <div align="left"><strong>Secci&oacute;n</strong></div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td colspan="2"><% fbusqueda.dibujaCampoLista "lBusqueda", "secc_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="26%"> <div align="left"><strong>Afecta al Promedio</strong></div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td width="62%"><%f_afecta.dibujaCampo("carg_afecta_promedio")%> <input type="hidden" name="matr_ncorr" value="<%=matr_ncorr%>"></td>
                              	<td width="10%"><%
								                   if tipo_plan <> "0" and cint(suma_creditos) >= 27 then
													    botonera.agregaBotonParam "guardar","deshabilitado","TRUE"
												   end if
								                   botonera.dibujaboton "guardar"
												%></td>
							  </tr>
							  <tr>
							     <td colspan="4" align="center">&nbsp;</font></td>	
							  </tr>
							  <%if tipo_plan <> "0" and cint(suma_creditos) >= 27 then%>
								<tr>
								   <td colspan="4" align="center"><font  size="2" color="#0000FF"><strong>Atención el total de Cr&eacute;ditos Asignados (<%=suma_creditos%>) esta fuera del rango permitido (9-27).<br> Elimine parte de la carga para tomar el optativo.</strong></font>
								   </td>
								</tr>
							  <%else%>
								  <%if afecta_promedio=False then%>
								  <tr>
									 <td colspan="4" align="center"><font color="#0000FF" size="2">El alumno ya tiene dictados todos los optativos de la carrera o bien esta no tiene configurado ramos para optativos. Cualquier otro optativo será complementario a su malla y no afectará al promedio final.</font></td>	
								  </tr>
								  <%end if%>
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
						<td><%pagina.DibujarSubtitulo "Listado de Optativos Deportivos asignados al alumno"%>
						  <br></td>
					  </tr>
					  </table>
				     <table width="100%" border="0">
					  <tr> 
						<td align="right"><strong><font color="000000" size="1"> 
						  <% optativos_deportivos.pagina%>
						  &nbsp;&nbsp;&nbsp;&nbsp; 
						  <% optativos_deportivos.accesoPagina%>
						  </font></strong></td>
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
						<% if optativos_deportivos.NroFilas = 0 then
									  f_botonera_optativo.agregabotonparam "ELIMINAR", "deshabilitado" ,"TRUE"
                           end if							
								  f_botonera_optativo.DibujaBoton "ELIMINAR"%>
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
                    <% f_botonera.agregaBotonParam "anterior", "url", "equivalencias.asp"
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

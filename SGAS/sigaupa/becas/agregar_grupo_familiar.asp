<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
Function SqlGrupoFamiliar(p_pare_ccod,v_post_ncorr,v_pers_ncorr)
	
SqlGrupoFamiliar =" select '"&v_post_ncorr&"' as post_ncorr,'"&p_pare_ccod&"' as pare_ccod, c.pers_ncorr, c.pers_nrut, c.pers_xdv, c.pers_tnombre, c.pers_tape_paterno,    " & VBCRLF & _
" c.pers_tape_materno, c.pers_fnacimiento,c.eciv_ccod, " & VBCRLF & _
" (select dire_tcalle from  " & VBCRLF & _
"         direcciones_publica d  " & VBCRLF & _
"         where d.pers_ncorr = c.pers_ncorr  " & VBCRLF & _
"         and d.tdir_ccod =1  " & VBCRLF  	& _
" ) as  dire_tcalle,  " & VBCRLF  	& _
"  (select dire_tnro from  " & VBCRLF  	& _
"         direcciones_publica d  " & VBCRLF  	& _
"         where d.pers_ncorr = c.pers_ncorr  " & VBCRLF  	& _
"         and d.tdir_ccod =1  " & VBCRLF  	& _
" ) as  dire_tnro ,  " & VBCRLF  	& _
" (select dire_tfono from  " & VBCRLF  	& _
"         direcciones_publica d  " & VBCRLF  	& _
"         where d.pers_ncorr = c.pers_ncorr  " & VBCRLF  	& _
"         and d.tdir_ccod =1  " & VBCRLF  	& _
" ) as  dire_tfono ,  " & VBCRLF  	& _
" (select dire_tblock from  " & VBCRLF  	& _
"         direcciones_publica d  " & VBCRLF  	& _
"         where d.pers_ncorr = c.pers_ncorr  " & VBCRLF  	& _
"         and d.tdir_ccod =1  " & VBCRLF  	& _
" ) as  dire_tblock ,  " & VBCRLF  	& _
"  (select dire_tpoblacion from  " & VBCRLF  	& _
"         direcciones_publica d  " & VBCRLF  	& _
"         where d.pers_ncorr = c.pers_ncorr  " & VBCRLF & _
"         and d.tdir_ccod =1  " & VBCRLF  	& _
" ) as  dire_tpoblacion ,  " & VBCRLF  	& _
" (select CIUD_CCOD from  " & VBCRLF  	& _
"         direcciones_publica d  " & VBCRLF  	& _
"         where d.pers_ncorr = c.pers_ncorr  " & VBCRLF  	& _
"         and d.tdir_ccod =1  " & VBCRLF  	& _
" ) as  CIUD_CCOD,  " & VBCRLF  	& _
"  ( SELECT REGI_CCOD FROM  " & VBCRLF  	& _
"   DIRECCIONES_PUBLICA D,CIUDADES E  " & VBCRLF  	& _
"   WHERE D.CIUD_CCOD = E.CIUD_CCOD    " & VBCRLF  	& _
"   AND D.PERS_NCORR = C.PERS_NCORR  " & VBCRLF  	& _
"   AND D.TDIR_CCOD = 1  " & VBCRLF  	& _
" )  AS REGI_CCOD ,  " & VBCRLF  	& _
"  ( SELECT REGI_CCOD FROM  " & VBCRLF  	& _
"   DIRECCIONES_PUBLICA D,CIUDADES E  " & VBCRLF  	& _
"   WHERE D.CIUD_CCOD = E.CIUD_CCOD    " & VBCRLF  	& _
"   AND D.PERS_NCORR = C.PERS_NCORR  " & VBCRLF  	& _
"   AND D.TDIR_CCOD = 1  " & VBCRLF  	& _
" )  AS REGI_CCOD,nied_ccod,prev_ccod,prsa_ccod   " & VBCRLF  	& _
"  from   personas_postulante c  left outer join antecedentes_personas d" &vbcrlf &_
"		on c.pers_ncorr = d.pers_ncorr " &vbcrlf &_ 
"  where cast(c.pers_ncorr  as varchar)= '"&v_pers_ncorr&"' " 
 
'response.Write("<pre>"&SqlGrupoFamiliar&"</pre>")
End function




v_parentesco=request.QueryString("pare_ccod")
pers_ncorr_pariente=request.QueryString("pers_ncorr")
grup_nindependiente = request.QueryString("grup_nindependiente")


if(v_parentesco="") then
	v_parentesco=0
end if

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Agregar datos Grupo Familiar"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


rut_temporal = request.Form("padre[0][pers_nrut]")
xdv_temporal = request.Form("padre[0][pers_xdv]")

if grup_nindependiente = "" then
	grup_nindependiente = request.Form("padre[0][grup_nindependiente]")
end if

if grup_nindependiente = "" then
	grup_nindependiente = request.Form("grup_nindependiente")
end if


if rut_temporal <> "" then
'response.Write("rut "&rut_temporal)
pers_ncorr_pariente = conexion.consultaUno("Select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&rut_temporal&"'")
end if

pers_ncorr =session("pers_ncorr_alumno")
periodo = negocio.ObtenerPeriodoAcademico("Postulacion")

cod_actividad = conexion.consultaUno("select acti_ccod from antecedentes_personas where cast(pers_ncorr as varchar)='"&pers_ncorr_pariente&"'")
profesion = conexion.consultaUno("select pers_tprofesion from antecedentes_personas where cast(pers_ncorr as varchar)='"&pers_ncorr_pariente&"'")

v_post_ncorr = session("post_ncorr_alumno") 'conexion.consultaUno("select post_ncorr from postulantes where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&periodo&"' and epos_ccod=2")

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "grupo_familiar.xml", "botonera"

'######################################################################
' obtiene el rut del alumno para evitar que lo repita como familiar
sql_rut_alumno= " Select pers_nrut " & VBCRLF & _
				" From personas_postulante a, postulantes b " & VBCRLF & _
				" Where a.pers_ncorr=b.pers_ncorr" & VBCRLF & _
				" and cast(b.post_ncorr as varchar)='"&v_post_ncorr&"' " 

v_rut_alumno=conexion.consultaUno(sql_rut_alumno)				
'######################################################################

sql_existe_padre="Select count(*) as total from grupo_familiar Where pare_ccod=1 and cast(post_ncorr as varchar)='"&v_post_ncorr&"'"
sql_existe_madre="Select count(*) as total from grupo_familiar Where pare_ccod=2 and cast(post_ncorr as varchar)='"&v_post_ncorr&"'"


v_existe_padre	=	conexion.ConsultaUno(sql_existe_padre)
v_existe_madre	=	conexion.ConsultaUno(sql_existe_madre)
if v_existe_padre > 0 and v_existe_madre >0 then
	if v_parentesco =1 then
		filtro_parientes=" pare_ccod not in (0,2)"
	elseif v_parentesco =2 then
		filtro_parientes=" pare_ccod not in (0,1)"
	else
		filtro_parientes=" pare_ccod not in (0,1,2)"
	end if
elseif v_existe_padre > 0 then
	if v_parentesco =1 then
		filtro_parientes=""
	else
		filtro_parientes=" pare_ccod not in (0,1)"
	end if
	
elseif v_existe_madre > 0 then
	if v_parentesco =2 then
		filtro_parientes=""
	else
		filtro_parientes=" pare_ccod not in (0,2)"
	end if
end if
'response.Write(v_parentesco)
'---------------------------------------------------------------------------------------------------
set f_padre = new CFormulario
f_padre.Carga_Parametros "grupo_familiar.xml", "grupo_familiar"
f_padre.Inicializar conexion
f_padre.AgregaParam "variable", "padre"

consulta = SqlGrupoFamiliar(v_parentesco,v_post_ncorr,pers_ncorr_pariente)
'response.Write("<pre>" & consulta & "</pre>")
  
f_padre.Consultar consulta
f_padre.Siguientef


'---------------------------------------------------------------------------------------------------
grupo = request.QueryString("grupo")
'response.Write("grupo "&grupo)
if grupo="1" then
	titulo = "Integrante mayor de 18 años"
	filtro_parientes = ""' pare_ccod in (1,2,5,6,9,13)"
elseif grupo="2" then
    'response.Write("entre al grupo menores")
	titulo = "Integrante menor de 18 años"
	filtro_parientes = " where pare_ccod not in (1,2,5,6,9,13)"
	f_padre.AgregaCampoParam "nied_ccod","id","TO-S"
	f_padre.AgregaCampoParam "prev_ccod","id","TO-S"
	f_padre.AgregaCampoParam "prsa_ccod","id","TO-S"
elseif grupo = "3" then
    titulo = "Padre no pertenece al grupo Familiar"
	filtro_parientes = " where pare_ccod in (1)"
elseif grupo = "4" then
    titulo = "Madre no pertenece al grupo Familiar"
	filtro_parientes = " where pare_ccod in (2)"
else		
	titulo = "Familiar"	
end if	
'response.Write("<hr>"&filtro_pariente) 
'response.Write("(select pare_ccod,pare_tdesc from parentescos where "& filtro_parientes&")a")  

consulta_parentesco = "(select pare_ccod," & VBCRLF  	& _
                      " case pare_ccod when 1 then '1: ' when 5 then  '2: ' when 2 then '3: ' when 6 then '4: ' when 3 then '5: ' when 7 then '6: ' " & VBCRLF  	& _
				      " when 8 then '7: ' when 9 then '8: ' when 10 then '9: ' when 11 then '10: ' when 12 then '11: '  " & VBCRLF  	& _
					  " when 13 then '12: ' when 14 then '13: ' when 4 then '14: ' end + pare_tdesc as pare_tdesc from parentescos "& filtro_parientes&")a"

if f_padre.nroFilas = 0 and rut_temporal <> "" then
 	f_padre.AgregaCampoCons "pers_nrut",rut_temporal
	f_padre.AgregaCampoCons "pers_xdv",xdv_temporal
end if 
 
f_padre.AgregaCampoParam "pare_ccod", "destino", consulta_parentesco
f_padre.AgregaCampoParam "regi_ccod", "script", "onChange=""_FiltrarCombobox(this.form.elements['padre[0][ciud_ccod]'], this.value, d_ciudades, 'regi_ccod', 'ciud_ccod', 'ciud_tdesc', '');"""
f_padre.AgregaCampoParam "regi_ccod_empresa", "script", "onChange=""_FiltrarCombobox(this.form.elements['padre[0][ciud_ccod_empresa]'], this.value, d_ciudades, 'regi_ccod', 'ciud_ccod', 'ciud_tdesc', '');"""

f_padre.agregaCampoCons "grup_nindependiente", grup_nindependiente
'-----------------------------------------------------------------------------------------------------------
consulta_ciudades = "select regi_ccod, ciud_ccod, ciud_tdesc, ciud_tcomuna from ciudades order by ciud_tdesc asc"
'-------------------------------------------------------------------------------------

'---------- CONSULTA PARA SUGERIR DIRECCION DEL ALUMNO POSTULANTE-------------------------------
set f_alumno_direccion = new CFormulario
f_alumno_direccion.Carga_Parametros "grupo_familiar.xml", "direccion_postulante"
f_alumno_direccion.Inicializar conexion
consulta_direccion= " select g.regi_ccod, g.ciud_ccod, f.dire_tcalle,f.dire_tnro, f.dire_tblock,f.dire_tpoblacion,f.dire_tfono"&_ 
					" from direcciones_publica f , postulantes pos, ciudades g "&_
    				" where f.pers_ncorr = pos.pers_ncorr"&_
					" and f.ciud_ccod = g.ciud_ccod"&_
    				" And pos.post_ncorr="&v_post_ncorr&_
    				" and f.tdir_ccod  = 1 "
'response.Write(consulta_direccion)
f_alumno_direccion.Consultar consulta_direccion
f_alumno_direccion.SiguienteF
'-------------------------------------------------------------------------------------


v_epos_ccod = conexion.ConsultaUno("select epos_ccod from postulantes where post_ncorr = '" & v_post_ncorr & "'")
lenguetas_postulacion = Array("Antecedentes Familiares")

'---------------------------cambiamos el título de acuerdo a que desee ingresar en el grupo familiar-------------
grupo = request.QueryString("grupo")
if grupo="1" then
	titulo = "Integrante mayor de 18 años"
elseif grupo="2" then
	titulo = "Integrante menor de 18 años"
else
	titulo = "Familiar"	
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
<script language="JavaScript" src="../biblioteca/dicc_ciudades.js"></script>
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">
var t_padre;
function Validar()
{
	formulario = document.edicion;
	
	rut_padre = formulario.elements["padre[0][pers_nrut]"].value + "-" + formulario.elements["padre[0][pers_xdv]"].value;
	
	if (!isEmpty(formulario.elements["padre[0][pers_nrut]"].value)) {	
		if (!valida_rut(rut_padre)) {
			alert('Ingrese un RUT válido.');
			formulario.elements["padre[0][pers_xdv]"].focus();
			formulario.elements["padre[0][pers_xdv]"].select();
			return false;
		}
	}else{
		alert('Ingrese un RUT válido.');
		return false;
	}
	return true;
}


function pers_nrut_change(p_objeto)
{
	var tabla;
	var v_rut_ingresado;
	var v_rut_alumno;
	
	v_rut_alumno='<%=v_rut_alumno%>';
	v_rut_ingresado=p_objeto.value;
	
	switch (_VariableCampo(p_objeto)) {
		case "padre" :
			tabla = t_padre;
			break;
	}

	
	if (v_rut_alumno==v_rut_ingresado){
		alert("Esta ingresando para un familiar su propio numero de Rut que ya se encuentra registrado.\nNo puede ingresar este Rut como familiar ya que modificaria sus propios datos personales.");
		p_objeto.value='';
		return false;
	}
	tabla.filas[0].HabilitarPorCampo(!isEmpty(tabla.ObtenerValor(0, "pers_nrut")), "pers_nrut");	
	//tabla.filas[0].HabilitarPorCampo("pers_nrut", false);	
	document.edicion.elements["padre[0][pers_xdv]"].focus();
	
}

function revisar_digito(p_objeto)
{  var pers_ncorr = '<%=pers_ncorr_pariente%>';
   var rut_temporal = '<%=rut_temporal%>';
	//alert(p_objeto.value+ " pers_ncorr "+pers_ncorr);
	p_objeto.value=p_objeto.value.toUpperCase();
	if((pers_ncorr=="")&&(rut_temporal==""))
	{ document.edicion.submit();
	}	
}

function CopiarDireccionParticular()
{
v_ciudad	=	document.edicion.elements['test[0][ciud_ccod]'].value;
v_region	=   document.edicion.elements["test[0][regi_ccod]"].value;
if ((!v_ciudad)||(!v_region)){
	alert("El postulante no presenta su direccion completa");
	return false;
}else{
	t_padre.AsignarValor(0, "regi_ccod", v_region);
	_FiltrarCombobox(document.edicion.elements["padre[0][ciud_ccod]"], 
	                 document.edicion.elements["padre[0][regi_ccod]"].value,
					 d_ciudades,
					 'regi_ccod',
					 'ciud_ccod',
					 'ciud_tdesc',
					 '+v_ciudad+');
	
		t_padre.AsignarValor(0, "ciud_ccod", document.edicion.elements['test[0][ciud_ccod]'].value);
		t_padre.AsignarValor(0, "dire_tcalle", document.edicion.elements['test[0][dire_tcalle]'].value);
		t_padre.AsignarValor(0, "dire_tnro", document.edicion.elements['test[0][dire_tnro]'].value);
		t_padre.AsignarValor(0, "dire_tblock", document.edicion.elements['test[0][dire_tblock]'].value);
		t_padre.AsignarValor(0, "dire_tpoblacion", document.edicion.elements['test[0][dire_tpoblacion]'].value);
		t_padre.AsignarValor(0, "dire_tfono", document.edicion.elements['test[0][dire_tfono]'].value);
	}	
}



function InicioPagina()
{
	t_padre = new CTabla("padre");
	
	_FiltrarCombobox(document.edicion.elements["padre[0][ciud_ccod]"], 
	                 document.edicion.elements["padre[0][regi_ccod]"].value,
					 d_ciudades,
					 'regi_ccod',
					 'ciud_ccod',
					 'ciud_tdesc',
					 '<%=f_padre.ObtenerValor("ciud_ccod")%>');
				
	t_padre.filas[0].HabilitarPorCampo(!isEmpty(t_padre.ObtenerValor(0, "pers_nrut")), "pers_nrut");
	
}


</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "padre[0][pers_fnacimiento]","1","edicion","fecha_oculta_fnacimiento_papa"
	calendario.FinFuncion
%>

<style type="text/css">
<!--
.style1 {color: #FF0000}
.Estilo2 {color: #FF0000; font-weight: bold; }
-->
</style>
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina(); " onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
<table width="750"  border="0" align="center" cellpadding="0" cellspacing="0">
  <!--<tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>-->

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
            <td><%				
				pagina.DibujarLenguetas lenguetas_postulacion, 1
				%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTitulo "Ingreso Datos FAMILIARES" %>
              <br>
              <br>
              <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td><div align="justify"><%=msjRecordatorio%></div></td>
                </tr>
              </table>
			</div>
              <form name="edicion" method="post">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo titulo%>                      
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" >
                            <tr> 
                              <td width="20%"><strong> R.U.T.</strong><br> <%f_padre.DibujaCampo("pers_nrut")%>
                                - 
                                <%f_padre.DibujaCampo("pers_xdv")%></td>
                              <td width="30%"><strong>Fecha de nacimiento </strong><br> 
                                <%f_padre.DibujaCampo("pers_fnacimiento")%> <%calendario.DibujaImagen "fecha_oculta_fnacimiento_papa","1","edicion" %> </td>
                              <td width="30%"><strong>Parentesco</strong><BR><%f_padre.DibujaCampo("pare_ccod")%></td>
							  <td width="20%"><strong>Est.Civil</strong><BR><%f_padre.DibujaCampo("eciv_ccod")%></td>
                            </tr>
                          </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><strong>Apellido paterno </strong><br>
                              <%f_padre.DibujaCampo("pers_tape_paterno")%></td>
                          <td><strong>Apellido materno </strong><br>
                              <%f_padre.DibujaCampo("pers_tape_materno")%></td>
                          <td><strong>Nombres</strong><br>
                              <%f_padre.DibujaCampo("pers_tnombre")%></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="33%"><strong>Regi&oacute;n</strong><br>
                              <%f_padre.DibujaCampo("regi_ccod")%>                          </td>
                          <td width="33%"><strong>Ciudad</strong><br>
                              <%f_padre.DibujaCampo("ciud_ccod")%></td>
						  <td width="34%"><strong>Fuera del Grupo Familiar</strong><br>
                              <%f_padre.DibujaCampo("grup_nindependiente")%></td>  
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td><strong>Calle</strong><br> <%f_padre.DibujaCampo("dire_tcalle")%></td>
                              <td><strong>Nº</strong><br> <%f_padre.DibujaCampo("dire_tnro")%></td>
                              <td> <strong>Depto</strong><br>  <%f_padre.DibujaCampo("dire_tblock")%> </td>
							  <td><strong>Condominio/Conjunto</strong><br> <%f_padre.DibujaCampo("dire_tpoblacion")%></td>
                              <td><strong>Tel&eacute;fono</strong><br> <%f_padre.DibujaCampo("dire_tfono")%></td>
                            </tr>
							<tr>
								<td colspan="5" align="right"> <%f_botonera.DibujaBoton("copiar_direccion")%></td>
						     </tr>
                          </table>
					  <br>
					  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td><strong>Nivel Educacional</strong><br> <%f_padre.DibujaCampo("nied_ccod")%></td>
                              <td colspan="2"><strong>Previsi&oacute;n</strong><br><%f_padre.DibujaCampo("prev_ccod")%></td>
                            </tr>
							<tr><td colspan="3">&nbsp;</td></tr>
							<tr> 
                              <td><strong>Prev.Salud</strong><br> <%f_padre.DibujaCampo("prsa_ccod")%></td>
                              <td align="center"><strong>C&oacute;d. Actividad</strong><br><input type="text" name="cod_actividad" size="2" maxlength="2" id="NU-N" value="<%=cod_actividad%>"></td>
							  <td align="center"><strong>Profesi&oacute;n u Oficio</strong><br><input type="text" name="profesion" size="25" maxlength="50" id="TO-N" value="<%=profesion%>"></td>
                            </tr>
						</table>
                      <%f_padre.DibujaCampo("post_ncorr")%><br>                      
                     </td>
                  </tr>
                </table>
			  
			  	  <%f_alumno_direccion.DibujaCampo("ciud_ccod")%>
			 
				  <%f_alumno_direccion.DibujaCampo("regi_ccod")%>
				 
				  <%f_alumno_direccion.DibujaCampo("dire_tcalle")%>
			 
				  <%f_alumno_direccion.DibujaCampo("dire_tnro")%>
				  
				  <%f_alumno_direccion.DibujaCampo("dire_tblock")%>
				  
				  <%f_alumno_direccion.DibujaCampo("dire_tpoblacion")%>
			  
				  <%f_alumno_direccion.DibujaCampo("dire_tfono")%>
				  <input type="hidden" name="grup_nindependiente" value="<%=grup_nindependiente%>">
				  <input type="hidden" name="grupo" value="<%=grupo%>">
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
                    <%f_botonera.DibujaBoton("agregar")%>
                  </div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("cerrar")%>
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

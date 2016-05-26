<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Function SqlGrupoFamiliar(p_pare_ccod,v_post_ncorr,v_pers_ncorr)
	
SqlGrupoFamiliar =" select '"&v_post_ncorr&"' as post_ncorr,'"&p_pare_ccod&"' as pare_ccod, c.pers_ncorr, c.pers_nrut, c.pers_xdv, c.pers_tnombre, c.pers_tape_paterno,    " & VBCRLF & _
" c.pers_tape_materno, c.pers_fnacimiento, c.pers_fdefuncion, c.nedu_ccod, c.pers_tprofesion, c.pers_tempresa, c.pers_tcargo,c.eciv_ccod,pers_temail,pers_tcelular,  " & VBCRLF & _
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
" )  AS REGI_CCOD ,  " & VBCRLF  	& _
" (select dire_tcalle from  " & VBCRLF  	& _
"         direcciones_publica d  " & VBCRLF  	& _
"         where d.pers_ncorr = c.pers_ncorr  " & VBCRLF  	& _
"         and d.tdir_ccod =3  " & VBCRLF  	& _
" ) as  dire_tcalle_empresa,  " & VBCRLF  	& _
" (select dire_tnro from  " & VBCRLF  	& _
"         direcciones_publica d  " & VBCRLF  	& _
"         where d.pers_ncorr = c.pers_ncorr  " & VBCRLF  	& _
"         and d.tdir_ccod =3  " & VBCRLF  	& _
" ) as  dire_tnro_empresa,  " & VBCRLF  	& _
"   (select dire_tfono from  " & VBCRLF  	& _
"         direcciones_publica d  " & VBCRLF  	& _
"         where d.pers_ncorr = c.pers_ncorr  " & VBCRLF  	& _
"         and d.tdir_ccod =3  " & VBCRLF  	& _
" ) as  dire_tfono_EMPRESA,  " & VBCRLF  	& _
" (select dire_tpoblacion from  " & VBCRLF  	& _
"         direcciones_publica d  " & VBCRLF  	& _
"         where d.pers_ncorr = c.pers_ncorr  " & VBCRLF  	& _
"         and d.tdir_ccod =3  " & VBCRLF  	& _
" ) as  dire_tpoblacion_EMPRESA ,  " & VBCRLF  	& _
" (select CIUD_CCOD from  " & VBCRLF  	& _
"         direcciones_publica d  " & VBCRLF  	& _
"         where d.pers_ncorr = c.pers_ncorr  " & VBCRLF  	& _
"         and d.tdir_ccod =3  " & VBCRLF  	& _
" ) as  CIUD_CCOD_EMPRESA,  " & VBCRLF  	& _
" ( SELECT REGI_CCOD FROM  " & VBCRLF  	& _
"   DIRECCIONES_PUBLICA D,CIUDADES E  " & VBCRLF  	& _
"   WHERE D.CIUD_CCOD = E.CIUD_CCOD    " & VBCRLF  	& _
"   AND D.PERS_NCORR = C.PERS_NCORR  " & VBCRLF  	& _
"   AND D.TDIR_CCOD = 3  " & VBCRLF  	& _
" )  AS REGI_CCOD_EMPRESA    " & VBCRLF  	& _
"  from   personas_postulante c" &vbcrlf &_
"  where cast(c.pers_ncorr  as varchar)= '"&v_pers_ncorr&"' " 
'response.Write("<pre>"&SqlGrupoFamiliar&"</pre>")
End function

pers_ncorr_pariente=request.QueryString("pers_ncorr")
v_parentesco=request.QueryString("pare_ccod")

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------

rut_temporal = request.Form("padre[0][pers_nrut]")
xdv_temporal = request.Form("padre[0][pers_xdv]")

if rut_temporal <> "" then
'response.Write("rut "&rut_temporal)
pers_ncorr_pariente = conexion.consultaUno("Select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&rut_temporal&"'")
end if



if(v_parentesco="") then
	v_parentesco=4
end if
v_post_ncorr = Session("post_ncorr")
'response.Write("post_ncorr=" & v_post_ncorr)
if EsVacio(v_post_ncorr) then
	Response.Redirect("inicio.asp")
end if

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Postulación - Antecedentes Familiares"


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "postulacion_4.xml", "botonera"

'######################################################################
' obtiene el rut del alumno para evitar que lo repita como familiar
sql_rut_alumno= " Select pers_nrut " & VBCRLF & _
				" From personas_postulante a, postulantes b " & VBCRLF & _
				" Where a.pers_ncorr=b.pers_ncorr" & VBCRLF & _
				" and b.post_ncorr='"&v_post_ncorr&"' " 

v_rut_alumno=conexion.consultaUno(sql_rut_alumno)				
'######################################################################

sql_existe_padre="Select count(*) as total from grupo_familiar Where pare_ccod=1 and post_ncorr="&v_post_ncorr
sql_existe_madre="Select count(*) as total from grupo_familiar Where pare_ccod=2 and post_ncorr="&v_post_ncorr

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
		filtro_parientes="pare_ccod not in (0)"
	else
		filtro_parientes=" pare_ccod not in (0,1)"
	end if
	
elseif v_existe_madre > 0 then
	if v_parentesco =2 then
		filtro_parientes="pare_ccod not in (0)"
	else
		filtro_parientes=" pare_ccod not in (0,2)"
	end if
end if

if isnull(filtro_parientes) or esVacio(filtro_parientes) or filtro_parientes="" then
	filtro_parientes=" pare_ccod not in (0)"
end if


'---------------------------------------------------------------------------------------------------
set f_padre = new CFormulario
f_padre.Carga_Parametros "postulacion_4.xml", "grupo_familiar"
f_padre.Inicializar conexion
f_padre.AgregaParam "variable", "padre"

consulta = SqlGrupoFamiliar(v_parentesco,v_post_ncorr,pers_ncorr_pariente)
'response.Write("<pre>" & consulta & "</pre>")
  
f_padre.Consultar consulta
f_padre.Siguientef


'---------------------------------------------------------------------------------------------------

  
 if f_padre.nroFilas = 0 and rut_temporal <> "" then
 	f_padre.AgregaCampoCons "pers_nrut",rut_temporal
	f_padre.AgregaCampoCons "pers_xdv",xdv_temporal
 end if 
f_padre.AgregaCampoParam "pare_ccod", "filtro", filtro_parientes
f_padre.AgregaCampoParam "regi_ccod", "script", "onChange=""_FiltrarCombobox(this.form.elements['padre[0][ciud_ccod]'], this.value, d_ciudades, 'regi_ccod', 'ciud_ccod', 'ciud_tdesc', '');"""
f_padre.AgregaCampoParam "regi_ccod_empresa", "script", "onChange=""_FiltrarCombobox(this.form.elements['padre[0][ciud_ccod_empresa]'], this.value, d_ciudades, 'regi_ccod', 'ciud_ccod', 'ciud_tdesc', '');"""

'-----------------------------------------------------------------------------------------------------------
consulta_ciudades = "select regi_ccod, ciud_ccod, ciud_tdesc, ciud_tcomuna from ciudades order by ciud_tdesc asc"
'-------------------------------------------------------------------------------------

'---------- CONSULTA PARA SUGERIR DIRECCION DEL ALUMNO POSTULANTE-------------------------------
set f_alumno_direccion = new CFormulario
f_alumno_direccion.Carga_Parametros "postulacion_4.xml", "direccion_postulante"
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
'response.Write(v_post_ncorr)

	lenguetas_postulacion = Array("Antecedentes Familiares")
	msjRecordatorio = ""
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
	
	/*
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
		t_padre.AsignarValor(0, "dire_tfono", document.edicion.elements['test[0][dire_tfono]'].value);*/
		
		v_ciudad	=	document.edicion.elements["test[0][ciud_ccod]"].value;
		v_region	=   document.edicion.elements["test[0][regi_ccod]"].value;

	if ((!v_ciudad)||(!v_region)){
		alert("El postulante no presenta su direccion completa");
		return false;
	}else{
	
	_FiltrarCombobox(document.edicion.elements["padre[0][ciud_ccod]"], 
	                 document.edicion.elements["padre[0][regi_ccod]"].value,
					 d_ciudades,
					 'regi_ccod',
					 'ciud_ccod',
					 'ciud_tdesc',
					 '+v_ciudad+');
		
		b=document.edicion.elements["test[0][dire_tcalle]"].value;
		c=document.edicion.elements["test[0][dire_tnro]"].value;
		d=document.edicion.elements["test[0][dire_tblock]"].value;
		f=document.edicion.elements["test[0][dire_tpoblacion]"].value;
		g=document.edicion.elements["test[0][dire_tfono]"].value;
		
		document.edicion.elements["padre[0][ciud_ccod]"].value = v_ciudad;
		document.edicion.elements["padre[0][regi_ccod]"].value = v_region;
		
		document.edicion.elements['padre[0][dire_tcalle]'].value = b;
		document.edicion.elements["padre[0][dire_tnro]"].value = c;
		document.edicion.elements["padre[0][dire_tblock]"].value = d;
		document.edicion.elements["padre[0][dire_tpoblacion]"].value=f;
		document.edicion.elements["padre[0][dire_tfono]"].value =g;
		
		
	}	
}



function InicioPagina()
{
	//t_padre = new CTabla("padre");
	
	_FiltrarCombobox(document.edicion.elements["padre[0][ciud_ccod]"], 
	                 document.edicion.elements["padre[0][regi_ccod]"].value,
					 d_ciudades,
					 'regi_ccod',
					 'ciud_ccod',
					 'ciud_tdesc',
					 '<%=f_padre.ObtenerValor("ciud_ccod")%>');
					 
					 
	_FiltrarCombobox(document.edicion.elements["padre[0][ciud_ccod_empresa]"], 
	                 document.edicion.elements["padre[0][regi_ccod_empresa]"].value,
					 d_ciudades,
					 'regi_ccod',
					 'ciud_ccod',
					 'ciud_tdesc',
					 '<%=f_padre.ObtenerValor("ciud_ccod_empresa")%>');
					 
					 
			 
	//t_padre.filas[0].HabilitarPorCampo(!isEmpty(t_padre.ObtenerValor(0, "pers_nrut")), "pers_nrut");
	
}


</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "padre[0][pers_fnacimiento]","1","edicion","fecha_oculta_fnacimiento_papa"
	calendario.MuestraFecha "padre[0][pers_fdefuncion]","2","edicion","fecha_oculta_fdefuncion_papa"
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
                    <td><%pagina.DibujarSubtitulo "Familiar"%>                      
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" >
                            <tr> 
                              <td width="20%"><span class="Estilo2">(*)</span><strong> R.U.T.</strong><br> <%f_padre.DibujaCampo("pers_nrut")%>
                                - 
                                <%f_padre.DibujaCampo("pers_xdv")%></td>
                              <td width="30%"><strong>FECHA DE NACIMIENTO </strong><br> 
                                <%f_padre.DibujaCampo("pers_fnacimiento")%> <%calendario.DibujaImagen "fecha_oculta_fnacimiento_papa","1","edicion" %> </td>
                              <td width="30%"><strong>FECHA DE DEFUNCION </strong><br> 
                                <%f_padre.DibujaCampo("pers_fdefuncion")%> <%calendario.DibujaImagen "fecha_oculta_fdefuncion_papa","2","edicion" %> </td>
							  <td width="20%"><span class="Estilo2">(*)</span><strong>PARENTESCO</strong><BR><%f_padre.DibujaCampo("pare_ccod")%></td>
                            </tr>
                          </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><span class="Estilo2">(*)</span><strong> APELLIDO PATERNO </strong><br>
                              <%f_padre.DibujaCampo("pers_tape_paterno")%></td>
                          <td><span class="Estilo2">(*)</span><strong> APELLIDO MATERNO </strong><br>
                              <%f_padre.DibujaCampo("pers_tape_materno")%></td>
                          <td><span class="Estilo2">(*)</span><strong> NOMBRES</strong><br>
                              <%f_padre.DibujaCampo("pers_tnombre")%></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="40%"><strong>REGI&Oacute;N</strong><br>
                              <%f_padre.DibujaCampo("regi_ccod")%>                          </td>
                              <td width="40%"><strong>CIUDAD DE PROCEDENCIA</strong><br>
                              <%f_padre.DibujaCampo("ciud_ccod")%></td>
							  <td width="20%"><span class="Estilo2">(*)</span><strong>EST. CIVIL</strong><br>
                              <%f_padre.DibujaCampo("eciv_ccod")%></td>
                        </tr>
                      </table>
                      <br>
						<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
						<tr> 
                              <td><strong>CALLE</strong><br> <%f_padre.DibujaCampo("dire_tcalle")%></td>
                              <td><strong>N&Uacute;MERO</strong><br> <%f_padre.DibujaCampo("dire_tnro")%></td>
                              <td> <strong>DEPTO</strong><br>  <%f_padre.DibujaCampo("dire_tblock")%> </td>
							  <td><strong>CONDOMINIO/CONJUNTO</strong><br> <%f_padre.DibujaCampo("dire_tpoblacion")%></td>
                              <td><strong>TEL&Eacute;FONO</strong><br> <%f_padre.DibujaCampo("dire_tfono")%></td>
                            </tr>
					</table>
					<br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                            
							<tr> 
                              <td><strong>CELULAR</strong><br> <%f_padre.DibujaCampo("pers_tcelular")%></td>
                              <td colspan="2"><strong>EMAIL</strong><br> <%f_padre.DibujaCampo("pers_temail")%></td>
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                            </tr>
                             <tr>
								<td colspan="4" align="right"> <%f_botonera.DibujaBoton("copiar_direccion")%></td>
						     </tr>
                          </table>
					  <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><strong>ESCOLARIDAD (&Uacute;LTIMO A&Ntilde;O CURSADO) </strong><br>
                            <%f_padre.DibujaCampo("nedu_ccod")%></td>
                        </tr>
                      </table>
                      <br>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><strong>PROFESI&Oacute;N U OFICIO </strong><br>
                              <%f_padre.DibujaCampo("pers_tprofesion")%></td>
                          <td><strong>EMPRESA</strong><br>
                              <%f_padre.DibujaCampo("pers_tempresa")%></td>
                          <td><strong>CARGO O ACTIVIDAD </strong><br>
                              <%f_padre.DibujaCampo("pers_tcargo")%></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="50%"><strong>REGI&Oacute;N</strong><br>
                              <%f_padre.DibujaCampo("regi_ccod_empresa")%>                          </td>
                          <td width="50%"><strong>CIUDAD O LOCALIDAD</strong><br>
                              <%f_padre.DibujaCampo("ciud_ccod_empresa")%></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td><strong>CALLE</strong><br> 
                                <%f_padre.DibujaCampo("dire_tcalle_empresa")%>
                              </td>
                              <td><strong>N&Uacute;MERO</strong><br> 
                                <%f_padre.DibujaCampo("dire_tnro_empresa")%>
                              </td>
							  <td> <b>CONJUNTO/CONDOMINIO</b><br> 
                                <%f_padre.DibujaCampo("dire_tpoblacion_empresa")%>
                              </td>
                              <td><strong>TEL&Eacute;FONO</strong><br> 
                                <%f_padre.DibujaCampo("dire_tfono_empresa")%>
                              </td>
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

<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion_cpp.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
set conexion = new cConexion2
conexion.inicializar "upacifico"

'---------------------------------------------------------------------------------------------------
rut = request.querystring("busqueda[0][pers_nrut]")
digito = request.querystring("busqueda[0][pers_xdv]")
tipo = request.querystring("busqueda[0][tipo]")
'--------------------------------------------------------------------------

 set botonera = new CFormulario2
 botonera.Carga_Parametros "cpp_externos.xml", "botonera"
'response.End()
 set f_busqueda = new CFormulario2
 f_busqueda.Carga_Parametros "cpp_externos.xml", "busqueda_usuarios"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' "
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut
 f_busqueda.AgregaCampoCons "pers_xdv", digito

if rut <> "" then 
         
		 pers_ncorr = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&rut&"'")
		 ofer_ncorr = conexion.consultaUno("select top 1 ofer_ncorr from alumnos where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and emat_ccod in (4,8)")
		 carr_ccod  = conexion.consultaUno("select carr_ccod from ofertas_academicas a, especialidades b where a.espe_ccod=b.espe_ccod and cast(a.ofer_ncorr as varchar)='"&ofer_ncorr&"'")
		 jorn_ccod  = conexion.consultaUno("select jorn_ccod from ofertas_academicas where cast(ofer_ncorr as varchar)='"&ofer_ncorr&"'")
		
		 c_titulado = "select sum(total) " & vbCrLf &_
					  "	from( " & vbCrLf &_
					  "		select count(*) as total from alumnos where emat_ccod in (4,8) and cast(pers_ncorr as varchar)='"&pers_ncorr&"' " & vbCrLf &_
					  "		union " & vbCrLf &_
					  "		select count(*) as total from egresados_upa2 where cast(pers_nrut as varchar)='"&rut&"' " & vbCrLf &_
   				      "		union " & vbCrLf &_
					  "		select count(*) as total from alumnos_salidas_intermedias where emat_ccod in (4,8) and cast(pers_ncorr as varchar)='"&pers_ncorr&"' " & vbCrLf &_
					  "		)table_1"
		 titulado = conexion.consultaUno(c_titulado)
		 if titulado <> "0" then 
		 
				 if tipo = 1 then 
					 set f_datos_personales = new CFormulario2
					 f_datos_personales.Carga_Parametros "cpp_externos.xml", "datos_personales"
					 f_datos_personales.Inicializar conexion
					 
					 carrera = conexion.consultaUno("select carr_tdesc from carreras where carr_ccod='"&carr_ccod&"'")
					 jornada = conexion.consultaUno("select jorn_tdesc from jornadas where cast(jorn_ccod as varchar)='"&jorn_ccod&"'")
					
					 consulta =  "   select b.pers_nrut, b.pers_xdv,b.pais_ccod, b.pers_tape_paterno, b.pers_tape_materno, b.pers_tnombre, b.pers_ncorr, " & vbCrLf &_
								"   b.sexo_ccod,isnull(pers_temail,'') as pers_temail,b.pers_tfono,b.pers_tcelular,b.pers_fnacimiento,pers_tfax, " & vbCrLf &_
								"   b.eciv_ccod,c.dire_tcalle,c.dire_tnro,c.dire_tpoblacion,c.ciud_ccod,c.dire_tblock,regi_particular,ciud_particular, " & vbCrLf &_
								"   d.cod_postal,d.num_hijos,d.tsoc_ccod,convert(varchar,fecha_incorporacion,103) as fecha_incorporacion,convert(varchar,fecha_vencimiento,103) as fecha_vencimiento,observaciones, otro_email_personal,otra_carrera,otro_titulo_grado,otra_institucion,otro_anio, isnull(tipo_contacto,'P') as tipo_contacto,isnull(recibir_info,'SI') as recibir_info " & vbCrLf &_
								"   from  personas b left outer join direcciones c " & vbCrLf &_
								"        on b.pers_ncorr = c.pers_ncorr and  2=c.tdir_ccod " & vbCrLf &_
								"   left outer join datos_adicionales_egresados d " & vbCrLf &_
								"        on b.pers_ncorr = d.pers_ncorr " & vbCrLf &_
								"   where cast(b.pers_ncorr as varchar)= '" & pers_ncorr & "'"
					
					'response.Write("<pre>"&consulta&"</pre>")
					f_datos_personales.Consultar consulta
					f_datos_personales.Siguiente
					
					pais_temporal = f_datos_personales.obtenerValor("pais_ccod")
					tipo_contacto = f_datos_personales.obtenerValor("tipo_contacto")
					recibir_info = f_datos_personales.obtenerValor("recibir_info")
					'response.Write("tipo_contacto "&tipo_contacto&" recibir_info "&recibir_info)
					'------------------en el casod e ser un pais distinto a chile entonces debemos habilitar los campos especiales y deshabilar los otros.
					asterisco1 = ""
					asterisco2 = ""
					asterisco3 = ""
					asterisco4 = ""
					asterisco5 = ""
					if pais_temporal <> "1" and pais_temporal <> "" then
						 f_datos_personales.agregaCampoParam "regi_particular","deshabilitado","false"
						 f_datos_personales.agregaCampoParam "ciud_particular","deshabilitado","false"
						 f_datos_personales.agregaCampoParam "regi_particular", "id" , "TO-N"
						 f_datos_personales.agregaCampoParam "ciud_particular", "id" , "TO-N"
						 asterisco1 = "*"
						 asterisco2 = "*"
						 f_datos_personales.agregaCampoParam "ciud_ccod","deshabilitado","true"
						 f_datos_personales.agregaCampoParam "dire_tcalle","deshabilitado","true"
						 f_datos_personales.agregaCampoParam "dire_tnro","deshabilitado","true"
						 f_datos_personales.agregaCampoParam "dire_tblock","deshabilitado","true"
						 f_datos_personales.agregaCampoParam "dire_tpoblacion","deshabilitado","true"
						 f_datos_personales.agregaCampoParam "ciud_ccod", "id" , "TO-S"
						 f_datos_personales.agregaCampoParam "dire_tcalle" , "id", "TO-S"
						 f_datos_personales.agregaCampoParam "dire_tnro" , "id" , "TO-S"
						 f_datos_personales.agregaCampoParam "dire_tblock" ,"id" , "TO-S"
						 f_datos_personales.agregaCampoParam "dire_tpoblacion","id", "TO-S"
						 asterisco3 = ""
						 asterisco4 = ""
						 asterisco5 = ""
					else
						 f_datos_personales.agregaCampoParam "regi_particular","deshabilitado","true"
						 f_datos_personales.agregaCampoParam "ciud_particular","deshabilitado","true"
						 f_datos_personales.agregaCampoParam "regi_particular", "id" , "TO-S"
						 f_datos_personales.agregaCampoParam "ciud_particular", "id" , "TO-S"
						 asterisco1 = ""
						 asterisco2 = ""
						 f_datos_personales.agregaCampoParam "ciud_ccod","deshabilitado","false"
						 f_datos_personales.agregaCampoParam "dire_tcalle","deshabilitado","false"
						 f_datos_personales.agregaCampoParam "dire_tnro","deshabilitado","false"
						 f_datos_personales.agregaCampoParam "dire_tblock","deshabilitado","false"
						 f_datos_personales.agregaCampoParam "dire_tpoblacion","deshabilitado","false"
						 f_datos_personales.agregaCampoParam "ciud_ccod", "id" , "TO-N"
						 f_datos_personales.agregaCampoParam "dire_tcalle" , "id", "TO-N"
						 f_datos_personales.agregaCampoParam "dire_tnro" , "id" , "TO-N"
						 f_datos_personales.agregaCampoParam "dire_tblock" ,"id" , "TO-S"
						 f_datos_personales.agregaCampoParam "dire_tpoblacion","id", "TO-S" 
						 asterisco3 = "*"
						 asterisco4 = "*"
						 asterisco5 = "*"
					end if
				elseif tipo = 2 then
					set f_datos_laborales = new CFormulario2
					f_datos_laborales.Carga_Parametros "cpp_externos.xml", "datos_laborales"
					f_datos_laborales.Inicializar conexion
					
					dlpr_ncorr = conexion.consultaUno("select top 1 dlpr_ncorr from direccion_laboral_profesionales where cast(pers_ncorr as varchar)='"&pers_ncorr&"' order by audi_fmodificacion desc") 
		
					consulta =  " select top 1 a.dlpr_ncorr,c.pers_nrut,c.pers_xdv, c.pers_tnombre,c.pers_tape_paterno,c.pers_tape_materno, " & vbCrLf &_
								" c.pers_ncorr,a.pais_ccod,a.ciud_ccod,a.dlpr_cpostal,a.dlpr_tcalle,a.dlpr_tnro,a.dlpr_tpoblacion,a.dlpr_tblock, " & vbCrLf &_
								" a.dlpr_tfono,a.dire_tfax,a.dlpr_nombre_empresa,a.dlpr_rubro_empresa,a.dlpr_cargo_empresa,a.dlpr_depto_empresa, " & vbCrLf &_
								" a.dlpr_email_empresa,a.dlpr_web_empresa,a.dlpr_tobservacion,a.dlpr_regi_particular,a.dlpr_ciud_particular,isnull(b.tipo_contacto,'P') as tipo_contacto, "& vbCrLf &_
								" isnull(b.recibir_info,'SI') as recibir_info, isnull(a.dlpr_empleado,'si') as dlpr_empleado, isnull(a.dlpr_duenio,'no') as dlpr_duenio, " & vbCrLf &_
								" a.dlpr_nombre_empresa_propia,a.dlpr_rubro_empresa_propia,isnull(a.dlpr_independiente,'no') as dlpr_independiente,a.dlpr_rubro_independiente " & vbCrLf &_
								" from personas c left outer join direccion_laboral_profesionales a " & vbCrLf &_
								"      on a.pers_ncorr = c.pers_ncorr " & vbCrLf &_
								" left outer join datos_adicionales_egresados b  " & vbCrLf &_
								"     on b.pers_ncorr=c.pers_ncorr  " & vbCrLf &_
								" where cast(c.pers_ncorr as varchar)='"&pers_ncorr&"' " & vbCrLf &_
								" order by a.audi_fmodificacion desc " 
					
					
					'response.Write("<pre>"&consulta&"</pre>")
					'response.End()
					f_datos_laborales.Consultar consulta
					
					if f_datos_laborales.nroFilas = "0" then
						f_datos_laborales.Consultar "select ''"
					end if
					f_datos_laborales.Siguiente
					
					pais_temporal = f_datos_laborales.obtenerValor("pais_ccod")
					tipo_contacto = f_datos_laborales.obtenerValor("tipo_contacto")
					recibir_info = f_datos_laborales.obtenerValor("recibir_info")
					'response.Write("tipo_contacto "&tipo_contacto&" recibir_info "&recibir_info)
					'response.Write(pais_temporal)
					'------------------en el casod e ser un pais distinto a chile entonces debemos habilitar los campos especiales y deshabilar los otros.
					asterisco1 = ""
					asterisco2 = ""
					asterisco3 = ""
					asterisco4 = ""
					asterisco5 = ""
					if pais_temporal <> "1" and pais_temporal <> "" then
						 f_datos_laborales.agregaCampoParam "dlpr_regi_particular","deshabilitado","false"
						 f_datos_laborales.agregaCampoParam "dlpr_ciud_particular","deshabilitado","false"
						 f_datos_laborales.agregaCampoParam "dlpr_regi_particular", "id" , "TO-N"
						 f_datos_laborales.agregaCampoParam "dlpr_ciud_particular", "id" , "TO-N"
						 asterisco1 = "*"
						 asterisco2 = "*"
						 f_datos_laborales.agregaCampoParam "ciud_ccod","deshabilitado","true"
						 f_datos_laborales.agregaCampoParam "dlpr_tcalle","deshabilitado","true"
						 f_datos_laborales.agregaCampoParam "dlpr_tnro","deshabilitado","true"
						 f_datos_laborales.agregaCampoParam "dlpr_tblock","deshabilitado","true"
						 f_datos_laborales.agregaCampoParam "ciud_ccod", "id" , "TO-S"
						 f_datos_laborales.agregaCampoParam "dlpr_tcalle" , "id", "TO-S"
						 f_datos_laborales.agregaCampoParam "dlpr_tnro" , "id" , "TO-S"
						 f_datos_laborales.agregaCampoParam "dlpr_tblock" ,"id" , "TO-S"
						 asterisco3 = ""
					     asterisco4 = ""
					     asterisco5 = ""
					else
						 f_datos_laborales.agregaCampoParam "dlpr_regi_particular","deshabilitado","true"
						 f_datos_laborales.agregaCampoParam "dlpr_ciud_particular","deshabilitado","true"
						 f_datos_laborales.agregaCampoParam "dlpr_regi_particular", "id" , "TO-S"
						 f_datos_laborales.agregaCampoParam "dlpr_ciud_particular", "id" , "TO-S"
						 asterisco1 = ""
						 asterisco2 = ""
						 f_datos_laborales.agregaCampoParam "ciud_ccod","deshabilitado","false"
						 f_datos_laborales.agregaCampoParam "dlpr_tcalle","deshabilitado","false"
						 f_datos_laborales.agregaCampoParam "dlpr_tnro","deshabilitado","false"
						 f_datos_laborales.agregaCampoParam "dlpr_tblock","deshabilitado","false"
						 f_datos_laborales.agregaCampoParam "ciud_ccod", "id" , "TO-S"
						 f_datos_laborales.agregaCampoParam "dlpr_tcalle" , "id", "TO-S"
						 f_datos_laborales.agregaCampoParam "dlpr_tnro" , "id" , "TO-S"
						 f_datos_laborales.agregaCampoParam "dlpr_tblock" ,"id" , "TO-S"
						 asterisco3 = "*"
						 asterisco4 = "*"
						 asterisco5 = "*"
					end if
				
				end if
			else ' en caso de no tener registros de titulado
				mensaje_no_titulado = "Lo Sentimos pero este rut no presenta asociada una matr�cula de egresado o titulado en nuestros sistemas. Le solicitamos comunicarse con la direcci�n de CPP para solucionar dicho problema."
			end if
else
		mensaje_no_titulado=""
end if 'por si el rut es distinto de vacio


%>
<html>
<head>
<title>CPP</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_inicio.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" src="../biblioteca/dicc_ciudades.js"></script>

<script language="JavaScript">

function Validar( tipo )
{
	formulario = document.buscador;
	
	rut_alumno = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	formulario.elements["busqueda[0][tipo]"].value = tipo;
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT v�lido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }
	
	 
	
	return true;
}


function cambiar_ciudad(valor)
{var formulario;
     formulario = document.edicion;
	 //alert("valor "+valor);
	 if ((valor != "") &&(valor != "1"))
	 {
	 	formulario.elements["dp[0][regi_particular]"].disabled = false;
	 	formulario.elements["dp[0][ciud_particular]"].disabled = false;
		formulario.elements["dp[0][regi_particular]"].id = "TO-N";
	 	formulario.elements["dp[0][ciud_particular]"].id = "TO-N";
		formulario.ext1.value = "*";
		formulario.ext2.value = "*";
	 	
		formulario.elements["dp[0][ciud_ccod]"].disabled = true;
	 	formulario.elements["dp[0][dire_tcalle]"].disabled = true;
	 	formulario.elements["dp[0][dire_tnro]"].disabled = true;
	 	formulario.elements["dp[0][dire_tblock]"].disabled = true;
	 	formulario.elements["dp[0][dire_tpoblacion]"].disabled = true;
		formulario.elements["dp[0][ciud_ccod]"].id = "TO-S";
	 	formulario.elements["dp[0][dire_tcalle]"].id = "TO-S";
	 	formulario.elements["dp[0][dire_tnro]"].id = "TO-S";
	 	formulario.elements["dp[0][dire_tblock]"].id = "TO-S";
	 	formulario.elements["dp[0][dire_tpoblacion]"].id = "TO-S";
		formulario.nac1.value = "";
		formulario.nac2.value = "";
		formulario.nac3.value = "";
		
	 }
	 else
	 {
	 	formulario.elements["dp[0][regi_particular]"].disabled = true;
	 	formulario.elements["dp[0][ciud_particular]"].disabled = true;
		formulario.elements["dp[0][regi_particular]"].id = "TO-S";
	 	formulario.elements["dp[0][ciud_particular]"].id = "TO-S";
		formulario.ext1.value = "";
		formulario.ext2.value = "";
		
	 	formulario.elements["dp[0][ciud_ccod]"].disabled = false;
	 	formulario.elements["dp[0][dire_tcalle]"].disabled = false;
	 	formulario.elements["dp[0][dire_tnro]"].disabled = false;
	 	formulario.elements["dp[0][dire_tblock]"].disabled = false;
	 	formulario.elements["dp[0][dire_tpoblacion]"].disabled = false;
		formulario.elements["dp[0][ciud_ccod]"].id = "TO-N";
	 	formulario.elements["dp[0][dire_tcalle]"].id = "TO-N";
	 	formulario.elements["dp[0][dire_tnro]"].id = "TO-N";
	 	formulario.elements["dp[0][dire_tblock]"].id = "TO-S";
	 	formulario.elements["dp[0][dire_tpoblacion]"].id = "TO-S";
		formulario.nac1.value = "*";
		formulario.nac2.value = "*";
		formulario.nac3.value = "*";
	 }
}


function cambiar_ciudad2(valor)
{var formulario;
     formulario = document.edicion;
	 //alert("valor "+valor);
	 if ((valor != "") &&(valor != "1"))
	 {
	 	formulario.elements["dp[0][dlpr_regi_particular]"].disabled = false;
	 	formulario.elements["dp[0][dlpr_ciud_particular]"].disabled = false;
		formulario.elements["dp[0][dlpr_regi_particular]"].id = "TO-N";
	 	formulario.elements["dp[0][dlpr_ciud_particular]"].id = "TO-N";
		formulario.ext1.value = "*";
		formulario.ext2.value = "*";
	 	formulario.elements["dp[0][ciud_ccod]"].disabled = true;
	 	formulario.elements["dp[0][dlpr_tcalle]"].disabled = true;
	 	formulario.elements["dp[0][dlpr_tnro]"].disabled = true;
	 	formulario.elements["dp[0][dlpr_tblock]"].disabled = true;
		formulario.elements["dp[0][ciud_ccod]"].id = "TO-S";
	 	formulario.elements["dp[0][dlpr_tcalle]"].id = "TO-S";
	 	formulario.elements["dp[0][dlpr_tnro]"].id = "TO-S";
	 	formulario.elements["dp[0][dlpr_tblock]"].id = "TO-S";
		formulario.nac1.value = "";
		formulario.nac2.value = "";
		formulario.nac3.value = "";
	 }
	 else
	 {
	 	formulario.elements["dp[0][dlpr_regi_particular]"].disabled = true;
	 	formulario.elements["dp[0][dlpr_ciud_particular]"].disabled = true;
		formulario.elements["dp[0][dlpr_regi_particular]"].id = "TO-S";
	 	formulario.elements["dp[0][dlpr_ciud_particular]"].id = "TO-S";
		formulario.ext1.value = "";
		formulario.ext2.value = "";
	 	formulario.elements["dp[0][ciud_ccod]"].disabled = false;
	 	formulario.elements["dp[0][dlpr_tcalle]"].disabled = false;
	 	formulario.elements["dp[0][dlpr_tnro]"].disabled = false;
	 	formulario.elements["dp[0][dlpr_tblock]"].disabled = false;
		formulario.elements["dp[0][ciud_ccod]"].id = "TO-N";
	 	formulario.elements["dp[0][dlpr_tcalle]"].id = "TO-N";
	 	formulario.elements["dp[0][dlpr_tnro]"].id = "TO-N";
	 	formulario.elements["dp[0][dlpr_tblock]"].id = "TO-S";
		formulario.nac1.value = "*";
		formulario.nac2.value = "*";
		formulario.nac3.value = "*";
	 }
}

</script>

<style>
@media print{ .noprint {visibility:hidden; }}
</style>
<style type="text/css">
<!--
td {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 8px;
}
h1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 16px;
}
-->
</style>
</head>
<body bgcolor="#ffffff">
<center>
<table width="851" cellpadding="0" cellspacing="0" border="1" bordercolor="#000000">
<tr valign="top">
<td width="100%">

<table width="851" cellpadding="0" cellspacing="0" border="0">
	<tr valign="top">
		<td width="13" background="imagenes_certificado/fondo_izquierda.jpg">&nbsp;</td>	
	    <td width="836" bgcolor="#FFFFFF">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr valign="top">
					<td width="297" height="86"><img width="297" height="86" border="0" src="imagenes_certificado/frame_0.jpg"></td>
					<td width="539" height="86"><img width="539" height="86" border="0" src="imagenes_certificado/frame_1.jpg"></td>
				</tr>
				<tr valign="top">
					
            <td width="297" height="86"><img width="297" height="86" border="0" src="imagenes_certificado/frame2.jpg"></td>
			<td width="539" height="86">
			      <!-----------inicio cuadro con rut de busqueda------->
					    <table width="500" cellpadding="0" cellspacing="0" align="right">
						<tr>
							<td width="33" height="33" align="right"><img src="imagenes_certificado/izquierda_sup.jpg" width="33" height="33"></td>
							<td width="428" align="right"><img src="imagenes_certificado/superior.jpg" width="428" height="33"></td>
							<td width="39" height="33" align="left"><img src="imagenes_certificado/derecha_sup.jpg" width="35" height="33"></td>
						</tr>
						<tr valign="top">
							  <td width="33" align="right" background="imagenes_certificado/izquierda_lado.jpg">&nbsp;</td>
							  <td bgcolor="#FFFFFF" width="428">
								   <div align="center"> 
									  <form name="buscador">
										<table width="98%"  border="0" cellpadding="0" cellspacing="0">
										  <tr> 
											<td width="81%"><input type="hidden" name="busqueda[0][tipo]" value="">
											   <table width="100%" border="0" cellpadding="0" cellspacing="0">
												<tr> 
												  <td width="40%" align="right"><font size="2"><strong></strong>Rut Egresado</font></td>
												  <td width="1%">:</td>
												  <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
													<%f_busqueda.DibujaCampo("pers_nrut") %>-<%f_busqueda.DibujaCampo("pers_xdv")%>
													</font></td>
												</tr>
											   </table></td>
												<td width="19%"><div align="center"> 
													<%botonera.DibujaBoton "actualiza1" %>
												  </div></td>
										  </tr>
										  <tr> 
											<td width="81%">&nbsp;</td>
												<td width="19%"><div align="center"> 
													<%botonera.DibujaBoton "actualiza2" %>
												  </div></td>
										  </tr>
										</table>
									  </form>
									</div>
									</td>
							        <td width="39" align="left" background="imagenes_certificado/derecha_lado.jpg">&nbsp;</td>
						</tr>
						<tr valign="top">
							<td width="33" height="36" align="right"><img src="imagenes_certificado/izquierda_inf.jpg" width="33" height="36"></td>
							<td width="428" bgcolor="#FFFFFF" height="36" align="right"><img width="428" height="36" src="imagenes_certificado/inferior.jpg"></td>
							<td width="39" height="36" align="left"><img src="imagenes_certificado/derecha_inf.jpg" width="35" height="36"></td>
						</tr>
						</table>
					    <!------------Fin de cuadro con rut de b�squeda--->
					</td>
				</tr>
			    <tr>
					<td colspan="2" align="right">
					<!------------inicio de cuadro con datos--->
						<table width="672" border="0" cellpadding="0" cellspacing="0">
						<tr><td colspan="3"><font size="2">&nbsp;</font></td></tr>
						<tr>
							<td width="33" height="33" align="right"><img src="imagenes_certificado/izquierda_sup.jpg" width="33" height="33"></td>
							<td width="550"><img src="imagenes_certificado/superior.jpg" width="600" height="33"></td>
							<td width="39" height="33" align="left"><img src="imagenes_certificado/derecha_sup.jpg" width="35" height="33"></td>
						</tr>
						<tr valign="top">
							<td width="33" align="right" background="imagenes_certificado/izquierda_lado.jpg">&nbsp;</td>
							<%if rut <> "" and mensaje_no_titulado = "" then%>
							<form name="edicion">
							<td bgcolor="#FFFFFF" width="600">
								<table width="100%" cellpadding="0" cellspacing="0" border="0">
								  <tr><td width="100%" align="left"><font size="3" face="Times New Roman, Times, serif"><strong>Directorio de Egresados CPP</strong></font></td></tr>
								  <tr><td width="100%"><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></td></tr>
								  <tr><td width="100%"><font size="2">Estimado(a) Egresado(a):</font></td></tr>
								  <tr><td width="100%"><font size="1">&nbsp;</font></td></tr>
								  <tr> 
									  <td width="100%"><font size="2">La informaci�n que solicitamos ser� de uso exclusivo y protegido de nuestra Universidad y sus egresados. Rogamos completar todos los campos de consulta.</font></td>
								  </tr>
								  <tr><td width="100%"><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></td></tr>
								  <tr><td width="100%" align="left"><font size="3"><strong>Datos Personales</strong></font></td></tr>
								  <tr><td width="100%" align="center">
											<table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
												<tr valign="middle">
													<td width="17%" align="right"><font size="2"><font color="#CC0000">*</font>Rut</font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td width="30%" align="left"><font size="2"><%if tipo = 1 then 
																									   f_datos_personales.dibujaCampo("pers_nrut") %>
																									   - 
																									   <%f_datos_personales.dibujaCampo("pers_xdv") 
																								   elseif tipo = 2 then 
																									   f_datos_laborales.dibujaCampo("pers_nrut")%>
																									   - 
																									   <%f_datos_laborales.dibujaCampo("pers_xdv")   
																								   end if%></font></td>
													<td width="17%" align="right"><font size="2"><font color="#CC0000">*</font>Nombres</font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td width="32%" align="left"><font size="2"><%if tipo = 1 then 
																										f_datos_personales.dibujaCampo("pers_tnombre")
																								  elseif tipo = 2 then  
																										response.Write(f_datos_laborales.obtenerValor("pers_tnombre")) 
																								  end if%></font></td>
												</tr>
												<tr valign="middle">
													
                                      <td width="17%" align="right"><font size="2"><font color="#CC0000">*</font>A.Paterno</font></td>
													<td width="2%" align="center"><font size="2">:</font><%  if tipo = 1 then 
																											   f_datos_personales.dibujaCampo("pers_ncorr")
																											 elseif tipo = 2 then 
																											   f_datos_laborales.dibujaCampo("pers_ncorr")
																											 end if%></td>
													<td width="30%" align="left"><font size="2"><%if tipo = 1 then 
																									   f_datos_personales.dibujaCampo("pers_tape_paterno") 
																								  elseif tipo = 2 then 
																									   response.Write(f_datos_laborales.obtenerValor("pers_tape_paterno")) 
																								  end if%></font></td>
													
                                      <td width="17%" align="right"><font size="2"><font color="#CC0000">*</font>A.Materno</font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td width="32%" align="left"><font size="2"><%if tipo = 1 then 
																									   f_datos_personales.dibujaCampo("pers_tape_materno") 
																								  elseif tipo = 2 then 
																									   response.Write(f_datos_laborales.obtenerValor("pers_tape_materno")) 
																								  end if%></font></td>
												</tr>
												<%if tipo = 1 then %>
												<tr valign="middle">
													<td width="17%" align="right"><font size="2"><font color="#CC0000">*</font>Sexo</font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td colspan="4" align="left"><%f_datos_personales.dibujaCampo("sexo_ccod")%></td>
												</tr>
												<tr><td colspan="6" align="left"><font size="2"><strong>Direcci�n Personal</strong></font></td></tr>
												<tr valign="middle">
													<td width="17%" align="right"><font size="2"><font color="#CC0000">*</font>Pa�s</font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td colspan="4" align="left"><%f_datos_personales.dibujaCampo("pais_ccod")%></td>
												</tr>
												<tr valign="middle">
													<td colspan="6" align="center"><font size="2" color="#000099">Ubicaci�n en el Extranjero</font></td>
												</tr>
												<tr valign="middle">
													<td colspan="6" align="center">
													<table width="95%" cellpadding="0" cellspacing="0" border="1" bordercolor="#000099">
													<tr valign="middle"><td width="100%">
														<table width="100%" cellpadding="0" cellspacing="0" border="0">
															<tr valign="middle">
																<td width="15%" align="right"><input type="text" name="ext1" size="1" maxlength="1" value="<%=asterisco1%>" style="border:none; color:red"><font size="2">Ciudad</font></td>
																<td width="2%" align="center"><font size="2">:</font></td>
																<td width="83%" colspan="4" align="left"><%f_datos_personales.dibujaCampo("ciud_particular")%></td>
															</tr>
															<tr valign="middle">
																<td width="15%" align="right"><input type="text" name="ext2" size="1" maxlength="1" value="<%=asterisco2%>" style="border:none; color:red"><font size="2">Direcci�n</font></td>
																<td width="2%" align="center"><font size="2">:</font></td>
																<td colspan="4" align="left"><%f_datos_personales.dibujaCampo("regi_particular")%></td>
															</tr>
														</table></td>
													</tr>
													</table>
													</td>
												</tr>
												<tr valign="top">
													<td colspan="6" align="center"><font size="1" color="#000099">&nbsp;</font></td>
												</tr>
												<tr valign="top">
													<td colspan="6" align="center"><font size="2" color="#000099">Ubicaci�n dentro de Chile</font></td>
												</tr>
												<tr valign="top">
													<td colspan="6" align="center">
													<table width="95%" cellpadding="0" cellspacing="0" border="1" bordercolor="#000099">
													<tr valign="top"><td width="100%">
														<table width="100%" cellpadding="0" cellspacing="0" border="0">
															<tr valign="top">
																<td width="17%" align="right"><input type="text" name="nac1" size="1" maxlength="1" value="<%=asterisco3%>" style="border:none; color:red"><font size="2">Comuna</font></td>
																<td width="2%" align="center"><font size="2">:</font></td>
																<td colspan="4" align="left"><%f_datos_personales.dibujaCampo("ciud_ccod")%></td>
															</tr>
															<tr valign="top">
																<td width="17%" align="right"><input type="text" name="nac2" size="1" maxlength="1" value="<%=asterisco4%>" style="border:none; color:red"><font size="2">Direcci�n</font></td>
																<td width="2%" align="center"><font size="2">:</font></td>
																<td width="30%" align="left"><%f_datos_personales.dibujaCampo("dire_tcalle")%></td>
																<td width="17%" align="right"><input type="text" name="nac3" size="1" maxlength="1" value="<%=asterisco5%>" style="border:none; color:red"><font size="2">N�</font></td>
																<td width="2%" align="center"><font size="2">:</font></td>
																<td width="32%" align="left"><%f_datos_personales.dibujaCampo("dire_tnro")%></td>
															</tr>
															<tr valign="top">
																<td width="17%" align="right"><font size="2">Departamento</font></td>
																<td width="2%" align="center"><font size="2">:</font></td>
																<td width="30%" align="left"><%f_datos_personales.dibujaCampo("dire_tblock")%></td>
																<td width="17%" align="right"><font size="2">&nbsp;</font></td>
																<td width="2%" align="center"><font size="2">&nbsp;</font></td>
																<td width="32%" align="left">&nbsp;</td>
															</tr>
															<tr valign="top">
																<td width="17%" align="right"><font size="2">Condominio</font></td>
																<td width="2%" align="center"><font size="2">:</font></td>
																<td width="30%" align="left"><%f_datos_personales.dibujaCampo("dire_tpoblacion")%></td>
																<td width="17%" align="right"><font size="2">&nbsp;</font></td>
																<td width="2%" align="center"><font size="2">&nbsp;</font></td>
																<td width="32%" align="left">&nbsp;</td>
															</tr>
														</table></td>
													</tr>
													</table>
													</td>
												</tr>
												<tr><td colspan="6"><font size="1">&nbsp;</font></td></tr>
												<tr valign="top">
													<td width="17%" align="right"><font size="2">Cod. Postal</font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td colspan="4" align="left"><%f_datos_personales.dibujaCampo("cod_postal")%></td>
												</tr>
												<tr valign="top">
													<td width="17%" align="right"><font size="2"><font color="#CC0000">*</font>Fono</font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td width="30%" align="left"><%f_datos_personales.dibujaCampo("pers_tfono")%></td>
													<td width="17%" align="right"><font size="2"><font color="#CC0000">*</font>Celular</font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td width="32%" align="left"><%f_datos_personales.dibujaCampo("pers_tcelular")%></td>
												</tr>
												<tr valign="top">
													<td width="17%" align="right"><font size="2"><font color="#CC0000">*</font>E-Mail </font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td width="30%" align="left"><%f_datos_personales.dibujaCampo("pers_temail")%></td>
													<td width="17%" align="right">&nbsp;</td>
													<td width="2%" align="center">&nbsp;</td>
													<td width="32%" align="left">&nbsp;</td>
												</tr>
												<tr valign="top">
													<td width="17%" align="right"><font size="2">Otro E-Mail </font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td width="30%" colspan="4" align="left"><%f_datos_personales.dibujaCampo("otro_email_personal")%></td>
												</tr>
												<tr><td width="100%" colspan="6" align="left"><font size="2"><strong>Otros Estudios</strong></font></td></tr>
												<tr valign="top">
													<td width="17%" align="right"><font size="2">Carrera</font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td width="30%" colspan="4" align="left"><%f_datos_personales.dibujaCampo("otra_carrera")%></td>
												</tr>
												<tr valign="top">
													<td width="17%" align="right"><font size="2">T�tulo/grado</font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td width="30%" colspan="4" align="left"><%f_datos_personales.dibujaCampo("otro_titulo_grado")%></td>
												</tr>
												<tr valign="top">
													<td width="17%" align="right"><font size="2">Instituci�n</font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td width="30%" colspan="4" align="left"><%f_datos_personales.dibujaCampo("otra_institucion")%></td>
												</tr>
												<tr valign="top">
													<td width="17%" align="right"><font size="2">A�o</font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td width="30%" colspan="4" align="left"><%f_datos_personales.dibujaCampo("otro_anio")%></td>
												</tr>
												<%end if ' por si queria actualizar datos personales%>
												<%if tipo = 2 then %>
												<tr><td colspan="6" align="left"><font size="2"><strong>Direcci�n Comercial</strong></font></td></tr>
												<tr valign="middle">
													<td width="17%" align="right"><font size="2"><font color="#CC0000">*</font>Pa�s</font></td>
													<td width="2%" align="center"><font size="2">:</font><%f_datos_laborales.dibujaCampo("dlpr_ncorr")%></td>
													<td colspan="4" align="left"><%f_datos_laborales.dibujaCampo("pais_ccod")%></td>
												</tr>
												<tr valign="middle">
													<td colspan="6" align="center"><font size="2" color="#000099">Ubicaci�n en el Extranjero</font></td>
												</tr>
												<tr valign="middle">
													<td colspan="6" align="center">
													<table width="95%" cellpadding="0" cellspacing="0" border="1" bordercolor="#000099">
													<tr valign="middle"><td width="100%">
														<table width="100%" cellpadding="0" cellspacing="0" border="0">
															<tr valign="middle">
																<td width="15%" align="right"><input type="text" name="ext1" size="1" maxlength="1" value="<%=asterisco1%>" style="border:none; color:red"><font size="2">Ciudad</font></td>
																<td width="2%" align="center"><font size="2">:</font></td>
																<td width="83%" colspan="4" align="left"><%f_datos_laborales.dibujaCampo("dlpr_ciud_particular")%></td>
															</tr>
															<tr valign="middle">
																<td width="15%" align="right"><input type="text" name="ext2" size="1" maxlength="1" value="<%=asterisco2%>" style="border:none; color:red"><font size="2">Direcci�n</font></td>
																<td width="2%" align="center"><font size="2">:</font></td>
																<td colspan="4" align="left"><%f_datos_laborales.dibujaCampo("dlpr_regi_particular")%></td>
															</tr>
														</table></td>
													</tr>
													</table>
													</td>
												</tr>
												<tr valign="top">
													<td colspan="6" align="center"><font size="1" color="#000099">&nbsp;</font></td>
												</tr>
												<tr valign="top">
													<td colspan="6" align="center"><font size="2" color="#000099">Ubicaci�n dentro de Chile</font></td>
												</tr>
												<tr valign="top">
													<td colspan="6" align="center">
													<table width="95%" cellpadding="0" cellspacing="0" border="1" bordercolor="#000099">
													<tr valign="top"><td width="100%">
														<table width="100%" cellpadding="0" cellspacing="0" border="0">
															<tr valign="top">
																<td width="17%" align="right"><input type="text" name="nac1" size="1" maxlength="1" value="<%=asterisco3%>" style="border:none; color:red"><font size="2">Comuna</font></td>
																<td width="2%" align="center"><font size="2">:</font></td>
																<td colspan="4" align="left"><%f_datos_laborales.dibujaCampo("ciud_ccod")%></td>
															</tr>
															<tr valign="top">
																<td width="17%" align="right"><input type="text" name="nac2" size="1" maxlength="1" value="<%=asterisco4%>" style="border:none; color:red"><font size="2">Direcci�n</font></td>
																<td width="2%" align="center"><font size="2">:</font></td>
																<td width="30%" align="left"><%f_datos_laborales.dibujaCampo("dlpr_tcalle")%></td>
																<td width="17%" align="right"><input type="text" name="nac3" size="1" maxlength="1" value="<%=asterisco5%>" style="border:none; color:red"><font size="2">N�</font></td>
																<td width="2%" align="center"><font size="2">:</font></td>
																<td width="32%" align="left"><%f_datos_laborales.dibujaCampo("dlpr_tnro")%></td>
															</tr>
															<tr valign="top">
																<td width="17%" align="right"><font size="2">Oficina</font></td>
																<td width="2%" align="center"><font size="2">:</font></td>
																<td width="30%" align="left"><%f_datos_laborales.dibujaCampo("dlpr_tblock")%></td>
																<td width="17%" align="right"><font size="2">&nbsp;</font></td>
																<td width="2%" align="center"><font size="2">&nbsp;</font></td>
																<td width="32%" align="left">&nbsp;</td>
															</tr>
														</table></td>
													</tr>
													</table>
													</td>
												</tr>
												<tr valign="top">
													<td width="17%" align="right"><font size="2">Cod. Postal</font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td colspan="4" align="left"><%f_datos_laborales.dibujaCampo("dlpr_cpostal")%></td>
												</tr>
												<tr valign="top">
													<td width="17%" align="right"><font size="2">E-Mail</font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td width="30%" align="left"><%f_datos_laborales.dibujaCampo("dlpr_email_empresa")%></td>
													<td width="17%" align="right"><font size="2">Fono</font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td width="32%" align="left"><%f_datos_laborales.dibujaCampo("dlpr_tfono")%></td>
												</tr>
												<tr valign="top">
													<td width="17%" align="right"><font size="2">Fax</font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td width="30%" align="left"><%f_datos_laborales.dibujaCampo("dire_tfax")%></td>
													<td width="17%" align="right">&nbsp;</td>
													<td width="2%" align="center">&nbsp;</td>
													<td width="32%" align="left">&nbsp;</td>
												</tr>
												<tr><td colspan="6" align="left"><font size="2"><strong>Datos Ocupacionales</strong></font></td></tr>
												<tr valign="middle">
													<td width="17%" align="right"><font size="2"><strong>Empleado</strong></font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td width="30%" colspan="4" align="left">
																  <font size="2"><%f_datos_laborales.dibujaCampo("dlpr_empleado")%></font>
													</td>
												</tr>
												<tr valign="top">
													<td width="17%" align="right"><font size="2">Nombre Empresa</font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td width="30%" colspan="4" align="left">
																  <font size="2">
																	  <%f_datos_laborales.dibujaCampo("dlpr_nombre_empresa")%>
																   </font>
													</td>
												</tr>
												<tr valign="top">
													<td width="17%" align="right"><font size="2">Rubro Empresa</font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td width="30%" colspan="4" align="left">
																  <font size="2">
																	  <%f_datos_laborales.dibujaCampo("dlpr_rubro_empresa")%>
																   </font>
													</td>
												</tr>
												<tr valign="top">
													<td width="17%" align="right"><font size="2">Cargo</font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td width="30%" colspan="4" align="left">
																  <font size="2">
																	  <%f_datos_laborales.dibujaCampo("dlpr_cargo_empresa")%>
																   </font>
													</td>
												</tr>
												<tr valign="middle">
													<td width="17%" align="right"><font size="2"><strong>Due�o de Empresa</strong></font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td width="30%" colspan="4" align="left">
																  <font size="2"><%f_datos_laborales.dibujaCampo("dlpr_duenio")%></font>
													</td>
												</tr>
												<tr valign="top">
													<td width="17%" align="right"><font size="2">Nombre Empresa</font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td width="30%" colspan="4" align="left">
																  <font size="2"><%f_datos_laborales.dibujaCampo("dlpr_nombre_empresa_propia")%></font>
													</td>
												</tr>
												<tr valign="top">
													<td width="17%" align="right"><font size="2">Rubro Empresa</font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td width="30%" colspan="4" align="left">
																  <font size="2"><%f_datos_laborales.dibujaCampo("dlpr_rubro_empresa_propia")%></font>
													</td>
												</tr>
												<tr valign="top">
													<td width="17%" align="right"><font size="2"><strong>Independiente</strong></font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td width="30%" colspan="4" align="left">
																  <font size="2"><%f_datos_laborales.dibujaCampo("dlpr_independiente")%></font>
													</td>
												</tr>
												<tr valign="top">
													<td width="17%" align="right"><font size="2">Rubro</font></td>
													<td width="2%" align="center"><font size="2">:</font></td>
													<td width="30%" colspan="4" align="left">
																  <font size="2"><%f_datos_laborales.dibujaCampo("dlpr_rubro_independiente")%></font>
													</td>
												</tr>
												<%end if ' por si desea actualizar datos empresariales%>										
												<tr><td width="100%" colspan="6" align="left"><font size="2"><strong>Otros</strong></font></td></tr>
												<tr>
                                      <td width="100%" colspan="6" align="left"><font size="2">Preferencia 
                                        de contacto:</font></td>
                                    </tr>
												<tr> <td width="17" align="center">&nbsp;</td>
													 <td width="100%" colspan="5" align="left">
													   <font size="2">
																	<table width='40%'>
																	<tr>
																	    <%if tipo_contacto = "C" then%>
																		<td> <input type='RADIO' value='C'  id='TO-N'  name='dp[0][tipo_contacto]' checked>Comercial</td>
																		<%else%>
																		<td> <input type='RADIO' value='C'  id='TO-N'  name='dp[0][tipo_contacto]' >Comercial</td>
																		<%end if%>
                                                                        <%if tipo_contacto = "P" then%>
																		<td><input type='RADIO' value='P' id='TO-N'  name='dp[0][tipo_contacto]' checked>Particular</td>
																		<%else%>
																		<td> <input type='RADIO' value='P' id='TO-N'  name='dp[0][tipo_contacto]'>Particular</td>
																		<%end if%>
																	</tr>
																	</table>
														</font>
													 </td>
												</tr>
												<tr><td width="100%" colspan="6" align="left"><font size="2">�Desea recibir informaci�n permanente sobre charlas, seminarios y eventos que se realicen en la Universidad?:</font></td></tr>
												<tr> <td width="17" align="center">&nbsp;</td>
													 <td width="100%" colspan="5" align="left">
													              <font size="2">
																		<table width='40%'>
																			<tr>
																			    <%if recibir_info = "NO" then%>
																				<td><input type='RADIO' value='no'  id='TO-N'  name='dp[0][recibir_info]' checked>No</td>
																				<%else%>
																				<td><input type='RADIO' value='no'  id='TO-N'  name='dp[0][recibir_info]'>No</td>
																				<%end if%>
																				<%if recibir_info = "SI" then%>
																				<td> <input type='RADIO' value='si'  id='TO-N'  name='dp[0][recibir_info]' checked>Si</td>
																				<%else%>
																				<td> <input type='RADIO' value='si'  id='TO-N'  name='dp[0][recibir_info]' >Si</td>
																				<%end if%>
																			</tr>
																		 </table>
																	</font>
													 </td>
												</tr>
												<tr><td width="100%" colspan="6" align="right"><% if tipo = 1 then
																										botonera.agregaBotonParam "guardar","url","cpp_externos_DP_proc.asp" 
																										botonera.DibujaBoton("guardar")
																								   elseif tipo= 2 then
																										botonera.agregaBotonParam "guardar","url","cpp_externos_DL_proc.asp"		
																										botonera.DibujaBoton("guardar")	
																								   end if%></td></tr>
											</table>
									  </td>
								   </tr>
								</table>
							</td>
							<%else%>
								<td bgcolor="#FFFFFF" width="600"><font color="#CC0000" size="2"><div align="justify"><%=mensaje_no_titulado%></div></font></td>
								</form>
							<%end if%>
							<td width="39" align="left" background="imagenes_certificado/derecha_lado.jpg">&nbsp;</td>
						</tr>
						<tr valign="top">
							<td width="33" height="36" align="right"><img src="imagenes_certificado/izquierda_inf.jpg" width="33" height="36"></td>
							<td width="550" bgcolor="#FFFFFF" height="36"><img width="600" height="36" src="imagenes_certificado/inferior.jpg"></td>
							<td width="39" height="36" align="left"><img src="imagenes_certificado/derecha_inf.jpg" width="35" height="36"></td>
						</tr>
						<TR>
							<TD colspan="3">&nbsp;</TD>
						</TR>
						<TR>
							<TD colspan="3" align="center"><img width="455" height="47" src="../imagenes/firma_CPP.png"></TD>
						</TR>
					</table>
					
					
					<!------------fin de cuadro con datos-->
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

</td>
</tr>
</table> 
  </center>
  </body>
</html>

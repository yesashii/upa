<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
dgso_ncorr 	= request.QueryString("dgso_ncorr")
empr_ncorr 	= request.QueryString("empr_ncorr")
nord_compra = request.QueryString("nord_compra")
tipo 		= request.QueryString("tipo")
empr_ncorr_2= request.QueryString("empr_ncorr_2")
fpot_ccod 	= request.QueryString("fpot_ccod")

set pagina = new CPagina
pagina.Titulo = "Configurar Orden de Compra"

set botonera =  new CFormulario
botonera.carga_parametros "agrega_postulantes.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

programa = conexion.consultaUno("select dcur_tdesc from datos_generales_secciones_otec a, diplomados_cursos b where a.dcur_ncorr=b.dcur_ncorr and cast(a.dgso_ncorr as varchar)='"&dgso_ncorr&"'")
matricula = conexion.consultaUno("select isnull(ofot_nmatricula,0) from datos_generales_secciones_otec a, ofertas_otec b where a.dgso_ncorr = b.dgso_ncorr and cast(a.dgso_ncorr as varchar)='"&dgso_ncorr&"'")
arancel = conexion.consultaUno("select isnull(ofot_narancel,0) from datos_generales_secciones_otec a, ofertas_otec b where a.dgso_ncorr = b.dgso_ncorr and cast(a.dgso_ncorr as varchar)='"&dgso_ncorr&"'")

empresa_orden = conexion.consultaUno("select empr_trazon_social from empresas where cast(empr_ncorr as varchar)='"&empr_ncorr&"'")
empresa = conexion.consultaUno("select empr_trazon_social from empresas where cast(empr_ncorr as varchar)='"&empr_ncorr_2&"'")
tiene_detalle = conexion.consultaUno(" select count(*) from ordenes_compras_otec  where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'  and cast(empr_ncorr as varchar)='"&empr_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'")
'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "agrega_postulantes.xml", "datos_orden"
formulario.inicializar conexion

if dgso_ncorr <> "" and empr_ncorr <> "" and nord_compra <> "" and tiene_detalle <> "0" then 
	consulta= " select orco_ncorr,dgso_ncorr,empr_ncorr,nord_compra,empr_ncorr_2,fpot_ccod,ocot_nalumnos,ocot_monto_persona,ocot_monto_otic,ocot_NRO_REGISTRO_SENCE,ocot_monto_empresa " & vbCrlf & _
			  " from ordenes_compras_otec " & vbCrlf & _
			  " where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' " & vbCrlf & _
			  " and cast(empr_ncorr as varchar)='"&empr_ncorr&"' " & vbCrlf & _
			  " and cast(nord_compra as varchar)='"&nord_compra&"' " 
end if

if tiene_detalle = "0" then
	consulta = "select '"&dgso_ncorr&"' as dgso_ncorr, '"&empr_ncorr&"' as empr_ncorr,'"&nord_compra&"' as nord_compra, '"&fpot_ccod&"' as fpot_ccod,'"&empr_ncorr_2&"' as empr_ncorr_2"
end if
'response.write("<pre>"&consulta&"</pre>")

formulario.consultar consulta 
formulario.siguiente

lenguetas_masignaturas = Array(Array("Configurar Orden de compra", "agregar_orden_compra.asp?mote_ccod="&codigo))
'response.Write("doras "&horas_Asignatura&" duracion "&duracion_asignatura)

'##########################################################################################
'*******************	ARREGLO PARA SOLUCION DE CAMBIO DE AÑO	***************************
set f_datos = new cformulario
f_datos.carga_parametros "tabla_vacia.xml", "tabla"
f_datos.inicializar conexion

sql_cambio_anio=	"select protic.trunc(dgso_finicio) as fecha_inicio,protic.trunc(dgso_ftermino) as fecha_fin,year(dgso_finicio) as anio_inicio, "& vbcrlf &_
					" year(dgso_ftermino) as anio_fin,(year(dgso_ftermino)- year(dgso_finicio)) as diferencia "& vbcrlf &_
					" from datos_generales_secciones_otec "& vbcrlf &_
					" where dgso_ncorr="&dgso_ncorr

f_datos.consultar sql_cambio_anio 
f_datos.siguiente

v_cambio_anio 	= f_datos.obtenerValor("diferencia") 
v_anio_inicio 	= f_datos.obtenerValor("anio_inicio") 
v_anio_fin 		= f_datos.obtenerValor("anio_fin") 
v_fecha_inicio_a= f_datos.obtenerValor("fecha_inicio") 
v_fecha_corte_b = f_datos.obtenerValor("fecha_fin") 
v_fecha_inicio_c= f_datos.obtenerValor("fecha_inicio") 
v_fecha_corte_d = f_datos.obtenerValor("fecha_fin") 

v_num_oc_a=nord_compra
v_num_oc_b=nord_compra
v_num_oc_c=nord_compra
v_num_oc_d=nord_compra

' Si cambia de año y es con Otic y codigo sence (Empresa sence, empresa y otic,  natural y empresa)
if v_cambio_anio=1 and (fpot_ccod="3" or  fpot_ccod="4" or  fpot_ccod="5") then
	v_txt="Total"
	v_orco_ncorr=formulario.obtenerValor("orco_ncorr")

	set f_detalle = new cformulario
	f_detalle.carga_parametros "agrega_postulantes.xml", "detalle_datos_orden"
	f_detalle.inicializar conexion
	
	if v_orco_ncorr <>"" then
		consulta_detalle= "select orco_ncorr,anos_ccod,protic.trunc(dorc_finicio) as dorc_finicio,protic.trunc(dorc_ffin) as dorc_ffin,  "& vbcrlf &_
						  "	dorc_mmonto, dorc_naccion_sence, dorc_num_oc, empr_ncorr, tins_ccod, dorc_nindice,dorc_nhoras  "& vbcrlf &_
						  "	from detalle_ordenes_compras_otec where orco_ncorr="&v_orco_ncorr&" order by dorc_nindice asc "
	else
		consulta_detalle = "select * from detalle_ordenes_compras_otec  where 1=2"
	end if 
	'response.write("<pre>"&consulta_detalle&"</pre>")
	f_detalle.consultar consulta_detalle 
	f_detalle.siguiente
	
	if f_detalle.nroFilas >1 then
		' tins_ccod=1 (empresa)
		v_fecha_inicio_a=f_detalle.obtenerValor("dorc_finicio")
		v_fecha_corte_a	=f_detalle.obtenerValor("dorc_ffin")
		v_monto_a		=f_detalle.obtenerValor("dorc_mmonto")
		v_num_horas_a	=f_detalle.obtenerValor("dorc_nhoras")
		v_num_accion_a	=f_detalle.obtenerValor("dorc_naccion_sence")
		v_num_oc_a		=f_detalle.obtenerValor("dorc_num_oc")
		
		f_detalle.Siguiente	
		
		v_fecha_inicio_b=f_detalle.obtenerValor("dorc_finicio")
		v_fecha_corte_b	=f_detalle.obtenerValor("dorc_ffin")
		v_monto_b		=f_detalle.obtenerValor("dorc_mmonto")
		v_num_horas_b	=f_detalle.obtenerValor("dorc_nhoras")
		v_num_accion_b	=f_detalle.obtenerValor("dorc_naccion_sence")
		v_num_oc_b		=f_detalle.obtenerValor("dorc_num_oc")
		
		if tipo = "2" then ' tins_ccod=2 (otic)
	
			f_detalle.Siguiente	
	
			v_fecha_inicio_c=f_detalle.obtenerValor("dorc_finicio")
			v_fecha_corte_c	=f_detalle.obtenerValor("dorc_ffin")
			v_monto_c		=f_detalle.obtenerValor("dorc_mmonto")
			v_num_horas_c	=f_detalle.obtenerValor("dorc_nhoras")
			v_num_accion_c	=f_detalle.obtenerValor("dorc_naccion_sence")
			v_num_oc_c		=f_detalle.obtenerValor("dorc_num_oc")
			
			f_detalle.Siguiente	
			
			v_fecha_inicio_d=f_detalle.obtenerValor("dorc_finicio")
			v_fecha_corte_d	=f_detalle.obtenerValor("dorc_ffin")
			v_monto_d		=f_detalle.obtenerValor("dorc_mmonto")
			v_num_horas_d	=f_detalle.obtenerValor("dorc_nhoras")
			v_num_accion_d	=f_detalle.obtenerValor("dorc_naccion_sence")
			v_num_oc_d		=f_detalle.obtenerValor("dorc_num_oc")
		end if
	end if
	
end if

' Si NO cambia de año aunque sea con otic y codigo sence, solo va en un año (Empresa sence, empresa y otic,  natural y empresa)
if v_cambio_anio=0 and (fpot_ccod="3" or  fpot_ccod="4" or  fpot_ccod="5") then

' cambian las fechas al no dividir las facturas
v_fecha_inicio_a= f_datos.obtenerValor("fecha_inicio") 
v_fecha_corte_a = f_datos.obtenerValor("fecha_fin") 
v_fecha_inicio_c= f_datos.obtenerValor("fecha_inicio") 
v_fecha_corte_c = f_datos.obtenerValor("fecha_fin") 


	v_txt="Total"
	v_orco_ncorr=formulario.obtenerValor("orco_ncorr")

	set f_detalle = new cformulario
	f_detalle.carga_parametros "agrega_postulantes.xml", "detalle_datos_orden"
	f_detalle.inicializar conexion
	
	if v_orco_ncorr <>"" then
		consulta_detalle= "select orco_ncorr,anos_ccod,protic.trunc(dorc_finicio) as dorc_finicio,protic.trunc(dorc_ffin) as dorc_ffin,  "& vbcrlf &_
						  "	dorc_mmonto, dorc_naccion_sence, dorc_num_oc, empr_ncorr, tins_ccod, dorc_nindice,dorc_nhoras  "& vbcrlf &_
						  "	from detalle_ordenes_compras_otec where orco_ncorr="&v_orco_ncorr&" order by dorc_nindice asc "
	else
		consulta_detalle = "select * from detalle_ordenes_compras_otec  where 1=2"
	end if 
	'response.write("<pre>"&consulta_detalle&"</pre>")
	f_detalle.consultar consulta_detalle 
	f_detalle.Siguiente	
	if f_detalle.nroFilas >=1 then
		' tins_ccod=1 (empresa)
		v_fecha_inicio_a=f_detalle.obtenerValor("dorc_finicio")
		v_fecha_corte_a	=f_detalle.obtenerValor("dorc_ffin")
		v_monto_a		=f_detalle.obtenerValor("dorc_mmonto")
		v_num_horas_a	=f_detalle.obtenerValor("dorc_nhoras")
		v_num_accion_a	=f_detalle.obtenerValor("dorc_naccion_sence")
		v_num_oc_a		=f_detalle.obtenerValor("dorc_num_oc")
		
		if tipo = "2" then ' tins_ccod=2 (otic)
	
			f_detalle.Siguiente	
	
			v_fecha_inicio_c=f_detalle.obtenerValor("dorc_finicio")
			v_fecha_corte_c	=f_detalle.obtenerValor("dorc_ffin")
			v_monto_c		=f_detalle.obtenerValor("dorc_mmonto")
			v_num_horas_c	=f_detalle.obtenerValor("dorc_nhoras")
			v_num_accion_c	=f_detalle.obtenerValor("dorc_naccion_sence")
			v_num_oc_c		=f_detalle.obtenerValor("dorc_num_oc")
			
		end if
	end if
	
end if




'##########################################################################################
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
function valida_orden(formulario){
valor=0;
v_cambio_anio	=	'<%=v_cambio_anio%>';
forma_pago 		= 	'<%=fpot_ccod%>';
v_otic 			= 	'<%=tipo%>';
//v_nro_accion	=	formulario.elements["o[0][ocot_NRO_REGISTRO_SENCE]"].value;
v_nro_alumnos	=	formulario.elements["o[0][ocot_nalumnos]"].value;
v_monto_empresa	=	formulario.elements["o[0][ocot_monto_empresa]"].value;

//alert(forma_pago);alert(v_nro_accion);alert(v_nro_alumnos);alert(v_monto_empresa);
 if (v_otic==2){
	 v_monto_otic	=formulario.elements["o[0][ocot_monto_otic]"].value;
	 if (!v_monto_otic){
		alert("Debe ingresar los datos generales de la Orden de Compra");
		return false; 	
	 }
 }
 
 //if ((!v_nro_accion)||(!v_nro_alumnos)||(!v_monto_empresa)){
 if ((!v_nro_alumnos)||(!v_monto_empresa)){	 
	alert("Debe ingresar los datos generales de la Orden de Compra");
	return false; 	
 }
 
 if(v_cambio_anio==1) {
	 
  //Si es solo empresa y los valores traen datos, validar los montos complementarios
	if (forma_pago=='3'){ 
		v_monto_a	=	parseInt(formulario.elements["do[0][dorc_mmonto]"].value);
		v_monto_b	=	parseInt(formulario.elements["do[1][dorc_mmonto]"].value);
		v_monto_total=v_monto_a+v_monto_b;
		if (v_monto_total!=v_monto_empresa){
			alert("La suma de los montos "+v_monto_total+" complementarios deben se igual al monto total Empresa \nMonto Empresa: "+v_monto_empresa+" ");
			return false;
		}
		return true;
	}
	
	// SI ES EMPRESA CON OTIC
	if (forma_pago=='4'){ 
		v_monto_a	=	parseInt(formulario.elements["do[0][dorc_mmonto]"].value);
		v_monto_b	=	parseInt(formulario.elements["do[1][dorc_mmonto]"].value);
		v_monto_total=v_monto_a+v_monto_b;
		if (v_monto_total!=v_monto_empresa){
			alert("La suma de los montos "+v_monto_total+" complementarios deben se igual al monto total Empresa \nMonto Empresa: "+v_monto_empresa+" ");
			return false;
		}
		
		v_monto_c	=	parseInt(formulario.elements["do[2][dorc_mmonto]"].value);
		v_monto_d	=	parseInt(formulario.elements["do[3][dorc_mmonto]"].value);
		v_monto_total=eval(v_monto_c + v_monto_d);
		
		if (v_monto_total!=v_monto_otic){
			alert("La suma de los montos "+ v_monto_total +"complementarios deben se igual al monto total Otic \nMonto Otic: "+v_monto_otic+" ");
			return false;
		}
		return true;
	}

  //SI ES PERSONA NATURAL + EMPRESA
	if (forma_pago=='5'){ 
		v_monto_a	=	parseInt(formulario.elements["do[0][dorc_mmonto]"].value);
		v_monto_b	=	parseInt(formulario.elements["do[1][dorc_mmonto]"].value);
		v_monto_total=v_monto_a+v_monto_b;
		if (v_monto_total!=v_monto_empresa){
			alert("La suma de los montos "+v_monto_total+" complementarios deben se igual al monto total Empresa \nMonto Empresa: "+v_monto_empresa+" ");
			return false;
		}
		return true;
	}	
 }

//CUANDO NO CAMBIAN DE AÑO
 if(v_cambio_anio==0) { 

    // Empresa con Sence
	if (forma_pago=='3'){ 
		v_monto_a	=	parseInt(formulario.elements["do[0][dorc_mmonto]"].value);

		if (v_monto_a!=v_monto_empresa){
			alert("El monto parcial ingresado "+v_monto_a+" para la Empresa, debe se igual al monto total Empresa \nMonto Empresa: "+v_monto_empresa+" ");
			return false;
		}
		return true;
	}
	
	// SI ES EMPRESA CON OTIC
	if (forma_pago=='4'){ 
		
		v_monto_a	=	parseInt(formulario.elements["do[0][dorc_mmonto]"].value); // EMPRESA
		if (v_monto_a!=v_monto_empresa){
			alert("El monto parcial ingresado "+v_monto_a+" para la Empresa, debe se igual al monto total Empresa \nMonto Empresa: "+v_monto_empresa+" ");
			return false;
		}
		
		v_monto_c	=	parseInt(formulario.elements["do[2][dorc_mmonto]"].value); // OTIC
		if (v_monto_c!=v_monto_otic){
			alert("El monto parcial ingresado "+v_monto_c+" para la Otic, debe se igual al monto total Otic \nMonto Otic: "+v_monto_otic+" ");
			return false;
		}
		return true;
	} 

    //SI ES PERSONA NATURAL + EMPRESA
	if (forma_pago=='5'){ 
		v_monto_a	=	parseInt(formulario.elements["do[0][dorc_mmonto]"].value);
		if (v_monto_a!=v_monto_empresa){
			alert("El monto parcial ingresado "+v_monto_a+" para la Empresa, debe se igual al monto total Empresa \nMonto Empresa: "+v_monto_empresa+" ");			
			return false;
		}
		return true;
	}	
 } // FIN SIN CAMBIO DE AÑO
 
return true;
}

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="380" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas lenguetas_masignaturas, 1%> </td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
              <form name="edicion" method="post">
			  <table width="100%"  border="0">
				  <tr>
					<td><strong>Programa : </strong><%=programa%></td>
				  </tr>
				  <tr>
					<td><strong>Matrícula : </strong><%=formatcurrency(matricula,0)%></td>
				  </tr>
				  <tr>
					<td><strong>Arancel : </strong><%=formatcurrency(arancel,0)%></td>
				  </tr>
				   <tr>
					<td><%if tipo=1 then
					       response.Write("<strong>Empresa :</strong> "&empresa_orden)
						  else
						   response.Write("<strong>Otic :</strong> "&empresa_orden)
						  end if%></td>
				  </tr>
				  <tr>
					<td><strong>N° de Orden :</strong><%=nord_compra%></td>
				  </tr>
				  <%if tipo= 2 then%>
				  <tr>
					<td><strong>Empresa :</strong><%=empresa%></td>
				  </tr>
				  <%end if%>
				  <tr>
					<td align="center">
						<table width="90%" border="1">
						<tr><td align="center">
						    	<table width="100%">
                                	<tr>
									    <td colspan="3" align="center" bgcolor="#99CCFF"><strong>Datos Generales</strong></td>
									</tr>
									<!--
                                    <tr>
									    <td width="44%"><strong>N° Accion sence</strong></td>
										<td width="1%"><strong>:</strong></td>
									    <td><%formulario.dibujaCampo("ocot_NRO_REGISTRO_SENCE")%></td>
									</tr>
                                    -->
									<tr>
									    <td width="44%"><strong>Cant. Alumnos</strong></td>
										<td width="1%"><strong>:</strong></td>
									    <td><%
										
										if tipo = "1" and fpot_ccod="5" then
											formulario.AgregaCampoParam "ocot_nalumnos", "soloLectura", "TRUE"
											formulario.AgregaCampoCons "ocot_nalumnos", 1
										end if
										
                                        formulario.dibujaCampo("ocot_nalumnos")
                                        %></td>
									</tr>
									<%if tipo = "2" then%>
									<tr>
									    <td width="44%"><strong>Monto <%=v_txt%> Otic</strong></td>
										<td width="1%"><strong>:</strong></td>
									    <td><%formulario.dibujaCampo("ocot_monto_otic")%></td>
									</tr>
									<%end if%>
									<%if tipo = "1" and fpot_ccod="5" then%>
									<tr>
									    <td width="44%"><strong>Monto Persona</strong></td>
										<td width="1%"><strong>:</strong></td>
									    <td><%formulario.dibujaCampo("ocot_monto_persona")%></td>
									</tr>
									<%end if%>                                    
									<tr>
									    <td width="44%"><strong>Monto <%=v_txt%> Empresa</strong></td>
										<td width="1%"><strong>:</strong></td>
									    <td><%formulario.dibujaCampo("ocot_monto_empresa")%></td>
									</tr>
									<%formulario.dibujaCampo("orco_ncorr")%>
									<%formulario.dibujaCampo("dgso_ncorr")%>
									<%formulario.dibujaCampo("empr_ncorr")%>
									<%formulario.dibujaCampo("nord_compra")%>
									<%formulario.dibujaCampo("empr_ncorr_2")%>
									<%formulario.dibujaCampo("fpot_ccod")%>
									<input type="hidden" name="tipo" value="<%=tipo%>"> 
									<% if v_cambio_anio=1 and (fpot_ccod="3" or  fpot_ccod="4" or  fpot_ccod="5") then %>
                                    <tr>
                                        <td colspan="3">
                                        <br>
                                        <center><font color="#0000FF" size="2">Detalle de pagos complementarios</font></center>
                                        <br>
                                        <input type="hidden" name="do[0][empr_ncorr]" value="<%=empr_ncorr%>">
                                        <input type="hidden" name="do[1][empr_ncorr]" value="<%=empr_ncorr%>">
                                        <input type="hidden" name="do[0][anos_ccod]" value="<%=v_anio_inicio%>">
                                        <input type="hidden" name="do[1][anos_ccod]" value="<%=v_anio_fin%>">
                                        <input type="hidden" name="do[0][tins_ccod]" value="1">
                                        <input type="hidden" name="do[1][tins_ccod]" value="1">
                                        <input type="hidden" name="do[0][dorc_nindice]" value="0">
                                        <input type="hidden" name="do[1][dorc_nindice]" value="1">                                         
                                            <table width="100%">
                                            <tr>
                                              <td colspan="3" align="center" bgcolor="#99CCFF"><strong>EMPRESA</strong></td></tr>
                                              <tr><td></td><th><%=v_anio_inicio%></th><th><%=v_anio_fin%></th></tr>
                                            <tr>
                                                <th align="left">Fecha Inicio</th>
                                                <td><input type="text" name="do[0][dorc_finicio]" value="<%=v_fecha_inicio_a%>" size="12" id="FE-N"/></td>
                                                <td><input type="text" name="do[1][dorc_finicio]" value="<%=v_fecha_inicio_b%>" size="12" id="FE-N"/></td>
                                            </tr>
                                            <tr>
                                            	<th align="left">Fecha Corte</th>
                                                <td><input type="text" name="do[0][dorc_ffin]" value="<%=v_fecha_corte_a%>" size="12" id="FE-N"/></td>
                                                <td><input type="text" name="do[1][dorc_ffin]" value="<%=v_fecha_corte_b%>" size="12" id="FE-N"/></td>
                                            </tr>
                                            <tr>
                                            	<th align="left">Monto</th>
                                                <td><input type="text" name="do[0][dorc_mmonto]" value="<%=v_monto_a%>" size="10" id="NU-N"/></td>
                                                <td><input type="text" name="do[1][dorc_mmonto]" value="<%=v_monto_b%>" size="10" id="NU-N"/></td>
                                            </tr>
                                            <tr>
                                            	<th align="left">N° Horas</th>
                                                <td><input type="text" name="do[0][dorc_nhoras]" value="<%=v_num_horas_a%>" size="10" maxlength="3" id="NU-N"/></td>
                                                <td><input type="text" name="do[1][dorc_nhoras]" value="<%=v_num_horas_b%>" size="10" maxlength="3" id="NU-N"/></td>
                                            </tr>
                                            <tr>
                                            	<th align="left">Reg. Accion Sence</th>
                                                <td><input type="text" name="do[0][dorc_naccion_sence]" value="<%=v_num_accion_a%>" size="10" maxlength="7" id="NU-N"/></td>
                                                <td><input type="text" name="do[1][dorc_naccion_sence]" value="<%=v_num_accion_b%>" size="10" maxlength="7" id="NU-N"/></td>
                                            </tr>
                                            <tr>
                                            	<th align="left">N° Orden Compra</th>
                                                <td><input type="text" name="do[0][dorc_num_oc]" value="<%=v_num_oc_a%>" size="10" maxlength="10" id="NU-N"/></td>
                                                <td><input type="text" name="do[1][dorc_num_oc]" value="<%=v_num_oc_b%>" size="10" maxlength="10" id="NU-N"/></td>
                                            </tr>
                                            </table>
                                            <br/>
                                           <%if tipo = "2" then%>

                                        <input type="hidden" name="do[2][empr_ncorr]" value="<%=empr_ncorr_2%>">
                                        <input type="hidden" name="do[3][empr_ncorr]" value="<%=empr_ncorr_2%>"> 
                                        <input type="hidden" name="do[2][anos_ccod]" value="<%=v_anio_inicio%>">
                                        <input type="hidden" name="do[3][anos_ccod]" value="<%=v_anio_fin%>">
                                        <input type="hidden" name="do[2][tins_ccod]" value="2">
                                        <input type="hidden" name="do[3][tins_ccod]" value="2">
                                        <input type="hidden" name="do[2][dorc_nindice]" value="2">
                                        <input type="hidden" name="do[3][dorc_nindice]" value="3">
                                                                                    
                                           <table width="100%">
                                            <tr><td colspan="3" align="center" bgcolor="#99CCFF"><strong>OTIC</strong></td></tr>
                                            <tr><td></td><th><%=v_anio_inicio%></th><th><%=v_anio_fin%></th></tr>
                                            <tr>
                                                <th align="left">Fecha Inicio</th>
                                                <td><input type="text" name="do[2][dorc_finicio]" value="<%=v_fecha_inicio_c%>" size="12" id="FE-N" /></td>
                                                <td><input type="text" name="do[3][dorc_finicio]" value="<%=v_fecha_inicio_d%>" size="12" id="FE-N" /></td>
                                            </tr>
                                            <tr>
                                            	<th align="left">Fecha Corte</th>
                                                <td><input type="text" name="do[2][dorc_ffin]" value="<%=v_fecha_corte_c%>" size="12" id="FE-N" /></td>
                                                <td><input type="text" name="do[3][dorc_ffin]" value="<%=v_fecha_corte_d%>" size="12" id="FE-N" /></td>
                                            </tr>
                                            <tr>
                                            	<th align="left">Monto</th>
                                                <td><input type="text" name="do[2][dorc_mmonto]" value="<%=v_monto_c%>" size="10" id="NU-N" /></td>
                                                <td><input type="text" name="do[3][dorc_mmonto]" value="<%=v_monto_d%>" size="10" id="NU-N" /></td>
                                            </tr>
                                            <tr>
                                            	<th align="left">N° Horas</th>
                                                <td><input type="text" name="do[2][dorc_nhoras]" value="<%=v_num_horas_c%>" size="10" maxlength="3" id="NU-N" /></td>
                                                <td><input type="text" name="do[3][dorc_nhoras]" value="<%=v_num_horas_d%>" size="10" maxlength="3" id="NU-N" /></td>
                                            </tr>
                                            <tr>
                                            	<th align="left">Reg. Accion Sence</th>
                                                <td><input type="text" name="do[2][dorc_naccion_sence]" value="<%=v_num_accion_c%>" size="10" maxlength="7" id="NU-N" /></td>
                                                <td><input type="text" name="do[3][dorc_naccion_sence]" value="<%=v_num_accion_d%>" size="10" maxlength="7" id="NU-N" /></td>
                                            </tr>
                                            <tr>
                                            	<th align="left">N° Orden Compra</th>
                                                <td><input type="text" name="do[2][dorc_num_oc]" value="<%=v_num_oc_c%>" size="10" maxlength="10" id="NU-N" /></td>
                                                <td><input type="text" name="do[3][dorc_num_oc]" value="<%=v_num_oc_d%>" size="10" maxlength="10" id="NU-N" /></td>
                                            </tr>
                                            </table>
                                            <br/>
                                        
                                        <%end if%>
                                        </td>
                                    </tr>
                                   <%end if%>

									<% if v_cambio_anio=0 and (fpot_ccod="3" or  fpot_ccod="4" or  fpot_ccod="5") then %>
                                    <tr>
                                        <td colspan="3">
                                        <br>
                                        <center><font color="#0000FF" size="2">Detalle de pagos complementarios</font></center>
                                        <br>
                                        <input type="hidden" name="do[0][empr_ncorr]" value="<%=empr_ncorr%>">
                                        <input type="hidden" name="do[0][anos_ccod]" value="<%=v_anio_inicio%>">
                                        <input type="hidden" name="do[0][tins_ccod]" value="1">
                                        <input type="hidden" name="do[0][dorc_nindice]" value="0">
                                  
                                            <table width="100%">
                                            <tr>
                                              <td colspan="3" align="center" bgcolor="#99CCFF"><strong>EMPRESA</strong></td></tr>
                                              <tr><td></td><th><%=v_anio_inicio%></th><th>&nbsp;</th></tr>
                                            <tr>
                                                <th align="left">Fecha Inicio</th>
                                                <td><input type="text" name="do[0][dorc_finicio]" value="<%=v_fecha_inicio_a%>" size="12" id="FE-N"/></td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr>
                                            	<th align="left">Fecha Corte</th>
                                                <td><input type="text" name="do[0][dorc_ffin]" value="<%=v_fecha_corte_a%>" size="12" id="FE-N"/></td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr>
                                            	<th align="left">Monto</th>
                                                <td><input type="text" name="do[0][dorc_mmonto]" value="<%=v_monto_a%>" size="10" id="NU-N"/></td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr>
                                            	<th align="left">N° Horas</th>
                                                <td><input type="text" name="do[0][dorc_nhoras]" value="<%=v_num_horas_a%>" size="10" maxlength="3" id="NU-N"/></td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr>
                                            	<th align="left">Reg. Accion Sence</th>
                                                <td><input type="text" name="do[0][dorc_naccion_sence]" value="<%=v_num_accion_a%>" size="10" maxlength="7" id="NU-N"/></td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr>
                                            	<th align="left">N° Orden Compra</th>
                                                <td><input type="text" name="do[0][dorc_num_oc]" value="<%=v_num_oc_a%>" size="10" maxlength="10" id="NU-N"/></td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            </table>
                                            <br/>
                                           <%if tipo = "2" then%>

                                        <input type="hidden" name="do[2][empr_ncorr]" value="<%=empr_ncorr_2%>">
                                        <input type="hidden" name="do[2][anos_ccod]" value="<%=v_anio_inicio%>">
                                        <input type="hidden" name="do[2][tins_ccod]" value="2">
                                        <input type="hidden" name="do[2][dorc_nindice]" value="2">
                                                                                    
                                           <table width="100%">
                                            <tr><td colspan="3" align="center" bgcolor="#99CCFF"><strong>OTIC</strong></td></tr>
                                            <tr><td></td><th><%=v_anio_inicio%></th><th>&nbsp;</th></tr>
                                            <tr>
                                                <th align="left">Fecha Inicio</th>
                                                <td><input type="text" name="do[2][dorc_finicio]" value="<%=v_fecha_inicio_c%>" size="12" id="FE-N" /></td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr>
                                            	<th align="left">Fecha Corte</th>
                                                <td><input type="text" name="do[2][dorc_ffin]" value="<%=v_fecha_corte_c%>" size="12" id="FE-N" /></td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr>
                                            	<th align="left">Monto</th>
                                                <td><input type="text" name="do[2][dorc_mmonto]" value="<%=v_monto_c%>" size="10" id="NU-N" /></td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr>
                                            	<th align="left">N° Horas</th>
                                                <td><input type="text" name="do[2][dorc_nhoras]" value="<%=v_num_horas_c%>" size="10" maxlength="3" id="NU-N" /></td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr>
                                            	<th align="left">Reg. Accion Sence</th>
                                                <td><input type="text" name="do[2][dorc_naccion_sence]" value="<%=v_num_accion_c%>" size="10" maxlength="7" id="NU-N" /></td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr>
                                            	<th align="left">N° Orden Compra</th>
                                                <td><input type="text" name="do[2][dorc_num_oc]" value="<%=v_num_oc_c%>" size="10" maxlength="10" id="NU-N" /></td>
                                                <td>&nbsp;</td>
                                            </tr>
                                          </table>
                                            <br/>
                                        
                                        <%end if%>
                                        </td>
                                    </tr>
                                   <%end if%>
                                   
								</table>
							</td>
						</tr>
						</table>
					</td>
				  </tr>
				</table>
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
                  <td><div align="center"><%botonera.dibujaboton "guardar_orden_compra"%></div></td>
                  <td><div align="center"><%botonera.dibujaboton "salir"%></div></td>
                  <td><div align="center"></div></td>
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
	</td>
  </tr>  
</table>
</body>
</html>

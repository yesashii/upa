<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
v_pers_ncorr = Session("pers_ncorr")
if EsVacio(v_pers_ncorr) then
	Response.Redirect("inicio.asp")
end if

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Postulación - Información General"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "postulacion_1.xml", "botonera"


'---------------------------------------------------------------------------------------------------
v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
'response.Write(v_peri_ccod)
'------si esta en el segundo semestre no debe hacer cambios de carrera, para eso hay un modulo especializado
plec_ccod = conexion.consultaUno("select plec_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&v_peri_ccod&"'")
if plec_ccod ="2" then
	f_botonera.agregaBotonParam "cambiar_oferta", "deshabilitado", "TRUE"
end if
'---------------------------------------------------------------------------------------------------


'---------------------------------------------------------------------------------------------------------------
set fc_postulante = new CFormulario
fc_postulante.Carga_Parametros "consulta.xml", "consulta"
fc_postulante.Inicializar conexion

consulta = "select a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre_completo, b.post_bnuevo, " & vbCrLf &_
           "       case cast(b.post_bnuevo as varchar) when 'S' then 'NUEVO' when 'N' then 'ANTIGUO' end as tipo_alumno " & vbCrLf &_
		   "from personas_postulante a, postulantes b " & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
		   "  and cast(a.pers_ncorr as varchar) = '" & v_pers_ncorr & "' " & vbCrLf &_
		   "  and cast(b.peri_ccod as varchar) = '" & v_peri_ccod & "'"
		   
		
		   
fc_postulante.Consultar consulta
fc_postulante.Siguiente

v_post_bnuevo_aux=conexion.ConsultaUno("select protic.es_nuevo_institucion(" & v_pers_ncorr & ", " & v_peri_ccod & ") ")

if v_post_bnuevo_aux = "N" then
	v_post_bnuevo_aux = "ANTIGUO"
	b_antiguo = true
	session("v_post_antiguo")=b_antiguo
else
	v_post_bnuevo_aux = "NUEVO"
	b_antiguo = false
end if
	   
'---------------------------------------------------------------------------------------------------------------
consulta = "select distinct b.sede_ccod " & vbCrLf &_
           "from postulantes a, ofertas_academicas b, aranceles c " & vbCrLf &_
		   "where a.post_bnuevo = b.post_bnuevo " & vbCrLf &_
		   "  and b.aran_ncorr = c.aran_ncorr " & vbCrLf &_
		   "  and cast(c.aran_nano_ingreso as varchar) = case a.post_bnuevo when 'S' then cast(c.aran_nano_ingreso as varchar) else '" & v_ano_ingreso & "' end " & vbCrLf &_
		   "  and cast(a.post_ncorr as varchar) = '" & v_post_ncorr & "' " & vbCrLf &_
		   "  and cast(b.peri_ccod as varchar) = '" & v_peri_ccod & "'"
		   
'f_oferta_academica.AgregaCampoParam "sede_ccod", "filtro", "sede_ccod in (" & consulta & ")"



'------------------------------------------------------------------------------------------------------------------
consulta_ofertas = "select b.ofer_ncorr, e.sede_ccod, e.sede_tdesc, d.carr_ccod, d.carr_tdesc, c.espe_ccod, c.espe_tdesc, f.jorn_ccod, f.jorn_tdesc " & vbCrLf &_
                   "from postulantes a, ofertas_academicas b, especialidades c, carreras d, sedes e, jornadas f, aranceles g " & vbCrLf &_
				   "where a.post_bnuevo = b.post_bnuevo " & vbCrLf &_
				   "  and b.espe_ccod = c.espe_ccod " & vbCrLf &_
				   "  and c.carr_ccod = d.carr_ccod " & vbCrLf &_
				   "  and b.sede_ccod = e.sede_ccod " & vbCrLf &_
				   "  and b.jorn_ccod = f.jorn_ccod " & vbCrLf &_
				   "  and b.aran_ncorr = g.aran_ncorr " & vbCrLf &_
				   "  and a.post_ncorr = '" & v_post_ncorr & "' " & vbCrLf &_
				   "  and b.peri_ccod = '" & v_peri_ccod & "'" & vbCrLf &_
				   "  And isnull(b.ofer_bactiva,'S')='S' "
				   
				   
'---------------------------------------------------------------------------------------------
consulta_carreras = "select distinct b.sede_ccod, d.carr_ccod, d.carr_tdesc " & vbCrLf &_
                    "from postulantes a, ofertas_academicas b, especialidades c, carreras d, aranceles e " & vbCrLf &_
					"where a.post_bnuevo = b.post_bnuevo " & vbCrLf &_
					"  and b.espe_ccod = c.espe_ccod " & vbCrLf &_
					"  and c.carr_ccod = d.carr_ccod " & vbCrLf &_
					"  and b.aran_ncorr = e.aran_ncorr " & vbCrLf &_
					"  and cast(e.aran_nano_ingreso as varchar) = case a.post_bnuevo when 'S' then cast(e.aran_nano_ingreso as varchar) else '" & v_ano_ingreso & "' end " & vbCrLf &_
					"  and cast(a.post_ncorr as varchar) = '" & v_post_ncorr & "' " & vbCrLf &_
					"  and cast(b.peri_ccod as varchar) = '" & v_peri_ccod & "'" & vbCrLf &_
					"  And isnull(b.ofer_bactiva,'S')='S' "& vbCrLf &_
					"order by d.carr_tdesc asc"

consulta_especialidades = "select distinct b.sede_ccod, c.carr_ccod, c.espe_ccod, c.espe_tdesc " & vbCrLf &_
                          "from postulantes a, ofertas_academicas b, especialidades c, aranceles d  " & vbCrLf &_
						  "where a.post_bnuevo = b.post_bnuevo  " & vbCrLf &_
						  "  and b.espe_ccod = c.espe_ccod  " & vbCrLf &_
						  "  and b.aran_ncorr = d.aran_ncorr " & vbCrLf &_
						  "  and cast(d.aran_nano_ingreso as varchar) = case a.post_bnuevo when 'S' then cast(d.aran_nano_ingreso as varchar) else '" & v_ano_ingreso & "' end " & vbCrLf &_
						  "  and cast(a.post_ncorr as varchar) = '" & v_post_ncorr & "'  " & vbCrLf &_
						  "  and cast(b.peri_ccod as varchar) = '" & v_peri_ccod & "'" & vbCrLf &_
						  " order by c.espe_tdesc asc"
						  
consulta_jornadas = "select distinct b.sede_ccod, c.carr_ccod, c.espe_ccod, d.jorn_ccod, d.jorn_tdesc " & vbCrLf &_
                    "from postulantes a, ofertas_academicas b, especialidades c, jornadas d, aranceles e  " & vbCrLf &_
					"where a.post_bnuevo = b.post_bnuevo  " & vbCrLf &_
					"  and b.espe_ccod = c.espe_ccod " & vbCrLf &_
					"  and b.jorn_ccod = d.jorn_ccod " & vbCrLf &_
					"  and b.aran_ncorr = e.aran_ncorr " & vbCrLf &_
					"  and cast(e.aran_nano_ingreso as varchar) = case a.post_bnuevo when 'S' then cast(e.aran_nano_ingreso as varchar) else '" & v_ano_ingreso & "' end " & vbCrLf &_
					"  and cast(a.post_ncorr as varchar) = '" & v_post_ncorr & "'  " & vbCrLf &_
					"  and cast(b.peri_ccod as varchar) = '" & v_peri_ccod & "'"


'----------------------------------------------------------------------------------------------
set errores = new CErrores


'-----------------------------------------------------------------------------------------------------------------

	lenguetas_postulacion = Array("Información general", "Datos Personales", "Ant. Académicos", "Ant. Familiares", "Apoderado Sostenedor", "Envío de Postulación")
	msjRecordatorio = ""

'-----------------------------------------------------------------------------------------------------------------

js_antiguo = "0"
'if b_antiguo then

	
	sql_carreras_postulante = "Select a.post_ncorr, b.sede_ccod, b.sede_ccod as c_sede_ccod, isnull(sede_tdesc, " & vbcrlf & _
              "(Select top 1 ee.sede_tdesc from detalle_postulantes x,ofertas_academicas y left outer join sedes ee " & vbcrlf & _  
		  	  " on  y.sede_ccod = ee.sede_ccod where x.post_ncorr=a.post_ncorr and y.ofer_ncorr=x.ofer_ncorr )" & vbcrlf & _
              ") as sede_tdesc,b.peri_ccod, b.jorn_ccod, " & vbcrlf & _
		 	  " b.jorn_ccod as c_jorn_ccod, isnull(jorn_tdesc, " & vbcrlf & _
              " (Select top 1 ff.jorn_tdesc from detalle_postulantes x,ofertas_academicas y left outer join jornadas ff  " & vbcrlf & _
		  	  " on  y.jorn_ccod = ff.jorn_ccod where x.post_ncorr=a.post_ncorr and y.ofer_ncorr=x.ofer_ncorr ) " & vbcrlf & _
              " ) as jorn_tdesc,b.espe_ccod,isnull(c.espe_tdesc, " & vbcrlf & _
              " (Select top 1 cc.espe_tdesc from detalle_postulantes x,ofertas_academicas y left outer join especialidades cc  " & vbcrlf & _
		  	  "    on  y.espe_ccod = cc.espe_ccod where x.post_ncorr=a.post_ncorr and y.ofer_ncorr=x.ofer_ncorr) " & vbcrlf & _
              ") as espe_tdesc, c.carr_ccod, c.carr_ccod as c_carr_ccod,isnull(carr_tdesc, " & vbcrlf & _
              "isnull((Select top 1 dd.carr_tdesc from detalle_postulantes x,ofertas_academicas y,especialidades z left outer join carreras dd  " & vbcrlf & _
		  	  "    on  z.carr_ccod = dd.carr_ccod where x.post_ncorr=a.post_ncorr and y.ofer_ncorr=x.ofer_ncorr and y.espe_ccod=z.espe_ccod )" & vbcrlf & _
              ",'NO EXISTE OFERTA')) as carr_tdesc,a.epos_ccod, g.epos_tdesc," & vbcrlf & _
			  "protic.ano_ingreso_carrera(a.pers_ncorr, c.carr_ccod) as ano_ingreso, " & vbcrlf & _
			  "case when b.post_bnuevo = 'S' then 'Nuevo' ELSE 'Antiguo' END AS tipo_alumno " & vbcrlf & _
			  "From postulantes a " & vbcrlf & _
		  	  "left outer join ofertas_academicas b  " & vbcrlf & _
		  	  "    on  a.ofer_ncorr = b.ofer_ncorr   " & vbcrlf & _
		  	  "left outer join especialidades c  " & vbcrlf & _
		  	  "    on  b.espe_ccod = c.espe_ccod  " & vbcrlf & _
              "left outer join carreras d  " & vbcrlf & _
		  	  "    on  c.carr_ccod = d.carr_ccod  " & vbcrlf & _
              "left outer join sedes e  " & vbcrlf & _
		  	  "    on  b.sede_ccod = e.sede_ccod      " & vbcrlf & _                   
              "left outer join jornadas f  " & vbcrlf & _
		  	  "    on  b.jorn_ccod = f.jorn_ccod         " & vbcrlf & _                     
			  "left outer join estados_postulantes g  " & vbcrlf & _
		  	  "    on  a.epos_ccod = g.epos_ccod   " & vbcrlf & _
		  	  "where cast(a.peri_ccod as varchar)= '" & v_peri_ccod & "'  " & vbcrlf & _
		  	  "and cast(a.pers_ncorr as varchar) = '" & v_pers_ncorr & "' " & vbcrlf & _
			  "and carr_tdesc <> 'NO EXISTE OFERTA' "
			  
	'response.Write("<pre>" & sql_carreras_postulante & "</pre>")  
	set f_carrera_postulante = new CFormulario
	f_carrera_postulante.Carga_Parametros "postulacion_1.xml", "carrera_postulante2"
	f_carrera_postulante.Inicializar conexion

	f_carrera_postulante.consultar sql_carreras_postulante

	js_antiguo = "1"
	
	f_botonera.AgregaBotonParam "siguiente", "accion", "GUARDAR"
	f_botonera.AgregaBotonParam "siguiente", "funcionValidacion", "validarSeleccion();" 
	f_botonera.AgregaBotonParam "siguiente", "formulario", "edicion2"
	f_botonera.AgregaBotonParam "cambiar_oferta", "funcionValidacion", "validarSeleccionCambioCarr();" 
	f_botonera.AgregaBotonParam "cambiar_oferta", "formulario", "edicion2"
	f_botonera.AgregaBotonParam "siguiente", "url", "pre_postulacion_2.asp"
	
		
'end if
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
function validarSeleccionCambioCarr()
{
form = document.edicion2;
nro = form.elements.length;
//alert("cantidad:"+nro)
valor = uno_seleccionado(form);
if	(valor == 1)// se selecciono uno
	{
	for	( i = 0; i < nro; i++ ) 
		{
		comp = form.elements[i];
		str  = form.elements[i].name;
		if	((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo'))
			{
			indice=extrae_indice(str);
			estado_postulacion = form.elements["m["+indice+"][epos_ccod]"].value;
			v_estado=form.elements["m["+indice+"][post_ncorr]"].value;
			//if	(estado_postulacion == 2)// si el estado de la postulacion es ENVIADO
				//{						 // no se puede llevar a cabo el cambio de carrera.
				//alert("La postulación que usted selecciono a sido ENVIADA.\n Opción válida sólo para postulaciones EN PROCESO.");
				//return false;
				//}
			return true;
		  	}
		}
	}
else	
	{
	alert('Ud. no ha seleccionado registro o selecciono más de uno, debe seleccionar sólo un registro.');
	return false;
	}
return false;	
}
function validarSeleccion()
{
form = document.edicion2;
nro = form.elements.length;
//alert("cantidad:"+nro)
valor = uno_seleccionado(form);
if	(valor == 1)// se selecciono uno
	{
	for	( i = 0; i < nro; i++ ) 
		{
		comp = form.elements[i];
		str  = form.elements[i].name;
		if	((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo'))
			{
		  	//	alert(str);
			indice=extrae_indice(str);
			 //alert("Indice:"+indice);
			v_estado=form.elements["m["+indice+"][post_ncorr]"].value;
			//if	((v_estado==1)) // estado del contrato debe ser activo
				//{ 
				//cont_ncorr = form.elements["m["+indice+"][cont_ncorr]"].value;
				//return true;
				//pagina = "../REPORTESNET/Comprobante.aspx?contrato=" +cont_ncorr+"&periodo="+<%=Periodo%>;
				//resultado = open(pagina,'wAgregar','width=800px, height=600px, scrollbars=yes, resizable=yes');
				//resultado.focus();
				return true;
				//}	
		  	}
		}
	//alert("Opción de impresión sólo para contratos activos.");	
	//return false;	
	}
else	
	{
	alert('Ud. no ha seleccionado registro o selecciono más de uno, debe seleccionar sólo un registro.');
	return false;
	}
//alert("Opción de impresión sólo para contratos activos.");	
return false;	
}
function uno_seleccionado(form){
	  	nro = form.elements.length;
   		num =0;
	   for( i = 0; i < nro; i++ ) {
		  comp = form.elements[i];
		  str  = form.elements[i].name;
		  
		  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo')){
	 		num += 1;
		  }
	   }
	   return num;
 }

function FiltrarCarreras(formulario, p_carr_ccod)
{	
	o_carr_ccod = formulario.elements["oferta[0][carr_ccod]"];
	v_sede_ccod = formulario.elements["oferta[0][sede_ccod]"].value;
	
	o_carr_ccod.length = 0;
	op = document.createElement("OPTION");
	op.value = "";
	op.text = "Seleccione carrera";
	o_carr_ccod.add(op);	

	for (i in (new VBArray(d_carreras.Keys())).toArray()) {
		if (d_carreras.Item(i).Item("sede_ccod") == v_sede_ccod) {			
			op = new Option(d_carreras.Item(i).Item("carr_tdesc"), d_carreras.Item(i).Item("carr_ccod"));
			if (d_carreras.Item(i).Item("carr_ccod") == p_carr_ccod)
				op.selected = true;
				
			o_carr_ccod.add(op);
		}		
	}
	FiltrarEspecialidades(formulario);
}

function FiltrarEspecialidades(formulario, p_espe_ccod)
{
	o_espe_ccod = formulario.elements["oferta[0][espe_ccod]"];
	v_sede_ccod = formulario.elements["oferta[0][sede_ccod]"].value;
	v_carr_ccod = formulario.elements["oferta[0][carr_ccod]"].value;
	
	o_espe_ccod.length = 0;
	op = document.createElement("OPTION");
	op.value = "";
	op.text = "Seleccione especialidad";
	o_espe_ccod.add(op);	

	for (i in (new VBArray(d_especialidades.Keys())).toArray()) {
		if ((d_especialidades.Item(i).Item("sede_ccod") == v_sede_ccod)  && (d_especialidades.Item(i).Item("carr_ccod") == v_carr_ccod) ) {			
			op = new Option(d_especialidades.Item(i).Item("espe_tdesc"), d_especialidades.Item(i).Item("espe_ccod"));			
			if (d_especialidades.Item(i).Item("espe_ccod") == p_espe_ccod)
				op.selected = true;
				
			o_espe_ccod.add(op);
		}		
	}	
	
	//FiltrarJornadas(formulario);
}


function FiltrarJornadas(formulario, p_jorn_ccod)
{
	o_jorn_ccod = formulario.elements["oferta[0][jorn_ccod]"];
	v_sede_ccod = formulario.elements["oferta[0][sede_ccod]"].value;
	v_carr_ccod = formulario.elements["oferta[0][carr_ccod]"].value;
	v_espe_ccod = formulario.elements["oferta[0][espe_ccod]"].value;
	
	o_jorn_ccod.length = 0;
	op = document.createElement("OPTION");
	op.value = "";
	op.text = "Seleccione jornada";
	o_jorn_ccod.add(op);	
	

	for (i in (new VBArray(d_jornadas.Keys())).toArray()) {	
		if ((d_jornadas.Item(i).Item("sede_ccod") == v_sede_ccod)  && (d_jornadas.Item(i).Item("carr_ccod") == v_carr_ccod) && (d_jornadas.Item(i).Item("espe_ccod") == v_espe_ccod) ) {			
			op = new Option(d_jornadas.Item(i).Item("jorn_tdesc"), d_jornadas.Item(i).Item("jorn_ccod"));
			if (d_jornadas.Item(i).Item("jorn_ccod") == p_jorn_ccod)
				op.selected = true;			
			
			o_jorn_ccod.add(op);
		}		
	}	
}


/*function InicioPagina()
{
	if ('<%'=js_contrato_generado%>' == '0') {
	
		if ('<%'=js_antiguo%>' == '0')
			FiltrarCarreras(document.edicion, '<%'=f_oferta_academica.ObtenerValor("carr_ccod")%>');
		
		FiltrarEspecialidades(document.edicion, '<%'=f_oferta_academica.ObtenerValor("espe_ccod")%>');
		//FiltrarJornadas(document.edicion, '<%'=f_oferta_academica.ObtenerValor("jorn_ccod")%>');
	}
}*/

</script>





</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); " onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
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
              <%pagina.DibujarTitulo("Información General")%><br><br>
              <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td><div align="justify"><%=msjRecordatorio%></div></td>
                </tr>
              </table>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><p>
                          <%pagina.DibujarSubtitulo "Datos del postulante"%>                      
                          </p>
                      <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="22%" height="20"><strong>Nombre Postulante </strong></td>
                          <td width="4%" height="20"><strong>:</strong></td>
                          <td width="74%" height="20"><%=fc_postulante.ObtenerValor("nombre_completo")%> </td>
                        </tr>
                        <tr>
                          <td height="20"><strong>Tipo de Postulante </strong></td>
                          <td height="20"><strong>:</strong></td>
                          <td height="20"><%=v_post_bnuevo_aux%>
						  <%'=fc_postulante.ObtenerValor("tipo_alumno")
						  %>
						  </td>
                        </tr>
                      </table>                      <p><br>
                            <%pagina.DibujarSubtitulo "Seleccionar Oferta Académica"%>
                            <br>
                      </p>
                      <!--<table width="90%" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="156" height="25"><strong>Sede Postulaci&oacute;n</strong></td>
                          <td width="14"><div align="left"><strong>:</strong></div></td>
                          <td width="185" height="25"><%'f_oferta_academica.DibujaCampo("sede_ccod")%> <%'f_oferta_academica.DibujaCampo("c_sede_ccod")
						  %></td>
                          <td width="224"><%'l_ofertas.DibujaCampoLista "oferta_academica", "sede_ccod" %></td>
                          <td width="224" rowspan="4"><div align="center"><%'if b_antiguo then f_botonera.DibujaBoton("cambiar_oferta")%></div></td>
                        </tr>
                        <tr>
                          <td height="25"><strong>Carrera Postulaci&oacute;n</strong></td>
                          <td><div align="left"><strong>:</strong></div></td>
                          <td height="25"><%'f_oferta_academica.DibujaCampo("carr_ccod")%> <%'f_oferta_academica.DibujaCampo("c_carr_ccod")%></td>
                          <td><%'l_ofertas.DibujaCampoLista "oferta_academica", "carr_ccod" %></td>
                          </tr>
                        <tr>
                          <td height="25"><strong>Especialidad / Menci&oacute;n</strong></td>
                          <td><div align="left"><strong>:</strong></div></td>
                          <td height="25"><%'f_oferta_academica.DibujaCampo("espe_ccod")%>                            </td>
                          <td><%'l_ofertas.DibujaCampoLista "oferta_academica", "espe_ccod" %></td>
                          </tr>
                        <tr>
                          <td height="25"><strong>Jornada</strong></td>
                          <td><div align="left"><strong>:</strong></div></td>
                          <td height="25"><%'f_oferta_academica.DibujaCampo("jorn_ccod")%>  <%'f_oferta_academica.DibujaCampo("c_jorn_ccod")%> </td>
                          <td><%'l_ofertas.DibujaCampoLista "oferta_academica", "jorn_ccod" %></td>
                          </tr>
                      </table>--></td>
                  </tr>
                </table>
                          <br>
            </form></td></tr>
			<tr><td>
				<table border="0" align="center">
				<tr>
					<td><form name="edicion2"><div align="center"><%f_carrera_postulante.dibujatabla()%></div></form></td>
				</tr>
				</table>
				</td>
			</tr>
			<tr><td>&nbsp;</td>
			</tr>
			<%if plec_ccod = "2" then%>
			<tr>
                <td><font color="#0033CC"><strong>Atenci&oacute;n : </strong></font> 
                  Si desea realizar algún cambio de carrera para este alumno, 
                  dir&iacute;jase al módulo correspondiente de cambios de carrera, 
                  para as&iacute; gestionar los movimientos que se hicieron para 
                  la antigua carrera. </td>
			</tr>
			<%end if%>
			<tr><td>&nbsp;</td>
			</tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="27%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("siguiente")%></div></td>
				  <td><div align="center"><%if b_antiguo then f_botonera.DibujaBoton("cambiar_oferta")%></div></td>
                  <td><div align="center">
                    <% 	if Session("ses_act_ancedentes")<>"" then f_botonera.AgregaBotonParam "salir", "url", "actualizacion_antecedentes.asp" end if%>
					<% 	if Session("ses_estado_alumno")=1 then f_botonera.AgregaBotonParam "salir", "url", "actualizacion_antecedentes_matriculados.asp" end if%>
					<%  if Session("alumno_asistente")="1" then f_botonera.AgregaBotonParam "salir", "url", "apoyo_postulacion.asp" end if%>
					<%f_botonera.DibujaBoton("salir")%>
                  </div></td>
                  </tr>
              </table>
            </div></td> 
            <td width="73%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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

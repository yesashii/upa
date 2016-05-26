<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:14/01/2013
'ACTUALIZADO POR		:JAIME PAINEMAL A.
'MOTIVO			:Optimizar código, eliminar sentencia *= y =*
'LINEA			:67,68
'********************************************************************
tipo = Session("tipo")
if	EsVacio(tipo) then
	tipo = 0 ' 1 solo pregrado, 2 solo postgrado y 0 ambos
	filtro_tcar_ccod = " and d.tcar_ccod in (1,2) "
else
	filtro_tcar_ccod = " and d.tcar_ccod in (" & tipo & ") "
end if
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
negocio.InicializaPortal conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "postulacion_1.xml", "botonera"


'---------------------------------------------------------------------------------------------------
v_peri_ccod = session("periodo_postulacion")'negocio.ObtenerPeriodoAcademico("POSTULACION")
peri_tdesc = conexion.consultaUno("Select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar)='"&v_peri_ccod&"'")

'response.Write("pers_ncorr "&v_pers_ncorr&" periodo "&v_peri_ccod)
'---------------------------------------------------------------------------------------------------
set f_oferta_academica = new CFormulario
f_oferta_academica.Carga_Parametros "postulacion_1.xml", "oferta_academica"
f_oferta_academica.Inicializar conexion

'consulta = "select a.post_ncorr, b.sede_ccod, b.sede_ccod as c_sede_ccod, b.peri_ccod, b.jorn_ccod, b.espe_ccod, c.carr_ccod, c.carr_ccod as c_carr_ccod, protic.ANO_INGRESO_CARRERA(a.pers_ncorr, c.carr_ccod) as ano_ingreso " & vbCrLf &_
'           "from postulantes a, ofertas_academicas b, especialidades c " & vbCrLf &_
'		   "where a.ofer_ncorr *= b.ofer_ncorr  " & vbCrLf &_
'		   "  and b.espe_ccod =* c.espe_ccod  " & vbCrLf &_
'		   "  and cast(a.peri_ccod as varchar)= '" & v_peri_ccod & "' " & vbCrLf &_
'		   "  and cast(a.pers_ncorr as varchar)= '" & v_pers_ncorr & "'"

consulta = "select a.post_ncorr, b.sede_ccod, b.sede_ccod as c_sede_ccod, b.peri_ccod, b.jorn_ccod, b.espe_ccod, c.carr_ccod, c.carr_ccod as c_carr_ccod, protic.ANO_INGRESO_CARRERA(a.pers_ncorr, c.carr_ccod) as ano_ingreso " & vbCrLf &_
           "from postulantes a LEFT OUTER JOIN (ofertas_academicas b " & vbCrLf &_
		   "RIGHT OUTER JOIN especialidades c " & vbCrLf &_
		   "  ON b.espe_ccod = c.espe_ccod ) " & vbCrLf &_
		   "  ON a.ofer_ncorr = b.ofer_ncorr  " & vbCrLf &_
		   "  WHERE cast(a.peri_ccod as varchar)= '" & v_peri_ccod & "' " & vbCrLf &_
		   "  and cast(a.pers_ncorr as varchar)= '" & v_pers_ncorr & "'"


'response.Write("pre"&consulta&"</pre>")
consulta_oferta_postulante = consulta

f_oferta_academica.Consultar consulta
f_oferta_academica.Siguiente

v_post_ncorr = f_oferta_academica.ObtenerValor("post_ncorr")

Session("post_ncorr") = v_post_ncorr

v_ano_ingreso = f_oferta_academica.ObtenerValor("ano_ingreso")
'---------------------------------------------------------------------------------------------------------------
set fc_postulante = new CFormulario
fc_postulante.Carga_Parametros "consulta.xml", "consulta"
fc_postulante.Inicializar conexion

consulta = "select a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre_completo, b.post_bnuevo, " & vbCrLf &_
		   "CASE b.post_bnuevo" & vbCrLf &_
		   "WHEN 'S' THEN 'NUEVO'" & vbCrLf &_
		   "WHEN 'N' THEN 'ANTIGUO'" & vbCrLf &_
		   "END AS tipo_alumno" & vbCrLf &_
		   "from personas_postulante a, postulantes b " & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
		   "  and cast(a.pers_ncorr as varchar)= '" & v_pers_ncorr & "' " & vbCrLf &_
		   "  and cast(b.peri_ccod as varchar)= '" & v_peri_ccod & "'"
		   
'response.write("<pre>"&consulta&"</pre>")		
		   
fc_postulante.Consultar consulta
fc_postulante.Siguiente


if fc_postulante.ObtenerValor("post_bnuevo") = "N" then
	b_antiguo = true
else
	b_antiguo = false
end if
	   
'---------------------------------------------------------------------------------------------------------------
consulta = "select distinct b.sede_ccod " & vbCrLf &_
           "from postulantes a, ofertas_academicas b, aranceles c " & vbCrLf &_
		   "where a.post_bnuevo = b.post_bnuevo " & vbCrLf &_
		   "  and b.aran_ncorr = c.aran_ncorr " & vbCrLf &_
		   "  and c.aran_nano_ingreso in (select case a.post_bnuevo" & vbCrLf &_
		   "								when 'S' then c.aran_nano_ingreso" & vbCrLf &_
		   "								else '" & v_ano_ingreso & "'" & vbCrLf &_
		   "								end)" & vbCrLf &_
		   "  and cast(a.post_ncorr as varchar)= '" & v_post_ncorr & "' " & vbCrLf &_
		   "  and cast(b.peri_ccod as varchar)= '" & v_peri_ccod & "'" & vbCrLf &_
		   " and b.ofer_bpublica='S'"& vbCrLf &_
		   " and isnull(b.ofer_bactiva,'S')='S'"
		   
		   '"  and c.aran_nano_ingreso = decode(a.post_bnuevo, 'S', c.aran_nano_ingreso, '" & v_ano_ingreso & "') " & vbCrLf &_		   
'and c.aran_nano_ingreso in (SELECT CASE a.post_bnuevo
'			      when 'S' then c.aran_nano_ingreso
'			      else ''
'			      end )		   
		   
f_oferta_academica.AgregaCampoParam "sede_ccod", "filtro", "sede_ccod in (" & consulta & ")"



'------------------------------------------------------------------------------------------------------------------
consulta_ofertas = "select b.ofer_ncorr, e.sede_ccod, e.sede_tdesc, d.carr_ccod, d.carr_tdesc, c.espe_ccod, c.espe_tdesc, f.jorn_ccod, f.jorn_tdesc " & vbCrLf &_
                   "from postulantes a, ofertas_academicas b, especialidades c, carreras d, sedes e, jornadas f, aranceles g " & vbCrLf &_
				   "where a.post_bnuevo = b.post_bnuevo " & vbCrLf &_
				   "  and b.espe_ccod = c.espe_ccod " & vbCrLf &_
				   "  and c.carr_ccod = d.carr_ccod " & vbCrLf &_
				   "  and b.sede_ccod = e.sede_ccod " & vbCrLf &_
				   "  and b.jorn_ccod = f.jorn_ccod " & vbCrLf &_
				   "  and b.aran_ncorr = g.aran_ncorr " & vbCrLf &_
                   "  and d.ecar_ccod = 1 " &vbcrlf & _
                   "  and d.inst_ccod = 1 " &vbcrlf & _ 
				   "  and cast(a.post_ncorr as varchar) = '" & v_post_ncorr & "' " & vbCrLf &_
				   "  and cast(b.peri_ccod as varchar)= '" & v_peri_ccod & "'" & vbCrLf
				   
				   '"  and a.post_ncorr = '" & v_post_ncorr & "' " & vbCrLf &_
				   '"  and b.peri_ccod = '" & v_peri_ccod & "'" & vbCrLf
'response.write("<pre>"&consulta_ofertas&"</pre>")				   

set l_ofertas = new CFormulario
l_ofertas.Carga_Parametros "postulacion_1.xml", "lista_ofertas"
l_ofertas.Inicializar conexion

l_ofertas.Consultar consulta_oferta_postulante
l_ofertas.Siguiente

l_ofertas.InicializaListaDependiente "oferta_academica", consulta_ofertas


'---------------------------------------------------------------------------------------------
consulta_carreras = "select distinct b.sede_ccod, d.carr_ccod, d.carr_tdesc " & vbCrLf &_
                    "from postulantes a, ofertas_academicas b, especialidades c, carreras d, aranceles e " & vbCrLf &_
					"where a.post_bnuevo = b.post_bnuevo " & vbCrLf &_
					"  and b.espe_ccod = c.espe_ccod " & vbCrLf &_
					"  and c.carr_ccod = d.carr_ccod " & vbCrLf &_
					"  and b.aran_ncorr = e.aran_ncorr " & vbCrLf &_
					filtro_tcar_ccod & vbCrLf &_
					"  and b.ofer_bpublica = 'S' " & vbCrLf &_
					"  and isnull(b.ofer_bactiva,'S')='S'"& vbCrLf &_
					"  and cast(e.aran_nano_ingreso as varchar) in (select case cast(a.post_bnuevo as varchar)" & vbCrLf &_
					"								when 'S' then cast(e.aran_nano_ingreso as varchar)" & vbCrLf &_
					"								else '" & v_ano_ingreso & "'" & vbCrLf &_
					"								end)" & vbCrLf &_
					"  and cast(a.post_ncorr as varchar)= '" & v_post_ncorr & "' " & vbCrLf &_
					"  and cast(b.peri_ccod as varchar)= '" & v_peri_ccod & "'" & vbCrLf &_
                    " and d.ecar_ccod = 1 " &vbcrlf & _
                    "  and d.inst_ccod = 1 " &vbcrlf & _ 
					"  and d.carr_ccod not in  ( select d.carr_ccod  " &vbcrlf & _
												" from detalle_postulantes a, ofertas_academicas b, " &vbcrlf & _
												" especialidades c,carreras d,sedes e,jornadas f, " &vbcrlf & _
												" ESTADO_EXAMEN_POSTULANTES G" & VBCRLF & _
												" where a.ofer_ncorr = b.ofer_ncorr " &vbcrlf & _
												" and b.espe_ccod = c.espe_ccod " &vbcrlf & _
												" and c.carr_ccod = d.carr_ccod " &vbcrlf & _
												" and b.sede_ccod =e.sede_ccod " &vbcrlf & _
												" and b.jorn_ccod = f.jorn_ccod " &vbcrlf & _
												" and A.EEPO_ccod = G.EEPO_ccod " &vbcrlf & _
                                                " and d.ecar_ccod = 1 " &vbcrlf & _
                                                "  and d.inst_ccod = 1 " &vbcrlf & _ 							
												" and cast(a.post_ncorr as varchar)='"&v_post_ncorr&"' )"&vbcrlf & _							
					" order by d.carr_tdesc asc" 							
												

consulta_especialidades = "select distinct b.sede_ccod, c.carr_ccod, c.espe_ccod, c.espe_tdesc " & vbCrLf &_
                          "from postulantes a, ofertas_academicas b, especialidades c, aranceles d  " & vbCrLf &_
						  "where a.post_bnuevo = b.post_bnuevo  " & vbCrLf &_
						  "  and b.espe_ccod = c.espe_ccod  " & vbCrLf &_
						  "  and b.aran_ncorr = d.aran_ncorr " & vbCrLf &_
						  "  and cast(d.aran_nano_ingreso as varchar) in (select case cast(a.post_bnuevo as varchar)" & vbCrLf &_
						  "								when 'S' then cast(d.aran_nano_ingreso as varchar) " & vbCrLf &_
						  "								else '" & v_ano_ingreso & "'" & vbCrLf &_
						  "								end)" & vbCrLf &_
						  "  and cast(a.post_ncorr as varchar)= '" & v_post_ncorr & "'  " & vbCrLf &_
						  "  and cast(b.peri_ccod as varchar)= '" & v_peri_ccod & "'" & vbCrLf &_
						  "order by c.espe_tdesc asc"
						  
						  '"  and d.aran_nano_ingreso = decode(a.post_bnuevo, 'S', d.aran_nano_ingreso, '" & v_ano_ingreso & "') " & vbCrLf &_
						  
consulta_jornadas = "select distinct b.sede_ccod, c.carr_ccod, c.espe_ccod, d.jorn_ccod, d.jorn_tdesc " & vbCrLf &_
                    "from postulantes a, ofertas_academicas b, especialidades c, jornadas d, aranceles e  " & vbCrLf &_
					"where a.post_bnuevo = b.post_bnuevo  " & vbCrLf &_
					"  and b.espe_ccod = c.espe_ccod " & vbCrLf &_
					"  and b.jorn_ccod = d.jorn_ccod " & vbCrLf &_
					"  and b.aran_ncorr = e.aran_ncorr " & vbCrLf &_
					"  and cast(e.aran_nano_ingreso as varchar) in (select case cast(a.post_bnuevo as varchar)" & vbCrLf &_
						  "								when 'S' then cast(e.aran_nano_ingreso as varchar) " & vbCrLf &_
						  "								else '" & v_ano_ingreso & "'" & vbCrLf &_
						  "								end)" & vbCrLf &_
					"  and cast(a.post_ncorr as varchar)= '" & v_post_ncorr & "'  " & vbCrLf &_
					"  and cast(b.peri_ccod as varchar)= '" & v_peri_ccod & "'"
					'"  and e.aran_nano_ingreso = decode(a.post_bnuevo, 'S', e.aran_nano_ingreso, '" & v_ano_ingreso & "') " & vbCrLf &_


'----------------------------------------------------------------------------------------------
set errores = new CErrores


'-----------------------------------------------------------------------------------------------------------------
v_epos_ccod = conexion.ConsultaUno("select epos_ccod from postulantes where cast(post_ncorr as varchar)= '" & v_post_ncorr & "'")

if v_epos_ccod = "2" then
	lenguetas_postulacion = Array(Array("Información general", "postulacion_1.asp"), Array("Datos Personales", "postulacion_2.asp"), Array("Ant. Académicos", "postulacion_3.asp"), Array("Ant. Familiares", "postulacion_4.asp"), Array("Apoderado Sostenedor", "postulacion_5.asp"))
	msjRecordatorio = "Se ha detectado que esta postulación ya ha sido enviada.  Si va a realizar cambios en la información de esta página, presione el botón ""Siguiente"" para guardarlos."
else
	lenguetas_postulacion = Array("Información general", "Datos Personales", "Ant. Académicos", "Ant. Familiares", "Apoderado Sostenedor", "Envío de Postulación")
	msjRecordatorio = ""
end if


'-----------------------------------------------------------------------------------------------------------------
set postulante = new CPostulante
postulante.Inicializar conexion, v_post_ncorr

js_contrato_generado = "0"
if postulante.TieneContratoGenerado then
	js_contrato_generado = "1"
	f_oferta_academica.AgregaCampoParam "sede_ccod", "permiso", "LECTURA"
	f_oferta_academica.AgregaCampoParam "carr_ccod", "permiso", "LECTURA"
	f_oferta_academica.AgregaCampoParam "espe_ccod", "permiso", "LECTURA"
	f_oferta_academica.AgregaCampoParam "jorn_ccod", "permiso", "LECTURA"
	
	f_oferta_academica.AgregaCampoParam "carr_ccod", "destino", "carreras"
	f_oferta_academica.AgregaCampoParam "carr_ccod", "filtro", ""
	
	f_oferta_academica.AgregaCampoParam "espe_ccod", "destino", "especialidades"
	f_oferta_academica.AgregaCampoParam "espe_ccod", "filtro", ""
	
	f_oferta_academica.AgregaCampoParam "jorn_ccod", "destino", "jornadas"
	f_oferta_academica.AgregaCampoParam "jorn_ccod", "filtro", ""
	
	f_botonera.AgregaBotonParam "siguiente", "accion", "NAVEGAR"
	f_botonera.AgregaBotonParam "siguiente", "url", "postulacion_2.asp"
	f_botonera.AgregaBotonParam "cambiar_oferta", "deshabilitado", "TRUE"
end if



'----------------------------------------------------------------------------------------------------
js_antiguo = "0"
if b_antiguo then
	js_antiguo = "1"
	f_oferta_academica.AgregaCampoParam "sede_ccod", "permiso", "OCULTO"
	f_oferta_academica.AgregaCampoParam "c_sede_ccod", "permiso", "LECTURA"
	
	f_oferta_academica.AgregaCampoParam "carr_ccod", "permiso", "OCULTO"
	f_oferta_academica.AgregaCampoParam "c_carr_ccod", "permiso", "LECTURA"	
	
	f_oferta_academica.AgregaCampoParam "carr_ccod", "destino", "carreras"
	f_oferta_academica.AgregaCampoParam "carr_ccod", "filtro", ""	
end if


sql_carreras_postulante =   " select G.EEPO_TDESC,a.post_ncorr,a.ofer_ncorr,d.carr_tdesc,c.espe_tdesc ,e.sede_tdesc,f.jorn_tdesc " &vbcrlf & _
							" from detalle_postulantes a, ofertas_academicas b, " &vbcrlf & _
							" especialidades c,carreras d,sedes e,jornadas f, " &vbcrlf & _
							" ESTADO_EXAMEN_POSTULANTES G" & VBCRLF & _
							" where a.ofer_ncorr = b.ofer_ncorr " &vbcrlf & _
							" and b.espe_ccod = c.espe_ccod " &vbcrlf & _
							" and c.carr_ccod = d.carr_ccod " &vbcrlf & _
							" and b.sede_ccod =e.sede_ccod " &vbcrlf & _
							" and b.jorn_ccod = f.jorn_ccod " &vbcrlf & _
							" and A.EEPO_ccod = G.EEPO_ccod " &vbcrlf & _
                            " and d.ecar_ccod = 1 " &vbcrlf & _
                            "  and d.inst_ccod = 1 " &vbcrlf & _ 							
							" and cast(a.post_ncorr as varchar)='"&v_post_ncorr&"' " &vbcrlf & _
							" order by carr_tdesc"

'response.Write("<pre>"&sql_carreras_postulante&"</pre>")
set f_carrera_postulante = new CFormulario
f_carrera_postulante.Carga_Parametros "postulacion_1.xml", "carrera_postulante"
f_carrera_postulante.Inicializar conexion

f_carrera_postulante.consultar sql_carreras_postulante
							
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

<%
pagina.GeneraDiccionarioJS consulta_carreras, conexion, "d_carreras"
pagina.GeneraDiccionarioJS consulta_especialidades, conexion, "d_especialidades"
pagina.GeneraDiccionarioJS consulta_jornadas, conexion, "d_jornadas"
'pagina.GeneraDiccionarioJS consulta_ofertas, conexion, "d_ofertas"
'l_ofertas.GeneraJS
%>


<script language="JavaScript">

function FiltrarCarreras(formulario, p_carr_ccod)
{	
	o_carr_ccod = formulario.elements["oferta[0][carr_ccod]"];
	v_sede_ccod = formulario.elements["oferta[0][sede_ccod]"].value;
	
	o_carr_ccod.length = 0;
	op = document.createElement("OPTION");
	op.value = "";
	<% if tipo=2 then%>
	op.text = "Seleccione programa";
	<% else%>
	op.text = "Seleccione carrera";
	<% end if%>
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
	
	FiltrarJornadas(formulario);
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


function InicioPagina()
{
	if ('<%=js_contrato_generado%>' == '0') {
	
		if ('<%=js_antiguo%>' == '0')
			FiltrarCarreras(document.edicion, '<%=f_oferta_academica.ObtenerValor("carr_ccod")%>');
		
		FiltrarEspecialidades(document.edicion, '<%=f_oferta_academica.ObtenerValor("espe_ccod")%>');
		FiltrarJornadas(document.edicion, '<%=f_oferta_academica.ObtenerValor("jorn_ccod")%>');
	}
}

</script>





</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">  
  <tr>
    <td valign="top" bgcolor="#e1eae0">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td colspan="3" valign="top" bgcolor="#FFFFFF" width="750" align="center">
    <img src="../imagenes/vineta2_r1_c1_2008.jpg" width="750" height="100"/>
    </td>
  </tr>
  <% 'pagina.DibujarEncabezado() %>  
  <tr>
    <td valign="top" bgcolor="#FFFFFF">

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
                          <td width="25%" height="20"><strong>Nombre Postulante </strong></td>
                          <td width="1%" height="20"><strong>:</strong></td>
                          <td width="74%" height="20"><%=fc_postulante.ObtenerValor("nombre_completo")%> </td>
                        </tr>
                        <tr>
                          <td height="20"><strong>Tipo de Postulante </strong></td>
                          <td height="20"><strong>:</strong></td>
                          <td height="20"><%=fc_postulante.ObtenerValor("tipo_alumno")%></td>
                        </tr>
                        <tr>
                          <td height="20"><strong>Periodo de Postulaci&oacute;n </strong></td>
                          <td height="20"><strong>:</strong></td>
                          <td height="20"><font size="2" color="#0066FF"><b><%=peri_tdesc%></b></font></td>
                        </tr>
                      </table>                      
                      <p><br>
                            <%pagina.DibujarSubtitulo "Seleccionar Oferta Académica"%>
                            <br>
                      </p>
                          <table width="90%" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td width="174" height="25"><strong>Sede Postulaci&oacute;n</strong></td>
                              <td width="12"><div align="left"><strong>:</strong></div></td>
                              <td width="217" height="25">
                                <%f_oferta_academica.DibujaCampo("sede_ccod")%>
                                <%f_oferta_academica.DibujaCampo("c_sede_ccod")%>
                              </td>
                              <td width="33">
                                <%'l_ofertas.DibujaCampoLista "oferta_academica", "sede_ccod" %>
                              </td>
                              <td width="143" rowspan="4"><div align="center">
                                  <%if b_antiguo then f_botonera.DibujaBoton("cambiar_oferta")%>
                                </div></td>
                            </tr>
                            <tr> 
                              <td height="25"><strong><% if tipo=2 then%>
														 Programa Postulaci&oacute;n
												  	  <% else%>
														Carrera Postulaci&oacute;n
													  <% end if%></strong></td>
                              <td><div align="left"><strong>:</strong></div></td>
                              <td height="25">
                                <%f_oferta_academica.DibujaCampo("carr_ccod")%>
                                <%f_oferta_academica.DibujaCampo("c_carr_ccod")%>
                              </td>
                              <td>
                                <%'l_ofertas.DibujaCampoLista "oferta_academica", "carr_ccod" %>
                              </td>
                            </tr>
                            <tr> 
                              <td height="25"><strong>Especialidad / Menci&oacute;n</strong></td>
                              <td><div align="left"><strong>:</strong></div></td>
                              <td height="25">
                                <%f_oferta_academica.DibujaCampo("espe_ccod")%>
                              </td>
                              <td>
                                <%'l_ofertas.DibujaCampoLista "oferta_academica", "espe_ccod" %>
                              </td>
                            </tr>
                            <tr> 
                              <td height="25"><strong>Jornada</strong></td>
                              <td><div align="left"><strong>:</strong></div></td>
                              <td height="25">
                                <%f_oferta_academica.DibujaCampo("jorn_ccod")%>
                              </td>
                              <td>
                                <%'l_ofertas.DibujaCampoLista "oferta_academica", "jorn_ccod" %>
                              </td>
                            </tr>
                            <tr>
                              <td height="25">&nbsp;</td>
                              <td>&nbsp;</td>
                              <td height="25">&nbsp;</td>
                              <td>
                                <%f_botonera.DibujaBoton("agregar")%>
                              </td>
                              <td>&nbsp;</td>
                            </tr>
                          </table>
                          <p> 
                            <% if tipo=2 then ' programas de postgrado
									pagina.DibujarSubtitulo "Lista De Programas A Las Que Postula"
							   else
									pagina.DibujarSubtitulo "Lista De Carreras A Las Que Postula"
							   end if
							'pagina.DibujarSubtitulo "Lista De Carreras A Las Que Postula"
							%>
                          </p>
                        </td>
                  </tr>
                </table>
                          
            </form></td></tr>

        </table>
		<form name="f_eliminar" method="post">
            <table width="100%" border="0">
              <tr> 
                <td colspan="3"><div align="right">P&aacute;ginas: 
                    <%f_carrera_postulante.accesopagina%>
                  </div></td>
              </tr>
              <tr> 
                <td colspan="3"><div align="center"> 
                    <%f_carrera_postulante.dibujatabla()%>
                  </div></td>
              </tr>
              <tr> 
                <td width="12%"><div align="right"></div></td>
                <td width="69%"><div align="right"> </div></td>
                <td width="19%"><div align="right"> 
                    <%f_botonera.DibujaBoton("eliminar")%>
                  </div></td>
              </tr>
            </table></form>
			</td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="27%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%if f_carrera_postulante.nrofilas > 0 then %><%f_botonera.DibujaBoton("siguiente")%><%end if%></div></td>
                  <td><div align="center">
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
</td>
</tr>
</table>
</body>
</html>

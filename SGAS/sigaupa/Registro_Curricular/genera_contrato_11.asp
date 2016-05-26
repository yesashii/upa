<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Generación de contratos - Información"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "genera_contrato_1.xml", "botonera"

'---------------------------------------------------------------------------------------------------
v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")

'if not EsVacio(q_pers_nrut) then
'    conexion.EjecutaP "genera_bloqueos('" & q_pers_nrut & "', '" & v_peri_ccod & "')"
	
'	v_mensaje_bloqueo = conexion.ConsultaUno("select bloqueos_matricula('" & q_pers_nrut & "', '" & v_peri_ccod & "') from dual")
'	if not EsVacio(v_mensaje_bloqueo) then
'		Session("mensajeError") = v_mensaje_bloqueo
'		set errores = new CErrores	
'		f_botonera.AgregaBotonParam "siguiente", "deshabilitado", "TRUE"
'	end if
'end if

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "genera_contrato_1.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select '' "
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv

'------------------------------------------------------------------------------------------------
if EsVacio(q_pers_nrut) then
q_pers_nrut=0
end if 

v_post_ncorr = conexion.consultauno(" select post_ncorr " & vbcrlf & _
									" from postulantes a, personas_postulante b " & vbcrlf & _
									" where a.pers_ncorr = b.pers_ncorr" & vbcrlf & _
									" and b.pers_nrut='"&q_pers_nrut&"'  and a.peri_ccod = '"&v_peri_ccod&"'")

if EsVacio(v_post_ncorr) then
	v_post_ncorr=0
end if 
'--------------------------------------------------------------------------------------------------------
'-----------------------	Validacion de entrega de documentos y estados de bloqueos -------------------
v_pers_ncorr=conexion.consultaUno("select pers_ncorr from postulantes where post_ncorr="&v_post_ncorr)
if Not EsVacio(v_pers_ncorr) then
	
v_cantidad_requerida=conexion.ConsultaUno("select count(doma_ccod) From documentos_matricula Where doma_bobligatorio='S'")

	sql_documentos_requeridos= "select count(*) as total "& vbcrlf & _
								" From documentos_matricula a,documentos_postulantes b "& vbcrlf & _
								" Where a.doma_ccod = b.doma_ccod "& vbcrlf & _
								" And cast(b.pers_ncorr as varchar)= '"&v_pers_ncorr&"' "& vbcrlf & _
								" And a.doma_ccod in (select doma_ccod "& vbcrlf & _
								" From documentos_matricula Where doma_bobligatorio='S') "
	'response.Write(sql_documentos_requeridos)							
	v_doc_requeridos=conexion.consultaUno(sql_documentos_requeridos)
	
	sql_bloqueos=" Select count(*) as total from bloqueos "& vbcrlf & _
				 " Where eblo_ccod=1 and pers_ncorr='"&v_pers_ncorr&"' "
	'response.Write(sql_bloqueos)			 
	v_bloqueos	=conexion.consultaUno(sql_bloqueos)
	
	if v_bloqueos > 0 and v_doc_requeridos < v_cantidad_requerida then
		v_tiene_impedimentos =true
		txt_impedimento=" 1.-No ha entregado toda la documentacion encesaria\n 2.- Esta en estado bloqueado en el Sistema \n"
	elseif v_doc_requeridos < v_cantidad_requerida then
		v_tiene_impedimentos =true
		txt_impedimento=" 1.-No ha entregado toda la documentacion necesaria\n "
	elseif v_bloqueos > 0 then
		v_tiene_impedimentos =true
		txt_impedimento=" 2.- Esta en estado bloqueado en el Sistema \n "
	end if
	if v_tiene_impedimentos then
		
		txt_encabezado_error="No es posible generar un contrato en este momento, "&_
							" ya que el postulante presenta situaciones de impedimento."&_
							"\nLas situaciones detectadas son las siguientes :\n\n"&txt_impedimento&_
							" \n Para ver mas detalles presione Aceptar, para salir presiones Cancelar"
	session("mensaje_error")=	txt_encabezado_error
	'response.Redirect("../REGISTRO_CURRICULAR/GENERA_CONTRATO_1.ASP")					
	end if
end if
'--------------------------------------------------------------------------------------------------------

consulta_datos = "select a.pers_ncorr, b.post_ncorr, cast(a.pers_nrut as varchar(10)) + ' - ' + a.pers_xdv as rut, a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre_completo, " & vbCrLf &_
                 "       e.carr_tdesc +' '+ d.espe_tdesc as carrera ,e.carr_tdesc, d.espe_tdesc, convert(datetime,getdate(), 103) as fecha_actual, g.sede_tdesc, " & vbCrLf &_
				 "	   f.aran_mmatricula, f.aran_mcolegiatura, isnull(f.aran_mmatricula, 0) + isnull(f.aran_mcolegiatura, 0) as total " & vbCrLf &_
				 "from personas_postulante a, postulantes b, detalle_postulantes bb, ofertas_academicas c, especialidades d, carreras e, aranceles f, sedes g " & vbCrLf &_
				 "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
				 "  and bb.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
				 "  and b.post_ncorr = bb.post_ncorr " & _
				 "  and c.espe_ccod = d.espe_ccod " & vbCrLf &_
				 "  and d.carr_ccod = e.carr_ccod " & vbCrLf &_
				 "  and c.aran_ncorr = f.aran_ncorr " & vbCrLf &_
				 "  and c.sede_ccod = g.sede_ccod " & vbCrLf &_
				 "  and b.tpos_ccod = 1 " & vbCrLf &_
				 "  and b.epos_ccod = 2 " & vbCrLf &_
				 "  and b.peri_ccod = " & v_peri_ccod & " " & vbCrLf &_
				 "  and a.pers_nrut = " & q_pers_nrut & " "

'response.Write("<pre>"&consulta_datos&"</pre>")	

set f_valores = new CFormulario
f_valores.Carga_Parametros "genera_contrato_1.xml", "tabla_valores"
f_valores.Inicializar conexion
f_valores.Consultar consulta_datos				 

mostrar_datos =True
if f_valores.NroFilas = 0 then
	f_botonera.AgregaBotonParam "siguiente", "deshabilitado", "TRUE"
	 mostrar_datos =False
end if

if v_tiene_impedimentos then
	 mostrar_datos =False
end if

set fc_datos = new CFormulario
fc_datos.Carga_Parametros "consulta.xml", "consulta"
fc_datos.Inicializar conexion
fc_datos.Consultar consulta_datos
fc_datos.Siguiente

f_botonera.AgregaBotonParam "siguiente", "url", "genera_contrato_2.asp?post_ncorr=" & fc_datos.ObtenerValor("post_ncorr")

'-------------------------------------------------------------------------------------------------
set persona = new CPersona
persona.Inicializar conexion, q_pers_nrut

set postulante = new CPostulante
'postulante.Inicializar conexion, persona.ObtenerPostNcorr(negocio.ObtenerPeriodoAcademico("POSTULACION"))

sql_postulante = " select cast(a.pers_nrut as varchar(10))  + ' - ' + a.pers_xdv as rut, " & vbcrlf & _
" a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre_completo, " & vbcrlf & _
" protic.obtener_nombre_carrera(c.ofer_ncorr, 'CE') as carrera, " & vbcrlf & _
" g.jorn_tdesc,h.sede_tdesc,i.eepo_tdesc,c.ofer_ncorr,i.eepo_ccod " & vbcrlf & _
" from  " & vbcrlf & _
" personas_postulante a,postulantes b,detalle_postulantes c, " & vbcrlf & _
" ofertas_academicas d,especialidades e,carreras f,jornadas g, " & vbcrlf & _
" sedes h,estado_examen_postulantes i " & vbcrlf & _
" where a.pers_ncorr = b.pers_ncorr " & vbcrlf & _
" and b.post_ncorr = c.post_ncorr " & vbcrlf & _
" and c.ofer_ncorr = d.ofer_ncorr " & vbcrlf & _
" and d.espe_ccod = e.espe_ccod " & vbcrlf & _
" and e.carr_ccod = f.carr_ccod   " & vbcrlf & _
" and d.jorn_ccod = g.jorn_ccod " & vbcrlf & _
" and d.sede_ccod = h.sede_ccod " & vbcrlf & _
" and c.eepo_ccod = i.eepo_ccod " & vbcrlf & _
" and b.epos_ccod = 2 " & vbcrlf & _
" and b.tpos_ccod = 1 " & vbcrlf & _
" and b.post_ncorr = '"&v_post_ncorr&"'" 'postulante.ObtenerSql("INFORMACION_POSTULANTE")



sql_codeudor = " select b.pers_tnombre + ' ' + b.pers_tape_paterno + ' ' +b.pers_tape_materno as nombre_codeudor, " & vbcrlf & _
" c.DIRE_TCALLE + ' ' + c.DIRE_TNRO + '  (' + d.CIUD_TDESC + ')' AS direccion_codeudor, " & vbcrlf & _
" b.pers_tfono " & vbcrlf & _
" from codeudor_postulacion a, " & vbcrlf & _
" personas_postulante b,direcciones_publica c,ciudades d " & vbcrlf & _
" where a.pers_ncorr = b.pers_ncorr " & vbcrlf & _
" and b.pers_ncorr = c.pers_ncorr " & vbcrlf & _
" and c.ciud_ccod = d.ciud_ccod " & vbcrlf & _
" and c.tdir_ccod= 1 " & vbcrlf & _
" and a.post_ncorr = '"&v_post_ncorr&"'"



set fc_postulante = new CFormulario
fc_postulante.Carga_Parametros "post_cerrada.xml", "info_postulacion_contrato"
fc_postulante.Inicializar conexion

fc_postulante.Consultar sql_postulante
fc_postulante.Siguiente
num = fc_postulante.nrofilas

NombrePostulante =fc_postulante.obtenervalor("nombre_completo")
RutPostulante    =fc_postulante.obtenervalor("rut")
fc_postulante.primero



set fc_codeudor = new CFormulario
fc_codeudor.Carga_Parametros "post_cerrada.xml", "info_codeudor"
fc_codeudor.Inicializar conexion

fc_codeudor.Consultar sql_codeudor
fc_codeudor.siguiente
NombreCodeudor = fc_codeudor.obtenervalor("nombre_codeudor")
DireccionCodeudor = fc_codeudor.obtenervalor("direccion_codeudor")
FonoCodeudor = fc_codeudor.obtenervalor("pers_tfono")

set botonera = new CFormulario
botonera.Carga_Parametros "class_postulante.xml", "botonera"

nmatriculas = CInt(conexion.ConsultaUno("select count(*) from alumnos where post_ncorr = '" & v_post_ncorr & "' and emat_ccod = 1"))
		
		if nmatriculas > 0 then
			EstaMatriculado = True
		else
			EstaMatriculado = False
		end if

botonera.AgregaBotonUrlParam "cambiar_info_codeudor", "post_ncorr", v_post_ncorr
if EstaMatriculado then
	botonera.AgregaBotonParam "cambiar_info_codeudor", "deshabilitado", "TRUE"
end if		

query_ofertas = " select a.ofer_ncorr,b.eepo_ccod " & _
				" from detalle_postulantes a,estado_examen_postulantes b " & _
				" where a.eepo_ccod = b.eepo_ccod " & _
				" and a.post_ncorr = '"&v_post_ncorr&"'"
				
conexion.Ejecuta query_ofertas
set rec_ofertas = conexion.ObtenerRS				

oferta_selec = conexion.consultauno("select ofer_ncorr from postulantes where post_ncorr = '"&v_post_ncorr&"'")

tiene_contrato = conexion.consultauno("select count(*) from contratos where post_ncorr = '"&v_post_ncorr&"'")


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
var t_busqueda;

rec_ofertas = new Array();

<%
if (rec_ofertas.BOF <> rec_ofertas.EOF) then

rec_ofertas.MoveFirst
i = 0
while not rec_ofertas.Eof
%>
rec_ofertas[<%=i%>] = new Array();
rec_ofertas[<%=i%>]["ofer_ncorr"] = '<%=rec_ofertas("ofer_ncorr")%>';
rec_ofertas[<%=i%>]["eepo_ccod"] = '<%=rec_ofertas("eepo_ccod")%>';



<%	
	rec_ofertas.MoveNext
	i = i + 1
wend
end if
%>



function ValidaBusqueda()
{
	rut=document.buscador.elements['busqueda[0][pers_nrut]'].value+'-'+document.buscador.elements['busqueda[0][pers_xdv]'].value
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido');		
		document.buscador.elements['busqueda[0][pers_xdv]'].focus()
		document.buscador.elements['busqueda[0][pers_xdv]'].select()
		return false;
	}
	
	return true;	
}

function verifica_check(formulario) {
	num=formulario.elements.length;
	c=0;
	for (i=0;i<num;i++){
		nombre = formulario.elements[i].name;
		var elem = new RegExp ("ofer_ncorr","gi");
		if (elem.test(nombre)){
			if((formulario.elements[i].checked==true)){
				c=c+1;
			}
		}
	}
	if (c<=0) {
		check = 0;
	}
	else {
		if (c > 1){
			check=2;
		}
		else{
			if (c==1){
				check=1;
			}
		}
	}
	return(check);
}

function enviar(formulario){
	tiene_contrato =<%=tiene_contrato%>
	if (tiene_contrato >0){
		window.navigate("genera_contrato_2.asp?post_ncorr="+<%=v_post_ncorr%>)
		//alert("genera_contrato_2.asp?post_ncorr="+<%=v_post_ncorr%>)
	}
	else
	{	
		if (verifica_check(formulario)==1){
			formulario.action='proc_matricular_carrera.asp';
			formulario.submit();
		}
		else {alert("Debe seleccionar una carrera ")}
	}	
}
function InicioPagina(formulario)
{

	t_busqueda = new CTabla("busqueda");
	num=<%=num%>
	tiene_contrato =<%=tiene_contrato%>


	for (i=0;i<num;i++){
			if ((formulario.elements["m["+i+"][eepo_ccod]"].value==2)||(formulario.elements["m["+i+"][eepo_ccod]"].value==5)||(formulario.elements["m["+i+"][eepo_ccod]"].value==6)){

					formulario.elements["m["+i+"][ofer_ncorr]"].disabled = false
					if(formulario.elements["m["+i+"][ofer_ncorr]"].value=='<%=oferta_selec%>') {
						formulario.elements["m["+i+"][ofer_ncorr]"].checked = true
					}

				}
			else{

					formulario.elements["m["+i+"][ofer_ncorr]"].disabled = true			

			}		

		}
		
	if (tiene_contrato > 0 )
	{
		for (i=0;i<num;i++){
			formulario.elements["m["+i+"][ofer_ncorr]"].disabled = true
		}
	}		
if (('<%=mostrar_datos%>' == 'False') && (document.buscador.elements["busqueda[0][pers_nrut]"].value!="")){
	alert("La Persona No Es Postulante")
}

}
	
function MensajeError(){
<% if session("mensaje_error")<> "" then %>
if(confirm('<%=session("mensaje_error")%>')){
	<%session("mensaje_error")=""%>
	location.href="impedimentos.asp?rut=<%=q_pers_nrut%>&dv=<%=q_pers_xdv%>";
	return;
}else{
	<%session("mensaje_error")=""%>
	location.href="genera_contrato_1.asp";
	return;
}
<%end if%>
}

</script>
<script>
MensajeError();
</script>
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');InicioPagina(document.edicion);" onBlur="revisaVentana();">
<table width="750" height="60%" border="0" align="center" cellpadding="0" cellspacing="0">
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
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Búsqueda de postulantes"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="32%"><div align="right">R.U.T.</div></td>
                        <td width="7%"><div align="center">:</div></td>
                        <td width="61%"><%f_busqueda.DibujaCampo("pers_nrut")%> 
                        - 
                          <%f_busqueda.DibujaCampo("pers_xdv")%> <%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]" %></td>
                      </tr>
                    </table>
                  </div></td>
                  <td width="19%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
                </tr>
              </table>         
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion" method="post">
			  <input name="post_ncorr" value="<%=v_post_ncorr%>" type="hidden">
			   <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>
					<%if mostrar_datos = true then%>
                      <%pagina.DibujarSubtitulo "Datos del postulante"%>

                            <br>
							
							<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td width="27%" colspan="2"> <div align="left"><strong>R.U.T. 
                                  Postulante</strong></div></td>
                              <td width="3%"><strong>:</strong></td>
                              <td width="70%"><%=RutPostulante%></td>
                            </tr>
                            <tr> 
                              <td colspan="2">&nbsp;</td>
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td colspan="2"><strong>Nombre Postulante</strong></td>
                              <td><strong>:</strong></td>
                              <td><%=NombrePostulante%></td>
                            </tr>
                            <tr> 
                              <td colspan="4"> <div align="center"> </div></td>
                            </tr>
							</table>
							<br>
							<%pagina.DibujarSubtitulo "Datos del Apoderado/Sostenedor"%>
							<table  width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td colspan="3">  </td>
                            </tr>
                            <tr> 
                              <td colspan="3">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td ><strong>Nombre Apoderado/Sostenedor<br>
                                </strong></td>
                              <td width="1%"><strong>:</strong></td>
                              <td width="64%"><%=NombreCodeudor%></td>
                            </tr>
                            <tr> 
                              <td colspan="3">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td width="35%"><strong>Direcci&oacute;n Apoderado/Sostenedor<br>
                                </strong></td>
                              
                              <td><strong>:</strong></td>
                              <td> <%=DireccionCodeudor%> </td>
                            </tr>
                            <tr> 
                              <td colspan="3">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td><strong>Telefono Apoderado/Sostenedor<br>
                                </strong></td>
                              <td><strong>:</strong></td>
                              <td> <%=FonoCodeudor%> </td>
                            </tr>
                            <tr> 
                              <td colspan="4"> <div align="right"> 
                                  <%botonera.DibujaBoton "cambiar_info_codeudor"%>
                                </div></td>
                            </tr>
                          
                         
                            <tr> 
                              <td colspan="4"><div align="right"></div></td>
                            </tr>
                          </table>
                           
                          <p>
                            <%end if%>
                            <%if mostrar_datos = true then%>
                          </p>
                          <table width="100%" border="0">
                            <tr> 
                              <td> <%pagina.DibujarSubtitulo "Postulaciones"%> </td>
                            </tr>
                            <tr> 
                              <td> <div align="center"> 
                                  <%fc_postulante.dibujatabla()%>
                                </div></td>
                            </tr>
                            <tr> 
                              <td> <div align="center"> </div></td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td> <%pagina.DibujarSubtitulo "Valores arancel"%> </td>
                            </tr>
                            <tr> 
                              <td> <div align="center"> 
                                  <%f_valores.DibujaTabla%>
                                </div></td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                            <tr>
                              <td>Nota : De la lista de carreras postuladas, seleccione 
                                la carrera en la cual se quiere matricular, la 
                                carrera &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;seleccionada 
                                debe tener el examen de admisi&oacute;n <em><strong>&quot;Aprobado&quot;</strong></em> 
                                para seguir con la generaci&oacute;n del contrato</td>
                            </tr>
                          </table>
                         
                            
                          </td>
                  </tr>
                      <div align="center">
        

                        <%end if%>
                      </div>
                    </table>
                          <br>
            </form></td></tr>
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
</body>
</html>

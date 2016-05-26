<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
anio_admision = request.querystring("b[0][anio_admision]")
sede_ccod = request.querystring("b[0][sede_ccod]")
DCUR_NCORR = request.querystring("b[0][DCUR_NCORR]")
rut = request.querystring("b[0][pers_nrut]")
xdv = request.querystring("b[0][pers_xdv]")

'response.Write("detalle "&detalle)
session("url_actual")="../mantenedores/postulacion_otec.asp?b[0][dcur_ncorr]="&dcur_ncorr&"&b[0][sede_ccod]="&sede_ccod&"&detalle=2&b[0][anio_admision]="&anio_admision&""
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Postulacion a Seminarios, Cursos y Diplomados"

set botonera =  new CFormulario
botonera.carga_parametros "anular_postulacion_otec.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores



'response.Write(carr_ccod)
dcur_tdesc = conexion.consultauno("SELECT dcur_tdesc FROM diplomados_cursos WHERE cast(dcur_ncorr as varchar)= '" & DCUR_NCORR & "'")
'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "anular_postulacion_otec.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 
 consulta = "Select '"&anio_admision&"' as anio_admision, '"&sede_ccod&"' as sede_ccod, '"&dcur_ncorr&"' as dcur_ncorr "
 f_busqueda.consultar consulta

 consulta = " select anio_admision,c.sede_ccod,c.sede_tdesc, b.dcur_ncorr,b.dcur_tdesc " & vbCrlf & _
			" from datos_generales_secciones_otec a, diplomados_cursos b,sedes c,ofertas_otec d " & vbCrlf & _
			" where a.dcur_ncorr=b.dcur_ncorr " & vbCrlf & _
			" and a.sede_ccod=c.sede_ccod  " & vbCrlf & _
			" and a.dgso_ncorr=d.dgso_ncorr " & vbCrlf & _
			" and a.esot_ccod not in (3,4) and a.dcur_ncorr not in (5,35) " & vbCrlf & _
			" order by anio_admision desc,c.sede_tdesc asc, b.dcur_tdesc asc " 
			
 f_busqueda.inicializaListaDependiente "lBusqueda", consulta
 f_busqueda.Siguiente

 f_busqueda.AgregaCampoCons "pers_nrut", rut
 f_busqueda.AgregaCampoCons "pers_xdv", xdv

tiene_datos_generales = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&DCUR_NCORR&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2)")

dcur_tdesc = conexion.consultaUno("select dcur_tdesc from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")
dcur_nsence = conexion.consultaUno("select dcur_nsence from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
dgso_ncorr = conexion.consultaUno("select dgso_ncorr from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&DCUR_NCORR&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2)")
periodo_programa = conexion.consultaUno("select 'FECHA INICIO : <strong>'+ protic.trunc(dgso_finicio) + '</strong>    FECHA TERMINO : <strong>' + protic.trunc(dgso_ftermino) + '</strong>' from datos_generales_secciones_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")

'response.Write(dgso_ncorr)

'---------------------------------------------------------------------------------------------------
set datos_generales = new cformulario
datos_generales.carga_parametros "anular_postulacion_otec.xml", "datos_generales"
datos_generales.inicializar conexion


consulta= " select a.dgso_ncorr,a.dcur_ncorr,a.sede_ccod,protic.trunc(dgso_finicio) as dgso_finicio,protic.trunc(dgso_ftermino) as dgso_ftermino,dgso_ncupo,dgso_nquorum,ofot_nmatricula,ofot_narancel " & vbCrlf & _
		  " from datos_generales_secciones_otec a left outer join ofertas_otec  b" & vbCrlf & _
		  "  on a.dgso_ncorr = b.dgso_ncorr " & vbCrlf &_
		  " where cast(a.dcur_ncorr as varchar)='"&DCUR_NCORR&"'  " & vbCrlf & _
		  " and cast(a.sede_ccod as varchar)='"&sede_ccod&"' " 

if tiene_datos_generales = "N" then
	consulta = "select '' as dgso_ncorr"
end if
'response.write("<pre>"&consulta&"</pre>")
datos_generales.consultar consulta 
if codigo <> "" then
	datos_generales.agregacampocons "sede_ccod", sede_ccod
	datos_generales.agregacampocons "dcur_ncorr", dcur_ncorr
end if
datos_generales.siguiente

'--------------iniciamos variables de sessión con valor de sede y programa para la postulación------------
if sede_ccod <> "" and dcur_ncorr <> "" then
	session("sede_ccod_postulacion") = sede_ccod
	session("dcur_ncorr_postulacion") = dcur_ncorr
end if



'---------------------------------------------------------------------------------------------------
set listado_postulaciones = new cformulario
listado_postulaciones.carga_parametros "anular_postulacion_otec.xml", "f_listado"
listado_postulaciones.inicializar conexion


consulta=	" select b.epot_ccod,b.pote_ncorr,dgso_ncorr,cast(a.pers_nrut as varchar)+'-'+a.pers_xdv as rut,a.pers_nrut,a.pers_xdv, " & vbCrlf & _
			" a.pers_tnombre +' '+ a.pers_tape_paterno + ' ' + a.pers_tape_materno as alumno, " & vbCrlf & _
			" c.epot_tdesc as estado_postulacion,protic.trunc(fecha_postulacion)as fecha_postulacion, " & vbCrlf & _
			" case fpot_ccod when 1 then 'Persona Natural' when 2  then 'Empresa sin Sence' when 3 then 'Empresa con Sence' when 4 then 'Empresa y Otic' when 5 then 'Persona Nat. Y Empresa' end as forma_pago " & vbCrlf & _
			"  from personas a " & vbCrlf & _
			"	join postulacion_otec b " & vbCrlf & _
			"		on a.pers_ncorr=b.pers_ncorr  " & vbCrlf & _
			"	join estados_postulacion_otec c " & vbCrlf & _
			"		on  b.epot_ccod=c.epot_ccod " & vbCrlf & _
			"	join personas per " & vbCrlf & _
			"		on isnull(empr_ncorr_empresa,empr_ncorr_otic) = per.PERS_NCORR " & vbCrlf & _
			" 	where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'  " & vbCrlf & _ 
			"		and cast(per.PERS_NRUT as varchar)='"&rut&"' "


'response.write("<pre>"&consulta&"</pre>")
listado_postulaciones.consultar consulta 
'listado_postulaciones.siguiente
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

function enviar(formulario){
	formulario.elements["detalle"].value="2";
  	if(preValidaFormulario(formulario)){	
		formulario.submit();
		
	}
}

function valida_anulacion(miformulario) {
   form = document.edicion
	
   nro = form.elements.length;
   num =0;
   msg_accion="pagar";
   for( i = 0; i < nro; i++ ) {
	//alert("en el FOR"+i);
	  comp = form.elements[i];
	  str  = form.elements[i].name;
	  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo')){
	     num += 1;
	  }
   }
   if( num > 0 ) {
	   	if (num >= 15){
			alert('Error: No podrá imprimir Comprobante de Ingresos.\nEl detalle a generar es mas grande que el comprobante.')
			return false;
		}
		if(confirm('Ud. ha seleccionado '+ num +' registros para '+ msg_accion +'. ¿Desea continuar?')){
			resultado = window.open('','ventana','menubar = no; width=820;height=500; top = 0; left = 0; scrollbars= yes')
			return true;
		}
		else{
			return false;
		}
   }else{
      alert('Ud. no ha seleccionado ningún registro para '+ msg_accion +' ');
	  return false;
   }	
   
   	alert('Debe seleccionar al menos un compromiso.')
	return false
}

function apaga_check(){
   nro = document.edicion.elements.length;
   num =0;
   for( i = 0; i < nro; i++ ) {
	  comp = document.edicion.elements[i];
	  str  = document.edicion.elements[i].name; 
	 
	  if(comp.type == 'checkbox'){ 
	     num += 1;
		 v_indice=extrae_indice(str);
		 v_estado=document.edicion.elements["m["+v_indice+"][epot_ccod]"].value;
		
		 if ((v_estado=="5")||(v_estado=="1")){
		 	document.edicion.elements["m["+v_indice+"][dgso_ncorr]"].disabled=true;
		 }
	  }
   }
}


</script>
<% f_busqueda.generaJS %>
</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="apaga_check();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="580" height="100%">
<tr valign="top" height="30">
	<td bgcolor="#EAEAEA">
</td>
</tr>
<tr valign="top">
	<td bgcolor="#EAEAEA">
<table width="652" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA" align="center">
	<table width="90%">
	<tr>
		<td align="center">
	
	<table width="50%"  border="0" align="left" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td align="left"><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                
				  <tr>
                    <td width="20%"><strong>Año</strong></td>
					<td width="3%"><strong>:</strong></td>
                    <td><%f_busqueda.dibujaCampoLista "lBusqueda", "anio_admision" %></td>
                  </tr>
				  <tr>
                    <td width="20%"><strong>Sede</strong></td>
					<td width="3%"><strong>:</strong></td>
                    <td><%f_busqueda.dibujaCampoLista "lBusqueda", "sede_ccod" %></td>
                  </tr>
				 <tr>
                    <td width="20%"><strong>Módulo</strong></td>
					<td width="3%"><strong>:</strong></td>
                    <td><%f_busqueda.dibujaCampoLista "lBusqueda", "dcur_ncorr"%></td>
                 </tr>
				 <tr>
                    <td width="20%"><strong>Rut</strong></td>
					<td width="3%"><strong>:</strong></td>
                    <td>   <%f_busqueda.DibujaCampo("pers_nrut") %>-<%f_busqueda.DibujaCampo("pers_xdv")%><strong> (Empresa u Otic)</strong></td>
                 </tr>				  
				 <tr> 
				  <td colspan="3"><input type="hidden" name="detalle" value=""></td>
                </tr>
				 <tr> 
				  <td colspan="3"><table width="100%">
				                      <tr>
									  	<td width="50%" align="center"><%'botonera.dibujaboton "crear_dcurso"%></td>
										<td width="50%" align="right"><%botonera.dibujaboton "buscar"%></td>
									  </tr>
				                  </table>
			       </td>
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
	</td>
	</tr>
	</table>
	</td></tr>
	
	
	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">&nbsp;</td></tr>
	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">
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
            <td><%pagina.DibujarLenguetas Array("Listado Postulantes"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="edicion">
                <table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>                        <div align="center"><%pagina.DibujarTituloPagina%> <br>
                    </div></td>
                    </tr>
                  
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <%if dcur_ncorr <> "" and not esVacio(dcur_ncorr) then %>
				  <tr>
                    <td><%response.Write("Año: <strong>"&anio_admision&"</strong>")
						%></td>
                  </tr>
				  <tr>
                    <td><%response.Write("SEDE: <strong>"&sede_tdesc&"</strong>")
						%></td>
                  </tr>
				  <tr>
                    <td><%response.Write("PROGRAMA: <strong>"&dcur_tdesc&"</strong>")
						%></td>
                  </tr>
				  <tr>
                    <td><%response.Write("CÓDIGO SENCE: <strong>"&dcur_nsence&"</strong>")
						%></td>
                  </tr>
				  <tr>
				  	<td><%=periodo_programa%>
					</td>
				  </tr>
				  <tr>
				  	<td>&nbsp;</td>
				  </tr>
				  <tr>
					  <td><div align="right"><strong>P&aacute;ginas :</strong>                          
						  <%listado_postulaciones.accesopagina%></div>
					   </td>
				  </tr>
				  <tr>
					  <td>&nbsp;</td>
				  </tr>
				  <tr>
					  <td colspan="2"><div align="center">
									  <%listado_postulaciones.dibujatabla()%>
					  </div></td>
				  </tr>
				  <tr>
					  <td>&nbsp;</td>
				  </tr>
				  <tr>
				  	<td align="center">
									  <table width="80%">
									  <tr>
									  	  <td align="right"><%botonera.dibujaBoton "anular_postulante"%></td>
										  <td align="left"></td>
									  </tr>
									  </table>
					</td>
				  </tr>
				  <%end if%>
				  <tr>
                    <td>&nbsp;</td>
                  </tr>
                </table>
              <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	</td>
  </tr>  
</table>
</td>
</tr>
</table>
</body>
</html>

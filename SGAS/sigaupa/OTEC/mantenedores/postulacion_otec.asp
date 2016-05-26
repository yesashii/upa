<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
anio_admision = request.querystring("b[0][anio_admision]")
sede_ccod = request.querystring("b[0][sede_ccod]")
DCUR_NCORR = request.querystring("b[0][DCUR_NCORR]")
tipo_usuario=session("tipo_usuario")
'response.Write("anio_admision = "&anio_admision&" , sede_ccod = "&sede_ccod&" , DCUR_NCORR = "&DCUR_NCORR&" , tipo_usuario = "&tipo_usuario)
'response.End
'--anio_admision = 2014 , sede_ccod = 1 , DCUR_NCORR = 969 , tipo_usuario = Asistente

'response.Write("detalle "&detalle)
session("url_actual")="../mantenedores/postulacion_otec.asp?b[0][dcur_ncorr]="&dcur_ncorr&"&b[0][sede_ccod]="&sede_ccod&"&detalle=2&b[0][anio_admision]="&anio_admision&""
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Postulacion a Seminarios, Cursos y Diplomados"

set botonera =  new CFormulario
botonera.carga_parametros "postulacion_otec.xml", "botonera"
'response.End()
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores

'response.Write("carr_ccod = "&carr_ccod)
'response.End
'--debe estar vacio

'response.Write("DCUR_NCORR = "&DCUR_NCORR)
'response.End
'--DCUR_NCORR = 969 -->>POSTÍTULO MENCIÓN EN CURRÍCULUM EDUCACIONAL (I&D_ABRIL 2014)

dcur_tdesc = conexion.consultauno("SELECT dcur_tdesc FROM diplomados_cursos WHERE cast(dcur_ncorr as varchar)= '" & DCUR_NCORR & "'")
'response.Write("<pre>"&dcur_tdesc&"</pre>")
'response.End
'--POSTÍTULO MENCIÓN EN CURRÍCULUM EDUCACIONAL (I&D_ABRIL 2014)

'-----------------------------------------------------------------------
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "postulacion_otec.xml", "f_busqueda"

 f_busqueda.Inicializar conexion

 consulta = "Select '"&anio_admision&"' as anio_admision, '"&sede_ccod&"' as sede_ccod, '"&dcur_ncorr&"' as dcur_ncorr "
 f_busqueda.consultar consulta
 'response.Write("<pre>"&consulta&"</pre>")
 'response.End
 '--Select '2014' as anio_admision, '1' as sede_ccod, '969' as dcur_ncorr

  filtro_dcur = ""
  if tipo_usuario = "Externo" then
   filtro_dcur = " and b.dcur_ncorr in (select dcur_ncorr from mantenedor_diplomados_cursos where isnull(mdcu_estado,0) = 1)"
  end if

 consulta = " select anio_admision,c.sede_ccod,c.sede_tdesc, b.dcur_ncorr,b.dcur_tdesc " & vbCrlf & _
			" from datos_generales_secciones_otec a, diplomados_cursos b,sedes c,ofertas_otec d " & vbCrlf & _
			" where a.dcur_ncorr=b.dcur_ncorr " & vbCrlf & _
			" and a.sede_ccod=c.sede_ccod  " & vbCrlf & _
			" and a.dgso_ncorr=d.dgso_ncorr " & vbCrlf & _
			" and a.esot_ccod not in (3,4) and a.dcur_ncorr not in (5,35) "& filtro_dcur & vbCrlf & _
			" order by anio_admision desc,c.sede_tdesc asc, b.dcur_tdesc asc "
 'response.Write("<pre>"&consulta&"</pre>")
 'response.End

 f_busqueda.inicializaListaDependiente "lBusqueda", consulta
 f_busqueda.Siguiente

'response.Write("DCUR_NCORR = "&DCUR_NCORR&" , sede_ccod = "&sede_ccod)
'response.End
'--DCUR_NCORR = 969 , sede_ccod = 1

tiene_datos_generales = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&DCUR_NCORR&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2)")
dcur_tdesc = conexion.consultaUno("select dcur_tdesc from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")
dcur_nsence = conexion.consultaUno("select dcur_nsence from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
dgso_ncorr = conexion.consultaUno("select dgso_ncorr from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&DCUR_NCORR&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2)")
periodo_programa = conexion.consultaUno("select 'FECHA INICIO : <strong>'+ protic.trunc(dgso_finicio) + '</strong>    FECHA TERMINO : <strong>' + protic.trunc(dgso_ftermino) + '</strong>' from datos_generales_secciones_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")

'response.Write("dgso_ncorr = "&dgso_ncorr)
'response.End
'--dgso_ncorr = 945

'---------------------------------------------------------------------------------------------------
set datos_generales = new cformulario
datos_generales.carga_parametros "postulacion_otec.xml", "datos_generales"
datos_generales.inicializar conexion


consulta= " select a.dgso_ncorr,a.dcur_ncorr,a.sede_ccod,protic.trunc(dgso_finicio) as dgso_finicio,protic.trunc(dgso_ftermino) as dgso_ftermino,dgso_ncupo,dgso_nquorum,ofot_nmatricula,ofot_narancel " & vbCrlf & _
		  " from datos_generales_secciones_otec a left outer join ofertas_otec  b" & vbCrlf & _
		  "  on a.dgso_ncorr = b.dgso_ncorr " & vbCrlf &_
		  " where cast(a.dcur_ncorr as varchar)='"&DCUR_NCORR&"'  " & vbCrlf & _
		  " and cast(a.sede_ccod as varchar)='"&sede_ccod&"' "
'response.Write("<pre>"&consulta&"</pre>")
'response.End

'response.Write("tiene_datos_generales = "&tiene_datos_generales)
'response.End
'--tiene_datos_generales = S
'Si no tiene datos generales ==> dgso_ncorr = ''
if tiene_datos_generales = "N" then
	consulta = "select '' as dgso_ncorr"
end if

datos_generales.consultar consulta

'response.Write("codigo = "&codigo)
'response.End
'--codigo =

if codigo <> "" then
	datos_generales.agregacampocons "sede_ccod", sede_ccod
	datos_generales.agregacampocons "dcur_ncorr", dcur_ncorr
end if

datos_generales.siguiente
'response.Write("sede_ccod = "&sede_ccod&" , dcur_ncorr = "&dcur_ncorr)
'response.End
'--sede_ccod = 1 , dcur_ncorr = 969

'--------------iniciamos variables de sessión con valor de sede y programa para la postulación------------
if sede_ccod <> "" and dcur_ncorr <> "" then
	session("sede_ccod_postulacion") = sede_ccod
	session("dcur_ncorr_postulacion") = dcur_ncorr
end if
'response.Write("sede_ccod = "&sede_ccod&" , dcur_ncorr = "&dcur_ncorr&" , dgso_ncorr = "&dgso_ncorr)
'response.End
'--sede_ccod = 1 , dcur_ncorr = 969 , dgso_ncorr = 945

'---------------------------------------------------------------------------------------------------
'----- LISTADO DE ALUMNOS QUE APARECEN EN PANTALLA -------------------------------------------------
'---------------------------------------------------------------------------------------------------
set listado_postulaciones = new cformulario
listado_postulaciones.carga_parametros "postulacion_otec.xml", "f_listado"
listado_postulaciones.inicializar conexion

consulta= " select cast(a.pers_nrut as varchar)+'-'+a.pers_xdv as rut,a.pers_nrut,a.pers_xdv, " & vbCrlf & _
		  " a.pers_tnombre +' '+ a.pers_tape_paterno + ' ' + a.pers_tape_materno as alumno, " & vbCrlf & _
		  " c.epot_tdesc as estado_postulacion, " & vbCrlf & _
		  " --case b.fpot_ccod when 1 then 'Persona Natural' when 2 then 'Empresa sin Sence' when 3 then 'Empresa con Sence' when 4 then 'Empresa y Otic' when 5 then 'Persona Nat. Y Empresa' end as forma_pago, " & vbCrlf & _
          " d.fpot_tdesc as forma_pago, " & vbCrlf & _
		  " protic.trunc(fecha_postulacion)as fecha_postulacion " & vbCrlf & _
		  " from personas a, postulacion_otec b,estados_postulacion_otec c, forma_pago_otec d " & vbCrlf & _
		  " where a.pers_ncorr=b.pers_ncorr and b.epot_ccod=c.epot_ccod " & vbCrlf & _
		  " and cast(b.dgso_ncorr as varchar)='"&dgso_ncorr&"'  " & vbCrlf & _
		  "  and b.fpot_ccod = d.fpot_ccod "
'response.write("<pre>"&consulta&"</pre>")
'response.End

listado_postulaciones.consultar consulta
'listado_postulaciones.siguiente

'---------------------------------------------------------------------------------------------------
'---------------------------------------------------------------------------------------------------
'---------------------------------------------------------------------------------------------------

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
function abrir() {

	direccion = "editar_diplomados_curso.asp";
	resultado=window.open(direccion, "ventana1","width=550,height=250,scrollbars=no, left=380, top=150");

 // window.close();
}
function abrir_programa() {
	var DCUR_NCORR = '<%=DCUR_NCORR%>';
	direccion = "editar_programas_dcurso.asp?dcur_ncorr=" + DCUR_NCORR;
	resultado=window.open(direccion, "ventana2","width=550,height=400,scrollbars=yes, left=380, top=100");

 // window.close();
}

function agregar_nuevo(formulario){
  	if(preValidaFormulario(formulario)){
		formulario.action = "agrega_postulantes.asp";
		formulario.submit();

	}
}

function aprobar_alumnos() {
	var dgso_ncorr = '<%=dgso_ncorr%>';
	direccion = "aprobar_postulantes.asp?dgso_ncorr=" + dgso_ncorr;
	resultado=window.open(direccion, "ventana2","width=500,height=400,scrollbars=yes, left=380, top=100");
}
</script>
<% f_busqueda.generaJS %>
</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
									  	  <td align="right"><%botonera.dibujaBoton "agregar_postulante"%></td>
										  <td align="left"><%botonera.dibujaBoton "aprobar_alumnos"%></td>
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

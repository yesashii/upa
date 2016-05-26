<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Informe de Beneficios"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.InicializaPortal conexion
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
Usuario = negocio.ObtenerUsuario()
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Informe_Beneficios.xml", "botonera"
'-----------------------------------------------------------------------
 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 tipo_beneficio = request.querystring("busqueda[0][tben_ccod]")
 beneficio = request.querystring("busqueda[0][stde_ccod]")
 estado_beneficio = request.querystring("busqueda[0][eben_ccod]")
 sede = request.querystring("busqueda[0][sede_ccod]")
 '------------------------------------------------------------------
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "Informe_Beneficios.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
 f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
 f_busqueda.AgregaCampoCons "tben_ccod", tipo_beneficio
 f_busqueda.AgregaCampoCons "stde_ccod", beneficio
 f_busqueda.AgregaCampoCons "eben_ccod", estado_beneficio
 f_busqueda.AgregaCampoCons "sede_ccod", sede
'--------------------------------------------------------------------
consulta = "SELECT pers_ncorr FROM personas WHERE pers_nrut='" & Usuario & "'"
pers_ncorr = conexion.ConsultaUno(consulta)
f_busqueda.AgregaCampoParam "sede_ccod","destino", "(select a.sede_ccod, d.sede_tdesc from sis_sedes_usuarios a, sis_usuarios b, personas c, sedes d where a.pers_ncorr = b.pers_ncorr and b.pers_ncorr = c.pers_ncorr and a.sede_ccod = d.sede_ccod and cast(a.pers_ncorr  as varchar) ='" & pers_ncorr & "') a"

'-----------------------------------------------------------------------
set f_respuesta = new CFormulario
 f_respuesta.Carga_Parametros "Informe_Beneficios.xml", "descuentos"
 f_respuesta.Inicializar conexion
'--------------------------------------------------------------------

 set f_descuentos = new CFormulario
 f_descuentos.Carga_Parametros "Informe_Beneficios.xml", "descuentos"
 f_descuentos.Inicializar conexion
 
' sql = "select i.tben_tdesc, a.stde_ccod, b.stde_tdesc, c.esde_tdesc, a.post_ncorr, d.pers_ncorr, a.ofer_ncorr, e.sede_ccod, " & vbCrLf &_
'			   "f.pers_nrut || '-' || f.pers_xdv as rut_alumno, f.pers_nrut, " & vbCrLf &_
'			   "f.pers_tape_paterno || ' ' || f.pers_tape_materno || ' ' || f.pers_tnombre as nombre_alumno, " & vbCrLf &_
'			   "h.carr_tdesc, to_number(a.sdes_mmatricula) as sdes_mmatricula, to_number(a.sdes_nporc_matricula) as sdes_nporc_matricula, " & vbCrLf &_
'			   "to_number(a.sdes_mcolegiatura) as sdes_mcolegiatura, to_number(a.sdes_nporc_colegiatura) as sdes_nporc_colegiatura, " & vbCrLf &_
'			   "nvl(a.sdes_mmatricula, 0) + nvl(a.sdes_mcolegiatura, 0) as subtotal, c.esde_ccod " & vbCrLf &_
'		"from sdescuentos a, stipos_descuentos b, sestados_descuentos c,  postulantes d, " & vbCrLf &_
'			 "ofertas_academicas e,  personas_postulante f,  especialidades g,  carreras h, " & vbCrLf &_
'			 "tipos_beneficios i, sedes j " & vbCrLf &_
'		"where a.stde_ccod = b.stde_ccod " & vbCrLf &_
'		  "and b.tben_ccod = i.tben_ccod " & vbCrLf &_
'		  "and a.esde_ccod = c.esde_ccod " & vbCrLf &_
'		  "and a.post_ncorr = d.post_ncorr " & vbCrLf &_
'		  "and a.ofer_ncorr = d.ofer_ncorr " & vbCrLf &_
'		  "and d.ofer_ncorr = e.ofer_ncorr " & vbCrLf &_
'		  "and d.pers_ncorr = f.pers_ncorr " & vbCrLf &_
'		  "and e.espe_ccod = g.espe_ccod " & vbCrLf &_
'		  "and g.carr_ccod = h.carr_ccod " & vbCrLf &_
'		  "and e.sede_ccod = j.sede_ccod " & vbCrLf &_
'		  "and d.peri_ccod ='" & Periodo & "' " & vbCrLf &_
'		  "and b.tben_ccod = nvl('" & tipo_beneficio & "', b.tben_ccod) " & vbCrLf &_
'		  "and a.stde_ccod =  nvl('" & beneficio & "', a.stde_ccod) " & vbCrLf &_
'		  "and f.pers_nrut =  nvl('" & rut_alumno & "', f.pers_nrut) " & vbCrLf &_
'		  "and a.esde_ccod =  nvl('" & estado_beneficio & "', a.esde_ccod) " & vbCrLf &_
 '         "and j.sede_ccod =  nvl('" & sede & "', j.sede_ccod) " & vbCrLf &_
	'	  "and exists (select 1 " & vbCrLf &_
'            "from sis_sedes_usuarios a2 " & vbCrLf &_
'			"where a2.pers_ncorr =" & pers_ncorr & " " & vbCrLf &_
'			  "and a2.sede_ccod = j.sede_ccod " & vbCrLf &_
 '          ") " & vbCrLf &_
	'	  "ORDER BY nombre_alumno "
'if EsVacio(tipo_beneficio) then
'		filtro = ""	
		'  response.Write("<hr>"&beneficio&"<hr>")
sql = "select i.tben_tdesc, a.stde_ccod, b.stde_tdesc, c.esde_tdesc, a.post_ncorr, d.pers_ncorr, a.ofer_ncorr, e.sede_ccod," & vbCrLf &_
		"    cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as rut_alumno, f.pers_nrut," & vbCrLf &_
		"    f.pers_tape_paterno + ' ' + f.pers_tape_materno + ' ' + f.pers_tnombre as nombre_alumno," & vbCrLf &_
		"    h.carr_tdesc,cast(a.sdes_mmatricula as int) as sdes_mmatricula," & vbCrLf &_
		"    a.sdes_nporc_matricula as sdes_nporc_matricula," & vbCrLf &_
		"    cast(a.sdes_mcolegiatura as int) as sdes_mcolegiatura,a.sdes_nporc_colegiatura as sdes_nporc_colegiatura," & vbCrLf &_
		"    cast(isnull(a.sdes_mmatricula, 0) + isnull(a.sdes_mcolegiatura, 0) as int) as subtotal, c.esde_ccod" & vbCrLf &_
		"    from sdescuentos a,stipos_descuentos b,sestados_descuentos c," & vbCrLf &_
		"          postulantes d,ofertas_academicas e,personas_postulante f," & vbCrLf &_
		"          especialidades g,carreras h,tipos_beneficios i,sedes j" & vbCrLf &_
		"    where a.stde_ccod = b.stde_ccod" & vbCrLf &_
		"        and a.esde_ccod = c.esde_ccod " & vbCrLf &_
		"        and a.post_ncorr = d.post_ncorr " & vbCrLf &_
		"        and a.ofer_ncorr = d.ofer_ncorr" & vbCrLf &_
		"        and d.ofer_ncorr = e.ofer_ncorr " & vbCrLf &_
		"        and d.pers_ncorr = f.pers_ncorr" & vbCrLf &_
		"        and e.espe_ccod = g.espe_ccod " & vbCrLf &_
		"        and g.carr_ccod = h.carr_ccod" & vbCrLf &_
		"        and e.sede_ccod = j.sede_ccod  " & vbCrLf &_
		"        and b.tben_ccod = i.tben_ccod " & vbCrLf &_
		"        and d.peri_ccod ='" & Periodo & "' "
		if tipo_beneficio <>"" then
		 	sql= sql & " and cast(b.tben_ccod as varchar) ='" & tipo_beneficio & "'" 
		end if
		if beneficio<>"" then
		 	sql= sql & " and cast(a.stde_ccod as varchar) ='" & beneficio & "'"
		end if
		if rut_alumno <> "" then
		 	sql= sql & " and cast(f.pers_nrut as varchar) ='" & rut_alumno & "'"
		end if
		if estado_beneficio<>"" then
		 	sql= sql & " and cast(a.esde_ccod as varchar) ='" & estado_beneficio & "'"
		end if
		if sede<>"" then
		 	sql= sql & " and cast(j.sede_ccod as varchar) ='" & sede & "'"
		end if 
		sql= sql & " and exists (select 1 " & vbCrLf &_
		"from sis_sedes_usuarios a2 " & vbCrLf &_
		"where cast(a2.pers_ncorr as varchar) ='" & pers_ncorr & "' " & vbCrLf &_
		"and a2.sede_ccod = j.sede_ccod " & vbCrLf &_
		") " & vbCrLf &_
		"ORDER BY nombre_alumno"
'response.Write("<pre>"&sql&"</pre>")
'response.End()		 
 if Request.QueryString <> "" then
   f_descuentos.consultar sql
   f_respuesta.consultar sql
   fila = 0
   while f_respuesta.siguiente
     RUT = f_respuesta.obtenerValor ("pers_nrut")
     if contrato_generado (Periodo, RUT) = true then
       f_descuentos.AgregaCampoFilaParam fila, "esde_ccod", "permiso", "LECTURA"	  
     end if
     fila = fila + 1
   wend
  else
	 f_descuentos.consultar "select '' where 1 = 2"
	 f_descuentos.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
  end if
 
'conexion.Ejecuta consulta
'set rec_beneficios = conexion.ObtenerRS

%>

<%
  function contrato_generado(periodo,rut)
  consulta = "select b.post_ncorr "&_ 
           "from personas_postulante a, postulantes b "&_ 
		   "where a.pers_ncorr = b.pers_ncorr "&_ 
		   "  and b.peri_ccod = '" & periodo & "' "&_ 
		   "  and cast(a.pers_nrut as varchar) = '" & rut & "'"

  post_ncorr = conexion.ConsultaUno(consulta)

  consulta = "select count(*) "&_ 
           "from contratos "&_ 
		   "where econ_ccod <> 3 "&_ 
		   "  and cast(post_ncorr as varchar) = '" & post_ncorr & "'"
  
  if CInt(conexion.ConsultaUno(consulta)) > 0 then
	contrato_generado = true
  else
	contrato_generado = false
  end if

  end function
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
function Validar()
{
	formulario = document.buscador;
	
	rut_alumno = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }		
	return true;
}

</script>
<!--
<script language="JavaScript">
arr_beneficios = new Array();

<%
  'rec_beneficios.MoveFirst
  'i = 0
  'while not rec_beneficios.Eof
%>
    arr_beneficios[<%'=i%>] = new Array();
    arr_beneficios[<%'=i%>]["stde_ccod"] = '<%'=rec_beneficios("stde_ccod")%>';
    arr_beneficios[<%'=i%>]["stde_tdesc"] = '<%'=rec_beneficios("stde_tdesc")%>';
    arr_beneficios[<%'=i%>]["tben_ccod"] = '<%'=rec_beneficios("tben_ccod")%>';
<%	
   'rec_beneficios.MoveNext
   ' i = i + 1
  'wend
%>

function CargarCuentas(formulario, tben_ccod)
{
	formulario.elements["busqueda[0][stde_ccod]"].length = 0;
	op = document.createElement("OPTION");
	op.value = "-1";
	op.text = "Seleccione Beneficio";
	formulario.elements["busqueda[0][stde_ccod]"].add(op)
	for (i = 0; i < arr_beneficios.length; i++)
	  { 
		if (arr_beneficios[i]["tben_ccod"] == tben_ccod)
		 {
			op = document.createElement("OPTION");
			op.value = arr_beneficios[i]["stde_ccod"];
			op.text = arr_beneficios[i]["stde_tdesc"];
			formulario.elements["busqueda[0][stde_ccod]"].add(op)			
		 }
	}	
}

</script>
-->



<style type="text/css">
<!--
.style4 {
	color: #42424A;
	font-weight: bold;
}
.style8 {font-size: 18px}
-->
</style>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
            <tr>
              <td width="9"><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="100%" height="1" border="0" alt=""></td>
              <td width="7"><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
            <tr>
              <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td width="9"><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><%pagina.DibujarLenguetas Array("Búsqueda de contratos para activar"), 1 %></td>
              <td width="7"><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>              
            </tr>
            <tr>
              <td width="9"><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
              <td width="7"><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
				<form name="buscador">
				<BR>
                      <table width="98%"  border="0">
                        <tr> 
                          <td>Tipo Beneficio</td>
                          <td>:</td>
                          <td><%f_busqueda.DibujaCampo "tben_ccod" %></td>
                          <td>Beneficio</td>
                          <td>:</td>
                          <td><%f_busqueda.DibujaCampo "stde_ccod" %></td>
                          <td rowspan="3"> <div align="center"> 
                              <% botonera.DibujaBoton "buscar" %>
                            </div></td>
                        </tr>
                        <tr>
                          <td>Rut Alumno</td>
                          <td>:</td>
                          <td> 
                            <% f_busqueda.DibujaCampo ("pers_nrut") %>
                            - 
                            <% f_busqueda.DibujaCampo ("pers_xdv") %>
                            <a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a> 
                          </td>
                          <td>Estado Beneficio</td>
                          <td>:</td>
                          <td>
                            <% f_busqueda.DibujaCampo ("eben_ccod") %>
                          </td>
                        </tr>
                        <tr> 
                          <td width="15%">Sede</td>
                          <td width="4%">:</td>
                          <td width="21%"><%f_busqueda.DibujaCampo ("sede_ccod") %></td>
                          <td width="17%">&nbsp;</td>
                          <td width="3%">&nbsp;</td>
                          <td width="23%">&nbsp;</td>
                        </tr>
                      </table>
				</form>
                </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="100%" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
      </tr>
    </table>	
	<br>		
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="100%" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>			  
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td bgcolor="#D8D8DE">
				<%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %>				
				</td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>			 
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
&nbsp;<div align="center"><%pagina.DibujarTituloPagina%>
                    <table width="100%" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                            <% f_descuentos.AccesoPagina %>
                          </div></td>
                        <td width="24"> <div align="right"> </div></td>
                      </tr>
                    </table>
                  </div>
<form name="edicion">
                    <div align="center">
                      <%pagina.DibujarSubtitulo "Contratos"%>
                      <br>
                      <% f_descuentos.DibujaTabla()%>
                    </div>
                  </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="99" bgcolor="#D8D8DE"><table width="100%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="20%"> <div align="left"> 
                          <% botonera.dibujaboton "guardar" %>
                        </div></td>
                      <td width="80%">
                        <%botonera.DibujaBoton "lanzadera"%>
                      </td>
                      <td width="80%">
                        <%
						'botonera.AgregaBotonParam "excel", "url", "informe_beneficios_excel.asp?rut=" & rut_alumno & "&amp;t_bene="  & tipo_beneficio & "&amp;bene=" & beneficio & "&amp;e_bene=" & estado_beneficio & "&amp;sede=" & sede
						'botonera.DibujaBoton "excel"
						%>
                      </td>
                      <td width="80%"> <div align="left"> 
                          <%  
						  'botonera.AgregaBotonParam "imprimir", "url", "/REPORTESNET/Informe_Beneficios.aspx?rut=" & rut_alumno & "&amp;t_bene="  & tipo_beneficio & "&amp;bene=" & beneficio & "&amp;e_bene=" & estado_beneficio & "&amp;sede=" & sede & "&amp;periodo=" & Periodo & "&amp;pers_ncorr="  & pers_ncorr
						  'botonera.AgregaBotonParam "imprimir", "url", "http://127.0.0.1/reportes/informe_beneficios/Informe_Beneficios.aspx?rut=" & rut_alumno & "&amp;t_bene="  & tipo_beneficio & "&amp;bene=" & beneficio & "&amp;e_bene=" & estado_beneficio & "&amp;sede=" & sede & "&amp;periodo=" & Periodo & "&amp;pers_ncorr="  & pers_ncorr
						  'botonera.dibujaboton "imprimir" %>
                        </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="256" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="311" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>			
		  </td>
        </tr>
      </table>	
   <p>&nbsp;</p></td>
  </tr>  
</table>
</body>
</html>

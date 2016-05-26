<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
tipo = Request.QueryString("tipo")
q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
dcur_ncorr = Request.QueryString("b[0][dcur_ncorr]")
'for each k in request.querystring
'	response.write(k&"="&request.querystring(k)&"<br>")
'next
'response.End()

'response.Write("dcur_ncorr "&dcur_ncorr)
session("url_actual")="../mantenedores/certificacion_otec.asp?b[0][pers_nrut]="&q_pers_nrut&"&b[0][pers_xdv]="&q_pers_xdv
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Certificados alumnos OTEC"

set botonera =  new CFormulario
botonera.carga_parametros "certificacion_otec.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores

'----------------------------------------------------------------------- 
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "certificacion_otec.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select '' "
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv

if q_pers_nrut <> "" and q_pers_xdv <> "" then
	pers_ncorr = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
	nombre = conexion.consultaUno("select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
	rut = conexion.consultaUno("select cast(pers_nrut as varchar) + '-' + pers_xdv from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")

    set f_programas = new CFormulario
	f_programas.Carga_Parametros "tabla_vacia.xml", "tabla"
	f_programas.Inicializar conexion
	
	consulta =  " select a.pers_ncorr, a.dgso_ncorr, d.sede_tdesc as sede, c.dcur_tdesc as programa, e.tdcu_tdesc as tipo,  " & vbCrLf &_
				" isnull((select sum(maot_nhoras_programa) from mallas_otec tt where tt.dcur_ncorr=c.dcur_ncorr),0) as horas,  " & vbCrLf &_
				" replace(pote_nnota_final,',','.') as nota_final, pote_nasistencia as asistencia,   " & vbCrLf &_
				" case pote_nest_final when 1 then 'REPROBADO' when 2 then 'APROBADO' else '' end  as estado,  " & vbCrLf &_
				" case vb_finanzas when 1 then 'SI' else 'NO' end as finanzas,   " & vbCrLf &_
				" case vb_biblioteca when 1 then 'SI' else 'NO' end as biblioteca,   " & vbCrLf &_
				" case vb_audiovisual when 1 then 'SI' else 'NO' end as audiovisual  " & vbCrLf &_
				" from postulacion_otec a, datos_generales_secciones_otec b, diplomados_cursos c,   " & vbCrLf &_
				" sedes d, tipos_diplomados_cursos e  " & vbCrLf &_
				" where cast(a.pers_ncorr as varchar) = '"&pers_ncorr&"'  " & vbCrLf &_
				" and a.dgso_ncorr=b.dgso_ncorr and b.dcur_ncorr=c.dcur_ncorr  " & vbCrLf &_
				" and b.sede_ccod=d.sede_ccod and c.tdcu_ccod=e.tdcu_ccod  " & vbCrLf &_
				" UNION  " & vbCrLf &_
				" select a.pers_ncorr, a.dgso_ncorr, d.sede_tdesc as sede, c.dcur_tdesc as programa, e.tdcu_tdesc as tipo,  " & vbCrLf &_
				" isnull((select sum(maot_nhoras_programa) from mallas_otec tt where tt.dcur_ncorr=c.dcur_ncorr),0) as horas,  " & vbCrLf &_
				" replace(pote_nnota_final,',','.') as nota_final, pote_nasistencia as asistencia,   " & vbCrLf &_
				" case pote_nest_final when 1 then 'REPROBADO' when 2 then 'APROBADO' else '' end  as estado,  " & vbCrLf &_
				" case vb_finanzas when 1 then 'SI' else 'NO' end as finanzas,   " & vbCrLf &_
				" case vb_biblioteca when 1 then 'SI' else 'NO' end as biblioteca,   " & vbCrLf &_
				" case vb_audiovisual when 1 then 'SI' else 'NO' end as audiovisual  " & vbCrLf &_
				" from postulacion_asociada_otec a, datos_generales_secciones_otec b, diplomados_cursos c,   " & vbCrLf &_
				" sedes d, tipos_diplomados_cursos e  " & vbCrLf &_
				" where cast(a.pers_ncorr as varchar) = '"&pers_ncorr&"'  " & vbCrLf &_
				" and a.dgso_ncorr=b.dgso_ncorr and b.dcur_ncorr=c.dcur_ncorr  " & vbCrLf &_
				" and b.sede_ccod=d.sede_ccod and c.tdcu_ccod=e.tdcu_ccod  " & vbCrLf &_
				" order by sede, programa " 
	f_programas.Consultar consulta
	'response.Write("<pre>"&consulta&"</pre>")
	
	set f_solicitudes = new CFormulario
	f_solicitudes.Carga_Parametros "tabla_vacia.xml", "tabla"
	f_solicitudes.Inicializar conexion
	
	consulta =  " select c.dcur_tdesc as programa, cert_tipo as tipo, cert_motivo as motivo,protic.trunc(cert_fecha) as fecha,  " & vbCrLf &_
				" d.pers_tnombre + ' ' + d.pers_tape_paterno as usuario   " & vbCrLf &_
				" from CERTIFICADOS_EMITIDOS_OTEC a, datos_generales_secciones_otec b, diplomados_cursos c, personas d  " & vbCrLf &_
				" where a.dgso_ncorr = b.dgso_ncorr and b.dcur_ncorr = c.dcur_ncorr  " & vbCrLf &_
				" and cast(d.pers_nrut as varchar) = a.audi_tusuario  " & vbCrLf &_
				" and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'  "

	f_solicitudes.Consultar consulta
	
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


<script language="JavaScript">

function dibujar(formulario){
	formulario.action='toma_carga_otec.asp';
	formulario.submit();
}

function enviar(formulario){
	formulario.elements["detalle"].value="2";
  	if(preValidaFormulario(formulario)){	
		formulario.submit();
	}
}

var t_busqueda;
var t_busqueda2;
function ValidaBusqueda()
{
	rut=document.buscador.elements['b[0][pers_nrut]'].value+'-'+document.buscador.elements['b[0][pers_xdv]'].value
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido');		
		document.buscador.elements['b[0][pers_nrut]'].focus()
		document.buscador.elements['b[0][pers_nrut]'].select()
		return false;
	}
	
	return true;	
}
function InicioPagina()
{
	t_busqueda = new CTabla("b");
	t_busqueda2 = new CTabla("e");
	t_busqueda3 = new CTabla("o");
}
function ValidaRut22()
{
	rut = t_busqueda2.ObtenerValor(0, "empr_nrut") + '-' + t_busqueda2.ObtenerValor(0, "empr_xdv")

	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido.');		
		t_busqueda2.filas[0].campos["empr_xdv"].objeto.select();
		return false;
	}
	
	return true;	
}
function ValidaRut33()
{
	rut = t_busqueda3.ObtenerValor(0, "empr_nrut") + '-' + t_busqueda3.ObtenerValor(0, "empr_xdv")

	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido.');		
		t_busqueda3.filas[0].campos["empr_xdv"].objeto.select();
		return false;
	}
	
	return true;	
}

function genera_digito (rut){
 var IgStringVerificador, IgN, IgSuma, IgDigito, IgDigitoVerificador, rut;
 var texto_rut = new String(rut);
 var posicion_guion = 0;
 
 posicion_guion = texto_rut.indexOf("-");
 if (posicion_guion != -1)
 {
    texto_rut = texto_rut.substring(0,posicion_guion);
    document.edicion2.elements["e[0][empr_nrut]"].value= texto_rut;
	rut = texto_rut;
 }
// texto_rut.
 //alert(texto_rut);
   if (rut.length==7) rut = '0' + rut; 

   
   IgStringVerificador = '32765432';
   IgSuma = 0;
   for( IgN = 0; IgN < 8 && IgN < rut.length; IgN++)
      IgSuma = eval(IgSuma + '+' + rut.substr(IgN, 1) + '*' + IgStringVerificador.substr(IgN, 1) + ';');
   IgDigito = 11 - IgSuma % 11;
   IgDigitoVerificador = IgDigito==10?'K':IgDigito==11?'0':IgDigito;
   //alert(IgDigitoVerificador);
   document.edicion2.elements["e[0][empr_xdv]"].value=IgDigitoVerificador;
//alert(rut+IgDigitoVerificador);
_Buscar(this, document.forms['edicion2'],'', 'ValidaRut22();', 'FALSE');
}

function genera_digito2 (rut){
 var IgStringVerificador, IgN, IgSuma, IgDigito, IgDigitoVerificador, rut;
 var texto_rut = new String(rut);
 var posicion_guion = 0;
 
 posicion_guion = texto_rut.indexOf("-");
 if (posicion_guion != -1)
 {
    texto_rut = texto_rut.substring(0,posicion_guion);
    document.edicion2.elements["o[0][empr_nrut]"].value= texto_rut;
	rut = texto_rut;
 }
// texto_rut.
 //alert(texto_rut);
   if (rut.length==7) rut = '0' + rut; 

   
   IgStringVerificador = '32765432';
   IgSuma = 0;
   for( IgN = 0; IgN < 8 && IgN < rut.length; IgN++)
      IgSuma = eval(IgSuma + '+' + rut.substr(IgN, 1) + '*' + IgStringVerificador.substr(IgN, 1) + ';');
   IgDigito = 11 - IgSuma % 11;
   IgDigitoVerificador = IgDigito==10?'K':IgDigito==11?'0':IgDigito;
   //alert(IgDigitoVerificador);
   document.edicion2.elements["o[0][empr_xdv]"].value=IgDigitoVerificador;
//alert(rut+IgDigitoVerificador);
_Buscar(this, document.forms['edicion2'],'', 'ValidaRut33();', 'FALSE');
}

function configurar_orden_compra() {
	
	direccion = '<%=url_orden%>';
	resultado=window.open(direccion, "ventana1","width=400,height=250,scrollbars=no, left=380, top=150");
	
 // window.close();
}

colores = Array(3);   colores[0] = ''; colores[1] = '#FFECC6'; colores[2] = '#FFECC6';

function guardar_imprimir(pers_ncorr,dgso_ncorr)
{
	var tipo = 10;
	
	respuesta = confirm("¿Está seguro que desea guardar la solicitud del certificado?"); 
	var rut = '<%=q_pers_nrut%>';
	if (respuesta)
	{
        irA('guarda_certificado.asp?pers_ncorr='+pers_ncorr+'&tipo='+tipo+'&dgso_ncorr='+dgso_ncorr, '1', 50, 50); 
	}
}

</script>

</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
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
	
	<table width="68%"  border="0" align="left" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
                    <td width="20%"><div align="center"><strong>Rut</strong></td>
					<td width="3%"><div align="center"><strong>:</strong></td>
                    <td width="50%"><%f_busqueda.DibujaCampo("pers_nrut")%> 
                          - 
                            <%f_busqueda.DibujaCampo("pers_xdv")%></td>
					<td align="right"><%botonera.dibujaboton "buscar"%></td>
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
	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Certificación OTEC"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
                <table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><div align="center"><%pagina.DibujarTituloPagina%> <br></div></td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <%if q_pers_nrut <> "" and q_pers_xdv <> "" then%>
				  <tr>
                    <td>
						<table width="100%" cellpadding="0" cellspacing="0">
						 <tr>
						 	<td width="19%" align="left"><strong>Rut</strong></td>
							<td width="1%" align="center"><strong>:</strong></td>
							<td width="80%" align="left"><%=rut%></td>
						 </tr>
						 <tr>
						 	<td width="19%" align="left"><strong>Nombre</strong></td>
							<td width="1%" align="center"><strong>:</strong></td>
							<td width="80%" align="left"><%=nombre%></td>
						 </tr>
						 <tr>
						 	<td colspan="3" align="center">&nbsp;</td>
						 </tr>	
						 <tr>
						 	<td colspan="3" align="center">
							
								<table class="v1" width="98%" border="1" bordercolor="#999999" bgcolor="#adadad" cellspacing="0" cellpadding="0">
                                	<tr borderColor="#999999" bgColor="#c4d7ff">
                                        <TH colspan="7"><FONT color="#333333">&nbsp;</FONT></TH>	
										<TH colspan="3" align="center"><FONT color="#333333">Visto Bueno de:</FONT></TH>
										<TH><FONT color="#333333">&nbsp;</FONT></TH>
                                    </tr>
									<tr borderColor="#999999" bgColor="#c4d7ff">
                                        <TH><FONT color="#333333">Sede</FONT></TH>	
										<TH><FONT color="#333333">Programa</FONT></TH>
                                        <TH><FONT color="#333333">Tipo</FONT></TH>
                                        <TH><FONT color="#333333">Horas</FONT></TH>
										<TH><FONT color="#333333">Nota Final</FONT></TH>
                                        <TH><FONT color="#333333">Asistencia</FONT></TH>
                                        <TH><FONT color="#333333">Estado Final</FONT></TH>
                                        <TH><FONT color="#333333">&nbsp;Finanzas&nbsp;</FONT></TH>
										<TH><FONT color="#333333">&nbsp;Biblioteca&nbsp;</FONT></TH>
										<TH><FONT color="#333333">&nbsp;Audiovisual&nbsp;</FONT></TH>
										<TH><FONT color="#333333">&nbsp;Acciones&nbsp;</FONT></TH>
                                    </tr>
									<%if f_programas.nroFilas > 0 then
									    f_programas.primero
										while f_programas.siguiente 
										sede 		= f_programas.obtenerValor("sede")
										programa 	= f_programas.obtenerValor("programa")
										tipo 		= f_programas.obtenerValor("tipo")
										horas 		= f_programas.obtenerValor("horas")
										nota_final 	= f_programas.obtenerValor("nota_final")
										asistencia 	= f_programas.obtenerValor("asistencia")
										estado 		= f_programas.obtenerValor("estado")
										finanzas 	= f_programas.obtenerValor("finanzas")
										biblioteca 	= f_programas.obtenerValor("biblioteca")
										audiovisual = f_programas.obtenerValor("audiovisual")
										pers_ncorr 	= f_programas.obtenerValor("pers_ncorr")
										dgso_ncorr  = f_programas.obtenerValor("dgso_ncorr")
									%>
                                        <tr bgColor="#ffffff">
                                            <td onMouseOver="resaltar(this);" onMouseOut="desResaltar(this);"><%=sede%></td>
											<td onMouseOver="resaltar(this);" onMouseOut="desResaltar(this);"><%=programa%></td>
                                            <td onMouseOver="resaltar(this);" onMouseOut="desResaltar(this);"><%=tipo%></td>
                                            <td onMouseOver="resaltar(this);" onMouseOut="desResaltar(this);" align="center"><%=horas%></td>
                                            <td onMouseOver="resaltar(this);" onMouseOut="desResaltar(this);" align="center"><%=nota_final%></td>
											<td onMouseOver="resaltar(this);" onMouseOut="desResaltar(this);" align="center"><%=asistencia%> %</td>
											<td onMouseOver="resaltar(this);" onMouseOut="desResaltar(this);"><%=estado%></td>
											<td onMouseOver="resaltar(this);" onMouseOut="desResaltar(this);" align="center"><%=finanzas%></td>
											<td onMouseOver="resaltar(this);" onMouseOut="desResaltar(this);" align="center"><%=biblioteca%></td>
											<td onMouseOver="resaltar(this);" onMouseOut="desResaltar(this);" align="center"><%=audiovisual%></td>
											<td onMouseOver="resaltar(this);" onMouseOut="desResaltar(this);" align="center">
											  <table width="50" cellpadding="0" cellspacing="0" align="center" border="0">
											  	<tr valign="top">
													<td width="25%" height="16" align="center">
													   <%if estado <> "" and finanzas = "SI" and biblioteca = "SI" and audiovisual = "SI" then%>
														   <a href="javascript:irA('certificado_otec.asp?dgso_ncorr=<%=dgso_ncorr%>&pers_ncorr=<%=pers_ncorr%>', '1', 750, 550);" title="Imprimir Certificado">
													   <%else%>
													   	   <a href="javascript:alert('Existen requerimientos que no se han cumplido para imprimir el certificado');" title="Imprimir Certificado">
													    <%end if%>
															<img width="16" height="16" src="../imagenes/imprimir.png" title="Imprimir Certificado" border="0">
														   </a>
								                    </td>
                                                    <td width="25%" height="16" align="center">
													   <%if estado <> "" and finanzas = "SI" and biblioteca = "SI" and audiovisual = "SI" then%>
														   <a href="javascript:irA('diploma_final_otec.asp?dgso_ncorr=<%=dgso_ncorr%>&pers_ncorr=<%=pers_ncorr%>', '1', 750, 550);" title="Imprimir Diploma Final">
													   <%else%>
													   	   <a href="javascript:alert('Existen requerimientos que no se han cumplido para imprimir el diploma');" title="Imprimir Diploma Final">
													    <%end if%>
															<img width="16" height="16" src="../imagenes/imprimir.png" title="Imprimir Diploma Final" border="0">
														   </a>
								                    </td>
                                                    <td width="25%" height="16" align="center">
													   <%if estado <> "" and finanzas = "SI" and biblioteca = "SI" and audiovisual = "SI" then%>
														   <a href="javascript:irA('certificado_final_otec.asp?dgso_ncorr=<%=dgso_ncorr%>&pers_ncorr=<%=pers_ncorr%>', '1', 750, 550);" title="Imprimir certificado Final">
													   <%else%>
													   	   <a href="javascript:alert('Existen requerimientos que no se han cumplido para imprimir el certificado');" title="Imprimir certificado Final">
													    <%end if%>
															<img width="16" height="16" src="../imagenes/imprimir.png" title="Imprimir Diploma Final" border="0">
														   </a>
								                    </td>
													<td width="25%" height="16" align="center">
													  <%if estado <> "" and finanzas = "SI" and biblioteca = "SI" and audiovisual = "SI" then%>
														   <a href="javascript:guardar_imprimir(<%=pers_ncorr%>,<%=dgso_ncorr%>);" title="Guardar solicitud certificado">
													   <%else%>
													   	   <a href="javascript:alert('Existen requerimientos que no se han cumplido para grabar solicitud de certificados');" title="Imprimir Certificado">
													   <%end if%>
													   <img width="16" height="16" src="../imagenes/guardar.png" title="Guardar Solicitud de Certificado" border="0">
													       </a>
													</td>
												</tr>
											  </table>
											</td>
										</tr>
									<%  wend
									else%>
                                    <tr bgColor="#ffffff">
                                    	<td colspan="11" align="center">No existen programas para certificación del alumno</td>
                                    </tr>
                                    <%end if%>
								</table>							
							</td>
						 </tr>
						 <tr>
						 	<td colspan="3" align="center">&nbsp;</td>
						 </tr>
						 <tr>
						 	<td colspan="3" align="center">&nbsp;</td>
						 </tr>
						 <tr>
						 	<td colspan="3" align="left">Certificados Emitidos por OTEC</td>
						 </tr>
						 <tr>
						 	<td colspan="3" align="center">&nbsp;</td>
						 </tr>
						 <tr>
						 	<td colspan="3" align="center">
								<table class="v1" width="98%" border="1" bordercolor="#999999" bgcolor="#adadad" cellspacing="0" cellpadding="0">
                                   <tr borderColor="#999999" bgColor="#c4d7ff">
                                        <TH><FONT color="#333333">Programa</FONT></TH>	
										<TH><FONT color="#333333">Tipo</FONT></TH>
                                        <TH><FONT color="#333333">Motivo</FONT></TH>
                                        <TH><FONT color="#333333">Fecha</FONT></TH>
										<TH><FONT color="#333333">Guardado por</FONT></TH>
                                    </tr>
									<%if f_solicitudes.nroFilas > 0 then
									    f_solicitudes.primero
										while f_solicitudes.siguiente 
										programa	= f_solicitudes.obtenerValor("programa")
										tipo		= f_solicitudes.obtenerValor("tipo")
										motivo 		= f_solicitudes.obtenerValor("motivo")
										fecha_a		= f_solicitudes.obtenerValor("fecha")
										usuario 	= f_solicitudes.obtenerValor("usuario")
									%>
                                        <tr bgColor="#ffffff">
                                            <td onMouseOver="resaltar(this);" onMouseOut="desResaltar(this);"><%=programa%></td>
											<td onMouseOver="resaltar(this);" onMouseOut="desResaltar(this);"><%=tipo%></td>
                                            <td onMouseOver="resaltar(this);" onMouseOut="desResaltar(this);"><%=motivo%></td>
                                            <td onMouseOver="resaltar(this);" onMouseOut="desResaltar(this);" align="center"><%=fecha_a%></td>
                                            <td onMouseOver="resaltar(this);" onMouseOut="desResaltar(this);" align="center"><%=usuario%></td>
                                        </tr>
									<%wend
									  else%>
                                    <tr bgColor="#ffffff">
                                    	<td colspan="5" align="center">No existen certificados solicitados del alumno</td>
                                    </tr>
                                    <%end if%>
							   </table>
							</td>
						 </tr>
						 
						</table>
					</td>
                  </tr>
				  <%end if%>
                </table>
              <br>
            </td>
		  </tr>
        </table>
	    </td>
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

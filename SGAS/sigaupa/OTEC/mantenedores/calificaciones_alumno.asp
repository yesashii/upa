<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION			        :
'FECHA CREACIÓN			      :
'CREADO POR				        :
'ENTRADA				          : NA
'SALIDA				            : NA
'MODULO QUE ES UTILIZADO	: EVALUAR PROGRAMAS
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 03/04/2013
'ACTUALIZADO POR			  : Luis Herrera G.
'MOTIVO				          : Corregir código, eliminar sentencia *= , =*
'LINEA				          : 103
'********************************************************************
tipo 					= Request.QueryString("tipo")
q_pers_nrut 	= Request.QueryString("b[0][pers_nrut]")
q_pers_xdv 		= Request.QueryString("b[0][pers_xdv]")
dcur_ncorr 		= Request.QueryString("b[0][dcur_ncorr]")
'for each k in request.querystring
'	response.write(k&"="&request.querystring(k)&"<br>")
'next
'response.End()

'response.Write("dcur_ncorr "&dcur_ncorr)
session("url_actual")="../mantenedores/calificaciones_alumno.asp?b[0][pers_nrut]="&q_pers_nrut&"&b[0][pers_xdv]="&q_pers_xdv&"&b[0][dcur_ncorr]="&dcur_ncorr
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Calificaciones Alumno"

set botonera =  new CFormulario
botonera.carga_parametros "calificaciones_alumno.xml", "botonera"
'response.End()
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores



'response.Write(carr_ccod)
'-----------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "calificaciones_alumno.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select '' "
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv

if q_pers_nrut <> "" and q_pers_xdv <> "" then

pers_ncorr = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
nombre = conexion.consultaUno("select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
rut = conexion.consultaUno("select cast(pers_nrut as varchar) + '-' + pers_xdv from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")

consulta = "select b.dgso_ncorr from postulacion_otec a, datos_generales_secciones_otec b " & vbCrLf &_
		   " where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and a.dgso_ncorr=b.dgso_ncorr " & vbCrLf &_
           " and cast(b.dcur_ncorr as varchar)='"&dcur_ncorr&"' and esot_ccod = 1"

'response.write(consulta)

dgso_ncorr = conexion.consultaUno(consulta)

consultaAux = "select pote_ncorr from postulacion_otec where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'"

'response.write(consultaAux)

pote_ncorr = conexion.consultaUno(consultaAux)




    set programa					=	new cformulario
	programa.inicializar					conexion
	programa.carga_parametros	    "calificaciones_alumno.xml","programas"

    consulta_programas 	= " select c.dcur_ncorr,c.dcur_tdesc " & vbCrlf & _
						  " from postulacion_otec a,datos_generales_secciones_otec b,diplomados_cursos c  " & vbCrlf & _
						  " where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and a.dgso_ncorr=b.dgso_ncorr " & vbCrlf & _
						  " and esot_ccod=1 and b.dcur_ncorr=c.dcur_ncorr "

    c_programa 	=	"select '' as dcur_ncorr "
    programa.consultar	c_programa

    programa.agregacampoparam	"dcur_ncorr",	"destino", "("& consulta_programas &")m"
    programa.agregacampocons	"dcur_ncorr",	dcur_ncorr

    if  programa.nrofilas > 0 then
		programa.siguiente
	end if


	set f_carga_tomada = new CFormulario
	f_carga_tomada.Carga_Parametros "calificaciones_alumno.xml", "calificaciones"
	f_carga_tomada.Inicializar conexion

'	consulta =  " select protic.trunc(a.caot_fecha_evaluado) as fecha,replace(caot_nnota_final,',','.') as nota,e.sitf_tdesc as estado, " & vbCrLf &_
'	            " d.mote_ccod as cod_modulo,mote_tdesc as modulo,seot_nhoras_programa as horas, " & vbCrLf &_
'				" protic.horario_otec_con_sala(a.seot_ncorr) as horario,protic.trunc(caot_fecha_carga) as fecha_carga,caot_nasistencia as asistencia " & vbCrLf &_
'				" from cargas_academicas_otec a, secciones_otec b, mallas_otec c, modulos_otec d,situaciones_finales e" & vbCrLf &_
'			    " where a.seot_ncorr=b.seot_ncorr and b.maot_ncorr=c.maot_ncorr" & vbCrLf &_
'				" and c.mote_ccod=d.mote_ccod and cast(pote_ncorr as varchar)='"&pote_ncorr&"' and a.sitf_ccod *= e.sitf_ccod"

'----------------------------------------------------------------------------------nueva consulta 2008
consulta =  " select protic.trunc(a.caot_fecha_evaluado)        as fecha, "& vbCrLf & _
"       replace(caot_nnota_final, ',', '.')        as nota,               "& vbCrLf & _
"       e.sitf_tdesc                               as estado,             "& vbCrLf & _
"       d.mote_ccod                                as cod_modulo,         "& vbCrLf & _
"       mote_tdesc                                 as modulo,             "& vbCrLf & _
"       seot_nhoras_programa                       as horas,              "& vbCrLf & _
"       protic.horario_otec_con_sala(a.seot_ncorr) as horario,            "& vbCrLf & _
"       protic.trunc(caot_fecha_carga)             as fecha_carga,        "& vbCrLf & _
"       caot_nasistencia                           as asistencia          "& vbCrLf & _
"from   cargas_academicas_otec as a                                       "& vbCrLf & _
"       inner join secciones_otec as b                                    "& vbCrLf & _
"               on a.seot_ncorr = b.seot_ncorr                            "& vbCrLf & _
"       inner join mallas_otec as c                                       "& vbCrLf & _
"               on b.maot_ncorr = c.maot_ncorr                            "& vbCrLf & _
"       inner join modulos_otec as d                                      "& vbCrLf & _
"               on c.mote_ccod = d.mote_ccod                              "& vbCrLf & _
"       left outer join situaciones_finales as e                          "& vbCrLf & _
"                    on a.sitf_ccod = e.sitf_ccod                         "& vbCrLf & _
"where  cast(pote_ncorr as VARCHAR) = '"&pote_ncorr&"'                    "
'----------------------------------------------------------------------------------fin nueva consulta 2008
'response.write("<pre>"&consulta&"</pre>")
'response.end()



	f_carga_tomada.Consultar consulta
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
	formulario.action='calificaciones_alumno.asp';
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
	rut = t_busqueda.ObtenerValor(0, "pers_nrut") + '-' + t_busqueda.ObtenerValor(0, "pers_xdv")

	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido.');
		t_busqueda.filas[0].campos["pers_xdv"].objeto.select();
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
            <td><%pagina.DibujarLenguetas Array("Avance alumno en Programa"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
                <table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><div align="center"><%pagina.DibujarTituloPagina%> <br>
                    </div></td>
                    </tr>

                  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <%if q_pers_nrut <> "" and q_pers_xdv <> "" then %>

				  <tr>
				  	<td align="center">
						<form name="edicion">
						  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
						  <tr><input type="hidden" name="b[0][pers_nrut]" value="<%=q_pers_nrut%>">
						      <input type="hidden" name="b[0][pers_xdv]" value="<%=q_pers_xdv%>">
							  <input type="hidden" name="dgso_ncorr" value="<%=dgso_ncorr%>">
							<td>
							  <table width="100%" border="0">
							  <tr>
							      <td width="25%"><strong>Rut Alumno</strong></td>
								  <td align="left"><strong>: </strong><%=rut%></td>
							  </tr>
							  <tr>
							      <td width="25%"><strong>Nombre Alumno</strong></td>
								  <td align="left"><strong>: </strong><%=nombre%></td>
							  </tr>
							  <tr>
							      <td width="25%"><strong>Programa</strong></td>
								  <td align="left"><strong>: </strong><%=programa.dibujacampo("dcur_ncorr")%> </td>
							  </tr>
							  </table>
							  <br>
							  <%if dcur_ncorr <> "" then %>
							  <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
								<tr>

								<td>
								</td>
							  </tr>

							  <tr>
								<td align="right">&nbsp;</td>
							  </tr>
							  <tr>
								<td align="Left"><font size="2" color="#0033FF">Calificaciones del alumno en el Programa de Estudios</font></td>
							  </tr>
							  <tr>
								<td align="center"><%f_carga_tomada.dibujatabla()%></td>
							  </tr>
							  </table>
							  <%end if%>
							</td>
						  </tr>
						</table>
                          <br>
     					</form>
					</td>
				  </tr>
				  <%end if%>
				  <tr>
                    <td>&nbsp;</td>
                  </tr>
                </table>
              <br>
            </td></tr>
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

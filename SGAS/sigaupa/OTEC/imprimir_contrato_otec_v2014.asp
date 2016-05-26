<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Contrato Otec"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set errores = new CErrores

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "rendicion_cajas.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede



v_folio = request.QueryString("folio_ingreso")
v_ting_ccod = request.QueryString("ting_ccod")
'---------------------------------------------------------------------------------------------------

set f_contrato = new CFormulario
f_contrato.Carga_Parametros "consulta.xml", "consulta"
f_contrato.Inicializar conexion

		   
consulta	 =  "SELECT top 1 ingr_mtotal AS monto_total, 'DIURNA' AS jorn_tdesc, ', correo electr�nico: '+cast(c.pers_temail as varchar) AS emailp, ', estado civil: ' + cast(d.eciv_tdesc as varchar) AS eciv_tdescp, " & vbCrLf &_
				" ', nacionalidad: ' + cast(e.pais_tnacionalidad as varchar) AS pais_tdescp, ', profesi�n: ' + cast(c.pers_tprofesion as varchar)  AS pers_tprofesionp, ', correo electr�nico: '+cast(c.pers_temail as varchar) AS emailppc, '' AS eciv_tdescppc, " & vbCrLf &_
				" ', nacionalidad: ' + cast(e.pais_tnacionalidad as varchar) AS pais_tdescppc, ', profesi�n: ' + cast(c.pers_tprofesion as varchar) AS pers_tprofesionppc, 0 AS nro_informe, 'Contrato' AS NOMBRE_INFORME, " & vbCrLf &_
				" a.ingr_nfolio_referencia AS NRO_CONTRATO, datepart(dd,a.ingr_fpago) AS DD_HOY, datepart(mm,a.ingr_fpago) AS MM_HOY, datepart(year,a.ingr_fpago) AS YY_HOY, 'Universidad del Pac�fico' AS NOMBRE_INSTITUCION, " & vbCrLf &_
				" anio_admision AS PERIODO_ACADEMICO, '71704700-1' AS RUT_INSTITUCION, 'ITALO GIRAUDO TORRES' AS NOMBRE_REPRESENTANTE, " & vbCrLf &_
				" protic.obtener_rut(a.pers_ncorr) AS RUT_POSTULANTE, '' AS EDAD, protic.obtener_nombre_completo(c.pers_ncorr,'n') AS NOMBRE_ALUMNO, tdet_tdesc AS CARRERA, " & vbCrLf &_
				" protic.obtener_rut(a.pers_ncorr) AS RUT_CODEUDOR, protic.obtener_nombre_completo(c.pers_ncorr,'n') AS NOMBRE_CODEUDOR, ', profesi�n: ' + cast(c.pers_tprofesion as varchar) AS PROFESION, '' AS DIRECCION, " & vbCrLf &_
				" protic.obtener_direccion(c.pers_ncorr,1,'CNPB') AS DIRECCION_ALUMNO, '' AS CIUDAD, '' AS COMUNA, " & vbCrLf &_
				" protic.obtener_direccion(c.pers_ncorr,1,'CIU')  AS CIUDAD_ALUMNO," & vbCrLf &_
				" protic.obtener_direccion(c.pers_ncorr,1,'COM')  AS COMUNA_ALUMNO," & vbCrLf &_
				" isnull(f.ting_tdesc,'EFECTIVO') AS TIPO_DOCUMENTO, isnull(f.ting_tdesc,'EFECTIVO') AS DOCUMENTO, '' AS NOMBRE_BANCO, " & vbCrLf &_
				" b.ding_mdetalle AS VALOR_DOCTO, b.ding_ndocto AS NRO_DOCTO, b.ding_fdocto AS FECHA_VENCIMIENTO, '' AS TOTAL_M, " & vbCrLf &_
				" '' AS TOTAL_A, ofot_nmatricula AS matricula, ofot_narancel AS arancel, sede_tdesc AS sede, o.ciud_tdesc AS comuna_sede" & vbCrLf &_
				" from ingresos a " & vbCrLf &_
				" left outer join detalle_ingresos b " & vbCrLf &_
				" on a.ingr_ncorr=b.ingr_ncorr " & vbCrLf &_
				" join personas c" & vbCrLf &_
				" on a.pers_ncorr=c.pers_ncorr " & vbCrLf &_
				" left outer join estados_civiles d " & vbCrLf &_
				" on c.eciv_ccod=d.eciv_ccod " & vbCrLf &_
				" left outer join paises e " & vbCrLf &_
				" on c.pais_ccod = e.pais_ccod " & vbCrLf &_
				" left outer join tipos_ingresos f " & vbCrLf &_
				" on b.ting_ccod=f.ting_ccod " & vbCrLf &_
				" join abonos g " & vbCrLf &_
				" on a.ingr_ncorr=g.ingr_ncorr " & vbCrLf &_
				" join compromisos h " & vbCrLf &_
				" on g.comp_ndocto=h.comp_ndocto " & vbCrLf &_
				" and g.tcom_ccod=h.tcom_ccod " & vbCrLf &_
				" and g.inst_ccod=h.inst_ccod " & vbCrLf &_
				" join detalles i " & vbCrLf &_
				" on h.comp_ndocto=i.comp_ndocto " & vbCrLf &_
				" and h.tcom_ccod=i.tcom_ccod " & vbCrLf &_
				" and h.inst_ccod=i.inst_ccod " & vbCrLf &_
				" and i.deta_msubtotal>0 " & vbCrLf &_
				" join tipos_detalle j " & vbCrLf &_
				" on i.tdet_ccod=j.tdet_ccod " & vbCrLf &_
				" join postulacion_otec k " & vbCrLf &_
				" on k.pote_ncorr= (select max(pote_ncorr) from postulantes_cargos_otec where comp_ndocto=g.comp_ndocto) " & vbCrLf &_
				" join datos_generales_secciones_otec l " & vbCrLf &_
				" on k.dgso_ncorr=l.dgso_ncorr " & vbCrLf &_        
				" join ofertas_otec m " & vbCrLf &_
				" on l.dcur_ncorr=m.dcur_ncorr " & vbCrLf &_
				" and l.dgso_ncorr=m.dgso_ncorr " & vbCrLf &_
				" join sedes n " & vbCrLf &_
				" on m.sede_ccod=n.sede_ccod " & vbCrLf &_     
				" join ciudades o " & vbCrLf &_
				" on n.ciud_ccod=o.ciud_ccod  " & vbCrLf &_                           
				" where a.ingr_nfolio_referencia="&v_folio& " "& vbCrLf &_
				" and a.ting_ccod=33" 

f_contrato.Consultar consulta
f_contrato.siguiente
'response.Write("<pre>"&consulta&"</pre>")
'--------------------------------------------------------------------------------------------------
'monto_total	=f_contrato.obtenerValor("monto_total")
jornada		=f_contrato.obtenerValor("jorn_tdesc")
email		=f_contrato.obtenerValor("emailp")
estado_civil=f_contrato.obtenerValor("eciv_tdescp")
pais_alumno	=f_contrato.obtenerValor("pais_tdescp")
pers_tprofesionp=f_contrato.obtenerValor("pers_tprofesionp")
emailppc		=f_contrato.obtenerValor("emailppc")
eciv_tdescppc	=f_contrato.obtenerValor("eciv_tdescppc")
pais_tdescppc	=f_contrato.obtenerValor("pais_tdescppc")
pers_tprofesionppc	=f_contrato.obtenerValor("pers_tprofesionppc")
nro_informe			=f_contrato.obtenerValor("nro_informe")
NOMBRE_INFORME		=f_contrato.obtenerValor("NOMBRE_INFORME")
NRO_CONTRATO=f_contrato.obtenerValor("NRO_CONTRATO")
DD_HOY=f_contrato.obtenerValor("DD_HOY")
MM_HOY=f_contrato.obtenerValor("MM_HOY")
YY_HOY=f_contrato.obtenerValor("YY_HOY")
NOMBRE_INSTITUCION=f_contrato.obtenerValor("NOMBRE_INSTITUCION")
PERIODO_ACADEMICO=f_contrato.obtenerValor("PERIODO_ACADEMICO")
RUT_INSTITUCION=f_contrato.obtenerValor("RUT_INSTITUCION")
NOMBRE_REPRESENTANTE=f_contrato.obtenerValor("NOMBRE_REPRESENTANTE")
RUT_POSTULANTE=f_contrato.obtenerValor("RUT_POSTULANTE")
NOMBRE_ALUMNO=f_contrato.obtenerValor("NOMBRE_ALUMNO")
CARRERA=f_contrato.obtenerValor("CARRERA")
RUT_CODEUDOR=f_contrato.obtenerValor("RUT_CODEUDOR")
NOMBRE_CODEUDOR=f_contrato.obtenerValor("NOMBRE_CODEUDOR")
PROFESION=f_contrato.obtenerValor("PROFESION")
DIRECCION=f_contrato.obtenerValor("DIRECCION")
DIRECCION_ALUMNO=f_contrato.obtenerValor("DIRECCION_ALUMNO")
CIUDAD=f_contrato.obtenerValor("CIUDAD")
COMUNA=f_contrato.obtenerValor("COMUNA")
CIUDAD_ALUMNO=f_contrato.obtenerValor("CIUDAD_ALUMNO")
COMUNA_ALUMNO=f_contrato.obtenerValor("COMUNA_ALUMNO")
sede=f_contrato.obtenerValor("sede")
comuna_sede=f_contrato.obtenerValor("comuna_sede")



set f_detalle_contrato = new CFormulario
f_detalle_contrato.Carga_Parametros "consulta.xml", "consulta"
f_detalle_contrato.Inicializar conexion

		   
consulta_detalle	 =  "SELECT  " & vbCrLf &_
				" p.tcom_tdesc AS TIPO_DOCUMENTO, isnull(f.ting_tdesc,'EFECTIVO') AS DOCUMENTO,  " & vbCrLf &_
				" isnull(b.ding_mdetalle,a.ingr_mefectivo) AS VALOR_DOCTO, isnull(b.ding_ndocto,0) AS NRO_DOCTO, isnull(b.ding_fdocto, protic.trunc(getdate())) AS FECHA_VENCIMIENTO " & vbCrLf &_
				" from ingresos a " & vbCrLf &_
				" left outer join detalle_ingresos b " & vbCrLf &_
				" on a.ingr_ncorr=b.ingr_ncorr " & vbCrLf &_
				" join personas c" & vbCrLf &_
				" on a.pers_ncorr=c.pers_ncorr " & vbCrLf &_
				" left outer join tipos_ingresos f " & vbCrLf &_
				" on b.ting_ccod=f.ting_ccod " & vbCrLf &_
				" join abonos g " & vbCrLf &_
				" 	on a.ingr_ncorr=g.ingr_ncorr " & vbCrLf &_
				" join compromisos h " & vbCrLf &_
				" 	on g.comp_ndocto=h.comp_ndocto " & vbCrLf &_
				" 	and g.tcom_ccod=h.tcom_ccod " & vbCrLf &_
				" 	and g.inst_ccod=h.inst_ccod " & vbCrLf &_
				" join tipos_compromisos p " & vbCrLf &_
				" 	on h.tcom_ccod=p.tcom_ccod  " & vbCrLf &_                             
				" where a.ingr_nfolio_referencia="&v_folio& " "& vbCrLf &_
				" and a.ting_ccod=33" 
'response.Write("<pre>"&consulta_detalle&"</pre>")
f_detalle_contrato.Consultar consulta_detalle

monto_total=conexion.consultaUno("select sum(ingr_mtotal) from ingresos where ingr_nfolio_referencia="&v_folio& " ")

'response.Write(Day(una_fecha)& "-" &Month(una_fecha)& "-" & Year(una_fecha))
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_inicial.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">


<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script>
function imprimir()
{
  window.print();  
}
</script>
</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<style>
@media print{ .noprint {visibility:hidden; }}
.letra {font-size:12px;}
</style>
<table width="700" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" >
	<br><div align="center" class="noprint"><%f_botonera.DibujaBoton("imprimir")%></div>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" >
      <tr>
        <td>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              	<td valign="top">
					<table width="100%">
						<tr>
							<td width="15%"><img src="../imagenes/logo_upa_rojo_2011.png" /></td>
						  <td width="75%">&nbsp;</td>
							<td width="10%"></td>
						</tr>
					</table>				</td>
            </tr>
            <tr>
              <td align="center">
			  			<table width="80%"><tr><td align="center"><b><font color="#666677" size="4">CONTRATO DE SERVICIOS EDUCACIONALES PROGRAMAS DE EXTENSI�N</font></b></td></tr></table>
                   <br>
                  <br>              </td>
            </tr>
        </table></td>
      </tr>
      <tr>
        <td>
		<p align="justify" class="letra">En Santiago, a <%=dd_hoy%> de <%=MM_HOY%> de <%=YY_HOY%>  entre la <%=nombre_institucion%> RUT: <%=RUT_INSTITUCION%> organismo de educaci�n superior, representado por el Sr. <%=NOMBRE_REPRESENTANTE%>, ambos con domicilio para estos efectos en Santiago de Chile, Avenida Las Condes N�11.121, por una parte, y por la otra don(a): <%=NOMBRE_ALUMNO%> <%=pais_alumno%> <%=estado_civil%>, domicilio:<%=CIUDAD_ALUMNO%> /<%=COMUNA_ALUMNO%>  calle <%=DIRECCION_ALUMNO%>, Rut: <%=RUT_POSTULANTE%> <%=email%>, en adelante el alumno, se ha convenido el siguiente Contrato de Servicios Educacionales de programa de extensi�n.</p>

<p align="justify" class="letra" ><strong>PRIMERO</strong>: El alumno, contrata los servicios educacionales con la Universidad del Pac�fico, qui�n acepta e inscribe como alumno regular , comprometi�ndose a impartirle durante el a�o acad�mico <%=PERIODO_ACADEMICO%>, los estudios correspondientes al Programa de Extensi�n <%=CARRERA%> , en la Sede/Campus de <%=sede%> de la Universidad localizada en la Comuna de <%=comuna_sede%>, conforme a los actuales planes y programas de dicho programa, que el alumno declara  haber conocido por medio de informaci&oacute;n escrita en folletos, d&iacute;pticos,  tr&iacute;pticos y publicidad en general y/o a trav&eacute;s de la p&aacute;gina Web de la  Universidad, aquello con anterioridad a esta fecha. Como consecuencia de lo  se&ntilde;alado y al haber sido informado por parte de la Universidad, el alumno  reconoce y acepta los actuales planes y programas.   No obstante, la Universidad del Pac�fico se reserva la facultad de modificar el actual curr�culum del programa de extensi�n,  en el caso que sus autoridades  acad�micas lo estimaren conveniente. Lo anterior, con el fin de lograr una mejor excelencia en el programa de extensi�n impartido o as� lo exigiere la autoridad p�blica educacional.  Todo lo cual, de producirse, deber&aacute; ser aceptado  en forma escrita por el alumno.</p>


<p align="justify" class="letra"><strong>SEGUNDO</strong>: En virtud de la contrataci�n de los servicios educacionales se�alados en la cl�usula primera,  el alumno acepta el valor de de los servicios educacionales que asciende a <%=formatcurrency(monto_total,0)%>. El pago de los servicios educacionales se efectuar� en la forma que se indica en la cl�usula D�cimo Segundo.</p> 

<p align="justify" class="letra"><strong>TERCERO</strong>: Con el solo objeto de facilitar el pago de los valores indicados y sin que ello constituya novaci�n, el alumno ha girado cheques, ha suscrito pagar�s de pago a trav�s de cargo directo de las cuotas en: tarjetas de cr�dito bancarias de cuenta corriente, o ha aceptado letras de cambio o pagar&eacute; en cuotas, en favor de la Universidad del Pac�fico, los que se pagar�n en la forma, plazo y condiciones que se establecen en dichos instrumentos mercantiles y en la cl�usula D�cimo Segundo.</p>

<p align="justify" class="letra"><strong>CUARTO</strong>: Las partes convienen que el valor de los servicios educacionales es una obligaci�n indivisible durante el respectivo per�odo acad�mico a que se refiere la cl�usula primera, independiente de la forma de pago de estos valores, de tal modo que el pago de las referidas cantidades constituye una obligaci�n que permanece vigente para �el alumno� durante el per�odo de que se trata, aunque el alumno no hiciere uso del servicio educacional contratado, porque se retira de la Universidad del Pac�fico por su libre voluntad, es decir, hace abandono de los estudios. De esta manera, los plazos conferidos para el pago de los servicios educacionales constituyen s�lo una mera facilidad de pago otorgada en beneficio del alumno. Consecuente con ello, si el alumno hace abandono de los estudios por cualquier causa, no tendr� derecho alguno a exigir la devoluci�n de todo o parte de lo pagado en virtud de este contrato, debiendo adem�s continuar pagando �ntegramente y en su oportunidad el valor total de las cuotas pactadas que se encuentran documentadas.</p>

<p align="justify" class="letra"><strong>QUINTO</strong>: La Universidad del Pac�fico, tendr� derecho a sancionar al alumno en los casos contemplados en sus respectivos Reglamentos, que para todos los efectos legales forma parte integrante del presente contrato.</p>

<p align="justify" class="letra"><strong>SEXTO</strong>:   El primer d�a de clases el alumno recibir� los reglamentos y dem�s normas internas que regulan el funcionamiento de la Universidad del Pac�fico, los que aceptar� en todas sus partes. En todo caso el alumno reconoce la facultad de la Universidad para imponer normas docentes, acad�micas y de convivencia, las cuales se compromete a acatar. En caso que el alumno ocasionare da�os al patrimonio de la Universidad del Pac�fico, el �alumno� deber� pagar la reparaci�n o reposici�n de los da�os causados, sin perjuicio de las sanciones que establezca el reglamento correspondiente.</p>
<p align="justify" class="letra"><strong>SEPTIMO</strong>: La Universidad del Pac�fico, suspender� al alumno de toda actividad comprendida dentro de sus estudios, si �ste no se encuentra al d�a en el cumplimiento de sus obligaciones de pago a que se refiere este Contrato, sin perjuicio del derecho de la Universidad para exigir extrajudicialmente o judicialmente el pago de tales obligaciones. En consecuencia, la mora o simple retardo en el pago o cumplimiento de cualquiera de las obligaciones asumidas por medio de este instrumento, dar� derecho a la Universidad del Pac�fico, entre otras facultades, para suspender de clases al alumno, como tambi�n de evaluaciones, proceso de certificaci�n y titulaci�n, si correspondiese; entendiendo las partes que el no pago de las obligaciones asumidas en este contrato, constituye la contraprestaci�n que debe recibir la Universidad.</p>

<p align="justify" class="letra">Se deja establecido que el no pago oportuno de cualquiera de las obligaciones que contrae el alumno, dar� derecho a la Universidad del Pac�fico para cobrar el inter�s m�ximo convencional para operaciones de cr�dito de dinero en moneda nacional no reajustable, durante el lapso de tiempo que dure el incumplimiento.</p>

<p align="justify" class="letra">Cumplido el d�a de vencimiento, sin que �ste se pague por parte de su girador, suscriptor o aceptante seg�n corresponda, el documento ser� protestado inmediatamente, siendo de cargo del girador, suscriptor o aceptante seg�n sea el caso, todos los gastos que irrogue el protesto, como tambi�n, todos los gastos que se originen producto del cobro de estos documentos.</p>

<p align="justify" class="letra">La Universidad del Pac�fico encomendar� la cobranza de sus cr�ditos morosos o atrasados a empresa de cobranza externa, lo que ser� informado oportunamente.</p>

<p align="justify" class="letra">Los pagos atrasados o morosos que se efect�en en la etapa prejudicial, estar�n afectos a gastos y/u honorarios de cobranza extrajudicial, los que deber�n ser pagados por los deudores en su totalidad a partir del d�a d�cimo sexto contado desde la mora o simple atraso y por los porcentajes que se indican a continuaci�n:</p>




<p align="left" class="letra">MONTO DE DEUDA 					% SOBRE CAPITAL o CUOTA</p>
<li class="letra">Deuda hasta 10 UF. 						         		9%</li>
<li class="letra">Por la parte que exceda de 10 UF. y hasta 50 UF. 		6%</li>
<li class="letra">Por la parte que exceda de 50 UF. 						3%</li>

<p align="justify" class="letra">Los honorarios ser�n aplicados en forma progresiva sobre el capital e inter�s adeudado o la cuota vencida respectivamente.</p>

<p align="justify" class="letra"><strong>OCTAVO</strong>: Las partes dejan constancia que no ser� de responsabilidad de la Universidad del Pac�fico los perjuicios derivados de la p�rdida, da�os o sustracci�n de efectos personales, art�culos, bienes de cualquiera clase o naturaleza del contratante o del estudiante, que se introduzcan o se mantengan en la Universidad, por los cuales �stos reconocen su obligaci�n de mantener el debido resguardo sobre dichos elementos.</p>

<p align="justify" class="letra"><strong>NOVENO</strong>: La Universidad del Pac�fico, no estar� obligada a notificar en cada oportunidad las fechas de pago, y se reserva el derecho de efectuar la cobranza en forma directa o a trav�s de una entidad financiera o bancaria. Asimismo la Universidad podr� ceder el presente contrato o por lo tanto los derechos y obligaciones de pago que de este derivan, a un tercero, como asimismo los documentos mercantiles que hubiese suscrito el apoderado o el alumno, con el fin de facilitar la cobranza y pago de las obligaciones aqu� asumidas, cesiones que el alumno acepta desde ya.</p>

<p align="justify" class="letra"><strong>DECIMO</strong>: Las partes dejan constancia que la Universidad del Pac�fico no es responsable de los software que porten los alumnos, sean o no de propiedad de ellos, y por lo tanto no le cabe responsabilidad alguna respecto del uso que se haga de �stos, a�n cuando sean utilizados en las dependencias de la Universidad.</p>

<p align="justify" class="letra"><strong>DECIMO PRIMERO</strong>: Las partes fijan su domicilio en la ciudad de Santiago, para todos los efectos de este contrato.</p>

<p align="justify" class="letra"><strong>DECIMO SEGUNDO</strong>: El pago de los servicios educacionales se efect�a y documenta de la siguiente forma:</p>
<table width="90%" border="0" align="center" >
  <tr>
    <td width="12%" bgcolor="#FFFFCC" ><div align="center" class="letra"><strong>N�</strong></div></td>
    <td width="29%" bgcolor="#FFFFCC"><div align="center" class="letra"><strong>Compromiso</strong></div></td>
    <td width="23%" bgcolor="#FFFFCC"><div align="center" class="letra"><strong>Documento</strong></div></td>
    <td width="15%" bgcolor="#FFFFCC"><div align="center" class="letra"><strong>Valor</strong></div></td>
    <td width="21%" bgcolor="#FFFFCC"><div align="center" class="letra"><strong>Vencimiento</strong></div></td>
  </tr>
  <% fila = 1 
  monto_total=0
     while f_detalle_contrato.Siguiente %>
  <tr>
    <td><div align="left" class="letra"><%=fila%></div></td>
    <td><div align="left" class="letra"><%=f_detalle_contrato.ObtenerValor("TIPO_DOCUMENTO")%></div></td>
    <td><div align="left" class="letra"><%=f_detalle_contrato.ObtenerValor("DOCUMENTO")%></div></td>
    <td><div align="left" class="letra"><%=formatcurrency(f_detalle_contrato.ObtenerValor("VALOR_DOCTO"),0)%></div></td>
    <td><div align="left" class="letra"><%=f_detalle_contrato.ObtenerValor("FECHA_VENCIMIENTO")%></div></td>
  </tr>
  <% 
  monto_total=Clng(monto_total)+Clng(f_detalle_contrato.ObtenerValor("VALOR_DOCTO"))
  fila = fila + 1  
  wend %>
  <tr><td colspan="3" align="right" class="letra"><strong>Total:</strong></td><td class="letra"><%=formatcurrency(monto_total,0)%></td><td></td></tr>
</table>
<br>
<p class="letra">El presente contrato se firma en dos ejemplares, quedando uno en poder del alumno.</p>
<br>
<br>
<br>
<br>
<table width="100%" align="center" cellpadding="0" cellspacing="0">
<tr>
	<td align="center" valign="bottom"><img src="imagenes/firma_otec.jpg" width="204" height="128"/></td>
	<td></td>
	<td align="center"></td>
</tr>
<tr height="2">
	<td align="center" valign="top">_______________________<br>Firma Universidad</td>
	<td></td>
	<td align="center"  valign="top">_______________________<br>Firma Alumno/Apoderado</td>
</tr>
</table>
<br><br>
</td>
      </tr>
      <tr>
        <td align="center" class="noprint" ><%f_botonera.DibujaBoton("imprimir")%></td>
      </tr>
    </table>
	</td>
  </tr>  
</table>
</body>
</html>

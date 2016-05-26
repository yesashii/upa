<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
seot_ncorr= request.QueryString("seot_ncorr")
set pagina = new CPagina

pagina.Titulo = "Asignar Relator a horario"

set botonera =  new CFormulario
botonera.carga_parametros "pago_relatores.xml", "btn_agregar_relator"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores

dcur_tdesc = conexion.consultauno("SELECT dcur_tdesc FROM secciones_otec aa,datos_generales_secciones_otec a,diplomados_cursos b WHERE cast(seot_ncorr as varchar)= '" & seot_ncorr & "' and aa.dgso_ncorr = a.dgso_ncorr and a.dcur_ncorr=b.dcur_ncorr")
sede_tdesc = conexion.consultauno("SELECT sede_tdesc FROM secciones_otec aa,datos_generales_secciones_otec a,sedes b WHERE cast(seot_ncorr as varchar)= '" & seot_ncorr & "'  and aa.dgso_ncorr=a.dgso_ncorr and a.sede_ccod=b.sede_ccod")

lenguetas_masignaturas = Array(Array("Asignar Relator Horario", "#"))

'-----------------------------------------planificación de la sección----------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "pago_relatores.xml", "f_horario"
formulario.inicializar conexion

if seot_ncorr <> "" then
consulta = "  select distinct a.seot_ncorr,f.pers_ncorr,f.pers_ncorr as clave, c.mote_ccod as cod_modulo, mote_tdesc as modulo, pers_tnombre + ' ' + pers_tape_paterno as relator, " & vbCrlf & _
           " (select monto_asignado from pago_relatores_otec bb where bb.seot_ncorr=a.seot_ncorr and bb.pers_ncorr=f.pers_ncorr) as monto_asignado, " & vbCrlf &_        
		   " (select hora_asignada from pago_relatores_otec bb where bb.seot_ncorr=a.seot_ncorr and bb.pers_ncorr=f.pers_ncorr) as hora_asignada " & vbCrlf & _
 		   " from secciones_otec a, mallas_otec b, modulos_otec c,bloques_horarios_otec d, bloques_relatores_otec e, personas f " & vbCrlf & _
 		   " where a.maot_ncorr = b.maot_ncorr and b.mote_ccod=c.mote_ccod " & vbCrlf & _
		   " and a.seot_ncorr = d.seot_ncorr and d.bhot_ccod=e.bhot_ccod " & vbCrlf & _
		   " and e.pers_ncorr = f.pers_ncorr and cast(a.seot_ncorr as varchar)='"&seot_ncorr&"' " 
          

else
consulta = "select '' as seot_ncorr"
end if

'response.Write("<pre>"&consulta&"</pre>")

formulario.consultar consulta 

monto_maximo = conexion.consultaUno("select maot_npresupuesto_relator from secciones_otec a, mallas_otec b where cast(seot_ncorr as varchar)='"&seot_ncorr&"' and a.maot_ncorr=b.maot_ncorr")
horas_repartir= conexion.consultaUno("select MAOT_NHORAS_PROGRAMA from secciones_otec a,modulos_otec b,mallas_otec c where a.maot_ncorr=c.maot_ncorr and b.mote_ccod=c.mote_ccod and seot_ncorr="&seot_ncorr&"")
max_registro = formulario.nroFilas
'response.Write(max_registro)
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
function cerrar(){
	CerrarActualizar();
}
function revisar()
{   var i=0;
    var formulario = document.edicion2;
    var max_registro=<%=max_registro%>;
	var hora_max= <%=horas_repartir%>;
	var monto_maximo= <%=monto_maximo%>;
	var valor_total = 0;
	var valor_hora_total =0;
	var contador = 0;
	var i=0;
	var monto=0;
	var hora=0;
	for( i = 0; i < max_registro; i++ ) 
	{
		valor_asignado = formulario.elements["m["+i+"][monto_asignado]"].value;
		if (valor_asignado !="")
			valor_total = valor_total + (valor_asignado * 1);
		
	}
	for( i = 0; i < max_registro; i++ ) 
	{
		valor_hora = formulario.elements["m["+i+"][hora_asignada]"].value;
		if (valor_hora !="")
			valor_hora_total = valor_hora_total + (valor_hora * 1);
			
		
	}
	
	alerta=""
	
	if (valor_total <= monto_maximo)
	{
	   monto=1;
	}
	else
	{
	alerta="El monto asignado a los relatores, no corresponde a lo establecido en la planificación del programa ($ "+monto_maximo+")\r";
	}
	
	if (hora_max >= valor_hora_total)
	{
	   hora=1;
	}
	else
	{
	alerta=alerta+"El total de horas asigandas es mayor a "+hora_max+"";
	}
	
	//alert("monto "+monto+"");
	//alert("hora "+hora+"");

	if ((monto==1)&&(hora==1))
	{
	    //alert("Ok");
		return true;
	}
	else
	{
	 alert(alerta);
	    return false;
	 
	}
	
}

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="520" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA"><br>
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
              
			  <table width="100%"  border="0">
			  <tr>
				<td align="center">
				
						<table width="98%">
						
					    <form name="edicion2">
						<tr>
							<td><%response.Write("<strong>PROGRAMA: "&dcur_tdesc&"</strong>")%></td>
						  </tr>
						  <tr>
							<td><%response.Write("<strong>SEDE: "&sede_tdesc&"</strong>")%></td>
						  </tr>
						  <tr>
							<td><%response.Write("<strong>Monto a Repartir: "&monto_maximo&"</strong>")%></td>
						  </tr>
						   <tr>
							<td><%response.Write("<strong>Horas a Repartir: "&horas_repartir&"</strong>")%></td>
						  </tr>
						
						<tr>
							<td><div align="right"><strong>P&aacute;ginas :</strong>                          
							  <%formulario.accesopagina%>
							</div></td>
					    </tr>
					    <tr>
						   <td>&nbsp;</td>
					    </tr>
					    <tr>
						   <td><div align="center">
							  <%formulario.dibujatabla()%>
						      </div></td>
					       </tr>
						   		<td>&nbsp;</td>
					       </tr>
					    </form>
					</table>
				</td>
			  </tr>
			</table>
          </td></tr>
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
				  <td><div align="center"><%botonera.dibujaboton "guardar"%></div></td>	
				  <td><div align="center"><%botonera.dibujaboton "eliminar"%></div></td>
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

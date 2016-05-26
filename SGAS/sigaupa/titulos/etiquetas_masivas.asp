<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "impresión masiva de etiquetas"

set botonera =  new CFormulario
botonera.carga_parametros "etiquetas_masivas.xml", "btn_etiqueta"
'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set errores = new CErrores
'---------------------------------------------------------------------------------------------------
consulta =  " select distinct c.pers_tape_paterno + ' ' + c.pers_tape_materno  + ', ' +  c.pers_tnombre as nombre, protic.format_rut(c.pers_nrut) as rut,  " & vbCrLf &_
			" d.carr_tdesc as carrera,  " & vbCrLf &_
			" (select top 1 sede_tdesc   " & vbCrLf &_
			" from alumnos tt, ofertas_academicas t2, especialidades t3, sedes t4  " & vbCrLf &_
			" where tt.ofer_ncorr = t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  " & vbCrLf &_
			" and tt.pers_ncorr = a.pers_ncorr and t3.carr_ccod = d.carr_ccod   " & vbCrLf &_
			" and t2.sede_ccod = t4.sede_ccod  " & vbCrLf &_
			" order by peri_ccod, tt.alum_fmatricula desc) as sede  " & vbCrLf &_
			" from detalles_titulacion_carrera a, personas c, carreras d  " & vbCrLf &_
			" where isnull(imprimir_etiqueta,0) = 1  " & vbCrLf &_
			" and a.pers_ncorr=c.pers_ncorr  "& vbCrLf &_
			" and a.carr_ccod=d.carr_ccod " & vbCrLf &_
			" and exists (select 1 from planes_estudio tt where tt.plan_ccod=a.plan_ccod)  " & vbCrLf &_
			" union  " & vbCrLf &_
			" select distinct c.pers_tape_paterno + ' ' + c.pers_tape_materno + ', ' +  c.pers_tnombre as nombre, protic.format_rut(c.pers_nrut) as rut,  " & vbCrLf &_
			" d.saca_tdesc as carrera, e.sede_tdesc as sede   " & vbCrLf &_
			" from detalles_titulacion_carrera a, alumnos_salidas_carrera b, personas c, salidas_carrera d, sedes e  " & vbCrLf &_
			" where isnull(imprimir_etiqueta,0) = 1  " & vbCrLf &_
			" and a.pers_ncorr=b.pers_ncorr   " & vbCrLf &_
			" and a.pers_ncorr=c.pers_ncorr  "& vbCrLf &_
			" and b.saca_ncorr=d.saca_ncorr and b.sede_ccod=e.sede_ccod  " & vbCrLf &_
			" and not exists (select 1 from planes_estudio tt where tt.plan_ccod=a.plan_ccod) " & vbCrLf &_
			" order by carrera, nombre"

set formulario 		= 		new cFormulario
formulario.carga_parametros	"etiquetas_masivas.xml" , "tabla_etiquetas"
formulario.inicializar		conectar
formulario.consultar 		consulta
registros = formulario.nrofilas

filtro_sede_1 = " and  (select top 1 t4.sede_ccod   " & vbCrLf &_
				" 		from alumnos tt, ofertas_academicas t2, especialidades t3, sedes t4  " & vbCrLf &_
				" 		where tt.ofer_ncorr = t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  " & vbCrLf &_
				" 		and tt.pers_ncorr = a.pers_ncorr and t3.carr_ccod = d.carr_ccod   " & vbCrLf &_
				" 		and t2.sede_ccod = t4.sede_ccod  " & vbCrLf &_
				" 		order by peri_ccod, tt.alum_fmatricula desc) in (1,2,7,9)  " 
				
filtro_sede = " and e.sede_ccod in (1,2,7,9) " 'las condes
'---------------------------------------------------------------------------------------------------
consulta =  " select distinct c.pers_tape_paterno + ' ' + c.pers_tape_materno  + ', ' +  c.pers_tnombre as nombre, protic.format_rut(c.pers_nrut) as rut,  " & vbCrLf &_
			" d.carr_tdesc as carrera, " & vbCrLf &_
			" (select top 1 sede_tdesc   " & vbCrLf &_
			" from alumnos tt, ofertas_academicas t2, especialidades t3, sedes t4  " & vbCrLf &_
			" where tt.ofer_ncorr = t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  " & vbCrLf &_
			" and tt.pers_ncorr = a.pers_ncorr and t3.carr_ccod = d.carr_ccod   " & vbCrLf &_
			" and t2.sede_ccod = t4.sede_ccod  " & vbCrLf &_
			" order by peri_ccod, tt.alum_fmatricula desc) as sede  " & vbCrLf &_
			" from detalles_titulacion_carrera a, personas c, carreras d " & vbCrLf &_
			" where isnull(imprimir_etiqueta,0) = 1  " & vbCrLf &_
			" and a.pers_ncorr=c.pers_ncorr  "& vbCrLf &_
			" and a.carr_ccod=d.carr_ccod "& filtro_sede_1 & vbCrLf &_
			" and exists (select 1 from planes_estudio tt where tt.plan_ccod=a.plan_ccod)  " & vbCrLf &_
			" union  " & vbCrLf &_
			" select distinct c.pers_tape_paterno + ' ' + c.pers_tape_materno + ', ' +  c.pers_tnombre as nombre, protic.format_rut(c.pers_nrut) as rut,  " & vbCrLf &_
			" d.saca_tdesc as carrera, e.sede_tdesc as sede   " & vbCrLf &_
			" from detalles_titulacion_carrera a, alumnos_salidas_carrera b, personas c, salidas_carrera d, sedes e  " & vbCrLf &_
			" where isnull(imprimir_etiqueta,0) = 1  " & vbCrLf &_
			" and a.pers_ncorr=b.pers_ncorr   " & vbCrLf &_
			" and a.pers_ncorr=c.pers_ncorr  "& vbCrLf &_
			" and b.saca_ncorr=d.saca_ncorr and b.sede_ccod=e.sede_ccod "&filtro_sede & vbCrLf &_
			" and not exists (select 1 from planes_estudio tt where tt.plan_ccod=a.plan_ccod) " & vbCrLf &_
			" order by carrera, nombre"

set formulario2 		= 		new cFormulario
formulario2.carga_parametros	"tabla_vacia.xml" , "tabla"
formulario2.inicializar		conectar
formulario2.consultar 		consulta

filtro_sede_1 = " and  (select top 1 t4.sede_ccod   " & vbCrLf &_
				" 		from alumnos tt, ofertas_academicas t2, especialidades t3, sedes t4  " & vbCrLf &_
				" 		where tt.ofer_ncorr = t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  " & vbCrLf &_
				" 		and tt.pers_ncorr = a.pers_ncorr and t3.carr_ccod = d.carr_ccod   " & vbCrLf &_
				" 		and t2.sede_ccod = t4.sede_ccod  " & vbCrLf &_
				" 		order by peri_ccod, tt.alum_fmatricula desc) in (8)  " 
				
filtro_sede = " and e.sede_ccod in (8) " 'Baquedano
'---------------------------------------------------------------------------------------------------
consulta =  " select distinct c.pers_tape_paterno + ' ' + c.pers_tape_materno  + ', ' +  c.pers_tnombre as nombre, protic.format_rut(c.pers_nrut) as rut,  " & vbCrLf &_
			" d.carr_tdesc as carrera, " & vbCrLf &_
			" (select top 1 sede_tdesc   " & vbCrLf &_
			" from alumnos tt, ofertas_academicas t2, especialidades t3, sedes t4  " & vbCrLf &_
			" where tt.ofer_ncorr = t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  " & vbCrLf &_
			" and tt.pers_ncorr = a.pers_ncorr and t3.carr_ccod = d.carr_ccod   " & vbCrLf &_
			" and t2.sede_ccod = t4.sede_ccod  " & vbCrLf &_
			" order by peri_ccod, tt.alum_fmatricula desc) as sede  " & vbCrLf &_
			" from detalles_titulacion_carrera a, personas c, carreras d  " & vbCrLf &_
			" where isnull(imprimir_etiqueta,0) = 1  " & vbCrLf &_
			" and a.pers_ncorr=c.pers_ncorr  "& vbCrLf &_
			" and a.carr_ccod=d.carr_ccod "& filtro_sede_1& vbCrLf &_
			" and exists (select 1 from planes_estudio tt where tt.plan_ccod=a.plan_ccod)  " & vbCrLf &_
			" union  " & vbCrLf &_
			" select distinct c.pers_tape_paterno + ' ' + c.pers_tape_materno + ', ' +  c.pers_tnombre as nombre, protic.format_rut(c.pers_nrut) as rut,  " & vbCrLf &_
			" d.saca_tdesc as carrera, e.sede_tdesc as sede   " & vbCrLf &_
			" from detalles_titulacion_carrera a, alumnos_salidas_carrera b, personas c, salidas_carrera d, sedes e  " & vbCrLf &_
			" where isnull(imprimir_etiqueta,0) = 1  " & vbCrLf &_
			" and a.pers_ncorr=b.pers_ncorr   " & vbCrLf &_
			" and a.pers_ncorr=c.pers_ncorr  "& vbCrLf &_
			" and b.saca_ncorr=d.saca_ncorr and b.sede_ccod=e.sede_ccod "&filtro_sede & vbCrLf &_
			" and not exists (select 1 from planes_estudio tt where tt.plan_ccod=a.plan_ccod) " & vbCrLf &_
			" order by carrera, nombre"

set formulario3 		= 		new cFormulario
formulario3.carga_parametros	"tabla_vacia.xml" , "tabla"
formulario3.inicializar		conectar
formulario3.consultar 		consulta

filtro_sede_1 = " and  (select top 1 t4.sede_ccod   " & vbCrLf &_
				" 		from alumnos tt, ofertas_academicas t2, especialidades t3, sedes t4  " & vbCrLf &_
				" 		where tt.ofer_ncorr = t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  " & vbCrLf &_
				" 		and tt.pers_ncorr = a.pers_ncorr and t3.carr_ccod = d.carr_ccod   " & vbCrLf &_
				" 		and t2.sede_ccod = t4.sede_ccod  " & vbCrLf &_
				" 		order by peri_ccod, tt.alum_fmatricula desc) in (4)  " 

filtro_sede   = " and e.sede_ccod in (4) " 'Melipilla
'---------------------------------------------------------------------------------------------------
consulta =  " select distinct c.pers_tape_paterno + ' ' + c.pers_tape_materno  + ', ' +  c.pers_tnombre as nombre, protic.format_rut(c.pers_nrut) as rut,  " & vbCrLf &_
			" d.carr_tdesc as carrera, " & vbCrLf &_
			" (select top 1 sede_tdesc   " & vbCrLf &_
			" from alumnos tt, ofertas_academicas t2, especialidades t3, sedes t4  " & vbCrLf &_
			" where tt.ofer_ncorr = t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  " & vbCrLf &_
			" and tt.pers_ncorr = a.pers_ncorr and t3.carr_ccod = d.carr_ccod   " & vbCrLf &_
			" and t2.sede_ccod = t4.sede_ccod  " & vbCrLf &_
			" order by peri_ccod, tt.alum_fmatricula desc) as sede  " & vbCrLf &_
			" from detalles_titulacion_carrera a, personas c, carreras d " & vbCrLf &_
			" where isnull(imprimir_etiqueta,0) = 1  " & vbCrLf &_
			" and a.pers_ncorr=c.pers_ncorr  "& vbCrLf &_
			" and a.carr_ccod=d.carr_ccod "& filtro_sede_1 & vbCrLf &_
			" and exists (select 1 from planes_estudio tt where tt.plan_ccod=a.plan_ccod)  " & vbCrLf &_
			" union  " & vbCrLf &_
			" select distinct c.pers_tape_paterno + ' ' + c.pers_tape_materno + ', ' +  c.pers_tnombre as nombre, protic.format_rut(c.pers_nrut) as rut,  " & vbCrLf &_
			" d.saca_tdesc as carrera, e.sede_tdesc as sede   " & vbCrLf &_
			" from detalles_titulacion_carrera a, alumnos_salidas_carrera b, personas c, salidas_carrera d, sedes e  " & vbCrLf &_
			" where isnull(imprimir_etiqueta,0) = 1  " & vbCrLf &_
			" and a.pers_ncorr=b.pers_ncorr   " & vbCrLf &_
			" and a.pers_ncorr=c.pers_ncorr  "& vbCrLf &_
			" and b.saca_ncorr=d.saca_ncorr and b.sede_ccod=e.sede_ccod "&filtro_sede & vbCrLf &_
			" and not exists (select 1 from planes_estudio tt where tt.plan_ccod=a.plan_ccod) " & vbCrLf &_
			" order by carrera, nombre"

set formulario4 		= 		new cFormulario
formulario4.carga_parametros	"tabla_vacia.xml" , "tabla"
formulario4.inicializar		conectar
formulario4.consultar 		consulta
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
formulario.submit();
}
function agrega_ceremonia(formulario) {
	direccion = "agregar_ceremonia.asp";
	resultado=window.open(direccion, "ventana1","width=500,height=230,scrollbars=no, left=380, top=350");
	
 // window.close();
}

function lanzar_alumnos(id)
{
	direccion = "alumnos_ceremonia_excel.asp?id_ceremonia="+id;
	resultado=window.open(direccion, "ventana1","width=500,height=500,scrollbars=yes, left=380, top=350");
}

function imprimir_etiqueta()
{
	window.open("imprimir_etiqueta.asp?pers_ncorr=", "mywindow1", "status=1,width=750,height=550"); 
}

function enviar_email_masivo(sede)
{
	if (sede == 1)
	{
		if (confirm("Está seguro que desea enviar email a Biblioteca, Finanzas y Audiovisual,\n¿Para continuar presione Aceptar?") )
			{
				var formulario = document.edicion_email_las_condes;
				formulario.action = "http://www.upacifico.cl/super_test/motor_email_etiquetas.php?sede=1";
				formulario.target = "_black";
				formulario.submit();
			}
	}
	else if (sede == 8)
	{
		if (confirm("Está seguro que desea enviar email a Biblioteca, Finanzas y Audiovisual,\n¿Para continuar presione Aceptar?") )
			{
				var formulario = document.edicion_email_baquedano;
				formulario.action = "http://www.upacifico.cl/super_test/motor_email_etiquetas.php?sede=8";
				formulario.target = "_black";
				formulario.submit();
			}
	}	
	else if (sede == 4)
	{
		if (confirm("Está seguro que desea enviar email a Biblioteca, Finanzas y Audiovisual,\n¿Para continuar presione Aceptar?") )
			{
				var formulario = document.edicion_email_melipilla;
				formulario.action = "http://www.upacifico.cl/super_test/motor_email_etiquetas.php?sede=4";
				formulario.target = "_black";
				formulario.submit();
			}
	}	
}
</script>

</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
            <td><%pagina.DibujarLenguetas Array("Listado de alumnos para etiquetas"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br><br>
                    <table width="650" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                            <%formulario.AccesoPagina%>
                          </div></td>
                        <td width="24"> <div align="right"> </div></td>
                      </tr>
                    </table>
                  </div>
              <form name="edicion">
                <div align="center"><%formulario.dibujatabla()%><br>
                </div>
              </form></td></tr>
		  <tr>
		  	  <td>
			  	  <form name="edicion_email_las_condes" method="post">
				        <input type="hidden" name="dato_0_rut" value="Rut">
						<input type="hidden" name="dato_0_nombre" value="Nombre">
						<input type="hidden" name="dato_0_sede" value="Sede">
						<input type="hidden" name="dato_0_carrera" value="Carrera">
				  		<%fila = 1
						  while formulario2.siguiente
						     nombre_email  = formulario2.obtenerValor("nombre")
							 rut_email 	   = formulario2.obtenerValor("rut")
							 carrera_email = formulario2.obtenerValor("carrera")
							 sede_email    = formulario2.obtenerValor("sede")
						 %>
						     <input type="hidden" name="dato_<%=fila%>_rut" value="<%=rut_email%>">
							 <input type="hidden" name="dato_<%=fila%>_nombre" value="<%=nombre_email%>">
							 <input type="hidden" name="dato_<%=fila%>_sede" value="<%=sede_email%>">
							 <input type="hidden" name="dato_<%=fila%>_carrera" value="<%=carrera_email%>">
						 <%
						  	 fila = fila + 1
						  wend
						 %>
						 <input type="hidden" name="total_carrera" value="<%=formulario2.nroFilas%>">
				  </form>
			  </td>
		  </tr>
		  <tr>
		  	  <td>
			  	  <form name="edicion_email_baquedano" method="post">
				        <input type="hidden" name="dato_0_rut" value="Rut">
						<input type="hidden" name="dato_0_nombre" value="Nombre">
						<input type="hidden" name="dato_0_sede" value="Sede">
						<input type="hidden" name="dato_0_carrera" value="Carrera">
				  		<%fila = 1
						  while formulario3.siguiente
						     nombre_email  = formulario3.obtenerValor("nombre")
							 rut_email 	   = formulario3.obtenerValor("rut")
							 carrera_email = formulario3.obtenerValor("carrera")
							 sede_email    = formulario3.obtenerValor("sede")
						 %>
						     <input type="hidden" name="dato_<%=fila%>_rut" value="<%=nombre_email%>">
							 <input type="hidden" name="dato_<%=fila%>_nombre" value="<%=rut_email%>">
							 <input type="hidden" name="dato_<%=fila%>_sede" value="<%=sede_email%>">
							 <input type="hidden" name="dato_<%=fila%>_carrera" value="<%=carrera_email%>">
						 <%
						  	 fila = fila + 1
						  wend
						 %>
						 <input type="hidden" name="total_carrera" value="<%=formulario3.nroFilas%>">
				  </form>
			  </td>
		  </tr>
		  <tr>
		  	  <td>
			  	  <form name="edicion_email_melipilla" method="post">
				        <input type="hidden" name="dato_0_rut" value="Rut">
						<input type="hidden" name="dato_0_nombre" value="Nombre">
						<input type="hidden" name="dato_0_sede" value="Sede">
						<input type="hidden" name="dato_0_carrera" value="Carrera">
				  		<%fila = 1
						  while formulario3.siguiente
						     nombre_email  = formulario4.obtenerValor("nombre")
							 rut_email 	   = formulario4.obtenerValor("rut")
							 carrera_email = formulario4.obtenerValor("carrera")
							 sede_email    = formulario4.obtenerValor("sede")
						 %>
						     <input type="hidden" name="dato_<%=fila%>_rut" value="<%=nombre_email%>">
							 <input type="hidden" name="dato_<%=fila%>_nombre" value="<%=rut_email%>">
							 <input type="hidden" name="dato_<%=fila%>_sede" value="<%=sede_email%>">
							 <input type="hidden" name="dato_<%=fila%>_carrera" value="<%=carrera_email%>">
						 <%
						  	 fila = fila + 1
						  wend
						 %>
						 <input type="hidden" name="total_carrera" value="<%=formulario4.nroFilas%>">
				  </form>
			  </td>
		  </tr>
		  <tr>
		  	<td align="center">
				<table width="80%">
					<tr>
						<td><div align="center">
                         <% if formulario2.nroFilas = 0 then
						      botonera.agregaBotonParam "enviar_email_las_condes", "deshabilitado", "true"
						    end if
						    botonera.dibujaboton "enviar_email_las_condes"%>
                       </div>
					  </td>
					  <td><div align="center">
							 <% if formulario3.nroFilas = 0 then
								  botonera.agregaBotonParam "enviar_email_baquedano", "deshabilitado", "true"
								end if
							    botonera.dibujaboton "enviar_email_baquedano"%>
						   </div>
					  </td>
					  <td><div align="center">
							 <% if formulario4.nroFilas = 0 then
								  botonera.agregaBotonParam "enviar_email_melipilla", "deshabilitado", "true"
								end if
							    botonera.dibujaboton "enviar_email_melipilla"%>
						   </div>
					  </td>
					</tr>
				</table>
			</td>
		  </tr>
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
                  <td><div align="center">
                        <%  if formulario2.nroFilas = 0 and formulario3.nroFilas = 0 and formulario4.nroFilas = 0 then
						      botonera.agregaBotonParam "imprimir", "deshabilitado", "true"
						    end if
						   botonera.dibujaboton "imprimir"%>
                       </div>
                  </td>
				  <td><div align="center">
                         <%botonera.dibujaboton "SALIR"%>
                       </div>
                  </td>
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
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>

<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Listado de Alumnos por Año"
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------

periodo = negocio.obtenerPeriodoAcademico("POSTULACION")
'-------------------------------------------------------------------------------

set botonera = new CFormulario
botonera.Carga_Parametros "alumnos_x_anio.xml", "botonera"
'-------------------------------------------------------------------------------
 carr_ccod     =    request.QueryString("busqueda[0][carr_ccod]")
 anos_ccod     =	request.querystring("busqueda[0][anos_ccod]")
 tasa	       =	request.querystring("tasa_corte")
 tasa_informar =	request.querystring("tasa_informar")

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "alumnos_x_anio.xml", "busqueda"
 f_busqueda.Inicializar conexion
 
 consulta="Select '"&carr_ccod&"' as carr_ccod, '"&anos_ccod&"' as anos_ccod"
 f_busqueda.consultar consulta

 consulta = " select distinct anos_ccod,d.carr_ccod,d.carr_tdesc " & vbCrLf & _
			" from periodos_academicos a, ofertas_Academicas b, especialidades c, carreras d " & vbCrLf & _
			" where a.peri_ccod = b.peri_ccod " & vbCrLf & _
			" and b.espe_ccod=c.espe_ccod " & vbCrLf & _
			" and exists (select 1 from alumnos alu where alu.ofer_ncorr = b.ofer_ncorr) " & vbCrLf & _
			" and c.carr_ccod=d.carr_ccod order by anos_ccod, carr_tdesc" 


 f_busqueda.inicializaListaDependiente "lBusqueda", consulta

 f_busqueda.Siguiente
 
 'f_busqueda.AgregaCampoCons "nombre_asig", nombre
 'f_busqueda.AgregaCampoCons "codigo_asig", codigo

'----------------------------------------------------------------------------------
set f_asignaturas = new CFormulario
f_asignaturas.Carga_Parametros "alumnos_x_anio.xml", "f_alumnos"
f_asignaturas.Inicializar conexion

set f_cuentas = new CFormulario
f_cuentas.Carga_Parametros "tabla_vacia.xml", "tabla"
f_cuentas.Inicializar conexion

 consulta = " select distinct c.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbCrLf &_
			" c.pers_tape_paterno + ' ' + c.pers_tape_materno + ', '+ c.pers_tnombre as alumno, "& vbCrLf &_
			" (select max(anos_ccod) from alumnos alu, ofertas_Academicas ofe, especialidades esp, periodos_Academicos pea "& vbCrLf &_
			"  where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.espe_ccod=esp.espe_ccod and ofe.peri_ccod=pea.peri_ccod "& vbCrLf &_
			"  and esp.carr_ccod=e.carr_ccod) as ultimo_anio_estudio, "& vbCrLf &_
		    " (select top 1 emat_tdesc from alumnos alu1, ofertas_academicas ofe1, especialidades esp1, estados_matriculas ema1 "& vbCrLf &_
			"  where alu1.pers_ncorr= a.pers_ncorr and alu1.ofer_ncorr=ofe1.ofer_ncorr "& vbCrLf &_
			"   and ofe1.peri_ccod in (select max(peri_ccod) from alumnos alu, ofertas_Academicas ofe, especialidades esp "& vbCrLf &_
			"                          where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.espe_ccod=esp.espe_ccod "& vbCrLf &_
			"                          and esp.carr_ccod=e.carr_ccod) "& vbCrLf &_
			"   and ofe1.espe_ccod=esp1.espe_ccod and esp1.carr_ccod=e.carr_ccod "& vbCrLf &_
			"   and alu1.emat_ccod=ema1.emat_ccod order by alu1.audi_fmodificacion desc) as ultimo_estado_registrado, "& vbCrLf &_
			" (select count(distinct peri_ccod) from alumnos alu, ofertas_Academicas ofe, especialidades esp "& vbCrLf &_
			"  where alu.pers_ncorr = a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.espe_ccod=esp.espe_ccod "& vbCrLf &_
			"  and esp.carr_ccod = e.carr_ccod) as cantidad_semestres_registrado, "& vbCrLf &_
			" isnull((select top 1 cast(anos_ccod as varchar) + ' - ' + cast(plec_ccod as varchar) as ano "& vbCrLf &_
			"  from alumnos alu, ofertas_Academicas ofe, especialidades esp,periodos_Academicos pea "& vbCrLf &_
			"  where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.espe_ccod=esp.espe_ccod "& vbCrLf &_
			"  and esp.carr_ccod=e.carr_ccod and ofe.peri_ccod=pea.peri_ccod and alu.emat_ccod = 4 ), 'No Registra') as periodo_egreso,     "& vbCrLf &_
			"  isnull((select top 1 cast(anos_ccod as varchar) + ' - ' + cast(plec_ccod as varchar) as ano "& vbCrLf &_
			"  from alumnos alu, ofertas_Academicas ofe, especialidades esp,periodos_Academicos pea "& vbCrLf &_
			"  where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.espe_ccod=esp.espe_ccod "& vbCrLf &_
			"  and esp.carr_ccod=e.carr_ccod and ofe.peri_ccod=pea.peri_ccod and alu.emat_ccod = 8 ), 'No Registra') as periodo_titulacion, "& vbCrLf &_
			"  (select case count(*) when 0 then 'No' else 'Sí' end  "& vbCrLf &_
			"  from alumnos alu, ofertas_Academicas ofe, especialidades esp,periodos_Academicos pea "& vbCrLf &_
			"  where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.espe_ccod=esp.espe_ccod "& vbCrLf &_
			"  and esp.carr_ccod=e.carr_ccod and ofe.peri_ccod=pea.peri_ccod and pea.anos_ccod='2007') as matricula_2005 "& vbCrLf &_
			" from alumnos a, ofertas_academicas b, personas c, periodos_academicos d,especialidades e "& vbCrLf &_
			" where a.ofer_ncorr=b.ofer_ncorr and a.pers_ncorr=c.pers_ncorr "& vbCrLf &_
			" and b.peri_ccod = d.peri_ccod and b.espe_ccod = e.espe_ccod and a.emat_ccod <> 9"& vbCrLf &_
			" --and exists(select 1 from cargas_Academicas carg where carg.matr_ncorr=a.matr_ncorr) "& vbCrLf &_
			" and cast(d.anos_ccod as varchar)='"&anos_ccod&"' and e.carr_ccod='"&carr_ccod&"'"& vbCrLf &_
			" and not exists (select 1 from alumnos alu, ofertas_academicas ofe, periodos_academicos pea,especialidades esp "& vbCrLf &_
			" where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.peri_ccod=pea.peri_ccod "& vbCrLf &_
            " and pea.anos_ccod < d.anos_ccod  and ofe.espe_ccod=esp.espe_ccod and esp.carr_ccod=e.carr_ccod)"& vbCrLf		   
      'response.Write("<pre>"&consulta&"</pre>")
      f_asignaturas.consultar consulta
	  f_cuentas.consultar consulta
	  
	  
total = 0
total_titulados = 0
total_egresados = 0
total_activos = 0
total_actuales = 0
while f_cuentas.siguiente
		total = total + 1
		if f_cuentas.obtenerValor("periodo_egreso") <> "No Registra" then
			total_egresados = total_egresados + 1
		end if
		if f_cuentas.obtenerValor("periodo_titulacion") <> "No Registra" then
			total_titulados= total_titulados + 1
		end if
		if f_cuentas.obtenerValor("ultimo_estado_registrado") = "ACTIVA" then
			total_activos= total_activos + 1
		end if
		if f_cuentas.obtenerValor("matricula_2005") = "Sí" then
			total_actuales= total_actuales + 1
		end if
wend
f_cuentas.primero

carr_tdesc = conexion.consultaUno("Select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")

if carr_ccod <> "" and tasa <> "" then
	total_cumplen = conexion.consultaUno("select protic.obtener_indice_selectividad_carrera('"&carr_ccod&"',"&anos_ccod&","&tasa&")")
	total_informar = conexion.consultaUno("select protic.obtener_indice_selectividad_carrera('"&carr_ccod&"',"&anos_ccod&","&tasa_informar&")")
	if total > 0 then
		calculo = (cdbl(total_cumplen) / cdbl(total)) * 100.00
	else
		calculo = 0
	end if
	total_calculado = formatnumber(calculo,2,-1,0,0)
	
	if cint(total_informar) > 0 then
		calculo2 = (cdbl(total_cumplen) / cdbl(total_informar)) * 100.00
	else
		calculo2 = 0
	end if
	total_calculado2 = formatnumber(calculo2,2,-1,0,0)		
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
function enviar(formulario){
            document.getElementById("texto_alerta").style.visibility="visible";
			formulario.action ="alumnos_x_anio.asp";
			formulario.submit();
}
</script>
<% f_busqueda.generaJS %>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0">
                      <tr>
                        <td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="20%"> <div align="left">Año Ingreso</div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td width="79%"><% f_busqueda.dibujaCampoLista "lBusqueda", "anos_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="20%"> <div align="left">Carrera</div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% f_busqueda.dibujaCampoLista "lBusqueda", "carr_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="20%"> <div align="left">Tasa de Corte</div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><input type="text" name="tasa_corte" size="10" maxlength="5" value="<%=tasa%>" id="NU-N"> Ej:520.4</td>
                              </tr>
							  <tr> 
                                <td width="20%"> <div align="left">Tasa a Informar</div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><input type="text" name="tasa_informar" size="10" maxlength="3" value="<%=tasa_informar%>" id="NU-N"> Ej:475</td>
                              </tr> 
							  <tr> 
                                <td colspan="3" align="right"><%botonera.dibujaboton "buscar"%></td>
							  </tr>
							  <tr> 
                                <td width="20%"> <div align="left"></div></td>
								<td width="1%"> <div align="center"></div> </td>
								<td><div  align="center" id="texto_alerta" style="position:absolute; visibility: hidden;"><font color="#0000FF" size="-1">Espere 
                                  un momento mientras se realiza la busqueda...</font></div></td>
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
              <br><br>
			 <table width="98%"  border="1">
			 <tr><td>
			  <table width="98%">
			  	<%if total > 0 then%>
				<tr>
					<td colspan="6"><strong>Totalizador</strong></td>
				</tr>
				<tr>
					<td width="16%" align="left"><strong>Total General</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td align="left" colspan="4"><%=total%></td>
				</tr>
				<tr>
					<td width="16%" align="left"><strong>Total Egresados</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td align="left" width="29%"><%=total_egresados%></td>
					<td width="23%" align="left"><strong>Total Titulados</strong></td>
					<td width="1%" align="center"><strong>:</strong></td>
					<td width="29%" align="left"><%=total_titulados%></td>
				</tr>
				<tr>
					<td width="16%" align="left"><strong>Total Activos</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td align="left" width="29%"><%=total_activos%></td>
					<td width="23%" align="left"><strong>Total Matricula Actual</strong></td>
					<td width="1%" align="center"><strong>:</strong></td>
					<td width="29%" align="left"><%=total_actuales%></td>
				</tr>
				<tr>
					<td width="16%" align="left"><strong>Tasa de Corte</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td align="left" width="29%"><%=tasa%></td>
					<td width="23%" align="left"><strong>Total >= <%=tasa%> </strong></td>
					<td width="1%" align="center"><strong>:</strong></td>
					<td width="29%" align="left"><%=total_cumplen%></td>
				</tr>
				<tr>
					<td width="16%" align="left"><strong>Tasa a Informar</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td align="left" colspan="4"><%=tasa_informar%></td>
				</tr>
				<tr>
					<td colspan="6" align="left"><font color="#0000FF"><strong>Índice de Selectividad real: (<%=total_cumplen%> / <%=total%>) * 100 =</strong> <%=total_calculado%> %</font></td>
				</tr>
				<tr>
					<td colspan="6" align="left"><font color="#0000FF"><strong>Índice de Selectividad informado: (<%=total_cumplen%> / <%=total_informar%>) * 100 =</strong> <%=total_calculado2%> %</font></td>
				</tr>
				<%end if%>
				<tr>
					<td align="left" colspan="6"><hr></td>
				</tr>
				<tr>
					<td width="16%" align="left"><strong>Año Ingreso</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td align="left" colspan="4"><%=anos_ccod%></td>
				</tr>
				<tr>
					<td width="16%" align="left"><strong>Carrera</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td align="left" colspan="4"><%=carr_tdesc%></td>
				</tr>
    		  </table></td></tr>
			  </table>
			 
			  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                       <td><div align="right">P&aacute;ginas: &nbsp; 
                            <%f_asignaturas.AccesoPagina%>
                          </div>
						</td>
                  </tr>
				  <tr>
                      <td>
					  <%f_asignaturas.dibujaTabla()%>
					  </td>
                  </tr>
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
            <td width="18%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><div align="center"><%botonera.dibujaBoton "lanzadera"%></div></td>
						<td width="49%"> <div align="center">  <% if total = 0 then
				                                                botonera.agregabotonparam "excel","deshabilitado","TRUE"    
															end if																             
					                       botonera.agregabotonparam "excel", "url", "alumnos_x_anio_excel.asp?anos_ccod="&anos_ccod&"&carr_ccod="&carr_ccod
										   botonera.dibujaboton "excel"
										%>
					             </div>
                        </td>
						<td> <div align="center"><% if total = 0 then
				                                                botonera.agregabotonparam "excel2","deshabilitado","TRUE"    
												    end if																             
					                       botonera.agregabotonparam "excel2", "url", "selectividad_excel.asp?anos_ccod="&anos_ccod&"&tasa="&tasa&"&tasa_informar="&tasa_informar
										   botonera.dibujaboton "excel2"
										%>
					             </div>
                        </td>
                      </tr>
                    </table>
            </div></td>
            <td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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

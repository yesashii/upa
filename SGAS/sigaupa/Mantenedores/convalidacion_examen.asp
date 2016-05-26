<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
carr_ccod =Request.QueryString("a[0][carrera]")
cantidad_convalidada=Request.QueryString("cantidad")
if cantidad_convalidada > 11 then
	cantidad_convalidada_01 = 11
else
	cantidad_convalidada_01=cantidad_convalidada
end if
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Convalidación/Examen Conocimientos Relevantes"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "convalidacion_examen.xml", "botonera"


'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "convalidacion_examen.xml", "busqueda"
f_busqueda.Inicializar conexion

f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv


'---------------------------------------------------------------------------------------------------

v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_pers_ncorr = conexion.consultauno("select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)  = '"&q_pers_nrut&"'")
ultimo_periodo = conexion.consultaUno(" select top 1 max(b.peri_ccod)as periodo from postulantes a, periodos_academicos b where cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"' and a.peri_ccod=b.peri_ccod order by periodo desc")
v_post_ncorr = conexion.consultaUno("select top 1 a.post_ncorr from postulantes a, detalle_postulantes b where a.post_ncorr=b.post_ncorr and cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"' and cast(a.peri_ccod as varchar)='"&ultimo_periodo&"' order by convert(datetime,a.audi_fmodificacion,103) asc")

'response.Write("select top 1 post_ncorr from postulantes where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' and cast(peri_ccod as varchar)='"&ultimo_periodo&"' order by audi_fmodificacion desc")

'response.Write(v_post_ncorr)
periodo=negocio.obtenerPeriodoAcademico("Postulacion")
sede=negocio.obtenerSede		

'--------------------------------------------------------------------------------------------------
set fc_datos = new CFormulario
fc_datos.Carga_Parametros "convalidacion_examen.xml", "pase_escolar"
fc_datos.Inicializar conexion

if q_pers_nrut <> "" and q_pers_xdv <> "" then
	filtro = " and  cast(b.post_ncorr as varchar)='" & v_post_ncorr & "'"  
else
	filtro = " and 1=2"
end if

'-----------------------------version postulantes			
consulta="select a.pers_ncorr, pers_tape_paterno + ' ' +  pers_tape_materno + ' ' + pers_tnombre as alumno," & vbCrLf &_
		 " espe_tdesc, cast(pers_nrut as varchar)  + '-' + pers_xdv as rut,c.post_ncorr" & vbCrLf &_
		 " from personas_postulante a,postulantes c,ofertas_academicas d,especialidades e,carreras f" & vbCrLf &_
		 " where  a.pers_ncorr = c.pers_ncorr" & vbCrLf &_
		 " and c.ofer_ncorr = d.ofer_ncorr" & vbCrLf &_
		 " and d.espe_ccod = e.espe_ccod" & vbCrLf &_
		 " and e.carr_ccod = f.carr_ccod" & vbCrLf &_
		 " and cast(c.peri_ccod as varchar)= '"&periodo&"' " & vbCrLf &_
    	 " and cast(d.sede_ccod as varchar) = isnull('"&sede&"',cast(d.sede_ccod as varchar))" & vbCrLf &_
         "" & filtro &""
		 
'----------------------------versión final para todo postuante-----------------------------------------
consulta=" select a.pers_ncorr,a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as alumno, " & vbcrlf & _
		" protic.Format_rut(a.pers_nrut) as rut ,b.post_ncorr,f.carr_ccod,d.jorn_ccod " & vbcrlf & _
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
		" and isnull(c.eepo_ccod,5) = i.eepo_ccod " & vbcrlf & _
		" and b.epos_ccod = 2 " & vbcrlf & _
		" and b.tpos_ccod in (1,2) " & vbcrlf & _
		"" & filtro & ""

'--------------------------------------------------------------------------------------------------------
'response.Write("<pre>"&consulta&"</pre>")
		 			
fc_datos.Consultar consulta
inicial= fc_datos.nroFilas
if filtro<>"" then
	while fc_datos.Siguiente
          if carreras_escritas="" then
		     carreras_escritas=carreras_escritas & fc_datos.obtenerValor("carr_ccod")
		  else
		     carreras_escritas=carreras_escritas &","&fc_datos.obtenerValor("carr_ccod")	 		
		  end if
    wend
end if	
'response.Write(carreras_escritas)
fc_datos.primero
fc_datos.siguiente
fc_datos.AgregaCampoCons "carrera",carr_ccod
fc_datos.AgregaCampoParam "carrera","filtro"," carr_ccod in ("&carreras_escritas&")"
'
'----------------------------Revisamos si la persona ya tiene un cargo de convalidación para la carrera_seleciconada en ese periodo 
if carr_ccod <> "" then
	consulta_anteriores="Select count(*) from cargos_convalidacion a, ofertas_academicas b, especialidades c" & vbcrlf & _
    	                " where cast(a.post_ncorr as varchar)='"&v_post_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr"& vbcrlf & _
						" and b.espe_ccod=c.espe_ccod and cast(c.carr_ccod as varchar)='"&carr_ccod&"' and cast(b.peri_ccod as varchar)='"&periodo&"'"
	
	'response.Write("<pre>"&consulta_anteriores&"</pre>")
						
	cantidad_convalidados=conexion.consultaUno(consulta_anteriores)
	'if cantidad_convalidados >"0" then
		'response.Write("carrera ya convalidada "&cantidad_convalidados)
	'else
	'	response.Write("carrera sin convalidar "&cantidad_convalidados)
	'end if
end if

'----------------------------calculo de valor a pagar-----------------------------------------
if carr_ccod <>"" and cantidad_convalidada<>"" and cantidad_convalidados="0" then
consulta3=" select d.jorn_ccod" & vbcrlf & _
		" from  " & vbcrlf & _
		" personas_postulante a,postulantes b,detalle_postulantes c, " & vbcrlf & _
		" ofertas_academicas d,especialidades e,carreras f,jornadas g, " & vbcrlf & _
		" sedes h,estado_examen_postulantes i " & vbcrlf & _
		" where a.pers_ncorr = b.pers_ncorr " & vbcrlf & _
		" and b.post_ncorr = c.post_ncorr " & vbcrlf & _
		" and c.ofer_ncorr = d.ofer_ncorr " & vbcrlf & _
		" and d.espe_ccod = e.espe_ccod " & vbcrlf & _
		" and cast(e.carr_ccod as varchar)='"&carr_ccod&"'"& vbcrlf & _
		" and e.carr_ccod = f.carr_ccod   " & vbcrlf & _
		" and d.jorn_ccod = g.jorn_ccod " & vbcrlf & _
		" and d.sede_ccod = h.sede_ccod " & vbcrlf & _
		" and c.eepo_ccod = i.eepo_ccod " & vbcrlf & _
		" and b.epos_ccod = 2 " & vbcrlf & _
		" and b.tpos_ccod = 1 " & vbcrlf & _
		"" & filtro & ""
jorn_ccod=conexion.consultaUno(consulta3)
	if jorn_ccod="1" then
      monto = conexion.consultaUno("Select tdet_mvalor_unitario from tipos_detalle where tdet_ccod='1259'")
	else
	  monto = conexion.consultaUno("Select tdet_mvalor_unitario from tipos_detalle where tdet_ccod='1260'")  
	end if
monto = "0"' No se cobra en 2013-01 según pase interno 258 - 09-10-2012 MS	
total_pagar= clng(monto) * clng(cantidad_convalidada_01)
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
function ValidaFormBusqueda()
{
	var formulario = document.buscador;
	var	rut = formulario.elements["busqueda[0][pers_nrut]"].value + '-' + formulario.elements["busqueda[0][pers_xdv]"].value;
	
	if (!valida_rut(rut)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	}
	
	return true;
	
}
function InicioPagina(formulario)
{

}
function enviar()
{
formulario=document.edicion;
carrera=formulario.elements("a[0][carrera]").value;
cantidad=formulario.elements("cantidad").value;
carrera_calculo=formulario.elements("carrera2").value;
cantidad_calculo=formulario.elements("cantidad2").value;
//alert("carrera==> "+carrera+"="+carrera_calculo);
//alert("cantidad==> "+cantidad+"="+cantidad_calculo);

	if ((carrera==carrera_calculo)&&(cantidad==cantidad_calculo)){
		formulario.action="proc_convalidacion_examen.asp"
		formulario.submit();
	}
	else
	{
		alert("Debe volver a realizar el cálculo ya que el total no concuerda con los últimos datos entregados");
	}
}

function mensaje(numero)
{   if (numero==1)
	   {alert("El usuario al que pertenece el RUT no existe en el Sistema");}
	else
	   {alert("Ya se realizó una convalidación para este alumno en esta carrera");}
    var formulario = document.buscador;
	formulario.elements("busqueda[0][pers_nrut]").focus();
}

function calcular()
{ var formulario; 
  var cantid;
  formulario=document.edicion;
  cantid=formulario.cantidad.value;
  if (isNumber(cantid))
  	{formulario.method="GET";
     formulario.action="convalidacion_examen.asp"
     formulario.submit();}
  else
  	{alert("Debe ingresar un número");
	 formulario.cantidad.focus();
	}
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../matricula/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../matricula/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../matricula/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../matricula/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="50%" border="0" align="center" cellpadding="0" cellspacing="0">
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
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td><div align="right">R.U.T. Alumno </div></td>
                        <td width="7%"><div align="center">:</div></td>
                        <td><%f_busqueda.DibujaCampo("pers_nrut")%> 
                        - 
                          <%f_busqueda.DibujaCampo("pers_xdv")%><%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td>
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
	<br><% if q_pers_nrut <>"" and inicial > 0 then %>
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
				<br><%pagina.DibujarSubtitulo "Informacion Alumno"%>				<br>
				<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
				 <form name="edicion" method="post">
				 <input type="hidden" name="busqueda[0][pers_nrut]" value="<%=q_pers_nrut%>">
				 <input type="hidden" name="busqueda[0][pers_xdv]" value="<%=q_pers_xdv%>">
                 <input type="hidden" name="total_cargo" value="<%=total_pagar%>">
				 <input type="hidden" name="post_ncorr" value="<%=fc_datos.obtenerValor("post_ncorr")%>">
				 <input type="hidden" name="jorn_ccod" value="<%=jorn_ccod%>">
				 <input type="hidden" name="carrera2" value="<%=carr_ccod%>">
				 <input type="hidden" name="cantidad2" value="<%=cantidad_convalidada%>">
				
				    <tr> 
                      <td width="188" height="25"><strong>Rut Alumno</strong></td>
                      <td width="10"><strong>:</strong></td>
                      <td colspan="2"><%=fc_datos.DibujaCampo("rut")%></td>
                    </tr>
                    <tr> 
                      <td width="188" height="25"><strong>Nombre</strong></td>
                      <td width="10"><strong>:</strong></td>
                      <td colspan="2"><%=fc_datos.DibujaCampo("alumno")%></td>
                    </tr>
                    <tr> 
                      <td width="188" height="25"><strong>Carreras Postuladas</strong></td>
                      <td width="10"><strong>:</strong></td>
                      <td colspan="2"><%=fc_datos.DibujaCampo("carrera")%></td>
                    </tr>
				    <tr>
                      <td width="188"><strong>Cantidad de convalidaciones solicitadas</strong></td>
                      <td width="10">:</td>
                      <td width="47"><input type="text" value="<%=cantidad_convalidada%>" maxlength="2" size="3" name="cantidad"></td>
					<td >&nbsp;<%f_botonera.DibujaBoton("calcular")%></td>
                    </tr>
					<%if total_pagar <>"" then%>
					<tr> 
                      <td width="188" height="25"><strong>Pago por Convalidaci&oacute;n</strong></td>
                      <td width="10"><strong>:</strong></td>
                      <td colspan="2">$<%=total_pagar%></td>
                    </tr>
					<%end if%>
					</form>
                  </table>
             
                
                          <br>
            </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="28%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
				  <% if total_pagar="" then
				         f_botonera.agregabotonparam "guardar", "deshabilitado" ,"TRUE"
				    end if
					
				  f_botonera.DibujaBoton("guardar")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir")%>
                  </div></td>
                  </tr>
              </table>
            </div></td>
            <td width="72%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table><%end if%>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
<% if q_pers_nrut <>"" and inicial = 0 and cantidad_convalidados="0" then 
	response.Write("<script language='JavaScript'>")
	response.Write("mensaje(1);")
	response.Write("</script>")
   elseif q_pers_nrut<>"" and inicial>0 and cantidad_convalidados>"0" then
    response.Write("<script language='JavaScript'>")
	response.Write("mensaje(2);")
	response.Write("</script>")
end if%>

<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

pagina.Titulo = "Mantenedor de Inasistencias"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set errores = new CErrores

set negocio = new CNegocio
negocio.Inicializa conexion
periodo = negocio.obtenerPeriodoAcademico("Planificacion")
peri = negocio.obtenerPeriodoAcademico("CLASES18")

ano_seleccionado = conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
ano_actual = conexion.consultaUno("Select datepart(year,getDate())")
peri = conexion.consultaUno("Select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&ano_seleccionado&"' and plec_ccod=1 ")

if cint(ano_seleccionado)=cint(ano_actual) then
	correcto="S"
else
	correcto="N"
end if

'---------------------------------------------------------------------------------------------------
rut = request.querystring("busqueda[0][pers_nrut]")
digito = request.querystring("busqueda[0][pers_xdv]")
carr_ccod   =   request.QueryString("a[0][carr_ccod]")
asig_ccod	=	request.querystring("a[0][asig_ccod]")
inicio = request.querystring("inicio")
termino = request.querystring("termino")
'--------------------------------------------------------------------------
anos_ccod = conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")


 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "m_recuperativas.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' "
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut
 f_busqueda.AgregaCampoCons "pers_xdv", digito
 'response.End()
'--------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "m_recuperativas.xml", "botonera"
'--------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "m_recuperativas.xml", "listado_asignaturas"
formulario.Inicializar conexion 

if (not esVacio(rut) and not esVacio(digito)) then
	pers_ncorr=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&rut&"'")
	'periodo=negocio.obtenerPeriodoAcademico("CLASES18")
	'-------------------------------------------Seleccionar asignatura para equivalencia de una lista sin escribir su código-----
    '-----------------------------------------------------------msandoval 19-02-2005---------------------------------------------
	set f_filtros = new cFormulario
	f_filtros.carga_parametros "m_recuperativas.xml", "buscador"
	f_filtros.inicializar conexion
	consulta="Select '"&carr_ccod&"' as carr_ccod, '"&asig_ccod&"' as asig_ccod"
	f_filtros.consultar consulta
	consulta = " select distinct d.carr_ccod,d.carr_tdesc,e.asig_ccod,e.asig_tdesc " & vbCrLf & _
			   " from secciones a, bloques_horarios b, bloques_profesores c,carreras d,asignaturas e " & vbCrLf & _
			   " where a.secc_ccod=b.secc_ccod " & vbCrLf & _
			   " and b.bloq_ccod=c.bloq_ccod " & vbCrLf & _
			   " and a.carr_ccod=d.carr_ccod " & vbCrLf & _
			   " and a.asig_ccod=e.asig_ccod " & vbCrLf & _
			   " and cast(a.peri_ccod as varchar)= case e.duas_ccod when 3 then '"&peri&"' else '"&periodo&"' end	 " & vbCrLf & _
			   " and cast(c.pers_ncorr as varchar)='"&pers_ncorr&"' " & vbCrLf & _
			   " order by carr_tdesc" 	
	
	f_filtros.inicializaListaDependiente "filtros", consulta
	f_filtros.siguiente
	'-----------------------------------------------------------------------------------------------------------------
end if 
filtro=""
if not esvacio(carr_ccod) then 
	filtro = filtro & " and cast(a.carr_ccod as varchar)='"&carr_ccod&"'"
end if
if not esvacio(asig_ccod) then 
	filtro = filtro & " and cast(a.asig_ccod as varchar)='"&asig_ccod&"'"
end if

filtro_2 = ""
if not esVacio(inicio) and not esVacio(termino) then
	filtro_2 = "and convert(varchar,f.cale_fcalendario,103) >= " & vbcrlf & _
	           " (case when convert(datetime,'"&inicio&"',103) >= convert(varchar,b.bloq_finicio_modulo,103) then convert(datetime,'"&inicio&"',103)" & vbcrlf & _
			   " else convert(varchar,b.bloq_finicio_modulo,103) end)  " & vbcrlf & _
			   " and convert(varchar,f.cale_fcalendario,103) <= (case when convert(datetime,'"&termino&"',103) <= convert(varchar,b.bloq_ftermino_modulo,103) then convert(datetime,'"&termino&"',103) else case when convert(varchar,b.bloq_ftermino_modulo,103) < convert(varchar,getDate(),103) then convert(varchar,b.bloq_ftermino_modulo,103) else convert(varchar,getDate(),103) end end)"
elseif not esVacio(inicio) and  esVacio(termino) then
	filtro_2 = " and convert(varchar,f.cale_fcalendario,103) between " & vbcrlf & _
	           " case when convert(datetime,'"&inicio&"',103) >= convert(varchar,b.bloq_finicio_modulo,103) then convert(datetime,'"&inicio&"',103)" & vbcrlf & _
			   " else convert(varchar,b.bloq_finicio_modulo,103) end  " & vbcrlf & _
			   " and case when convert(varchar,b.bloq_ftermino_modulo,103) < convert(varchar,getDate(),103) then convert(varchar,b.bloq_ftermino_modulo,103) else convert(varchar,getDate(),103) end"
elseif esVacio(inicio) and  not esVacio(termino) then
	filtro_2 = " and convert(varchar,f.cale_fcalendario,103) between convert(varchar,b.bloq_finicio_modulo,103) " & vbcrlf & _
			   " and case when convert(datetime,'"&termino&"',103) <= convert(varchar,b.bloq_ftermino_modulo,103) then convert(datetime,'"&termino&"',103) else case when convert(varchar,b.bloq_ftermino_modulo,103) < convert(varchar,getDate(),103) then convert(varchar,b.bloq_ftermino_modulo,103) else convert(varchar,getDate(),103) end end"
else
 filtro_2 = "and convert(datetime,f.cale_fcalendario,103) between convert(datetime,b.bloq_finicio_modulo,103) and case when convert(datetime,b.bloq_ftermino_modulo,103) < convert(datetime,getDate(),103) then convert(datetime,b.bloq_ftermino_modulo,103) else convert(datetime,getDate(),103) end "
end if

'response.Write("<pre>"&filtro_2&"</pre>")
consulta = " select distinct d.carr_tdesc as carrera,e.asig_ccod +' --> ' + e.asig_tdesc as asignatura,g.libr_ncorr,b.bloq_ccod,f.cale_fcalendario,"& vbcrlf & _
		   " protic.trunc(f.cale_fcalendario) as fecha,h.dias_tdesc as dia,i.hora_tdesc as bloque,'' as observacion "& vbcrlf & _
		   " from secciones a, bloques_horarios b, bloques_profesores c,carreras d, "& vbcrlf & _
		   "  	  asignaturas e, calendario f, libros_clases g,dias_semana h,horarios i "& vbcrlf & _
		   " where a.secc_ccod=b.secc_ccod "& vbcrlf & _
		   "	and b.bloq_ccod=c.bloq_ccod "& vbcrlf & _
		   "	and b.dias_ccod=h.dias_ccod "& vbcrlf & _
		   " 	and b.hora_ccod=i.hora_ccod "& vbcrlf & _
		   "	and a.carr_ccod=d.carr_ccod "& vbcrlf & _
		   "	and a.asig_ccod=e.asig_ccod "& vbcrlf & _
		   "	and a.secc_ccod=g.secc_ccod "& vbcrlf & _
		   "	and c.pers_ncorr=g.pers_ncorr "& filtro & vbcrlf & _
		   "	"&filtro_2& vbcrlf & _
		   "	--and (f.cale_bferiado <> 1 or f.cale_bferiado is null) "& vbcrlf & _
		   "	and datepart(weekday,f.cale_fcalendario) = b.dias_ccod "& vbcrlf & _
		   "	and not exists(select 1 from prestamos_libros pres where g.libr_ncorr=pres.libr_ncorr "& vbcrlf & _
		   "               and b.bloq_ccod=pres.bloq_ccod and protic.trunc(pres.pres_fprestamo) = protic.trunc(f.cale_fcalendario)) "& vbcrlf & _
		   " 	and cast(a.peri_ccod as varchar)=case e.duas_ccod when 3 then '"&peri&"' else '"&periodo&"' end "& vbcrlf & _
		   "	and cast(c.pers_ncorr as varchar)='"&pers_ncorr&"' "& vbcrlf & _
		   "	--and datepart(year,f.cale_fcalendario)='"&anos_ccod&"' "& vbcrlf & _
		   " 	order by f.cale_fcalendario "		   
		   
'response.Write("<pre>"&consulta&"</pre>")		   
formulario.Consultar consulta

nombre_docente= conexion.consultaUno("select pers_tnombre +' ' +pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_nrut as varchar)='"&rut&"'")
existe_foto = conexion.consultaUno("select count(*) from personas where cast(pers_nrut as varchar)='"&rut&"' and pers_nrut in (6182724,6376895,6555419,7994624,8053780,8534150,8712234,9908394,9942779,13254304)")
if existe_foto > 0 then
	foto_docente= conexion.consultaUno("Select '''../profes/'+ltrim(rtrim(cast('"&rut&"' as varchar)))+'.jpg''' as ruta")
else
	foto_docente= "'../profes/sin_foto.gif'"
end if
'response.Write(foto_docente)
  
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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

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
function genera_digito (rut){
 var IgStringVerificador, IgN, IgSuma, IgDigito, IgDigitoVerificador, rut;
   if (rut.length==7) rut = '0' + rut; 

   //alert(rut);
   IgStringVerificador = '32765432';
   IgSuma = 0;
   for( IgN = 0; IgN < 8 && IgN < rut.length; IgN++)
      IgSuma = eval(IgSuma + '+' + rut.substr(IgN, 1) + '*' + IgStringVerificador.substr(IgN, 1) + ';');
   IgDigito = 11 - IgSuma % 11;
   IgDigitoVerificador = IgDigito==10?'K':IgDigito==11?'0':IgDigito;
   //alert(IgDigitoVerificador);
buscador.elements["busqueda[0][pers_xdv]"].value=IgDigitoVerificador;
//alert(rut+IgDigitoVerificador);
_Buscar(this, document.forms['buscador'],'', 'Validar();', 'FALSE');
}

function revisa_check(){
     var formulario= document.edicion;
	 nro = formulario.elements.length;
	 valor_retorno=false;
     num =0;
     for( i = 0; i < nro; i++ ) {
	   comp = formulario.elements[i];
	   str  = formulario.elements[i].name;
	   if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo')){
	      num += 1;
	   }
     }
	 if (num==0)
	 {
      alert("Debe seleccionar la clase antes de ordenar la Recuperación o inasistencia");	 
	  valor_retorno=false;
	 }
	 else
	  {valor_retorno=true;}
	 
	 return valor_retorno;
}
</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "inicio","1","filtrador","fecha_oculta_inicio"
	calendario.MuestraFecha "termino","2","filtrador","fecha_oculta_termino"
	calendario.FinFuncion
%>
<% if not esVacio(rut) then
   		f_filtros.generaJS
   end if %>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<%calendario.ImprimeVariables%>
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
                    <tr> 
                      <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                      <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
                      <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                      <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                            <td width="210" valign="bottom" background="../imagenes/fondo1.gif"> 
                              <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador 
                                </font></div></td>
                            <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                            <td width="423" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                          </tr>
                        </table></td>
                      <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
                    </tr>
                  </table>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                      <td bgcolor="#D8D8DE"><div align="center"> 
                          <form name="buscador">
                            <table width="98%"  border="0">
                              <tr> 
                                <td width="81%"><table width="524" border="0">
                                    <tr> 
                                      <td width="98">Rut Docente</td>
                                      <td width="23">:</td>
                                      <td width="389"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                        <%f_busqueda.DibujaCampo("pers_nrut") %>
                                        - 
                                        <%f_busqueda.DibujaCampo("pers_xdv")%>
                                        </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                                    </tr>
                                  </table></td>
                                <td width="19%"><div align="center"> 
                                    <%botonera.DibujaBoton "buscar" %>
                                  </div></td>
                              </tr>
							  <tr>
							  	  <td colspan="2">&nbsp;</td>
							  </tr>
							  <tr>
							    <td colspan="2">Para acceder a los libros de un profesor puede hacerlo a través del código del libro con la pistola lectora o escribiendo directamente el Rut en el recuadro correspondiente.</td>
							  </tr>
                            </table>
                          </form>
                        </div></td>
                      <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                      <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                      <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
      </tr>
    </table>	
	<br>		
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Datos 
                          Encontrados</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0" aling="center">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <%if correcto="S" then %>  
                <td bgcolor="#D8D8DE"> <div align="center">&nbsp; 
                    <BR>
					<%pagina.DibujarTituloPagina%>
					<br><br>
                  </div>
                  <table  width="100%" border="0">
				   <%if not esVacio(rut) then%>
                    <tr> 
                      <td colspan="6" align="left">
					     <%if not esVacio(rut) then%>
					     <img name="foto" src=<%=foto_docente%> width="80" height="80" border="1">
						 <%end if%>
					  </td>
					</tr>
					<form name="filtrador">
					<input type="hidden" name="busqueda[0][pers_nrut]" value="<%=rut%>">
					<input type="hidden" name="busqueda[0][pers_xdv]" value="<%=digito%>">
					<tr> 
                      <td width="16%"><strong>Nombre Docente</strong></td>
					  <td width="1%"><strong>:</strong></td>
					  <td width="42%"><%=nombre_docente%></td>
					  <td width="7%"><strong>R.U.T.</strong></td>
					  <td width="1%"><strong>:</strong></td>
					  <td width="33%"><%=rut +"-"+digito%></td>
                    </tr>
						<%if not esvacio(rut) then%>
							<tr> 
							  <td width="16%"><strong>Carrera</strong></td>
							  <td width="1%"><strong>:</strong></td>
							  <td width="42%"><%f_filtros.dibujaCampoLista "filtros", "carr_ccod"%></td>
							  <td><strong>Inicio</strong></td>
								  <td>:</td>
								  <td><div align="left"></div><input type="text" name="inicio" maxlength="10" size="12" value="<%=inicio%>">
                          			  <%calendario.DibujaImagen "fecha_oculta_inicio","1","filtrador" %></td>
							   
							</tr>
							<tr> 
								  <td width="16%"><strong>Asignatura</strong></td>
							  	  <td width="1%"><strong>:</strong></td>
							      <td width="42%"><%f_filtros.dibujaCampoLista "filtros", "asig_ccod"%></td>
								  <td><strong>T&eacute;rmino</strong></td>
								  <td>:</td>
								  <td width="33%"><div align="left"><input type="text" name="termino" maxlength="10" size="12" value="<%=termino%>">
                                       <%calendario.DibujaImagen "fecha_oculta_termino","2","filtrador" %>
                          </div></td>
							</tr>
							<tr> <td colspan="6">
<div align="right"><% botonera.dibujaboton "filtrar"%></div></td> 
							</tr>
						<%end if%>
					<%end if%>
					</form>
					<tr> 
                      <td colspan="6"><div align="right">P&aacute;ginas: &nbsp; 
                          <%formulario.AccesoPagina%>
                        </div></td>
                    </tr>
                  </table> 
                  <form name="edicion">
                    <div align="center">
                      <% formulario.DibujaTabla %>
                    </div>
                  </form>
				  
				  * Seleccione las Clases que no se dictaron y presione "Guardar Inasistencia"<br></td>
				  <%else%>
				  <td bgcolor="#D8D8DE" align="center"><br><font size="2" color="#0000FF"><strong>El periodo de planificación seleccionado no corresponde al año en curso haga el favor de salir de esta funcionalidad y seleccionar el correcto antes de continuar.</strong></font><br><br></td>
				  <%end if%>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="65" nowrap bgcolor="#D8D8DE"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="30%">
                        <%  botonera.dibujaboton "salir"%>
                      </td>
					   <td width="32%">
                        <% ' botonera.agregaBotonParam "guardar1","deshabilitado","TRUE"
						   'botonera.dibujaboton "guardar1"%>
                      </td>
					  <td width="32%">
					     <%  if correcto = "S" then
						     botonera.dibujaboton "guardar2"
							 end if%>
                      </td>
                    </tr>
                  </table></td>
                  <td width="345" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="267" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<BR>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>

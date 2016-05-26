<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Listado Alumnos Matriculados"
set errores = new CErrores
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set botonera = new CFormulario
botonera.Carga_Parametros "codigos_alumnos.xml", "botonera"
'---------------------------------------------------------------------------------------------------
 v_sede_ccod 	= request.querystring("busqueda[0][sede_ccod]")
 v_post_bnuevo 	= request.querystring("busqueda[0][post_bnuevo]")
 v_carr_ccod 	= request.querystring("busqueda[0][carr_ccod]")
 rut_alumno 	= request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "codigos_alumnos.xml", "busqueda_alumnos"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente

 f_busqueda.AgregaCampoCons "sede_ccod", v_sede_ccod
 f_busqueda.AgregaCampoCons "post_bnuevo", v_post_bnuevo
 f_busqueda.AgregaCampoCons "carr_ccod", v_carr_ccod
 f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
 f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
'----------------------------------------------------------------------------------
set f_alumnos = new CFormulario
f_alumnos.Carga_Parametros "codigos_alumnos.xml", "f_alumnos"
f_alumnos.Inicializar conexion

				 
		 	  

consulta	=	" select distinct (select pers_nrut from personas where pers_ncorr=c.pers_ncorr) as rut,protic.obtener_rut(c.pers_ncorr) as rut_alumno, "& vbCrLf &_
				" protic.obtener_nombre_completo(c.pers_ncorr,'n') as nombre_alumno,"& vbCrLf &_
				" protic.obtener_nombre_carrera(c.ofer_ncorr,'CJ') as carrera,"& vbCrLf &_
				" sede_tdesc as sede, case (select post_bnuevo from postulantes where post_ncorr=c.post_ncorr) when 'S' then 'NUEVO' else 'ANTIGUO' end as tipo_alumno "& vbCrLf &_
				" 	 from ofertas_academicas a  "& vbCrLf &_  
				" 		 left outer join sedes b    "& vbCrLf &_
				" 			 on a.sede_ccod =b.sede_ccod    "& vbCrLf &_
				" 		 left outer join alumnos c    "& vbCrLf &_
				" 			 on a.ofer_ncorr =c.ofer_ncorr    "& vbCrLf &_
				"		 join personas e	"& vbCrLf &_
				" 			on c.pers_ncorr=e.pers_ncorr "& vbCrLf &_
				" 		 right outer join especialidades d    "& vbCrLf &_
				" 			 on a.espe_ccod = d.espe_ccod    "& vbCrLf &_
				" 		where c.emat_ccod in (1,4,8,2,13)     "& vbCrLf &_
				" 		and protic.afecta_estadistica(c.matr_ncorr) > 0   "& vbCrLf &_ 
				" 		and a.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod =datepart(year, getdate())) "& vbCrLf &_
				" 		And c.pers_ncorr > 0    "
	 
					if  v_sede_ccod <> ""  then 
						consulta = consulta & " and a.sede_ccod = '" & v_sede_ccod & "'"
					end if
					
					if v_carr_ccod  <> "" then 
						consulta = consulta & " and d.carr_ccod = '" & v_carr_ccod & "'"
					end if
					
					if rut_alumno <> "" then
						consulta = consulta &  " AND e.pers_nrut = '" & rut_alumno & "' "
					end if						  
					
					if v_post_bnuevo  <> "" then 
						consulta = consulta & "and (select post_bnuevo from postulantes where post_ncorr=c.post_ncorr) in ('" & v_post_bnuevo & "')"
					else
						consulta = consulta & " and (select post_bnuevo from postulantes where post_ncorr=c.post_ncorr) in('S','N') "
					end if		
	  
					consulta = consulta  &  "order by  carrera,nombre_alumno desc "
 

 
 if Request.QueryString <> "" then
	  f_alumnos.consultar consulta
  else
	f_alumnos.consultar "select '' where 1 = 2"
	f_alumnos.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
  end if
'response.Write("<pre>"&consulta&"</pre>")
'response.Flush()
 cantidad=f_alumnos.nroFilas
'----------------------------------------------------------------------- 
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
function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>
}

function Validar()
{
	formulario = document.buscador;
	rut_profesor = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_profesor)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }
	
	return true;
}

</script>
<script language='javaScript1.2'> 
  colores = Array(3);
  colores[0] = ''; 
  colores[1] = '#97AAC6'; 
  colores[2] = '#C0C0C0'; 
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
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
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8" ><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="14" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="208" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador 
                          de Alumnos</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="430" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
                      <td width="81%"><table border="0" width="100%">
                        <tr>
                          <td width="66" height="20"><strong>Sede</strong></td>
                          <td width="13"><strong>:</strong></td>
                          <td width="113"><% f_busqueda.DibujaCampo("sede_ccod") %></td>
                          <td height="20"><strong>Tipo Alumno</strong></td>
                          <td>:</td>
                          <td><% f_busqueda.dibujaCampo ("post_bnuevo")%></td>
                        </tr>
                        <tr>
                          <td height="20"><strong>Carrera</strong></td>
                          <td><strong>:</strong></td>
                          <td colspan="4" align="left">
                            <% f_busqueda.DibujaCampo("carr_ccod") %></td>
                        </tr>
                        <tr>
                          <td width="129" height="20"><div align="left"><strong>Rut Alumno </strong> </div></td>
                          <td width="11"><strong>:</strong></td>
                          <td width="168"><% f_busqueda.dibujaCampo ("pers_nrut")%>
                            -
                              <%f_busqueda.dibujaCampo("pers_xdv")%>
                              <a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a><font face="Verdana, Arial, Helvetica, sans-serif" size="1">&nbsp;</font> </td>
                        </tr>
                      </table></td>
                      <td width="19%"><div align="center"><%botonera.DibujaBoton "buscar_alumnos" %></div></td>
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
            </table>			
          </td>
      </tr>
    </table>	
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Listado 
                          de alumnos encontrados </font></div>
                    </td>
                    <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                  </tr>
                </table>
              </td>
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
                <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"> <div align="center"><BR>
                    <%pagina.DibujarTituloPagina%>
                    <table width="665" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                            <%f_alumnos.AccesoPagina%>
                          </div></td>
                        <td width="24"> <div align="right"> </div></td>
                      </tr>
                    </table>
                  </div>
                  <form name="edicion" method="post">
				  <%if v_post_bnuevo<>"" then%>
				  	<input type="hidden" name="tipo_alumno" value="<%=v_post_bnuevo%>">
				  <%end if%>
				 <%if rut_alumno <>"" then%>
				  	<input type="hidden" name="rut_alumno" value="<%=rut_alumno%>">
				  <%end if%>
				  <%if v_sede_ccod<>"" then%>
				  	<input type="hidden" name="sede_ccod" value="<%=v_sede_ccod%>">
				  <%end if%>
				  <%if v_carr_ccod<>"" then%>
				  	<input type="hidden" name="carr_ccod" value="<%=v_carr_ccod%>">
				  <%end if%>
                    <div align="center">
                      <%f_alumnos.DibujaTabla %>
                    </div>
                  </form>
                    <br>
                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="195" bgcolor="#D8D8DE"><table width="41%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="8%"><div align="center"> 
                          <% botonera.dibujaboton "imprimir" %>
                        </div></td>
                      <td width="9%">&nbsp; </td>
                      <td width="12%"> </td>
                      <td width="71%"> <div align="left"> 
                          <% botonera.DibujaBoton "lanzadera" %>
                        </div></td>
                    </tr>
                  </table>
                </td>
                <td width="167" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
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
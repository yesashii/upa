<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina
pagina.Titulo = "Anulación de Contratos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "anulacion_contratos.xml", "botonera"

set errores = new CErrores

'---------------------------------------------------------------------------------------------------
v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
if v_peri_ccod="164" or v_peri_ccod="200" or v_peri_ccod="202" then
	mensaje="<div align='center'><font color='#0000FF' size='2' >Esta seleccionando un contrato del <b>Año 2005</b>.<br>La anulacion de estos contratos a sido deshabilitada.</font></div> <br>"
	f_botonera.AgregaBotonParam "anular", "deshabilitado", "true"
end if
'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "anulacion_contratos.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv

'---------------------------------------------------------------------------------------------------
consulta = "select c.cont_ncorr " & vbCrLf &_
           "from personas_postulante a, postulantes b, contratos c  " & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr  " & vbCrLf &_
		   "  and b.post_ncorr = c.post_ncorr  " & vbCrLf &_
		   "  and c.econ_ccod <> 3  " & vbCrLf &_
		   "  and c.peri_ccod = '" & v_peri_ccod & "'    " & vbCrLf &_
		   "  and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "' " & vbCrLf &_
		   " order by cont_ncorr desc "
'response.Write("<pre>"&consulta&"</pre>")		   
v_cont_ncorr = conexion.ConsultaUno(consulta)
arr_contratos = negocio.ObtenerContratosHermanos(v_cont_ncorr)


str_filtro_contratos = ""
for i_= 0 to UBound(arr_contratos)
	str_filtro_contratos = str_filtro_contratos & arr_contratos(i_)
	
	if i_ <> UBound(arr_contratos) then
		str_filtro_contratos = str_filtro_contratos & ", "
	end if
next
if EsVacio(str_filtro_contratos) then
	str_filtro_contratos = "''"
end if 

'---------------------------------------------------------------------------------------------------


set f_contratos = new CFormulario
f_contratos.Carga_Parametros "anulacion_contratos.xml", "contratos"
f_contratos.Inicializar conexion

		   
consulta = "select isnull(protic.total_abonado_contrato(c.cont_ncorr),0) as abonado,c.cont_ncorr, c.cont_ncorr as c_cont_ncorr, c.cont_fcontrato, c.econ_ccod" & vbCrLf &_
			"        ,protic.obtener_nombre_carrera(isnull(d.ofer_ncorr, b.ofer_ncorr), 'CE') as carrera" & vbCrLf &_
			"        ,case e.pers_ncorr when null then cast(a.pers_nrut as varchar(10)) + '-' + a.pers_xdv" & vbCrLf &_
			"                            else protic.obtener_rut(e.pers_ncorr)" & vbCrLf &_
			"                            end as rut" & vbCrLf &_
			"        ,case e.pers_ncorr " & vbCrLf &_
			"        when null then a.pers_tape_paterno + ' ' +  a.pers_tape_materno + ', ' + a.pers_tnombre " & vbCrLf &_
			"        else protic.obtener_nombre_completo(e.pers_ncorr, 'n') " & vbCrLf &_
			"        end as nombre_completo" & vbCrLf &_
			"        ,protic.total_contrato(c.cont_ncorr) as total_contrato, protic.total_abonado_contrato(c.cont_ncorr) as total_abonado" & vbCrLf &_
			"        ,protic.total_documentado_contrato(c.cont_ncorr) as total_documentado " & vbCrLf &_
			"    from personas_postulante a,postulantes b,contratos c,alumnos d,personas e" & vbCrLf &_
			"    where a.pers_ncorr = b.pers_ncorr  " & vbCrLf &_
			"        and b.post_ncorr = c.post_ncorr" & vbCrLf &_
			"        and c.matr_ncorr *= d.matr_ncorr" & vbCrLf &_
			"        and b.pers_ncorr *= e.pers_ncorr" & vbCrLf &_
			"        and c.econ_ccod <> 3 " & vbCrLf &_
			"        and cast(c.cont_ncorr as varchar) in (" & str_filtro_contratos & ")"
'response.Write("<pre>"&consulta&"</pre>")
		   
f_contratos.Consultar consulta

if f_contratos.NroFilas = 0 then
	f_botonera.AgregaBotonParam "anular", "deshabilitado", "TRUE"
end if



'---------------------------------------------------------------
set persona = new CPersona
persona.Inicializar conexion, q_pers_nrut

set postulante = new CPostulante
postulante.Inicializar conexion, persona.ObtenerPostNCorr(v_peri_ccod)
'response.End()		   
'------------------------------------------

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
function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>
}

function Anula_Contrato(form){
mensaje="Anular";
	if (valida_abonado(form)){
		if (preValidaFormulario(form)){
			if (verifica_check(form,mensaje)){
				return true;
			}
		}	
	}
	return false;
} 


function valida_abonado(form){
	  	nro = form.elements.length;
   		num =0;
	   for( i = 0; i < nro; i++ ) {
		  comp = form.elements[i];
		  str  = form.elements[i].name;
		  
		  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo')){
		  //	alert(str);
		  	 indice=extrae_indice(str);
			 //alert("Indice:"+indice);
			 v_abonado=form.elements["contratos["+indice+"][abonado]"].value;
			 v_contrato=form.elements["contratos["+indice+"][cont_ncorr]"].value;
			 	if (v_abonado>0){ 
			 		alert('El contrato N°: '+ v_contrato +' tiene pagos asociados. \nPor lo que no puede anularse de esta forma');
					return false;

				}	
		  }
	   }
	   
	return true;

 }

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                    <table width="60%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td><div align="right"><strong>R.U.T. Alumno </strong></div></td>
                        <td width="50"><div align="center"><strong>:</strong></div></td>
                        <td><%f_busqueda.DibujaCampo("pers_nrut")%> 
                          - 
                            <%f_busqueda.DibujaCampo("pers_xdv")%> <%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td>
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
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Contratos"%>
                      <br>
					  <%=mensaje%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center">
                                <%f_contratos.DibujaTabla%>
                          </div></td>
                        </tr>
						<%if f_contratos.NroFilas > 1 then%>
                        <tr>
                          <td><br>
                            Se ha encontrado que el contrato que se desea anular comparte uno o m&aacute;s documentos con otros contratos, por lo que deben anularse todos &eacute;stos. Presione &quot;Anular&quot; para anularlos. </td>
                        </tr>
						<%end if%>
                      </table></td>
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
            <td width="29%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("anular")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir")%>
                  </div></td>
                  </tr>
              </table>
            </div></td>
            <td width="71%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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

<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_ncorr 	= Request.QueryString("pers_ncorr")
q_dgso_ncorr 	= Request.QueryString("dgso_ncorr")
v_norc_empresa	= Request.QueryString("norc_empresa")
q_tipo_persona	= Request.QueryString("tipo")

set pagina = new CPagina
pagina.Titulo = "Detalle postulacion Otec"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'response.end()
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "datos_otec.xml", "botonera"

set errores = new CErrores


'---------------------------------------------------------------------------------------------------
set f_cargo = new CFormulario
f_cargo.Carga_Parametros "datos_otec.xml", "detalle_cargo"
f_cargo.Inicializar conexion

if q_pers_ncorr<>"" then

	select case q_tipo_persona
			case "1"
			sql_datos_postulante= 	" select top 1 protic.obtener_rut(x.pers_ncorr) as rut_empresa,x.pers_tnombre as empresa, "&vbcrlf&_
									"	protic.obtener_rut(y.pers_ncorr) as rut_otic,y.pers_tnombre as otic  "&vbcrlf&_
									"	from postulacion_otec a, personas e "&vbcrlf&_
									"	,datos_generales_secciones_otec b , ofertas_otec c , diplomados_cursos d, "&vbcrlf&_
									"	personas x, personas y "&vbcrlf&_
									"	where cast(a.pers_ncorr as varchar)='"&q_pers_ncorr&"' "&vbcrlf&_
									"	 and a.pers_ncorr=e.pers_ncorr  "&vbcrlf&_
									"	 and a.dgso_ncorr=b.dgso_ncorr  "&vbcrlf&_
									"	 and b.dgso_ncorr=c.dgso_ncorr  "&vbcrlf&_
									"	 and c.dcur_ncorr=d.dcur_ncorr  "&vbcrlf&_
									"	 and c.dcur_ncorr=d.dcur_ncorr  "&vbcrlf&_
									"	 and a.empr_ncorr_empresa*=x.pers_ncorr "&vbcrlf&_
									"	 and a.empr_ncorr_otic*=y.pers_ncorr"		
		case "2"
			'Empresa	
			sql_datos_postulante= 	" select top 1 protic.obtener_rut(x.pers_ncorr) as rut_empresa,x.pers_tnombre as empresa, "&vbcrlf&_
									"	protic.obtener_rut(y.pers_ncorr) as rut_otic,y.pers_tnombre as otic  "&vbcrlf&_
									"	from postulacion_otec a, personas e "&vbcrlf&_
									"	,datos_generales_secciones_otec b , ofertas_otec c , diplomados_cursos d, "&vbcrlf&_
									"	personas x, personas y "&vbcrlf&_
									"	where cast(a.empr_ncorr_empresa as varchar)='"&q_pers_ncorr&"' "&vbcrlf&_
									" 	 and a.dgso_ncorr='"&q_dgso_ncorr&"'"&vbcrlf&_
									"	 and a.pers_ncorr=e.pers_ncorr  "&vbcrlf&_
									"	 and a.dgso_ncorr=b.dgso_ncorr  "&vbcrlf&_
									"	 and b.dgso_ncorr=c.dgso_ncorr  "&vbcrlf&_
									"	 and c.dcur_ncorr=d.dcur_ncorr  "&vbcrlf&_
									"	 and c.dcur_ncorr=d.dcur_ncorr  "&vbcrlf&_
									"	 and a.empr_ncorr_empresa*=x.pers_ncorr "&vbcrlf&_
									"	 and a.empr_ncorr_otic*=y.pers_ncorr"		
																
		case "3"
			'Otic
			sql_datos_postulante= 	" select top 1 protic.obtener_rut(x.pers_ncorr) as rut_empresa,x.pers_tnombre as empresa, "&vbcrlf&_
									"	protic.obtener_rut(y.pers_ncorr) as rut_otic,y.pers_tnombre as otic  "&vbcrlf&_
									"	from postulacion_otec a, personas e "&vbcrlf&_
									"	,datos_generales_secciones_otec b , ofertas_otec c , diplomados_cursos d, "&vbcrlf&_
									"	personas x, personas y "&vbcrlf&_
									"	where cast(a.empr_ncorr_otic as varchar)='"&q_pers_ncorr&"' "&vbcrlf&_
									" 	 and a.dgso_ncorr='"&q_dgso_ncorr&"'"&vbcrlf&_
									"	 and a.pers_ncorr=e.pers_ncorr  "&vbcrlf&_
									"	 and a.dgso_ncorr=b.dgso_ncorr  "&vbcrlf&_
									"	 and b.dgso_ncorr=c.dgso_ncorr  "&vbcrlf&_
									"	 and c.dcur_ncorr=d.dcur_ncorr  "&vbcrlf&_
									"	 and c.dcur_ncorr=d.dcur_ncorr  "&vbcrlf&_
									"	 and a.empr_ncorr_empresa*=x.pers_ncorr "&vbcrlf&_
									"	 and a.empr_ncorr_otic*=y.pers_ncorr"		
	end select																
else
	sql_datos_postulante="select '' where 1=2"
end if
'response.Write("<pre>"&sql_datos_postulante&"</pre>")
f_cargo.Consultar sql_datos_postulante

set f_detalle = new CFormulario
f_detalle.Carga_Parametros "datos_otec.xml", "detalle_postulantes"
f_detalle.Inicializar conexion

if v_norc_empresa<>"" then

			sql_detalle_postulantes="select protic.obtener_rut(a.pers_ncorr) as rut_alumno, pers_tnombre, pers_tape_paterno, pers_tape_materno "&vbcrlf&_ 
								" from postulacion_otec a, datos_generales_secciones_otec b, "&vbcrlf&_
								" ofertas_otec c, diplomados_cursos d, personas e"&vbcrlf&_
								" where a.dgso_ncorr='"&q_dgso_ncorr&"'"&vbcrlf&_
								"  and a.norc_empresa="&v_norc_empresa&" "&vbcrlf&_
								"  and a.dgso_ncorr=b.dgso_ncorr "&vbcrlf&_
								"  and b.dgso_ncorr=c.dgso_ncorr "&vbcrlf&_
								"  and c.dcur_ncorr=d.dcur_ncorr "&vbcrlf&_
								"  --and a.epot_ccod=2 "&vbcrlf&_
								"  and a.pers_ncorr=e.pers_ncorr"
						
else
	sql_detalle_postulantes="select '' where 1=2"

end if
'response.Write("<pre>"&sql_detalle_postulantes&"</pre>")
'response.End()
'response.Flush()

f_detalle.Consultar sql_detalle_postulantes

'---------------------------------------------------------------------------------------------------

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

function uno_seleccionado(form){
	  	nro = form.elements.length;
   		num =0;
	   for( i = 0; i < nro; i++ ) {
		  comp = form.elements[i];
		  str  = form.elements[i].name;
		  
		  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo')){
	 		num += 1;
		  }
	   }
	   return num;
 }

function Validar(formulario)
{
	valor = uno_seleccionado(formulario);
	if	(valor == 1)// se selecciono uno
	{
		return true;
	}else{
		alert("Debe seleccionar una opcion a la vez");
	}
}


function ValidaBusqueda()
{
	n_rut=document.buscador.elements["busqueda[0][pers_nrut]"].value;
	n_dv=document.buscador.elements["busqueda[0][pers_xdv]"].value;
	rut=n_rut+ '-' +n_dv;
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido.');		
		document.buscador.elements["busqueda[0][pers_nrut]"].focus();
		return false;
	}
	
	return true;	
}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');" onBlur="revisaVentana();">
<table width="" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA"><br>
	<table width="400"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td></td>
          </tr>
          <tr>
            <td height="2" background=""></td>
          </tr>
          <tr>
            <td>
            <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Detalle Financiamiento"%>

                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><%f_cargo.DibujaTabla%></td>
                        </tr>
                      </table>
					  </td>
                  </tr>
				  <tr>
				  <td>
				  <br>
				  <br>
				  <%pagina.DibujarSubtitulo "Detalle Postulantes"%>
				  <br/>
				  <%f_detalle.DibujaTabla%>
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
            <td width="23%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton "cerrar"%>
                  </div></td>
                  </tr>
              </table>
            </div></td>
            <td width="77%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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

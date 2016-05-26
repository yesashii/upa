
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------
q_pers_nrut 	= 	Request.QueryString("buscador[0][pers_nrut]")
q_pers_xdv 		= 	Request.QueryString("buscador[0][pers_xdv]")

set pagina = new CPagina
pagina.Titulo = "Crear Matriculas"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "crea_matriculas.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "crea_matriculas.xml", "buscador"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.Siguiente

v_pers_ncorr = conexion.ConsultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar) = '" & q_pers_nrut & "'")

'--------------------------------------------------------------------------------------------------

set formulario = new CFormulario
formulario.Carga_Parametros "crea_matriculas.xml", "datos_postulante"
formulario.Inicializar conexion
consulta ="Select protic.obtener_rut(pers_ncorr) as rut,protic.obtener_nombre_completo(pers_ncorr, 'n') as nombre from personas where cast(pers_nrut as varchar) = '" & q_pers_nrut & "'"
formulario.Consultar consulta
formulario.Siguiente

'------------------------------------------------------------------------------------------------------
'----------------------------buscamos la información de las matriculas del alumno
set datos_matriculas = new CFormulario
datos_matriculas.Carga_Parametros "crea_matriculas.xml", "matriculas"
datos_matriculas.Inicializar conexion
consulta_matriculas =  " select top 3 case when m.espe_ccod <> d.espe_ccod then '<font color=red><strong>'+cast(a.matr_ncorr as varchar)+'</strong></font>' else cast(a.matr_ncorr as varchar) end  as num_matricula, a.post_ncorr as num_pos,cast(j.cont_ncorr as varchar) + case j.contrato when null then '' else '(' + cast(contrato as varchar) + ')' end  as num_con,protic.initcap(f.peri_tdesc) as periodo,protic.initcap(g.sede_tdesc) as sede, protic.initcap(e.carr_tdesc) as carrera,case h.jorn_ccod when 1 then '(D)' else '(V)' end as jornada,cast(d.espe_ccod as varchar)+ '-->' + protic.initcap(d.espe_tdesc) as mension, "& vbCrLf &_
					   " protic.initcap(i.emat_tdesc) as estado_alumno, protic.trunc(isnull(j.cont_fcontrato,a.alum_fmatricula)) as fecha, isnull(k.econ_tdesc,'*') as estado_matricula "& vbCrLf &_   
					   " ,'('+cast(l.plan_ccod as varchar)+') '+ l.plan_tdesc as plan_estu, m.espe_ccod as espe_plan,f.anos_ccod,f.plec_ccod,isnull(j.cont_fcontrato,a.alum_fmatricula) as fecha2  "& vbCrLf &_
					   " from "& vbCrLf &_
					   " alumnos a join ofertas_academicas c "& vbCrLf &_
				       "    on a.ofer_ncorr = c.ofer_ncorr "& vbCrLf &_
					   " join especialidades d "& vbCrLf &_
				       "    on c.espe_ccod  = d.espe_ccod "& vbCrLf &_
					   " join carreras e "& vbCrLf &_
				       "    on d.carr_ccod  = e.carr_ccod "& vbCrLf &_
					   " join periodos_Academicos f "& vbCrLf &_
				       "    on c.peri_ccod  = f.peri_ccod  "& vbCrLf &_
				       " join sedes g "& vbCrLf &_
				       "    on c.sede_ccod  = g.sede_ccod "& vbCrLf &_
				       " join jornadas h "& vbCrLf &_
				       "    on c.jorn_ccod  = h.jorn_ccod  "& vbCrLf &_
					   " join estados_matriculas i "& vbCrLf &_
					   "    on a.emat_ccod  = i.emat_ccod "& vbCrLf &_
					   " left outer join contratos j "& vbCrLf &_
					   "    on a.matr_ncorr = j.matr_ncorr "& vbCrLf &_
				       " left outer join estados_contrato k "& vbCrLf &_
					   "    on j.econ_ccod = k.econ_ccod "& vbCrLf &_
					   "left outer join planes_estudio l "& vbCrLf &_
					   "    on a.plan_ccod = l.plan_ccod   "& vbCrLf &_
					   " left outer join especialidades m "& vbCrLf &_
					   "    on l.espe_ccod = m.espe_ccod " & vbCrLf &_
					   " where cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"' "& vbCrLf &_					   
					   " order by anos_ccod desc, fecha2 desc    "
'response.Write("<pre>"&consulta_matriculas&"</pre>")
datos_matriculas.Consultar consulta_matriculas


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
end if
%>
}

function ValidaBusqueda()
{
	rut=document.buscador.elements['buscador[0][pers_nrut]'].value+'-'+document.buscador.elements['buscador[0][pers_xdv]'].value
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido');		
		document.buscador.elements['buscador[0][pers_nrut]'].focus()
		document.buscador.elements['buscador[0][pers_nrut]'].select()
		return false;
	}
	
	return true;	
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr>
    <td height="65"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
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
                        <td width="32%"><div align="right">R.U.T.</div></td>
                        <td width="7%"><div align="center">:</div></td>
                        <td width="61%"><%f_busqueda.DibujaCampo("pers_nrut")%>-<%f_busqueda.DibujaCampo("pers_xdv")%>
        <%pagina.DibujarBuscaPersonas "buscador[0][pers_nrut]", "buscador[0][pers_xdv]" %></td>
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
        <td>
        <% 
		if q_pers_nrut <> "" then%>
        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>          
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%>
              <br><br></div>		
			<form name="edicion">
            <input type="hidden" name="pers_nrut" value="<%=q_pers_nrut%>">
            <input type="hidden" name="pers_ncorr" value="<%=v_pers_ncorr%>">
            	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
                	<tr>
                    	<td width="18%"><strong>RUT</strong></td>
                        <td width="2%"><strong>:</strong></td>
                        <td width="80%"><%formulario.DibujaCampo("rut")%></td>
                    </tr>
                    <tr>
                    	<td width="18%"><strong>NOMBRE</strong></td>
                        <td width="2%"><strong>:</strong></td>
                        <td width="80%"><%formulario.DibujaCampo("nombre")%></td>
                    </tr>          		
			  	</table>
                <br>
                <table width="100%"  border="0" cellspacing="0" cellpadding="0">               
                	<tr>  
                    <td><%pagina.DibujarSubtitulo "ULTIMAS 3 MATRICULAS DEL ALUMNO"%> <%datos_matriculas.DibujaTabla %></td>                    </tr>                            		
			  	</table>   
                <br>
                <br>
                <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                      <td width="21%"><strong>Periodo a matricular</strong></td>
                    <td width="79%"><%formulario.DibujaCampo("peri_ccod")%> </td>
                    </tr> 
                    <tr>
                      <td width="21%"><strong>Sede a matricular</strong></td>
                    <td width="79%"><%formulario.DibujaCampo("sede_ccod")%> </td>
                    </tr> 
                </table>
                <br>
                <br>             
            </form>            
            </td></tr>            
        </table>
		<% end if %>
        </td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="18%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="45%"> <%f_botonera.DibujaBoton("guardar")%>
                          
                        </td>
                        <td width="55%"><div align="center">
                            <%f_botonera.DibujaBoton("salir")%>
                          </div></td>
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
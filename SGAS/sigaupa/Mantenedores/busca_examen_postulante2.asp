<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
function SQLExamenesPostulantes()
usuario=negocio.ObtenerUsuario()
pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")
consulta = "select case c.ofer_bpaga_examen when 'S' then 1 else 0 end as ofer_bpaga_examen,isnull((select cast(cast(pa.comp_mneto AS integer) - (protic.total_abonado_cuota(ba.tcom_ccod,  pa.inst_ccod, "  & vbCrLf &_
		 " pa.comp_ndocto, ba.dcom_ncompromiso) + protic.total_abono_documentado_cuota(ba.tcom_ccod, pa.inst_ccod, "  & vbCrLf &_
		 " pa.comp_ndocto, ba.dcom_ncompromiso))as integer) "  & vbCrLf &_
		 " from compromisos pa,detalle_compromisos ba "  & vbCrLf &_
		 " where pa.pers_ncorr=b.pers_ncorr "  & vbCrLf &_
		 " and pa.tcom_ccod=15 "  & vbCrLf &_
		 " and pa.tcom_ccod=ba.tcom_ccod "  & vbCrLf &_
		 " and pa.inst_ccod=ba.inst_ccod "  & vbCrLf &_
		 " And pa.comp_ndocto=ba.comp_ndocto "  & vbCrLf &_
		 " And pa.ecom_ccod=1),-1) as deuda , "& vbCrLf &_
		 " (Select count(*) from postulantes where post_ncorr =b.post_ncorr and post_bpaga='N') as exento, "  & vbCrLf &_
		 " a.pers_ncorr, cast(a.pers_nrut as varchar) + '-' + a.pers_xdv as rut,"  & vbCrLf &_
							"       a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre_completo, " & vbCrLf &_
							"       e.carr_tdesc + '-' + d.espe_tdesc as carrera,f.ofer_ncorr,d.espe_ccod,e.carr_ccod,g.eepo_tdesc," & vbCrLf &_
							"       f.eepo_ccod,f.post_ncorr,a.pers_nrut as q_pers_nrut" & vbCrLf &_
							"from personas_postulante a, postulantes b,ofertas_academicas c,especialidades d,carreras e," & vbCrLf &_
							"     detalle_postulantes f, estado_examen_postulantes g,areas_academicas h" & vbCrLf &_
							"where a.pers_ncorr = b.pers_ncorr  " 
							if q_pers_nrut<>"" and q_pers_xdv<>"" then
							    consulta=consulta & " and cast(a.pers_nrut as varchar)='"&q_pers_nrut&"'"
							end if	
							consulta=consulta & "  and f.post_ncorr = b.post_ncorr and c.post_bnuevo='S' " & vbCrLf &_
							"  and f.eepo_ccod = g.eepo_ccod" 
							 if jorn_ccod<>"" then
		                     	consulta=consulta&" and cast(c.jorn_ccod as varchar)='"&jorn_ccod&"'"
		                     end if
							consulta=consulta & "  and f.ofer_ncorr = c.ofer_ncorr" & vbCrLf &_
							"  and c.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where cast(pers_ncorr as varchar)='"&pers_ncorr_encargado&"')" 
							if sede_ccod<>"" then
                               consulta=consulta & " and cast(c.sede_ccod as varchar)= '"&sede_ccod&"'"
		                    end if
							consulta=consulta & "  and c.espe_ccod = d.espe_ccod"
							 if carr_ccod<>"" then
                                consulta=consulta & " and cast(e.carr_ccod as varchar)= '"&carr_ccod&"'" 
		                      end if
							consulta=consulta & "  and d.carr_ccod = e.carr_ccod" & vbCrLf &_
							"  and e.area_ccod = h.area_ccod " & vbCrLf &_
							"  and b.peri_ccod = '"&negocio.obtenerperiodoacademico("postulacion")&"' " & vbCrLf &_
							" and b.epos_ccod=2 " & vbCrLf &_
							"  and not exists (select 1 " & vbCrLf &_
							"                  from alumnos a2 " & vbCrLf &_
							"				  where a2.post_ncorr = b.post_ncorr " & vbCrLf &_
							"				    and a2.emat_ccod = 1)"
SQLExamenesPostulantes = consulta

end function
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
sede_ccod = Request.QueryString("sede")
carr_ccod = Request.QueryString("carrera")
jorn_ccod= request.QueryString("jornada")
paso=request.QueryString("paso")
v_anula_edicion=0
'response.Write("sede "&sede&" carrera "&carr_ccod&" jornada "&jorn_ccod)
'response.Write("<br>paso "&paso)
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina
pagina.Titulo = "Examenes Admisión Postulantes"

set errores = new CErrores

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "busca_examen_postulante.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "busca_examen_postulante.xml", "busqueda2"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "Select ''"
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.Siguiente
'response.End()
if q_pers_nrut<>"" and q_pers_xdv<>"" then
	sql_pers_ncorr="select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'"
	v_pers_ncorr=conexion.ConsultaUno(sql_pers_ncorr)
end if

'-------------------------------------------------------------------
set f_alumno = new CFormulario
f_alumno.Carga_Parametros "busca_examen_postulante.xml", "alumno"
f_alumno.Inicializar conexion

v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")

consulta = "select distinct a.pers_ncorr, protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'ap') as nombre_completo " & vbCrLf &_
           "from personas a, alumnos b, postulantes c" & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
		   "  and b.emat_ccod = 1 " & vbCrLf &_
		   "  and b.post_ncorr=c.post_ncorr " & vbCrLf &_
		   "  and cast(c.peri_ccod as varchar)= '"&v_peri_ccod&"'" & vbCrLf &_
		   "  and a.pers_nrut = cast(cast('" & q_pers_nrut & "' as real ) as numeric)" & vbCrLf &_
		   "  and not exists (select 1 " & vbCrLf &_
		   "                  from alumnos a2, ofertas_academicas b2" & vbCrLf &_
		   "				  where a2.ofer_ncorr = b2.ofer_ncorr" & vbCrLf &_
		   "				    and cast(b2.peri_ccod as varchar) = '" & v_peri_ccod & "'" & vbCrLf &_
		   "					and a2.pers_ncorr = b.pers_ncorr" & vbCrLf &_
		   "					and a2.emat_ccod = 1)"
		   

'response.Write("<pre>" & consulta & "</pre>")
'response.End()
f_alumno.Consultar consulta
cantidad22= f_alumno.NroFilas

if f_alumno.NroFilas = 0 then	
'response.End()
if paso<>"" then
consulta=SQLExamenesPostulantes()
else
consulta="Select * from sexos where 1=2"
end if
'response.End()

	
	f_alumno.Consultar consulta
	cantidad_encontrados=conexion.consultaUno("Select count(*)from ("&consulta&")a")
	if v_pers_ncorr<>"" then
		sql_examen_pagado="select cast(cast(a.comp_mneto AS integer) - (protic.total_abonado_cuota(b.tcom_ccod,  a.inst_ccod, "&_
							" a.comp_ndocto, b.dcom_ncompromiso) + protic.total_abono_documentado_cuota(b.tcom_ccod, a.inst_ccod, "&_
							" a.comp_ndocto, b.dcom_ncompromiso))as integer) AS saldo"&_
							" from compromisos a,detalle_compromisos b "&_
							" where cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"'"&_
							" and a.tcom_ccod=15 "&_
							" and a.tcom_ccod=b.tcom_ccod "&_
							" and a.inst_ccod=b.inst_ccod "&_
							" And a.comp_ndocto=b.comp_ndocto "&_
							" And a.ecom_ccod=1 "
		
		'response.Write("<br>"&sql_examen_pagado)
		v_saldo_examen=conexion.consultaUno(sql_examen_pagado)
	'response.End()	
		if v_saldo_examen>0 or isnull(v_saldo_examen) then
			v_anula_edicion=1 ' no ha pagado todo
				sql_post_ncorr	="Select post_ncorr from postulantes where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'"
				v_post_ncorr	=conexion.consultaUno(sql_post_ncorr)
				sql_paga_o_no="Select count(*) from postulantes where cast(post_ncorr as varchar)='"&v_post_ncorr&"' and post_bpaga='N'"
				'response.Write(sql_paga_o_no)
				v_paga=conexion.consultaUno(sql_paga_o_no)
					if (v_paga = 1) then
						v_anula_edicion=0 ' El alumno esta exento de pago
					end if
		end if

	end if
	if f_alumno.NroFilas = 0 then
		f_botonera.AgregaBotonParam "siguiente", "deshabilitado", "TRUE"
	end if
	
end if
%>
<%'response.End()
'---------------------------modificaciones nuevos filtros-------------------------------------------------
usuario=negocio.ObtenerUsuario()

pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")

set f_sedes = new CFormulario
f_sedes.Carga_Parametros "tabla_vacia.xml", "tabla"
f_sedes.Inicializar conexion
consulta_sedes = "select distinct b.sede_tdesc as tdesc,b.sede_ccod as ccod from ofertas_academicas a, sedes b where cast(peri_ccod as varchar)='"&v_peri_ccod&"' and a.sede_ccod=b.sede_ccod "
f_sedes.Consultar consulta_sedes
f_sedes.agregacampoCons "sede_ccod",sede_ccod
cantidad_sedes=f_sedes.nroFilas
'f_sedes.Siguiente

set f_carreras = new CFormulario
f_carreras.Carga_Parametros "tabla_vacia.xml", "tabla"
f_carreras.Inicializar conexion
consulta_carreras = "Select distinct c.carr_ccod,c.carr_tdesc" & vbCrLf &_ 
                    " from ofertas_academicas a, especialidades b,carreras c" & vbCrLf &_ 
					" where cast(a.sede_ccod as varchar)='"&sede_ccod&"'" & vbCrLf &_ 
                    " and a.post_bnuevo='S'" & vbCrLf &_ 
                    " and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
                    " and a.espe_ccod=b.espe_ccod" & vbCrLf &_
					" and a.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
                    " and b.carr_ccod=c.carr_ccod" 
             
if sede_ccod="" then
consulta_carreras=consulta_carreras & " and 1=2"
end if
consulta_carreas=consulta_carreras & " order by carr_tdesc"
'response.Write("<pre>"&consulta_carreras&"</pre>")					  
f_carreras.Consultar consulta_carreras
cantidad_carreras=f_carreras.nroFilas
'---------------------------------------------------------------------------------------------------------
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
/*function irA(parametro){
pagado=<%=v_anula_edicion%>;
//pagado=1 -> entonces el alumno si ha pagado el examen
	if (pagado==1){
		alert("El alumno aun no ha cancelado el pago para poder rendir el examen de admision");
	}else{
		window.open(parametro,'notas','resizable,scrollbars');
	}
}
*/
function detalle(deuda,exento,ofer_paga,q_pers_nrut,post_ncorr,ofer_ncorr){
	//alert("DEuda:"+deuda+" -> exento:"+exento+" Oferta:"+ofer_paga);
	//deuda= 0 pagado, -1 sin cargo,>0 con deuda
v_url="edita_examen_postulante.asp?q_pers_nrut="+q_pers_nrut+"&post_ncorr="+post_ncorr+"&ofer_ncorr="+ofer_ncorr;	
	
	if ((deuda > 0) && (exento==0) && (ofer_paga==1)){ // tiene deuda y no esta exento y la carrera a la que postula cobra, debe pagar
		alert("El alumno aun no ha cancelado el pago para poder rendir el examen de admision");
	}else if (exento==1){ //esta exento de pago
		//alert("Esta exento del pago, porque no necesita pagar");
		window.open(v_url,"examen","resizable,width=800,height=400");
	}else if ((deuda == 0) && (exento==0)){ // no tiene deuda y no esta exento, puede rendir examne
		//alert("Esta exento del pago porque ya pago");
		window.open(v_url,"examen","resizable,width=800,height=400");
	}else if ((deuda == -1) && (ofer_paga==0)){ // no tiene cargo y su carrera no paga , esta bien... pasa
		//alert("El postulo a una carrera que no necesita pagar");
		window.open(v_url,"examen","resizable,width=800,height=400");
	}else if ((deuda > 0) && (ofer_paga==0)){ // si tiene deuda pero no corresponde a la carrera selecionada
		window.open(v_url,"examen","resizable,width=800,height=400");
	}else if (deuda == -1){ // no tiene cargo , no esta exento
		alert(" El alumno no presenta cargos por concepto de pago de examen y no esta exento de este pago.\n No puede ser ingresado su examen en esta condición a menos que sea eximido de este pago.");
	}
	
}
//edita_examen_postulante.asp?q_pers_nrut=%q_pers_nrut%&amp;post_ncorr=%post_ncorr%&amp;ofer_ncorr=%ofer_ncorr%
function filtrarFacultades(formulario)
{
formulario.paso.value="";
formulario.method="get";
formulario.action="busca_examen_postulante.asp";
formulario.submit();
}
function filtrarCarreras(formulario)
{
formulario.paso.value="";
formulario.method="get";
formulario.action="busca_examen_postulante.asp";
formulario.submit();
}
function enviar(formulario)
{
document.buscador.paso.value="1";
document.buscador.method="get";
document.buscador.action="busca_examen_postulante.asp";
document.buscador.submit();
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="97%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
			    <input type="hidden" name="paso" value="">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                    <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="99"><div align="left"><strong>R.U.T. Alumno</strong></div></td>
						<td width="23"><div align="center">:</div></td>
						<td width="385"><%f_busqueda.DIbujaCampo("pers_nrut")%> - <%f_busqueda.DibujaCampo("pers_xdv")%> <%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td>
						</tr>
					    <tr>
                        <td width="99"><div align="left"><strong>Sede </strong></div></td>
                        <td width="23"><div align="center">:</div></td>
                        <td width="385"><%'f_sedes.DibujaCampo("sede_ccod")%> 
						               <select name="sede" onChange="filtrarFacultades(this.form);">
									   <%If cantidad_sedes>"0" then%>
						               <option value="">Seleccione una sede</option>
						               <%while f_sedes.siguiente
									       ccod = f_sedes.obtenervalor("ccod")
										   tdesc= f_sedes.obtenervalor("tdesc")
										   		if cstr(ccod)=cstr(sede_ccod) then%>
								           			<option value="<%=ccod%>" selected><%=tdesc%></option>
										   		<%else%>
										   			<option value="<%=ccod%>"><%=tdesc%></option>		
										  		 <%end if
										   wend
										   else%>
										  <option value="">No existen sedes Disponibles</option> 
										  <%end if%>
						                </select>
						</td>				
					  </tr>	
                       <tr>
                        <td><div align="left"><strong>Carrera </strong></div></td>
                        <td width="23"><div align="center">:</div></td>
                        <td><%'f_carreras.DibujaCampo("carr_ccod")%> 
						    <select name="carrera" onChange="filtrarCarreras(this.form);">
									   <%If cantidad_carreras>"0" then%>
						               <option value="">Seleccione una Carrera</option>
						               <%while f_carreras.siguiente
									       ccod3 = f_carreras.obtenervalor("carr_ccod")
										   tdesc3= f_carreras.obtenervalor("carr_tdesc")
										   		if cstr(ccod3)=cstr(carr_ccod) then%>
								           			<option value="<%=ccod3%>" selected><%=tdesc3%></option>
										   		<%else%>
										   			<option value="<%=ccod3%>"><%=tdesc3%></option>		
										  		 <%end if
										   wend
										   else%>
										  <option value="">No existen Carreras Disponibles</option> 
										  <%end if%>
						    </select>
						</td>	
                      </tr>
					  <tr>
                        <td><div align="left"><strong>Jornada </strong></div></td>
                        <td width="23"><div align="center">:</div></td>
                        <td><%'f_carreras.DibujaCampo("carr_ccod")%> 
						    <select name="jornada" onChange="filtrarCarreras(this.form);">
							<%if jorn_ccod="" then%>
							<option value="" selected>Seleccione una Jornada</option>
							<%else%>
							<option value="">Seleccione una Jornada</option>
							<%end if%>
							<%if jorn_ccod="1" then%>
 						    <option value="1" selected>DIURNA</option>
							<%else%>
							<option value="1">DIURNA</option>
							<%end if%>
							<%if jorn_ccod="2" then%>
							<option value="2"selected>VESPERTINA</option>
							<%else%>
							<option value="2">VESPERTINA</option>
							<%end if%>
							</select>
						</td>	
                      </tr>
                    </table>
                  </div></td>
                  <td width="19%"><div align="center"><%f_botonera.DibujaBoton("buscar2")%></div></td>
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
	<table width="97%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
			  <input type="hidden" name="act_antecedentes" value="S">
                <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Postulante"%>
                      <br>
                      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
						   <td><strong>Cantidad Encontrados :&nbsp;&nbsp;</strong><%=cantidad_encontrados%>&nbsp; Alumnos
						   </td>
						</tr>
						<tr>
                          <td><div align="right">P&aacute;gina:<%f_alumno.accesopagina%></div></td>
                        </tr>
					    <tr>
                          <td><div align="center"><%f_alumno.DibujaTabla%></div></td>
                        </tr>
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
            <td width="9%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="left"><%f_botonera.DibujaBoton("salir")%></div></td>
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

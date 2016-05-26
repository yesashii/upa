<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 150000 

set pagina = new CPagina
pagina.Titulo = "Alumnos con CAE"



q_taca_ccod	=	request.QueryString("taca_ccod")
q_anos_ccod	= 	request.querystring("anos_ccod")
nro_t		= 	request.querystring("nro_t")
 
Response.AddHeader "Content-Disposition", "attachment;filename=alumnos_con_cae.xls"
Response.ContentType = "application/vnd.ms-excel"

'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"


if q_taca_ccod<>"" then
	filtro_ingresa	=	"	and a.taca_ccod="&q_taca_ccod&""
	if q_taca_ccod=1 then
		filtro_sga		=	"	and scc.socc_brenovante=2"
	else
		filtro_sga		=	"	and scc.socc_brenovante=1"
	end if
end if

'---------------------------------------------------------------------------------------------------

set formulario 		= 		new cFormulario
formulario.carga_parametros	"tabla_vacia.xml",	"tabla"


	  if nro_t="" then
	  	nro_t=1
	  end if

select case (nro_t)
		case 1:

			consulta= "select distinct protic.obtener_rut(b.pers_ncorr) rut_alumno,b.pers_tnombre,b.pers_tape_paterno, b.pers_tape_materno, " & vbCrlf & _ 
						"	isnull(a.arancel_solicitado,0) as monto_solicitado, c.nom_carrera_ing as carrera, d.taca_tdesc as tipo_cae " & vbCrlf & _ 
						"	from ufe_alumnos_cae a  " & vbCrlf & _ 
						"	join personas b " & vbCrlf & _ 
						"		on a.RUT=b.pers_nrut  " & vbCrlf & _ 
						"	join ufe_carreras_ingresa c " & vbCrlf & _ 
						"		 on a.CARRERA=c.car_ing_ncorr " & vbCrlf & _
						"	join ufe_tipo_alumnos_cae d " & vbCrlf & _
						"		on a.taca_ccod=d.taca_ccod " & vbCrlf & _						 
						"	where a.anos_ccod="&q_anos_ccod&" " & vbCrlf & _ 
						" "&filtro_ingresa&" "& vbCrlf & _ 
						" order by b.pers_tape_paterno desc "	
		
		case 2:
		
			consulta=   "select protic.obtener_rut(b.pers_ncorr) rut_alumno,b.pers_tnombre,b.pers_tape_paterno,  " & vbCrlf & _
						" b.pers_tape_materno, isnull(scc.socc_mmonto_solicitado,0) as monto_solicitado, " & vbCrlf & _
						" protic.obtener_nombre_carrera(oa.ofer_ncorr,'C') as carrera,case scc.socc_brenovante when 1 then 'RENOVANTE' else 'LICITADO' end  as tipo_cae " & vbCrlf & _
						" from solicitud_credito_cae scc  " & vbCrlf & _
						" join alumnos al " & vbCrlf & _
						"	on scc.post_ncorr=al.POST_NCORR " & vbCrlf & _
						"	and al.emat_ccod in (1) " & vbCrlf & _
						" "&filtro_sga&" "& vbCrlf & _ 
						" join ofertas_academicas oa " & vbCrlf & _
						"	on al.ofer_ncorr=oa.ofer_ncorr " & vbCrlf & _
						"	and oa.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&q_anos_ccod&") " & vbCrlf & _
						" join personas b " & vbCrlf & _
						"	on al.PERS_NCORR=b.PERS_NCORR " & vbCrlf & _ 
						" order by b.pers_tape_paterno desc "	
						
		case 3:
			
			consulta= "select distinct protic.obtener_rut(b.pers_ncorr) rut_alumno,b.pers_tnombre,b.pers_tape_paterno, b.pers_tape_materno, " & vbCrlf & _ 
						"	isnull(a.arancel_solicitado,0) as monto_solicitado, c.nom_carrera_ing as carrera, d.taca_tdesc as tipo_cae " & vbCrlf & _ 
						"	from ufe_alumnos_cae a  " & vbCrlf & _ 
						"	join personas b " & vbCrlf & _ 
						"		on a.RUT=b.pers_nrut  " & vbCrlf & _ 
						"	join ufe_carreras_ingresa c " & vbCrlf & _ 
						"		 on a.CARRERA=c.car_ing_ncorr " & vbCrlf & _
						"	join ufe_tipo_alumnos_cae d " & vbCrlf & _
						"		on a.taca_ccod=d.taca_ccod " & vbCrlf & _						 
						"	where a.anos_ccod="&q_anos_ccod&" " & vbCrlf & _
						" "&filtro_ingresa&" "& vbCrlf & _  
						"	and rut not in ( " & vbCrlf & _ 
						"				select distinct b.pers_nrut " & vbCrlf & _ 
						"				from solicitud_credito_cae scc  " & vbCrlf & _ 
						"				join alumnos al " & vbCrlf & _ 
						"					on scc.post_ncorr=al.POST_NCORR " & vbCrlf & _ 

						"					and al.emat_ccod in (1) " & vbCrlf & _
						"				join ofertas_academicas oa " & vbCrlf & _ 
						"					on al.ofer_ncorr=oa.ofer_ncorr " & vbCrlf & _ 
						"					and oa.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&q_anos_ccod&") " & vbCrlf & _ 
						"				join personas b " & vbCrlf & _ 
						"					on al.PERS_NCORR=b.PERS_NCORR " & vbCrlf & _ 
						"	) " & vbCrlf & _ 
						" order by b.pers_tape_paterno desc "	

		case 4:

			consulta=   "select protic.obtener_rut(b.pers_ncorr) rut_alumno,b.pers_tnombre,b.pers_tape_paterno,  " & vbCrlf & _
						" b.pers_tape_materno, isnull(scc.socc_mmonto_solicitado,0) as monto_solicitado, " & vbCrlf & _
						" protic.obtener_nombre_carrera(oa.ofer_ncorr,'C') as carrera, case scc.socc_brenovante when 1 then 'RENOVANTE' else 'LICITADO' end  as tipo_cae " & vbCrlf & _
						" from solicitud_credito_cae scc  " & vbCrlf & _
						" join alumnos al " & vbCrlf & _
						"	on scc.post_ncorr=al.POST_NCORR " & vbCrlf & _
						"	and al.emat_ccod in (1) " & vbCrlf & _
						" "&filtro_sga&" "& vbCrlf & _
						" join ofertas_academicas oa " & vbCrlf & _
						"	on al.ofer_ncorr=oa.ofer_ncorr " & vbCrlf & _
						"	and oa.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&q_anos_ccod&") " & vbCrlf & _
						" join personas b " & vbCrlf & _
						"	on al.PERS_NCORR=b.PERS_NCORR " & vbCrlf & _
						" where b.pers_nrut not in ( " & vbCrlf & _
						"					select distinct pers_nrut " & vbCrlf & _
						"					from ufe_alumnos_cae a  " & vbCrlf & _
						"					join personas b " & vbCrlf & _
						"						on a.RUT=b.pers_nrut  " & vbCrlf & _
						"					where a.anos_ccod="&q_anos_ccod&"  " & vbCrlf & _
						" ) "& vbCrlf & _
						" order by b.pers_tape_paterno desc "	

		case 5:
		
			consulta="select distinct tabla_1.rut_alumno, tabla_1.pers_tnombre,tabla_1.pers_tape_paterno,tabla_1.pers_tape_materno,tabla_1.tipo_cae as tipo_ingresa,tabla_2.tipo_cae as tipo_sga, " & vbCrlf & _
						"	tabla_1.monto_solicitado as monto_solictado_1,tabla_1.carrera as carrera_1, tabla_2.monto_solicitado as monto_solicitado_2,tabla_2.carrera as carrera_2   " & vbCrlf & _
						"	from  " & vbCrlf & _
						"	(select distinct protic.obtener_rut(b.pers_ncorr) rut_alumno,b.pers_tnombre,b.pers_tape_paterno, b.pers_tape_materno, isnull(a.arancel_solicitado,0) as monto_solicitado, c.nom_carrera_ing as carrera, d.taca_tdesc as tipo_cae " & vbCrlf & _
						"	from ufe_alumnos_cae a  " & vbCrlf & _
						"	join personas b " & vbCrlf & _
						"		on a.RUT=b.pers_nrut  " & vbCrlf & _
						" "&filtro_ingresa&" "& vbCrlf & _
						"	join ufe_carreras_ingresa c " & vbCrlf & _
						"		 on a.CARRERA=c.car_ing_ncorr " & vbCrlf & _
						"	join ufe_tipo_alumnos_cae d " & vbCrlf & _
						"		on a.taca_ccod=d.taca_ccod " & vbCrlf & _
						"	where a.anos_ccod="&q_anos_ccod&") as tabla_1  " & vbCrlf & _
						"	join  " & vbCrlf & _
						"	(select protic.obtener_rut(b.pers_ncorr) rut_alumno,b.pers_tnombre,b.pers_tape_paterno, b.pers_tape_materno, isnull(scc.socc_mmonto_solicitado,0) as monto_solicitado, " & vbCrlf & _
						"	protic.obtener_nombre_carrera(oa.ofer_ncorr,'C') as carrera,case scc.socc_brenovante when 1 then 'RENOVANTE' else 'LICITADO' end  as tipo_cae " & vbCrlf & _
						"	from solicitud_credito_cae scc  " & vbCrlf & _
						"	join alumnos al " & vbCrlf & _
						"		on scc.post_ncorr=al.POST_NCORR " & vbCrlf & _
						"		and al.emat_ccod in (1) " & vbCrlf & _
						" "&filtro_sga&" "& vbCrlf & _ 
						"	join ofertas_academicas oa " & vbCrlf & _
						"		on al.ofer_ncorr=oa.ofer_ncorr " & vbCrlf & _
						"		and oa.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&q_anos_ccod&") " & vbCrlf & _
						"	join personas b " & vbCrlf & _
						"		on al.PERS_NCORR=b.PERS_NCORR) as tabla_2 " & vbCrlf & _
						"	on tabla_1.rut_alumno =tabla_2.rut_alumno " & vbCrlf & _
						" order by tabla_1.pers_tape_paterno desc "																	
		
	end select	

 
'response.write "<pre>"&consulta&"</pre>"
'response.end()
			

formulario.inicializar		conectar
formulario.consultar 		consulta
'response.end()



%>
<html>
<head>
<title><%=pagina.Titulo%></title>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
                      
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td>
    <br/>
    <% 
    select case (nro_t)
    case 1:
    %>
        <font>Alumnos CAE segun informa Ingresa</font>
        <br/>
      <%case 2:%>
        <font>Alumnos CAE que hicieron solicitud SGA</font>
        <br/>
      <%case 3:%>
        <font>COMPARATIVA: Alumnos Ingresa que no solicitaron en SGA</font>
        <br/>
      <%case 4:%>
        <font>COMPARATIVA: Alumnos solicitan en SGA y no se figuran en Ingresa</font>
        <br/>
      <%case 5:%>
        <font>COMPARATIVA: Alumnos conciden con ambas solicitudes </font>
        <br/>
      <% end select %>
    <br/>

<% if nro_t<>5 then %>
    <table width="100%" border="1">
      <tr>
        <td width="14%"><div align="up"><strong>Rut Alumno</strong></div></td>
        <td width="7%"><div align="center"><strong>Nombre Alumno</strong></div></td>
        <td width="24%"><div align="center"><strong>ap paterno</strong></div></td>
        <td width="18%"><div align="center"><strong>ap materno</strong></div></td>
         <td width="7%"><div align="center"><strong>Monto</strong></div></td>
         <td width="7%"><div align="center"><strong>Carrera</strong></div></td>
         <td width="8%"><div align="center"><strong>Tipo Cae</strong></div></td>
      </tr>
      <%  while formulario.Siguiente %>
      <tr>
        <td><div align="left"><%=formulario.ObtenerValor("rut_alumno")%></div></td>
        <td><div align="left"><%=formulario.ObtenerValor("pers_tnombre")%></div></td>
        <td><div align="left"><%=formulario.ObtenerValor("pers_tape_paterno")%></div></td>
        <td><div align="left"><%=formulario.ObtenerValor("pers_tape_materno")%></div></td>
        <td><div align="left"><%=formulario.ObtenerValor("monto_solicitado")%></div></td>
        <td><div align="left"><%=formulario.ObtenerValor("carrera")%></div></td>
        <td><div align="left"><%=formulario.ObtenerValor("tipo_cae")%></div></td>
      </tr>
      <%  wend %>
    </table>
<%else%>
    <table width="100%" border="1">
      <tr>
        <td width="14%"><div align="up"><strong>Rut Alumno</strong></div></td>
        <td width="7%"><div align="center"><strong>Nombre Alumno</strong></div></td>
        <td width="24%"><div align="center"><strong>ap paterno</strong></div></td>
        <td width="18%"><div align="center"><strong>ap materno</strong></div></td>
         <td width="7%"><div align="center"><strong>Monto Ingresa</strong></div></td>
         <td width="7%"><div align="center"><strong>Monto SGA</strong></div></td>
         <td width="7%"><div align="center"><strong>Carrera Ingresa</strong></div></td>
         <td width="7%"><div align="center"><strong>Carrera SGA</strong></div></td>
         <td width="8%"><div align="center"><strong>Tipo Cae-Ingresa</strong></div></td>
         <td width="8%"><div align="center"><strong>Tipo Cae-SGA</strong></div></td>
      </tr>
      <%  while formulario.Siguiente %>
      <tr>
        <td><div align="left"><%=formulario.ObtenerValor("rut_alumno")%></div></td>
        <td><div align="left"><%=formulario.ObtenerValor("pers_tnombre")%></div></td>
        <td><div align="left"><%=formulario.ObtenerValor("pers_tape_paterno")%></div></td>
        <td><div align="left"><%=formulario.ObtenerValor("pers_tape_materno")%></div></td>
        <td><div align="left"><%=formulario.ObtenerValor("monto_solictado_1")%></div></td>
        <td><div align="left"><%=formulario.ObtenerValor("monto_solictado_2")%></div></td>
		<td><div align="left"><%=formulario.ObtenerValor("carrera_1")%></div></td>
        <td><div align="left"><%=formulario.ObtenerValor("carrera_2")%></div></td>
        <td><div align="left"><%=formulario.ObtenerValor("tipo_ingresa")%></div></td>
        <td><div align="left"><%=formulario.ObtenerValor("tipo_sga")%></div></td>
      </tr>
      <%  wend %>
    </table>
<%end if%>

    </td>
      </tr>
    </table>
  
</body>
</html>

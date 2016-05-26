<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
pers_nrut = Request.QueryString("b[0][pers_nrut]")
pers_xdv = Request.QueryString("b[0][pers_xdv]")
codigo = request.QueryString("b[0][codigo_activacion]")
q_pers_nrut=pers_nrut
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "adm_estado_alumnos.xml", "botonera"

set errores 	= new cErrores

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "adm_estado_alumnos.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select '' "
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", pers_xdv

pers_ncorr = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")
cant_pers_ncorr = conexion.consultaUno("select count(*) from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")
'response.Write("pers_ncorr "&pers_ncorr)
if cant_pers_ncorr <> "0" and pers_nrut <> "" then
	tiene_certificado = conexion.consultaUno("select count(*) from certificados_online where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cod_activacion='"&codigo&"'")
    if tiene_certificado = "0" then 
		mensaje_error = "No existe una solicitud de certificado para este rut con este código de validación, haga el favor de revisar los datos ingresados."
	else
		es_activo = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from certificados_online where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cod_activacion='"&codigo&"' and convert(datetime,protic.trunc(getDate()),103) <= convert(datetime,protic.trunc(fecha_vencimiento),103)")
	    if es_activo = "N" then 
			vencimiento = conexion.consultaUno("select protic.trunc(fecha_vencimiento) from certificados_online where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cod_activacion='"&codigo&"'")
		    mensaje_error = "El certificado solicitado pierde su validez ya que su fecha de vencimiento es "&vencimiento
		else
		    mensaje_error = ""
		end if
	end if	
elseif cant_pers_ncorr= "0" and pers_nrut <> "" then
	mensaje_error = "No existe registros de esta persona en nuestros sistemas."
end if

if es_activo = "S" then 
	carr_ccod = conexion.consultaUno("select carr_ccod from certificados_online where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cod_activacion='"&codigo&"'")
	tdes_ccod = conexion.consultaUno("select tdes_ccod from certificados_online where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cod_activacion='"&codigo&"'")
	c_vencimiento = " select protic.trunc(fecha_vencimiento) " & vbCrLf &_
			 " from certificados_online " & vbCrLf &_
			 " where cast(pers_ncorr as varchar)='"&pers_ncorr&"'  " & vbCrLf &_
		     " and carr_ccod ='"&carr_ccod&"' " & vbCrLf &_
			 " and cast(tdes_ccod as varchar)='"&tdes_ccod&"' " & vbCrLf &_
			 " and convert(datetime,protic.trunc(getDate()),103) <= convert(datetime,protic.trunc(fecha_vencimiento),103)"
	vencimiento = conexion.consultaUno(c_vencimiento) 
    if (tdes_ccod = "5" or tdes_ccod = "1" or tdes_ccod = "4" or tdes_ccod = "9" or tdes_ccod = "10" or tdes_ccod = "11" or tdes_ccod = "12" or tdes_ccod = "13" or tdes_ccod = "19") then
		motivo = conexion.consultaUno("select protic.initcap(tdes_tdesc) from tipos_descripciones where cast(tdes_ccod as varchar)='"&tdes_ccod&"'")
		resto_mensaje= " a petici&oacute;n del (la) interesado(a) para solicitar "&motivo&"."
	elseif (tdes_ccod = "6" or tdes_ccod = "7" or tdes_ccod = "8" or tdes_ccod = "14" or tdes_ccod = "16" or tdes_ccod = "18") then
		motivo = conexion.consultaUno("select protic.initcap(tdes_tdesc) from tipos_descripciones where cast(tdes_ccod as varchar)='"&tdes_ccod&"'")
		resto_mensaje= " a petici&oacute;n del (la) interesado(a) para ser presentado en "&motivo&"."
	elseif tdes_ccod = "2" then
		resto_mensaje= " a petici&oacute;n del (la) interesado(a) para ser presentado en Cant&oacute;n de Reclutamiento."
	elseif (tdes_ccod = "15" or tdes_ccod = "17")then
		motivo = conexion.consultaUno("select protic.initcap(tdes_tdesc) from tipos_descripciones where cast(tdes_ccod as varchar)='"&tdes_ccod&"'")
		resto_mensaje= " a petici&oacute;n del (la) interesado(a) para "&motivo&"."	
	end if
	
if tdes_ccod="99" then 
	certificado_dae="S"	
	pers_ncorr=conexion.ConsultaUno("select pers_ncorr from personas where pers_nrut="&q_pers_nrut&"")
	q_peri_ccod=218
			set f_datos_antecedentes = new CFormulario
			 f_datos_antecedentes.Carga_Parametros "tabla_vacia.xml", "tabla" 
			 f_datos_antecedentes.Inicializar conexion
			
								
							 selec_antecedentes=	"select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,"& vbCrLf &_
								"pers_nrut as rut,pers_xdv as dv,"& vbCrLf &_
								"upper(protic.obtener_f_nacimiento_escrita(pers_nrut))as fnacimiento,"& vbCrLf &_
								"pers_temail,"& vbCrLf &_
								"pers_tcelular,"& vbCrLf &_
								"(select upper(dire_tcalle)+' '+dire_tnro from direcciones where pers_ncorr=a.pers_ncorr and tdir_ccod=1)as direccion,(select ciud_tdesc from ciudades cc where cc.ciud_ccod=c.ciud_ccod)as comuna ,"& vbCrLf &_
								"(select sexo_tdesc from sexos bb where a.sexo_ccod=bb.sexo_ccod )as sexo,"& vbCrLf &_
								"(select eciv_tdesc from estados_civiles aa where a.eciv_ccod=aa.eciv_ccod)as estado_civil,"& vbCrLf &_
								"(select pais_tnacionalidad from paises aa where aa.pais_ccod=a.pais_ccod)as nacionalidad,"& vbCrLf &_
								"dire_tfono,"& vbCrLf &_
								"(select ciud_tcomuna from ciudades cc where cc.ciud_ccod=c.ciud_ccod)as ciudad"& vbCrLf &_
								"from personas a, direcciones b,ciudades c "& vbCrLf &_
								"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_
								"and b.ciud_ccod=c.ciud_ccod"& vbCrLf &_
								"and a.pers_ncorr="&pers_ncorr&""& vbCrLf &_
								"and tdir_ccod in (1)"
								
								
			 f_datos_antecedentes.Consultar selec_antecedentes
			 f_datos_antecedentes.Siguiente
			 
			
			 
			   
			  matr_ncorr=conexion.ConsultaUno("Select max(matr_ncorr) from alumnos a, postulantes b,personas c where a.post_ncorr=b.post_ncorr and emat_ccod=1 and b.pers_ncorr=c.pers_ncorr and  pers_nrut="&q_pers_nrut&"")
			   
			   '---------------------------------------------obtengo los datos academicos
			   
			   set f_academico = new CFormulario
			 f_academico.Carga_Parametros "tabla_vacia.xml", "tabla" 
			 f_academico.Inicializar conexion
			 
			 
			 s_academico="select  pers_ncorr, c.carr_ccod,carr_tdesc , emat_ccod,b.jorn_ccod,facu_tdesc,(select sede_tdesc from sedes hhh where hhh.sede_ccod=b.sede_ccod) as sede,protic.ANO_INGRESO_CARRERA(a.pers_ncorr,c.carr_ccod)as anio_ingreso,a.post_ncorr"& vbCrLf &_
			",(select top 1 anos_ccod from alumnos aa,postulantes bb,periodos_academicos cc where aa.pers_ncorr=a.pers_ncorr and emat_ccod in (1)and aa.pers_ncorr=bb.pers_ncorr and bb.peri_ccod=cc.peri_ccod order by bb.peri_ccod desc)as ultimo_ano"& vbCrLf &_
			",cast(ARAN_MMATRICULA as numeric(18,0))as ARAN_MMATRICULA,cast(ARAN_MCOLEGIATURA as numeric(18,0))as ARAN_MCOLEGIATURA"& vbCrLf &_
			"from alumnos a, ofertas_academicas b,especialidades c,carreras d,areas_academicas e,facultades f,aranceles g"& vbCrLf &_
			"where a.ofer_ncorr=b.ofer_ncorr"& vbCrLf &_
			"and b.espe_ccod=c.espe_ccod"& vbCrLf &_
			"and b.peri_ccod="&q_peri_ccod&""& vbCrLf &_
			"and a.pers_ncorr="&pers_ncorr&""& vbCrLf &_
			"and c.carr_ccod=d.carr_ccod"& vbCrLf &_
			"and d.area_ccod=e.area_ccod"& vbCrLf &_
			"and e.facu_ccod=f.facu_ccod"& vbCrLf &_
			"and b.ofer_ncorr=g.ofer_ncorr"& vbCrLf &_
			"and b.aran_ncorr=g.aran_ncorr"
			
			   
			 f_academico.Consultar s_academico
			 f_academico.Siguiente
			 'response.write(s_academico)
			 
			 
			 
			  post_ncorr=f_academico.ObtenerValor("post_ncorr")
			 post_bnuevo=conexion.ConsultaUno("select post_bnuevo from postulantes where post_ncorr="&post_ncorr&"")
			 
			 if post_bnuevo ="S" then
			 lleva_cursado="CERO"
			 cursara="PRIMER "
			 else
			 lleva_cursado=""
			 end if
			 
			 
			 
			 rut=f_datos_antecedentes.ObtenerValor("rut")
			 
			 ano_ingreso=f_academico.ObtenerValor("ANO_INGRESO_CARRERA")
			ultimo_ano_cursado=f_academico.ObtenerValor("ultimo_ano")
			colegiatura=f_academico.ObtenerValor("ARAN_MCOLEGIATURA")
			matricula=f_academico.ObtenerValor("ARAN_MMATRICULA")
			carrera=f_academico.ObtenerValor("carr_tdesc")
			   jorn_ccod=f_academico.ObtenerValor("jorn_ccod")
			   if jorn_ccod="1" then
			   jorn="(D)"
			   else
			   jorn="(V)"
			   end if
			   
			  
				sede=f_academico.ObtenerValor("sede")
				v_dia_actual 	= 	Day(now())
				v_mes	= 	Month(now())
				v_anio  = 	year(now())
				Select Case (v_mes)
				Case 1:
				   v_mes_actual="Enero" 
				Case 2:
				   v_mes_actual="Febrero" 
				Case 3:
				   v_mes_actual="Marzo" 
				Case 4:
				   v_mes_actual="Abril"
				Case 5:
				   v_mes_actual="Mayo"
				Case 6:
				   v_mes_actual="Junio"
				Case 7:
				   v_mes_actual="Julio"
				Case 8:
				   v_mes_actual="Agosto"
				Case 9:
				   v_mes_actual="Septiembre"
				Case 10:
				   v_mes_actual="Octubre"
				Case 11:
				   v_mes_actual="Noviembre"
				Case 12:
				   v_mes_actual="Diciembre"  
					 
				End Select
				carr_ccod =f_academico.ObtenerValor("carr_ccod")
				tdes_ccod="99"
			'response.Write("<br/>"&carr_ccod)	
			
				c_consulta = " select case count(*) when 0 then 'N' else 'S' end " & vbCrLf &_
						 " from certificados_online " & vbCrLf &_
						 " where cast(pers_ncorr as varchar)='"&pers_ncorr&"'  " & vbCrLf &_
						 " and carr_ccod ='"&carr_ccod&"' " & vbCrLf &_
						 " and cast(tdes_ccod as varchar)='"&tdes_ccod&"' "
			
			'response.Write("<br/>"&c_consulta)
			'response.End()
			tiene_grabado = conexion.consultaUno(c_consulta)
			
			'---------------------revisamos si tiene grabado este certificado y si no l tiene se debe grabar un certificado nuevo.
			 
			
			if tiene_grabado = "N" then 
			
			set Password= new CPassword
			clave= Password.GenerarPassword(25,conexion)
			
			 codigo = "matr"&clave
			
			 vencimiento = conexion.consultaUno("select protic.trunc(getDate()+30)")
			 ceon_ncorr = conexion.consultaUno("exec obtenerSecuencia 'certificados_online'")
			 c_insert = "insert into certificados_online (ceon_ncorr, pers_ncorr, carr_ccod, tdes_ccod, fecha_emision, fecha_vencimiento, audi_tusuario, audi_fmodificacion,cod_activacion)"&_
						"values ("&ceon_ncorr&","&pers_ncorr&",'"&carr_ccod&"',"&tdes_ccod&",getDate(), (getDate() + 30), '"&pers_nrut&"', getdate(),'"&codigo&"')"
						
			 conexion.ejecutaS c_insert
			else
			c_codigo = " select ltrim(rtrim(cod_activacion)) " & vbCrLf &_
						 " from certificados_online " & vbCrLf &_
						 " where cast(pers_ncorr as varchar)='"&pers_ncorr&"'  " & vbCrLf &_
						 " and carr_ccod ='"&carr_ccod&"' " & vbCrLf &_
						 " and cast(tdes_ccod as varchar)='"&tdes_ccod&"' " & vbCrLf &_
						 " and convert(datetime,protic.trunc(getDate()),103) <= convert(datetime,protic.trunc(fecha_vencimiento),103)"
			codigo = conexion.consultaUno(c_codigo)
			end if 

rut=FormatNumber(rut,0)
matricula=FormatCurrency(matricula, 0)
colegiatura=FormatCurrency(colegiatura, 0)
	
else
certificado_dae="N"
			'response.Write(carr_ccod)
			consulta_jornada = " select top 1 e.jorn_tdesc from personas a, alumnos b, ofertas_academicas c, especialidades d,jornadas e " & vbCrLf &_
					  " where cast(a.pers_nrut as varchar)='"&pers_nrut&"' " & vbCrLf &_
					  " and a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
					  " and b.ofer_ncorr=c.ofer_ncorr " & vbCrLf &_
					  " and c.espe_ccod=d.espe_ccod " & vbCrLf &_
					  " and c.jorn_ccod=e.jorn_ccod " & vbCrLf &_
					  " and cast(d.carr_ccod as varchar)='"&carr_ccod&"'  and emat_ccod = 1 " & vbCrLf &_
					  " order by peri_ccod desc"
			
			
			consulta_sede= " select top 1 e.sede_tdesc from personas a, alumnos b, ofertas_academicas c, especialidades d,sedes e " & vbCrLf &_
					  " where cast(a.pers_nrut as varchar)='"&pers_nrut&"' " & vbCrLf &_
					  " and a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
					  " and b.ofer_ncorr=c.ofer_ncorr " & vbCrLf &_
					  " and c.espe_ccod=d.espe_ccod " & vbCrLf &_
					  " and c.sede_ccod=e.sede_ccod " & vbCrLf &_
					  " and cast(d.carr_ccod as varchar)='"&carr_ccod&"'   and emat_ccod = 1 " & vbCrLf &_
					  " order by peri_ccod desc"
			
			nombre = conexion.consultaUno("select cast(pers_tnombre as varchar) + ' ' + cast(pers_tape_paterno as varchar) + ' ' + cast(pers_tape_materno as varchar) from personas where cast(pers_nrut as varchar)='" & pers_nrut & "' ")
			rut = conexion.consultaUno("select protic.format_rut('"&pers_nrut&"')")
			carrera = conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar)='" & carr_ccod & "' ")
			jornada = conexion.consultaUno(consulta_jornada)
			nombre_sede = conexion.consultaUno(consulta_sede)
			tcar_ccod = conexion.consultaUno("select tcar_ccod from carreras where cast(carr_ccod as varchar)='" & carr_ccod & "' ")
			
			'consulta_fecha = " select cast(datePart(day,getDate()) as varchar)+ ' de ' + " & vbCrLf &_
						'	 " case datePart(month,getDate()) when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' " & vbCrLf &_
						'	 " when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' " & vbCrLf &_
						'	 " when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' end + ' de ' +  " & vbCrLf &_
						'	 " cast(datePart(year,getDate()) as varchar) as fecha_01"
							 
			consulta_fecha = "  select cast(datePart(day,fecha_emision) as varchar)+ ' de ' + " & vbCrLf &_
							 "  case datePart(month,fecha_emision) when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' " & vbCrLf &_
							 "  when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' " & vbCrLf &_
							 "  when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' end " & vbCrLf &_
							 "  + ' de ' + cast(datePart(year,fecha_emision) as varchar) as fecha_01 " & vbCrLf &_
							 "  from certificados_online " & vbCrLf &_
							 "  where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cod_activacion='"&codigo&"'"				 
			'response.Write(consulta_fecha)
			fecha_01 = conexion.consultaUno(consulta_fecha)
			fecha_01 = "Santiago, "&fecha_01
			'------------------------------------ configuramos mensaje de salida para el alumno de acuerdo a su estado---------------
			consulta_ultimo_estado= " select top 1 emat_ccod from alumnos a, ofertas_academicas b, especialidades c " & vbCrLf &_
									" where a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
									" and b.espe_ccod=c.espe_ccod " & vbCrLf &_
									" and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'  and emat_ccod= 1  " & vbCrLf &_
									" and c.carr_ccod='"&carr_ccod&"' " & vbCrLf &_  
									" order by peri_ccod desc,a.audi_fmodificacion desc"
			estado=	conexion.consultaUno(consulta_ultimo_estado)					
			'response.Write(estado)
			'-------------------------Debemos ver si el alumno tiene matricula para el periodo solicitado
			consulta_matricula = "select count(*) from alumnos a, ofertas_Academicas b where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr and cast(b.peri_ccod as varchar)='214' and a.emat_ccod = 1 "
			
			tiene_matricula = conexion.consultaUno(consulta_matricula)
			
			'response.Write(consulta_matricula)
			if tcar_ccod <> "2" then
				
				if estado = "8" then
					mensaje = "Es alumno(a) Titulado(a)"	
				else
					if estado= "2" or estado="3" or estado="5" or estado="6" or estado="9" or estado= "10" or tiene_matricula="0" then
						mensaje = "Fue Alumno(a)"
					else
						mensaje = "Es Alumno(a)"
					end if
				end if	
			else
				if estado = "8" then
					mensaje = "Se encuetra Graduado(a) "	
				else
					if estado= "2" or estado="3" or estado="5" or estado="6" or estado="9" or estado= "10" or tiene_matricula="0" then
						mensaje = "Fue Alumno(a)"
					else
						mensaje = "Es Alumno(a)"
					end if
				end if	
			
			end if
			
			
			detalle_estado= conexion.consultaUno("Select protic.initcap(emat_tdesc) from estados_matriculas where cast(emat_ccod as varchar)='"&estado&"'")
			if estado = "1" or estado = "13" then
				mensaje = mensaje & " regular "
			'else
			'	mensaje = mensaje & detalle_estado & "(a)"
			end if	
			
			if tcar_ccod <> "2" then
				mensaje = mensaje & " de la Carrera de "
			else
				mensaje = mensaje & " de "
			end if	
			 
			end if
end if	
	'response.Write(mensaje_error)
	
%>


<html>
<head>
<title>Validación Certificados Emitidos por Internet</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
var t_busqueda;

function ValidaBusqueda()
{
	rut = document.buscador.elements["b[0][pers_nrut]"].value + '-' + document.buscador.elements["b[0][pers_xdv]"].value;
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido.');		
		document.buscador.elements["b[0][pers_xdv]"].focus();
		return false;
	}
	
	return true;	
}

function cerrar_ventana()
{
	window.close();
}
</script>

</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); ">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="72" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
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
            <td><%'pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
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
                    <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td><div align="right"><strong>R.U.T. Alumno</strong></div></td>
                        <td width="40"><div align="center"><strong>:</strong></div></td>
                        <td><%f_busqueda.DibujaCampo("pers_nrut")%> 
                          - 
                            <%f_busqueda.DibujaCampo("pers_xdv")%></td>
                      </tr>
					  <tr>
                        <td><div align="right"><strong>Código de Validación</strong></div></td>
                        <td width="40"><div align="center"><strong>:</strong></div></td>
                        <td><input type="text" name="b[0][codigo_activacion]" size="40" maxlength="50" id="TO-N" value="<%=codigo%>"></td>
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
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <br>
              <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td>&nbsp;</td>
                </tr>
				<%if mensaje_error <> ""  then %>
				<tr>
                  <td align="center"><font face="Times New Roman, Times, serif" size="+1" ><strong><%=mensaje_error%></strong></font></td>
                </tr>
				
				<%elseif es_activo = "S" and  certificado_dae = "N" then%>
				<tr>
                  <td align="center"><font face="Times New Roman, Times, serif" size="+1" >A continuación se presenta el certificado que corresponde al solicitado por el alumno bajo el código <%=codigo%>.<br> <strong>Si existe alguna diferencia con el que usted tiene en sus manos, dicho certificado pierde validez dentro de esta casa de estudios.</strong></font></td>
                </tr>
				<tr>
					<td align="center">
						<table width="100%" border="1" bordercolor="#666666" bgcolor="#FFFFFF">
							<tr valign="top">
							<td width="100%" align="center">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
							 <tr><td colspan="3">&nbsp;</td></tr>
							 <tr><td colspan="3" align="left"><table width="10%">
																<tr valign="top">
																	<td width="5%">&nbsp;</td>
																	<td width="65" height="50" align="center"><img align="middle" width="65" height="50" src="../imagenes/logo_upa.jpg"></td>
																</tr>
																<tr valign="top">
																	<td width="5%">&nbsp;</td>
																	<td align="center">Universidad Del Pacífico</td>
																</tr>
															  </table></td></tr> 
							  							  
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr> 
								<td colspan="3"><div align="center"><font size="4"><strong>CERTIFICADO DE ALUMNO</strong></font></div></td>
							  </tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr><td colspan="3"><div align="left"><font size="2"><strong>&nbsp;La Universidad del Pac&iacute;fico :</strong></font></div></td></tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr>
								  <td width="50%"><div align="left"><font size="2">&nbsp;Certifica que el(la) Sr.(ita).</font></div></td>
								  <td width="1%"><div align="center"><font size="2">:</font></div></td>
								  <td width="49%"><div align="left"><font size="2"><%=nombre%></font></div></td>	
							  </tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr>
								  <td width="50%"><div align="left"><font size="2">&nbsp;R.u.t.</font></div></td>
								  <td width="1%"><div align="center"><font size="2">:</font></div></td>
								  <td width="49%"><div align="left"><font size="2"><%=rut%></font></div></td>	
							  </tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr>
								  <td width="50%"><div align="left"><font size="2">&nbsp;<%=mensaje%></font></div></td>
								  <td width="1%"><div align="center"><font size="2">:</font></div></td>
								  <td width="49%"><div align="left"><font size="2"><%=carrera%></font></div></td>	
							  </tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr>
								  <td width="50%"><div align="left"><font size="2">&nbsp;Jornada</font></div></td>
								  <td width="1%"><div align="center"><font size="2">:</font></div></td>
								  <td width="49%"><div align="left"><font size="2"><%=jornada%></font></div></td>	
							  </tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							   <tr>
								  <td width="50%"><div align="left"><font size="2">&nbsp;Sede</font></div></td>
								  <td width="1%"><div align="center"><font size="2">:</font></div></td>
								  <td width="49%"><div align="left"><font size="2"><%=nombre_sede%></font></div></td>	
							  </tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr><td colspan="3"><div align="left"><font size="2">Se extiende el presente certificado<%=resto_mensaje%></font></div></td></tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							</table>
							<br>
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
							  <tr> 
								<td width="34%" align="center">&nbsp;</td>
								<td width="10%" align="center">&nbsp;</td>
								<td width="56%" align="center">&nbsp;</td>
							  </tr>
							  <tr> 
								<td width="34%" align="center">&nbsp;</td>
								<td width="10%" align="center">&nbsp;</td>
								<td width="56%" align="center"><img width="280" height="134" src="../imagenes/firma2.jpg"></td>
							  </tr>
								<tr> 
								<td width="34%" align="center">&nbsp;</td>
								<td width="10%" align="center">&nbsp;</td>
								<!--<td width="50%" align="center"><font size="2"><strong>ELENA ORTUZAR MU&Ntilde;OZ</strong></font></td>-->
								<td width="56%" align="center"><font size="2"><strong>JEFE OFICINA</strong></font></td>
							  </tr>
								<tr> 
								<td width="34%" align="center">&nbsp;</td>
								<td width="10%" align="center">&nbsp;</td>
								<!--<td width="50%" align="center"><font size="2"><strong>Secretaria General</strong></font></td>-->
								<td width="56%" align="center"><font size="2"><strong>REGISTRO CURRICULAR</strong></font></td>
							  </tr>
								<tr> 
								<td width="34%" align="center">&nbsp;</td>
								<td width="10%" align="center">&nbsp;</td>
								<td width="56%" align="center">&nbsp;</td>
							  </tr>
							  <tr> 
								<td colspan="3" align="center">&nbsp;</td>
							  </tr>
							  <tr> 
								<td colspan="3" align="center"><font size="1"><strong>C&oacute;digo de Validaci&oacute;n: <%=codigo%></strong></font></td>
							  </tr>
							  <tr> 
								<td colspan="3" align="center">&nbsp;</td>
							  </tr>
							  <tr> 
								<td colspan="3" align="center"><font size="-2">Para validar este certificado dir&iacute;jase a la p&aacute;gina de la Universidad:<br><a href="http://www.upacifico.cl/validacion_certificados/valida.htm" target="_blank">http://www.upacifico.cl/validacion_certificados/valida.htm</a><br>Ingrese Rut del alumno y código de validaci&oacute;n <br>(el certificado es V&aacute;lido sólo si el mostrado en pantalla de validaci&oacute;n es id&eacute;ntico al que se encuentra en su poder). <br>Este certificado es v&aacute;lido hasta el <%=vencimiento%>.</font></td>
							  </tr>
							  <tr> 
								<td colspan="3" align="center">&nbsp;</td>
							  </tr>
							  <tr> 
								<td colspan="3" align="center"><font size="-2"><strong>Santiago: </strong>Casa central: Las Condes 11.121 - Sede Lyon: Av. R. Lyon 227 - Sede Baquedano: Av. Ramón Carnicer 65. <br> <strong>Melipilla : </strong>Sede Melipilla : Andrés Bello 0383 - Mall Leyán, Av. Serrano 395, Local 13, Planta Baja. <br> <strong>Concepción: </strong>Oficina Concepción: Víctor Lamas 917, Edificio Horizonte.</font></td>
							  </tr>
							  <tr> 
								<td colspan="3" align="center">&nbsp;</td>
							  </tr>
							  <tr> 
								<td colspan="3" align="center">&nbsp;</td>
							  </tr>
							  <tr> 
								<td colspan="3" align="center"><font size="1"><%=fecha_01%></font></td>
							  </tr>
							</table>
							</td>
							</tr>
							</table>
					</td>
				</tr>	
				
				<%elseif es_activo = "S"  and certificado_dae = "S" then%>
				<tr>
                  <td align="center"><font face="Times New Roman, Times, serif" size="+1" >A continuación se presenta el certificado que corresponde al solicitado por el alumno bajo el código <%=codigo%>.<br> <strong>Si existe alguna diferencia con el que usted tiene en sus manos, dicho certificado pierde validez dentro de esta casa de estudios.</strong></font></td>
                </tr>
				<tr>
					<td align="center">
						<table width="100%" border="1" bordercolor="#666666" bgcolor="#FFFFFF">
							<tr valign="top">
							<td width="100%" align="center">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
							 <tr><td colspan="3">&nbsp;</td></tr>
							 <tr></tr> 
							  							  
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr> 
								<td colspan="3"><div align="center"><font size="4" style=""><u><strong>CERTIFICADO</strong></u></font></div></td>
							  </tr>
							  <tr><td colspan="3"><div align="center"><font size="4" style=""><u><strong>LÍNEA DE CRÉDITO EDUCACIÓN SUPERIOR</strong></u></font></div></td></tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr><td colspan="3"><div align="center"><font size="4" style=""><u><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ÍTALO GIRAUDO TORRES&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong></u></font></div></td></tr>
							  <tr><td colspan="3"><div align="center"><font size="4" style="">NOMBRE</font></div></td></tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr><td colspan="3"><div align="center"><font size="4" style=""><u><strong>VICERRECTOR DE ADMINISTRACIÓN Y FINANZAS</strong></u></font></div></td></tr>
							  <tr><td colspan="3"><div align="center"><font size="4" style=""><u><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;CARGO&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong></u></font></div></td></tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr><td colspan="3"><div align="center"><font size="4"><u><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LA UNIVERSIDAD DEL PAC&Iacute;FICO&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong></u></font></div></td></tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr width="100%">
								  <td colspan="3">
								  			<table width="93%" align="center">
												<tr>
													<td>
													<font size="2">Certifica que don (ña) <%=f_datos_antecedentes.ObtenerValor("nombre")%> Cédula de Identidad N° <%=rut%>- <%=f_datos_antecedentes.ObtenerValor("dv")%> es alumna(o) regular de la Carrera de <%=carrera%> <%=jorn%>, SEDE <%=sede%>, habiendo cursado a la fecha <%=lleva_cursado%> año.</font>													</td>
												</tr>
									  		</table>								</td>
							  </tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr>
								  <td colspan="3">
								  			<table width="93%" align="center">
												<tr>
													<td>
													<font size="2">De acuerdo a la malla curricular, debiera restarle UN AÑO Y MEDIO para egresar de la carrera</font>													</td>
												</tr>
									  		</table>								  </td>
							  </tr>
							  <tr>
								  <td colspan="3">
								  			<table width="93%" align="center">
												<tr>
													<td>
													<font size="2">Los valores correspondientes a matrícula y al arancel que el interesado deberá pagar para cursar el <%=cursara%> AÑO, durante el año académico 2010, ascienden a:  Matrícula <%=matricula%>.- y Arancel <%=colegiatura%></font>													</td>
												</tr>
									  		</table>								  </td>
							  </tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr>
								  <td colspan="3">
								  			<table width="93%" align="center">
												<tr>
													<td>
													<font size="2">En caso que dicha suma sea financiada total o parcialmente con un crédito bancario, el monto respectivo deberá ser girado en documento a nombre de: UNIVERSIDAD DEL PACIFICO,  RUT.: 71.704.700-1.</font>													</td>
												</tr>
									  		</table>								  </td>
							  </tr>
							
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr><td colspan="3">&nbsp;</td></tr>
							  <tr>
							  	<td width="4%" >&nbsp;</td>
							    <td width="44%" align="left" background="../certificados_dae/imagenes/guion.jpg"><img width="280" height="134" src="../certificados_dae/imagenes/firma.gif"></td>
								<td width="52%" align="center" valign="bottom" ><font size="2"><%=v_dia_actual%> de <%=v_mes_actual%> del <%=v_anio%></font></td>
							  </tr>
							</table>
							<br>
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
							  <tr> 
								<td width="44%" align="center">&nbsp;</td>
								<td width="8%" align="center">&nbsp;</td>
								<td width="48%" align="center">&nbsp;</td>
							  </tr>
							  <tr> 
								<td width="44%" align="center" >&nbsp;</td>
								<td width="8%" align="center">&nbsp;</td>
								<td width="48%" align="center" valign="bottom"></td>
							  </tr>
								<tr> 
								<td width="44%" align="center">&nbsp;</td>
								<td width="8%" align="center">&nbsp;</td>
								<td width="48%" align="center">&nbsp;</td>
							  </tr>
								<tr> 
								<td width="44%" align="center">&nbsp;</td>								
								<td width="8%" align="center">&nbsp;</td>
								<td width="48%" align="center">&nbsp;</td>
							  </tr>
								<tr> 
								<td width="44%" align="center">&nbsp;</td>
								<td width="8%" align="center">&nbsp;</td>
								<td width="48%" align="center">&nbsp;</td>
							  </tr>
							  <tr> 
								<td colspan="3" align="center">&nbsp;</td>
							  </tr>
							  <tr> 
								<td colspan="3" align="center"><font size="1"><strong>C&oacute;digo de Validaci&oacute;n: <%=codigo%></strong></font></td>
							  </tr>
							  <tr> 
								<td colspan="3" align="center">&nbsp;</td>
							  </tr>
							  <tr> 
								<td colspan="3" align="center"><font size="-2">Para validar este certificado dir&iacute;jase a la p&aacute;gina de la Universidad:<br><a href="http://www.upacifico.cl/validacion_certificados/valida.htm" target="_blank">http://www.upacifico.cl/validacion_certificados/valida.htm</a><br>Ingrese Rut del alumno y código de validaci&oacute;n <br>(el certificado es V&aacute;lido sólo si el mostrado en pantalla de validaci&oacute;n es id&eacute;ntico al que se encuentra en su poder).</font></td>
							  </tr>
							  <tr> 
								<td colspan="3" align="center">&nbsp;</td>
							  </tr>
							  <tr> 
								<td colspan="3" align="center">&nbsp;</td>
							  </tr>
							  <tr> 
								<td colspan="3" align="center">&nbsp;</td>
							  </tr>
							  <tr> 
								<td colspan="3" align="center">&nbsp;</td>
							  </tr>
							  <tr> 
								<td colspan="3" align="center"><font size="1"><%=fecha_01%></font></td>
							  </tr>
							</table>
							</td>
							</tr>
							</table>
					</td>
				</tr>	
				<%end if%>
				<tr>
                  <td>&nbsp;</td>
                </tr>
              </table>
                </div>
              </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="11%" height="20"><div align="center">
              <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                   <td><div align="center">
                    <% f_botonera.agregaBotonParam "salir","accion","javascript"
					   f_botonera.agregaBotonParam "salir","funcion","cerrar_ventana();" 
					   f_botonera.DibujaBoton("salir")%>
                  </div></td>
				</tr>
              </table>
            </div></td>
            <td width="89%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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

<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
'for each k in request.Form()
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
ruta=request.ServerVariables("HTTP_REFERER")
'response.Write("RUTA "&request.ServerVariables("HTTP_REFERER"))
'response.End()
if esVacio(request.Form("esec[0][jorn_ccod]")) then
   jornada_temporal=1
else
   jornada_temporal=request.Form("esec[0][jorn_ccod]")
end if

set conexion1 = new cConexion
set fsecc_asig = new cFormulario
set negocio = new cnegocio


conexion1.inicializar "upacifico"
negocio.inicializa	conexion1

'conexion1.EstadoTransaccion false



function No_repetida()
		i=0
		cont=0
		dim a()
		dim b()
		for each k in request.form
			if  k <> "sede_ccod" and k <> "peri_ccod" and k <>"asig_ccod" and k <> "carr_ccod" and k <> "A.x" and k <> "E.x" and k <> "I.x" and k <> "A.y" and k <> "E.y" and k <> "I.y"  and k <> "btn_clickeado" and k <> "asig_ccod_electiva" and k <> "mall_ccod_electiva" and  k<>"insertar_electivo" and k<>"mall_ccod_asignatura" then
				c=split(k,"]") 
					if c(1)="[secc_ccod" then
						redim preserve d(cont)
						d(cont)=request.form(k)
						cont=cont+1		
					end if
			end if
		next
  
	if isObject(d) then
		for x=0 to ubound(d)-1
			temp=temp&d(x)+","
		next
		temp=temp+d(ubound(d))
	else
		temp="0"
	end if
		for each k in request.form
			if  k <> "sede_ccod" and k <> "peri_ccod" and k <>"asig_ccod" and k <> "carr_ccod" and k <> "A.x" and k <> "E.x" and k <> "I.x" and k <> "A.y" and k <> "E.y" and k <> "I.y" and k <> "btn_clickeado"  and k <> "asig_ccod_electiva" and k <> "mall_ccod_electiva" and k<>"insertar_electivo" and k<>"mall_ccod_asignatura" then
				s=split(k,"]") 
					if s(1)="[secc_tdesc" then
						redim preserve a(i)
						a(i)=request.form(k)
						i=i+1		
					end if
			end if
		next
		repetido=0
		for P=1 to i-1 
			for L=0 to P-1
				if a(P)=a(L) then
					repetido=repetido+1
				end if
			next
		next
		
		dim z()
		j = 0
	
		h="select secc_tdesc from secciones where cast(asig_ccod as varchar) = '"&asig_ccod&"' and cast(sede_ccod as varchar) = '"&sede_ccod&"' and cast(peri_ccod as varchar)= "&peri_ccod&" and cast(carr_ccod as varchar) = '"&carr_ccod&"' and secc_ccod not in ("&temp&") "
		conexion1.ejecuta (h)
		set rs = conexion1.obtenerRs
			if not rs.eof then
					while not rs.eof
					redim preserve z(j)
					z(j)=rs("secc_tdesc")
					j= j + 1
					rs.movenext
				wend
			end if
		
		repetido2=0
		
		for m=0 to  i-1 
			for n=0 to j-1
					if a(m)=z(n) then					
					repetido2=repetido2+1
					end if
			next
		next

		if repetido <> 0 or repetido2 <> 0 then
			 No_repetida=false
		else
			 No_repetida=true
		end if
		
end function


if request.form("btn_clickeado") = "1" then  insertar = "1" end if
if request.form("btn_clickeado") = "2" then  actualizar = "2" end if
if request.form("btn_clickeado") = "3" then  eliminar = "3" end if


sede_ccod = request.Form("sede_ccod")
peri_ccod = request.Form("peri_ccod")
asig_ccod = request.Form("asig_ccod")
carr_ccod = request.Form("carr_ccod")
'ruta_anterior="edicion_secc_asig.asp?sede_ccod="&sede_ccod&"&asig_ccod="&asig_ccod&"&carr_ccod="&carr_ccod&"&periodo="&peri_ccod
'response.Write(ruta_anterior)
'response.Write(sede_ccod)
'response.Write(peri_ccod)
'response.Write(asig_ccod)
'response.Write(carr_ccod)
'response.End()
'--------------------------------------------------------------------------------------------------------
insertar_electivo = Request.Form("insertar_electivo")
if insertar_electivo = "1" then
	v_mall_ccod = Request.Form("mall_ccod_electiva")
else
	v_mall_ccod = request.Form("mall_ccod_asignatura")
end if

'--------------------------------------------------------------------------------------------------------

moda_ccod = 1


if (No_repetida)  then 

		horas = cint(conexion1.consultaUno("select isnull(asig_nhoras,0) from asignaturas where cast(asig_ccod as varchar) = '" & asig_ccod & "'"))

		if not fsecc_asig.esDDMMYYYY then
			tipoFecha = "E"
		else
			tipoFecha = "E"
		end if
	
		fechaInicioClases = negocio.obtenerFechaInicio("CLASES18",tipoFecha)
		fechaTerminoClases = negocio.obtenerFechaTermino("CLASES20",tipoFecha)
		
		'response.Write("inicio "&fechaInicioClases&" termino "&fechaTerminoClases)
		'response.End()
		if insertar <> "" then
		    'response.Write("Entre al uno <br>")
			tsse_ccod = 1
			secc_ccod =  conexion1.consultauno("execute obtenersecuencia 'secciones'")
			consu="select protic.prox_secc_tdesc('" & carr_ccod & "', '" & asig_ccod & "', " & peri_ccod & ", " & sede_ccod & ")"
			'response.Write(consu)
			
			v_secc_tdesc = conexion1.ConsultaUno(consu)
			v_jornada_corta = conexion1.ConsultaUno("select jorn_tdesc_corta from jornadas where cast(jorn_ccod as varchar)= '"&jornada_temporal&"'")
			
			v_secc_tdesc = v_secc_tdesc & " ("&v_jornada_corta&")"
			'response.Write("<br>v_secc_tdesc "&v_secc_tdesc)
			'response.End()
			'--------------------------------------------------------------------------------------------------------------------
			set f_consulta = new CFormulario
			f_consulta.Carga_Parametros "consulta.xml", "consulta"
			f_consulta.Inicializar conexion1
			
			consulta = "select mall_ccod,  " & vbCrLf &_
			           "      rtrim(ltrim(cast(mall_nota_presentacion as decimal(3,1)))) as mall_nota_presentacion,  " & vbCrLf &_
					   "	  rtrim(ltrim(cast(mall_porcentaje_presentacion as decimal(3,1)))) as mall_porcentaje_presentacion, " & vbCrLf &_
					   "	  rtrim(ltrim(cast(mall_nevaluacion_minima as decimal(3,1)))) as mall_nevaluacion_minima, " & vbCrLf &_
					   "	  rtrim(ltrim(cast(mall_porcentaje_asistencia as decimal(3,1)))) as mall_porcentaje_asistencia, " & vbCrLf &_
					   "	  rtrim(ltrim(cast(mall_nota_eximicion as decimal(3,1)))) as mall_nota_eximicion, " & vbCrLf &_
					   "	  rtrim(ltrim(cast(mall_min_examen as decimal(3,1)))) as mall_min_examen " & vbCrLf &_
			           "from malla_curricular " & vbCrLf &_
					   "where cast(mall_ccod as varchar) = '" & v_mall_ccod & "'"
			'response.End()		   
			'response.Write("<pre>" & consulta & "</pre>")		   
            'response.End()
			f_consulta.Consultar consulta
			f_consulta.Siguiente
					   
			'--------------------------------------------------------------------------------------------------------------------
					   
			
			fsecc_asig.carga_parametros "parametros.xml", "4.1"
			fsecc_asig.inicializar conexion1
			fsecc_asig.creaFilaPost
			fsecc_asig.agregaCampoPost "sede_ccod", sede_ccod
			fsecc_asig.agregaCampoPost "peri_ccod", peri_ccod
			fsecc_asig.agregaCampoPost "asig_ccod", asig_ccod
			fsecc_asig.agregaCampoPost "carr_ccod", carr_ccod
			fsecc_asig.agregaCampoPost "moda_ccod", moda_ccod
			'response.Write("fecha inicio "&fechaInicioClases)
			'response.End()
			fsecc_asig.agregaCampoPost "secc_finicio_sec", fechaInicioClases
			fsecc_asig.agregaCampoPost "secc_ftermino_sec", fechaTerminoClases
			fsecc_asig.agregaCampoPost "secc_ccod", secc_ccod
			'fsecc_asig.agregaCampoPost "secc_tdesc", ""
			fsecc_asig.agregaCampoPost "secc_tdesc", v_secc_tdesc
			'fsecc_asig.agregaCampoPost "secc_ncupo", ""
			fsecc_asig.agregaCampoPost "secc_ncupo", "30"
			'fsecc_asig.agregaCampoPost "secc_nquorum", ""
			fsecc_asig.agregaCampoPost "secc_nquorum", "0"
			fsecc_asig.agregaCampoPost "jorn_ccod", "1"			
			fsecc_asig.agregaCampoPost "ssec_ncorr", ""
			fsecc_asig.agregaCampoPost "ssec_finicio_sec", fechaInicioClases
			fsecc_asig.agregaCampoPost "ssec_ftermino_sec", fechaTerminoClases
			fsecc_asig.agregaCampoPost "tsse_ccod", tsse_ccod
			fsecc_asig.agregaCampoPost "mall_ccod",request.Form("mall_ccod_asignatura")
			'fsecc_asig.agregaCampoPost "secc_nota_presentacion", f_consulta.ObtenerValor("mall_nota_presentacion")
			'fsecc_asig.agregaCampoPost "secc_porcentaje_presentacion", f_consulta.ObtenerValor("mall_porcentaje_presentacion")
			'fsecc_asig.agregaCampoPost "secc_eval_mini", f_consulta.ObtenerValor("mall_nevaluacion_minima")
			'fsecc_asig.agregaCampoPost "secc_porce_asiste", f_consulta.ObtenerValor("mall_porcentaje_asistencia")
			'fsecc_asig.agregaCampoPost "secc_nota_ex", f_consulta.ObtenerValor("mall_nota_eximicion")
			'fsecc_asig.agregaCampoPost "secc_min_examen", f_consulta.ObtenerValor("mall_min_examen")
			fsecc_asig.agregaCampoPost "secc_eximision", "S"
			
			
			'fsecc_asig.ListarPost
			fsecc_asig.mantieneTablas false
			'conexion1.EstadoTransaccion false
			'response.End()
			
	
			if request.Form("insertar_electivo")= "1" then

						set formulario = new cformulario
						formulario.carga_parametros "buscar_asignaturas_elec.xml", "f_electivos"
						formulario.inicializar conexion1
						formulario.creaFilaPost
						
						formulario.agregacampopost "secc_ccod", secc_ccod
						formulario.agregacampopost "asig_ccod", request.Form("asig_ccod_electiva")
						'response.Write("<br>2.asig_ccod "&request.Form("asig_ccod_electiva"))
						formulario.agregacampopost "mall_ccod", request.Form("mall_ccod_electiva")
						'response.Write("<br>3.mall_ccod_electiva "&request.Form("mall_ccod_electiva"))
						
						formulario.mantienetablas false
			end if
		end if
		if actualizar <> "" then
		    'response.Write("Entre al dos <br>")
		    consu="select protic.prox_secc_tdesc('" & carr_ccod & "', '" & asig_ccod & "', " & peri_ccod & ", " & sede_ccod & ")"
			'response.Write("select jorn_tdesc_corta from jornadas where cast(jorn_ccod as varchar)= '"&jornada_temporal&"'")
			v_secc_tdesc = conexion1.ConsultaUno(consu)
			v_jornada_corta = conexion1.ConsultaUno("select jorn_tdesc_corta from jornadas where cast(jorn_ccod as varchar)= '"&jornada_temporal&"'")
			
			v_secc_tdesc = v_secc_tdesc & " ("&v_jornada_corta&")"
			'response.Write("<hr>"&v_secc_tdesc&"<hr>")
			fsecc_asig.carga_parametros "parametros.xml", "4.1"
			fsecc_asig.inicializar conexion1
			fsecc_asig.procesaForm
			fsecc_asig.clonaColumnaPost "secc_ncupo","ssec_ncupo"
			fsecc_asig.clonaColumnaPost "secc_nquorum","ssec_nquorum"
			fsecc_asig.clonaColumnaPost "secc_finicio_sec", "ssec_finicio_sec"
			fsecc_asig.clonaColumnaPost "secc_ftermino_sec", "ssec_ftermino_sec"
			'fsecc_asig.agregaCampoPost "secc_tdesc",v_secc_tdesc
			fsecc_asig.mantieneTablas false
			if request.Form("insertar_electivo")="1" then
						set formulario = new cformulario
						
						formulario.carga_parametros "buscar_asignaturas_elec.xml", "f_electivos"
						formulario.inicializar conexion1
						
						formulario.procesaForm
						formulario.agregacampopost "asig_ccod", request.Form("asig_ccod_electiva")
						'response.Write("<br>4. asig_ccod_electiva "&request.Form("asig_ccod_electiva"))
						formulario.agregacampopost "mall_ccod", request.Form("mall_ccod_electiva")
						'response.Write("<br>5. mall_ccod_electiva "&request.Form("mall_ccod_electiva"))
						
						formulario.mantienetablas false
			end if
			
		end if
	 if eliminar <> "" then
	        'response.Write("Entre al tres <br>")
			fsecc_asig.carga_parametros "parametros.xml", "4.2"
			fsecc_asig.inicializar conexion1
			fsecc_asig.procesaForm
			fsecc_asig.intercambiaCampoPost "secc_ccod_paso", "secc_ccod"
			fsecc_asig.mantieneTablas false
		end if	
else 
session("mensajeError") = "Ha Ingresado una Seccion Repetida"
end if
'response.Redirect(request.ServerVariables("HTTP_REFERER"))
'conexion1.estadotransaccion false  'roolback 
'response.End()
'response.End()
response.Redirect(ruta)
%>
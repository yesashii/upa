<!-- #include file = "../biblioteca/_conexion.asp" -->
<%

carr_ccod = request.QueryString("carr_ccod")
HorasC = request.form("HorasC")
JORN_CCOD = request.QueryString("JORN_CCOD")
SEDE_CCOD = request.QueryString("SEDE_CCOD")

'response.Write(carr_ccod&"--CC<br>")
'response.Write(HorasC&"--H<br>")
'response.Write(JORN_CCOD&"--JC<br>")
'response.Write(SEDE_CCOD&"--SC<br>")

'for each x in request.form
'	response.write("<br>"&x&"->"&request.form(x))
'next
'response.Write("<br>--"&  request.Form("submit") ) 

'response.Write(request.Form("submit")&"<br>")
'response.End()

	IF request.Form("submit") = "Calcular" THEN
		set conexion = new CConexion
		conexion.Inicializar "upacifico"
		
		for each x in request.form
			if instr(x,"pers_ncorr") <> 0 then
				conexion.ejecutas (" GENERA_CONTRATOS_DOCENTES " & request.form(x) & ",164," & carr_ccod & ",'" & HorasC & "',"&SEDE_CCOD&","& JORN_CCOD)		
				'MiVar=conexion.consulta1(" GENERA_CONTRATOS_DOCENTES " & request.form(x) & ",164," & carr_ccod)
				'response.Write("exec GENERA_CONTRATOS_DOCENTES " & request.form(x) & ",164," & carr_ccod & ",'" & HorasC & "',"&SEDE_CCOD&","& JORN_CCOD)
			    'response.Flush()
			end if
		next
	END IF
'conexion.estadotransaccion false
'response.End()

	IF request.Form("submit") = "Imprimir" THEN
		for each x in request.form
			if instr(x,"pers_ncorr") <> 0 then
'				RESPONSE.Redirect("../REPORTESNET/contrato_docente.aspx?post_ncorr=1")
			end if
		next	
	END IF

'response.End()

	response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>


<%
Class CPagina
	Public Titulo

	Sub DibujarEncabezado 
		Dim salida
		
		salida = "<tr>" & vbCrLf &_		         		         
		         "<td height=""23"" nowrap background=""../imagenes/fondo_gris.gif"" height=""15"" valign=""top"" > " & vbCrLf &_
				 "    <table width=""100%""  border=""0"" cellspacing=""0"" cellpadding=""0""> " & vbCrLf &_
				 "      <tr> " & vbCrLf &_
				 "      <tr> " & vbCrLf &_
				 "      </tr> " & vbCrLf &_
				 "      <tr> " & vbCrLf &_
				 "      </tr> " & vbCrLf &_
				 "      <tr> " & vbCrLf &_
				 "      </tr> " & vbCrLf &_
				 "      <tr> " & vbCrLf &_
				 "      </tr> " & vbCrLf &_
				 "      <tr> " & vbCrLf &_
				 "      </tr> " & vbCrLf &_
				 "        <td><font color=""#FFFFFF""><a href=""../lanzadera/lanzadera.asp"" style=""color:#FFFFFF"">&nbsp; Men&uacute; </a></font>	</td> " & vbCrLf &_
				 "        <td><font color=""#FFFFFF""><a href=""../lanzadera/cerrar_sesion.asp"" style=""color:#FFFFFF"">&nbsp;- Cerrar sesión </a></font>	</td> " & vbCrLf &_
				 "        <td><font color=""#FFFFFF""><b> </b></font></td> " & vbCrLf &_
				 "        <td><div align=""right""><font color=""#FFFFFF""><b>"&Session("_nombreUsuario")&" - "&Session("_nombreSede")&" - "&Session("_nombreActividad")&" - "&Session("_nombrePeriodo")&"</b></font></div></td> " & vbCrLf &_
				 "      </tr> " & vbCrLf &_
				 "    </table> " & vbCrLf &_
				 "  </td> " & vbCrLf &_
				 "</tr>"
				 				 
		Response.Write(salida)
	End Sub
	
	
	Sub DibujarBoton(p_texto, p_accion, p_url)
		Dim salida, nombre_boton
		
		nombre_boton = "bt" & p_texto & CLng((Rnd(Second(now)) * 10000))		
		
		salida = "<table id=""" & nombre_boton & """ width=""92"" border=""0"" cellspacing=""0"" cellpadding=""0"" class=""click"" onMouseOver=""_OverBoton(this);"" onMouseOut=""_OutBoton(this);"" onClick=""_ProcesaBoton(this, '" & p_accion & "', '" & p_url & "', '" & p_parametros_adicionales & "');"">" & vbCrLf &_
		         "  <tr> " & vbCrLf &_
				 "    <td width=""7"" height=""16"" rowspan=""3""><img src=""../imagenes/botones/boton1.gif"" width=""5"" height=""16"" id=""" & nombre_boton & "c11""></td> " & vbCrLf &_
				 "    <td width=""88"" height=""2""><img src=""../imagenes/botones/boton2.gif"" width=""88"" height=""2"" id=""" & nombre_boton & "c12""></td> " & vbCrLf &_
				 "    <td width=""10"" height=""16"" rowspan=""3""><img src=""../imagenes/botones/boton4.gif"" width=""5"" height=""16"" id=""" & nombre_boton & "c13""></td>" & vbCrLf &_
				 "  </tr>" & vbCrLf &_
				 "  <tr> " & vbCrLf &_
				 "    <td height=""12"" bgcolor=""#EEEEF0"" id=""" & nombre_boton & "c21""> " & vbCrLf &_
				 "      <div align=""center""><font id=""" & nombre_boton & "f21"" color=""#333333"" size=""1"" face=""Verdana, Arial, Helvetica, sans-serif"">" & p_texto & vbCrLf &_
				 "        </font></div></td>" & vbCrLf &_
				 "  </tr>" & vbCrLf &_
				 "  <tr> " & vbCrLf &_
				 "    <td width=""88"" height=""2""><img src=""../imagenes/botones/boton3.gif"" width=""88"" height=""2"" id=""" & nombre_boton & "c31""></td>" & vbCrLf &_
				 "  </tr>" & vbCrLf &_
				 "</table>"
				 
		Response.Write(salida)				 
	End Sub
	
	
	
	Sub DibujarSubtitulo(p_texto)
		dim salida				
		
		salida = "<table width=""100%""  border=""0"" cellpadding=""0"" cellspacing=""0"">" & vbCrLf &_
		         "  <tr>" & vbCrLf &_
				 "     <td>" & vbCrLf				 
		
		salida = salida & "<table width=""99%"" border=""0"" align=""left"" cellpadding=""0"" cellspacing=""0""> " & vbCrLf &_
		         "    <tr> " & vbCrLf &_
				 "      <td><font face=""Verdana, Arial, Helvetica, sans-serif"" size=""1""><b><font color=""#666677"" size=""2"">" & p_texto & "</font></b></font></td> " & vbCrLf &_
				 "    </tr> " & vbCrLf &_
				 "    <tr> " & vbCrLf &_
				 "      <td width=""0"" height=""0""><font color=""#666677""><img src=""../imagenes/linea.gif"" width=""100%"" height=""9""></font></td> " & vbCrLf &_
				 "    </tr> " & vbCrLf &_
				 "</table>"				 
				 
		salida = salida & "  </tr>" & vbCrLf &_
		                  "</table>"
				 
		Response.Write(salida)
	End Sub
	
	
	Sub DibujarLenguetas_Ant(p_textos, p_seleccionado)
		dim salida
		dim i
		dim v_background, v_img_izq, v_img_der, v_font_color
		
		salida = "<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""0"">" & vbCrLf &_
		         "  <tr>" & vbCrLf
		
		for i = 0 to UBound(p_textos)
			if i <> p_seleccionado - 1 then
				v_background = "../imagenes/fondo2.gif"
				v_img_izq = "../imagenes/izq2.gif"
				v_img_der = "../imagenes/der2.gif"
				v_font_color = "#333333"
			else
				v_background = "../imagenes/fondo1.gif"
				v_img_izq = "../imagenes/izq_1.gif"
				v_img_der = "../imagenes/derech1.gif"
				v_font_color = "#000000"
			end if
			
			
			salida = salida & "<td width=""6""><img src=""" & v_img_izq & """ width=""6"" height=""17""></td>" & vbCrLf &_
			                  "	<td valign=""middle"" nowrap background=""" & v_background & """>" & vbCrLf &_
							  "	<div align=""center""><font color=""" & v_font_color & """ face=""Verdana, Arial, Helvetica, sans-serif"">" & p_textos(i) & "</font></div></td>" & vbCrLf &_
							  "	<td width=""6""><img src=""" & v_img_der & """ width=""6"" height=""17""></td>" & vbCrLf

		next
		
		salida = salida & "<td width=""100%"" bgcolor=""#D8D8DE"">" & vbCrLf &_				
		                  "  </tr>" & vbCrLf &_
		                  "</table>"
						  
		salida__ = salida & "<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""0"">" & vbCrLf &_
		                  "  <tr>" & vbCrLf &_
						  "   <td><img name=""top_r3_c1"" src=""../imagenes/top_r3_c1.gif"" width=""9"" height=""2"" border=""0""></td>" & vbCrLf &_
						  "   <td><img name=""top_r3_c2"" src=""../imagenes/top_r3_c2.gif"" width=""100%"" height=""2"" border=""0""></td>" & vbCrLf &_
						  "   <td><img name=""top_r3_c3"" src=""../imagenes/top_r3_c3.gif"" width=""7"" height=""2"" border=""0"" alt=""""></td>" & vbCrLf &_
						  "</tr>" & vbCrLf &_
						  "</table>"
		
		Response.Write(salida)
	End Sub
	
	
	
	Sub DibujarLenguetas(p_tabs, p_seleccionado)	
		dim salida, i
		dim v_background, v_img_izq, v_img_der, v_font_color, v_td_propiedades
		dim v_texto
		
		salida = "<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""0"">" & vbCrLf &_
		         "  <tr>" & vbCrLf
				 
		for i = 0 to UBound(p_tabs)			
			if i <> p_seleccionado - 1 then
				v_background = "../imagenes/fondo2.gif"
				v_img_izq = "../imagenes/izq2.gif"
				v_img_der = "../imagenes/der2.gif"
				v_font_color = "#333333"
				
				if IsArray(p_tabs(i)) then
					v_td_propiedades = "class=""click"" onClick=""navigate('" & p_tabs(i)(1) & "')"""
				else
					v_td_propiedades = ""
				end if				
			else
				v_background = "../imagenes/fondo1.gif"
				v_img_izq = "../imagenes/izq_1.gif"
				v_img_der = "../imagenes/derech1.gif"
				v_font_color = "#FFFFFF"
				v_td_propiedades = ""
			end if
			
			if IsArray(p_tabs(i)) then
				v_texto = p_tabs(i)(0)
			else
				v_texto = p_tabs(i)
			end if
			
			salida = salida & "<td width=""6"" " & v_td_propiedades & "><img src=""" & v_img_izq & """ width=""6"" height=""17""></td>" & vbCrLf &_
			                  "<td valign=""middle"" nowrap background=""" & v_background & """ " & v_td_propiedades & ">" & vbCrLf &_
							  "   <div align=""center""><font color=""" & v_font_color & """ face=""Verdana, Arial, Helvetica, sans-serif"">" & v_texto & "</font></div></td>" & vbCrLf &_
							  "<td width=""6""><img src=""" & v_img_der & """ width=""6"" height=""17"" " & v_td_propiedades & "></td>" & vbCrLf
		next
		
		salida = salida & "<td width=""100%"" bgcolor=""#D8D8DE"">" & vbCrLf &_				
		                  "  </tr>" & vbCrLf &_						  
		                  "</table>"
						  
		Response.Write(salida)							
	End Sub
	
	
	Sub DibujarLenguetasFClaro(p_tabs, p_seleccionado)	
		dim salida, i
		dim v_background, v_img_izq, v_img_der, v_font_color, v_td_propiedades
		dim v_texto
		
		salida = "<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""0"">" & vbCrLf &_
		         "  <tr>" & vbCrLf
				 
		for i = 0 to UBound(p_tabs)			
			if i <> p_seleccionado - 1 then
				v_background = "../imagenes/fondo2.gif"
				v_img_izq = "../imagenes/marco_claro/1claro.gif"
				v_img_der = "../imagenes/marco_claro/2claro.gif"
				v_font_color = "#333333"
				
				if IsArray(p_tabs(i)) then
					v_td_propiedades = "class=""click"" onClick=""navigate('" & p_tabs(i)(1) & "')"""
				else
					v_td_propiedades = ""
				end if				
			else
				v_background = "../imagenes/fondo1.gif"
				v_img_izq = "../imagenes/marco_claro/leng1.gif"
				v_img_der = "../imagenes/marco_claro/2oscuro.gif"
				v_font_color = "#FFFFFF"
				v_td_propiedades = ""
			end if
			
			if IsArray(p_tabs(i)) then
				v_texto = p_tabs(i)(0)
			else
				v_texto = p_tabs(i)
			end if
			
			salida = salida & "<td width=""6"" " & v_td_propiedades & "><img src=""" & v_img_izq & """ width=""6"" height=""17""></td>" & vbCrLf &_
			                  "<td valign=""middle"" nowrap background=""" & v_background & """ " & v_td_propiedades & ">" & vbCrLf &_
							  "   <div align=""center""><font color=""" & v_font_color & """ face=""Verdana, Arial, Helvetica, sans-serif"">" & v_texto & "</font></div></td>" & vbCrLf &_
							  "<td width=""6""><img src=""" & v_img_der & """ width=""6"" height=""17"" " & v_td_propiedades & "></td>" & vbCrLf
		next
		
		salida = salida & "<td width=""100%"" bgcolor=""#EDEDEF"">" & vbCrLf &_				
		                  "  </tr>" & vbCrLf &_						  
		                  "</table>"
						  
		Response.Write(salida)							
	End Sub
	
	
	
	Sub DibujarBuscaPersonas(p_objeto_rut, p_objeto_dv)
		dim salida
		
		salida = "<a href=""javascript:buscar_persona('" & p_objeto_rut & "', '" & p_objeto_dv & "');""><img src=""../imagenes/lupa_f2.gif"" width=""16"" height=""15"" border=""0""></a>"
		
		Response.Write(salida)
	End Sub
	
	
	Sub DibujarTitulo(p_titulo)
		dim salida
		
		salida = "<font face=""Verdana, Arial, Helvetica, sans-serif""><span style=""color:#42424A; font-weight: bold; font-size: 17px"">" & UCase(p_titulo) & "</span></font>"
		
		Response.Write(salida)		
	End Sub
	
	Sub DibujarTituloPagina
		Me.DibujarTitulo Me.Titulo
	End Sub	
	
	
	Sub GeneraDiccionarioJS(p_consulta, p_conexion, p_diccionario)
		dim v_conexion, registros, fila, campo
		dim salida, i		
		
		salida = "<script language=""JavaScript"">" & vbCrLf
		salida = salida & p_diccionario & " = new ActiveXObject(""Scripting.Dictionary"")" & vbCrLf		
		
		set v_conexion = p_conexion
		
		v_conexion.Ejecuta p_consulta
		set registros = v_conexion.ObtenerRegistros	
		
		i = 0
		for each fila in registros.Item("filas").Items
			salida = salida & vbCrLf
			salida = salida & p_diccionario & ".Add(""" & i & """, new ActiveXObject(""Scripting.Dictionary""));" & vbCrLf
			
			for each campo in fila.Keys
				salida = salida & p_diccionario & ".Item(""" & i & """).Add(""" & LCase(campo) & """, """&fila.Item(campo)&""");" & vbCrLf
			next			
			
			i = i + 1
		next
		
		salida = salida & "</script>" & vbCrLf
		
		Response.Write(salida)
		
	End Sub
	
	
	Sub GeneraDiccionarioJSClave(p_consulta, p_clave, p_conexion, p_diccionario)
		dim v_conexion, registros, fila, campo
		dim salida, i
		
		salida = "<script language=""JavaScript"">" & vbCrLf
		salida = salida & p_diccionario & " = new ActiveXObject(""Scripting.Dictionary"")" & vbCrLf		
		
		set v_conexion = p_conexion
		
		v_conexion.Ejecuta p_consulta
		set registros = v_conexion.ObtenerRegistros	
		
		i = 0
		for each fila in registros.Item("filas").Items
			salida = salida & vbCrLf
			salida = salida & p_diccionario & ".Add(""" & fila.Item(UCase(p_clave)) & """, new ActiveXObject(""Scripting.Dictionary""));" & vbCrLf
			
			for each campo in fila.Keys
				salida = salida & p_diccionario & ".Item(""" & fila.Item(UCase(p_clave)) & """).Add(""" & LCase(campo) & """, """&fila.Item(campo)&""");" & vbCrLf
			next			
			
			i = i + 1
		next
		
		salida = salida & "</script>" & vbCrLf
		
		Response.Write(salida)
		
		
	End Sub
	
End Class
%>
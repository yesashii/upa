<%
Function Traduce_numero(varmonto,Espacio)
i_c = 1

tamvar = Len(varmonto)
res = (12 - tamvar) + 1
aux_cifra = ""
While i_c <= 12 - tamvar
	 aux_cifra = aux_cifra & "0"
      i_c = i_c + 1
Wend

aux_cifra = aux_cifra & varmonto

i_c = 0
aux_char = ""
While i_c <= 12 And (aux_char = " " Or aux_char = "" Or aux_char = "0")
    i_c = i_c + 1
    aux_char = Mid(aux_cifra, i_c, 1) 
Wend

If CLng(varmonto) < 2 And CLng(varmonto) >= 1 Then
   linea = "UNO "
   i_c = 13
End If

While i_c <= 12
  If ((i_c = 1 Or i_c = 4 Or i_c = 7 Or i_c = 10) And aux_char <> "0") Then
    ' /* Se traducen las centenas */
       tot1 = i_c + 1
       TOT2 = i_c + 2
    If aux_char = "1" And Mid(aux_cifra, tot1, 1) = "0" And Mid(aux_cifra, TOT2, 1) = "0" Then
        linea = RTrim(linea) + " CIEN"
        If i_c = 1 Or i_c = 7 Then
           linea = RTrim(linea) + " MIL"
        End If
        If i_c = 1 Or i_c = 4 Then
           linea = RTrim(linea) + " MILLLONES"
        End If
    Else
        AUX_CHAR2 = aux_char
        Select Case AUX_CHAR2
           Case "1"
              NOM_CENTENA = "CIENTO"
           Case "2"
              NOM_CENTENA = "DOSCIENTOS"
           Case "3"
              NOM_CENTENA = "TRESCIENTOS"
           Case "4"
              NOM_CENTENA = "CUATROCIENTOS"
           Case "5"
              NOM_CENTENA = "QUINIENTOS"
           Case "6"
              NOM_CENTENA = "SEISCIENTOS"
           Case "7"
              NOM_CENTENA = "SETECIENTOS"
           Case "8"
              NOM_CENTENA = "OCHOCIENTOS"
           Case "9"
              NOM_CENTENA = "NOVECIENTOS"
           End Select

           linea = RTrim(linea) + " " + NOM_CENTENA
           tot1 = i_c + 1
           TOT2 = i_c + 2
           If Mid(aux_cifra, tot1, 1) = "0" And Mid(aux_cifra, TOT2, 1) = "0" Then
            If i_c = 1 Or i_c = 7 Then
                       linea = RTrim(linea) + " MIL"
            End If
            If i_c = 1 Or i_c = 4 Then
                    linea = RTrim(linea) + " MILLONES"
            End If
           End If
    End If
  Else
    If (i_c = 2 Or i_c = 5 Or i_c = 8 Or i_c = 11) And aux_char <> "0" Then
           ' /* Se traducen las decenas */
        If aux_char = "1" Or aux_char = "2" Then
           i_c = i_c + 1
           AUX_CHAR2 = aux_char + Mid(aux_cifra, i_c, 1)
           Select Case AUX_CHAR2
           Case "10"
              NOM_UNIDAD = "DIEZ"
           Case "11"
              NOM_UNIDAD = "ONCE"
           Case "12"
              NOM_UNIDAD = "DOCE"
           Case "13"
              NOM_UNIDAD = "TRECE"
           Case "14"
              NOM_UNIDAD = "CATORCE"
           Case "15"
              NOM_UNIDAD = "QUINCE"
           Case "16"
              NOM_UNIDAD = "DIECISEIS"
           Case "17"
              NOM_UNIDAD = "DIECISIETE"
           Case "18"
              NOM_UNIDAD = "DIECIOCHO"
           Case "19"
              NOM_UNIDAD = "DIECINUEVE"
           Case "20"
              NOM_UNIDAD = "VEINTE"
           Case "21"
              NOM_UNIDAD = "VEINTIUNO"
           Case "22"
              NOM_UNIDAD = "VEINTIDOS"
           Case "23"
              NOM_UNIDAD = "VEINTITRES"
           Case "24"
              NOM_UNIDAD = "VEINTICUATRO"
           Case "25"
              NOM_UNIDAD = "VEINTICINCO"
           Case "26"
              NOM_UNIDAD = "VEINTISEIS"
           Case "27"
              NOM_UNIDAD = "VEINTISIETE"
           Case "28"
              NOM_UNIDAD = "VEINTIOCHO"
           Case "29"
              NOM_UNIDAD = "VEINTINUEVE"
           End Select
                 linea = RTrim(linea) + " " + NOM_UNIDAD
           If i_c = 3 Or i_c = 9 Then
                 linea = RTrim(linea) + " MIL"
           End If
           If i_c = 6 Then
              linea = RTrim(linea) + " MILLONES"
           End If
        Else
           AUX_CHAR2 = aux_char
           Select Case AUX_CHAR2
           Case "1"
              NOM_UNIDAD = "DIEZ"
           Case "2"
              NOM_UNIDAD = "VEINTE"
           Case "3"
              NOM_UNIDAD = "TREINTA"
           Case "4"
              NOM_UNIDAD = "CUARENTA"
           Case "5"
              NOM_UNIDAD = "CINCUENTA"
           Case "6"
              NOM_UNIDAD = "SESENTA"
           Case "7"
              NOM_UNIDAD = "SETENTA"
           Case "8"
              NOM_UNIDAD = "OCHENTA"
           Case "9"
              NOM_UNIDAD = "NOVENTA"
           End Select

           linea = RTrim(linea) + " " + NOM_UNIDAD
           tot1 = i_c + 1
           If Mid(aux_cifra, tot1, 1) <> "0" Then
              linea = RTrim(linea) + " Y"
           Else
              If i_c = 3 Or i_c = 9 Or i_c = 8 Then
                    linea = RTrim(linea) + " MIL"
                 End If
              If i_c = 5 Then
                 linea = RTrim(linea) + " MILLONES"
              End If
           End If
        End If
    Else
           If aux_char <> "0" And Mid(aux_cifra, i_c - 1, 1) <> "1" And Mid(aux_cifra, i_c - 1, 1) <> "2" Then
                If aux_char = "1" And i_c <> 12 Then
                   linea = RTrim(linea) + " UN"
                Else
                   AUX_CHAR2 = aux_char
                   Select Case AUX_CHAR2
                   Case "1"
                      NOM_UNIDAD = "UN "
                   Case "2"
                      NOM_UNIDAD = "DOS"
                   Case "3"
                      NOM_UNIDAD = "TRES"
                   Case "4"
                      NOM_UNIDAD = "CUATRO"
                   Case "5"
                      NOM_UNIDAD = "CINCO"
                   Case "6"
                      NOM_UNIDAD = "SEIS"
                   Case "7"
                      NOM_UNIDAD = "SIETE"
                   Case "8"
                      NOM_UNIDAD = "OCHO"
                   Case "9"
                      NOM_UNIDAD = "NUEVE"
                   End Select

                   linea = RTrim(linea) + " " + NOM_UNIDAD
                End If
              If i_c = 3 Or i_c = 9 Then
                    linea = RTrim(linea) + " MIL"
              End If
              If i_c = 6 Then
                 If aux_char <> "0" And aux_char <> "1" Then
                   linea = RTrim(linea) + " MILLONES"
                 Else
                    linea = RTrim(linea) + " MILLON"
                 End If
              End If
           End If
    End If
  End If
        i_c = i_c + 1
        aux_char = Mid(aux_cifra, i_c, 1)

Wend

  linea = RTrim(linea) 
  tot1 = Len(linea)

  If tot1 < 50 Then
     Glosa1 = Mid(linea, 1, tot1)
     glosa2 = ""
  Else
     
       i_c = 50
       While Mid(linea, i_c, 1) <> " "
         i_c = i_c - 1
       Wend

       Glosa1 = Mid(linea, 1, i_c)
       i_c = i_c + 1
       tot1 = tot1 - 2
       glosa2 = Mid(linea, i_c, tot1)
  End If
  
  glosa2 = Trim(glosa2)
  
  If glosa2 = "" Then Glosa1 = Glosa1 & " .-"
  tamvar = (Len(glosa2)) + 1
 
  t_aux_glosa = Trim(glosa2)
  for i_ = tamvar + 1 to Len(aux_glosa)
      t_aux_glosa = t_aux_glosa & Mid(aux_glosa, i_, 1)  
  next
  aux_glosa = t_aux_glosa
  
  While tamvar <> 51
	  aux_glosa = aux_glosa & "-"
      tamvar = tamvar + 1
  Wend

  glosa2 = aux_glosa
  
  Traduce_numero = Trim(linea) 
  
End Function

'************************************************************************************
   function sin_acentos(texto_temp)
   if texto_temp<>"" then
     texto_temp = replace(texto_temp,"Á", "A")
	 texto_temp = replace(texto_temp,"É", "E")
	 texto_temp = replace(texto_temp,"Í", "I")
	 texto_temp = replace(texto_temp,"Ó", "O")
	 texto_temp = replace(texto_temp,"Ú", "U")	 
	 texto_temp = replace(texto_temp,"Ñ", "N")
	 texto_temp = replace(texto_temp,"Ä", "A")
	 texto_temp = replace(texto_temp,"Ë", "E")
	 texto_temp = replace(texto_temp,"Ï", "I")
	 texto_temp = replace(texto_temp,"Ö", "O")
	 texto_temp = replace(texto_temp,"Ü", "U")
	 texto_temp = replace(texto_temp,"À", "A")
	 texto_temp = replace(texto_temp,"È", "E")
	 texto_temp = replace(texto_temp,"Ì", "I")
	 texto_temp = replace(texto_temp,"Ò", "O")
	 texto_temp = replace(texto_temp,"Ù", "U")	 
	 texto_temp = replace(texto_temp,"Ç", "C")	
	 texto_temp = replace(texto_temp,"±", "Ñ")		 
end if
	 sin_acentos = texto_temp
  end function


'--------------------------------------------------------------------------------------------------------------------
function Ac(texto,ancho,alineado)
    largo =Len(Trim(texto))
	if largo > ancho then largo=ancho
    if ucase(alineado) = "D" then 
	   Ac=space(ancho-largo)&Left(texto,largo)
	else
	   Ac=Left(texto,cint(largo))&space(ancho-largo)
	end if   
  end function
  
function dibujamenu()

salida = "  <td><a href=""novedades.asp"" onMouseOut=""MM_swapImgRestore();"" onMouseOver=""MM_swapImage('mamut_r1_c2','','img/mamut_r1_c2_f2.gif',1);""><img name=""mamut_r1_c2"" src=""img/mamut_r1_c2.gif"" width=""78"" height=""17"" border=""0"" alt=""""></a></td>" & vbCrLf &_
		 "  <td><a href=""quienes_somos.asp"" onMouseOut=""MM_swapImgRestore();"" onMouseOver=""MM_swapImage('mamut_r1_c3','','img/mamut_r1_c3_f2.gif',1);""><img name=""mamut_r1_c3"" src=""img/mamut_r1_c3.gif"" width=""99"" height=""17"" border=""0"" alt=""""></a></td>" & vbCrLf &_
		 "  <td colspan=""2""><a href=""login.asp"" onMouseOut=""MM_swapImgRestore();"" onMouseOver=""MM_swapImage('mamut_r1_c4','','img/mamut_r1_c4_f2.gif',1);""><img name=""mamut_r1_c4"" src=""img/mamut_r1_c4.gif"" width=""61"" height=""17"" border=""0"" alt=""""></a></td>" & vbCrLf &_
		 "  <td><a href=""catalogo.asp"" onMouseOut=""MM_swapImgRestore();"" onMouseOver=""MM_swapImage('mamut_r1_c6','','img/mamut_r1_c6_f2.gif',1);""><img name=""mamut_r1_c6"" src=""img/mamut_r1_c6.gif"" width=""133"" height=""17"" border=""0"" alt=""""></a></td>" & vbCrLf &_
		 "  <td><a href=""#"" onMouseOut=""MM_swapImgRestore();"" onMouseOver=""MM_swapImage('mamut_r1_c7','','img/mamut_r1_c7_f2.gif',1);""><img name=""mamut_r1_c7"" src=""img/mamut_r1_c7.gif"" width=""93"" height=""17"" border=""0"" alt=""""></a></td>" 
		   
dibujamenu=salida
end function

function dibujamenuportada()
salida=  " <td><a href=""novedades.asp"" onMouseOut=""MM_swapImgRestore();"" onMouseOver=""MM_swapImage('index_r2_c2','','img/index_r2_c2_f2.gif',1);""><img name=""index_r2_c2"" src=""img/index_r2_c2.gif"" width=""78"" height=""22"" border=""0"" alt=""""></a></td>"& vbCrLf &_
 " <td><a href=""quienes_somos.asp"" onMouseOut=""MM_swapImgRestore();"" onMouseOver=""MM_swapImage('index_r2_c3','','img/index_r2_c3_f2.gif',1);""><img name=""index_r2_c3"" src=""img/index_r2_c3.gif"" width=""99"" height=""22"" border=""0"" alt=""""></a></td>"& vbCrLf &_
 " <td><a href=""login.asp"" onMouseOut=""MM_swapImgRestore();"" onMouseOver=""MM_swapImage('index_r2_c4','','img/index_r2_c4_f2.gif',1);""><img name=""index_r2_c4"" src=""img/index_r2_c4.gif"" width=""61"" height=""22"" border=""0"" alt=""""></a></td>"& vbCrLf &_
 " <td><a href=""catalogo.asp"" onMouseOut=""MM_swapImgRestore();"" onMouseOver=""MM_swapImage('index_r2_c5','','img/index_r2_c5_f2.gif',1);""><img name=""index_r2_c5"" src=""img/index_r2_c5.gif"" width=""133"" height=""22"" border=""0"" alt=""""></a></td>"& vbCrLf &_
 " <td><a href=""#"" onMouseOut=""MM_swapImgRestore();"" onMouseOver=""MM_swapImage('index_r2_c6','','img/index_r2_c6_f2.gif',1);""><img name=""index_r2_c6"" src=""img/index_r2_c6.gif"" width=""93"" height=""22"" border=""0"" alt=""""></a></td> " 
dibujamenuportada=salida
end function


' "  <td><a href=""novedades.asp"" onMouseOut=""MM_swapImgRestore();"" onMouseOver=""MM_swapImage('index_r2_c3','','img/index_r2_c3_f2.gif',1);""><img name=""index_r2_c3"" src=""img/index_r2_c3.gif"" width=""78"" height=""22"" border=""0"" alt=""""></a></td>"& vbCrLf &_
'		 "  <td colspan=""3""><a href=""quienes_somos.asp"" onMouseOut=""MM_swapImgRestore();"" onMouseOver=""MM_swapImage('index_r2_c4','','img/index_r2_c4_f2.gif',1);""><img name=""index_r2_c4"" src=""img/index_r2_c4.gif"" width=""99"" height=""22"" border=""0"" alt=""""></a></td>"& vbCrLf &_
	'	 "  <td colspan=""2""><a href=""#"" onMouseOut=""MM_swapImgRestore();"" onMouseOver=""MM_swapImage('index_r2_c7','','img/index_r2_c7_f2.gif',1);""><img name=""index_r2_c7"" src=""img/index_r2_c7.gif"" width=""61"" height=""22"" border=""0"" alt=""""></a></td>"& vbCrLf &_
		' "  <td><a href=""catalogo.asp"" onMouseOut=""MM_swapImgRestore();"" onMouseOver=""MM_swapImage('index_r2_c9','','img/index_r2_c9_f2.gif',1);""><img name=""index_r2_c9"" src=""img/index_r2_c9.gif"" width=""133"" height=""22"" border=""0"" alt=""""></a></td>"& vbCrLf &_
		 '"  <td colspan=""2""><a href=""#"" onMouseOut=""MM_swapImgRestore();"" onMouseOver=""MM_swapImage('index_r2_c10','','img/index_r2_c10_f2.gif',1);""><img name=""index_r2_c10"" src=""img/index_r2_c10.gif"" width=""93"" height=""22"" border=""0"" alt=""""></a></td>" 
%>

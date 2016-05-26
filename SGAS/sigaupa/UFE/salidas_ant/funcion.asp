<%
function ExtraeAcentosCaracteres (cadena)
cadena=trim(cadena) 
cadena=LCase(cadena)
cadena=Replace(cadena,"á", "a")
cadena=Replace(cadena,"ä", "a")
cadena=Replace(cadena,"à", "a")
cadena=Replace(cadena,"é", "e")
cadena=Replace(cadena,"ë", "e")
cadena=Replace(cadena,"è", "e")
cadena=Replace(cadena,"í", "i")
cadena=Replace(cadena,"í", "i")
cadena=Replace(cadena,"ì", "i")
cadena=Replace(cadena,"ó", "o")
cadena=Replace(cadena,"ó", "o")
cadena=Replace(cadena,"ò", "o")
cadena=Replace(cadena,"ú", "u")
cadena=Replace(cadena,"ú", "u")
cadena=Replace(cadena,"ù", "u")
cadena=Replace(cadena,"ñ", "n")
cadena=Replace(cadena," ", "_")
cadena=Replace(cadena,".", "")
cadena=Replace(cadena,",", "")
cadena=Replace(cadena,";", "")
cadena=Replace(cadena,"-", "")
cadena=Replace(cadena,"/", "")
cadena=Replace(cadena,"\", "")
cadena=Replace(cadena,"@", "")
cadena=Replace(cadena,"*", "")
cadena=Replace(cadena,"'", "")
cadena=Replace(cadena,"?", "")
cadena=Replace(cadena,"¿", "")
cadena=Replace(cadena,"¡", "")
cadena=Replace(cadena,"!", "")
cadena=Replace(cadena,"{", "")
cadena=Replace(cadena,"}", "")
cadena=Replace(cadena,"[", "")
cadena=Replace(cadena,"]", "")
cadena=Replace(cadena,"°", "")
cadena=Replace(cadena,"%", "")
cadena=Replace(cadena,"(", "")
cadena=Replace(cadena,")", "")


ExtraeAcentosCaracteres=cadena
end function

function ExtraeCremilla(cadena)
cadena=Replace(cadena,"'", "")
ExtraeCremilla=cadena
end function

%>

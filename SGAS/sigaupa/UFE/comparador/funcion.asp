<%
function ExtraeAcentosCaracteres (cadena)
cadena=trim(cadena) 
cadena=LCase(cadena)
cadena=Replace(cadena,"�", "a")
cadena=Replace(cadena,"�", "a")
cadena=Replace(cadena,"�", "a")
cadena=Replace(cadena,"�", "e")
cadena=Replace(cadena,"�", "e")
cadena=Replace(cadena,"�", "e")
cadena=Replace(cadena,"�", "i")
cadena=Replace(cadena,"�", "i")
cadena=Replace(cadena,"�", "i")
cadena=Replace(cadena,"�", "o")
cadena=Replace(cadena,"�", "o")
cadena=Replace(cadena,"�", "o")
cadena=Replace(cadena,"�", "u")
cadena=Replace(cadena,"�", "u")
cadena=Replace(cadena,"�", "u")
cadena=Replace(cadena,"�", "n")
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
cadena=Replace(cadena,"�", "")
cadena=Replace(cadena,"�", "")
cadena=Replace(cadena,"!", "")
cadena=Replace(cadena,"{", "")
cadena=Replace(cadena,"}", "")
cadena=Replace(cadena,"[", "")
cadena=Replace(cadena,"]", "")
cadena=Replace(cadena,"�", "")
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

<% 

text="GERENCIAS DE ÁREAasdfaasdfasdfasdsdf asdfasdaasdfa sdfasddasdfa sdfasdasdfasdfasdfasdfasdfasdfasdfa sdfasdfasdfasdfasdfasdfasdfasdfasdfasd fasdfasdfasdfasdfasd fasdfasdfas dfasdfa dfasdfasdfasdf fasdfasdfasdf asdfasdfasdfasd fasdfasdfasdfasd fasdfas dfasdfasdf asdfa sdfasdf asdfasdfas dfasd fasdf asdfas dfasdf asdfa sdfasdfas dfasdfa sdfas d fas dasdf asdfasd asdfasdf"



function AgregaSaltoLinea(texto)

largo=len(texto)

resultado=split(texto," ")

UBound(resultado) 
response.write(UBound(resultado))
re=0
while 0< UBound(resultado) 
response.write("<BR>"&resultado(re))
re=re+1
wend
end function

AgregaSaltoLinea(text)



%>
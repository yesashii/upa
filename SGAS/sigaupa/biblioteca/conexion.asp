<% @language=vbscript%>
<%
function conexion(sqltext)
On Error Resume Next 
set rs= createobject("ADODB.Recordset")
set con = createobject("ADODB.Connection")

con.open "DSN=frindt;UID=sa;PWD=,.-frindt;"
rs.open sqltext,con,3
set conexion = rs
If con.Errors.Count > 0 then
    For each error in con.errors 
      i=i+1
	  if error.number<>0 and i=1 then
    	session("error") = "ERROR (" & Error.Number & ")\n" & Error.Description & "\n"
	  end if
    next
End if
end function
%>

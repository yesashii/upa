﻿<% 
class HomeController
 Dim Model
 Dim ViewData
   
 private sub Class_Initialize()
    Set ViewData = Server.CreateObject("Scripting.Dictionary")
 end sub

 private sub Class_Terminate()
 end sub
 
 public Sub Index(vars)
    Model = "dude"
     %>   <!--#include file="../views/Home/Index.asp" --> <%
 End Sub
 
 public Sub About(vars)
    if Session("sessionCounter")="" then
       Session("sessionCounter") = 1
    Else
        Session("sessionCounter") = Session("sessionCounter") + 1
    End If
    Model = Session("sessionCounter")
    %>   <!--#include file="../views/Home/About.asp" --> <%
 End Sub
 
 Public Sub AbandonSession(vars)
   Session.Abandon()
   Response.Redirect("?controller=Home&action=About")
 End Sub
 
 
End Class
%>

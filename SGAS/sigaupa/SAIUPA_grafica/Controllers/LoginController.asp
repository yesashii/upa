      <%
      class LoginController
      Dim Model
      Dim ViewData

      private sub Class_Initialize()
      Set ViewData = Server.CreateObject("Scripting.Dictionary")
      end sub

      private sub Class_Terminate()
      end sub

        public Sub List(vars)
            Dim u,t
            set u = new LoginHelper
            If IsNothing(vars) Then
                 set Model = u.SelectAll
            ElseIf IsNothing(vars("q")) Then
                 set Model = u.SelectAll
            Else
                 set Model = u.Search(vars("User"),vars("Clave"))
            End If
            %>   <!--#include file="../views/Login/List.asp" --> <%
        End Sub
		
		public Sub ListPost(vars)
            Dim u,t
            set u = new LoginHelper
			t = 0
            If IsNothing(vars) Then
                 set Model = u.SelectAll
            ElseIf IsNothing(vars("User")) or IsNothing(vars("Clave")) Then
                set Model = u.SelectAll
            Else
                set Model = u.Search(vars("User"),vars("Clave"))
				if IsNothing(Model) then
				   t = 1
				   session("_e_") = "E"
				   %>   <!--#include file="../views/Home/Index.asp" --> <%
				end if
            End If
            if t = 0 then 
			     Dim obj_T,interno
		         For each obj_T in Model.Items
				    interno = u.Insert(obj_T)
					'Lista de personas (pers_ncorr) que entran a la aplicación en forma genérica (sin perfiles)
				    if obj_T.id = "13160" or obj_T.id = "243243" or obj_T.id = "242965" or obj_T.id = "108389" or obj_T.id = "270528" or obj_T.id = "131983" or obj_T.id = "261928" or obj_T.id = "135842" or obj_T.id = "23838" or obj_T.id = "100"  then
						session("_pers_ncorr_") = "0"
					else
		  	     		session("_pers_ncorr_") = obj_T.id           
				    end if
				 next
            	%>   <!--#include file="../views/Login/List.asp" --> <%
			end if
        End Sub
		
		public Sub Ingreso()
			set Model = new Login
            
			%>   <!--#include file="../views/Home/Index.asp" --> <%
		End Sub
		 
		public Sub Autenticar(args)
			Dim u
            set u = new LoginHelper
            set Model = u.BuscaUsuario(args("User"),UCase(args("Clave")))
		    Response.Redirect("?controller=Login&action=list")
		End Sub
		
		 Public Sub AbandonSession(vars)
		   session("_pers_ncorr_") = ""
		   Session.Abandon()
		   %>   <!--#include file="../views/Home/Index.asp" --> <%
		 End Sub

  End Class

%>
    
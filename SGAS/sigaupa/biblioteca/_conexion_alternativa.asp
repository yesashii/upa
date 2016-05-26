<%
Class CAlternativa
	private c_conexion
		
	sub Inicializa 
                dsn="sbd_alumnos_02":usuario_bd="protic":clave_bd=",.protic"
				str_con = "DSN=" & dsn & ";UID=" & usuario_bd & ";PWD=" & clave_bd & ";"
				set c_conexion = createobject("ADODB.Connection")
                c_conexion.open str_con	
	end sub

	Private Sub Class_Terminate
		On Error Resume Next 'Uncomment this to prevent IIS crashing
		c_conexion.Close   
		set c_conexion = nothing
	End Sub 	

	function ConsultaUnoDirecta (sqltext)
		set rs= createobject("ADODB.Recordset")
		rs.open sqltext,c_conexion, 0
		if not rs.EOF then
			valor = rs(0)
			rs.close
			set rs = nothing
			ConsultaUnoDirecta = valor 
		else
			ConsultaUnoDirecta = null
		end if
	end function

	function EjecutaQueryDirecta (sqltext)
	    On Error Resume Next
		EjecutaQueryDirecta = true
		set rs= createobject("ADODB.Recordset")
		rs.open sqltext,c_conexion, 3
		If con.Errors.Count > 0 then
			salida = ""
			For each error in con.errors 
			  select case error.number
			  	case -2147217900 
					salida = salida & "Error al intentar Ejecutar la intruccion : <br> "&sqltext&" "
			  end select
			next
			EjecutaQueryDirecta = false
		end if
	end function

	Sub CierraConexionDirecta   
		c_conexion.Close   
		set c_conexion = nothing
   	End Sub

End Class

%>

USE [sigaupa]
GO

/****** Object:  UserDefinedFunction [protic].[anexos_pendientes]    Script Date: 02/29/2016 09:39:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

ALTER FUNCTION [protic].[anexos_pendientes]
(@pers_ncorr numeric,@p_carr_ccod char(3)) returns numeric
  as  
 begin
 
  declare @v_pendientes varchar(250)

 select @v_pendientes=count(AA.BLOQ_CCOD) 
 from BLOQUES_PROFESORES AA, BLOQUES_horarios BB, secciones CC 
     where AA.PERS_NCORR=@pers_ncorr  
         and BB.BLOQ_CCOD=AA.BLOQ_CCOD 
         and CC.SECC_CCOD = BB.SECC_CCOD 
         and CC.CARR_CCOD=@p_carr_ccod
         AND AA.CDOC_NCORR IS NULL
         AND AA.BLOQ_ANEXO IS NULL
		 --and isnull(CC.seccion_completa,'N')='S'  
	
	return @v_pendientes
end
GO



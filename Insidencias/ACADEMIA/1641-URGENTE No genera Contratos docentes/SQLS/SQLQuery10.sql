USE [sigaupa]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[ANULA_CONTRATO]
		@p_cont_ncorr = 168007,
		@p_audi_tusuario = '15370707',
		@p_caja_anulacion = 22378,
		@p_anular = 1

SELECT	'Return Value' = @return_value

GO



select * from CONTRATOS where CONT_NCORR = 123694

select * from CONTRATOS where CONT_NCORR = 168007


select * from 
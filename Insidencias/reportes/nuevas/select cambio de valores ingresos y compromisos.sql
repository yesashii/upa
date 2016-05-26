-- Ingresos
SELECT     INGR_NCORR, MCAJ_NCORR, EING_CCOD, INGR_FPAGO, INGR_MEFECTIVO, INGR_MDOCTO, INGR_MTOTAL
FROM         INGRESOS
WHERE     (INGR_NFOLIO_REFERENCIA = 421974)

-- Detalle de ingresos
SELECT     TING_CCOD, DING_NDOCTO, INGR_NCORR, DING_MDETALLE, DING_MDOCTO
FROM         DETALLE_INGRESOS
WHERE     (INGR_NCORR IN (849557))

-- Abonos
SELECT     INGR_NCORR, TCOM_CCOD, INST_CCOD, COMP_NDOCTO, DCOM_NCOMPROMISO, ABON_FABONO, ABON_MABONO
FROM         ABONOS
WHERE     (INGR_NCORR = 849557)

-- Compromisos
SELECT     TCOM_CCOD, INST_CCOD, COMP_NDOCTO, ECOM_CCOD, COMP_MNETO, COMP_MDESCUENTO, COMP_MINTERESES, COMP_MDOCUMENTO
FROM         COMPROMISOS
WHERE     (COMP_NDOCTO = 148227) AND (TCOM_CCOD = 9)

-- detalle de Compromisos
SELECT     TCOM_CCOD, INST_CCOD, COMP_NDOCTO, DCOM_NCOMPROMISO, DCOM_FCOMPROMISO, DCOM_MNETO, DCOM_MINTERESES, 
                      DCOM_MCOMPROMISO
FROM         DETALLE_COMPROMISOS
WHERE     (COMP_NDOCTO = 148227) AND (TCOM_CCOD = 9)

--Detalles
SELECT     TCOM_CCOD, INST_CCOD, COMP_NDOCTO, DETA_MVALOR_UNITARIO, DETA_MVALOR_DETALLE, DETA_MSUBTOTAL
FROM         DETALLES
WHERE     (COMP_NDOCTO = 148227) AND (TCOM_CCOD = 9)
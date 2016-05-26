

-- tabla ingresos

INSERT INTO ingresos 
            ( 
                        [INGR_NCORR], 
                        [MCAJ_NCORR], 
                        [EING_CCOD], 
                        [INGR_FPAGO], 
                        [INGR_MEFECTIVO], 
                        [INGR_MDOCTO], 
                        [INGR_MTOTAL], 
                        [INGR_NESTADO], 
                        [INGR_NFOLIO_REFERENCIA], 
                        [TING_CCOD], 
                        [AUDI_TUSUARIO], 
                        [AUDI_FMODIFICACION], 
                        [INST_CCOD], 
                        [INGR_MINTERESES], 
                        [INGR_MMULTAS], 
                        [PERS_NCORR], 
                        [INGR_MANTICIPADO], 
                        [INEM_CCOD], 
                        [TMOV_CCOD], 
                        [GLOSA_FOX], 
                        [INGR_NCORRELATIVO_CAJA], 
                        [MCAJ_NCORR_ORIGEN] 
            ) 
            VALUES 
            ( 
                        '348942', 
                        '4948', 
                        '4', 
                        '2007-06-01 19:45:35.937', 
                        '.00', 
                        '2978000.00', 
                        '2978000.00', 
                        NULL, 
                        '52184', 
                        '88', 
                        '9158297-Protesto_Cheque', 
                        '2007-06-01 19:45:35.937', 
                        '1', 
                        NULL, 
                        NULL, 
                        '119012', 
                        NULL, 
                        NULL, 
                        '1', 
                        NULL, 
                        NULL, 
                        NULL 
            );
			
			
-- tabla DETALLE_INGRESOS

INSERT INTO DETALLE_INGRESOS
            ( 
                        [TING_CCOD], 
                        [DING_NDOCTO], 
                        [INGR_NCORR], 
                        [DING_NSECUENCIA], 
                        [DING_NCORRELATIVO], 
                        [PLAZ_CCOD], 
                        [BANC_CCOD], 
                        [DING_FDOCTO], 
                        [DING_MDETALLE], 
                        [DING_MDOCTO], 
                        [DING_TCUENTA_CORRIENTE], 
                        [EDIN_CCOD], 
                        [ENVI_NCORR], 
                        [REPA_NCORR], 
                        [DING_BPACTA_CUOTA], 
                        [PERS_NCORR_CODEUDOR], 
                        [AUDI_TUSUARIO], 
                        [AUDI_FMODIFICACION], 
                        [ding_tplaza_sbif], 
                        [esed_ncorr], 
                        [sede_actual] 
            ) 
            VALUES 
            ( 
                        '38', 
                        '640', 
                        '348942', 
                        '99255909', 
                        '1', 
                        '1', 
                        '37', 
                        '2007-05-30 00:00:00.000', 
                        '2978000.00', 
                        '2978000.00', 
                        '5223563', 
                        '10', 
                        '33936', 
                        NULL, 
                        'S', 
                        '123398', 
                        '8876413', 
                        '2010-07-19 18:10:36.327', 
                        NULL, 
                        NULL, 
                        NULL 
            );

-- 
INSERT INTO abonos 
            ( 
                        [INGR_NCORR], 
                        [TCOM_CCOD], 
                        [INST_CCOD], 
                        [COMP_NDOCTO], 
                        [DCOM_NCOMPROMISO], 
                        [DCOM_MTRASPASADO], 
                        [ABON_FABONO], 
                        [ABON_MABONO], 
                        [AUDI_TUSUARIO], 
                        [AUDI_FMODIFICACION], 
                        [PERS_NCORR], 
                        [PERI_CCOD], 
                        [INEM_CCOD] 
            ) 
            VALUES 
            ( 
                        '348942', 
                        '13', 
                        '1', 
                        '52184', 
                        '1', 
                        NULL, 
                        '2007-06-01 19:45:35.937', 
                        '2978000.00', 
                        '9158297-Protesto_Cheque', 
                        '2007-06-01 19:45:35.937', 
                        '119012', 
                        '206', 
                        NULL 
            );
			
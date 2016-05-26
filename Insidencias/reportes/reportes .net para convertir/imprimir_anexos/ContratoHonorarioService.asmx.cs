namespace imprimir_anexos
{
    using System;
    using System.Web.Services;
    using CrystalDecisions.Shared;
    using CrystalDecisions.CrystalReports.Engine;
    using CrystalDecisions.ReportSource;
    using CrystalDecisions.Web.Services;


    [ WebService( Namespace="http://crystaldecisions.com/reportwebservice/9.1/" ) ]
    public class ContratoHonorarioService : ReportServiceBase
    {
        public ContratoHonorarioService() 
        {
            this.ReportSource = new CachedWebContratoHonorario( this );
        }

        
        protected void  OnInitReport( object source, EventArgs args )
        {
        }


        public class CachedWebContratoHonorario : ICachedReport
        {
            protected ContratoHonorarioService     webService = null;

            
            public CachedWebContratoHonorario
            (
                ContratoHonorarioService   webServiceParam
            )
            {
                this.webService = webServiceParam;
            }

            public virtual bool IsCacheable
            {
                get { return ( true ); }
                set {}
            }

            public virtual bool  ShareDBLogonInfo
            {
                get { return ( false ); }
                set {}
            }

            public virtual TimeSpan  CacheTimeOut
            {
                get { return ( CachedReportConstants.DEFAULT_TIMEOUT ); }
                set {}
            }

            public virtual ReportDocument  CreateReport()
            {
                ContratoHonorario    report =
                        new ContratoHonorario();

                report.InitReport += new EventHandler( this.webService.OnInitReport );

                return ( report );
            }

            public virtual string  GetCustomizedCacheKey( RequestContext request )
            {
                string  key = null;

                /*
                    key = RequestContext.BuildCompleteCacheKey(
                            null,   // RequestContext
                            null,   // sReportFilename
                            this.GetType(),
                            this.ShareDBLogonInfo );
                */

                return ( key );
            }
        } // CachedWebContratoHonorario
    } // ContratoHonorarioService
} // imprimir_anexos


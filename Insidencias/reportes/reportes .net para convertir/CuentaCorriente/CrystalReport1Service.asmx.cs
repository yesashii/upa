namespace CuentaCorriente
{
    using System;
    using System.Web.Services;
    using CrystalDecisions.Shared;
    using CrystalDecisions.CrystalReports.Engine;
    using CrystalDecisions.ReportSource;
    using CrystalDecisions.Web.Services;


    [ WebService( Namespace="http://crystaldecisions.com/reportwebservice/9.1/" ) ]
    public class CrystalReport1Service : ReportServiceBase
    {
        public CrystalReport1Service() 
        {
            this.ReportSource = new CachedWebCrystalReport1( this );
        }

        
        protected void  OnInitReport( object source, EventArgs args )
        {
        }


        public class CachedWebCrystalReport1 : ICachedReport
        {
            protected CrystalReport1Service     webService = null;

            
            public CachedWebCrystalReport1
            (
                CrystalReport1Service   webServiceParam
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
                CrystalReport1    report =
                        new CrystalReport1();

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
        } // CachedWebCrystalReport1
    } // CrystalReport1Service
} // CuentaCorriente


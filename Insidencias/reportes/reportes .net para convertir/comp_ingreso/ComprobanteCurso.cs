﻿//------------------------------------------------------------------------------
// <autogenerated>
//     This code was generated by a tool.
//     Runtime Version: 1.0.3705.0
//
//     Changes to this file may cause incorrect behavior and will be lost if 
//     the code is regenerated.
// </autogenerated>
//------------------------------------------------------------------------------

namespace comp_ingreso {
    using System;
    using System.ComponentModel;
    using CrystalDecisions.Shared;
    using CrystalDecisions.ReportSource;
    using CrystalDecisions.CrystalReports.Engine;
    
    
    public class ComprobanteCurso : ReportClass {
        
        public ComprobanteCurso() {
        }
        
        public override String ResourceName {
            get {
                return "ComprobanteCurso.rpt";
            }
            set {
                // Do nothing
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public Section Section1 {
            get {
                return this.ReportDefinition.Sections[0];
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public Section Section2 {
            get {
                return this.ReportDefinition.Sections[1];
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public Section Section6 {
            get {
                return this.ReportDefinition.Sections[2];
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public Section Section3 {
            get {
                return this.ReportDefinition.Sections[3];
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public Section Section7 {
            get {
                return this.ReportDefinition.Sections[4];
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public Section Section4 {
            get {
                return this.ReportDefinition.Sections[5];
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public Section Section5 {
            get {
                return this.ReportDefinition.Sections[6];
            }
        }
    }
    
    [System.Drawing.ToolboxBitmapAttribute(typeof(CrystalDecisions.Shared.ExportOptions), "report.bmp")]
    public class CachedComprobanteCurso : Component, ICachedReport {
        
        public CachedComprobanteCurso() {
        }
        
        public virtual Boolean IsCacheable {
            get {
                return true;
            }
            set {
                // 
            }
        }
        
        public virtual Boolean ShareDBLogonInfo {
            get {
                return false;
            }
            set {
                // 
            }
        }
        
        public virtual TimeSpan CacheTimeOut {
            get {
                return CachedReportConstants.DEFAULT_TIMEOUT;
            }
            set {
                // 
            }
        }
        
        public virtual ReportDocument CreateReport() {
            ComprobanteCurso rpt = new ComprobanteCurso();
            rpt.Site = this.Site;
            return rpt;
        }
        
        public virtual String GetCustomizedCacheKey(RequestContext request) {
            String key = null;
            // // The following is the code used to generate the default
            // // cache key for caching report jobs in the ASP.NET Cache.
            // // Feel free to modify this code to suit your needs.
            // // Returning key == null causes the default cache key to
            // // be generated.
            // 
            // key = RequestContext.BuildCompleteCacheKey(
            //     request,
            //     null,       // sReportFilename
            //     this.GetType(),
            //     this.ShareDBLogonInfo );
            return key;
        }
    }
}

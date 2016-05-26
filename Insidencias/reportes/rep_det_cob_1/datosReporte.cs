﻿//------------------------------------------------------------------------------
// <autogenerated>
//     This code was generated by a tool.
//     Runtime Version: 1.0.3705.0
//
//     Changes to this file may cause incorrect behavior and will be lost if 
//     the code is regenerated.
// </autogenerated>
//------------------------------------------------------------------------------

namespace rep_det_cob {
    using System;
    using System.Data;
    using System.Xml;
    using System.Runtime.Serialization;
    
    
    [Serializable()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Diagnostics.DebuggerStepThrough()]
    [System.ComponentModel.ToolboxItem(true)]
    public class datosReporte : DataSet {
        
        private reporteDataTable tablereporte;
        
        public datosReporte() {
            this.InitClass();
            System.ComponentModel.CollectionChangeEventHandler schemaChangedHandler = new System.ComponentModel.CollectionChangeEventHandler(this.SchemaChanged);
            this.Tables.CollectionChanged += schemaChangedHandler;
            this.Relations.CollectionChanged += schemaChangedHandler;
        }
        
        protected datosReporte(SerializationInfo info, StreamingContext context) {
            string strSchema = ((string)(info.GetValue("XmlSchema", typeof(string))));
            if ((strSchema != null)) {
                DataSet ds = new DataSet();
                ds.ReadXmlSchema(new XmlTextReader(new System.IO.StringReader(strSchema)));
                if ((ds.Tables["reporte"] != null)) {
                    this.Tables.Add(new reporteDataTable(ds.Tables["reporte"]));
                }
                this.DataSetName = ds.DataSetName;
                this.Prefix = ds.Prefix;
                this.Namespace = ds.Namespace;
                this.Locale = ds.Locale;
                this.CaseSensitive = ds.CaseSensitive;
                this.EnforceConstraints = ds.EnforceConstraints;
                this.Merge(ds, false, System.Data.MissingSchemaAction.Add);
                this.InitVars();
            }
            else {
                this.InitClass();
            }
            this.GetSerializationData(info, context);
            System.ComponentModel.CollectionChangeEventHandler schemaChangedHandler = new System.ComponentModel.CollectionChangeEventHandler(this.SchemaChanged);
            this.Tables.CollectionChanged += schemaChangedHandler;
            this.Relations.CollectionChanged += schemaChangedHandler;
        }
        
        [System.ComponentModel.Browsable(false)]
        [System.ComponentModel.DesignerSerializationVisibilityAttribute(System.ComponentModel.DesignerSerializationVisibility.Content)]
        public reporteDataTable reporte {
            get {
                return this.tablereporte;
            }
        }
        
        public override DataSet Clone() {
            datosReporte cln = ((datosReporte)(base.Clone()));
            cln.InitVars();
            return cln;
        }
        
        protected override bool ShouldSerializeTables() {
            return false;
        }
        
        protected override bool ShouldSerializeRelations() {
            return false;
        }
        
        protected override void ReadXmlSerializable(XmlReader reader) {
            this.Reset();
            DataSet ds = new DataSet();
            ds.ReadXml(reader);
            if ((ds.Tables["reporte"] != null)) {
                this.Tables.Add(new reporteDataTable(ds.Tables["reporte"]));
            }
            this.DataSetName = ds.DataSetName;
            this.Prefix = ds.Prefix;
            this.Namespace = ds.Namespace;
            this.Locale = ds.Locale;
            this.CaseSensitive = ds.CaseSensitive;
            this.EnforceConstraints = ds.EnforceConstraints;
            this.Merge(ds, false, System.Data.MissingSchemaAction.Add);
            this.InitVars();
        }
        
        protected override System.Xml.Schema.XmlSchema GetSchemaSerializable() {
            System.IO.MemoryStream stream = new System.IO.MemoryStream();
            this.WriteXmlSchema(new XmlTextWriter(stream, null));
            stream.Position = 0;
            return System.Xml.Schema.XmlSchema.Read(new XmlTextReader(stream), null);
        }
        
        internal void InitVars() {
            this.tablereporte = ((reporteDataTable)(this.Tables["reporte"]));
            if ((this.tablereporte != null)) {
                this.tablereporte.InitVars();
            }
        }
        
        private void InitClass() {
            this.DataSetName = "datosReporte";
            this.Prefix = "";
            this.Namespace = "http://www.tempuri.org/datosReporte.xsd";
            this.Locale = new System.Globalization.CultureInfo("es-ES");
            this.CaseSensitive = false;
            this.EnforceConstraints = true;
            this.tablereporte = new reporteDataTable();
            this.Tables.Add(this.tablereporte);
        }
        
        private bool ShouldSerializereporte() {
            return false;
        }
        
        private void SchemaChanged(object sender, System.ComponentModel.CollectionChangeEventArgs e) {
            if ((e.Action == System.ComponentModel.CollectionChangeAction.Remove)) {
                this.InitVars();
            }
        }
        
        public delegate void reporteRowChangeEventHandler(object sender, reporteRowChangeEvent e);
        
        [System.Diagnostics.DebuggerStepThrough()]
        public class reporteDataTable : DataTable, System.Collections.IEnumerable {
            
            private DataColumn columnTIPO;
            
            private DataColumn columnFECHA_EMISION;
            
            private DataColumn columnNRO_NDOCTO;
            
            private DataColumn columnMONTO;
            
            private DataColumn columnFECHA_VEN;
            
            private DataColumn columnESTADO;
            
            private DataColumn columnRUT_ALUMNO;
            
            private DataColumn columnRUT_APODERADO;
            
            internal reporteDataTable() : 
                    base("reporte") {
                this.InitClass();
            }
            
            internal reporteDataTable(DataTable table) : 
                    base(table.TableName) {
                if ((table.CaseSensitive != table.DataSet.CaseSensitive)) {
                    this.CaseSensitive = table.CaseSensitive;
                }
                if ((table.Locale.ToString() != table.DataSet.Locale.ToString())) {
                    this.Locale = table.Locale;
                }
                if ((table.Namespace != table.DataSet.Namespace)) {
                    this.Namespace = table.Namespace;
                }
                this.Prefix = table.Prefix;
                this.MinimumCapacity = table.MinimumCapacity;
                this.DisplayExpression = table.DisplayExpression;
            }
            
            [System.ComponentModel.Browsable(false)]
            public int Count {
                get {
                    return this.Rows.Count;
                }
            }
            
            internal DataColumn TIPOColumn {
                get {
                    return this.columnTIPO;
                }
            }
            
            internal DataColumn FECHA_EMISIONColumn {
                get {
                    return this.columnFECHA_EMISION;
                }
            }
            
            internal DataColumn NRO_NDOCTOColumn {
                get {
                    return this.columnNRO_NDOCTO;
                }
            }
            
            internal DataColumn MONTOColumn {
                get {
                    return this.columnMONTO;
                }
            }
            
            internal DataColumn FECHA_VENColumn {
                get {
                    return this.columnFECHA_VEN;
                }
            }
            
            internal DataColumn ESTADOColumn {
                get {
                    return this.columnESTADO;
                }
            }
            
            internal DataColumn RUT_ALUMNOColumn {
                get {
                    return this.columnRUT_ALUMNO;
                }
            }
            
            internal DataColumn RUT_APODERADOColumn {
                get {
                    return this.columnRUT_APODERADO;
                }
            }
            
            public reporteRow this[int index] {
                get {
                    return ((reporteRow)(this.Rows[index]));
                }
            }
            
            public event reporteRowChangeEventHandler reporteRowChanged;
            
            public event reporteRowChangeEventHandler reporteRowChanging;
            
            public event reporteRowChangeEventHandler reporteRowDeleted;
            
            public event reporteRowChangeEventHandler reporteRowDeleting;
            
            public void AddreporteRow(reporteRow row) {
                this.Rows.Add(row);
            }
            
            public reporteRow AddreporteRow(string TIPO, string FECHA_EMISION, string NRO_NDOCTO, string MONTO, string FECHA_VEN, string ESTADO, string RUT_ALUMNO, string RUT_APODERADO) {
                reporteRow rowreporteRow = ((reporteRow)(this.NewRow()));
                rowreporteRow.ItemArray = new object[] {
                        TIPO,
                        FECHA_EMISION,
                        NRO_NDOCTO,
                        MONTO,
                        FECHA_VEN,
                        ESTADO,
                        RUT_ALUMNO,
                        RUT_APODERADO};
                this.Rows.Add(rowreporteRow);
                return rowreporteRow;
            }
            
            public System.Collections.IEnumerator GetEnumerator() {
                return this.Rows.GetEnumerator();
            }
            
            public override DataTable Clone() {
                reporteDataTable cln = ((reporteDataTable)(base.Clone()));
                cln.InitVars();
                return cln;
            }
            
            protected override DataTable CreateInstance() {
                return new reporteDataTable();
            }
            
            internal void InitVars() {
                this.columnTIPO = this.Columns["TIPO"];
                this.columnFECHA_EMISION = this.Columns["FECHA_EMISION"];
                this.columnNRO_NDOCTO = this.Columns["NRO_NDOCTO"];
                this.columnMONTO = this.Columns["MONTO"];
                this.columnFECHA_VEN = this.Columns["FECHA_VEN"];
                this.columnESTADO = this.Columns["ESTADO"];
                this.columnRUT_ALUMNO = this.Columns["RUT_ALUMNO"];
                this.columnRUT_APODERADO = this.Columns["RUT_APODERADO"];
            }
            
            private void InitClass() {
                this.columnTIPO = new DataColumn("TIPO", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnTIPO);
                this.columnFECHA_EMISION = new DataColumn("FECHA_EMISION", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnFECHA_EMISION);
                this.columnNRO_NDOCTO = new DataColumn("NRO_NDOCTO", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnNRO_NDOCTO);
                this.columnMONTO = new DataColumn("MONTO", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnMONTO);
                this.columnFECHA_VEN = new DataColumn("FECHA_VEN", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnFECHA_VEN);
                this.columnESTADO = new DataColumn("ESTADO", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnESTADO);
                this.columnRUT_ALUMNO = new DataColumn("RUT_ALUMNO", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnRUT_ALUMNO);
                this.columnRUT_APODERADO = new DataColumn("RUT_APODERADO", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnRUT_APODERADO);
                this.columnTIPO.ReadOnly = true;
                this.columnFECHA_EMISION.ReadOnly = true;
                this.columnNRO_NDOCTO.ReadOnly = true;
                this.columnMONTO.ReadOnly = true;
                this.columnFECHA_VEN.ReadOnly = true;
                this.columnESTADO.ReadOnly = true;
                this.columnRUT_ALUMNO.ReadOnly = true;
                this.columnRUT_APODERADO.ReadOnly = true;
            }
            
            public reporteRow NewreporteRow() {
                return ((reporteRow)(this.NewRow()));
            }
            
            protected override DataRow NewRowFromBuilder(DataRowBuilder builder) {
                return new reporteRow(builder);
            }
            
            protected override System.Type GetRowType() {
                return typeof(reporteRow);
            }
            
            protected override void OnRowChanged(DataRowChangeEventArgs e) {
                base.OnRowChanged(e);
                if ((this.reporteRowChanged != null)) {
                    this.reporteRowChanged(this, new reporteRowChangeEvent(((reporteRow)(e.Row)), e.Action));
                }
            }
            
            protected override void OnRowChanging(DataRowChangeEventArgs e) {
                base.OnRowChanging(e);
                if ((this.reporteRowChanging != null)) {
                    this.reporteRowChanging(this, new reporteRowChangeEvent(((reporteRow)(e.Row)), e.Action));
                }
            }
            
            protected override void OnRowDeleted(DataRowChangeEventArgs e) {
                base.OnRowDeleted(e);
                if ((this.reporteRowDeleted != null)) {
                    this.reporteRowDeleted(this, new reporteRowChangeEvent(((reporteRow)(e.Row)), e.Action));
                }
            }
            
            protected override void OnRowDeleting(DataRowChangeEventArgs e) {
                base.OnRowDeleting(e);
                if ((this.reporteRowDeleting != null)) {
                    this.reporteRowDeleting(this, new reporteRowChangeEvent(((reporteRow)(e.Row)), e.Action));
                }
            }
            
            public void RemovereporteRow(reporteRow row) {
                this.Rows.Remove(row);
            }
        }
        
        [System.Diagnostics.DebuggerStepThrough()]
        public class reporteRow : DataRow {
            
            private reporteDataTable tablereporte;
            
            internal reporteRow(DataRowBuilder rb) : 
                    base(rb) {
                this.tablereporte = ((reporteDataTable)(this.Table));
            }
            
            public string TIPO {
                get {
                    try {
                        return ((string)(this[this.tablereporte.TIPOColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.tablereporte.TIPOColumn] = value;
                }
            }
            
            public string FECHA_EMISION {
                get {
                    try {
                        return ((string)(this[this.tablereporte.FECHA_EMISIONColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.tablereporte.FECHA_EMISIONColumn] = value;
                }
            }
            
            public string NRO_NDOCTO {
                get {
                    try {
                        return ((string)(this[this.tablereporte.NRO_NDOCTOColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.tablereporte.NRO_NDOCTOColumn] = value;
                }
            }
            
            public string MONTO {
                get {
                    try {
                        return ((string)(this[this.tablereporte.MONTOColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.tablereporte.MONTOColumn] = value;
                }
            }
            
            public string FECHA_VEN {
                get {
                    try {
                        return ((string)(this[this.tablereporte.FECHA_VENColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.tablereporte.FECHA_VENColumn] = value;
                }
            }
            
            public string ESTADO {
                get {
                    try {
                        return ((string)(this[this.tablereporte.ESTADOColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.tablereporte.ESTADOColumn] = value;
                }
            }
            
            public string RUT_ALUMNO {
                get {
                    try {
                        return ((string)(this[this.tablereporte.RUT_ALUMNOColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.tablereporte.RUT_ALUMNOColumn] = value;
                }
            }
            
            public string RUT_APODERADO {
                get {
                    try {
                        return ((string)(this[this.tablereporte.RUT_APODERADOColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.tablereporte.RUT_APODERADOColumn] = value;
                }
            }
            
            public bool IsTIPONull() {
                return this.IsNull(this.tablereporte.TIPOColumn);
            }
            
            public void SetTIPONull() {
                this[this.tablereporte.TIPOColumn] = System.Convert.DBNull;
            }
            
            public bool IsFECHA_EMISIONNull() {
                return this.IsNull(this.tablereporte.FECHA_EMISIONColumn);
            }
            
            public void SetFECHA_EMISIONNull() {
                this[this.tablereporte.FECHA_EMISIONColumn] = System.Convert.DBNull;
            }
            
            public bool IsNRO_NDOCTONull() {
                return this.IsNull(this.tablereporte.NRO_NDOCTOColumn);
            }
            
            public void SetNRO_NDOCTONull() {
                this[this.tablereporte.NRO_NDOCTOColumn] = System.Convert.DBNull;
            }
            
            public bool IsMONTONull() {
                return this.IsNull(this.tablereporte.MONTOColumn);
            }
            
            public void SetMONTONull() {
                this[this.tablereporte.MONTOColumn] = System.Convert.DBNull;
            }
            
            public bool IsFECHA_VENNull() {
                return this.IsNull(this.tablereporte.FECHA_VENColumn);
            }
            
            public void SetFECHA_VENNull() {
                this[this.tablereporte.FECHA_VENColumn] = System.Convert.DBNull;
            }
            
            public bool IsESTADONull() {
                return this.IsNull(this.tablereporte.ESTADOColumn);
            }
            
            public void SetESTADONull() {
                this[this.tablereporte.ESTADOColumn] = System.Convert.DBNull;
            }
            
            public bool IsRUT_ALUMNONull() {
                return this.IsNull(this.tablereporte.RUT_ALUMNOColumn);
            }
            
            public void SetRUT_ALUMNONull() {
                this[this.tablereporte.RUT_ALUMNOColumn] = System.Convert.DBNull;
            }
            
            public bool IsRUT_APODERADONull() {
                return this.IsNull(this.tablereporte.RUT_APODERADOColumn);
            }
            
            public void SetRUT_APODERADONull() {
                this[this.tablereporte.RUT_APODERADOColumn] = System.Convert.DBNull;
            }
        }
        
        [System.Diagnostics.DebuggerStepThrough()]
        public class reporteRowChangeEvent : EventArgs {
            
            private reporteRow eventRow;
            
            private DataRowAction eventAction;
            
            public reporteRowChangeEvent(reporteRow row, DataRowAction action) {
                this.eventRow = row;
                this.eventAction = action;
            }
            
            public reporteRow Row {
                get {
                    return this.eventRow;
                }
            }
            
            public DataRowAction Action {
                get {
                    return this.eventAction;
                }
            }
        }
    }
}

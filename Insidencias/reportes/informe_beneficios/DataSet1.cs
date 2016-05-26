﻿//------------------------------------------------------------------------------
// <autogenerated>
//     This code was generated by a tool.
//     Runtime Version: 1.0.3705.0
//
//     Changes to this file may cause incorrect behavior and will be lost if 
//     the code is regenerated.
// </autogenerated>
//------------------------------------------------------------------------------

namespace informe_beneficios {
    using System;
    using System.Data;
    using System.Xml;
    using System.Runtime.Serialization;
    
    
    [Serializable()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Diagnostics.DebuggerStepThrough()]
    [System.ComponentModel.ToolboxItem(true)]
    public class DataSet1 : DataSet {
        
        private _TableDataTable table_Table;
        
        public DataSet1() {
            this.InitClass();
            System.ComponentModel.CollectionChangeEventHandler schemaChangedHandler = new System.ComponentModel.CollectionChangeEventHandler(this.SchemaChanged);
            this.Tables.CollectionChanged += schemaChangedHandler;
            this.Relations.CollectionChanged += schemaChangedHandler;
        }
        
        protected DataSet1(SerializationInfo info, StreamingContext context) {
            string strSchema = ((string)(info.GetValue("XmlSchema", typeof(string))));
            if ((strSchema != null)) {
                DataSet ds = new DataSet();
                ds.ReadXmlSchema(new XmlTextReader(new System.IO.StringReader(strSchema)));
                if ((ds.Tables["Table"] != null)) {
                    this.Tables.Add(new _TableDataTable(ds.Tables["Table"]));
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
        public _TableDataTable _Table {
            get {
                return this.table_Table;
            }
        }
        
        public override DataSet Clone() {
            DataSet1 cln = ((DataSet1)(base.Clone()));
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
            if ((ds.Tables["Table"] != null)) {
                this.Tables.Add(new _TableDataTable(ds.Tables["Table"]));
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
            this.table_Table = ((_TableDataTable)(this.Tables["Table"]));
            if ((this.table_Table != null)) {
                this.table_Table.InitVars();
            }
        }
        
        private void InitClass() {
            this.DataSetName = "DataSet1";
            this.Prefix = "";
            this.Namespace = "http://www.tempuri.org/DataSet1.xsd";
            this.Locale = new System.Globalization.CultureInfo("es-CL");
            this.CaseSensitive = false;
            this.EnforceConstraints = true;
            this.table_Table = new _TableDataTable();
            this.Tables.Add(this.table_Table);
        }
        
        private bool ShouldSerialize_Table() {
            return false;
        }
        
        private void SchemaChanged(object sender, System.ComponentModel.CollectionChangeEventArgs e) {
            if ((e.Action == System.ComponentModel.CollectionChangeAction.Remove)) {
                this.InitVars();
            }
        }
        
        public delegate void _TableRowChangeEventHandler(object sender, _TableRowChangeEvent e);
        
        [System.Diagnostics.DebuggerStepThrough()]
        public class _TableDataTable : DataTable, System.Collections.IEnumerable {
            
            private DataColumn columnTBEN_TDESC;
            
            private DataColumn columnSTDE_CCOD;
            
            private DataColumn columnSTDE_TDESC;
            
            private DataColumn columnESDE_TDESC;
            
            private DataColumn columnPOST_NCORR;
            
            private DataColumn columnPERS_NCORR;
            
            private DataColumn columnESDE_TDESC1;
            
            private DataColumn columnOFER_NCORR;
            
            private DataColumn columnSEDE_CCOD;
            
            private DataColumn columnRUT_ALUMNO;
            
            private DataColumn columnPERS_NRUT;
            
            private DataColumn columnNOMBRE_ALUMNO;
            
            private DataColumn columnCARR_TDESC;
            
            private DataColumn columnSDES_MMATRICULA;
            
            private DataColumn columnSDES_NPORC_MATRICULA;
            
            private DataColumn columnSDES_MCOLEGIATURA;
            
            private DataColumn columnSDES_NPORC_COLEGIATURA;
            
            private DataColumn columnSUBTOTAL;
            
            private DataColumn columnESDE_CCOD;
            
            internal _TableDataTable() : 
                    base("Table") {
                this.InitClass();
            }
            
            internal _TableDataTable(DataTable table) : 
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
            
            internal DataColumn TBEN_TDESCColumn {
                get {
                    return this.columnTBEN_TDESC;
                }
            }
            
            internal DataColumn STDE_CCODColumn {
                get {
                    return this.columnSTDE_CCOD;
                }
            }
            
            internal DataColumn STDE_TDESCColumn {
                get {
                    return this.columnSTDE_TDESC;
                }
            }
            
            internal DataColumn ESDE_TDESCColumn {
                get {
                    return this.columnESDE_TDESC;
                }
            }
            
            internal DataColumn POST_NCORRColumn {
                get {
                    return this.columnPOST_NCORR;
                }
            }
            
            internal DataColumn PERS_NCORRColumn {
                get {
                    return this.columnPERS_NCORR;
                }
            }
            
            internal DataColumn ESDE_TDESC1Column {
                get {
                    return this.columnESDE_TDESC1;
                }
            }
            
            internal DataColumn OFER_NCORRColumn {
                get {
                    return this.columnOFER_NCORR;
                }
            }
            
            internal DataColumn SEDE_CCODColumn {
                get {
                    return this.columnSEDE_CCOD;
                }
            }
            
            internal DataColumn RUT_ALUMNOColumn {
                get {
                    return this.columnRUT_ALUMNO;
                }
            }
            
            internal DataColumn PERS_NRUTColumn {
                get {
                    return this.columnPERS_NRUT;
                }
            }
            
            internal DataColumn NOMBRE_ALUMNOColumn {
                get {
                    return this.columnNOMBRE_ALUMNO;
                }
            }
            
            internal DataColumn CARR_TDESCColumn {
                get {
                    return this.columnCARR_TDESC;
                }
            }
            
            internal DataColumn SDES_MMATRICULAColumn {
                get {
                    return this.columnSDES_MMATRICULA;
                }
            }
            
            internal DataColumn SDES_NPORC_MATRICULAColumn {
                get {
                    return this.columnSDES_NPORC_MATRICULA;
                }
            }
            
            internal DataColumn SDES_MCOLEGIATURAColumn {
                get {
                    return this.columnSDES_MCOLEGIATURA;
                }
            }
            
            internal DataColumn SDES_NPORC_COLEGIATURAColumn {
                get {
                    return this.columnSDES_NPORC_COLEGIATURA;
                }
            }
            
            internal DataColumn SUBTOTALColumn {
                get {
                    return this.columnSUBTOTAL;
                }
            }
            
            internal DataColumn ESDE_CCODColumn {
                get {
                    return this.columnESDE_CCOD;
                }
            }
            
            public _TableRow this[int index] {
                get {
                    return ((_TableRow)(this.Rows[index]));
                }
            }
            
            public event _TableRowChangeEventHandler _TableRowChanged;
            
            public event _TableRowChangeEventHandler _TableRowChanging;
            
            public event _TableRowChangeEventHandler _TableRowDeleted;
            
            public event _TableRowChangeEventHandler _TableRowDeleting;
            
            public void Add_TableRow(_TableRow row) {
                this.Rows.Add(row);
            }
            
            public _TableRow Add_TableRow(
                        string TBEN_TDESC, 
                        string STDE_CCOD, 
                        string STDE_TDESC, 
                        string ESDE_TDESC, 
                        string POST_NCORR, 
                        string PERS_NCORR, 
                        string ESDE_TDESC1, 
                        string OFER_NCORR, 
                        string SEDE_CCOD, 
                        string RUT_ALUMNO, 
                        string PERS_NRUT, 
                        string NOMBRE_ALUMNO, 
                        string CARR_TDESC, 
                        string SDES_MMATRICULA, 
                        string SDES_NPORC_MATRICULA, 
                        string SDES_MCOLEGIATURA, 
                        string SDES_NPORC_COLEGIATURA, 
                        string SUBTOTAL, 
                        string ESDE_CCOD) {
                _TableRow row_TableRow = ((_TableRow)(this.NewRow()));
                row_TableRow.ItemArray = new object[] {
                        TBEN_TDESC,
                        STDE_CCOD,
                        STDE_TDESC,
                        ESDE_TDESC,
                        POST_NCORR,
                        PERS_NCORR,
                        ESDE_TDESC1,
                        OFER_NCORR,
                        SEDE_CCOD,
                        RUT_ALUMNO,
                        PERS_NRUT,
                        NOMBRE_ALUMNO,
                        CARR_TDESC,
                        SDES_MMATRICULA,
                        SDES_NPORC_MATRICULA,
                        SDES_MCOLEGIATURA,
                        SDES_NPORC_COLEGIATURA,
                        SUBTOTAL,
                        ESDE_CCOD};
                this.Rows.Add(row_TableRow);
                return row_TableRow;
            }
            
            public System.Collections.IEnumerator GetEnumerator() {
                return this.Rows.GetEnumerator();
            }
            
            public override DataTable Clone() {
                _TableDataTable cln = ((_TableDataTable)(base.Clone()));
                cln.InitVars();
                return cln;
            }
            
            protected override DataTable CreateInstance() {
                return new _TableDataTable();
            }
            
            internal void InitVars() {
                this.columnTBEN_TDESC = this.Columns["TBEN_TDESC"];
                this.columnSTDE_CCOD = this.Columns["STDE_CCOD"];
                this.columnSTDE_TDESC = this.Columns["STDE_TDESC"];
                this.columnESDE_TDESC = this.Columns["ESDE_TDESC"];
                this.columnPOST_NCORR = this.Columns["POST_NCORR"];
                this.columnPERS_NCORR = this.Columns["PERS_NCORR"];
                this.columnESDE_TDESC1 = this.Columns["ESDE_TDESC1"];
                this.columnOFER_NCORR = this.Columns["OFER_NCORR"];
                this.columnSEDE_CCOD = this.Columns["SEDE_CCOD"];
                this.columnRUT_ALUMNO = this.Columns["RUT_ALUMNO"];
                this.columnPERS_NRUT = this.Columns["PERS_NRUT"];
                this.columnNOMBRE_ALUMNO = this.Columns["NOMBRE_ALUMNO"];
                this.columnCARR_TDESC = this.Columns["CARR_TDESC"];
                this.columnSDES_MMATRICULA = this.Columns["SDES_MMATRICULA"];
                this.columnSDES_NPORC_MATRICULA = this.Columns["SDES_NPORC_MATRICULA"];
                this.columnSDES_MCOLEGIATURA = this.Columns["SDES_MCOLEGIATURA"];
                this.columnSDES_NPORC_COLEGIATURA = this.Columns["SDES_NPORC_COLEGIATURA"];
                this.columnSUBTOTAL = this.Columns["SUBTOTAL"];
                this.columnESDE_CCOD = this.Columns["ESDE_CCOD"];
            }
            
            private void InitClass() {
                this.columnTBEN_TDESC = new DataColumn("TBEN_TDESC", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnTBEN_TDESC);
                this.columnSTDE_CCOD = new DataColumn("STDE_CCOD", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnSTDE_CCOD);
                this.columnSTDE_TDESC = new DataColumn("STDE_TDESC", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnSTDE_TDESC);
                this.columnESDE_TDESC = new DataColumn("ESDE_TDESC", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnESDE_TDESC);
                this.columnPOST_NCORR = new DataColumn("POST_NCORR", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnPOST_NCORR);
                this.columnPERS_NCORR = new DataColumn("PERS_NCORR", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnPERS_NCORR);
                this.columnESDE_TDESC1 = new DataColumn("ESDE_TDESC1", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnESDE_TDESC1);
                this.columnOFER_NCORR = new DataColumn("OFER_NCORR", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnOFER_NCORR);
                this.columnSEDE_CCOD = new DataColumn("SEDE_CCOD", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnSEDE_CCOD);
                this.columnRUT_ALUMNO = new DataColumn("RUT_ALUMNO", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnRUT_ALUMNO);
                this.columnPERS_NRUT = new DataColumn("PERS_NRUT", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnPERS_NRUT);
                this.columnNOMBRE_ALUMNO = new DataColumn("NOMBRE_ALUMNO", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnNOMBRE_ALUMNO);
                this.columnCARR_TDESC = new DataColumn("CARR_TDESC", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnCARR_TDESC);
                this.columnSDES_MMATRICULA = new DataColumn("SDES_MMATRICULA", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnSDES_MMATRICULA);
                this.columnSDES_NPORC_MATRICULA = new DataColumn("SDES_NPORC_MATRICULA", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnSDES_NPORC_MATRICULA);
                this.columnSDES_MCOLEGIATURA = new DataColumn("SDES_MCOLEGIATURA", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnSDES_MCOLEGIATURA);
                this.columnSDES_NPORC_COLEGIATURA = new DataColumn("SDES_NPORC_COLEGIATURA", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnSDES_NPORC_COLEGIATURA);
                this.columnSUBTOTAL = new DataColumn("SUBTOTAL", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnSUBTOTAL);
                this.columnESDE_CCOD = new DataColumn("ESDE_CCOD", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnESDE_CCOD);
                this.columnTBEN_TDESC.ReadOnly = true;
                this.columnSTDE_CCOD.ReadOnly = true;
                this.columnSTDE_TDESC.ReadOnly = true;
                this.columnESDE_TDESC.ReadOnly = true;
                this.columnPOST_NCORR.ReadOnly = true;
                this.columnPERS_NCORR.ReadOnly = true;
                this.columnESDE_TDESC1.ReadOnly = true;
                this.columnOFER_NCORR.ReadOnly = true;
                this.columnSEDE_CCOD.ReadOnly = true;
                this.columnRUT_ALUMNO.ReadOnly = true;
                this.columnPERS_NRUT.ReadOnly = true;
                this.columnNOMBRE_ALUMNO.ReadOnly = true;
                this.columnCARR_TDESC.ReadOnly = true;
                this.columnSDES_MMATRICULA.ReadOnly = true;
                this.columnSDES_NPORC_MATRICULA.ReadOnly = true;
                this.columnSDES_MCOLEGIATURA.ReadOnly = true;
                this.columnSDES_NPORC_COLEGIATURA.ReadOnly = true;
                this.columnSUBTOTAL.ReadOnly = true;
                this.columnESDE_CCOD.ReadOnly = true;
            }
            
            public _TableRow New_TableRow() {
                return ((_TableRow)(this.NewRow()));
            }
            
            protected override DataRow NewRowFromBuilder(DataRowBuilder builder) {
                return new _TableRow(builder);
            }
            
            protected override System.Type GetRowType() {
                return typeof(_TableRow);
            }
            
            protected override void OnRowChanged(DataRowChangeEventArgs e) {
                base.OnRowChanged(e);
                if ((this._TableRowChanged != null)) {
                    this._TableRowChanged(this, new _TableRowChangeEvent(((_TableRow)(e.Row)), e.Action));
                }
            }
            
            protected override void OnRowChanging(DataRowChangeEventArgs e) {
                base.OnRowChanging(e);
                if ((this._TableRowChanging != null)) {
                    this._TableRowChanging(this, new _TableRowChangeEvent(((_TableRow)(e.Row)), e.Action));
                }
            }
            
            protected override void OnRowDeleted(DataRowChangeEventArgs e) {
                base.OnRowDeleted(e);
                if ((this._TableRowDeleted != null)) {
                    this._TableRowDeleted(this, new _TableRowChangeEvent(((_TableRow)(e.Row)), e.Action));
                }
            }
            
            protected override void OnRowDeleting(DataRowChangeEventArgs e) {
                base.OnRowDeleting(e);
                if ((this._TableRowDeleting != null)) {
                    this._TableRowDeleting(this, new _TableRowChangeEvent(((_TableRow)(e.Row)), e.Action));
                }
            }
            
            public void Remove_TableRow(_TableRow row) {
                this.Rows.Remove(row);
            }
        }
        
        [System.Diagnostics.DebuggerStepThrough()]
        public class _TableRow : DataRow {
            
            private _TableDataTable table_Table;
            
            internal _TableRow(DataRowBuilder rb) : 
                    base(rb) {
                this.table_Table = ((_TableDataTable)(this.Table));
            }
            
            public string TBEN_TDESC {
                get {
                    try {
                        return ((string)(this[this.table_Table.TBEN_TDESCColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.table_Table.TBEN_TDESCColumn] = value;
                }
            }
            
            public string STDE_CCOD {
                get {
                    try {
                        return ((string)(this[this.table_Table.STDE_CCODColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.table_Table.STDE_CCODColumn] = value;
                }
            }
            
            public string STDE_TDESC {
                get {
                    try {
                        return ((string)(this[this.table_Table.STDE_TDESCColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.table_Table.STDE_TDESCColumn] = value;
                }
            }
            
            public string ESDE_TDESC {
                get {
                    try {
                        return ((string)(this[this.table_Table.ESDE_TDESCColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.table_Table.ESDE_TDESCColumn] = value;
                }
            }
            
            public string POST_NCORR {
                get {
                    try {
                        return ((string)(this[this.table_Table.POST_NCORRColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.table_Table.POST_NCORRColumn] = value;
                }
            }
            
            public string PERS_NCORR {
                get {
                    try {
                        return ((string)(this[this.table_Table.PERS_NCORRColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.table_Table.PERS_NCORRColumn] = value;
                }
            }
            
            public string ESDE_TDESC1 {
                get {
                    try {
                        return ((string)(this[this.table_Table.ESDE_TDESC1Column]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.table_Table.ESDE_TDESC1Column] = value;
                }
            }
            
            public string OFER_NCORR {
                get {
                    try {
                        return ((string)(this[this.table_Table.OFER_NCORRColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.table_Table.OFER_NCORRColumn] = value;
                }
            }
            
            public string SEDE_CCOD {
                get {
                    try {
                        return ((string)(this[this.table_Table.SEDE_CCODColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.table_Table.SEDE_CCODColumn] = value;
                }
            }
            
            public string RUT_ALUMNO {
                get {
                    try {
                        return ((string)(this[this.table_Table.RUT_ALUMNOColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.table_Table.RUT_ALUMNOColumn] = value;
                }
            }
            
            public string PERS_NRUT {
                get {
                    try {
                        return ((string)(this[this.table_Table.PERS_NRUTColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.table_Table.PERS_NRUTColumn] = value;
                }
            }
            
            public string NOMBRE_ALUMNO {
                get {
                    try {
                        return ((string)(this[this.table_Table.NOMBRE_ALUMNOColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.table_Table.NOMBRE_ALUMNOColumn] = value;
                }
            }
            
            public string CARR_TDESC {
                get {
                    try {
                        return ((string)(this[this.table_Table.CARR_TDESCColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.table_Table.CARR_TDESCColumn] = value;
                }
            }
            
            public string SDES_MMATRICULA {
                get {
                    try {
                        return ((string)(this[this.table_Table.SDES_MMATRICULAColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.table_Table.SDES_MMATRICULAColumn] = value;
                }
            }
            
            public string SDES_NPORC_MATRICULA {
                get {
                    try {
                        return ((string)(this[this.table_Table.SDES_NPORC_MATRICULAColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.table_Table.SDES_NPORC_MATRICULAColumn] = value;
                }
            }
            
            public string SDES_MCOLEGIATURA {
                get {
                    try {
                        return ((string)(this[this.table_Table.SDES_MCOLEGIATURAColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.table_Table.SDES_MCOLEGIATURAColumn] = value;
                }
            }
            
            public string SDES_NPORC_COLEGIATURA {
                get {
                    try {
                        return ((string)(this[this.table_Table.SDES_NPORC_COLEGIATURAColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.table_Table.SDES_NPORC_COLEGIATURAColumn] = value;
                }
            }
            
            public string SUBTOTAL {
                get {
                    try {
                        return ((string)(this[this.table_Table.SUBTOTALColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.table_Table.SUBTOTALColumn] = value;
                }
            }
            
            public string ESDE_CCOD {
                get {
                    try {
                        return ((string)(this[this.table_Table.ESDE_CCODColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.table_Table.ESDE_CCODColumn] = value;
                }
            }
            
            public bool IsTBEN_TDESCNull() {
                return this.IsNull(this.table_Table.TBEN_TDESCColumn);
            }
            
            public void SetTBEN_TDESCNull() {
                this[this.table_Table.TBEN_TDESCColumn] = System.Convert.DBNull;
            }
            
            public bool IsSTDE_CCODNull() {
                return this.IsNull(this.table_Table.STDE_CCODColumn);
            }
            
            public void SetSTDE_CCODNull() {
                this[this.table_Table.STDE_CCODColumn] = System.Convert.DBNull;
            }
            
            public bool IsSTDE_TDESCNull() {
                return this.IsNull(this.table_Table.STDE_TDESCColumn);
            }
            
            public void SetSTDE_TDESCNull() {
                this[this.table_Table.STDE_TDESCColumn] = System.Convert.DBNull;
            }
            
            public bool IsESDE_TDESCNull() {
                return this.IsNull(this.table_Table.ESDE_TDESCColumn);
            }
            
            public void SetESDE_TDESCNull() {
                this[this.table_Table.ESDE_TDESCColumn] = System.Convert.DBNull;
            }
            
            public bool IsPOST_NCORRNull() {
                return this.IsNull(this.table_Table.POST_NCORRColumn);
            }
            
            public void SetPOST_NCORRNull() {
                this[this.table_Table.POST_NCORRColumn] = System.Convert.DBNull;
            }
            
            public bool IsPERS_NCORRNull() {
                return this.IsNull(this.table_Table.PERS_NCORRColumn);
            }
            
            public void SetPERS_NCORRNull() {
                this[this.table_Table.PERS_NCORRColumn] = System.Convert.DBNull;
            }
            
            public bool IsESDE_TDESC1Null() {
                return this.IsNull(this.table_Table.ESDE_TDESC1Column);
            }
            
            public void SetESDE_TDESC1Null() {
                this[this.table_Table.ESDE_TDESC1Column] = System.Convert.DBNull;
            }
            
            public bool IsOFER_NCORRNull() {
                return this.IsNull(this.table_Table.OFER_NCORRColumn);
            }
            
            public void SetOFER_NCORRNull() {
                this[this.table_Table.OFER_NCORRColumn] = System.Convert.DBNull;
            }
            
            public bool IsSEDE_CCODNull() {
                return this.IsNull(this.table_Table.SEDE_CCODColumn);
            }
            
            public void SetSEDE_CCODNull() {
                this[this.table_Table.SEDE_CCODColumn] = System.Convert.DBNull;
            }
            
            public bool IsRUT_ALUMNONull() {
                return this.IsNull(this.table_Table.RUT_ALUMNOColumn);
            }
            
            public void SetRUT_ALUMNONull() {
                this[this.table_Table.RUT_ALUMNOColumn] = System.Convert.DBNull;
            }
            
            public bool IsPERS_NRUTNull() {
                return this.IsNull(this.table_Table.PERS_NRUTColumn);
            }
            
            public void SetPERS_NRUTNull() {
                this[this.table_Table.PERS_NRUTColumn] = System.Convert.DBNull;
            }
            
            public bool IsNOMBRE_ALUMNONull() {
                return this.IsNull(this.table_Table.NOMBRE_ALUMNOColumn);
            }
            
            public void SetNOMBRE_ALUMNONull() {
                this[this.table_Table.NOMBRE_ALUMNOColumn] = System.Convert.DBNull;
            }
            
            public bool IsCARR_TDESCNull() {
                return this.IsNull(this.table_Table.CARR_TDESCColumn);
            }
            
            public void SetCARR_TDESCNull() {
                this[this.table_Table.CARR_TDESCColumn] = System.Convert.DBNull;
            }
            
            public bool IsSDES_MMATRICULANull() {
                return this.IsNull(this.table_Table.SDES_MMATRICULAColumn);
            }
            
            public void SetSDES_MMATRICULANull() {
                this[this.table_Table.SDES_MMATRICULAColumn] = System.Convert.DBNull;
            }
            
            public bool IsSDES_NPORC_MATRICULANull() {
                return this.IsNull(this.table_Table.SDES_NPORC_MATRICULAColumn);
            }
            
            public void SetSDES_NPORC_MATRICULANull() {
                this[this.table_Table.SDES_NPORC_MATRICULAColumn] = System.Convert.DBNull;
            }
            
            public bool IsSDES_MCOLEGIATURANull() {
                return this.IsNull(this.table_Table.SDES_MCOLEGIATURAColumn);
            }
            
            public void SetSDES_MCOLEGIATURANull() {
                this[this.table_Table.SDES_MCOLEGIATURAColumn] = System.Convert.DBNull;
            }
            
            public bool IsSDES_NPORC_COLEGIATURANull() {
                return this.IsNull(this.table_Table.SDES_NPORC_COLEGIATURAColumn);
            }
            
            public void SetSDES_NPORC_COLEGIATURANull() {
                this[this.table_Table.SDES_NPORC_COLEGIATURAColumn] = System.Convert.DBNull;
            }
            
            public bool IsSUBTOTALNull() {
                return this.IsNull(this.table_Table.SUBTOTALColumn);
            }
            
            public void SetSUBTOTALNull() {
                this[this.table_Table.SUBTOTALColumn] = System.Convert.DBNull;
            }
            
            public bool IsESDE_CCODNull() {
                return this.IsNull(this.table_Table.ESDE_CCODColumn);
            }
            
            public void SetESDE_CCODNull() {
                this[this.table_Table.ESDE_CCODColumn] = System.Convert.DBNull;
            }
        }
        
        [System.Diagnostics.DebuggerStepThrough()]
        public class _TableRowChangeEvent : EventArgs {
            
            private _TableRow eventRow;
            
            private DataRowAction eventAction;
            
            public _TableRowChangeEvent(_TableRow row, DataRowAction action) {
                this.eventRow = row;
                this.eventAction = action;
            }
            
            public _TableRow Row {
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

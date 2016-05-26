﻿//------------------------------------------------------------------------------
// <autogenerated>
//     This code was generated by a tool.
//     Runtime Version: 1.0.3705.0
//
//     Changes to this file may cause incorrect behavior and will be lost if 
//     the code is regenerated.
// </autogenerated>
//------------------------------------------------------------------------------

namespace detalle_envio_notaria {
    using System;
    using System.Data;
    using System.Xml;
    using System.Runtime.Serialization;
    
    
    [Serializable()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Diagnostics.DebuggerStepThrough()]
    [System.ComponentModel.ToolboxItem(true)]
    public class DataSet1 : DataSet {
        
        private T_detallesDataTable tableT_detalles;
        
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
                if ((ds.Tables["T_detalles"] != null)) {
                    this.Tables.Add(new T_detallesDataTable(ds.Tables["T_detalles"]));
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
        public T_detallesDataTable T_detalles {
            get {
                return this.tableT_detalles;
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
            if ((ds.Tables["T_detalles"] != null)) {
                this.Tables.Add(new T_detallesDataTable(ds.Tables["T_detalles"]));
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
            this.tableT_detalles = ((T_detallesDataTable)(this.Tables["T_detalles"]));
            if ((this.tableT_detalles != null)) {
                this.tableT_detalles.InitVars();
            }
        }
        
        private void InitClass() {
            this.DataSetName = "DataSet1";
            this.Prefix = "";
            this.Namespace = "http://www.tempuri.org/DataSet1.xsd";
            this.Locale = new System.Globalization.CultureInfo("es-CL");
            this.CaseSensitive = false;
            this.EnforceConstraints = true;
            this.tableT_detalles = new T_detallesDataTable();
            this.Tables.Add(this.tableT_detalles);
        }
        
        private bool ShouldSerializeT_detalles() {
            return false;
        }
        
        private void SchemaChanged(object sender, System.ComponentModel.CollectionChangeEventArgs e) {
            if ((e.Action == System.ComponentModel.CollectionChangeAction.Remove)) {
                this.InitVars();
            }
        }
        
        public delegate void T_detallesRowChangeEventHandler(object sender, T_detallesRowChangeEvent e);
        
        [System.Diagnostics.DebuggerStepThrough()]
        public class T_detallesDataTable : DataTable, System.Collections.IEnumerable {
            
            private DataColumn columnENVI_NCORR;
            
            private DataColumn columnENVI_FENVIO;
            
            private DataColumn columnINEN_TDESC;
            
            private DataColumn columnTING_CCOD;
            
            private DataColumn columnINGR_NCORR;
            
            private DataColumn columnDING_NDOCTO;
            
            private DataColumn columnDING_MDOCTO;
            
            private DataColumn columnINGR_FPAGO;
            
            private DataColumn columnDING_FDOCTO;
            
            private DataColumn columnEDIN_TDESC;
            
            private DataColumn columnRUT_ALUMNO;
            
            private DataColumn columnRUT_APODERADO;
            
            private DataColumn columnNOMBRE_APODERADO;
            
            internal T_detallesDataTable() : 
                    base("T_detalles") {
                this.InitClass();
            }
            
            internal T_detallesDataTable(DataTable table) : 
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
            
            internal DataColumn ENVI_NCORRColumn {
                get {
                    return this.columnENVI_NCORR;
                }
            }
            
            internal DataColumn ENVI_FENVIOColumn {
                get {
                    return this.columnENVI_FENVIO;
                }
            }
            
            internal DataColumn INEN_TDESCColumn {
                get {
                    return this.columnINEN_TDESC;
                }
            }
            
            internal DataColumn TING_CCODColumn {
                get {
                    return this.columnTING_CCOD;
                }
            }
            
            internal DataColumn INGR_NCORRColumn {
                get {
                    return this.columnINGR_NCORR;
                }
            }
            
            internal DataColumn DING_NDOCTOColumn {
                get {
                    return this.columnDING_NDOCTO;
                }
            }
            
            internal DataColumn DING_MDOCTOColumn {
                get {
                    return this.columnDING_MDOCTO;
                }
            }
            
            internal DataColumn INGR_FPAGOColumn {
                get {
                    return this.columnINGR_FPAGO;
                }
            }
            
            internal DataColumn DING_FDOCTOColumn {
                get {
                    return this.columnDING_FDOCTO;
                }
            }
            
            internal DataColumn EDIN_TDESCColumn {
                get {
                    return this.columnEDIN_TDESC;
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
            
            internal DataColumn NOMBRE_APODERADOColumn {
                get {
                    return this.columnNOMBRE_APODERADO;
                }
            }
            
            public T_detallesRow this[int index] {
                get {
                    return ((T_detallesRow)(this.Rows[index]));
                }
            }
            
            public event T_detallesRowChangeEventHandler T_detallesRowChanged;
            
            public event T_detallesRowChangeEventHandler T_detallesRowChanging;
            
            public event T_detallesRowChangeEventHandler T_detallesRowDeleted;
            
            public event T_detallesRowChangeEventHandler T_detallesRowDeleting;
            
            public void AddT_detallesRow(T_detallesRow row) {
                this.Rows.Add(row);
            }
            
            public T_detallesRow AddT_detallesRow(string ENVI_NCORR, string ENVI_FENVIO, string INEN_TDESC, string TING_CCOD, string INGR_NCORR, string DING_NDOCTO, string DING_MDOCTO, string INGR_FPAGO, string DING_FDOCTO, string EDIN_TDESC, string RUT_ALUMNO, string RUT_APODERADO, string NOMBRE_APODERADO) {
                T_detallesRow rowT_detallesRow = ((T_detallesRow)(this.NewRow()));
                rowT_detallesRow.ItemArray = new object[] {
                        ENVI_NCORR,
                        ENVI_FENVIO,
                        INEN_TDESC,
                        TING_CCOD,
                        INGR_NCORR,
                        DING_NDOCTO,
                        DING_MDOCTO,
                        INGR_FPAGO,
                        DING_FDOCTO,
                        EDIN_TDESC,
                        RUT_ALUMNO,
                        RUT_APODERADO,
                        NOMBRE_APODERADO};
                this.Rows.Add(rowT_detallesRow);
                return rowT_detallesRow;
            }
            
            public System.Collections.IEnumerator GetEnumerator() {
                return this.Rows.GetEnumerator();
            }
            
            public override DataTable Clone() {
                T_detallesDataTable cln = ((T_detallesDataTable)(base.Clone()));
                cln.InitVars();
                return cln;
            }
            
            protected override DataTable CreateInstance() {
                return new T_detallesDataTable();
            }
            
            internal void InitVars() {
                this.columnENVI_NCORR = this.Columns["ENVI_NCORR"];
                this.columnENVI_FENVIO = this.Columns["ENVI_FENVIO"];
                this.columnINEN_TDESC = this.Columns["INEN_TDESC"];
                this.columnTING_CCOD = this.Columns["TING_CCOD"];
                this.columnINGR_NCORR = this.Columns["INGR_NCORR"];
                this.columnDING_NDOCTO = this.Columns["DING_NDOCTO"];
                this.columnDING_MDOCTO = this.Columns["DING_MDOCTO"];
                this.columnINGR_FPAGO = this.Columns["INGR_FPAGO"];
                this.columnDING_FDOCTO = this.Columns["DING_FDOCTO"];
                this.columnEDIN_TDESC = this.Columns["EDIN_TDESC"];
                this.columnRUT_ALUMNO = this.Columns["RUT_ALUMNO"];
                this.columnRUT_APODERADO = this.Columns["RUT_APODERADO"];
                this.columnNOMBRE_APODERADO = this.Columns["NOMBRE_APODERADO"];
            }
            
            private void InitClass() {
                this.columnENVI_NCORR = new DataColumn("ENVI_NCORR", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnENVI_NCORR);
                this.columnENVI_FENVIO = new DataColumn("ENVI_FENVIO", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnENVI_FENVIO);
                this.columnINEN_TDESC = new DataColumn("INEN_TDESC", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnINEN_TDESC);
                this.columnTING_CCOD = new DataColumn("TING_CCOD", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnTING_CCOD);
                this.columnINGR_NCORR = new DataColumn("INGR_NCORR", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnINGR_NCORR);
                this.columnDING_NDOCTO = new DataColumn("DING_NDOCTO", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnDING_NDOCTO);
                this.columnDING_MDOCTO = new DataColumn("DING_MDOCTO", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnDING_MDOCTO);
                this.columnINGR_FPAGO = new DataColumn("INGR_FPAGO", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnINGR_FPAGO);
                this.columnDING_FDOCTO = new DataColumn("DING_FDOCTO", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnDING_FDOCTO);
                this.columnEDIN_TDESC = new DataColumn("EDIN_TDESC", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnEDIN_TDESC);
                this.columnRUT_ALUMNO = new DataColumn("RUT_ALUMNO", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnRUT_ALUMNO);
                this.columnRUT_APODERADO = new DataColumn("RUT_APODERADO", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnRUT_APODERADO);
                this.columnNOMBRE_APODERADO = new DataColumn("NOMBRE_APODERADO", typeof(string), null, System.Data.MappingType.Element);
                this.Columns.Add(this.columnNOMBRE_APODERADO);
                this.columnENVI_NCORR.ReadOnly = true;
                this.columnENVI_FENVIO.ReadOnly = true;
                this.columnINEN_TDESC.ReadOnly = true;
                this.columnTING_CCOD.ReadOnly = true;
                this.columnINGR_NCORR.ReadOnly = true;
                this.columnDING_NDOCTO.ReadOnly = true;
                this.columnDING_MDOCTO.ReadOnly = true;
                this.columnINGR_FPAGO.ReadOnly = true;
                this.columnDING_FDOCTO.ReadOnly = true;
                this.columnEDIN_TDESC.ReadOnly = true;
                this.columnRUT_ALUMNO.ReadOnly = true;
                this.columnRUT_APODERADO.ReadOnly = true;
                this.columnNOMBRE_APODERADO.ReadOnly = true;
            }
            
            public T_detallesRow NewT_detallesRow() {
                return ((T_detallesRow)(this.NewRow()));
            }
            
            protected override DataRow NewRowFromBuilder(DataRowBuilder builder) {
                return new T_detallesRow(builder);
            }
            
            protected override System.Type GetRowType() {
                return typeof(T_detallesRow);
            }
            
            protected override void OnRowChanged(DataRowChangeEventArgs e) {
                base.OnRowChanged(e);
                if ((this.T_detallesRowChanged != null)) {
                    this.T_detallesRowChanged(this, new T_detallesRowChangeEvent(((T_detallesRow)(e.Row)), e.Action));
                }
            }
            
            protected override void OnRowChanging(DataRowChangeEventArgs e) {
                base.OnRowChanging(e);
                if ((this.T_detallesRowChanging != null)) {
                    this.T_detallesRowChanging(this, new T_detallesRowChangeEvent(((T_detallesRow)(e.Row)), e.Action));
                }
            }
            
            protected override void OnRowDeleted(DataRowChangeEventArgs e) {
                base.OnRowDeleted(e);
                if ((this.T_detallesRowDeleted != null)) {
                    this.T_detallesRowDeleted(this, new T_detallesRowChangeEvent(((T_detallesRow)(e.Row)), e.Action));
                }
            }
            
            protected override void OnRowDeleting(DataRowChangeEventArgs e) {
                base.OnRowDeleting(e);
                if ((this.T_detallesRowDeleting != null)) {
                    this.T_detallesRowDeleting(this, new T_detallesRowChangeEvent(((T_detallesRow)(e.Row)), e.Action));
                }
            }
            
            public void RemoveT_detallesRow(T_detallesRow row) {
                this.Rows.Remove(row);
            }
        }
        
        [System.Diagnostics.DebuggerStepThrough()]
        public class T_detallesRow : DataRow {
            
            private T_detallesDataTable tableT_detalles;
            
            internal T_detallesRow(DataRowBuilder rb) : 
                    base(rb) {
                this.tableT_detalles = ((T_detallesDataTable)(this.Table));
            }
            
            public string ENVI_NCORR {
                get {
                    try {
                        return ((string)(this[this.tableT_detalles.ENVI_NCORRColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.tableT_detalles.ENVI_NCORRColumn] = value;
                }
            }
            
            public string ENVI_FENVIO {
                get {
                    try {
                        return ((string)(this[this.tableT_detalles.ENVI_FENVIOColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.tableT_detalles.ENVI_FENVIOColumn] = value;
                }
            }
            
            public string INEN_TDESC {
                get {
                    try {
                        return ((string)(this[this.tableT_detalles.INEN_TDESCColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.tableT_detalles.INEN_TDESCColumn] = value;
                }
            }
            
            public string TING_CCOD {
                get {
                    try {
                        return ((string)(this[this.tableT_detalles.TING_CCODColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.tableT_detalles.TING_CCODColumn] = value;
                }
            }
            
            public string INGR_NCORR {
                get {
                    try {
                        return ((string)(this[this.tableT_detalles.INGR_NCORRColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.tableT_detalles.INGR_NCORRColumn] = value;
                }
            }
            
            public string DING_NDOCTO {
                get {
                    try {
                        return ((string)(this[this.tableT_detalles.DING_NDOCTOColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.tableT_detalles.DING_NDOCTOColumn] = value;
                }
            }
            
            public string DING_MDOCTO {
                get {
                    try {
                        return ((string)(this[this.tableT_detalles.DING_MDOCTOColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.tableT_detalles.DING_MDOCTOColumn] = value;
                }
            }
            
            public string INGR_FPAGO {
                get {
                    try {
                        return ((string)(this[this.tableT_detalles.INGR_FPAGOColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.tableT_detalles.INGR_FPAGOColumn] = value;
                }
            }
            
            public string DING_FDOCTO {
                get {
                    try {
                        return ((string)(this[this.tableT_detalles.DING_FDOCTOColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.tableT_detalles.DING_FDOCTOColumn] = value;
                }
            }
            
            public string EDIN_TDESC {
                get {
                    try {
                        return ((string)(this[this.tableT_detalles.EDIN_TDESCColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.tableT_detalles.EDIN_TDESCColumn] = value;
                }
            }
            
            public string RUT_ALUMNO {
                get {
                    try {
                        return ((string)(this[this.tableT_detalles.RUT_ALUMNOColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.tableT_detalles.RUT_ALUMNOColumn] = value;
                }
            }
            
            public string RUT_APODERADO {
                get {
                    try {
                        return ((string)(this[this.tableT_detalles.RUT_APODERADOColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.tableT_detalles.RUT_APODERADOColumn] = value;
                }
            }
            
            public string NOMBRE_APODERADO {
                get {
                    try {
                        return ((string)(this[this.tableT_detalles.NOMBRE_APODERADOColumn]));
                    }
                    catch (InvalidCastException e) {
                        throw new StrongTypingException("No se puede obtener el valor porque es DBNull.", e);
                    }
                }
                set {
                    this[this.tableT_detalles.NOMBRE_APODERADOColumn] = value;
                }
            }
            
            public bool IsENVI_NCORRNull() {
                return this.IsNull(this.tableT_detalles.ENVI_NCORRColumn);
            }
            
            public void SetENVI_NCORRNull() {
                this[this.tableT_detalles.ENVI_NCORRColumn] = System.Convert.DBNull;
            }
            
            public bool IsENVI_FENVIONull() {
                return this.IsNull(this.tableT_detalles.ENVI_FENVIOColumn);
            }
            
            public void SetENVI_FENVIONull() {
                this[this.tableT_detalles.ENVI_FENVIOColumn] = System.Convert.DBNull;
            }
            
            public bool IsINEN_TDESCNull() {
                return this.IsNull(this.tableT_detalles.INEN_TDESCColumn);
            }
            
            public void SetINEN_TDESCNull() {
                this[this.tableT_detalles.INEN_TDESCColumn] = System.Convert.DBNull;
            }
            
            public bool IsTING_CCODNull() {
                return this.IsNull(this.tableT_detalles.TING_CCODColumn);
            }
            
            public void SetTING_CCODNull() {
                this[this.tableT_detalles.TING_CCODColumn] = System.Convert.DBNull;
            }
            
            public bool IsINGR_NCORRNull() {
                return this.IsNull(this.tableT_detalles.INGR_NCORRColumn);
            }
            
            public void SetINGR_NCORRNull() {
                this[this.tableT_detalles.INGR_NCORRColumn] = System.Convert.DBNull;
            }
            
            public bool IsDING_NDOCTONull() {
                return this.IsNull(this.tableT_detalles.DING_NDOCTOColumn);
            }
            
            public void SetDING_NDOCTONull() {
                this[this.tableT_detalles.DING_NDOCTOColumn] = System.Convert.DBNull;
            }
            
            public bool IsDING_MDOCTONull() {
                return this.IsNull(this.tableT_detalles.DING_MDOCTOColumn);
            }
            
            public void SetDING_MDOCTONull() {
                this[this.tableT_detalles.DING_MDOCTOColumn] = System.Convert.DBNull;
            }
            
            public bool IsINGR_FPAGONull() {
                return this.IsNull(this.tableT_detalles.INGR_FPAGOColumn);
            }
            
            public void SetINGR_FPAGONull() {
                this[this.tableT_detalles.INGR_FPAGOColumn] = System.Convert.DBNull;
            }
            
            public bool IsDING_FDOCTONull() {
                return this.IsNull(this.tableT_detalles.DING_FDOCTOColumn);
            }
            
            public void SetDING_FDOCTONull() {
                this[this.tableT_detalles.DING_FDOCTOColumn] = System.Convert.DBNull;
            }
            
            public bool IsEDIN_TDESCNull() {
                return this.IsNull(this.tableT_detalles.EDIN_TDESCColumn);
            }
            
            public void SetEDIN_TDESCNull() {
                this[this.tableT_detalles.EDIN_TDESCColumn] = System.Convert.DBNull;
            }
            
            public bool IsRUT_ALUMNONull() {
                return this.IsNull(this.tableT_detalles.RUT_ALUMNOColumn);
            }
            
            public void SetRUT_ALUMNONull() {
                this[this.tableT_detalles.RUT_ALUMNOColumn] = System.Convert.DBNull;
            }
            
            public bool IsRUT_APODERADONull() {
                return this.IsNull(this.tableT_detalles.RUT_APODERADOColumn);
            }
            
            public void SetRUT_APODERADONull() {
                this[this.tableT_detalles.RUT_APODERADOColumn] = System.Convert.DBNull;
            }
            
            public bool IsNOMBRE_APODERADONull() {
                return this.IsNull(this.tableT_detalles.NOMBRE_APODERADOColumn);
            }
            
            public void SetNOMBRE_APODERADONull() {
                this[this.tableT_detalles.NOMBRE_APODERADOColumn] = System.Convert.DBNull;
            }
        }
        
        [System.Diagnostics.DebuggerStepThrough()]
        public class T_detallesRowChangeEvent : EventArgs {
            
            private T_detallesRow eventRow;
            
            private DataRowAction eventAction;
            
            public T_detallesRowChangeEvent(T_detallesRow row, DataRowAction action) {
                this.eventRow = row;
                this.eventAction = action;
            }
            
            public T_detallesRow Row {
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

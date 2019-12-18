// ORM class for table 'null'
// WARNING: This class is AUTO-GENERATED. Modify at your own risk.
//
// Debug information:
// Generated date: Fri May 25 13:20:40 CST 2018
// For connector: org.apache.sqoop.manager.MySQLManager
import org.apache.hadoop.io.BytesWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.mapred.lib.db.DBWritable;
import com.cloudera.sqoop.lib.JdbcWritableBridge;
import com.cloudera.sqoop.lib.DelimiterSet;
import com.cloudera.sqoop.lib.FieldFormatter;
import com.cloudera.sqoop.lib.RecordParser;
import com.cloudera.sqoop.lib.BooleanParser;
import com.cloudera.sqoop.lib.BlobRef;
import com.cloudera.sqoop.lib.ClobRef;
import com.cloudera.sqoop.lib.LargeObjectLoader;
import com.cloudera.sqoop.lib.SqoopRecord;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class QueryResult extends SqoopRecord  implements DBWritable, Writable {
  private final int PROTOCOL_VERSION = 3;
  public int getClassFormatVersion() { return PROTOCOL_VERSION; }
  public static interface FieldSetterCommand {    void setField(Object value);  }  protected ResultSet __cur_result_set;
  private Map<String, FieldSetterCommand> setters = new HashMap<String, FieldSetterCommand>();
  private void init0() {
    setters.put("id", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        id = (String)value;
      }
    });
    setters.put("proj_id", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        proj_id = (String)value;
      }
    });
    setters.put("proj_name", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        proj_name = (String)value;
      }
    });
    setters.put("create_time", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        create_time = (java.sql.Timestamp)value;
      }
    });
    setters.put("proj_status", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        proj_status = (String)value;
      }
    });
    setters.put("pta_id", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        pta_id = (String)value;
      }
    });
    setters.put("proj_text", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        proj_text = (String)value;
      }
    });
    setters.put("cert_id", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        cert_id = (String)value;
      }
    });
  }
  public QueryResult() {
    init0();
  }
  private String id;
  public String get_id() {
    return id;
  }
  public void set_id(String id) {
    this.id = id;
  }
  public QueryResult with_id(String id) {
    this.id = id;
    return this;
  }
  private String proj_id;
  public String get_proj_id() {
    return proj_id;
  }
  public void set_proj_id(String proj_id) {
    this.proj_id = proj_id;
  }
  public QueryResult with_proj_id(String proj_id) {
    this.proj_id = proj_id;
    return this;
  }
  private String proj_name;
  public String get_proj_name() {
    return proj_name;
  }
  public void set_proj_name(String proj_name) {
    this.proj_name = proj_name;
  }
  public QueryResult with_proj_name(String proj_name) {
    this.proj_name = proj_name;
    return this;
  }
  private java.sql.Timestamp create_time;
  public java.sql.Timestamp get_create_time() {
    return create_time;
  }
  public void set_create_time(java.sql.Timestamp create_time) {
    this.create_time = create_time;
  }
  public QueryResult with_create_time(java.sql.Timestamp create_time) {
    this.create_time = create_time;
    return this;
  }
  private String proj_status;
  public String get_proj_status() {
    return proj_status;
  }
  public void set_proj_status(String proj_status) {
    this.proj_status = proj_status;
  }
  public QueryResult with_proj_status(String proj_status) {
    this.proj_status = proj_status;
    return this;
  }
  private String pta_id;
  public String get_pta_id() {
    return pta_id;
  }
  public void set_pta_id(String pta_id) {
    this.pta_id = pta_id;
  }
  public QueryResult with_pta_id(String pta_id) {
    this.pta_id = pta_id;
    return this;
  }
  private String proj_text;
  public String get_proj_text() {
    return proj_text;
  }
  public void set_proj_text(String proj_text) {
    this.proj_text = proj_text;
  }
  public QueryResult with_proj_text(String proj_text) {
    this.proj_text = proj_text;
    return this;
  }
  private String cert_id;
  public String get_cert_id() {
    return cert_id;
  }
  public void set_cert_id(String cert_id) {
    this.cert_id = cert_id;
  }
  public QueryResult with_cert_id(String cert_id) {
    this.cert_id = cert_id;
    return this;
  }
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof QueryResult)) {
      return false;
    }
    QueryResult that = (QueryResult) o;
    boolean equal = true;
    equal = equal && (this.id == null ? that.id == null : this.id.equals(that.id));
    equal = equal && (this.proj_id == null ? that.proj_id == null : this.proj_id.equals(that.proj_id));
    equal = equal && (this.proj_name == null ? that.proj_name == null : this.proj_name.equals(that.proj_name));
    equal = equal && (this.create_time == null ? that.create_time == null : this.create_time.equals(that.create_time));
    equal = equal && (this.proj_status == null ? that.proj_status == null : this.proj_status.equals(that.proj_status));
    equal = equal && (this.pta_id == null ? that.pta_id == null : this.pta_id.equals(that.pta_id));
    equal = equal && (this.proj_text == null ? that.proj_text == null : this.proj_text.equals(that.proj_text));
    equal = equal && (this.cert_id == null ? that.cert_id == null : this.cert_id.equals(that.cert_id));
    return equal;
  }
  public boolean equals0(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof QueryResult)) {
      return false;
    }
    QueryResult that = (QueryResult) o;
    boolean equal = true;
    equal = equal && (this.id == null ? that.id == null : this.id.equals(that.id));
    equal = equal && (this.proj_id == null ? that.proj_id == null : this.proj_id.equals(that.proj_id));
    equal = equal && (this.proj_name == null ? that.proj_name == null : this.proj_name.equals(that.proj_name));
    equal = equal && (this.create_time == null ? that.create_time == null : this.create_time.equals(that.create_time));
    equal = equal && (this.proj_status == null ? that.proj_status == null : this.proj_status.equals(that.proj_status));
    equal = equal && (this.pta_id == null ? that.pta_id == null : this.pta_id.equals(that.pta_id));
    equal = equal && (this.proj_text == null ? that.proj_text == null : this.proj_text.equals(that.proj_text));
    equal = equal && (this.cert_id == null ? that.cert_id == null : this.cert_id.equals(that.cert_id));
    return equal;
  }
  public void readFields(ResultSet __dbResults) throws SQLException {
    this.__cur_result_set = __dbResults;
    this.id = JdbcWritableBridge.readString(1, __dbResults);
    this.proj_id = JdbcWritableBridge.readString(2, __dbResults);
    this.proj_name = JdbcWritableBridge.readString(3, __dbResults);
    this.create_time = JdbcWritableBridge.readTimestamp(4, __dbResults);
    this.proj_status = JdbcWritableBridge.readString(5, __dbResults);
    this.pta_id = JdbcWritableBridge.readString(6, __dbResults);
    this.proj_text = JdbcWritableBridge.readString(7, __dbResults);
    this.cert_id = JdbcWritableBridge.readString(8, __dbResults);
  }
  public void readFields0(ResultSet __dbResults) throws SQLException {
    this.id = JdbcWritableBridge.readString(1, __dbResults);
    this.proj_id = JdbcWritableBridge.readString(2, __dbResults);
    this.proj_name = JdbcWritableBridge.readString(3, __dbResults);
    this.create_time = JdbcWritableBridge.readTimestamp(4, __dbResults);
    this.proj_status = JdbcWritableBridge.readString(5, __dbResults);
    this.pta_id = JdbcWritableBridge.readString(6, __dbResults);
    this.proj_text = JdbcWritableBridge.readString(7, __dbResults);
    this.cert_id = JdbcWritableBridge.readString(8, __dbResults);
  }
  public void loadLargeObjects(LargeObjectLoader __loader)
      throws SQLException, IOException, InterruptedException {
  }
  public void loadLargeObjects0(LargeObjectLoader __loader)
      throws SQLException, IOException, InterruptedException {
  }
  public void write(PreparedStatement __dbStmt) throws SQLException {
    write(__dbStmt, 0);
  }

  public int write(PreparedStatement __dbStmt, int __off) throws SQLException {
    JdbcWritableBridge.writeString(id, 1 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(proj_id, 2 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(proj_name, 3 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeTimestamp(create_time, 4 + __off, 93, __dbStmt);
    JdbcWritableBridge.writeString(proj_status, 5 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(pta_id, 6 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(proj_text, 7 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(cert_id, 8 + __off, 12, __dbStmt);
    return 8;
  }
  public void write0(PreparedStatement __dbStmt, int __off) throws SQLException {
    JdbcWritableBridge.writeString(id, 1 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(proj_id, 2 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(proj_name, 3 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeTimestamp(create_time, 4 + __off, 93, __dbStmt);
    JdbcWritableBridge.writeString(proj_status, 5 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(pta_id, 6 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(proj_text, 7 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(cert_id, 8 + __off, 12, __dbStmt);
  }
  public void readFields(DataInput __dataIn) throws IOException {
this.readFields0(__dataIn);  }
  public void readFields0(DataInput __dataIn) throws IOException {
    if (__dataIn.readBoolean()) { 
        this.id = null;
    } else {
    this.id = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.proj_id = null;
    } else {
    this.proj_id = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.proj_name = null;
    } else {
    this.proj_name = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.create_time = null;
    } else {
    this.create_time = new Timestamp(__dataIn.readLong());
    this.create_time.setNanos(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.proj_status = null;
    } else {
    this.proj_status = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.pta_id = null;
    } else {
    this.pta_id = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.proj_text = null;
    } else {
    this.proj_text = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.cert_id = null;
    } else {
    this.cert_id = Text.readString(__dataIn);
    }
  }
  public void write(DataOutput __dataOut) throws IOException {
    if (null == this.id) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, id);
    }
    if (null == this.proj_id) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, proj_id);
    }
    if (null == this.proj_name) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, proj_name);
    }
    if (null == this.create_time) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.create_time.getTime());
    __dataOut.writeInt(this.create_time.getNanos());
    }
    if (null == this.proj_status) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, proj_status);
    }
    if (null == this.pta_id) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, pta_id);
    }
    if (null == this.proj_text) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, proj_text);
    }
    if (null == this.cert_id) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, cert_id);
    }
  }
  public void write0(DataOutput __dataOut) throws IOException {
    if (null == this.id) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, id);
    }
    if (null == this.proj_id) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, proj_id);
    }
    if (null == this.proj_name) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, proj_name);
    }
    if (null == this.create_time) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.create_time.getTime());
    __dataOut.writeInt(this.create_time.getNanos());
    }
    if (null == this.proj_status) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, proj_status);
    }
    if (null == this.pta_id) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, pta_id);
    }
    if (null == this.proj_text) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, proj_text);
    }
    if (null == this.cert_id) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, cert_id);
    }
  }
  private static final DelimiterSet __outputDelimiters = new DelimiterSet((char) 1, (char) 10, (char) 0, (char) 0, false);
  public String toString() {
    return toString(__outputDelimiters, true);
  }
  public String toString(DelimiterSet delimiters) {
    return toString(delimiters, true);
  }
  public String toString(boolean useRecordDelim) {
    return toString(__outputDelimiters, useRecordDelim);
  }
  public String toString(DelimiterSet delimiters, boolean useRecordDelim) {
    StringBuilder __sb = new StringBuilder();
    char fieldDelim = delimiters.getFieldsTerminatedBy();
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(id==null?"null":id, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(proj_id==null?"null":proj_id, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(proj_name==null?"null":proj_name, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(create_time==null?"null":"" + create_time, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(proj_status==null?"null":proj_status, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(pta_id==null?"null":pta_id, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(proj_text==null?"null":proj_text, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(cert_id==null?"null":cert_id, delimiters));
    if (useRecordDelim) {
      __sb.append(delimiters.getLinesTerminatedBy());
    }
    return __sb.toString();
  }
  public void toString0(DelimiterSet delimiters, StringBuilder __sb, char fieldDelim) {
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(id==null?"null":id, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(proj_id==null?"null":proj_id, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(proj_name==null?"null":proj_name, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(create_time==null?"null":"" + create_time, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(proj_status==null?"null":proj_status, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(pta_id==null?"null":pta_id, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(proj_text==null?"null":proj_text, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(cert_id==null?"null":cert_id, delimiters));
  }
  private static final DelimiterSet __inputDelimiters = new DelimiterSet((char) 1, (char) 10, (char) 0, (char) 0, false);
  private RecordParser __parser;
  public void parse(Text __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(CharSequence __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(byte [] __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(char [] __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(ByteBuffer __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(CharBuffer __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  private void __loadFromFields(List<String> fields) {
    Iterator<String> __it = fields.listIterator();
    String __cur_str = null;
    try {
    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.id = null; } else {
      this.id = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.proj_id = null; } else {
      this.proj_id = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.proj_name = null; } else {
      this.proj_name = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.create_time = null; } else {
      this.create_time = java.sql.Timestamp.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.proj_status = null; } else {
      this.proj_status = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.pta_id = null; } else {
      this.pta_id = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.proj_text = null; } else {
      this.proj_text = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.cert_id = null; } else {
      this.cert_id = __cur_str;
    }

    } catch (RuntimeException e) {    throw new RuntimeException("Can't parse input data: '" + __cur_str + "'", e);    }  }

  private void __loadFromFields0(Iterator<String> __it) {
    String __cur_str = null;
    try {
    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.id = null; } else {
      this.id = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.proj_id = null; } else {
      this.proj_id = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.proj_name = null; } else {
      this.proj_name = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.create_time = null; } else {
      this.create_time = java.sql.Timestamp.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.proj_status = null; } else {
      this.proj_status = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.pta_id = null; } else {
      this.pta_id = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.proj_text = null; } else {
      this.proj_text = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.cert_id = null; } else {
      this.cert_id = __cur_str;
    }

    } catch (RuntimeException e) {    throw new RuntimeException("Can't parse input data: '" + __cur_str + "'", e);    }  }

  public Object clone() throws CloneNotSupportedException {
    QueryResult o = (QueryResult) super.clone();
    o.create_time = (o.create_time != null) ? (java.sql.Timestamp) o.create_time.clone() : null;
    return o;
  }

  public void clone0(QueryResult o) throws CloneNotSupportedException {
    o.create_time = (o.create_time != null) ? (java.sql.Timestamp) o.create_time.clone() : null;
  }

  public Map<String, Object> getFieldMap() {
    Map<String, Object> __sqoop$field_map = new HashMap<String, Object>();
    __sqoop$field_map.put("id", this.id);
    __sqoop$field_map.put("proj_id", this.proj_id);
    __sqoop$field_map.put("proj_name", this.proj_name);
    __sqoop$field_map.put("create_time", this.create_time);
    __sqoop$field_map.put("proj_status", this.proj_status);
    __sqoop$field_map.put("pta_id", this.pta_id);
    __sqoop$field_map.put("proj_text", this.proj_text);
    __sqoop$field_map.put("cert_id", this.cert_id);
    return __sqoop$field_map;
  }

  public void getFieldMap0(Map<String, Object> __sqoop$field_map) {
    __sqoop$field_map.put("id", this.id);
    __sqoop$field_map.put("proj_id", this.proj_id);
    __sqoop$field_map.put("proj_name", this.proj_name);
    __sqoop$field_map.put("create_time", this.create_time);
    __sqoop$field_map.put("proj_status", this.proj_status);
    __sqoop$field_map.put("pta_id", this.pta_id);
    __sqoop$field_map.put("proj_text", this.proj_text);
    __sqoop$field_map.put("cert_id", this.cert_id);
  }

  public void setField(String __fieldName, Object __fieldVal) {
    if (!setters.containsKey(__fieldName)) {
      throw new RuntimeException("No such field:"+__fieldName);
    }
    setters.get(__fieldName).setField(__fieldVal);
  }

}

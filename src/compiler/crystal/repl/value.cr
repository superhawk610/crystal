require "./repl"

struct Crystal::Repl::Value
  getter pointer : Pointer(UInt8)
  getter type : Type

  def initialize(@pointer : Pointer(UInt8), @type : Type)
  end

  def value
    type = @type
    case type
    when NilType
      nil
    when BoolType
      @pointer.as(Bool*).value
    when CharType
      @pointer.as(Char*).value
    when IntegerType
      case type.kind
      when :i8
        @pointer.as(Int8*).value
      when :u8
        @pointer.as(UInt8*).value
      when :i16
        @pointer.as(Int16*).value
      when :u16
        @pointer.as(UInt16*).value
      when :i32
        @pointer.as(Int32*).value
      when :u32
        @pointer.as(UInt32*).value
      when :i64
        @pointer.as(Int64*).value
      when :u64
        @pointer.as(UInt64*).value
      else
        raise "BUG: missing handling of Repl value for #{type}"
      end
    when FloatType
      case type.kind
      when :f32
        @pointer.as(Float32*).value
      when :f64
        @pointer.as(Float64*).value
      else
        raise "BUG: missing handling of Repl value for #{type}"
      end
    when type.program.string
      # TODO
      @pointer.unsafe_as(String)
    when PointerInstanceType
      # TODO
      PointerWrapper.new(@pointer.as(Value*))
    when MetaclassType
      # TODO
      @pointer.as(Type*).value
    else
      raise "BUG: missing handling of Repl value for #{type}"
    end
  end

  def to_s(io : IO)
    value.inspect(io)
    io << " : "
    io << type
  end
end

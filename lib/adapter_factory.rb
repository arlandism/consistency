module Consistency
  class NoSuchAdapterError < StandardError
  end

  class AdapterFactory
    def self.adapter(adapter_name)
      case adapter_name
      when :sql
        Adapters::Sql.new
      else
        raise NoSuchAdapterError
      end
    end
  end
end

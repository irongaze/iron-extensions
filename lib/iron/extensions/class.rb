class Class

  # Override #inspect to only include the specified
  def inspect_only(*methods)
    @inspect_field_set = methods
    alias_method :original_inspect, :inspect
    class_eval do
      def inspect
        fields = self.class.inspect_field_set
        vars = instance_variables
        field_vals = fields.collect do |field|
          if instance_variables.include?("@#{field}".to_sym)
            "@#{field}=" + instance_variable_get("@#{field}").inspect
          elsif respond_to?(field)
            ":#{field}=" + send(field).inspect
          end
        end.compact
        text = "#<#{self.class.name}:#{self.object_id}"
        text += (' ' + field_vals.list_join(', ')) if field_vals.any?
        text += '>'
        text
      end
    end
  end

  def inspect_field_set
    @inspect_field_set || []
  end
  
end
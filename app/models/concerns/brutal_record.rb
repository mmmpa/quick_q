module BrutalRecord
  def self.included(klass)
    class << klass
      def brutal_attributes(data_store, *attributes)
        define_base_method!(data_store)
        define_attributes!(attributes)
      end

      def define_attributes!(attributes)
        attributes.each(&method(:define_attribute!))
      end

      def define_attribute!(attribute_name)
        class_eval <<-EOS
          def #{attribute_name}
            brutal_data_store['#{attribute_name}']
          end

          def #{attribute_name}=(value)
            brutal_data_store['#{attribute_name}'] = value
          end
        EOS
      end

      def define_base_method!(data_store)
        @brutal_data_store_names ||= Set.new
        return if @brutal_data_store_names.include?(data_store)
        @brutal_data_store_names << data_store

        class_eval <<-EOS
          def save
            self.#{data_store} = JSON.generate(brutal_data_store)
            self
          end

          def retrieve
            self.brutal_data_store = JSON.parse(#{data_store}) rescue {}
            self
          end

          def brutal_data_store
            @stored_brutal_data_store ||= {}
          end

          def brutal_data_store=(value)
            @stored_brutal_data_store = value
          end
        EOS
      end
    end
  end
end
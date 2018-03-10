require 'pp'
require 'ffaker'

module Embulk
  module Input

    class FFaker < InputPlugin
      Plugin.register_input('ffaker', self)

      def self.transaction(config, &control)
        rows = config.param('rows', :integer)
        schema = config.param('schema', :array)

        task = {
          'rows' => rows, # number of rows
          'schema' => schema
        }

        columns = schema.each.with_index(0).map do |column, index|
          name = column['name']
          column['module'] = 'Random' if column.has_key?('random')

          case column['module']
          when 'Random'
            if column['random'].nil?
              Column.new(index, name, :double)
            else
              Column.new(index, name, :long)
            end
          when 'Boolean'
            Column.new(index, name, :boolean)
          else
            Column.new(index, name, :string)
          end
        end

        resume(task, columns, 1, &control)
      end

      def self.resume(task, columns, count, &control)
        task_reports = yield(task, columns, count)

        next_config_diff = {}
        return next_config_diff
      end

      def init
        # initialization code:
        @rows = task['rows']
        @schema = task['schema'].map do |column|
          if column.has_key?('random')
            random = column['random']

            column['module'] = ::FFaker::Random
            column['method'] = 'rand'

            if random.nil?
              column['parameters'] = []
            elsif random.has_key?('min') && random.has_key?('max')
              column['parameters'] = [Range.new(random['min'], random['max'])]
            elsif random.has_key?('max')
              column['parameters'] = [random['max']]
            end
          else
            column['module'] = ::FFaker.const_get(column['module'])
            column['parameters'] = (column['parameters'] || []).map do |parameter|
              parameter.is_a?(Hash) ? symbolize_keys(parameter) : parameter
            end
          end

          column
        end
      end

      def run
        @rows.times do |n|
          columns = @schema.map do |column|
            column['module'].send(column['method'], *column['parameters'])
          end

          page_builder.add(columns)
        end

        page_builder.finish

        task_report = {}
        return task_report
      end

      private

      def symbolize_keys(hash)
        hash.map{|k,v| [k.to_sym, v] }.to_h
      end
    end

  end
end

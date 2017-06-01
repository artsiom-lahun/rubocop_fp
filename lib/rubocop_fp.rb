require "rubocop_fp/version"

module RubocopFp
  class ExtendRubocopConfig
    DEFAULT_CONFIG_FILENAME = 'default_rubocop_fp_config.yml'.freeze

    def initialize
      @existed_lines = []
    end

    def extend_config
      if File.exist?(File.join(Rails.root, '.rubocop.yml'))
        read_existed_config
        @existed_lines.each do |line|
          unless line == 'rubocop_fp'
            delete_existed_config
            write_new_config
          end
        end
      else
        write_new_config
      end
    end

    private

    def read_existed_config
      file = File.open(File.join(Rails.root, '.rubocop.yml'), 'r+')
      @existed_lines = file.readlines
      file.close
    end

    def delete_existed_config
      File.delete(File.join(Rails.root, '.rubocop.yml'))
    end

    def write_new_config
      File.open(File.join(Rails.root, '.rubocop.yml'), 'w+') do |f|
        f.write "inherit_gem:"
        f.write "  rubocop_fp: #{DEFAULT_CONFIG_FILENAME}"
        @existed_lines.each {|line| f.write line}
        f.close
      end
    end
  end
end

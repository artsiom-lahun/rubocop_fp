require "rubocop_fp/version"

module RubocopFp
  class << self
    def configure
      config = ExtendRubocopConfig.new
      config.extend_config
    end
  end

  class ExtendRubocopConfig
    APPLICATION_CONFIG_PATH = File.join(Rails.root, '.rubocop.yml')

    def initialize
      @existed_lines = []
    end

    def extend_config
      if File.exist?(APPLICATION_CONFIG_PATH)
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
      file = File.open(APPLICATION_CONFIG_PATH, 'r+')
      @existed_lines = file.readlines
      file.close
    end

    def delete_existed_config
      File.delete(APPLICATION_CONFIG_PATH)
    end

    def write_new_config
      File.open(APPLICATION_CONFIG_PATH, 'w+') do |f|
        f.write "inherit_gem:".freeze
        f.write "  rubocop_fp: default_rubocop_fp_config.yml".freeze
        @existed_lines.each {|line| f.write line}
        f.close
      end
    end
  end
end

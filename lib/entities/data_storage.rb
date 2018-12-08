# frozen_string_literal: true

class DataStorage
  FILE_NAME = 'lib/database/data.yml'

  def create
    object = []
    File.new(FILE_NAME, 'w')
    File.write(FILE_NAME, object.to_yaml)
  end

  def load
    object = [Menu]
    YAML.load(File.open(FILE_NAME), object) if storage_exist?
  end

  def save(object)
    File.open(FILE_NAME, 'w') { |file| file.write(YAML.dump(object)) }
  end

  def storage_exist?
    File.exist?(FILE_NAME)
  end
end

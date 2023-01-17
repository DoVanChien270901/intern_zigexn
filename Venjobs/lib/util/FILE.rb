require 'zip'
class FILE
  def unzip(file_path, to_dir)
    Zip::File.open(file_path) do |zip_file|
      zip_file.each do |entry|
        path = File.join(to_dir, entry.name)
        FileUtils.mkdir_p(File.dirname(path))
        zip_file.extract(entry, path)
      end
    end
  end
end

require 'CSV'

module ReadableWriteable

  def read_csv(filename='todo.csv')
    filename = safejoin(filename)
    if !File.exist?(filename)
      return nil
    else
      content = []          # CSV does not have a `map` method
      CSV.foreach(filename) do |line|
        content.push(line)
      end
    end
    content
  end

  def read_txt(filename="todo.txt")
    filename = safejoin(filename)
    if !File.exist?(filename)
      return nil
    else
      content = File.open(filename, 'r') { |file|
        file.read
      }
    end
    content
  end

  def write_txt(filename, content=nil)
    filename = safejoin(filename)
    if !!content then
      File.open(filename, 'w') { |file|
        file.write(content)
      }
    end
  end

  def safejoin(filename="todo.txt", path="data")
    File.join(path, filename)
  end


end

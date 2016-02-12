require_relative "../view"
require_relative "../item"
require_relative "../todo_list"
require_relative "../controller"
require_relative "../readable_writeable"
include ReadableWriteable

describe "TodoList" do

  let(:todo_list) {TodoList.new}

  describe 'TodoList#add' do
    it 'should create one record with correct ID' do
      todo_list.add("sample junk")
      # We are 1-indexing.
      expect(todo_list.tasks[0].id).to eq(1)
    end
  end

  describe 'TodoList#add' do
    it 'should create one record, not completed' do
      todo_list.add("sample junk")
      expect(todo_list.tasks[0].completed).to eq(false)
    end
  end

  describe 'TodoList#add run twice' do
    it 'should create two records, second with correct text' do
      todo_list.add("sample junk")
      todo_list.add("more sample junk")
      expect(todo_list.tasks[0].text).to eq("sample junk")
    end
  end

  describe 'TodoList#add run twice' do
    it 'should create two records, second with correct ID' do
      todo_list.add("sample junk")
      todo_list.add("more sample junk")
      # We are 1-indexing.
      expect(todo_list.tasks[1].id).to eq(2)
    end
  end

  describe 'TodoList#delete' do
    it 'should leave one record with correct ID and text' do
      todo_list.add("sample junk")
      todo_list.add("more sample junk")
      todo_list.delete(0)
      expect(todo_list.tasks[0].text).to eq("more sample junk")
    end
  end

  describe 'TodoList#delete run twice times on three records' do
    it 'should leave one record with correct ID and text' do
      todo_list.add("sample junk")
      todo_list.add("more sample junk")
      todo_list.add("still more sample junk")
      todo_list.delete(0)
      todo_list.delete(0)
      expect(todo_list.tasks[0].text).to eq("still more sample junk")
    end
  end

  describe 'TodoList#delete run ten times' do
    it 'should leave one record with correct ID and text' do
      10.times {todo_list.add("sample junk")}
      todo_list.add("more sample junk")
      10.times {todo_list.delete(0)}
      expect(todo_list.tasks[0].text).to eq("more sample junk")
    end
  end

  describe 'TodoList#delete run twice' do
    it 'should leave empty task-list' do
      todo_list.add("sample junk")
      todo_list.add("more sample junk")
      todo_list.delete(0)
      todo_list.delete(0)
      expect(todo_list.tasks.empty?).to eq(true)
    end
  end

  describe 'TodoList#to_s with three records' do
    it 'should leave one record with correct ID and text' do
      todo_list.add("sample junk")
      todo_list.add("more sample junk")
      todo_list.add("still more sample junk")
      expected = "1. [ ] sample junk\n2. [ ] more sample junk\n3. [ ] still more sample junk"
      expect(todo_list.to_s).to eq(expected)
    end
  end

end

describe "Item" do

  let(:item) {Item.new({id: 7, text: "sample text"})}
  let(:item2) {Item.new({id: 7734, text: "sample text 2"})}

  describe 'Item#completed' do
    it 'should be created incomplete' do
      expect(item.completed).to eq(false)
    end
  end

  describe 'Item#complete' do
    it 'should be made complete by' do
      item.complete
      expect(item.completed).to eq(true)
    end
  end

  describe 'to_s not completed' do
    it 'should return string without checkmark' do
      expect(item.to_s).to eq("7. [ ] sample text")
    end
  end

  describe 'to_s completed' do
    it 'should return string without checkmark' do
      item.complete
      expect(item.to_s).to eq("7. [X] sample text")
    end
  end

  describe 'to_s followed by s_to_object (on uncompleted task)' do
    it 'should return integer ID, completed boolean, task-string' do
      item2.complete
      item2.s_to_object(item2.to_s)
      expect(item2.id).to eq(7734)
      expect(item2.completed).to eq(true)
      expect(item2.text).to eq("sample text 2")
    end
  end

  describe 'to_s followed by s_to_object (on uncompleted task)' do
    it 'should return integer ID, completed boolean, task-string' do
      item2.s_to_object(item2.to_s)
      expect(item2.id).to eq(7734)
      expect(item2.completed).to eq(false)
      expect(item2.text).to eq("sample text 2")
    end
  end

end

describe "ReadableWriteable" do

  describe 'read_csv' do
    it 'should read in a three-line file' do
      expect(read_csv("todo_spec.csv").length).to eq(3)
    end
  end

  describe 'read_csv' do
    it 'should read in three-element first line' do
      expect(read_csv("todo_spec.csv")[0].length).to eq(3)
    end
  end

  describe 'read_txt' do
    it 'should read in a three-line file' do
      expect(read_txt("todo_spec_to_read.txt").split("\n").length).to eq(3)
    end
  end

  describe 'write_txt' do
    it 'should write out a four-line file (then we delete it)' do
      # Create file
      content = "line 1\nline 2\nline 3\nline 4"
      filename = "todo_spec_to_write.txt"
      write_txt(filename=filename, content=content)
      expect(read_txt(filename).split("\n").length).to eq(4)

      # Clean up by deleting file
      filename = safejoin(filename)
      File.delete(filename)
      expect(File.exist?(filename)).to eq(false)
    end
  end

end

describe "View" do

  let(:view) {View.new}
  let(:controller) {Controller.new(debug=true)}

  describe 'options listed in help message' do
    it 'should correspond to commands available to controller' do
      options = view.MESSAGES[:help].split("\n")[2..-1].map { |line|
        line.gsub(/^  (\w+) .+$/, '\1').to_sym
      }
      commands = controller.commands.keys
      expect(options.sort).to eq(commands.sort)
    end
  end

end

describe "Controller" do
  # No tests written.
end

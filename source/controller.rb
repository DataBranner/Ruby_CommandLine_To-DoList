require_relative "view"
require_relative "item"
require_relative "todo_list"

require_relative "readable_writeable"
include ReadableWriteable

class Controller
  attr_accessor :commands, :content_read

  def initialize(debug=false)
    @todo_list = TodoList.new
    @view      = View.new
    # In commands, second element asks whether to return immediately afterwards.
    @commands  = {add:      [:handle_new_item],
                  complete: [:handle_completion],
                  delete:   [:delete_id],
                  help:     [:display_help, true],
                  list:     [:list_all]
                 }
    if !debug then run_command end
  end

  def run_command
    command, @argument = @view.get_command
    command = command.to_sym
    if @commands.include?(command)
      # Some methods do not require interaction with the to-do lists.
      # Variable return_right_after is the sentinel for this.
      method, return_right_after = @commands[command]
      if !return_right_after
        process_existing_file
        file_as_read_hash = @todo_list.to_s.hash
      end
      send(method)

      # Write file if revised (compare hashes)
      if !return_right_after && @todo_list.to_s.hash != file_as_read_hash
        save_revised_list
      end

    else
      @view.display(:sorry)
    end
  end

  def handle_new_item
    # Find ID number, create item, send to list to be added.
    @view.display(@todo_list.add(text=@argument))
  end

  def handle_completion
    @view.display(@todo_list.tasks[@argument.to_i-1].complete)
  end

  def display_help
    @view.display(:help)
  end

  def delete_id
    @todo_list.delete(@argument.to_i-1)
  end

  def list_all
    @view.display(@todo_list)
  end

  def save_revised_list
    write_txt(filename="todo.txt", content=@todo_list.to_s)
  end

  def process_existing_file
    @content_read = read_txt
    if !@content_read
      # Read file if it exists
      @view.display(:no_file)
    else
      # Isolate item text of each line in file and populate @todo_list
      @content_read.split("\n").each_with_index { |line,i|
        completed_and_text = line.split(".", 2)[-1]
        completed = (completed_and_text[2] == "X") ? true : false
        text = completed_and_text[5..-1]
        # TODO must add "completed"
        @todo_list.add(text=text, completed=completed)
      }
      end
  end

end

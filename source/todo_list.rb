class TodoList
  attr_accessor :tasks

  def initialize
    @tasks = Array.new
  end

  def add(text=nil, completed=false)
    # Find ID number, create item, send to list to be added.
    item = Item.new({text: text, id: @tasks.length+1, completed: completed})
    @tasks << item
    "Added item:\n\n    #{item}"
  end

  def delete(id)
    if 0 <= id && id <= @tasks.length
      @tasks.delete_at(id)
      # Renumber whole list from that ID to end.
      @tasks[id..-1].each { |item| item.id -= 1 }
    end
  end

  def to_s
    @tasks.map { |item| item.to_s}.join("\n")
  end
end

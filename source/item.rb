class Item
  attr_accessor :completed, :id
  attr_reader   :text

  def initialize(args={})
    @id = args.fetch(:id, nil)     # Controller must supply ID; list.length+1
    @text = args.fetch(:text, nil)
    @completed = args.fetch(:completed, false)  # false => [ ]; true => [X]
  end

  # TODO: Specification details no way to "uncomplete" a completed item.
  def complete
    @completed = true
    "Item #{@id} marked completed (#{@text})"
  end

  def to_s
    checkmark = @completed ? "X" : " "
    "#{@id}. [#{checkmark}] #{@text}"
  end

  def s_to_object(str)
    @id, str = str.split(".", 2)
    @id = @id.to_i
    if str[0..5] == " [ ] "
      @completed = false
    elsif str[0..5] == " [X] "
      @completed = true
    end
    @text = str[5..-1]
  end
end

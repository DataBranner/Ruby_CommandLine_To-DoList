class View
  attr_reader :MESSAGES

  def initialize
    @MESSAGES = {welcome: "\nThis program models a to-do list. \n",
                help:    "Your options are:\n\n" +
                         "  add <item text>\n" +
                         "  complete <item number>\n" +
                         "  delete <item number>\n" +
                         "  help (print this message)\n" +
                         "  list (show current list)\n",
                sorry:   "Sorry, I don't know that command.\n" +
                         "For help, please type\n\n" +
                         "    ruby todo.rb help\n",
                no_file: "The file is not found.\n",
                goodbye: "End of program."
                }
  end

  def display(msg)
    if msg == nil
      puts "Not possible at this time."
    elsif @MESSAGES.include?(msg)
      puts @MESSAGES[msg]
    else
      puts msg
    end
    puts
  end

  def get_command
    if ARGV[1..-1]
      [ARGV[0], ARGV[1..-1].join(" ")]
    end
  end
end

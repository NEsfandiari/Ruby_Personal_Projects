puts 'Hello how are you doing'

def winners(var, &block)
  puts var
  yield
end
winners('alright thank you for asking') { puts 'I am a Unicorn' }

class Contact
  BILLY = 'bob'
  bingo = 'bango'
  attr_writer :first_name, :middle_name, :last_name

  def first_name
    @first_name
  end

  def middle_name
    @middle_name
  end

  def last_name
    @last_name
  end

  def full_name
    full_name = first_name
    if !@middle_name.nil?
      full_name += ' '
      full_name += middle_name
    end
    full_name += ' ' + last_name
    return full_name
  end
end

c = Contact.new
c.first_name = 'niki'
c.last_name = 'estefarni'
puts c.full_name
puts Contact::BILLY

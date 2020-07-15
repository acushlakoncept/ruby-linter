class Ticket
  def initialize(venue), date)
    @venue = venue
    @date = date
  end

  def fake_method(lines)
    lines.each |x| do
      #say something
    end
  end

end
class CsvConverter
  def self.headers
    %w[
      bearden_id
      city
      country
      email
      in_business
      latitude
      location
      longitude
      organization_name
      organization_type
      phone_number
      tag_names
      website
      sources
    ]
  end

  def self.convert(input)
    new(input).convert
  end

  def initialize(input)
    @input = input
  end

  def convert
    [
      @input[:bearden_id],
      @input[:city],
      @input[:country],
      @input[:email],
      @input[:in_business],
      @input[:latitude],
      @input[:location],
      @input[:longitude],
      @input[:organization_name],
      @input[:organization_type],
      @input[:phone_number],
      @input[:tag_names],
      @input[:website],
      @input[:sources]
    ]
  end
end

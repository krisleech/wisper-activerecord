describe Wisper::Activerecord::Publisher do

  it 'includes Wisper::Publisher' do
    klass = Class.new(ActiveRecord::Base) do
      include Wisper::Activerecord::Publisher
    end

    expect(klass.ancestors).to include Wisper::Publisher
  end
end

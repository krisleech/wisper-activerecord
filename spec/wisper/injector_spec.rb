describe Wisper::Activerecord::Injector, '#inject' do
  it 'includes Wisper::Publisher' do
    klass = Class.new

    described_class.inject(klass)
    expect(klass.ancestors).to include Wisper::Publisher
  end
end

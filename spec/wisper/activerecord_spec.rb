describe 'ActiveRecord' do
  describe 'create' do
    let(:listener) { double('Listener') }

    it 'publishes an on_create event to listener' do
      expect(listener).to receive(:on_create)
      Wisper::Activerecord.subscribe(Meeting, to: listener)

      Meeting.create!
    end

    it 'publishes created object to listener' do
      expect(listener).to receive(:on_create).with(an_instance_of(Meeting))
      Wisper::Activerecord.subscribe(Meeting, to: listener)

      Meeting.create!
    end

  end

end

describe 'ActiveRecord' do
  let(:listener) { double('Listener') }

  before { Wisper::GlobalListeners.clear }

  describe 'create' do

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

  describe 'update' do
    before do
      Meeting.create!
    end

    it 'publishes an on_update event to listener' do
      expect(listener).to receive(:on_update)
      Wisper::Activerecord.subscribe(Meeting, to: listener)

      meeting = Meeting.first
      meeting.update_attributes(title: 'new title')

    end
  end
end

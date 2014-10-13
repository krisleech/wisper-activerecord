describe 'ActiveRecord' do
  let(:listener)    { double('Listener') }
  let(:model_class) { Class.new(Meeting) { include Wisper.model } }

  before { Wisper::GlobalListeners.clear }

  it '.model returns ActiveRecord module' do
    expect(Wisper.model).to eq Wisper::ActiveRecord::Publisher
  end

  describe 'create' do
    it 'publishes an after_create event to listener' do
      expect(listener).to receive(:after_create).with(instance_of(model_class))
      model_class.subscribe(listener)
      model_class.create!
    end

    it 'publishes create_<model_name>_successful event to listener' do
      allow(model_class).to receive(:name).and_return('Meeting')
      expect(listener).to receive(:create_meeting_successful).with(instance_of(model_class))
      model_class.subscribe(listener)
      model_class.create!
    end
  end

  describe 'update' do
    before { model_class.create! }

    it 'publishes an after_update event to listener' do
      expect(listener).to receive(:after_update).with(instance_of(model_class))
      meeting = model_class.first
      meeting.subscribe(listener)
      meeting.update_attributes!(title: 'new title')
    end

    it 'publishes update_<model_name>_successful event to listener' do
      allow(model_class).to receive(:name).and_return('Meeting')
      expect(listener).to receive(:update_meeting_successful).with(instance_of(model_class))
      model_class.subscribe(listener)
      meeting = model_class.first
      meeting.update_attributes!(title: 'new title')
    end
  end

  describe 'destroy' do
    before { model_class.create! }

    it 'publishes an on_destroy event to listener' do
      expect(listener).to receive(:after_destroy).with(instance_of(model_class))
      model_class.subscribe(listener)
      meeting = model_class.first
      meeting.destroy!
    end

    it 'publishes destroy_<model_name>_successful event to listener' do
      allow(model_class).to receive(:name).and_return('Meeting')
      expect(listener).to receive(:destroy_meeting_successful).with(instance_of(model_class))
      model_class.subscribe(listener)
      meeting = model_class.first
      meeting.destroy!
    end
  end
end

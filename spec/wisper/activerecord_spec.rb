describe 'ActiveRecord' do
  let(:listener)    { double('Listener') }
  let(:model_class) { Class.new(Meeting) { include Wisper.model } }

  before { Wisper::GlobalListeners.clear }
  before { allow(model_class).to receive(:name).and_return('Meeting') }

  it '.model returns ActiveRecord module' do
    expect(Wisper.model).to eq Wisper::ActiveRecord::Publisher
  end

  describe '.commit' do # DEPRECATED
    describe 'when creating' do
      context 'and model is valid' do
        it 'publishes create_<model_name>_successful event to listener' do
          expect(listener).to receive(:create_meeting_successful).with(instance_of(model_class))
          model_class.subscribe(listener)
          model_class.commit
        end
      end

      context 'and model is not valid' do
        it 'publishes create_<model_name>_failed event to listener' do
          expect(listener).to receive(:create_meeting_failed).with(instance_of(model_class))
          model_class.subscribe(listener)
          model_class.commit(title: nil)
        end
      end
    end

    describe 'when updating' do
      before { model_class.create! }

      let(:model) { model_class.first }

      context 'and model is valid' do
        it 'publishes update_<model_name>_successful event to listener' do
          expect(listener).to receive(:update_meeting_successful).with(instance_of(model_class))
          model_class.subscribe(listener)
          model.commit(title: 'foo')
        end
      end

      context 'and model is not valid' do
        it 'publishes update_<model_name>_failed event to listener' do
          expect(listener).to receive(:update_meeting_failed).with(instance_of(model_class))
          model_class.subscribe(listener)
          model.commit(title: nil)
        end
      end
    end
  end

  describe 'create' do
    it 'publishes an after_create event to listener' do
      expect(listener).to receive(:after_create).with(instance_of(model_class))
      model_class.subscribe(listener)
      model_class.create
    end
  end

  describe 'update' do
    before { model_class.create! }

    let(:model) { model_class.first }

    it 'publishes an after_update event to listener' do
      expect(listener).to receive(:after_update).with(instance_of(model_class))
      model.subscribe(listener)
      model.update_attributes(title: 'new title')
    end
  end

  describe 'destroy' do
    before { model_class.create! }

    let(:model) { model_class.first }

    it 'publishes an on_destroy event to listener' do
      expect(listener).to receive(:after_destroy).with(instance_of(model_class))
      model_class.subscribe(listener)
      model.destroy
    end
  end
end

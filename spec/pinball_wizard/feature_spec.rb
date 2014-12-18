require 'pinball_wizard'

describe PinballWizard::Feature do
  describe '#state' do
    context 'with defaults' do
      subject { PinballWizard::Feature.new 'example' }

      it 'should not be active' do
        expect(subject.state).to eq('inactive')
      end
    end

    context 'when setting active to a boolean' do
      subject do
        PinballWizard::Feature.new 'example', active: true
      end

      it 'should be activate' do
        expect(subject.state).to eq('active')
      end
    end

    context 'when setting active to a proc' do
      subject do
        PinballWizard::Feature.new 'example', active: proc { true }
      end

      it 'should be activate' do
        expect(subject.state).to eq('active')
      end
    end

    context 'when disabled' do
      subject do
        PinballWizard::Feature.new 'example'
      end

      it 'should be disabled with a message' do
        subject.disable 'reason'
        expect(subject.state).to eq('disabled: reason')
      end
    end
  end

  describe '#active?' do
    context 'without setting a value' do
      subject { PinballWizard::Feature.new 'example' }

      it 'should not be active' do
        expect(subject).not_to be_active
      end
    end

    context 'with a boolean value' do
      subject do
        PinballWizard::Feature.new 'example', active: true
      end

      it 'should not be activated' do
        expect(subject).to be_active
      end
    end

    context 'with a proc' do
      subject do
        PinballWizard::Feature.new 'example', active: proc { true }
      end

      it 'should not be activated' do
        expect(subject).to be_active
      end
    end
  end

  describe '#name' do
    subject do
      PinballWizard::Feature.new('my_super_duper').name
    end

    it { should eq('my_super_duper') }
  end

  describe '.new' do
    it 'takes a hash of options' do
      feature = PinballWizard::Feature.new 'example', foo: 'bar'
      expect(feature.options).to eq({ foo: 'bar' })
    end
  end
end

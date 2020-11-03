RSpec.describe MultiPassword do
  after { described_class.reset_config }

  it 'has a version number' do
    expect(MultiPassword::VERSION).not_to be nil
  end

  describe '.configure' do
    it 'can be configured' do
      described_class.configure do |config|
        config.default_algorithm = :scrypt
        config.default_options = { key_len: 64 }
      end

      config = described_class.config
      expect(config.default_algorithm).to eq :scrypt
      expect(config.default_options).to eq({ key_len: 64 })
    end
  end

  describe '.register' do
    let(:klass) { Class.new }
    let(:algorithm) { :dummy }

    context 'when algorithm is not registered yet' do
      it 'sets correct value' do
        expect {
          described_class.register(algorithm, klass)
        }.to change { described_class.config.registers[algorithm] }
          .from(nil).to(klass)
      end
    end

    context 'when algorithm is registered' do
      it 'sets correct value with warning' do
        expect(Warning).to receive(:warn)

        expect {
          described_class.register(algorithm, Class.new)
          described_class.register(algorithm, klass)
        }.to change { described_class.config.registers[algorithm] }
          .from(nil).to(klass)
      end
    end
  end

  describe '#create' do
    let(:algorithm) { :bcrypt }
    let(:options) { { cost: 12 } }
    let(:manager) { described_class.new(algorithm: algorithm, options: options) }
    let(:password) { 'password' }
    subject { manager.create(password) }

    context 'when algorithm is not registered' do
      it 'raises error' do
        expect {
          subject
        }.to raise_error(described_class::AlgorithmNotRegistered, /Algorithm bcrypt is not registered. Try requiring 'multi_password\/strategies\/bcrypt'\./)
      end
    end

    context 'when algorithm is registered' do
      let(:strategy) { Class.new.include(described_class::Strategy) }
      let(:encrypted_password) { 'encrypted_password' }

      before do
        described_class.register(algorithm, strategy)

        expect_any_instance_of(strategy).to receive(:create)
          .with(password, options).and_return(encrypted_password)
      end

      it { is_expected.to eq encrypted_password }
    end
  end

  describe '#verify' do
    let(:algorithm) { :bcrypt }
    let(:options) { { cost: 12 } }
    let(:manager) { described_class.new(algorithm: algorithm, options: options) }
    let(:password) { 'password' }
    let(:encrypted_password) { 'encrypted_password' }
    subject { manager.verify(password, encrypted_password) }

    context 'when algorithm is not registered' do
      it 'raises error' do
        expect {
          subject
        }.to raise_error(described_class::AlgorithmNotRegistered, /Algorithm bcrypt is not registered. Try requiring 'multi_password\/strategies\/bcrypt'\./)
      end
    end

    context 'when algorithm is registered' do
      let(:strategy) { Class.new.include(described_class::Strategy) }

      before do
        described_class.register(algorithm, strategy)

        expect_any_instance_of(strategy).to receive(:verify)
          .with(password, encrypted_password).and_return(true)
      end

      it { is_expected.to eq true }
    end
  end
end

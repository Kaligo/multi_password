RSpec.describe MultiPassword do
  it 'has a version number' do
    expect(MultiPassword::VERSION).not_to be nil
  end

  describe '.configure' do
    after { described_class.reset_config }

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
end

require 'multi_password/strategies/scrypt'
require 'byebug'

RSpec.describe MultiPassword::Strategies::SCrypt do
  describe '#create and #verify' do
    let(:manager) { MultiPassword.new(algorithm: :scrypt, options: options) }

    let(:options) { { key_len: 64, max_time: 1, max_mem: 128 } }

    it 'creates and verifies password correctly' do
      encrypted_password = manager.create('password')
      expect(encrypted_password).not_to eq 'password'
      expect(manager.verify('password', encrypted_password)).to eq true
    end
  end

  describe '#validate_options' do
    let(:strategy) { described_class.new }

    context 'when options are valid' do
      let(:options) { { key_len: 64, max_time: 1, max_mem: 128 } }

      it 'returns options' do
        expect(strategy.validate_options(options)).to eq(options)
        expect(strategy.validate_options({})).to eq({})
      end
    end

    context 'when options are invalid' do
      context 'when key_len is invalid' do
        it 'raises error' do
          [5.5, 15, 513].each do |invalid_value|
            options = { key_len: invalid_value }

            expect { strategy.validate_options(options) }
              .to raise_error(MultiPassword::InvalidOptions, 'Algorithm scrypt options: key_len must be an integer between 16 and 512')
          end
        end
      end

      context 'when max_time is invalid' do
        it 'raises error' do
          [5.5, -1, 3].each do |invalid_value|
            options = { max_time: invalid_value }

            expect { strategy.validate_options(options) }
              .to raise_error(MultiPassword::InvalidOptions, 'Algorithm scrypt options: max_time must be an integer between 0 and 2')
          end
        end
      end

      context 'when max_mem is invalid' do
        it 'raises error' do
          ['a', -1, 257].each do |invalid_value|
            options = { max_mem: invalid_value }

            expect { strategy.validate_options(options) }
              .to raise_error(MultiPassword::InvalidOptions, 'Algorithm scrypt options: max_mem must be a number between 0 and 256')
          end
        end
      end
    end
  end
end

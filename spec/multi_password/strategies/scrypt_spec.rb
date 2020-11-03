require 'multi_password/strategies/scrypt'

RSpec.describe MultiPassword::Strategies::SCrypt do
  let(:options) { { key_len: 64, max_time: 1 } }
  let(:manager) { MultiPassword.new(algorithm: :scrypt, options: options) }

  it 'creates and verifies password correctly' do
    encrypted_password = manager.create('password')
    expect(encrypted_password).not_to eq 'password'
    expect(manager.verify('password', encrypted_password)).to eq true
  end
end

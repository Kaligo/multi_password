require 'multi_password/strategies/bcrypt'

RSpec.describe MultiPassword::Strategies::BCrypt do
  let(:options) { { cost: 12 } }
  let(:manager) { MultiPassword.new(algorithm: :bcrypt, options: options) }

  it 'creates and verifies password correctly' do
    encrypted_password = manager.create('password')
    expect(encrypted_password).not_to eq 'password'
    expect(manager.verify('password', encrypted_password)).to eq true
  end
end

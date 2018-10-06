require 'spec_helper'

describe '#be_accessible (real server)' do
  it 'can login valid user and password' do
    expect(ENV['TARGET_HOST']).to be_accessible.user(property['username']).pass(property['password'])
  end
end

describe '#be_chroot (real server)' do
  it 'check chroot enabled' do
    expect(ENV['TARGET_HOST']).to be_chroot.user(property['username']).pass(property['password'])
  end
end

describe '#be_writable (real server)' do
  it 'check writable with active mode' do
    expect(ENV['TARGET_HOST']).to be_writable.user(property['username']).pass(property['password']).passive
  end
end 

describe '#be_removable (real server)' do
  it 'check removable' do
    expect(ENV['TARGET_HOST']).to be_removable.user(property['username']).pass(property['password']).passive
  end
end

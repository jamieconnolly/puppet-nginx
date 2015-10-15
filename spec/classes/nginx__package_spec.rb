require 'spec_helper'

describe 'nginx::package' do
  let(:test_params) { {
    :ensure  => 'present',
    :package => 'nginx',
    :version => '1.8.0',
  } }

  let(:facts) { default_test_facts }
  let(:params) { test_params }

  context 'ensure => present' do
    it do
      should contain_package('nginx').with_ensure('1.8.0')
    end
  end

  context 'ensure => absent' do
    let(:params) { test_params.merge(:ensure => 'absent') }

    it do
      should contain_package('nginx').with_ensure(:absent)
    end
  end

  describe 'osfamily => Darwin' do
    let(:facts) { default_test_facts.merge(:osfamily => 'Darwin') }

    it do
      should contain_class('homebrew')
      should contain_homebrew__formula('nginx')
    end
  end

  describe 'osfamily => Debian' do
    let(:facts) { default_test_facts.merge(:osfamily => 'Debian') }

    it do
      should_not contain_class('homebrew')
      should_not contain_homebrew__formula('nginx')
    end
  end
end

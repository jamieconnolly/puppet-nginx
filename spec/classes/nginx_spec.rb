require 'spec_helper'

describe 'nginx' do
  let(:facts) { default_test_facts }
  let(:params) { {
    :configdir => '/test/boxen/config/nginx',
    :datadir   => '/test/boxen/data/nginx',
    :enable    => true,
    :logdir    => '/test/boxen/log/nginx',
    :sitesdir  => '/test/boxen/config/nginx/sites'
  } }

  it do
    should contain_class('nginx::config')
    should contain_class('nginx::package')
    should contain_class('nginx::service')
  end

  describe 'osfamily => Darwin' do
    let(:facts) { default_test_facts.merge(:osfamily => 'Darwin') }

    it 'should include boxen' do
      should contain_class('boxen::config')
    end
  end

  describe 'osfamily => Debian' do
    let(:facts) { default_test_facts.merge(:osfamily => 'Debian') }

    it 'should not include boxen' do
      should_not contain_class('boxen::config')
    end
  end
end

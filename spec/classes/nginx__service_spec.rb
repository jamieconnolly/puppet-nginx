require 'spec_helper'

describe 'nginx::service' do
  let(:test_params) { {
    :ensure  => 'present',
    :enable  => true,
    :service => 'dev.nginx',
  } }

  let(:facts) { default_test_facts }
  let(:params) { test_params }

  context 'ensure => present' do
    it do
      should contain_service('dev.nginx').with({
        :ensure => :running,
        :enable => true,
        :alias  => 'nginx',
      })
    end
  end

  context 'ensure => absent' do
    let(:params) { test_params.merge(:ensure => 'absent') }

    it do
      should contain_service('dev.nginx').with_ensure(:stopped)
    end
  end

  context 'enable => false' do
    let(:params) { test_params.merge(:enable => false) }

    it do
      should contain_service('dev.nginx').with_enable(false)
    end
  end

  describe 'osfamily => Darwin' do
    let(:facts) { default_test_facts.merge(:osfamily => 'Darwin') }

    context 'ensure => present' do
      it do
        should contain_file('/Library/LaunchDaemons/dev.nginx.plist').with_ensure(:present)
      end
    end

    context 'ensure => absent' do
      let(:params) { test_params.merge(:ensure => 'absent') }

      it do
        should contain_file('/Library/LaunchDaemons/dev.nginx.plist').with_ensure(:absent)
      end
    end
  end

  describe 'osfamily => Debian' do
    let(:facts) { default_test_facts.merge(:osfamily => 'Debian') }

    it do
      should_not contain_file('/Library/LaunchDaemons/dev.nginx.plist')
    end
  end
end

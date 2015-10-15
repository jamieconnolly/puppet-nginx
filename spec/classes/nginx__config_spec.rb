require 'spec_helper'

describe 'nginx::config' do
  let(:test_params) { {
    :ensure  => 'present',
    :configdir => '/test/boxen/config/nginx',
    :datadir   => '/test/boxen/data/nginx',
    :logdir    => '/test/boxen/log/nginx',
    :sitesdir  => '/test/boxen/config/nginx/sites',
  } }

  let(:facts) { default_test_facts }
  let(:params) { test_params }

  context 'ensure => present' do
    it do
      %w(config data log).each do |d|
        should contain_file("/test/boxen/#{d}/nginx").with_ensure(:directory)
      end
      should contain_file('/test/boxen/config/nginx/sites').with_ensure(:directory)

      %w(fastcgi_params nginx.conf scgi_params uwsgi_params).each do |f|
        should contain_file("/test/boxen/config/nginx/#{f}").with_ensure(:present)
      end
      should contain_file('/test/boxen/config/nginx/public').with_ensure(:directory)
    end
  end

  context 'ensure => absent' do
    let(:params) { test_params.merge(:ensure => 'absent') }

    it do
      %w(config data log).each do |d|
        should contain_file("/test/boxen/#{d}/nginx").with_ensure(:absent)
      end
      should contain_file('/test/boxen/config/nginx/sites').with_ensure(:absent)

      %w(fastcgi_params nginx.conf scgi_params uwsgi_params).each do |f|
        should contain_file("/test/boxen/config/nginx/#{f}").with_ensure(:absent)
      end
      should contain_file('/test/boxen/config/nginx/public').with_ensure(:absent)
    end
  end

  describe 'osfamily => Darwin' do
    let(:facts) { default_test_facts.merge(:osfamily => 'Darwin') }

    it do
      should contain_file('/test/boxen/homebrew/etc/nginx').with_ensure(:absent)
    end
  end

  describe 'osfamily => Debian' do
    let(:facts) { default_test_facts.merge(:osfamily => 'Debian') }

    it do
      should_not contain_file('/test/boxen/homebrew/etc/nginx').with_ensure(:absent)
    end
  end
end

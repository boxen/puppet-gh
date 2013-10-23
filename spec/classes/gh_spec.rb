require 'spec_helper'

describe 'gh' do
  let(:boxen_home) { '/opt/boxen' }
  let(:config_dir) { "#{boxen_home}/config/git" }
  let(:repo_dir)   { "#{boxen_home}/repo" }
  let(:env_dir)    { "#{boxen_home}/env.d" }
  let(:facts) do
    {
      :boxen_home    => boxen_home,
      :boxen_repodir => repo_dir,
      :boxen_envdir  => env_dir,
      :osfamily      => "Darwin"
    }
  end

  it { should include_class('boxen::config') }
  it { should contain_package('gh').with_ensure('latest') }

  it 'sets up gh.sh file' do
    should contain_file("#{env_dir}/gh.sh")
  end

  it 'sets up global hub protocal config option' do
    should contain_git__config__global('gh.protocol').with_value('https')
  end
end

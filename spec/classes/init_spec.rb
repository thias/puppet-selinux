require 'spec_helper'

describe 'selinux' do

  context "default", :compile do
    it { should contain_package('policycoreutils-python').with_alias('audit2allow') }
  end

end

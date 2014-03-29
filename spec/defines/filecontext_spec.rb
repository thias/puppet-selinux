require 'spec_helper'

describe "selinux::filecontext" do
  let(:title) { '/www' }
  let(:params) { {
    :seltype => "httpd_sys_content_t",
  } }
  let(:pre_condition) { "class { 'selinux': }" }

  context "default", :compile do
    it { should contain_exec("semanage_fcontext_httpd_sys_content_t_/www").
      with_command("semanage fcontext -a -t httpd_sys_content_t '/www'")
    }
    it { should contain_exec("restorecon_httpd_sys_content_t_/www").
      with_command("restorecon /www")
    }
  end
  context "when selinux is not enforcing", :compile do
    let(:facts) {{
      :selinux => true,
      :selinux_enforced => false
    }}
    it { should_not contain_exec("semanage_fcontext_httpd_sys_content_t_/www") }
    it { should_not contain_exec("restorecon_httpd_sys_content_t_/www") }
  end
end

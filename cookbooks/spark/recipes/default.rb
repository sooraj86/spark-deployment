# coding: UTF-8
# Recipe:: default
colo='sooraj'
sparkInstallDir="#{node["spark"]["base_dir"]}/spark_#{node["spark"]["version"]}"
sparkTmp="/tmp/spark_#{node["spark"]["version"]}.tar.gz"
sparkTmpDir="/tmp/spark"
sparkHome="#{node["spark"]["base_dir"]}/spark"
sparkConf="#{sparkInstallDir}/conf"
lockFile="#{sparkInstallDir}/LOCK"

group 'spark' do
  action :create
end

user 'spark' do
  gid 'spark'
  shell "/bin/bash"
  home "/u/users/spark"
  supports :manage_home => true
end

directory "#{sparkInstallDir}" do
  action :create
  owner 'spark'
  mode 00755
end

directory "#{sparkTmpDir}" do
  action :create
  owner 'spark'
  mode 00755
end

directory "#{sparkInstallDir}/eventLogs" do
  action :create
  owner 'spark'
  group 'spark'
  mode 03777
end

directory "#{sparkInstallDir}/sparkLocal" do
  action :create
  owner 'spark'
  group 'spark'
  mode 00755
end

remote_file "#{sparkTmp}" do
  action :create_if_missing
  source node["spark"]["download_url"]
  backup false
end

execute "untar spark binary" do
  cwd sparkTmpDir
  command "tar -xvf #{sparkTmp}; mv spark-#{node["spark"]["version"]}-bin-hadoop2.7/*  #{sparkInstallDir}/"
  not_if do
    File.exists? "#{lockFile}"
  end
end

execute "Create Lock file" do
  command "touch #{lockFile}"
  not_if do
    File.exists? "#{lockFile}"
  end
end


template "#{sparkConf}/spark-defaults.conf" do
  source "spark-defaults.conf.erb"
  owner "spark"
  mode  00644
  variables(
    :sparkmasters =>node["spark"]["masters"]["sooraj"],
    :sparkzookeeper =>node["spark"]["zookeeper"]['sooraj'],
    :sparkeventlogs =>"#{sparkInstallDir}/eventLogs",
    :sparklocaldir =>"#{sparkInstallDir}/sparkLocal",
  )
end

cookbook_file "#{sparkConf}/spark-env.sh" do
  source "spark-env.sh"
  mode "0644"
end

execute "chown spark directory" do
  command "chown -R spark #{sparkInstallDir}"
end

link "#{sparkHome}" do
  owner 'spark'
  to "#{sparkInstallDir}"
  link_type :symbolic
end


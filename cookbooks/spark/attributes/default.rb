# coding: UTF-8 
# Cookbook Name:: flume collector
# Attributes:: default
default["spark"]["version"] = "2.3.1"
default["spark"]["download_url"] = "http://<host>/spark/spark-2.3.1-bin-hadoop2.7.tgz"
default["spark"]["base_dir"]  = "/opt/sooraj"


# Zookeeper Quorum in each colo
default["spark"]["zookeeper"]['sooraj']  = "<host1>:2181,<host2>:2181,<host3>:2181"

default["spark"]["masters"]['sooraj'] = "spark://<host1>:7077,<host2>:7077"

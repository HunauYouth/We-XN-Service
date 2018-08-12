::CarrierWave.configure do |config|
  config.storage              = :qiniu
  config.qiniu_access_key     = "KoHsIl4VZfafoyNw8K--EBUP91ftuL4KMyuFNIpu"
  config.qiniu_secret_key     = 'k1_Kc1VUuWZ9iqEoFB_neuW8rl2OUEKktjEMaP35'
  config.qiniu_bucket         = "wexn"
  config.qiniu_bucket_domain  = "p7vtpdonm.bkt.clouddn.com"
  config.qiniu_bucket_private = true #default is false
  config.qiniu_block_size     = 4*1024*1024
  config.qiniu_protocol       = "http"
  # config.qiniu_up_host        = 'http://up.qiniug.com' #七牛上传海外服务器,国内使用可以不要这行配置
end


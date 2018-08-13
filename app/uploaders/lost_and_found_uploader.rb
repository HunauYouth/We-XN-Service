class LostAndFoundUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :qiniu
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  #def store_dir
  #  "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  #end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end
  def default_url(*args)
    "/images/fallback/lost_and_found/" + [version_name, "default.png"].compact.join('_')
  end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end
  process resize_to_fit: [800, 800]

  version :thumb do
    process resize_to_fill: [200,200]
  end


  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
  def filename
    if original_filename
      # current_path 是 Carrierwave 上传过程临时创建的一个文件，有时间标记
      # 例如: /Users/jason/work/ruby-china/public/uploads/tmp/20131105-1057-46664-5614/_____2013-11-05___10.37.50.png
      @name ||= Digest::MD5.hexdigest(current_path)
      "#{@name}.#{file.extension}"
    end
  end
end

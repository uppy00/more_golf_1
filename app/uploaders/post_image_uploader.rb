class PostImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :fog
  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:

  # ファイルの保存先
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  # 保存形式をjpgに固定
  process convert: "jpg"

  # アップロードされた画像を全て　800x400に変換
  process resize_to_fit: [ 800, 800 ]
  # 軽量化処理

  # OGPようにリサイズ
  version :ogp do
    process resize_to_fill: [1200, 628] # Twitter推奨サイズ
  end
  # デフォルトのファイルassets/images配下のもの
  def default_url
    "default_image.png"
  end

  # 保存を許すファイルの形式
  def extension_allowlist
    %w[jpg jpeg gif png heic HEIC]
  end

  # アップロード後のファイル名を強制的に .jpg にする
  def filename
    if original_filename.present?
      # タイムスタンプ付きで重複防止（必要なければ削除）
      "#{File.basename(original_filename, '.*')}.jpg"
    end
  end

  # MiniMagickで画質を下げるメソッド
  def quality(percentage)
    manipulate! do |img|
      img.strip # メタデータ削除
      img.quality(percentage.to_s)
      img
    end
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add an allowlist of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_allowlist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end

class GolfGearImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end
  process resize_to_limit: [512, 512]
  process convert: "webp"

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # 保存を許すファイルの形式
  def extension_allowlist
    %w[jpg jpeg gif png webp heic JPG JPEG GIF PNG WEBP HEIC]
  end

  # アップロード後のファイル名を強制的に .webp にする
  def filename
    if original_filename.present?
      # タイムスタンプ付きで重複防止（必要なければ削除）
      "#{File.basename(original_filename, '.*')}.webp"
    end
  end
end

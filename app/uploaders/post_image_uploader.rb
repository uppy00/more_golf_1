class PostImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  # ファイルの保存先
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  # 保存形式をjpgに固定
  process convert: "webp"

  # アップロードされた画像を全て　800x400に変換
  process resize_to_fit: [ 800, 800 ]

  # OGPようにリサイズ
  version :ogp do
    process resize_to_fill: [ 1200, 628 ] # Twitter推奨サイズ
  end
  # 画像がない場合これを表示
  def default_url
    "default_image.webp"
  end

  # 保存を許すファイルの形式
  def extension_allowlist
    %w[jpg jpeg gif png webp heic JPG JPEG GIF PNG WEBP HEIC]
  end

  # アップロード後のファイル名を強制的に .jpg にする
  def filename
    if original_filename.present?
      # タイムスタンプ付きで重複防止（必要なければ削除）
      "#{File.basename(original_filename, '.*')}.webp"
    end
  end
end

class ImageHandler
  def initialize(image_url, name, model)
    @model = model
    @name = name.present? ? name : SecureRandom.hex(16)
    @image_url = image_url
  end

  def upload_image
    image_file = begin
      open(URI.open(@image_url.to_s))
    rescue StandardError
      nil
    end

    return if image_file.blank?
    local_image_path = "#{@name}.jpg"
    IO.copy_stream(image_file, local_image_path)
    @model.image.attach(
      io: File.open(image_file),
      filename: "#{@name}.jpg"
    )
    @model.save!
    File.delete(local_image_path)
  end

  def upload_image_base64
    data = @image_url
    image = Base64.decode64(data['data:image/png;base64,'.length..-1])
    file = Tempfile.new('image')
    file.binmode
    file.write(image)
    file.rewind

    @model.image.attach(
      io: file,
      filename: "#{@name}.png",
      content_type: 'image/png'
    )
  end
end

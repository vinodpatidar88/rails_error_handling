class VideoHandler
  def initialize(video_url, name, model = nil)
    @video_url = video_url
    @filename = name
    @model = model
  end

  def download_compress
    video = FFMPEG::Movie.new(@video_url)
    converted_path = Rails.root.join('public', "#{@filename}.webm")
    options = { video_codec: 'libvpx', audio_codec: 'libvorbis', custom: %w[-b:v 0.5M -b:a 128k -crf 30] }
    video.transcode(converted_path.to_s, options)

    if @model.present?
      @model.video.attach(
        io: File.open(converted_path),
        filename: "#{@filename}.webm"
      )
      @model.save!
    end
    File.delete(converted_path)
  end

  def compress(path)
    video = FFMPEG::Movie.new(path.to_s)
    converted_path = Rails.root.join('public', "#{@filename}.webm")
    options = { video_codec: 'libvpx', audio_codec: 'libvorbis', custom: %w[-b:v 0.5M -b:a 128k -crf 30] }
    video.transcode(converted_path.to_s, options)
  end

  def upload_video
    video_file = begin
      open(URI.open(@video_url.to_s))
    rescue StandardError
      nil
    end
  
    return if video_file.blank?
  
    local_video_path = "#{@filename}.mp4"
    IO.copy_stream(video_file, local_video_path)
    
    @model.video.attach(
      io: File.open(local_video_path),
      filename: "#{@name}.mp4"
    )
    
    @model.save!
    File.delete(local_video_path)
  end
end

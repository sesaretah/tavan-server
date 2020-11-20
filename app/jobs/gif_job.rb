class GifJob < ApplicationJob
  queue_as :default
  RootFolder = Rails.root.to_s + "/public/gifs"

  def perform(id)
    surveillance = Surveillance.find_by_id(id)
    if !surveillance.blank?
      #system("mkdir -p #{RootFolder}/#{id}")
      p "ffmpeg -i #{surveillance.screen_cast_path} -vf 'fps=10,scale=320:-1:flags=lanczos' -c:v pam -f image2pipe - | convert -delay 10 - -loop 0 -layers optimize #{RootFolder}/#{id}.gif"
      #system("ffmpeg -i #{surveillance.screen_cast_path} -vf 'fps=10,scale=320:-1:flags=lanczos' -c:v pam -f image2pipe - | convert -delay 10 - -loop 0 -layers optimize #{RootFolder}/#{id}.gif")
      #p "ffmpeg -i #{surveillance.screen_cast_path} -vf 'fps=10,scale=320:-1:flags=lanczos' -c:v pam -f image2pipe - | convert -delay 10 - -loop 0 -layers optimize #{RootFolder}/#{id}.gif"
    end
  end
end

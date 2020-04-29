class FcmJob < ApplicationJob
  queue_as :default

  def perform(title, body, to)
    opts = {
    headers: {
      'Authorization' => "key=AAAAdB1Ro3U:APA91bHAH0A3Qg6SP5qPygibAVS6U059ZJHB0AQ8_Pl8rfbi35XgGQn1Yn64Y0m5GoYA4emPOemTrefbhl0JzW5xfdU-a_1c0fzyKPJ2tof_O0vubVPvSZJ_ZJh33T1QBtuUsJXlQaFQ",
      'Content-Type' => 'application/json'
    },
    body: {     
      "notification" => {
      "title" => title,
      "body"  => body,
      "content_available"  => true,
      "priority"  => "high"
      },
        "to"  => to#"eGfhD00UUjyvAauohj6Dgt:APA91bGDQ9SBNHZL6HNLJRD_PC-kdcJVPxIXXwikPRA8PqEuQXH3F5YSuTfmQAPiguuKsWWc3l35mBYlJusnTp7mdosmE8ubGaEeCFjXd9nW4tO6pF1ZKUA4Pi5NA70VQ1phtS3BsJCw"
      }.to_json
    }
    url = "https://fcm.googleapis.com/fcm/send"
    HTTParty.post(url, opts)
  end
end

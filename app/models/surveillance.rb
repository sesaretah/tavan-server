class Surveillance < ApplicationRecord
    has_one_attached :screen_cast

    def screen_cast_path
        ActiveStorage::Blob.service.send(:path_for, self.screen_cast.key)
    end
end

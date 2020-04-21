class AddTheParamsToVisit < ActiveRecord::Migration[5.2]
  def change
    add_column :visits, :the_params, :json
  end
end

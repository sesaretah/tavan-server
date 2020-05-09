class AbilitySerializer < ActiveModel::Serializer
  attributes :id, :the_ability
  def the_ability
    object.ability
  end
end

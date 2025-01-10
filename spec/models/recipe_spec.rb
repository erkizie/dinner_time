# == Schema Information
#
# Table name: recipes
#
#  id         :bigint           not null, primary key
#  author     :string
#  category   :string
#  cook_time  :integer
#  cuisine    :string
#  image      :string
#  prep_time  :integer
#  ratings    :float
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_recipes_on_ratings  (ratings)
#  index_recipes_on_title    (title)
#
require 'rails_helper'

RSpec.describe Recipe, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# frozen_string_literal: true

# user model to handle user with auth
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :person

  after_create :create_person

  def create_person
    Person.create(user_id: id)
  end
end

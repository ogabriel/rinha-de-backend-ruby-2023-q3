# frozen_string_literal: true

class Pessoa < ApplicationRecord
  before_save :build_busca

  validate :valid_nascimento?

  private

  def valid_nascimento?
    Date.parse(nascimento)
  rescue Date::Error
    errors.add(:nascimento, 'invalid')
  end

  def build_busca
    return if errors.any?

    self.busca = if stack.present?
                   "#{apelido.downcase} #{nome.downcase} #{stack.map(&:downcase).join(' ')}"
                 else
                   "#{apelido.downcase} #{nome.downcase}"
                 end
  end
end

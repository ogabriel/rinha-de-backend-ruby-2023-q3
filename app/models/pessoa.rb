# frozen_string_literal: true

class Pessoa < ApplicationRecord
  before_save :build_busca

  validate :valid_nascimento?

  private

  def valid_nascimento?
    year, month, day = nascimento.split('-')

    if year.to_s.length != 4 ||
       month.to_s.length != 2 ||
       day.to_s.length != 2
      errors.add(:nascimento, 'invalid')
    else
      Date.parse(nascimento)
    end
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

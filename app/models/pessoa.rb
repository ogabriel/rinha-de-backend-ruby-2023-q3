# frozen_string_literal: true

class Pessoa < ApplicationRecord
  scope :busca, ->(term) { where('busca LIKE ?', "%#{term}%") }

  validates :apelido, presence: true, length: { in: 1..32 }
  validates :nome, presence: true, length: { in: 1..100 }
  validates :nascimento, presence: true

  validate :valid_nascimento?
  validate :valid_stack?
  after_validation :build_busca

  private

  def valid_nascimento?
    return if errors.any?

    year, month, day = nascimento.split('-')

    if year.to_s.length == 4 && month.to_s.length == 2 && day.to_s.length == 2
      Date.parse(nascimento)
    else
      errors.add(:nascimento, 'invalid')
    end
  rescue Date::Error
    errors.add(:nascimento, 'invalid')
  end

  def valid_stack?
    return if errors.any? || stack.nil?

    if stack.any? { |s| !s.length.in?(1..32) }
      errors.add(:stack, 'invalid')
    end
  end

  def build_busca
    return if errors.any?

    self.busca =
      if stack.present?
        "#{apelido.downcase} #{nome.downcase} #{stack.map(&:downcase).join(' ')}"
      else
        "#{apelido.downcase} #{nome.downcase}"
      end
  end
end

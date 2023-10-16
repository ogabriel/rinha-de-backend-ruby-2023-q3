# frozen_string_literal: true

class Pessoa < ApplicationRecord
  scope :busca, ->(term) { where('busca LIKE ?', "%#{term}%") }

  after_validation :build_busca

  private

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

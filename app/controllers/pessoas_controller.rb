# frozen_string_literal: true

class PessoasController < ApplicationController
  FIELDS = %i[id apelido nome nascimento stack].freeze

  before_action :validate_pessoas_params, only: :create

  def show
    pessoa = Pessoa.select(FIELDS).find(params[:id])

    if pessoa.present?
      render json: pessoa
    else
      head :not_found
    end
  end

  def search
    if params[:t].present?
      pessoas = Pessoa.busca(params[:t]).select(FIELDS).limit(50)

      render json: pessoas
    else
      head :bad_request
    end
  end

  def create
    pessoa = Pessoa.new(pessoa_params)

    if pessoa.save
      head :created, location: pessoa
    else
      head :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    head :unprocessable_entity
  end

  def count
    render plain: Pessoa.count.to_s
  end

  private

  def pessoa_params
    @pessoa_params ||= params.require(:pessoa).permit(:apelido, :nome, :nascimento, stack: [])
  end

  def validate_pessoas_params
    if pessoa_params[:apelido].nil? || pessoa_params[:nome].nil? || pessoa_params[:nascimento].nil?
      head :unprocessable_entity
      return
    elsif !(valid_strings? && valid_nascimento?)
      head :bad_request
      return
    elsif !valid_stack?
      head :unprocessable_entity
      return
    end
  end

  def valid_strings?
    pessoa_params[:apelido].is_a?(String) &&
      pessoa_params[:apelido].length.in?(1..32) &&
      pessoa_params[:nome].is_a?(String) &&
      pessoa_params[:nome].length.in?(1..100) &&
      pessoa_params[:nascimento].is_a?(String) &&
      pessoa_params[:nascimento].length == 10
  end

  def valid_nascimento?
    nascimento = pessoa_params[:nascimento]

    year, month, day = nascimento.split('-')

    return unless year.to_s.length == 4 && month.to_s.length == 2 && day.to_s.length == 2

    Date.parse(nascimento)
  rescue
    false
  end

  def valid_stack?
    stack = params[:stack]

    return true if stack.nil?

    stack.is_a?(Array) &&
      stack.any? &&
      stack.all? { |s| s.is_a?(String) && s.length.in?(1..32) }
  end
end

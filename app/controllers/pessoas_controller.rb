# frozen_string_literal: true

class PessoasController < ApplicationController
  FIELDS = %i[id apelido nome nascimento stack].freeze

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
    if bad_request?
      head :bad_request
    else
      pessoa = Pessoa.new(pessoa_params)

      if pessoa.save
        head :created, location: pessoa
      else
        head :unprocessable_entity
      end
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

  # necessário porque o cast do rais é muito agressivo e permite coisas q a rinha não permite
  def bad_request?
    !pessoa_params[:apelido].is_a?(String) ||
      !pessoa_params[:nome].is_a?(String) ||
      !pessoa_params[:nascimento].is_a?(String) ||
      !(pessoa_params[:stack].nil? ||
      (pessoa_params[:stack].is_a?(Array) &&
        pessoa_params[:stack].any? &&
        pessoa_params[:stack].all? { |s| s.is_a?(String) }))
  end
end

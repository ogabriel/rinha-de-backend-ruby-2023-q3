class PessoasController < ApplicationController
  def show
    @pessoa = Pessoa.find(params[:id])

    render json: @pessoa
  end

  def search
    if params[:t].present?
      @pessoas = Pessoa.where("busca LIKE ?", "%#{params[:t]}%").limit(50)
      render json: @pessoas
    else
      render json: []
    end
  end

  # POST /pessoas
  def create
    require 'pry'; binding.pry
    @pessoa = Pessoa.new(pessoa_params)

    if @pessoa.save
      render json: "", status: :created, location: @pessoa
    else
      render json: @pessoa.errors, status: :unprocessable_entity
    end
  end

  def count
    render json: Pessoa.count
  end

  private

  def pessoa_params
    params.require(:pessoa).permit(:apelido, :nome, :nascimento, stack: [])
  end
end

class PessoasController < ApplicationController
  def show
    @pessoa = Pessoa.find(params[:id])

    render json: @pessoa, except: %i[busca]
  end

  def search
    if params[:t].present?
      @pessoas = Pessoa.where('busca LIKE ?', "%#{params[:t]}%").limit(50)

      render json: @pessoas, except: %i[busca]
    else
      render json: '', status: 400
    end
  end

  def create
    if !present_params?
      render json: '', status: 422
    elsif !valid_params?
      render json: '', status: 400
    else
      @pessoa = Pessoa.new(pessoa_params)

      if @pessoa.save
        render json: '', status: :created, location: @pessoa
      else
        render json: '', status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordNotUnique
    render json: '', status: 422
  end

  def count
    render json: Pessoa.count
  end

  private

  def pessoa_params
    @pessoa_params ||= params.require(:pessoa).permit(:apelido, :nome, :nascimento, stack: [])
  end

  def present_params?
    pessoa_params[:apelido].present? &&
      pessoa_params[:nome].present? &&
      pessoa_params[:nascimento].present?
  end

  def valid_params?
    pessoa_params[:apelido].is_a?(String) &&
      (pessoa_params[:apelido].length in 1..32) &&
      pessoa_params[:nome].is_a?(String) &&
      (pessoa_params[:nome].length in 1..100) &&
      pessoa_params[:nascimento].is_a?(String) &&
      (pessoa_params[:nascimento].length == 10) &&
      valid_stack_types?
  end

  def valid_stack_types?
    return true if pessoa_params[:stack].nil?

    pessoa_params[:stack].is_a?(Array) &&
      pessoa_params[:stack].all? { |s| s.is_a?(String) && s.length in 1..32 }
  end
end

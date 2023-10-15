class CreatePessoas < ActiveRecord::Migration[7.1]
  def change
    create_table :pessoas, id: :uuid do |t|
      t.string :apelido, limit: 32
      t.string :nome, limit: 100
      t.string :nascimento
      t.string :stack, array: true, limit: 32
      t.text :busca
    end

    add_index :pessoas, :apelido, unique: true
    enable_extension :pg_trgm
    execute('CREATE INDEX ON pessoas USING GIST (busca gist_trgm_ops(siglen=1024))')
  end
end

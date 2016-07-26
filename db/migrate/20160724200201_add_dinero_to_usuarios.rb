class AddDineroToUsuarios < ActiveRecord::Migration
  def change
    add_column :usuarios, :Dinero, :integer
  end
end

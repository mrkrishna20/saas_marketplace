class MakeEmailNullableInCompanyClients < ActiveRecord::Migration[8.1]
  def change
    change_column_null :company_clients, :email, true
  end
end

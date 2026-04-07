class MakeClientIdNullableInCompanyClients < ActiveRecord::Migration[8.1]
  def change
    change_column_null :company_clients, :client_id, true
  end
end

class AddClientIdToCompanyClients < ActiveRecord::Migration[8.1]
  def change
    add_reference :company_clients, :client, null: false, foreign_key: true
  end
end

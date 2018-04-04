Sequel.migration do
  change do
    create_table(:events) do
      primary_key :id
      Int :max_players, null: false
      Time :date, null: false

      Time :created_at, null: false
      Time :updated_at
    end

    create_table(:players) do
      primary_key :id
      String :name, null: false
      String :uid, null: false
      String :email
      String :avatar_url
      String :racket

      Time :created_at, null: false
      Time :updated_at
    end

    create_table(:participants) do
      primary_key :id
      Int :event_id, null: false
      Int :player_id, null: false
    end
  end
end

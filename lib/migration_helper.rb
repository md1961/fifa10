module MigrationHelper

  # 外部キー作成メソッド.
  # migrationで外部キーを実行する場合のSQLを見えないようにして、migrationファイルの可視性アップを狙う.
  def foreign_key(from_table, from_column, to_table)
    constraint_name = "fk_#{from_table}_#{to_table}"

    execute "ALTER TABLE #{from_table}" \
            + " ADD CONSTRAINT #{constraint_name}" \
            + " FOREIGN KEY (#{from_column}) REFERENCES #{to_table}(id)"
  end
end

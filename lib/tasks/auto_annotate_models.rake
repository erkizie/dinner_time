if Rails.env.development?
  require 'annotate'

  task :set_annotation_options do
    Annotate.set_defaults(
      'models' => 'true',
      'routes' => 'false',
      'fixtures' => 'false',
      'factories' => 'false',
      'serializers' => 'false',
      'helpers' => 'false',
      'controllers' => 'false',
      'position_in_class' => 'after',
      'show_foreign_keys' => 'true',
      'show_indexes' => 'true',
      'simple_indexes' => 'false',
      'model_dir' => 'app/models',
      'exclude_tests' => 'true',
      'exclude_fixtures' => 'true',
      'exclude_factories' => 'true',
      'exclude_serializers' => 'true',
      'exclude_scaffolds' => 'true',
      'exclude_controllers' => 'true',
      'ignore_model_sub_dir' => 'false',
      'ignore_columns' => nil,
      'hide_limit_column_types' => 'integer,bigint,boolean',
      'hide_default_column_types' => 'json,jsonb,hstore',
      'skip_on_db_migrate' => 'false'
    )
  end

  Annotate.load_tasks
end

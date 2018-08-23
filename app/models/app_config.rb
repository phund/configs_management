class AppConfig
  include Mongoid::Document

  module ConfigEnvs
    DEV = 'development'
    STG = 'staging'
    TEST = 'test'
    PRD = 'production'
    STG_PRD = [STG, PRD]
    ALL = [DEV, STG, TEST, PRD]
  end

  attr_accessor :development_configs, :staging_configs, :test_configs, :production_configs
  field :name, type: String
  field :type, type: String
  field :development, type: Hash
  field :staging, type: Hash
  field :test, type: Hash
  field :production, type: Hash
end

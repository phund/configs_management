class Report
  IGNORE_CONFIGS = ['SYSOP_USERNAME', '']
  def self.check_duplicates(type: '')
    configs = type.blank? ? AppConfig.all : AppConfig.where(type: type)
    keys = {}
    configs.each do |conf|
      AppConfig::ConfigEnvs::STG_PRD.each do |e|
        env_config = conf.try(e)
        next if !env_config
        env_config.each do |k,v|
          next if v.blank? 
          keys[v] = {
            scopes: {},
            count: 0
          } if !keys[v]
          keys[v][:scopes][conf.name] = [] if !keys[v][:scopes][conf.name]
          keys[v][:scopes][conf.name] << "#{k}-#{e}"
          keys[v][:count] += 1
        end
      end
    end
    # duplicates = keys.select{|key, h| h[:scopes].keys.length >  1 }.values.map{|h| h[:scopes]}
    duplicates = keys.select{|key, h| h[:count] >  1 }.values.map{|h| h[:scopes]}
  end

end

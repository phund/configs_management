class AppConfigsController < ApplicationController
  before_action :set_app_config, only: [:show, :edit, :update, :destroy]

  # GET /app_configs
  # GET /app_configs.json
  def index
    @app_configs = AppConfig.order(name: 1)
  end

  # GET /app_configs/1
  # GET /app_configs/1.json
  def show
  end

  # GET /app_configs/new
  def new
    @app_config = AppConfig.new
  end

  # GET /app_configs/1/edit
  def edit
  end

  # POST /app_configs
  # POST /app_configs.json
  def create
    p app_config_params
    @app_config = AppConfig.new(app_config_params)

    respond_to do |format|
      if @app_config.save
        format.html { redirect_to @app_config, notice: 'App config was successfully created.' }
        format.json { render :show, status: :created, location: @app_config }
      else
        format.html { render :new }
        format.json { render json: @app_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_configs/1
  # PATCH/PUT /app_configs/1.json
  def update
    respond_to do |format|
      if @app_config.update(app_config_params)
        format.html { redirect_to @app_config, notice: 'App config was successfully updated.' }
        format.json { render :show, status: :ok, location: @app_config }
      else
        format.html { render :edit }
        format.json { render json: @app_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_configs/1
  # DELETE /app_configs/1.json
  def destroy
    @app_config.destroy
    respond_to do |format|
      format.html { redirect_to app_configs_url, notice: 'App config was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_config
      @app_config = AppConfig.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_config_params
      app_params = params.require(:app_config).permit(:name, :type, :development_configs, :staging_configs, :test_configs, :production_configs)
      configs = nil
      enscrypt_infos = {}
      AppConfig::ConfigEnvs::ALL.each do |e|
        params_key = "#{e}_configs"
        next if !app_params[params_key.to_sym]
        configs = HashWithIndifferentAccess.new(YAML.load(app_params[params_key.to_sym]))
        if configs[e]
          configs[e].each do |k,v|
            configs[e][k] = Digest::SHA1.hexdigest(v.to_s)
          end
          app_params[e] = configs[e]
        end
      end

      app_params
    end
end

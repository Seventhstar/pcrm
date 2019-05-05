class TarifsController < ApplicationController
  before_action :set_tarif, only: [:show, :edit, :update, :destroy]
  before_action :def_params, only: [:new, :edit]
  before_action :check_sum, only: [:create, :update]
  before_action :logged_in_user
  respond_to :html

  def index
    @tarifs = Tarif.order(:project_type_id, :from)
                   .left_joins([:project_type, :tarif_calc_type])

    @tarifs = @tarifs.map{ |t| {
                        id: t.id,
                        project_type:    t.project_type_name,
                        project_type_id: t.project_type_id,
                        sum:  t.sum,
                        sum2: t.sum2,
                        calc_type:    t.tarif_calc_type_name,
                        calc_type_id: t.tarif_calc_type_id,
                        from: t.from,
                        designer_price:  t.designer_price,
                        designer_price2: t.designer_price2,
                        vis_price:  t.vis_price
                      }}.sort_by{|hsh| [hsh[:project_type], hsh[:from].to_i] }

    @columns = [ ['project_type', 'Вид работ'], ['sum', 'Сумма договора'], ['sum2', 'Сумма 2 договора'],
                 ['calc_type', 'Расчет за'], ['from', 'При площади от'], ['designer_price', 'Цена 2 дизайнера'], 
                 ['designer_price2', 'Цена 2 дизайнера'], ['vis_price', 'Цена визуализатора']
               ]

    respond_with(@tarifs)
  end

  def show
    respond_with(@tarif)
  end

  def new
    @tarif = Tarif.new
    @tarifs = Tarif.order(:project_type_id, :from)
    respond_with(@tarif)
  end

  def edit
    @tarifs = Tarif.order(:project_type_id, :from)
  end

  def create
    @tarif = Tarif.new(tarif_params)
    @tarif.save
    respond_with(@tarif, location: tarifs_path)
  end

  def update
    @tarif.update(tarif_params)
    respond_with(@tarif, location: tarifs_path)
  end

  def destroy
    @tarif.destroy
    respond_with(@tarif)
  end

  private
    def check_sum
      prms = %w(sum sum2 designer_price designer_price2 vis_price)
        
      prms.each do |p|
        tarif_params[p] = tarif_params[p].gsub!(' ','') if !tarif_params[p].nil?
      end
    end

    def def_params
      @project_types = ProjectType.order(:id)
      @tarif_calc_types = TarifCalcType.order(:id)
    end

    def set_tarif
      @tarif = Tarif.find(params[:id])
    end

    def tarif_params
      params.require(:tarif).permit(:project_type_id, :sum, :sum2, :tarif_calc_type_id, :from, :designer_price, :designer_price2, :vis_price)
    end
end

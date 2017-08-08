class ProjectPdf < Prawn::Document
  def initialize(project)
    super(top_margin: 30, :page_size => "A4", :page_layout => :landscape)
    font_families.update("pragmatica" => {
      :normal => Rails.root.join("app/assets/fonts/pragmatica/Pragmatica-Medium_gdi.ttf"),

      :bold => Rails.root.join("app/assets/fonts/pragmatica/Pragmatica-Bold_gdi.ttf"),
      :bold_italic => Rails.root.join("app/assets/fonts/OpenSans-Regular.ttf")
      })
    font "pragmatica"


    
    # p "project #{project}"
    @project = project
    order_number
    line_items


  end

  def order_number
    text "Смета \##{@project.number} #{@project.address}", size: 30, style: :bold
  end

  def line_items
    move_down 20
    @r = []
    table line_item_rows do
      row(0).font_style = :bold

      # columns(0..3).align = :center
      # self.row_colors = ['DDDDDD', 'FFFFFF']
      # self.row_colors = ["F0F0F0", "FFFFCC"]
      # self.row_colors = @r
      self.header = true
    end
    # p "@r #{@r}"
  end

  def line_item_rows
    a =  [[{content:"Позиция",width:160},{content:"Поставщик",width:160}, {content:"Дата",width:80}, 
     {content:"Примечание",width:160}, {content:'Валюта',width:58}, {content:'Стоимость',width:100}]]
    
    @project.project_g_types.each do |item|
      if item.goods.count>0
         
        b = []
        sum = 0
        @r << 'ff8411'
        item.goods.each do |g|
            b<< [g.name, g.provider_name,g.date_offer.try('strftime',"%d.%m.%Y"),g.description,g.currency_name,g.gsum.to_sum]
            sum +=g.gsum
            @r << 'ffffff'
        end
         a << [{content: item.goodstype.name, colspan: 5, background_color: 'ff8411'}, {content: sum.to_sum, background_color: 'ff8411'} ]
        #a << [{content: item.goodstype.name, colspan: 5}, sum.to_sum ]
        
        a += b
      end
    end
    a
  end
end
class ProjectPdf < Prawn::Document
  def initialize(project)
    super(top_margin: 30, page_size: "A4", page_layout: :landscape)
      font_families.update("pragmatica" => {
      :normal => Rails.root.join("app/assets/fonts/pragmatica/Pragmatica-Medium_gdi.ttf"),
      :bold => Rails.root.join("app/assets/fonts/pragmatica/Pragmatica-Bold_gdi.ttf"),
      :bold_italic => Rails.root.join("app/assets/fonts/OpenSans-Regular.ttf")
      })
    font "pragmatica"

    @project = project
    head_address
    head
    line_items
  end

  def head_address
    text "#{@project.address}", size: 16, style: :bold
  end
  def head
    # move_down 15
    text "Калькуляция на чистовые материалы, мебель и оборудование", size: 12, style: :bold
  end

  def line_items
    move_down 10
    @r = []
    table line_item_rows, :cell_style => { size: 9, border_width: 0 } do
      self.header = true
      self.row_colors = ["FFFFFF","ffe0ab"]
      row(0).font_style = :bold
      # row(0).height = 20
      row(0).height = 40
      row(0).background_color = 'ff8411'
      row(0).align = :center
      row(0).valign = :center
      row(0).column(2).padding_bottom = 5
      # col(1).align = :center
      column(0).align = :center
      column(2).align = :center
      column(3).align = :center
      # self.size = 8
    end

      #   table line_item_rows, 
      # :header => true,
      # self.row(0).align => :center,
      # # :column_widths => widths,
      # # row(0).font_size => 10,
      # :cell_style => { size: 7 },
      # :row_colors => ["EEEEEE", "FFFFFF"]

  end

  def line_item_rows
    a =  [[{content:"№",width:40},
           {content:"Наименование",width:160},
           {content:'Стоимость',width:100},
           {content:"Сроки поставки",width:120}, 
           {content:"Контакты поставщика",width:160}, 
           {content:"Примечание",width:160}
           ]]

    @prj_good_types = Goodstype.where(id: [@project.goods.pluck(:goodstype_id).uniq]).order(:name)  
    
    ind = 1

    @prj_good_types.each do |item|
      if item.goods.count>0
        item.goods.each do |g|
            date_supp = g.date_supply.nil? ? 'По согласованию' : I18n.localize(g.date_supply, format: :long)

            a << [ind, g.name, 
                  [g.gsum.to_sum,g.currency_print_name].join(' '), 
                  date_supp,
                  g.provider_full_info,
                  g.description]
            ind+=1
        end
      end
    end
    a
  end
end
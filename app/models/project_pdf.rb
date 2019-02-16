class ProjectPdf < Prawn::Document
  def initialize(project)
    super(top_margin: 30, page_size: "A4", page_layout: :landscape)
      font_families.update("pragmatica" => {
      normal: Rails.root.join("app/assets/fonts/pragmatica/Pragmatica-Medium_gdi.ttf"),
      bold: Rails.root.join("app/assets/fonts/pragmatica/Pragmatica-Bold_gdi.ttf"),
      bold_italic: Rails.root.join("app/assets/fonts/OpenSans-Regular.ttf")
      })

    font "pragmatica"
    @project = project
    @items = @project.goods.order(:goodstype_id, :name)

    head_address
    head
    line_items
    footer
  end

  def head_address
    text "#{@project.address}", size: 16, style: :bold
  end

  def head
    # move_down 15
    text "Калькуляция на чистовые материалы, мебель и оборудование", size: 12, style: :bold
  end

  def footer
    move_down 15

    curr = Currency.order(:id)

    total = ""
    curr.each do |cr|
      total += @total[cr.id-1].to_sum + " " + cr.short + ", " if @total[cr.id-1]>0
    end

    total = total[0..-3]

    text "Итого: #{total}" , size: 14 

    move_down 15
    text "* Представлено на основании данных предоставленных поставщиками", size: 10
    text "** Суммы в итоге включают только основные позиции", size: 10
  end

  def line_items
    move_down 10
    @rows = []

    @items.each_with_index do |g, index|
      @rows << index if g.goods_priority_id == 1
    end
    # puts "@rows, #{@rows}"

    table line_item_rows, cell_style: { size: 9, border_width: 0 } do
      rows_count = cells.count/6
      # header = true
      i = 0 

      rows_count.times do 
        i +=1
        c = cells[i, 0]
        row(i).background_color = "ffe0ab" if !c.nil? && c.content.try(:to_i)>0 
      end

      row(0).font_style = :bold
      row(0).size = 12

      row(0).height = 35
      row(0).background_color = 'ff8411'
      row(0).align = :center
      row(0).valign = :center
      row(0).padding_bottom = 13

      column(0).align = :center
      column(2).align = :center
      column(3).align = :center
    end
  end

  def line_item_rows
    a = [[ {content:"№", width:40},
           {content:"Вид товара", width:160},
           {content:'Стоимость', width:100},
           {content:"Сроки поставки*", width:120}, 
           {content:"Контакты поставщика", width:160}, 
           {content:"Примечание", width:160}]]

    ind = 0
    @total = [0,0,0]

    @items.each do |g|
      date_supp = g.delivery_time.try(:name)

      if g.goods_priority_id == 1 
        ind += 1 
        @total[g.currency_id-1] += g.gsum  
      end
      number = g.goods_priority_id == 1 ? ind : ''

      a << [ number, g.name, 
             "#{g.gsum.to_sum} #{g.currency_print_name}", 
              date_supp, g.provider_full_info, g.description]
    end
    a
  end
end
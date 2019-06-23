# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#    User.create([{name: 'Евгений',email: 'seventhstar@mail.ru', activated:true, admin: true, password_digest: '$2a$10$ik8NsTg/BlEUFdfiAcNW8upCYFsr4v843Fm1OyA/p3YQaUoP10DLO'}])
#    Channel.create([{name: 'Телефон'},{name: 'E-mail'}])
#    Status.create([{name: 'Перезвонить'},{name: 'Дорого'},{name: 'Выслать КП'},{name: 'Готов подписать договор'},{name: 'Думает'},{name: 'Выбрал других'}])
#     DevStatus.create([{name: 'Новая'},{name: 'Выполнена'},{name: 'Проверена'},{name: 'В доработке'}])
#     Priority.create([{name: 'Обычный'},{name: 'Срочно'},{name: 'Низкий'}])

#    PaymentPurpose.delete_all
#    PaymentPurpose.create([{id: 1,name: 'Выплата дизайнеру'},{id: 2, name: 'Выплата визуализатору'},{id: 3, name:'Штраф'},{id: 4, name:'Откат'}])

if ProjectStatus.count==0  
  ProjectStatus.create([{name: 'В работе'},{name: 'Приостановлен'},{name: 'Завершен'}])
end

if Currency.count==0  
  Currency.create([{name: 'RUB', short: 'руб.', code: '643'},
   {name: 'USD', short: '$', code: '840'},
   {name: 'EUR', short: '€', code: '978'}, ])
end

if AbsenceReason.count==0  
  AbsenceReason.create([{name: 'Прогул'},{name: 'На объекте'},{name: 'Выезд в магазин'},{name: 'Отпуск'}])
end

if AbsenceTarget.count==0  
  AbsenceTarget.create([{name: 'Приемка кухни'},{name: 'Встреча с заказчиком'},{name: 'Обсуждение вопросов с прорабом'}])
end

if AbsenceShopTarget.count==0  
  AbsenceShopTarget.create([{name: 'Подбор'},{name: 'Корректировка'},{name: 'Заказ'}])
end

if City.count == 0 
  City.create([{name: 'Санкт-Петербург'}, {name: 'Москва'}])
end

if CostingsType.count == 0 
  CostingsType.create([{name: 'Основная'}, {name: 'Дополнительная'}])
end

if GoodsPriority.count == 0
  GoodsPriority.create([{name: 'Основной'}, {name: 'Альтернативный'}, {name: 'Отложено'}])
end

if DeliveryTime.count == 0
  DeliveryTime.create([{name: 'По согласованию'}, {name: '2 недели'}, {name: 'Месяц'}])
end

if Position.count == 0
  Position.create([{name: 'Директор', secret: true}, {name: 'Менеджер', secret: false}])
end

if TarifCalcType.count == 0 
  TarifCalcType.create([{name: 'За м2'}, {name: 'В мес'}, {name: 'Общая'}])
end

ProviderGoodstype.where(owner_type: '').update_all(owner_type: 'Provider')

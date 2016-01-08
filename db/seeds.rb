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

    if ProjectStatus.all.count==0  
      ProjectStatus.create([{name: 'В работе'},{name: 'Приостановлен'},{name: 'Завершен'}])
    end

    if AbsenceReason.all.count==0  
      AbsenceReason.create([{name: 'Прогул'},{name: 'На объекте'},{name: 'Выезд в магазин'},{name: 'Отпуск'}])
    end
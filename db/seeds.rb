# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
    Channel.create([{name: 'Телефон'},{name: 'E-mail'}])
    Status.create([{name: 'Перезвонить'},{name: 'Дорого'},{name: 'Выслать КП'},{name: 'Готов подписать договор'},{name: 'Думает'},{name: 'Выбрал других'}])
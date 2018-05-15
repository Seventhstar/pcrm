 window.onload = function () {
  var lvTB = new Vue({
    el: '#lvTable',
    data: {
      tbFullPrice: 0, // Итоговая сумма
      tbData: [ // Массив строк
        { name: '', count: 1, price: 1, amount: 1 }
      ]
    },
    computed: { // Определяем вычисляемое свойство для автоматического пересчета сумм и итога
      fCalcPrice: function () { // Расчёт сумм по строкам и общего итога
        tbFullPrice = 0;
        for (i = 0; i < this.tbData.length; ++i) { // Цикл по строкам таблицы
          this.tbData[i].amount = this.tbData[i].count * this.tbData[i].price; // Расчёт суммы в строке
          tbFullPrice = tbFullPrice + this.tbData[i].amount; // Расчёт итоговой суммы
        }
        return tbFullPrice; // Функция возвращает итоговую сумму
      }
    }
  });
}


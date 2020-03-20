// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/autocomplete
//= require jquery-ui/accordion
//= require jquery-ui/datepicker
//= require jquery-ui/tabs
//= require jquery.fileupload
//= require jquery.tokeninput
//= require chosen.jquery
//= require jquery.timepicker
//= require jquery.inputmask.bundle
//= require tinymce-jquery
//= require nprogress
//= require bootstrap-tokenfield
//= require moment
//= require cocoon
//= require contextMenu.min
//= require plyr.min
//= require vue
//= require vuex
//= require v-store
//= require_tree .

function toInt(d){
  if (isNaN(d)) return 0;
  if (v_nil(d)) return 0;
  return parseInt(d);
}

function toSum(d){ 
  if (isNaN(d) || d == undefined) return 0;
  s = d.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1 ");
  return s;
}

$.fn.capitalize = function () {
  $.each(this, function () {
      var caps = this.value;
      caps = caps.charAt(0).toUpperCase() + caps.slice(1);
      this.value = caps;
  });
  return this;
};

function updateRow(name, json, id, newItem = false, group = ''){
  let where = app[name]
  replace = where.filter(i => i.id === id)[0]
  for (var field in json) {
    replace[field] = json[field] 
  } 
}

function updAttachments(files, owner_id) {
  let old_files = app.goods_files.filter(f => f.owner_id == owner_id)

  old_files.forEach((file) => {
    let idx     = app.goods_files.indexOf(file)
    let file_id = file.value
    let pg_file = filesapp.ProjectGood.filter(f => f.id == file_id)
    if (pg_file.length >0) {
      let idx2    = filesapp.ProjectGood.indexOf(pg_file[0])
      Vue.delete(filesapp.ProjectGood, idx2)
    }
    Vue.delete(app.goods_files, idx)
  })
  filesapp.updateLists()

  files.forEach((file, ind) => {
    app.goods_files.push(file);
    filesapp.ProjectGood.push(file);
  })
  filesapp.updateLists()
}

function updateOptionRow(name, json, id, newItem = false, group = '') {
  let where = app[name];
    if (group == 'project_id'){
    gt = where
    replace = where.filter(i => i.id === id)[0]
  } else {
    gt = where.filter(n => n[0][0] === json.goodstype_id)[0]
    replace = gt[1].filter(i => i.id === id)[0]
  }
  
  if (newItem) { 
    gt[1].push(json); // в 0 - группа товаров, 1 - товары
    return;
  }


  if (typeof(found) === "string") {
    show_ajax_message("Ошибка обновления строки заказа", "error")
  } else {
    // json.forEach( f => replace[field] = json[field])
    // console.log('json', typeof(json))
    for (var field in json) {
      replace[field] = json[field] 
    } 
  }
}

function intFromSum(sum){
  if (sum === undefined) return 0;
  var s = sum.replace(/ /g, '')
  var i = parseInt(s)
  if (isNaN(i)) return 0;
  return i;
}

function showNotifications(){ 
  $nt = $(".alert"); 
  setTimeout("$nt.addClass('in')", 800);
  setTimeout("$nt.removeClass('in').addClass('out')", 7000);
}

function checkTime(i){
  if (i < 10) { i = "0" + i;}
  return i;
}

function ItemByID(id, list){
  found = list.filter(f => f.value == toInt(id))
  if (found.length > 0) return found[0]
    // return {label: found[0].label, value: id}
  return {}
}

function startTime(){
  var tm= new Date();
  var h = tm.getHours();
  var m = tm.getMinutes();
  var s = tm.getSeconds();
  
  m = checkTime(m);
  s = checkTime(s);
  $(".time_h").html(h+":"+m+":"+s);
  t = setTimeout('startTime()', 500);
}

function diff_hours(dt2, dt1) {
  var diff = (new Date(dt2).getTime() - new Date(dt1).getTime()) / 1000;
  diff /= (360);
  diff = Math.abs(Math.ceil(diff)/10);
  if (diff > 6) diff = diff - 1;
  // console.log('diff', diff);
  return diff;
}

function diff_days(dt2, dt1) {
  d1 = new Date(dt1)
  d2 = new Date(dt2)
  v  = $('#holidays').val()

  if (v != undefined && v != "") {
    v = v.split(" ")
    w  = $('#workdays').val().split(" ")
    days = moment().isoWeekdayCalc(d1, d2, [1,2,3,4,5,6,7], v, w)
    if (days>0) days += 1
  } else {
    const diffTime = Math.abs(d2.setHours(0,0,0,0) - d1.setHours(0,0,0,0));
    days = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  }

  return days; 
}

var delay = ( function() {
  var timer = 0;
  return function(callback, ms){
    clearTimeout (timer);
    timer = setTimeout(callback, ms);
  };
})();

var message_template = function(msg, type) {
  return '<div class="alert flash_'+type+'">'+msg+'<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a></div>';
};

var add_ajax_message = function(msg, type) {
  if (!type) {type = "success"};
  $(".js-notes").append( message_template(msg,type));    
  showNotifications();
};

var show_ajax_message = function(msg, type) {
  if (!type) {type = "success"};
  $(".js-notes").html( message_template(msg,type));    
  showNotifications();
};

var v_nil = function(v, zeroIsNil = false){ 
  if (typeof(v) == "object") 
    return v === null || v === undefined || v.value === undefined || v.value === 0;

  if (zeroIsNil && v === 0) return true
  
  return v === null || v === undefined || v === '';
}

var e_nil = function(id) {
  return e_val(id) === "";
}

var e_val = function(id) {
  let v = document.getElementById(id);
  if (v === null) return "";
  return v.value;
}

var format_date = function(date) {
  if (v_nil(date)) date = new Date().toJSON().slice(0,10).replace(/-/g,'-');
  if (date.includes('-')) return date.slice(0,10).split('-').reverse().join('.');
  return date;
}

function getInputSelection(elem) {
  if (typeof elem != "undefined") {
    s = elem[0].selectionStart;
    e = elem[0].selectionEnd;
    return elem.val().substring(s, e);
  } else { return '' }
}

function enableSwitcher(){
  $('.switcher_a').each(function(){    
    var link = $(this).find('.link_a,.link_c');
    var scale = $(this).find('.scale');
    var handle = $(this).find('.handle');
    var switcher = $(this);
    var details = switcher.parent().find('.details');

    $('.switcher_a .scale').click(function(event){
      switcher.toggleClass('toggled');
      link.toggleClass('on');
      link[0].innerHTML = link.attr(link.hasClass('on') ? 'on' : 'off');

      handle.toggleClass('active');

      if (switcher.hasClass('toggled')){
        details.slideDown(300);
      } else {
        details.slideUp(300);
      }

      if (link.hasClass('link_a'))
        sortable_query({only_actual:link.hasClass('on')});
      else{
        if (link.hasClass('on')){
          $('tr.new_client').hide();
          $('tr.ex_client').show();
        }else{
          $('tr.new_client').show();
          $('tr.ex_client').hide();
          $('#project_client_id').val(0);
          $('#project_client_id').trigger("chosen:updated")
        }
      }
      return false;
    });
  });

}

$(document).ready(function() {
  $(document).keydown(function(event){
    switch (event.key) {
    case "F7":
      document.getElementById("top-search").focus()
      break;
    case "Insert":
      document.getElementById("develop_task_name").focus()
    }    
  });

  $('.develop-main').keydown(function(event){
    if(event.keyCode == 13) {
      event.preventDefault();
      return false;
    }
  });
});

$(function() {

  var menu = [
    {name: 'Телефон', fun: function (){$('#lead_phone').val(getInputSelection($('#lead_info')));}}, 
    {name: 'email', fun: function () {$('#lead_email').val(getInputSelection($('#lead_info')));}},
    {name: 'ФИО', fun: function (){$('#lead_fio').val(getInputSelection($('#lead_info')));}}, 
    {name: 'Адрес', fun: function () {$('#lead_address').val(getInputSelection($('#lead_info')));}}
  ];

  $('.chosen_for_vue').on('change', function (e) {
    // console.log('e', e.target.id);
    if (app != undefined) app.onInput({name: e.target.id, value: $(this).val()});
  });

  $( document ).ajaxError(function( event, jqxhr, settings, thrownError ) {
    if (jqxhr.status != 200) show_ajax_message('error:' + jqxhr.responseText,'error')
  });

  //Calling context menu
  $('#lead_info').contextMenu(menu, {triggerOn:'contextmenu'});

  startTime();
  NProgress.configure({ showSpinner: false, ease: 'ease', speed: 300 });
  NProgress.start();
  NProgress.done();
  // plyr.setup();
  const player = new Plyr('#player');

  $( document ).ajaxStart(function() { NProgress.start(); });  
  $( document ).ajaxStop( function() {
    $('[data-toggle="tooltip"]').tooltip({'placement': 'top', fade: false});
    NProgress.done(); 
    apply_mask();
  });

  $('.progress').hide();
  $('#file').hide();

  $('#tabs').tabs({
    activate: function (event, ui) {
      p = $(".ui-tabs-active a").attr('href');
      window.location.hash = p;
      if ($(p).html() == undefined || ($('.good_group').size()==0 && p=='#tabs-4' )) {
        l = $('form').attr('action');
        url = l+"/edit"+p.replace('#','?').replace('-','=')
      } else if (p == '#tabs-6' ) {
        // console.log('fu')
        $('#attach_list').attr('owner_id', $('#upd_modal_project_id').val())
        $('#attach_list').attr('owner_type', 'Project')
      }
      $('body,html').animate({ scrollTop:(223) }, 0)
    }
  });

  
  tinyMCE.init({
    selector: '.tinymce textarea', 
    plugins: "textcolor,lists,spellchecker",
    toolbar_items_size : 'small',
    branding: false,
    menubar: '',
    gecko_spellcheck:true,
    toolbar: 'bold italic underline | forecolor backcolor fontsizeselect | bullist numlist '
  });

  // $('.navsearch .clear').click(function(){
  //   $('#search').val('');
  //   $('#search').trigger('clear');
  // });

  $('.timepicker').timepicker({ 'timeFormat': 'H:i' });
  
  $(document).on('focus', '.datepicker', function () {
    $(".datepicker").inputmask('99.99.9999'); 
    $('.ui-datepicker').css('z-index', 99999999999999);
  });

  enableSwitcher();

  $('.nav #develops').addClass('li-right develops');
  $('.nav #options').addClass('li-right options');
  $('[data-toggle="tooltip"]').tooltip({'placement': 'top', fade: false});

  showNotifications();
});



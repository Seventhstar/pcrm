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
//= require nprogress
//= require jquery-ui  
//= require jquery-ui/accordion
//= require jquery-ui/datepicker
//= require jquery-ui/tabs
//= require bootstrap-tokenfield
//= require chosen.jquery
//= require jquery.fileupload
//= require tinymce-jquery
//= require jquery.timepicker
//= require moment
//= require_tree .

function to_sum(d){ 
    if (isNaN(d)) return 0;
    s = d.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1 ");  
    return s;
}

function intFromSum(sum){
  if (sum === undefined) return 0;
  var s = sum.replace(/ /g,'')
  var i = parseInt(s)
  if (isNaN(i)) return 0;
  return i;
}

function showNotifications(){ 
  $nt = $(".alert"); 
  setTimeout("$nt.addClass('in')",500);
  setTimeout("$nt.removeClass('in').addClass('out')",5000);
}

function checkTime(i){
  if (i<10){i="0" + i;}
  return i;
}

function startTime(){
  var tm=new Date();
  var h=tm.getHours();
  var m=tm.getMinutes();
  var s=tm.getSeconds();
  
  m=checkTime(m);
  s=checkTime(s);
  $(".time_h").html(h+":"+m+":"+s);
  t=setTimeout('startTime()',500);
}

var delay = (function(){
  var timer = 0;
  return function(callback, ms){
    clearTimeout (timer);
    timer = setTimeout(callback, ms);
  };
})();


var show_ajax_message = function(msg, type) {
    if (!type) {type = "success"};
    $(".js-notes").html( '<div class="alert flash_'+type+'">'+msg+'<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a></div>');    
    showNotifications();
};


$(function() {

  startTime();
  NProgress.configure({ showSpinner: false, ease: 'ease', speed: 300 });
  NProgress.start();
  NProgress.done();

  $( document ).ajaxStart(function() { NProgress.start(); });  
  $( document ).ajaxStop( function() {
    $('[data-toggle="tooltip"]').tooltip({'placement': 'top', fade: false});
    NProgress.done(); 
    apply_mask();
  });

  $('.progress').hide();
  $('#file').hide();
  // $("#tabs" ).tabs({select: function(event, ui) { // select event
  //         $(ui.tab); // the tab selected
  //         alert(ui.index); // zero-based index
  //     });
  //   }); //{active: 3}
  $('#tabs').tabs({
    active: 2,
    activate: function (event, ui) {
      // var l = window.location.toString().split('#')[0];
      // var t = $(".ui-tabs-active a").attr('href');
      // setLoc(""+l+t);
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


  $('.timepicker').timepicker({ 'timeFormat': 'H:i' });

  $(document).on('focus', '.datepicker', function () {
        var me = $(".datepicker");
        me.mask('99.99.9999');
    });

  $('.switcher_a').each(function(){
    
    var link = $(this).find('.link_a,.link_c');
    var scale = $(this).find('.scale');
    var handle = $(this).find('.handle');
    var switcher = $(this);
    var details = switcher.parent().find('.details');

    $(scale).click(function(event){
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

  $('.nav #develops').addClass('li-right develops');
  $('.nav #options').addClass('li-right options');
 


  $('[data-toggle="tooltip"]').tooltip({'placement': 'top', fade: false});
  


  $(document).ajaxError(function myErrorHandler(event, xhr, ajaxOptions, thrownError) {
   // alert("There was an ajax error!");
  });
    
  showNotifications();



});



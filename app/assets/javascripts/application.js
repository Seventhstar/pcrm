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
//= require jquery-ui/datepicker
//= require jquery-ui/tabs
//= require jquery-ui  
//= require jquery-ui/accordion
//= require bootstrap-tokenfield
//= require chosen.jquery
//= require jquery.fileupload
//= require jquery.timepicker
//= require nprogress
//= require moment
//= require tinymce-jquery
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

var showNotifications = function(){ 
  var time = 5000;
  $nt = $(".alert"); 
  if ($nt.hasClass('flash_success')){ time = 2000; }
  setTimeout(function() {
    $nt.removeClass("in"); 
    setTimeout("$nt.addClass('out')",1000);
  }, time);
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
    $(".js-notes").html( '<div class="alert fade-in flash_'+type+'">'+msg+'</div>');    
    showNotifications();
};


$(function() {

  startTime();

    tinyMCE.init({
      selector: '.tinymce textarea',  // change this value according to your HTML
      plugins: "textcolor,lists",

      toolbar_items_size : 'small',
      branding: false,
      menubar: '',
      toolbar: 'bold italic underline | forecolor backcolor  fontsizeselect | bullist numlist '
      
    });


  $('.timepicker').timepicker({ 'timeFormat': 'H:i' });

  //.try('strftime',"%d.%m.%Y")
  //alert(v[0]);
  $(document).on('focus', '.datepicker', function () {
        var me = $(".datepicker");
        me.mask('99.99.9999');
    });

  $('.switcher_a').each(function(){
        var switcher = $(this);
        var link = $(this).find('.link_a,.link_c');
        var scale = $(this).find('.scale');
        var handle = $(this).find('.handle');
        var details = switcher.parent().find('.details');

        $(scale).click(function(event){
            switcher.toggleClass('toggled');
            link.toggleClass('on');
            link[0].innerHTML = link.attr(link.hasClass('on') ? 'on' : 'off');
            
            handle.toggleClass('active');

            if(switcher.hasClass('toggled')){
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
                // alert(
                $('#project_client_id').val(0);
                $('#project_client_id').trigger("chosen:updated")
                  //alert($('#project_client_id').val());
                  // );
              }
            }
            return false;
        });
       
        

    });



  $('.nav #develops').addClass('li-right develops');
  $('.nav #options').addClass('li-right options');
 
 
   NProgress.configure({
    showSpinner: false,
    ease: 'ease',
    speed: 300
  });

  NProgress.start();
  NProgress.done();

  $( document ).ajaxStart(function() {
      NProgress.start();
  });  

  $( document ).ajaxStop( function() {
    $('[data-toggle="tooltip"]').tooltip({'placement': 'top', fade: false});
    NProgress.done();
  });

  $('[data-toggle="tooltip"]').tooltip({'placement': 'top', fade: false});
  


  $(document).ajaxError(function myErrorHandler(event, xhr, ajaxOptions, thrownError) {
   // alert("There was an ajax error!");
  });
    

$('.progress').hide();
$('#file').hide();
$( "#tabs" ).tabs({active: 3});
 

  // дата по умолчанию для нового лида - сегодня
  if (!$("#lead_start_date").val()){
      $("#lead_start_date").val($.datepicker.formatDate('dd.mm.yy', new Date()));
  }

 $('.sel_val').click(function(){
          if ($(this).hasClass('select_custom_ext')) {
            $(this).removeClass('select_custom_ext');
            $(this).parent().removeClass('select_custom_ext');
          }
          else {
            $(this).addClass('select_custom_ext');
            $(this).parent().addClass('select_custom_ext');
          }
        });

  showNotifications();

});



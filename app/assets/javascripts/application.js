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
//= require jquery-ui
//= require jquery-ui/datepicker
//= require jquery_ujs
//= require twitter/bootstrap
//= require bootstrap-tokenfield
//= require bootstrap
//= require chosen.jquery

//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.ru.js
//= require_tree .
//= require jquery.fileupload


window.setTimeout(function() {
  $(".fade").fadeTo(500, 0).slideUp(500, function(){
      $(this).remove();
  });
}, 3000);

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
  //alert(h+":"+m+":"+s);
	$(".time_h").html(h+":"+m+":"+s);
	t=setTimeout('startTime()',500);
}


var show_ajax_message = function(msg, type) {
    if (!type) {type = "success"};
    $(".flash").html('<div class="alert fade in alert-'+type+'">'+msg+'</div>');    
    fade_flash();
};

  var fixEncode = function(loc) {
    var h = loc.split('#');
    var l = h[0].split('?');
    return l[0] + (l[1] ? ('?' + ajx2q(q2ajx(l[1]))) : '') + (h[1] ? ('#' + h[1]) : '');
  }




//function updateDev(){
//  $.get( "develops/", {'search':$("#search").val(),'show':$(".active").attr('show')},null,"script");
//}

$(function() {


var setLoc = function(loc) {
  //curLoc = fixEncode(loc.replace(/#(\/|!)?/, ''));
  navPrefix ="";
  curLoc = fixEncode(loc);
  var l = (location.toString().match(/#(.*)/) || {})[1] || '';
  if (!l ) { l = (location.pathname || '') + (location.search || '');  }
  
  l = fixEncode(l);
  if (l.replace(/^(\/|!)/, '') != curLoc) {
      try {
        //alert(l);
      history.pushState({}, '', '/' + curLoc);
      return;
    } catch(e) {}
  window.chHashFlag = true;
  //location.hash = '#' + navPrefix + curLoc;
  location.hash = navPrefix + curLoc;
  if (withFrame && getLoc() != curLoc) {
  setFrameContent(curLoc);
  }
  }
}
  startTime();

var settings = {
    url: "/",
    method: "POST",
    fileName: "myfile",
    onSuccess:function(files,data,xhr)
    {
        alert("Upload success");
    },
    onError: function(files,status,errMsg)
    {       
        alert("Upload Failed");
    }
}
$('.progress').hide();
$('#file').hide();
 
$("#mulitplefileuploader").uploadFile(settings);


//alert(29);

  // форматы календарей
  $("#lead_status_date").datepicker({format: "yyyy-mm-dd", weekStart: 1, autoclose: true, language: "ru", todayHighlight: true});
  $("#lead_start_date").datepicker({format: "yyyy-mm-dd", weekStart: 1, autoclose: true, language: "ru", todayHighlight: true});
  $("#user_date_birth").datepicker({format: "yyyy-mm-dd", weekStart: 1, autoclose: true, language: "ru", todayHighlight: true});

  $(".datepicker").datepicker({format: "yyyy-mm-dd", weekStart: 1, autoclose: true, language: "ru", todayHighlight: true});

  // дата по умолчанию для нового лида - сегодня
  if (!$("#lead_start_date").val()){
	    $("#lead_start_date").val($.datepicker.formatDate('yy-mm-dd', new Date()));
      $("#lead_status_date").val($.datepicker.formatDate('yy-mm-dd', new Date()));
  }

  //$('#lead_channel_id').chosen();

/*  $('.options-menu a').click(function(){ 
      $('.options-menu a.active').removeClass("active", 150, "easeInQuint");
      $(this).addClass("active");
      var url = "/" + $(this).attr("controller");
      $.get(url, null, null, "script");
      if (url!="/undefined") setLoc("options"+url);
  });*/

  //var $select_custom = $select.parent();
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


  $('.menu_sb li a').click(function(){ 
      $('.menu_sb li.active').removeClass("active", 150, "easeInQuint");
      $(this).parent().addClass("active");
      var url = "/" + $(this).attr("controller");
      $.get(url, null, null, "script");
      if (url!="/undefined") setLoc("options"+url);
  });

    

  $(document).on('click','#btn-send',function(e) {  
     
    var valuesToSubmit = $('form').serialize();
    var url = $('form').attr('action');
    
    $.ajax({
        type: "POST",
        url: url, //sumbits it to the given url of the form
        data: valuesToSubmit,
        dataType: 'JSON',  
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},         
        success: function(){
          $.get(url, null, null, "script");
      }
    });
    
    return false; // prevents normal behaviour
  });


  /*$( document ).ajaxStop(function() {
    $('table.tleads ').tableSort();
  });*/
  //$('table.tleads ').tableSort({width: 1100px;});

  
  //$('span.btn-sm').click(function(){
    $('.comments_box').on('click', 'span.btn-sm', function(){
  	var comment = $("#comment_comment").val();
  	var lead_id = $(this).attr('leadid');

	comment_id = $(".microposts p:first").attr('leadid');
	if (comment=='') return;
  	//return;
  	$.ajax({
    	 url: "/ajax/add_comment",
    	 data: {'comment':comment,'lead_id':lead_id},
    	 type: "POST",
    	 beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},	 
    	  success: function(){
    	   $("#comment_comment").val("");
    	   $.get('/leads/'+lead_id+'/edit', "", null, "script");
    	   //$('.panel-body').scrollTop(-9999);
    	  }
    	 });
  });



});



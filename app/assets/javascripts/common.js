// BROWSER DETECTION
	var matched, browser;
	
	$.uaMatch = function( ua ) {
		ua = ua.toLowerCase();

		var match = /(chrome)[ \/]([\w.]+)/.exec( ua ) ||
			/(webkit)[ \/]([\w.]+)/.exec( ua ) ||
			/(opera)(?:.*version|)[ \/]([\w.]+)/.exec( ua ) ||
			/(msie) ([\w.]+)/.exec( ua ) ||
			ua.indexOf("compatible") < 0 && /(mozilla)(?:.*? rv:([\w.]+)|)/.exec( ua ) ||
			[];

		return {
			browser: match[ 1 ] || "",
			version: match[ 2 ] || "0"
		};
	};

	matched = $.uaMatch( navigator.userAgent );
	browser = {};

	if ( matched.browser ) {
		browser[ matched.browser ] = true;
		browser.version = matched.version;
	}

	// Chrome is Webkit, but Webkit is also Safari.
	if ( browser.chrome ) {
		browser.webkit = true;
	} else if ( browser.webkit ) {
		browser.safari = true;
	}

	$.browser = browser;
// BROWSER DETECTION


$(document).ready(function(){
	
	$('.file_inp .btn_add').click(function(event){
		$file_inp = $(this).parents('.file_inp');
		$('input', $file_inp).trigger('click');
		event.preventDefault();
	})

	$(window).load(function(){
		box_cent();
		$('.comments_box .scrollPane_v:visible').each(function(){
			scrollPane_v_init($(this), 30, 100);
		})
	})
	$(window).resize(function(){
		box_cent();
	})

	// inpBtns_init($('input[type="radio"], input[type="checkbox"]'));
	
	$('.select').select();
	
	$('.txt_tags').txtTags();
	

// Datepicker _start
    $.datepicker.regional['ru'] = {
		showOtherMonths: true,
		selectOtherMonths: true,
        monthNames: ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'],
        monthNamesShort: ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн', 'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек'],
        dayNames: ['воскресенье', 'понедельник', 'вторник', 'среда', 'четверг', 'пятница', 'суббота'],
        dayNamesShort: ['вск', 'пнд', 'втр', 'срд', 'чтв', 'птн', 'сбт'],
        dayNamesMin: ['Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб'],
        weekHeader: 'Нед',
        dateFormat: 'dd.mm.yy',
        firstDay: 1,
        isRTL: false,
        showMonthAfterYear: false
    };
    $.datepicker.setDefaults($.datepicker.regional['ru']);

	$(document).on('click', '.datepicker', function (event) {
		var $txt = $(this),
			val = $txt.val(),			
			placeholder = $(this).attr('placeholder'); //if (val!='') 
			
		$(this).datepicker({
			showOn: 'focus',
			dateFormat: 'dd.mm.yy',
			
			onClose: function(sel,ev) {changeDTP(this,sel)},
			beforeShow: function(){
				var offsetTop = $('#ui-datepicker-div').offset().top;
				//if (!val && val!='') {
				//	$txt.val(placeholder);					
				//}
				//alert(offsetTop);
			}
		}).focus();
	});

// Input buttons _start
	$(document).on('click', '.inp_btn', function(event){
		var $input = $('input', this);
		if (!$(this).parents('label').length) {
			if ($input.prop('checked')) {
				$input.prop({checked: false});
			} else {
				$input.prop({checked: true});
			}
			$input.trigger('change');
		}
	})
	$(document).on('click', '.inp_btn input', function(event){
		event.stopPropagation();
	})
	
	$(document).on('change', '.inp_btn input', function(){
		var $inp_btns = $(this).parents('.inp_btns');
		var $inp_btn = $(this).parents('.inp_btn');
		if ($inp_btn.hasClass('radio')) {
			if ($(this).prop('checked')) {
				$('.inp_btn', $inp_btns).removeClass('active');
				$inp_btn.addClass('active');
			}
		}
		else {
			var ch = $(this).prop('checked');
			if (ch) {
				$inp_btn.addClass('active');
			} else {
				$inp_btn.removeClass('active');
			}
			$(this).val(ch);
			// $('[name^='+$(this).attr('name')).val(ch); 
		}
	})

})


	// Custom scroll Init
    function scrollPane_v_init($scrollPane, dragMinHeight, dragMaxHeight){
        if (!dragMinHeight) {dragMinHeight = 50;}
        if (!dragMaxHeight) {dragMaxHeight = 150;}
        var maxHeight = parseInt($scrollPane.css('maxHeight'));

        $scrollPane.each(function(){
            if ($(this).height() >= maxHeight || !maxHeight) {
                var scrollPane = $(this).jScrollPane({showArrows:false, verticalDragMinHeight: dragMinHeight, verticalDragMaxHeight: dragMaxHeight});
                var api = scrollPane.data('jsp');
                scrollPane.bind(
                    'mousewheel',
                    function (event, delta, deltaX, deltaY)
                    {
                        api.scrollByX(delta*-50);
                        return false;
                    }
                );
                $(window).resize(function(){
                    if ($scrollPane.is(':visible')) {
                        api.reinitialise();
                    }
                })
            }
        });
    }

	function scrollPane_reinit($scrollPane){
		var scrollPane = $scrollPane.jScrollPane();
		var api = scrollPane.data('jsp');
		api.reinitialise();
	}

	function scrollPane_destroy($scrollPane){
		var scrollPane = $scrollPane.jScrollPane();
		var api = scrollPane.data('jsp');
		api.destroy();
	}
	
	function box_cent(){
		$('.box_cent').each(function(){
			var bc_h = $(this).height(),
				win_h = $(window).height(),
				hd_h = $('.header').height(),
				ft_h = $('.footer').height(),
				cont_h = (win_h - hd_h - ft_h - bc_h - 250)*0.5;
			if (cont_h<0) {cont_h = 0}
			$(this).css({top: cont_h});
		})
	}
	
	// txtTags plugin
	(function($){
		var methods = {
			init : function(options) {
				this.each(function(){
					var $txt_tags = $(this),
						$tags = $('.tags', this),
						$txt = $('.txt', this),
						$val = $('.val', this),
						$down_list = $('.down_list', this);
					
					$tags.html('');
					
					$(document).click(function(){
						$('.txt_tags').removeClass('extend');
					});
					
					$txt.click(function(event){
						$('.txt_tags').removeClass('extend');
						$txt_tags.toggleClass('extend');
						event.stopPropagation();
					});
					
					$down_list.each(function(){
						if (!$('.dl_i', this).length)
							$(this).wrapInner('<div class="dl_i scrollPane_v"></div>');
						$(this).click(function(event){
							event.stopPropagation();
						});
					})
					
					$('li', $down_list).each(function(event){
						var item_val = $(this).text();
						if ($(this).hasClass('checked')) {
							tag_create(item_val);
						}
						
						$(this).click(function(event){
							if (!$(this).hasClass('checked')) {
								$(this).addClass('checked');
								tag_create(item_val);
							}
						});
					});
					
					
					function tag_create(item_val){
						var tag_match = $('.tag', $tags).filter(function(){
							return $(this).text()==item_val;
						});
						
						$txt_tags.addClass('noEmpty');
						if (!tag_match.length) {
							$tags.append('<span class="tag">'+item_val+'<span class="icon btn_remove"></span></span>');
						}
						
						$('.tag:last .btn_remove', $tags).click(function(event){
							var $tag = $(this).parents('.tag');

							$('li', $down_list).each(function(){
								if ($(this).text() == $tag.text()) {
									$(this).removeClass('checked');
								}
							})
							
							$tag.remove();
							tagsVal_set();

							if (!$('.tag', $tags).length) {
								$txt_tags.removeClass('noEmpty');
							}
							event.stopPropagation();
						});
						
						tagsVal_set();
					}
					
					function tagsVal_set(){
						var tags_val = '';
						$('.tag', $tags).each(function(index){
							var tag_val = $(this).text(),
							sep = ',';
							if (!index) sep = '';
							tags_val =  tags_val + sep + tag_val;
						})
						$val.val(tags_val);
					}
				})
			}
		};

		$.fn.txtTags = function(method) {
			if (methods[method]){
				return methods[method].apply( this, Array.prototype.slice.call(arguments, 1));
			} else if (typeof method === 'object' || ! method) {
				return methods.init.apply(this, arguments);
			} else {
				$.error('Метод с именем ' +  method + ' не существует для jQuery.txtTags');
			} 
		};
	})(jQuery);
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require recurring_select
//= require fullcalendar
//= require jquery.ui.draggable
//= require jquery.ui.resizable
//= require jquery.ui.autocomplete
//= require twitter/bootstrap
//= require dataTables/jquery.dataTables
//= require dataTables/jquery.dataTables.bootstrap3
//= require jquery_nested_form
//= require_tree ./components

function log(msg){
    return console.log(msg)
}

//#initialize site wide searching
function initialize_search(input_id){
    console.log('site search initialized with: ' + input_id)
    var input = $("[id *= '"+input_id+"']")

    $.each(input, function(){
        var input = $(this)
        input.closest("form[role~='search']").submit(function(e){
            e.preventDefault();
            input.autocomplete("search", input.val());
        });

        var data = input.autocomplete().data("ui-autocomplete");

        input_id = input_id.indexOf('_') > 0 ? input_id.substr(0, input_id.indexOf('_')) : input_id
        switch(input_id){
            case 'site-search' :
                var source = '/search'
                site_search_autocomplete();
                break;
            case 'workorder-search' :
                var source = '/workorder_search'
                workorder_search_autocomplete();
                break
            case 'service-search' :
                var source = '/service_search'
                service_search_autocomplete();
                break
            case 'customer-search' :
                var source = '/customer_search'
                customer_search_autocomplete();
                break
            case 'property-search' :
                var source = '/property_search'
                property_search_autocomplete();
                break
            default:
                return
        }

        data._renderMenu = function(ul, items){
            that = this;
            currentCategory = "";
            $.each(items, function(index, item){
                if(item.category != currentCategory){
                    ul.append("<li class='ui-autocomplete-category'><i class='" + item.icon + "' style='font-size:16px;'></i>&nbsp;&nbsp;&nbsp;" + item.category + "</li>")
                    currentCategory = item.category;
                }
                that._renderItemData(ul, item);
            });
            $(ul).removeClass("ui-front ui-menu ui-widget ui-widget-content");
            $(ul).addClass("dropdown-menu");
            $(ul).css({
                "z-index": 9999,
                "padding-left": "5px",
                "padding-right": "5px"
            });
        }

        data._renderItem = function(ul, item){
            var li =  $("<li>").data({value: item.value}).append("<a>" + item.value + "</a>");
            li.appendTo(ul)
            return li
        }

        /*
         Scoped functions
         */
        function site_search_autocomplete(){
            return input.autocomplete({
                source: source,
                delay: 500,
                select: function(event, ui){
                    window.location = ui.item.url
                },
                open: function(){
                    //removes the outdated jquery-ui hover colors
                    //$('li.ui-menu-item').removeClass('ui-menu-item')
                    $('.dropdown-menu li a').css({'font-size':'12px'});
                }
            });
        }
        function workorder_search_autocomplete(){
            return input.autocomplete({
                source: source,
                delay: 500,
                select: function(event, ui){
                    $('#workorder-id').val(ui.item.id)
                },
                open: function(){
                    //removes the outdated jquery-ui hover colors
                    //$('li.ui-menu-item').removeClass('ui-menu-item')
                    $('.dropdown-menu li a').css({'font-size':'12px'});
                }
            });
        }
        function service_search_autocomplete(){
            return input.autocomplete({
                source: source,
                delay: 500,
                select: function(event, ui){
                    //console.log($(this).parents('.fields').find('.service_id'))
                    var fields = $(this).parents('.fields')
                    fields.find('.service_id input').val(ui.item.id)
                    fields.find('.service_cost input').val(ui.item.cost)
                },
                open: function(){
                    //removes the outdated jquery-ui hover colors
                    //$('li.ui-menu-item').removeClass('ui-menu-item')
                    $('.dropdown-menu li a').css({'font-size':'12px'});
                }
            });
        }
        function customer_search_autocomplete(){
            return input.autocomplete({
                source: source,
                delay: 500,
                select: function(event, ui){
                    $('#customer-id').val(ui.item.id)
                },
                open: function(){
                    //removes the outdated jquery-ui hover colors
                    //$('li.ui-menu-item').removeClass('ui-menu-item')
                    $('.dropdown-menu li a').css({'font-size':'12px'});
                }
            });
        }
        function property_search_autocomplete(){
            return input.autocomplete({
                source: source,
                delay: 500,
                select: function(event, ui){
                    $('#property-id').val(ui.item.id)
                },
                open: function(){
                    //removes the outdated jquery-ui hover colors
                    //$('li.ui-menu-item').removeClass('ui-menu-item')
                    $('.dropdown-menu li a').css({'font-size':'18px'});
                }
            });
        }
    })
}

function notify(notify_type, msg) {
    var target = $('.modal:visible').length ? (notify_type == 'error' ? $('#modal-alerts') : $('#alerts'))
                                            : $('#alerts')
    var div = $('<div></div>')

    div.append('<button class="close" data-dismiss="alert" href="#">×</button>');

    if (notify_type == 'success') {
        div.append('<div class="h4">How about that?! It worked!!!</div>')
        div.append('<div class="h4">'+msg+'</div>')
        div.addClass('alert alert-success').fadeIn('fast');
    }

    if (notify_type == 'error') {
        div.append('<div class="h4">Oops! There was an error processing your request!</div>')
        div.append('<div class="h4">'+msg+'</div>')
        div.addClass('alert alert-danger').fadeIn('fast');
    }

    target.append(div)
    $('.alert').delay(7000).fadeTo(3000, 0, 'linear', function(){
        target.html('')
    })
}

function parse_json_errors(jqXHR){
    var msg = ''
    var json = $.parseJSON(jqXHR.responseText);
    for (var k in json){
        var key = k
        k = k.replace(/_id/g, '').replace(/_/g, ' ');
        var s = k.split(' ');
        k = '';
        for(var word in s){
            k += s[word].substr(0,1).toUpperCase() + s[word].substr(1) + ' ';
        }
        msg += k + json[key][0] + '.<br/>';
    }
    return msg
}

function get_error_fields(jqXHR){
    var error_fields = [];
    var json = $.parseJSON(jqXHR.responseText);
    for(var k in json){
      var field = $('.'+k)
        error_fields.push(field)
    }
    return error_fields
}

function datatable_defaults(){
    return {
        "sPaginationType": "bootstrap",
        "iDisplayLength": 5,
        "aLengthMenu": [[5,10,15,20,25,-1],[5,10,15,20,25,"All"]]
    }
}

$(document).ready(function(){
    initialize_search('site-search');
    initialize_search('service-search');
    initialize_search('customer-search');
    initialize_search('workorder-search');
    initialize_search('property-search');
})


/*
* AJAX event handlers
*/
$(document).on('ajax:error', function(event, jqXHR, ajaxSettings, thrownError){
    handle_ajax(event, jqXHR, 'error')
})

$(document).on('ajax:success', function(event, jqXHR, ajaxSettings){
    handle_ajax(event, jqXHR, 'success')
})

$(document).on('ajax:complete', function(event, jqXHR, ajaxSettings){
    handle_ajax(event, jqXHR, 'complete')
})

function handle_ajax(event, jqXHR, stage){
    var target = $(event.target).attr('id')
    switch (target){
        case 'new_workorder_link' :
            handle_new_workorder_link(stage, jqXHR)
            break
        case 'new_workorder' :
            handle_new_workorder_form_submit(stage, jqXHR)
            break
        case 'edit_property_link' :
            handle_edit_property_link(stage, jqXHR)
            break
        case 'edit_property' :
            handle_edit_property_form_submit(stage, jqXHR)
            break
        case 'new_property' :
            handle_new_property_form_submit(stage, jqXHR)
            break
        default :
            default_ajax_handler(stage, target)
            break
    }
}

function default_ajax_handler(stage, target){
    log('unidentified target - ')
    log(target)
    var msg = ''
    switch(stage){
        case 'error' :
            msg += 'This is doubly embarrassing because we didn\'t account for this!<br/>'
            msg += 'You really need to contact whoever is supporting this thing.<br/>'
            break
        case 'success' :
            msg += 'Actually, this is kinda embarrassing because we didn\'t account for this. Fortunately, everything seems to be ok!<br/>'
            msg += 'You should contact whoever is supporting this thing and let them know something\'s up.<br/>'
            break
    }
    notify(stage,msg)
}

function handle_new_workorder_link(stage, jqXHR){
    switch(stage){
        case 'error' :
            notify('error', parse_json_errors(jqXHR))
            break
        case 'success' :
            log('new_workorder_link - ' + stage)
            break;
        case 'complete' :
            log('new_workorder_link - ' + stage)
            break;
    }

}

function handle_new_workorder_form_submit(stage,jqXHR){
    switch(stage){
        case 'error' :
            notify('error', parse_json_errors(jqXHR))
            break
        case 'success' :
            log('new_workorder_form_submit - ' + stage)
            $('#ajax-modal').modal('hide')
            notify('success', jqXHR.message)
            $.ajax({
                global: false,
                url:'/properties_refresh_profile',
                dataType: 'html',
                data: {id: jqXHR.id},
                error: function(jqXHR, textStatus, errorThrown){
                    alert('could not refresh profile. reload the page.')
                },
                success: function(data, textStatus, jqXHR){
                    $('#profile').html(data)
                }
            })
            $.ajax({
                global: false,
                url: '/properties_refresh_workorders',
                dataType: 'html',
                data: {id:jqXHR.id},
                error: function(jqXHR, textStatus, errorThrown){
                    alert('could not refresh workorders. reload the page.')
                },
                success: function(data, textStatus, jqXHR){
                    $('#workorders').html(data)
                }
            })

            break;
        case 'complete' :
            log('new_workorder_form_submit - ' + stage)
            break;
    }
}

function handle_edit_property_link(stage, jqXHR){
    switch(stage){
        case 'error' :
            notify('error', parse_json_errors(jqXHR))
            break
        case 'success' :
            log('edit_property_link - ' + stage)
            break;
        case 'complete' :
            log('edit_property_link - ' + stage)
            break;
    }
}

function handle_edit_property_form_submit(stage,jqXHR){
    switch(stage){
        case 'error' :
            notify('error', parse_json_errors(jqXHR))
            break
        case 'success' :
            log('edit_property_form_submit - ' + stage)
            $('#ajax-modal').modal('hide')
            notify('success', jqXHR.message)
            refresh_profile(jqXHR.id)
            break;
        case 'complete' :
            log('edit_property_form_submit - ' + stage)
            break;
    }
}

function handle_new_property_form_submit(stage, jqXHR){
    switch(stage){
        case 'error' :
            notify('error', parse_json_errors(jqXHR))
            break
        case 'success' :
            log('new_property_form_submit - ' + stage)
            notify('success', jqXHR.message)
            $('#properties.datatable').dataTable().fnReloadAjax()
            break;
        case 'complete' :
            log('new_property_form_submit - ' + stage)
            break;
    }
}
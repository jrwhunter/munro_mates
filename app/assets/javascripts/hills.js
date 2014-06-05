

var hill_ids = new Array();

function create_links(){
    $.ajax({
        url: '/hills/create_links.js',
        type: 'POST',
        data: {hill_ids: hill_ids},
    });
}

function update_sidebar(){
    linked_hill_ids = new Array();
    $.ajax({
        url: '/hills/update_sidebar.js',
        type: 'POST',
        data: {hill_ids: hill_ids, category: category, selected: selected},
    });
}

// Get the caption
//function get_caption() {
//    if (selected == 'All') {
//        if (category == 'All')
//            return 'All hills'
//        else
//            return 'All '.concat(category);
//    } else if (selected == 'Climbed') {
//        return category.concat(' climbed');
//    } else if (selected == 'To do') {
//        return category.concat(' to do');
//    };
//};

$(document).ready(function() {


    // Set the initial caption for the correct hills' description
    //$('#caption').html(get_caption());

    // Category buttons set Munros, Corbetts, etc.
    $(".category_button").click(function(){
        $.ajax({
            url: '/hills.js',
            type: 'GET',
            data: {category: $(this).attr("value")}
        });

        //category = $(this).attr("value");
        //load_data()
    });

    // Select buttons set All, Climbed, To do
    $(".select_button").click(function(){
        $.ajax({
            url: '/hills.js',
            type: 'GET',
            data: {selected: $(this).attr("value")}
        });
        //selected = $(this).attr('value');
        //load_data()
    });





});

    // Load the new hill data 
    function load_data() {
        $.ajax({
            url: '/hills.js',
            type: 'GET',
            data: {category: category, selected: selected}
        });
        //$('#caption').html(get_caption());
    } 

function setup_table(){
    // Gets called each time table is loaded
    /*$("tr").mouseover(function() {
        $(this).addClass("over");
    });

    $("tr").mouseout(function() {
        $(this).removeClass("over");
    });*/
    
    // Selects row, stores hill_id, and gets mates
    $("tr").click(function() {
        id = $(this).find("input").first().attr("value")
        name = $(this).find('td').eq(1).text()
        
        index = hill_ids.indexOf(id)
        if (index == -1){
            hill_ids.push(id)
            hill_names.push(name)
        } else {
            hill_ids.splice(index, 1) 
            hill_names.splice(index, 1) 
        }

        update_sidebar();
        //set_mates();
        //set_hill_names();
        //set_selected_hills();
        //set_edit();
        
        $(this).toggleClass("row_selected");
    });


    $('#hill_table').dataTable({
        "sDom": 'iC<"clear">rt',
        "sScrollY": 500,
        "bPaginate": false,
    } );

};


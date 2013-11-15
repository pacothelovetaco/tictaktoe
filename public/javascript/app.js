function makeMove(e) {
    e.preventDefault();

    var _board = [];
    
    _board[0] = $("#c0").val();
    _board[1] = $("#c1").val();   
    _board[2] = $("#c2").val();
    _board[3] = $("#c3").val();
    _board[4] = $("#c4").val();
    _board[5] = $("#c5").val();
    _board[6] = $("#c6").val();
    _board[7] = $("#c7").val();
    _board[8] = $("#c8").val();
    
    var _playerMove = e.target.id;
    
    $(e.target).prop('disabled', true);
    
    $.ajax({
        type: 'POST',
        url: '/play',
        data: { 
            board: _board,
            move: _playerMove,
            letter: "X"
        },
    }).done(function(data){
        var json = $.parseJSON(data);
        updateBoard(json.board);
        if(json.winner){
            disableBoard();
            printResults(json.winner);
        }
    });
}

function updateBoard(board) {
    var $inputs = $('input')
    
    $.each(board, function(index, value){
        if(value != ""){
            input = $("#board").find("#c"+ index);
            input.val(value);
            input.prop('disabled', true);
        }
    
    });
}

function disableBoard() {
    var $inputs = $('input');
    $.each($inputs, function(index, value){
        $(this).prop('disabled', true);
    });
}


function printResults(winner){
    console.log(winner);
    var $div = $("#result");
    if(winner == "tie") {
        $div.append("<h3>It was a tie!</h3>");
    } else if (winner == "computer") {
        $div.append("<h3>The computer beat you!</h3>");
    } else if (winner == "player") {
        $div.append("<h3>Awesome, you won!!</h3>");
    }
}

$(document).ready(function(){
    $("input").on("click", function(e){
        makeMove(e)
    });
});

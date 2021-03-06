package lobby.gameLoop.phase;

import haxe.Timer;
import js.node.Querystring;
import js.lib.Promise;
import lobby.wikiAPI.WikiTools;
import lobby.Lobby.WebsocketPackage;
import lobby.gameLoop.Phase.PhaseType;
import lobby.player.Player;
using utils.ReverseArrayIterator;
using lobby.player.PlayersExtension;
using Lambda;

class Playing extends Phase {

    public var startPage:String;
    public var endPage:String;
    public var hasWinner:Bool = false;
    
    public override function onStart() {
        lobby.players.pageHistoryReset();
        lobby.players.setStartPage(startPage);
        lobby.players.emitVoteResult(startPage, endPage);
    }

    public override function onEnd() {
        if (!hasWinner) lobby.players.emitWinRound(null);
    }

    public override function controller(player:Player, json:WebsocketPackage) {
        switch json.type {
            case Validate:
                validate(player, json);
            default:
        }
    }

    public function validate(player:Player, json:WebsocketPackage) {
        if (player.currentPage == json.value) return;
        var oldPage = player.currentPage;
        player.numberOfJump +=1;
        player.currentPage = json.value;
        var currentValidation = player.currentValidation;
        var validation:Promise<String>;
        validation = WikiTools.validateJump(lobby.language, oldPage, json.value);
        validation.then(
            (landPage) -> {
                currentValidation.page = landPage;
                currentValidation.validated = true;
                player.validationBuffer.remove(validation);
            }
        ).catchError(
            (reason) -> {
                var pos = player.validationList.indexOf(currentValidation);
                if ( pos != -1) {
                    player.validationList.splice(pos,player.validationList.length);
                    player.rollback(player.currentPage);
                }
                player.validationBuffer.remove(validation);
                switch reason.type {
                    case Cheat:
                        onCheat(player, oldPage, json.value, reason.url, reason.body);
                    case WikiError:
                        onWikiError(player, oldPage, json.value, reason.url, reason.body);
                    case RequestFailed:
                        onRequestFailed(player, oldPage, json.value, reason.url, reason.e);
                    default:
                }
            }
        );
        validation.then(
            (actualPage) -> checkWin(player, actualPage),
            (e) -> log(e, Error)
        );
    }

    public function checkWin(player:Player, actualPage:String) {
        if (Querystring.unescape(actualPage) == endPage)
            Promise.all(player.validationBuffer).then(
                (v) -> {
                    if (player.validationList.reversedIterable().find((v) -> v.page == endPage && v.validated) == null) {
                        log("player " + player.uuid + " cheat on final validation : ", PlayerData);
                        return;
                    }
                    win(player);
                }
            ).catchError(
                (reason) -> log("player " + player.uuid + " cheat on final validation : ", PlayerData)
            );
    }

    public function win(player:Player) {
        if (lobby.gameLoop.currentPhase.type != Playing) return;
        var timeLeft = duration - (Timer.stamp() - lobby.gameLoop.timeStampStateBegin);
        player.score += 500 + Std.int(timeLeft*0.5);
        log("updateScore --> " +  player.id + "(" + player.pseudo + ") :" + player.score, PlayerData);
        log("WinRound --> " +  player.id + "(" + player.pseudo + ")", PlayerData);
        lobby.players.emitUpdateScore(player);
        lobby.players.emitWinRound(player);
        lobby.players.emitPath(player, duration - timeLeft);
        hasWinner = true;
        end();
    }

    public function onCheat(player:Player, oldPage:String, newPage:String, url:String, body:String) {
        log(body, PlayerData);
        log(player.pseudo + " is cheating!", PlayerData);
        log(oldPage + " --> " + url, PlayerData);
        log(player.validationList, PlayerData);
        lobby.players.emitMessage("Unvalidated jump from " + player.pseudo + " ! 
        He might have tried to cheat!");
        lobby.players.emitMessage(player.pseudo + "jump from " + player.currentPage + " to " + newPage);
        
    }

    public function onWikiError(player:Player, oldPage:String, newPage:String, url:String, body:String) {
        log(body, Error);
        log(player.pseudo + " WikiError on url: " + url, Error);
        lobby.players.emitMessage("Wiki verification error " + player.pseudo);
        lobby.players.emitMessage(player.pseudo + "jump from " + player.currentPage + " to " + StringTools.urlDecode(url));
    }

    public function onRequestFailed(player:Player, oldPage:String, newPage:String, url:String, error:String) {
        log(error, Error);
        log(player.pseudo + " Request fail on url: " + url, Error);
        lobby.players.emitMessage("Server verification error for " + player.pseudo);
    }

    public override function sendCurrentState(player:Player) {
        player.currentPage = startPage;
        [player].emitVoteResult(startPage, endPage);
    }
    
    public function new(start:String, end:String, lobby:Lobby, duration:Int = 600) {
        super(lobby, duration);
        type = Playing;
        startPage = start;
        endPage = end;
    }


}
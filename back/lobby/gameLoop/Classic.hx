package lobby.gameLoop;

import lobby.GameLoop.GameLoopType;
import lobby.player.Player;
import lobby.gameLoop.phase.Waiting;
import lobby.gameLoop.phase.GameFinish;
import lobby.gameLoop.phase.RoundFinish;
import lobby.wikiAPI.WikiTools.VoteResult;
import lobby.gameLoop.Phase.PhaseType;
import lobby.gameLoop.phase.Voting;
import lobby.gameLoop.phase.Playing;

class Classic extends GameLoop {

    public override function onStart(?data:Any) {
        currentPhase = lobby.type != Public ? new Waiting(lobby) : new Voting(lobby);
        currentPhase.start();
    }

    public override function onEnd(?data:Any) {
    }

    public override function next(?data:Any) {
        if (lobby.players.length == 0) return;
        switch currentPhase.type {
            case Waiting:
                currentPhase = new Voting(lobby);
            case Voting:
                var v:VoteResult = data;
                currentPhase = new Playing(v.startPage, v.endPage, lobby);
            case Playing:
                currentPhase = new RoundFinish(lobby);
            case RoundFinish:
                if (lobby.gameLoop.currentRound >= lobby.gameLoop.round) currentPhase = new GameFinish(lobby);
                else {
                    currentRound++;
                    currentPhase = new Voting(lobby);
                }
            case GameFinish:
                return end();
        }
        if (currentPhase != null) currentPhase.start();
    }

    public override function new(lobby:Lobby, round=5) {
        this.lobby = lobby;
        this.round = round;
        this.type = Classic;
        
    }

    public override function sendCurrentState(player:Player) {
        currentPhase.sendCurrentState(player);
    }

}
package lobby.gameLoop.phase;

import lobby.gameLoop.Phase.PhaseType;
using lobby.player.PlayersExtension;

class GameFinish extends Phase {

    public override function onEnd() {
        lobby.players.resetScore();
    }
    
    public function new(lobby:Lobby, duration:Int = 30) {
        super(lobby, duration);
        type = GameFinish;
    }
}
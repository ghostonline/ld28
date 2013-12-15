import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.tweens.misc.NumTween;
import com.haxepunk.utils.Ease;
import flash.text.TextFormatAlign;
 
class GameOver extends Entity
{
    public function new()
    {
        super(0, 0);
        var gameOverTxt = new Text("Game over!", 0, 60, 320, 100, {align : TextFormatAlign.CENTER, size : 40, color : 0xFFFFFF });
        addGraphic(gameOverTxt);
        restartHint = new Text("press 'R' to try again", 0, 92, 320, 100, {align : TextFormatAlign.CENTER, color : 0xFFFFFF });
        addGraphic(restartHint);
        fadeTween = new NumTween();
        addTween(fadeTween);
        fadeTween.tween(125, 92, 1, Ease.quadOut);
    }

    public override function update()
    {
        super.update();
        restartHint.y = fadeTween.value;
        restartHint.alpha = fadeTween.percent;
    }

    var restartHint:Text;
    var fadeTween:NumTween;
}
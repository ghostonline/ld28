import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.tweens.misc.NumTween;
import com.haxepunk.utils.Ease;
import flash.text.TextFormatAlign;
 
class Title extends Entity
{
    public function new()
    {
        super(0, 0);
        titleTxt = new Text("King of the hill", 3, 60, 320, 100, { size : 40, color : 0xFFFFFF });
        addGraphic(titleTxt);
    }

    public function hide()
    {
        fadeTween = new NumTween();
        addTween(fadeTween);
        fadeTween.tween(60, 0, 1, Ease.quadIn);
    }

    public override function update()
    {
        super.update();
        if (fadeTween != null)
        {
	        titleTxt.y = fadeTween.value;
	        titleTxt.alpha = 1 - fadeTween.percent;
	    }
    }

    var titleTxt:Text;
    var fadeTween:NumTween;
}